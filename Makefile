SRCDIR=CSources
SHAREDLIB=libVulkanShims.so
SHAREDLIBPATH=/usr/lib
INCLUDEPATH=/home/tony/.bin/VulkanSDK/1.0.37.0/x86_64/include/

all:
	swift build -Xlinker -L/home/tony/.bin/VulkanSDK/1.0.37.0/x86_64/lib \
              -Xlinker -lvulkan -Xlinker -lVulkanShims \
							-Xswiftc -DDEBUG 

setup:
	clang -shared $(SRCDIR)/Shims.c -o $(SHAREDLIB) -I$(INCLUDEPATH) -fPIC
	sudo cp $(SHAREDLIB) $(SHAREDLIBPATH)
	rm $(SHAREDLIB)

