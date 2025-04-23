import Foundation

struct Article: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let url: URL
    let imageUrl: URL?
    let newsSite: String
    let summary: String
    let publishedAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, title, url
        case imageUrl = "image_url"
        case newsSite = "news_site"
        case summary
        case publishedAt = "published_at"
        case updatedAt = "updated_at"
    }
}
