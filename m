From: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] mm: only enable sys_pkey* when ARCH_HAS_PKEYS
Date: Tue, 8 Nov 2016 10:39:04 -0800
Message-ID: <c4d177e7-c707-93aa-20be-5959d5193655@linux.intel.com>
References: <1477958904-9903-1-git-send-email-mark.rutland@arm.com>
 <c716d515-409f-4092-73d2-1a81db6c1ba3@linux.intel.com>
 <20161104234459.GA18760@remoulade> <20161108093042.GC3528@osiris>
 <20161108104112.GM1041@n2100.armlinux.org.uk> <20161108112400.GE3528@osiris>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161108112400.GE3528@osiris>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/08/2016 03:24 AM, Heiko Carstens wrote:
> Something like this:
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 11936526b08b..9fb86b107e49 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -484,6 +484,8 @@ SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
>  	return do_mprotect_pkey(start, len, prot, -1);
>  }
>  
> +#ifdef CONFIG_ARCH_HAS_PKEYS
> +
>  SYSCALL_DEFINE4(pkey_mprotect, unsigned long, start, size_t, len,
>  		unsigned long, prot, int, pkey)
>  {
> @@ -534,3 +536,4 @@ SYSCALL_DEFINE1(pkey_free, int, pkey)
>  	 */
>  	return ret;
>  }
> +#endif /* CONFIG_ARCH_HAS_PKEYS */

That's fine with me, fwiw.  It ends up meaning that the config option
changes whether we get -ENOSPC vs. -ENOSYS, so the x86_32 behavior will
change, for instance.  But, I _think_ that's OK.
