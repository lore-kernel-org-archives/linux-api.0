Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D99541E67
	for <linux-api@vger.kernel.org>; Thu, 15 Oct 2026 14:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075944; cv=none; b=kulug6C3xLuBotskOJ5T1InB2fsJnYzI/nInijYfaVjHCBmqakC+pYWjaQiunDerB90hN6e3gcOVMlqX56xFszoi2uyxxNKSpeDvd6w0bkpGjn1ydXyk0FleUz4uk2KO/TbB7Wg/nnbL1CNmhx8ZNLs6+fgtBqkXFBHgv4OO3FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075944; c=relaxed/simple;
	bh=IIYDSkmK5d46cA9S1uvpN3XtFbPTp7y5uXpeN3p4TGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYiIazuY0Nwf2Cpc0SPZW17vm3hlWxhSqVUGioD7/ovH7nINbDQ/AdqoQCm8lLQrJppY0lH5jDxHxDjlRn3b2bRRRI6K5Sae1DHHS9P54mPPmlMBlqkI6blqjJPMcs+ZckYSsHXTM8EcdBe4azz0mmWGLhGExjQcv5QWq9/FoQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=EaeN+kZS; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="EaeN+kZS"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c2e4df2e26fso737427666b.2
        for <linux-api@vger.kernel.org>; Thu, 15 Oct 2026 07:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1792075939; x=1792680739; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iVqDzpfDA3WTL/rRjIXG9OKMA9xQQIb+x8amT3YTw4A=;
        b=EaeN+kZS6omdHrxaalqYaEqcxekdeP4YREC0/yF6GugFYCox90YlEwvJ+AA67ejCWX
         ZiDi3BfaBWrO1VirfxUHilEQ84N9XlwUyYogyeDS3K0+K1kv9nVJvtt6Z7N5TTZslNsQ
         DaMZj/g1r0EJB136z7Azh21/qX31fX6GRz8GLW9oc9oz4wPw7lbAN4N/rru4xdw3XpH2
         FNxHTUHw5d7/uHqJtyFPXe3Z7/GKBqv9CLPpUzQBMzF07P2TeFuA724t9x8ZbHiOJUwr
         vJcOOoUrqs0zj077FIhJ2cn9drtAKUQsBaXicSo0EIPHThPHSncF/uxoOhmUQ7fhb4/g
         Ax7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075939; x=1792680739;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iVqDzpfDA3WTL/rRjIXG9OKMA9xQQIb+x8amT3YTw4A=;
        b=BdzHkSo6b+0akoYsPpuZrU2E3LqUeFswT39aMBYAN4AzkFEGC0twDto1bROO6oV0Nh
         yx31pfju5pKhnxo+0haTXBzZKoUfX38n7nsrxFgXoU97rVsqKK99k2bYhqJaHW8qion7
         i9WWi8bIg8Vxx75wfQw/sHepby+n9jn8+lh87P24LmI5Vs8q/zDieus+b12dVNeSMSOV
         gAC+Yo7ZbQ7SJ7teKMtQXm+vNf5sJ4AZE2Y4/b3kSNEwqD3wvU/uoajnmYXN5CV4Sh+o
         n2VXe7S1rFcnePrsboRI1y41pD3tcmL4WprKJuL+OcNBptxNoL8Zww21u4gcQQ9CxnaM
         pQ/g==
X-Forwarded-Encrypted: i=1; AKwUvBwT0WJImBtcPQdWvldUqjSd1FA9jv45pqt4XwPu+7M+gfHu6OvXLjvyfiSRzuN3OCm6Ur6CJPdJlzM=@vger.kernel.org
X-Gm-Message-State: AFq9FYIlHW43hYxaFMvP+CbMKWE84FZGqa8x+W9+345gQ3jhUtA0BWzr
	bgaWmk/WIWc92bVMClMPhbJckSQBBHA2LOGfiz99aSuNzl8oNd6XYxD1QZngp4KLTkw=
X-Gm-Gg: AYBFou3GwnnNbKglYb+XJ4AaNd0xqxPRMpShKHlqHBo7ZLrPvW45En5ddvzMpfjvuyn
	Ub64KFE4LpaVOqYkiXYgb/51ZgnuafAGotTsX1xndK1tGDzNRlguR35ERWzAs6Tl/z56bQuyYNO
	dNXOn+4VZNj23JH33PdPQs7KqOE7lna1Se4n0M+7buB6j+HXtHL2Enr2ni0exzdOBQADgPcqVFr
	WqgItH5FZi5Ef3Sv7gLvJ1lYDQ6bRazO1KUylP9nOp2Jx1itYSQuT5WiaBpU82cgNl0mFsziIgD
	0RDOSu8f2ghQZO1UJN9OrF+B2M6d4dH+qvj5Ciia6XCLHXWiOOjHskKKiABpNRQ+Fy74Xia+FW2
	kqRry9W6G/0nwY5lgjwOm/swzxZelVS4SpXrFaYvyVR8MfMricCzx4eIBWdwK5W8KpQxa4jvj1t
	lfwvRTfkHn5u/NZ9cNWqW7FEB5E3jGHKjWbJxInZWgrTuv6rglaA3nhoHtIz86FC6jNUAp4r1eG
	fhFuhZcgg==
X-Received: by 2002:a17:906:c10b:b0:c2e:4742:491c with SMTP id a640c23a62f3a-c31a9f887cbmr1836174666b.31.1792075939352;
        Thu, 15 Oct 2026 07:52:19 -0700 (PDT)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3f41b78f77sm95954666b.54.2026.10.15.07.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:52:18 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: linux-coco@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	jgg@ziepe.ca,
	david.quigley@intel.com,
	lukas@wunner.de,
	ksinyuk@kernel.org,
	rodrigo.vivi@intel.com,
	cedric.xing@intel.com,
	sameo@meta.com,
	drdeeglaze@gmail.com,
	James.Bottomley@HansenPartnership.com,
	aik@amd.com,
	jpiotrowski@nvidia.com,
	qinkun@google.com,
	pgonda@google.com,
	jic23@kernel.org,
	alistair.francis@wdc.com,
	ankita@nvidia.com,
	suzuki.poulose@arm.com,
	kas@kernel.org,
	rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com,
	dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com,
	peter.fang@intel.com
Subject: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Date: Thu, 15 Oct 2026 16:50:53 +0200
Message-ID: <20261015145053.3664509-21-jiri@resnulli.us>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261015145053.3664509-1-jiri@resnulli.us>
References: <20261015145053.3664509-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

Connect the attestation family to the native TDX service. Expose
TDREPORT, Quote, MRTD and RTMR operations while preserving the existing
native interfaces.

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 Documentation/driver-api/attestation.rst |  16 ++
 drivers/attestation/Kconfig              |  14 ++
 drivers/attestation/Makefile             |   5 +
 drivers/attestation/providers/tdx.c      | 277 +++++++++++++++++++++++
 4 files changed, 312 insertions(+)
 create mode 100644 drivers/attestation/providers/tdx.c

diff --git a/Documentation/driver-api/attestation.rst b/Documentation/driver-api/attestation.rst
index 5ce121ded05f..f253c848e856 100644
--- a/Documentation/driver-api/attestation.rst
+++ b/Documentation/driver-api/attestation.rst
@@ -46,3 +46,19 @@ CTLV first drains userspace operations.  The base ``pre_fini`` callback then
 withdraws the instance from the kernel registry while provider state and CTLV
 event emission remain available.  CTLV stops events only after that callback
 returns; provider and base ``fini`` callbacks may then release native storage.
+
+TDX provider
+============
+
+``CONFIG_ATTESTATION_TDX`` registers a ``ctlv-attestation-tdx`` instance for
+the native TDX guest service.  MRTD has stable MR ID 0 and is read-only.
+RTMR0 through RTMR3 have IDs 1 through 4 and are readable and extendable with
+SHA-384.
+
+``EVIDENCE_GET`` supports complete raw TDREPORT and Quote objects.  Both
+formats cryptographically bind all architectural TDX measurement registers,
+so successful replies carry the matching MR-journal boundary.  The provider
+exposes no verdict or device-security operation.
+
+The provider consumes only ``<linux/tdx-guest.h>``.  It does not call the TDX
+misc ioctl, configfs TSM-report, or TSM-MR sysfs frontends.
diff --git a/drivers/attestation/Kconfig b/drivers/attestation/Kconfig
index e2fb4b4205fe..139bcc710019 100644
--- a/drivers/attestation/Kconfig
+++ b/drivers/attestation/Kconfig
@@ -10,3 +10,17 @@ menuconfig ATTESTATION
 	  translate the common operations to their native service.
 
 	  If you are unsure, say N.
+
+if ATTESTATION
+
+config ATTESTATION_TDX
+	tristate "TDX attestation provider"
+	depends on TDX_GUEST_DRIVER
+	help
+	  Exposes TDREPORT, Quote, MRTD and RTMR operations through the common
+	  attestation CTLV family. The native TDX misc, TSM-report and TSM-MR
+	  interfaces remain available independently.
+
+	  If you are unsure, say N.
+
+endif # ATTESTATION
diff --git a/drivers/attestation/Makefile b/drivers/attestation/Makefile
index e520fee2e90d..d56df9adaa75 100644
--- a/drivers/attestation/Makefile
+++ b/drivers/attestation/Makefile
@@ -3,3 +3,8 @@ obj-$(CONFIG_ATTESTATION) += attestation.o
 
 attestation-y := core/core.o core/ctlv.o core/events.o core/mr.o \
 		 generated/ctlv_attestation_gen.o
+
+obj-$(CONFIG_ATTESTATION_TDX) += attestation-tdx.o
+
+attestation-tdx-y := providers/tdx.o \
+		     generated/ctlv_attestation_tdx_gen.o
diff --git a/drivers/attestation/providers/tdx.c b/drivers/attestation/providers/tdx.c
new file mode 100644
index 000000000000..9b41b985c783
--- /dev/null
+++ b/drivers/attestation/providers/tdx.c
@@ -0,0 +1,277 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <crypto/sha2.h>
+#include <linux/attestation.h>
+#include <linux/ctlv.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/tdx-guest.h>
+
+#include "../generated/ctlv_attestation_tdx_gen.h"
+
+struct attestation_tdx_init_info {
+	struct device *parent_dev;
+	const struct tdx_guest_ops *ops;
+};
+
+struct attestation_tdx {
+	struct device *parent_dev;
+	const struct tdx_guest_ops *ops;
+};
+
+static const enum hash_algo attestation_tdx_algorithms[] = {
+	HASH_ALGO_SHA384,
+};
+
+static const struct attestation_mr_props attestation_tdx_mrs[] = {
+	{
+		.id = 0,
+		.name = "mrtd",
+		.algorithms = attestation_tdx_algorithms,
+		.algorithms_count = ARRAY_SIZE(attestation_tdx_algorithms),
+		.readable = true,
+	},
+	{
+		.id = 1,
+		.name = "rtmr0",
+		.algorithms = attestation_tdx_algorithms,
+		.algorithms_count = ARRAY_SIZE(attestation_tdx_algorithms),
+		.has_register_index = true,
+		.register_index = 0,
+		.readable = true,
+		.extendable = true,
+	},
+	{
+		.id = 2,
+		.name = "rtmr1",
+		.algorithms = attestation_tdx_algorithms,
+		.algorithms_count = ARRAY_SIZE(attestation_tdx_algorithms),
+		.has_register_index = true,
+		.register_index = 1,
+		.readable = true,
+		.extendable = true,
+	},
+	{
+		.id = 3,
+		.name = "rtmr2",
+		.algorithms = attestation_tdx_algorithms,
+		.algorithms_count = ARRAY_SIZE(attestation_tdx_algorithms),
+		.has_register_index = true,
+		.register_index = 2,
+		.readable = true,
+		.extendable = true,
+	},
+	{
+		.id = 4,
+		.name = "rtmr3",
+		.algorithms = attestation_tdx_algorithms,
+		.algorithms_count = ARRAY_SIZE(attestation_tdx_algorithms),
+		.has_register_index = true,
+		.register_index = 3,
+		.readable = true,
+		.extendable = true,
+	},
+};
+
+static const struct attestation_evidence_supported_object
+attestation_tdx_evidence_objects[] = {
+	{
+		.format = "tdx-tdreport-1.0",
+		.max_length = TDX_GUEST_REPORT_LEN,
+		.binds_mrs = true,
+	},
+	{
+		.format = "tdx-quote-1.0",
+		.max_length = TDX_GUEST_QUOTE_MAX_LEN,
+		.binds_mrs = true,
+	},
+};
+
+static const struct attestation_evidence_caps attestation_tdx_evidence_caps = {
+	.min_challenge_length = TDX_GUEST_REPORTDATA_LEN,
+	.max_challenge_length = TDX_GUEST_REPORTDATA_LEN,
+	.max_total_output_length = TDX_GUEST_QUOTE_MAX_LEN,
+	.objects = attestation_tdx_evidence_objects,
+	.objects_count = ARRAY_SIZE(attestation_tdx_evidence_objects),
+};
+
+static int
+attestation_tdx_evidence_get(struct attestation *att,
+			     const struct attestation_evidence_request *request,
+			     struct attestation_evidence_result *result)
+{
+	const struct attestation_evidence_object_request *object;
+	struct attestation_tdx *tdx = ctlv_priv_child(att);
+	size_t length;
+	void *buffer;
+	int ret;
+
+	if (request->objects_count != 1)
+		return -EOPNOTSUPP;
+	object = &request->objects[0];
+	buffer = kvmalloc(object->supported_object->max_length, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+	if (object->supported_object == &attestation_tdx_evidence_objects[0])
+		ret = tdx->ops->report_get(tdx->parent_dev,
+			request->challenge,
+			request->challenge_length, buffer,
+			object->supported_object->max_length, &length);
+	else if (object->supported_object ==
+		 &attestation_tdx_evidence_objects[1])
+		ret = tdx->ops->quote_get(tdx->parent_dev,
+			request->challenge,
+			request->challenge_length, buffer,
+			object->supported_object->max_length, &length);
+	else
+		ret = -EOPNOTSUPP;
+	if (!ret)
+		ret = ctlv_blob_write(object->output, 0, buffer, length);
+	if (!ret)
+		result->object_lengths[0] = length;
+	kvfree(buffer);
+	return ret;
+}
+
+static int attestation_tdx_mr_read(struct attestation *att, unsigned int mr_id,
+				   struct attestation_digest_set *values)
+{
+	static const enum tdx_guest_mr native_mrs[] = {
+		TDX_GUEST_MR_MRTD,
+		TDX_GUEST_MR_RTMR0,
+		TDX_GUEST_MR_RTMR1,
+		TDX_GUEST_MR_RTMR2,
+		TDX_GUEST_MR_RTMR3,
+	};
+	struct attestation_tdx *tdx = ctlv_priv_child(att);
+
+	if (mr_id >= ARRAY_SIZE(native_mrs) ||
+	    values->values_count != 1 ||
+	    values->values[0].algorithm != HASH_ALGO_SHA384)
+		return -EINVAL;
+	return tdx->ops->mr_read(tdx->parent_dev, native_mrs[mr_id],
+		values->values[0].data);
+}
+
+static int
+attestation_tdx_mr_extend(struct attestation *att, unsigned int mr_id,
+			  const struct attestation_digest_set *values)
+{
+	struct attestation_tdx *tdx = ctlv_priv_child(att);
+
+	if (mr_id < 1 || mr_id > 4)
+		return -EOPNOTSUPP;
+	if (values->values_count != 1 ||
+	    values->values[0].algorithm != HASH_ALGO_SHA384)
+		return -EINVAL;
+	return tdx->ops->rtmr_extend(tdx->parent_dev, mr_id - 1,
+				     values->values[0].data);
+}
+
+static const struct attestation_provider attestation_tdx_provider = {
+	.evidence_get = attestation_tdx_evidence_get,
+	.mr_read = attestation_tdx_mr_read,
+	.mr_extend = attestation_tdx_mr_extend,
+	.evidence_caps = &attestation_tdx_evidence_caps,
+	.mrs = attestation_tdx_mrs,
+	.mrs_count = ARRAY_SIZE(attestation_tdx_mrs),
+};
+
+size_t ctlv_attestation_tdx_priv_size(void)
+{
+	return sizeof(struct attestation_tdx);
+}
+
+const void *ctlv_attestation_tdx_pre_init(const void *init_info)
+{
+	return &attestation_tdx_provider;
+}
+
+int ctlv_attestation_tdx_init(struct ctlv_device *ctlvdev,
+			      const void *init_info, void *priv)
+{
+	const struct attestation_tdx_init_info *info = init_info;
+	struct attestation_tdx *tdx = priv;
+
+	if (!info || !info->parent_dev || !info->ops)
+		return -EINVAL;
+	tdx->parent_dev = info->parent_dev;
+	tdx->ops = info->ops;
+	return 0;
+}
+
+void ctlv_attestation_tdx_fini(struct ctlv_device *ctlvdev, void *priv)
+{
+}
+
+int ctlv_attestation_tdx_op_pre(void *priv, struct ctlv_op_ctx *ctx)
+{
+	return ctlv_attestation_op_pre(ctlv_priv_parent(priv), ctx);
+}
+
+void ctlv_attestation_tdx_op_post(void *priv, struct ctlv_op_ctx *ctx)
+{
+	ctlv_attestation_op_post(ctlv_priv_parent(priv), ctx);
+}
+
+int ctlv_attestation_tdx_device_info_fill(void *priv,
+					  struct ctlv_op_ctx *ctx,
+					  const struct ctlv_cursor *request,
+					  struct ctlv_cursor *nest)
+{
+	struct attestation_tdx *tdx = priv;
+	const struct tdx_guest_info *info =
+		tdx->ops->info_get(tdx->parent_dev);
+	bool ok;
+
+	if (!info)
+		return -ENODEV;
+	ok = ctlv_attestation_tdx_info_mrconfigid_put(nest, info->mrconfigid,
+						      sizeof(info->mrconfigid));
+	ok &= ctlv_attestation_tdx_info_mrowner_put(nest, info->mrowner,
+						    sizeof(info->mrowner));
+	ok &= ctlv_attestation_tdx_info_mrownerconfig_put(nest,
+							   info->mrownerconfig,
+							   sizeof(info->mrownerconfig));
+	return ok ? 0 : -EMSGSIZE;
+}
+
+static void *attestation_tdx_add(struct device *parent_dev,
+				 const struct tdx_guest_ops *ops)
+{
+	struct attestation_tdx_init_info info = {
+		.parent_dev = parent_dev,
+		.ops = ops,
+	};
+
+	return ctlv_create(parent_dev, &ctlv_attestation_tdx_family,
+			   &info);
+}
+
+static void attestation_tdx_remove(void *client_priv)
+{
+	ctlv_destroy(client_priv);
+}
+
+static const struct tdx_guest_client attestation_tdx_client = {
+	.add = attestation_tdx_add,
+	.remove = attestation_tdx_remove,
+};
+
+static int __init attestation_tdx_init_module(void)
+{
+	return tdx_guest_client_register(&attestation_tdx_client);
+}
+
+static void __exit attestation_tdx_exit_module(void)
+{
+	tdx_guest_client_unregister(&attestation_tdx_client);
+}
+
+module_init(attestation_tdx_init_module);
+module_exit(attestation_tdx_exit_module);
+MODULE_DESCRIPTION("TDX attestation provider");
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS("ATTESTATION");
+MODULE_IMPORT_NS("CTLV");
+MODULE_IMPORT_NS("TDX_GUEST");
-- 
2.56.0

