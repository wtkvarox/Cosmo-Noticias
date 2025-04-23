import SwiftUI
import Resolver

final class AppCoordinator: ObservableObject {
    func start() -> some View {
        ArticlesListView()
    }
}
