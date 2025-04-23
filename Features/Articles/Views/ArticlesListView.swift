import SwiftUI
import Resolver

struct ArticlesListView: View {
    @InjectedObject var viewModel: ArticlesListViewModel
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.articles) { article in
                    NavigationLink(destination: ArticleDetailView(article: article)) {
                        ArticleRowView(article: article)
                            .onAppear {
                                viewModel.loadMoreIfNeeded(currentItem: article)
                            }
                    }
                }
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Cosmo Noticias")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Buscar artículos")
            .onSubmit(of: .search) {
                viewModel.fetchArticles(query: searchText)
            }
            .onChange(of: searchText) { newValue in
                if newValue.isEmpty {
                    viewModel.fetchArticles(query: nil)
                }
            }
            .refreshable {
                viewModel.fetchArticles(query: searchText)
            }
            .overlay {
                if let error = viewModel.error {
                    ErrorView(message: error.localizedDescription) {
                        viewModel.fetchArticles(query: searchText)
                    }
                }
            }
        }
    }
}
