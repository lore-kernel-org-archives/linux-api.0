From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 13/14] ARM: configs: Add STM32 defconfig
Date: Thu, 12 Feb 2015 18:46:03 +0100
Message-ID: <1423763164-5606-14-git-send-email-mcoquelin.stm32__19857.8884978362$1423763275$gmane$org@gmail.com>
References: <1423763164-5606-1-git-send-email-mcoquelin.stm32@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423763164-5606-1-git-send-email-mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Nikolay Borisov <Nikolay.Borisov-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch adds a new config for STM32 MCUs.
STM32F429 Discovery board boots successfully with this config applied.

Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 arch/arm/configs/stm32_defconfig | 72 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)
 create mode 100644 arch/arm/configs/stm32_defconfig

diff --git a/arch/arm/configs/stm32_defconfig b/arch/arm/configs/stm32_defconfig
new file mode 100644
index 0000000..3d7802a
--- /dev/null
+++ b/arch/arm/configs/stm32_defconfig
@@ -0,0 +1,72 @@
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_LOG_BUF_SHIFT=16
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_INITRAMFS_SOURCE="./rootfs.cpio"
+CONFIG_CC_OPTIMIZE_FOR_SIZE=y
+# CONFIG_UID16 is not set
+# CONFIG_BASE_FULL is not set
+# CONFIG_FUTEX is not set
+# CONFIG_EPOLL is not set
+# CONFIG_SIGNALFD is not set
+# CONFIG_EVENTFD is not set
+# CONFIG_AIO is not set
+CONFIG_EMBEDDED=y
+# CONFIG_VM_EVENT_COUNTERS is not set
+# CONFIG_SLUB_DEBUG is not set
+# CONFIG_LBDAF is not set
+# CONFIG_BLK_DEV_BSG is not set
+# CONFIG_IOSCHED_DEADLINE is not set
+# CONFIG_IOSCHED_CFQ is not set
+# CONFIG_MMU is not set
+CONFIG_ARCH_STM32=y
+CONFIG_SET_MEM_PARAM=y
+CONFIG_DRAM_BASE=0xd0000000
+CONFIG_FLASH_MEM_BASE=0x08000000
+CONFIG_FLASH_SIZE=0x00200000
+CONFIG_PREEMPT=y
+# CONFIG_ATAGS is not set
+CONFIG_ZBOOT_ROM_TEXT=0x0
+CONFIG_ZBOOT_ROM_BSS=0x0
+CONFIG_XIP_KERNEL=y
+CONFIG_XIP_PHYS_ADDR=0x08020000
+CONFIG_BINFMT_FLAT=y
+CONFIG_BINFMT_SHARED_FLAT=y
+# CONFIG_COREDUMP is not set
+CONFIG_DEVTMPFS=y
+CONFIG_DEVTMPFS_MOUNT=y
+# CONFIG_FW_LOADER is not set
+# CONFIG_BLK_DEV is not set
+CONFIG_EEPROM_93CX6=y
+# CONFIG_INPUT is not set
+# CONFIG_SERIO is not set
+# CONFIG_VT is not set
+# CONFIG_UNIX98_PTYS is not set
+# CONFIG_LEGACY_PTYS is not set
+CONFIG_SERIAL_NONSTANDARD=y
+# CONFIG_DEVKMEM is not set
+CONFIG_SERIAL_STM32=y
+CONFIG_SERIAL_STM32_CONSOLE=y
+# CONFIG_HW_RANDOM is not set
+CONFIG_GPIO_SYSFS=y
+# CONFIG_HWMON is not set
+CONFIG_USB=y
+CONFIG_USB_DWC2=y
+CONFIG_NEW_LEDS=y
+CONFIG_LEDS_CLASS=y
+CONFIG_LEDS_GPIO=y
+CONFIG_LEDS_TRIGGERS=y
+CONFIG_LEDS_TRIGGER_HEARTBEAT=y
+# CONFIG_IOMMU_SUPPORT is not set
+# CONFIG_FILE_LOCKING is not set
+# CONFIG_DNOTIFY is not set
+# CONFIG_INOTIFY_USER is not set
+CONFIG_PRINTK_TIME=y
+CONFIG_DEBUG_INFO=y
+# CONFIG_ENABLE_WARN_DEPRECATED is not set
+# CONFIG_ENABLE_MUST_CHECK is not set
+CONFIG_MAGIC_SYSRQ=y
+# CONFIG_SCHED_DEBUG is not set
+# CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_FTRACE is not set
+CONFIG_CRC_ITU_T=y
+CONFIG_CRC7=y
-- 
1.9.1
