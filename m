From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH v2 0/5] add new ioctls to do metadata readahead in btrfs
Date: Tue, 18 Jan 2011 13:15:27 +0800
Message-ID: <1295327727.1949.730.camel@sli10-conroe>
References: <20110110142606.GA8788@localhost>
	 <1294704919.1949.593.camel@sli10-conroe> <20110111013813.GA10449@localhost>
	 <1294711397.1949.613.camel@sli10-conroe> <20110111030723.GA12949@localhost>
	 <1294716453.1949.625.camel@sli10-conroe> <20110111091353.GA13753@localhost>
	 <20110112025516.GA11303@sli10-conroe.sh.intel.com>
	 <20110116033800.GA15260@localhost> <1295227957.1949.646.camel@sli10-conroe>
	 <20110118044135.GA6736@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110118044135.GA6736@localhost>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Wu, Fengguang" <fengguang.wu@intel.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Arjan van de Ven <arjan@infradead.org>, "Yan, Zheng" <zheng.z.yan@linux.intel.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Tue, 2011-01-18 at 12:41 +0800, Wu, Fengguang wrote:
> On Mon, Jan 17, 2011 at 09:32:37AM +0800, Li, Shaohua wrote:
> > On Sun, 2011-01-16 at 11:38 +0800, Wu, Fengguang wrote:
> > > On Wed, Jan 12, 2011 at 10:55:16AM +0800, Li, Shaohua wrote:
> > > > On Tue, Jan 11, 2011 at 05:13:53PM +0800, Wu, Fengguang wrote:
> > > > > On Tue, Jan 11, 2011 at 11:27:33AM +0800, Li, Shaohua wrote:
> > > > > > On Tue, 2011-01-11 at 11:07 +0800, Wu, Fengguang wrote:
> > > > > > > On Tue, Jan 11, 2011 at 10:03:16AM +0800, Li, Shaohua wrote:
> 
> > > > > > > > fincore can takes a parameter or it returns a bit to distinguish
> > > > > > > > referenced pages, but I don't think it's a good API. This should be
> > > > > > > > transparent to userspace.
> > > > > > >
> > > > > > > Users care about the "cached" status may well be interested in the
> > > > > > > "active/referenced" status. They are co-related information. fincore()
> > > > > > > won't be a simple replication of mincore() anyway. fincore() has to
> > > > > > > deal with huge sparsely accessed files. The accessed bits of a file
> > > > > > > page are normally more meaningful than the accessed bits of mapped
> > > > > > > (anonymous) pages.
> > > > > > if all filesystems have the bit set, I'll buy-in. Otherwise, this isn't generic enough.
> > > > > 
> > > > > It's a reasonable thing to set the accessed bits. So I believe the
> > > > > various filesystems are calling mark_page_accessed() on their metadata
> > > > > inode, or can be changed to do it.
> > > > yes, we can, with a lot of pain. And filesystems must be smart to avoid marking the bit
> > > > for pages which are readahead in but actually are invalid. The second patch in the series
> > > 
> > > "invalid" means !PG_uptodate? I wonder why there is a need to test
> > > that bit at all. !PG_uptodate seems an unrelated transitional state.
> > not PG_update, it's referenced bit. A readahead metadata page will have update bit set,
> > but it might not have referenced bit if it's an obsolete page. btrfs
> > doesn't use the buffer_head
> 
> I do see PageUptodate() tests in your patch, perhaps they be removed?
uptodate bit isn't really needed, but I added it to make sure the page
is valid.

> > > > has more detailed infomation about this issue. The problem is if this is really worthy
> > > > for metadata readahead. Some filesystems might don't care about metadata readahead. If
> > > > we make fincore check the bit, then fincore syscall will not work for such filesystems,
> > > > which is bad.
> > > 
> > > fincore() will always work as is. If the filesystem don't care about
> > > metadata readahead, then the metadata readahead that makes use of the
> > > bits will naturally not work for them?
> > yes, they don't care about readahead, but they do care about fincore
> > output.
> 
> fincore() just reports the accessed bits as is. If the filesystem does
> not use blockdev or export its internal metadata inode, the user won't
> be able to run fincore() on the metadata inode at all.
> 
> > if fincore() checks the bits, it doesn't work even for normal file
> > pages, if the pages get deactivated.
> 
> That's a problem independent of the interface. And for user space
> readahead, it can be nicely fixed by collecting the pages-to-readahead
> before the free pages drop low, ie. before any page reclaim actions.
> It's "nice" because you don't want to readahead more data than
> cache-able anyway and avoid thrashing for small memory systems.
My point is fincore() isn't designed only for readahead. People will use
it like mincore, which is its normal usage. Checking the bits will break
its normal usage, because fincore just doesn't check if the fd means a
metadata inode.

> > > > > > > Another option may be to use the above
> > > > > > > /debug/tracing/objects/mm/pages/dump-file interface.
> > > > > > >
> > > > > > > > > - btrfs_metadata_readahead() can be passed to some (faked)
> > > > > > > > >   ->readpages() for use with fadvise.
> > > > > > > > this need filesystem specific hook too, the difference is your proposal
> > > > > > > > uses fadvise but I'm using ioctl. There isn't big difference.
> > > > > > >
> > > > > > > True for btrfs. However they make big differences for other file systems.
> > > > > > why?
> > > > > 
> > > > > The block_dev of ext2/3/4 can do metadata query/readahead directly
> > > > > with fincore()+fadvise(), with no need for any additional ioctls.
> > > > > 
> > > > > Given that the vast majority desktops are running ext2/3/4, it seems
> > > > > worthwhile to have a straightforward solution for them.
> > > > This does make ext filesystem metadata readahead straightforward, but gives a lot
> > > > of pain for other filesystems. And even for ext filesystem, we need take care
> > > > about the 'invalid page' issue above.
> > > > On the other hand, with the ioctls approach, we can still make ext filesystem
> > > > metadata readahead straightforward (just several lines of code, we can even
> > > > add a lib API for such filesystems)
> > > > We'd better have a more generic approach for all filelsystems, while the ioctl
> > > > apporoach is better.
> > > 
> > > Although I'm not all that fond of adding ioctls, I can understand the
> > > difficulties and won't insist on you doing it the other way.
> > Thanks!
> 
> I'm not sure how reality it is, but the other wild ideas that
> intrigued me exporting the btrfs_inode in the initial plan is, it
> might enable some interesting btrfs use cases. For example, to write
> some user space lib/tool to examine btrfs_inode and do live fsck on
> some snapshot.  Or to mount btrfs only to read/write btrfs_inode, to
> make use of btrfs' low level (RAID?) functionalities.
> 
> Just play for fun :)
get it. don't know if there is valid usage though.

Thanks,
Shaohua

