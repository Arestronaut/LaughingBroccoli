import UIKit

/// A router that is responsible for navigation between different feature modules.
public protocol Router: AnyObject {

    /// The RootViewController of a router that is the first controller in the navigation stack.
    var rootViewController: UIViewController { get }

    /// Start the router navigation.
    func start()
}

/// A router that acts as a parent router and must clean up the child routers when they are done.
public protocol ParentRouter: Router {

    /// Tells the parent router that given router is done and should be removed from the list of routers.
    func childDidFinish(_ child: Router)
}
