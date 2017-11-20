From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 1/2] mm: introduce MAP_FIXED_SAFE
Date: Mon, 20 Nov 2017 10:33:09 +0100
Message-ID: <20171120093309.wobvu6mixbk75m3v@dhcp22.suse.cz>
References: <20171116101900.13621-1-mhocko@kernel.org>
 <20171116101900.13621-2-mhocko@kernel.org>
 <a3f7aed9-0df2-2fd6-cebb-ba569ad66781@redhat.com>
 <20171120085524.y4onsl5dpd3qbh7y@dhcp22.suse.cz>
 <37a6e9ba-e0df-b65f-d5ef-871c25b5cb87@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <37a6e9ba-e0df-b65f-d5ef-871c25b5cb87-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon 20-11-17 10:10:32, Florian Weimer wrote:
> On 11/20/2017 09:55 AM, Michal Hocko wrote:
> > On Fri 17-11-17 08:30:48, Florian Weimer wrote:
> > > On 11/16/2017 11:18 AM, Michal Hocko wrote:
> > > > +	if (flags & MAP_FIXED_SAFE) {
> > > > +		struct vm_area_struct *vma = find_vma(mm, addr);
> > > > +
> > > > +		if (vma && vma->vm_start <= addr)
> > > > +			return -ENOMEM;
> > > > +	}
> > > 
> > > Could you pick a different error code which cannot also be caused by a an
> > > unrelated, possibly temporary condition?  Maybe EBUSY or EEXIST?
> > 
> > Hmm, none of those are described in the man page. I am usually very
> > careful to not add new and potentially unexpected error codes but it is
> 
> I think this is a bad idea.  It leads to bizarre behavior, like open failing
> with EOVERFLOW with certain namespace configurations (which have nothing to
> do with file sizes).

Ohh, I agree but breaking userspace is, you know, no-no. And an
unexpected error codes can break things terribly.

> Most of the manual pages are incomplete regarding error codes, and with
> seccomp filters and security modules, what error codes you actually get is
> anyone's guess.
> 
> > true that a new flag should warrant a new error code. I am not sure
> > which one is more appropriate though. EBUSY suggests that retrying might
> > help which is true only if some other party unmaps the range. So EEXIST
> > would sound more natural.
> 
> Sure, EEXIST is completely fine.

OK, I will use it.
 
> > > This would definitely help with application-based randomization of mappings,
> > > and there, actual ENOMEM and this error would have to be handled
> > > differently.
> > 
> > I see. Could you be more specific about the usecase you have in mind? I
> > would incorporate it into the patch description.
> 
> glibc ld.so currently maps DSOs without hints.  This means that the kernel
> will map right next to each other, and the offsets between them a completely
> predictable.  We would like to change that and supply a random address in a
> window of the address space.  If there is a conflict, we do not want the
> kernel to pick a non-random address. Instead, we would try again with a
> random address.

This makes sense to me. Thanks, I will add it to the cover letter.
-- 
Michal Hocko
SUSE Labs
