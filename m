From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/8] arch: uapi: asm: mman.h: Let MADV_FREE have same
 value for all architectures
Date: Tue, 3 Nov 2015 11:36:51 +0900
Message-ID: <20151103023651.GI17906@bbox>
References: <1446188504-28023-1-git-send-email-minchan@kernel.org>
 <1446188504-28023-4-git-send-email-minchan@kernel.org>
 <alpine.LSU.2.11.1511011542030.11427@eggly.anvils>
 <20151103023250.GH17906@bbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151103023250.GH17906@bbox>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chen Gang <gang.chen.5i5j-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org" <rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org>, "ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org" <ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org>, "mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, jejb@parisc-linu
List-Id: linux-api@vger.kernel.org

On Tue, Nov 03, 2015 at 11:32:51AM +0900, Minchan Kim wrote:
> On Sun, Nov 01, 2015 at 04:08:27PM -0800, Hugh Dickins wrote:
> > On Fri, 30 Oct 2015, Minchan Kim wrote:
> > > From: Chen Gang <gang.chen.5i5j-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > 
> > > For uapi, need try to let all macros have same value, and MADV_FREE is
> > > added into main branch recently, so need redefine MADV_FREE for it.
> > > 
> > > At present, '8' can be shared with all architectures, so redefine it to
> > > '8'.
> > > 
> > > Cc: rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org <rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org>,
> > > Cc: ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org <ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org>
> > > Cc: mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org <mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > Cc: Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
> > > Cc: jejb-6jwH94ZQLHl74goWV3ctuw@public.gmane.org <jejb-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
> > > Cc: deller-Mmb7MZpHnFY@public.gmane.org <deller-Mmb7MZpHnFY@public.gmane.org>
> > > Cc: chris-YvXeqwSYzG2sTnJN9+BGXg@public.gmane.org <chris-YvXeqwSYzG2sTnJN9+BGXg@public.gmane.org>
> > > Cc: jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org <jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> > > Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > Acked-by: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > Signed-off-by: Chen Gang <gang.chen.5i5j-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > 
> > Let me add
> > Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > to this one too.
> > 
> > But I have extended your mail's Cc list: Darrick pointed out earlier
> > that dietlibc has a Solaris #define MADV_FREE 0x5 in its mman.h,
> > and that was in the kernel's sparc mman.h up until 2.6.25.  I doubt
> > that presents any obstacle nowadays, but Dave Miller should be Cc'ed.

For the convenience for Dave, I found this.

commit ec98c6b9b47df6df1c1fa6cf3d427414f8c2cf16
Author: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Date:   Sun Apr 20 02:14:23 2008 -0700

    [SPARC]: Remove SunOS and Solaris binary support.
    
    As per Documentation/feature-removal-schedule.txt
    
    Signed-off-by: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>

Hello Dave,
Could you confirm it?

Thanks.
