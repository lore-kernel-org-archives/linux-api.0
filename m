From: Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 1/5] add metadata_incore ioctl in vfs
Date: Thu, 20 Jan 2011 14:45:22 +0800
Message-ID: <20110120064522.GA23406@localhost>
References: <20110119184240.b0a6a016.akpm@linux-foundation.org>
 <1295491713.1949.898.camel@sli10-conroe>
 <20110119190548.e1f7f01f.akpm@linux-foundation.org>
 <1295493709.1949.910.camel@sli10-conroe>
 <20110119201014.adf02a78.akpm@linux-foundation.org>
 <1295501898.1949.917.camel@sli10-conroe>
 <20110119215510.0882db92.akpm@linux-foundation.org>
 <1295503953.1949.928.camel@sli10-conroe>
 <20110120061950.GA21597@localhost>
 <1295505457.1949.934.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1295505457.1949.934.camel@sli10-conroe>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Li, Shaohua" <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 20, 2011 at 02:37:37PM +0800, Li, Shaohua wrote:
> On Thu, 2011-01-20 at 14:19 +0800, Wu, Fengguang wrote:
> > On Thu, Jan 20, 2011 at 02:12:33PM +0800, Li, Shaohua wrote:
> > > On Thu, 2011-01-20 at 13:55 +0800, Andrew Morton wrote:
> > > > On Thu, 20 Jan 2011 13:38:18 +0800 Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > > > 
> > > > > > ext2, minix and probably others create an address_space for each
> > > > > > directory.  Heaven knows what xfs does (for example).
> > > > > yes, this is for one directiory, but the all files's metadata are in
> > > > > block_dev address_space.
> > > > > I thought you mean there are several block_dev address_space like
> > > > > address_space in some filesystems, which doesn't fit well in my
> > > > > implementation. for ext like filesystem, there is only one
> > > > > address_space. for filesystems with several address_space, my proposal
> > > > > is map them to a virtual big address_space in the new ioctls.
> > > > 
> > > > ext2 and minixfs (and I think sysv and ufs) have a separate
> > > > address_space for each directory.  I don't see how those can be
> > > > represented with a single "virtual big address_space" - we also need
> > > > identifiers in there so each directory's address_space can be created
> > > > and appropriately populated.
> > > Oh, I misunderstand your comments. you are right, the ioctl methods
> > > don't work for ext2. the dir's address_space can't be readahead either.
> > > Looks we could only do the metadata readahead in filesystem specific
> > > way.
> > 
> > There should be little interest on ext2 boot time optimization.
> > 
> > However if necessary, we might somehow treat ext2 dirs as files and
> > do normal fadvise on them? The other ext2 metadata may still be
> > accessible via the block_dev interface.
> current readahead syscall might already work here. however, I would
> expect there is stall easily when reading dirs.
> thinking 3 dirs:
> /
> /aa
> /aa/bb
> before / is in memory, reading aa will have stall. And we can't reduce
> disk seeks here. metadata readahead will still have some benefits but
> might not be much in such filesystem.

Yeah, good point.

Thanks,
Fengguang
