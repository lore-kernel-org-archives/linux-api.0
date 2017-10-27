From: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFC v2 1/4] mm/mempolicy: Fix get_nodes() mask miscalculation
Date: Fri, 27 Oct 2017 18:14:22 +0800
Message-ID: <1509099265-30868-2-git-send-email-xieyisheng1@huawei.com>
References: <1509099265-30868-1-git-send-email-xieyisheng1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509099265-30868-1-git-send-email-xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, salls-b3bnyZ7c9ISVc3sceRu5cw@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tanxiaojun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

It appears there is a nodemask miscalculation in the get_nodes()
function in mm/mempolicy.c.  This bug has two effects:

1. It is impossible to specify a length 1 nodemask.
2. It is impossible to specify a nodemask containing the last node.

Brent have submmit a patch before v2.6.12, however, Andi revert his
changed for ABI problem. I just resent this patch as RFC, for do not
clear about what's the problem Andi have met.

As manpage of set_mempolicy, If the value of maxnode is zero, the
nodemask argument is ignored. but we should not ignore the nodemask
when maxnode is 1.

Signed-off-by: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/mempolicy.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index a2af6d5..613e9d0 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1265,7 +1265,6 @@ static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
 	unsigned long nlongs;
 	unsigned long endmask;
 
-	--maxnode;
 	nodes_clear(*nodes);
 	if (maxnode == 0 || !nmask)
 		return 0;
-- 
1.7.12.4
