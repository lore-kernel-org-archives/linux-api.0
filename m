From: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Subject: [PATCH v2] next: openrisc: Fix build
Date: Fri, 26 Sep 2014 09:05:39 -0700
Message-ID: <1411747539-28308-1-git-send-email-linux@roeck-us.net>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonas Bonn <jonas-A9uVI2HLR7kOP4wsBPIw7w@public.gmane.org>
Cc: linux-ZwoEplunGu2h2975yA52AaxOck334EZe@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stefan Kristiansson <stefan.kristiansson-MbMCFXIvDHJFcC0YU169RA@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

openrisc:defconfig fails to build in next-20140926 with the following error.

In file included from arch/openrisc/kernel/signal.c:31:0:
./arch/openrisc/include/asm/syscall.h: In function 'syscall_get_arch':
./arch/openrisc/include/asm/syscall.h:77:9: error: 'EM_OPENRISC' undeclared

Fix by moving EM_OPENRISC to include/uapi/linux/elf-em.h.

Fixes: ce5d112827e5 ("ARCH: AUDIT: implement syscall_get_arch for all arches")
Cc: Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Stefan Kristiansson <stefan.kristiansson-MbMCFXIvDHJFcC0YU169RA@public.gmane.org>
Cc: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Signed-off-by: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
---
v2: Only move EM_OPENRISC.

Another possible solution for the problem would be to include asm/elf.h
in arch/openrisc/kernel/signal.c. I had actually submitted a patch with
that fix back in August (maybe that is where I remembered the problem from).
Wonder what happened with that patch.

Would it make sense to drop EM_OR32 and replace it with EM_OPENRISC where
it is used ? binutils seems to suggest that EM_OPENRISC is the "official"
definition.

 arch/openrisc/include/uapi/asm/elf.h | 3 +--
 include/uapi/linux/elf-em.h          | 1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/openrisc/include/uapi/asm/elf.h b/arch/openrisc/include/uapi/asm/elf.h
index f02ea58..8884276 100644
--- a/arch/openrisc/include/uapi/asm/elf.h
+++ b/arch/openrisc/include/uapi/asm/elf.h
@@ -55,9 +55,8 @@ typedef elf_greg_t elf_gregset_t[ELF_NGREG];
 /* A placeholder; OR32 does not have fp support yes, so no fp regs for now.  */
 typedef unsigned long elf_fpregset_t;
 
-/* This should be moved to include/linux/elf.h */
+/* EM_OPENRISC is defined in linux/elf-em.h */
 #define EM_OR32         0x8472
-#define EM_OPENRISC     92     /* OpenRISC 32-bit embedded processor */
 
 /*
  * These are used to set parameters in the core dumps.
diff --git a/include/uapi/linux/elf-em.h b/include/uapi/linux/elf-em.h
index 01529bd..aa90bc9 100644
--- a/include/uapi/linux/elf-em.h
+++ b/include/uapi/linux/elf-em.h
@@ -32,6 +32,7 @@
 #define EM_V850		87	/* NEC v850 */
 #define EM_M32R		88	/* Renesas M32R */
 #define EM_MN10300	89	/* Panasonic/MEI MN10300, AM33 */
+#define EM_OPENRISC     92     /* OpenRISC 32-bit embedded processor */
 #define EM_BLACKFIN     106     /* ADI Blackfin Processor */
 #define EM_TI_C6000	140	/* TI C6X DSPs */
 #define EM_AARCH64	183	/* ARM 64 bit */
-- 
1.9.1
