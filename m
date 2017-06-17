From: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 2/2] mm, fs: daxfile, an interface for
 byte-addressable updates to pmem
Date: Sat, 17 Jun 2017 16:50:49 -0700
Message-ID: <CALCETrUfv26pvmyQ1gOkKbzfSXK2DnmeBG6VmSWjFy1WBhknTw@mail.gmail.com>
References: <149766212410.22552.15957843500156182524.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149766213493.22552.4057048843646200083.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CALCETrU1Hg=q4cdQDex--3nVBfwRC1o=9pC6Ss77Z8Lxg7ZJLg@mail.gmail.com> <CAPcyv4j4UEegViDJcLZjVv5AFGC18-DcvHFnhZatB0hH3BY85g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPcyv4j4UEegViDJcLZjVv5AFGC18-DcvHFnhZatB0hH3BY85g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jun 17, 2017 at 2:52 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Sat, Jun 17, 2017 at 9:25 AM, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>
>> Can you remind those of us who haven't played with DAX in a while what
>> the problem is with mmapping a DAX file without this patchset?  If
>> there's some bookkkeeping needed to make sure that the filesystem will
>> invalidate all the mappings if it decides to move the file, maybe that
>> should be the default rather than needing a new syscall.
>
> The bookkeeping to invalidate mappings when the filesystem moves a
> block is already there.
>
> Without this patchset an application needs to call fsync/msync after
> any write to a DAX mapping otherwise there is no guarantee the
> filesystem has written the metadata to find the updated block after a
> crash or power loss event. Even if the sync operation is reduced to a
> minimal cmpxchg in userspace to check if the filesystem-metadata is
> dirty, that mechanism doesn't translate to a virtualized environment,
> as requiring guests to trigger host fsync()s is not feasible. It's a
> half-step solution when you can instead just ask the filesystem to
> never move blocks, as Dave proposed many months back.
>
> We stepped back from that proposal when it looked like a significant
> amount of per-filesystem work to introduce the capability and it was
> not clear that application developers would tolerate the side effects
> of this 'immutable' semantic. However, the implementation is dead
> simple since ext4 and xfs already need to make
> block-allocation-immutable semantics available for swapfiles. We also
> have application developers telling us they are ok with the semantics,
> especially because it catches Linux up to other operating environments
> that are already on board with allowing this type of access to pmem
> through a filesystem. This patchset gives pmem application developers
> what they want without any additional burden on filesystem
> implementations.

I see.

I have a couple of minor-ish issues with the current proposal, then.
One is that I think the terminology should be changed to still make
sense if filesystems or VFS improves to make this approach
unnecessary.  Rather than saying "this file is now static", perhaps
users should set a flag with the explicit semantics that "mmaps of
this file are guaranteed not to lose data due to the kernel's
activities", IOW that mmaps will be at least as durable as a direct
mapping of DAX memory.  Then the kernel has the flexibility to add a
future implementation in which, instead of pinning the file, the
filesystem just knows to keep metadata synced before allowing
page_mkwrite to re-enable writes to an mmapped DAX file.

My other objection is that the syscall intentionally leaks a reference
to the file.  This means it needs overflow protection and it probably
shouldn't ever be allowed to use it without privilege.

Why can't the underlying issue be easily fixed, though?  Could
.page_mkwrite just make sure that metadata is synced when the FS uses
DAX?  On a DAX fs, syncing metadata should be extremely fast.  This
could be conditioned on an madvise or mmap flag if performance might
be an issue.  As far as I know, this change alone should be
sufficient.
