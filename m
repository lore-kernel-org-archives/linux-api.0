From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [PATCH v8 05/14] x86/cet/ibt: ELF header parsing for IBT
Date: Tue, 13 Aug 2019 13:53:50 -0700
Message-ID: <20190813205359.12196-6-yu-cheng.yu@intel.com>
References: <20190813205359.12196-1-yu-cheng.yu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190813205359.12196-1-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

Look in .note.gnu.property of an ELF file and check if Indirect
Branch Tracking needs to be enabled for the task.

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
---
 arch/x86/Kconfig             | 1 +
 arch/x86/kernel/process_64.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 666dc66a382e..7edb544cef00 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1971,6 +1971,7 @@ config X86_INTEL_BRANCH_TRACKING_USER
 	select X86_INTEL_CET
 	select ARCH_HAS_AS_LIMIT
 	select ARCH_USE_GNU_PROPERTY
+	select ARCH_BINFMT_ELF_STATE
 	---help---
 	  Indirect Branch Tracking provides hardware protection against return-/jmp-
 	  oriented programming attacks.
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 7ec60b14e96d..a051cfc5242f 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -856,6 +856,11 @@ int arch_setup_property(struct arch_elf_state *state)
 			return r;
 	}
 
+	if (cpu_feature_enabled(X86_FEATURE_IBT)) {
+		if (state->gnu_property & GNU_PROPERTY_X86_FEATURE_1_IBT)
+			r = cet_setup_ibt();
+	}
+
 	return r;
 }
 #endif
-- 
2.17.1
