From: Fam Zheng <famz@redhat.com>
Subject: [PATCH RFC v3 7/7] x86: Hook up epoll_pwait1 syscall
Date: Fri, 13 Feb 2015 17:04:03 +0800
Message-ID: <1423818243-15410-8-git-send-email-famz@redhat.com>
References: <1423818243-15410-1-git-send-email-famz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1423818243-15410-1-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, David Herrmann <dh.herrmann@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Miklos Szeredi <mszeredi@suse.cz>, David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>, "David S. Miller" <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Theodore Ts'o <tytso@mit.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Rashika Kheria <rashika.kheria@gmail.com>, Hugh Dickins <hughd@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Fam Zheng <famz@redhat.com>, Peter Zijlstra <peter>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 arch/x86/syscalls/syscall_32.tbl | 1 +
 arch/x86/syscalls/syscall_64.tbl | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index fe809f6..bf912d8 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -366,3 +366,4 @@
 357	i386	bpf			sys_bpf
 358	i386	execveat		sys_execveat			stub32_execveat
 359	i386	epoll_ctl_batch		sys_epoll_ctl_batch
+360	i386	epoll_pwait1		sys_epoll_pwait1
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 67b2ea4..9246ad5 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -330,6 +330,7 @@
 321	common	bpf			sys_bpf
 322	64	execveat		stub_execveat
 323	64	epoll_ctl_batch		sys_epoll_ctl_batch
+324	64	epoll_pwait1		sys_epoll_pwait1
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
-- 
1.9.3
