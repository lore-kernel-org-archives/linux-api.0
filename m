From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 12/13] Remove AT_VECTOR_SIZE_ARCH on x86
Date: Mon, 14 Sep 2015 15:50:46 -0700
Message-ID: <1442271047-4908-13-git-send-email-palmer@dabbelt.com>
References: <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
 <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
Sender: linux-arch-owner@vger.kernel.org
To: arnd@arndb.de, dhowells@redhat.com
Cc: viro@zeniv.linux.org.uk, ast@plumgrid.com, aishchuk@linux.vnet.ibm.com, aarcange@redhat.com, akpm@linux-foundation.org, luto@kernel.org, acme@kernel.org, bhe@redhat.com, 3chas3@gmail.com, chris@zankel.net, dave@sr71.net, dyoung@redhat.com, drysdale@google.com, davem@davemloft.net, ebiederm@xmission.com, geoff@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com, mingo@kernel.org, iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org, josh@joshtriplett.org, kexec@lists.infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, mathieu.desnoyers@efficios.com, jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de, tomi.valkeinen@ti.com, vgoyal@redhat.com, x86@kernel.org, Palmer Dabbelt <palmer@dabbelt.com>
List-Id: linux-api@vger.kernel.org

It looks like there aren't actually users of this macro anywhere:

 * The kernel doesn't use it on x86 because we don't suppor ELF FDPIC.

 * The only Google results point to LMKL patches, both the one that
   wrote this (from 2010) and my patch to hide it behind __KERNEL__.

 * I grep'd through all the source tarballs on my machine, and the
   only packages that matched were the kernel and crui (which copied a
   PPC kernel header).

Since I'm not sure how to actually provide the right answer (if I
understand correctly, CONFIG_IA32_EMULATION is not __i386__), the only
thing I can think of to do is to just remove the definition.

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>
---
 arch/x86/include/uapi/asm/auxvec.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/x86/include/uapi/asm/auxvec.h b/arch/x86/include/uapi/asm/auxvec.h
index 77203ac352de..1316b4c35425 100644
--- a/arch/x86/include/uapi/asm/auxvec.h
+++ b/arch/x86/include/uapi/asm/auxvec.h
@@ -9,11 +9,4 @@
 #endif
 #define AT_SYSINFO_EHDR		33
 
-/* entries in ARCH_DLINFO: */
-#if defined(CONFIG_IA32_EMULATION) || !defined(CONFIG_X86_64)
-# define AT_VECTOR_SIZE_ARCH 2
-#else /* else it's non-compat x86-64 */
-# define AT_VECTOR_SIZE_ARCH 1
-#endif
-
 #endif /* _ASM_X86_AUXVEC_H */
-- 
2.4.6
