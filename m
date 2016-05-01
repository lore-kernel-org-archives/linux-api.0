From: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>
Subject: [PATCH 03/13] iio: health/afe440x: Remove unneeded initializers
Date: Sun, 1 May 2016 15:36:53 -0500
Message-ID: <1462135023-14445-4-git-send-email-afd@ti.com>
References: <1462135023-14445-1-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462135023-14445-1-git-send-email-afd-l0cyMroinI0@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Cc: linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The drivers set some register values during initialization that can be
set at runtime, these defaults were used in testing but are not
necessary, remove these.

Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
---
 drivers/iio/health/afe4403.c | 7 +------
 drivers/iio/health/afe4404.c | 4 ----
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/iio/health/afe4403.c b/drivers/iio/health/afe4403.c
index e3700cf..5484785 100644
--- a/drivers/iio/health/afe4403.c
+++ b/drivers/iio/health/afe4403.c
@@ -472,12 +472,7 @@ static const struct iio_trigger_ops afe4403_trigger_ops = {
 
 static const struct reg_sequence afe4403_reg_sequences[] = {
 	AFE4403_TIMING_PAIRS,
-	{ AFE440X_CONTROL1, AFE440X_CONTROL1_TIMEREN | 0x000007},
-	{ AFE4403_TIA_AMB_GAIN, AFE4403_TIAGAIN_RES_1_M },
-	{ AFE440X_LEDCNTRL, (0x14 << AFE440X_LEDCNTRL_LED1_SHIFT) |
-			    (0x14 << AFE440X_LEDCNTRL_LED2_SHIFT) },
-	{ AFE440X_CONTROL2, AFE440X_CONTROL2_TX_REF_050 <<
-			    AFE440X_CONTROL2_TX_REF_SHIFT },
+	{ AFE440X_CONTROL1, AFE440X_CONTROL1_TIMEREN },
 };
 
 static const struct regmap_range afe4403_yes_ranges[] = {
diff --git a/drivers/iio/health/afe4404.c b/drivers/iio/health/afe4404.c
index 783b9b4..2d4c522 100644
--- a/drivers/iio/health/afe4404.c
+++ b/drivers/iio/health/afe4404.c
@@ -443,10 +443,6 @@ static const struct iio_trigger_ops afe4404_trigger_ops = {
 static const struct reg_sequence afe4404_reg_sequences[] = {
 	AFE4404_TIMING_PAIRS,
 	{ AFE440X_CONTROL1, AFE440X_CONTROL1_TIMEREN },
-	{ AFE4404_TIA_GAIN, AFE4404_TIA_GAIN_RES_50_K },
-	{ AFE440X_LEDCNTRL, (0xf << AFE4404_LEDCNTRL_ILED1_SHIFT) |
-			    (0x3 << AFE4404_LEDCNTRL_ILED2_SHIFT) |
-			    (0x3 << AFE4404_LEDCNTRL_ILED3_SHIFT) },
 	{ AFE440X_CONTROL2, AFE440X_CONTROL3_OSC_ENABLE	},
 };
 
-- 
2.8.1
