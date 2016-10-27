From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v7 6/6] x86/arch_prctl: Add ARCH_[GET|SET]_CPUID
Date: Thu, 27 Oct 2016 13:15:17 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1610271022030.4817@nanos>
References: <20161019020333.3766-1-khuey@kylehuey.com> <20161019020333.3766-7-khuey@kylehuey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161019020333.3766-7-khuey-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Cc: Robert O'Callahan <robert-7ok7fSEJICeEi8DpZVb4nw@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Dmitry Safonov <dsafonov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, user-mode-linux-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, user-mode-linux-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 18 Oct 2016, Kyle Huey wrote:
> When supported, this feature is controlled by toggling bit 0 of
> MSR_MISC_FEATURES_ENABLES. It is documented in detail in Section 2.3.2 of
> http://www.intel.com/content/dam/www/public/us/en/documents/application-notes/virtualization-technology-flexmigration-application-note.pdf
> 

Bah. I really dislike these document URLs. They often change before a patch
hits Linus tree just because $corps think that restructuring their web
sites every two month is enhancing user experience.

I really wonder if we should start collecting such information in a k.org
wiki or just stick the PDF into the k.org bugzilla so we get a permanent
reference. 

<RANT AT INHELL> 

Can Intel please get its act together and stop sticking stuff in random
application notes instead of properly documenting it in the SDM?

The SDM Sept 2016 still marks bit 31 of the PLATFORM_INFO MSR as reserved
and the MISC_FEATURE_ENABLES msr is mentioned at all. Really useful, NOT!

</RANT>

> +static void switch_cpuid_faulting(bool on)
> +{
> +	if (on)
> +		msr_set_bit(MSR_MISC_FEATURES_ENABLES, 0);

We really want this '0' to be a proper define and not just a hardcoded
value.

> +	else
> +		msr_clear_bit(MSR_MISC_FEATURES_ENABLES, 0);
> +}
> +
> +static void disable_cpuid(void)
> +{
> +	preempt_disable();
> +	if (!test_and_set_thread_flag(TIF_NOCPUID)) {
> +		/*
> +		 * Must flip the CPU state synchronously with
> +		 * TIF_NOCPUID in the current running context.
> +		 */
> +		switch_cpuid_faulting(true);
> +	}
> +	preempt_enable();
> +}
> +
> +static void enable_cpuid(void)
> +{
> +	preempt_disable();
> +	if (test_and_clear_thread_flag(TIF_NOCPUID)) {
> +		/*
> +		 * Must flip the CPU state synchronously with
> +		 * TIF_NOCPUID in the current running context.
> +		 */
> +		switch_cpuid_faulting(false);
> +	}
> +	preempt_enable();
> +}
> +
> +static int get_cpuid_mode(void)
> +{
> +	return test_thread_flag(TIF_NOCPUID) ? ARCH_CPUID_SIGSEGV : ARCH_CPUID_ENABLE;
> +}
> +
> +static int set_cpuid_mode(struct task_struct *task, unsigned long val)
> +{
> +	/* Only disable_cpuid() if it is supported on this hardware. */
> +	bool cpuid_fault_supported = static_cpu_has(X86_FEATURE_CPUID_FAULT);

Errm. Why are you restricting this to disable_cpuid()? If that feature is
off then there is no guarantee that MSR_MISC_FEATURES_ENABLES is
accessible. This wants to have:

	if (!static_cpu_has(X86_FEATURE_CPUID_FAULT))
		return -ENODEV;

or some other sensible error code.

> +	if (val == ARCH_CPUID_ENABLE)
> +		enable_cpuid();
> +	else if (val == ARCH_CPUID_SIGSEGV && cpuid_fault_supported)
> +		disable_cpuid();
> +	else
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +/*
> + * Called immediately after a successful exec.
> + */
> +void arch_setup_new_exec(void)
> +{
> +	/* If cpuid was previously disabled for this task, re-enable it. */
> +	if (test_thread_flag(TIF_NOCPUID))
> +		enable_cpuid();
> +}
> +
>  void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
>  		      struct tss_struct *tss)
>  {
> @@ -211,6 +276,15 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
>  		update_debugctlmsr(debugctl);
>  	}
>  
> +	if (test_tsk_thread_flag(prev_p, TIF_NOCPUID) ^
> +	    test_tsk_thread_flag(next_p, TIF_NOCPUID)) {
> +		/* prev and next are different */

Why commenting the obvious? That's clear from the code.

> +		if (test_tsk_thread_flag(next_p, TIF_NOCPUID))
> +			switch_cpuid_faulting(true);
> +		else
> +			switch_cpuid_faulting(false);

This is insane. The compiler makes that a conditional jump and then in
switch_cpuid_faulting we get another one. Further switch_cpuid_faulting()
calls into lib/msr which is adding even more overhead.

msr_set/clear_bit() are nice for random driver code, but complete overkill
for the context switch hotpath.

That's just not acceptable for switch_to(). We keep adding cruft and then
wonder why context switches slow down despite machines getting faster.

This can and needs to be done smarter. See untested patch below. The
resulting code has a single conditional jump, which is obviously the check
for a change between prev and next. Everything else is done with straight
linear shift,add,and,rdmsr,wrmsr instructions.

> @@ -587,5 +661,25 @@ unsigned long get_wchan(struct task_struct *p)
>  
>  long do_arch_prctl_common(struct task_struct *task, int code, unsigned long arg2)
>  {
> -	return -EINVAL;
> +	int ret = 0;
> +
> +	switch (code) {
> +	case ARCH_GET_CPUID: {
> +		if (arg2 != 0)
> +			ret = -EINVAL;
> +		else
> +			ret = get_cpuid_mode();
> +		break;
> +	}
> +	case ARCH_SET_CPUID: {
> +		ret = set_cpuid_mode(task, arg2);
> +		break;
> +	}
> +
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	return ret;

If you try hard, you might come up with a variant which takes even more
lines.

The delta patch below applies on top of this patch and is completely
untested. If you find bugs, you own them :)

Thanks,

	tglx

8<-----------------------

--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -54,6 +54,7 @@
 #define MSR_IA32_BBL_CR_CTL		0x00000119
 #define MSR_IA32_BBL_CR_CTL3		0x0000011e
 #define MSR_MISC_FEATURES_ENABLES	0x00000140
+#define CPUID_FAULT_ENABLE		(1ULL << 0)
 
 #define MSR_IA32_SYSENTER_CS		0x00000174
 #define MSR_IA32_SYSENTER_ESP		0x00000175
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -193,12 +193,17 @@ int set_tsc_mode(unsigned int val)
 	return 0;
 }
 
-static void switch_cpuid_faulting(bool on)
+#define CPUID_FAULT_ON_MASK	(~0ULL)
+#define CPUID_FAULT_OFF_MASK	(~CPUID_FAULT_ENABLE)
+
+static void cpuid_fault_ctrl(u64 msk)
 {
-	if (on)
-		msr_set_bit(MSR_MISC_FEATURES_ENABLES, 0);
-	else
-		msr_clear_bit(MSR_MISC_FEATURES_ENABLES, 0);
+	u64 msrval;
+
+	rdmsrl(MSR_MISC_FEATURES_ENABLES, msrval);
+	msrval |= CPUID_FAULT_ENABLE;
+	msrval &= msk;
+	wrmsrl(MSR_MISC_FEATURES_ENABLES, msrval);
 }
 
 static void disable_cpuid(void)
@@ -209,7 +214,7 @@ static void disable_cpuid(void)
 		 * Must flip the CPU state synchronously with
 		 * TIF_NOCPUID in the current running context.
 		 */
-		switch_cpuid_faulting(true);
+		cpuid_fault_ctrl(CPUID_FAULT_OFF_MASK);
 	}
 	preempt_enable();
 }
@@ -222,7 +227,7 @@ static void enable_cpuid(void)
 		 * Must flip the CPU state synchronously with
 		 * TIF_NOCPUID in the current running context.
 		 */
-		switch_cpuid_faulting(false);
+		cpuid_fault_ctrl(CPUID_FAULT_ON_MASK);
 	}
 	preempt_enable();
 }
@@ -234,16 +239,18 @@ static int get_cpuid_mode(void)
 
 static int set_cpuid_mode(struct task_struct *task, unsigned long val)
 {
-	/* Only disable_cpuid() if it is supported on this hardware. */
-	bool cpuid_fault_supported = static_cpu_has(X86_FEATURE_CPUID_FAULT);
+	if (static_cpu_has(X86_FEATURE_CPUID_FAULT))
+		return -ENODEV;
 
-	if (val == ARCH_CPUID_ENABLE)
+	switch (val) {
+	case ARCH_CPUID_ENABLE:
 		enable_cpuid();
-	else if (val == ARCH_CPUID_SIGSEGV && cpuid_fault_supported)
+		break;
+	case ARCH_CPUID_SIGSEGV:
 		disable_cpuid();
-	else
-		return -EINVAL;
-
+		break;
+	default: return -EINVAL;
+	}
 	return 0;
 }
 
@@ -278,11 +285,10 @@ void __switch_to_xtra(struct task_struct
 
 	if (test_tsk_thread_flag(prev_p, TIF_NOCPUID) ^
 	    test_tsk_thread_flag(next_p, TIF_NOCPUID)) {
-		/* prev and next are different */
-		if (test_tsk_thread_flag(next_p, TIF_NOCPUID))
-			switch_cpuid_faulting(true);
-		else
-			switch_cpuid_faulting(false);
+		bool set = test_tsk_thread_flag(next_p, TIF_NOCPUID);
+		u64 msk = set ? CPUID_FAULT_ON_MASK : CPUID_FAULT_OFF_MASK;
+
+		cpuid_fault_ctrl(msk);
 	}
 
 	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
@@ -661,25 +667,11 @@ unsigned long get_wchan(struct task_stru
 
 long do_arch_prctl_common(struct task_struct *task, int code, unsigned long arg2)
 {
-	int ret = 0;
-
 	switch (code) {
-	case ARCH_GET_CPUID: {
-		if (arg2 != 0)
-			ret = -EINVAL;
-		else
-			ret = get_cpuid_mode();
-		break;
-	}
-	case ARCH_SET_CPUID: {
-		ret = set_cpuid_mode(task, arg2);
-		break;
+	case ARCH_GET_CPUID:
+		return arg2 ? -EINVAL : get_cpuid_mode();
+	case ARCH_SET_CPUID:
+		return set_cpuid_mode(task, arg2);
 	}
-
-	default:
-		ret = -EINVAL;
-		break;
-	}
-
-	return ret;
+	return -EINVAL;
 }
