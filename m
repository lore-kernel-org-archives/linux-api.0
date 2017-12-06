From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] mm: introduce MAP_FIXED_SAFE
Date: Wed, 6 Dec 2017 10:08:03 +0100
Message-ID: <20171206090803.GG16386@dhcp22.suse.cz>
References: <20171129144219.22867-1-mhocko@kernel.org>
 <CAGXu5jLa=b2HhjWXXTQunaZuz11qUhm5aNXHpS26jVqb=G-gfw@mail.gmail.com>
 <20171130065835.dbw4ajh5q5whikhf@dhcp22.suse.cz>
 <87zi6we9z2.fsf@concordia.ellerman.id.au>
 <a3b3129a-2626-a65e-59b0-68aada523723@prevas.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a3b3129a-2626-a65e-59b0-68aada523723-rjjw5hvvQKZaa/9Udqfwiw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rasmus Villemoes <rasmus.villemoes-rjjw5hvvQKZaa/9Udqfwiw@public.gmane.org>
Cc: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Abdul Haleem <abdhalee-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed 06-12-17 08:33:37, Rasmus Villemoes wrote:
> On 2017-12-06 05:50, Michael Ellerman wrote:
> > Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:
> > 
> >> On Wed 29-11-17 14:25:36, Kees Cook wrote:
> >> It is safe in a sense it doesn't perform any address space dangerous
> >> operations. mmap is _inherently_ about the address space so the context
> >> should be kind of clear.
> > 
> > So now you have to define what "dangerous" means.
> > 
> >>> MAP_FIXED_UNIQUE
> >>> MAP_FIXED_ONCE
> >>> MAP_FIXED_FRESH
> >>
> >> Well, I can open a poll for the best name, but none of those you are
> >> proposing sound much better to me. Yeah, naming sucks...
> 
> I also don't like the _SAFE name - MAP_FIXED in itself isn't unsafe [1],
> but I do agree that having a way to avoid clobbering (parts of) an
> existing mapping is quite useful. Since we're bikeshedding names, how
> about MAP_FIXED_EXCL, in analogy with the O_ flag.

I really give up on the name discussion. I will take whatever the
majority comes up with. I just do not want this (useful) funtionality
get bikeched to death.
-- 
Michal Hocko
SUSE Labs
