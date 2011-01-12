From: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/5] add new ioctls to do metadata readahead in btrfs
Date: Wed, 12 Jan 2011 10:55:16 +0800
Message-ID: <20110112025516.GA11303@sli10-conroe.sh.intel.com>
References: <1294119630.1949.365.camel@sli10-conroe>
 <20110110142606.GA8788@localhost>
 <1294704919.1949.593.camel@sli10-conroe>
 <20110111013813.GA10449@localhost>
 <1294711397.1949.613.camel@sli10-conroe>
 <20110111030723.GA12949@localhost>
 <1294716453.1949.625.camel@sli10-conroe>
 <20110111091353.GA13753@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110111091353.GA13753@localhost>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wu, Fengguang" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 11, 2011 at 05:13:53PM +0800, Wu, Fengguang wrote:
> On Tue, Jan 11, 2011 at 11:27:33AM +0800, Li, Shaohua wrote:
> > On Tue, 2011-01-11 at 11:07 +0800, Wu, Fengguang wrote:
> > > On Tue, Jan 11, 2011 at 10:03:16AM +0800, Li, Shaohua wrote:
> > > > On Tue, 2011-01-11 at 09:38 +0800, Wu, Fengguang wrote:
> > > > > On Tue, Jan 11, 2011 at 08:15:19AM +0800, Li, Shaohua wrote:
> > > > > > On Mon, 2011-01-10 at 22:26 +0800, Wu, Fengguang wrote:
> > > > > > > Shaohua,
> > > > > > >
> > > > > > > On Tue, Jan 04, 2011 at 01:40:30PM +0800, Li, Shaohua wrote:
> > > > > > > > Hi,
> > > > > > > >   We have file readahead to do asyn file read, but has no metadata
> > > > > > > > readahead. For a list of files, their metadata is stored in fragmented
> > > > > > > > disk space and metadata read is a sync operation, which impacts the
> > > > > > > > efficiency of readahead much. The patches try to add meatadata readahead
> > > > > > > > for btrfs.
> > > > > > > >   In btrfs, metadata is stored in btree_inode. Ideally, if we could hook
> > > > > > > > the inode to a fd so we could use existing syscalls (readahead, mincore
> > > > > > > > or upcoming fincore) to do readahead, but the inode is hidden, there is
> > > > > > > > no easy way for this from my understanding. So we add two ioctls for
> > > > > > >
> > > > > > > If that is the main obstacle, why not do straightforward fincore()/
> > > > > > > fadvise(), and add ioctls to btrfs to export/grab the hidden
> > > > > > > btree_inode in any form?  This will address btrfs' specific issue, and
> > > > > > > have the benefit of making the VFS part general enough. You know
> > > > > > > ext2/3/4 already have block_dev ready for metadata readahead.
> > > > > > I forgot to update this comment. Please see patch 2 and patch 4, both
> > > > > > incore and readahead need btrfs specific staff involved, so we can't use
> > > > > > generic fincore or something.
> > > > >
> > > > > You can if you like :)
> > > > >
> > > > > - fincore() can return the referenced bit, which is generally
> > > > >   useful information
> > > > metadata page in ext2/3 doesn't have reference bit set, while btrfs has.
> > > > we can't blindly filter out such pages with the bit.
> > >
> > > block_dev inodes have the accessed bits. Look at the below output.
> > >
> > > /dev/sda5 is a mounted ext4 partition.  The 'A'/'R' in the
> > > dump_page_cache lines stand for Active/Referenced.
> > ext4 already does readahead? please check other filesystems.
> 
> ext3/4 does readahead on accessing large directories. However that's
> orthogonal feature to the user space metadata readahead. The latter is
> still important for fast boot on ext3/4.
> 
> > filesystem sues bread like API to read metadata, which definitely
> > doesn't set referenced bit.
> 
> __find_get_block() will call touch_buffer() which is a synonymous for
> mark_page_accessed().
yes, but only when the buffer is accessed at the second time.

> > > > fincore can takes a parameter or it returns a bit to distinguish
> > > > referenced pages, but I don't think it's a good API. This should be
> > > > transparent to userspace.
> > >
> > > Users care about the "cached" status may well be interested in the
> > > "active/referenced" status. They are co-related information. fincore()
> > > won't be a simple replication of mincore() anyway. fincore() has to
> > > deal with huge sparsely accessed files. The accessed bits of a file
> > > page are normally more meaningful than the accessed bits of mapped
> > > (anonymous) pages.
> > if all filesystems have the bit set, I'll buy-in. Otherwise, this isn't generic enough.
> 
> It's a reasonable thing to set the accessed bits. So I believe the
> various filesystems are calling mark_page_accessed() on their metadata
> inode, or can be changed to do it.
yes, we can, with a lot of pain. And filesystems must be smart to avoid marking the bit
for pages which are readahead in but actually are invalid. The second patch in the series
has more detailed infomation about this issue. The problem is if this is really worthy
for metadata readahead. Some filesystems might don't care about metadata readahead. If
we make fincore check the bit, then fincore syscall will not work for such filesystems,
which is bad.

> > > Another option may be to use the above
> > > /debug/tracing/objects/mm/pages/dump-file interface.
> > >
> > > > > - btrfs_metadata_readahead() can be passed to some (faked)
> > > > >   ->readpages() for use with fadvise.
> > > > this need filesystem specific hook too, the difference is your proposal
> > > > uses fadvise but I'm using ioctl. There isn't big difference.
> > >
> > > True for btrfs. However they make big differences for other file systems.
> > why?
> 
> The block_dev of ext2/3/4 can do metadata query/readahead directly
> with fincore()+fadvise(), with no need for any additional ioctls.
> 
> Given that the vast majority desktops are running ext2/3/4, it seems
> worthwhile to have a straightforward solution for them.
This does make ext filesystem metadata readahead straightforward, but gives a lot
of pain for other filesystems. And even for ext filesystem, we need take care
about the 'invalid page' issue above.
On the other hand, with the ioctls approach, we can still make ext filesystem
metadata readahead straightforward (just several lines of code, we can even
add a lib API for such filesystems)
We'd better have a more generic approach for all filelsystems, while the ioctl
apporoach is better.

Thanks,
Shaohua
