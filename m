From: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 0/5]add new ioctls to do metadata readahead in btrfs
Date: Wed, 19 Jan 2011 09:15:15 +0800
Message-ID: <1295399715.1949.863.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Wu, Fengguang" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,
  We have file readahead to do asyn file read, but has no metadata
readahead. For a list of files, their metadata is stored in fragmented
disk space and metadata read is a sync operation, which impacts the
efficiency of readahead much. The patches try to add meatadata readahead
for btrfs. It has two advantages. One is make metadata read async, the
other is significant reducing disk I/O seek.
  In btrfs, metadata is stored in btree_inode. Ideally, if we could hook
the inode to a fd so we could use existing syscalls (readahead, mincore
or upcoming fincore) to do readahead, but the inode is hidden, there is
no easy way for this from my understanding. Another problem is we need
check page referenced bit to make sure if a page is valid, which isn't
ok doing this in fincore/mincore. And in metadata readahead, filesystem
need specific checking like the patch4. Doing the checking in current
API (for example fadvise) will mess things too. So we add two ioctls for
this. One is like readahead syscall, the other is like micore/fincore
syscall.
  Under a harddisk based netbook with Meego, the metadata readahead
reduced about 3.5s boot time in average from total 16s.

v2->v3:
1. fixed some issues Arnd pointed out
2. rebased to latest git
3. remove the 'updated' page flag check from patch 2 as suggested by
Fengguang.

v1->v2:
1. Added more comments and fix return values suggested by Andrew Morton
2. fix a race condition pointed out by Yan Zheng

initial post:
http://marc.info/?l=linux-fsdevel&m=129222493406353&w=2

Thanks,
Shaohua
