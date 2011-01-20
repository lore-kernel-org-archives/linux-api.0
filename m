From: Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 1/5] add metadata_incore ioctl in vfs
Date: Thu, 20 Jan 2011 14:06:21 +0800
Message-ID: <20110120060621.GA21101@localhost>
References: <1295399718.1949.864.camel@sli10-conroe>
 <20110119124158.b0348c44.akpm@linux-foundation.org>
 <1295490647.1949.890.camel@sli10-conroe>
 <20110119184240.b0a6a016.akpm@linux-foundation.org>
 <1295491713.1949.898.camel@sli10-conroe>
 <20110119190548.e1f7f01f.akpm@linux-foundation.org>
 <1295493709.1949.910.camel@sli10-conroe>
 <20110119201014.adf02a78.akpm@linux-foundation.org>
 <20110120044127.GQ16267@dastard>
 <1295502297.1949.924.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1295502297.1949.924.camel@sli10-conroe>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Li, Shaohua" <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 20, 2011 at 01:44:57PM +0800, Li, Shaohua wrote:
> On Thu, 2011-01-20 at 12:41 +0800, Dave Chinner wrote:
> > On Wed, Jan 19, 2011 at 08:10:14PM -0800, Andrew Morton wrote:
> > > On Thu, 20 Jan 2011 11:21:49 +0800 Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > > 
> > > > > It seems to return a single offset/length tuple which refers to the
> > > > > btrfs metadata "file", with the intent that this tuple later be fed
> > > > > into a btrfs-specific readahead ioctl.
> > > > > 
> > > > > I can see how this might be used with say fatfs or ext3 where all
> > > > > metadata resides within the blockdev address_space.  But how is a
> > > > > filesytem which keeps its metadata in multiple address_spaces supposed
> > > > > to use this interface?
> > > > Oh, this looks like a big problem, thanks for letting me know such
> > > > filesystems. is it possible specific filesystem mapping multiple
> > > > address_space ranges to a virtual big ranges? the new ioctls handle the
> > > > mapping.
> > > 
> > > I'm not sure what you mean by that.
> > > 
> > > ext2, minix and probably others create an address_space for each
> > > directory.  Heaven knows what xfs does (for example).
> > 
> > In 2.6.39 it won't even use address spaces for metadata caching.
> > 
> > Besides, XFS already has pretty sophisticated metadata readahead
> > built in - it's one of the reasons why the XFS directory code scales
> > so well on cold cache lookups of arge directories - so I don't see
> > much need for such an interface for XFS.
> > 
> > Perhaps btrfs would be better served by implementing speculative
> > metadata readahead in the places where it makes sense (e.g. readdir)
> > bcause it will improve cold-cache performance on a much wider range
> > of workloads than at just boot-time....
> I don't know about xfs. A sophisticated metadata readahead might make
> metadata async, but I thought it's impossible it can removes the disk
> seek. Since metadata and data usually lives in different disk block
> ranges, doing data readahead will unavoidable read metadata and cause
> disk seek between reading data and metadata.

It's standard practice to do in-kernel heuristic readahead for large
directories.  It's irrelevant to data/metadata interleaving.

It's exactly interleaved reads that makes readahead a must-have.
Think about interleavingly reading 2+ large files :)

Thanks,
Fengguang
