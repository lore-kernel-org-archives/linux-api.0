From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH v7 8/9] ARM: add seccomp syscall
Date: Mon, 23 Jun 2014 14:58:12 -0700
Message-ID: <1403560693-21809-9-git-send-email-keescook@chromium.org>
References: <1403560693-21809-1-git-send-email-keescook@chromium.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403560693-21809-1-git-send-email-keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Julien Tinnes <jln-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Wires up the new seccomp syscall.

Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 arch/arm/include/uapi/asm/unistd.h |    1 +
 arch/arm/kernel/calls.S            |    1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/include/uapi/asm/unistd.h b/arch/arm/include/uapi/asm/unistd.h
index ba94446c72d9..e21b4a069701 100644
--- a/arch/arm/include/uapi/asm/unistd.h
+++ b/arch/arm/include/uapi/asm/unistd.h
@@ -409,6 +409,7 @@
 #define __NR_sched_setattr		(__NR_SYSCALL_BASE+380)
 #define __NR_sched_getattr		(__NR_SYSCALL_BASE+381)
 #define __NR_renameat2			(__NR_SYSCALL_BASE+382)
+#define __NR_seccomp			(__NR_SYSCALL_BASE+383)
 
 /*
  * This may need to be greater than __NR_last_syscall+1 in order to
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index 8f51bdcdacbb..bea85f97f363 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -392,6 +392,7 @@
 /* 380 */	CALL(sys_sched_setattr)
 		CALL(sys_sched_getattr)
 		CALL(sys_renameat2)
+		CALL(sys_seccomp)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
-- 
1.7.9.5
