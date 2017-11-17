From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH 1/2] mm: introduce MAP_FIXED_SAFE
Date: Fri, 17 Nov 2017 11:12:51 -0800
Message-ID: <20171117191251.GA1601@bombadil.infradead.org>
References: <20171116101900.13621-1-mhocko@kernel.org>
 <20171116101900.13621-2-mhocko@kernel.org>
 <CAGXu5jKssQCcYcZujvQeFy5LTzhXSW=f-a0riB=4+caT1i38BQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jKssQCcYcZujvQeFy5LTzhXSW=f-a0riB=4+caT1i38BQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 16, 2017 at 04:27:36PM -0800, Kees Cook wrote:
> On Thu, Nov 16, 2017 at 2:18 AM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> >
> > MAP_FIXED is used quite often to enforce mapping at the particular
> > range. The main problem of this flag is, however, that it is inherently
> > dangerous because it unmaps existing mappings covered by the requested
> > range. This can cause silent memory corruptions. Some of them even with
> > serious security implications. While the current semantic might be
> > really desiderable in many cases there are others which would want to
> > enforce the given range but rather see a failure than a silent memory
> > corruption on a clashing range. Please note that there is no guarantee
> > that a given range is obeyed by the mmap even when it is free - e.g.
> > arch specific code is allowed to apply an alignment.
> >
> > Introduce a new MAP_FIXED_SAFE flag for mmap to achieve this behavior.
> > It has the same semantic as MAP_FIXED wrt. the given address request
> > with a single exception that it fails with ENOMEM if the requested
> > address is already covered by an existing mapping. We still do rely on
> > get_unmaped_area to handle all the arch specific MAP_FIXED treatment and
> > check for a conflicting vma after it returns.
> 
> I like this much more than special-casing the ELF loader. It is an
> unusual property that MAP_FIXED does _two_ things, so I like having
> this split out.
> 
> Bikeshedding: maybe call this MAP_NO_CLOBBER? It's a modifier to
> MAP_FIXED, really...

Way back when, I proposed a new flag called MAP_FIXED_WEAK.  I was
dissuaded from it when userspace people said it was just as easy for
them to provide the address hint, then run fixups on their data if the
address they were assigned wasn't the one they asked for.

The real problem is that MAP_FIXED should have been called MAP_FORCE.

So ... do we really have users that want failure instead of success at
a different address?  And if so, is it really a hardship for them to
make a call to unmap on success-at-the-wrong-address?
