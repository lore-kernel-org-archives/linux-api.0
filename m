From: Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 13/14] Hide CONFIG_PHY_RAM_BASE_ADDRESS from userspace
Date: Mon,  9 Nov 2015 17:31:10 -0800
Message-ID: <1447119071-19392-14-git-send-email-palmer@dabbelt.com>
References: <1446579994-9937-1-git-send-email-palmer@dabbelt.com>
 <1447119071-19392-1-git-send-email-palmer@dabbelt.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447119071-19392-1-git-send-email-palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: arnd-r2nGTMty4D4@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org, aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, 3chas3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chris-YvXeqwSYzG2sTnJN9+BGXg@public.gmane.org, dave-gkUM19QKKo4@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org, jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xtensa-PjhNF2WwrV/0Sa2dR60CXw@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, tomi.valkeinen-l0cyMroinI0@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This feels a bit odd, but I couldn't really come up with a better way to
do it.  There already appears to be a workaround for this macro not
being defined in userspace, so I figured I'd better leave that in place,
since someone is probably using it.

The result is that unless you include <asm/fixed_code.h> before
<uapi/asm/fixed_code.h> then you'll get the wrong offsets.  The only
user of <uapi/asm/fixed_code.h> is currently <asm/fixed_code.h>, so it's
at least safe for now.  There's a CPP error in there to check for this.
---
 arch/blackfin/include/asm/fixed_code.h      |  6 +++++
 arch/blackfin/include/uapi/asm/fixed_code.h | 35 ++++++++++++++++-------------
 2 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/arch/blackfin/include/asm/fixed_code.h b/arch/blackfin/include/asm/fixed_code.h
index bc330f0..7e03b9b 100644
--- a/arch/blackfin/include/asm/fixed_code.h
+++ b/arch/blackfin/include/asm/fixed_code.h
@@ -9,6 +9,12 @@
 #ifndef __BFIN_ASM_FIXED_CODE_H__
 #define __BFIN_ASM_FIXED_CODE_H__
 
+#ifdef CONFIG_PHY_RAM_BASE_ADDRESS
+#define CONFIG_PHY_RAM_BASE_ADDRESS 0x0
+#endif
+
+#define PHY_RAM_BASE_ADDRESS CONFIG_PHY_RAM_BASE_ADDRESS
+
 #include <uapi/asm/fixed_code.h>
 
 #ifndef __ASSEMBLY__
diff --git a/arch/blackfin/include/uapi/asm/fixed_code.h b/arch/blackfin/include/uapi/asm/fixed_code.h
index 3bef1dc..50b70a0 100644
--- a/arch/blackfin/include/uapi/asm/fixed_code.h
+++ b/arch/blackfin/include/uapi/asm/fixed_code.h
@@ -10,29 +10,32 @@
 #ifndef _UAPI__BFIN_ASM_FIXED_CODE_H__
 #define _UAPI__BFIN_ASM_FIXED_CODE_H__
 
-
-#ifndef CONFIG_PHY_RAM_BASE_ADDRESS
-#define CONFIG_PHY_RAM_BASE_ADDRESS	0x0
+#ifndef PHY_RAM_BASE_ADDRESS
+#ifdef __KERNEL__
+#error "Don't include <uapi/asm/fixed_code.h>, include <asm/fixed_code.h>"
+#else
+#define PHY_RAM_BASE_ADDRESS	0x0
+#endif
 #endif
 
-#define FIXED_CODE_START	(CONFIG_PHY_RAM_BASE_ADDRESS + 0x400)
+#define FIXED_CODE_START	(PHY_RAM_BASE_ADDRESS + 0x400)
 
-#define SIGRETURN_STUB		(CONFIG_PHY_RAM_BASE_ADDRESS + 0x400)
+#define SIGRETURN_STUB		(PHY_RAM_BASE_ADDRESS + 0x400)
 
-#define ATOMIC_SEQS_START	(CONFIG_PHY_RAM_BASE_ADDRESS + 0x410)
+#define ATOMIC_SEQS_START	(PHY_RAM_BASE_ADDRESS + 0x410)
 
-#define ATOMIC_XCHG32		(CONFIG_PHY_RAM_BASE_ADDRESS + 0x410)
-#define ATOMIC_CAS32		(CONFIG_PHY_RAM_BASE_ADDRESS + 0x420)
-#define ATOMIC_ADD32		(CONFIG_PHY_RAM_BASE_ADDRESS + 0x430)
-#define ATOMIC_SUB32		(CONFIG_PHY_RAM_BASE_ADDRESS + 0x440)
-#define ATOMIC_IOR32		(CONFIG_PHY_RAM_BASE_ADDRESS + 0x450)
-#define ATOMIC_AND32		(CONFIG_PHY_RAM_BASE_ADDRESS + 0x460)
-#define ATOMIC_XOR32		(CONFIG_PHY_RAM_BASE_ADDRESS + 0x470)
+#define ATOMIC_XCHG32		(PHY_RAM_BASE_ADDRESS + 0x410)
+#define ATOMIC_CAS32		(PHY_RAM_BASE_ADDRESS + 0x420)
+#define ATOMIC_ADD32		(PHY_RAM_BASE_ADDRESS + 0x430)
+#define ATOMIC_SUB32		(PHY_RAM_BASE_ADDRESS + 0x440)
+#define ATOMIC_IOR32		(PHY_RAM_BASE_ADDRESS + 0x450)
+#define ATOMIC_AND32		(PHY_RAM_BASE_ADDRESS + 0x460)
+#define ATOMIC_XOR32		(PHY_RAM_BASE_ADDRESS + 0x470)
 
-#define ATOMIC_SEQS_END		(CONFIG_PHY_RAM_BASE_ADDRESS + 0x480)
+#define ATOMIC_SEQS_END		(PHY_RAM_BASE_ADDRESS + 0x480)
 
-#define SAFE_USER_INSTRUCTION   (CONFIG_PHY_RAM_BASE_ADDRESS + 0x480)
+#define SAFE_USER_INSTRUCTION   (PHY_RAM_BASE_ADDRESS + 0x480)
 
-#define FIXED_CODE_END		(CONFIG_PHY_RAM_BASE_ADDRESS + 0x490)
+#define FIXED_CODE_END		(PHY_RAM_BASE_ADDRESS + 0x490)
 
 #endif /* _UAPI__BFIN_ASM_FIXED_CODE_H__ */
-- 
2.4.10
