import Foundation
import Combine

/// ViewModel para la lista de artículos con soporte de paginación e infinite scroll y mejor manejo de errores
final class ArticlesListViewModel: ObservableObject {
    @Published private(set) var articles: [Article] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: NetworkError?
    
    private var currentPage: Int = 1
    private let pageSize: Int = 20
    private let service: APIService
    
    init(service: APIService = DefaultAPIService()) {
        self.service = service
        fetchArticles()
    }
    
    /// Carga la primera página o refresca la lista
    func fetchArticles(query: String? = nil) {
        reset()
        loadPage(query: query)
    }
    
    /// Carga la siguiente página si no está ya cargando
    private func loadPage(query: String? = nil) {
        guard !isLoading else { return }
        isLoading = true
        
        Task {
            do {
                let newItems = try await service.fetchArticles(query: query, page: currentPage)
                await MainActor.run {
                    self.articles.append(contentsOf: newItems)
                    self.isLoading = false
                }
            } catch let urlError as URLError {
                print("[Network] URLError: \(urlError)")
                await MainActor.run {
                    // Mostramos el mensaje original de la conexión
                    self.error = .decodingError(urlError)
                    self.isLoading = false
                }
            } catch let netError as NetworkError {
                print("[Network] NetworkError: \(netError)")
                await MainActor.run {
                    self.error = netError
                    self.isLoading = false
                }
            } catch {
                print("[Network] Unexpected error: \(error)")
                await MainActor.run {
                    self.error = .decodingError(error)
                    self.isLoading = false
                }
            }
        }
    }
    
    /// Infinite scroll: carga más al llegar al final de la lista
    func loadMoreIfNeeded(currentItem: Article) {
        guard let last = articles.last, currentItem.id == last.id else { return }
        currentPage += 1
        loadPage()
    }
    
    /// Reinicia paginación y datos
    private func reset() {
        currentPage = 1
        articles.removeAll()
        error = nil
    }
}
