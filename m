Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11E053E2ED
	for <linux-api@vger.kernel.org>; Thu, 15 Oct 2026 14:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075937; cv=none; b=IPtPIHcXgZmGMA0ekhxXhh1d+FkCb3+Exmsfm25AFQCYbImj7L9bIpZUD+VmHh8GfvfJBx/6EZFRvrqK2nfLVm+onrPKPoJiKSzVG5Jok/wWPPEvuEkK9xqu1rt4FeIkn6O1ttTSrNcX7xAl4U0aHpEIBWsdHIszpxoXDoanGyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075937; c=relaxed/simple;
	bh=uTA5OqX6aCayYRXD94t69B3dcQ+q2y5pRQaAguIpFNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7CzGOf+U1R1TqV6V1ykqhT8rjDNXCrv3SnwhXJ5TbNfyw+mmHhazScOlvp8JTkaUVJ1Xl3LNDkacO6kKILiK/6v3bjPpGH9oO0zcsUjz7PhOzgyXdg4Wmg1NnX0oeuFvhLQ0VBpoEc+1OwsgPbR0B9mJNCggJSLyd74FPJ++a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=Y4+Mw9ce; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="Y4+Mw9ce"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b1f31c63ebso102987a12.0
        for <linux-api@vger.kernel.org>; Thu, 15 Oct 2026 07:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1792075930; x=1792680730; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NsmR4AMRImZA17bfh34rZkIDYhK7cJ0pMdRSE8RA0ss=;
        b=Y4+Mw9ceRUTc7vwTcJUO0SwwIfG61jE23mMgKRctX8j0lIq+ZlZOF38U1ChEy+cmcR
         kIfgXr46PW+2qo5Ng8cd4D5ehi5ApTHrswxeOe+XBDNqqeaY5xtTbqp5g+1rgHwY9bR5
         I/yM1VkE6zPDbPBHcqvYYBy6l/9ykyGm3v0RfMFgWz301tMdzut31WU2Zc//MlqlsC5r
         NkX/llfrMSPsntAsjcDdCHiECq0VgKvRZQWr8vqoPgI1m18W0Tl5MIhnGCAra6snbkgs
         K3gIFSe34N+NhZoPmOppnHFAtoDd0jGpnEWZQDyIUisUpCeCeXOeg76wQZHTwSuHD/dA
         wOvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075930; x=1792680730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NsmR4AMRImZA17bfh34rZkIDYhK7cJ0pMdRSE8RA0ss=;
        b=Uz8Wjh4luAoBJBkzgZaAVXGSeNEOXeFJHQxMg3A6BXN4x9uBcr5XYQR+RpbKe+K/hU
         SgkppwubC9obH/7klzaN1dVr2eMC207swEzLW0BV5D+hU1FwXe1EFnLE/tlQtleuSgrs
         CUUFDKLj6tiNx6QF2adIv9w1nYqoqbc7p9cTw4w41KQmK63KB63nNdGekTaukTE9EGLp
         ZD343X5HTs/PvnCK/vIxTWhOZfdOEN1/FhCkg7ss0pH9bQ0l6cWvt6H2rdmDvI7WpL74
         I/Xd45jQbd76P7RnX1W6GwQRr7O6f2LKAQaMqU9yy18yC3Xfr8hifav9pzIhN5CUiEQF
         TgUg==
X-Forwarded-Encrypted: i=1; AKwUvByTq2DACjmH43wvP8Y5dYKKny1ZmNmpa3o82Ry8gvA5X707AhTHHwGUxJoYx3m5tVOJVL8kHPQ8A0g=@vger.kernel.org
X-Gm-Message-State: AFq9FYJgEBiu9WYRtzr+vUJPnebw4CME0YTCch0Cc1uICBavVNfHLp8M
	ZZCh+C5/03Yn4/Khdd+iR6jf6ZQ5796pYFu/ruawD/xeQoyrCzqjJyX2S8TIzHB6yiI=
X-Gm-Gg: AYBFou1yH170CyNcsEGH095DgDEfwnUvllmJ1Wuj0JaciszyLEvVJHZM+yg1OnjL6It
	Iv0SfuGr15oQd0x0gNbcvNWFRwbR4VPosoLbYj2zJu+wZrEY6Z/gaMLyhQ3Dd59apmk0djTSei+
	V5sHRJk7X7xvD3jsPietlsb1VX2K3A8wVnUxdAQN3icHKSP84gG5MMeNZ5FyaJA+fvB6i16427h
	SAtyKB0X8KvKM0i2igtd8GHdjDSz/uECNaLKhcssVFSUqFocXJk8lWgZH4vwqwtozJ0wFeE17oE
	AwvQz8WyKq7um9soCR8JcAbZ4eGXNFWdzcv4HvCEFoHgbigwDvgLCCHynHHyRXKxQsRupZfCzRv
	CNwbgThdezHziedZoqy+Pf5YiVLQsXsCBSBUL9Ji5yquGrtpvKa7m3QdI/Zx/gAahuF8ZlyW4lI
	OjRxrvfgqI76+IP2WTJuPdb4nHTwHPnfB3UbNavIaDdHpDJlSGCCd2OqUOJNMqKiMtu0uAhwTc7
	UaK25EudA==
X-Received: by 2002:a17:907:9708:b0:c2a:ac35:95fb with SMTP id a640c23a62f3a-c40223da0b9mr27472066b.24.1792075929766;
        Thu, 15 Oct 2026 07:52:09 -0700 (PDT)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3ed9b3f0a6sm137223866b.43.2026.10.15.07.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:52:09 -0700 (PDT)
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
Subject: [PATCH RFC 17/20] attestation: Add CTLV operation handling
Date: Thu, 15 Oct 2026 16:50:50 +0200
Message-ID: <20261015145053.3664509-18-jiri@resnulli.us>
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

Translate CTLV evidence, MR and journal operations to the provider core and
wire the attestation family into the kernel build.

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 Documentation/driver-api/attestation.rst |   4 +
 drivers/Kconfig                          |   2 +
 drivers/Makefile                         |   1 +
 drivers/attestation/Makefile             |   3 +-
 drivers/attestation/core/core.c          |   2 +
 drivers/attestation/core/ctlv.c          | 520 +++++++++++++++++++++++
 6 files changed, 531 insertions(+), 1 deletion(-)
 create mode 100644 drivers/attestation/core/ctlv.c

diff --git a/Documentation/driver-api/attestation.rst b/Documentation/driver-api/attestation.rst
index 3cddd853aaa0..5ce121ded05f 100644
--- a/Documentation/driver-api/attestation.rst
+++ b/Documentation/driver-api/attestation.rst
@@ -35,6 +35,10 @@ and event before invoking ``mr_extend``.  A successful callback is followed
 only by infallible publication, so userspace observes the same ordered
 journal.
 
+``MR_READ`` uses ``mr_read_generation`` only to validate query continuation;
+the returned ``mr.generation`` is the journal boundary at which the values
+were read.
+
 Teardown
 ========
 
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 9acc7f74c5c8..971db1f0192c 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -27,6 +27,8 @@ source "drivers/connector/Kconfig"
 
 source "drivers/ctlv/Kconfig"
 
+source "drivers/attestation/Kconfig"
+
 source "drivers/firmware/Kconfig"
 
 source "drivers/fwctl/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index f2c0c3a367ea..2b4dfc8e256b 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -136,6 +136,7 @@ obj-$(CONFIG_INFINIBAND)	+= infiniband/
 obj-y				+= firmware/
 obj-$(CONFIG_FWCTL)		+= fwctl/
 obj-$(CONFIG_CTLV)		+= ctlv/
+obj-$(CONFIG_ATTESTATION)	+= attestation/
 obj-$(CONFIG_CRYPTO)		+= crypto/
 obj-$(CONFIG_SUPERH)		+= sh/
 obj-y				+= clocksource/
diff --git a/drivers/attestation/Makefile b/drivers/attestation/Makefile
index e7c9cb2dfec0..e520fee2e90d 100644
--- a/drivers/attestation/Makefile
+++ b/drivers/attestation/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_ATTESTATION) += attestation.o
 
-attestation-y := core/core.o core/events.o core/mr.o
+attestation-y := core/core.o core/ctlv.o core/events.o core/mr.o \
+		 generated/ctlv_attestation_gen.o
diff --git a/drivers/attestation/core/core.c b/drivers/attestation/core/core.c
index 6db8ed093e93..3fb58f344663 100644
--- a/drivers/attestation/core/core.c
+++ b/drivers/attestation/core/core.c
@@ -326,6 +326,7 @@ int ctlv_attestation_op_pre(void *priv, struct ctlv_op_ctx *ctx)
 	}
 	return 0;
 }
+EXPORT_SYMBOL_NS_GPL(ctlv_attestation_op_pre, "ATTESTATION");
 
 void ctlv_attestation_op_post(void *priv, struct ctlv_op_ctx *ctx)
 {
@@ -333,6 +334,7 @@ void ctlv_attestation_op_post(void *priv, struct ctlv_op_ctx *ctx)
 
 	mutex_unlock(&att->lock);
 }
+EXPORT_SYMBOL_NS_GPL(ctlv_attestation_op_post, "ATTESTATION");
 
 static int __init attestation_module_init(void)
 {
diff --git a/drivers/attestation/core/ctlv.c b/drivers/attestation/core/ctlv.c
new file mode 100644
index 000000000000..ff19400843c2
--- /dev/null
+++ b/drivers/attestation/core/ctlv.c
@@ -0,0 +1,520 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <crypto/hash_info.h>
+#include <linux/cleanup.h>
+#include <linux/err.h>
+#include <linux/limits.h>
+#include <linux/slab.h>
+#include <linux/sort.h>
+#include <linux/string.h>
+
+#include "internal.h"
+
+static const struct attestation_evidence_supported_object *
+attestation_evidence_object_find(const struct attestation_evidence_caps *caps, const char *format)
+{
+	size_t index;
+
+	for (index = 0; index < caps->objects_count; index++) {
+		const struct attestation_evidence_supported_object *object = &caps->objects[index];
+
+		if (!strcmp(object->format, format))
+			return object;
+	}
+	return NULL;
+}
+
+static int attestation_device_caps_put(struct attestation *att, struct ctlv_cursor *reply)
+{
+	const struct attestation_provider *provider = att->provider;
+	struct ctlv_cursor caps_nest, group, object;
+	bool ok = true;
+	size_t index;
+	u64 flags;
+
+	if (!ctlv_attestation_device_caps_start(reply, &caps_nest))
+		return -EMSGSIZE;
+	if (provider->evidence_caps) {
+		const struct attestation_evidence_caps *caps = provider->evidence_caps;
+		u64 blob_class = CTLV_ATTESTATION_EVIDENCE_BLOB_CLASS_PRIMARY;
+		u64 representation = CTLV_ATTESTATION_EVIDENCE_REPRESENTATION_RAW;
+		u64 max_output_length = caps->max_total_output_length;
+
+		if (!ctlv_attestation_cap_evidence_start(&caps_nest, &group))
+			return -EMSGSIZE;
+		ok &= ctlv_attestation_cap_min_challenge_length_put(&group,
+								    caps->min_challenge_length);
+		ok &= ctlv_attestation_cap_max_challenge_length_put(&group,
+								    caps->max_challenge_length);
+		ok &= ctlv_attestation_cap_max_total_output_length_put(&group, max_output_length);
+		for (index = 0; index < caps->objects_count; index++) {
+			const struct attestation_evidence_supported_object *cap =
+				&caps->objects[index];
+
+			if (!ctlv_attestation_cap_object_start(&group, &object)) {
+				ok = false;
+				break;
+			}
+			ok &= ctlv_attestation_cap_blob_class_put(&object, blob_class);
+			ok &= ctlv_attestation_cap_format_put(&object, cap->format);
+			ok &= ctlv_attestation_cap_representation_put(&object, representation);
+			ok &= ctlv_attestation_cap_max_length_put(&object, cap->max_length);
+			ctlv_nest_end(&object);
+		}
+		ctlv_nest_end(&group);
+	}
+	if (provider->mrs_count) {
+		if (!ctlv_attestation_cap_mr_start(&caps_nest, &group))
+			return -EMSGSIZE;
+		flags = 0;
+		if (provider->mr_read)
+			flags |= CTLV_ATTESTATION_MR_DEVICE_CAPS_READ;
+		if (provider->mr_extend)
+			flags |= CTLV_ATTESTATION_MR_DEVICE_CAPS_EXTEND;
+		ok &= ctlv_attestation_cap_mr_flags_put(&group, flags);
+		ctlv_nest_end(&group);
+	}
+	ctlv_nest_end(&caps_nest);
+	return ok ? 0 : -EMSGSIZE;
+}
+
+int ctlv_attestation_device_get_action(void *priv, struct ctlv_op_ctx *ctx,
+				       const struct ctlv_cursor *request, struct ctlv_cursor *reply)
+{
+	struct attestation *att = priv;
+	struct ctlv_cursor info;
+	int ret;
+
+	ret = attestation_device_caps_put(att, reply);
+	if (ret)
+		return ret;
+	if (!ctlv_attestation_device_info_start(reply, &info))
+		return -EMSGSIZE;
+	ret = ctlv_stub_fill(ctx, request, &info);
+	ctlv_nest_end(&info);
+	return ret;
+}
+
+static int
+attestation_evidence_decode_objects(struct attestation *att, struct ctlv_op_ctx *ctx,
+				    const struct ctlv_cursor *request,
+				    struct attestation_evidence_request *decoded,
+				    struct attestation_evidence_object_request **objects_out)
+{
+	const struct attestation_evidence_caps *caps = att->provider->evidence_caps;
+	struct attestation_evidence_object_request *objects;
+	struct ctlv_cursor object;
+	size_t count = 0, index = 0, previous;
+
+	ctlv_attestation_evidence_get_evidence_object_for_each(&object, request) count++;
+	objects = kcalloc(count, sizeof(*objects), GFP_KERNEL);
+	if (!objects)
+		return -ENOMEM;
+	ctlv_attestation_evidence_get_evidence_object_for_each(&object, request)
+	{
+		const struct attestation_evidence_supported_object *supported;
+		const char *format;
+		size_t total = 0;
+
+		format = ctlv_attestation_evidence_get_object_evidence_format_get(&object);
+		supported = attestation_evidence_object_find(caps, format);
+		if (!supported) {
+			kfree(objects);
+			return -EOPNOTSUPP;
+		}
+		for (previous = 0; previous < index; previous++)
+			if (objects[previous].supported_object == supported) {
+				kfree(objects);
+				return -EINVAL;
+			}
+		objects[index].supported_object = supported;
+		objects[index].output =
+			ctlv_attestation_evidence_get_object_evidence_data_resolve(ctx, &object);
+		if (IS_ERR(objects[index].output)) {
+			int ret = PTR_ERR(objects[index].output);
+
+			objects[index].output = NULL;
+			while (index)
+				ctlv_blob_put(objects[--index].output);
+			kfree(objects);
+			return ret;
+		}
+		if (ctlv_blob_len(objects[index].output) < supported->max_length) {
+			for (previous = 0; previous <= index; previous++)
+				ctlv_blob_put(objects[previous].output);
+			kfree(objects);
+			return -EMSGSIZE;
+		}
+		for (previous = 0; previous <= index; previous++) {
+			if (check_add_overflow(total, ctlv_blob_len(objects[previous].output),
+					       &total) ||
+			    total > caps->max_total_output_length) {
+				for (previous = 0; previous <= index; previous++)
+					ctlv_blob_put(objects[previous].output);
+				kfree(objects);
+				return -E2BIG;
+			}
+		}
+		index++;
+	}
+	decoded->objects = objects;
+	decoded->objects_count = count;
+	*objects_out = objects;
+	return 0;
+}
+
+static int attestation_evidence_request_decode(struct attestation *att, struct ctlv_op_ctx *ctx,
+					       const struct ctlv_cursor *request,
+					       struct attestation_evidence_request *decoded,
+					       struct attestation_evidence_object_request **objects)
+{
+	const struct attestation_evidence_caps *caps = att->provider->evidence_caps;
+	u32 challenge_length;
+
+	decoded->challenge =
+		ctlv_attestation_evidence_get_evidence_challenge_get(request, &challenge_length);
+	decoded->challenge_length = challenge_length;
+	if (challenge_length < caps->min_challenge_length ||
+	    challenge_length > caps->max_challenge_length)
+		return -EINVAL;
+	return attestation_evidence_decode_objects(att, ctx, request, decoded, objects);
+}
+
+static void attestation_evidence_request_free(struct attestation_evidence_object_request *objects,
+					      size_t count)
+{
+	while (count) {
+		count--;
+		if (objects[count].output)
+			ctlv_blob_put(objects[count].output);
+	}
+	kfree(objects);
+}
+
+int ctlv_attestation_evidence_get_action(void *priv, struct ctlv_op_ctx *ctx,
+					 const struct ctlv_cursor *request,
+					 struct ctlv_cursor *reply)
+{
+	struct attestation_evidence_object_request *objects = NULL;
+	struct attestation_evidence_request decoded = {};
+	struct attestation_evidence_result result = {};
+	struct attestation *att = priv;
+	bool mr_dependent = false;
+	size_t index;
+	int put_ret;
+	int ret;
+
+	ret = attestation_evidence_request_decode(att, ctx, request, &decoded, &objects);
+	if (ret)
+		goto out;
+	result.object_lengths =
+		kcalloc(decoded.objects_count, sizeof(*result.object_lengths), GFP_KERNEL);
+	if (!result.object_lengths) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	for (index = 0; index < decoded.objects_count; index++)
+		mr_dependent |= decoded.objects[index].supported_object->binds_mrs;
+	ret = att->provider->evidence_get(att, &decoded, &result);
+	if (ret)
+		goto out;
+	for (index = 0; index < decoded.objects_count; index++) {
+		if (result.object_lengths[index] >
+			    decoded.objects[index].supported_object->max_length ||
+		    result.object_lengths[index] > ctlv_blob_len(decoded.objects[index].output)) {
+			ret = -E2BIG;
+			goto out;
+		}
+	}
+	for (index = 0; index < decoded.objects_count; index++) {
+		put_ret = ctlv_blob_put(decoded.objects[index].output);
+		objects[index].output = NULL;
+		if (!ret)
+			ret = put_ret;
+	}
+	if (ret)
+		goto out;
+	if (mr_dependent && !ctlv_attestation_mr_generation_put(reply, att->log->generation)) {
+		ret = -EMSGSIZE;
+		goto out;
+	}
+	for (index = 0; index < decoded.objects_count; index++)
+		if (!ctlv_attestation_evidence_object_length_put(reply,
+								 result.object_lengths[index])) {
+			ret = -EMSGSIZE;
+			goto out;
+		}
+out:
+	kfree(result.object_lengths);
+	attestation_evidence_request_free(objects, decoded.objects_count);
+	return ret;
+}
+
+int ctlv_attestation_mr_get_action(void *priv, struct ctlv_op_ctx *ctx,
+				   const struct ctlv_cursor *request, struct ctlv_cursor *reply)
+{
+	struct attestation *att = priv;
+	struct attestation_mr *mr;
+	u64 id = ctlv_attestation_mr_get_mr_id_get(request);
+
+	if (id > UINT_MAX)
+		return -ERANGE;
+	mr = attestation_mr_lookup_live(att, id);
+	return IS_ERR(mr) ? PTR_ERR(mr) : attestation_mr_props_encode(reply, mr, false);
+}
+
+int ctlv_attestation_mr_dump_query(void *priv, struct ctlv_op_ctx *ctx,
+				   const struct ctlv_cursor *request, struct ctlv_cursor *reply)
+{
+	struct attestation *att = priv;
+	struct attestation_mr *mr;
+	struct ctlv_cursor nested;
+	unsigned long id;
+	u64 cursor = ctlv_op_query_cursor(ctx);
+	unsigned int generation = att->log->generation;
+	int ret;
+
+	if (cursor && ctlv_op_query_generation(ctx) != generation)
+		return -ESTALE;
+	id = cursor ? cursor - 1 : 0;
+	mr = xa_find(&att->mrs, &id, UINT_MAX, XA_PRESENT);
+	while (mr) {
+		if (!ctlv_attestation_mr_item_start(reply, &nested))
+			return ctlv_op_query_more(ctx, generation, id + 1);
+		ret = attestation_mr_props_encode(&nested, mr, true);
+		ctlv_nest_end(&nested);
+		if (ret)
+			return ret;
+		mr = xa_find_after(&att->mrs, &id, UINT_MAX, XA_PRESENT);
+	}
+	return ctlv_op_query_done(ctx, generation);
+}
+
+static int attestation_mr_values_put(struct ctlv_cursor *reply,
+				     const struct attestation_digest_set *values)
+{
+	struct ctlv_cursor nested;
+	size_t index;
+	bool ok;
+
+	for (index = 0; index < values->values_count; index++) {
+		const struct attestation_digest *value = &values->values[index];
+		enum hash_algo algorithm = value->algorithm;
+		size_t length = hash_digest_size[algorithm];
+
+		if (!ctlv_attestation_mr_value_start(reply, &nested))
+			return -EMSGSIZE;
+		ok = ctlv_attestation_mr_hash_algo_put(&nested, algorithm);
+		ok &= ctlv_attestation_mr_data_put(&nested, value->data, length);
+		ctlv_nest_end(&nested);
+		if (!ok)
+			return -EMSGSIZE;
+	}
+	return 0;
+}
+
+int ctlv_attestation_mr_read_query(void *priv, struct ctlv_op_ctx *ctx,
+				   const struct ctlv_cursor *request, struct ctlv_cursor *reply)
+{
+	struct attestation_digest_set values = {};
+	struct attestation *att = priv;
+	struct attestation_mr *mr;
+	u64 id;
+	int ret;
+
+	if (ctlv_op_query_cursor(ctx) &&
+	    ctlv_op_query_generation(ctx) != att->mr_read_generation)
+		return -ESTALE;
+	id = ctlv_attestation_mr_read_mr_id_get(request);
+	if (id > UINT_MAX)
+		return -ERANGE;
+	mr = attestation_mr_lookup_live(att, id);
+	if (IS_ERR(mr))
+		return PTR_ERR(mr);
+	if (!mr->props->readable)
+		return -EOPNOTSUPP;
+	values.values_count = mr->props->algorithms_count;
+	values.values = kcalloc(values.values_count, sizeof(*values.values), GFP_KERNEL);
+	if (!values.values)
+		return -ENOMEM;
+	for (id = 0; id < values.values_count; id++)
+		values.values[id].algorithm = mr->props->algorithms[id];
+	ret = att->provider->mr_read(att, mr->props->id, &values);
+	if (!ret)
+		ret = attestation_mr_values_validate(mr, &values);
+	if (!ret && !ctlv_attestation_mr_generation_put(reply, att->log->generation))
+		ret = -EMSGSIZE;
+	if (!ret)
+		ret = attestation_mr_values_put(reply, &values);
+	kfree(values.values);
+	if (ret)
+		return ret;
+	return ctlv_op_query_done(ctx, att->mr_read_generation);
+}
+
+static int attestation_digest_compare(const void *left, const void *right)
+{
+	const struct attestation_digest *a = left;
+	const struct attestation_digest *b = right;
+
+	return (int)a->algorithm - (int)b->algorithm;
+}
+
+static int attestation_mr_extend_decode(const struct ctlv_cursor *request,
+					struct attestation_digest_set *values)
+{
+	struct ctlv_cursor item;
+	size_t count = 0, index = 0;
+
+	ctlv_attestation_mr_extend_mr_value_for_each(&item, request) count++;
+	values->values = kcalloc(count, sizeof(*values->values), GFP_KERNEL);
+	if (!values->values)
+		return -ENOMEM;
+	values->values_count = count;
+	ctlv_attestation_mr_extend_mr_value_for_each(&item, request)
+	{
+		struct attestation_digest *value = &values->values[index++];
+		u32 length;
+		const void *data;
+		u64 algorithm;
+
+		algorithm =
+			ctlv_attestation_mr_extend_value_mr_hash_algo_get(&item);
+		if (algorithm >= HASH_ALGO__LAST || !hash_digest_size[algorithm])
+			return -EINVAL;
+		data = ctlv_attestation_mr_extend_value_mr_data_get(&item, &length);
+		if (length != hash_digest_size[algorithm])
+			return -EINVAL;
+		value->algorithm = algorithm;
+		memcpy(value->data, data, length);
+	}
+	sort(values->values, values->values_count, sizeof(*values->values),
+	     attestation_digest_compare, NULL);
+	return 0;
+}
+
+int ctlv_attestation_mr_extend_action(void *priv, struct ctlv_op_ctx *ctx,
+				      const struct ctlv_cursor *request, struct ctlv_cursor *reply)
+{
+	struct attestation_digest_set values = {};
+	struct attestation_mr_change *change;
+	const struct attestation_mr_log_entry *entry;
+	struct attestation *att = priv;
+	struct attestation_mr *mr;
+	u64 id;
+	int ret;
+
+	id = ctlv_attestation_mr_extend_mr_id_get(request);
+	if (id > UINT_MAX)
+		return -ERANGE;
+	mr = attestation_mr_lookup_live(att, id);
+	if (IS_ERR(mr))
+		return PTR_ERR(mr);
+	if (!mr->props->extendable)
+		return -EOPNOTSUPP;
+	ret = attestation_mr_extend_decode(request, &values);
+	if (ret)
+		goto out_values;
+	ret = attestation_mr_values_validate(mr, &values);
+	if (ret)
+		goto out_values;
+	change = attestation_mr_change_prepare(att, mr, &values);
+	if (IS_ERR(change)) {
+		ret = PTR_ERR(change);
+		goto out_values;
+	}
+	entry = attestation_mr_extend_locked(att, change);
+	if (IS_ERR(entry))
+		ret = PTR_ERR(entry);
+	else if (!ctlv_attestation_mr_generation_put(reply, entry->mr_generation))
+		ret = -EMSGSIZE;
+	attestation_mr_change_free(change);
+out_values:
+	kfree(values.values);
+	return ret;
+}
+
+static bool attestation_log_selected(const unsigned int *ids, size_t count, unsigned int id)
+{
+	size_t index;
+
+	if (!count)
+		return true;
+	for (index = 0; index < count; index++)
+		if (ids[index] == id)
+			return true;
+	return false;
+}
+
+int ctlv_attestation_mr_log_get_query(void *priv, struct ctlv_op_ctx *ctx,
+				      const struct ctlv_cursor *request, struct ctlv_cursor *reply)
+{
+	struct attestation *att = priv;
+	struct attestation_mr_log_entry *entry;
+	struct ctlv_cursor item, nested;
+	unsigned int ids[256];
+	size_t ids_count = 0, index;
+	unsigned int start, end;
+	unsigned long xa_index;
+	u64 boundary;
+	u64 cursor = ctlv_op_query_cursor(ctx);
+	int ret;
+
+	ctlv_attestation_mr_log_get_mr_selection_for_each(&item, request)
+	{
+		u64 id = ctlv_attestation_mr_log_get_selection_mr_id_get(&item);
+
+		if (id > UINT_MAX)
+			return -ERANGE;
+		for (index = 0; index < ids_count; index++)
+			if (ids[index] == id)
+				return -EINVAL;
+		ids[ids_count++] = id;
+	}
+	if (cursor)
+		boundary = ctlv_op_query_generation(ctx);
+	else
+		boundary = att->log->generation;
+	if (boundary > UINT_MAX || boundary > att->log->generation)
+		return -ESTALE;
+	end = boundary;
+	if (ctlv_attestation_mr_log_get_mr_end_generation_present(request)) {
+		u64 requested_end = ctlv_attestation_mr_log_get_mr_end_generation_get(request);
+
+		end = min_t(u64, end, requested_end);
+	}
+	start = 1;
+	if (ctlv_attestation_mr_log_get_mr_start_generation_present(request)) {
+		u64 value = ctlv_attestation_mr_log_get_mr_start_generation_get(request);
+
+		if (value > UINT_MAX)
+			return -EINVAL;
+		start = value;
+	}
+	if (att->log->generation && start > end)
+		return -EINVAL;
+	if (!cursor && att->log->generation) {
+		if (!ctlv_attestation_mr_start_generation_put(reply, start) ||
+		    !ctlv_attestation_mr_end_generation_put(reply, end))
+			return -EMSGSIZE;
+	}
+	xa_index = cursor ? cursor : start;
+	entry = xa_find(&att->log->entries, &xa_index, end, XA_PRESENT);
+	while (entry && !attestation_log_selected(ids, ids_count, entry->mr_id))
+		entry = xa_find_after(&att->log->entries, &xa_index, end, XA_PRESENT);
+	if (!entry)
+		return ctlv_op_query_done(ctx, boundary);
+	if (!cursor)
+		return ctlv_op_query_more(ctx, boundary, entry->mr_generation);
+	if (!ctlv_attestation_log_entry_start(reply, &nested))
+		return -EMSGSIZE;
+	ret = attestation_mr_log_entry_encode(&nested, entry);
+	ctlv_nest_end(&nested);
+	if (ret)
+		return ret;
+	entry = xa_find_after(&att->log->entries, &xa_index, end, XA_PRESENT);
+	while (entry && !attestation_log_selected(ids, ids_count, entry->mr_id))
+		entry = xa_find_after(&att->log->entries, &xa_index, end, XA_PRESENT);
+	if (entry)
+		return ctlv_op_query_more(ctx, boundary, entry->mr_generation);
+	return ctlv_op_query_done(ctx, boundary);
+}
-- 
2.56.0

