From: js1304@gmail.com
Subject: [PATCH v2 2/5] mm/slub: query dynamic DEBUG_PAGEALLOC setting
Date: Thu, 11 Feb 2016 13:04:58 +0900
Message-ID: <1455163501-9341-3-git-send-email-iamjoonsoo.kim@lge.com>
References: <1455163501-9341-1-git-send-email-iamjoonsoo.kim@lge.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1455163501-9341-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Christian Borntraeger <borntraeger@de.ibm.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Takashi Iwai <tiwai@suse.com>, Chris Metcalf <cmetcalf@ezchip.com>, Christoph Lameter <cl@linux.com>, linux-api@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
List-Id: linux-api@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

We can disable debug_pagealloc processing even if the code is compiled
with CONFIG_DEBUG_PAGEALLOC. This patch changes the code to query
whether it is enabled or not in runtime.

v2: clean up code, per Christian.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/slub.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 606488b..a1874c2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -250,11 +250,10 @@ static inline void *get_freepointer_safe(struct kmem_cache *s, void *object)
 {
 	void *p;
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
+	if (!debug_pagealloc_enabled())
+		return get_freepointer(s, object);
+
 	probe_kernel_read(&p, (void **)(object + s->offset), sizeof(p));
-#else
-	p = get_freepointer(s, object);
-#endif
 	return p;
 }
 
-- 
1.9.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
