From: Dmitry Safonov <dima@arista.com>
Subject: [PATCHv5 21/37] x86/vdso: Restrict splitting VVAR VMA
Date: Mon, 29 Jul 2019 22:57:03 +0100
Message-ID: <20190729215758.28405-22-dima@arista.com>
References: <20190729215758.28405-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190729215758.28405-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Although, time namespace can work with VVAR VMA split, it seems worth
to forbid splitting VVAR resulting in stricter ABI and reducing amount
of corner-cases to consider while working further on VDSO.

I don't think there is any use-case for partial mremap() of vvar,
but if there is any - this patch can be easily reverted.

Co-developed-by: Andrei Vagin <avagin@openvz.org>
Signed-off-by: Andrei Vagin <avagin@openvz.org>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 arch/x86/entry/vdso/vma.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index 349a61d8bf34..3f05418642a8 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -84,6 +84,18 @@ static int vdso_mremap(const struct vm_special_mapping *sm,
 	return 0;
 }
 
+static int vvar_mremap(const struct vm_special_mapping *sm,
+		struct vm_area_struct *new_vma)
+{
+	unsigned long new_size = new_vma->vm_end - new_vma->vm_start;
+	const struct vdso_image *image = new_vma->vm_mm->context.vdso_image;
+
+	if (new_size != -image->sym_vvar_start)
+		return -EINVAL;
+
+	return 0;
+}
+
 static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,
 		      struct vm_area_struct *vma, struct vm_fault *vmf)
 {
@@ -136,6 +148,7 @@ static const struct vm_special_mapping vdso_mapping = {
 static const struct vm_special_mapping vvar_mapping = {
 	.name = "[vvar]",
 	.fault = vvar_fault,
+	.mremap = vvar_mremap,
 };
 
 /*
-- 
2.22.0
