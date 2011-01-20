From: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 1/5] add metadata_incore ioctl in vfs
Date: Thu, 20 Jan 2011 11:21:49 +0800
Message-ID: <1295493709.1949.910.camel@sli10-conroe>
References: <1295399718.1949.864.camel@sli10-conroe>
	 <20110119124158.b0348c44.akpm@linux-foundation.org>
	 <1295490647.1949.890.camel@sli10-conroe>
	 <20110119184240.b0a6a016.akpm@linux-foundation.org>
	 <1295491713.1949.898.camel@sli10-conroe>
	 <20110119190548.e1f7f01f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110119190548.e1f7f01f.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Wu, Fengguang" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2011-01-20 at 11:05 +0800, Andrew Morton wrote:
> On Thu, 20 Jan 2011 10:48:33 +0800 Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
> > On Thu, 2011-01-20 at 10:42 +0800, Andrew Morton wrote:
> > > On Thu, 20 Jan 2011 10:30:47 +0800 Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > > 
> > > > > I don't know if this is worth addressing.  Perhaps require that the
> > > > > filp refers to the root of the fs?
> > > > I didn't see why this is needed, but I can limit the fip to the root of
> > > > the fs.
> > > 
> > > I don't think it matters much either.  The only problem I can see is if
> > > we were to later try to extend the ioctl into a per-file thing.
> > since we return page range, a metadata page might be shared by several
> > files, which makes the per-file thing doesn't work. For a fs using
> > trees, it's even more hard to distinguish a file's metadata
> 
> hm, why.  A query for "which blocks need to be read to access this
> file" may return blocks which are shared with other files, but it's
> still useful info.  Because it will represent vastly less data (and
> hence IO) than the current fs-wide thing.
ok
> Now I actually look at it, I cannot find any documentation for the ioctl!  
I'll write more doc in later post.

> It seems to return a single offset/length tuple which refers to the
> btrfs metadata "file", with the intent that this tuple later be fed
> into a btrfs-specific readahead ioctl.
> 
> I can see how this might be used with say fatfs or ext3 where all
> metadata resides within the blockdev address_space.  But how is a
> filesytem which keeps its metadata in multiple address_spaces supposed
> to use this interface?
Oh, this looks like a big problem, thanks for letting me know such
filesystems. is it possible specific filesystem mapping multiple
address_space ranges to a virtual big ranges? the new ioctls handle the
mapping.
If the issue can't be solved, we can only add the metadata readahead for
specific implementation like my initial post instead of a generic
interface.

Thanks,
Shaohua
