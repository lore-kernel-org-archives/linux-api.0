From: roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] audit.h: remove the macro AUDIT_ARCH_ARMEB definition
Date: Fri, 20 Mar 2015 12:55:29 +0800
Message-ID: <1426827329-27976-1-git-send-email-roy.qing.li@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

After 2f9783669 [ARM: 7412/1: audit: use only AUDIT_ARCH_ARM regardless
of endianness], no kernel user uses this macro;

Keeping this macro, only makes the compiling old version audit [before 
changeset 931 Improve ARM and AARCH64 support] success, but the audit
program can not work with the kernel after 2f9783669 still,
since no syscall entry is enabled for AUDIT_ARCH_ARMEB in kernel.

so remove it to force to use the latest audit program

Signed-off-by: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
other workaround is to define AUDIT_ARCH_ARMEB as AUDIT_ARCH_ARM,
but it seems very strange

 include/uapi/linux/audit.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index d3475e1..125aa49 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -351,7 +351,6 @@ enum {
 #define AUDIT_ARCH_AARCH64	(EM_AARCH64|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
 #define AUDIT_ARCH_ALPHA	(EM_ALPHA|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
 #define AUDIT_ARCH_ARM		(EM_ARM|__AUDIT_ARCH_LE)
-#define AUDIT_ARCH_ARMEB	(EM_ARM)
 #define AUDIT_ARCH_CRIS		(EM_CRIS|__AUDIT_ARCH_LE)
 #define AUDIT_ARCH_FRV		(EM_FRV)
 #define AUDIT_ARCH_I386		(EM_386|__AUDIT_ARCH_LE)
-- 
2.1.0
