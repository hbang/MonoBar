include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MonoBar
MonoBar_FILES = Tweak.xm
MonoBar_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

internal-after-install::
	install.exec spring
