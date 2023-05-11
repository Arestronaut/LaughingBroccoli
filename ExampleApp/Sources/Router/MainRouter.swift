import UIKit
import Factory
import Shared

protocol MainRouter: Router, ParentRouter { }

final class MainRouterImpl: MainRouter {

    private let container: Container = Container.shared

    let rootViewController = UIViewController()

    private var routers: [Router] = []

    @MainActor
    func start() {
    }
}

extension MainRouterImpl: ParentRouter {

    func childDidFinish(_ child: Router) {
        routers.removeAll { $0 === child }
    }
}
