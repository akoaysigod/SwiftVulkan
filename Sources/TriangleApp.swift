import CGLFW3
import CVulkan
import Foundation

final class TriangleApp {
  private let window: OpaquePointer //can this be destroyed?
  private let validationLayers = ValidationLayers()

  //these need to be deallocated with the vulkan api?
  private var instance: VkInstance? 
  private var callback: VkDebugReportCallbackEXT?
  private var device: VkDevice?
  //-------------------------------------------------
  private var physicalDevice: PhysicalDevice?
  private var logicalDevice: LogicalDevice?
  private var graphicsQueue: VkQueue?
  private var surface: VkSurfaceKHR?

  init() {
    glfwInit()
    glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API)
    glfwWindowHint(GLFW_RESIZABLE, GLFW_FALSE)
    window = glfwCreateWindow(800, 600, "Triangle App", nil, nil)
  }

  func run() {
    initVulkan()
    mainLoop()
  }

  private func initVulkan() {
    createInstance()
//    #if DEBUG
//    setupDebugCallback()
//    #endif
//    createSurface()
//
//    physicalDevice = PhysicalDevice(instance: instance!, surface: surface!)
//    logicalDevice = LogicalDevice(instance: instance!, physicalDevice: physicalDevice!, validationLayers: validationLayers, queueFamilyIndices: physicalDevice!.queueFamilyIndices)


    //tmp
    //let indices = QueueFamilyFinder.findQueueFamilies(physicalDevice: physicalDevice!.vkDevice)
    //vkGetDeviceQueue(device, UInt32(indices.graphicsFamily), 0, &graphicsQueue)
  }

  private func createInstance() {
    //add #if debug to this guard
    #if DEBUG
    guard validationLayers.checkSupport() else {
      fatalError("Validation layers requested not available.")
    }
    #endif

    let appInfoBuilder = ApplicationInfoBuilder(applicationName: "Triangle", engineName: "No Name")
    var appInfo = appInfoBuilder.build()

    let createInfoBuilder = InstanceCreateInfoBuilder()
    createInfoBuilder.applicationInfo = withUnsafePointer(to: &appInfo) { return $0 }

    let requiredExtensions = RequiredExtensions()
    createInfoBuilder.enabledExtensionCount = requiredExtensions.count
    createInfoBuilder.enabledExtensionNames = requiredExtensions.names

    #if DEBUG
    createInfoBuilder.enabledLayerCount = validationLayers.count
    createInfoBuilder.enabledLayerNames = validationLayers.names
    #endif

    var createInfo = createInfoBuilder.build()
    let result = vkCreateInstance(&createInfo, nil, &instance)
    if result != VK_SUCCESS { 
      fatalError("Failed to create instance. \(result)")
    }
  }

  private func setupDebugCallback() {
    var createInfo = VkDebugReportCallbackCreateInfoEXT()
    createInfo.sType = VK_STRUCTURE_TYPE_DEBUG_REPORT_CALLBACK_CREATE_INFO_EXT
    createInfo.flags = VK_DEBUG_REPORT_ERROR_BIT_EXT.rawValue | VK_DEBUG_REPORT_WARNING_BIT_EXT.rawValue
    createInfo.pfnCallback = { (a, b, c, e, code, layerPrefix, msg, i) -> UInt32 in
      if let ptr = msg {
        print("Validation layer: \(String(cString: ptr))") 
      }
      return UInt32(VK_FALSE)
    }
    
    var voidFunc = vkGetInstanceProcAddr(instance, "vkCreateDebugReportCallbackEXT") 
    _ = withUnsafePointer(to: &voidFunc) { (p) in
      p.withMemoryRebound(to: PFN_vkCreateDebugReportCallbackEXT.self, capacity: 1) { (fn) in
        fn.pointee(instance, &createInfo, nil, &callback)
      }
    }
  }

//how to query information about the gpu 
//  func isDeviceSuitable(device: VkPhysicalDevice) -> Bool {
//    var deviceProperties = VkPhysicalDeviceProperties()
//    vkGetPhysicalDeviceProperties(device, &deviceProperties)
//
//    var deviceFeatures = VkPhysicalDeviceFeatures()
//    vkGetPhysicalDeviceFeatures(device, &deviceFeatures)
//
//    print(deviceProperties, deviceFeatures)
//    return true
//  }

  private func createSurface() {
    if glfwCreateWindowSurface(instance, window, nil, &surface) != VK_SUCCESS {
      fatalError("Failed to create window surface.")
    }
  }

  private func mainLoop() {
    while glfwWindowShouldClose(window) == 0 {
      glfwPollEvents()
    }
    glfwDestroyWindow(window)
  }
}
