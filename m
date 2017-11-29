From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] mm: introduce MAP_FIXED_SAFE
Date: Wed, 29 Nov 2017 16:50:09 +0100
Message-ID: <20171129155009.i5xai77rrapsyrd2@dhcp22.suse.cz>
References: <20171129144219.22867-1-mhocko@kernel.org>
 <b154b794-7a8b-995e-0954-9234b9446b31@prevas.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b154b794-7a8b-995e-0954-9234b9446b31-rjjw5hvvQKZaa/9Udqfwiw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rasmus Villemoes <rasmus.villemoes-rjjw5hvvQKZaa/9Udqfwiw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Abdul Haleem <abdhalee-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed 29-11-17 16:13:53, Rasmus Villemoes wrote:
> On 2017-11-29 15:42, Michal Hocko wrote:
[...]
> >The flag is introduced as a completely
> > new one rather than a MAP_FIXED extension because of the backward
> > compatibility. We really want a never-clobber semantic even on older
> > kernels which do not recognize the flag. Unfortunately mmap sucks wrt.
> > flags evaluation because we do not EINVAL on unknown flags. On those
> > kernels we would simply use the traditional hint based semantic so the
> > caller can still get a different address (which sucks) but at least not
> > silently corrupt an existing mapping. I do not see a good way around
> > that.
> 
> I think it would be nice if this rationale was in the 1/2 changelog,
> along with the hint about what userspace that wants to be compatible
> with old kernels will have to do (namely, check that it got what it
> requested) - which I see you did put in the man page.

OK, I've added there.

-- 
Michal Hocko
SUSE Labs
