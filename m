From: Dmitry Safonov <dima@arista.com>
Subject: [PATCHv7 23/33] x86/vdso: Handle faults on timens page
Date: Fri, 11 Oct 2019 02:23:31 +0100
Message-ID: <20191011012341.846266-24-dima@arista.com>
References: <20191011012341.846266-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191011012341.846266-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

If a task belongs to a time namespace then the VVAR page which contains
the system wide VDSO data is replaced with a namespace specific page
which has the same layout as the VVAR page.

Co-developed-by: Andrei Vagin <avagin@gmail.com>
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 arch/x86/entry/vdso/vma.c | 53 +++++++++++++++++++++++++++++++++++++--
 mm/mmap.c                 |  2 ++
 2 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index 5dab706aca2e..f6e13ab29d94 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -14,11 +14,13 @@
 #include <linux/elf.h>
 #include <linux/cpu.h>
 #include <linux/ptrace.h>
+#include <linux/time_namespace.h>
 #include <asm/pvclock.h>
 #include <asm/vgtod.h>
 #include <asm/proto.h>
 #include <asm/vdso.h>
 #include <asm/vvar.h>
+#include <asm/tlb.h>
 #include <asm/page.h>
 #include <asm/desc.h>
 #include <asm/cpufeature.h>
@@ -107,10 +109,36 @@ static int vvar_mremap(const struct vm_special_mapping *sm,
 	return 0;
 }
 
+#ifdef CONFIG_TIME_NS
+static struct page *find_timens_vvar_page(struct vm_area_struct *vma)
+{
+	if (likely(vma->vm_mm == current->mm))
+		return current->nsproxy->time_ns->vvar_page;
+
+	/*
+	 * VM_PFNMAP | VM_IO protect .fault() handler from being called
+	 * through interfaces like /proc/$pid/mem or
+	 * process_vm_{readv,writev}() as long as there's no .access()
+	 * in special_mapping_vmops().
+	 * For more details check_vma_flags() and __access_remote_vm()
+	 */
+
+	WARN(1, "vvar_page accessed remotely");
+
+	return NULL;
+}
+#else
+static inline struct page *find_timens_vvar_page(struct vm_area_struct *vma)
+{
+	return NULL;
+}
+#endif
+
 static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,
 		      struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	const struct vdso_image *image = vma->vm_mm->context.vdso_image;
+	unsigned long pfn;
 	long sym_offset;
 
 	if (!image)
@@ -130,8 +158,21 @@ static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,
 		return VM_FAULT_SIGBUS;
 
 	if (sym_offset == image->sym_vvar_page) {
-		return vmf_insert_pfn(vma, vmf->address,
-				__pa_symbol(&__vvar_page) >> PAGE_SHIFT);
+		struct page *timens_page = find_timens_vvar_page(vma);
+
+		pfn = __pa_symbol(&__vvar_page) >> PAGE_SHIFT;
+
+		/*
+		 * If a task belongs to a time namespace then a namespace
+		 * specific VVAR is mapped with the sym_vvar_page offset and
+		 * the real VVAR page is mapped with the sym_timens_page
+		 * offset.
+		 * See also the comment near timens_setup_vdso_data().
+		 */
+		if (timens_page)
+			pfn = page_to_pfn(timens_page);
+
+		return vmf_insert_pfn(vma, vmf->address, pfn);
 	} else if (sym_offset == image->sym_pvclock_page) {
 		struct pvclock_vsyscall_time_info *pvti =
 			pvclock_get_pvti_cpu0_va();
@@ -146,6 +187,14 @@ static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,
 		if (tsc_pg && vclock_was_used(VCLOCK_HVCLOCK))
 			return vmf_insert_pfn(vma, vmf->address,
 					virt_to_phys(tsc_pg) >> PAGE_SHIFT);
+	} else if (sym_offset == image->sym_timens_page) {
+		struct page *timens_page = find_timens_vvar_page(vma);
+
+		if (!timens_page)
+			return VM_FAULT_SIGBUS;
+
+		pfn = __pa_symbol(&__vvar_page) >> PAGE_SHIFT;
+		return vmf_insert_pfn(vma, vmf->address, pfn);
 	}
 
 	return VM_FAULT_SIGBUS;
diff --git a/mm/mmap.c b/mm/mmap.c
index a7d8c84d19b7..af722a47db3c 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -3363,6 +3363,8 @@ static const struct vm_operations_struct special_mapping_vmops = {
 	.fault = special_mapping_fault,
 	.mremap = special_mapping_mremap,
 	.name = special_mapping_name,
+	/* vDSO code relies that VVAR can't be accessed remotely */
+	.access = NULL,
 };
 
 static const struct vm_operations_struct legacy_special_mapping_vmops = {
-- 
2.23.0
