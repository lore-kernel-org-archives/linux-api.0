From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [RFC PATCH v4 5/9] x86/cet/ibt: ELF header parsing for IBT
Date: Fri, 21 Sep 2018 08:05:49 -0700
Message-ID: <20180921150553.21016-6-yu-cheng.yu@intel.com>
References: <20180921150553.21016-1-yu-cheng.yu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180921150553.21016-1-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>Peter
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

Look in .note.gnu.property of an ELF file and check if Indirect
Branch Tracking needs to be enabled for the task.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
---
 arch/x86/include/uapi/asm/elf_property.h | 1 +
 arch/x86/kernel/elf.c                    | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/elf_property.h b/arch/x86/include/uapi/asm/elf_property.h
index af361207718c..343a871b8fc1 100644
--- a/arch/x86/include/uapi/asm/elf_property.h
+++ b/arch/x86/include/uapi/asm/elf_property.h
@@ -11,5 +11,6 @@
  * Bits for GNU_PROPERTY_X86_FEATURE_1_AND
  */
 #define GNU_PROPERTY_X86_FEATURE_1_SHSTK	(0x00000002)
+#define GNU_PROPERTY_X86_FEATURE_1_IBT		(0x00000001)
 
 #endif /* _UAPI_ASM_X86_ELF_PROPERTY_H */
diff --git a/arch/x86/kernel/elf.c b/arch/x86/kernel/elf.c
index 2fddd0bc545b..13358026cd64 100644
--- a/arch/x86/kernel/elf.c
+++ b/arch/x86/kernel/elf.c
@@ -300,7 +300,8 @@ int arch_setup_features(void *ehdr_p, void *phdr_p,
 
 	struct elf64_hdr *ehdr64 = ehdr_p;
 
-	if (!cpu_feature_enabled(X86_FEATURE_SHSTK))
+	if (!cpu_feature_enabled(X86_FEATURE_SHSTK) &&
+	    !cpu_feature_enabled(X86_FEATURE_IBT))
 		return 0;
 
 	if (ehdr64->e_ident[EI_CLASS] == ELFCLASS64) {
@@ -335,6 +336,11 @@ int arch_setup_features(void *ehdr_p, void *phdr_p,
 		}
 	}
 
+	if (cpu_feature_enabled(X86_FEATURE_IBT)) {
+		if (feature & GNU_PROPERTY_X86_FEATURE_1_IBT)
+			err = cet_setup_ibt();
+	}
+
 out:
 	return err;
 }
-- 
2.17.1
