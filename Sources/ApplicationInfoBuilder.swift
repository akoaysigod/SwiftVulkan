import CVulkan

final class ApplicationInfoBuilder {
  private let sType = VK_STRUCTURE_TYPE_APPLICATION_INFO
  private let applicationName: String?
  private let applicationVersion: UInt32
  private let engineName: String?
  private let engineVersion: UInt32
  private let apiVersion: UInt32

  init(applicationName: String? = nil,
       applicationVersion: UInt32 = Version.make(major: 1, minor: 0, patch: 0),
       engineName: String? = nil,
       engineVersion: UInt32 = Version.make(major: 1, minor: 0, patch: 0),
       apiVersion: UInt32 = Version.apiVersion) {
    self.applicationName = applicationName
    self.applicationVersion = applicationVersion
    self.engineName = engineName
    self.engineVersion = engineVersion
    self.apiVersion = apiVersion
  }

  func build() -> VkApplicationInfo {
//    return VkApplicationInfo(
//      sType: sType,
//      pNext: nil,
//      pApplicationName: "ok",
//      applicationVersion: 1,
//      pEngineName: "ok",
//      engineVersion: 1,
//      apiVersion: 1
//    )
    var appInfo = VkApplicationInfo()
    appInfo.sType = sType
    appInfo.pApplicationName = applicationName?.cStringCopy
    appInfo.applicationVersion = applicationVersion
    appInfo.pEngineName = engineName?.cStringCopy
    appInfo.engineVersion = engineVersion
    appInfo.apiVersion = apiVersion
    return appInfo
  }
}
