From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: introduce MADV_CLR_HUGEPAGE
Date: Wed, 31 May 2017 16:32:17 +0200
Message-ID: <20170531143216.GR27783@dhcp22.suse.cz>
References: <20170524142735.GF3063@rapoport-lnx>
 <20170530074408.GA7969@dhcp22.suse.cz>
 <20170530101921.GA25738@rapoport-lnx>
 <20170530103930.GB7969@dhcp22.suse.cz>
 <20170530140456.GA8412@redhat.com>
 <20170530143941.GK7969@dhcp22.suse.cz>
 <20170530154326.GB8412@redhat.com>
 <20170531120822.GL27783@dhcp22.suse.cz>
 <8FA5E4C2-D289-4AF5-AA09-6C199E58F9A5@linux.vnet.ibm.com>
 <20170531141809.GB302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170531141809.GB302-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mike Rapoprt <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed 31-05-17 16:18:09, Andrea Arcangeli wrote:
> On Wed, May 31, 2017 at 03:39:22PM +0300, Mike Rapoport wrote:
> > For the CRIU usecase, disabling THP for a while and re-enabling it
> > back will do the trick, provided VMAs flags are not affected, like
> > in the patch you've sent.  Moreover, we may even get away with
> 
> Are you going to check uname -r to know when the kABI changed in your
> favor (so CRIU cannot ever work with enterprise backports unless you
> expand the uname -r coverage), or how do you know the patch is
> applied?

I would assume such a patch would be backported to stable trees because
to me it sounds like the current semantic is simply broken and needs
fixing anyway but it shouldn't be much different from any other bugs.

This is far from ideal from the "guarantee POV" of course.

> Optimistically assuming people is going to run new CRIU code only on
> new kernels looks very risky, it would leads to silent random memory
> corruption, so I doubt you can get away without a uname -r check.
> 
> This is fairly simple change too, its main cons is that it adds a
> branch to the page fault fast path, the old behavior of the prctl and
> the new madvise were both zero cost.
> 
> Still if the prctl is preferred despite the added branch, to avoid
> uname -r clashes, to me it sounds better to add a new prctl ID and
> keep the old one too. The old one could be implemented the same way as
> the new one if you want to save a few bytes of .text. But the old one
> should probably do a printk_once to print a deprecation warning so the
> old ID with weaker (zero runtime cost) semantics can be removed later.

this would be an option as well although it adds to the mess...

-- 
Michal Hocko
SUSE Labs
