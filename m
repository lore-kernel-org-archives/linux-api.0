From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 4/6] power: max17040: Add ID for MAX77836 Fuel Gauge block
Date: Fri, 04 Jul 2014 12:12:43 +0200
Message-ID: <1404468765-10818-5-git-send-email-k.kozlowski@samsung.com>
References: <1404468765-10818-1-git-send-email-k.kozlowski@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1404468765-10818-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Kyungmin Park <kyungmin.park@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>, Anton Vorontsov <anton@enomsg.org>
List-Id: linux-api@vger.kernel.org

MAX77836 has the same Fuel Gauge as MAX17040/17048. The max17040 driver
can be safely re-used. The patch adds MAX77836 ID to array of
i2c_device_id.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/power/max17040_battery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
index 0fbac861080d..165ffe381803 100644
--- a/drivers/power/max17040_battery.c
+++ b/drivers/power/max17040_battery.c
@@ -278,6 +278,7 @@ static SIMPLE_DEV_PM_OPS(max17040_pm_ops, max17040_suspend, max17040_resume);
 
 static const struct i2c_device_id max17040_id[] = {
 	{ "max17040", 0 },
+	{ "max77836-battery", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max17040_id);
-- 
1.9.1
