From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH v5 1/6] mm, documentation: clarify /proc/pid/status VmSwap limitations for shmem
Date: Wed, 18 Nov 2015 10:29:31 +0100
Message-ID: <1447838976-17607-2-git-send-email-vbabka@suse.cz>
References: <1447838976-17607-1-git-send-email-vbabka@suse.cz>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447838976-17607-1-git-send-email-vbabka-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jerome Marchand <jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The documentation for /proc/pid/status does not mention that the value of
VmSwap counts only swapped out anonymous private pages, and not swapped out
pages of the underlying shmem objects (for shmem mappings). This is not
obvious, so document this limitation.

Signed-off-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Acked-by: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Acked-by: Jerome Marchand <jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 Documentation/filesystems/proc.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 402ab99..9f13b6e 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -238,7 +238,8 @@ Table 1-2: Contents of the status files (as of 4.1)
  VmLib                       size of shared library code
  VmPTE                       size of page table entries
  VmPMD                       size of second level page tables
- VmSwap                      size of swap usage (the number of referred swapents)
+ VmSwap                      amount of swap used by anonymous private data
+                             (shmem swap usage is not included)
  HugetlbPages                size of hugetlb memory portions
  Threads                     number of threads
  SigQ                        number of signals queued/max. number for queue
-- 
2.6.3
