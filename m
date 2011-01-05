From: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/5] add new ioctls to do metadata readahead in btrfs
Date: Wed, 05 Jan 2011 10:10:48 +0800
Message-ID: <1294193448.1949.377.camel@sli10-conroe>
References: <1294119630.1949.365.camel@sli10-conroe>
	 <x498vz0abov.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <x498vz0abov.fsf-RRHT56Q3PSP4kTEheFKJxxDDeQx5vsVwAInAS/Ez/D0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 2011-01-05 at 00:14 +0800, Jeff Moyer wrote:
> Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:
> 
> > Hi,
> >   We have file readahead to do asyn file read, but has no metadata
> > readahead. For a list of files, their metadata is stored in fragmented
> > disk space and metadata read is a sync operation, which impacts the
> > efficiency of readahead much. The patches try to add meatadata readahead
> > for btrfs.
> >   In btrfs, metadata is stored in btree_inode. Ideally, if we could hook
> > the inode to a fd so we could use existing syscalls (readahead, mincore
> > or upcoming fincore) to do readahead, but the inode is hidden, there is
> > no easy way for this from my understanding. So we add two ioctls for
> > this. One is like readahead syscall, the other is like micore/fincore
> > syscall.
> >   Under a harddisk based netbook with Meego, the metadata readahead
> > reduced about 3.5s boot time in average from total 16s.
> >   Last time I posted similar patches to btrfs maillist, which adds the
> > new ioctls in btrfs specific ioctl code. But Christoph Hellwig asks we
> > have a generic interface to do this so other filesystem can share some
> > code, so I came up with the new one. Comments and suggestions are
> > welcome!
> 
> Is it not possible to enhance the existing readahead mechanisms to work
> on metadata as well? 
using existing sys_readahead to do metadata readahead? The problem is I
can't hook a fd for meatadata inode, as explained above.
or let kernel automatically do metadata readahead? Kernel can't be so
intelligent, because kernel doesn't even know which file should be
readahead till userspace tells it

>  Is there some reason why metadata should be
> fetched separately from the data it references?
metadata read is sync operation, which will break data readahead
pipeline. And metadata and data usually lives in not adjacent disk
blocks, which will introduce a lot of disk seeks. reading metadata first
and then do data readahead can reduce a lot of disk seeks and data
readahead can be fully pumped

Thanks,
Shaohua
