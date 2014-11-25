From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH 5/7] KVM: arm64: guest debug, add support for single-step
Date: Tue, 25 Nov 2014 16:10:03 +0000
Message-ID: <1416931805-23223-6-git-send-email-alex.bennee@linaro.org>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de
Cc: jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, pbonzini@redhat.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Gleb Natapov <gleb@kernel.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, open list <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

This adds support for single-stepping the guest. As userspace can and
will manipulate guest registers before restarting any tweaking of the
registers has to occur just before control is passed back to the guest.
=46urthermore while guest debugging is in effect we need to squash the
ability of the guest to single-step itself as we have no easy way of
re-entering the guest after the exception has been delivered to the
hypervisor.

Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 48d26bb..a76daae 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -38,6 +38,7 @@
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 #include <asm/virt.h>
+#include <asm/debug-monitors.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
@@ -300,6 +301,17 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_arm_set_running_vcpu(NULL);
 }
=20
+/**
+ * kvm_arch_vcpu_ioctl_set_guest_debug - Setup guest debugging
+ * @kvm:	pointer to the KVM struct
+ * @kvm_guest_debug: the ioctl data buffer
+ *
+ * This sets up the VM for guest debugging. Care has to be taken when
+ * manipulating guest registers as these will be set/cleared by the
+ * hyper-visor controller, typically before each kvm_run event. As a
+ * result modification of the guest registers needs to take place
+ * after they have been restored in the hyp.S trampoline code.
+ */
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *dbg)
 {
@@ -317,8 +329,8 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_=
vcpu *vcpu,
=20
 	/* Single Step */
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
-		kvm_info("SS requested, not yet implemented\n");
-		return -EINVAL;
+		kvm_info("SS requested\n");
+		route_el2 =3D true;
 	}
=20
 	/* Software Break Points */
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-of=
fsets.c
index 8da1043..78e5ae1 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -121,6 +121,7 @@ int main(void)
   DEFINE(VCPU_FAR_EL2,		offsetof(struct kvm_vcpu, arch.fault.far_el2))=
;
   DEFINE(VCPU_HPFAR_EL2,	offsetof(struct kvm_vcpu, arch.fault.hpfar_el=
2));
   DEFINE(VCPU_DEBUG_FLAGS,	offsetof(struct kvm_vcpu, arch.debug_flags)=
);
+  DEFINE(GUEST_DEBUG,		offsetof(struct kvm_vcpu, guest_debug));
   DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
   DEFINE(VCPU_MDCR_EL2,	offsetof(struct kvm_vcpu, arch.mdcr_el2));
   DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.=
c
index 28dc92b..6def054 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -91,6 +91,25 @@ static int kvm_handle_bkpt(struct kvm_vcpu *vcpu, st=
ruct kvm_run *run)
 	return 0;
 }
=20
+/**
+ * kvm_handle_ss - handle single step exceptions
+ *
+ * @vcpu:	the vcpu pointer
+ *
+ * See: ARM ARM D2.12 for the details. While the host is routing debug
+ * exceptions to it's handlers we have to suppress the ability of the
+ * guest to trigger exceptions.
+ */
+static int kvm_handle_ss(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	WARN_ON(!(vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP));
+
+	run->exit_reason =3D KVM_EXIT_DEBUG;
+	run->debug.arch.exit_type =3D KVM_DEBUG_EXIT_SINGLE_STEP;
+	run->debug.arch.address =3D *vcpu_pc(vcpu);
+	return 0;
+}
+
 static exit_handle_fn arm_exit_handlers[] =3D {
 	[ESR_EL2_EC_WFI]	=3D kvm_handle_wfx,
 	[ESR_EL2_EC_CP15_32]	=3D kvm_handle_cp15_32,
@@ -105,6 +124,7 @@ static exit_handle_fn arm_exit_handlers[] =3D {
 	[ESR_EL2_EC_SYS64]	=3D kvm_handle_sys_reg,
 	[ESR_EL2_EC_IABT]	=3D kvm_handle_guest_abort,
 	[ESR_EL2_EC_DABT]	=3D kvm_handle_guest_abort,
+	[ESR_EL2_EC_SOFTSTP]    =3D kvm_handle_ss,
 	[ESR_EL2_EC_BKPT32]	=3D kvm_handle_bkpt,
 	[ESR_EL2_EC_BRK64]	=3D kvm_handle_bkpt,
 };
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 3c733ea..c0bc218 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -16,6 +16,7 @@
  */
=20
 #include <linux/linkage.h>
+#include <linux/kvm.h>
=20
 #include <asm/assembler.h>
 #include <asm/memory.h>
@@ -168,6 +169,31 @@
 	// x19-x29, lr, sp*, elr*, spsr*
 	restore_common_regs
=20
+	// After restoring the guest registers but before we return to the gu=
est
+	// we may want to make some final tweaks to support guest debugging.
+	ldr	x3, [x0, #GUEST_DEBUG]
+	tbz	x3, #KVM_GUESTDBG_ENABLE_SHIFT, 2f	// No guest debug
+
+	// x0 - preserved as VCPU ptr
+	// x1 - spsr
+	// x2 - mdscr
+	mrs	x1, spsr_el2
+	mrs 	x2, mdscr_el1
+
+	// See ARM ARM D2.12.3 The software step state machine
+	// If we are doing Single Step - set MDSCR_EL1.SS and PSTATE.SS
+	orr	x1, x1, #DBG_SPSR_SS
+	orr	x2, x2, #DBG_MDSCR_SS
+	tbnz	x3, #KVM_GUESTDBG_SINGLESTEP_SHIFT, 1f
+	// If we are not doing Single Step we want to prevent the guest doing=
 so
+	// as otherwise we will have to deal with the re-routed exceptions as=
 we
+	// are doing other guest debug related things
+	eor	x1, x1, #DBG_SPSR_SS
+	eor	x2, x2, #DBG_MDSCR_SS
+1:
+	msr	spsr_el2, x1
+	msr	mdscr_el1, x2
+2:
 	// Last bits of the 64bit state
 	pop	x2, x3
 	pop	x0, x1
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 523f476..347e5b0 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -7,6 +7,8 @@
  * Note: you must update KVM_API_VERSION if you change this interface.
  */
=20
+#ifndef __ASSEMBLY__
+
 #include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/ioctl.h>
@@ -515,11 +517,6 @@ struct kvm_s390_irq {
 	} u;
 };
=20
-/* for KVM_SET_GUEST_DEBUG */
-
-#define KVM_GUESTDBG_ENABLE		0x00000001
-#define KVM_GUESTDBG_SINGLESTEP		0x00000002
-
 struct kvm_guest_debug {
 	__u32 control;
 	__u32 pad;
@@ -1189,4 +1186,15 @@ struct kvm_assigned_msix_entry {
 	__u16 padding[3];
 };
=20
+#endif /* __ASSEMBLY__ */
+
+/* for KVM_SET_GUEST_DEBUG */
+
+#define KVM_GUESTDBG_ENABLE_SHIFT	0
+#define KVM_GUESTDBG_ENABLE		(1 << KVM_GUESTDBG_ENABLE_SHIFT)
+#define KVM_GUESTDBG_SINGLESTEP_SHIFT	1
+#define KVM_GUESTDBG_SINGLESTEP	(1 << KVM_GUESTDBG_SINGLESTEP_SHIFT)
+
+
+
 #endif /* __LINUX_KVM_H */
--=20
2.1.3

