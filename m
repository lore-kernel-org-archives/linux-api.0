From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: [PATCH v5 3/4] x86: wire up the process_vmsplice syscall
Date: Tue,  9 Jan 2018 08:30:52 +0200
Message-ID: <1515479453-14672-4-git-send-email-rppt@linux.vnet.ibm.com>
References: <1515479453-14672-1-git-send-email-rppt@linux.vnet.ibm.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1515479453-14672-1-git-send-email-rppt@linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, criu@openvz.org, gdb@sourceware.org, devel@lists.open-mpi.org, rr-dev@mozilla.org, Arnd Bergmann <arnd@arndb.de>, Pavel Emelyanov <xemul@virtuozzo.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Josh Triplett <josh@joshtriplett.org>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Andrei Vagin <avagin@openvz.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

From: Andrei Vagin <avagin@openvz.org>

Signed-off-by: Andrei Vagin <avagin@openvz.org>
---
 arch/x86/entry/syscalls/syscall_32.tbl | 1 +
 arch/x86/entry/syscalls/syscall_64.tbl | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 448ac2161112..dc64bf577b17 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -391,3 +391,4 @@
 382	i386	pkey_free		sys_pkey_free
 383	i386	statx			sys_statx
 384	i386	arch_prctl		sys_arch_prctl			compat_sys_arch_prctl
+385	i386	process_vmsplice	sys_process_vmsplice		compat_sys_process_vmsplice
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 5aef183e2f85..d2f916c0309a 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -339,6 +339,7 @@
 330	common	pkey_alloc		sys_pkey_alloc
 331	common	pkey_free		sys_pkey_free
 332	common	statx			sys_statx
+333	64	process_vmsplice	sys_process_vmsplice
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
@@ -380,3 +381,4 @@
 545	x32	execveat		compat_sys_execveat/ptregs
 546	x32	preadv2			compat_sys_preadv64v2
 547	x32	pwritev2		compat_sys_pwritev64v2
+548	x32	process_vmsplice	compat_sys_process_vmsplice
-- 
2.7.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
