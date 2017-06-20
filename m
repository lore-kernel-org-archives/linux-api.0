From: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 2/2] mm, fs: daxfile, an interface for
 byte-addressable updates to pmem
Date: Tue, 20 Jun 2017 09:14:24 -0700
Message-ID: <CALCETrVCJkm5SCxAtNMW36eONHsFw1s0dkVnDAs4vAXvEKMsPw@mail.gmail.com>
References: <149766213493.22552.4057048843646200083.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CALCETrU1Hg=q4cdQDex--3nVBfwRC1o=9pC6Ss77Z8Lxg7ZJLg@mail.gmail.com>
 <CAPcyv4j4UEegViDJcLZjVv5AFGC18-DcvHFnhZatB0hH3BY85g@mail.gmail.com>
 <CALCETrUfv26pvmyQ1gOkKbzfSXK2DnmeBG6VmSWjFy1WBhknTw@mail.gmail.com>
 <CAPcyv4iPb69e+rE3fJUzm9U_P_dLfhantU9mvYmV-R0oQee4rA@mail.gmail.com>
 <CALCETrVY38h2ajpod2U_2pdHSp8zO4mG2p19h=OnnHmhGTairw@mail.gmail.com>
 <20170619132107.GG11993@dastard>
 <CALCETrUe0igzK0RZTSSondkCY3ApYQti89tOh00f0j_APrf_dQ@mail.gmail.com>
 <20170620004653.GI17542@dastard>
 <CALCETrVuoPDRuuhc9X8eVCYiFUzWLSTRkcjbD6jas_2J2GixNQ@mail.gmail.com>
 <20170620101145.GJ17542@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170620101145.GJ17542@dastard>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 20, 2017 at 3:11 AM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> On Mon, Jun 19, 2017 at 10:53:12PM -0700, Andy Lutomirski wrote:
>> On Mon, Jun 19, 2017 at 5:46 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
>> > On Mon, Jun 19, 2017 at 08:22:10AM -0700, Andy Lutomirski wrote:
>> >> Second: syncing extents.  Here's a straw man.  Forget the mmap() flag.
>> >> Instead add a new msync() operation:
>> >>
>> >> msync(start, length, MSYNC_PMEM_PREPARE_WRITE);
>> >
>> > How's this any different from the fallocate command I proposed to do
>> > this (apart from the fact that msync() is not intended to be abused
>> > as a file preallocation/zeroing interface)?
>>
>> I must have missed that suggestion.
>>
>> But it's different in a major way.  fallocate() takes an fd parameter,
>> which means that, if some flag gets set, it's set on the struct file.
>
> DAX is a property of the inode, not the VMA or struct file as it
> needs to be consistent across all VMAs and struct files that
> reference that inode. Also, fallocate() manipulates state and
> metadata hidden behind the struct inode, not the struct file, so it
> seems to me like the right API to use.

I'm not sure I see why.  I can think of a few different scenarios:

 - Reflink while a DAX-using program is running.  It would be nice for
performance, but not critical for functionality, if trying to reflink
a file that's mapped for DAX would copy instead of COWing.  But
breaking COW on the next page_mkwrite would work, too.  A per-inode
count of the number of live DAX mappings or of the number of struct
file instances that have requested DAX would work here.

 - Trying to use DAX on a file that is already reflinked.  The order
of operations doesn't matter hugely, except that breaking COW for the
entire range in question all at once would be faster and result in
better allocation.

 - Checksumming filesystems.  I think it's basically impossible to do
DAX writes to a file like this.  A filesystem could skip checksumming
on extents that are actively mapped for DAX, but something like chattr
to tell, say, btrfs that a given file is intended for DAX is probably
better.  (But, if so, it should presumably be persistent like chattr
and not something that's purely in memory like daxctl().)

 - Defrag and such on an otherwise simple filesystem.  Defragging a
file while it's not actively mapped for DAX should be allowed.
Defragging a file while it is actively mapped for DAX may be slow, but
it a filesystem could certainly make it work.

 - RAID.  Not going to work.

>
> And, as mmap() requires a fd to set up the mapping and fallocate()
> would have to be run *before* mmap() is used to access the data
> directly, I don't see why using fallocate would be a problem here...

Fair enough.  But ISTM fallocate() has no business setting up
important state in the struct file.  It's an operation on inodes.

Looking at the above scenarios, it seems to may that two or three
separate mechanisms may be ideal here.

1. The most important: some way to tell the kernel that an open file
description or an mmap or some subrange thereof is going to be used
for DAX writes and for the kernel to respond by saying "yes, okay" or
"no, not okay".  This should be 100% reliable, which means that all
the corner cases have to work.  This means that, if one task says
"make this file work for DAX" and another task extends the file using
truncate (without calling fallocate), then whatever the kernel
promised to the first task should remain true.

2. Some way to tell filesystems like btrfs to make a file that will be
DAX-able.  chattr +C might already fit the bill.  Without this, I'd
expect the normal incantation to DAX-map a file on btrfs to return an
error.

3. (Not strictly related to DAX.) A way to tell the kernel "I have
this file mmapped for write.  Please go out of your way to avoid
future page faults."  I've wanted this for ordinary files on ext4.
The kernel could, but presently does not, use hardware dirty tracking
instead of software dirty tracking to decide when to write the page
back.  The kernel could also, in principle, write back dirty pages
without ever write protecting them.  For DAX, this might change
behavior to prevent any operation that would relocate blocks or to
have the kernel go out of its way to only do such operations when
absolutely necessary and to immediately update and unwriteprotect the
relevant pages.

(3) is optional and could be delayed to the distant future.  It's not
needed for correctness.

I really don't want to see a scenario where DAX works if you use some
fancy special-purpose library exactly as intended but occasionally
eats your data if you don't use the library exactly as intended.
Getting a valid DAX mapping, writing to it, and doing
CLFLUSHOPT;SFENCE must make that write durable no matter what (unless
the underlying hardware actually fails).

> The MAP_SYNC proposal is effectively "run the metadata side of
> fdatasync() on every page fault". If the inode is not metadata
> dirty, then it will do nothing, otherwise it will do what it needs
> to stabilise the inode for userspace to be able to sync the data and
> it will block until it is done.
>
> Prediction for the MAP_SYNC future: frequent bug reports about huge,
> unpredictable page fault latencies on DAX files because every so
> often a page fault is required to sync tens of thousands of
> unrelated dirty objects because of filesystem journal ordering
> constraints....

Is this really so bad?  Someone might ask for relaxed journal ordering
or they might switch to a different filesystem.  IIRC some filesystems
(ZFS?) have explicit support for this use case.  I suspect that users
saying "your filesystem is slower than I'd like for such-and-such use
case" isn't all that rare.
