Received: from mail-oo2-f42.google.com (mail-oo2-f42.google.com [74.125.231.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5188A3ACA58
	for <linux-api@vger.kernel.org>; Thu, 10 Sep 2026 03:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789010506; cv=none; b=fEvDqF7vpnDYqbwliLl4KEzi16xhnrwpwyr07wtz7ITRxgaH1XVPZ2oWMZXs1czcUJAxDZLoIWU+QDB295oeBnXAQVDnESlRN/mPT3I8YtuLmG+ElGg6867O6d9Nol+ZL9I8iIAu9YzhH+vtsq5KTkjZbkbtuoM9bdMHjj2QhNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789010506; c=relaxed/simple;
	bh=Wk25pDrWZZ8xckY9K4N8F+kJpb59de13eoDp0NRWCAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tofZqx2WBY8JGWcqz2dsftFvhW3FL2qPkWQ2WeZiX28KORnlzOKcXfYJvnRjj8qpR1d4/PLBHUzVM4JPI0lwTAvCrtcmi+UxI01ROFHzWcCjmy90UvmKYuaqE7FydeJT3FlfOAyrESOsf8aOYtj5TpDRgwSLOPE9yIyQ1vsGWs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pxKo/Sog; arc=none smtp.client-ip=74.125.231.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pxKo/Sog"
Received: by mail-oo2-f42.google.com with SMTP id 46e09a7af769-801d2f7a00eso164375a34.0
        for <linux-api@vger.kernel.org>; Wed, 09 Sep 2026 20:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789010502; x=1789615302; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hOmOC07Rob7vDzQ8fVisbebB3r+JqdG7WBbz/t4NVWc=;
        b=pxKo/Sogex9TpyjqSnsfL5A5474RrtiEHwkLJeCRsF9tISQmRc2LyUcCweDXEPz+4Z
         5fAh3q+0fKTurut7X6Iuarxluyg8OohC7+coPXSUa9gG7hrFsVq0dGte91eIZeQipTGo
         cCwmyr59vCOMuAYSTXdaEW3LzIcg9/66daytA8pscL/fG1RPj2nEYLRK7LJ6X8wjt1mN
         OCn0E01fMnXkWMWv+HBk2I3kj/SU6/WXTWPqy/XoDQa/AowARouNPjyOYwmgXe6f5zvd
         xL8LNlTII0PrJmGLFeKAc0LjhVdrMamLBH0l6sv2MsPw9FjIgDGbXvWt56kXnHf8vYRi
         si7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789010502; x=1789615302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hOmOC07Rob7vDzQ8fVisbebB3r+JqdG7WBbz/t4NVWc=;
        b=H9XF6dGvCCmXxX7kHxUdtQpJRNh9fx0ivXuoORphGdbuPnj25zMTkZQ/lCPrw6Gx35
         zj7Ba6tM9+XGeyXl7ymahWu2XfiFhTN0yN13RB7izCMG1PpbQdlELbRCsZzQAHZZekL2
         QSpu/bxxQjRufK24tBteKmkiACi/UqtBbgtZR9DZLyIge2f0A9r9we2gsaDfLN4rlFLr
         eloSF7Q92EXA9Ebhls808/uJPShTCGB7uJZRWAXn9/ue9CyEvNuGcbzMiucE+XMlCfgo
         hN4Qvtwan4i0uOF+iewUoxnNGMlEvRdCVKsRuOu/NoRhM8gG62A+RGJZ/PfoPGQypo3h
         Mtew==
X-Forwarded-Encrypted: i=1; AKwUvBzOeaVrp9J3sUNSGT0z9seMNst7kPShuBtqO7zbMIBUoMnYd60/3S7dqIAh9UTsnoXGDM05uhMS1Tw=@vger.kernel.org
X-Gm-Message-State: AFuF++nzqhmxTLMZy5CIFP5zFrShmshG+9I/lrda0Axkv/n5BrrplAmD
	MqSZJBZaWwx7piZU5eBw1F5eF6Mpuv1QBMA0YWGYc+WENMsy7jF18pI7
X-Gm-Gg: AYBFou2WndpRA5KA89k4ILshhqANZS6+vVQQneQedfBTyeQpG1lzJ6lQEr2mkdR0JRr
	5jvf3wXnrlY43QAyLiQ/gadxZkhVXvt/JhvIu2PI7ux4vZligXa4wwgtOweLiy/3PetmnmanSVZ
	E/y8U/Kg7zzv/+l3KuoxCmybcWpqOcmugWOzXvWgJ6ikFsXPbryqcTySYUoGIVD0yXANlsZhDAX
	amYRp64iFarFYHXTrhmVNEP9BNSvfUVSqw8Db27Q/RGVcBqzvpzfYcNkB7lnRFpbYcCZvoG7Mji
	n0TE6h28SEhXDYSuCfUJdMzw8FMC5tu5xWJ6QncOT5lyCiB4OMZ9eMINxZXfQz/POclY2NPaGSA
	jigeqaw5S5lA1ZGrYLQkwwDE9heaYKcFvx9yimJ4IOCzNBNsUoZfnKd8WDO7dVoqhSs9D4nw56M
	O2F6cRH8KPrL576KKVPTgdhqWEreVm6QS7DX3FVpJfX/emdR5ioe7hI6bufvgIAqYop+oF5CMgD
	gXJZI9M0gei4zQ60rnz8zj5HlDMpGrLsaQc4bhSTuyY2e0UrxSHJ7Y=
X-Received: by 2002:a05:6830:82aa:b0:7e9:e1ca:5316 with SMTP id 46e09a7af769-7fb76b4310dmr15524364a34.0.1789010502075;
        Wed, 09 Sep 2026 20:21:42 -0700 (PDT)
Received: from localhost ([76.187.192.44])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f9f6da9a49sm19758315a34.13.2026.09.09.20.21.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 20:21:41 -0700 (PDT)
From: Andrei Aldea <andrei1998@gmail.com>
To: Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	"Derek J. Clark" <derekjohn.clark@gmail.com>
Cc: linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lee Jones <lee@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	linux-leds@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: [PATCH 15/15] HID: hid-oxp: add X2 auxiliary RGB zones
Date: Wed,  9 Sep 2026 22:21:15 -0500
Message-ID: <20260910032115.28669-16-andrei1998@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260910032115.28669-1-andrei1998@gmail.com>
References: <20260910032115.28669-1-andrei1998@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add separate multicolor LED devices for the X2 guide button and rear logo
using Gen3 zones 5 and 6. Each LED retains independent color, brightness,
and monocolor or breathing effect state.

Use the common LED array and type-tagged state introduced earlier.
Protect auxiliary state snapshots with scoped spinlocks, serialize output
with other RGB operations, and retry a failed command once. Do not alter
an auxiliary zone until userspace has supplied valid state, and restore
valid cached settings after resume.

Expose these zones only on the matched ONEXPLAYER 3 and X2 Mini Pro.
Physical validation of the latter remains outstanding.

Document the auxiliary effects together with the existing joystick-ring
effects and add the previously omitted controller, mapping, rumble, and
ring-lighting ABI. Add the ABI file to the ONEXPLAYER HID maintainer
pattern.

Assisted-by: LLM
Reviewed-by: Derek J. Clark <derekjohn.clark@gmail.com>
Signed-off-by: Andrei Aldea <andrei1998@gmail.com>
---
 .../ABI/testing/sysfs-driver-hid-oxp          | 196 +++++++++++
 MAINTAINERS                                   |   1 +
 drivers/hid/hid-oxp.c                         | 305 +++++++++++++++++-
 3 files changed, 497 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-oxp

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-oxp b/Documentation/ABI/testing/sysfs-driver-hid-oxp
new file mode 100644
index 0000000..7c97f28
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-hid-oxp
@@ -0,0 +1,196 @@
+What:		/sys/class/leds/oxp:rgb:joystick_rings/effect
+What:		/sys/class/leds/oxp:rgb:guide_button/effect
+What:		/sys/class/leds/oxp:rgb:rear_logo/effect
+Date:		April 2026
+Contact:	Derek J. Clark <derekjohn.clark@gmail.com>
+Description:	Read/write attribute selecting the lighting effect for the LED.
+
+		The joystick_rings LED supports the following effect names:
+
+		``aurora``, ``birthday_cake``, ``flowing_light``,
+		``chroma_popping``, ``neon``, ``chroma_breathing``, ``dreamy``,
+		``warm_sun``, ``cyberpunk``, ``sea_foam``, ``sunset_afterglow``,
+		``colorful``, ``monster_woke``, ``green_breathing``,
+		``blue_breathing``, ``yellow_breathing``, ``teal_breathing``,
+		``purple_breathing``, ``foggy_haze``, and ``monocolor``.
+
+		The guide_button and rear_logo LEDs support ``monocolor`` and
+		``breathing``. These two LEDs were added in August 2026 and are
+		available on the ONEXPLAYER 3 and ONEXPLAYER X2 Mini Pro.
+
+		The ``monocolor`` effect displays the color selected through
+		the standard multicolor LED ``multi_intensity`` attribute.
+		The auxiliary ``breathing`` effect pulses the selected color.
+		Other joystick ring effects select firmware-defined presets.
+		The standard brightness and multicolor attributes are documented
+		in Documentation/ABI/testing/sysfs-class-led and
+		Documentation/ABI/testing/sysfs-class-led-multicolor.
+
+		Read returns the selected effect name followed by a newline.
+		The value may reflect cached driver state rather than a live
+		hardware query. The joystick_rings LED may report ``unknown``
+		when no known effect has been recorded; this is not a selectable
+		effect. Auxiliary effect writes queue the update asynchronously.
+
+What:		/sys/class/leds/oxp:rgb:joystick_rings/effect_index
+What:		/sys/class/leds/oxp:rgb:guide_button/effect_index
+What:		/sys/class/leds/oxp:rgb:rear_logo/effect_index
+Date:		April 2026
+Contact:	Derek J. Clark <derekjohn.clark@gmail.com>
+Description:	Read-only list of effect names supported by the corresponding
+		LED, separated by spaces and terminated by a newline.
+
+		The supported names are described in the effect entry above.
+		The list is specific to each LED and does not include ``unknown``.
+		The guide_button and rear_logo attributes were added in August
+		2026 and are available on the ONEXPLAYER 3 and ONEXPLAYER X2
+		Mini Pro.
+
+What:		/sys/class/leds/oxp:rgb:joystick_rings/enabled
+Date:		April 2026
+Contact:	Derek J. Clark <derekjohn.clark@gmail.com>
+Description:	Read/write enable state for the joystick ring lighting.
+
+		Write ``true`` to enable lighting or ``false`` to disable it.
+		Only these literal names are accepted, not numeric boolean
+		values. Read requests lighting status and returns the driver's
+		enable state as one of these names followed by a newline.
+
+		This attribute is not exposed for guide_button or rear_logo.
+
+What:		/sys/class/leds/oxp:rgb:joystick_rings/enabled_index
+Date:		April 2026
+Contact:	Derek J. Clark <derekjohn.clark@gmail.com>
+Description:	Read-only list of names accepted by enabled. Returns
+		``false true`` followed by a newline.
+
+What:		/sys/class/leds/oxp:rgb:joystick_rings/speed
+Date:		April 2026
+Contact:	Derek J. Clark <derekjohn.clark@gmail.com>
+Description:	Read/write firmware animation-speed setting for the joystick
+		ring lighting. Write a decimal integer from 0 through 9.
+		These are firmware levels, not a duration or frequency.
+
+		Read requests lighting status and returns the driver's speed
+		setting as a decimal integer followed by a newline.
+		This attribute is not exposed for guide_button or rear_logo.
+
+What:		/sys/class/leds/oxp:rgb:joystick_rings/speed_range
+Date:		April 2026
+Contact:	Derek J. Clark <derekjohn.clark@gmail.com>
+Description:	Read-only range of values accepted by speed. Returns ``0-9``
+		followed by a newline; both endpoints are inclusive.
+
+What:		/sys/bus/hid/devices/.../gamepad_mode
+Date:		April 2026
+Contact:	Derek J. Clark <derekjohn.clark@gmail.com>
+Description:	Read/write controller mode on the HID configuration interface
+		with usage page 0xff00 (shared by Gen2 and X2/Gen3 devices). Write one of the following names:
+
+		* ``xinput``: normal gamepad input.
+		* ``debug``: route controller events to a hidraw interface for
+		  input-mapping diagnostics instead of the xpad evdev interface.
+
+		Read returns the driver's cached mode name followed by a newline,
+		not a firmware query. The initial cached mode is ``xinput``.
+		Switching to ``xinput`` also reapplies the cached rumble intensity.
+
+		This attribute and the other controller configuration attributes
+		below are attached directly to the selected HID configuration device's
+		sysfs directory, not an input device or LED directory. They are
+		not exposed on Gen1 configuration interfaces.
+
+What:		/sys/bus/hid/devices/.../gamepad_mode_index
+Date:		April 2026
+Contact:	Derek J. Clark <derekjohn.clark@gmail.com>
+Description:	Read-only list of supported controller modes. Returns
+		``xinput debug`` followed by a newline.
+
+What:		/sys/bus/hid/devices/.../button_a
+What:		/sys/bus/hid/devices/.../button_b
+What:		/sys/bus/hid/devices/.../button_x
+What:		/sys/bus/hid/devices/.../button_y
+What:		/sys/bus/hid/devices/.../button_lb
+What:		/sys/bus/hid/devices/.../button_rb
+What:		/sys/bus/hid/devices/.../button_lt
+What:		/sys/bus/hid/devices/.../button_rt
+What:		/sys/bus/hid/devices/.../button_start
+What:		/sys/bus/hid/devices/.../button_select
+What:		/sys/bus/hid/devices/.../button_l3
+What:		/sys/bus/hid/devices/.../button_r3
+What:		/sys/bus/hid/devices/.../button_d_up
+What:		/sys/bus/hid/devices/.../button_d_down
+What:		/sys/bus/hid/devices/.../button_d_left
+What:		/sys/bus/hid/devices/.../button_d_right
+What:		/sys/bus/hid/devices/.../button_m1
+What:		/sys/bus/hid/devices/.../button_m2
+Date:		April 2026
+Contact:	Derek J. Clark <derekjohn.clark@gmail.com>
+Description:	Read/write output mapping for the named physical controller
+		button on a HID configuration device with usage page 0xff00.
+
+		Write one exact, case-sensitive mapping name from
+		button_mapping_options, such as ``BTN_A`` or ``KEY_F15``.
+		Numeric key codes, multiple names, and arbitrary key names
+		are not accepted.
+
+		Read returns the driver's cached mapping name followed by a
+		newline. Writes update that cache and queue the firmware update
+		asynchronously; successful writes do not confirm that the
+		hardware has already applied the mapping.
+
+What:		/sys/bus/hid/devices/.../button_mapping_options
+Date:		April 2026
+Contact:	Derek J. Clark <derekjohn.clark@gmail.com>
+Description:	Read-only list of output mapping names accepted by the
+		controller button attributes, separated by spaces and terminated by a
+		newline. All 18 button attributes accept the same list.
+
+		The gamepad mapping names are:
+
+		``BTN_A``, ``BTN_B``, ``BTN_X``, ``BTN_Y``, ``BTN_LB``,
+		``BTN_RB``, ``BTN_LT``, ``BTN_RT``, ``BTN_START``, ``BTN_SELECT``,
+		``BTN_L3``, ``BTN_R3``, ``DPAD_UP``, ``DPAD_DOWN``,
+		``DPAD_LEFT``, ``DPAD_RIGHT``, ``JOY_L_UP``, ``JOY_L_UP_RIGHT``,
+		``JOY_L_RIGHT``, ``JOY_L_DOWN_RIGHT``, ``JOY_L_DOWN``,
+		``JOY_L_DOWN_LEFT``, ``JOY_L_LEFT``, ``JOY_L_UP_LEFT``,
+		``JOY_R_UP``, ``JOY_R_UP_RIGHT``, ``JOY_R_RIGHT``,
+		``JOY_R_DOWN_RIGHT``, ``JOY_R_DOWN``, ``JOY_R_DOWN_LEFT``,
+		``JOY_R_LEFT``, ``JOY_R_UP_LEFT``, and ``BTN_GUIDE``.
+
+		Keyboard mapping names are ``KEY_F1`` through ``KEY_F24``.
+		There are no ``BTN_M1`` or ``BTN_M2`` output mapping names;
+		button_m1 and button_m2 select from the same options as the
+		other buttons.
+
+What:		/sys/bus/hid/devices/.../reset_buttons
+Date:		April 2026
+Contact:	Derek J. Clark <derekjohn.clark@gmail.com>
+Description:	Write-only reset of the controller's button mappings.
+		Write the decimal value ``1`` to restore the driver's default
+		mappings and send them to the controller. Other values are
+		rejected.
+
+		Main controls map to their corresponding gamepad functions;
+		M1 maps to ``KEY_F15`` and M2 to ``KEY_F16``. This resets button
+		mappings only, not lighting, rumble, or other device settings.
+		It is not a factory reset. Cached mappings are reset before
+		the firmware update and are not rolled back if that update fails.
+
+What:		/sys/bus/hid/devices/.../rumble_intensity
+Date:		April 2026
+Contact:	Derek J. Clark <derekjohn.clark@gmail.com>
+Description:	Read/write rumble-intensity level on the HID configuration
+		device with usage page 0xff00. Write a decimal integer from 0 through 5. These are
+		firmware levels, not percentages or values in physical units.
+
+		Read returns the driver's cached level as a decimal integer
+		followed by a newline. The initial cached value is 5. A write
+		sends the firmware command before updating the cached level.
+
+What:		/sys/bus/hid/devices/.../rumble_intensity_range
+Date:		April 2026
+Contact:	Derek J. Clark <derekjohn.clark@gmail.com>
+Description:	Read-only range of values accepted by the rumble_intensity
+		attribute. Returns ``0-5`` followed by a newline; both endpoints
+		are inclusive.
diff --git a/MAINTAINERS b/MAINTAINERS
index c392ded..fe5a2f6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20381,6 +20381,7 @@ ONEXPLAYER HID DRIVER
 M:	Derek J. Clark <derekjohn.clark@gmail.com>
 L:	linux-input@vger.kernel.org
 S:	Maintained
+F:	Documentation/ABI/testing/sysfs-driver-hid-oxp
 F:	drivers/hid/hid-oxp.c
 
 ONEXPLAYER PLATFORM EC DRIVER
diff --git a/drivers/hid/hid-oxp.c b/drivers/hid/hid-oxp.c
index 9a46602..757cef8 100644
--- a/drivers/hid/hid-oxp.c
+++ b/drivers/hid/hid-oxp.c
@@ -45,6 +45,7 @@
 #define OXP_GET_PROPERTY 0xfc
 #define OXP_SET_PROPERTY 0xfd
 #define OXP_EFFECT_MONO_TRUE 0xfe /* actual index for monocolor */
+#define OXP_EFFECT_BREATHING_TRUE 0xf0
 
 #define OXP_DEVICE_ATTR_RW(_name, _group)                                     \
 	static ssize_t _name##_store(struct device *dev,                      \
@@ -358,6 +359,17 @@ struct oxp_gen_3_rgb_color_report {
 
 enum oxp_rgb_type {
 	OXP_RGB_FULL,
+	OXP_RGB_AUX,
+};
+
+enum oxp_rgb_aux_effect {
+	OXP_RGB_AUX_EFFECT_MONOCOLOR,
+	OXP_RGB_AUX_EFFECT_BREATHING,
+};
+
+static const char *const oxp_rgb_aux_effect_text[] = {
+	[OXP_RGB_AUX_EFFECT_MONOCOLOR] = "monocolor",
+	[OXP_RGB_AUX_EFFECT_BREATHING] = "breathing",
 };
 
 struct oxp_rgb_full_state {
@@ -367,18 +379,30 @@ struct oxp_rgb_full_state {
 	u8 speed;
 };
 
+struct oxp_rgb_aux_state {
+	enum led_brightness brightness;
+	bool valid;
+	u8 effect;
+	u8 green;
+	u8 blue;
+	u8 red;
+};
+
 struct oxp_rgb_led {
 	struct mc_subled subled_info[3];
 	struct led_classdev_mc mc_cdev;
 	struct delayed_work work;
 	struct oxp_hid_cfg *cfg;
+	spinlock_t state_lock; /* protects auxiliary RGB state */
 	void *state;
 	u8 type;
+	u8 zone;
 };
 
 struct oxp_rgb_led_desc {
 	const char *name;
 	u8 type;
+	u8 zone;
 };
 
 struct oxp_attr {
@@ -417,6 +441,23 @@ static struct oxp_rgb_full_state *oxp_rgb_full_state(struct oxp_rgb_led *led)
 	switch (led->type) {
 	case OXP_RGB_FULL:
 		return led->state;
+	case OXP_RGB_AUX:
+		return NULL;
+	}
+
+	return NULL;
+}
+
+static struct oxp_rgb_aux_state *oxp_rgb_aux_state(struct oxp_rgb_led *led)
+{
+	if (!led)
+		return NULL;
+
+	switch (led->type) {
+	case OXP_RGB_FULL:
+		return NULL;
+	case OXP_RGB_AUX:
+		return led->state;
 	}
 
 	return NULL;
@@ -473,6 +514,8 @@ static int oxp_rgb_status_store(struct oxp_rgb_led *led, u8 enabled, u8 speed,
 				u8 brightness);
 static int oxp_rgb_effect_set(struct oxp_rgb_led *led, u8 effect);
 
+static void oxp_rgb_aux_restore_locked(struct oxp_rgb_led *led);
+
 static void oxp_rgb_restore(struct oxp_hid_cfg *cfg)
 {
 	struct oxp_rgb_full_state *state;
@@ -510,6 +553,9 @@ static void oxp_rgb_restore(struct oxp_hid_cfg *cfg)
 					"Error: Failed to restore RGB effect: %i\n",
 					ret);
 			break;
+		case OXP_RGB_AUX:
+			oxp_rgb_aux_restore_locked(led);
+			break;
 		}
 	}
 }
@@ -842,6 +888,19 @@ static int oxp_gen_3_rgb_property_out(struct oxp_hid_cfg *cfg, u8 *data,
 	return first_err;
 }
 
+static int oxp_gen_3_rgb_zone_property_out(struct oxp_hid_cfg *cfg,
+					   u8 *data, u8 data_size)
+{
+	int ret;
+
+	ret = oxp_gen_3_property_out(cfg, data, data_size);
+	/* Retry once if the write or its acknowledgment failed. */
+	if (ret)
+		ret = oxp_gen_3_property_out(cfg, data, data_size);
+
+	return ret;
+}
+
 static void oxp_gen_3_rgb_fill_color(struct oxp_gen_3_rgb_color_report *report,
 				     u8 command, u8 zone, u8 red, u8 green,
 				     u8 blue)
@@ -858,6 +917,85 @@ static void oxp_gen_3_rgb_fill_color(struct oxp_gen_3_rgb_color_report *report,
 	report->final_green = green;
 }
 
+static bool oxp_rgb_aux_snapshot(struct oxp_rgb_led *led,
+				 struct oxp_rgb_aux_state *state)
+{
+	struct oxp_rgb_aux_state *cached = oxp_rgb_aux_state(led);
+
+	if (!cached)
+		return false;
+
+	scoped_guard(spinlock_irqsave, &led->state_lock) {
+		*state = *cached;
+	}
+
+	return state->valid;
+}
+
+static int oxp_rgb_aux_apply(struct oxp_rgb_led *led,
+			     const struct oxp_rgb_aux_state *state)
+{
+	struct oxp_hid_cfg *cfg = led->cfg;
+	unsigned int max_brightness = led->mc_cdev.led_cdev.max_brightness;
+	unsigned int brightness = min_t(unsigned int, state->brightness,
+						 max_brightness);
+	u8 status_data[6] = { OXP_SET_PROPERTY, led->zone, 0x02,
+			      OXP_FEAT_DISABLED, 0x05, 0x04 };
+	struct oxp_gen_3_rgb_color_report color_report;
+	u8 command;
+	u8 green;
+	u8 blue;
+	u8 red;
+	int ret;
+
+	if (brightness)
+		status_data[3] = OXP_FEAT_ENABLED;
+
+	ret = oxp_gen_3_rgb_zone_property_out(cfg, status_data,
+					      sizeof(status_data));
+	if (ret || !brightness)
+		return ret;
+
+	/* Scale each RGB channel by brightness, rounding to the nearest integer. */
+	red = ((unsigned int)state->red * brightness + max_brightness / 2) /
+	      max_brightness;
+	green = ((unsigned int)state->green * brightness + max_brightness / 2) /
+		max_brightness;
+	blue = ((unsigned int)state->blue * brightness + max_brightness / 2) /
+	       max_brightness;
+
+	switch (state->effect) {
+	case OXP_RGB_AUX_EFFECT_MONOCOLOR:
+		command = OXP_EFFECT_MONO_TRUE;
+		break;
+	case OXP_RGB_AUX_EFFECT_BREATHING:
+		command = OXP_EFFECT_BREATHING_TRUE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	oxp_gen_3_rgb_fill_color(&color_report, command, led->zone, red, green,
+				 blue);
+	return oxp_gen_3_rgb_zone_property_out(cfg, (u8 *)&color_report,
+					       sizeof(color_report));
+}
+
+static void oxp_rgb_aux_restore_locked(struct oxp_rgb_led *led)
+{
+	struct oxp_hid_cfg *cfg = led->cfg;
+	struct oxp_rgb_aux_state state;
+	int ret;
+
+	if (!oxp_rgb_aux_snapshot(led, &state))
+		return;
+
+	ret = oxp_rgb_aux_apply(led, &state);
+	if (ret)
+		dev_err(&cfg->hdev->dev,
+			"Failed to restore RGB zone %#04x: %i\n", led->zone, ret);
+}
+
 static ssize_t gamepad_mode_store(struct device *dev,
 				  struct device_attribute *attr, const char *buf,
 				  size_t count)
@@ -1913,6 +2051,25 @@ static void oxp_gen_3_rgb_queue(struct oxp_rgb_led *led,
 			"Error: Failed to write RGB color: %i\n", ret);
 }
 
+static void oxp_rgb_aux_queue(struct oxp_rgb_led *led)
+{
+	struct oxp_hid_cfg *cfg = led->cfg;
+	struct oxp_rgb_aux_state state;
+	int ret;
+
+	if (!oxp_rgb_aux_snapshot(led, &state))
+		return;
+
+	guard(mutex)(&cfg->rgb_mutex);
+	if (READ_ONCE(cfg->suspended) || READ_ONCE(cfg->removing))
+		return;
+
+	ret = oxp_rgb_aux_apply(led, &state);
+	if (ret)
+		dev_err(led->mc_cdev.led_cdev.dev,
+			"Failed to write RGB zone %#04x: %i\n", led->zone, ret);
+}
+
 static void oxp_rgb_queue_fn(struct work_struct *work)
 {
 	struct oxp_rgb_led *led = container_of(to_delayed_work(work),
@@ -1929,6 +2086,9 @@ static void oxp_rgb_queue_fn(struct work_struct *work)
 		else
 			oxp_rgb_full_queue(led, led->state);
 		break;
+	case OXP_RGB_AUX:
+		oxp_rgb_aux_queue(led);
+		break;
 	}
 }
 
@@ -1937,16 +2097,112 @@ static void oxp_rgb_brightness_set(struct led_classdev *led_cdev,
 {
 	struct led_classdev_mc *mc_cdev = lcdev_to_mccdev(led_cdev);
 	struct oxp_rgb_led *led = container_of(mc_cdev, struct oxp_rgb_led,
-					     mc_cdev);
+					       mc_cdev);
 	struct oxp_hid_cfg *cfg = led->cfg;
+	struct oxp_rgb_aux_state *state;
 
-	if (READ_ONCE(cfg->suspended) || READ_ONCE(cfg->removing))
+	if (READ_ONCE(cfg->removing))
+		return;
+
+	switch (led->type) {
+	case OXP_RGB_FULL:
+		if (READ_ONCE(cfg->suspended))
+			return;
+		led_cdev->brightness = brightness;
+		break;
+	case OXP_RGB_AUX:
+		state = led->state;
+		led_cdev->brightness = brightness;
+		scoped_guard(spinlock_irqsave, &led->state_lock) {
+			state->brightness = brightness;
+			state->red = led->subled_info[0].intensity;
+			state->green = led->subled_info[1].intensity;
+			state->blue = led->subled_info[2].intensity;
+			state->valid = true;
+		}
+		if (READ_ONCE(cfg->suspended))
+			return;
+		break;
+	default:
 		return;
+	}
 
-	led_cdev->brightness = brightness;
 	mod_delayed_work(system_dfl_wq, &led->work, msecs_to_jiffies(50));
 }
 
+static ssize_t oxp_rgb_aux_effect_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct oxp_rgb_led *led = oxp_rgb_led_from_dev(dev);
+	struct oxp_hid_cfg *cfg = led->cfg;
+	struct oxp_rgb_aux_state *state = oxp_rgb_aux_state(led);
+	int ret;
+
+	if (!state || READ_ONCE(cfg->removing))
+		return -ENODEV;
+
+	ret = sysfs_match_string(oxp_rgb_aux_effect_text, buf);
+	if (ret < 0)
+		return ret;
+
+	scoped_guard(spinlock_irqsave, &led->state_lock) {
+		state->effect = ret;
+		state->valid = true;
+	}
+
+	if (!READ_ONCE(cfg->suspended) && !READ_ONCE(cfg->removing))
+		mod_delayed_work(system_dfl_wq, &led->work,
+				 msecs_to_jiffies(50));
+
+	return count;
+}
+
+static ssize_t oxp_rgb_aux_effect_show(struct device *dev,
+				       struct device_attribute *attr, char *buf)
+{
+	struct oxp_rgb_led *led = oxp_rgb_led_from_dev(dev);
+	struct oxp_hid_cfg *cfg = led->cfg;
+	struct oxp_rgb_aux_state state;
+
+	if (!oxp_rgb_aux_state(led) || READ_ONCE(cfg->removing))
+		return -ENODEV;
+
+	oxp_rgb_aux_snapshot(led, &state);
+	if (state.effect >= ARRAY_SIZE(oxp_rgb_aux_effect_text))
+		return -EINVAL;
+
+	return sysfs_emit(buf, "%s\n", oxp_rgb_aux_effect_text[state.effect]);
+}
+static DEVICE_ATTR_RW_NAMED(oxp_rgb_aux_effect, "effect");
+
+static ssize_t oxp_rgb_aux_effect_index_show(struct device *dev,
+					     struct device_attribute *attr,
+					     char *buf)
+{
+	int count = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(oxp_rgb_aux_effect_text); i++)
+		count += sysfs_emit_at(buf, count, "%s ",
+				       oxp_rgb_aux_effect_text[i]);
+	if (count)
+		buf[count - 1] = '\n';
+
+	return count;
+}
+static DEVICE_ATTR_RO_NAMED(oxp_rgb_aux_effect_index, "effect_index");
+
+static struct attribute *oxp_rgb_aux_attrs[] = {
+	&dev_attr_oxp_rgb_aux_effect.attr,
+	&dev_attr_oxp_rgb_aux_effect_index.attr,
+	NULL,
+};
+
+static const struct attribute_group oxp_rgb_aux_attr_group = {
+	.attrs = oxp_rgb_aux_attrs,
+};
+
 static struct attribute *oxp_rgb_attrs[] = {
 	&dev_attr_effect.attr,
 	&dev_attr_effect_index.attr,
@@ -1966,12 +2222,23 @@ static const struct oxp_rgb_led_desc oxp_rgb_led_descs[] = {
 		.name = "oxp:rgb:joystick_rings",
 		.type = OXP_RGB_FULL,
 	},
+	{
+		.name = "oxp:rgb:guide_button",
+		.type = OXP_RGB_AUX,
+		.zone = 0x05,
+	},
+	{
+		.name = "oxp:rgb:rear_logo",
+		.type = OXP_RGB_AUX,
+		.zone = 0x06,
+	},
 };
 
 static int oxp_rgb_led_init(struct oxp_hid_cfg *cfg, struct oxp_rgb_led *led,
 			    const struct oxp_rgb_led_desc *desc)
 {
 	struct oxp_rgb_full_state *full_state;
+	struct oxp_rgb_aux_state *aux_state;
 	struct hid_device *hdev = cfg->hdev;
 	u8 green;
 	u8 blue;
@@ -1979,6 +2246,7 @@ static int oxp_rgb_led_init(struct oxp_hid_cfg *cfg, struct oxp_rgb_led *led,
 
 	led->cfg = cfg;
 	led->type = desc->type;
+	led->zone = desc->zone;
 
 	switch (led->type) {
 	case OXP_RGB_FULL:
@@ -1992,6 +2260,20 @@ static int oxp_rgb_led_init(struct oxp_hid_cfg *cfg, struct oxp_rgb_led *led,
 		green = 0x22;
 		blue = 0x99;
 		break;
+	case OXP_RGB_AUX:
+		aux_state = devm_kzalloc(&hdev->dev, sizeof(*aux_state),
+					 GFP_KERNEL);
+		if (!aux_state)
+			return -ENOMEM;
+		aux_state->red = 0xff;
+		aux_state->green = 0xff;
+		aux_state->blue = 0xff;
+		aux_state->effect = OXP_RGB_AUX_EFFECT_MONOCOLOR;
+		led->state = aux_state;
+		red = 0xff;
+		green = 0xff;
+		blue = 0xff;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2020,6 +2302,7 @@ static int oxp_rgb_led_init(struct oxp_hid_cfg *cfg, struct oxp_rgb_led *led,
 	led->mc_cdev.led_cdev.brightness_set = oxp_rgb_brightness_set;
 	led->mc_cdev.num_colors = ARRAY_SIZE(led->subled_info);
 	led->mc_cdev.subled_info = led->subled_info;
+	spin_lock_init(&led->state_lock);
 	INIT_DELAYED_WORK(&led->work, oxp_rgb_queue_fn);
 
 	return 0;
@@ -2027,7 +2310,8 @@ static int oxp_rgb_led_init(struct oxp_hid_cfg *cfg, struct oxp_rgb_led *led,
 
 static int oxp_rgb_leds_register(struct oxp_hid_cfg *cfg)
 {
-	int led_count = ARRAY_SIZE(oxp_rgb_led_descs);
+	int led_count = cfg->x2_rgb ? ARRAY_SIZE(oxp_rgb_led_descs) : 1;
+	const struct attribute_group *attr_group;
 	struct hid_device *hdev = cfg->hdev;
 	struct oxp_rgb_led *led;
 	int ret;
@@ -2051,8 +2335,19 @@ static int oxp_rgb_leds_register(struct oxp_hid_cfg *cfg)
 			return dev_err_probe(&hdev->dev, ret,
 					     "Failed to create RGB device\n");
 
+		switch (led->type) {
+		case OXP_RGB_FULL:
+			attr_group = &oxp_rgb_attr_group;
+			break;
+		case OXP_RGB_AUX:
+			attr_group = &oxp_rgb_aux_attr_group;
+			break;
+		default:
+			return -EINVAL;
+		}
+
 		ret = devm_device_add_group(led->mc_cdev.led_cdev.dev,
-					    &oxp_rgb_attr_group);
+					    attr_group);
 		if (ret)
 			return dev_err_probe(led->mc_cdev.led_cdev.dev, ret,
 					     "Failed to create RGB configuration attributes\n");
