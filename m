From: David Drysdale <drysdale@google.com>
Subject: [PATCHv10 2/5] x86: Hook up execveat system call.
Date: Mon, 24 Nov 2014 11:53:56 +0000
Message-ID: <1416830039-21952-3-git-send-email-drysdale@google.com>
References: <1416830039-21952-1-git-send-email-drysdale@google.com>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <1416830039-21952-1-git-send-email-drysdale@google.com>
Sender: sparclinux-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Oleg Nesterov <oleg@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@aerifal.cx>, Christoph Hellwig <hch@infradead.org>, x86@kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, sparclinux@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

Hook up x86-64, i386 and x32 ABIs.

Signed-off-by: David Drysdale <drysdale@google.com>
---
 arch/x86/ia32/audit.c            |  1 +
 arch/x86/ia32/ia32entry.S        |  1 +
 arch/x86/kernel/audit_64.c       |  1 +
 arch/x86/kernel/entry_64.S       | 28 ++++++++++++++++++++++++++++
 arch/x86/syscalls/syscall_32.tbl |  1 +
 arch/x86/syscalls/syscall_64.tbl |  2 ++
 arch/x86/um/sys_call_table_64.c  |  1 +
 7 files changed, 35 insertions(+)

diff --git a/arch/x86/ia32/audit.c b/arch/x86/ia32/audit.c
index 5d7b381da692..2eccc8932ae6 100644
--- a/arch/x86/ia32/audit.c
+++ b/arch/x86/ia32/audit.c
@@ -35,6 +35,7 @@ int ia32_classify_syscall(unsigned syscall)
 	case __NR_socketcall:
 		return 4;
 	case __NR_execve:
+	case __NR_execveat:
 		return 5;
 	default:
 		return 1;
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index ffe71228fc10..82e8a1d44658 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -480,6 +480,7 @@ GLOBAL(\label)
 	PTREGSCALL stub32_rt_sigreturn, sys32_rt_sigreturn
 	PTREGSCALL stub32_sigreturn, sys32_sigreturn
 	PTREGSCALL stub32_execve, compat_sys_execve
+	PTREGSCALL stub32_execveat, compat_sys_execveat
 	PTREGSCALL stub32_fork, sys_fork
 	PTREGSCALL stub32_vfork, sys_vfork
 
diff --git a/arch/x86/kernel/audit_64.c b/arch/x86/kernel/audit_64.c
index 06d3e5a14d9d..f3672508b249 100644
--- a/arch/x86/kernel/audit_64.c
+++ b/arch/x86/kernel/audit_64.c
@@ -50,6 +50,7 @@ int audit_classify_syscall(int abi, unsigned syscall)
 	case __NR_openat:
 		return 3;
 	case __NR_execve:
+	case __NR_execveat:
 		return 5;
 	default:
 		return 0;
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index df088bb03fb3..40d893c60fcc 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -652,6 +652,20 @@ ENTRY(stub_execve)
 	CFI_ENDPROC
 END(stub_execve)
 
+ENTRY(stub_execveat)
+	CFI_STARTPROC
+	addq $8, %rsp
+	PARTIAL_FRAME 0
+	SAVE_REST
+	FIXUP_TOP_OF_STACK %r11
+	call sys_execveat
+	RESTORE_TOP_OF_STACK %r11
+	movq %rax,RAX(%rsp)
+	RESTORE_REST
+	jmp int_ret_from_sys_call
+	CFI_ENDPROC
+END(stub_execveat)
+
 /*
  * sigreturn is special because it needs to restore all registers on return.
  * This cannot be done with SYSRET, so use the IRET return path instead.
@@ -697,6 +711,20 @@ ENTRY(stub_x32_execve)
 	CFI_ENDPROC
 END(stub_x32_execve)
 
+ENTRY(stub_x32_execveat)
+	CFI_STARTPROC
+	addq $8, %rsp
+	PARTIAL_FRAME 0
+	SAVE_REST
+	FIXUP_TOP_OF_STACK %r11
+	call compat_sys_execveat
+	RESTORE_TOP_OF_STACK %r11
+	movq %rax,RAX(%rsp)
+	RESTORE_REST
+	jmp int_ret_from_sys_call
+	CFI_ENDPROC
+END(stub_x32_execveat)
+
 #endif
 
 /*
diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index 9fe1b5d002f0..b3560ece1c9f 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -364,3 +364,4 @@
 355	i386	getrandom		sys_getrandom
 356	i386	memfd_create		sys_memfd_create
 357	i386	bpf			sys_bpf
+358	i386	execveat		sys_execveat			stub32_execveat
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 281150b539a2..8d656fbb57aa 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -328,6 +328,7 @@
 319	common	memfd_create		sys_memfd_create
 320	common	kexec_file_load		sys_kexec_file_load
 321	common	bpf			sys_bpf
+322	64	execveat		stub_execveat
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
@@ -366,3 +367,4 @@
 542	x32	getsockopt		compat_sys_getsockopt
 543	x32	io_setup		compat_sys_io_setup
 544	x32	io_submit		compat_sys_io_submit
+545	x32	execveat		stub_x32_execveat
diff --git a/arch/x86/um/sys_call_table_64.c b/arch/x86/um/sys_call_table_64.c
index f2f0723070ca..20c3649d0691 100644
--- a/arch/x86/um/sys_call_table_64.c
+++ b/arch/x86/um/sys_call_table_64.c
@@ -31,6 +31,7 @@
 #define stub_fork sys_fork
 #define stub_vfork sys_vfork
 #define stub_execve sys_execve
+#define stub_execveat sys_execveat
 #define stub_rt_sigreturn sys_rt_sigreturn
 
 #define __SYSCALL_COMMON(nr, sym, compat) __SYSCALL_64(nr, sym, compat)
-- 
2.1.0.rc2.206.gedb03e5

