all:
	swift build -Xlinker -L/home/tony/.bin/VulkanSDK/1.0.37.0/x86_64/lib -Xlinker -lvulkan -Xswiftc -DDEBUG
