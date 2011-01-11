From: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/5] add new ioctls to do metadata readahead in btrfs
Date: Tue, 11 Jan 2011 11:27:33 +0800
Message-ID: <1294716453.1949.625.camel@sli10-conroe>
References: <1294119630.1949.365.camel@sli10-conroe>
	 <20110110142606.GA8788@localhost> <1294704919.1949.593.camel@sli10-conroe>
	 <20110111013813.GA10449@localhost> <1294711397.1949.613.camel@sli10-conroe>
	 <20110111030723.GA12949@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110111030723.GA12949@localhost>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wu, Fengguang" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2011-01-11 at 11:07 +0800, Wu, Fengguang wrote:
> On Tue, Jan 11, 2011 at 10:03:16AM +0800, Li, Shaohua wrote:
> > On Tue, 2011-01-11 at 09:38 +0800, Wu, Fengguang wrote:
> > > On Tue, Jan 11, 2011 at 08:15:19AM +0800, Li, Shaohua wrote:
> > > > On Mon, 2011-01-10 at 22:26 +0800, Wu, Fengguang wrote:
> > > > > Shaohua,
> > > > >
> > > > > On Tue, Jan 04, 2011 at 01:40:30PM +0800, Li, Shaohua wrote:
> > > > > > Hi,
> > > > > >   We have file readahead to do asyn file read, but has no metadata
> > > > > > readahead. For a list of files, their metadata is stored in fragmented
> > > > > > disk space and metadata read is a sync operation, which impacts the
> > > > > > efficiency of readahead much. The patches try to add meatadata readahead
> > > > > > for btrfs.
> > > > > >   In btrfs, metadata is stored in btree_inode. Ideally, if we could hook
> > > > > > the inode to a fd so we could use existing syscalls (readahead, mincore
> > > > > > or upcoming fincore) to do readahead, but the inode is hidden, there is
> > > > > > no easy way for this from my understanding. So we add two ioctls for
> > > > >
> > > > > If that is the main obstacle, why not do straightforward fincore()/
> > > > > fadvise(), and add ioctls to btrfs to export/grab the hidden
> > > > > btree_inode in any form?  This will address btrfs' specific issue, and
> > > > > have the benefit of making the VFS part general enough. You know
> > > > > ext2/3/4 already have block_dev ready for metadata readahead.
> > > > I forgot to update this comment. Please see patch 2 and patch 4, both
> > > > incore and readahead need btrfs specific staff involved, so we can't use
> > > > generic fincore or something.
> > >
> > > You can if you like :)
> > >
> > > - fincore() can return the referenced bit, which is generally
> > >   useful information
> > metadata page in ext2/3 doesn't have reference bit set, while btrfs has.
> > we can't blindly filter out such pages with the bit.
> 
> block_dev inodes have the accessed bits. Look at the below output.
> 
> /dev/sda5 is a mounted ext4 partition.  The 'A'/'R' in the
> dump_page_cache lines stand for Active/Referenced.
ext4 already does readahead? please check other filesystems.
filesystem sues bread like API to read metadata, which definitely
doesn't set referenced bit.

> root@bay /home/wfg# echo /dev/sda5 > /debug/tracing/objects/mm/pages/dump-file
> root@bay /home/wfg# cat /debug/tracing/trace
> # tracer: nop
> #
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |
>              zsh-2950  [003]   879.500764: dump_inode_cache:            0  55643986944      1703936        21879 D___  BLK            mount /dev/sda5
>              zsh-2950  [003]   879.500774: dump_page_cache:            0      2 ___AR_____P    2    0
>              zsh-2950  [003]   879.500776: dump_page_cache:            2      3 ____R_____P    2    0
>              zsh-2950  [003]   879.500777: dump_page_cache:         1026      5 ___AR_____P    2    0
>              zsh-2950  [003]   879.500778: dump_page_cache:         1031      3 ___A______P    2    0
>              zsh-2950  [003]   879.500779: dump_page_cache:         1034      1 ___AR_____P    2    0
>              zsh-2950  [003]   879.500780: dump_page_cache:         1035      2 ___A______P    2    0
>              zsh-2950  [003]   879.500781: dump_page_cache:         1037      1 ___AR_____P    2    0
>              zsh-2950  [003]   879.500782: dump_page_cache:         1038      3 ____R_____P    2    0
>              zsh-2950  [003]   879.500782: dump_page_cache:         1041      1 ___A______P    2    0
>              zsh-2950  [003]   879.500783: dump_page_cache:         1057      1 ___AR_D___P    2    0
>              zsh-2950  [003]   879.500788: dump_page_cache:         1058      6 ___A______P    2    0
>              zsh-2950  [003]   879.500788: dump_page_cache:         9249      1 ___AR_____P    2    0
>              zsh-2950  [003]   879.500789: dump_page_cache:       524289      1 ____R_____P    2    0
>              zsh-2950  [003]   879.500790: dump_page_cache:       524290      2 ___A______P    2    0
>              zsh-2950  [003]   879.500790: dump_page_cache:       524292      1 ___AR_____P    2    0
>              zsh-2950  [003]   879.500791: dump_page_cache:       524293      1 ___A______P    2    0
>              zsh-2950  [003]   879.500796: dump_page_cache:       524294      9 ____R_____P    2    0
>              zsh-2950  [003]   879.500797: dump_page_cache:       524303      1 ___A______P    2    0
>              zsh-2950  [003]   879.500798: dump_page_cache:       987136      1 ___AR_____P    2    0
>              zsh-2950  [003]   879.500798: dump_page_cache:      1048576      1 ____R_____P    2    0
>              zsh-2950  [003]   879.500799: dump_page_cache:      1048577      2 ___A______P    2    0
>              zsh-2950  [003]   879.500800: dump_page_cache:      1048579      1 ___AR_____P    2    0
>              zsh-2950  [003]   879.500801: dump_page_cache:      1048580      5 ___A______P    2    0
>              zsh-2950  [003]   879.500802: dump_page_cache:      1048585      1 ___AR_____P    2    0
>              zsh-2950  [003]   879.500805: dump_page_cache:      1048586      5 ___A______P    2    0
>              zsh-2950  [003]   879.500805: dump_page_cache:      1048591      1 ___AR_____P    2    0
>              zsh-2950  [003]   879.500806: dump_page_cache:      1572864      1 ____R_____P    2    0
>              zsh-2950  [003]   879.500807: dump_page_cache:      1572865      5 ___A______P    2    0
>              zsh-2950  [003]   879.500808: dump_page_cache:      1572870      1 ___AR_____P    2    0
>              zsh-2950  [003]   879.500811: dump_page_cache:      1572871      6 ___A______P    2    0
>              zsh-2950  [003]   879.500812: dump_page_cache:      1572877      3 ____R_____P    2    0
>              zsh-2950  [003]   879.500816: dump_page_cache:      2097153      8 ____R_____P    2    0
>              zsh-2950  [003]   879.500817: dump_page_cache:      2097161      1 ___A______P    2    0
>              zsh-2950  [003]   879.500818: dump_page_cache:      2097162      4 ____R_____P    2    0
>              zsh-2950  [003]   879.500819: dump_page_cache:      6324224      1 ____R_D___P    2    0
>              zsh-2950  [003]   879.500820: dump_page_cache:      6324225      3 ___AR_____P    2    0
>              zsh-2950  [003]   879.500825: dump_page_cache:      6324228     29 ___A______P    2    0
>              zsh-2950  [003]   879.500826: dump_page_cache:      6324257      1 ____R_____P    2    0
>              zsh-2950  [003]   879.500828: dump_page_cache:      6324258      4 ___A______P    2    0
>              zsh-2950  [003]   879.500830: dump_page_cache:      6324262     11 ____R_____P    2    0
>              zsh-2950  [003]   879.500833: dump_page_cache:      6324273     16 ___AR_____P    2    0
>              zsh-2950  [003]   879.500833: dump_page_cache:      6324289      1 ___A______P    2    0
>              zsh-2950  [003]   879.500834: dump_page_cache:      6324290      2 ___AR_____P    2    0
>              zsh-2950  [003]   879.500835: dump_page_cache:      6324292      8 ___A______P    2    0
>              zsh-2950  [003]   879.500836: dump_page_cache:      6324300      2 ___AR_____P    2    0
>              zsh-2950  [003]   879.500837: dump_page_cache:      6324302      3 ___A______P    2    0
>              zsh-2950  [003]   879.500838: dump_page_cache:      6324305      4 ____R_____P    2    0
>              zsh-2950  [003]   879.500843: dump_page_cache:      6324309     28 ___AR_____P    2    0
>              zsh-2950  [003]   879.500844: dump_page_cache:      6324337      4 ___A______P    2    0
>              zsh-2950  [003]   879.500845: dump_page_cache:      6324341      2 ____R_____P    2    0
>              zsh-2950  [003]   879.500850: dump_page_cache:      6324343     30 ___AR_____P    2    0
>              zsh-2950  [003]   879.500851: dump_page_cache:      6324373      2 ___A______P    2    0
>              zsh-2950  [003]   879.500852: dump_page_cache:      6324375      2 ___AR_____P    2    0
>              zsh-2950  [003]   879.500853: dump_page_cache:      6324377      9 ___A______P    2    0
>              zsh-2950  [003]   879.500854: dump_page_cache:      6324386      2 ___AR_____P    2    0
>              zsh-2950  [003]   879.500855: dump_page_cache:      6324388      5 ___A______P    2    0
>              zsh-2950  [003]   879.500856: dump_page_cache:      6324393      3 ___AR_____P    2    0
>              zsh-2950  [003]   879.500858: dump_page_cache:      6324396     11 ___A______P    2    0
>              zsh-2950  [003]   879.500859: dump_page_cache:      6324407      1 ____R_____P    2    0
>              zsh-2950  [003]   879.500864: dump_page_cache:      6324408     31 ___AR_____P    2    0
>              zsh-2950  [003]   879.500864: dump_page_cache:      6324439      1 ___A______P    2    0
>              zsh-2950  [003]   879.500865: dump_page_cache:      6324440      1 ____R_____P    2    0
>              zsh-2950  [003]   879.500866: dump_page_cache:      6324441      2 ___A______P    2    0
>              zsh-2950  [003]   879.500867: dump_page_cache:      6324443      5 ____R_____P    2    0
>              zsh-2950  [003]   879.500872: dump_page_cache:      6324448     26 ___AR_____P    2    0
>              zsh-2950  [003]   879.500873: dump_page_cache:      6324474      6 ___A______P    2    0
>              zsh-2950  [003]   879.500874: dump_page_cache:      6324480      4 ____R_____P    2    0
>              zsh-2950  [003]   879.500879: dump_page_cache:      6324484     28 ___AR_____P    2    0
>              zsh-2950  [003]   879.500880: dump_page_cache:      6324512      4 ___A______P    2    0
>              zsh-2950  [003]   879.500881: dump_page_cache:      6324516      1 ____R_____P    2    0
>              zsh-2950  [003]   879.500881: dump_page_cache:      6324517      1 ___A______P    2    0
>              zsh-2950  [003]   879.500882: dump_page_cache:      6324518      2 ___AR_____P    2    0
>              zsh-2950  [003]   879.500888: dump_page_cache:      6324520     28 ___A______P    2    0
>              zsh-2950  [003]   879.500890: dump_page_cache:      6324548      2 ____R_____P    2    0
> 
> > fincore can takes a parameter or it returns a bit to distinguish
> > referenced pages, but I don't think it's a good API. This should be
> > transparent to userspace.
> 
> Users care about the "cached" status may well be interested in the
> "active/referenced" status. They are co-related information. fincore()
> won't be a simple replication of mincore() anyway. fincore() has to
> deal with huge sparsely accessed files. The accessed bits of a file
> page are normally more meaningful than the accessed bits of mapped
> (anonymous) pages.
if all filesystems have the bit set, I'll buy-in. Otherwise, this isn't generic enough.

> Another option may be to use the above
> /debug/tracing/objects/mm/pages/dump-file interface.
> 
> > > - btrfs_metadata_readahead() can be passed to some (faked)
> > >   ->readpages() for use with fadvise.
> > this need filesystem specific hook too, the difference is your proposal
> > uses fadvise but I'm using ioctl. There isn't big difference.
> 
> True for btrfs. However they make big differences for other file systems.
why?

> > BTW, it's hard to hook btrfs_inode to a fd even with a ioctl, at least I
> > didn't find a easy way to do this. It might be possible to do this for
> > example adding a fake device or fake fs (anon_inode doesn't work here,
> > IIRC), which is a bit ugly. Before it's proved generic API can handle
> > metadata readahead, I don't want to do it.
> 
> Right, it could be hard to export btrfs_inode. I'm glad you speak it
> out. If we cannot make it, it's valuable to point out the problem and
> let everyone know the root cause we turn to an ioctl based workaround.
> Then others will understand the design choices, and if lucky, join us
> and help export the btrfs_inode.
I didn't hide anything. I actually tell out this in the comments. this
is what I said. 

 In btrfs, metadata is stored in btree_inode. Ideally, if we could hook
> > > > > > the inode to a fd so we could use existing syscalls
(readahead, mincore
> > > > > > or upcoming fincore) to do readahead, but the inode is
hidden, there is
> > > > > > no easy way for this from my understanding.


Thanks,
Shaohua
> > > > > > this. One is like readahead syscall, the other is like micore/fincore
> > > > > > syscall.
> > > > > >   Under a harddisk based netbook with Meego, the metadata readahead
> > > > > > reduced about 3.5s boot time in average from total 16s.
> > > > > >   Last time I posted similar patches to btrfs maillist, which adds the
> > > > > > new ioctls in btrfs specific ioctl code. But Christoph Hellwig asks we
> > > > > > have a generic interface to do this so other filesystem can share some
> > > > > > code, so I came up with the new one. Comments and suggestions are
> > > > > > welcome!
> > > > > >
> > > > > > v1->v2:
> > > > > > 1. Added more comments and fix return values suggested by Andrew Morton
> > > > > > 2. fix a race condition pointed out by Yan Zheng
> > > > > >
> > > > > > initial post:
> > > > > > http://marc.info/?l=linux-fsdevel&m=129222493406353&w=2
> > > > > >
> > > > > > Thanks,
> > > > > > Shaohua
> > > > > >
> > > > > > --
> > > > > > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > > > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > >
> > > >
> >
> >
