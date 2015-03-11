From: James Hogan <james.hogan-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 15/20] MIPS: KVM: Wire up FPU capability
Date: Wed, 11 Mar 2015 14:44:51 +0000
Message-ID: <1426085096-12932-16-git-send-email-james.hogan@imgtec.com>
References: <1426085096-12932-1-git-send-email-james.hogan@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426085096-12932-1-git-send-email-james.hogan-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org
Cc: James Hogan <james.hogan-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Now that the code is in place for KVM to support FPU in MIPS KVM guests,
wire up the new KVM_CAP_MIPS_FPU capability.

For backwards compatibility, the capability must be explicitly enabled
in order to detect or make use of the FPU from the guest.

Signed-off-by: James Hogan <james.hogan-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Cc: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
Cc: Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 Documentation/virtual/kvm/api.txt | 13 +++++++++++++
 arch/mips/kvm/mips.c              | 37 +++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  1 +
 3 files changed, 51 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 8ba55b9c903e..44623688d566 100644
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
index 5e41afe15ae8..6cdb2a1cd8ec 100644
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
+	if (cap->flags)
+		return -EINVAL;
+	if (cap->args[0])
+		return -EINVAL;
+
+	switch (cap->cap) {
+	case KVM_CAP_MIPS_FPU:
+		if (!cpu_has_fpu)
+			return -EINVAL;
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
index 805570650062..98f6e5c653ff 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -760,6 +760,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_PPC_ENABLE_HCALL 104
 #define KVM_CAP_CHECK_EXTENSION_VM 105
 #define KVM_CAP_S390_USER_SIGP 106
+#define KVM_CAP_MIPS_FPU 107
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.0.5
