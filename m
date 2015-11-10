From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 13/14] Hide CONFIG_PHY_RAM_BASE_ADDRESS from userspace
Date: Mon,  9 Nov 2015 17:31:10 -0800
Message-ID: <1447119071-19392-14-git-send-email-palmer__31281.0318581343$1447119260$gmane$org@dabbelt.com>
References: <1446579994-9937-1-git-send-email-palmer@dabbelt.com>
 <1447119071-19392-1-git-send-email-palmer@dabbelt.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1447119071-19392-1-git-send-email-palmer@dabbelt.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: arnd@arndb.de, dhowells@redhat.com, peterz@infradead.org
Cc: viro@zeniv.linux.org.uk, ast@plumgrid.com, aishchuk@linux.vnet.ibm.com, aarcange@redhat.com, akpm@linux-foundation.org, luto@kernel.org, acme@kernel.org, bhe@redhat.com, 3chas3@gmail.com, chris@zankel.net, dave@sr71.net, dyoung@redhat.com, drysdale@google.com, davem@davemloft.net, ebiederm@xmission.com, geoff@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com, mingo@kernel.org, iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org, josh@joshtriplett.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, mathieu.desnoyers@efficios.com, jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de, tomi.valkeinen@ti.com, vgoyal@redhat.com, x86@kernel.org, Palmer Dabbelt <palmer@dabbelt.com>
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

