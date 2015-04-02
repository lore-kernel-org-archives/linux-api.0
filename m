From: David Rientjes <rientjes@google.com>
Subject: [patch -mm] mm, doc: cleanup and clarify munmap behavior for hugetlb
 memory fix
Date: Thu, 2 Apr 2015 15:50:15 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1504021547330.15536@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1503261621570.20009@chino.kir.corp.google.com> <alpine.LSU.2.11.1503291801400.1052@eggly.anvils> <alpine.DEB.2.10.1504021536210.15536@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.10.1504021536210.15536@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, Davide Libenzi <davidel@xmailserver.org>, Luiz Capitulino <lcapitulino@redhat.com>, Shuah Khan <shuahkh@osg.samsung.com>, Andrea Arcangeli <aarcange@redhat.com>, Joern Engel <joern@logfs.org>, Jianguo Wu <wujianguo@huawei.com>, Eric B Munson <emunson@akamai.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Don't only specify munmap(2) behavior with respect the hugetlb memory, all 
other syscalls get naturally aligned to the native page size of the 
processor.  Rather, pick out munmap(2) as a specific example.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/vm/hugetlbpage.txt | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/vm/hugetlbpage.txt b/Documentation/vm/hugetlbpage.txt
index 1270fb1..030977f 100644
--- a/Documentation/vm/hugetlbpage.txt
+++ b/Documentation/vm/hugetlbpage.txt
@@ -313,8 +313,11 @@ into /proc/sys/vm/hugetlb_shm_group.  It is possible for same or different
 applications to use any combination of mmaps and shm* calls, though the mount of
 filesystem will be required for using mmap calls without MAP_HUGETLB.
 
-When using munmap(2) to unmap hugetlb memory, the length specified must be
-hugepage aligned, otherwise it will fail with errno set to EINVAL.
+Syscalls that operate on memory backed by hugetlb pages only have their lengths
+aligned to the native page size of the processor; they will normally fail with
+errno set to EINVAL or exclude hugetlb pages that extend beyond the length if
+not hugepage aligned.  For example, munmap(2) will fail if memory is backed by
+a hugetlb page and the length is smaller than the hugepage size.
 
 
 Examples

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
