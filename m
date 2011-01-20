From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v3 1/5] add metadata_incore ioctl in vfs
Date: Wed, 19 Jan 2011 20:10:14 -0800
Message-ID: <20110119201014.adf02a78.akpm@linux-foundation.org>
References: <1295399718.1949.864.camel@sli10-conroe>
	<20110119124158.b0348c44.akpm@linux-foundation.org>
	<1295490647.1949.890.camel@sli10-conroe>
	<20110119184240.b0a6a016.akpm@linux-foundation.org>
	<1295491713.1949.898.camel@sli10-conroe>
	<20110119190548.e1f7f01f.akpm@linux-foundation.org>
	<1295493709.1949.910.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295493709.1949.910.camel@sli10-conroe>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Wu, Fengguang" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 20 Jan 2011 11:21:49 +0800 Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> > It seems to return a single offset/length tuple which refers to the
> > btrfs metadata "file", with the intent that this tuple later be fed
> > into a btrfs-specific readahead ioctl.
> > 
> > I can see how this might be used with say fatfs or ext3 where all
> > metadata resides within the blockdev address_space.  But how is a
> > filesytem which keeps its metadata in multiple address_spaces supposed
> > to use this interface?
> Oh, this looks like a big problem, thanks for letting me know such
> filesystems. is it possible specific filesystem mapping multiple
> address_space ranges to a virtual big ranges? the new ioctls handle the
> mapping.

I'm not sure what you mean by that.

ext2, minix and probably others create an address_space for each
directory.  Heaven knows what xfs does (for example).

> If the issue can't be solved, we can only add the metadata readahead for
> specific implementation like my initial post instead of a generic
> interface.

Well.  One approach would be for the kernel to report the names of all
presently-cached files.  And for each file, report the offsets of all
the pages which are presently in pagecache.  This all gets put into a
database.

At cold-boot time we open all those files and read the relevant files.

To optimise that further, userspace would need to use fibmap to work
out the LBA(s) of each page, and then read the pages in an optimised order.

To optimise that even further, userspace would need to find the on-disk
locations all the metadata for each file, generate the metadata->data
dependencies and then incorporate that into the reading order.

I actually wrote code to do all this.  Gad, it was ten years ago.  I
forget how it works, but I do recall that it pioneered the technology
of doing (effecticely) a sys_write(1, ...) from a kernel module, so the
module's output appears on modprobe's stdout and can be redirected to
another file or a pipe.  So sue me!  It's in
http://userweb.kernel.org/~akpm/stuff/fboot.tar.gz.  Good luck with
that ;)

<looks>

It walked mem_map[], indentifying pagecache pages, walking back from
the page* all the way to the filename then logging the pathname and the
file's pagecache indexes.  It also handled the blockdev superblock,
where all the ext3 metadata resides.

There are much smarter ways of doing this of course, especially with
the vfs data structures which we later added.

<googles>

According to http://kerneltrap.org/node/2157 it sped up cold boot by
"10%", whatever that means.  Seems that I wasn't sufficiently impressed
by that and got distracted.


I'm not sure any of that was very useful, really.  A full-on coldboot
optimiser really wants visibility into every disk block which need to
be read, and then mechanisms to tell the kernel to load those blocks
into the correct address_spaces.  That's hard, because file data
depends on file metadata.  A vast simplification would be to do it in
two disk passes: read all the metadata on pass 1 then all the data on
pass 2.

A totally different approach is to reorder all the data and metadata
on-disk, so no special cold-boot processing is needed at all.

And a third approach is to save all the cache into a special
file/partition/etc and to preload all that into kernel data structures
at boot.  Obviously this one is ricky/tricky because the on-disk
replica of the real data can get out of sync with the real data.
