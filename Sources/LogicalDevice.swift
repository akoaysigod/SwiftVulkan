import CVulkan

final class LogicalDevice {
  let device: VkDevice //needs to be deallocated
  let graphicsQueue: VkQueue
  let presentQueue: VkQueue

  init(instance: VkInstance, physicalDevice: PhysicalDevice, validationLayers: ValidationLayers, queueFamilyIndices: QueueFamilyIndices) {
    let (device, graphicsQueue, presentQueue) = LogicalDevice.makeDevice(instance: instance, physicalDevice: physicalDevice.vkDevice, validationLayers: validationLayers, queueFamilyIndices: queueFamilyIndices)
    self.device = device
    self.graphicsQueue = graphicsQueue
    self.presentQueue = presentQueue
  }

  private static func makeDevice(instance: VkInstance, physicalDevice: VkPhysicalDevice, validationLayers: ValidationLayers, queueFamilyIndices: QueueFamilyIndices) -> (VkDevice, VkQueue, VkQueue) {

    let uniqueFamilies = Set<Int>([queueFamilyIndices.graphicsFamily, queueFamilyIndices.presentFamily])

    let queueCreateInfos = uniqueFamilies.map { (i) -> VkDeviceQueueCreateInfo in
      let queueCreateInfoBuilder = DeviceQueueCreateInfoBuilder()
      queueCreateInfoBuilder.queueFamilyIndex = UInt32(i)
      queueCreateInfoBuilder.queueCount = 1
      queueCreateInfoBuilder.queuePriorities = [1.0]
      return queueCreateInfoBuilder.build()
    }

    let createInfoBuilder = DeviceCreateInfoBuilder(infos: queueCreateInfos)
    //var queueCreateInfo = queueCreateInfoBuilder.build()
    //createInfoBuilder.queueCreateInfos = withUnsafePointer(to: &queueCreateInfos) { return $0 }
    createInfoBuilder.queueCreateInfoCount = UInt32(queueCreateInfos.count)
    var deviceFeatures = VkPhysicalDeviceFeatures()
    createInfoBuilder.enabledFeatures = withUnsafePointer(to: &deviceFeatures) { return $0 }
    #if DEBUG
    createInfoBuilder.enabledLayerCount = validationLayers.count
    createInfoBuilder.enabledLayerNames = validationLayers.names
    #endif

    var createInfo = createInfoBuilder.build()
    var device: VkDevice?
    let result = vkCreateDevice(physicalDevice, &createInfo, nil, &device)
    guard result == VK_SUCCESS else {
      fatalError("Unable to create the logical device. \(result)")
    }

    //tmp
    var graphicsQueue: VkQueue?
    vkGetDeviceQueue(device, UInt32(queueFamilyIndices.graphicsFamily), 0, &graphicsQueue)
    var presentQueue: VkQueue?
    vkGetDeviceQueue(device, UInt32(queueFamilyIndices.presentFamily), 0, &presentQueue)
    //
    return (device!, graphicsQueue!, presentQueue!)
  }
}
