From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [PATCH 4/5] doc: ABI: bone_capemgr sysfs API
Date: Wed, 13 May 2015 10:59:44 +0300
Message-ID: <1431503985-31853-5-git-send-email-pantelis.antoniou@konsulko.com>
References: <1431503985-31853-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1431503985-31853-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-doc-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Robert Nelson <robertcnelson@gmail.com>, Rob Herring <robherring2@gmail.com>, Grant Likely <grant.likely@secretlab.ca>, Jonathan Corbet <corbet@lwn.net>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, Guenter Roeck <linux@roeck-us.net>, Geert Uytterhoeven <geert+renesas@glider.be>, =?UTF-8?q?Beno=C3=AEt=20Cousso?= <bcousson@baylibre.com>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Pantelis Antoniou <panto@antoniou-consulting.com>
List-Id: linux-api@vger.kernel.org

Document the beaglebone's capemgr sysfs API

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 .../testing/sysfs-devices-platform-bone_capemgr    | 63 ++++++++++++++++++++++
 1 file changed, 63 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-platform-bone_capemgr

diff --git a/Documentation/ABI/testing/sysfs-devices-platform-bone_capemgr b/Documentation/ABI/testing/sysfs-devices-platform-bone_capemgr
new file mode 100644
index 0000000..e2df613
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-platform-bone_capemgr
@@ -0,0 +1,63 @@
+What:		/sys/devices/platform/bone_capemgr/slots
+Date:		May 2015
+KernelVersion:	4.0
+Contact:	Pantelis Antoniou <pantelis.antoniou@konsulko.com>
+Description:
+		READ:
+		  Describe the state of all the slots of the beaglebone capemgr.
+		  Each line of the output describes a slot:
+		  The slot format is as following:
+		  <slot-id>: [P-][F-][O-][l-][L-][D-] \
+			  <overlay-id> <board-name>,<version>,
+			  <manufacturer>,<part-number>
+
+		Where the flags are:
+		P: Slot has been probed
+		F: Slot has failed probing (i.e. no EEPROM detected)
+		O: Slot has been overridden by the user
+		l: Slot is current loading
+		L: Slot has completed loading and is ready
+		D: Slot has been disabled
+
+		Example:
+		0: P---L-  -1 BeagleBone RS232 CAPE,00A1,Beagleboardtoys,BB-BONE-SERL-03
+		1: PF----  -1
+		2: PF----  -1
+		3: PF----  -1
+
+		WRITE:
+		  Writing a string of the form <part-number>[:version] issues a request to
+		  load a firmware blob containing an overlay. The name of the firmware blob
+		  is <part-number>-[version|00A0].dtbo. This act is defined as a slot override.
+
+		  Writing a negative slot id removes the slot if it was an overridden one, or
+		  unloads a slot that was probed.
+
+What:		/sys/devices/platform/bone_capemgr/baseboard/<eeprom-field>
+Date:		May 2015
+KernelVersion:	4.0
+Contact:	Pantelis Antoniou <pantelis.antoniou@konsulko.com>
+Description:	Contains the probed base board EEPROM field; one of:
+		board-name		- board-name as stored in cape EEPROM
+		dc-supplied		- whether the cape draws or supplies DC
+		eeprom-format-revision	- EEPROM format rev, only 00A0 supported
+		header			- header; should be 'aa 55 33 ee'
+		manufacturer		- manufacturer string
+		part-number		- part-number of the cape
+		serial-number		- serial number of the cape
+		version			- version of the cape, i.e. 00A0
+		number-of-pins		- displayed but ignored
+		pin-usage		- displayed but ignored
+		sys-5v			- displayed but ignored
+		vdd-3v3exp		- displayed but ignored
+		vdd-5v			- displayed but ignored
+What:		/sys/devices/platform/bone_capemgr/slot-<n>/<eeprom-field>
+Date:		May 2015
+KernelVersion:	4.0
+Contact:	Pantelis Antoniou <pantelis.antoniou@konsulko.com>
+Description:	Contains the probed cape's EEPROM field; the field is one of:
+		board-name		- baseboard name i.e. A335BNLT
+		header			- header; should be 'aa 55 33 ee'
+		revision		- baseboard revision
+		serial-number		- baseboard serial number
+		config-option		- displayed but ignored
-- 
1.7.12

