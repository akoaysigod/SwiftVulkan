import CVulkan

final class DeviceQueueCreateInfoBuilder {
  private let sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO

  //probably shouldn't default these to anything
  var queueFamilyIndex: UInt32 = 0 
  var queueCount: UInt32 = 0
  var queuePriorities: [Float] = [1.0]

  func build() -> VkDeviceQueueCreateInfo {
    return VkDeviceQueueCreateInfo(
      sType: sType,
      pNext: nil,
      flags: 0,
      queueFamilyIndex: queueFamilyIndex,
      queueCount: queueCount,
      pQueuePriorities: queuePriorities
    )
  }
}
