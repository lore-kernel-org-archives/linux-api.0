From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [RFC PATCH 3/3] Prevent user from writing to IBT bitmap.
Date: Fri, 28 Jun 2019 12:41:58 -0700
Message-ID: <20190628194158.2431-3-yu-cheng.yu@intel.com>
References: <20190628194158.2431-1-yu-cheng.yu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190628194158.2431-1-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

The IBT bitmap is visiable from user-mode, but not writable.

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>

---
 arch/x86/mm/fault.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 59f4f66e4f2e..231196abb62e 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1454,6 +1454,13 @@ void do_user_addr_fault(struct pt_regs *regs,
 	 * we can handle it..
 	 */
 good_area:
+#define USER_MODE_WRITE (FAULT_FLAG_WRITE | FAULT_FLAG_USER)
+	if (((flags & USER_MODE_WRITE)  == USER_MODE_WRITE) &&
+	    (vma->vm_flags & VM_IBT)) {
+		bad_area_access_error(regs, hw_error_code, address, vma);
+		return;
+	}
+
 	if (unlikely(access_error(hw_error_code, vma))) {
 		bad_area_access_error(regs, hw_error_code, address, vma);
 		return;
-- 
2.17.1
