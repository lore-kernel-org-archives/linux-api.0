From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: [PATCH v2 2/7] x86: Opt into HAVE_COPY_THREAD_TLS, for both 32-bit
 and 64-bit
Date: Sun, 15 Mar 2015 00:59:37 -0700
Message-ID: <d83cbda2c2cef90cbfc107019fba9d5151e712b5.1426376419.git.josh@joshtriplett.org>
References: <cover.1426376419.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1426376419.git.josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

For 32-bit userspace on a 64-bit kernel, this requires modifying
stub32_clone to actually swap the appropriate arguments to match
CONFIG_CLONE_BACKWARDS, rather than just leaving the C argument for tls
broken.

Signed-off-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Signed-off-by: Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Acked-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 arch/x86/Kconfig             | 1 +
 arch/x86/ia32/ia32entry.S    | 2 +-
 arch/x86/kernel/process_32.c | 6 +++---
 arch/x86/kernel/process_64.c | 8 ++++----
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b7d31ca..4960b0d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -124,6 +124,7 @@ config X86
 	select MODULES_USE_ELF_REL if X86_32
 	select MODULES_USE_ELF_RELA if X86_64
 	select CLONE_BACKWARDS if X86_32
+	select HAVE_COPY_THREAD_TLS
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_QUEUE_RWLOCK
 	select OLD_SIGSUSPEND3 if X86_32 || IA32_EMULATION
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 156ebca..0286735 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -487,7 +487,7 @@ GLOBAL(\label)
 	ALIGN
 GLOBAL(stub32_clone)
 	leaq sys_clone(%rip),%rax
-	mov	%r8, %rcx
+	xchg %r8, %rcx
 	jmp  ia32_ptregs_common	
 
 	ALIGN
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 603c4f9..ead28ff 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -129,8 +129,8 @@ void release_thread(struct task_struct *dead_task)
 	release_vm86_irqs(dead_task);
 }
 
-int copy_thread(unsigned long clone_flags, unsigned long sp,
-	unsigned long arg, struct task_struct *p)
+int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
+	unsigned long arg, struct task_struct *p, unsigned long tls)
 {
 	struct pt_regs *childregs = task_pt_regs(p);
 	struct task_struct *tsk;
@@ -185,7 +185,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	 */
 	if (clone_flags & CLONE_SETTLS)
 		err = do_set_thread_area(p, -1,
-			(struct user_desc __user *)childregs->si, 0);
+			(struct user_desc __user *)tls, 0);
 
 	if (err && p->thread.io_bitmap_ptr) {
 		kfree(p->thread.io_bitmap_ptr);
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 67fcc43..c69cabc 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -151,8 +151,8 @@ static inline u32 read_32bit_tls(struct task_struct *t, int tls)
 	return get_desc_base(&t->thread.tls_array[tls]);
 }
 
-int copy_thread(unsigned long clone_flags, unsigned long sp,
-		unsigned long arg, struct task_struct *p)
+int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
+		unsigned long arg, struct task_struct *p, unsigned long tls)
 {
 	int err;
 	struct pt_regs *childregs;
@@ -209,10 +209,10 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 #ifdef CONFIG_IA32_EMULATION
 		if (test_thread_flag(TIF_IA32))
 			err = do_set_thread_area(p, -1,
-				(struct user_desc __user *)childregs->si, 0);
+				(struct user_desc __user *)tls, 0);
 		else
 #endif
-			err = do_arch_prctl(p, ARCH_SET_FS, childregs->r8);
+			err = do_arch_prctl(p, ARCH_SET_FS, tls);
 		if (err)
 			goto out;
 	}
-- 
2.1.4
