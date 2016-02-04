From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 3/5] sound: query dynamic DEBUG_PAGEALLOC setting
Date: Thu,  4 Feb 2016 14:56:24 +0900
Message-ID: <1454565386-10489-4-git-send-email-iamjoonsoo.kim@lge.com>
References: <1454565386-10489-1-git-send-email-iamjoonsoo.kim@lge.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1454565386-10489-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Christian Borntraeger <borntraeger@de.ibm.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Takashi Iwai <tiwai@suse.com>, Chris Metcalf <cmetcalf@ezchip.com>, Christoph Lameter <cl@linux.com>, linux-api@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
List-Id: linux-api@vger.kernel.org

We can disable debug_pagealloc processing even if the code is complied
with CONFIG_DEBUG_PAGEALLOC. This patch changes the code to query
whether it is enabled or not in runtime.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 sound/drivers/pcsp/pcsp.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/sound/drivers/pcsp/pcsp.c b/sound/drivers/pcsp/pcsp.c
index 27e25bb..72e2d00 100644
--- a/sound/drivers/pcsp/pcsp.c
+++ b/sound/drivers/pcsp/pcsp.c
@@ -14,6 +14,7 @@
 #include <linux/input.h>
 #include <linux/delay.h>
 #include <linux/bitops.h>
+#include <linux/mm.h>
 #include "pcsp_input.h"
 #include "pcsp.h"
 
@@ -148,11 +149,11 @@ static int alsa_card_pcsp_init(struct device *dev)
 		return err;
 	}
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
 	/* Well, CONFIG_DEBUG_PAGEALLOC makes the sound horrible. Lets alert */
-	printk(KERN_WARNING "PCSP: CONFIG_DEBUG_PAGEALLOC is enabled, "
-	       "which may make the sound noisy.\n");
-#endif
+	if (debug_pagealloc_enabled()) {
+		printk(KERN_WARNING "PCSP: CONFIG_DEBUG_PAGEALLOC is enabled, "
+		       "which may make the sound noisy.\n");
+	}
 
 	return 0;
 }
-- 
1.9.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
