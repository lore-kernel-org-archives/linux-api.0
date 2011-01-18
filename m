From: Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/5] add new ioctls to do metadata readahead in btrfs
Date: Tue, 18 Jan 2011 14:22:53 +0800
Message-ID: <20110118062253.GA7370@localhost>
References: <20110111013813.GA10449@localhost>
 <1294711397.1949.613.camel@sli10-conroe>
 <20110111030723.GA12949@localhost>
 <1294716453.1949.625.camel@sli10-conroe>
 <20110111091353.GA13753@localhost>
 <20110112025516.GA11303@sli10-conroe.sh.intel.com>
 <20110116033800.GA15260@localhost>
 <1295227957.1949.646.camel@sli10-conroe>
 <20110118044135.GA6736@localhost>
 <1295327727.1949.730.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1295327727.1949.730.camel@sli10-conroe>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Li, Shaohua" <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 18, 2011 at 01:15:27PM +0800, Li, Shaohua wrote:
> On Tue, 2011-01-18 at 12:41 +0800, Wu, Fengguang wrote:
> > On Mon, Jan 17, 2011 at 09:32:37AM +0800, Li, Shaohua wrote:
> > > On Sun, 2011-01-16 at 11:38 +0800, Wu, Fengguang wrote:
> > > > On Wed, Jan 12, 2011 at 10:55:16AM +0800, Li, Shaohua wrote:
> > > > > On Tue, Jan 11, 2011 at 05:13:53PM +0800, Wu, Fengguang wrote:
> > > > > > On Tue, Jan 11, 2011 at 11:27:33AM +0800, Li, Shaohua wrote:
> > > > > > > On Tue, 2011-01-11 at 11:07 +0800, Wu, Fengguang wrote:
> > > > > > > > On Tue, Jan 11, 2011 at 10:03:16AM +0800, Li, Shaohua wrote:
> > 
> > > > > > > > > fincore can takes a parameter or it returns a bit to distinguish
> > > > > > > > > referenced pages, but I don't think it's a good API. This should be
> > > > > > > > > transparent to userspace.
> > > > > > > >
> > > > > > > > Users care about the "cached" status may well be interested in the
> > > > > > > > "active/referenced" status. They are co-related information. fincore()
> > > > > > > > won't be a simple replication of mincore() anyway. fincore() has to
> > > > > > > > deal with huge sparsely accessed files. The accessed bits of a file
> > > > > > > > page are normally more meaningful than the accessed bits of mapped
> > > > > > > > (anonymous) pages.
> > > > > > > if all filesystems have the bit set, I'll buy-in. Otherwise, this isn't generic enough.
> > > > > > 
> > > > > > It's a reasonable thing to set the accessed bits. So I believe the
> > > > > > various filesystems are calling mark_page_accessed() on their metadata
> > > > > > inode, or can be changed to do it.
> > > > > yes, we can, with a lot of pain. And filesystems must be smart to avoid marking the bit
> > > > > for pages which are readahead in but actually are invalid. The second patch in the series
> > > > 
> > > > "invalid" means !PG_uptodate? I wonder why there is a need to test
> > > > that bit at all. !PG_uptodate seems an unrelated transitional state.
> > > not PG_update, it's referenced bit. A readahead metadata page will have update bit set,
> > > but it might not have referenced bit if it's an obsolete page. btrfs
> > > doesn't use the buffer_head
> > 
> > I do see PageUptodate() tests in your patch, perhaps they be removed?
> uptodate bit isn't really needed, but I added it to make sure the page
> is valid.

It may be nit pick, but I always try to remove optional code.  The
PageUptodate() looks like an irrelevant test and a good candidate to
remove.

> > > > > has more detailed infomation about this issue. The problem is if this is really worthy
> > > > > for metadata readahead. Some filesystems might don't care about metadata readahead. If
> > > > > we make fincore check the bit, then fincore syscall will not work for such filesystems,
> > > > > which is bad.
> > > > 
> > > > fincore() will always work as is. If the filesystem don't care about
> > > > metadata readahead, then the metadata readahead that makes use of the
> > > > bits will naturally not work for them?
> > > yes, they don't care about readahead, but they do care about fincore
> > > output.
> > 
> > fincore() just reports the accessed bits as is. If the filesystem does
> > not use blockdev or export its internal metadata inode, the user won't
> > be able to run fincore() on the metadata inode at all.
> > 
> > > if fincore() checks the bits, it doesn't work even for normal file
> > > pages, if the pages get deactivated.
> > 
> > That's a problem independent of the interface. And for user space
> > readahead, it can be nicely fixed by collecting the pages-to-readahead
> > before the free pages drop low, ie. before any page reclaim actions.
> > It's "nice" because you don't want to readahead more data than
> > cache-able anyway and avoid thrashing for small memory systems.
> My point is fincore() isn't designed only for readahead. People will use
> it like mincore, which is its normal usage. Checking the bits will break
> its normal usage, because fincore just doesn't check if the fd means a
> metadata inode.

Sorry, you missed my point :) I mean to export the accessed bits as-is
via the fincore() interface, not to check the accessed bits and then
report "page not cached" to user space for !PG_referenced pages.

Thanks,
Fengguang
