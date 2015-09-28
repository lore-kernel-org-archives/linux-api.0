From: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
Subject: [PATCH v8 06/14] power: bq24257: Add bit definition for temp sense enable
Date: Mon, 28 Sep 2015 17:33:54 -0500
Message-ID: <1443479642-23712-7-git-send-email-dannenberg@ti.com>
References: <1443479642-23712-1-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443479642-23712-1-git-send-email-dannenberg-l0cyMroinI0@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Adding a missing bit definition for the sake of consistency device model
vs. bit field representation. No change in functionality.

Signed-off-by: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
Reviewed-by: Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/power/bq24257_charger.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/bq24257_charger.c b/drivers/power/bq24257_charger.c
index b0c8533..93f7582 100644
--- a/drivers/power/bq24257_charger.c
+++ b/drivers/power/bq24257_charger.c
@@ -66,7 +66,7 @@ enum bq24257_fields {
 	F_VBAT, F_USB_DET,					    /* REG 3 */
 	F_ICHG, F_ITERM,					    /* REG 4 */
 	F_LOOP_STATUS, F_LOW_CHG, F_DPDM_EN, F_CE_STATUS, F_VINDPM, /* REG 5 */
-	F_X2_TMR_EN, F_TMR, F_SYSOFF, F_TS_STAT,		    /* REG 6 */
+	F_X2_TMR_EN, F_TMR, F_SYSOFF, F_TS_EN, F_TS_STAT,	    /* REG 6 */
 	F_VOVP, F_CLR_VDP, F_FORCE_BATDET, F_FORCE_PTM,		    /* REG 7 */
 
 	F_MAX_FIELDS
@@ -156,6 +156,7 @@ static const struct reg_field bq24257_reg_fields[] = {
 	[F_X2_TMR_EN]		= REG_FIELD(BQ24257_REG_6, 7, 7),
 	[F_TMR]			= REG_FIELD(BQ24257_REG_6, 5, 6),
 	[F_SYSOFF]		= REG_FIELD(BQ24257_REG_6, 4, 4),
+	[F_TS_EN]		= REG_FIELD(BQ24257_REG_6, 3, 3),
 	[F_TS_STAT]		= REG_FIELD(BQ24257_REG_6, 0, 2),
 	/* REG 7 */
 	[F_VOVP]		= REG_FIELD(BQ24257_REG_7, 5, 7),
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
