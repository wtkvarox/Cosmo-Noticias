import XCTest

final class MockAPIService: APIService {
    enum MockError: Error { case sample }
    var result: Result<[Article], Error>
    
    init(result: Result<[Article], Error>) {
        self.result = result
    }
    
    func fetchArticles(query: String?, page: Int) async throws -> [Article] {
        switch result {
        case .success(let articles): return articles
        case .failure(let error): throw error
        }
    }
}

final class ArticlesListViewModelTests: XCTestCase {
    func testInitialState() {
        let mock = MockAPIService(result: .success([]))
        let vm = ArticlesListViewModel(service: mock)
        XCTAssertTrue(vm.articles.isEmpty)
        XCTAssertNil(vm.error)
    }
    
    func testFetchArticlesSuccess() {
        let sample = Article(
            id: 1,
            title: "Test",
            url: URL(string: "https://example.com")!,
            imageUrl: nil,
            newsSite: "Site",
            summary: "Summary",
            publishedAt: Date(),
            updatedAt: Date()
        )
        let mock = MockAPIService(result: .success([sample]))
        let vm = ArticlesListViewModel(service: mock)
        
        let exp = XCTestExpectation(description: "Fetch completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(vm.articles, [sample])
            XCTAssertFalse(vm.isLoading)
            XCTAssertNil(vm.error)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func testFetchArticlesFailure() {
        let mock = MockAPIService(result: .failure(MockAPIService.MockError.sample))
        let vm = ArticlesListViewModel(service: mock)
        
        let exp = XCTestExpectation(description: "Fetch fails")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(vm.error)
            XCTAssertFalse(vm.isLoading)
            XCTAssertTrue(vm.articles.isEmpty)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func testLoadMorePages() {
        // Simula dos páginas con 1 item cada una
        let first = Article(id: 1, title: "A", url: URL(string: "https://a.com")!, imageUrl: nil, newsSite: "A", summary: "", publishedAt: Date(), updatedAt: Date())
        let second = Article(id: 2, title: "B", url: URL(string: "https://b.com")!, imageUrl: nil, newsSite: "B", summary: "", publishedAt: Date(), updatedAt: Date())
        var call = 0
        let mock = MockAPIService(result: .success([]))
        mock.result = .success([first])
        let vm = ArticlesListViewModel(service: mock)
        
        let exp1 = XCTestExpectation(description: "First page")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(vm.articles, [first])
            call += 1
            mock.result = .success([second])
            vm.loadMoreIfNeeded(currentItem: first)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(vm.articles, [first, second])
                exp1.fulfill()
            }
        }
        wait(for: [exp1], timeout: 2)
    }
}
