From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 04/13] Always expose MAP_UNINITIALIZED to userspace
Date: Mon, 14 Sep 2015 15:50:38 -0700
Message-ID: <1442271047-4908-5-git-send-email-palmer__3474.70862693644$1442271381$gmane$org@dabbelt.com>
References: <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
 <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
Sender: linux-arch-owner@vger.kernel.org
To: arnd@arndb.de, dhowells@redhat.com
Cc: viro@zeniv.linux.org.uk, ast@plumgrid.com, aishchuk@linux.vnet.ibm.com, aarcange@redhat.com, akpm@linux-foundation.org, luto@kernel.org, acme@kernel.org, bhe@redhat.com, 3chas3@gmail.com, chris@zankel.net, dave@sr71.net, dyoung@redhat.com, drysdale@google.com, davem@davemloft.net, ebiederm@xmission.com, geoff@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com, mingo@kernel.org, iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org, josh@joshtriplett.org, kexec@lists.infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, mathieu.desnoyers@efficios.com, jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de, tomi.valkeinen@ti.com, vgoyal@redhat.com, x86@kernel.org, Palmer Dabbelt <palmer@dabbelt.com>
List-Id: linux-api@vger.kernel.org

This used to be hidden behind CONFIG_MMAP_ALLOW_UNINITIALIZED, so
userspace wouldn't actually ever see it be non-zero.  While I could
have kept hiding it, the man pages seem to indicate that
MAP_UNINITIALIZED should be visible:

  mmap(2)
  MAP_UNINITIALIZED (since Linux 2.6.33)
    Don't clear anonymous pages.  This flag is intended to improve
    performance on embedded devices.  This flag is honored only if the
    kernel was configured with the CONFIG_MMAP_ALLOW_UNINITIALIZED
    option.  Because of the security implications, that option is
    normally enabled only on embedded devices (i.e., devices where one
    has complete control of the contents of user memory).

and since the only time it shows up in my /usr/include is in this
header I believe this should have been visible to userspace (as
non-zero, which wouldn't do anything when or'd into the flags) all
along.

This change also applies to the xtensa version of this definition,
whic is the same as the generic one.

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>
---
 arch/xtensa/include/uapi/asm/mman.h    | 4 +---
 include/uapi/asm-generic/mman-common.h | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/xtensa/include/uapi/asm/mman.h b/arch/xtensa/include/uapi/asm/mman.h
index 201aec0e0446..2cbc1e717082 100644
--- a/arch/xtensa/include/uapi/asm/mman.h
+++ b/arch/xtensa/include/uapi/asm/mman.h
@@ -55,11 +55,9 @@
 #define MAP_NONBLOCK	0x20000		/* do not block on IO */
 #define MAP_STACK	0x40000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x80000		/* create a huge page mapping */
-#ifdef CONFIG_MMAP_ALLOW_UNINITIALIZED
+#ifndef MAP_UNINITIALIZED
 # define MAP_UNINITIALIZED 0x4000000	/* For anonymous mmap, memory could be
 					 * uninitialized */
-#else
-# define MAP_UNINITIALIZED 0x0		/* Don't support this flag */
 #endif
 
 /*
diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
index ddc3b36f1046..7aeeb12db193 100644
--- a/include/uapi/asm-generic/mman-common.h
+++ b/include/uapi/asm-generic/mman-common.h
@@ -19,10 +19,8 @@
 #define MAP_TYPE	0x0f		/* Mask for type of mapping */
 #define MAP_FIXED	0x10		/* Interpret addr exactly */
 #define MAP_ANONYMOUS	0x20		/* don't use a file */
-#ifdef CONFIG_MMAP_ALLOW_UNINITIALIZED
+#ifndef MAP_UNINITIALIZED
 # define MAP_UNINITIALIZED 0x4000000	/* For anonymous mmap, memory could be uninitialized */
-#else
-# define MAP_UNINITIALIZED 0x0		/* Don't support this flag */
 #endif
 
 #define MS_ASYNC	1		/* sync memory asynchronously */
-- 
2.4.6
