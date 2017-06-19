From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 2/2] mm, fs: daxfile, an interface for
 byte-addressable updates to pmem
Date: Sun, 18 Jun 2017 18:51:49 -0700
Message-ID: <CAPcyv4jt2EMfiVB-5uOdjKMuYfLrqUdK4vYkteqAqXkSRqTs5g@mail.gmail.com>
References: <149766212410.22552.15957843500156182524.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149766213493.22552.4057048843646200083.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CALCETrU1Hg=q4cdQDex--3nVBfwRC1o=9pC6Ss77Z8Lxg7ZJLg@mail.gmail.com>
 <CAPcyv4j4UEegViDJcLZjVv5AFGC18-DcvHFnhZatB0hH3BY85g@mail.gmail.com>
 <CALCETrUfv26pvmyQ1gOkKbzfSXK2DnmeBG6VmSWjFy1WBhknTw@mail.gmail.com>
 <CAPcyv4iPb69e+rE3fJUzm9U_P_dLfhantU9mvYmV-R0oQee4rA@mail.gmail.com> <20170618081850.GA26332@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170618081850.GA26332-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 18, 2017 at 1:18 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> On Sat, Jun 17, 2017 at 08:15:05PM -0700, Dan Williams wrote:
>> The hang up is that it requires per-fs enabling as it needs to be
>> careful to manage mmap_sem vs fs journal locks for example. I know the
>> in-development NOVA [1] filesystem is planning to support this out of
>> the gate. ext4 would be open to implementing it, but I think xfs is
>> cold on the idea. Christoph originally proposed it here [2], before
>> Dave went on to propose immutable semantics.
>>
>> [1]: https://github.com/NVSL/NOVA
>> [2]: https://lists.01.org/pipermail/linux-nvdimm/2016-February/004609.html
>
> And I stand to that statement.  Let's get DAX stable first, and
> properly cleaned up (e.g. follow on work with separating it entirely
> from the block device).  Then think hard about how most of the
> persistent memory technologies actually work, including the point that
> for a lot of workloads page cache will be required at least on the
> write side.   And then come up with actual real use cases and we can
> look into it.

I see it differently. We're already at a good point in time to start
iterating on a fix for this issue. Ross and Jan have done a lot of
good work on the dax stability front, and the block-device separation
of dax is well underway.

> And stop trying to shoe-horn crap like this in.

The kernel shoe-horning all pmem+filesystem-dax applications into
abiding page-cache semantics is a problem, and this RFC has already
helped move the needle on a couple fronts. 1/ Swapfiles are subtly
broken which is something worth fixing, and if it gets us a
synchronous-dax mode without major filesystem surgery then that's all
for the better. 2/ There's an appetite for just fixing this
incrementally in each filesystem's fault handler, so if ext4 was able
to prove out an interface / implementation for synchronous faults we
could go with that instead of a pre-allocated + immutable interface
and let other filesystems set their own timelines.
