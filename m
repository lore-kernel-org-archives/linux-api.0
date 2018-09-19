From: Dmitry Safonov <dima@arista.com>
Subject: [RFC 11/20] x86/vdso: Purge timens page on setns()/unshare()/clone()
Date: Wed, 19 Sep 2018 21:50:28 +0100
Message-ID: <20180919205037.9574-12-dima@arista.com>
References: <20180919205037.9574-1-dima@arista.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919205037.9574-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Find page with timens offsets on vvar and flush mapping for it during
entering/creating another time namespace.
Prevents application to have stale mapping from old namespace.
(as old namespace might be destroyed on the moment of userspace access,
it also prevents leaks from kernel).

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 arch/x86/entry/vdso/vma.c   | 31 +++++++++++++++++++++++++++++++
 arch/x86/include/asm/vdso.h |  1 +
 kernel/time_namespace.c     | 12 ++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index 0f92227a4a7e..90eadcfcb7f5 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -25,6 +25,7 @@
 #include <asm/cpufeature.h>
 #include <asm/mshyperv.h>
 #include <asm/page.h>
+#include <asm/tlbflush.h>
 
 #if defined(CONFIG_X86_64)
 unsigned int __read_mostly vdso64_enabled = 1;
@@ -158,6 +159,36 @@ static int vvar_fault(const struct vm_special_mapping *sm,
 	return VM_FAULT_SIGBUS;
 }
 
+static void clear_flush_timens_pte(struct mm_struct *mm, unsigned long addr)
+{
+	spinlock_t *ptl;
+	pte_t *ptep;
+
+	if (follow_pte_pmd(mm, addr, NULL, NULL, &ptep, NULL, &ptl))
+		return; /* no pte found */
+	ptep_get_and_clear(mm, addr, ptep);
+	pte_unmap_unlock(ptep, ptl);
+	flush_tlb_mm_range(mm, addr, addr + PAGE_SIZE, VM_NONE);
+}
+
+int vvar_purge_timens(struct task_struct *task)
+{
+	struct mm_struct *mm = task->mm;
+	const struct vdso_image *image;
+	unsigned long addr;
+
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
+
+	image = mm->context.vdso_image;
+
+	addr = (unsigned long)mm->context.vdso + image->sym_timens_page;
+	clear_flush_timens_pte(mm, addr);
+
+	up_write(&mm->mmap_sem);
+	return 0;
+}
+
 static const struct vm_special_mapping vdso_mapping = {
 	.name = "[vdso]",
 	.fault = vdso_fault,
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index 619322065b8e..98b02481137c 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -45,6 +45,7 @@ extern const struct vdso_image vdso_image_32;
 extern void __init init_vdso_image(const struct vdso_image *image);
 
 extern int map_vdso_once(const struct vdso_image *image, unsigned long addr);
+extern int vvar_purge_timens(struct task_struct *task);
 
 #endif /* __ASSEMBLER__ */
 
diff --git a/kernel/time_namespace.c b/kernel/time_namespace.c
index f96871cb8124..f88ae0e17d92 100644
--- a/kernel/time_namespace.c
+++ b/kernel/time_namespace.c
@@ -14,6 +14,7 @@
 #include <linux/proc_ns.h>
 #include <linux/sched/task.h>
 #include <linux/mm.h>
+#include <asm/vdso.h>
 
 static struct ucounts *inc_time_namespaces(struct user_namespace *ns)
 {
@@ -91,9 +92,15 @@ static struct time_namespace *clone_time_ns(struct user_namespace *user_ns,
 struct time_namespace *copy_time_ns(unsigned long flags,
 	struct user_namespace *user_ns, struct time_namespace *old_ns)
 {
+	int ret;
+
 	if (!(flags & CLONE_NEWTIME))
 		return get_time_ns(old_ns);
 
+	ret = vvar_purge_timens(current);
+	if (ret)
+		return ERR_PTR(ret);
+
 	return clone_time_ns(user_ns, old_ns);
 }
 
@@ -138,11 +145,16 @@ static void timens_put(struct ns_common *ns)
 static int timens_install(struct nsproxy *nsproxy, struct ns_common *new)
 {
 	struct time_namespace *ns = to_time_ns(new);
+	int ret;
 
 	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN) ||
 	    !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
 		return -EPERM;
 
+	ret = vvar_purge_timens(current);
+	if (ret)
+		return ret;
+
 	get_time_ns(ns);
 	put_time_ns(nsproxy->time_ns);
 	nsproxy->time_ns = ns;
-- 
2.13.6
