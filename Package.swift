import PackageDescription

let package = Package(
  name: "SwiftVulkan",
  dependencies: [
    .Package(url: "../CVulkan", Version(1, 0, 11)),
    //for testing mostly remove this at some point
    .Package(url: "git@github.com:akoaysigod/CGLFW3Linux.git", Version(1, 0, 1))
  ]
)
