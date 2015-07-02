From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v7 09/11] KVM: arm64: guest debug, HW assisted debug support
Date: Thu, 02 Jul 2015 14:50:33 +0100
Message-ID: <87pp4asm6u.fsf@linaro.org>
References: <1435775343-20034-1-git-send-email-alex.bennee@linaro.org> <1435775343-20034-10-git-send-email-alex.bennee@linaro.org> <20150702084847.GB3418@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20150702084847.GB3418@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>, "agraf@suse.de" <agraf@suse.de>, "drjones@redhat.com" <drjones@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "zhichao.huang@linaro.org" <zhichao.huang@linaro.org>, "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>, "dahi@linux.vnet.ibm.com" <dahi@linux.vnet.ibm.com>, "r65777@freescale.com" <r65777@freescale.com>, "bp@suse.de" <bp@suse.de>, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <Catalin.Marinas@arm.com>, Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>, Ingo Molnar <mingo@kernel.o>
List-Id: linux-api@vger.kernel.org


Will Deacon <will.deacon@arm.com> writes:

Are you happy with this?:

Subject: [PATCH v8 09/11] KVM: arm64: guest debug, HW assisted debug su=
pport

This adds support for userspace to control the HW debug registers for
guest debug. In the debug ioctl we copy an IMPDEF registers into a new
register set called host_debug_state.

We use the recently introduced vcpu parameter debug_ptr to select which
register set is copied into the real registers when world switch occurs=
=2E

I've made some helper functions from hw_breakpoint.c more widely
available for re-use.

As with single step we need to tweak the guest registers to enable the
exceptions so we need to save and restore those bits.

Two new capabilities have been added to the KVM_EXTENSION ioctl to allo=
w
userspace to query the number of hardware break and watch points
available on the host hardware.

Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

---
v2
   - switched to C setup
   - replace host debug registers directly into context
   - minor tweak to api docs
   - setup right register for debug
   - add FAR_EL2 to debug exit structure
   - add support for trapping debug register access
v3
   - remove stray trace statement
   - fix spacing around operators (various)
   - clean-up usage of trap_debug
   - introduce debug_ptr, replace excessive memcpy stuff
   - don't use memcpy in ioctl, just assign
   - update cap ioctl documentation
   - reword a number comments
   - rename host_debug_state->external_debug_state
v4
   - use the new u32/u64 split debug_ptr approach
   - fix some wording/comments
v5
   - don't set MDSCR_EL1.KDE (not needed)
v6
   - update wording given change in commentary
   - KVM_GUESTDBG_USE_HW_BP->KVM_GUESTDBG_USE_HW
v7
   - fix merge conflicts from ioctl move to guest.c
   - use kvm_arm_reset_debug_ptr to reset ptr
   - a BUG_ON() test has been added to trap failure to reset debug_ptr
   - debugging->debug in kvm_host.h comment
   - s/defined// s/to// in commit msg
   - rm ref to introducing debug_ptr in commit msg
   - add r-b tag
v8
   - use hw_breakpoint_slots() instead
---
 Documentation/virtual/kvm/api.txt |  7 ++++++-
 arch/arm64/include/asm/kvm_host.h |  6 +++++-
 arch/arm64/kvm/debug.c            | 40 +++++++++++++++++++++++++++++++=
+++-----
 arch/arm64/kvm/guest.c            |  7 +++++++
 arch/arm64/kvm/handle_exit.c      |  6 ++++++
 arch/arm64/kvm/reset.c            | 13 +++++++++++++
 arch/arm64/kvm/sys_regs.c         |  3 ---
 include/uapi/linux/kvm.h          |  2 ++
 8 files changed, 74 insertions(+), 10 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/=
kvm/api.txt
index 33c8143..ada57df 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2668,7 +2668,7 @@ The top 16 bits of the control field are architec=
ture specific control
 flags which can include the following:
=20
   - KVM_GUESTDBG_USE_SW_BP:     using software breakpoints [x86, arm64=
]
-  - KVM_GUESTDBG_USE_HW_BP:     using hardware breakpoints [x86, s390]
+  - KVM_GUESTDBG_USE_HW_BP:     using hardware breakpoints [x86, s390,=
 arm64]
   - KVM_GUESTDBG_INJECT_DB:     inject DB type exception [x86]
   - KVM_GUESTDBG_INJECT_BP:     inject BP type exception [x86]
   - KVM_GUESTDBG_EXIT_PENDING:  trigger an immediate guest exit [s390]
@@ -2683,6 +2683,11 @@ updated to the correct (supplied) values.
 The second part of the structure is architecture specific and
 typically contains a set of debug registers.
=20
+For arm64 the number of debug registers is implementation defined and
+can be determined by querying the KVM_CAP_GUEST_DEBUG_HW_BPS and
+KVM_CAP_GUEST_DEBUG_HW_WPS capabilities which return a positive number
+indicating the number of supported registers.
+
 When debug events exit the main run loop with the reason
 KVM_EXIT_DEBUG with the kvm_debug_exit_arch part of the kvm_run
 structure containing architecture specific debug information.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
index 461d288..6c745e0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -116,13 +116,17 @@ struct kvm_vcpu_arch {
 	 * debugging the guest from the host and to maintain separate host an=
d
 	 * guest state during world switches. vcpu_debug_state are the debug
 	 * registers of the vcpu as the guest sees them.  host_debug_state ar=
e
-	 * the host registers which are saved and restored during world switc=
hes.
+	 * the host registers which are saved and restored during
+	 * world switches. external_debug_state contains the debug
+	 * values we want to debug the guest. This is set via the
+	 * KVM_SET_GUEST_DEBUG ioctl.
 	 *
 	 * debug_ptr points to the set of debug registers that should be load=
ed
 	 * onto the hardware when running the guest.
 	 */
 	struct kvm_guest_debug_arch *debug_ptr;
 	struct kvm_guest_debug_arch vcpu_debug_state;
+	struct kvm_guest_debug_arch external_debug_state;
=20
 	/* Pointer to host CPU context */
 	kvm_cpu_context_t *host_cpu_context;
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index ffefb97..46b73d7 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -105,10 +105,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 				MDCR_EL2_TDRA |
 				MDCR_EL2_TDOSA);
=20
-	/* Trap on access to debug registers? */
-	if (trap_debug)
-		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDA;
-
 	/* Is Guest debugging in effect? */
 	if (vcpu->guest_debug) {
 		/* Route all software debug exceptions to EL2 */
@@ -143,11 +139,45 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 		} else {
 			vcpu_sys_reg(vcpu, MDSCR_EL1) &=3D ~DBG_MDSCR_SS;
 		}
+
+		/*
+		 * HW Breakpoints and watchpoints
+		 *
+		 * We simply switch the debug_ptr to point to our new
+		 * external_debug_state which has been populated by the
+		 * debug ioctl. The existing KVM_ARM64_DEBUG_DIRTY
+		 * mechanism ensures the registers are updated on the
+		 * world switch.
+		 */
+		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW) {
+			/* Enable breakpoints/watchpoints */
+			vcpu_sys_reg(vcpu, MDSCR_EL1) |=3D DBG_MDSCR_MDE;
+
+			vcpu->arch.debug_ptr =3D &vcpu->arch.external_debug_state;
+			vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
+			trap_debug =3D true;
+		}
 	}
+
+	BUG_ON(!vcpu->guest_debug &&
+		vcpu->arch.debug_ptr !=3D &vcpu->arch.vcpu_debug_state);
+
+	/* Trap debug register access */
+	if (trap_debug)
+		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDA;
 }
=20
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->guest_debug)
+	if (vcpu->guest_debug) {
 		restore_guest_debug_regs(vcpu);
+
+		/*
+		 * If we were using HW debug we need to restore the
+		 * debug_ptr to the guest debug state.
+		 */
+		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW)
+			kvm_arm_reset_debug_ptr(vcpu);
+
+	}
 }
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 48de4f4..6f1b249 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -334,6 +334,7 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *=
vcpu,
=20
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE |    \
 			    KVM_GUESTDBG_USE_SW_BP | \
+			    KVM_GUESTDBG_USE_HW | \
 			    KVM_GUESTDBG_SINGLESTEP)
=20
 /**
@@ -354,6 +355,12 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm=
_vcpu *vcpu,
=20
 	if (dbg->control & KVM_GUESTDBG_ENABLE) {
 		vcpu->guest_debug =3D dbg->control;
+
+		/* Hardware assisted Break and Watch points */
+		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW) {
+			vcpu->arch.external_debug_state =3D dbg->arch;
+		}
+
 	} else {
 		/* If not enabled clear all flags */
 		vcpu->guest_debug =3D 0;
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.=
c
index e9de13e..68a0759 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -103,7 +103,11 @@ static int kvm_handle_guest_debug(struct kvm_vcpu =
*vcpu, struct kvm_run *run)
 	run->debug.arch.hsr =3D hsr;
=20
 	switch (hsr >> ESR_ELx_EC_SHIFT) {
+	case ESR_ELx_EC_WATCHPT_LOW:
+		run->debug.arch.far =3D vcpu->arch.fault.far_el2;
+		/* fall through */
 	case ESR_ELx_EC_SOFTSTP_LOW:
+	case ESR_ELx_EC_BREAKPT_LOW:
 	case ESR_ELx_EC_BKPT32:
 	case ESR_ELx_EC_BRK64:
 		break;
@@ -132,6 +136,8 @@ static exit_handle_fn arm_exit_handlers[] =3D {
 	[ESR_ELx_EC_IABT_LOW]	=3D kvm_handle_guest_abort,
 	[ESR_ELx_EC_DABT_LOW]	=3D kvm_handle_guest_abort,
 	[ESR_ELx_EC_SOFTSTP_LOW]=3D kvm_handle_guest_debug,
+	[ESR_ELx_EC_WATCHPT_LOW]=3D kvm_handle_guest_debug,
+	[ESR_ELx_EC_BREAKPT_LOW]=3D kvm_handle_guest_debug,
 	[ESR_ELx_EC_BKPT32]	=3D kvm_handle_guest_debug,
 	[ESR_ELx_EC_BRK64]	=3D kvm_handle_guest_debug,
 };
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 0b43265..5a954c4 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -22,6 +22,7 @@
 #include <linux/errno.h>
 #include <linux/kvm_host.h>
 #include <linux/kvm.h>
+#include <linux/hw_breakpoint.h>
=20
 #include <kvm/arm_arch_timer.h>
=20
@@ -56,6 +57,12 @@ static bool cpu_has_32bit_el1(void)
 	return !!(pfr0 & 0x20);
 }
=20
+/**
+ * kvm_arch_dev_ioctl_check_extension
+ *
+ * We currently assume that the number of HW registers is uniform
+ * across all CPUs (see cpuinfo_sanity_check).
+ */
 int kvm_arch_dev_ioctl_check_extension(long ext)
 {
 	int r;
@@ -64,6 +71,12 @@ int kvm_arch_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_ARM_EL1_32BIT:
 		r =3D cpu_has_32bit_el1();
 		break;
+	case KVM_CAP_GUEST_DEBUG_HW_BPS:
+		r =3D hw_breakpoint_slots(TYPE_INST);
+		break;
+	case KVM_CAP_GUEST_DEBUG_HW_WPS:
+		r  =3D hw_breakpoint_slots(TYPE_DATA);
+		break;
 	default:
 		r =3D 0;
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3267b96..f753a67 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -362,9 +362,6 @@ static inline bool trap_wcr(struct kvm_vcpu *vcpu,
 			vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg]);
 	}
=20
-	trace_trap_reg(__func__, rd->reg, p->is_write,
-		vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg]);
-
 	return true;
 }
=20
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 70ac641..f020dd0 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -817,6 +817,8 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_S390_INJECT_IRQ 113
 #define KVM_CAP_S390_IRQ_STATE 114
 #define KVM_CAP_PPC_HWRNG 115
+#define KVM_CAP_GUEST_DEBUG_HW_BPS 116
+#define KVM_CAP_GUEST_DEBUG_HW_WPS 117
=20
 #ifdef KVM_CAP_IRQ_ROUTING
=20
--=20
2.4.5


