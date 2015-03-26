From: David Rientjes <rientjes@google.com>
Subject: [patch 1/2] mm, doc: cleanup and clarify munmap behavior for hugetlb
 memory
Date: Thu, 26 Mar 2015 16:23:21 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1503261621570.20009@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>
Cc: Davide Libenzi <davidel@xmailserver.org>, Luiz Capitulino <lcapitulino@redhat.com>, Shuah Khan <shuahkh@osg.samsung.com>, Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Joern Engel <joern@logfs.org>, Jianguo Wu <wujianguo@huawei.com>, Eric B Munson <emunson@akamai.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

munmap(2) of hugetlb memory requires a length that is hugepage aligned,
otherwise it may fail.  Add this to the documentation.

This also cleans up the documentation and separates it into logical
units: one part refers to MAP_HUGETLB and another part refers to
requirements for shared memory segments.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/vm/hugetlbpage.txt | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/Documentation/vm/hugetlbpage.txt b/Documentation/vm/hugetlbpage.txt
--- a/Documentation/vm/hugetlbpage.txt
+++ b/Documentation/vm/hugetlbpage.txt
@@ -289,15 +289,20 @@ file systems, write system calls are not.
 Regular chown, chgrp, and chmod commands (with right permissions) could be
 used to change the file attributes on hugetlbfs.
 
-Also, it is important to note that no such mount command is required if the
+Also, it is important to note that no such mount command is required if
 applications are going to use only shmat/shmget system calls or mmap with
-MAP_HUGETLB.  Users who wish to use hugetlb page via shared memory segment
-should be a member of a supplementary group and system admin needs to
-configure that gid into /proc/sys/vm/hugetlb_shm_group.  It is possible for
-same or different applications to use any combination of mmaps and shm*
-calls, though the mount of filesystem will be required for using mmap calls
-without MAP_HUGETLB.  For an example of how to use mmap with MAP_HUGETLB see
-map_hugetlb.c.
+MAP_HUGETLB.  For an example of how to use mmap with MAP_HUGETLB see map_hugetlb
+below.
+
+Users who wish to use hugetlb memory via shared memory segment should be a
+member of a supplementary group and system admin needs to configure that gid
+into /proc/sys/vm/hugetlb_shm_group.  It is possible for same or different
+applications to use any combination of mmaps and shm* calls, though the mount of
+filesystem will be required for using mmap calls without MAP_HUGETLB.
+
+When using munmap(2) to unmap hugetlb memory, the length specified must be
+hugepage aligned, otherwise it will fail with errno set to EINVAL.
+
 
 Examples
 ========
