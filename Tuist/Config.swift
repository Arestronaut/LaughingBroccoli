import ProjectDescription

let config = Config(
    plugins: [
        .git(url: "ssh://git@scm.adesso-mobile.de:7999/aab/ios-templates.git", tag: "1.0.7")
    ]
)
