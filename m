From: David Drysdale <drysdale@google.com>
Subject: [PATCHv9 4/5] sparc: Hook up execveat system call.
Date: Wed, 19 Nov 2014 17:27:51 +0000
Message-ID: <1416418072-18639-5-git-send-email-drysdale@google.com>
References: <1416418072-18639-1-git-send-email-drysdale@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1416418072-18639-1-git-send-email-drysdale@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@aerifal.cx>, Christoph Hellwig <hch@infradead.org>, x86@kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, sparclinux@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

Signed-off-by: David Drysdale <drysdale@google.com>
Acked-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/include/uapi/asm/unistd.h | 3 ++-
 arch/sparc/kernel/systbls_32.S       | 1 +
 arch/sparc/kernel/systbls_64.S       | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/sparc/include/uapi/asm/unistd.h b/arch/sparc/include/uapi/asm/unistd.h
index 46d83842eddc..6f35f4df17f2 100644
--- a/arch/sparc/include/uapi/asm/unistd.h
+++ b/arch/sparc/include/uapi/asm/unistd.h
@@ -415,8 +415,9 @@
 #define __NR_getrandom		347
 #define __NR_memfd_create	348
 #define __NR_bpf		349
+#define __NR_execveat		350
 
-#define NR_syscalls		350
+#define NR_syscalls		351
 
 /* Bitmask values returned from kern_features system call.  */
 #define KERN_FEATURE_MIXED_MODE_STACK	0x00000001
diff --git a/arch/sparc/kernel/systbls_32.S b/arch/sparc/kernel/systbls_32.S
index ad0cdf497b78..e31a9056a303 100644
--- a/arch/sparc/kernel/systbls_32.S
+++ b/arch/sparc/kernel/systbls_32.S
@@ -87,3 +87,4 @@ sys_call_table:
 /*335*/	.long sys_syncfs, sys_sendmmsg, sys_setns, sys_process_vm_readv, sys_process_vm_writev
 /*340*/	.long sys_ni_syscall, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
 /*345*/	.long sys_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf
+/*350*/	.long sys_execveat
diff --git a/arch/sparc/kernel/systbls_64.S b/arch/sparc/kernel/systbls_64.S
index 580cde9370c9..15069cb35dac 100644
--- a/arch/sparc/kernel/systbls_64.S
+++ b/arch/sparc/kernel/systbls_64.S
@@ -88,6 +88,7 @@ sys_call_table32:
 	.word sys_syncfs, compat_sys_sendmmsg, sys_setns, compat_sys_process_vm_readv, compat_sys_process_vm_writev
 /*340*/	.word sys_kern_features, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
 	.word sys32_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf
+/*350*/	.word sys_execveat
 
 #endif /* CONFIG_COMPAT */
 
@@ -167,3 +168,4 @@ sys_call_table:
 	.word sys_syncfs, sys_sendmmsg, sys_setns, sys_process_vm_readv, sys_process_vm_writev
 /*340*/	.word sys_kern_features, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
 	.word sys_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf
+/*350*/	.word sys_execveat
-- 
2.1.0.rc2.206.gedb03e5
