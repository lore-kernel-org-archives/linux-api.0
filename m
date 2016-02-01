From: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 5/6] coresight-stm: Bindings for System Trace Macrocell
Date: Mon,  1 Feb 2016 16:20:57 +0800
Message-ID: <1454314857-9340-1-git-send-email-zhang.chunyan@linaro.org>
References: <1454313529-8860-6-git-send-email-zhang.chunyan@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454313529-8860-6-git-send-email-zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, nicolas.guion-qxv4g6HH51o@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

The System Trace Macrocell (STM) is an IP block falling under the
CoreSight umbrella.  It's main purpose it so expose stimulus channels
to any system component for the purpose of information logging.

Bindings for this IP block adds a couple of items to the current
mandatory definition for CoreSight components.

Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 .../devicetree/bindings/arm/coresight.txt          | 28 ++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/coresight.txt b/Documentation/devicetree/bindings/arm/coresight.txt
index 62938eb..93147c0c 100644
--- a/Documentation/devicetree/bindings/arm/coresight.txt
+++ b/Documentation/devicetree/bindings/arm/coresight.txt
@@ -19,6 +19,7 @@ its hardware characteristcs.
 		- "arm,coresight-etm3x", "arm,primecell";
 		- "arm,coresight-etm4x", "arm,primecell";
 		- "qcom,coresight-replicator1x", "arm,primecell";
+		- "arm,coresight-stm", "arm,primecell"; [1]
 
 	* reg: physical base address and length of the register
 	  set(s) of the component.
@@ -36,6 +37,14 @@ its hardware characteristcs.
 	  layout using the generic DT graph presentation found in
 	  "bindings/graph.txt".
 
+* Additional required properties for System Trace Macrocells (STM):
+	* reg: along with the physical base address and length of the register
+	  set as described above, another entry is required to describe the
+	  mapping of the extended stimulus port area.
+
+	* reg-names: the only acceptable values are "stm-base" and
+	  "stm-stimulus-base", each corresponding to the areas defined in "reg".
+
 * Required properties for devices that don't show up on the AMBA bus, such as
   non-configurable replicators:
 
@@ -202,3 +211,22 @@ Example:
 			};
 		};
 	};
+
+4. STM
+	stm@20100000 {
+		compatible = "arm,coresight-stm", "arm,primecell";
+		reg = <0 0x20100000 0 0x1000>,
+		      <0 0x28000000 0 0x180000>;
+		reg-names = "stm-base", "stm-stimulus-base";
+
+		clocks = <&soc_smc50mhz>;
+		clock-names = "apb_pclk";
+		port {
+			stm_out_port: endpoint {
+				remote-endpoint = <&main_funnel_in_port2>;
+			};
+		};
+	};
+
+[1]. There is currently two version of STM: STM32 and STM500.  Both
+have the same HW interface and as such don't need an explicit binding name.
-- 
1.9.1
