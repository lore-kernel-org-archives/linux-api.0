From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 12/13] Hide AT_VECTOR_SIZE_ARCH behind #ifdef __KERNEL__
Date: Wed,  9 Sep 2015 14:08:21 -0700
Message-ID: <1441832902-28993-13-git-send-email-palmer@dabbelt.com>
References: <2644177.lVCYzIBfPW@wuerfel>
 <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de
Cc: 3chas3@gmail.com, hpa@zytor.com, mingo@redhat.com, plagnioj@jcrosoft.com, jikos@kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-atm-general@lists.sourceforge.net, linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, tglx@linutronix.de, tomi.valkeinen@ti.com, x86@kernel.org, Palmer Dabbelt <palmer@dabbelt.com>
List-Id: linux-api@vger.kernel.org

I think this actually isn't a good idea, but I can't find anything
outside of the kernel that's using this so I'm going to hide it.

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>
---
 arch/x86/include/uapi/asm/auxvec.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/uapi/asm/auxvec.h b/arch/x86/include/uapi/asm/auxvec.h
index 77203ac352de..88e5fa6d97e7 100644
--- a/arch/x86/include/uapi/asm/auxvec.h
+++ b/arch/x86/include/uapi/asm/auxvec.h
@@ -9,11 +9,13 @@
 #endif
 #define AT_SYSINFO_EHDR		33
 
+#ifdef __KERNEL__
 /* entries in ARCH_DLINFO: */
 #if defined(CONFIG_IA32_EMULATION) || !defined(CONFIG_X86_64)
 # define AT_VECTOR_SIZE_ARCH 2
 #else /* else it's non-compat x86-64 */
 # define AT_VECTOR_SIZE_ARCH 1
 #endif
+#endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_AUXVEC_H */
-- 
2.4.6
