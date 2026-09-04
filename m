Received: from e3i605.smtp2go.com (e3i605.smtp2go.com [158.120.86.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B6C392C29
	for <linux-api@vger.kernel.org>; Fri,  4 Sep 2026 02:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=158.120.86.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788489863; cv=none; b=Kv0If2dq5Trdc3bgpnzlHk8Et3rbNL/86Qa2GsAgawJqIs6G1m3Gfrswia3p7/ADoRxbCi8A0GpVO/uWBIg41C9TT0e2NsmiSRCrTdadu2VYMuT/XmchznNlJQOHmZG3xAb18eIjkqXxaQo2tuo6lM7xqxVmKrIZ7z84eYCgzh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788489863; c=relaxed/simple;
	bh=HdmRsQ0oWz0pzPHVEpRH/Owyu2ppe304S5oRqL5q5R8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M4QXL4w2CLQqqQQBAUVpXrsDcUKSW78QgWulZBZzD1nTIJvTVgAAKgVbt6ExrQnt+3EnPpNGXQQI+guTyqF/Gv++Bxpeqr5sa/RYTdu9wRP3tcf7vOcxlEMlKgYjPNKl5+03CXcrQjHo4Cdm6TKIMFCif4AP9ZK51l1cCFNELUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ait.place; spf=pass smtp.mailfrom=em943033.ait.place; dkim=pass (2048-bit key) header.d=ait.place header.i=@ait.place header.b=ZZnWX9Ck; arc=none smtp.client-ip=158.120.86.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ait.place
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em943033.ait.place
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ait.place header.i=@ait.place header.b="ZZnWX9Ck"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ait.place;
 i=@ait.place; q=dns/txt; s=s943033; t=1788488951; h=from : subject :
 to : message-id : date : list-unsubscribe : list-unsubscribe-post;
 bh=xXZlOcCTr+E0XNy1fQaeGQiQCz9QBsCdB1zl9NIC7A8=;
 b=ZZnWX9CkluW5GVn1INP0so8SlfenB026DltV8c0njTBUEY5NeNIzK3E1gagq4Bw6cInli
 2mPYp50tmn8bnM1fZIQknBIduNQVVyl283R/v6ojZtG/na2SSfVz295JSiQwi/PdRETv5Rp
 HOq4PujFQMeobo90qSU6zAcmInfGTJ6RpVe/7v+18DD6YcD7jMIbHSniLbsZHTGJNBpSInO
 Fn+K1VuuvYJILCMjnuksx4l7/yJjtuu4bahyeSS33LhddXSSBkKDU2Ww9GUoTw5PB6eTAqp
 Wpicw8QlXA5YidK3agJhU8vTnzFWaBaJZS/ADXdlt4G40iY/Ktsw1QJNnsQg==
Received: from [10.191.245.51] (helo=omarchy.bb.online.no)
	by smtpcorp.com with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.99.4)
	(envelope-from <ait@ait.place>)
	id 1x2Jfv-FnQW0hPnlyJ-nLce;
	Fri, 04 Sep 2026 02:29:07 +0000
From: ait <ait@ait.place>
To: ait@ait.place
Cc: Jonathan Jansen <jonathanjansen@ait.place>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org,
	linux-api@vger.kernel.org,
	Your Name <you@example.com>
Subject: [PATCH] HID: input: map System Microphone Mute LED
Date: Fri,  4 Sep 2026 04:29:03 +0200
Message-ID: <20260904022903.607880-1-ait@ait.place>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Report-Abuse: Please forward a copy of this message, including all headers, to <abuse-report@smtp2go.com>
Feedback-ID: 943033m:943033ayMjrpg:943033ssDv2ghnHS
X-smtpcorp-track: VrFwr5v8VAki.LxPoUAbh7-OI.IrCvHgR8jtM

From: Jonathan Jansen <jonathanjansen@ait.place>

HUTRR110 (approved 2022, part of HID Usage Tables since v1.4) defines:

  Generic Desktop (0x01)  0xa9  System Microphone Mute  OOC (input)
  LED Page (0x08)         0x57  System Microphone Mute  OOC (output)

The input usage already maps to KEY_MICMUTE, so the button works on
HUTRR110 devices.  The LED output usage is ignored, though, so the
indicator stays dark and userspace depends on per-vendor hacks
(hid-lenovo, hid-lg-g15, hid-playstation, hid-plantronics) or platform
drivers instead.

Map LED page usage 0x57 to a new LED_MICMUTE input LED.  It shows up
as /sys/class/leds/inputN::micmute with the "audio-micmute" trigger
that snd-ctl-led registers, so the LED tracks the audio stack's
system-wide microphone mute state, like the existing "Mute" (LED page
0x09) mapping does for speaker mute.

LED_MICMUTE takes the next free input LED code (0x0b, below LED_MAX
0x0f), so nothing existing breaks.

Link: https://www.usb.org/sites/default/files/hutrr110-systemmicrophonemute.pdf
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
Cc: linux-api@vger.kernel.org
Signed-off-by: Your Name <you@example.com>
---
 drivers/hid/hid-debug.c                | 2 +-
 drivers/hid/hid-input.c                | 1 +
 drivers/input/input-leds.c             | 1 +
 include/uapi/linux/input-event-codes.h | 1 +
 4 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index f44e6e708..92a950105 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -3550,7 +3550,7 @@ static const char *leds[LED_MAX + 1] = {
 	[LED_KANA] = "Kana",		[LED_SLEEP] = "Sleep",
 	[LED_SUSPEND] = "Suspend",	[LED_MUTE] = "Mute",
 	[LED_MISC] = "Misc",		[LED_MAIL] = "Mail",
-	[LED_CHARGING] = "Charging",
+	[LED_CHARGING] = "Charging",	[LED_MICMUTE] = "Mic Mute",
 };
 
 static const char *repeats[REP_MAX + 1] = {
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index edd6bbf83..727374dd5 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -990,6 +990,7 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 		case 0x27:  map_led (LED_SLEEP);    break;    /*   "Stand-By"                 */
 		case 0x4c:  map_led (LED_SUSPEND);  break;    /*   "System Suspend"           */
 		case 0x09:  map_led (LED_MUTE);     break;    /*   "Mute"                     */
+		case 0x57:  map_led (LED_MICMUTE);  break;    /*   "System Microphone Mute"   */
 		case 0x4b:  map_led (LED_MISC);     break;    /*   "Generic Indicator"        */
 		case 0x19:  map_led (LED_MAIL);     break;    /*   "Message Waiting"          */
 		case 0x4d:  map_led (LED_CHARGING); break;    /*   "External Power Connected" */
diff --git a/drivers/input/input-leds.c b/drivers/input/input-leds.c
index b08d1d08d..6522079a4 100644
--- a/drivers/input/input-leds.c
+++ b/drivers/input/input-leds.c
@@ -36,6 +36,7 @@ static const struct {
 	[LED_SLEEP]	= { "sleep" } ,
 	[LED_SUSPEND]	= { "suspend" },
 	[LED_MUTE]	= { "mute", AUDIO_TRIGGER("audio-mute") },
+	[LED_MICMUTE]	= { "micmute", AUDIO_TRIGGER("audio-micmute") },
 	[LED_MISC]	= { "misc" },
 	[LED_MAIL]	= { "mail" },
 	[LED_CHARGING]	= { "charging" },
diff --git a/include/uapi/linux/input-event-codes.h b/include/uapi/linux/input-event-codes.h
index 3528168f7..bc374821c 100644
--- a/include/uapi/linux/input-event-codes.h
+++ b/include/uapi/linux/input-event-codes.h
@@ -983,6 +983,7 @@
 #define LED_MISC		0x08
 #define LED_MAIL		0x09
 #define LED_CHARGING		0x0a
+#define LED_MICMUTE		0x0b
 #define LED_MAX			0x0f
 #define LED_CNT			(LED_MAX+1)
 
-- 
2.51.0

