From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: [PATCH selftest fails!] m68k: Wire up execveat
Date: Sun, 21 Dec 2014 12:02:11 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1412211159410.7624@ayla.of.borg>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux/m68k <linux-m68k-cunTk1MwBs8S/qaLPR03pWD2FQJk+8+b@public.gmane.org>, Linux Kernel Development <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Check success of execveat(3, '../execveat', 0)... [OK]
Check success of execveat(5, 'execveat', 0)... [OK]
Check success of execveat(6, 'execveat', 0)... [OK]
Check success of execveat(-100, '/root/selftest-exec/exec/execveat', 0)... [OK]
Check success of execveat(99, '/root/selftest-exec/exec/execveat', 0)... [OK]
Check success of execveat(8, '', 4096)... [OK]
Check success of execveat(17, '', 4096)... [OK]
Check success of execveat(9, '', 4096)... [OK]
Check success of execveat(14, '', 4096)... [OK]
Check success of execveat(14, '', 4096)... [OK]
Check success of execveat(15, '', 4096)... [OK]
Check failure of execveat(8, '', 0) with ENOENT... [OK]
Check failure of execveat(8, '(null)', 4096) with EFAULT... [OK]
Check success of execveat(5, 'execveat.symlink', 0)... [OK]
Check success of execveat(6, 'execveat.symlink', 0)... [OK]
Check success of execveat(-100, '/root/selftest-exec/...xec/execveat.symlink', 0)... [OK]
Check success of execveat(10, '', 4096)... [OK]
Check success of execveat(10, '', 4352)... [OK]
Check failure of execveat(5, 'execveat.symlink', 256) with ELOOP... [OK]
Check failure of execveat(6, 'execveat.symlink', 256) with ELOOP... [OK]
Check failure of execveat(-100, '/root/selftest-exec/exec/execveat.symlink', 256) with ELOOP... [OK]
Check success of execveat(3, '../script', 0)... [OK]
Check success of execveat(5, 'script', 0)... [OK]
Check success of execveat(6, 'script', 0)... [OK]
Check success of execveat(-100, '/root/selftest-exec/exec/script', 0)... [OK]
Check success of execveat(13, '', 4096)... [OK]
Check success of execveat(13, '', 4352)... [OK]
Check failure of execveat(18, '', 4096) with ENOENT... [OK]
Check failure of execveat(7, 'script', 0) with ENOENT... [OK]
Check success of execveat(16, '', 4096)... [OK]
Check success of execveat(16, '', 4096)... [OK]
Check success of execveat(4, '../script', 0)... [OK]
Check success of execveat(4, 'script', 0)... [OK]
Check success of execveat(4, '../script', 0)... [OK]
Check failure of execveat(4, 'script', 0) with ENOENT... [OK]
Check failure of execveat(5, 'execveat', 65535) with EINVAL... [OK]
Check failure of execveat(5, 'no-such-file', 0) with ENOENT... [OK]
Check failure of execveat(6, 'no-such-file', 0) with ENOENT... [OK]
Check failure of execveat(-100, 'no-such-file', 0) with ENOENT... [OK]
Check failure of execveat(5, '', 4096) with EACCES... [OK]
Check failure of execveat(5, 'Makefile', 0) with EACCES... [OK]
Check failure of execveat(11, '', 4096) with EACCES... [OK]
Check failure of execveat(12, '', 4096) with EACCES... [OK]
Check failure of execveat(99, '', 4096) with EBADF... [OK]
Check failure of execveat(99, 'execveat', 0) with EBADF... [OK]
Check failure of execveat(8, 'execveat', 0) with ENOTDIR... [OK]
Invoke copy of 'execveat' via filename of length 4093:
Check success of execveat(19, '', 4096)... [OK]
Check success of execveat(5, 'xxxxxxxxxxxxxxxxxxxx...yyyyyyyyyyyyyyyyyyyy', 0)... [OK]
Invoke copy of 'script' via filename of length 4093:
Check success of execveat(20, '', 4096)... [OK]
/bin/sh: /dev/fd/5/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
 xxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
 xxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
 xxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
 xxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
 xxxxxxxxxxxxxxxxxxxxxxxxxx/yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy: File name too long
Check success of execveat(5, 'xxxxxxxxxxxxxxxxxxxx...yyyyyyyyyyyyyyyyyyyy', 0)... [FAIL] (child 792 exited with 126 not 127)
1 tests failed
make: *** [run_tests] Error 1

Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
---
The last test fails because of an unexpected exit code?

 arch/m68k/include/asm/unistd.h      | 2 +-
 arch/m68k/include/uapi/asm/unistd.h | 1 +
 arch/m68k/kernel/syscalltable.S     | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
index 75e75d7b1702fb64..244e0dbe45dbeda3 100644
--- a/arch/m68k/include/asm/unistd.h
+++ b/arch/m68k/include/asm/unistd.h
@@ -4,7 +4,7 @@
 #include <uapi/asm/unistd.h>
 
 
-#define NR_syscalls		355
+#define NR_syscalls		356
 
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
diff --git a/arch/m68k/include/uapi/asm/unistd.h b/arch/m68k/include/uapi/asm/unistd.h
index 2c1bec9a14b67da4..61fb6cb9d2ae3c66 100644
--- a/arch/m68k/include/uapi/asm/unistd.h
+++ b/arch/m68k/include/uapi/asm/unistd.h
@@ -360,5 +360,6 @@
 #define __NR_getrandom		352
 #define __NR_memfd_create	353
 #define __NR_bpf		354
+#define __NR_execveat		355
 
 #endif /* _UAPI_ASM_M68K_UNISTD_H_ */
diff --git a/arch/m68k/kernel/syscalltable.S b/arch/m68k/kernel/syscalltable.S
index 2ca219e184cd16e6..a0ec4303f2c8e57a 100644
--- a/arch/m68k/kernel/syscalltable.S
+++ b/arch/m68k/kernel/syscalltable.S
@@ -375,4 +375,5 @@ ENTRY(sys_call_table)
 	.long sys_getrandom
 	.long sys_memfd_create
 	.long sys_bpf
+	.long sys_execveat		/* 355 */
 
-- 
1.9.1
