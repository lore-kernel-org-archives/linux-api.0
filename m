From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 0/5]add new ioctls to do metadata readahead in btrfs
Date: Wed, 19 Jan 2011 12:34:51 -0800
Message-ID: <20110119123451.75bb3c76.akpm@linux-foundation.org>
References: <1295399715.1949.863.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1295399715.1949.863.camel@sli10-conroe>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Shaohua Li <shaohua.li@intel.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjan@infradead.org>, "Yan, Zheng" <zheng.z.yan@linux.intel.com>, "Wu, Fengguang" <fengguang.wu@intel.com>, linux-api <linux-api@vger.kernel.org>, manpages <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, 19 Jan 2011 09:15:15 +0800
Shaohua Li <shaohua.li@intel.com> wrote:

>   We have file readahead to do asyn file read, but has no metadata
> readahead. For a list of files, their metadata is stored in fragmented
> disk space and metadata read is a sync operation, which impacts the
> efficiency of readahead much. The patches try to add meatadata readahead
> for btrfs. It has two advantages. One is make metadata read async, the
> other is significant reducing disk I/O seek.
>   In btrfs, metadata is stored in btree_inode. Ideally, if we could hook
> the inode to a fd so we could use existing syscalls (readahead, mincore
> or upcoming fincore) to do readahead, but the inode is hidden, there is
> no easy way for this from my understanding. Another problem is we need
> check page referenced bit to make sure if a page is valid, which isn't
> ok doing this in fincore/mincore. And in metadata readahead, filesystem
> need specific checking like the patch4. Doing the checking in current
> API (for example fadvise) will mess things too. So we add two ioctls for
> this. One is like readahead syscall, the other is like micore/fincore
> syscall.

Has anyone looked at implementing this for filesystems other than
btrfs?  Have the ext4 guys taken a look?  Did they see any impediments
to implementing it for ext4?

>   Under a harddisk based netbook with Meego, the metadata readahead
> reduced about 3.5s boot time in average from total 16s.

That's a respectable speedup.  And it *needs* to be a good speedup,
given how hacky all of this is!

But then..  reducing bootup time on a laptop/desktop/server by 3.5s
isn't exactly a world-shattering benefit, is it?  Is it worth all the
hacky code?

It would be much more valuable if those 3.5 seconds were available to
devices which really really care about bootup times, but very few of
those devices use rotating disks nowadays, I expect?

