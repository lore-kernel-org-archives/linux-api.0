From: Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/5] add new ioctls to do metadata readahead in btrfs
Date: Tue, 11 Jan 2011 09:38:13 +0800
Message-ID: <20110111013813.GA10449@localhost>
References: <1294119630.1949.365.camel@sli10-conroe>
 <20110110142606.GA8788@localhost>
 <1294704919.1949.593.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1294704919.1949.593.camel@sli10-conroe>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Li, Shaohua" <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 11, 2011 at 08:15:19AM +0800, Li, Shaohua wrote:
> On Mon, 2011-01-10 at 22:26 +0800, Wu, Fengguang wrote:
> > Shaohua,
> > 
> > On Tue, Jan 04, 2011 at 01:40:30PM +0800, Li, Shaohua wrote:
> > > Hi,
> > >   We have file readahead to do asyn file read, but has no metadata
> > > readahead. For a list of files, their metadata is stored in fragmented
> > > disk space and metadata read is a sync operation, which impacts the
> > > efficiency of readahead much. The patches try to add meatadata readahead
> > > for btrfs.
> > >   In btrfs, metadata is stored in btree_inode. Ideally, if we could hook
> > > the inode to a fd so we could use existing syscalls (readahead, mincore
> > > or upcoming fincore) to do readahead, but the inode is hidden, there is
> > > no easy way for this from my understanding. So we add two ioctls for
> > 
> > If that is the main obstacle, why not do straightforward fincore()/
> > fadvise(), and add ioctls to btrfs to export/grab the hidden
> > btree_inode in any form?  This will address btrfs' specific issue, and
> > have the benefit of making the VFS part general enough. You know
> > ext2/3/4 already have block_dev ready for metadata readahead.
> I forgot to update this comment. Please see patch 2 and patch 4, both
> incore and readahead need btrfs specific staff involved, so we can't use
> generic fincore or something.

You can if you like :)

- fincore() can return the referenced bit, which is generally
  useful information

- btrfs_metadata_readahead() can be passed to some (faked)
  ->readpages() for use with fadvise.

Thanks,
Fengguang

> > > this. One is like readahead syscall, the other is like micore/fincore
> > > syscall.
> > >   Under a harddisk based netbook with Meego, the metadata readahead
> > > reduced about 3.5s boot time in average from total 16s.
> > >   Last time I posted similar patches to btrfs maillist, which adds the
> > > new ioctls in btrfs specific ioctl code. But Christoph Hellwig asks we
> > > have a generic interface to do this so other filesystem can share some
> > > code, so I came up with the new one. Comments and suggestions are
> > > welcome!
> > > 
> > > v1->v2:
> > > 1. Added more comments and fix return values suggested by Andrew Morton
> > > 2. fix a race condition pointed out by Yan Zheng
> > > 
> > > initial post:
> > > http://marc.info/?l=linux-fsdevel&m=129222493406353&w=2
> > > 
> > > Thanks,
> > > Shaohua
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
