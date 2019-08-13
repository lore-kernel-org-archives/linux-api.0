From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [PATCH v8 03/14] x86/cet/ibt: Handle signals for end branch
Date: Tue, 13 Aug 2019 13:53:48 -0700
Message-ID: <20190813205359.12196-4-yu-cheng.yu@intel.com>
References: <20190813205359.12196-1-yu-cheng.yu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190813205359.12196-1-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

Restore end branch tracking setting from thread header.

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
---
 arch/x86/kernel/cet.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kernel/cet.c b/arch/x86/kernel/cet.c
index 505a69f476e1..db542bd423cc 100644
--- a/arch/x86/kernel/cet.c
+++ b/arch/x86/kernel/cet.c
@@ -281,6 +281,15 @@ int cet_restore_signal(bool ia32, struct sc_ext *sc_ext)
 		msr_ia32_u_cet |= MSR_IA32_CET_SHSTK_EN;
 	}
 
+	if (current->thread.cet.ibt_enabled) {
+		if (current->thread.cet.ibt_bitmap_used)
+			msr_ia32_u_cet |= (IBT_BITMAP_ADDR |
+					   MSR_IA32_CET_LEG_IW_EN);
+
+		msr_ia32_u_cet |= (MSR_IA32_CET_ENDBR_EN |
+				   MSR_IA32_CET_NO_TRACK_EN);
+	}
+
 	wrmsrl(MSR_IA32_PL3_SSP, new_ssp);
 	wrmsrl(MSR_IA32_U_CET, msr_ia32_u_cet);
 	return 0;
@@ -321,6 +330,15 @@ int cet_setup_signal(bool ia32, unsigned long rstor_addr, struct sc_ext *sc_ext)
 		sc_ext->ssp = new_ssp;
 	}
 
+	if (current->thread.cet.ibt_enabled) {
+		if (current->thread.cet.ibt_bitmap_used)
+			msr_ia32_u_cet |= (IBT_BITMAP_ADDR |
+					   MSR_IA32_CET_LEG_IW_EN);
+
+		msr_ia32_u_cet |= (MSR_IA32_CET_ENDBR_EN |
+				   MSR_IA32_CET_NO_TRACK_EN);
+	}
+
 	modify_fpu_regs_begin();
 	wrmsrl(MSR_IA32_PL3_SSP, ssp);
 	wrmsrl(MSR_IA32_U_CET, msr_ia32_u_cet);
-- 
2.17.1
