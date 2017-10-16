From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v9 0/6] MAP_DIRECT for DAX userspace flush
Date: Mon, 16 Oct 2017 15:07:28 +0300
Message-ID: <27694a5e-ec3a-0a68-b053-c138e0c91446@grimberg.me>
References: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171012142319.GA11254@lst.de>
 <CAPcyv4gTON__Ohop0B5R2gsKXC71bycTBozqGmF3WmwG9C6LVA@mail.gmail.com>
 <20171013065716.GB26461@lst.de>
 <CAPcyv4gaLBBefOU+8f7_ypYnCTjSMk+9nq8NfCqBHAE+NbUusw@mail.gmail.com>
 <20171013163822.GA17411@obsidianresearch.com>
 <CAPcyv4jDHp8z2VgVfyRK1WwMzixYVQnh54LZoPD57HB3yqSPPQ@mail.gmail.com>
 <20171013173145.GA18702@obsidianresearch.com> <20171016072644.GB28270@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016072644.GB28270-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org


>> I don't think that really represents how lots of apps actually use
>> RDMA.
>>
>> RDMA is often buried down in the software stack (eg in a MPI), and by
>> the time a mapping gets used for RDMA transfer the link between the
>> FD, mmap and the MR is totally opaque.
>>
>> Having a MR specific notification means the low level RDMA libraries
>> have a chance to deal with everything for the app.
>>
>> Eg consider a HPC app using MPI that uses some DAX aware library to
>> get DAX backed mmap's. It then passes memory in those mmaps to the
>> MPI library to do transfers. The MPI creates the MR on demand.
>>
> 
> I suspect one of the more interesting use cases might be a file server,
> for which that's not the case.  But otherwise I agree with the above,
> and also thing that notifying the MR handle is the only way to go for
> another very important reason:  fencing.  What if the application/library
> does not react on the notification?  With a per-MR notification we
> can unregister the MR in kernel space and have a rock solid fencing
> mechanism.  And that is the most important bit here.

I agree we must deregister the MR in kernel space. As said, I think
its perfectly reasonable to let user-space see error completions and
provide query mechanism for MR granularity (unfortunately this will
probably need drivers assistance as they know how their device reports
in MR granularity access violations).
