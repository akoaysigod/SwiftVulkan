import CVulkan

final class PhysicalDevice {
  //this gets deallocated with the VkInstance
  let vkDevice: VkPhysicalDevice
 
  init(instance: VkInstance) {
    vkDevice = PhysicalDevice.getPhysicalDevice(instance: instance)
  }

  private static func getPhysicalDevice(instance: VkInstance) -> VkPhysicalDevice {
    var deviceCount: UInt32 = 0
    vkEnumeratePhysicalDevices(instance, &deviceCount, nil)
    guard deviceCount > 0 else {
      fatalError("No devices were found. :(")
    }

    var pDevice: VkPhysicalDevice? //this should be an array?
    vkEnumeratePhysicalDevices(instance, &deviceCount, &pDevice)

    guard let physicalDevice = pDevice, QueueFamilyFinder.findQueueFamilies(physicalDevice: physicalDevice).isComplete else {
      fatalError("No suitable devices found. :(")
    }

    return physicalDevice 
  }
}
