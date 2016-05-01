From: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>
Subject: [PATCH 13/13] iio: health/afe4404: ENSEPGAIN is part of CONTROL2 register
Date: Sun, 1 May 2016 15:37:03 -0500
Message-ID: <1462135023-14445-14-git-send-email-afd@ti.com>
References: <1462135023-14445-1-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462135023-14445-1-git-send-email-afd-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Cc: linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Rename this definition, no functional changes.

Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
---
 drivers/iio/health/afe4404.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/health/afe4404.c b/drivers/iio/health/afe4404.c
index 3a8131d..4526640 100644
--- a/drivers/iio/health/afe4404.c
+++ b/drivers/iio/health/afe4404.c
@@ -48,8 +48,8 @@
 #define AFE4404_AVG_LED2_ALED2VAL	0x3f
 #define AFE4404_AVG_LED1_ALED1VAL	0x40
 
-/* AFE4404 CONTROL3 register fields */
-#define AFE440X_CONTROL3_OSC_ENABLE	BIT(9)
+/* AFE4404 CONTROL2 register fields */
+#define AFE440X_CONTROL2_OSC_ENABLE	BIT(9)
 
 enum afe4404_fields {
 	/* Gains */
@@ -398,7 +398,7 @@ static const struct reg_sequence afe4404_reg_sequences[] = {
 	AFE4404_TIMING_PAIRS,
 	{ AFE440X_CONTROL1, AFE440X_CONTROL1_TIMEREN },
 	{ AFE4404_TIA_GAIN_SEP, AFE440X_TIAGAIN_ENSEPGAIN },
-	{ AFE440X_CONTROL2, AFE440X_CONTROL3_OSC_ENABLE	},
+	{ AFE440X_CONTROL2, AFE440X_CONTROL2_OSC_ENABLE	},
 };
 
 static const struct regmap_range afe4404_yes_ranges[] = {
-- 
2.8.1
