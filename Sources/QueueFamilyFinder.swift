import CVulkan

struct QueueFamilyIndices {
  let graphicsFamily: Int
  var isComplete: Bool {
    return graphicsFamily >= 0
  }
}

struct QueueFamilyFinder {
  static func findQueueFamilies(physicalDevice: VkPhysicalDevice) -> QueueFamilyIndices {
    var queueFamilyCount: UInt32 = 0
    vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, &queueFamilyCount, nil)
    var queueFamily = VkQueueFamilyProperties() //this should be an array?
    vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, &queueFamilyCount, &queueFamily)

    if queueFamily.queueCount > 0 && queueFamily.queueFlags & VK_QUEUE_GRAPHICS_BIT.rawValue == 1 {
      return QueueFamilyIndices(graphicsFamily: 0)
    }
    return QueueFamilyIndices(graphicsFamily: -1)
  }
}
