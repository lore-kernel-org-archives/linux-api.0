From: Kyle Huey <me@kylehuey.com>
Subject: [PATCH v3 2/3] x86 Test and expose CPUID faulting capabilities in /proc/cpuinfo
Date: Thu, 15 Sep 2016 16:33:23 -0700
Message-ID: <20160915233324.6060-3-khuey@kylehuey.com>
References: <20160915233324.6060-1-khuey@kylehuey.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160915233324.6060-1-khuey@kylehuey.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert O'Callahan <robert@ocallahan.org>
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Dmitry Safonov <0x7f454c46@gmail.com>, Borislav Petkov <bp@suse.de>, linux-api@vger.kernel.org, xen-devel@lists.xenproject.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "maintainer:X86 ARCHITECTURE 32-BIT AND 64-BIT" <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Huang Rui <ray.huang@amd.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Len Brown <len.brown@intel.com>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Kyle Huey <khuey@kylehuey.com>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/msr-index.h   |  1 +
 arch/x86/kernel/cpu/scattered.c    | 14 ++++++++++++++
 3 files changed, 16 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 92a8308..78b9d06 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -190,6 +190,7 @@
 
 #define X86_FEATURE_CPB		( 7*32+ 2) /* AMD Core Performance Boost */
 #define X86_FEATURE_EPB		( 7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
+#define X86_FEATURE_CPUID_FAULT ( 7*32+ 4) /* Intel CPUID faulting */
 
 #define X86_FEATURE_HW_PSTATE	( 7*32+ 8) /* AMD HW-PState */
 #define X86_FEATURE_PROC_FEEDBACK ( 7*32+ 9) /* AMD ProcFeedbackInterface */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 56f4c66..83908d5 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -41,6 +41,7 @@
 #define MSR_IA32_PERFCTR1		0x000000c2
 #define MSR_FSB_FREQ			0x000000cd
 #define MSR_PLATFORM_INFO		0x000000ce
+#define CPUID_FAULTING_SUPPORT		(1UL << 31)
 
 #define MSR_NHM_SNB_PKG_CST_CFG_CTL	0x000000e2
 #define NHM_C3_AUTO_DEMOTE		(1UL << 25)
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 8cb57df..d502da1 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -24,6 +24,17 @@ enum cpuid_regs {
 	CR_EBX
 };
 
+static int supports_cpuid_faulting(void)
+{
+	unsigned int lo, hi;
+
+	if (rdmsr_safe(MSR_PLATFORM_INFO, &lo, &hi) == 0 &&
+	    (lo & CPUID_FAULTING_SUPPORT))
+		return 1;
+	else
+		return 0;
+}
+
 void init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 {
 	u32 max_level;
@@ -54,4 +65,7 @@ void init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 		if (regs[cb->reg] & (1 << cb->bit))
 			set_cpu_cap(c, cb->feature);
 	}
+
+	if (supports_cpuid_faulting())
+		set_cpu_cap(c, X86_FEATURE_CPUID_FAULT);
 }
-- 
2.9.3
