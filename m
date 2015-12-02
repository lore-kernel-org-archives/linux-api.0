From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v1 08/10] ARM: configs: add MPS2 defconfig
Date: Wed,  2 Dec 2015 09:33:08 +0000
Message-ID: <1449048790-25859-9-git-send-email-vladimir.murzin@arm.com>
References: <1449048790-25859-1-git-send-email-vladimir.murzin@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449048790-25859-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, u.kleine-koenig@pengutronix.de, afaerber@suse.de, mcoquelin.stm32@gmail.com
Cc: Mark.Rutland@arm.com, Pawel.Moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, jslaby@suse.cz, robh+dt@kernel.org, devicetree@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patch adds a new config for MPS2 platform.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm/configs/mps2_defconfig |  112 +++++++++++++++++++++++++++++++++++=
++++
 1 file changed, 112 insertions(+)
 create mode 100644 arch/arm/configs/mps2_defconfig

diff --git a/arch/arm/configs/mps2_defconfig b/arch/arm/configs/mps2_defcon=
fig
new file mode 100644
index 0000000..c36c519
--- /dev/null
+++ b/arch/arm/configs/mps2_defconfig
@@ -0,0 +1,112 @@
+# CONFIG_USELIB is not set
+CONFIG_NO_HZ_IDLE=3Dy
+CONFIG_HIGH_RES_TIMERS=3Dy
+CONFIG_LOG_BUF_SHIFT=3D16
+CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy
+# CONFIG_UID16 is not set
+# CONFIG_BASE_FULL is not set
+# CONFIG_FUTEX is not set
+# CONFIG_EPOLL is not set
+# CONFIG_SIGNALFD is not set
+# CONFIG_EVENTFD is not set
+# CONFIG_AIO is not set
+CONFIG_EMBEDDED=3Dy
+# CONFIG_VM_EVENT_COUNTERS is not set
+# CONFIG_SLUB_DEBUG is not set
+# CONFIG_BLOCK is not set
+# CONFIG_MMU is not set
+CONFIG_ARM_SINGLE_ARMV7M=3Dy
+CONFIG_ARCH_MPS2=3Dy
+CONFIG_SET_MEM_PARAM=3Dy
+CONFIG_DRAM_BASE=3D0x21000000
+CONFIG_DRAM_SIZE=3D0x1000000
+CONFIG_PREEMPT_VOLUNTARY=3Dy
+# CONFIG_ATAGS is not set
+CONFIG_ZBOOT_ROM_TEXT=3D0x0
+CONFIG_ZBOOT_ROM_BSS=3D0x0
+CONFIG_BINFMT_FLAT=3Dy
+CONFIG_BINFMT_SHARED_FLAT=3Dy
+# CONFIG_COREDUMP is not set
+# CONFIG_SUSPEND is not set
+CONFIG_NET=3Dy
+CONFIG_PACKET=3Dy
+CONFIG_UNIX=3Dy
+CONFIG_INET=3Dy
+CONFIG_IP_PNP=3Dy
+CONFIG_IP_PNP_DHCP=3Dy
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+# CONFIG_INET_LRO is not set
+# CONFIG_INET_DIAG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_WIRELESS is not set
+CONFIG_DEVTMPFS=3Dy
+CONFIG_DEVTMPFS_MOUNT=3Dy
+# CONFIG_FW_LOADER is not set
+CONFIG_NETDEVICES=3Dy
+# CONFIG_NET_CORE is not set
+# CONFIG_NET_VENDOR_ARC is not set
+# CONFIG_NET_CADENCE is not set
+# CONFIG_NET_VENDOR_BROADCOM is not set
+# CONFIG_NET_VENDOR_CIRRUS is not set
+# CONFIG_NET_VENDOR_EZCHIP is not set
+# CONFIG_NET_VENDOR_FARADAY is not set
+# CONFIG_NET_VENDOR_HISILICON is not set
+# CONFIG_NET_VENDOR_INTEL is not set
+# CONFIG_NET_VENDOR_MARVELL is not set
+# CONFIG_NET_VENDOR_MICREL is not set
+# CONFIG_NET_VENDOR_NATSEMI is not set
+# CONFIG_NET_VENDOR_QUALCOMM is not set
+# CONFIG_NET_VENDOR_RENESAS is not set
+# CONFIG_NET_VENDOR_ROCKER is not set
+# CONFIG_NET_VENDOR_SAMSUNG is not set
+# CONFIG_NET_VENDOR_SEEQ is not set
+CONFIG_SMSC911X=3Dy
+# CONFIG_NET_VENDOR_STMICRO is not set
+# CONFIG_NET_VENDOR_VIA is not set
+# CONFIG_NET_VENDOR_WIZNET is not set
+# CONFIG_WLAN is not set
+# CONFIG_INPUT is not set
+# CONFIG_SERIO is not set
+# CONFIG_VT is not set
+# CONFIG_LEGACY_PTYS is not set
+CONFIG_SERIAL_NONSTANDARD=3Dy
+# CONFIG_DEVKMEM is not set
+CONFIG_SERIAL_MPS2_UART_CONSOLE=3Dy
+CONFIG_SERIAL_MPS2_UART=3Dy
+# CONFIG_HW_RANDOM is not set
+# CONFIG_HWMON is not set
+CONFIG_WATCHDOG=3Dy
+CONFIG_ARM_SP805_WATCHDOG=3Dy
+CONFIG_MFD_SYSCON=3Dy
+# CONFIG_USB_SUPPORT is not set
+CONFIG_NEW_LEDS=3Dy
+CONFIG_LEDS_CLASS=3Dy
+CONFIG_LEDS_SYSCON=3Dy
+CONFIG_LEDS_TRIGGERS=3Dy
+CONFIG_LEDS_TRIGGER_TIMER=3Dy
+CONFIG_LEDS_TRIGGER_ONESHOT=3Dy
+CONFIG_LEDS_TRIGGER_HEARTBEAT=3Dy
+CONFIG_LEDS_TRIGGER_BACKLIGHT=3Dy
+CONFIG_LEDS_TRIGGER_CPU=3Dy
+CONFIG_LEDS_TRIGGER_DEFAULT_ON=3Dy
+CONFIG_ARM_TIMER_SP804=3Dy
+# CONFIG_DNOTIFY is not set
+# CONFIG_INOTIFY_USER is not set
+# CONFIG_MISC_FILESYSTEMS is not set
+CONFIG_NFS_FS=3Dy
+CONFIG_NFS_V4=3Dy
+CONFIG_NFS_V4_1=3Dy
+CONFIG_NFS_V4_2=3Dy
+CONFIG_ROOT_NFS=3Dy
+CONFIG_NLS=3Dy
+CONFIG_PRINTK_TIME=3Dy
+CONFIG_DEBUG_INFO=3Dy
+# CONFIG_ENABLE_WARN_DEPRECATED is not set
+# CONFIG_ENABLE_MUST_CHECK is not set
+CONFIG_DEBUG_FS=3Dy
+CONFIG_MAGIC_SYSRQ=3Dy
+# CONFIG_SCHED_DEBUG is not set
+# CONFIG_DEBUG_BUGVERBOSE is not set
+CONFIG_MEMTEST=3Dy
--=20
1.7.9.5
