From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [REGRESSION] "Locked" and "Pss" in /proc/*/smaps are the same
Date: Tue, 3 Jul 2018 09:36:45 +0200
Message-ID: <ebf6c7fb-fec3-6a26-544f-710ed193c154@suse.cz>
References: <69eb77f7-c8cc-fdee-b44f-ad7e522b8467@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <69eb77f7-c8cc-fdee-b44f-ad7e522b8467@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Lindroth <thomas.lindroth@gmail.com>, dancol@google.com, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
List-Id: linux-api@vger.kernel.org

+CC

On 07/01/2018 08:31 PM, Thomas Lindroth wrote:
> While looking around in /proc on my v4.14.52 system I noticed that
> all processes got a lot of "Locked" memory in /proc/*/smaps. A lot
> more memory than a regular user can usually lock with mlock().
> 
> commit 493b0e9d945fa9dfe96be93ae41b4ca4b6fdb317 (v4.14-rc1) seems
> to have changed the behavior of "Locked".
> 
> commit 493b0e9d945fa9dfe96be93ae41b4ca4b6fdb317
> Author: Daniel Colascione <dancol@google.com>
> Date:   Wed Sep 6 16:25:08 2017 -0700
> 
>     mm: add /proc/pid/smaps_rollup
> 
> Before that commit the code was like this. Notice the VM_LOCKED
> check.
> 
> seq_printf(m,
>            "Size:           %8lu kB\n"
>            "Rss:            %8lu kB\n"
>            "Pss:            %8lu kB\n"
>            "Shared_Clean:   %8lu kB\n"
>            "Shared_Dirty:   %8lu kB\n"
>            "Private_Clean:  %8lu kB\n"
>            "Private_Dirty:  %8lu kB\n"
>            "Referenced:     %8lu kB\n"
>            "Anonymous:      %8lu kB\n"
>            "LazyFree:       %8lu kB\n"
>            "AnonHugePages:  %8lu kB\n"
>            "ShmemPmdMapped: %8lu kB\n"
>            "Shared_Hugetlb: %8lu kB\n"
>            "Private_Hugetlb: %7lu kB\n"
>            "Swap:           %8lu kB\n"
>            "SwapPss:        %8lu kB\n"
>            "KernelPageSize: %8lu kB\n"
>            "MMUPageSize:    %8lu kB\n"
>            "Locked:         %8lu kB\n",
>            (vma->vm_end - vma->vm_start) >> 10,
>            mss.resident >> 10,
>            (unsigned long)(mss.pss >> (10 + PSS_SHIFT)),
>            mss.shared_clean  >> 10,
>            mss.shared_dirty  >> 10,
>            mss.private_clean >> 10,
>            mss.private_dirty >> 10,
>            mss.referenced >> 10,
>            mss.anonymous >> 10,
>            mss.lazyfree >> 10,
>            mss.anonymous_thp >> 10,
>            mss.shmem_thp >> 10,
>            mss.shared_hugetlb >> 10,
>            mss.private_hugetlb >> 10,
>            mss.swap >> 10,
>            (unsigned long)(mss.swap_pss >> (10 + PSS_SHIFT)),
>            vma_kernel_pagesize(vma) >> 10,
>            vma_mmu_pagesize(vma) >> 10,
>            (vma->vm_flags & VM_LOCKED) ?
>                 (unsigned long)(mss.pss >> (10 + PSS_SHIFT)) : 0);
> 
> After that commit Locked is now the same as Pss. This looks like a
> mistake.
> 
> seq_printf(m,
>            "Rss:            %8lu kB\n"
>            "Pss:            %8lu kB\n"
>            "Shared_Clean:   %8lu kB\n"
>            "Shared_Dirty:   %8lu kB\n"
>            "Private_Clean:  %8lu kB\n"
>            "Private_Dirty:  %8lu kB\n"
>            "Referenced:     %8lu kB\n"
>            "Anonymous:      %8lu kB\n"
>            "LazyFree:       %8lu kB\n"
>            "AnonHugePages:  %8lu kB\n"
>            "ShmemPmdMapped: %8lu kB\n"
>            "Shared_Hugetlb: %8lu kB\n"
>            "Private_Hugetlb: %7lu kB\n"
>            "Swap:           %8lu kB\n"
>            "SwapPss:        %8lu kB\n"
>            "Locked:         %8lu kB\n",
>            mss->resident >> 10,
>            (unsigned long)(mss->pss >> (10 + PSS_SHIFT)),
>            mss->shared_clean  >> 10,
>            mss->shared_dirty  >> 10,
>            mss->private_clean >> 10,
>            mss->private_dirty >> 10,
>            mss->referenced >> 10,
>            mss->anonymous >> 10,
>            mss->lazyfree >> 10,
>            mss->anonymous_thp >> 10,
>            mss->shmem_thp >> 10,
>            mss->shared_hugetlb >> 10,
>            mss->private_hugetlb >> 10,
>            mss->swap >> 10,
>            (unsigned long)(mss->swap_pss >> (10 + PSS_SHIFT)),
>            (unsigned long)(mss->pss >> (10 + PSS_SHIFT)));
> 
> The latest git has changed a bit but the functionality is the
> same.

----8<----
>From fa721521c981167c24ac8f4be446443d293d741e Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Tue, 3 Jul 2018 09:24:27 +0200
Subject: [PATCH] mm: fix Locked field in /proc/pid/smaps*

Thomas reports:

: While looking around in /proc on my v4.14.52 system I noticed that
: all processes got a lot of "Locked" memory in /proc/*/smaps. A lot
: more memory than a regular user can usually lock with mlock().
:
: commit 493b0e9d945fa9dfe96be93ae41b4ca4b6fdb317 (v4.14-rc1) seems
: to have changed the behavior of "Locked".
:
: Before that commit the code was like this. Notice the VM_LOCKED
: check.
:
:          (vma->vm_flags & VM_LOCKED) ?
:               (unsigned long)(mss.pss >> (10 + PSS_SHIFT)) : 0);
:
: After that commit Locked is now the same as Pss. This looks like a
: mistake.
:
: (unsigned long)(mss->pss >> (10 + PSS_SHIFT)));

Indeed, the commit has added mss->pss_locked with the correct value that
depends on VM_LOCKED, but forgot to actually use it. Fix it.

Fixes: 493b0e9d945f ("mm: add /proc/pid/smaps_rollup")
Reported-by: Thomas Lindroth <thomas.lindroth@gmail.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: stable@vger.kernel.org
---
 fs/proc/task_mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e9679016271f..dfd73a4616ce 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -831,7 +831,8 @@ static int show_smap(struct seq_file *m, void *v, int is_pid)
 		SEQ_PUT_DEC(" kB\nSwap:           ", mss->swap);
 		SEQ_PUT_DEC(" kB\nSwapPss:        ",
 						mss->swap_pss >> PSS_SHIFT);
-		SEQ_PUT_DEC(" kB\nLocked:         ", mss->pss >> PSS_SHIFT);
+		SEQ_PUT_DEC(" kB\nLocked:         ",
+						mss->pss_locked >> PSS_SHIFT);
 		seq_puts(m, " kB\n");
 	}
 	if (!rollup_mode) {
-- 
2.18.0
