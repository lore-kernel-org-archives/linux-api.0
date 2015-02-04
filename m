From: Fam Zheng <famz@redhat.com>
Subject: [PATCH RFC v2 5/7] x86: Hook up epoll_ctl_batch syscall
Date: Wed,  4 Feb 2015 18:36:51 +0800
Message-ID: <1423046213-7043-6-git-send-email-famz@redhat.com>
References: <1423046213-7043-1-git-send-email-famz@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1423046213-7043-1-git-send-email-famz@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, David Herrmann <dh.herrmann@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Miklos Szeredi <mszeredi@suse.cz>, David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>, "David S. Miller" <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Theodore Ts'o <tytso@mit.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Rashika Kheria <rashika.kheria@gmail.com>, Hugh Dickins <hughd@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Fam Zheng <famz@redhat.com>, Peter Zijlstra <peter>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 arch/x86/syscalls/syscall_32.tbl | 1 +
 arch/x86/syscalls/syscall_64.tbl | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index b3560ec..fe809f6 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -365,3 +365,4 @@
 356	i386	memfd_create		sys_memfd_create
 357	i386	bpf			sys_bpf
 358	i386	execveat		sys_execveat			stub32_execveat
+359	i386	epoll_ctl_batch		sys_epoll_ctl_batch
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 8d656fb..67b2ea4 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -329,6 +329,7 @@
 320	common	kexec_file_load		sys_kexec_file_load
 321	common	bpf			sys_bpf
 322	64	execveat		stub_execveat
+323	64	epoll_ctl_batch		sys_epoll_ctl_batch
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
-- 
1.9.3

