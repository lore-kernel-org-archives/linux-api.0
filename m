From: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 1/5] add metadata_incore ioctl in vfs
Date: Thu, 20 Jan 2011 13:38:18 +0800
Message-ID: <1295501898.1949.917.camel@sli10-conroe>
References: <1295399718.1949.864.camel@sli10-conroe>
	 <20110119124158.b0348c44.akpm@linux-foundation.org>
	 <1295490647.1949.890.camel@sli10-conroe>
	 <20110119184240.b0a6a016.akpm@linux-foundation.org>
	 <1295491713.1949.898.camel@sli10-conroe>
	 <20110119190548.e1f7f01f.akpm@linux-foundation.org>
	 <1295493709.1949.910.camel@sli10-conroe>
	 <20110119201014.adf02a78.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110119201014.adf02a78.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Wu, Fengguang" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2011-01-20 at 12:10 +0800, Andrew Morton wrote:
> On Thu, 20 Jan 2011 11:21:49 +0800 Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
> > > It seems to return a single offset/length tuple which refers to the
> > > btrfs metadata "file", with the intent that this tuple later be fed
> > > into a btrfs-specific readahead ioctl.
> > > 
> > > I can see how this might be used with say fatfs or ext3 where all
> > > metadata resides within the blockdev address_space.  But how is a
> > > filesytem which keeps its metadata in multiple address_spaces supposed
> > > to use this interface?
> > Oh, this looks like a big problem, thanks for letting me know such
> > filesystems. is it possible specific filesystem mapping multiple
> > address_space ranges to a virtual big ranges? the new ioctls handle the
> > mapping.
> 
> I'm not sure what you mean by that.
> 
> ext2, minix and probably others create an address_space for each
> directory.  Heaven knows what xfs does (for example).
yes, this is for one directiory, but the all files's metadata are in
block_dev address_space.
I thought you mean there are several block_dev address_space like
address_space in some filesystems, which doesn't fit well in my
implementation. for ext like filesystem, there is only one
address_space. for filesystems with several address_space, my proposal
is map them to a virtual big address_space in the new ioctls.

snip

> I'm not sure any of that was very useful, really.  A full-on coldboot
> optimiser really wants visibility into every disk block which need to
> be read, and then mechanisms to tell the kernel to load those blocks
> into the correct address_spaces.  That's hard, because file data
> depends on file metadata.  A vast simplification would be to do it in
> two disk passes: read all the metadata on pass 1 then all the data on
> pass 2.
This is exactly what my patch does. We use the new ioctls to do metadata
readahead in first pass, and do data readahead in the second pass.

> A totally different approach is to reorder all the data and metadata
> on-disk, so no special cold-boot processing is needed at all.
not feasible for a product and it's very hard for some filesystmes.

> And a third approach is to save all the cache into a special
> file/partition/etc and to preload all that into kernel data structures
> at boot.  Obviously this one is ricky/tricky because the on-disk
> replica of the real data can get out of sync with the real data.
Tricky staff.
