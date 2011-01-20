From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 1/5] add metadata_incore ioctl in vfs
Date: Thu, 20 Jan 2011 15:41:27 +1100
Message-ID: <20110120044127.GQ16267@dastard>
References: <1295399718.1949.864.camel@sli10-conroe>
 <20110119124158.b0348c44.akpm@linux-foundation.org>
 <1295490647.1949.890.camel@sli10-conroe>
 <20110119184240.b0a6a016.akpm@linux-foundation.org>
 <1295491713.1949.898.camel@sli10-conroe>
 <20110119190548.e1f7f01f.akpm@linux-foundation.org>
 <1295493709.1949.910.camel@sli10-conroe>
 <20110119201014.adf02a78.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110119201014.adf02a78.akpm@linux-foundation.org>
Sender: linux-btrfs-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohua Li <shaohua.li@intel.com>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjan@infradead.org>, "Yan, Zheng" <zheng.z.yan@linux.intel.com>, "Wu, Fengguang" <fengguang.wu@intel.com>, linux-api <linux-api@vger.kernel.org>, manpages <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 19, 2011 at 08:10:14PM -0800, Andrew Morton wrote:
> On Thu, 20 Jan 2011 11:21:49 +0800 Shaohua Li <shaohua.li@intel.com> wrote:
> 
> > > It seems to return a single offset/length tuple which refers to the
> > > btrfs metadata "file", with the intent that this tuple later be fed
> > > into a btrfs-specific readahead ioctl.
> > > 
> > > I can see how this might be used with say fatfs or ext3 where all
> > > metadata resides within the blockdev address_space.  But how is a
> > > filesytem which keeps its metadata in multiple address_spaces supposed
> > > to use this interface?
> > Oh, this looks like a big problem, thanks for letting me know such
> > filesystems. is it possible specific filesystem mapping multiple
> > address_space ranges to a virtual big ranges? the new ioctls handle the
> > mapping.
> 
> I'm not sure what you mean by that.
> 
> ext2, minix and probably others create an address_space for each
> directory.  Heaven knows what xfs does (for example).

In 2.6.39 it won't even use address spaces for metadata caching.

Besides, XFS already has pretty sophisticated metadata readahead
built in - it's one of the reasons why the XFS directory code scales
so well on cold cache lookups of arge directories - so I don't see
much need for such an interface for XFS.

Perhaps btrfs would be better served by implementing speculative
metadata readahead in the places where it makes sense (e.g. readdir)
bcause it will improve cold-cache performance on a much wider range
of workloads than at just boot-time....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
