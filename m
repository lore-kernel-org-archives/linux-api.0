From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 2/5] mfd: max77693: Map charger device to its own of_node
Date: Mon, 20 Oct 2014 14:34:46 +0200
Message-ID: <1413808489-3524-3-git-send-email-k.kozlowski@samsung.com>
References: <1413808489-3524-1-git-send-email-k.kozlowski@samsung.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-reply-to: <1413808489-3524-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-pm-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>, linux-api@vger.kernel.org, devicetree@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>
List-Id: linux-api@vger.kernel.org

Add a "maxim,max77693-charger" of_compatible to the mfd_cell so the MFD
child device (the charger) will have its own of_node set. This will be
used by the max77693 charger driver in next patches to obtain battery
configuration from DTS.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/max77693.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index cf008f45968c..2277a11b6629 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -43,7 +43,10 @@
 
 static const struct mfd_cell max77693_devs[] = {
 	{ .name = "max77693-pmic", },
-	{ .name = "max77693-charger", },
+	{
+		.name = "max77693-charger",
+		.of_compatible = "maxim,max77693-charger",
+	},
 	{ .name = "max77693-muic", },
 	{ .name = "max77693-haptic", },
 	{
-- 
1.9.1

