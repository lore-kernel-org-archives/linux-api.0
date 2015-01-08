From: Fam Zheng <famz@redhat.com>
Subject: [RESEND PATCH 3/3] x86: hook up epoll_pwait1 syscall
Date: Thu,  8 Jan 2015 17:16:03 +0800
Message-ID: <1420708563-21743-4-git-send-email-famz@redhat.com>
References: <1420708563-21743-1-git-send-email-famz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1420708563-21743-1-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Miklos Szeredi <mszeredi@suse.cz>, Juri Lelli <juri.lelli@gmail.com>, Zach Brown <zab@zabbo.net>, David Drysdale <drysdale@google.com>, Fam Zheng <famz@redhat.com>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@plumgrid.com>, David Herrmann <dh.herrmann@gmail.com>, Dario Faggioli <raistlin@linux.it>, Theodore Ts'o <tytso@mit.edu>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Oleg Nesterov <oleg@redhat.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Fabian Frederick <fabf@skynet.be>, Josh
List-Id: linux-api@vger.kernel.org

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 arch/x86/syscalls/syscall_32.tbl | 1 +
 arch/x86/syscalls/syscall_64.tbl | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index b3560ec..1c863f6 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -365,3 +365,4 @@
 356	i386	memfd_create		sys_memfd_create
 357	i386	bpf			sys_bpf
 358	i386	execveat		sys_execveat			stub32_execveat
+359	i386	epoll_pwait1		sys_epoll_pwait1
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 8d656fb..644a90f 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -329,6 +329,7 @@
 320	common	kexec_file_load		sys_kexec_file_load
 321	common	bpf			sys_bpf
 322	64	execveat		stub_execveat
+323	common	epoll_pwait1		sys_epoll_pwait1
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
-- 
1.9.3
