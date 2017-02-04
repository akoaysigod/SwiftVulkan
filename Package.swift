import PackageDescription

let package = Package(
  name: "SwiftVulkan",
  dependencies: [
    .Package(url: "../CVulkan", Version(1, 0, 14)),
    //for testing mostly remove this at some point
    .Package(url: "../CGLFW3Linux", Version(1, 0, 4))
  ]
)
