import Foundation

// MARK: - APIService Protocol
protocol APIService {
    /// Obtiene los artículos. Si query es nil, devuelve los últimos artículos.
    func fetchArticles(query: String?, page: Int) async throws -> [Article]
}

// MARK: - NetworkError
enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .invalidResponse(let status):
            return "Respuesta inválida del servidor (código \(status))"
        case .decodingError(let error):
            return "Error al procesar datos: \(error.localizedDescription)"
        }
    }
}

// MARK: - SpaceFlightNewsAPI Endpoints
enum SpaceFlightNewsAPI {
    static let baseURL = URL(string: "https://api.spaceflightnewsapi.net/v4/")!
    case articles(query: String?, page: Int)
    
    private var path: String {
        switch self {
        case .articles:
            return "articles"
        }
    }
    
    private var queryItems: [URLQueryItem] {
        let pageSize = 20
        switch self {
        case let .articles(query, page):
            let limit = pageSize
            let offset = (page - 1) * pageSize
            var items = [
                URLQueryItem(name: "limit",  value: "\(limit)"),
                URLQueryItem(name: "offset", value: "\(offset)")
            ]
            if let q = query, !q.isEmpty {
                items.append(URLQueryItem(name: "title_contains", value: q))
            }
            return items
        }
    }
    
    var urlRequest: URLRequest {
        guard var components = URLComponents(url: SpaceFlightNewsAPI.baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            return URLRequest(url: SpaceFlightNewsAPI.baseURL)
        }
        components.queryItems = queryItems
        guard let url = components.url else {
            return URLRequest(url: SpaceFlightNewsAPI.baseURL)
        }
        print("[Network] Fetching URL: \(url.absoluteString)")
        return URLRequest(url: url)
    }
}

// MARK: - DefaultAPIService Implementation
final class DefaultAPIService: APIService {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        self.decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            if let date = isoFormatter.date(from: dateString) {
                return date
            }
            let fallback = ISO8601DateFormatter()
            fallback.formatOptions = [.withInternetDateTime]
            if let date2 = fallback.date(from: dateString) {
                return date2
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(dateString)")
        }
    }
    
    func fetchArticles(query: String? = nil, page: Int = 1) async throws -> [Article] {
        let request = SpaceFlightNewsAPI.articles(query: query, page: page).urlRequest
        let (data, response) = try await session.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(statusCode: -1)
        }
        guard 200..<300 ~= http.statusCode else {
            throw NetworkError.invalidResponse(statusCode: http.statusCode)
        }
        
        do {
            let listResponse = try decoder.decode(ArticleListResponse.self, from: data)
            return listResponse.results
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
