import CVulkan

final class LogicalDevice {
  let device: VkDevice //needs to be deallocated
  let graphicsQueue: VkQueue

  init(instance: VkInstance, physicalDevice: PhysicalDevice, validationLayers: ValidationLayers) {
    let (device, graphicsQueue) = LogicalDevice.makeDevice(instance: instance, physicalDevice: physicalDevice.vkDevice, validationLayers: validationLayers)
    self.device = device
    self.graphicsQueue = graphicsQueue
  }

  private static func makeDevice(instance: VkInstance, physicalDevice: VkPhysicalDevice, validationLayers: ValidationLayers) -> (VkDevice, VkQueue) {
    let indices = QueueFamilyFinder.findQueueFamilies(physicalDevice: physicalDevice)

    let queueCreateInfoBuilder = DeviceQueueCreateInfoBuilder()
    queueCreateInfoBuilder.queueFamilyIndex = UInt32(indices.graphicsFamily)
    queueCreateInfoBuilder.queueCount = 1
    queueCreateInfoBuilder.queuePriorities = [1.0]

    let createInfoBuilder = DeviceCreateInfoBuilder()
    var queueCreateInfo = queueCreateInfoBuilder.build()
    createInfoBuilder.queueCreateInfos = withUnsafePointer(to: &queueCreateInfo) { return $0 }
    createInfoBuilder.queueCreateInfoCount = 1
    var deviceFeatures = VkPhysicalDeviceFeatures()
    createInfoBuilder.enabledFeatures = withUnsafePointer(to: &deviceFeatures) { return $0 }
    #if DEBUG
    createInfoBuilder.enabledLayerCount = validationLayers.count
    createInfoBuilder.enabledLayerNames = validationLayers.layerNames
    #endif

    var createInfo = createInfoBuilder.build()
    var device: VkDevice?
    let result = vkCreateDevice(physicalDevice, &createInfo, nil, &device)
    guard result == VK_SUCCESS else {
      fatalError("Unable to create the logical device. \(result)")
    }

    //tmp
    var graphicsQueue: VkQueue?
    vkGetDeviceQueue(device, UInt32(indices.graphicsFamily), 0, &graphicsQueue)
    //
    return (device!, graphicsQueue!)
  }
}
