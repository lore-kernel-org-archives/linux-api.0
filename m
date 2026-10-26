Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793044290;
	b=3y1pn5T0eR5ahdv+EyIlAXUopEOLtsNtz9sMB6x9VSdr65aqQa2kkG8NQ0hx5rYJ4Dru
	 PViF6EpkROGVo5YnEMJA0VMtwZHtIvUKIMqXgEhsC8z/9pjEm56slpvk1vd+2SmLwtmci
	 QssD6evkd7c3QeugMuM0lDjx7DZF/Xs7KVK3E8bEP/bGAHR3EpzSgJZ8vPzSSB1Jr7r8x
	 Hpmht68cQ22lxgHa647Hfi6LmqTurE4Pl0bR6fYDHZS0z/pPsV5RRfAq8vuhW0KsYsFNT
	 bdV0JHxZyV/gzYXoqilkpSXQs4AC1xXe9PI6koNBYlxDPcA5+094JX2kzAy/cFKrSXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793044290;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DnpEfAnHLyjZMADI1t3fu+4d+XOhledfLpjhiEBItFQ=;
	b=y/dskeHv9OIb6j0c+NMhv2fJru6vuH8ktfP5ICZW2wQznTWbw3PizZ6s2SnmCIX+3Q6c
	 slB1mdCIdeh7FW7t1ALYxLC2QBDxum2t9fP73CFxUxKXRFxL0V4s5k1Seai1ftr62pviJ
	 mhQJ1bAINBqQEKfxKAiZPe7sKTZVyN8daHdKAkXQ0Tj191NIerXcHTX2nCytSxNw78wUV
	 T1F9kdDuAoq1EGjSLobDhvkYZoX5E9RQONnrWwlGghO4p7VLShhKiezXRQjpv4Zs6hoUn
	 9flOnO1cDiMubbzmtkij0WpD3ffGbTPGQaEjhPNEAyTy4hy0QNJtUuJrOHI4fKg/PBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=dj0dz7ej;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46976606A320
	for <linux-api@vger.kernel.org>; Mon, 26 Oct 2026 19:51:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46976606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=dj0dz7ej
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48c4d99c32bso2381831f8f.1
        for <linux-api@vger.kernel.org>; Mon, 26 Oct 2026 12:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793044288; x=1793649088; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DnpEfAnHLyjZMADI1t3fu+4d+XOhledfLpjhiEBItFQ=;
        b=dj0dz7ejlSWpUsGKbu1M+CLz4JWXLQHylT7etTPO09+ssGGXFVyOHz3zE6QM5Lj+VF
         XwyioFpobd1QT6W1uPzm4smaWTAVHH0iDxbnfHs5Tc8PORNLYG9StnGCEy0H4tDcgzmi
         Cz7UpRJg3GJhh3BAyYNCX6CdNYNTHCnEFzK87/XitQuiGsLJNPHPfSlQ5MkRbOzrf+0h
         4QpoDL7ryxEOyh3GF5MZoCCGpq50gCjbpB/98eV9OzKJ9yH3gn9TxqSqFLMIVwcUvHEE
         Vmxz1NUM7tHOPGK1MXHjajh7ND4pIP7ZKeMe/aMyk76NTev3oygiLTfWHtCTFmkWW1Lo
         igQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793044288; x=1793649088;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DnpEfAnHLyjZMADI1t3fu+4d+XOhledfLpjhiEBItFQ=;
        b=GkzhBgigHuVnrfe0v2h5bOpnNoPSTt04fU5zjTj7UnGzjCh3AqQWL+F/l0fRUMDjZD
         6BpMC+QwFY7m0+eezWb/+2RBB7MebWj9xmSVSrhzxlyV4fp8Vh9Mp2gY2WuELleXqXLP
         eLQ9+PJpRi7gvLFbW+kpQ5N72RAUDnExXI1jmPGuGkwkM6C9u8io5eD664BtqpugacX0
         9dpcXZulBwJGSY3qHU7ZE7XfFLySKchTYL53b3zjxprcRYYpp8lFh0T5YZ/8Njc9NPCm
         mt4JDrlyvwMzS/fscuNtzMOH9b/OQf8g2bgeqybL3NEsrMPMBxh5+vVBWElSYunI3gsP
         2yYQ==
X-Forwarded-Encrypted: i=1; AKwUvByh5bU1EjxfMmcUE7H69VHTFwGZXAV2KkSXgyc1VV41jT7y3GvjuOtYLoBIylBRVoerD8YjdiIZA+c=@vger.kernel.org
X-Gm-Message-State: AFq9FYJqmE435/3pnTg2eTj2PBvg04rIBB9ADTtcFn87MhPV7kahJwqU
	8XAL4y0idjyIIMZCvspXM7u1sxnLW/qa6nc5UP1r5HEdE4vA4j6WVdsI
X-Gm-Gg: AYBFou14bj5yuo+uVH/dqpWlKUb+MgqRquypVMVKu3u5VyoR/zZ8weKIgs6PqaPd4Sg
	lmRPwPi9RxO8hbfVOe4xKmThCYHqmJ47j3/3PpOw8+Pf7rD6GZy0QKWn1JP9rW3QdiSrPTtF5r/
	2qFjFUf2n2r/OuEw/Wrs9qcCtzNdFkx2Vje+l/tG+hDsz078laz6rOP7UbVJSdYDrCuWHb+KZ9Y
	mLvmVAhZTh6dOydUOFVjuPXvb1Gmb8yjsB+OtybJ+qNMLwJB8xvrH7nx6IDDkIcCWdP77KmTktv
	INYUAoXgCVtVj0VmAzXUytwmDT7l+7ES61ZUHChpAlaviE3m/shS8/Z9HQXfrJiuUmPANqjF7Fk
	v72hAyr9H1uMOXHAOIkeV3S9Z+VPtrn4Qj/oJnHn2vKpbbb+YFTJpfyxvpiRycGeLytkFK0SCof
	aKEID4GaU4g9KKzvDfmKg114/BSm9xcsucQkRg+43W6dnlUNThQPIbzo7ATHgOZA/T8/17P1ZBv
	OeEBCUvB3+pABrd4pZTDL1r1JO9enHK5zIHhLYxunEER8sRRCYjJlC6ywjumJZJj9mC5/c/V2Yk
	UpIek6k2XOK9Tvqir1L+6otfbK0QPateZbFdHrefZDjuTwiqXf3Vrd4ugeOgJruHfA/JNPuFRFl
	NBVtBC5ui0gmhw1jmnnZ4fEAfGdfLdMKgYY8a9cPTWwcwJUDWBHf7YRA3O/5upHglvjBH0nwBRa
	dZIgEd
X-Received: by 2002:a05:6000:200f:b0:48e:f8d:8cab with SMTP id ffacd0b85a97d-48e3eb455bdmr15156265f8f.4.1793044287488;
        Mon, 26 Oct 2026 12:51:27 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a00-1028-8388-a84e-8ce1-bbf6-5949-b0f3.ipv6.o2.cz. [2a00:1028:8388:a84e:8ce1:bbf6:5949:b0f3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebc3c5bsm18877654f8f.9.2026.10.26.12.51.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 26 Oct 2026 12:51:26 -0700 (PDT)
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
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	linux-leds@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] leds: turris-1x: Add support for CZ.NIC Turris 1.x LEDs
Date: Mon, 26 Oct 2026 20:51:20 +0100
Message-ID: <20261026195120.12759-3-pepe.schlehofer@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026195120.12759-1-pepe.schlehofer@gmail.com>
References: <20261026195120.12759-1-pepe.schlehofer@gmail.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

Add a driver for the eight RGB LEDs on the front panel of the CZ.NIC
Turris 1.x routers. They are driven by the CZ.NIC CPLD firmware, whose
source is available at
https://gitlab.nic.cz/turris/hw/turris_cpld/-/blob/master/CZ_NIC_Router_CPLD.v

The WAN, WiFi and power LEDs use the multicolor LED class. The five LAN
LEDs share one set of colour registers, and the CPLD can only switch
each of them on and off. The LAN 1 LED is therefore the only multicolor
LAN LED, and its colour is the colour of all five. The other four LAN
LEDs are plain LEDs, and all five have max_brightness 1. Every LED
except the WiFi LED can also be driven by the CPLD from hardware events,
exposed as the private turris1x-cpld trigger.

The controller device exposes the global brightness controlled by the
button on the back of the router through `brightness`,
`brightness_level`, and `brightness_levels/<N>`. `brightness` is named
after the Turris Omnia attribute, but it holds the 0-255 value of the
selected CPLD level rather than a percentage.

Signed-off-by: Pali Rohár <pali@kernel.org>
Co-developed-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
---

Notes:
    Changes in v4, by Josef Schlehofer:
    - rgb:lan-1 is the only multicolor LAN LED, the other four are plain
      LEDs, all five with max_brightness 1 (Marek). No symlinks, see the
      cover letter.
    - the LAN colour keeps its full range (max_intensity 255) and is
      written also while rgb:lan-1 is off, as the other LAN LEDs show it
    - brightness moved from the Omnia ABI file to the Turris 1.x one, with
      Date, KernelVersion and wording updated (Andy)
    - cleanups from Andy's review: guard(), lockdep_assert_held(), min(),
      an __assign_bit() helper, u8 reg, proper error codes, loop counters
      in for(), the child nodes counted before touching the CPLD
    - kept __ATTR() for brightness_levels/<N>, __ATTR_RW() cannot build
      handler names from a digit (Andy)
    - no mod_devicetable.h, { } as the OF table terminator (Andy, Uwe)
    - comment on why shutdown hands the LEDs back to the CPLD (Uwe). The
      v3 reason for it was wrong.
    - Cc: lines out of the commit message, driver name in the subject,
      rebased onto leds/for-leds-next 59cf91cf87ab
    
    v3: https://lore.kernel.org/r/20260928111907.72592-3-pepe.schlehofer@gmail.com/
    
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

 .../testing/sysfs-class-led-driver-turris1x   |  58 ++
 MAINTAINERS                                   |   9 +
 drivers/leds/Kconfig                          |  13 +
 drivers/leds/Makefile                         |   1 +
 drivers/leds/leds-turris-1x.c                 | 624 ++++++++++++++++++
 5 files changed, 705 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-led-driver-turris1x
 create mode 100644 drivers/leds/leds-turris-1x.c

diff --git a/Documentation/ABI/testing/sysfs-class-led-driver-turris1x b/Documentation/ABI/testing/sysfs-class-led-driver-turris1x
new file mode 100644
index 000000000000..859e96ba5ee4
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-led-driver-turris1x
@@ -0,0 +1,58 @@
+What:		/sys/class/leds/<turris1x_led>/device/brightness
+Date:		February 2027
+KernelVersion:	7.5
+Contact:	Josef Schlehofer <pepe.schlehofer@gmail.com>
+Description:	(RW) Global brightness of the LEDs on the front panel of the
+		Turris 1.x routers. The button on the back side of the router
+		steps through 8 brightness levels, whose values are in
+		brightness_levels/<N>. Reading this file returns the value
+		(0-255) of the level in use. Writing an integer between 0 and
+		255 selects the level whose value is closest to it. If two
+		levels are equally close, the lower level index is selected.
+
+		Format: %u
+
+What:		/sys/class/leds/<turris1x_led>/device/brightness_level
+Date:		February 2027
+KernelVersion:	7.5
+Contact:	Josef Schlehofer <pepe.schlehofer@gmail.com>
+Description:	(RW) Index (0-7) of the global brightness level in use on
+		the Turris 1.x routers. The button on the back side of the
+		router steps through the levels. Writing to this file selects
+		a level directly. The CPLD keeps the selection when the driver
+		is unbound and across reboots.
+
+		Format: %u
+
+What:		/sys/class/leds/<turris1x_led>/device/brightness_levels/<N>
+Date:		February 2027
+KernelVersion:	7.5
+Contact:	Josef Schlehofer <pepe.schlehofer@gmail.com>
+Description:	(RW) Value of the global brightness level N (0-7) on the
+		Turris 1.x routers, one file per level. These are the values
+		the CPLD firmware steps through when the brightness button is
+		pressed. Reading returns the value, writing accepts an integer
+		between 0 and 255. The CPLD keeps the values when the driver is
+		unbound and across reboots, and restores the defaults (255 64 32
+		16 8 4 2 0) at power-on and when the reset button is pressed.
+
+		Format: %u
+
+What:		/sys/class/leds/rgb:lan-1/multi_intensity
+Date:		February 2027
+KernelVersion:	7.5
+Contact:	Josef Schlehofer <pepe.schlehofer@gmail.com>
+Description:	(RW) Colour of all five LAN LEDs on the Turris 1.x routers.
+		The LAN LEDs share one set of colour registers in the CPLD, and
+		the CPLD can only switch each of them on and off. rgb:lan-1 is
+		therefore the only multicolor LAN LED, and writing its
+		multi_intensity changes the colour of all five LAN LEDs, also
+		while rgb:lan-1 itself is off. While a software trigger blinks
+		rgb:lan-1, the new colour is written at the next brightness
+		change of rgb:lan-1. rgb:lan-2 to rgb:lan-5 are plain LEDs
+		without a colour of their own. All five LAN LEDs have
+		max_brightness 1, and the brightness of each of them only turns
+		that LED on or off.
+
+		For the format, see
+		Documentation/ABI/testing/sysfs-class-led-multicolor.
diff --git a/MAINTAINERS b/MAINTAINERS
index bccc0146f415..1a2b9d98a90f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7163,6 +7163,15 @@ L:	linux-input@vger.kernel.org
 S:	Maintained
 F:	drivers/input/touchscreen/cyttsp*
 
+CZ.NIC TURRIS 1.X LED DRIVER
+M:	Josef Schlehofer <pepe.schlehofer@gmail.com>
+L:	linux-leds@vger.kernel.org
+S:	Maintained
+W:	https://www.turris.cz/
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
index 000000000000..e74490e6454b
--- /dev/null
+++ b/drivers/leds/leds-turris-1x.c
@@ -0,0 +1,624 @@
+// SPDX-License-Identifier: GPL-2.0
+// (C) 2022 Pali Rohár <pali@kernel.org>
+//
+// CZ.NIC's Turris 1.x LEDs driver, controlled by CPLD firmware:
+// https://gitlab.nic.cz/turris/hw/turris_cpld/-/blob/master/CZ_NIC_Router_CPLD.v
+
+#include <linux/bitops.h>
+#include <linux/bits.h>
+#include <linux/cleanup.h>
+#include <linux/container_of.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/kstrtox.h>
+#include <linux/led-class-multicolor.h>
+#include <linux/leds.h>
+#include <linux/limits.h>
+#include <linux/lockdep.h>
+#include <linux/math.h>
+#include <linux/minmax.h>
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
+/* LEDs 1-5 are LAN 5 to LAN 1, as described in the binding */
+#define TURRIS1X_LED_LAN5			1
+#define TURRIS1X_LED_LAN1			5
+#define TURRIS1X_LED_WIFI			6
+
+struct turris1x_led {
+	struct led_classdev_mc mc_cdev;
+	struct mc_subled subled_info[TURRIS1X_LED_NUM_COLORS];
+	u8 reg;
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
+	/*
+	 * Set by turris1x_leds_reset(). LED triggers keep running after
+	 * .shutdown(), so once this is set the callbacks leave the LED
+	 * registers alone.
+	 */
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
+/* Set or clear one bit of a CPLD register */
+static void turris1x_assign_bit(struct turris1x_leds *ddata, unsigned int reg,
+				unsigned int bit, bool value)
+{
+	unsigned long val;
+
+	lockdep_assert_held(&ddata->lock);
+
+	val = turris1x_read(ddata, reg);
+	__assign_bit(bit, &val, value);
+	turris1x_write(ddata, reg, val);
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
+static bool turris1x_led_is_lan(u32 led)
+{
+	return led >= TURRIS1X_LED_LAN5 && led <= TURRIS1X_LED_LAN1;
+}
+
+/* LAN 2-5 have no colour of their own, they show the colour of LAN 1 */
+static bool turris1x_led_has_color(u32 led)
+{
+	return !turris1x_led_is_lan(led) || led == TURRIS1X_LED_LAN1;
+}
+
+static void turris1x_led_set_colors(struct turris1x_leds *ddata, struct turris1x_led *led,
+				    enum led_brightness brightness)
+{
+	struct led_classdev_mc *mc_cdev = &led->mc_cdev;
+
+	lockdep_assert_held(&ddata->lock);
+
+	led_mc_calc_color_components(mc_cdev, brightness);
+
+	/* The colour registers are 8 bits wide, do not let values wrap */
+	for (unsigned int i = 0; i < TURRIS1X_LED_NUM_COLORS; i++) {
+		u8 val = min(mc_cdev->subled_info[i].brightness, U8_MAX);
+
+		turris1x_write(ddata, turris1x_color_reg(led->reg, i), val);
+	}
+}
+
+static int turris1x_hwtrig_activate(struct led_classdev *cdev)
+{
+	struct turris1x_leds *ddata = dev_get_drvdata(cdev->dev->parent);
+	struct turris1x_led *led = to_turris1x_led(cdev);
+
+	guard(spinlock_irqsave)(&ddata->lock);
+
+	if (ddata->reset)
+		return 0;
+
+	/*
+	 * If software turned the LED off, the last configured colour was not
+	 * necessarily written to the CPLD. Write it with max_brightness before
+	 * the hardware takes over. LAN 1 writes its colour on every brightness
+	 * change, and LAN 2-5 have no colour of their own.
+	 */
+	if (!turris1x_led_is_lan(led->reg) && !led->on)
+		turris1x_led_set_colors(ddata, led, cdev->max_brightness);
+
+	/* Disable LED software control */
+	turris1x_assign_bit(ddata, TURRIS1X_LED_SW_OVERRIDE_REG, led->reg, false);
+
+	led->hwtrig = true;
+
+	return 0;
+}
+
+static void turris1x_hwtrig_deactivate(struct led_classdev *cdev)
+{
+	struct turris1x_leds *ddata = dev_get_drvdata(cdev->dev->parent);
+	struct turris1x_led *led = to_turris1x_led(cdev);
+
+	guard(spinlock_irqsave)(&ddata->lock);
+
+	if (ddata->reset)
+		return;
+
+	led->hwtrig = false;
+
+	/*
+	 * Turn the LED off before software control takes over, as the LED core
+	 * does right after anyway.
+	 */
+	turris1x_assign_bit(ddata, TURRIS1X_LED_SW_DISABLE_REG, led->reg, true);
+	led->on = false;
+
+	/* Enable LED software control */
+	turris1x_assign_bit(ddata, TURRIS1X_LED_SW_OVERRIDE_REG, led->reg, true);
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
+
+	guard(spinlock_irqsave)(&ddata->lock);
+
+	/* Software triggers run until the reboot, do not undo the reset */
+	if (ddata->reset)
+		return;
+
+	/*
+	 * Write the colours when the LED is on, and also when the hardware
+	 * trigger drives it, as the trigger uses the same registers. LAN 1
+	 * always writes its full intensities, also when it is off, as LAN 2-5
+	 * show its colour.
+	 */
+	if (led->reg == TURRIS1X_LED_LAN1)
+		turris1x_led_set_colors(ddata, led, cdev->max_brightness);
+	else if (turris1x_led_has_color(led->reg) && (brightness || led->hwtrig))
+		turris1x_led_set_colors(ddata, led, brightness ?: cdev->max_brightness);
+
+	/*
+	 * Enable or disable the LED under software control. The CPLD ignores
+	 * this bit while the hardware trigger drives the LED, so leave it
+	 * alone.
+	 */
+	if (!led->hwtrig) {
+		turris1x_assign_bit(ddata, TURRIS1X_LED_SW_DISABLE_REG, led->reg, !brightness);
+		led->on = !!brightness;
+	}
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
+	u32 reg, color;
+	int ret;
+	u8 val;
+
+	ret = fwnode_property_read_u32(fwnode, "reg", &reg);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to read 'reg'\n");
+	if (reg >= TURRIS1X_LED_NUM)
+		return dev_err_probe(dev, -EINVAL, "Invalid 'reg' %u\n", reg);
+
+	ret = fwnode_property_read_u32(fwnode, "color", &color);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to read 'color'\n");
+	if (color != LED_COLOR_ID_RGB)
+		return dev_err_probe(dev, -EINVAL, "Invalid 'color' %u\n", color);
+
+	led = &ddata->led[reg];
+	if (led->registered)
+		return dev_err_probe(dev, -EEXIST, "LED %u already registered\n", reg);
+
+	led->reg = reg;
+
+	init_data.fwnode = fwnode;
+
+	cdev = &led->mc_cdev.led_cdev;
+	cdev->brightness_set = turris1x_led_brightness_set;
+
+	/*
+	 * LEDs 1-5 (LAN) share one set of colour registers, and the CPLD can
+	 * only switch each of them on and off. LAN 1 is a multicolor LED whose
+	 * colour is the colour of all five, LAN 2-5 are plain LEDs, and all
+	 * five have max_brightness 1. The other LEDs have colour registers of
+	 * their own and scale their colour by the brightness.
+	 */
+	cdev->max_brightness = turris1x_led_is_lan(reg) ? 1 : 255;
+
+	if (turris1x_led_has_color(reg)) {
+		/* Set the initial colours to those currently in use */
+		for (unsigned int i = 0; i < TURRIS1X_LED_NUM_COLORS; i++) {
+			led->subled_info[i].intensity =
+				turris1x_read(ddata, turris1x_color_reg(reg, i));
+			/*
+			 * LAN 1 does not scale its colour, so its intensities
+			 * are not limited by max_brightness but by the 8-bit
+			 * colour registers.
+			 */
+			if (reg == TURRIS1X_LED_LAN1)
+				led->subled_info[i].max_intensity = U8_MAX;
+			led->subled_info[i].color_index = colors[i];
+			led->subled_info[i].channel = i;
+		}
+
+		led->mc_cdev.subled_info = led->subled_info;
+		led->mc_cdev.num_colors = TURRIS1X_LED_NUM_COLORS;
+	}
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
+	if (turris1x_led_has_color(reg))
+		ret = devm_led_classdev_multicolor_register_ext(dev, &led->mc_cdev, &init_data);
+	else
+		ret = devm_led_classdev_register_ext(dev, cdev, &init_data);
+	if (ret)
+		return dev_err_probe(dev, ret, "Cannot register LED %u\n", reg);
+
+	/*
+	 * A linux,default-trigger property replaces the hardware trigger, and
+	 * the CPLD then keeps driving the LED and ignores software control.
+	 * Take such an LED over in the state the LED core reports.
+	 */
+	scoped_guard(spinlock_irqsave, &ddata->lock) {
+		val = turris1x_read(ddata, TURRIS1X_LED_SW_OVERRIDE_REG);
+		if (!led->hwtrig && !(val & BIT(reg))) {
+			turris1x_assign_bit(ddata, TURRIS1X_LED_SW_DISABLE_REG, reg,
+					    !cdev->brightness);
+			led->on = !!cdev->brightness;
+			turris1x_assign_bit(ddata, TURRIS1X_LED_SW_OVERRIDE_REG, reg, true);
+		}
+	}
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
+	unsigned int best_level;
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
+	guard(spinlock_irqsave)(&ddata->lock);
+
+	best_level = 0;
+	best_error = INT_MAX;
+	for (unsigned int level = 0; level < TURRIS1X_LED_NUM_LEVELS; level++) {
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
+	guard(spinlock_irqsave)(&ddata->lock);
+
+	turris1x_write(ddata, TURRIS1X_LED_GLOBAL_LEVEL_REG, level);
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
+	u8 value;
+	int ret;
+
+	ret = kstrtou8(buf, 10, &value);
+	if (ret)
+		return ret;
+
+	guard(spinlock_irqsave)(&ddata->lock);
+
+	turris1x_write(ddata, TURRIS1X_LED_LEVEL_VALUE_REG + la->level, value);
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
+/*
+ * Give the LEDs back to the CPLD with full colours, as after power-on, but
+ * keep the WiFi LED under software control and off. Called when the driver
+ * goes away and at shutdown.
+ */
+static void turris1x_leds_reset(void *data)
+{
+	struct turris1x_leds *ddata = data;
+
+	guard(spinlock_irqsave)(&ddata->lock);
+
+	ddata->reset = true;
+
+	/* Disable software control of all LEDs except the WiFi LED */
+	turris1x_write(ddata, TURRIS1X_LED_SW_OVERRIDE_REG, BIT(TURRIS1X_LED_WIFI));
+
+	/* Turn off the WiFi LED, as there is no hardware trigger for it */
+	turris1x_assign_bit(ddata, TURRIS1X_LED_SW_DISABLE_REG, TURRIS1X_LED_WIFI, true);
+
+	/* Reset the colours of all LEDs to full intensity */
+	for (unsigned int i = 0; i < TURRIS1X_LED_NUM_COLOR_BLOCKS * TURRIS1X_LED_NUM_COLORS; i++)
+		turris1x_write(ddata, TURRIS1X_LED_COLOR_REG + i, U8_MAX);
+}
+
+static int turris1x_leds_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct turris1x_leds *ddata;
+	u8 val_sw_override, val_sw_disable;
+	int ret;
+
+	if (!device_get_child_node_count(dev))
+		return dev_err_probe(dev, -ENODEV, "No LED devices found in device tree\n");
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
+	scoped_guard(spinlock_irqsave, &ddata->lock) {
+		val_sw_override = turris1x_read(ddata, TURRIS1X_LED_SW_OVERRIDE_REG);
+		val_sw_disable = turris1x_read(ddata, TURRIS1X_LED_SW_DISABLE_REG);
+
+		/*
+		 * The WiFi LED has no hardware trigger, put it under software
+		 * control and turn it off.
+		 */
+		if (!(val_sw_override & BIT(TURRIS1X_LED_WIFI))) {
+			val_sw_disable |= BIT(TURRIS1X_LED_WIFI);
+			val_sw_override |= BIT(TURRIS1X_LED_WIFI);
+			turris1x_write(ddata, TURRIS1X_LED_SW_DISABLE_REG, val_sw_disable);
+			turris1x_write(ddata, TURRIS1X_LED_SW_OVERRIDE_REG, val_sw_override);
+		}
+	}
+
+	device_for_each_child_node_scoped(dev, child) {
+		ret = turris1x_led_register(dev, ddata, child, val_sw_override, val_sw_disable);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * A reboot resets the CPU, but the CPLD keeps the LED registers until
+ * power-on or the reset button. Give the LEDs back to the CPLD, so that the
+ * bootloader and the next kernel, also one started by kexec, do not get them
+ * as this kernel left them.
+ */
+static void turris1x_leds_shutdown(struct platform_device *pdev)
+{
+	turris1x_leds_reset(platform_get_drvdata(pdev));
+}
+
+static const struct of_device_id of_turris1x_leds_match[] = {
+	{ .compatible = "cznic,turris1x-leds" },
+	{ }
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

