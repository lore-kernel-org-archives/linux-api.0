From: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [patch v16 3/4] Documentation: jtag: Add bindings for Aspeed SoC 24xx and 25xx families JTAG master driver
Date: Fri, 12 Jan 2018 19:08:28 +0200
Message-ID: <1515776909-29894-4-git-send-email-oleksandrs@mellanox.com>
References: <1515776909-29894-1-git-send-email-oleksandrs@mellanox.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515776909-29894-1-git-send-email-oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org, tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vadimp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

It has been tested on Mellanox system with BMC equipped with
Aspeed 2520 SoC for programming CPLD devices.

Signed-off-by: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
v15->v16
Comments pointed by Joel Stanley <joel.stan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
- change clocks = <&clk_apb> to proper clocks = <&syscon ASPEED_CLK_APB>
- add reset descriptions in bndings file

v14->v15
v13->v14
v12->v13
v11->v12
v10->v11
v9->v10
v8->v9
v7->v8
Comments pointed by pointed by Joel Stanley <joel.stan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
- Change compatible string to ast2400 and ast2000

V6->v7
Comments pointed by Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>
 - Fix spell "Doccumentation" -> "Documentation"

v5->v6
Comments pointed by Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>
- Small nit: s/documentation/Documentation/

v4->v5

V3->v4
Comments pointed by Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
- delete unnecessary "status" and "reg-shift" descriptions in
  bndings file

v2->v3
Comments pointed by Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
- split Aspeed jtag driver and binding to sepatrate patches
- delete unnecessary "status" and "reg-shift" descriptions in
  bndings file
---
 .../devicetree/bindings/jtag/aspeed-jtag.txt       |   22 ++++++++++++++++++++
 drivers/jtag/jtag-aspeed.c                         |    1 +
 2 files changed, 23 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/jtag/aspeed-jtag.txt

diff --git a/Documentation/devicetree/bindings/jtag/aspeed-jtag.txt b/Documentation/devicetree/bindings/jtag/aspeed-jtag.txt
new file mode 100644
index 0000000..7c36eb6
--- /dev/null
+++ b/Documentation/devicetree/bindings/jtag/aspeed-jtag.txt
@@ -0,0 +1,22 @@
+Aspeed JTAG driver for ast2400 and ast2500 SoC
+
+Required properties:
+- compatible:		Should be one of
+      - "aspeed,ast2400-jtag"
+      - "aspeed,ast2500-jtag"
+- reg			contains the offset and length of the JTAG memory
+			region
+- clocks		root clock of bus, should reference the APB
+			clock in the second cell
+- resets		phandle to reset controller with the reset number in
+			the second cell
+- interrupts		should contain JTAG controller interrupt
+
+Example:
+jtag: jtag@1e6e4000 {
+	compatible = "aspeed,ast2500-jtag";
+	reg = <0x1e6e4000 0x1c>;
+	clocks = <&syscon ASPEED_CLK_APB>;
+	resets = <&syscon ASPEED_RESET_JTAG_MASTER>;
+	interrupts = <43>;
+};
diff --git a/drivers/jtag/jtag-aspeed.c b/drivers/jtag/jtag-aspeed.c
index 9cbd6da..f679041 100644
--- a/drivers/jtag/jtag-aspeed.c
+++ b/drivers/jtag/jtag-aspeed.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/platform_device.h>
+#include <linux/reset.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <uapi/linux/jtag.h>
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
