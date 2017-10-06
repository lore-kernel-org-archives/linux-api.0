From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v7 00/12] MAP_DIRECT for DAX RDMA and userspace flush
Date: Fri, 06 Oct 2017 15:35:13 -0700
Message-ID: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Ashok Raj <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Changes since v6 [1]:
* Abandon the concept of immutable files and rework the implementation
  to reuse same FL_LAYOUT file lease mechanism that coordinates pnfsd
  layouts vs local filesystem changes. This establishes an interface where
  the kernel is always in control of the block-map and is free to
  invalidate MAP_DIRECT mappings when a lease breaker arrives. (Christoph)

* Introduce a new ->mmap_validate() file operation since we need both
  the original @flags and @fd passed to mmap(2) to setup a MAP_DIRECT
  mapping.

* Introduce a ->lease_direct() vm operation to allow the RDMA core to
  safely register memory against DAX and tear down the mapping when the
  lease is broken. This can be reused by any sub-system that follows a
  memory registration semantic.

[1]: https://lkml.org/lkml/2017/8/23/754

---

MAP_DIRECT is a mechanism that allows an application to establish a
mapping where the kernel will not change the block-map, or otherwise
dirty the block-map metadata of a file without notification. It supports
a "flush from userspace" model where persistent memory applications can
bypass the overhead of ongoing coordination of writes with the
filesystem, and it provides safety to RDMA operations involving DAX
mappings.

The kernel always has the ability to revoke access and convert the file
back to normal operation after performing a "lease break". Similar to
fcntl leases, there is no way for userspace to to cancel the lease break
process once it has started, it can only delay it via the
/proc/sys/fs/lease-break-time setting.

MAP_DIRECT enables XFS to supplant the device-dax interface for
mmap-write access to persistent memory with no ongoing coordination with
the filesystem via fsync/msync syscalls.

---

Dan Williams (12):
      mm: introduce MAP_SHARED_VALIDATE, a mechanism to safely define new mmap flags
      fs, mm: pass fd to ->mmap_validate()
      fs: introduce i_mapdcount
      fs: MAP_DIRECT core
      xfs: prepare xfs_break_layouts() for reuse with MAP_DIRECT
      xfs: wire up MAP_DIRECT
      dma-mapping: introduce dma_has_iommu()
      fs, mapdirect: introduce ->lease_direct()
      xfs: wire up ->lease_direct()
      device-dax: wire up ->lease_direct()
      IB/core: use MAP_DIRECT to fix / enable RDMA to DAX mappings
      tools/testing/nvdimm: enable rdma unit tests


 arch/alpha/include/uapi/asm/mman.h           |    1 
 arch/mips/include/uapi/asm/mman.h            |    1 
 arch/mips/kernel/vdso.c                      |    2 
 arch/parisc/include/uapi/asm/mman.h          |    1 
 arch/tile/mm/elf.c                           |    3 
 arch/x86/mm/mpx.c                            |    3 
 arch/xtensa/include/uapi/asm/mman.h          |    1 
 drivers/base/dma-mapping.c                   |   10 +
 drivers/dax/device.c                         |    4 
 drivers/infiniband/core/umem.c               |   90 ++++++-
 drivers/iommu/amd_iommu.c                    |    6 
 drivers/iommu/intel-iommu.c                  |    6 
 fs/Kconfig                                   |    4 
 fs/Makefile                                  |    1 
 fs/aio.c                                     |    2 
 fs/mapdirect.c                               |  349 ++++++++++++++++++++++++++
 fs/xfs/Kconfig                               |    4 
 fs/xfs/Makefile                              |    1 
 fs/xfs/xfs_file.c                            |  130 ++++++++++
 fs/xfs/xfs_iomap.c                           |    9 +
 fs/xfs/xfs_layout.c                          |   42 +++
 fs/xfs/xfs_layout.h                          |   13 +
 fs/xfs/xfs_pnfs.c                            |   30 --
 fs/xfs/xfs_pnfs.h                            |   10 -
 include/linux/dma-mapping.h                  |    3 
 include/linux/fs.h                           |   33 ++
 include/linux/mapdirect.h                    |   68 +++++
 include/linux/mm.h                           |   15 +
 include/linux/mman.h                         |   42 +++
 include/rdma/ib_umem.h                       |    8 +
 include/uapi/asm-generic/mman-common.h       |    1 
 include/uapi/asm-generic/mman.h              |    1 
 ipc/shm.c                                    |    3 
 mm/internal.h                                |    2 
 mm/mmap.c                                    |   28 ++
 mm/nommu.c                                   |    5 
 mm/util.c                                    |    7 -
 tools/include/uapi/asm-generic/mman-common.h |    1 
 tools/testing/nvdimm/Kbuild                  |   31 ++
 tools/testing/nvdimm/config_check.c          |    2 
 tools/testing/nvdimm/test/iomap.c            |    6 
 41 files changed, 906 insertions(+), 73 deletions(-)
 create mode 100644 fs/mapdirect.c
 create mode 100644 fs/xfs/xfs_layout.c
 create mode 100644 fs/xfs/xfs_layout.h
 create mode 100644 include/linux/mapdirect.h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
