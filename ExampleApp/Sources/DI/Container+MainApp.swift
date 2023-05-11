import Factory

extension Container {

    var mainRouter: Factory<MainRouter> {
        self { self.commonMainRouter() }
    }

    private var commonMainRouter: Factory<MainRouterImpl> {
        self { MainRouterImpl() }
            .singleton
    }
}

