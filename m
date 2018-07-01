From: Thomas Lindroth <thomas.lindroth@gmail.com>
Subject: [REGRESSION] "Locked" and "Pss" in /proc/*/smaps are the same
Date: Sun, 1 Jul 2018 20:31:30 +0200
Message-ID: <69eb77f7-c8cc-fdee-b44f-ad7e522b8467@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: dancol@google.com
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

While looking around in /proc on my v4.14.52 system I noticed that
all processes got a lot of "Locked" memory in /proc/*/smaps. A lot
more memory than a regular user can usually lock with mlock().

commit 493b0e9d945fa9dfe96be93ae41b4ca4b6fdb317 (v4.14-rc1) seems
to have changed the behavior of "Locked".

commit 493b0e9d945fa9dfe96be93ae41b4ca4b6fdb317
Author: Daniel Colascione <dancol@google.com>
Date:   Wed Sep 6 16:25:08 2017 -0700

    mm: add /proc/pid/smaps_rollup

Before that commit the code was like this. Notice the VM_LOCKED
check.

seq_printf(m,
           "Size:           %8lu kB\n"
           "Rss:            %8lu kB\n"
           "Pss:            %8lu kB\n"
           "Shared_Clean:   %8lu kB\n"
           "Shared_Dirty:   %8lu kB\n"
           "Private_Clean:  %8lu kB\n"
           "Private_Dirty:  %8lu kB\n"
           "Referenced:     %8lu kB\n"
           "Anonymous:      %8lu kB\n"
           "LazyFree:       %8lu kB\n"
           "AnonHugePages:  %8lu kB\n"
           "ShmemPmdMapped: %8lu kB\n"
           "Shared_Hugetlb: %8lu kB\n"
           "Private_Hugetlb: %7lu kB\n"
           "Swap:           %8lu kB\n"
           "SwapPss:        %8lu kB\n"
           "KernelPageSize: %8lu kB\n"
           "MMUPageSize:    %8lu kB\n"
           "Locked:         %8lu kB\n",
           (vma->vm_end - vma->vm_start) >> 10,
           mss.resident >> 10,
           (unsigned long)(mss.pss >> (10 + PSS_SHIFT)),
           mss.shared_clean  >> 10,
           mss.shared_dirty  >> 10,
           mss.private_clean >> 10,
           mss.private_dirty >> 10,
           mss.referenced >> 10,
           mss.anonymous >> 10,
           mss.lazyfree >> 10,
           mss.anonymous_thp >> 10,
           mss.shmem_thp >> 10,
           mss.shared_hugetlb >> 10,
           mss.private_hugetlb >> 10,
           mss.swap >> 10,
           (unsigned long)(mss.swap_pss >> (10 + PSS_SHIFT)),
           vma_kernel_pagesize(vma) >> 10,
           vma_mmu_pagesize(vma) >> 10,
           (vma->vm_flags & VM_LOCKED) ?
                (unsigned long)(mss.pss >> (10 + PSS_SHIFT)) : 0);

After that commit Locked is now the same as Pss. This looks like a
mistake.

seq_printf(m,
           "Rss:            %8lu kB\n"
           "Pss:            %8lu kB\n"
           "Shared_Clean:   %8lu kB\n"
           "Shared_Dirty:   %8lu kB\n"
           "Private_Clean:  %8lu kB\n"
           "Private_Dirty:  %8lu kB\n"
           "Referenced:     %8lu kB\n"
           "Anonymous:      %8lu kB\n"
           "LazyFree:       %8lu kB\n"
           "AnonHugePages:  %8lu kB\n"
           "ShmemPmdMapped: %8lu kB\n"
           "Shared_Hugetlb: %8lu kB\n"
           "Private_Hugetlb: %7lu kB\n"
           "Swap:           %8lu kB\n"
           "SwapPss:        %8lu kB\n"
           "Locked:         %8lu kB\n",
           mss->resident >> 10,
           (unsigned long)(mss->pss >> (10 + PSS_SHIFT)),
           mss->shared_clean  >> 10,
           mss->shared_dirty  >> 10,
           mss->private_clean >> 10,
           mss->private_dirty >> 10,
           mss->referenced >> 10,
           mss->anonymous >> 10,
           mss->lazyfree >> 10,
           mss->anonymous_thp >> 10,
           mss->shmem_thp >> 10,
           mss->shared_hugetlb >> 10,
           mss->private_hugetlb >> 10,
           mss->swap >> 10,
           (unsigned long)(mss->swap_pss >> (10 + PSS_SHIFT)),
           (unsigned long)(mss->pss >> (10 + PSS_SHIFT)));

The latest git has changed a bit but the functionality is the
same.
