From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v2 1/4] mm, documentation: clarify /proc/pid/status VmSwap limitations
Date: Fri, 27 Mar 2015 17:40:38 +0100
Message-ID: <1427474441-17708-2-git-send-email-vbabka@suse.cz>
References: <1427474441-17708-1-git-send-email-vbabka@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427474441-17708-1-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-mm@kvack.org, Jerome Marchand <jmarchan@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Randy Dunlap <rdunlap@infradead.org>, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Linux API <linux-api@vger.kernel.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Vlastimil Babka <vbabka@suse.cz>
List-Id: linux-api@vger.kernel.org

The documentation for /proc/pid/status does not mention that the value of
VmSwap counts only swapped out anonymous private pages and not shmem. This is
not obvious, so document this limitation.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 Documentation/filesystems/proc.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index a07ba61..d4f56ec 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -231,6 +231,8 @@ Table 1-2: Contents of the status files (as of 2.6.30-rc7)
  VmLib                       size of shared library code
  VmPTE                       size of page table entries
  VmSwap                      size of swap usage (the number of referred swapents)
+                             by anonymous private data (shmem swap usage is not
+                             included)
  Threads                     number of threads
  SigQ                        number of signals queued/max. number for queue
  SigPnd                      bitmap of pending signals for the thread
-- 
2.1.4
