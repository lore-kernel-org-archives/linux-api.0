From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [PATCH v8 02/27] x86/cpufeatures: Add CET CPU feature flags for Control-flow Enforcement Technology (CET)
Date: Tue, 13 Aug 2019 13:52:00 -0700
Message-ID: <20190813205225.12032-3-yu-cheng.yu@intel.com>
References: <20190813205225.12032-1-yu-cheng.yu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190813205225.12032-1-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

Add CPU feature flags for Control-flow Enforcement Technology (CET).

CPUID.(EAX=7,ECX=0):ECX[bit 7] Shadow stack
CPUID.(EAX=7,ECX=0):EDX[bit 20] Indirect branch tracking

Reviewed-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
---
 arch/x86/include/asm/cpufeatures.h | 2 ++
 arch/x86/kernel/cpu/cpuid-deps.c   | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index e880f2408e29..122265ab46c1 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -334,6 +334,7 @@
 #define X86_FEATURE_OSPKE		(16*32+ 4) /* OS Protection Keys Enable */
 #define X86_FEATURE_WAITPKG		(16*32+ 5) /* UMONITOR/UMWAIT/TPAUSE Instructions */
 #define X86_FEATURE_AVX512_VBMI2	(16*32+ 6) /* Additional AVX512 Vector Bit Manipulation Instructions */
+#define X86_FEATURE_SHSTK		(16*32+ 7) /* Shadow Stack */
 #define X86_FEATURE_GFNI		(16*32+ 8) /* Galois Field New Instructions */
 #define X86_FEATURE_VAES		(16*32+ 9) /* Vector AES */
 #define X86_FEATURE_VPCLMULQDQ		(16*32+10) /* Carry-Less Multiplication Double Quadword */
@@ -358,6 +359,7 @@
 #define X86_FEATURE_MD_CLEAR		(18*32+10) /* VERW clears CPU buffers */
 #define X86_FEATURE_TSX_FORCE_ABORT	(18*32+13) /* "" TSX_FORCE_ABORT */
 #define X86_FEATURE_PCONFIG		(18*32+18) /* Intel PCONFIG */
+#define X86_FEATURE_IBT			(18*32+20) /* Indirect Branch Tracking */
 #define X86_FEATURE_SPEC_CTRL		(18*32+26) /* "" Speculation Control (IBRS + IBPB) */
 #define X86_FEATURE_INTEL_STIBP		(18*32+27) /* "" Single Thread Indirect Branch Predictors */
 #define X86_FEATURE_FLUSH_L1D		(18*32+28) /* Flush L1D cache */
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index b5353244749b..9bf35f081080 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -68,6 +68,8 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_CQM_MBM_TOTAL,	X86_FEATURE_CQM_LLC   },
 	{ X86_FEATURE_CQM_MBM_LOCAL,	X86_FEATURE_CQM_LLC   },
 	{ X86_FEATURE_AVX512_BF16,	X86_FEATURE_AVX512VL  },
+	{ X86_FEATURE_SHSTK,		X86_FEATURE_XSAVES    },
+	{ X86_FEATURE_IBT,		X86_FEATURE_XSAVES    },
 	{}
 };
 
-- 
2.17.1
