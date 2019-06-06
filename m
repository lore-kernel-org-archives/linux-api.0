From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [PATCH v7 04/14] x86/cet/ibt: Handle signals for IBT
Date: Thu,  6 Jun 2019 13:09:16 -0700
Message-ID: <20190606200926.4029-5-yu-cheng.yu@intel.com>
References: <20190606200926.4029-1-yu-cheng.yu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190606200926.4029-1-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

Setup/Restore Indirect Branch Tracking for signals.

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
---
 arch/x86/kernel/cet.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kernel/cet.c b/arch/x86/kernel/cet.c
index e0ef996d3148..e1ab7e722637 100644
--- a/arch/x86/kernel/cet.c
+++ b/arch/x86/kernel/cet.c
@@ -282,6 +282,15 @@ int cet_restore_signal(bool ia32, struct sc_ext *sc_ext)
 		msr_ia32_u_cet |= MSR_IA32_CET_SHSTK_EN;
 	}
 
+	if (current->thread.cet.ibt_enabled) {
+		if (current->thread.cet.ibt_bitmap_addr != 0)
+			msr_ia32_u_cet |= (current->thread.cet.ibt_bitmap_addr |
+					   MSR_IA32_CET_LEG_IW_EN);
+
+		msr_ia32_u_cet |= (MSR_IA32_CET_ENDBR_EN |
+				   MSR_IA32_CET_NO_TRACK_EN);
+	}
+
 	wrmsrl(MSR_IA32_PL3_SSP, new_ssp);
 	wrmsrl(MSR_IA32_U_CET, msr_ia32_u_cet);
 	return 0;
@@ -322,6 +331,15 @@ int cet_setup_signal(bool ia32, unsigned long rstor_addr, struct sc_ext *sc_ext)
 		sc_ext->ssp = new_ssp;
 	}
 
+	if (current->thread.cet.ibt_enabled) {
+		if (current->thread.cet.ibt_bitmap_addr != 0)
+			msr_ia32_u_cet |= (current->thread.cet.ibt_bitmap_addr |
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
