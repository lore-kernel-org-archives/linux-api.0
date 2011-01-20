From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 1/5] add metadata_incore ioctl in vfs
Date: Wed, 19 Jan 2011 19:05:48 -0800
Message-ID: <20110119190548.e1f7f01f.akpm@linux-foundation.org>
References: <1295399718.1949.864.camel@sli10-conroe>
	<20110119124158.b0348c44.akpm@linux-foundation.org>
	<1295490647.1949.890.camel@sli10-conroe>
	<20110119184240.b0a6a016.akpm@linux-foundation.org>
	<1295491713.1949.898.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1295491713.1949.898.camel@sli10-conroe>
Sender: linux-btrfs-owner@vger.kernel.org
To: Shaohua Li <shaohua.li@intel.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjan@infradead.org>, "Yan, Zheng" <zheng.z.yan@linux.intel.com>, "Wu, Fengguang" <fengguang.wu@intel.com>, linux-api <linux-api@vger.kernel.org>, manpages <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thu, 20 Jan 2011 10:48:33 +0800 Shaohua Li <shaohua.li@intel.com> wrote:

> On Thu, 2011-01-20 at 10:42 +0800, Andrew Morton wrote:
> > On Thu, 20 Jan 2011 10:30:47 +0800 Shaohua Li <shaohua.li@intel.com> wrote:
> > 
> > > > I don't know if this is worth addressing.  Perhaps require that the
> > > > filp refers to the root of the fs?
> > > I didn't see why this is needed, but I can limit the fip to the root of
> > > the fs.
> > 
> > I don't think it matters much either.  The only problem I can see is if
> > we were to later try to extend the ioctl into a per-file thing.
> since we return page range, a metadata page might be shared by several
> files, which makes the per-file thing doesn't work. For a fs using
> trees, it's even more hard to distinguish a file's metadata

hm, why.  A query for "which blocks need to be read to access this
file" may return blocks which are shared with other files, but it's
still useful info.  Because it will represent vastly less data (and
hence IO) than the current fs-wide thing.

Now I actually look at it, I cannot find any documentation for the ioctl!  

It seems to return a single offset/length tuple which refers to the
btrfs metadata "file", with the intent that this tuple later be fed
into a btrfs-specific readahead ioctl.

I can see how this might be used with say fatfs or ext3 where all
metadata resides within the blockdev address_space.  But how is a
filesytem which keeps its metadata in multiple address_spaces supposed
to use this interface?

So.  Please fully document the proposed userspace APIs!  This should be
the first thing we look at.  Then we can take a look at how applicable
that is to other-than-btrfs filesystems.

