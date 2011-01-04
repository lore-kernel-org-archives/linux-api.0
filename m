From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/5] add new ioctls to do metadata readahead in btrfs
Date: Tue, 04 Jan 2011 11:14:08 -0500
Message-ID: <x498vz0abov.fsf@segfault.boston.devel.redhat.com>
References: <1294119630.1949.365.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294119630.1949.365.camel@sli10-conroe> (Shaohua Li's message of
	"Tue, 04 Jan 2011 13:40:30 +0800")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:

> Hi,
>   We have file readahead to do asyn file read, but has no metadata
> readahead. For a list of files, their metadata is stored in fragmented
> disk space and metadata read is a sync operation, which impacts the
> efficiency of readahead much. The patches try to add meatadata readahead
> for btrfs.
>   In btrfs, metadata is stored in btree_inode. Ideally, if we could hook
> the inode to a fd so we could use existing syscalls (readahead, mincore
> or upcoming fincore) to do readahead, but the inode is hidden, there is
> no easy way for this from my understanding. So we add two ioctls for
> this. One is like readahead syscall, the other is like micore/fincore
> syscall.
>   Under a harddisk based netbook with Meego, the metadata readahead
> reduced about 3.5s boot time in average from total 16s.
>   Last time I posted similar patches to btrfs maillist, which adds the
> new ioctls in btrfs specific ioctl code. But Christoph Hellwig asks we
> have a generic interface to do this so other filesystem can share some
> code, so I came up with the new one. Comments and suggestions are
> welcome!

Is it not possible to enhance the existing readahead mechanisms to work
on metadata as well?  Is there some reason why metadata should be
fetched separately from the data it references?

Cheers,
Jeff
