From: Dmitry Safonov <dima@arista.com>
Subject: [RFC 12/20] x86/vdso: Look for vvar vma to purge timens page
Date: Wed, 19 Sep 2018 21:50:29 +0100
Message-ID: <20180919205037.9574-13-dima@arista.com>
References: <20180919205037.9574-1-dima@arista.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919205037.9574-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

As vvar vma may be moved away from vdso, let's search it, rather than
calculate purge address from vdso position.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 arch/x86/entry/vdso/vma.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index 90eadcfcb7f5..d1e2392a4905 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -159,7 +159,18 @@ static int vvar_fault(const struct vm_special_mapping *sm,
 	return VM_FAULT_SIGBUS;
 }
 
-static void clear_flush_timens_pte(struct mm_struct *mm, unsigned long addr)
+static const struct vm_special_mapping vdso_mapping = {
+	.name = "[vdso]",
+	.fault = vdso_fault,
+	.mremap = vdso_mremap,
+};
+static const struct vm_special_mapping vvar_mapping = {
+	.name = "[vvar]",
+	.fault = vvar_fault,
+	.mremap = vvar_mremap,
+};
+
+static void vvar_flush_timens_pte(struct mm_struct *mm, unsigned long addr)
 {
 	spinlock_t *ptl;
 	pte_t *ptep;
@@ -175,31 +186,31 @@ int vvar_purge_timens(struct task_struct *task)
 {
 	struct mm_struct *mm = task->mm;
 	const struct vdso_image *image;
+	struct vm_area_struct *vma;
 	unsigned long addr;
 
 	if (down_write_killable(&mm->mmap_sem))
 		return -EINTR;
 
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+		if (vma_is_special_mapping(vma, &vvar_mapping))
+			break;
+	}
+
+	/* vvar is unmapped */
+	if (!vma || !vma_is_special_mapping(vma, &vvar_mapping))
+		goto out;
+
 	image = mm->context.vdso_image;
 
-	addr = (unsigned long)mm->context.vdso + image->sym_timens_page;
-	clear_flush_timens_pte(mm, addr);
+	addr = vma->vm_end + image->sym_timens_page;
+	vvar_flush_timens_pte(mm, addr);
 
+out:
 	up_write(&mm->mmap_sem);
 	return 0;
 }
 
-static const struct vm_special_mapping vdso_mapping = {
-	.name = "[vdso]",
-	.fault = vdso_fault,
-	.mremap = vdso_mremap,
-};
-static const struct vm_special_mapping vvar_mapping = {
-	.name = "[vvar]",
-	.fault = vvar_fault,
-	.mremap = vvar_mremap,
-};
-
 /*
  * Add vdso and vvar mappings to current process.
  * @image          - blob to map
-- 
2.13.6
