LOCAL_PATH := $(call my-dir)

# we compile hijack if we have hijacked executables
ifneq ($(BOARD_HIJACK_EXECUTABLES),)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := hijack.c

LOCAL_MODULE := hijack
LOCAL_MODULE_TAGS := eng

LOCAL_STATIC_LIBRARIES := \
	libbusybox \
	libclearsilverregex \
	libm \
	libcutils \
	libc

LOCAL_FORCE_STATIC_EXECUTABLE := true

ifneq ($(BOARD_HIJACK_UPDATE_BINARY),)
LOCAL_CFLAGS += -DUPDATE_BINARY=\"$(BOARD_HIJACK_UPDATE_BINARY)\"
endif

ifneq ($(BOARD_HIJACK_BOOT_UPDATE_ZIP),)
LOCAL_CFLAGS += -DBOOT_UPDATE_ZIP=\"$(BOARD_HIJACK_BOOT_UPDATE_ZIP)\"
endif

ifneq ($(BOARD_HIJACK_RECOVERY_UPDATE_ZIP),)
LOCAL_CFLAGS += -DRECOVERY_UPDATE_ZIP=\"$(BOARD_HIJACK_RECOVERY_UPDATE_ZIP)\"
endif

ifeq ($(BOARD_HIJACK_LOG_ENABLE),true)
LOCAL_CFLAGS += -DLOG_ENABLE
endif

ifneq ($(BOARD_HIJACK_LOG_DEVICE),)
LOCAL_CFLAGS += -DLOG_DEVICE=\"$(BOARD_HIJACK_LOG_DEVICE)\"
endif

ifneq ($(BOARD_HIJACK_LOG_MOUNT),)
LOCAL_CFLAGS += -DLOG_MOUNT=\"$(BOARD_HIJACK_LOG_MOUNT)\"
endif

ifneq ($(BOARD_HIJACK_LOG_FILE),)
LOCAL_CFLAGS += -DLOG_FILE=\"$(BOARD_HIJACK_LOG_FILE)\"
endif

ifneq ($(BOARD_HIJACK_LOG_DUMP_BINARY),)
LOCAL_CFLAGS += -DLOG_DUMP_BINARY=\"$(BOARD_HIJACK_LOG_DUMP_BINARY)\"
endif

ifneq ($(BOARD_HIJACK_BOOT_MODE_FILE),)
LOCAL_CFLAGS += -DBOOT_MODE_FILE=\"$(BOARD_HIJACK_BOOT_MODE_FILE)\"
endif

ifneq ($(BOARD_HIJACK_RECOVERY_MODE_FILE),)
LOCAL_CFLAGS += -DRECOVERY_MODE_FILE=\"$(BOARD_HIJACK_RECOVERY_MODE_FILE)\"
endif

include $(BUILD_EXECUTABLE)

define link-hijack-files
file := $$(TARGET_OUT)/bin/$(1)
ALL_PREBUILT += $$(file)
$$(file) : $$(TARGET_OUT)/bin/hijack
	@echo "Symlink: $$@ -> hijack"
	@mkdir -p $$(dir $$@)
	@rm -rf $$@
	$$(hide) ln -sf hijack $$@
endef

$(foreach exe,$(BOARD_HIJACK_EXECUTABLES), \
  $(eval $(call link-hijack-files, $(exe))))

ifeq ($(BOARD_HIJACK_LOG_ENABLE),true)
include $(CLEAR_VARS)
LOCAL_MODULE := hijack.log_dump
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_OUT_EXECUTABLES)
LOCAL_SRC_FILES := $(LOCAL_MODULE)
include $(BUILD_PREBUILT)
endif

endif
