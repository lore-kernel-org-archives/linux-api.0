From: Fam Zheng <famz@redhat.com>
Subject: [PATCH v4 9/9] x86: Hook up 32 bit compat epoll_pwait1 syscall
Date: Tue, 10 Mar 2015 09:49:15 +0800
Message-ID: <1425952155-27603-10-git-send-email-famz@redhat.com>
References: <1425952155-27603-1-git-send-email-famz@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1425952155-27603-1-git-send-email-famz@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, David Herrmann <dh.herrmann@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Miklos Szeredi <mszeredi@suse.cz>, David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>, "David S. Miller" <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Theodore Ts'o <tytso@mit.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Rashika Kheria <rashika.kheria@gmail.com>, Hugh Dickins <hughd@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Fam Zheng <famz@redhat.com>, Peter Zijlstra <peter>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 arch/x86/syscalls/syscall_32.tbl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index bf912d8..5728c2e 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -366,4 +366,4 @@
 357	i386	bpf			sys_bpf
 358	i386	execveat		sys_execveat			stub32_execveat
 359	i386	epoll_ctl_batch		sys_epoll_ctl_batch
-360	i386	epoll_pwait1		sys_epoll_pwait1
+360	i386	epoll_pwait1		sys_epoll_pwait1		compat_sys_epoll_pwait1
-- 
1.9.3

