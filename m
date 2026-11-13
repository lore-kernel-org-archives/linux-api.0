Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794586136;
	b=HWNL3TdkbJXkOvn6sKQsX72XdQGzdljASdyAyJbp17QU3uycO0TUotbgfbSHWce9AhXU
	 Y9qUkj7ty6kgESVCec4UP8w2TJ/5U3I4kmmK3nk19znOU4UbFR3v3Gg+2U6occJedU/th
	 2hSkdz46vTalwhuxO1QfjFGZmKrNeO6ake6d8SRklhCKlsKJBZLCPqLWd8YkjpIHgOSyl
	 39pw5TqhiplXMdOYiOxoYnixyEnSPPQ8XsavwsVncgEHkDMg3AGbIuIBBBW0xZ2rizQMI
	 HGTk2VY5TcEbENpdPj2UQHoU+l4MSnPqF638jhz1aKylCKWnm0LkPLeYKDe5sNYOvCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586136;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CHva8CWvP7gwkMlzfMecnIUN3qeNv3ZRxSwpEsl3J0M=;
	b=L7rOh50ZnwP7qWf6oss6YHnRw8/7A/1hkjff1b5AnvSBSKzJyc/5OGLL1F8TaqvqYX0z
	 4Z702De43iAecklafBfBr9ewWjB65uKiaHXQn1XwA69+2u2pAJnsL01mEeHZEWjhTdfav
	 xQcSnKIUCnC8+29wx6xSct96oiX4so5CaTCviRsdj3ZDgPpRtucUPHkr6sLhIO37Y7Mx6
	 0GBfN50pOV2wbhEfueGLGYBTt6WARF+AwrE2Es9MGD5KbWWf0Ui4rHumM/u1NAltu4mej
	 ucNnJ5VCxX8LyxQgcuv5iEaMh/t9WnuoY1Fvf4sPoyBHvFU8wgZYBNERhVOygVc4bLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=w9Nreo3B;
	arc=none smtp.remote-ip=209.85.218.45
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D13606AE37
	for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 16:08:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35D13606AE37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=w9Nreo3B
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c4395d31228so247487266b.1
        for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 08:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1794586133; x=1795190933; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CHva8CWvP7gwkMlzfMecnIUN3qeNv3ZRxSwpEsl3J0M=;
        b=w9Nreo3BL/4o3QMJdEAdXXtqjn9YQoRGH0pe+0sf2eI8IPF0SCJ4+1ihTHTJMmxL1T
         LEWrwjLj4sgHSIgW0oqaMNUcbxHl59TrKQ08cGbmqIHPWKB2LRIIy6IBjYIaPpbV84k4
         J702vQQrLEum3G5pGVpof6Q4rTORM/+IQ5+b2LtgdIgAo2lQFj+/CZX+utgVSw4hRnuS
         AIKWmojMcd1jDYgJCYuMGsnLC3w1Oibi/z80Em557fDj977A0BPvQM8rkaxzdZXNyxpU
         lma/gnjfT8T+yNLLq/yW8/lAawN1E9NXl+cbDONTCX+FSY1jDPG/Xha0aiY0euVnaH+M
         OqWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794586133; x=1795190933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CHva8CWvP7gwkMlzfMecnIUN3qeNv3ZRxSwpEsl3J0M=;
        b=uuJOQkdYlvrNQ34pNZ08QI+xtmGTC5v3khOX5ROYXj9vFZ9p4UGHk7UYYDfwGJ0k5N
         G4KZ7JxEMlcNoT0RE4ldPys6UUe4hMAw50lQ815s9yztMBqyKx7CEBV8k/b/Mpe5rPdl
         6bnc9diO56a5RRFGI8tsGzl5+CmAH6vcN8rJBp9PXT/cVnf13HaFloGlYqD1ukzfbX8c
         vXrDPU1hRKyAIyVcVr/01un8k+Ent480pHVh6NnELZx73trN8ZseHUR8g1MUFmLXN+lN
         DDuR/pn8E5X9AM+JszCyozNX/LhOwJ9yUf9YxC9hXuZTUTNZQjrufHueT68st4tGmvFx
         f22w==
X-Forwarded-Encrypted: i=1; AL+hErHdMvOS7UHmgmITN8Jk5KW5WKU7ZgV5RzkDE8mqbCmSj4VrpFWS/tyb7Moqn74vpPUtcQmup670naY=@vger.kernel.org
X-Gm-Message-State: APuU4Z8pElRBrYFQTr9enuhsdqmVohH2DnAwdN5Z2f/chk0o1NW+t+F+
	tvOswzNhcPInneksFfMIQ3NGJtphqJ2sRjY4Mn8Y81AUdtDMcPQAO1Ha98P04ebdKDo=
X-Gm-Gg: AYBFou3Z5nMwtWzZKL1viWhRmkCWsjCj4ZybqgYUpbtc1AAkiBXjDI+c3mglZ/fVfpE
	muVKP/+ArlX/0/6atBBnl9dB1FFdvja6RoPQCJfAwl4RVY/xjP45SO7Xdi9vN+4MYXvF6UtSsvk
	2NkEABVS0pSd0Pvwli5DLrPZErz1UIMpEeHEkqiHBeLcQdEEVNzU1kJN4ii2qu4impTZqWMg8us
	Zl4B5oNYALVbUcnh57W/XljNAYOVkUrikYr8Y/ld0caNJoAd14wz64lx0VnXIhEL6nGjqTwDdAl
	H9RvCX9PkqkpkoqTG9RLXak+e0a3BSm08zyAMq0sBdA7MYMyW/rZY2eXCf9oL9Gkz/heaJ/uurO
	zSiyIuY/+BKAIwEM7FjU+Sjdt/D+uKaKpbzPas1d3/4ozY7BjZwEoXYhcF8zZRHVFXpsUmXa9p6
	ZbbbJsK8L1WP9mXcXA63gvfJ9+8BrEXAcKp2mIZPC9YN1a5WiKrAfmGqjlu9cjh8mDIMK3fmqNd
	5MRD6YnA+ogTeUlsljjCnLbs1uvZF51mqsou1/hUH6jzcnHpP5L2smZR+TAigEhCUaUyIGZPMo0
	O3uoK/rEUDVcHWvhZJpNALORYbEiQLQCgt4QA3vQ
X-Received: by 2002:a17:906:f591:b0:c50:5e10:71ae with SMTP id a640c23a62f3a-c50963075f7mr289725966b.17.1794586133342;
        Fri, 13 Nov 2026 08:08:53 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c604ee47dsm5608032f8f.38.2026.11.13.08.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 08:08:52 -0800 (PST)
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
	peter.fang@intel.com,
	jarkko@kernel.org,
	zohar@linux.ibm.com,
	yeoreum.yun@arm.com,
	aneesh.kumar@kernel.org,
	dave.jiang@intel.com,
	nik.borisov@suse.com,
	sergii.dmytruk@3mdeb.com
Subject: [PATCH RFC v2 3/9] attestation: Prepare provider and instance core
Date: Fri, 13 Nov 2026 17:08:32 +0100
Message-ID: <20261113160838.2512652-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113160838.2512652-1-jiri@resnulli.us>
References: <20261113160838.2512652-1-jiri@resnulli.us>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

Add provider validation, instance registration and lifecycle management
for the attestation family. Each instance is a device of the attestation
class, with a node under /dev/attestation/, and embeds its CTLV
instance and node.

The provider descriptor is one immutable evidence and MR contract; MR
state follows in the next patch. The core object can be compile-checked
here. CONFIG_ATTESTATION remains unwired until the CTLV handlers land.

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- gave attestation its own device, class and /dev/attestation/ nodes,
  each a struct ctlv_device
- dropped the goto from attestation_registry_insert()
- noted that instance indexes are never reused
- selected CRYPTO_HASH_INFO
- selected CTLV instead of depending on it
- kept each guard() on one line
- dropped the journal from the Kconfig help
- dropped read(), poll() and the event teardown
- refused hash algorithms the hash-algo enum does not list
- gave each evidence object a class and the formats it may have
- dropped max_total_output_length
- took each signed object's challenge lengths as a list, ascending
  and disjoint
- left the object count and challenge length limits to CTLV
- added attestation_evidence_write(), for blobs of any length
- let a request omit the challenge
- separated the steps of the longer functions
- took an MR's algorithms in any order, each once
- let mr_extend get the digests of some of an MR's banks
- required mr_read of a provider with MRs, as every MR can be read
- said that an MR's extend cap is fixed
- took the UAPI headers from include/uapi/ctlv/
- named evidence objects by ID, and had the provider give each
  result's format
---
 MAINTAINERS                         |   1 +
 drivers/attestation/Kconfig         |  12 +
 drivers/attestation/Makefile        |   4 +
 drivers/attestation/core/core.c     | 429 ++++++++++++++++++++++++++++
 drivers/attestation/core/internal.h |  21 ++
 include/linux/attestation.h         | 240 ++++++++++++++++
 6 files changed, 707 insertions(+)
 create mode 100644 drivers/attestation/Kconfig
 create mode 100644 drivers/attestation/Makefile
 create mode 100644 drivers/attestation/core/core.c
 create mode 100644 drivers/attestation/core/internal.h
 create mode 100644 include/linux/attestation.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 0c1778e676ed..e57fc8bb9c1d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4441,6 +4441,7 @@ F:	Documentation/ctlv/abi/ctlv-attestation*
 F:	Documentation/ctlv/specs/ctlv-attestation*
 F:	Documentation/userspace-api/attestation*.rst
 F:	drivers/attestation/
+F:	include/linux/attestation*
 F:	include/uapi/ctlv/ctlv_attestation*
 
 ATTO EXPRESSSAS SAS/SATA RAID SCSI DRIVER
diff --git a/drivers/attestation/Kconfig b/drivers/attestation/Kconfig
new file mode 100644
index 000000000000..a6bfb17dd480
--- /dev/null
+++ b/drivers/attestation/Kconfig
@@ -0,0 +1,12 @@
+# SPDX-License-Identifier: GPL-2.0-only
+menuconfig ATTESTATION
+	tristate "Attestation"
+	select CRYPTO_HASH_INFO
+	select CTLV
+	help
+	  Provides a CTLV family for evidence and measurement registers.
+
+	  Providers register one instance for a physical or logical device and
+	  translate the common operations to their native service.
+
+	  If you are unsure, say N.
diff --git a/drivers/attestation/Makefile b/drivers/attestation/Makefile
new file mode 100644
index 000000000000..8a75558a7013
--- /dev/null
+++ b/drivers/attestation/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_ATTESTATION) += attestation.o
+
+attestation-y := core/core.o
diff --git a/drivers/attestation/core/core.c b/drivers/attestation/core/core.c
new file mode 100644
index 000000000000..587a0a9616b6
--- /dev/null
+++ b/drivers/attestation/core/core.c
@@ -0,0 +1,429 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <crypto/hash_info.h>
+#include <linux/bitmap.h>
+#include <linux/cleanup.h>
+#include <linux/ctlv.h>
+#include <linux/ctlv_device.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/limits.h>
+#include <linux/module.h>
+#include <linux/overflow.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+#include "internal.h"
+
+#define ATTESTATION_MAX_DEVICES 4096
+
+static DEFINE_XARRAY(attestation_instances);
+
+static DEFINE_MUTEX(attestation_registry_lock);
+/* Never reused, so a stale index cannot name a newer instance. */
+static unsigned long attestation_next_index;
+
+/* A reply carries only what hash-algo in ctlv-attestation.yaml lists. */
+static bool attestation_algorithm_valid(enum hash_algo algorithm)
+{
+	return algorithm >= 0 && algorithm <= HASH_ALGO_SHA3_512 && hash_digest_size[algorithm] &&
+	       hash_digest_size[algorithm] <= HASH_MAX_DIGESTSIZE;
+}
+
+static int attestation_mr_props_validate(const struct attestation_provider *provider,
+					 const struct attestation_mr_props *props)
+{
+	DECLARE_BITMAP(seen, HASH_ALGO__LAST) = {};
+	size_t index;
+
+	if (!props || !props->name || !*props->name || strlen(props->name) > 128 ||
+	    !props->algorithms || !props->algorithms_count || props->algorithms_count > 23)
+		return -EINVAL;
+	for (index = 0; index < props->algorithms_count; index++) {
+		enum hash_algo algorithm = props->algorithms[index];
+
+		if (!attestation_algorithm_valid(algorithm) ||
+		    __test_and_set_bit(algorithm, seen))
+			return -EINVAL;
+	}
+	if (props->extendable && !provider->mr_extend)
+		return -EINVAL;
+	return 0;
+}
+
+/* What device-get and evidence-get carry, as ctlv-attestation.yaml bounds it. */
+#define ATTESTATION_EVIDENCE_OBJECTS_MAX 16
+#define ATTESTATION_EVIDENCE_FORMATS_MAX 4
+#define ATTESTATION_CHALLENGE_LENGTHS_MAX 8
+#define ATTESTATION_CHALLENGE_MAX 4096
+/* Moves with each value appended to evidence-format. */
+#define ATTESTATION_EVIDENCE_FORMAT_LAST CTLV_ATTESTATION_EVIDENCE_FORMAT_CCEL
+
+static bool
+attestation_challenge_lengths_valid(const struct attestation_evidence_supported_object *object)
+{
+	size_t index;
+
+	if (object->evidence_class != ATTESTATION_EVIDENCE_SIGNED)
+		return !object->challenge_lengths_count;
+	if (!object->challenge_lengths || !object->challenge_lengths_count ||
+	    object->challenge_lengths_count > ATTESTATION_CHALLENGE_LENGTHS_MAX)
+		return false;
+	for (index = 0; index < object->challenge_lengths_count; index++) {
+		const struct attestation_evidence_challenge_length *length =
+			&object->challenge_lengths[index];
+
+		if (!length->min || length->min > length->max ||
+		    length->max > ATTESTATION_CHALLENGE_MAX ||
+		    (index && object->challenge_lengths[index - 1].max >= length->min))
+			return false;
+	}
+	return true;
+}
+
+static bool
+attestation_formats_valid(const struct attestation_evidence_supported_object *object,
+			  u32 vendor_max)
+{
+	size_t counts[2] = {}, index, prior;
+
+	if (!object->formats || !object->formats_count)
+		return false;
+	for (index = 0; index < object->formats_count; index++) {
+		const struct attestation_evidence_format *format = &object->formats[index];
+		u32 max = format->vendor ? vendor_max : ATTESTATION_EVIDENCE_FORMAT_LAST;
+
+		if (!format->value || format->value > max ||
+		    ++counts[format->vendor] > ATTESTATION_EVIDENCE_FORMATS_MAX)
+			return false;
+		for (prior = 0; prior < index; prior++)
+			if (object->formats[prior].vendor == format->vendor &&
+			    object->formats[prior].value == format->value)
+				return false;
+	}
+	return true;
+}
+
+static int attestation_evidence_caps_validate(const struct attestation_provider *provider,
+					      const struct ctlv_family *family)
+{
+	const struct attestation_evidence_caps *caps = provider->evidence_caps;
+	size_t index;
+	u32 vendor_max;
+
+	if (!caps)
+		return provider->evidence_get ? -EINVAL : 0;
+	if (!provider->evidence_get || !caps->objects || !caps->objects_count ||
+	    caps->objects_count > ATTESTATION_EVIDENCE_OBJECTS_MAX)
+		return -EINVAL;
+
+	vendor_max = ctlv_enum_ext_max(family, CTLV_FAMILY_ATTESTATION,
+				       CTLV_ATTESTATION_ENUM_EXT_EVIDENCE_VENDOR_FORMAT);
+	for (index = 0; index < caps->objects_count; index++) {
+		const struct attestation_evidence_supported_object *object = &caps->objects[index];
+
+		if (object->evidence_class < ATTESTATION_EVIDENCE_SIGNED ||
+		    object->evidence_class > ATTESTATION_EVIDENCE_EVENT_LOG ||
+		    !attestation_formats_valid(object, vendor_max) ||
+		    !attestation_challenge_lengths_valid(object) ||
+		    !object->max_length || object->max_length > UINT_MAX)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+int attestation_provider_validate(const struct attestation_provider *provider,
+				  const struct ctlv_family *family)
+{
+	size_t index;
+	int ret;
+
+	if (!provider)
+		return -EINVAL;
+	ret = attestation_evidence_caps_validate(provider, family);
+	if (ret)
+		return ret;
+	if (!!provider->mrs != !!provider->mrs_count)
+		return -EINVAL;
+	if (provider->mrs_count && !provider->mr_read)
+		return -EINVAL;
+	if ((provider->mr_read || provider->mr_extend) && !provider->mrs_count)
+		return -EINVAL;
+	for (index = 0; index < provider->mrs_count; index++) {
+		ret = attestation_mr_props_validate(provider, &provider->mrs[index]);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static bool attestation_parent_exists(struct device *parent)
+{
+	struct attestation_dev *att;
+	unsigned long index;
+
+	xa_for_each(&attestation_instances, index, att)
+		if (att->node.dev.parent == parent)
+			return true;
+	return false;
+}
+
+static int attestation_registry_insert(struct attestation_dev *att)
+{
+	unsigned long index;
+	void *old;
+	int ret;
+
+	guard(mutex)(&attestation_registry_lock);
+	if (attestation_next_index > UINT_MAX)
+		return -ENOSPC;
+	index = attestation_next_index;
+	ret = xa_reserve(&attestation_instances, index, GFP_KERNEL);
+	if (ret)
+		return ret;
+
+	xa_lock(&attestation_instances);
+	if (attestation_parent_exists(att->node.dev.parent)) {
+		__xa_erase(&attestation_instances, index);
+		ret = -EEXIST;
+	} else {
+		old = __xa_store(&attestation_instances, index, att, GFP_NOWAIT);
+		ret = xa_err(old);
+	}
+	if (!ret) {
+		att->index = index;
+		attestation_next_index++;
+	}
+	xa_unlock(&attestation_instances);
+	return ret;
+}
+
+static void attestation_registry_remove(struct attestation_dev *att)
+{
+	xa_erase(&attestation_instances, att->index);
+}
+
+bool attestation_registered(struct attestation_dev *att)
+{
+	bool registered;
+
+	lockdep_assert_held(&att->lock);
+	xa_lock(&attestation_instances);
+	registered = xa_get_mark(&attestation_instances, att->index, ATTESTATION_REGISTERED);
+	xa_unlock(&attestation_instances);
+	return registered;
+}
+
+void attestation_stop(struct attestation_dev *att)
+{
+	lockdep_assert_held(&att->lock);
+	xa_lock(&attestation_instances);
+	__xa_clear_mark(&attestation_instances, att->index, ATTESTATION_REGISTERED);
+	xa_unlock(&attestation_instances);
+}
+
+/**
+ * attestation_evidence_write - Write an evidence object to its blob.
+ * @object: the requested object
+ * @data: the object's bytes
+ * @length: their length, at most the object's max_length
+ *
+ * A blob too short for the object fails the operation, and the caller is told
+ * how long it has to be.
+ *
+ * Return: 0, -EMSGSIZE where the blob is too short, or another negative error.
+ */
+int attestation_evidence_write(const struct attestation_evidence_object_request *object,
+			       const void *data, size_t length)
+{
+	if (length > object->supported_object->max_length)
+		return -E2BIG;
+	if (length > ctlv_blob_len(object->output))
+		return ctlv_blob_too_short(object->output, length);
+	return ctlv_blob_write(object->output, 0, data, length);
+}
+EXPORT_SYMBOL_NS_GPL(attestation_evidence_write, "ATTESTATION");
+
+void attestation_provide_ops(struct attestation_dev *att)
+{
+	const struct attestation_provider *provider = att->provider;
+	struct ctlv *ctlv = &att->ctlv;
+
+	if (provider->evidence_caps) {
+		ctlv_attestation_evidence_get_provide(ctlv);
+		ctlv_attestation_evidence_get_enable(ctlv);
+	}
+}
+
+/* Runs from the release, so it must not reach the provider's module. */
+static void attestation_state_free(struct attestation_dev *att)
+{
+	mutex_destroy(&att->lock);
+}
+
+static int attestation_op_pre(struct ctlv *ctlv, struct ctlv_op_ctx *ctx)
+{
+	struct attestation_dev *att = attestation_from_ctlv(ctlv);
+
+	mutex_lock(&att->lock);
+	if (!attestation_registered(att)) {
+		mutex_unlock(&att->lock);
+		return -ENODEV;
+	}
+	return 0;
+}
+
+static void attestation_op_post(struct ctlv *ctlv, struct ctlv_op_ctx *ctx)
+{
+	mutex_unlock(&attestation_from_ctlv(ctlv)->lock);
+}
+
+static const struct ctlv_hooks attestation_ctlv_hooks = {
+	.pre = attestation_op_pre,
+	.post = attestation_op_post,
+};
+
+/* Kernel callers find a device by its mark, and are drained once it is gone. */
+static void attestation_withdraw(struct attestation_dev *att)
+{
+	xa_lock(&attestation_instances);
+	__xa_clear_mark(&attestation_instances, att->index, ATTESTATION_REGISTERED);
+	xa_unlock(&attestation_instances);
+}
+
+static char *attestation_devnode(const struct device *dev, umode_t *mode)
+{
+	return kasprintf(GFP_KERNEL, "attestation/%s", dev_name(dev));
+}
+
+static void attestation_dev_release(struct device *dev)
+{
+	struct attestation_dev *att = container_of(dev, struct attestation_dev, node.dev);
+
+	attestation_state_free(att);
+	ctlv_fini(&att->ctlv);
+	ctlv_device_fini(&att->node);
+	kfree(att);
+}
+
+/*
+ * The core registers the class, so an open holds the core module and not the
+ * provider's, which may unload while readers remain.
+ */
+static struct ctlv_device_class attestation_class = {
+	.class = {
+		.name = "attestation",
+		.dev_release = attestation_dev_release,
+		.devnode = attestation_devnode,
+	},
+	.max_devices = ATTESTATION_MAX_DEVICES,
+};
+
+struct attestation_dev *_attestation_alloc(struct device *parent,
+					   const struct attestation_provider *provider,
+					   const struct ctlv_family *family, size_t size,
+					   size_t offset)
+{
+	struct attestation_dev *att;
+	int ret;
+
+	if (!parent || WARN_ON_ONCE(offset || size < sizeof(*att)) ||
+	    !ctlv_family_inherits(family, &ctlv_attestation_family))
+		return ERR_PTR(-EINVAL);
+	ret = attestation_provider_validate(provider, family);
+	if (ret)
+		return ERR_PTR(ret);
+
+	att = kzalloc(size, GFP_KERNEL);
+	if (!att)
+		return ERR_PTR(-ENOMEM);
+	att->provider = provider;
+	mutex_init(&att->lock);
+
+	/* From here on, the release frees whatever was set up. */
+	ret = ctlv_device_init(&att->node, &attestation_class, parent, &att->ctlv);
+	if (!ret)
+		ret = ctlv_init(&att->ctlv, &att->node.dev, family, &attestation_ctlv_hooks);
+	if (ret) {
+		put_device(&att->node.dev);
+		return ERR_PTR(ret);
+	}
+	attestation_provide_ops(att);
+	return att;
+}
+EXPORT_SYMBOL_NS_GPL(_attestation_alloc, "ATTESTATION");
+
+/**
+ * attestation_register - Make an allocated device reachable.
+ * @att: device from attestation_alloc()
+ *
+ * Return: 0, or a negative errno with @att still to be put.
+ */
+int attestation_register(struct attestation_dev *att)
+{
+	int ret;
+
+	ret = attestation_registry_insert(att);
+	if (ret)
+		return ret;
+	ctlv_publish(&att->ctlv);
+	xa_lock(&attestation_instances);
+	__xa_set_mark(&attestation_instances, att->index, ATTESTATION_REGISTERED);
+	xa_unlock(&attestation_instances);
+
+	ret = ctlv_device_add(&att->node);
+	if (ret)
+		goto err_withdraw;
+	return 0;
+
+err_withdraw:
+	attestation_withdraw(att);
+	ctlv_unpublish(&att->ctlv);
+	attestation_registry_remove(att);
+	return ret;
+}
+EXPORT_SYMBOL_NS_GPL(attestation_register, "ATTESTATION");
+
+/**
+ * attestation_unregister - Cut a registered device off from every caller.
+ * @att: registered device
+ *
+ * No provider callback runs once this returns, though open files may still
+ * hold @att.
+ */
+void attestation_unregister(struct attestation_dev *att)
+{
+	/* No new opens, and no node to open. */
+	ctlv_device_del(&att->node);
+	attestation_withdraw(att);
+	ctlv_unpublish(&att->ctlv);
+	attestation_registry_remove(att);
+}
+EXPORT_SYMBOL_NS_GPL(attestation_unregister, "ATTESTATION");
+
+/**
+ * attestation_put - Drop the reference attestation_alloc() returned.
+ * @att: device
+ */
+void attestation_put(struct attestation_dev *att)
+{
+	put_device(&att->node.dev);
+}
+EXPORT_SYMBOL_NS_GPL(attestation_put, "ATTESTATION");
+
+static int __init attestation_module_init(void)
+{
+	return ctlv_device_class_register(&attestation_class);
+}
+
+static void __exit attestation_module_exit(void)
+{
+	WARN_ON_ONCE(!xa_empty(&attestation_instances));
+	xa_destroy(&attestation_instances);
+	ctlv_device_class_unregister(&attestation_class);
+}
+
+module_init(attestation_module_init);
+module_exit(attestation_module_exit);
+MODULE_DESCRIPTION("Attestation core");
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS("CTLV");
diff --git a/drivers/attestation/core/internal.h b/drivers/attestation/core/internal.h
new file mode 100644
index 000000000000..f42bc3cd9a35
--- /dev/null
+++ b/drivers/attestation/core/internal.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ATTESTATION_INTERNAL_H
+#define _ATTESTATION_INTERNAL_H
+
+#include <linux/attestation.h>
+#include <linux/ctlv.h>
+#include <linux/mutex.h>
+#include <linux/xarray.h>
+
+#include "../generated/ctlv_attestation_gen.h"
+
+#define ATTESTATION_REGISTERED XA_MARK_1
+
+bool attestation_registered(struct attestation_dev *att);
+void attestation_stop(struct attestation_dev *att);
+
+int attestation_provider_validate(const struct attestation_provider *provider,
+				  const struct ctlv_family *family);
+void attestation_provide_ops(struct attestation_dev *att);
+
+#endif /* _ATTESTATION_INTERNAL_H */
diff --git a/include/linux/attestation.h b/include/linux/attestation.h
new file mode 100644
index 000000000000..29bb776bfb41
--- /dev/null
+++ b/include/linux/attestation.h
@@ -0,0 +1,240 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _LINUX_ATTESTATION_H
+#define _LINUX_ATTESTATION_H
+
+#include <crypto/hash.h>
+#include <linux/build_bug.h>
+#include <linux/ctlv.h>
+#include <linux/ctlv_device.h>
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/types.h>
+
+#include <uapi/ctlv/ctlv_attestation_gen.h>
+#include <uapi/linux/hash_info.h>
+
+struct attestation_dev;
+struct ctlv_blob;
+struct ctlv_family;
+
+enum attestation_evidence_class {
+	ATTESTATION_EVIDENCE_SIGNED = CTLV_ATTESTATION_EVIDENCE_CLASS_SIGNED,
+	ATTESTATION_EVIDENCE_EVENT_LOG = CTLV_ATTESTATION_EVIDENCE_CLASS_EVENT_LOG,
+};
+
+/**
+ * struct attestation_digest - One MR digest.
+ * @algorithm: hash algorithm
+ * @data: digest bytes
+ */
+struct attestation_digest {
+	enum hash_algo algorithm;
+	u8 data[HASH_MAX_DIGESTSIZE];
+};
+
+/**
+ * struct attestation_digest_set - Digests for an MR's banks, in the MR's order.
+ * @values_count: number of digests
+ * @values: digest array
+ */
+struct attestation_digest_set {
+	size_t values_count;
+	struct attestation_digest *values;
+};
+
+/**
+ * struct attestation_mr_props - Immutable MR properties.
+ * @id: provider-unique MR ID
+ * @name: MR name
+ * @algorithms: bank hash algorithms, each once, in the order replies list them
+ * @algorithms_count: number of algorithms
+ * @has_register_index: whether @register_index is valid
+ * @register_index: native register index
+ * @extendable: MR may be extended. Fixed: the provider instead refuses an
+ *	extend the platform forbids at the time, e.g. -EPERM for a TPM locality.
+ */
+struct attestation_mr_props {
+	unsigned int id;
+	const char *name;
+	const enum hash_algo *algorithms;
+	size_t algorithms_count;
+	bool has_register_index;
+	unsigned int register_index;
+	bool extendable;
+};
+
+/**
+ * struct attestation_evidence_format - The layout of an evidence object.
+ * @vendor: @value is an evidence-vendor-format value the device's family
+ *	gives, not an evidence-format one
+ * @value: the value, such as CTLV_ATTESTATION_EVIDENCE_FORMAT_CCEL
+ */
+struct attestation_evidence_format {
+	bool vendor;
+	u32 value;
+};
+
+/**
+ * struct attestation_evidence_challenge_length - Challenge lengths taken.
+ * @min: shortest challenge bytes, at least 1
+ * @max: longest challenge bytes, @min for one exact length, at most 4096
+ */
+struct attestation_evidence_challenge_length {
+	size_t min;
+	size_t max;
+};
+
+/**
+ * struct attestation_evidence_supported_object - One evidence object.
+ * @evidence_class: what the object is
+ * @formats: the layouts it may have, at most four of each kind
+ * @formats_count: number of formats
+ * @challenge_lengths: a signed object's challenge lengths, ascending and
+ *	disjoint; none for any other object
+ * @challenge_lengths_count: number of challenge lengths, at most 8
+ * @max_length: longest the object gets, in bytes
+ * @binds_mrs: the object covers MR values, as they are or by a digest, so
+ *	the reply carries mr-generation
+ *
+ * The object's index in the provider's objects is its ID.
+ */
+struct attestation_evidence_supported_object {
+	enum attestation_evidence_class evidence_class;
+	const struct attestation_evidence_format *formats;
+	size_t formats_count;
+	const struct attestation_evidence_challenge_length *challenge_lengths;
+	size_t challenge_lengths_count;
+	size_t max_length;
+	bool binds_mrs;
+};
+
+/**
+ * struct attestation_evidence_caps - Immutable evidence capabilities.
+ * @objects: supported evidence objects, at most 16
+ * @objects_count: number of objects
+ */
+struct attestation_evidence_caps {
+	const struct attestation_evidence_supported_object *objects;
+	size_t objects_count;
+};
+
+/**
+ * struct attestation_evidence_object_request - One resolved output object.
+ * @supported_object: the object requested
+ * @output: resolved output blob
+ */
+struct attestation_evidence_object_request {
+	const struct attestation_evidence_supported_object *supported_object;
+	struct ctlv_blob *output;
+};
+
+/**
+ * struct attestation_evidence_request - Validated evidence request.
+ * @challenge: challenge bytes, of a length every signed object requested
+ *	takes, or NULL where the request names no signed object
+ * @challenge_length: challenge length, 0 without a challenge
+ * @objects: requested output objects
+ * @objects_count: number of objects
+ */
+struct attestation_evidence_request {
+	const u8 *challenge;
+	size_t challenge_length;
+	const struct attestation_evidence_object_request *objects;
+	size_t objects_count;
+};
+
+/**
+ * struct attestation_evidence_object_result - What a provider made of one object.
+ * @format: the layout it came in, one of the object's formats
+ * @length: bytes written
+ */
+struct attestation_evidence_object_result {
+	struct attestation_evidence_format format;
+	size_t length;
+};
+
+/**
+ * struct attestation_evidence_result - Provider evidence result.
+ * @objects: one for every requested object, in request order
+ */
+struct attestation_evidence_result {
+	struct attestation_evidence_object_result *objects;
+};
+
+/**
+ * struct attestation_provider - Immutable provider operations and properties.
+ * @evidence_get: produce requested evidence, each object written with
+ *	attestation_evidence_write() and its result filled in
+ * @mr_read: read one MR; every MR can be read, so required with @mrs
+ * @mr_extend: extend the banks of one MR it gets digests for, leaving the
+ *	others, or fail with -EOPNOTSUPP before changing any if it cannot
+ * @evidence_caps: evidence capabilities, or NULL
+ * @mrs: fixed MR properties
+ * @mrs_count: number of fixed MRs
+ */
+struct attestation_provider {
+	int (*evidence_get)(struct attestation_dev *att,
+			    const struct attestation_evidence_request *request,
+			    struct attestation_evidence_result *result);
+	int (*mr_read)(struct attestation_dev *att, unsigned int mr_id,
+		       struct attestation_digest_set *values);
+	int (*mr_extend)(struct attestation_dev *att, unsigned int mr_id,
+			 const struct attestation_digest_set *values);
+	const struct attestation_evidence_caps *evidence_caps;
+	const struct attestation_mr_props *mrs;
+	size_t mrs_count;
+};
+
+/**
+ * struct attestation_dev - One attestation device.
+ * @node: the device's node, whose release frees the driver's struct embedding
+ *	this
+ *
+ * A driver embeds this first in its own struct, allocated by
+ * attestation_alloc(), and reaches that struct with container_of().
+ */
+struct attestation_dev {
+	struct ctlv_device node;
+	/* private: */
+	struct ctlv ctlv;
+	const struct attestation_provider *provider;
+	unsigned int index;
+
+	/* Mutable instance state. */
+	struct mutex lock;
+
+};
+
+/* What a CTLV callback of a family inheriting ctlv-attestation was handed. */
+static inline struct attestation_dev *attestation_from_ctlv(struct ctlv *ctlv)
+{
+	return container_of(ctlv, struct attestation_dev, ctlv);
+}
+
+struct attestation_dev *_attestation_alloc(struct device *parent,
+					   const struct attestation_provider *provider,
+					   const struct ctlv_family *family, size_t size,
+					   size_t offset);
+
+/**
+ * attestation_alloc - Allocate a driver struct embedding an attestation device.
+ * @parent: the device attested
+ * @provider: provider operations and properties, which must outlive the device
+ * @family: the driver's CTLV family, which inherits ctlv-attestation
+ * @type: the driver's struct
+ * @member: its struct attestation_dev, the first member
+ *
+ * Return: the driver's struct, released by attestation_put(), or an error
+ * pointer.
+ */
+#define attestation_alloc(parent, provider, family, type, member)		\
+	((type *)_attestation_alloc(parent, provider, family, sizeof(type),	\
+				    offsetof(type, member)))
+
+int attestation_register(struct attestation_dev *att);
+void attestation_unregister(struct attestation_dev *att);
+void attestation_put(struct attestation_dev *att);
+
+int attestation_evidence_write(const struct attestation_evidence_object_request *object,
+			       const void *data, size_t length);
+#endif /* _LINUX_ATTESTATION_H */
-- 
2.56.0

