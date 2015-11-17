From: Dave Hansen <dave@sr71.net>
Subject: [PATCH 00/37] x86: Memory Protection Keys
Date: Mon, 16 Nov 2015 19:35:11 -0800
Message-ID: <20151117033511.BFFA1440@viggo.jf.intel.com>
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave@sr71.net>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, aarcange@redhat.com, akpm@linux-foundation.org, jack@suse.cz, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com
List-Id: linux-api@vger.kernel.org

Memory Protection Keys for User pages is a CPU feature which will
first appear on Skylake Servers, but will also be supported on
future non-server parts.  It provides a mechanism for enforcing
page-based protections, but without requiring modification of the
page tables when an application changes protection domains.  See
the Documentation/ patch for more details.

Changes from RFCv3:

 * Added 'current' and 'foreign' variants of get_user_pages() to
   help indicate whether protection keys should be enforced.
   Thanks to Jerome Glisse for pointing out this issue.
 * Added "allocation" and set/get system calls so that we can do
   management of proection keys in the kernel.  This opens the
   door to use of specific protection keys for kernel use in the
   future, such as for execute-only memory.
 * Removed the kselftest code for the moment.  It will be
   submitted separately.

Thanks Ingo and Thomas for most of these):
Changes from RFCv2 (Thanks Ingo and Thomas for most of these):

 * few minor compile warnings
 * changed 'nopku' interaction with cpuid bits.  Now, we do not
   clear the PKU cpuid bit, we just skip enabling it.
 * changed __pkru_allows_write() to also check access disable bit
 * removed the unused write_pkru()
 * made si_pkey a u64 and added some patch description details.
   Also made it share space in siginfo with MPX and clarified
   comments.
 * give some real text for the Processor Trace xsave state
 * made vma_pkey() less ugly (and much more optimized actually)
 * added SEGV_PKUERR to copy_siginfo_to_user()
 * remove page table walk when filling in si_pkey, added some
   big fat comments about it being inherently racy.
 * added self test code

This code is not runnable to anyone outside of Intel unless they
have some special hardware or a fancy simulator.  If you are
interested in running this for real, please get in touch with me.
Hardware is available to a very small but nonzero number of
people.

This set is also available here (with the new syscall):

	git://git.kernel.org/pub/scm/linux/kernel/git/daveh/x86-pkeys.git pkeys-v010

=== diffstat ===

 Documentation/kernel-parameters.txt         |   3 +
 Documentation/x86/protection-keys.txt       |  53 +++++
 arch/mips/mm/gup.c                          |   3 +-
 arch/powerpc/include/asm/mman.h             |   5 +-
 arch/powerpc/include/asm/mmu_context.h      |  12 +
 arch/s390/include/asm/mmu_context.h         |  12 +
 arch/s390/mm/gup.c                          |   3 +-
 arch/sh/mm/gup.c                            |   2 +-
 arch/sparc/mm/gup.c                         |   2 +-
 arch/unicore32/include/asm/mmu_context.h    |  12 +
 arch/x86/Kconfig                            |  16 ++
 arch/x86/entry/syscalls/syscall_32.tbl      |   5 +
 arch/x86/entry/syscalls/syscall_64.tbl      |   5 +
 arch/x86/include/asm/cpufeature.h           |  54 +++--
 arch/x86/include/asm/disabled-features.h    |  12 +
 arch/x86/include/asm/fpu/types.h            |  12 +
 arch/x86/include/asm/fpu/xstate.h           |   4 +-
 arch/x86/include/asm/mmu.h                  |   7 +
 arch/x86/include/asm/mmu_context.h          | 110 ++++++++-
 arch/x86/include/asm/pgtable.h              |  38 +++
 arch/x86/include/asm/pgtable_types.h        |  34 ++-
 arch/x86/include/asm/pkeys.h                |  68 ++++++
 arch/x86/include/asm/required-features.h    |   4 +
 arch/x86/include/asm/special_insns.h        |  20 ++
 arch/x86/include/uapi/asm/mman.h            |  22 ++
 arch/x86/include/uapi/asm/processor-flags.h |   2 +
 arch/x86/kernel/cpu/common.c                |  42 ++++
 arch/x86/kernel/fpu/xstate.c                | 250 +++++++++++++++++++-
 arch/x86/kernel/ldt.c                       |   4 +-
 arch/x86/kernel/process_64.c                |   2 +
 arch/x86/kernel/setup.c                     |   9 +
 arch/x86/mm/fault.c                         | 153 ++++++++++--
 arch/x86/mm/gup.c                           |  52 ++--
 arch/x86/mm/mpx.c                           |   4 +-
 drivers/char/agp/frontend.c                 |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c     |   4 +-
 drivers/gpu/drm/i915/i915_gem_userptr.c     |   2 +-
 drivers/gpu/drm/radeon/radeon_ttm.c         |   4 +-
 drivers/gpu/drm/via/via_dmablit.c           |   3 +-
 drivers/infiniband/core/umem.c              |   2 +-
 drivers/infiniband/core/umem_odp.c          |   8 +-
 drivers/infiniband/hw/mthca/mthca_memfree.c |   3 +-
 drivers/infiniband/hw/qib/qib_user_pages.c  |   3 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c    |   2 +-
 drivers/iommu/amd_iommu_v2.c                |   8 +-
 drivers/media/pci/ivtv/ivtv-udma.c          |   4 +-
 drivers/media/pci/ivtv/ivtv-yuv.c           |  10 +-
 drivers/media/v4l2-core/videobuf-dma-sg.c   |   3 +-
 drivers/misc/sgi-gru/grufault.c             |   3 +-
 drivers/scsi/st.c                           |   2 -
 drivers/staging/android/ashmem.c            |   4 +-
 drivers/video/fbdev/pvr2fb.c                |   4 +-
 drivers/virt/fsl_hypervisor.c               |   5 +-
 fs/exec.c                                   |   8 +-
 fs/proc/task_mmu.c                          |   5 +
 include/asm-generic/mm_hooks.h              |  13 +
 include/linux/mm.h                          |  52 +++-
 include/linux/mman.h                        |   6 +-
 include/linux/pkeys.h                       |  59 +++++
 include/uapi/asm-generic/mman-common.h      |   5 +
 include/uapi/asm-generic/siginfo.h          |  17 +-
 kernel/events/uprobes.c                     |   8 +-
 kernel/signal.c                             |   4 +
 mm/Kconfig                                  |  13 +
 mm/frame_vector.c                           |   9 +-
 mm/gup.c                                    | 153 ++++++------
 mm/ksm.c                                    |  10 +-
 mm/memory.c                                 |   8 +-
 mm/mempolicy.c                              |   6 +-
 mm/mmap.c                                   |   2 +-
 mm/mprotect.c                               | 134 ++++++++++-
 mm/nommu.c                                  |  35 ++-
 mm/process_vm_access.c                      |   6 +-
 mm/util.c                                   |   4 +-
 net/ceph/pagevec.c                          |   2 +-
 security/tomoyo/domain.c                    |   9 +-
 virt/kvm/async_pf.c                         |   2 +-
 virt/kvm/kvm_main.c                         |  13 +-
 78 files changed, 1410 insertions(+), 285 deletions(-)


Cc: linux-api@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: aarcange@redhat.com
Cc: akpm@linux-foundation.org
Cc: jack@suse.cz
Cc: kirill.shutemov@linux.intel.com
Cc: linux-api@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com
Cc: x86@kernel.org
