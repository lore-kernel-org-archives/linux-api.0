From: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Subject: [PATCH 00/34] x86: Memory Protection Keys (v5)
Date: Thu, 03 Dec 2015 17:14:24 -0800
Message-ID: <20151204011424.8A36E365@viggo.jf.intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Memory Protection Keys for User pages is a CPU feature which will
first appear on Skylake Servers, but will also be supported on
future non-server parts.  It provides a mechanism for enforcing
page-based protections, but without requiring modification of the
page tables when an application changes protection domains.  See
the Documentation/ patch for more details.

Changes from v4:

 * Made "allow setting of XSAVE state" safe if we got preempted
   between when we saved our FPU state and when we restore it.
   (I would appreciate a look from Ingo on this patch).
 * Fixed up a few things from Thomas's latest comments: splt up
   siginfo in to x86 and generic, removed extra 'eax' variable
   in rdpkru function, reworked vm_flags assignment, reworded
   a comment in pte_allows_gup()
 * Add missing DISABLED/REQUIRED_MASK14 in cpufeature.h
 * Added comment about compile optimization in fault path
 * Left get_user_pages_locked() alone.  Andrea thinks we need it.

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

	git://git.kernel.org/pub/scm/linux/kernel/git/daveh/x86-pkeys.git pkeys-v014

=== diffstat ===

Dave Hansen (34):
      mm, gup: introduce concept of "foreign" get_user_pages()
      x86, fpu: add placeholder for Processor Trace XSAVE state
      x86, pkeys: Add Kconfig option
      x86, pkeys: cpuid bit definition
      x86, pkeys: define new CR4 bit
      x86, pkeys: add PKRU xsave fields and data structure(s)
      x86, pkeys: PTE bits for storing protection key
      x86, pkeys: new page fault error code bit: PF_PK
      x86, pkeys: store protection in high VMA flags
      x86, pkeys: arch-specific protection bits
      x86, pkeys: pass VMA down in to fault signal generation code
      signals, pkeys: notify userspace about protection key faults
      x86, pkeys: fill in pkey field in siginfo
      x86, pkeys: add functions to fetch PKRU
      mm: factor out VMA fault permission checking
      x86, mm: simplify get_user_pages() PTE bit handling
      x86, pkeys: check VMAs and PTEs for protection keys
      mm: add gup flag to indicate "foreign" mm access
      x86, pkeys: optimize fault handling in access_error()
      x86, pkeys: differentiate instruction fetches
      x86, pkeys: dump PKRU with other kernel registers
      x86, pkeys: dump PTE pkey in /proc/pid/smaps
      x86, pkeys: add Kconfig prompt to existing config option
      mm, multi-arch: pass a protection key in to calc_vm_flag_bits()
      x86, pkeys: add arch_validate_pkey()
      mm: implement new mprotect_key() system call
      x86, pkeys: make mprotect_key() mask off additional vm_flags
      x86: wire up mprotect_key() system call
      x86: separate out LDT init from context init
      x86, fpu: allow setting of XSAVE state
      x86, pkeys: allocation/free syscalls
      x86, pkeys: add pkey set/get syscalls
      x86, pkeys: actually enable Memory Protection Keys in CPU
      x86, pkeys: Documentation

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
 arch/x86/include/asm/cpufeature.h           |  56 +++--
 arch/x86/include/asm/disabled-features.h    |  13 ++
 arch/x86/include/asm/fpu/internal.h         |   2 +
 arch/x86/include/asm/fpu/types.h            |  12 +
 arch/x86/include/asm/fpu/xstate.h           |   4 +-
 arch/x86/include/asm/mmu.h                  |   7 +
 arch/x86/include/asm/mmu_context.h          | 110 ++++++++-
 arch/x86/include/asm/pgtable.h              |  38 +++
 arch/x86/include/asm/pgtable_types.h        |  34 ++-
 arch/x86/include/asm/pkeys.h                |  67 ++++++
 arch/x86/include/asm/required-features.h    |   5 +
 arch/x86/include/asm/special_insns.h        |  22 ++
 arch/x86/include/uapi/asm/mman.h            |  22 ++
 arch/x86/include/uapi/asm/processor-flags.h |   2 +
 arch/x86/kernel/cpu/common.c                |  42 ++++
 arch/x86/kernel/fpu/core.c                  |  63 +++++
 arch/x86/kernel/fpu/xstate.c                | 241 +++++++++++++++++++-
 arch/x86/kernel/ldt.c                       |   4 +-
 arch/x86/kernel/process_64.c                |   2 +
 arch/x86/kernel/setup.c                     |   9 +
 arch/x86/mm/fault.c                         | 158 +++++++++++--
 arch/x86/mm/gup.c                           |  51 +++--
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
 include/asm-generic/mm_hooks.h              |  12 +
 include/linux/mm.h                          |  55 ++++-
 include/linux/mman.h                        |   6 +-
 include/linux/pkeys.h                       |  59 +++++
 include/uapi/asm-generic/mman-common.h      |   5 +
 include/uapi/asm-generic/siginfo.h          |  17 +-
 kernel/events/uprobes.c                     |   4 +-
 kernel/signal.c                             |   4 +
 mm/Kconfig                                  |  13 ++
 mm/frame_vector.c                           |   2 +-
 mm/gup.c                                    |  93 ++++++--
 mm/ksm.c                                    |  10 +-
 mm/memory.c                                 |   8 +-
 mm/mempolicy.c                              |   6 +-
 mm/mmap.c                                   |   2 +-
 mm/mprotect.c                               | 136 ++++++++++-
 mm/nommu.c                                  |  35 ++-
 mm/process_vm_access.c                      |   6 +-
 mm/util.c                                   |   4 +-
 net/ceph/pagevec.c                          |   2 +-
 security/tomoyo/domain.c                    |   9 +-
 virt/kvm/async_pf.c                         |   2 +-
 virt/kvm/kvm_main.c                         |  13 +-
 80 files changed, 1470 insertions(+), 223 deletions(-)

Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org
Cc: kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
