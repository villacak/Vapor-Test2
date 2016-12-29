import PackageDescription

let package = Package(
    name: "vaportest2",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 3),
        .Package(url: "https://github.com/vapor/mysql-provider.git", majorVersion: 1, minor: 1)
//        .Package(url: "https://github.com/qutheory/vapor", majorVersion: 1, minor: 3),
//        .Package(url: "https://github.com/qutheory/mysql-provider.git", majorVersion: 1, minor: 1)
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
        "Tests",
    ]
)

