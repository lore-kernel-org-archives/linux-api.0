From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv6 23/36] x86/vdso: Allocate timens vdso
Date: Sun, 18 Aug 2019 18:29:19 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1908181828070.1923@nanos.tec.linutronix.de>
References: <20190815163836.2927-1-dima@arista.com> <20190815163836.2927-24-dima@arista.com> <b719199a-ed91-610b-38bc-015a0749f600@kernel.org> <alpine.DEB.2.21.1908162208190.1923@nanos.tec.linutronix.de> <483678c7-7687-5445-f09e-e45e9460d559@gmail.com>
 <alpine.DEB.2.21.1908171709360.1923@nanos.tec.linutronix.de> <alpine.DEB.2.21.1908181823010.1923@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1908181823010.1923@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, 18 Aug 2019, Thomas Gleixner wrote:

> On Sun, 18 Aug 2019, Thomas Gleixner wrote:
> > 
> > Patch below. I tested this with the normal order and by installing a
> > 'timens' page unconditionally for all processes. I'll reply with the timens
> > testing hacks so you can see what I did.
> 
> First hack...

And the second one.

Thanks,

	tglx

8<-----------------

Subject: x86/vdso: Hack to test the time namespace path
From: Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 18 Aug 2019 16:49:00 +0200

Install a special TIMENS vvar page which forces the VDSO to take the time
namespace path for testing.

Not-Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/entry/vdso/vma.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -84,6 +84,33 @@ static int vdso_mremap(const struct vm_s
 	return 0;
 }
 
+/* Hack for testing */
+static struct page *vdso_timens_page;
+
+static int __init init_vdso_timens(void)
+{
+	struct vdso_data *vdata;
+	void *va;
+
+	vdso_timens_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!vdso_timens_page)
+		return -ENOMEM;
+
+	/* Hack: vdso data is at offset 0x80 in the page ... */
+	va = page_address(vdso_timens_page);
+	vdata = (struct vdso_data *)(va + 0x80);
+
+	vdata[0].seq = 1;
+	vdata[0].clock_mode = UINT_MAX;
+	vdata[1].seq = 1;
+	vdata[1].clock_mode = UINT_MAX;
+
+	/* All offsets are zero */
+
+	return 0;
+}
+subsys_initcall(init_vdso_timens);
+
 static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,
 		      struct vm_area_struct *vma, struct vm_fault *vmf)
 {
@@ -106,7 +133,7 @@ static vm_fault_t vvar_fault(const struc
 	if (sym_offset == 0)
 		return VM_FAULT_SIGBUS;
 
-	if (sym_offset == image->sym_vvar_page) {
+	if (sym_offset == image->sym_timens_page) {
 		return vmf_insert_pfn(vma, vmf->address,
 				__pa_symbol(&__vvar_page) >> PAGE_SHIFT);
 	} else if (sym_offset == image->sym_pvclock_page) {
@@ -123,6 +150,11 @@ static vm_fault_t vvar_fault(const struc
 		if (tsc_pg && vclock_was_used(VCLOCK_HVCLOCK))
 			return vmf_insert_pfn(vma, vmf->address,
 					vmalloc_to_pfn(tsc_pg));
+	} else if (sym_offset == image->sym_vvar_page) {
+		unsigned long pfn;
+
+		pfn = page_to_pfn(vdso_timens_page);
+		return vmf_insert_pfn(vma, vmf->address, pfn);
 	}
 
 	return VM_FAULT_SIGBUS;
