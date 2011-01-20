From: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 0/5]add new ioctls to do metadata readahead in btrfs
Date: Thu, 20 Jan 2011 10:34:18 +0800
Message-ID: <1295490858.1949.894.camel@sli10-conroe>
References: <1295399715.1949.863.camel@sli10-conroe>
	 <20110119123451.75bb3c76.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110119123451.75bb3c76.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Wu, Fengguang" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2011-01-20 at 04:34 +0800, Andrew Morton wrote:
> On Wed, 19 Jan 2011 09:15:15 +0800
> Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
> >   We have file readahead to do asyn file read, but has no metadata
> > readahead. For a list of files, their metadata is stored in fragmented
> > disk space and metadata read is a sync operation, which impacts the
> > efficiency of readahead much. The patches try to add meatadata readahead
> > for btrfs. It has two advantages. One is make metadata read async, the
> > other is significant reducing disk I/O seek.
> >   In btrfs, metadata is stored in btree_inode. Ideally, if we could hook
> > the inode to a fd so we could use existing syscalls (readahead, mincore
> > or upcoming fincore) to do readahead, but the inode is hidden, there is
> > no easy way for this from my understanding. Another problem is we need
> > check page referenced bit to make sure if a page is valid, which isn't
> > ok doing this in fincore/mincore. And in metadata readahead, filesystem
> > need specific checking like the patch4. Doing the checking in current
> > API (for example fadvise) will mess things too. So we add two ioctls for
> > this. One is like readahead syscall, the other is like micore/fincore
> > syscall.
> 
> Has anyone looked at implementing this for filesystems other than
> btrfs?  Have the ext4 guys taken a look?  Did they see any impediments
> to implementing it for ext4?
Not yet. I do expect ext4 guys can check it. From my understanding, it
should be relatively easy to do it in ext filesystems.

> >   Under a harddisk based netbook with Meego, the metadata readahead
> > reduced about 3.5s boot time in average from total 16s.
> 
> That's a respectable speedup.  And it *needs* to be a good speedup,
> given how hacky all of this is!
> 
> But then..  reducing bootup time on a laptop/desktop/server by 3.5s
> isn't exactly a world-shattering benefit, is it?  Is it worth all the
> hacky code?
a laptop/desktop/server need read more data from hard disks, this will
give more bootup time saving I think, though not tested yet.

> It would be much more valuable if those 3.5 seconds were available to
> devices which really really care about bootup times, but very few of
> those devices use rotating disks nowadays, I expect?
Currently most popular netbooks are using rotating disks actually. And
this will benefit laptop/desktop too.

Thanks,
Shaohua
