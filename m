From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V4] powerpc: add little endian flag to syscall_get_arch()
Date: Tue,  9 Dec 2014 15:37:07 -0500
Message-ID: <24fcd2ea2c7633152e74a7a92abab1dd1782745d.1418157273.git.rgb@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tonyj-l3A5Bk7waGM@public.gmane.org
List-Id: linux-api@vger.kernel.org

Since both ppc and ppc64 have LE variants which are now reported by uname, add
that flag (__AUDIT_ARCH_LE) to syscall_get_arch() and add AUDIT_ARCH_PPC64LE
variant.

Without this,  perf trace and auditctl fail.

Mainline kernel reports ppc64le (per a058801) but there is no matching
AUDIT_ARCH_PPC64LE.

Since 32-bit PPC LE is not supported by audit, don't advertise it in
AUDIT_ARCH_PPC* variants.

See:
	https://www.redhat.com/archives/linux-audit/2014-August/msg00082.html
	https://www.redhat.com/archives/linux-audit/2014-December/msg00004.html

Signed-off-by: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/powerpc/include/asm/syscall.h |    6 +++++-
 include/uapi/linux/audit.h         |    2 ++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/syscall.h b/arch/powerpc/include/asm/syscall.h
index 6fa2708..d1934e5 100644
--- a/arch/powerpc/include/asm/syscall.h
+++ b/arch/powerpc/include/asm/syscall.h
@@ -90,6 +90,10 @@ static inline void syscall_set_arguments(struct task_struct *task,
 
 static inline int syscall_get_arch(void)
 {
-	return is_32bit_task() ? AUDIT_ARCH_PPC : AUDIT_ARCH_PPC64;
+	int arch = is_32bit_task() ? AUDIT_ARCH_PPC : AUDIT_ARCH_PPC64;
+#ifdef __LITTLE_ENDIAN__
+	arch |= __AUDIT_ARCH_LE;
+#endif
+	return arch;
 }
 #endif	/* _ASM_SYSCALL_H */
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 4d100c8..d82beec 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -364,7 +364,9 @@ enum {
 #define AUDIT_ARCH_PARISC	(EM_PARISC)
 #define AUDIT_ARCH_PARISC64	(EM_PARISC|__AUDIT_ARCH_64BIT)
 #define AUDIT_ARCH_PPC		(EM_PPC)
+/* do not define AUDIT_ARCH_PPCLE since it is not supported by audit */
 #define AUDIT_ARCH_PPC64	(EM_PPC64|__AUDIT_ARCH_64BIT)
+#define AUDIT_ARCH_PPC64LE	(EM_PPC64|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
 #define AUDIT_ARCH_S390		(EM_S390)
 #define AUDIT_ARCH_S390X	(EM_S390|__AUDIT_ARCH_64BIT)
 #define AUDIT_ARCH_SH		(EM_SH)
-- 
1.7.1
