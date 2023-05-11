import Factory

extension Container {

    var networkService: Factory<NetworkService> {
        self { NetworkServiceImpl() }
            .shared
    }
}
