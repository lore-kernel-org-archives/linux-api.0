From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [PATCH v7 4/6] Documentation: document of_overlay_disable parameter
Date: Thu, 22 Oct 2015 22:50:25 +0300
Message-ID: <1445543427-26275-5-git-send-email-pantelis.antoniou@konsulko.com>
References: <1445543427-26275-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445543427-26275-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Frank Rowand <frowand.list@gmail.com>, Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Pantelis Antoniou <panto@antoniou-consulting.com>
List-Id: linux-api@vger.kernel.org

Document the of_overlay_disable parameter.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 Documentation/kernel-parameters.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 22a4b68..8ca89d9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -90,6 +90,7 @@ parameter is applicable:
 	NET	Appropriate network support is enabled.
 	NUMA	NUMA support is enabled.
 	NFS	Appropriate NFS support is enabled.
+	OF	Open Firmware support (device tree) is enabled.
 	OSS	OSS sound support is enabled.
 	PV_OPS	A paravirtualized kernel is enabled.
 	PARIDE	The ParIDE (parallel port IDE) subsystem is enabled.
@@ -2579,6 +2580,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			This can be set from sysctl after boot.
 			See Documentation/sysctl/vm.txt for details.
 
+	of_overlay_disable	[OF] Disable device tree overlays at boot time.
+
 	ohci1394_dma=early	[HW] enable debugging via the ohci1394 driver.
 			See Documentation/debugging-via-ohci1394.txt for more
 			info.
-- 
1.7.12
