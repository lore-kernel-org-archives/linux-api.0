From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [RFC PATCH v6 09/26] mm/mmap: Prevent Shadow Stack VMA merges
Date: Mon, 19 Nov 2018 13:47:52 -0800
Message-ID: <20181119214809.6086-10-yu-cheng.yu@intel.com>
References: <20181119214809.6086-1-yu-cheng.yu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181119214809.6086-1-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pa
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

To prevent function call/return spills into the next shadow stack
area, do not merge shadow stack areas.

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
---
 mm/mmap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/mmap.c b/mm/mmap.c
index 6c04292e16a7..30836512ca79 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1147,6 +1147,12 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
 	if (vm_flags & VM_SPECIAL)
 		return NULL;
 
+	/*
+	 * Do not merge shadow stack areas.
+	 */
+	if (vm_flags & VM_SHSTK)
+		return NULL;
+
 	if (prev)
 		next = prev->vm_next;
 	else
-- 
2.17.1
