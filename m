From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC, PATCHv2 29/29] mm, x86: introduce RLIMIT_VADDR
Date: Wed, 11 Jan 2017 10:26:03 -0800
Message-ID: <3c886ad1-6c70-5875-1e69-4bcef4dbd881@intel.com>
References: <20161227015413.187403-1-kirill.shutemov@linux.intel.com>
 <20161227015413.187403-30-kirill.shutemov@linux.intel.com>
 <5a3dcc25-b264-37c7-c090-09981b23940d@intel.com>
 <20170105192910.q26ozg4ci4i3j2ai@black.fi.intel.com>
 <161ece66-fbf4-cb89-3da6-91b4851af69f@intel.com>
 <CALCETrUQ2+P424d9MW-Dy2yQ0+EnMfBuY80wd8NkNmc8is0AUw@mail.gmail.com>
 <978d5f1a-ec4d-f747-93fd-27ecfe10cb88@intel.com>
 <20170111142904.GD4895@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170111142904.GD4895-sVvlyX1904swdBt8bTSxpkEMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 01/11/2017 06:29 AM, Kirill A. Shutemov wrote:
> +#define mmap_max_addr() \
> +({									\
> +	unsigned long max_addr = min(TASK_SIZE, rlimit(RLIMIT_VADDR));	\
> +	/* At the moment, MPX cannot handle addresses above 47-bits */	\
> +	if (max_addr > USER_VADDR_LIM &&				\
> +			kernel_managing_mpx_tables(current->mm))	\
> + 		max_addr = USER_VADDR_LIM;				\
> + 	max_addr;							\
> +})

The bad part about this is that it adds code to a relatively fast path,
and the check that it's doing will not change its result for basically
the entire life of the process.

I'd much rather see this checking done at the point that MPX is enabled
and at the point the limit is changed.  Those are both super-rare paths.

>  extern u16 amd_get_nb_id(int cpu);
>  extern u32 amd_get_nodes_per_socket(void);
>  
> diff --git a/arch/x86/mm/mpx.c b/arch/x86/mm/mpx.c
> index 324e5713d386..04fa386a165a 100644
> --- a/arch/x86/mm/mpx.c
> +++ b/arch/x86/mm/mpx.c
> @@ -354,10 +354,22 @@ int mpx_enable_management(void)
>  	 */
>  	bd_base = mpx_get_bounds_dir();
>  	down_write(&mm->mmap_sem);
> +
> +	/*
> +	 * MPX doesn't support addresses above 47-bits yes.
> +	 * Make sure nothing is mapped there before enabling.
> +	 */
> +	if (find_vma(mm, 1UL << 47)) {
> +		pr_warn("%s (%d): MPX cannot handle addresses above 47-bits. "
> +				"Disabling.", current->comm, current->pid);
> +		ret = -ENXIO;
> +		goto out;
> +	}

I don't think allowing userspace to spam unlimited amounts of message
into the kernel log is a good idea. :)  But a WARN_ONCE() might not kill
any puppies.
