LOCAL_PATH := $(call my-dir)
OPUS_PATH := $(LOCAL_PATH)/opus102

include $(CLEAR_VARS)

LOCAL_MODULE := libopus

# opus
LOCAL_C_INCLUDES += $(OPUS_PATH)/include $(OPUS_PATH)/celt $(OPUS_PATH)/silk

# we need to rebuild silk cause we don't know what are diff required for opus and may change in the future
include $(OPUS_PATH)/silk_sources.mk 
LOCAL_SRC_FILES += $(SILK_SOURCES:%=opus102/%)
ifeq ($(TARGET_ARCH_ABI),$(filter $(TARGET_ARCH_ABI),armeabi armeabi-v7a))
LOCAL_C_INCLUDES += $(OPUS_PATH)/silk/fixed
LOCAL_SRC_FILES += $(SILK_SOURCES_FIXED:%=opus102/%)
else
LOCAL_C_INCLUDES += $(OPUS_PATH)/silk/float
LOCAL_SRC_FILES += $(SILK_SOURCES_FLOAT:%=opus102/%)
endif
include $(OPUS_PATH)/celt_sources.mk
LOCAL_SRC_FILES += $(CELT_SOURCES:%=opus102/%)
include $(OPUS_PATH)/opus_sources.mk
LOCAL_SRC_FILES += $(OPUS_SOURCES:%=opus102/%)

LOCAL_CFLAGS += -DOPUS_BUILD -DVAR_ARRAYS 
# Hack to mute restrict not supported by ndk 
LOCAL_CFLAGS += -Drestrict=__restrict
ifeq ($(TARGET_ARCH_ABI),$(filter $(TARGET_ARCH_ABI),armeabi armeabi-v7a))
LOCAL_CFLAGS += -DFIXED_POINT
endif

include $(BUILD_STATIC_LIBRARY)