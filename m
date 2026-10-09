Received: from out198-18.us.a.mail.aliyun.com (out198-18.us.a.mail.aliyun.com [47.90.198.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AC83C0607;
	Fri,  9 Oct 2026 08:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.198.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791534358; cv=none; b=LUgp+sKDa9pxCQPG5iNahW4z5ob46OO0igE9QMrhluWkgs+StDv7A950qkq2y1k1xnIfDI+416pm05aHMgMqdd4IcUo+HiCr+zoUMAmczJXy218goSVtN1oAo1kunhSkRACzFuAQTSh4a7pjyDoOAskBnL/gGvVf4yit9pGJHJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791534358; c=relaxed/simple;
	bh=I0Wkfmo6zgu/v7Zyd3Yd0eUzJK6+I/NoF1zXa5x02Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PoYv+H+0AN1byhlAe0o8QbBXngFlSpDcqgIOxA0kjFFWGCinqUnZ+EKMLxoZdMdPfSYihJ10wihfPhVXsL4OJl/JVoy6ori+Ev/ICTgb6Ge8Ql1nlEuH/d3bTgBwJlTBaQRXOS/LaA7cZgWdPkyqBjoQQv9Uf3xuB2WVO6XO45s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=edatec.cn; spf=pass smtp.mailfrom=edatec.cn; arc=none smtp.client-ip=47.90.198.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=edatec.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=edatec.cn
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.07440926|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00540171-8.58566e-05-0.994512;FP=16267207048373667903|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033068005250;MF=zjzhao@edatec.cn;NM=1;PH=DS;RN=12;RT=12;SR=0;TI=SMTPD_---.jXaSekJ_1791534330;
Received: from LAPTOP-VQRD5F43.hs.edatec.cn(mailfrom:zjzhao@edatec.cn fp:SMTPD_---.jXaSekJ_1791534330 cluster:ay29)
          by smtp.aliyun-inc.com;
          Fri, 09 Oct 2026 16:25:32 +0800
From: zjzhao@edatec.cn
To: gregkh@linuxfoundation.org,
	jirislaby@kernel.org
Cc: robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	hugo@hugovil.com,
	hy@wkmic.com,
	linux-serial@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-api@vger.kernel.org,
	Zi Jie Zhao <zjzhao@edatec.cn>
Subject: [PATCH v5 1/2] dt-bindings: serial: Document WK2xxx SPI UART
Date: Fri,  9 Oct 2026 16:24:07 +0800
Message-ID: <20261009082530.248219-1-zjzhao@edatec.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.20261009.wk2xxx.v5@edatec.cn>
References: <cover.20261009.wk2xxx.v5@edatec.cn>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zi Jie Zhao <zjzhao@edatec.cn>

Add a DT binding for the WK2xxx SPI-to-UART bridge ICs (WK2124,
WK2132, WK2168, WK2212 and WK2204) from Chengdu Weikai
Microelectronics (WKmic).

Describe each UART channel with a serial@N child node carrying its
serial and RS-485 properties. Register the wkmic vendor prefix based
on the vendor website.

Differentiate compatible strings by channel count and register
availability. WK2124 and WK2132 lack hardware flow-control and
RS-485 registers. WK2212 is a separate two-channel model that
supports both features. Reject serial@2 and serial@3 on the
two-channel members.

Correct the WK2202 compatible used in the public v4 series to
WK2212. WK2202 in the public reference driver is a typo.

Require the standard clocks property for the single external
reference clock used by the chips.

Assisted-by: LLM
Signed-off-by: Zi Jie Zhao <zjzhao@edatec.cn>
---
 .../bindings/serial/wkmic,wk2124.yaml         | 119 ++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
 MAINTAINERS                                   |   7 ++
 3 files changed, 128 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/serial/wkmic,wk2124.yaml

diff --git a/Documentation/devicetree/bindings/serial/wkmic,wk2124.yaml b/Documentation/devicetree/bindings/serial/wkmic,wk2124.yaml
new file mode 100644
index 000000000000..47a0cbdb5ca1
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/wkmic,wk2124.yaml
@@ -0,0 +1,119 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/serial/wkmic,wk2124.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: WKmic WK2xxx SPI to UART bridge
+
+maintainers:
+  - Huang Yang <hy@wkmic.com>
+
+description:
+  The WK2xxx family (WK2124, WK2132, WK2168, WK2212 and WK2204) are SPI to
+  UART bridge ICs from WKmic (Chengdu Weikai Microelectronics). Each IC
+  exposes two or four full-duplex UART channels with 256-byte RX/TX FIFOs
+  through a single SPI slave interface and one interrupt line, and is
+  clocked from a single external reference clock. Each channel is
+  described by a "serial@N" child node that carries its own serial and
+  RS-485 properties.
+
+properties:
+  compatible:
+    enum:
+      - wkmic,wk2124
+      - wkmic,wk2132
+      - wkmic,wk2168
+      - wkmic,wk2212
+      - wkmic,wk2204
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    description:
+      When missing, the device driver uses polling instead.
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 0
+
+patternProperties:
+  "^serial@[0-3]$":
+    type: object
+    description: A single UART channel of the chip.
+    allOf:
+      - $ref: /schemas/serial/serial.yaml#
+      - $ref: /schemas/serial/rs485.yaml#
+    properties:
+      reg:
+        description: UART channel number on the chip.
+        maximum: 3
+    required:
+      - reg
+    unevaluatedProperties: false
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - "#address-cells"
+  - "#size-cells"
+
+allOf:
+  - $ref: /schemas/spi/spi-peripheral-props.yaml#
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - wkmic,wk2132
+              - wkmic,wk2212
+    then:
+      patternProperties:
+        "^serial@[23]$": false
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    xtal: clock-11059200 {
+        compatible = "fixed-clock";
+        clock-frequency = <11059200>;
+        #clock-cells = <0>;
+    };
+
+    spi {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        serial@0 {
+            compatible = "wkmic,wk2204";
+            reg = <0>;
+            spi-max-frequency = <10000000>;
+            clocks = <&xtal>;
+            interrupt-parent = <&gpio>;
+            interrupts = <24 IRQ_TYPE_LEVEL_LOW>;
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            serial@0 {
+                reg = <0>;
+            };
+
+            serial@1 {
+                reg = <1>;
+                rs485-rts-active-low;
+                linux,rs485-enabled-at-boot-time;
+            };
+        };
+    };
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index ba2002969373..cdc04229d642 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1907,6 +1907,8 @@ patternProperties:
     description: Wireless Tag (qiming yunduan)
   "^wits,.*":
     description: Shenzhen Merrii Technology Co., Ltd. (WITS)
+  "^wkmic,.*":
+    description: Chengdu Weikai Microelectronics Co., Ltd. (http://www.wkmic.com/)
   "^wlf,.*":
     description: Wolfson Microelectronics
   "^wm,.*":
diff --git a/MAINTAINERS b/MAINTAINERS
index 3b2eb2a7a89a..e4a2443524d4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -29432,6 +29432,13 @@ M:	Miloslav Trmac <mitr@volny.cz>
 S:	Maintained
 F:	drivers/input/misc/wistron_btns.c
 
+WK2XXX SPI UART DRIVER
+M:	Huang Yang <hy@wkmic.com>
+L:	linux-serial@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/serial/wkmic,wk2124.yaml
+F:	drivers/tty/serial/wk2xxx.c
+
 WMI BINARY MOF DRIVER
 M:	Armin Wolf <W_Armin@gmx.de>
 R:	Thomas Weißschuh <linux@weissschuh.net>
-- 
2.43.0

