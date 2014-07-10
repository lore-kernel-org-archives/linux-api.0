From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v10 05/11] ARM: add seccomp syscall
Date: Thu, 10 Jul 2014 11:40:25 -0700
Message-ID: <1405017631-27346-6-git-send-email-keescook@chromium.org>
References: <1405017631-27346-1-git-send-email-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405017631-27346-1-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Alexei Starovoitov <ast@plumgrid.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Wires up the new seccomp syscall.

Signed-off-by: Kees Cook <keescook@chromium.org>
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
