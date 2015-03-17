From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [PATCH 5/5] MAINTAINERS: Pantelis Antoniou device tree overlay maintainer
Date: Tue, 17 Mar 2015 22:30:57 +0200
Message-ID: <1426624257-23003-6-git-send-email-pantelis.antoniou@konsulko.com>
References: <1426624257-23003-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426624257-23003-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matt Porter <matt.porter@linaro.org>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, Rob Herring <robherring2@gmail.com>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Pantelis Antoniou <panto@antoniou-consulting.com>
List-Id: linux-api@vger.kernel.org

Add me as the device tree overlays maintainer.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0e1abe8..24aa339 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7187,6 +7187,15 @@ F:	Documentation/devicetree/
 F:	arch/*/boot/dts/
 F:	include/dt-bindings/
 
+OPEN FIRMWARE AND DEVICE TREE OVERLAYS
+M:	Pantelis Antoniou <pantelis.antoniou@konsulko.com>
+L:	devicetree@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/dynamic-resolution-notes.txt
+F:	Documentation/devicetree/overlay-notes.txt
+F:	drivers/of/overlay.c
+F:	drivers/of/resolver.c
+
 OPENRISC ARCHITECTURE
 M:	Jonas Bonn <jonas@southpole.se>
 W:	http://openrisc.net
-- 
1.7.12
