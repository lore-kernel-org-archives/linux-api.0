From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 1/5] add metadata_incore ioctl in vfs
Date: Wed, 19 Jan 2011 22:27:40 -0800
Message-ID: <20110119222740.fb1b5229.akpm@linux-foundation.org>
References: <1295399718.1949.864.camel@sli10-conroe>
	<20110119124158.b0348c44.akpm@linux-foundation.org>
	<1295490647.1949.890.camel@sli10-conroe>
	<20110119184240.b0a6a016.akpm@linux-foundation.org>
	<1295491713.1949.898.camel@sli10-conroe>
	<20110119190548.e1f7f01f.akpm@linux-foundation.org>
	<1295493709.1949.910.camel@sli10-conroe>
	<20110119201014.adf02a78.akpm@linux-foundation.org>
	<1295501898.1949.917.camel@sli10-conroe>
	<20110119215510.0882db92.akpm@linux-foundation.org>
	<1295503953.1949.928.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1295503953.1949.928.camel@sli10-conroe>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Shaohua Li <shaohua.li@intel.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjan@infradead.org>, "Yan, Zheng" <zheng.z.yan@linux.intel.com>, "Wu, Fengguang" <fengguang.wu@intel.com>, linux-api <linux-api@vger.kernel.org>, manpages <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thu, 20 Jan 2011 14:12:33 +0800 Shaohua Li <shaohua.li@intel.com> wrote:

> On Thu, 2011-01-20 at 13:55 +0800, Andrew Morton wrote:
> > On Thu, 20 Jan 2011 13:38:18 +0800 Shaohua Li <shaohua.li@intel.com> wrote:
> > 
> > > > ext2, minix and probably others create an address_space for each
> > > > directory.  Heaven knows what xfs does (for example).
> > > yes, this is for one directiory, but the all files's metadata are in
> > > block_dev address_space.
> > > I thought you mean there are several block_dev address_space like
> > > address_space in some filesystems, which doesn't fit well in my
> > > implementation. for ext like filesystem, there is only one
> > > address_space. for filesystems with several address_space, my proposal
> > > is map them to a virtual big address_space in the new ioctls.
> > 
> > ext2 and minixfs (and I think sysv and ufs) have a separate
> > address_space for each directory.  I don't see how those can be
> > represented with a single "virtual big address_space" - we also need
> > identifiers in there so each directory's address_space can be created
> > and appropriately populated.
> Oh, I misunderstand your comments. you are right, the ioctl methods
> don't work for ext2. the dir's address_space can't be readahead either.
> Looks we could only do the metadata readahead in filesystem specific
> way.

Another way of doing all this would be to implement some sort of
lookaside cache at the vfs->block boundary.  At boot time, load that
cache up with all the disk blocks which we know the boot will need (a
single ascending pass across the disk) and then when the vfs/fs goes to
read a disk block take a peek in that cache first and if it's a hit,
either steal the page or memcpy it.

It has the obvious coherence problems which would be pretty simple to
solve by hooking into the block write path as well.  The list of needed
blocks can be very simply generated with existing blktrace
infrastructure.  It does add permanent runtime overhead - once the
cache is invalidated and disabled, every IO operation would incur a
test-n-not-taken-branch.  Maybe not too bad.

Need to handle small-memory systems somehow, where the cache simply
ooms the machine or becomes ineffective because it's causing eviction
elsewhere.

It could perhaps all be implemented as an md or dm driver.

Or even as an IO scheduler.  I say this because IO schedulers can be
replaced on-the-fly, so the caching layer can be unloaded from the
stack once it is finished with.
