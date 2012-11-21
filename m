From: Carlos O'Donell <carlos-v2tUB8YBRSi3e3T8WW9gsA@public.gmane.org>
Subject: [RFC] Preventing overlap between arch mman.h and asm-generic/mman.h
Date: Wed, 21 Nov 2012 15:42:38 -0500
Message-ID: <20121121204238.GA9125@lazarus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
List-Id: linux-api@vger.kernel.org

David,

Thanks for the great UAPI work. While working on glibc mman.h sync I had
the chance to look more closely at some of the UAPI headers.

Currently (3.7.0-rc6) sparc, powerpc, and tile are including mman-common.h,
but nothing in mman-common.h helps prevent the accidental definition of an
overlapping new constant value.

For example in mman.h powerpc defines:
 #define MAP_NORESERVE  0x40            /* don't reserve swap pages */
 #define MAP_LOCKED     0x80

If someone were to add a new MAP_* value in mman-common.h at 0x40 it
would conflict with the existing powerpc value. The powerpc maintainers
might not notice, and that's a bug.

I notice that someone is trying to avoid this kind of bug, because for
example the new MADV_HWPOISON was chosen as 100, which is higher than
any other MADV_* value for any architecture.

Rather than avoid the problem by spot-checking, would it be acceptable
to merge in some private macros that block out exactly which constants
are already in use as existing values for arches using UAPI headers?

Doing it this way would allow for the merged arches to more safely
include the asm-generic version of mman.h and start benefiting from new
constants without the usual maintenance cost (not to mention everyone
would start in lock-step going forward). Not to mention it simplifies
some of the glibc maintenance.

Rather than just talk about it here's a back-of-the-napkin sketch and a
patch:

* Merges asm-generic/mman-common.h back into asm-generic/mman.h
* Include asm-generic/mman.h instead of asm-generic/mman-common.h
  for powerpc, sparc, tile and parisc.
* Delete mman-common.h.
* Use internal placeholder macros for all existing uses of the 
  various constants in mman.h to avoid future overlap.

Is it only worth doing if *all* arches are included in the cleanup?

Is it worth loosing some bits for the benefit in maintenance (note that
bits can be got back through #undef reallocation in the arch header)?

Is this too ugly for the benefit?

Comments?

Notes: 
* Partly verified using a set of scripts to automate checking for
  macro defines matching regexp's and constant values.
* Build tested on parisc.

 arch/parisc/include/uapi/asm/mman.h    |   52 ++++++-----------
 arch/powerpc/include/uapi/asm/mman.h   |   16 +----
 arch/sparc/include/uapi/asm/mman.h     |   18 ++---
 arch/tile/include/uapi/asm/mman.h      |   22 ++-----
 include/uapi/asm-generic/mman-common.h |   58 -------------------
 include/uapi/asm-generic/mman.h        |   76 ++++++++++++++++++++++++-
 6 files changed, 118 insertions(+), 124 deletions(-)

diff --git a/arch/parisc/include/uapi/asm/mman.h b/arch/parisc/include/uapi/asm/mman.h
index 12219eb..79137d0 100644
--- a/arch/parisc/include/uapi/asm/mman.h
+++ b/arch/parisc/include/uapi/asm/mman.h
@@ -1,24 +1,30 @@
 #ifndef __PARISC_MMAN_H__
 #define __PARISC_MMAN_H__
 
-#define PROT_READ	0x1		/* page can be read */
-#define PROT_WRITE	0x2		/* page can be written */
-#define PROT_EXEC	0x4		/* page can be executed */
-#define PROT_SEM	0x8		/* page may be used for atomic ops */
-#define PROT_NONE	0x0		/* page can not be accessed */
-#define PROT_GROWSDOWN	0x01000000	/* mprotect flag: extend change to start of growsdown vma */
-#define PROT_GROWSUP	0x02000000	/* mprotect flag: extend change to end of growsup vma */
+#include <asm-generic/mman.h>
+
+/* The following constants don't match mman.h. */
+#undef MAP_TYPE
+#undef MAP_FIXED
+#undef MAP_ANONYMOUS
+#undef MAP_GROWSDOWN
+#undef MAP_POPULATE
+#undef MAP_NONBLOCK
+#undef MAP_STACK
+#undef MAP_HUGETLB
+#undef MS_ASYNC
+#undef MS_INVALIDATE
+#undef MS_SYNC
+#undef MADV_MERGEABLE
+#undef MADV_UNMERGEABLE
+#undef MADV_HUGEPAGE
+#undef MADV_NOHUGEPAGE
+#undef MADV_DONTDUMP
+#undef MADV_DODUMP
 
-#define MAP_SHARED	0x01		/* Share changes */
-#define MAP_PRIVATE	0x02		/* Changes are private */
 #define MAP_TYPE	0x03		/* Mask for type of mapping */
 #define MAP_FIXED	0x04		/* Interpret addr exactly */
 #define MAP_ANONYMOUS	0x10		/* don't use a file */
-
-#define MAP_DENYWRITE	0x0800		/* ETXTBSY */
-#define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
-#define MAP_LOCKED	0x2000		/* pages are locked */
-#define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_GROWSDOWN	0x8000		/* stack-like segment */
 #define MAP_POPULATE	0x10000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x20000		/* do not block on IO */
@@ -29,23 +35,9 @@
 #define MS_ASYNC	2		/* sync memory asynchronously */
 #define MS_INVALIDATE	4		/* invalidate the caches */
 
-#define MCL_CURRENT	1		/* lock all current mappings */
-#define MCL_FUTURE	2		/* lock all future mappings */
-
-#define MADV_NORMAL     0               /* no further special treatment */
-#define MADV_RANDOM     1               /* expect random page references */
-#define MADV_SEQUENTIAL 2               /* expect sequential page references */
-#define MADV_WILLNEED   3               /* will need these pages */
-#define MADV_DONTNEED   4               /* don't need these pages */
 #define MADV_SPACEAVAIL 5               /* insure that resources are reserved */
 #define MADV_VPS_PURGE  6               /* Purge pages from VM page cache */
 #define MADV_VPS_INHERIT 7              /* Inherit parents page size */
-
-/* common/generic parameters */
-#define MADV_REMOVE	9		/* remove these pages & resources */
-#define MADV_DONTFORK	10		/* don't inherit across fork */
-#define MADV_DOFORK	11		/* do inherit across fork */
-
 /* The range 12-64 is reserved for page size specification. */
 #define MADV_4K_PAGES   12              /* Use 4K pages  */
 #define MADV_16K_PAGES  14              /* Use 16K pages */
@@ -55,19 +47,15 @@
 #define MADV_4M_PAGES   22              /* Use 4 Megabyte pages */
 #define MADV_16M_PAGES  24              /* Use 16 Megabyte pages */
 #define MADV_64M_PAGES  26              /* Use 64 Megabyte pages */
-
 #define MADV_MERGEABLE   65		/* KSM may merge identical pages */
 #define MADV_UNMERGEABLE 66		/* KSM may not merge identical pages */
-
 #define MADV_HUGEPAGE	67		/* Worth backing with hugepages */
 #define MADV_NOHUGEPAGE	68		/* Not worth backing with hugepages */
-
 #define MADV_DONTDUMP   69		/* Explicity exclude from the core dump,
 					   overrides the coredump filter bits */
 #define MADV_DODUMP	70		/* Clear the MADV_NODUMP flag */
 
 /* compatibility flags */
-#define MAP_FILE	0
 #define MAP_VARIABLE	0
 
 #endif /* __PARISC_MMAN_H__ */
diff --git a/arch/powerpc/include/uapi/asm/mman.h b/arch/powerpc/include/uapi/asm/mman.h
index 6ea26df..ec1c84f 100644
--- a/arch/powerpc/include/uapi/asm/mman.h
+++ b/arch/powerpc/include/uapi/asm/mman.h
@@ -7,8 +7,13 @@
 #ifndef _UAPI_ASM_POWERPC_MMAN_H
 #define _UAPI_ASM_POWERPC_MMAN_H
 
-#include <asm-generic/mman-common.h>
+#include <asm-generic/mman.h>
 
+/* The following constants don't match mman.h. */
+#undef MAP_LOCKED
+#undef MAP_NORESERVE 
+#undef MCL_CURRENT
+#undef MCL_FUTURE
 
 #define PROT_SAO	0x10		/* Strong Access Ordering */
 
@@ -16,16 +21,7 @@
 #define MAP_NORESERVE   0x40            /* don't reserve swap pages */
 #define MAP_LOCKED	0x80
 
-#define MAP_GROWSDOWN	0x0100		/* stack-like segment */
-#define MAP_DENYWRITE	0x0800		/* ETXTBSY */
-#define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
-
 #define MCL_CURRENT     0x2000          /* lock all currently mapped pages */
 #define MCL_FUTURE      0x4000          /* lock all additions to address space */
 
-#define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
-#define MAP_NONBLOCK	0x10000		/* do not block on IO */
-#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
-#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
-
 #endif /* _UAPI_ASM_POWERPC_MMAN_H */
diff --git a/arch/sparc/include/uapi/asm/mman.h b/arch/sparc/include/uapi/asm/mman.h
index 0b14df3..f46bb61 100644
--- a/arch/sparc/include/uapi/asm/mman.h
+++ b/arch/sparc/include/uapi/asm/mman.h
@@ -1,10 +1,16 @@
 #ifndef _UAPI__SPARC_MMAN_H__
 #define _UAPI__SPARC_MMAN_H__
 
-#include <asm-generic/mman-common.h>
+#include <asm-generic/mman.h>
 
-/* SunOS'ified... */
+/* The following constants don't match mman.h. */
+#undef MAP_NORESERVE
+#undef MAP_LOCKED
+#undef MAP_GROWSDOWN
+#undef MCL_CURRENT
+#undef MCL_FUTURE
 
+/* SunOS'ified... */
 #define MAP_RENAME      MAP_ANONYMOUS   /* In SunOS terminology */
 #define MAP_NORESERVE   0x40            /* don't reserve swap pages */
 #define MAP_INHERIT     0x80            /* SunOS doesn't do this, but... */
@@ -12,16 +18,8 @@
 #define _MAP_NEW        0x80000000      /* Binary compatibility is fun... */
 
 #define MAP_GROWSDOWN	0x0200		/* stack-like segment */
-#define MAP_DENYWRITE	0x0800		/* ETXTBSY */
-#define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
 
 #define MCL_CURRENT     0x2000          /* lock all currently mapped pages */
 #define MCL_FUTURE      0x4000          /* lock all additions to address space */
 
-#define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
-#define MAP_NONBLOCK	0x10000		/* do not block on IO */
-#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
-#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
-
-
 #endif /* _UAPI__SPARC_MMAN_H__ */
diff --git a/arch/tile/include/uapi/asm/mman.h b/arch/tile/include/uapi/asm/mman.h
index 81b8fc3..5d1fa24 100644
--- a/arch/tile/include/uapi/asm/mman.h
+++ b/arch/tile/include/uapi/asm/mman.h
@@ -15,27 +15,23 @@
 #ifndef _ASM_TILE_MMAN_H
 #define _ASM_TILE_MMAN_H
 
-#include <asm-generic/mman-common.h>
+#include <asm-generic/mman.h>
 #include <arch/chip.h>
 
-/* Standard Linux flags */
+/* The following constants don't match mman.h. */
+#undef MAP_POPULATE
+#undef MAP_NONBLOCK
+#undef MAP_STACK
+#undef MAP_LOCKED
+#undef MAP_NORESERVE
+#undef MAP_HUGETLB
 
+/* Standard Linux flags */
 #define MAP_POPULATE	0x0040		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x0080		/* do not block on IO */
-#define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_STACK	MAP_GROWSDOWN	/* provide convenience alias */
 #define MAP_LOCKED	0x0200		/* pages are locked */
 #define MAP_NORESERVE	0x0400		/* don't check for reservations */
-#define MAP_DENYWRITE	0x0800		/* ETXTBSY */
-#define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
 #define MAP_HUGETLB	0x4000		/* create a huge page mapping */
 
-
-/*
- * Flags for mlockall
- */
-#define MCL_CURRENT	1		/* lock all current mappings */
-#define MCL_FUTURE	2		/* lock all future mappings */
-
-
 #endif /* _ASM_TILE_MMAN_H */
diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
deleted file mode 100644
index d030d2c..0000000
--- a/include/uapi/asm-generic/mman-common.h
+++ /dev/null
@@ -1,58 +0,0 @@
-#ifndef __ASM_GENERIC_MMAN_COMMON_H
-#define __ASM_GENERIC_MMAN_COMMON_H
-
-/*
- Author: Michael S. Tsirkin <mst-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Mellanox Technologies Ltd.
- Based on: asm-xxx/mman.h
-*/
-
-#define PROT_READ	0x1		/* page can be read */
-#define PROT_WRITE	0x2		/* page can be written */
-#define PROT_EXEC	0x4		/* page can be executed */
-#define PROT_SEM	0x8		/* page may be used for atomic ops */
-#define PROT_NONE	0x0		/* page can not be accessed */
-#define PROT_GROWSDOWN	0x01000000	/* mprotect flag: extend change to start of growsdown vma */
-#define PROT_GROWSUP	0x02000000	/* mprotect flag: extend change to end of growsup vma */
-
-#define MAP_SHARED	0x01		/* Share changes */
-#define MAP_PRIVATE	0x02		/* Changes are private */
-#define MAP_TYPE	0x0f		/* Mask for type of mapping */
-#define MAP_FIXED	0x10		/* Interpret addr exactly */
-#define MAP_ANONYMOUS	0x20		/* don't use a file */
-#ifdef CONFIG_MMAP_ALLOW_UNINITIALIZED
-# define MAP_UNINITIALIZED 0x4000000	/* For anonymous mmap, memory could be uninitialized */
-#else
-# define MAP_UNINITIALIZED 0x0		/* Don't support this flag */
-#endif
-
-#define MS_ASYNC	1		/* sync memory asynchronously */
-#define MS_INVALIDATE	2		/* invalidate the caches */
-#define MS_SYNC		4		/* synchronous memory sync */
-
-#define MADV_NORMAL	0		/* no further special treatment */
-#define MADV_RANDOM	1		/* expect random page references */
-#define MADV_SEQUENTIAL	2		/* expect sequential page references */
-#define MADV_WILLNEED	3		/* will need these pages */
-#define MADV_DONTNEED	4		/* don't need these pages */
-
-/* common parameters: try to keep these consistent across architectures */
-#define MADV_REMOVE	9		/* remove these pages & resources */
-#define MADV_DONTFORK	10		/* don't inherit across fork */
-#define MADV_DOFORK	11		/* do inherit across fork */
-#define MADV_HWPOISON	100		/* poison a page for testing */
-#define MADV_SOFT_OFFLINE 101		/* soft offline page for testing */
-
-#define MADV_MERGEABLE   12		/* KSM may merge identical pages */
-#define MADV_UNMERGEABLE 13		/* KSM may not merge identical pages */
-
-#define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
-#define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
-
-#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
-					   overrides the coredump filter bits */
-#define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
-
-/* compatibility flags */
-#define MAP_FILE	0
-
-#endif /* __ASM_GENERIC_MMAN_COMMON_H */
diff --git a/include/uapi/asm-generic/mman.h b/include/uapi/asm-generic/mman.h
index 32c8bd6..f960982 100644
--- a/include/uapi/asm-generic/mman.h
+++ b/include/uapi/asm-generic/mman.h
@@ -1,9 +1,31 @@
 #ifndef __ASM_GENERIC_MMAN_H
 #define __ASM_GENERIC_MMAN_H
 
-#include <asm-generic/mman-common.h>
+#define PROT_READ	0x1		/* page can be read */
+#define PROT_WRITE	0x2		/* page can be written */
+#define PROT_EXEC	0x4		/* page can be executed */
+#define PROT_SEM	0x8		/* page may be used for atomic ops */
+#define PROT_NONE	0x0		/* page can not be accessed */
+#define PROT_GROWSDOWN	0x01000000	/* mprotect flag: extend change to start of growsdown vma */
+#define PROT_GROWSUP	0x02000000	/* mprotect flag: extend change to end of growsup vma */
 
+#define MAP_SHARED	0x01		/* Share changes */
+#define MAP_PRIVATE	0x02		/* Changes are private */
+#define __MAP_PRIVATE1	0x03		/* Do not use. Private to parisc. */
+#define __MAP_PRIVATE2	0x04		/* Do not use. Private to parisc. */
+#define MAP_TYPE	0x0f		/* Mask for type of mapping */
+#define MAP_FIXED	0x10		/* Interpret addr exactly */
+#define MAP_ANONYMOUS	0x20		/* don't use a file */
+#ifdef CONFIG_MMAP_ALLOW_UNINITIALIZED
+# define MAP_UNINITIALIZED 0x4000000	/* For anonymous mmap, memory could be uninitialized */
+#else
+# define MAP_UNINITIALIZED 0x0		/* Don't support this flag */
+#endif
+#define __MAP_PRIVATE3	0x0040		/* Do not use. Private to sparc, powerpc and tile. */
+#define __MAP_PRIVATE4	0x0080		/* Do not use. Private to sparc, powerpc and tile. */
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
+#define __MAP_PRIVATE5	0x0200		/* Do not use. Private to sparc and tile. */
+#define __MAP_PRIVATE6	0x0400		/* Do not use. Private to tile. */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
 #define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
 #define MAP_LOCKED	0x2000		/* pages are locked */
@@ -12,8 +34,60 @@
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
 #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x40000		/* create a huge page mapping */
+#define __MAP_PRIVATE7	0x80000		/* Do not use. Private to parisc. */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
+#define __MCL_PRIVATE1	0x2000		/* Do not use. Private to powerpc and sparc. */
+#define __MCL_PRIVATE2	0x4000		/* Do not use. Private to powerpc and sparc. */
+
+#define MS_ASYNC	1		/* sync memory asynchronously */
+#define MS_INVALIDATE	2		/* invalidate the caches */
+#define MS_SYNC		4		/* synchronous memory sync */
+
+#define MADV_NORMAL	0		/* no further special treatment */
+#define MADV_RANDOM	1		/* expect random page references */
+#define MADV_SEQUENTIAL	2		/* expect sequential page references */
+#define MADV_WILLNEED	3		/* will need these pages */
+#define MADV_DONTNEED	4		/* don't need these pages */
+#define __MADV_PRIVATE1 5		/* Do not use. Private to parisc. */
+#define __MADV_PRIVATE2 6		/* Do not use. Private to parisc. */
+#define __MADV_PRIVATE3 7		/* Do not use. Private to parisc. */
+#define __MADV_UNUSED1  8		/* Unused on all arches. Free for use. */
+/* common parameters: try to keep these consistent across architectures */
+#define MADV_REMOVE	9		/* remove these pages & resources */
+#define MADV_DONTFORK	10		/* don't inherit across fork */
+#define MADV_DOFORK	11		/* do inherit across fork */
+#define MADV_MERGEABLE   12		/* KSM may merge identical pages */
+#define MADV_UNMERGEABLE 13		/* KSM may not merge identical pages */
+
+#define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
+#define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
+
+#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
+					   overrides the coredump filter bits */
+#define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
+#define __MADV_PRIVATE4	18		/* Do not use. Private to parisc. */
+#define __MADV_PRIVATE5	20		/* Do not use. Private to parisc. */
+#define __MADV_UNUSED2  21		/* Unused on all arches. Free for use. */
+#define __MADV_PRIVATE6	22		/* Do not use. Private to parisc. */
+#define __MADV_UNUSED3  23		/* Unused on all arches. Free for use. */
+#define __MADV_PRIVATE7	24		/* Do not use. Private to parisc. */
+#define __MADV_UNUSED4  25		/* Unused on all arches. Free for use. */
+#define __MADV_PRIVATE8	26		/* Do not use. Private to parisc. */
+/* Values from 27-64 are unused by all arches. */
+#define __MADV_PRIVATE9	65		/* Do not use. Private to parisc. */
+#define __MADV_PRIVATE10 66		/* Do not use. Private to parisc. */
+#define __MADV_PRIVATE11 67		/* Do not use. Private to parisc. */
+#define __MADV_PRIVATE12 68		/* Do not use. Private to parisc. */
+#define __MADV_PRIVATE13 69		/* Do not use. Private to parisc. */
+#define __MADV_PRIVATE14 70		/* Do not use. Private to parisc. */
+/* Values from 71-99 are unused by all arches. */
+#define MADV_HWPOISON	100		/* poison a page for testing */
+#define MADV_SOFT_OFFLINE 101		/* soft offline page for testing */
+
+/* compatibility flags */
+#define MAP_FILE	0
+#define __MAP_PRIVATE8	1		/* Do not use. Private to parisc. */
 
 #endif /* __ASM_GENERIC_MMAN_H */
