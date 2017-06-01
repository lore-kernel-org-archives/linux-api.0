From: Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] mm: introduce MADV_CLR_HUGEPAGE
Date: Thu, 1 Jun 2017 11:35:02 +0300
Message-ID: <20170601083501.GC30495@rapoport-lnx>
References: <20170524103947.GC3063@rapoport-lnx>
 <20170524111800.GD14733@dhcp22.suse.cz>
 <20170524142735.GF3063@rapoport-lnx>
 <20170530074408.GA7969@dhcp22.suse.cz>
 <20170530101921.GA25738@rapoport-lnx>
 <20170530103930.GB7969@dhcp22.suse.cz>
 <20170530140456.GA8412@redhat.com>
 <20170530143941.GK7969@dhcp22.suse.cz>
 <20170601065302.GA30495@rapoport-lnx>
 <20170601080909.GD32677@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170601080909.GD32677-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 01, 2017 at 10:09:09AM +0200, Michal Hocko wrote:
> On Thu 01-06-17 09:53:02, Mike Rapoport wrote:
> > On Tue, May 30, 2017 at 04:39:41PM +0200, Michal Hocko wrote:
> > > On Tue 30-05-17 16:04:56, Andrea Arcangeli wrote:
> > > > 
> > > > UFFDIO_COPY while not being a major slowdown for sure, it's likely
> > > > measurable at the microbenchmark level because it would add a
> > > > enter/exit kernel to every 4k memcpy. It's not hard to imagine that as
> > > > measurable. How that impacts the total precopy time I don't know, it
> > > > would need to be benchmarked to be sure.
> > > 
> > > Yes, please!
> > 
> > I've run a simple test (below) that fills 1G of memory either with memcpy
> > of ioctl(UFFDIO_COPY) in 4K chunks.
> > The machine I used has two "Intel(R) Xeon(R) CPU E5-2680 0 @ 2.70GHz" and
> > 128G of RAM.
> > I've averaged elapsed time reported by /usr/bin/time over 100 runs and here
> > what I've got:
> > 
> > memcpy with THP on: 0.3278 sec
> > memcpy with THP off: 0.5295 sec
> > UFFDIO_COPY: 0.44 sec
> 
> I assume that the standard deviation is small?

Yes.
 
> > That said, for the CRIU usecase UFFDIO_COPY seems faster that disabling THP
> > and then doing memcpy.
> 
> That is a bit surprising. I didn't think that the userfault syscall
> (ioctl) can be faster than a regular #PF but considering that
> __mcopy_atomic bypasses the page fault path and it can be optimized for
> the anon case suggests that we can save some cycles for each page and so
> the cumulative savings can be visible.
> 
> -- 
> Michal Hocko
> SUSE Labs
> 
