import CVulkan

final class PhysicalDevice {
  //this gets deallocated with the VkInstance
  let vkDevice: VkPhysicalDevice
  let queueFamilyIndices: QueueFamilyIndices
 
  init(instance: VkInstance, surface: VkSurfaceKHR) {
    let (vkDevice, queueFamilyIndices) = PhysicalDevice.getPhysicalDevice(instance: instance, surface: surface)
    self.vkDevice = vkDevice
    self.queueFamilyIndices = queueFamilyIndices
  }

  private static func getPhysicalDevice(instance: VkInstance, surface: VkSurfaceKHR) -> (VkPhysicalDevice, QueueFamilyIndices) {
    var deviceCount: UInt32 = 0
    vkEnumeratePhysicalDevices(instance, &deviceCount, nil)
    guard deviceCount > 0 else {
      fatalError("No devices were found. :(")
    }

    var pDevice: VkPhysicalDevice? //this should be an array?
    vkEnumeratePhysicalDevices(instance, &deviceCount, &pDevice)

    guard let physicalDevice = pDevice else {
      fatalError("No suitable devices found. :(")
    }

    let queueFamilyIndices = QueueFamilyFinder.findQueueFamilies(physicalDevice: physicalDevice, surface: surface)
    guard queueFamilyIndices.isComplete else {
      fatalError("No idea, no indices I guess.")
    }

    return (physicalDevice, queueFamilyIndices)
  }
}
