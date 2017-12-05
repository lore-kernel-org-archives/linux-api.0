From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] mmap.2: MAP_FIXED updated documentation
Date: Tue, 5 Dec 2017 08:08:38 +0100
Message-ID: <20171205070838.u3br5lvshywkwxby@dhcp22.suse.cz>
References: <20171204021411.4786-1-jhubbard@nvidia.com>
 <20171204113113.GA13465@rapoport-lnx>
 <6777116d-ad9e-48c9-0009-01d10274135e@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6777116d-ad9e-48c9-0009-01d10274135e-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon 04-12-17 18:52:27, John Hubbard wrote:
> On 12/04/2017 03:31 AM, Mike Rapoport wrote:
> > On Sun, Dec 03, 2017 at 06:14:11PM -0800, john.hubbard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >> From: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> >>
> [...]
> >> +.IP
> >> +Given the above limitations, one of the very few ways to use this option
> >> +safely is: mmap() a region, without specifying MAP_FIXED. Then, within that
> >> +region, call mmap(MAP_FIXED) to suballocate regions. This avoids both the
> >> +portability problem (because the first mmap call lets the kernel pick the
> >> +address), and the address space corruption problem (because the region being
> >> +overwritten is already owned by the calling thread).
> > 
> > Maybe "address space corruption problem caused by implicit calls to mmap"?
> > The region allocated with the first mmap is not exactly owned by the
> > thread and a multi-thread application can still corrupt its memory if
> > different threads use mmap(MAP_FIXED) for overlapping regions.
> > 
> > My 2 cents.
> > 
> 
> Hi Mike,
> 
> Yes, thanks for picking through this, and I agree that the above is misleading.
> It should definitely not use the word "owned" at all. Re-doing the whole 
> paragraph in order to make it all fit together nicely, I get this:
> 
> "Given the above limitations, one of the very few ways to use this option
> safely is: mmap() an enclosing region, without specifying MAP_FIXED.
> Then, within that region, call mmap(MAP_FIXED) to suballocate regions
> within the enclosing region. This avoids both the portability problem 
> (because the first mmap call lets the kernel pick the address), and the 
> address space corruption problem (because implicit calls to mmap will 
> not affect the already-mapped enclosing region)."
> 
> ...how's that sound to you? I'll post a v3 soon with this.

It sounds to me you are trying to tell way to much while actually being
a bit misleading. Even sub-range MAP_FIXED is not multi-thread safe.

Really the more corner cases you will try to cover the worse the end
result will end up. I would just try to be simple here and mention the
address space corruption issues you've had earlier and be done with it.
Maybe add a note that some architectures might need a special alignement
and fail if it is not the case but nothing really specific.
-- 
Michal Hocko
SUSE Labs
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
