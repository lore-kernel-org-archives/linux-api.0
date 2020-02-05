From: Yu-cheng Yu <yu-cheng.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH v9 3/7] x86/cet/ibt: Handle signals for Indirect Branch Tracking
Date: Wed,  5 Feb 2020 10:23:04 -0800
Message-ID: <20200205182308.4028-4-yu-cheng.yu@intel.com>
References: <20200205182308.4028-1-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200205182308.4028-1-yu-cheng.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Eugene Syromiatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H.J. Lu" <hjl.tools-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Nadav Amit <nadav.amit-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yu-cheng Yu <yu-cheng.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Indirect Branch Tracking setting does not change in signal delivering or
sigreturn; except the WAIT_ENDBR status.  In general, a task is in
WAIT_ENDBR after an indirect CALL/JMP and before the next instruction
starts.

WAIT_ENDBR status can be read from MSR_IA32_U_CET.  It is reset for signal
delivering, but preserved on a task's stack and restored for sigreturn.

v9:
- Fix missing WAIT_ENDBR in signal handling.

Signed-off-by: Yu-cheng Yu <yu-cheng.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/kernel/cet.c        | 24 ++++++++++++++++++++++--
 arch/x86/kernel/fpu/signal.c |  8 +++++---
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cet.c b/arch/x86/kernel/cet.c
index 26f5d7c4fbff..07864bef23f9 100644
--- a/arch/x86/kernel/cet.c
+++ b/arch/x86/kernel/cet.c
@@ -280,7 +280,7 @@ int cet_restore_signal(bool ia32, struct sc_ext *sc_ext)
 	u64 msr_val = 0;
 	int err;
 
-	if (!cet->shstk_enabled)
+	if (!cet->shstk_enabled && !cet->ibt_enabled)
 		return 0;
 
 	cet_user_state = get_xsave_addr(&current->thread.fpu.state.xsave,
@@ -297,6 +297,16 @@ int cet_restore_signal(bool ia32, struct sc_ext *sc_ext)
 		msr_val |= MSR_IA32_CET_SHSTK_EN;
 	}
 
+	if (cet->ibt_enabled) {
+		msr_val |= (MSR_IA32_CET_ENDBR_EN | MSR_IA32_CET_NO_TRACK_EN);
+
+		if (cet->ibt_bitmap_used)
+			msr_val |= (cet->ibt_bitmap_base | MSR_IA32_CET_LEG_IW_EN);
+
+		if (sc_ext->wait_endbr)
+			msr_val |= MSR_IA32_CET_WAIT_ENDBR;
+	}
+
 	cet_user_state->user_cet = msr_val;
 	return 0;
 }
@@ -312,7 +322,7 @@ int cet_setup_signal(bool ia32, unsigned long rstor_addr, struct sc_ext *sc_ext)
 	unsigned long ssp = 0, new_ssp = 0;
 	int err;
 
-	if (!cet->shstk_enabled)
+	if (!cet->shstk_enabled && !cet->ibt_enabled)
 		return 0;
 
 	if (cet->shstk_enabled) {
@@ -339,6 +349,16 @@ int cet_setup_signal(bool ia32, unsigned long rstor_addr, struct sc_ext *sc_ext)
 	}
 
 	start_update_msrs();
+	if (cet->ibt_enabled) {
+		u64 r;
+
+		rdmsrl(MSR_IA32_U_CET, r);
+		if (r & MSR_IA32_CET_WAIT_ENDBR) {
+			sc_ext->wait_endbr = 1;
+			wrmsrl(MSR_IA32_U_CET, r & ~MSR_IA32_CET_WAIT_ENDBR);
+		}
+	}
+
 	if (cet->shstk_enabled)
 		wrmsrl(MSR_IA32_PL3_SSP, ssp);
 	end_update_msrs();
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 875cc0fadce3..1d8a75408b95 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -57,7 +57,8 @@ int save_cet_to_sigframe(void __user *fp, unsigned long restorer, int is_ia32)
 	int err = 0;
 
 #ifdef CONFIG_X86_INTEL_CET
-	if (!current->thread.cet.shstk_enabled)
+	if (!current->thread.cet.shstk_enabled &&
+	    !current->thread.cet.ibt_enabled)
 		return 0;
 
 	if (fp) {
@@ -89,7 +90,8 @@ static int restore_cet_from_sigframe(int is_ia32, void __user *fp)
 	int err = 0;
 
 #ifdef CONFIG_X86_INTEL_CET
-	if (!current->thread.cet.shstk_enabled)
+	if (!current->thread.cet.shstk_enabled &&
+	    !current->thread.cet.ibt_enabled)
 		return 0;
 
 	if (fp) {
@@ -548,7 +550,7 @@ static unsigned long fpu__alloc_sigcontext_ext(unsigned long sp)
 	if (cpu_x86_cet_enabled()) {
 		struct cet_status *cet = &current->thread.cet;
 
-		if (cet->shstk_enabled)
+		if (cet->shstk_enabled || cet->ibt_enabled)
 			sp -= (sizeof(struct sc_ext) + 8);
 	}
 
-- 
2.21.0
