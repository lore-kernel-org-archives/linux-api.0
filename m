From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v7 01/11] KVM: add comments for kvm_debug_exit_arch struct
Date: Wed,  1 Jul 2015 19:28:53 +0100
Message-ID: <1435775343-20034-2-git-send-email-alex.bennee@linaro.org>
References: <1435775343-20034-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1435775343-20034-1-git-send-email-alex.bennee@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org
Cc: jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Bring into line with the comments for the other structures and their
KVM_EXIT_* cases. Also update api.txt to reflect use in kvm_run
documentation.

Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

---

v2
  - add comments for other exit types
v3
  - s/commentary/comments/
  - add rb tags
  - update api.txt kvm_run to include KVM_EXIT_DEBUG desc
v4
  - sp fixes
  - add a-b
---
 Documentation/virtual/kvm/api.txt | 4 +++-
 include/uapi/linux/kvm.h          | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/=
kvm/api.txt
index 9fa2bf8..c34c32d 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -3070,11 +3070,13 @@ data_offset describes where the data is located=
 (KVM_EXIT_IO_OUT) or
 where kvm expects application code to place the data for the next
 KVM_RUN invocation (KVM_EXIT_IO_IN).  Data format is a packed array.
=20
+		/* KVM_EXIT_DEBUG */
 		struct {
 			struct kvm_debug_exit_arch arch;
 		} debug;
=20
-Unused.
+If the exit_reason is KVM_EXIT_DEBUG, then a vcpu is processing a debu=
g event
+for which architecture specific information is returned.
=20
 		/* KVM_EXIT_MMIO */
 		struct {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4b60056..70ac641 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -237,6 +237,7 @@ struct kvm_run {
 			__u32 count;
 			__u64 data_offset; /* relative to kvm_run start */
 		} io;
+		/* KVM_EXIT_DEBUG */
 		struct {
 			struct kvm_debug_exit_arch arch;
 		} debug;
@@ -285,6 +286,7 @@ struct kvm_run {
 			__u32 data;
 			__u8  is_write;
 		} dcr;
+		/* KVM_EXIT_INTERNAL_ERROR */
 		struct {
 			__u32 suberror;
 			/* Available with KVM_CAP_INTERNAL_ERROR_DATA: */
@@ -295,6 +297,7 @@ struct kvm_run {
 		struct {
 			__u64 gprs[32];
 		} osi;
+		/* KVM_EXIT_PAPR_HCALL */
 		struct {
 			__u64 nr;
 			__u64 ret;
--=20
2.4.5

