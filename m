From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [RFC PATCH 1/2] mm: introduce bmap_walk()
Date: Mon, 19 Jun 2017 19:19:57 +0100
Message-ID: <20170619181956.GH10672@ZenIV.linux.org.uk>
References: <149766212410.22552.15957843500156182524.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149766212976.22552.11210067224152823950.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170617052212.GA8246@lst.de>
 <CAPcyv4g=x+Af1C8_q=+euwNw_Fwk3Wwe45XibtYR5=kbOcmgfg@mail.gmail.com>
 <20170618075152.GA25871@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170618075152.GA25871-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 18, 2017 at 09:51:52AM +0200, Christoph Hellwig wrote:

> > That said, I think "please don't add a new bmap()
> > user, use iomap instead" is a fair comment. You know me well enough to
> > know that would be all it takes to redirect my work, I can do without
> > the bluster.
> 
> But that's not the point.  The point is that ->bmap() semantics simplify
> do not work in practice because they don't make sense.

Speaking of iomap, what's supposed to happen when doing a write into what
used to be a hole?  Suppose we have a file with a megabyte hole in it
and there's some process mmapping that range.  Another process does
write over the entire range.  We call ->iomap_begin() and allocate
disk blocks.  Then we start copying data into those.  In the meanwhile,
the first process attempts to fetch from address in the middle of that
hole.  What should happen?

Should the blocks we'd allocated in ->iomap_begin() be immediately linked
into the whatever indirect locks/btree/whatnot we are using?  That would
require zeroing all of them first - otherwise that readpage will read
uninitialized block.  Another variant would be to delay linking them
in until ->iomap_end(), but...  Suppose we get the page evicted by
memory pressure after the writer is finished with it.  If ->readpage()
comes before ->iomap_end(), we'll need to somehow figure out that it's
not a hole anymore, or we'll end up with an uptodate page full of zeroes
observed by reads after successful write().

The comment you've got in linux/iomap.h would seem to suggest the second
interpretation, but neither it nor anything in Documentation discusses the
relations with readpage/writepage...
