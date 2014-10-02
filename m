From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 5/7] ARM: dts: exynos4412-trats: Add max77693 charger node
Date: Thu, 02 Oct 2014 14:22:06 +0200
Message-ID: <1412252528-30148-6-git-send-email-k.kozlowski@samsung.com>
References: <1412252528-30148-1-git-send-email-k.kozlowski@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1412252528-30148-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>, Javier Martinez Canillas <javier.martinez@collabora.co.uk>, linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>
List-Id: linux-api@vger.kernel.org

Add to Trats2 DTS new node for configuring the max77693 charger driver.
Only the maxim,constant-microvolt differs from default value but set all
of the optional properties anyway.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index dd9ac66770f7..952aeba473f1 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -543,6 +543,16 @@
 					regulator-max-microamp = <2580000>;
 				};
 			};
+
+			charger {
+				compatible = "maxim,max77693-charger";
+
+				maxim,constant-microvolt = <4350000>;
+				maxim,min-system-microvolt = <3600000>;
+				maxim,thermal-regulation-celsius = <100>;
+				maxim,battery-overcurrent-microamp = <3500000>;
+				maxim,charge-input-threshold-microvolt = <4300000>;
+			};
 		};
 	};
 
-- 
1.9.1
