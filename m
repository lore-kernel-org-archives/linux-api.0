From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH 28/34] x86: wire up mprotect_key() system call
Date: Tue, 8 Dec 2015 21:38:12 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1512082134470.3595@nanos>
References: <20151204011424.8A36E365@viggo.jf.intel.com> <20151204011503.2A095839@viggo.jf.intel.com> <alpine.DEB.2.11.1512081943270.3595@nanos> <56672A50.4010801@sr71.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56672A50.4010801-gkUM19QKKo4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 8 Dec 2015, Dave Hansen wrote:
> On 12/08/2015 10:44 AM, Thomas Gleixner wrote:
> > On Thu, 3 Dec 2015, Dave Hansen wrote:
> >>  #include <asm-generic/mman.h>
> >> diff -puN mm/Kconfig~pkeys-16-x86-mprotect_key mm/Kconfig
> >> --- a/mm/Kconfig~pkeys-16-x86-mprotect_key	2015-12-03 16:21:31.114920208 -0800
> >> +++ b/mm/Kconfig	2015-12-03 16:21:31.119920435 -0800
> >> @@ -679,4 +679,5 @@ config NR_PROTECTION_KEYS
> >>  	# Everything supports a _single_ key, so allow folks to
> >>  	# at least call APIs that take keys, but require that the
> >>  	# key be 0.
> >> +	default 16 if X86_INTEL_MEMORY_PROTECTION_KEYS
> >>  	default 1
> > 
> > What happens if I set that to 42?
> > 
> > I think we want to make this a runtime evaluated thingy. If pkeys are
> > compiled in, but the machine does not support it then we don't support
> > 16 keys, or do we?
> 
> We do have runtime evaluation:
> 
> #define arch_max_pkey() (boot_cpu_has(X86_FEATURE_OSPKE) ?      \
>                              CONFIG_NR_PROTECTION_KEYS : 1)
> 
> The config option really just sets the architectural limit for how many
> are supported.  So it probably needs a better name at least.  Let me
> take a look at getting rid of this config option entirely.

Well, it does not set the architectural limit. It sets some random
value which the guy who configures the kernel choses.

The limit we have in the architecture is 16 because we only have 4
bits for it.
 
arch_max_pkey() is architecture specific, so we can make this:

#define arch_max_pkey() (boot_cpu_has(X86_FEATURE_OSPKE) ? 16 : 1)

And when we magically get more bits in the next century, then '16' can
become a variable or whatever.

Thanks,

	tglx
