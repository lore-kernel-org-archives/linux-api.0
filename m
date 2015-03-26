From: James Hogan <james.hogan-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 19/20] MIPS: KVM: Expose MSA registers
Date: Thu, 26 Mar 2015 16:08:32 +0000
Message-ID: <1427386113-30515-3-git-send-email-james.hogan@imgtec.com>
References: <1427386113-30515-1-git-send-email-james.hogan@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427386113-30515-1-git-send-email-james.hogan-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org
Cc: James Hogan <james.hogan-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Paul Burton <paul.burton-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add KVM register numbers for the MIPS SIMD Architecture (MSA) registers,
and implement access to them with the KVM_GET_ONE_REG / KVM_SET_ONE_REG
ioctls when the MSA capability is enabled (exposed in a later patch) and
present in the guest according to its Config3.MSAP bit.

The MSA vector registers use the same register numbers as the FPU
registers except with a different size (128bits). Since MSA depends on
Status.FR=1, these registers are inaccessible when Status.FR=0. These
registers are returned as a single native endian 128bit value, rather
than least significant half first with each 64-bit half native endian as
the kernel uses internally.

Signed-off-by: James Hogan <james.hogan-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Cc: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Paul Burton <paul.burton-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Cc: Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
Cc: Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
Changes in v2:
- Add missing MSA vector and control register id bit patterns to API
  documentation.
---
 Documentation/virtual/kvm/api.txt | 12 +++++++-
 arch/mips/include/uapi/asm/kvm.h  | 12 ++++++--
 arch/mips/kvm/mips.c              | 65 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 86 insertions(+), 3 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index c95134160843..e50cbb56272b 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1981,8 +1981,11 @@ registers, find a list below:
   MIPS  | KVM_REG_MIPS_COUNT_HZ         | 64
   MIPS  | KVM_REG_MIPS_FPR_32(0..31)    | 32
   MIPS  | KVM_REG_MIPS_FPR_64(0..31)    | 64
+  MIPS  | KVM_REG_MIPS_VEC_128(0..31)   | 128
   MIPS  | KVM_REG_MIPS_FCR_IR           | 32
   MIPS  | KVM_REG_MIPS_FCR_CSR          | 32
+  MIPS  | KVM_REG_MIPS_MSA_IR           | 32
+  MIPS  | KVM_REG_MIPS_MSA_CSR          | 32
 
 ARM registers are mapped using the lower 32 bits.  The upper 16 of that
 is the register group type, or coprocessor number:
@@ -2040,14 +2043,21 @@ MIPS FPU registers (see KVM_REG_MIPS_FPR_{32,64}() above) have the following
 id bit patterns depending on the size of the register being accessed. They are
 always accessed according to the current guest FPU mode (Status.FR and
 Config5.FRE), i.e. as the guest would see them, and they become unpredictable
-if the guest FPU mode is changed:
+if the guest FPU mode is changed. MIPS SIMD Architecture (MSA) vector
+registers (see KVM_REG_MIPS_VEC_128() above) have similar patterns as they
+overlap the FPU registers:
   0x7020 0000 0003 00 <0:3> <reg:5> (32-bit FPU registers)
   0x7030 0000 0003 00 <0:3> <reg:5> (64-bit FPU registers)
+  0x7040 0000 0003 00 <0:3> <reg:5> (128-bit MSA vector registers)
 
 MIPS FPU control registers (see KVM_REG_MIPS_FCR_{IR,CSR} above) have the
 following id bit patterns:
   0x7020 0000 0003 01 <0:3> <reg:5>
 
+MIPS MSA control registers (see KVM_REG_MIPS_MSA_{IR,CSR} above) have the
+following id bit patterns:
+  0x7020 0000 0003 02 <0:3> <reg:5>
+
 
 4.69 KVM_GET_ONE_REG
 
diff --git a/arch/mips/include/uapi/asm/kvm.h b/arch/mips/include/uapi/asm/kvm.h
index 401e6a6f8bb8..6985eb59b085 100644
--- a/arch/mips/include/uapi/asm/kvm.h
+++ b/arch/mips/include/uapi/asm/kvm.h
@@ -58,7 +58,7 @@ struct kvm_fpu {
  *
  * Register set = 2: KVM specific registers (see definitions below).
  *
- * Register set = 3: FPU registers (see definitions below).
+ * Register set = 3: FPU / MSA registers (see definitions below).
  *
  * Other sets registers may be added in the future.  Each set would
  * have its own identifier in bits[31..16].
@@ -148,7 +148,7 @@ struct kvm_fpu {
 
 
 /*
- * KVM_REG_MIPS_FPU - Floating Point registers.
+ * KVM_REG_MIPS_FPU - Floating Point and MIPS SIMD Architecture (MSA) registers.
  *
  *  bits[15..8]  - Register subset (see definitions below).
  *  bits[7..5]   - Must be zero.
@@ -157,12 +157,14 @@ struct kvm_fpu {
 
 #define KVM_REG_MIPS_FPR	(KVM_REG_MIPS_FPU | 0x0000000000000000ULL)
 #define KVM_REG_MIPS_FCR	(KVM_REG_MIPS_FPU | 0x0000000000000100ULL)
+#define KVM_REG_MIPS_MSACR	(KVM_REG_MIPS_FPU | 0x0000000000000200ULL)
 
 /*
  * KVM_REG_MIPS_FPR - Floating point / Vector registers.
  */
 #define KVM_REG_MIPS_FPR_32(n)	(KVM_REG_MIPS_FPR | KVM_REG_SIZE_U32  | (n))
 #define KVM_REG_MIPS_FPR_64(n)	(KVM_REG_MIPS_FPR | KVM_REG_SIZE_U64  | (n))
+#define KVM_REG_MIPS_VEC_128(n)	(KVM_REG_MIPS_FPR | KVM_REG_SIZE_U128 | (n))
 
 /*
  * KVM_REG_MIPS_FCR - Floating point control registers.
@@ -170,6 +172,12 @@ struct kvm_fpu {
 #define KVM_REG_MIPS_FCR_IR	(KVM_REG_MIPS_FCR | KVM_REG_SIZE_U32 |  0)
 #define KVM_REG_MIPS_FCR_CSR	(KVM_REG_MIPS_FCR | KVM_REG_SIZE_U32 | 31)
 
+/*
+ * KVM_REG_MIPS_MSACR - MIPS SIMD Architecture (MSA) control registers.
+ */
+#define KVM_REG_MIPS_MSA_IR	 (KVM_REG_MIPS_MSACR | KVM_REG_SIZE_U32 |  0)
+#define KVM_REG_MIPS_MSA_CSR	 (KVM_REG_MIPS_MSACR | KVM_REG_SIZE_U32 |  1)
+
 
 /*
  * KVM MIPS specific structures and definitions
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index e02c7e5a12ff..35d3146895f1 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -531,6 +531,7 @@ static int kvm_mips_get_reg(struct kvm_vcpu *vcpu,
 	struct mips_fpu_struct *fpu = &vcpu->arch.fpu;
 	int ret;
 	s64 v;
+	s64 vs[2];
 	unsigned int idx;
 
 	switch (reg->id) {
@@ -579,6 +580,35 @@ static int kvm_mips_get_reg(struct kvm_vcpu *vcpu,
 		v = fpu->fcr31;
 		break;
 
+	/* MIPS SIMD Architecture (MSA) registers */
+	case KVM_REG_MIPS_VEC_128(0) ... KVM_REG_MIPS_VEC_128(31):
+		if (!kvm_mips_guest_has_msa(&vcpu->arch))
+			return -EINVAL;
+		/* Can't access MSA registers in FR=0 mode */
+		if (!(kvm_read_c0_guest_status(cop0) & ST0_FR))
+			return -EINVAL;
+		idx = reg->id - KVM_REG_MIPS_VEC_128(0);
+#ifdef CONFIG_CPU_LITTLE_ENDIAN
+		/* least significant byte first */
+		vs[0] = get_fpr64(&fpu->fpr[idx], 0);
+		vs[1] = get_fpr64(&fpu->fpr[idx], 1);
+#else
+		/* most significant byte first */
+		vs[0] = get_fpr64(&fpu->fpr[idx], 1);
+		vs[1] = get_fpr64(&fpu->fpr[idx], 0);
+#endif
+		break;
+	case KVM_REG_MIPS_MSA_IR:
+		if (!kvm_mips_guest_has_msa(&vcpu->arch))
+			return -EINVAL;
+		v = boot_cpu_data.msa_id;
+		break;
+	case KVM_REG_MIPS_MSA_CSR:
+		if (!kvm_mips_guest_has_msa(&vcpu->arch))
+			return -EINVAL;
+		v = fpu->msacsr;
+		break;
+
 	/* Co-processor 0 registers */
 	case KVM_REG_MIPS_CP0_INDEX:
 		v = (long)kvm_read_c0_guest_index(cop0);
@@ -664,6 +694,10 @@ static int kvm_mips_get_reg(struct kvm_vcpu *vcpu,
 		u32 v32 = (u32)v;
 
 		return put_user(v32, uaddr32);
+	} else if ((reg->id & KVM_REG_SIZE_MASK) == KVM_REG_SIZE_U128) {
+		void __user *uaddr = (void __user *)(long)reg->addr;
+
+		return copy_to_user(uaddr, vs, 16);
 	} else {
 		return -EINVAL;
 	}
@@ -675,6 +709,7 @@ static int kvm_mips_set_reg(struct kvm_vcpu *vcpu,
 	struct mips_coproc *cop0 = vcpu->arch.cop0;
 	struct mips_fpu_struct *fpu = &vcpu->arch.fpu;
 	s64 v;
+	s64 vs[2];
 	unsigned int idx;
 
 	if ((reg->id & KVM_REG_SIZE_MASK) == KVM_REG_SIZE_U64) {
@@ -689,6 +724,10 @@ static int kvm_mips_set_reg(struct kvm_vcpu *vcpu,
 		if (get_user(v32, uaddr32) != 0)
 			return -EFAULT;
 		v = (s64)v32;
+	} else if ((reg->id & KVM_REG_SIZE_MASK) == KVM_REG_SIZE_U128) {
+		void __user *uaddr = (void __user *)(long)reg->addr;
+
+		return copy_from_user(vs, uaddr, 16);
 	} else {
 		return -EINVAL;
 	}
@@ -742,6 +781,32 @@ static int kvm_mips_set_reg(struct kvm_vcpu *vcpu,
 		fpu->fcr31 = v;
 		break;
 
+	/* MIPS SIMD Architecture (MSA) registers */
+	case KVM_REG_MIPS_VEC_128(0) ... KVM_REG_MIPS_VEC_128(31):
+		if (!kvm_mips_guest_has_msa(&vcpu->arch))
+			return -EINVAL;
+		idx = reg->id - KVM_REG_MIPS_VEC_128(0);
+#ifdef CONFIG_CPU_LITTLE_ENDIAN
+		/* least significant byte first */
+		set_fpr64(&fpu->fpr[idx], 0, vs[0]);
+		set_fpr64(&fpu->fpr[idx], 1, vs[1]);
+#else
+		/* most significant byte first */
+		set_fpr64(&fpu->fpr[idx], 1, vs[0]);
+		set_fpr64(&fpu->fpr[idx], 0, vs[1]);
+#endif
+		break;
+	case KVM_REG_MIPS_MSA_IR:
+		if (!kvm_mips_guest_has_msa(&vcpu->arch))
+			return -EINVAL;
+		/* Read-only */
+		break;
+	case KVM_REG_MIPS_MSA_CSR:
+		if (!kvm_mips_guest_has_msa(&vcpu->arch))
+			return -EINVAL;
+		fpu->msacsr = v;
+		break;
+
 	/* Co-processor 0 registers */
 	case KVM_REG_MIPS_CP0_INDEX:
 		kvm_write_c0_guest_index(cop0, v);
-- 
2.0.5
