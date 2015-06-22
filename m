From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v6 4/9] nvmem: Add bindings for simple nvmem framework
Date: Tue, 23 Jun 2015 00:08:58 +0100
Message-ID: <1435014538-26308-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1435014459-26138-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435014459-26138-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, stefan.wahren-eS4NqCHxEME@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch adds bindings for simple nvmem framework which allows nvmem
consumers to talk to nvmem providers to get access to nvmem cell data.

Signed-off-by: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
[Maxime Ripard: intial version of eeprom framework]
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 Documentation/devicetree/bindings/nvmem/nvmem.txt | 85 +++++++++++++++++++++++
 1 file changed, 85 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/nvmem/nvmem.txt

diff --git a/Documentation/devicetree/bindings/nvmem/nvmem.txt b/Documentation/devicetree/bindings/nvmem/nvmem.txt
new file mode 100644
index 0000000..d1a37e7
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
+	in the byte and the length in bits of the data we care about.
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
+nvmem-cell: list of phandle to the nvmem data cells.
+nvmem-cell-names: names for the each nvmem-cell specified. Required if
+	nvmem-cell is used.
+
+Optional-properties:
+nvmem	: list of phandles to nvmem providers.
+nvmem-names: names for the each nvmem provider. required if nvmem is used.
+
+For example:
+
+	tsens {
+		...
+		nvmem-cell = <&tsens_calibration>;
+		nvmem-cell-names = "calibration";
+	};
-- 
1.9.1
