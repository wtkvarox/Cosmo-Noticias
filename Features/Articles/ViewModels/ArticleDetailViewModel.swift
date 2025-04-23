import Foundation

final class ArticleDetailViewModel: ObservableObject {
    @Published private(set) var article: Article
    
    init(article: Article) {
        self.article = article
    }
}
