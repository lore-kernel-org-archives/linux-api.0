From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] memfd_create.2: Add description of MFD_HUGETLB (hugetlbfs) support
Date: Fri, 15 Sep 2017 14:43:05 -0700
Message-ID: <20170915214305.7148-1-mike.kravetz@oracle.com>
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

hugetlbfs support for memfd_create was recently merged by Linus and
should be in the Linux 4.14 release.  To request hugetlbfs support
a new memfd_create flag (MFD_HUGETLB) was added.

This patch documents the following commit:

commit 749df87bd7bee5a79cef073f5d032ddb2b211de8
Author: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Wed Sep 6 16:24:16 2017 -0700

    mm/shmem: add hugetlbfs support to memfd_create()

Signed-off-by: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 man2/memfd_create.2 | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/man2/memfd_create.2 b/man2/memfd_create.2
index 4dfd1bb2d..b61254bb8 100644
--- a/man2/memfd_create.2
+++ b/man2/memfd_create.2
@@ -100,6 +100,33 @@ If this flag is not set, the initial set of seals will be
 meaning that no other seals can be set on the file.
 .\" FIXME Why is the MFD_ALLOW_SEALING behavior not simply the default?
 .\" Is it worth adding some text explaining this?
+.TP
+.BR MFD_HUGETLB " (since Linux 4.14)"
+The anonymous file will be created in the hugetlbfs filesystem using
+huge pages.  See the Linux kernel source file
+.I Documentation/vm/hugetlbpage.txt
+for more information about hugetlbfs.  The hugetlbfs filesystem does
+not support file sealing operations.  Therefore, specifying both
+.B MFD_HUGETLB
+and
+.B MFD_ALLOW_SEALING
+will result in an error
+.RB (EINVAL)
+being returned.
+
+.TP
+.BR MFD_HUGE_2MB ", " MFD_HUGE_1GB ", " "..."
+Used in conjunction with
+.B MFD_HUGETLB
+to select alternative hugetlb page sizes (respectively, 2 MB, 1 GB, ...)
+on systems that support multiple hugetlb page sizes.  Definitions for known
+huge page sizes are included in the header file
+.I <sys/memfd.h>.
+
+For details on encoding huge page sizes not included in the header file,
+see the discussion of the similarly named constants in
+.BR mmap (2).
+
 .PP
 Unused bits in
 .I flags
-- 
2.13.5

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
