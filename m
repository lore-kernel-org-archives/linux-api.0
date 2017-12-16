From: Ram Pai <linuxram-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: pkeys: Support setting access rights for signal handlers
Date: Sat, 16 Dec 2017 09:20:26 -0800
Message-ID: <20171216172026.GC5461@ram.oc3035372033.ibm.com>
References: <20171212231324.GE5460@ram.oc3035372033.ibm.com>
 <9dc13a32-b1a6-8462-7e19-cfcf9e2c151e@redhat.com>
 <20171213113544.GG5460@ram.oc3035372033.ibm.com>
 <9f86d79e-165a-1b8e-32dd-7e4e8579da59@redhat.com>
 <c220f36f-c04a-50ae-3fd7-2c6245e27057@intel.com>
 <93153ac4-70f0-9d17-37f1-97b80e468922@redhat.com>
 <20171214001756.GA5471@ram.oc3035372033.ibm.com>
 <cf13f6e0-2405-4c58-4cf1-266e8baae825@redhat.com>
 <20171216150910.GA5461@ram.oc3035372033.ibm.com>
 <2eba29f4-804d-b211-1293-52a567739cad@redhat.com>
Reply-To: Ram Pai <linuxram-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2eba29f4-804d-b211-1293-52a567739cad-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-x86_64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Dec 16, 2017 at 04:25:14PM +0100, Florian Weimer wrote:
> On 12/16/2017 04:09 PM, Ram Pai wrote:
> 
> >>It still restores the PKRU register value upon
> >>regular exit from the signal handler, which I think is something we
> >>should keep.
> >
> >On x86, the pkru value is restored, on return from the signal handler,
> >to the value before the signal handler was called. right?
> >
> >In other words, if 'x' was the value when signal handler was called, it
> >will be 'x' when return from the signal handler.
> >
> >If correct, than it is consistent with the behavior on POWER.
> 
> That's good to know.  I tended to implement the same semantics on x86.
> 
> >>I think we still should add a flag, so that applications can easily
> >>determine if a kernel has this patch.  Setting up a signal handler,
> >>sending the signal, and thus checking for inheritance is a bit
> >>involved, and we'd have to do this in the dynamic linker before we
> >>can use pkeys to harden lazy binding.  The flag could just be a
> >>no-op, apart from the lack of an EINVAL failure if it is specified.
> >
> >Sorry. I am little confused.  What should I implement on POWER?
> >PKEY_ALLOC_SETSIGNAL semantics?
> 
> No, we would add a flag, with a different name, and this patch only:
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index ec39f73..021f1d4 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -523,14 +523,17 @@ static int do_mprotect_pkey(unsigned long
> start, size_t l
>         return do_mprotect_pkey(start, len, prot, pkey);
>  }
> 
> +#define PKEY_ALLOC_FLAGS ((unsigned long) (PKEY_ALLOC_SETSIGNAL))
> +
>  SYSCALL_DEFINE2(pkey_alloc, unsigned long, flags, unsigned long, init_val)
>  {
>         int pkey;
>         int ret;
> 
> -       /* No flags supported yet. */
> -       if (flags)
> +       /* check for unsupported flags */
> +       if (flags & ~PKEY_ALLOC_FLAGS)
>                 return -EINVAL;
> +
>         /* check for unsupported init values */
>         if (init_val & ~PKEY_ACCESS_MASK)
>                 return -EINVAL;
> 
> 
> This way, an application can specify the flag during key allocation,
> and knows that if the allocation succeeds, the kernel implements
> access rights inheritance in signal handlers.  I think we need this
> so that applications which are incompatible with the earlier x86
> implementation of memory protection keys do not use them.
> 
> With my second patch (not the first one implementing
> PKEY_ALLOC_SETSIGNAL), no further changes to architecture=specific
> code are needed, except for the definition of the flag in the header
> files.

Ok. Sounds like I do not have much to do. My patches in its current form
will continue to work and provide the semantics you envision.


> 
> I'm open to a different way towards conveying this information to
> userspace.  I don't want to probe for the behavior by sending a
> signal because that is quite involved and would also be visible in
> debuggers, confusing programmers.

I am fine with your proposal.
RP
