From: john.hubbard@gmail.com
Subject: [PATCH v3] mmap.2: MAP_FIXED updated documentation
Date: Mon,  4 Dec 2017 19:12:57 -0800
Message-ID: <20171205031257.14407-1-jhubbard@nvidia.com>
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: linux-man <linux-man@vger.kernel.org>, linux-api@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Jann Horn <jannh@google.com>, Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Cyril Hrubis <chrubis@suse.cz>, Michal Hocko <mhocko@suse.com>, John Hubbard <jhubbard@nvidia.com>
List-Id: linux-api@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

Previously, MAP_FIXED was "discouraged", due to portability
issues with the fixed address. In fact, there are other, more
serious issues. Also, in some limited cases, this option can
be used safely.

Expand the documentation to discuss both the hazards, and how
to use it safely.

Some of the wording is lifted from Matthew Wilcox's review
(the "Portability issues" section).

Suggested-by: Matthew Wilcox <willy@infradead.org>
Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---

Changes since v2:

    -- Fixed up the "how to use safely" example, in response
       to Mike Rapoport's review.

    -- Changed the alignment requirement from system page
       size, to SHMLBA. This was inspired by (but not yet
       recommended by) Cyril Hrubis' review.

    -- Formatting: underlined /proc/<pid>/maps 

Changes since v1:

    -- Covered topics recommended by Matthew Wilcox
       and Jann Horn, in their recent review: the hazards
       of overwriting pre-exising mappings, and some notes
       about how to use MAP_FIXED safely.

    -- Rewrote the commit description accordingly.

 man2/mmap.2 | 47 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/man2/mmap.2 b/man2/mmap.2
index 385f3bfd5..0db8fad80 100644
--- a/man2/mmap.2
+++ b/man2/mmap.2
@@ -212,7 +212,9 @@ Don't interpret
 .I addr
 as a hint: place the mapping at exactly that address.
 .I addr
-must be a multiple of the page size.
+must be a multiple of SHMLBA (<sys/shm.h>), which in turn is either
+the system page size (on many architectures) or a multiple of the system
+page size (on some architectures).
 If the memory region specified by
 .I addr
 and
@@ -222,8 +224,47 @@ part of the existing mapping(s) will be discarded.
 If the specified address cannot be used,
 .BR mmap ()
 will fail.
-Because requiring a fixed address for a mapping is less portable,
-the use of this option is discouraged.
+.IP
+This option is extremely hazardous (when used on its own) and moderately
+non-portable.
+.IP
+Portability issues: a process's memory map may change significantly from one
+run to the next, depending on library versions, kernel versions and random
+numbers.
+.IP
+Hazards: this option forcibly removes pre-existing mappings, making it easy
+for a multi-threaded process to corrupt its own address space.
+.IP
+For example, thread A looks through
+.I /proc/<pid>/maps
+and locates an available
+address range, while thread B simultaneously acquires part or all of that same
+address range. Thread A then calls mmap(MAP_FIXED), effectively overwriting
+thread B's mapping.
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
+Given the above limitations, one of the very few ways to use this option
+safely is: mmap() an enclosing region, without specifying MAP_FIXED.
+Then, within that region, call mmap(MAP_FIXED) to suballocate regions
+within the enclosing region. This avoids both the portability problem
+(because the first mmap call lets the kernel pick the address), and the
+address space corruption problem (because implicit calls to mmap will
+not affect the already-mapped enclosing region).
+.IP
+Newer kernels
+(Linux 4.16 and later) have a
+.B MAP_FIXED_SAFE
+option that avoids the corruption problem; if available, MAP_FIXED_SAFE
+should be preferred over MAP_FIXED.
 .TP
 .B MAP_GROWSDOWN
 This flag is used for stacks.
-- 
2.15.1
