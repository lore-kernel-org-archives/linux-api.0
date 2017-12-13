From: Michal Hocko <mhocko@kernel.org>
Subject: [PATCH 2/2] mmap.2: MAP_FIXED updated documentation
Date: Wed, 13 Dec 2017 10:31:10 +0100
Message-ID: <20171213093110.3550-2-mhocko@kernel.org>
References: <20171213092550.2774-1-mhocko@kernel.org>
 <20171213093110.3550-1-mhocko@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20171213093110.3550-1-mhocko@kernel.org>
Sender: owner-linux-mm@kvack.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: linux-api@vger.kernel.org, Khalid Aziz <khalid.aziz@oracle.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Florian Weimer <fweimer@redhat.com>, John Hubbard <jhubbard@nvidia.com>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Cyril Hrubis <chrubis@suse.cz>, Pavel Machek <pavel@ucw.cz>, Michal Hocko <mhocko@suse.com>
List-Id: linux-api@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

    -- Expand the documentation to discuss the hazards in
       enough detail to allow avoiding them.

    -- Mention the upcoming MAP_FIXED_SAFE flag.

    -- Enhance the alignment requirement slightly.

CC: Michael Ellerman <mpe@ellerman.id.au>
CC: Jann Horn <jannh@google.com>
CC: Matthew Wilcox <willy@infradead.org>
CC: Michal Hocko <mhocko@kernel.org>
CC: Mike Rapoport <rppt@linux.vnet.ibm.com>
CC: Cyril Hrubis <chrubis@suse.cz>
CC: Pavel Machek <pavel@ucw.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 man2/mmap.2 | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/man2/mmap.2 b/man2/mmap.2
index 02d391697ce6..cb8789daec2d 100644
--- a/man2/mmap.2
+++ b/man2/mmap.2
@@ -212,8 +212,9 @@ Don't interpret
 .I addr
 as a hint: place the mapping at exactly that address.
 .I addr
-must be a multiple of the page size.
-If the memory region specified by
+must be suitably aligned: for most architectures a multiple of page
+size is sufficient; however, some architectures may impose additional
+restrictions. If the memory region specified by
 .I addr
 and
 .I len
@@ -226,6 +227,33 @@ Software that aspires to be portable should use this option with care, keeping
 in mind that the exact layout of a process' memory map is allowed to change
 significantly between kernel versions, C library versions, and operating system
 releases.
+.IP
+Furthermore, this option is extremely hazardous (when used on its own), because
+it forcibly removes pre-existing mappings, making it easy for a multi-threaded
+process to corrupt its own address space.
+.IP
+For example, thread A looks through
+.I /proc/<pid>/maps
+and locates an available
+address range, while thread B simultaneously acquires part or all of that same
+address range. Thread A then calls mmap(MAP_FIXED), effectively overwriting
+the mapping that thread B created.
+.IP
+Thread B need not create a mapping directly; simply making a library call
+that, internally, uses
+.I dlopen(3)
+to load some other shared library, will
+suffice. The dlopen(3) call will map the library into the process's address
+space. Furthermore, almost any library call may be implemented using this
+technique.
+Examples include brk(2), malloc(3), pthread_create(3), and the PAM libraries
+(http://www.linux-pam.org).
+.IP
+Newer kernels
+(Linux 4.16 and later) have a
+.B MAP_FIXED_SAFE
+option that avoids the corruption problem; if available, MAP_FIXED_SAFE
+should be preferred over MAP_FIXED.
 .TP
 .BR MAP_FIXED_SAFE " (since Linux 4.16)"
 Similar to MAP_FIXED with respect to the
-- 
2.15.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
