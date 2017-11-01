From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 0/18 v6] dax, ext4, xfs: Synchronous page faults
Date: Wed,  1 Nov 2017 16:36:29 +0100
Message-ID: <20171101153648.30166-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Darrick J . Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello,

here is the sixth version of my patches to implement synchronous page faults
for DAX mappings to make flushing of DAX mappings possible from userspace so
that they can be flushed on finer than page granularity and also avoid the
overhead of a syscall.

I think we are ready to get this merged - I've talked to Dan and he said he
could take the patches through his tree. It would just be nice to get final
ack from Christoph for the first patch implementing MAP_VALIDATE and someone
from XFS folks to check patch 17 (make xfs_filemap_pfn_mkwrite use
__xfs_filemap_fault()).

---

We use a new mmap flag MAP_SYNC to indicate that page faults for the mapping
should be synchronous.  The guarantee provided by this flag is: While a block
is writeably mapped into page tables of this mapping, it is guaranteed to be
visible in the file at that offset also after a crash.

How I implement this is that ->iomap_begin() indicates by a flag that inode
block mapping metadata is unstable and may need flushing (use the same test as
whether fdatasync() has metadata to write). If yes, DAX fault handler refrains
from inserting / write-enabling the page table entry and returns special flag
VM_FAULT_NEEDDSYNC together with a PFN to map to the filesystem fault handler.
The handler then calls fdatasync() (vfs_fsync_range()) for the affected range
and after that calls DAX code to update the page table entry appropriately.

I did some basic performance testing on the patches over ramdisk - timed
latency of page faults when faulting 512 pages. I did several tests: with file
preallocated / with file empty, with background file copying going on / without
it, with / without MAP_SYNC (so that we get comparison).  The results are
(numbers are in microseconds):

File preallocated, no background load no MAP_SYNC:
min=9 avg=10 max=46
8 - 15 us: 508
16 - 31 us: 3
32 - 63 us: 1

File preallocated, no background load, MAP_SYNC:
min=9 avg=10 max=47
8 - 15 us: 508
16 - 31 us: 2
32 - 63 us: 2

File empty, no background load, no MAP_SYNC:
min=21 avg=22 max=70
16 - 31 us: 506
32 - 63 us: 5
64 - 127 us: 1

File empty, no background load, MAP_SYNC:
min=40 avg=124 max=242
32 - 63 us: 1
64 - 127 us: 333
128 - 255 us: 178

File empty, background load, no MAP_SYNC:
min=21 avg=23 max=67
16 - 31 us: 507
32 - 63 us: 4
64 - 127 us: 1

File empty, background load, MAP_SYNC:
min=94 avg=112 max=181
64 - 127 us: 489
128 - 255 us: 23

So here we can see the difference between MAP_SYNC vs non MAP_SYNC is about
100-200 us when we need to wait for transaction commit in this setup. 

Changes since v5:
* really updated the manpage
* improved comment describing IOMAP_F_DIRTY
* fixed XFS handling of VM_FAULT_NEEDSYNC in xfs_filemap_pfn_mkwrite()

Changes since v4:
* fixed couple of minor things in the manpage
* make legacy mmap flags always supported, remove them from mask declared
  to be supported by ext4 and xfs

Changes since v3:
* updated some changelogs
* folded fs support for VM_SYNC flag into patches implementing the
  functionality
* removed ->mmap_validate, use ->mmap_supported_flags instead
* added some Reviewed-by tags
* added manpage patch

Changes since v2:
* avoid unnecessary flushing of faulted page (Ross) - I've realized it makes no
  sense to remeasure my benchmark results (after actually doing that and seeing
  no difference, sigh) since I use ramdisk and not real PMEM HW and so flushes
  are ignored.
* handle nojournal mode of ext4
* other smaller cleanups & fixes (Ross)
* factor larger part of finishing of synchronous fault into a helper (Christoph)
* reorder pfnp argument of dax_iomap_fault() (Christoph)
* add XFS support from Christoph
* use proper MAP_SYNC support in mmap(2)
* rebased on top of 4.14-rc4

Changes since v1:
* switched to using mmap flag MAP_SYNC
* cleaned up fault handlers to avoid passing pfn in vmf->orig_pte
* switched to not touching page tables before we are ready to insert final
  entry as it was unnecessary and not really simplifying anything
* renamed fault flag to VM_FAULT_NEEDDSYNC
* other smaller fixes found by reviewers

								Honza
