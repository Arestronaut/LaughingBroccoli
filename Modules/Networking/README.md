# Networking

## Introduction

This is the networking module according to the blueprint architecture.

An API is already implemented in the module that loads a random user from https://randomuser.me/. The goal is to show exemplarily how an API can be implemented. Furthermore, unit tests are included for the already implemented API.

You can replace the example implementation with your own APIs. 

## How to use

In the following an example usage of the RandomUserApi is shown. To load a user you must use async/await. 

```
class Example {

    let api: RandomUserApi

    init(api: RandomUserApi) {
        self.api = api
    }

    func fetchAndPrintUser() async {
        do {
            let randomUserDto = try await api.fetchUser()

            print("\(randomUserDto.name.first) \(randomUserDto.name.last)")
        } catch {
            print(error.localizedDescription)
        }
    }
}
```

```
let example = Example(api: RandomUserApiImpl())

Task.detached {
    await example.fetchAndPrintUser()
}
```
