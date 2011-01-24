From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3 1/5] add metadata_incore ioctl in vfs
Date: Mon, 24 Jan 2011 12:06:31 +0200
Message-ID: <4D3D4F27.8050109@panasas.com>
References: <1295399718.1949.864.camel@sli10-conroe>	<20110119124158.b0348c44.akpm@linux-foundation.org>	<1295490647.1949.890.camel@sli10-conroe>	<20110119184240.b0a6a016.akpm@linux-foundation.org>	<1295491713.1949.898.camel@sli10-conroe>	<20110119190548.e1f7f01f.akpm@linux-foundation.org>	<1295493709.1949.910.camel@sli10-conroe>	<20110119201014.adf02a78.akpm@linux-foundation.org>	<1295501898.1949.917.camel@sli10-conroe>	<20110119215510.0882db92.akpm@linux-foundation.org>	<1295503953.1949.928.camel@sli10-conroe> <20110119222740.fb1b5229.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110119222740.fb1b5229.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Wu, Fengguang" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 01/20/2011 08:27 AM, Andrew Morton wrote:
> 
> Another way of doing all this would be to implement some sort of
> lookaside cache at the vfs->block boundary.  At boot time, load that
> cache up with all the disk blocks which we know the boot will need (a
> single ascending pass across the disk) and then when the vfs/fs goes to
> read a disk block take a peek in that cache first and if it's a hit,
> either steal the page or memcpy it.
> 

Ha. this sounds very much like the cleancache project presented for
inclusion so many times. It has even visited and left linux-next
a few times. They solved all these problems with a few VFS hooks.

> It has the obvious coherence problems which would be pretty simple to
> solve by hooking into the block write path as well.  

See cleancache they solved it with a simple VFS hook.

> The list of needed
> blocks can be very simply generated with existing blktrace
> infrastructure.  It does add permanent runtime overhead - once the
> cache is invalidated and disabled, every IO operation would incur a
> test-n-not-taken-branch.  Maybe not too bad.
> 
> Need to handle small-memory systems somehow, where the cache simply
> ooms the machine or becomes ineffective because it's causing eviction
> elsewhere.
> 
> It could perhaps all be implemented as an md or dm driver.
> 
> Or even as an IO scheduler.  I say this because IO schedulers can be
> replaced on-the-fly, so the caching layer can be unloaded from the
> stack once it is finished with.

Or a cleancache driver

Boaz
