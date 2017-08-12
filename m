From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v2 0/5] fs, xfs: block map immutable files for dax,
        dma-to-storage, and swap
Date: Sat, 12 Aug 2017 09:33:49 +0200
Message-ID: <20170812073349.GA12679@lst.de>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com> <CAPcyv4ii41F-Rj9pPGc0FHwrQ=hkSF_f0niQDn5_NjU-wcL+gg@mail.gmail.com> <20170805095013.GC14930@lst.de> <CAPcyv4jgKmakB0WRUjx=2eD3YJ1x+C8cgnR6tA+g4+m+0etawQ@mail.gmail.com> <20170811104429.GA13736@lst.de> <CAPcyv4jrZ5a+zmAehZDxfP=+6BNCFAXOFWro2L7ruLkk+cY7OQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4jrZ5a+zmAehZDxfP=+6BNCFAXOFWro2L7ruLkk+cY7OQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 11, 2017 at 03:26:05PM -0700, Dan Williams wrote:
> Right, but they let userspace make inferences about the state of
> metadata relative to I/O to a given storage address. In this regard
> S_IOMAP_IMMUTABLE is no different than MAP_SYNC, but 'immutable' goes
> a step further to let an application infer that the storage address is
> stable. This enables applications that MAP_SYNC does not, see below.

But the application must not know (and cannot know) the storage address,
so it doesn't matter.

> > What is the observable behavior of an extent map change?  How can you
> > describe your immutable extent map behavior so that when I violate
> > them by e.g. moving one extent to a different place on disk you can
> > observe that in userspace?
> 
> The violation is blocked, it's immutable. Using this feature means the
> application is taking away some of the kernel's freedom. That is a
> valid / safe tradeoff for the set of applications that would otherwise
> resort to raw device access.

What can the application do with it safely that it can't otherwise do?
Short answer: nothing.

> >
> > Please explain how this interface allows for any sort of safe userspace
> > DMA.
> 
> So this is where I continue to see S_IOMAP_IMMUTABLE being able to
> support applications that MAP_SYNC does not. Dave mentioned userspace
> pNFS4 servers, but there's also Samba and other protocols that want to
> negotiate a direct path to pmem outside the kernel.

Userspace pNFS servers must use a userspace file system.  Everything
else is just brainded stupid due to the amount of communication they
need to do.  Also note that the only pNFS layouts that would even cause
direct block access are pNFS block/scsi and for those the
S_IOMAP_IMMUTABLE semantics are not very useful (background: I wrote
the Linux implementation for those, and authored the scsi layout spec)


> Applications that just want flush from userspace can use MAP_SYNC,
> those that need to temporarily pin the block for RDMA can use the
> in-kernel pNFS server, and those that need to coordinate both from
> userspace can use S_IOMAP_IMMUTABLE. It's a continuum, not a
> competition.

Again - how does your application even know that I moved your block
around with your S_IOMAP_IMMUTABLE?  We should never add interfaces
that mandate implementations - we should based interfaces based on
user observable behavior - and debug tools like fiemap don't count.

Before going any further please write a man page that describeѕ your
intended semantics in a way that an application programmer understands.
