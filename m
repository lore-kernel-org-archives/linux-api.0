From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/5] of: unittest: overlay: Keep track of created overlays
Date: Tue, 17 Mar 2015 22:30:53 +0200
Message-ID: <1426624257-23003-2-git-send-email-pantelis.antoniou@konsulko.com>
References: <1426624257-23003-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426624257-23003-1-git-send-email-pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Porter <matt.porter-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

During the course of the overlay selftests some of them remain
applied. While this does not pose a real problem, make sure you track
them and destroy them at the end of the test.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
---
 drivers/of/unittest.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 4e60682..c711534 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -23,6 +23,8 @@
 #include <linux/i2c.h>
 #include <linux/i2c-mux.h>
 
+#include <linux/bitops.h>
+
 #include "of_private.h"
 
 static struct selftest_results {
@@ -1115,6 +1117,59 @@ static const char *overlay_path(int nr)
 
 static const char *bus_path = "/testcase-data/overlay-node/test-bus";
 
+/* it is guaranteed that overlay ids are assigned in sequence */
+#define MAX_SELFTEST_OVERLAYS	256
+static unsigned long overlay_id_bits[BITS_TO_LONGS(MAX_SELFTEST_OVERLAYS)];
+static int overlay_first_id = -1;
+
+static void of_selftest_track_overlay(int id)
+{
+	if (overlay_first_id < 0)
+		overlay_first_id = id;
+	id -= overlay_first_id;
+
+	/* we shouldn't need that many */
+	BUG_ON(id >= MAX_SELFTEST_OVERLAYS);
+	overlay_id_bits[BIT_WORD(id)] |= BIT_MASK(id);
+}
+
+static void of_selftest_untrack_overlay(int id)
+{
+	if (overlay_first_id < 0)
+		return;
+	id -= overlay_first_id;
+	BUG_ON(id >= MAX_SELFTEST_OVERLAYS);
+	overlay_id_bits[BIT_WORD(id)] &= ~BIT_MASK(id);
+}
+
+static void of_selftest_destroy_tracked_overlays(void)
+{
+	int id, ret, defers;
+
+	if (overlay_first_id < 0)
+		return;
+
+	/* try until no defers */
+	do {
+		defers = 0;
+		/* remove in reverse order */
+		for (id = MAX_SELFTEST_OVERLAYS - 1; id >= 0; id--) {
+			if (!(overlay_id_bits[BIT_WORD(id)] & BIT_MASK(id)))
+				continue;
+
+			ret = of_overlay_destroy(id + overlay_first_id);
+			if (ret != 0) {
+				defers++;
+				pr_warn("%s: overlay destroy failed for #%d\n",
+					__func__, id + overlay_first_id);
+				continue;
+			}
+
+			overlay_id_bits[BIT_WORD(id)] &= ~BIT_MASK(id);
+		}
+	} while (defers > 0);
+}
+
 static int of_selftest_apply_overlay(int selftest_nr, int overlay_nr,
 		int *overlay_id)
 {
@@ -1136,6 +1191,7 @@ static int of_selftest_apply_overlay(int selftest_nr, int overlay_nr,
 		goto out;
 	}
 	id = ret;
+	of_selftest_track_overlay(id);
 
 	ret = 0;
 
@@ -1349,6 +1405,7 @@ static void of_selftest_overlay_6(void)
 			return;
 		}
 		ov_id[i] = ret;
+		of_selftest_track_overlay(ov_id[i]);
 	}
 
 	for (i = 0; i < 2; i++) {
@@ -1373,6 +1430,7 @@ static void of_selftest_overlay_6(void)
 						PDEV_OVERLAY));
 			return;
 		}
+		of_selftest_untrack_overlay(ov_id[i]);
 	}
 
 	for (i = 0; i < 2; i++) {
@@ -1417,6 +1475,7 @@ static void of_selftest_overlay_8(void)
 			return;
 		}
 		ov_id[i] = ret;
+		of_selftest_track_overlay(ov_id[i]);
 	}
 
 	/* now try to remove first overlay (it should fail) */
@@ -1439,6 +1498,7 @@ static void of_selftest_overlay_8(void)
 						PDEV_OVERLAY));
 			return;
 		}
+		of_selftest_untrack_overlay(ov_id[i]);
 	}
 
 	selftest(1, "overlay test %d passed\n", 8);
@@ -1861,6 +1921,8 @@ static void __init of_selftest_overlay(void)
 	of_selftest_overlay_i2c_cleanup();
 #endif
 
+	of_selftest_destroy_tracked_overlays();
+
 out:
 	of_node_put(bus_np);
 }
-- 
1.7.12

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
