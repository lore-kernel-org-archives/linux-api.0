From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] mmap.2: MAP_FIXED updated documentation
Date: Tue, 5 Dec 2017 08:05:10 +0100
Message-ID: <20171205070510.aojohhvixijk3i27@dhcp22.suse.cz>
References: <20171204021411.4786-1-jhubbard@nvidia.com>
 <20171204105549.GA31332@rei>
 <efb6eae4-7f30-42c3-0efe-0ab5fbf0fdb4@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <efb6eae4-7f30-42c3-0efe-0ab5fbf0fdb4-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon 04-12-17 18:14:18, John Hubbard wrote:
> On 12/04/2017 02:55 AM, Cyril Hrubis wrote:
> > Hi!
> > I know that we are not touching the rest of the existing description for
> > MAP_FIXED however the second sentence in the manual page says that "addr
> > must be a multiple of the page size." Which however is misleading as
> > this is not enough on some architectures. Code in the wild seems to
> > (mis)use SHMLBA for aligment purposes but I'm not sure that we should
> > advise something like that in the manpages.
> > 
> > So what about something as:
> > 
> > "addr must be suitably aligned, for most architectures multiple of page
> > size is sufficient, however some may impose additional restrictions for
> > page mapping addresses."
> > 
> 
> Hi Cyril,
> 
> Right, so I've been looking into this today, and I think we can go a bit
> further than that, even. The kernel, as far back as the *original* git
> commit in 2005, implements mmap on ARM by requiring that the address is
> aligned to SHMLBA:
> 
> arch/arm/mm/mmap.c:50:
> 
> 	if (flags & MAP_FIXED) {
> 		if (aliasing && flags & MAP_SHARED &&
> 		    (addr - (pgoff << PAGE_SHIFT)) & (SHMLBA - 1))
> 			return -EINVAL;
> 		return addr;
> 	}
> 
> So, given that this has been the implementation for the last 12+ years (and
> probably the whole time, in fact), I think we can be bold enough to use this
> wording for the second sentence of MAP_FIXED:
> 
> "addr must be a multiple of SHMLBA (<sys/shm.h>), which in turn is either
> the system page size (on many architectures) or a multiple of the system
> page size (on some architectures)."
> 
> What do you think?

I am not sure this is a good idea. This is pulling way too many
implementation details into the man page IMHO. Note that your wording is
even incorrect because this applies only to shared mappings and on some
architectures it even requires special memory regions. We do not want
all that in the man page...

-- 
Michal Hocko
SUSE Labs
