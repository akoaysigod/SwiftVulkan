import CGLFW3
import CVulkan
import Foundation

final class TriangleApp {
  private let window: OpaquePointer //can this be destroyed?
  private let validationLayers = ValidationLayers()

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
  }

  private func createInstance() {
    //add #if debug to this guard
    #if DEBUG
    guard validationLayers.checkSupport() else {
      fatalError("Validation layers requested not available.")
    }
    #endif

    var appInfo = VkApplicationInfo()
    appInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO
    appInfo.pApplicationName = "Triangles".cStringCopy
    appInfo.applicationVersion = Version.make(major: 1, minor: 0, patch: 0)
    appInfo.pEngineName = "No Engine".cStringCopy
    appInfo.engineVersion = Version.make(major: 1, minor: 0, patch: 0)
    appInfo.apiVersion = Version.apiVersion

    let createInfoBuilder = InstanceCreateInfoBuilder()
    createInfoBuilder.applicationInfo = withUnsafePointer(to: &appInfo) { return $0 }

    var glfwExtensionCount: UInt32 = 0
    guard let glfwExtensions = glfwGetRequiredInstanceExtensions(&glfwExtensionCount) else {
      fatalError("Cannot get glfw extensions.")
    }
    createInfoBuilder.enabledExtensionCount = glfwExtensionCount
    createInfoBuilder.enabledExtensionNames = UnsafePointer(glfwExtensions)

    #if DEBUG
    createInfoBuilder.enabledLayerCount = validationLayers.count
    createInfoBuilder.enabledLayerNames = validationLayers.layerNames
    #endif

    var instance: VkInstance? //these need to be deallocated with the vulkan api?
    var createInfo = createInfoBuilder.build()
    let result = vkCreateInstance(&createInfo, nil, &instance)
    if result != VK_SUCCESS { 
      fatalError("Failed to create instance. \(result)")
    }
  }

  //gets the available extensions as strings
  //probably can figure out how to use this to make sure glfwGetRequiredinstanceExtensions are satisfied
  private func checkAvailableExtensions() {
    var extensionCount: UInt32 = 0
    vkEnumerateInstanceExtensionProperties(nil, &extensionCount, nil)
    var extensionProperties = [VkExtensionProperties](repeating: VkExtensionProperties(), count: Int(extensionCount))
    vkEnumerateInstanceExtensionProperties(nil, &extensionCount, &extensionProperties)
    for p in extensionProperties {
      print(String.make(from: p.extensionName))
    }
  }

  private func mainLoop() {
    while glfwWindowShouldClose(window) == 0 {
      glfwPollEvents()
    }
    glfwDestroyWindow(window)
  }
}
