import SwiftUI
import Resolver
import Kingfisher

struct ArticleDetailView: View {
    @StateObject private var viewModel: ArticleDetailViewModel
    private let article: Article
    
    init(article: Article) {
        self.article = article
        let vm: ArticleDetailViewModel = Resolver.resolve(args: article)
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageUrl = viewModel.article.imageUrl {
                    KFImage(imageUrl)
                        .placeholder {
                            Color.gray
                        }
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                }
                
                Text(viewModel.article.title)
                    .font(.title)
                    .bold()
                
                Text(viewModel.article.newsSite)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(viewModel.article.publishedAt, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(viewModel.article.summary)
                    .font(.body)
                
                Link("Leer más", destination: viewModel.article.url)
                    .font(.body)
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
    }
}
