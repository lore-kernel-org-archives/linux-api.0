From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 6/8] power: max17040: Add ID for MAX77836 Fuel Gauge block
Date: Thu, 28 Aug 2014 15:05:48 +0200
Message-ID: <1409231150-2701-7-git-send-email-k.kozlowski@samsung.com>
References: <1409231150-2701-1-git-send-email-k.kozlowski@samsung.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-reply-to: <1409231150-2701-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-pm-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Kyungmin Park <kyungmin.park@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>
List-Id: linux-api@vger.kernel.org

MAX77836 has the same Fuel Gauge as MAX17040/17048. The max17040 driver
can be safely re-used. The patch adds MAX77836 device to the array of
i2c_device_id. Additionally it removes the id associated with MAX17040
device as the value is not used.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/max17040_battery.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
index 0fbac861080d..14d44706327b 100644
--- a/drivers/power/max17040_battery.c
+++ b/drivers/power/max17040_battery.c
@@ -277,7 +277,8 @@ static SIMPLE_DEV_PM_OPS(max17040_pm_ops, max17040_suspend, max17040_resume);
 #endif /* CONFIG_PM_SLEEP */
 
 static const struct i2c_device_id max17040_id[] = {
-	{ "max17040", 0 },
+	{ "max17040" },
+	{ "max77836-battery" },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max17040_id);
-- 
1.9.1

