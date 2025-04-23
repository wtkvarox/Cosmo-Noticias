import Resolver

extension Resolver: @retroactive ResolverRegistering {
    public static func registerAllServices() {
        register { DefaultAPIService() as APIService }
        register { ArticlesListViewModel(service: resolve()) }
        register { (_: Resolver, args: Resolver.Args) in
            let article: Article = args()
            return ArticleDetailViewModel(article: article)
        }
    }
}
