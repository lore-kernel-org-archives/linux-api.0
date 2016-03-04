From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: THP-enabled filesystem vs. FALLOC_FL_PUNCH_HOLE
Date: Sat, 5 Mar 2016 02:24:12 +0300
Message-ID: <20160304232412.GC12498@node.shutemov.name>
References: <1457023939-98083-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20160304112603.GA9790@node.shutemov.name>
 <56D9C882.3040808@intel.com>
 <alpine.LSU.2.11.1603041100320.6011@eggly.anvils>
 <20160304230548.GC11282@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160304230548.GC11282@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Jerome Marchand <jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Mar 05, 2016 at 10:05:48AM +1100, Dave Chinner wrote:
> On Fri, Mar 04, 2016 at 11:38:47AM -0800, Hugh Dickins wrote:
> > On Fri, 4 Mar 2016, Dave Hansen wrote:
> > > On 03/04/2016 03:26 AM, Kirill A. Shutemov wrote:
> > > > On Thu, Mar 03, 2016 at 07:51:50PM +0300, Kirill A. Shutemov wrote:
> > > >> Truncate and punch hole that only cover part of THP range is implemented
> > > >> by zero out this part of THP.
> > > >>
> > > >> This have visible effect on fallocate(FALLOC_FL_PUNCH_HOLE) behaviour.
> > > >> As we don't really create hole in this case, lseek(SEEK_HOLE) may have
> > > >> inconsistent results depending what pages happened to be allocated.
> > > >> Not sure if it should be considered ABI break or not.
> > > > 
> > > > Looks like this shouldn't be a problem. man 2 fallocate:
> > > > 
> > > > 	Within the specified range, partial filesystem blocks are zeroed,
> > > > 	and whole filesystem blocks are removed from the file.  After a
> > > > 	successful call, subsequent reads from this range will return
> > > > 	zeroes.
> > > > 
> > > > It means we effectively have 2M filesystem block size.
> > > 
> > > The question is still whether this will case problems for apps.
> > > 
> > > Isn't 2MB a quote unusual block size?  Wouldn't some files on a tmpfs
> > > filesystem act like they have a 2M blocksize and others like they have
> > > 4k?  Would that confuse apps?
> > 
> > At risk of addressing the tip of an iceberg, before diving down to
> > scope out the rest of the iceberg...
> ....
> 
> > (Though in the case of my huge tmpfs, it's the reverse: the small hole
> > punch splits the hugepage; but it's natural that Kirill's way would try
> > to hold on to its compound pages for longer than I do, and that's fine
> > so long as it's all consistent.)
> ....
> > Ah, but suppose someone holepunches out most of each 2M page: they would
> > expect the memcg not to be charged for those holes (just as when they
> > munmap most of an anonymous THP) - that does suggest splitting is needed.
> 
> I think filesystems will expect splitting to happen. They call
> truncate_pagecache_range() on the region that the hole is being
> punched out of, and they expect page cache pages over this range to
> be unmapped, invalidated and then removed from the mapping tree as a
> result. Also, most filesystems think the page cache only contains
> PAGE_CACHE_SIZE mappings, so they are completely unaware of the
> limitations THP might have when it comes to invalidation.
> 
> IOWs, if this range is not aligned to huge page boundaries, then it
> implies the huge page is either split into PAGE_SIZE mappings and
> then the range is invalidated as expected, or it is completely
> invalidated and then refaulted on future accesses which determine if
> THP or normal pages are used for the page being faulted....

The filesystem in question is tmpfs and complete invalidation is not
always an option. For other filesystems it also can be unavailable
immediately if the page is dirty (the dirty flag is tracked on per-THP
basis at the moment).

Would it be acceptable for fallocate(FALLOC_FL_PUNCH_HOLE) to return
-EBUSY (or other errno on your choice), if we cannot split the page
right away?

> Just to complicate things, keep in mind that some filesystems may
> have a PAGE_SIZE block size, but can be convinced to only
> allocate/punch/truncate/etc extents on larger alignments on a
> per-inode basis. IOWs, THP vs hole punch behaviour is not actually
> a filesystem type specific behaviour - it's per-inode specific...

There is also similar question about THP vs. i_size vs. SIGBUS.

For small pages an application will not get SIGBUS on mmap()ed file, until
it wouldn't try to access beyond round_up(i_size, PAGE_CACHE_SIZE) - 1.

For THP it would be round_up(i_size, HPAGE_PMD_SIZE) - 1.

Is it a problem?

-- 
 Kirill A. Shutemov
