From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] mremap.2: Add description of old_size == 0 functionality
Date: Fri, 15 Sep 2017 14:37:45 -0700
Message-ID: <20170915213745.6821-1-mike.kravetz@oracle.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Since at least the 2.6 time frame, mremap would create a new mapping
of the same pages if 'old_size == 0'.  It would also leave the original
mapping.  This was used to create a 'duplicate mapping'.

Document the behavior and return codes.  But, also mention that the
functionality is deprecated and discourage its use.

A recent change was made to mremap so that an attempt to create a
duplicate a private mapping will fail.

commit dba58d3b8c5045ad89c1c95d33d01451e3964db7
Author: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Wed Sep 6 16:20:55 2017 -0700

    mm/mremap: fail map duplication attempts for private mappings

This return code is also documented here.

Signed-off-by: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 man2/mremap.2 | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/man2/mremap.2 b/man2/mremap.2
index 98643c640..98df7d5fa 100644
--- a/man2/mremap.2
+++ b/man2/mremap.2
@@ -58,6 +58,21 @@ may be provided; see the description of
 .B MREMAP_FIXED
 below.
 .PP
+If the value of \fIold_size\fP is zero, and \fIold_address\fP refers to
+a private anonymous mapping, then
+.BR mremap ()
+will create a new mapping of the same pages. \fInew_size\fP
+will be the size of the new mapping and the location of the new mapping
+may be specified with \fInew_address\fP, see the description of
+.B MREMAP_FIXED
+below.  If a new mapping is requested via this method, then the
+.B MREMAP_MAYMOVE
+flag must also be specified.  This functionality is deprecated, and no
+new code should be written to use this feature.  A better method of
+obtaining multiple mappings of the same private anonymous memory is via the
+.BR memfd_create()
+system call.
+.PP
 In Linux the memory is divided into pages.
 A user process has (one or)
 several linear virtual memory segments.
@@ -174,7 +189,12 @@ and
 or
 .B MREMAP_FIXED
 was specified without also specifying
-.BR MREMAP_MAYMOVE .
+.BR MREMAP_MAYMOVE ;
+or \fIold_size\fP was zero and \fIold_address\fP does not refer to a
+private anonymous mapping;
+or \fIold_size\fP was zero and the
+.BR MREMAP_MAYMOVE
+flag was not specified.
 .TP
 .B ENOMEM
 The memory area cannot be expanded at the current virtual address, and the
@@ -210,6 +230,7 @@ if the area cannot be populated.
 .BR brk (2),
 .BR getpagesize (2),
 .BR getrlimit (2),
+.BR memfd_create(2),
 .BR mlock (2),
 .BR mmap (2),
 .BR sbrk (2),
-- 
2.13.5
