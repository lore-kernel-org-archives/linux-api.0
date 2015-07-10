From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v7 4/9] nvmem: Add bindings for simple nvmem framework
Date: Fri, 10 Jul 2015 10:45:13 +0100
Message-ID: <1436521513-10838-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1436521427-10568-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1436521427-10568-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org, pantelis.antoniou@konsulko.com, mporter@konsulko.com, stefan.wahren@i2se.com, wxt@rock-chips.com, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, Maxime Ripard <maxime.ripard@free-electrons.com>
List-Id: linux-api@vger.kernel.org

This patch adds bindings for simple nvmem framework which allows nvmem
consumers to talk to nvmem providers to get access to nvmem cell data.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
[Maxime Ripard: intial version of eeprom framework]
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 Documentation/devicetree/bindings/nvmem/nvmem.txt | 85 +++++++++++++++++++++++
 1 file changed, 85 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/nvmem/nvmem.txt

diff --git a/Documentation/devicetree/bindings/nvmem/nvmem.txt b/Documentation/devicetree/bindings/nvmem/nvmem.txt
new file mode 100644
index 0000000..849f1e1
--- /dev/null
+++ b/Documentation/devicetree/bindings/nvmem/nvmem.txt
@@ -0,0 +1,85 @@
+= NVMEM(Non Volatile Memory) Data Device Tree Bindings =
+
+This binding is intended to represent the location of hardware
+configuration data stored in NVMEMs like eeprom, efuses and so on.
+
+On a significant proportion of boards, the manufacturer has stored
+some data on NVMEM, for the OS to be able to retrieve these information
+and act upon it. Obviously, the OS has to know about where to retrieve
+these data from, and where they are stored on the storage device.
+
+This document is here to document this.
+
+= Data providers =
+Contains bindings specific to provider drivers and data cells as children
+of this node.
+
+Optional properties:
+ read-only: Mark the provider as read only.
+
+= Data cells =
+These are the child nodes of the provider which contain data cell
+information like offset and size in nvmem provider.
+
+Required properties:
+reg:	specifies the offset in byte within that storage device, start bit
+	in the byte and the length in bytes of the data we care about.
+	There could be more than one offset-length pairs in this property.
+
+Optional properties:
+
+bit-offset: specifies the offset in bit within the address range specified
+	by reg property. Can take values from 0-7.
+nbits: specifies number of bits this cell occupies starting from bit-offset.
+
+For example:
+
+	/* Provider */
+	qfprom: qfprom@00700000 {
+		...
+
+		/* Data cells */
+		tsens_calibration: calib@404 {
+			reg = <0x404 0x10>;
+		};
+
+		tsens_calibration_bckp: calib_bckp@504 {
+			reg = <0x504 0x11>;
+			bit-offset = 6;
+			nbits = 128;
+		};
+
+		pvs_version: pvs-version@6 {
+			reg = <0x6 0x2>
+			bit-offset = 7;
+			nbits = 2;
+		};
+
+		speed_bin: speed-bin@c{
+			reg = <0xc 0x1>;
+			bit-offset = 2;
+			nbits	= 3;
+
+		};
+		...
+	};
+
+= Data consumers =
+Are device nodes which consume nvmem data cells/providers.
+
+Required-properties:
+nvmem-cells: list of phandle to the nvmem data cells.
+nvmem-cell-names: names for the each nvmem-cells specified. Required if
+	nvmem-cells is used.
+
+Optional-properties:
+nvmem	: list of phandles to nvmem providers.
+nvmem-names: names for the each nvmem provider. required if nvmem is used.
+
+For example:
+
+	tsens {
+		...
+		nvmem-cells = <&tsens_calibration>;
+		nvmem-cell-names = "calibration";
+	};
-- 
1.9.1
