import SwiftUI
import Resolver

@main
struct CosmoNoticiasApp: App {
    init() {
        Resolver.registerAllServices()
    }
    
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            coordinator.start().environment(\.locale, Locale(identifier: "es"))
        }
    }
}
