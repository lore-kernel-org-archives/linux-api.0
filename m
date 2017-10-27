From: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFC v2 2/4] mm/mempolicy: remove redundant check in get_nodes
Date: Fri, 27 Oct 2017 18:14:23 +0800
Message-ID: <1509099265-30868-3-git-send-email-xieyisheng1@huawei.com>
References: <1509099265-30868-1-git-send-email-xieyisheng1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509099265-30868-1-git-send-email-xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, salls-b3bnyZ7c9ISVc3sceRu5cw@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tanxiaojun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

We have already checked whether maxnode is a page worth of bits, by:
    maxnode > PAGE_SIZE*BITS_PER_BYTE

So no need to check it once more.

Signed-off-by: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/mempolicy.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 613e9d0..3b51bb3 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1280,8 +1280,6 @@ static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
 	/* When the user specified more nodes than supported just check
 	   if the non supported part is all zero. */
 	if (nlongs > BITS_TO_LONGS(MAX_NUMNODES)) {
-		if (nlongs > PAGE_SIZE/sizeof(long))
-			return -EINVAL;
 		for (k = BITS_TO_LONGS(MAX_NUMNODES); k < nlongs; k++) {
 			unsigned long t;
 			if (get_user(t, nmask + k))
-- 
1.7.12.4
