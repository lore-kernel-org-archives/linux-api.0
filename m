From: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 0/3] some fixes and clean up for mempolicy
Date: Fri, 17 Nov 2017 09:37:01 +0800
Message-ID: <1510882624-44342-1-git-send-email-xieyisheng1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, salls-b3bnyZ7c9ISVc3sceRu5cw@public.gmane.org, ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tanxiaojun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patchset is triggered by Xiojun's report of ltp test fail[1],
and I have sent a patch to resolve it by check nodes_empty of new_nodes[2].

The new version is to follow Vlastimil's suggestion, which fix by checking
the new_nodes value in function get_nodes. And I just split them to small
patches for easy to review and discussion. For more detail, please look
into each patches.

Change logs of v3:
 * remove patch get_nodes's mask miscalculation
 * check whether node is empty after AND current task node, and then nodes
   which have memory.

Change logs of v2:
 * fix get_nodes's mask miscalculation
 * remove redundant check in get_nodes
 * fix the check of nodemask from user - per Vlastimil

Any comment and complain is welome.

Thanks
Yisheng Xie

[1] https://patchwork.kernel.org/patch/10012005/
[2] https://patchwork.kernel.org/patch/10013329/

Yisheng Xie (3):
  mm/mempolicy: remove redundant check in get_nodes
  mm/mempolicy: fix the check of nodemask from user
  mm/mempolicy: add nodes_empty check in SYSC_migrate_pages

 mm/mempolicy.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

-- 
1.8.3.1
