From: Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] mm: introduce MADV_CLR_HUGEPAGE
Date: Wed, 31 May 2017 12:08:45 +0300
Message-ID: <20170531090844.GA25375@rapoport-lnx>
References: <20170522142927.GG27382@rapoport-lnx>
 <a9e74c22-1a07-f49a-42b5-497fee85e9c9@suse.cz>
 <20170524075043.GB3063@rapoport-lnx>
 <c59a0893-d370-130b-5c33-d567a4621903@suse.cz>
 <20170524103947.GC3063@rapoport-lnx>
 <20170524111800.GD14733@dhcp22.suse.cz>
 <20170524142735.GF3063@rapoport-lnx>
 <20170530074408.GA7969@dhcp22.suse.cz>
 <20170530101921.GA25738@rapoport-lnx>
 <20170530103930.GB7969@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170530103930.GB7969-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 30, 2017 at 12:39:30PM +0200, Michal Hocko wrote:
> On Tue 30-05-17 13:19:22, Mike Rapoport wrote:
> > > > But then we'll have to populate these regions with
> > > > UFFDIO_COPY which adds quite an overhead.
> > > 
> > > How big is the performance impact?
> > 
> > I don't have the numbers handy, but for each post-copy range it means that
> > instead of memcpy() we will use ioctl(UFFDIO_COPY).
> 
> It would be good to measure that though.

I will, but I won't expect huge difference here. Anyway, memcpy() will
touch still unpopulated pages, so we'll anyway enter/exit kernel.

> You are proposing a new user 
> API and the THP api is quite convoluted already so there better be a
> very good reason to add a new API. So far I can only see that it would
> be more convinient to add another madvise command and that is rather
> insufficient justification IMHO.

Well, the most convenient for my use case would be simply disable THP
before restore and re-enable it afterwards. And the need to use
ioctl(UFFDIO_COPY) is not that less convenient that the proposed madvise
command.

I've proposed the new madvise command because I firmly believe it is
missing. All madvise() commands that set some flag in vma->vm_flags have
the counter-command that resets that flag. Except for THP. The THP-related
flags can define three states for a VMA, pretty much like VM_SEQ_READ and
VM_RAND_READ. And it requires three madvise commands to allow setting any
of the desired states, just like with MADV_RANDOM, MADV_SEQUENTIAL and
MADV_NORMAL.

> Also do you expect somebody else would use new madvise? What would be the
> usecase?

I can think of an application that wants to keep 4K pages to save physical
memory for certain phase, e.g. until these pages are populated with very
few data. After the memory usage increases, the application may wish to
stop preventing khugepged from merging these pages, but it does not have
strong inclination to force use of huge pages.

> -- 
> Michal Hocko
> SUSE Labs

--
Sincerely yours,
Mike. 
