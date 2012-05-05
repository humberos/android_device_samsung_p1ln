# This file is the device-specific product definition file for P1000 devices. 
# It lists all the overlays, files, modules and properties that are specific 
# to this hardware: i.e. those are device-specific drivers, configuration 
# files, settings, etc...
#
# Note that P1000 is not a fully open device. Some of the drivers aren't publicly
# available, which means that some of the hardware capabilities aren't present 
# in builds where those drivers aren't available. Such cases are handled by having
# the configuration separated into two halves: this half here contains the parts
# that are available to everyone, while another half in the vendor/ hierarchy 
# augments that set with the parts that are only relevant when all the associated
# drivers are available. Aspects that are irrelevant but harmless in no-driver
# builds should be kept here for simplicity and transparency. 

# --------------------------------------------------------------------------------
# device specific configuration
# --------------------------------------------------------------------------------

# This is the hardware-specific overlay, which points to the location
# of hardware-specific resource overrides, typically the frameworks and
# application settings that are stored in resourced.

DEVICE_PACKAGE_OVERLAYS := device/samsung/p1/overlay

# --------------------------------------------------------------------------------
# inherit device configuration common between GSM & CDMA products.
# --------------------------------------------------------------------------------

$(call inherit-product, device/samsung/p1-common/device_base.mk)

# --------------------------------------------------------------------------------
# Inherit VENDOR blobs and configuration.
# --------------------------------------------------------------------------------

# There are two variants of the half that deals with the unavailable drivers: one
# is directly checked into the unreleased vendor tree and is used by engineers who
# have access to it. The other is generated by setup-makefile.sh in the same
# directory as this files, and is used by people who have access to binary versions 
# of the drivers but not to the original vendor tree. Be sure to update both.

$(call inherit-product-if-exists, vendor/samsung/p1/p1-vendor.mk)

# --------------------------------------------------------------------------------
# Inherit from other products - most specific first
# --------------------------------------------------------------------------------

$(call inherit-product, $(SRC_TARGET_DIR)/product/full.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# Init files
PRODUCT_COPY_FILES += \
	device/samsung/p1/init.gt-p1000.rc:root/init.gt-p1000.rc \
	device/samsung/p1/ueventd.gt-p1000.rc:root/ueventd.gt-p1000.rc 

# vold
PRODUCT_COPY_FILES += \
        device/samsung/p1/prebuilt/etc/vold.fstab:system/etc/vold.fstab

# RIL
# Permissions
PRODUCT_COPY_FILES += \
	frameworks/base/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml

# Device-specific packages
PRODUCT_PACKAGES += \
	SamsungServiceMode

# Build.prop overrides
PRODUCT_PROPERTY_OVERRIDES += \
       ro.telephony.call_ring.delay=3000 \
       ro.telephony.call_ring.absent=true \
       mobiledata.interfaces=pdp0,wlan0,gprs \
       ro.telephony.ril.v3=icccardstatus,datacall,signalstrength,facilitylock \
       ro.ril.enable.managed.roaming=1 \
       ro.ril.oem.nosim.ecclist=911,112,999,000,08,118,120,122,110,119,995 \
       ro.ril.emc.mode=2 \
       rild.libpath=/system/lib/libsec-ril.so \
       rild.libargs=-d/dev/ttyS0 \
       ro.sf.lcd_density=160 \
       ro.phone_storage=1 \
       ro.additionalmounts=/mnt/emmc \
       ro.vold.switchablepair=/mnt/sdcard,/mnt/emmc \
       persist.sys.vold.switchexternal=0

# set recovery.fstab location (needed for p1l & p1n products)
TARGET_RECOVERY_FSTAB := device/samsung/p1/recovery.fstab

# Galaxy Tab uses high-density artwork where available
PRODUCT_LOCALES += hdpi

# Screen size is "large" 7'tablet, density is "hdpi"
PRODUCT_AAPT_CONFIG := large hdpi

# --------------------------------------------------------------------------------
# define common P1 product settings
# --------------------------------------------------------------------------------

# set here product definitions that valid for all p1 products
PRODUCT_BRAND := samsung
PRODUCT_MANUFACTURER := samsung

# Set build fingerprint / ID / product name etc.
PRODUCT_BUILD_PROP_OVERRIDES += \
       PRODUCT_NAME=GT-P1000 \
       TARGET_DEVICE=GT-P1000 \
       BUILD_FINGERPRINT=samsung/GT-P1000/GT-P1000:2.3.5/GINGERBREAD/XXJVT:user/release-keys \
       PRIVATE_BUILD_DESC="GT-P1000-user 2.3.5 GINGERBREAD XXJVT release-keys"
