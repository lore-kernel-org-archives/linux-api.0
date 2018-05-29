From: Oleksandr Shamray <oleksandrs@mellanox.com>
Subject: [patch v25 3/4] Documentation: jtag: Add bindings for Aspeed SoC 24xx and 25xx families JTAG master driver
Date: Tue, 29 May 2018 17:53:37 +0300
Message-ID: <1527605618-15705-4-git-send-email-oleksandrs@mellanox.com>
References: <1527605618-15705-1-git-send-email-oleksandrs@mellanox.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527605618-15705-1-git-send-email-oleksandrs@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, openbmc@lists.ozlabs.org, joel@jms.id.au, jiri@resnulli.us, tklauser@distanz.ch, linux-serial@vger.kernel.org, vadimp@mellanox.com, system-sw-low-level@mellanox.com, robh+dt@kernel.org, openocd-devel-owner@lists.sourceforge.net, linux-api@vger.kernel.org, davem@davemloft.net, mchehab@kernel.org, Oleksandr Shamray <oleksandrs@mellanox.com>
List-Id: linux-api@vger.kernel.org

It has been tested on Mellanox system with BMC equipped with
Aspeed 2520 SoC for programming CPLD devices.

Signed-off-by: Oleksandr Shamray <oleksandrs@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Acked-by: Rob Herring <robh@kernel.org>
---
v21->v22
v20->v21
v19->v20
v18->v19

v17->v18
v16->v17
v15->v16
Comments pointed by Joel Stanley <joel.stan@gmail.com>
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
Comments pointed by pointed by Joel Stanley <joel.stan@gmail.com>
- Change compatible string to ast2400 and ast2000

V6->v7
Comments pointed by Tobias Klauser <tklauser@distanz.ch>
 - Fix spell "Doccumentation" -> "Documentation"

v5->v6
Comments pointed by Tobias Klauser <tklauser@distanz.ch>
- Small nit: s/documentation/Documentation/

v4->v5

V3->v4
Comments pointed by Rob Herring <robh@kernel.org>
- delete unnecessary "status" and "reg-shift" descriptions in
  bndings file

v2->v3
Comments pointed by Rob Herring <robh@kernel.org>
- split Aspeed jtag driver and binding to sepatrate patches
- delete unnecessary "status" and "reg-shift" descriptions in
  bndings file
---
 .../devicetree/bindings/jtag/aspeed-jtag.txt       |   22 ++++++++++++++++++++
 MAINTAINERS                                        |    1 +
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
diff --git a/MAINTAINERS b/MAINTAINERS
index e7b8b2c..a5e5f75 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7617,6 +7617,7 @@ S:	Maintained
 F:	include/linux/jtag.h
 F:	include/uapi/linux/jtag.h
 F:	drivers/jtag/
+F:	Documentation/devicetree/bindings/jtag/
 
 K10TEMP HARDWARE MONITORING DRIVER
 M:	Clemens Ladisch <clemens@ladisch.de>
-- 
1.7.1
