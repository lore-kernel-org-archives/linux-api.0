From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v9 0/6] MAP_DIRECT for DAX userspace flush
Date: Fri, 13 Oct 2017 08:14:55 -0700
Message-ID: <CAPcyv4gaLBBefOU+8f7_ypYnCTjSMk+9nq8NfCqBHAE+NbUusw@mail.gmail.com>
References: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171012142319.GA11254@lst.de> <CAPcyv4gTON__Ohop0B5R2gsKXC71bycTBozqGmF3WmwG9C6LVA@mail.gmail.com>
 <20171013065716.GB26461@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171013065716.GB26461-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 12, 2017 at 11:57 PM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> On Thu, Oct 12, 2017 at 10:41:39AM -0700, Dan Williams wrote:
>> So, you're jumping into this review at v9 where I've split the patches
>> that take an initial MAP_DIRECT lease out from the patches that take
>> FL_LAYOUT leases at memory registration time. You can see a previous
>> attempt in "[PATCH v8 00/14] MAP_DIRECT for DAX RDMA and userspace
>> flush" which should be in your inbox.
>
> The point is that your problem has absolutely nothing to do with mmap,
> and all with get_user_pages.
>
> get_user_pages on DAX doesn't give the same guarantees as on pagecache
> or anonymous memory, and that is the prbolem we need to fix.  In fact
> I'm pretty sure if we try hard enough (and we might have to try
> very hard) we can see the same problem with plain direct I/O and without
> any RDMA involved, e.g. do a larger direct I/O write to memory that is
> mmap()ed from a DAX file, then truncate the DAX file and reallocate
> the blocks, and we might corrupt that new file.  We'll probably need
> a special setup where there is little other chance but to reallocate
> those used blocks.

I'll take a harder look at this...

> So what we need to do first is to fix get_user_pages vs unmapping
> DAX mmap()ed blocks, be that from a hole punch, truncate, COW
> operation, etc.
>
> Then we need to look into the special case of a long-living non-transient
> get_user_pages that RDMA does - we can't just reject any truncate or
> other operation for that, so that's where something like me layout
> lease suggestion comes into play - but the call that should get the
> least is not the mmap - it's the memory registration call that does
> the get_user_pages.

Yes, mmap is not the place to get the lease for a later
get_user_pages, and my patches do take an additional lease at
get_user_pages / MR init time. However, the mmap call has the
file-descriptor for SIGIO the MR-init call does not. If we delay all
of the setup it to MR time then we need to invent a notification
scheme specific to RDMA which seems like a waste to me when we can
generically signal an event on the fd for any event that effects any
of the vma's on the file. The FL_LAYOUT lease impacts the entire file,
so as far as I can see delaying the notification until MR-init is too
late, too granular, and too RDMA specific.
