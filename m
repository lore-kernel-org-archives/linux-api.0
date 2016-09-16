From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v3 2/3] x86 Test and expose CPUID faulting capabilities
 in /proc/cpuinfo
Date: Fri, 16 Sep 2016 12:13:01 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1609160959020.5384@nanos>
References: <20160915233324.6060-1-khuey@kylehuey.com> <20160915233324.6060-3-khuey@kylehuey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160915233324.6060-3-khuey-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Cc: Robert O'Callahan <robert-7ok7fSEJICeEi8DpZVb4nw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Huang Rui <ray.huang-5C7GfCeVMHo@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Srinivas Pandruvada <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 15 Sep 2016, Kyle Huey wrote:

Please use proper prefixes for your patch:

git-log arch/x86/kernel/cpu/scattered.c will give you the hint:

x86/cpufeature: Move some of the scattered feature bits to x86_capability
x86/cpufeature: Correct spelling of the HWP_NOTIFY flag

and make the subject line short. Long sentences belong into the body of the
changelog.

And again this changelog does not tell anything.

What is this CPUID faulting support?
Which CPUs do support this?
Why do we want this?

>  #define X86_FEATURE_CPB		( 7*32+ 2) /* AMD Core Performance Boost */
>  #define X86_FEATURE_EPB		( 7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
> +#define X86_FEATURE_CPUID_FAULT ( 7*32+ 4) /* Intel CPUID faulting */

Boris?

>  #define X86_FEATURE_HW_PSTATE	( 7*32+ 8) /* AMD HW-PState */
>  #define X86_FEATURE_PROC_FEEDBACK ( 7*32+ 9) /* AMD ProcFeedbackInterface */
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 56f4c66..83908d5 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -41,6 +41,7 @@
>  #define MSR_IA32_PERFCTR1		0x000000c2
>  #define MSR_FSB_FREQ			0x000000cd
>  #define MSR_PLATFORM_INFO		0x000000ce
> +#define CPUID_FAULTING_SUPPORT		(1UL << 31)

If you look at the other MSR bit defines then they have always a prefix
which links them to the MSR....

What's the name of this bit in the Documentation?

> +static int supports_cpuid_faulting(void)

bool please

> +{
> +	unsigned int lo, hi;
> +
> +	if (rdmsr_safe(MSR_PLATFORM_INFO, &lo, &hi) == 0 &&
> +	    (lo & CPUID_FAULTING_SUPPORT))
> +		return 1;
> +	else
> +		return 0;

  	if (rdmsr_safe(MSR_PLATFORM_INFO, &lo, &hi))
		return false;

	return lo & PLATINFO_CPUID_FAULT;

would make it readable without linebreaks.

Thanks,

	tglx
 
