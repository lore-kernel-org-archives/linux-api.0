From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v7 5/6] x86/cpufeature: Detect CPUID faulting support
Date: Thu, 27 Oct 2016 10:21:58 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1610271018180.4817@nanos>
References: <20161019020333.3766-1-khuey@kylehuey.com> <20161019020333.3766-6-khuey@kylehuey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161019020333.3766-6-khuey-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Cc: Robert O'Callahan <robert-7ok7fSEJICeEi8DpZVb4nw@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Dmitry Safonov <dsafonov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, user-mode-linux-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, user-mode-linux-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 18 Oct 2016, Kyle Huey wrote:
>  
> +static bool supports_cpuid_faulting(void)
> +{
> +	unsigned int lo, hi;
> +
> +	if (rdmsr_safe(MSR_PLATFORM_INFO, &lo, &hi))
> +		return false;
> +
> +	return lo & PLATINFO_CPUID_FAULT;
> +}
> +
>  void init_scattered_cpuid_features(struct cpuinfo_x86 *c)
>  {
>  	u32 max_level;
> @@ -54,4 +64,7 @@ void init_scattered_cpuid_features(struct cpuinfo_x86 *c)
>  		if (regs[cb->reg] & (1 << cb->bit))
>  			set_cpu_cap(c, cb->feature);
>  	}
> +
> +	if (supports_cpuid_faulting())
> +		set_cpu_cap(c, X86_FEATURE_CPUID_FAULT);
>  }

Instead of specific magic for this feature I'd rather like to see something
like the completely untested patch below. That allows us to add MSR based
features trivially in the future.

Thanks,

	tglx

8<------------------------

--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -24,11 +24,18 @@ enum cpuid_regs {
 	CR_EBX
 };
 
+struct msr_bit {
+	u16	feature;
+	u16	msr;
+	u8	bit;
+};
+
 void init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 {
-	u32 max_level;
-	u32 regs[4];
 	const struct cpuid_bit *cb;
+	const struct msr_bit *mb;
+	u32 max_level, regs[4];
+	u64 msrval;
 
 	static const struct cpuid_bit cpuid_bits[] = {
 		{ X86_FEATURE_INTEL_PT,		CR_EBX,25, 0x00000007, 0 },
@@ -42,6 +49,11 @@ void init_scattered_cpuid_features(struc
 		{ 0, 0, 0, 0, 0 }
 	};
 
+	static const struct msr_bit msr_bits[] = {
+		{ X86_FEATURE_CPUID_FAULT,	MSR_PLATFORM_INFO, 31 },
+		{ 0, 0, 0 }
+	};
+
 	for (cb = cpuid_bits; cb->feature; cb++) {
 
 		/* Verify that the level is valid */
@@ -56,4 +68,12 @@ void init_scattered_cpuid_features(struc
 		if (regs[cb->reg] & (1 << cb->bit))
 			set_cpu_cap(c, cb->feature);
 	}
+
+	for (mb = msr_bits; mb->feature; mb++) {
+		if (rdmsrl_safe(mb->msr, &msrval))
+			continue;
+		if (msrval & (1ULL << mb->bit))
+			set_cpu_cap(c, mb->feature);
+	}
+
 }
