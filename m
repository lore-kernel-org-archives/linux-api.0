From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] kvm: drop unsupported capabilities, fix documentation
Date: Sun, 12 Oct 2014 11:34:00 +0300
Message-ID: <1413102816-9289-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

No kernel ever reported KVM_CAP_DEVICE_MSIX, KVM_CAP_DEVICE_MSI,
KVM_CAP_DEVICE_ASSIGNMENT, KVM_CAP_DEVICE_DEASSIGNMENT.

This makes the documentation wrong, and no application ever
written to use these capabilities has a chance to work correctly.
The only way to detect support is to try, and test errno for ENOTTY.
That's unfortunate, but we can't fix the past.

Document the actual semantics, and drop the definitions from
the exported header to make it easier for application
developers to note and fix the bug.

Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/uapi/linux/kvm.h          |  8 --------
 Documentation/virtual/kvm/api.txt | 40 ++++++++++++++++++++++++++++++++-------
 2 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index cf3a2ff..98d72f7 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -647,11 +647,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_MP_STATE 14
 #define KVM_CAP_COALESCED_MMIO 15
 #define KVM_CAP_SYNC_MMU 16  /* Changes to host mmap are reflected in guest */
-#define KVM_CAP_DEVICE_ASSIGNMENT 17
 #define KVM_CAP_IOMMU 18
-#ifdef __KVM_HAVE_MSI
-#define KVM_CAP_DEVICE_MSI 20
-#endif
 /* Bug in KVM_SET_USER_MEMORY_REGION fixed: */
 #define KVM_CAP_DESTROY_MEMORY_REGION_WORKS 21
 #ifdef __KVM_HAVE_USER_NMI
@@ -665,10 +661,6 @@ struct kvm_ppc_smmu_info {
 #endif
 #define KVM_CAP_IRQ_ROUTING 25
 #define KVM_CAP_IRQ_INJECT_STATUS 26
-#define KVM_CAP_DEVICE_DEASSIGNMENT 27
-#ifdef __KVM_HAVE_MSIX
-#define KVM_CAP_DEVICE_MSIX 28
-#endif
 #define KVM_CAP_ASSIGN_DEV_IRQ 29
 /* Another bug in KVM_SET_USER_MEMORY_REGION fixed: */
 #define KVM_CAP_JOIN_MEMORY_REGIONS_WORKS 30
diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index beae3fd..0fe195c 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -68,9 +68,12 @@ description:
 
   Capability: which KVM extension provides this ioctl.  Can be 'basic',
       which means that is will be provided by any kernel that supports
-      API version 12 (see section 4.1), or a KVM_CAP_xyz constant, which
+      API version 12 (see section 4.1), a KVM_CAP_xyz constant, which
       means availability needs to be checked with KVM_CHECK_EXTENSION
-      (see section 4.4).
+      (see section 4.4), or 'none' which means that while not all kernels
+      support this ioctl, there's no capability bit to check its
+      availability: for kernels that don't support the ioctl,
+      the ioctl returns -ENOTTY.
 
   Architectures: which instruction set architectures provide this ioctl.
       x86 includes both i386 and x86_64.
@@ -1257,7 +1260,7 @@ The flags bitmap is defined as:
 
 4.48 KVM_ASSIGN_PCI_DEVICE
 
-Capability: KVM_CAP_DEVICE_ASSIGNMENT
+Capability: none
 Architectures: x86 ia64
 Type: vm ioctl
 Parameters: struct kvm_assigned_pci_dev (in)
@@ -1298,10 +1301,16 @@ Only PCI header type 0 devices with PCI BAR resources are supported by
 device assignment.  The user requesting this ioctl must have read/write
 access to the PCI sysfs resource files associated with the device.
 
+Errors:
+  ENOTTY: kernel does not support this ioctl
+
+  Other error conditions may be defined by individual device types or
+  have their standard meanings.
+
 
 4.49 KVM_DEASSIGN_PCI_DEVICE
 
-Capability: KVM_CAP_DEVICE_DEASSIGNMENT
+Capability: none
 Architectures: x86 ia64
 Type: vm ioctl
 Parameters: struct kvm_assigned_pci_dev (in)
@@ -1309,9 +1318,14 @@ Returns: 0 on success, -1 on error
 
 Ends PCI device assignment, releasing all associated resources.
 
-See KVM_CAP_DEVICE_ASSIGNMENT for the data structure. Only assigned_dev_id is
+See KVM_ASSIGN_PCI_DEVICE for the data structure. Only assigned_dev_id is
 used in kvm_assigned_pci_dev to identify the device.
 
+Errors:
+  ENOTTY: kernel does not support this ioctl
+
+  Other error conditions may be defined by individual device types or
+  have their standard meanings.
 
 4.50 KVM_ASSIGN_DEV_IRQ
 
@@ -1346,6 +1360,12 @@ The following flags are defined:
 It is not valid to specify multiple types per host or guest IRQ. However, the
 IRQ type of host and guest can differ or can even be null.
 
+Errors:
+  ENOTTY: kernel does not support this ioctl
+
+  Other error conditions may be defined by individual device types or
+  have their standard meanings.
+
 
 4.51 KVM_DEASSIGN_DEV_IRQ
 
@@ -1423,7 +1443,7 @@ struct kvm_irq_routing_s390_adapter {
 
 4.53 KVM_ASSIGN_SET_MSIX_NR
 
-Capability: KVM_CAP_DEVICE_MSIX
+Capability: none
 Architectures: x86 ia64
 Type: vm ioctl
 Parameters: struct kvm_assigned_msix_nr (in)
@@ -1445,7 +1465,7 @@ struct kvm_assigned_msix_nr {
 
 4.54 KVM_ASSIGN_SET_MSIX_ENTRY
 
-Capability: KVM_CAP_DEVICE_MSIX
+Capability: none
 Architectures: x86 ia64
 Type: vm ioctl
 Parameters: struct kvm_assigned_msix_entry (in)
@@ -1461,6 +1481,12 @@ struct kvm_assigned_msix_entry {
 	__u16 padding[3];
 };
 
+Errors:
+  ENOTTY: kernel does not support this ioctl
+
+  Other error conditions may be defined by individual device types or
+  have their standard meanings.
+
 
 4.55 KVM_SET_TSC_KHZ
 
-- 
MST
