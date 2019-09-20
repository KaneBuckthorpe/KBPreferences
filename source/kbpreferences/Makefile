
include $(THEOS)/makefiles/common.mk

FRAMEWORK_NAME = KBPreferences
KBPreferences_FILES = KBPListController.m  KBHeaderListController.m KBInfoListController.m KBStyledListController.m cells/KBStepperCell.m cells/KBFooterCell.m cells/KBCustomCell.m

KBPreferences_INSTALL_PATH = /Library/Frameworks

KBPreferences_CFLAGS += -fobjc-arc
KBPreferences_PRIVATE_FRAMEWORKS=Preferences
include $(THEOS_MAKE_PATH)/framework.mk