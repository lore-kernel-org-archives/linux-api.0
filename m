From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: THP-enabled filesystem vs. FALLOC_FL_PUNCH_HOLE
Date: Mon, 7 Mar 2016 10:03:36 +1100
Message-ID: <20160306230336.GE11282@dastard>
References: <1457023939-98083-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20160304112603.GA9790@node.shutemov.name>
 <56D9C882.3040808@intel.com>
 <alpine.LSU.2.11.1603041100320.6011@eggly.anvils>
 <20160304230548.GC11282@dastard>
 <20160304232412.GC12498@node.shutemov.name>
 <20160305223811.GD11282@dastard>
 <20160306003034.GA13704@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160306003034.GA13704-sVvlyX1904swdBt8bTSxpkEMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Jerome Marchand <jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Mar 06, 2016 at 03:30:34AM +0300, Kirill A. Shutemov wrote:
> On Sun, Mar 06, 2016 at 09:38:11AM +1100, Dave Chinner wrote:
> > On Sat, Mar 05, 2016 at 02:24:12AM +0300, Kirill A. Shutemov wrote:
> > > Would it be acceptable for fallocate(FALLOC_FL_PUNCH_HOLE) to return
> > > -EBUSY (or other errno on your choice), if we cannot split the page
> > > right away?
> > 
> > Which means THP are not transparent any more. What does an
> > application do when it gets an EBUSY, anyway?
> 
> I guess it's reasonable to expect from an application to handle EOPNOTSUPP
> as FALLOC_FL_PUNCH_HOLE is not supported by some filesystems.

Yes, but this is usually done as a check at the program
initialisation to determine whether to issue hole punches at all.
It's not suppose to be a dynamic error.

> Although, non-consistent result from the same fd can be confusing.

Exactly.

> > And it's not just hole punching that has this problem. Direct IO is
> > going to have the same issue with invalidation of the mapped ranges
> > over the IO being done. XFS already WARNs when page cache
> > invalidation fails with EBUSY in direct IO, because that is
> > indicative of an application with a potential data corruption vector
> > and there's nothing we can do in the kernel code to prevent it.
> 
> My current understanding is that for filesystems with persistent storage,
> in order to make THP any useful, we would need to implement writeback
> without splitting the huge page.

Algorithmically it is no different to filesytem block size < page
size writeback.

> At the moment, I have no idea how hard it would be..

THP support would effectively require us to remove PAGE_CACHE_SIZE
assumptions from all of the filesystem and buffer code. That's a
large chunk of work e.g.  fs/buffer.c and any filesystem that uses
bufferheads for tracking filesystem block state through the page
cache.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
