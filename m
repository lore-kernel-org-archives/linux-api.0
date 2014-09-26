From: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Subject: [PATCH] next: openrisc: Fix build
Date: Fri, 26 Sep 2014 06:54:15 -0700
Message-ID: <1411739655-4715-1-git-send-email-linux@roeck-us.net>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonas Bonn <jonas-A9uVI2HLR7kOP4wsBPIw7w@public.gmane.org>
Cc: linux-ZwoEplunGu2h2975yA52AaxOck334EZe@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stefan Kristiansson <stefan.kristiansson-MbMCFXIvDHJFcC0YU169RA@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

openrisc:defconfig fails to build in next-20140926 with the following error.

In file included from arch/openrisc/kernel/signal.c:31:0:
./arch/openrisc/include/asm/syscall.h: In function 'syscall_get_arch':
./arch/openrisc/include/asm/syscall.h:77:9: error: 'EM_OPENRISC' undeclared

Fix by moving EM_OPENRISC and EM_OR32 to include/uapi/linux/elf-em.h.

Fixes: ce5d112827e5 ("ARCH: AUDIT: implement syscall_get_arch for all arches")
Cc: Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Stefan Kristiansson <stefan.kristiansson-MbMCFXIvDHJFcC0YU169RA@public.gmane.org>
Cc: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Signed-off-by: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
---
Based Stefan's note. No idea if it is the correct fix.

 arch/openrisc/include/uapi/asm/elf.h | 4 +---
 include/uapi/linux/elf-em.h          | 2 ++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/openrisc/include/uapi/asm/elf.h b/arch/openrisc/include/uapi/asm/elf.h
index f02ea58..e75fdce 100644
--- a/arch/openrisc/include/uapi/asm/elf.h
+++ b/arch/openrisc/include/uapi/asm/elf.h
@@ -55,9 +55,7 @@ typedef elf_greg_t elf_gregset_t[ELF_NGREG];
 /* A placeholder; OR32 does not have fp support yes, so no fp regs for now.  */
 typedef unsigned long elf_fpregset_t;
 
-/* This should be moved to include/linux/elf.h */
-#define EM_OR32         0x8472
-#define EM_OPENRISC     92     /* OpenRISC 32-bit embedded processor */
+/* EM_OPENRISC and EM_OR32 defined in linux/elf-em.h	*/
 
 /*
  * These are used to set parameters in the core dumps.
diff --git a/include/uapi/linux/elf-em.h b/include/uapi/linux/elf-em.h
index 01529bd..c5d3948 100644
--- a/include/uapi/linux/elf-em.h
+++ b/include/uapi/linux/elf-em.h
@@ -32,11 +32,13 @@
 #define EM_V850		87	/* NEC v850 */
 #define EM_M32R		88	/* Renesas M32R */
 #define EM_MN10300	89	/* Panasonic/MEI MN10300, AM33 */
+#define EM_OPENRISC     92     /* OpenRISC 32-bit embedded processor */
 #define EM_BLACKFIN     106     /* ADI Blackfin Processor */
 #define EM_TI_C6000	140	/* TI C6X DSPs */
 #define EM_AARCH64	183	/* ARM 64 bit */
 #define EM_FRV		0x5441	/* Fujitsu FR-V */
 #define EM_AVR32	0x18ad	/* Atmel AVR32 */
+#define EM_OR32         0x8472	/* OpenRISC, alternate */
 
 /*
  * This is an interim value that we will use until the committee comes
-- 
1.9.1
