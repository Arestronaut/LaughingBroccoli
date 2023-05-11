# Repository

This is the repository module according to the blueprint architecture.

The repostories encapsulate the data accesses and provide a single source of truth.

This module implements a sample user repository to provide access to a random user. It uses the networking module to reload a user. A sample cache validator is used to prevent data older than one hour from being provided.

You can replace the example implementation with your own repositories.

## How to use

In the following an example usage of the UserRepository is shown. To get a user you must use Combine. To reload a user you must user async/await.

```
class Example {

    private let repository: UserRepository
    private var cancellables = Set<AnyCancellable>()

    init(repository: UserRepository) {
        self.repository = repository

        repository.user.sink { user in
            if let user = user {
                print("Hello, \(user.firstName) \(user.lastName)")
            } else {
                print("There is no user loaded.")
            }
        }.store(in: &cancellables)
    }

    func reload() async {
        do {
            try await repository.reload()
        } catch {
            print(error.localizedDescription)
        }
    }
}
```

```
let example = Example(
    repository: UserRepositoryImpl(
        randomUserApi: RandomUserApiImpl()
    )
)

Task.detached {
    await example.reload()
}
```
