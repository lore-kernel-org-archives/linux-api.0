From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v06 00/36] Userspace compile test and fixes for exported uapi header files
Date: Sun,  6 Aug 2017 18:43:51 +0200
Message-ID: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>
List-Id: linux-api@vger.kernel.org

v6:
Addressed v5 review comments.
Dropped patches already applied from other developers for same problems:
thanks Christoph Hellwig, Nicolas Dichtel, Arnd Bergmann, Dmitry V. Levin,
Leon Romanovsky, David Lebrun, Jason Gunthorpe, Jonas Gorski, Stephen
Hemminger, Davide Caratti and others!
Moved glibc compatibility fix to a separate patch set to focus on these.
Minor tuning to scripts/headers_compile_test.sh.
Since several patches are not getting any review comments from lkml or from
people and lists added by scripts/get_maintainer.pl, added manually crafted
Cc:'s to the patches.

v5:
https://lkml.org/lkml/2016/8/22/661
two years now from v1 to v5 though some of the patches have been applied
with these changes all uapi headers compile stand alone in users space
added myself to MAINTAINERS for the test script
tried to fix all v04 review findings
due to regression in one of the accepted patches, added a glibc compatibility test
fixed some glibc compatibility issues, which are hopefully on the right path

v4:
https://lkml.org/lkml/2015/10/15/22
tried to fix v03 review findings
tried to fix all hack patches

v3:
https://lkml.org/lkml/2015/5/30/96
tried to fix all v2 review findings
tried to guess how to fix a few more issue
with a few hacks, 0 files fail and 760 files pass the compile test on 32bit x86

v2:
https://lkml.org/lkml/2015/2/16/521
added cross compiler support with CROSS_COMPILE,
detecting libc and GCC headers from compiler,
more header file fixes

v1:
https://lkml.org/lkml/2014/8/21/665

Users of kernel header files would be happier if they did not contain
kernel specific parts and would contain #include statements for all
other header files that they depend on, and in general would compile.

This patch set introduces a compile test for headers exported to userspace
and then fixes all 42 of the remaining userspace header compilation
failures. Some of the fixes may change include order and thus may expose
incompatibilities between kernel and libc and other userspace library
headers which include incompatible copies of kernel uapi header definitions.

Changes are also available in headers_test_v06 branch at github:
https://github.com/mcfrisk/linux/tree/headers_test_v06

Here's how to run the userspace compile tests and example output with these
patches applied on top of v4.13-rc3-216-g0a23ea65ce9f:

$ make headers_install
$ cd usr/include
$ ../../scripts/headers_compile_test.sh
...
Kernel header compile test statistics:

0 files failed the kernel header compile test.
863 files passed the kernel header compile test.

Compile tested with the test itself on 32bit x86 and armhf and
with allmodconfig on x86 i586.

Would be nice when various Linux kernel subsystem maintainers would
pick and apply patches from this series to their queues, and comment
if there are problems with any of them.

Mikko Rapeli (36):
  Add scripts/headers_compile_test.sh: compile test for exported uapi
    headers
  uapi scsi/scsi_bsg_fc.h: use __u8, __u32 and __u64 from linux/types.h
  uapi scsi/scsi_netlink.h: use __u8, __u16 and __u64 from linux/types.h
  uapi scsi/scsi_netlink_fc.h: use __u16, __u32 and __u64 from
    linux/types.h
  uapi linux/sysctl.h: use __kernel_size_t instead of size_t
  uapi asm-generic/ipcbuf.h: include linux/posix_types.h
  uapi asm-generic/msgbuf.h: include asm/ipcbuf.h
  uapi asm-generic/shmbuf.h: include fixes
  uapi asm-generic/sembuf.h: include asm/posix_types.h and asm/ipcbuf.h
  uapi asm-generic/signal.h: use __kernel_size_t instead of size_t
  uapi asm-generic/ucontext.h: include asm/signal.h and asm/sigcontext.h
  x86 uapi asm/signal.h: use __kernel_size_t instead of size_t
  x86 uapi asm/sembuf.h: include linux/types.h and linux/ipc.h
  arm uapi asm/signal.h: include <stddef.h> for size_t in userspace
  uapi linux/socket.h: include sys/socket.h in user space
  uapi linux/dlm_netlink.h: include linux/dlmconstants.h
  uapi linux/sctp.h: use __u8, __u16 and __u32 from linux/types.h
  uapi linux/errqueue.h: include linux/time.h in user space
  uapi linux/omapfb.h: use __kernel_size_t instead of size_t
  uapi linux/scc.h: include linux/sockios.h
  uapi linux/kexec.h: use __kernel_size_t instead of size_t
  uapi linux/reiserfs_xattr.h: use __kernel_size_t instead of size_t
  uapi linux/coda.h: use __kernel_pid_t and add u_short etc definitions
    for userspace
  uapi linux/coda_psdev.h: move upc_req definition from uapi to kernel
    side headers
  uapi linux/android/binder.h: use __kernel_pid_t and __kernel_uid_t
  uapi xen/privcmd.h: fix compilation in userspace
  uapi xen/gntdev.h: include xen/privcmd.h and define grant_ref_t
  uapi xen/evtchn.h: include xen/privcmd.h
  uapi linux/elfcore.h: remove non-compiling userspace parts
  uapi rdma/rdma_user_rxe.h: include in.h and in6.h
  uapi linux/patchkey.h: change #error to #warning if file included
    directly
  uapi drm/armada_drm.h: use __u32 and __u64 instead of uint32_t and
    uint64_t
  uapi linux/fsmap.h: use __kernel_size_t instead of size_t
  uapi: break dependency loop between <linux/hdlc/ioctl.h> and
    <linux/if.h>
  uapi linux/tls.h: don't include <net/tcp.h> in user space
  uapi linux/kfd_ioctl.h: use __u32 and __u64 instead of uint32_t and
    uint64_t

 MAINTAINERS                         |   5 +
 arch/arm/include/uapi/asm/signal.h  |   2 +
 arch/x86/include/uapi/asm/sembuf.h  |   3 +
 arch/x86/include/uapi/asm/signal.h  |   2 +-
 include/linux/coda_psdev.h          |  11 +
 include/uapi/asm-generic/ipcbuf.h   |   2 +
 include/uapi/asm-generic/msgbuf.h   |   2 +
 include/uapi/asm-generic/sembuf.h   |   2 +
 include/uapi/asm-generic/shmbuf.h   |   4 +-
 include/uapi/asm-generic/signal.h   |   2 +-
 include/uapi/asm-generic/ucontext.h |   3 +
 include/uapi/drm/armada_drm.h       |  22 +-
 include/uapi/linux/android/binder.h |   4 +-
 include/uapi/linux/coda.h           |  11 +-
 include/uapi/linux/coda_psdev.h     |  13 -
 include/uapi/linux/dlm_netlink.h    |   1 +
 include/uapi/linux/elfcore.h        |  21 +-
 include/uapi/linux/errqueue.h       |   6 +
 include/uapi/linux/fsmap.h          |   2 +-
 include/uapi/linux/hdlc/ioctl.h     |  17 +-
 include/uapi/linux/if.h             |  23 +-
 include/uapi/linux/kexec.h          |   4 +-
 include/uapi/linux/kfd_ioctl.h      | 172 ++++++------
 include/uapi/linux/omapfb.h         |   2 +-
 include/uapi/linux/patchkey.h       |   2 +-
 include/uapi/linux/reiserfs_xattr.h |   2 +-
 include/uapi/linux/scc.h            |   1 +
 include/uapi/linux/sctp.h           |  20 +-
 include/uapi/linux/socket.h         |   4 +
 include/uapi/linux/sysctl.h         |   4 +-
 include/uapi/linux/tls.h            |   2 +
 include/uapi/rdma/rdma_user_rxe.h   |   2 +
 include/uapi/scsi/scsi_bsg_fc.h     |  54 ++--
 include/uapi/scsi/scsi_netlink.h    |  22 +-
 include/uapi/scsi/scsi_netlink_fc.h |  16 +-
 include/uapi/xen/evtchn.h           |   2 +
 include/uapi/xen/gntdev.h           |   6 +
 include/uapi/xen/privcmd.h          |  14 +-
 include/xen/interface/grant_table.h |   6 +-
 scripts/headers_compile_test.sh     | 507 ++++++++++++++++++++++++++++++++++++
 40 files changed, 784 insertions(+), 216 deletions(-)
 create mode 100755 scripts/headers_compile_test.sh

-- 
2.13.3
