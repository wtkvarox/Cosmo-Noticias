import Foundation

struct ArticleListResponse: Codable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [Article]
}
