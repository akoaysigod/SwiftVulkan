import CVulkan

struct QueueFamilyIndices {
  let graphicsFamily: Int
  let presentFamily: Int
  var isComplete: Bool {
    return graphicsFamily >= 0 && presentFamily >= 0
  }
}

struct QueueFamilyFinder {
  static func findQueueFamilies(physicalDevice: VkPhysicalDevice, surface: VkSurfaceKHR) -> QueueFamilyIndices {
    var queueFamilyCount: UInt32 = 0
    vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, &queueFamilyCount, nil)
    var queueFamily = VkQueueFamilyProperties() //this should be an array?
    vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, &queueFamilyCount, &queueFamily)

    var presentSupport: VkBool32 = 0
    vkGetPhysicalDeviceSurfaceSupportKHR(physicalDevice, 0, surface, &presentSupport)

    if queueFamily.queueCount > 0 && queueFamily.queueFlags & VK_QUEUE_GRAPHICS_BIT.rawValue == 1
       && presentSupport != 0 {
      return QueueFamilyIndices(graphicsFamily: 0, presentFamily: 0)
    }
    return QueueFamilyIndices(graphicsFamily: -1, presentFamily: -1)
  }
}
