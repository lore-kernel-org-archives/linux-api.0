From: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 15/20] MIPS: KVM: Wire up FPU capability
Date: Thu, 26 Mar 2015 16:08:31 +0000
Message-ID: <1427386113-30515-2-git-send-email-james.hogan@imgtec.com>
References: <1427386113-30515-1-git-send-email-james.hogan@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1427386113-30515-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-doc-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-mips@linux-mips.org
Cc: James Hogan <james.hogan@imgtec.com>, Ralf Baechle <ralf@linux-mips.org>, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Now that the code is in place for KVM to support FPU in MIPS KVM guests,
wire up the new KVM_CAP_MIPS_FPU capability.

For backwards compatibility, the capability must be explicitly enabled
in order to detect or make use of the FPU from the guest.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-mips@linux-mips.org
Cc: kvm@vger.kernel.org
Cc: linux-api@vger.kernel.org
Cc: linux-doc@vger.kernel.org
---
Changes in v2:
- Rebased on KVM queue (KVM_CAP_MIPS_FPU increased to 108 after
  KVM_CAP_S390_VECTOR_REGISTERS took 107).
- Just call kvm_vm_ioctl_check_extension() from
  kvm_vcpu_ioctl_enable_cap() rather than duplicating the extension
  presence condition (Paolo).
---
 Documentation/virtual/kvm/api.txt | 13 +++++++++++++
 arch/mips/kvm/mips.c              | 37 +++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  1 +
 3 files changed, 51 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index c666c375688e..c95134160843 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -3208,6 +3208,19 @@ Parameters: none
 This capability enables the in-kernel irqchip for s390. Please refer to
 "4.24 KVM_CREATE_IRQCHIP" for details.
 
+6.9 KVM_CAP_MIPS_FPU
+
+Architectures: mips
+Target: vcpu
+Parameters: args[0] is reserved for future use (should be 0).
+
+This capability allows the use of the host Floating Point Unit by the guest. It
+allows the Config1.FP bit to be set to enable the FPU in the guest. Once this is
+done the KVM_REG_MIPS_FPR_* and KVM_REG_MIPS_FCR_* registers can be accessed
+(depending on the current guest FPU register mode), and the Status.FR,
+Config5.FRE bits are accessible via the KVM API and also from the guest,
+depending on them being supported by the FPU.
+
 7. Capabilities that can be enabled on VMs
 ------------------------------------------
 
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 5e41afe15ae8..7f86cb73d05d 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -797,6 +797,30 @@ static int kvm_mips_set_reg(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
+				     struct kvm_enable_cap *cap)
+{
+	int r = 0;
+
+	if (!kvm_vm_ioctl_check_extension(vcpu->kvm, cap->cap))
+		return -EINVAL;
+	if (cap->flags)
+		return -EINVAL;
+	if (cap->args[0])
+		return -EINVAL;
+
+	switch (cap->cap) {
+	case KVM_CAP_MIPS_FPU:
+		vcpu->arch.fpu_enabled = true;
+		break;
+	default:
+		r = -EINVAL;
+		break;
+	}
+
+	return r;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp, unsigned int ioctl,
 			 unsigned long arg)
 {
@@ -854,6 +878,15 @@ long kvm_arch_vcpu_ioctl(struct file *filp, unsigned int ioctl,
 			r = kvm_vcpu_ioctl_interrupt(vcpu, &irq);
 			break;
 		}
+	case KVM_ENABLE_CAP: {
+		struct kvm_enable_cap cap;
+
+		r = -EFAULT;
+		if (copy_from_user(&cap, argp, sizeof(cap)))
+			goto out;
+		r = kvm_vcpu_ioctl_enable_cap(vcpu, &cap);
+		break;
+	}
 	default:
 		r = -ENOIOCTLCMD;
 	}
@@ -962,11 +995,15 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 
 	switch (ext) {
 	case KVM_CAP_ONE_REG:
+	case KVM_CAP_ENABLE_CAP:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
 		r = KVM_COALESCED_MMIO_PAGE_OFFSET;
 		break;
+	case KVM_CAP_MIPS_FPU:
+		r = !!cpu_has_fpu;
+		break;
 	default:
 		r = 0;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 82634a492fe0..0670cf4337d6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -761,6 +761,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_CHECK_EXTENSION_VM 105
 #define KVM_CAP_S390_USER_SIGP 106
 #define KVM_CAP_S390_VECTOR_REGISTERS 107
+#define KVM_CAP_MIPS_FPU 108
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.0.5

