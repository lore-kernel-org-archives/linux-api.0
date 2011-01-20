From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v3 1/5] add metadata_incore ioctl in vfs
Date: Wed, 19 Jan 2011 21:55:10 -0800
Message-ID: <20110119215510.0882db92.akpm@linux-foundation.org>
References: <1295399718.1949.864.camel@sli10-conroe>
	<20110119124158.b0348c44.akpm@linux-foundation.org>
	<1295490647.1949.890.camel@sli10-conroe>
	<20110119184240.b0a6a016.akpm@linux-foundation.org>
	<1295491713.1949.898.camel@sli10-conroe>
	<20110119190548.e1f7f01f.akpm@linux-foundation.org>
	<1295493709.1949.910.camel@sli10-conroe>
	<20110119201014.adf02a78.akpm@linux-foundation.org>
	<1295501898.1949.917.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295501898.1949.917.camel@sli10-conroe>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Wu, Fengguang" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 20 Jan 2011 13:38:18 +0800 Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> > ext2, minix and probably others create an address_space for each
> > directory.  Heaven knows what xfs does (for example).
> yes, this is for one directiory, but the all files's metadata are in
> block_dev address_space.
> I thought you mean there are several block_dev address_space like
> address_space in some filesystems, which doesn't fit well in my
> implementation. for ext like filesystem, there is only one
> address_space. for filesystems with several address_space, my proposal
> is map them to a virtual big address_space in the new ioctls.

ext2 and minixfs (and I think sysv and ufs) have a separate
address_space for each directory.  I don't see how those can be
represented with a single "virtual big address_space" - we also need
identifiers in there so each directory's address_space can be created
and appropriately populated.
