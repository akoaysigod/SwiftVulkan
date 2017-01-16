import CVulkan

final class DeviceCreateInfoBuilder {
  private let sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO
  var queueCreateInfos: UnsafePointer<VkDeviceQueueCreateInfo>!
  var queueCreateInfoCount: UInt32 = 0
  var enabledFeatures: UnsafePointer<VkPhysicalDeviceFeatures>!
  var enabledLayerCount: UInt32 = 0
  var enabledLayerNames: [UnsafePointer<Int8>?]!

  func build() -> VkDeviceCreateInfo {
    return VkDeviceCreateInfo(
      sType: sType,
      pNext: nil,
      flags: 0,
      queueCreateInfoCount: queueCreateInfoCount,
      pQueueCreateInfos: queueCreateInfos,
      enabledLayerCount: enabledLayerCount,
      ppEnabledLayerNames: enabledLayerNames,
      enabledExtensionCount: 0,
      ppEnabledExtensionNames: nil,
      pEnabledFeatures: enabledFeatures
    )
  }
}
