# Factory mit UIKit-Routing

Implementierung der Blueprint-Architektur mit Nutzung von Factory und UIKit-Routing.

## Übersicht

Die Implementierung stellt einen Ansatz vor, wie die Blueprint-Architektur unter Verwendung des DI-Frameworks [Factory](https://hmlongco.github.io/Factory/documentation/factory) und UIKit-Routing implementiert werden kann.

Überblick über verwendete Elemente/Frameworks:
* Dependency Injection über [Factory](https://github.com/hmlongco/Factory)
* Implementierung der Views/Screens in SwiftUI
* Routing über UIKit's `UINavigationController`

## Factory

Factory ist ein recht neues Container-basiertes DI-Framework und wurde als Nachfolger von [Resolver](https://github.com/hmlongco/Resolver) entwickelt. Factory stellt eine umfassende [Dokumentation](https://hmlongco.github.io/Factory/documentation/factory) bereit. Um den angewandten Ansatz in der Blueprint-Implementierung nachvollziehen zu können, sollte zu Beginn [Factory - Getting Started](https://hmlongco.github.io/Factory/documentation/factory/gettingstarted) gelesen werden.

Die Implementierung verwendet den standardmäßig bereitgestellten `Container`. In jedem Modul befinden sich die Factory-Definitionen im *DI*-Ordner. Factories, die außerhalb des Moduls bereitgestellt werden sollen, werden als `public` deklariert. 

> Note: Diese Implementierung verfolgt das Composition Root Pattern. Alle benötigten Instanzen inkl. deren Abhängigkeiten werden nur im Factory-Container konfiguriert und instanziiert. Die von Factory bereitgestellten Property Wrapper werden nicht verwendet. Dadurch beschränken sich die Abhängigkeiten zum Factory-Framework lediglich auf die Container-Extensions.

### Vorteile:
* Ein Typ kann nur aufgelöst werden, wenn auch eine entsprechende Factory definiert wurde (Compile-Time-Safety).
* Einfache Nutzung über bereitgestellte Property Wrappers.
* Es können verschiedene Injection-Strategien genutzt werden.
* Factories sind sehr leichtgewichtig und werden nur dann aufgelöst, wenn sie auch verwendet werden.
* Scopes bilden alle Standard-Use-Cases ab: unique (default), singleton, cached (bis Container-Cache geleert wird), shared (wie weak in Swinject), (graph).
* Verschiedene Anwendungsfälle über Contexts abbildbar: SwiftUI-Previews, UnitTests, On-Device, Simulator, usw.
* Debugging aufgelöster Instanzen sehr übersichtlich.
* Kein String-Tagging.
* Circular Dependency Cycle Detection.
* Umfangreiche Dokumentation.

### Nachteile:
* Über `.shared kann von überall auf den Container zugegriffen werden -> Entwicklerverantwortung.
* Überall kann über `.shared` eine andere Factory für einen Typ überschrieben/registriert werden -> Entwicklerverantwortung.
* Bei Nutzung der Property Wrappers müssen die Properties als `var deklariert werden.
* Bei Nutzung der Property Wrappers entstehen größere Abhängigkeiten zum Framework.
* Noch recht neu; noch nicht in der Praxis erprobt.


## UIKit-Routing

Das Routing in dieser Implementierung wurde über UIKit realisiert. Jedes Modul (die Main-App eingeschlossen) hat einen `Router`, welcher einen `rootViewController` bereitstellt. Über eine `start()`-Funktion wird ein `Router` konfiguriert.

Im ``MainRouter`` wird als Root-ViewController ein `UITabBarController` verwendet. Beim Starten des Routers wird dieser mit den Root-ViewControllern des `UserRouter`s und des `DocumentRouter`s konfiguriert. Die beiden Modul-Router haben jeweils einen `UINavigationController` als Root-ViewController. Die Modul-Router werden über den Factory-Container aufgelöst.

```
@MainActor
func start() {
    let userRouter = container.userRouter()
    let documentRouter = container.documentRouter()

    routers = [
        userRouter,
        documentRouter
    ]

    userRouter.start()
    documentRouter.start()

    tabBarController.viewControllers = [
        userRouter.rootViewController,
        documentRouter.rootViewController
    ]
}
```

### Wie wird SwiftUI eingebunden?

Um SwiftUI-Screens bzw. -Views im UIKit-Routing zu verwenden, werden `UIHostingController` genutzt. Für einen SwiftUI-Screen wird hierzu ein Typealias gesetzt:

```
typealias UserOverviewViewController = UIHostingController<UserOverviewScreen>
```

Im Factory-Container wird der `UIHostingController` mit dem SwiftUI-Screen initialisiert:

```
extension Container {

    var userOverviewViewModel: Factory<UserOverviewViewModel> {
        self { UserOverviewViewModel(interactor: self.userInteractor() )}
    }

    var userOverviewScreen: Factory<UserOverviewScreen> {
        self { UserOverviewScreen(viewModel: self.userOverviewViewModel() )}
    }

    var userOverviewViewController: Factory<UserOverviewViewController> {
        self { UserOverviewViewController(rootView: self.userOverviewScreen() )}
    }
}
```

In einem Router kann der `UIHostingController` wie folgt verwendet werden:

```
public func start() {
    [...]

    navigationController.viewControllers = [
        container.userOverviewViewController()
    ]
}
```
