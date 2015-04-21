From: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 2/2] x86: Opt into HAVE_COPY_THREAD_TLS, for both 32-bit and
 64-bit
Date: Tue, 21 Apr 2015 10:47:35 -0700
Message-ID: <20150421174735.GA5147@jtriplet-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

For 32-bit userspace on a 64-bit kernel, this requires modifying
stub32_clone to actually swap the appropriate arguments to match
CONFIG_CLONE_BACKWARDS, rather than just leaving the C argument for tls
broken.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Thiago Macieira <thiago.macieira@intel.com>
Acked-by: Andy Lutomirski <luto@kernel.org>
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
