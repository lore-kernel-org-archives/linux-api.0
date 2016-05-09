From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [PATCH v8 6/6] Documentation: ABI: overlays - per overlay docs
Date: Mon,  9 May 2016 16:10:03 +0300
Message-ID: <1462799403-10083-7-git-send-email-pantelis.antoniou@konsulko.com>
References: <1462799403-10083-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462799403-10083-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Frank Rowand <frowand.list@gmail.com>, Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Pantelis Antoniou <panto@antoniou-consulting.com>
List-Id: linux-api@vger.kernel.org

Documentation for the per-overlay attributes.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../ABI/testing/sysfs-firmware-devicetree-overlays | 28 ++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
index e938f44..88d1549 100644
--- a/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
+++ b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
@@ -22,3 +22,31 @@ Description:
 		to be a high-level one-way "off" switch for the interface so
 		that systems that have this interface can choose to turn it off
 		during initial boot, etc."
+
+What:		/sys/firmware/devicetree/overlays/<id>
+Date:		October 2015
+Contact:	Pantelis Antoniou <pantelis.antoniou@konsulko.com>
+Description:
+		Each directory represents an applied overlay, containing
+		the following attribute files.
+
+What:		/sys/firmware/devicetree/overlays/<id>/can_remove
+Date:		October 2015
+Contact:	Pantelis Antoniou <pantelis.antoniou@konsulko.com>
+Description:
+		The attribute set to 1 means that the overlay can be removed,
+		while 0 means that the overlay is being overlapped therefore
+		removal is prohibited.
+
+What:		/sys/firmware/devicetree/overlays/<id>/<fragment-name>/
+Date:		October 2015
+Contact:	Pantelis Antoniou <pantelis.antoniou@konsulko.com>
+Description:
+		Each of these directories contain information about of the
+		particular overlay fragment.
+
+What:		/sys/firmware/devicetree/overlays/<id>/<fragment-name>/target
+Date:		October 2015
+Contact:	Pantelis Antoniou <pantelis.antoniou@konsulko.com>
+Description:
+		The full-path of the target of the fragment
-- 
1.7.12
