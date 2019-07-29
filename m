From: Dmitry Safonov <dima@arista.com>
Subject: [PATCHv5 24/37] x86/vdso: Allocate timens vdso
Date: Mon, 29 Jul 2019 22:57:06 +0100
Message-ID: <20190729215758.28405-25-dima@arista.com>
References: <20190729215758.28405-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190729215758.28405-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

As it has been discussed on timens RFC, adding a new conditional branch
`if (inside_time_ns)` on VDSO for all processes is undesirable.
It will add a penalty for everybody as branch predictor may mispredict
the jump. Also there are instruction cache lines wasted on cmp/jmp.

Those effects of introducing time namespace are very much unwanted
having in mind how much work have been spent on micro-optimisation
vdso code.

The propose is to allocate a second vdso code with dynamically
patched out (disabled by static_branch) timens code on boot time.

Allocate another vdso and copy original code.

Co-developed-by: Andrei Vagin <avagin@openvz.org>
Signed-off-by: Andrei Vagin <avagin@openvz.org>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 arch/x86/entry/vdso/vdso2c.h |   2 +-
 arch/x86/entry/vdso/vma.c    | 113 +++++++++++++++++++++++++++++++++--
 arch/x86/include/asm/vdso.h  |   9 +--
 3 files changed, 114 insertions(+), 10 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso2c.h b/arch/x86/entry/vdso/vdso2c.h
index 7556bb70ed8b..885b988aea19 100644
--- a/arch/x86/entry/vdso/vdso2c.h
+++ b/arch/x86/entry/vdso/vdso2c.h
@@ -157,7 +157,7 @@ static void BITSFUNC(go)(void *raw_addr, size_t raw_len,
 	}
 	fprintf(outfile, "\n};\n\n");
 
-	fprintf(outfile, "const struct vdso_image %s = {\n", image_name);
+	fprintf(outfile, "struct vdso_image %s __ro_after_init = {\n", image_name);
 	fprintf(outfile, "\t.text = raw_data,\n");
 	fprintf(outfile, "\t.size = %lu,\n", mapping_size);
 	if (alt_sec) {
diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index 9bd66f84db5e..8a8211fd4cfc 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -30,26 +30,128 @@
 unsigned int __read_mostly vdso64_enabled = 1;
 #endif
 
-void __init init_vdso_image(const struct vdso_image *image)
+void __init init_vdso_image(struct vdso_image *image)
 {
 	BUG_ON(image->size % PAGE_SIZE != 0);
 
 	apply_alternatives((struct alt_instr *)(image->text + image->alt),
 			   (struct alt_instr *)(image->text + image->alt +
 						image->alt_len));
+#ifdef CONFIG_TIME_NS
+	image->text_timens = vmalloc_32(image->size);
+	if (WARN_ON(image->text_timens == NULL))
+		return;
+
+	memcpy(image->text_timens, image->text, image->size);
+#endif
 }
 
 struct linux_binprm;
 
+#ifdef CONFIG_TIME_NS
+static inline struct timens_offsets *current_timens_offsets(void)
+{
+	return current->nsproxy->time_ns->offsets;
+}
+
+static int vdso_check_timens(struct vm_area_struct *vma, bool *in_timens)
+{
+	struct task_struct *tsk;
+
+	if (likely(vma->vm_mm == current->mm)) {
+		*in_timens = !!current_timens_offsets();
+		return 0;
+	}
+
+	/*
+	 * .fault() handler can be called over remote process through
+	 * interfaces like /proc/$pid/mem or process_vm_{readv,writev}()
+	 * Considering such access to vdso as a slow-path.
+	 */
+
+#ifdef CONFIG_MEMCG
+	rcu_read_lock();
+
+	tsk = rcu_dereference(vma->vm_mm->owner);
+	if (tsk) {
+		task_lock(tsk);
+		/*
+		 * Shouldn't happen: nsproxy is unset in exit_mm().
+		 * Before that exit_mm() holds mmap_sem to set (mm = NULL).
+		 * It's impossible to have a fault in task without mm
+		 * and mmap_sem is taken during the fault.
+		 */
+		if (WARN_ON_ONCE(tsk->nsproxy == NULL)) {
+			task_unlock(tsk);
+			rcu_read_unlock();
+			return -EIO;
+		}
+		*in_timens = !!tsk->nsproxy->time_ns->offsets;
+		task_unlock(tsk);
+		rcu_read_unlock();
+		return 0;
+	}
+	rcu_read_unlock();
+#endif
+
+	read_lock(&tasklist_lock);
+	for_each_process(tsk) {
+		struct task_struct *c;
+
+		if (tsk->flags & PF_KTHREAD)
+			continue;
+		for_each_thread(tsk, c) {
+			if (c->mm == vma->vm_mm)
+				goto found;
+			if (c->mm)
+				break;
+		}
+	}
+	read_unlock(&tasklist_lock);
+	return -ESRCH;
+
+found:
+	task_lock(tsk);
+	read_unlock(&tasklist_lock);
+	*in_timens = !!tsk->nsproxy->time_ns->offsets;
+	task_unlock(tsk);
+
+	return 0;
+}
+#else /* CONFIG_TIME_NS */
+static inline int vdso_check_timens(struct vm_area_struct *vma, bool *in_timens)
+{
+	*in_timens = false;
+	return 0;
+}
+static inline struct timens_offsets *current_timens_offsets(void)
+{
+	return NULL;
+}
+#endif /* CONFIG_TIME_NS */
+
 static vm_fault_t vdso_fault(const struct vm_special_mapping *sm,
 		      struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	const struct vdso_image *image = vma->vm_mm->context.vdso_image;
+	unsigned long offset = vmf->pgoff << PAGE_SHIFT;
+	bool in_timens;
+	int err;
 
 	if (!image || (vmf->pgoff << PAGE_SHIFT) >= image->size)
 		return VM_FAULT_SIGBUS;
 
-	vmf->page = virt_to_page(image->text + (vmf->pgoff << PAGE_SHIFT));
+	err = vdso_check_timens(vma, &in_timens);
+	if (err)
+		return VM_FAULT_SIGBUS;
+
+	WARN_ON_ONCE(in_timens && !image->text_timens);
+
+	if (in_timens && image->text_timens)
+		vmf->page = vmalloc_to_page(image->text_timens + offset);
+	else
+		vmf->page = virt_to_page(image->text + offset);
+
 	get_page(vmf->page);
 	return 0;
 }
@@ -138,13 +240,14 @@ static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,
 			return vmf_insert_pfn(vma, vmf->address,
 					vmalloc_to_pfn(tsc_pg));
 	} else if (sym_offset == image->sym_timens_page) {
-		struct time_namespace *ns = current->nsproxy->time_ns;
+		/* We can fault only in current context for VM_PFNMAP mapping */
+		struct timens_offsets *offsets = current_timens_offsets();
 		unsigned long pfn;
 
-		if (!ns->offsets)
+		if (!offsets)
 			pfn = page_to_pfn(ZERO_PAGE(0));
 		else
-			pfn = page_to_pfn(virt_to_page(ns->offsets));
+			pfn = page_to_pfn(virt_to_page(offsets));
 
 		return vmf_insert_pfn(vma, vmf->address, pfn);
 	}
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index 9d420c545607..03f468c63a24 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -12,6 +12,7 @@
 
 struct vdso_image {
 	void *text;
+	void *text_timens;
 	unsigned long size;   /* Always a multiple of PAGE_SIZE */
 
 	unsigned long alt, alt_len;
@@ -30,18 +31,18 @@ struct vdso_image {
 };
 
 #ifdef CONFIG_X86_64
-extern const struct vdso_image vdso_image_64;
+extern struct vdso_image vdso_image_64;
 #endif
 
 #ifdef CONFIG_X86_X32
-extern const struct vdso_image vdso_image_x32;
+extern struct vdso_image vdso_image_x32;
 #endif
 
 #if defined CONFIG_X86_32 || defined CONFIG_COMPAT
-extern const struct vdso_image vdso_image_32;
+extern struct vdso_image vdso_image_32;
 #endif
 
-extern void __init init_vdso_image(const struct vdso_image *image);
+extern void __init init_vdso_image(struct vdso_image *image);
 
 extern int map_vdso_once(const struct vdso_image *image, unsigned long addr);
 
-- 
2.22.0
