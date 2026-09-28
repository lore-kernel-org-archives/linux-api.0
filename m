Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5B74A1E03
	for <linux-api@vger.kernel.org>; Mon, 28 Sep 2026 11:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790594362; cv=none; b=pIyDMLm2JYhDfPLMz2PcUssrpW69kvyw75ZJbMXK4pHl4qsi6mmaMdhyZCBjuXZ4x9pfOHr7bJ5jcXfa6F3m0CZqBF1x+ESCdqNimEp+7RrmjCcBNybIKPbrF5y2HzC11e63pnDAA2VsGB8pETmMTl+k5QM5ryhBBNPLftqYgws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790594362; c=relaxed/simple;
	bh=J+elphDED8lZ6p1BXG7GwAqnz1DPaMJRk3StcWkVjnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RfmbwJjwmzCG1Lrmm0CWsoozrT0sjb6AAuY2Df49jHpTOgElIE2oQSSePpsQLZo7hk98QKa1VS8iTmi9UOD4opHMwEZUD/vpEgM9N5/YR0OIVVmnXDOPDJQEazuE62Vu6zw0AYVo5vGONPuIQEZq2Q5lWWbBvXNQ2jr4i11yKeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GwiHGNFs; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GwiHGNFs"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485ac898fa4so2418772f8f.0
        for <linux-api@vger.kernel.org>; Mon, 28 Sep 2026 04:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790594358; x=1791199158; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NAVucCKmK28jzqfKNC7sP6QG65IPNfGrF5bTqhmyEog=;
        b=GwiHGNFsnNWZAMQxVmdDdS3VEV8ysysHJJHPNVyOHnoCnFIUz56H/f0r68fotM/ZtN
         o2eteiK68seeF7xhdAix86c7NohFuKJFpkQA0tBtVPWi+EmeOBrqEGuQsbWTf/qnppeO
         LVwYqRoMUfRGTn/LJ0BYmxBo6Ya4urTSExPGGl9IWpVTrA2m1PKQXw+lj0kDI8VB4U7h
         pG6ztVq2NuUI6SIkUwt5DnxddFlwIpz2Klc/Fetl+tcj7BwPxG82xbk3RngyTTzCm403
         gVBGwvNClBEl08Q7B0l0YCJiuPVIucco18Pp5AI8owhj1kG+S4spUDJhOWTOPgnvhDCA
         5FZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790594358; x=1791199158;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NAVucCKmK28jzqfKNC7sP6QG65IPNfGrF5bTqhmyEog=;
        b=DSdjIAI9r8x4xS60DSch3U/1E7Q0d6f1WrzW/cxxmUUTxt8IDy/wHDqhMkdrs9KGyq
         XoUv8hFzQBqMM7pAWtqv81aJ7Z5F4M1xlNMoPrgDwJN2MvmHOvPt+jx57msJdgUs2YcA
         pKEC8tZyT2fOc7C7BKvHe19A4gXSYvWssKRss0pIdKf9Qjzv6cSIYUGaI/LL4GICngjK
         3Vcb5P+o36wOXxqsr2szYJ85Ymc4VoC2blA7ovvcjSb8y2qDW6ICarSmuI+ff9lmODor
         1Lf5WOJNSc//yCii4wJTjGzKjui4ZBlGWeJRcsTty9612nSsnDUoeWoFPHsQGoFByt75
         BwiQ==
X-Forwarded-Encrypted: i=1; AKwUvByUtR7pXCR3BBUcyTQfkwf39TEDYiR12VQC56ORzI8hZNeUmJTqyww2Oqd/kZV78w1g/ODOD5rXOzE=@vger.kernel.org
X-Gm-Message-State: AFq9FYL0OlJji4Sef6F7u+ZNZIkRV5a6f0abwLvplL5C86O88txFAz3W
	cgtZXlFwhx5e08ESkyem+Xp5chzp1PnkX49+GXflGHLK6usrqRSB9IRD
X-Gm-Gg: AYBFou2HHNT3hdERDt8kJCMQryOeWLaYoh43SlQ3e8FfcWQQXmqAdgOlCpPkOXhlVfs
	dWjqyXClrhIcCEczPqa3Il/Pm2DS3c60VT/iWiGoY4qQG8bnwbed1nBzWB12wcwKajnxqkQ92DG
	eUK442FMV1ZHxlPQde4tNvIjcJwjDmIdrt3naI5X7Pz+iur9UudlUVp5hy+o97gohB4zFdxggQf
	GXSOuNgy8JF/hzBmaLRgwqGebMeXJktMFXkaH82NqMerWqIYZPfw8ZHj2hd05fkLlPlBf2yR0hy
	NlzqIBO3FM5HeoRY3E4lq7AZnGEfAKt7IZpEdTEEMulsrW/MmHlSXGD6R0n0JZ3fzvLu7GnRMDE
	zA4o2sx6W3RHHvkCSO3//PJBIXkqJvWChTcBhZgvSJRxlcpyY50beuNG9hHltlb3qUfNuqTSRyQ
	fmtIZu8rMSwPq+r556Xjk+9FRCZuIIgExn+LSvJv6d2ufFtEYhflG2FyRerWFv42Ehrip9OEbVl
	STR6uGrR4nZoNETPc+jz28wLn7dRa98tBXBEcis2le1l9dpRgHWFp3/UnBrQxJb0MiNnuh9UgFz
	j2AtaOXiZcjGNIf8yThjG3e8ttxMnihfX0L4iSqe
X-Received: by 2002:a05:6000:2dc3:b0:487:951:20 with SMTP id ffacd0b85a97d-488718775ebmr25465991f8f.46.1790594357559;
        Mon, 28 Sep 2026 04:19:17 -0700 (PDT)
Received: from localhost.localdomain (37-188-186-98.red.o2.cz. [37.188.186.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a34a638sm26164969f8f.9.2026.09.28.04.19.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Sep 2026 04:19:17 -0700 (PDT)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
To: Lee Jones <lee@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Rong Zhang <i@rong.moe>,
	linux-leds@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] leds: Add support for Turris 1.x LEDs
Date: Mon, 28 Sep 2026 13:19:07 +0200
Message-ID: <20260928111907.72592-3-pepe.schlehofer@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260928111907.72592-1-pepe.schlehofer@gmail.com>
References: <20260928111907.72592-1-pepe.schlehofer@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

Add a driver for the eight RGB LEDs on the front panel of the CZ.NIC
Turris 1.x routers. They are driven by the CZ.NIC CPLD firmware, whose
source is available at
https://gitlab.nic.cz/turris/hw/turris_cpld/-/blob/master/CZ_NIC_Router_CPLD.v

The LEDs use the multicolor LED class. Every LED except the WiFi LED can
also be driven by the CPLD from hardware events, exposed as the private
turris1x-cpld trigger. The five LAN LEDs share one set of colour
registers, so the colour and brightness set last on any of them apply
to all five.

The controller device exposes the global brightness controlled by the
button on the back of the router through `brightness`,
`brightness_level`, and `brightness_levels/<N>`. The Turris Omnia
driver already has `brightness`, so its ABI entry is extended to cover
the Turris 1.x as well.

Signed-off-by: Pali Rohár <pali@kernel.org>
Cc: Marek Behún <kabel@kernel.org>
Cc: Andy Shevchenko <andy@kernel.org>
Co-developed-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
---

Notes:
    Changes in v3, by Josef Schlehofer:
    - use actual CPLD register addresses and common read/write helpers
    - replace literal LED counts with driver constants and simplify LED
      lookup
    - use property/fwnode helpers, sysfs_emit(), kstrtou8(), and set the
      Kconfig dependency to PPC_85xx || COMPILE_TEST
    - replace the mutex with a spinlock so that brightness_set() does not
      sleep
    - drop brightness_get(), which could only return 0 or 1
    - expose brightness levels as brightness_levels/<N> sysfs files and
      document brightness in the existing Turris Omnia ABI entry, with its
      own Date and KernelVersion for the Turris 1.x
    - scale RGB colour by max_brightness = 255, keep per-LED intensities,
      and clamp the colour components to the 8-bit registers
    - restore CPLD control on unbind and restore configured colours when
      enabling the hardware trigger
    - leave the software enable bit alone while the hardware trigger drives
      the LED
    - take an LED over from the CPLD when a DT default trigger replaces the
      hardware trigger
    - stop writing the LED registers once they are reset at shutdown
    - use .dev_groups instead of devm_device_add_groups() and
      MODULE_DEVICE_TABLE() instead of MODULE_ALIAS(), and add the
      MAINTAINERS entry, which also covers the Omnia ABI file
    - implement hw_offloaded() and set hw_control_trigger for the LEDs that
      have the turris1x-cpld trigger, as leds-turris-omnia does since the
      hardware control changes in leds-next
    - short error messages, e.g. "LED %u already registered", and lines
      wrapped at 100 columns (Lee)
    - drop the comma after the NULL terminators (Andy)
    - write U8_MAX instead of 0xff in the reset (Andy asked about
      GENMASK()): the value is the maximum of an 8-bit colour register,
      not a bit mask
    - mc_cdev.subled_info points to the per-LED subled_info array, it is
      not a second copy of it (Lee)
    - keep the static led_hw_trigger_type (Lee): it holds no data, the LED
      core only compares its address with cdev->trigger_type, and the
      static turris1x-cpld trigger refers to it in its initializer, as in
      leds-turris-omnia
    - keep the reset at shutdown rather than at boot (Lee): the LED
      registers survive a board reset, and the CPLD shows its reset pattern
      correctly only when they are back in the default state before the
      reset, which U-Boot would do too late (Pali's answer in [1])
    - drop Marek's Reviewed-by from v2, the driver was largely rewritten
    
    [1] https://lore.kernel.org/r/20230309203526.5hcfa2w47vqzmny6@pali/

 .../sysfs-class-led-driver-turris-omnia       |  13 +-
 .../testing/sysfs-class-led-driver-turris1x   |  23 +
 MAINTAINERS                                   |  10 +
 drivers/leds/Kconfig                          |  13 +
 drivers/leds/Makefile                         |   1 +
 drivers/leds/leds-turris-1x.c                 | 609 ++++++++++++++++++
 6 files changed, 666 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-led-driver-turris1x
 create mode 100644 drivers/leds/leds-turris-1x.c

diff --git a/Documentation/ABI/testing/sysfs-class-led-driver-turris-omnia b/Documentation/ABI/testing/sysfs-class-led-driver-turris-omnia
index 369b4ae8be5f..bc2eaf292b3f 100644
--- a/Documentation/ABI/testing/sysfs-class-led-driver-turris-omnia
+++ b/Documentation/ABI/testing/sysfs-class-led-driver-turris-omnia
@@ -1,7 +1,7 @@
 What:		/sys/class/leds/<led>/device/brightness
-Date:		July 2020
-KernelVersion:	5.9
-Contact:	Marek Behún <kabel@kernel.org>
+Date:		July 2020 (Turris Omnia), September 2026 (Turris 1.x)
+KernelVersion:	5.9 (Turris Omnia), 7.4 (Turris 1.x)
+Contact:	Marek Behún <kabel@kernel.org>, linux-leds@vger.kernel.org
 Description:	(RW) On the front panel of the Turris Omnia router there is also
 		a button which can be used to control the intensity of all the
 		LEDs at once, so that if they are too bright, user can dim them.
@@ -11,6 +11,13 @@ Description:	(RW) On the front panel of the Turris Omnia router there is also
 		integer value between 0 and 100. It is therefore convenient to be
 		able to change this setting from software.
 
+		The button on the back of Turris 1.x routers selects one of 8
+		brightness levels, whose values (0-255) are in
+		brightness_levels/<N>. Reading this file returns the value of
+		the level in use; writing it selects the level whose value is
+		closest to the written one. If two levels are equally close, the
+		lower level index is selected.
+
 		Format: %i
 
 What:		/sys/class/leds/<led>/device/gamma_correction
diff --git a/Documentation/ABI/testing/sysfs-class-led-driver-turris1x b/Documentation/ABI/testing/sysfs-class-led-driver-turris1x
new file mode 100644
index 000000000000..961d29dedafd
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-led-driver-turris1x
@@ -0,0 +1,23 @@
+What:		/sys/class/leds/<led>/device/brightness_level
+Date:		September 2026
+Contact:	Josef Schlehofer <pepe.schlehofer@gmail.com>
+Description:	(RW) Index (0-7) of the global brightness level in use on the
+		Turris 1.x routers. The button on the back side of the router
+		steps through the levels. Writing to this file selects a level
+		directly. The CPLD keeps the selection across driver unbind and
+		reboot.
+
+		Format: %u
+
+What:		/sys/class/leds/<led>/device/brightness_levels/<N>
+Date:		September 2026
+Contact:	Josef Schlehofer <pepe.schlehofer@gmail.com>
+Description:	(RW) Value of the global brightness level N (0-7) on the
+		Turris 1.x routers, one file per level. These are the values
+		the CPLD firmware steps through when the brightness button is
+		pressed. Reading returns the value, writing accepts an integer
+		between 0 and 255. The CPLD keeps the values across driver
+		unbind and reboot, and restores the defaults (255 64 32 16 8 4
+		2 0) at power-on and when the reset button is pressed.
+
+		Format: %u
diff --git a/MAINTAINERS b/MAINTAINERS
index a1eb0937238d..f3df66cbde05 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7163,6 +7163,16 @@ L:	linux-input@vger.kernel.org
 S:	Maintained
 F:	drivers/input/touchscreen/cyttsp*
 
+CZ.NIC TURRIS 1.X LED DRIVER
+M:	Josef Schlehofer <pepe.schlehofer@gmail.com>
+L:	linux-leds@vger.kernel.org
+S:	Maintained
+W:	https://www.turris.cz/
+F:	Documentation/ABI/testing/sysfs-class-led-driver-turris-omnia
+F:	Documentation/ABI/testing/sysfs-class-led-driver-turris1x
+F:	Documentation/devicetree/bindings/leds/cznic,turris1x-leds.yaml
+F:	drivers/leds/leds-turris-1x.c
+
 D-LINK DIR-685 TOUCHKEYS DRIVER
 M:	Linus Walleij <linusw@kernel.org>
 L:	linux-input@vger.kernel.org
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 7ec2c8d78542..bfcf19912900 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -227,6 +227,19 @@ config LEDS_EL15203000
 	  To compile this driver as a module, choose M here: the module
 	  will be called leds-el15203000.
 
+config LEDS_TURRIS_1X
+	tristate "LED support for CZ.NIC's Turris 1.x routers"
+	depends on LEDS_CLASS_MULTICOLOR
+	depends on PPC_85xx || COMPILE_TEST
+	select LEDS_TRIGGERS
+	help
+	  This option enables support for the eight RGB LEDs on the front
+	  panel of CZ.NIC's Turris 1.x routers. The LEDs are driven by the
+	  CPLD firmware, which can also drive them from hardware events.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called leds-turris-1x.
+
 config LEDS_TURRIS_OMNIA
 	tristate "LED support for CZ.NIC's Turris Omnia"
 	depends on LEDS_CLASS_MULTICOLOR
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 4d4b089156e2..1a5bddc3a3d6 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -96,6 +96,7 @@ obj-$(CONFIG_LEDS_TCA6507)		+= leds-tca6507.o
 obj-$(CONFIG_LEDS_TI_LMU_COMMON)	+= leds-ti-lmu-common.o
 obj-$(CONFIG_LEDS_TLC591XX)		+= leds-tlc591xx.o
 obj-$(CONFIG_LEDS_TPS6105X)		+= leds-tps6105x.o
+obj-$(CONFIG_LEDS_TURRIS_1X)		+= leds-turris-1x.o
 obj-$(CONFIG_LEDS_TURRIS_OMNIA)		+= leds-turris-omnia.o
 obj-$(CONFIG_LEDS_UPBOARD)		+= leds-upboard.o
 obj-$(CONFIG_LEDS_WM831X_STATUS)	+= leds-wm831x-status.o
diff --git a/drivers/leds/leds-turris-1x.c b/drivers/leds/leds-turris-1x.c
new file mode 100644
index 000000000000..491a0e70e4c0
--- /dev/null
+++ b/drivers/leds/leds-turris-1x.c
@@ -0,0 +1,609 @@
+// SPDX-License-Identifier: GPL-2.0
+// (C) 2022 Pali Rohár <pali@kernel.org>
+//
+// CZ.NIC's Turris 1.x LEDs driver, controlled by CPLD firmware:
+// https://gitlab.nic.cz/turris/hw/turris_cpld/-/blob/master/CZ_NIC_Router_CPLD.v
+
+#include <linux/bits.h>
+#include <linux/container_of.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/kstrtox.h>
+#include <linux/led-class-multicolor.h>
+#include <linux/leds.h>
+#include <linux/limits.h>
+#include <linux/math.h>
+#include <linux/minmax.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/property.h>
+#include <linux/spinlock.h>
+#include <linux/sysfs.h>
+#include <linux/types.h>
+
+/* Addresses in the CPLD memory map, the LED registers start at 0x13 */
+#define TURRIS1X_LED_REG_BASE			0x13
+#define TURRIS1X_LED_COLOR_REG			0x13
+#define TURRIS1X_LED_GLOBAL_LEVEL_REG		0x20
+#define TURRIS1X_LED_GLOBAL_BRIGHTNESS_REG	0x21
+#define TURRIS1X_LED_SW_OVERRIDE_REG		0x22
+/* Called led_sw_enable in the CPLD source, but a set bit turns the LED off */
+#define TURRIS1X_LED_SW_DISABLE_REG		0x23
+/* 0x28 + N holds the value of level N (level 7 - N in the CPLD source) */
+#define TURRIS1X_LED_LEVEL_VALUE_REG		0x28
+
+#define TURRIS1X_LED_NUM			8
+#define TURRIS1X_LED_NUM_COLORS			3
+#define TURRIS1X_LED_NUM_LEVELS			8
+#define TURRIS1X_LED_GLOBAL_LEVEL_MASK		GENMASK(2, 0)
+/* Blocks of colour registers: LED 0, LEDs 1-5 (shared), LED 6 and LED 7 */
+#define TURRIS1X_LED_NUM_COLOR_BLOCKS		4
+#define TURRIS1X_LED_WIFI			6
+
+struct turris1x_led {
+	struct led_classdev_mc mc_cdev;
+	struct mc_subled subled_info[TURRIS1X_LED_NUM_COLORS];
+	u32 reg;
+	bool registered;
+	/* Set when software has the LED on, i.e. its SW_DISABLE bit is clear */
+	bool on;
+	/* Set when the hardware trigger drives this LED */
+	bool hwtrig;
+};
+
+#define to_turris1x_led(cdev) \
+	container_of(lcdev_to_mccdev(cdev), struct turris1x_led, mc_cdev)
+
+struct turris1x_leds {
+	void __iomem *regs;
+	/* Protects the CPLD LED registers and @reset */
+	spinlock_t lock;
+	/* Set by turris1x_leds_reset(), after which the LEDs are left alone */
+	bool reset;
+	struct turris1x_led led[TURRIS1X_LED_NUM];
+};
+
+static struct led_hw_trigger_type turris1x_hw_trigger_type;
+
+static u8 turris1x_read(struct turris1x_leds *ddata, unsigned int reg)
+{
+	return readb(ddata->regs + reg - TURRIS1X_LED_REG_BASE);
+}
+
+static void turris1x_write(struct turris1x_leds *ddata, unsigned int reg, u8 val)
+{
+	writeb(val, ddata->regs + reg - TURRIS1X_LED_REG_BASE);
+}
+
+/* Block of three colour registers (red, green, blue) that each LED uses */
+static const u8 turris1x_color_block[TURRIS1X_LED_NUM] = {
+	0,		/* WAN */
+	1, 1, 1, 1, 1,	/* LAN 1-5 share one block */
+	2,		/* WiFi */
+	3,		/* power */
+};
+
+static unsigned int turris1x_color_reg(u32 led, unsigned int color)
+{
+	return TURRIS1X_LED_COLOR_REG + turris1x_color_block[led] * TURRIS1X_LED_NUM_COLORS + color;
+}
+
+/* Must be called with ddata->lock held */
+static void turris1x_led_set_colors(struct turris1x_leds *ddata, struct turris1x_led *led,
+				    enum led_brightness brightness)
+{
+	struct led_classdev_mc *mc_cdev = &led->mc_cdev;
+	unsigned int i;
+	u8 val;
+
+	led_mc_calc_color_components(mc_cdev, brightness);
+
+	/* The colour registers are 8 bits wide, do not let values wrap */
+	for (i = 0; i < TURRIS1X_LED_NUM_COLORS; i++) {
+		val = min_t(unsigned int, mc_cdev->subled_info[i].brightness, U8_MAX);
+		turris1x_write(ddata, turris1x_color_reg(led->reg, i), val);
+	}
+}
+
+static int turris1x_hwtrig_activate(struct led_classdev *cdev)
+{
+	struct turris1x_leds *ddata = dev_get_drvdata(cdev->dev->parent);
+	struct turris1x_led *led = to_turris1x_led(cdev);
+	unsigned long flags;
+	u8 val;
+
+	spin_lock_irqsave(&ddata->lock, flags);
+
+	if (ddata->reset)
+		goto unlock;
+
+	/*
+	 * If software turned the LED off, the last configured colour was not
+	 * necessarily written to the CPLD. Write it with max_brightness before
+	 * the hardware takes over.
+	 */
+	if (!led->on)
+		turris1x_led_set_colors(ddata, led, cdev->max_brightness);
+
+	/* Disable LED software control */
+	val = turris1x_read(ddata, TURRIS1X_LED_SW_OVERRIDE_REG);
+	turris1x_write(ddata, TURRIS1X_LED_SW_OVERRIDE_REG, val & ~BIT(led->reg));
+
+	led->hwtrig = true;
+
+unlock:
+	spin_unlock_irqrestore(&ddata->lock, flags);
+
+	return 0;
+}
+
+static void turris1x_hwtrig_deactivate(struct led_classdev *cdev)
+{
+	struct turris1x_leds *ddata = dev_get_drvdata(cdev->dev->parent);
+	struct turris1x_led *led = to_turris1x_led(cdev);
+	unsigned long flags;
+	u8 val;
+
+	spin_lock_irqsave(&ddata->lock, flags);
+
+	if (ddata->reset)
+		goto unlock;
+
+	led->hwtrig = false;
+
+	/*
+	 * Turn the LED off before software control takes over, as the LED core
+	 * does right after anyway.
+	 */
+	val = turris1x_read(ddata, TURRIS1X_LED_SW_DISABLE_REG);
+	turris1x_write(ddata, TURRIS1X_LED_SW_DISABLE_REG, val | BIT(led->reg));
+	led->on = false;
+
+	/* Enable LED software control */
+	val = turris1x_read(ddata, TURRIS1X_LED_SW_OVERRIDE_REG);
+	turris1x_write(ddata, TURRIS1X_LED_SW_OVERRIDE_REG, val | BIT(led->reg));
+
+unlock:
+	spin_unlock_irqrestore(&ddata->lock, flags);
+}
+
+static bool turris1x_hwtrig_hw_offloaded(struct led_classdev *cdev)
+{
+	return true;
+}
+
+static struct led_trigger turris1x_hw_trigger = {
+	.name		= "turris1x-cpld",
+	.activate	= turris1x_hwtrig_activate,
+	.deactivate	= turris1x_hwtrig_deactivate,
+	.hw_offloaded	= turris1x_hwtrig_hw_offloaded,
+	.trigger_type	= &turris1x_hw_trigger_type,
+};
+
+static void turris1x_led_brightness_set(struct led_classdev *cdev, enum led_brightness brightness)
+{
+	struct turris1x_leds *ddata = dev_get_drvdata(cdev->dev->parent);
+	struct turris1x_led *led = to_turris1x_led(cdev);
+	unsigned long flags;
+	u8 val;
+
+	spin_lock_irqsave(&ddata->lock, flags);
+
+	/* Software triggers run until the reboot, do not undo the reset */
+	if (ddata->reset)
+		goto unlock;
+
+	/*
+	 * Write the colours when the LED is on, and also when the hardware
+	 * trigger drives it, as the trigger uses the same registers.
+	 */
+	if (brightness || led->hwtrig)
+		turris1x_led_set_colors(ddata, led, brightness ?: cdev->max_brightness);
+
+	/*
+	 * Enable or disable the LED under software control. The CPLD ignores
+	 * this bit while the hardware trigger drives the LED, so leave it
+	 * alone.
+	 */
+	if (!led->hwtrig) {
+		val = turris1x_read(ddata, TURRIS1X_LED_SW_DISABLE_REG);
+		if (brightness)
+			val &= ~BIT(led->reg);
+		else
+			val |= BIT(led->reg);
+		turris1x_write(ddata, TURRIS1X_LED_SW_DISABLE_REG, val);
+		led->on = !!brightness;
+	}
+
+unlock:
+	spin_unlock_irqrestore(&ddata->lock, flags);
+}
+
+static int turris1x_led_register(struct device *dev, struct turris1x_leds *ddata,
+				 struct fwnode_handle *fwnode, u8 val_sw_override,
+				 u8 val_sw_disable)
+{
+	static const unsigned int colors[TURRIS1X_LED_NUM_COLORS] = {
+		LED_COLOR_ID_RED, LED_COLOR_ID_GREEN, LED_COLOR_ID_BLUE,
+	};
+	struct led_init_data init_data = {};
+	struct led_classdev *cdev;
+	struct turris1x_led *led;
+	unsigned long flags;
+	u8 val, dis;
+	u32 reg, color;
+	unsigned int i;
+	int ret;
+
+	ret = fwnode_property_read_u32(fwnode, "reg", &reg);
+	if (ret || reg >= TURRIS1X_LED_NUM)
+		return dev_err_probe(dev, -EINVAL, "Invalid or missing 'reg' property\n");
+
+	ret = fwnode_property_read_u32(fwnode, "color", &color);
+	if (ret || color != LED_COLOR_ID_RGB)
+		return dev_err_probe(dev, -EINVAL, "Invalid or missing 'color' property\n");
+
+	led = &ddata->led[reg];
+	if (led->registered)
+		return dev_err_probe(dev, -EINVAL, "LED %u already registered\n", reg);
+
+	led->reg = reg;
+
+	/* Set the initial colours to those currently in use */
+	for (i = 0; i < TURRIS1X_LED_NUM_COLORS; i++) {
+		led->subled_info[i].intensity = turris1x_read(ddata, turris1x_color_reg(reg, i));
+		led->subled_info[i].color_index = colors[i];
+		led->subled_info[i].channel = i;
+	}
+
+	/*
+	 * LEDs 1-5 (LAN) share one set of colour registers, and the brightness
+	 * of an LED is applied by scaling its colour, so all of them show the
+	 * colour and brightness written last. Each LED still keeps its own
+	 * intensities and brightness, so multi_intensity and brightness report
+	 * what the LED was last given, which is not necessarily what it shows.
+	 */
+	led->mc_cdev.subled_info = led->subled_info;
+	led->mc_cdev.num_colors = TURRIS1X_LED_NUM_COLORS;
+
+	init_data.fwnode = fwnode;
+
+	cdev = &led->mc_cdev.led_cdev;
+	cdev->max_brightness = 255;
+	cdev->brightness_set = turris1x_led_brightness_set;
+
+	/* All LEDs except the WiFi LED can be driven by the hardware trigger */
+	if (reg != TURRIS1X_LED_WIFI) {
+		cdev->trigger_type = &turris1x_hw_trigger_type;
+		cdev->hw_control_trigger = turris1x_hw_trigger.name;
+	}
+
+	if (!(val_sw_override & BIT(reg)))
+		cdev->default_trigger = turris1x_hw_trigger.name;
+
+	if (!(val_sw_override & BIT(reg)) || !(val_sw_disable & BIT(reg)))
+		cdev->brightness = cdev->max_brightness;
+
+	led->on = !(val_sw_disable & BIT(reg));
+
+	ret = devm_led_classdev_multicolor_register_ext(dev, &led->mc_cdev, &init_data);
+	if (ret)
+		return dev_err_probe(dev, ret, "Cannot register LED %u\n", reg);
+
+	/*
+	 * A linux,default-trigger property replaces the hardware trigger, and
+	 * the CPLD then keeps driving the LED and ignores software control.
+	 * Take such an LED over in the state the LED core reports.
+	 */
+	spin_lock_irqsave(&ddata->lock, flags);
+	val = turris1x_read(ddata, TURRIS1X_LED_SW_OVERRIDE_REG);
+	if (!led->hwtrig && !(val & BIT(reg))) {
+		dis = turris1x_read(ddata, TURRIS1X_LED_SW_DISABLE_REG);
+		if (cdev->brightness)
+			dis &= ~BIT(reg);
+		else
+			dis |= BIT(reg);
+		turris1x_write(ddata, TURRIS1X_LED_SW_DISABLE_REG, dis);
+		led->on = !!cdev->brightness;
+		turris1x_write(ddata, TURRIS1X_LED_SW_OVERRIDE_REG, val | BIT(reg));
+	}
+	spin_unlock_irqrestore(&ddata->lock, flags);
+
+	led->registered = true;
+
+	return 0;
+}
+
+static ssize_t brightness_show(struct device *dev, struct device_attribute *a, char *buf)
+{
+	struct turris1x_leds *ddata = dev_get_drvdata(dev);
+	u8 brightness;
+
+	/* The CPLD has the value of the level in use in a read-only register */
+	brightness = turris1x_read(ddata, TURRIS1X_LED_GLOBAL_BRIGHTNESS_REG);
+
+	return sysfs_emit(buf, "%u\n", brightness);
+}
+
+static ssize_t brightness_store(struct device *dev, struct device_attribute *a,
+				const char *buf, size_t count)
+{
+	struct turris1x_leds *ddata = dev_get_drvdata(dev);
+	int best_error, error, value;
+	unsigned int best_level, level;
+	unsigned long flags;
+	u8 brightness;
+	int ret;
+
+	ret = kstrtou8(buf, 10, &brightness);
+	if (ret)
+		return ret;
+
+	/*
+	 * The global brightness can only be one of the values of the levels.
+	 * Select the level whose value is nearest to the requested brightness.
+	 */
+	spin_lock_irqsave(&ddata->lock, flags);
+
+	best_level = 0;
+	best_error = INT_MAX;
+	for (level = 0; level < TURRIS1X_LED_NUM_LEVELS; level++) {
+		value = turris1x_read(ddata, TURRIS1X_LED_LEVEL_VALUE_REG + level);
+		error = abs(value - brightness);
+		if (error < best_error) {
+			best_error = error;
+			best_level = level;
+		}
+	}
+
+	turris1x_write(ddata, TURRIS1X_LED_GLOBAL_LEVEL_REG, best_level);
+
+	spin_unlock_irqrestore(&ddata->lock, flags);
+
+	return count;
+}
+static DEVICE_ATTR_RW(brightness);
+
+static ssize_t brightness_level_show(struct device *dev, struct device_attribute *a, char *buf)
+{
+	struct turris1x_leds *ddata = dev_get_drvdata(dev);
+	u8 level;
+
+	level = turris1x_read(ddata, TURRIS1X_LED_GLOBAL_LEVEL_REG);
+	level &= TURRIS1X_LED_GLOBAL_LEVEL_MASK;
+
+	return sysfs_emit(buf, "%u\n", level);
+}
+
+static ssize_t brightness_level_store(struct device *dev, struct device_attribute *a,
+				      const char *buf, size_t count)
+{
+	struct turris1x_leds *ddata = dev_get_drvdata(dev);
+	unsigned long flags;
+	u8 level;
+	int ret;
+
+	ret = kstrtou8(buf, 10, &level);
+	if (ret)
+		return ret;
+
+	if (level >= TURRIS1X_LED_NUM_LEVELS)
+		return -EINVAL;
+
+	spin_lock_irqsave(&ddata->lock, flags);
+	turris1x_write(ddata, TURRIS1X_LED_GLOBAL_LEVEL_REG, level);
+	spin_unlock_irqrestore(&ddata->lock, flags);
+
+	return count;
+}
+static DEVICE_ATTR_RW(brightness_level);
+
+/* One file per level under brightness_levels/, holding its value */
+struct turris1x_level_attr {
+	struct device_attribute attr;
+	u8 level;
+};
+
+#define to_turris1x_level_attr(a) \
+	container_of(a, struct turris1x_level_attr, attr)
+
+static ssize_t brightness_level_value_show(struct device *dev, struct device_attribute *a,
+					   char *buf)
+{
+	struct turris1x_leds *ddata = dev_get_drvdata(dev);
+	struct turris1x_level_attr *la = to_turris1x_level_attr(a);
+	u8 value;
+
+	value = turris1x_read(ddata, TURRIS1X_LED_LEVEL_VALUE_REG + la->level);
+
+	return sysfs_emit(buf, "%u\n", value);
+}
+
+static ssize_t brightness_level_value_store(struct device *dev, struct device_attribute *a,
+					    const char *buf, size_t count)
+{
+	struct turris1x_leds *ddata = dev_get_drvdata(dev);
+	struct turris1x_level_attr *la = to_turris1x_level_attr(a);
+	unsigned long flags;
+	u8 value;
+	int ret;
+
+	ret = kstrtou8(buf, 10, &value);
+	if (ret)
+		return ret;
+
+	spin_lock_irqsave(&ddata->lock, flags);
+	turris1x_write(ddata, TURRIS1X_LED_LEVEL_VALUE_REG + la->level, value);
+	spin_unlock_irqrestore(&ddata->lock, flags);
+
+	return count;
+}
+
+/* _level is always a literal 0..7, it is pasted, stringified and stored */
+#define TURRIS1X_LEVEL_ATTR(_level)						\
+	static struct turris1x_level_attr turris1x_level_attr_##_level = {	\
+		.attr = __ATTR(_level, 0644, brightness_level_value_show,	\
+			       brightness_level_value_store),			\
+		.level = _level,						\
+	}
+
+TURRIS1X_LEVEL_ATTR(0);
+TURRIS1X_LEVEL_ATTR(1);
+TURRIS1X_LEVEL_ATTR(2);
+TURRIS1X_LEVEL_ATTR(3);
+TURRIS1X_LEVEL_ATTR(4);
+TURRIS1X_LEVEL_ATTR(5);
+TURRIS1X_LEVEL_ATTR(6);
+TURRIS1X_LEVEL_ATTR(7);
+
+static struct attribute *turris1x_leds_levels_attrs[] = {
+	&turris1x_level_attr_0.attr.attr,
+	&turris1x_level_attr_1.attr.attr,
+	&turris1x_level_attr_2.attr.attr,
+	&turris1x_level_attr_3.attr.attr,
+	&turris1x_level_attr_4.attr.attr,
+	&turris1x_level_attr_5.attr.attr,
+	&turris1x_level_attr_6.attr.attr,
+	&turris1x_level_attr_7.attr.attr,
+	NULL
+};
+
+static const struct attribute_group turris1x_leds_levels_group = {
+	.name = "brightness_levels",
+	.attrs = turris1x_leds_levels_attrs,
+};
+
+static struct attribute *turris1x_leds_controller_attrs[] = {
+	&dev_attr_brightness.attr,
+	&dev_attr_brightness_level.attr,
+	NULL
+};
+
+static const struct attribute_group turris1x_leds_controller_group = {
+	.attrs = turris1x_leds_controller_attrs,
+};
+
+static const struct attribute_group *turris1x_leds_controller_groups[] = {
+	&turris1x_leds_controller_group,
+	&turris1x_leds_levels_group,
+	NULL
+};
+
+static void turris1x_leds_reset(void *data)
+{
+	struct turris1x_leds *ddata = data;
+	unsigned int reg, end;
+	unsigned long flags;
+	u8 val;
+
+	spin_lock_irqsave(&ddata->lock, flags);
+
+	ddata->reset = true;
+
+	/*
+	 * The LED registers persist across board resets and driver unbind, so
+	 * put the LED controller back into its default control state before
+	 * the kernel reboots and when the driver goes away.
+	 */
+
+	/* Disable software control of all LEDs except the WiFi LED */
+	turris1x_write(ddata, TURRIS1X_LED_SW_OVERRIDE_REG, BIT(TURRIS1X_LED_WIFI));
+
+	/* Turn off the WiFi LED, as there is no hardware trigger for it */
+	val = turris1x_read(ddata, TURRIS1X_LED_SW_DISABLE_REG);
+	turris1x_write(ddata, TURRIS1X_LED_SW_DISABLE_REG, val | BIT(TURRIS1X_LED_WIFI));
+
+	/* Reset the colours of all LEDs to full intensity */
+	end = TURRIS1X_LED_COLOR_REG + TURRIS1X_LED_NUM_COLOR_BLOCKS * TURRIS1X_LED_NUM_COLORS;
+	for (reg = TURRIS1X_LED_COLOR_REG; reg < end; reg++)
+		turris1x_write(ddata, reg, U8_MAX);
+
+	spin_unlock_irqrestore(&ddata->lock, flags);
+}
+
+static int turris1x_leds_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct turris1x_leds *ddata;
+	u8 val_sw_override, val_sw_disable;
+	unsigned int count = 0;
+	unsigned long flags;
+	int ret;
+
+	ddata = devm_kzalloc(dev, sizeof(*ddata), GFP_KERNEL);
+	if (!ddata)
+		return -ENOMEM;
+
+	ddata->regs = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(ddata->regs))
+		return PTR_ERR(ddata->regs);
+
+	spin_lock_init(&ddata->lock);
+	platform_set_drvdata(pdev, ddata);
+
+	ret = devm_led_trigger_register(dev, &turris1x_hw_trigger);
+	if (ret)
+		return dev_err_probe(dev, ret, "Cannot register private LED trigger\n");
+
+	ret = devm_add_action_or_reset(dev, turris1x_leds_reset, ddata);
+	if (ret)
+		return ret;
+
+	spin_lock_irqsave(&ddata->lock, flags);
+
+	val_sw_override = turris1x_read(ddata, TURRIS1X_LED_SW_OVERRIDE_REG);
+	val_sw_disable = turris1x_read(ddata, TURRIS1X_LED_SW_DISABLE_REG);
+
+	/*
+	 * The WiFi LED has no hardware trigger, put it under software control
+	 * and turn it off.
+	 */
+	if (!(val_sw_override & BIT(TURRIS1X_LED_WIFI))) {
+		val_sw_disable |= BIT(TURRIS1X_LED_WIFI);
+		val_sw_override |= BIT(TURRIS1X_LED_WIFI);
+		turris1x_write(ddata, TURRIS1X_LED_SW_DISABLE_REG, val_sw_disable);
+		turris1x_write(ddata, TURRIS1X_LED_SW_OVERRIDE_REG, val_sw_override);
+	}
+
+	spin_unlock_irqrestore(&ddata->lock, flags);
+
+	device_for_each_child_node_scoped(dev, child) {
+		ret = turris1x_led_register(dev, ddata, child, val_sw_override, val_sw_disable);
+		if (ret)
+			return ret;
+		count++;
+	}
+
+	if (!count)
+		return dev_err_probe(dev, -ENODEV, "No LED devices found in device tree\n");
+
+	return 0;
+}
+
+static void turris1x_leds_shutdown(struct platform_device *pdev)
+{
+	turris1x_leds_reset(platform_get_drvdata(pdev));
+}
+
+static const struct of_device_id of_turris1x_leds_match[] = {
+	{ .compatible = "cznic,turris1x-leds" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, of_turris1x_leds_match);
+
+static struct platform_driver turris1x_leds_driver = {
+	.probe = turris1x_leds_probe,
+	.shutdown = turris1x_leds_shutdown,
+	.driver = {
+		.name = "turris1x_leds",
+		.of_match_table = of_turris1x_leds_match,
+		.dev_groups = turris1x_leds_controller_groups,
+	},
+};
+module_platform_driver(turris1x_leds_driver);
+
+MODULE_AUTHOR("Pali Rohár <pali@kernel.org>");
+MODULE_DESCRIPTION("CZ.NIC's Turris 1.x LEDs");
+MODULE_LICENSE("GPL");
-- 
2.54.0 (Apple Git-157)

