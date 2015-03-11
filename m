From: James Hogan <james.hogan-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/20] MIPS: KVM: Guest FPU & SIMD (MSA) support
Date: Wed, 11 Mar 2015 14:44:36 +0000
Message-ID: <1426085096-12932-1-git-send-email-james.hogan@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org
Cc: James Hogan <james.hogan-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Paul Burton <paul.burton-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patchset primarily adds guest Floating Point Unit (FPU) and MIPS
SIMD Architecture (MSA) support to MIPS KVM, by enabling the host
FPU/MSA while in guest mode.

This patchset depends on Paul Burton's FP/MSA fixes patchset, which will
hopefully make it into 4.0. I'd like to get this into 4.1, so all review
comments welcome. Corresponding QEMU patches will follow soon.

- Adds KVM_CAP_MIPS_FPU and KVM_CAP_MIPS_MSA capabilities which must be
  enabled to add FPU/MSA to the guest.
- Supports FR=0, FR=1, FRE=1 floating point register modes and 128-bit
  vector registers.
- Does not support UFR/UFE (guest user control of FR/FRE bits), or MSA
  vector partitioning.
- Context restore is lazy: done on first actual use.
- Context save is lazy: once restored, host FPU/MSA gets
  enabled/disabled when guest enables/disables it, with registers left
  loaded as long as possible.
- So the state that can be loaded at any one time is:
    - No FPRs/vector state
    - FR=0 FPRs (change of FR discards FP state)
    - FR=1 FPRs
    - Vector state (includes FR=1 FPRs)
    - Vector state only (when guest CU1=0, FR=0)
- FCSR/MSACSR status registers are saved/restored around guest
  execution, since care must be taken to handle FP exceptions when
  writing these registers.

The patches are arranged roughly in groups:
- Patch 1 is a related minimal stable fix which can be applied in
  advance of the others (patch 18 fills it out a bit).
- Patch 2 is a generic MIPS change required to be able to restore
  FCSR/MSACSR registers with exceptions pending.
- Patches 3..10 add various misc KVM improvements and cleanups, most of
  which the later patches depend on.
- Patches 11..15 add the main guest FPU support.
- Patches 16..20 add the main guest MSA support (structured like 11.15).

James Hogan (20):
  MIPS: KVM: Handle MSA Disabled exceptions from guest

  MIPS: Clear [MSA]FPE CSR.Cause after notify_die()

  MIPS: KVM: Handle TRAP exceptions from guest kernel
  MIPS: KVM: Implement PRid CP0 register access
  MIPS: KVM: Sort kvm_mips_get_reg() registers
  MIPS: KVM: Drop pr_info messages on init/exit
  MIPS: KVM: Clean up register definitions a little
  MIPS: KVM: Simplify default guest Config registers
  MIPS: KVM: Add Config4/5 and writing of Config registers
  MIPS: KVM: Add vcpu_get_regs/vcpu_set_regs callback

  MIPS: KVM: Add base guest FPU support
  MIPS: KVM: Emulate FPU bits in COP0 interface
  MIPS: KVM: Add FP exception handling
  MIPS: KVM: Expose FPU registers
  MIPS: KVM: Wire up FPU capability

  MIPS: KVM: Add base guest MSA support
  MIPS: KVM: Emulate MSA bits in COP0 interface
  MIPS: KVM: Add MSA exception handling
  MIPS: KVM: Expose MSA registers
  MIPS: KVM: Wire up MSA capability

 Documentation/virtual/kvm/api.txt |  47 ++++
 arch/mips/include/asm/kdebug.h    |   3 +-
 arch/mips/include/asm/kvm_host.h  | 125 +++++++---
 arch/mips/include/uapi/asm/kvm.h  | 160 ++++++++-----
 arch/mips/kernel/asm-offsets.c    |  39 ++++
 arch/mips/kernel/genex.S          |  14 +-
 arch/mips/kernel/traps.c          |  16 +-
 arch/mips/kvm/Makefile            |   8 +-
 arch/mips/kvm/emulate.c           | 332 +++++++++++++++++++++++++-
 arch/mips/kvm/fpu.S               | 122 ++++++++++
 arch/mips/kvm/locore.S            |  38 +++
 arch/mips/kvm/mips.c              | 478 +++++++++++++++++++++++++++++++++++++-
 arch/mips/kvm/msa.S               | 161 +++++++++++++
 arch/mips/kvm/stats.c             |   4 +
 arch/mips/kvm/tlb.c               |   6 +
 arch/mips/kvm/trap_emul.c         | 199 +++++++++++++++-
 include/uapi/linux/kvm.h          |   2 +
 17 files changed, 1630 insertions(+), 124 deletions(-)
 create mode 100644 arch/mips/kvm/fpu.S
 create mode 100644 arch/mips/kvm/msa.S

Cc: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Paul Burton <paul.burton-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Cc: Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
Cc: Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
-- 
2.0.5
