From: Dmitry Safonov <dima@arista.com>
Subject: [PATCHv8 25/34] x86/vdso: On timens page fault prefault also VVAR page
Date: Tue, 12 Nov 2019 01:27:14 +0000
Message-ID: <20191112012724.250792-26-dima@arista.com>
References: <20191112012724.250792-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191112012724.250792-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

As timens page has offsets to data on VVAR page VVAR is going
to be accessed shortly. Set it up with timens in one page fault
as optimization.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Co-developed-by: Andrei Vagin <avagin@gmail.com>
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 arch/x86/entry/vdso/vma.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index f6e13ab29d94..d6cb8a16f368 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -169,8 +169,23 @@ static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,
 		 * offset.
 		 * See also the comment near timens_setup_vdso_data().
 		 */
-		if (timens_page)
+		if (timens_page) {
+			unsigned long addr;
+			vm_fault_t err;
+
+			/*
+			 * Optimization: inside time namespace pre-fault
+			 * VVAR page too. As on timens page there are only
+			 * offsets for clocks on VVAR, it'll be faulted
+			 * shortly by VDSO code.
+			 */
+			addr = vmf->address + (image->sym_timens_page - sym_offset);
+			err = vmf_insert_pfn(vma, addr, pfn);
+			if (unlikely(err & VM_FAULT_ERROR))
+				return err;
+
 			pfn = page_to_pfn(timens_page);
+		}
 
 		return vmf_insert_pfn(vma, vmf->address, pfn);
 	} else if (sym_offset == image->sym_pvclock_page) {
-- 
2.24.0
