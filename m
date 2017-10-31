From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 17/17] xfs: support for synchronous DAX faults
Date: Tue, 31 Oct 2017 16:19:07 +0100
Message-ID: <20171031151907.GB26128@quack2.suse.cz>
References: <20171024152415.22864-1-jack@suse.cz>
 <20171024152415.22864-18-jack@suse.cz>
 <20171024222322.GX3666@dastard>
 <20171026154804.GF31161@quack2.suse.cz>
 <20171026211611.GC3666@dastard>
 <20171027100834.GH31161@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171027100834.GH31161-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri 27-10-17 12:08:34, Jan Kara wrote:
> On Fri 27-10-17 08:16:11, Dave Chinner wrote:
> > On Thu, Oct 26, 2017 at 05:48:04PM +0200, Jan Kara wrote:
> > > > > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > > > > index f179bdf1644d..b43be199fbdf 100644
> > > > > --- a/fs/xfs/xfs_iomap.c
> > > > > +++ b/fs/xfs/xfs_iomap.c
> > > > > @@ -33,6 +33,7 @@
> > > > >  #include "xfs_error.h"
> > > > >  #include "xfs_trans.h"
> > > > >  #include "xfs_trans_space.h"
> > > > > +#include "xfs_inode_item.h"
> > > > >  #include "xfs_iomap.h"
> > > > >  #include "xfs_trace.h"
> > > > >  #include "xfs_icache.h"
> > > > > @@ -1086,6 +1087,10 @@ xfs_file_iomap_begin(
> > > > >  		trace_xfs_iomap_found(ip, offset, length, 0, &imap);
> > > > >  	}
> > > > >  
> > > > > +	if ((flags & IOMAP_WRITE) && xfs_ipincount(ip) &&
> > > > > +	    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> > > > > +		iomap->flags |= IOMAP_F_DIRTY;
> > > > 
> > > > This is the very definition of an inode that is "fdatasync dirty".
> > > > 
> > > > Hmmmm, shouldn't this also be set for read faults, too?
> > > 
> > > No, read faults don't need to set IOMAP_F_DIRTY since user cannot write any
> > > data to the page which he'd then like to be persistent. The only reason why
> > > I thought it could be useful for a while was that it would be nice to make
> > > MAP_SYNC mapping provide the guarantee that data you see now is the data
> > > you'll see after a crash
> > 
> > Isn't that the entire point of MAP_SYNC? i.e. That when we return
> > from a page fault, the app knows that the data and it's underlying
> > extent is on persistent storage?
> > 
> > > but we cannot provide that guarantee for RO
> > > mapping anyway if someone else has the page mapped as well. So I just
> > > decided not to return IOMAP_F_DIRTY for read faults.
> > 
> > If there are multiple MAP_SYNC mappings to the inode, I would have
> > expected that they all sync all of the data/metadata on every page
> > fault, regardless of who dirtied the inode. An RO mapping doesn't
> 
> Well, they all do sync regardless of who dirtied the inode on every *write*
> fault.
> 
> > mean the data/metadata on the inode can't change, it just means it
> > can't change through that mapping.  Running fsync() to guarantee the
> > persistence of that data/metadata doesn't actually changing any
> > data....
> > 
> > IOWs, if read faults don't guarantee the mapped range has stable
> > extents on a MAP_SYNC mapping, then I think MAP_SYNC is broken
> > because it's not giving consistent guarantees to userspace. Yes, it
> > works fine when only one MAP_SYNC mapping is modifying the inode,
> > but the moment we have concurrent operations on the inode that
> > aren't MAP_SYNC or O_SYNC this goes out the window....
> 
> MAP_SYNC as I've implemented it provides guarantees only for data the
> process has actually written. I agree with that and it was a conscious
> decision. In my opinion that covers most usecases, provides reasonably
> simple semantics (i.e., if you write data through MAP_SYNC mapping, you can
> persist it just using CPU instructions), and reasonable performance.
> 
> Now you seem to suggest the semantics should be: "Data you have read from or
> written to a MAP_SYNC mapping can be persisted using CPU instructions." And
> from implementation POV we can do that rather easily (just rip out the
> IOMAP_WRITE checks). But I'm unsure whether this additional guarantee would
> be useful enough to justify the slowdown of read faults? I was not able to
> come up with a good usecase and so I've decided for current semantics. What
> do other people think?

Nobody commented on this for couple of days so how do we proceed? I would
prefer to go just with a guarantee for data written and we can always make
the guarantee stronger (i.e. apply it also for read data) when some user
comes with a good usecase?

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
