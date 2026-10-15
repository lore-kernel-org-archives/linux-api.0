Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026B5529412
	for <linux-api@vger.kernel.org>; Thu, 15 Oct 2026 14:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075888; cv=none; b=Z1NR+dw0BXE4k2UWUN8FDLJhP4xpLh2Txj/kGIRRU0cDS9S0qwNzMEtxiA+/mSHKL5cXbfwJT0IJhQKyguwNO8axZawu+GxWLyDvJlABOecKS9lLKrw4BeJ+2H9jX7b3esd0Seum7CC3kkXZ1eveBut25IwSYkJvTDB1dVuu6/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075888; c=relaxed/simple;
	bh=VTpo5ZReKi6aUeoYA7BClj2A3JUFHeXh9bZfnZxoBwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBA0khEECoX7k1jPXb9SYK0I4kzjL8bylNHKJ1739YSd4ZYIyQuNnF4Eqt6BrXt7Zkbz0KI/Fovb73z7YWPooYigsDvPWRxaUG+0MD6BIa9EFwyVTmtLRTd655tVqdKzMQrxnwm7/zH3dhloDSSdmr2N0aCdPNnrTPWs00F5MmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=GgWpBPO4; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="GgWpBPO4"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c3f8d72d7ceso105653466b.3
        for <linux-api@vger.kernel.org>; Thu, 15 Oct 2026 07:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1792075884; x=1792680684; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yYfTJ5hv9EMwutjH+FlT+/ZfnsL6STQjw/HcZoZEibo=;
        b=GgWpBPO4E98j1bU3Las7AMJ1w58CTUUG09/K6io1hSDHtC++JEl+cx+37MHMykOVk6
         IxflkK8TlvHfdJgdY2JW9SFWxC/WjmchWlknZn4U7EjTa1TEzlaqUaxKhPhtt9hHouUi
         mAeoCoU9XZ/1XitM4NLcui063oZZ8RJAv1M443doxXAoFj9GuEUaduhgprgKhGze/oE/
         y4ipmUBth/oVB77P+0AebPy5Wsk+e/JKVKqlXMAC2OQXoZmgqPXNhm/B3iuHT3zSDkr3
         ejyau32foa00GlxrNcnrebL9et4a7xBSRIzJBvx22JYDvtKON/Idasj0wlzEPedIT7Jw
         BLkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075884; x=1792680684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yYfTJ5hv9EMwutjH+FlT+/ZfnsL6STQjw/HcZoZEibo=;
        b=tHpTtefyS3bluf1JTDPKDXO+vWq8aJNNkcv6uGrYbAG2MSMj8QmRfLumQuXqoVoslu
         x+uHaEJxIedaOw8W8tNX3Y9c9wgbrMJMv2tbDD7T7GpJAdjLd597joHYMey66ebCibWg
         LhNBn3GtHinVSmjQQtizXA2WrwIKx5nYMT4IiLlrf3eYF/8GoR3BIT+pJ4ywAWAhrgnZ
         7t5JNiMFTH3LA9Ak32odWBacHKE//+GF1Vl0/yiKDQsez3JXYsauew6myY1TfxWFQWYG
         RE0ZoIe1dihkR0jfVxjurntxaROqxReZnBC/7JsyIttLcX1HNeRapSNAP2oToMnaYPR8
         /9jA==
X-Forwarded-Encrypted: i=1; AKwUvBzTLBXb8Esw8EsVHOke6omGv9dsEbz5sEPh9yzXUvY7+kUgViF3dBx2YxArIRoZsYsR3AwOM1MW7eE=@vger.kernel.org
X-Gm-Message-State: AFq9FYLxLxOJtSJR7MoSigFD5z326Wl/Tcy1UyV5RtvEBjgmSbpDxy3S
	3wxn8VLKxNfntxBcFfNRW6pgtoBJba9KZsNtMWOyMd+c2t8AQS+wFoNdk1Jf3D8y1fU=
X-Gm-Gg: AYBFou2Qn1rGTfPJQp9pDUTKxMyHAEkenvAoBzrwonqw55AhECBWlT7lDHnftaUcl7O
	pDqsgOmyadbJje6GJdVHOhZfkQyoLJ9qiMW7HYE6ZQ27TFxfZ1Pqwxo8gCB/dWtMbAWP5SDBZ98
	HEkk9qHsdhkXQCJ9sQGCr/WsDrihlBqeEBVFmKYmZfGgGhcgvDN3eFY+HfkYdVoTInhL5kmet9q
	pyLVRtkkImzkJaFxB8yv+/lv9rPSBRdawh/9sAzM0w+FvnNoVx53KZoKa9VX7Fg8Woswd8RK8i3
	wDZgsWG4fsHn1dXrc2I+NV3aQbIkJ6Q8fimfpoIEy88hRMwJGxO3a8N5s/kXxBtFzQfS92fhptB
	jY0vzAV6dnA1Az9/NYMpPvfJaKvfdkVM2caD7GUsbN6pXU57BTxN+Fk//7chqoPPMEZwmC1PoyR
	Ckuj5iE6+17vnBCK9xG0g1Kg4JDk4QFVMmDaG6/Nge0ey+UNNPAN9df4+EJvKxvfJFfAdeadXO3
	s1dXNJtJg==
X-Received: by 2002:a17:907:948f:b0:c35:3880:773b with SMTP id a640c23a62f3a-c3538807e2bmr1079685366b.45.1792075884192;
        Thu, 15 Oct 2026 07:51:24 -0700 (PDT)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3fd83464a7sm40271366b.76.2026.10.15.07.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:51:23 -0700 (PDT)
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
Subject: [PATCH RFC 06/20] ctlv: Prepare blob descriptor validation
Date: Thu, 15 Oct 2026 16:50:39 +0200
Message-ID: <20261015145053.3664509-7-jiri@resnulli.us>
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

Add parsing and VA checks for blob descriptors shared by schema
validation and runtime acquisition.

Keep CONFIG_CTLV unwired until dispatch completes the module.

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/ctlv/Makefile    |   2 +-
 drivers/ctlv/blob_desc.c | 102 +++++++++++++++++++++++++++++++++++++++
 drivers/ctlv/blob_desc.h |  29 +++++++++++
 3 files changed, 132 insertions(+), 1 deletion(-)
 create mode 100644 drivers/ctlv/blob_desc.c
 create mode 100644 drivers/ctlv/blob_desc.h

diff --git a/drivers/ctlv/Makefile b/drivers/ctlv/Makefile
index 4f0fe41bc9e1..5edc0b4b973f 100644
--- a/drivers/ctlv/Makefile
+++ b/drivers/ctlv/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_CTLV) += ctlv.o
 
-ctlv-y += message.o
+ctlv-y += blob_desc.o message.o
diff --git a/drivers/ctlv/blob_desc.c b/drivers/ctlv/blob_desc.c
new file mode 100644
index 000000000000..b84be3d723ab
--- /dev/null
+++ b/drivers/ctlv/blob_desc.c
@@ -0,0 +1,102 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Blob descriptor parsing and validation.
+ */
+#include <linux/align.h>
+#include <linux/bits.h>
+#include <linux/overflow.h>
+#include <linux/types.h>
+
+#include <uapi/linux/ctlv.h>
+#include <uapi/linux/ctlv_gen.h>
+
+#include "blob_desc.h"
+#include "message.h"
+
+static int ctlv_blob_member(u64 attr_id)
+{
+	switch (attr_id) {
+	case CTLV_ATTR_BLOB_TYPE:
+		return CTLV_BLOB_MEMBER_TYPE;
+	case CTLV_ATTR_BLOB_ADDRESS:
+		return CTLV_BLOB_MEMBER_ADDRESS;
+	case CTLV_ATTR_BLOB_FD:
+		return CTLV_BLOB_MEMBER_FD;
+	case CTLV_ATTR_BLOB_OFFSET:
+		return CTLV_BLOB_MEMBER_OFFSET;
+	case CTLV_ATTR_BLOB_LENGTH:
+		return CTLV_BLOB_MEMBER_LENGTH;
+	default:
+		return -1;
+	}
+}
+
+u32 ctlv_blob_desc_read(const struct ctlv_attr *blob, struct ctlv_blob_desc *desc,
+			const struct ctlv_attr **bad)
+{
+	const struct ctlv_attr *child = NULL;
+	enum ctlv_message_step step;
+
+	*desc = (struct ctlv_blob_desc){};
+	while ((step = ctlv_message_next(blob, &child)) == CTLV_MESSAGE_STEP_ATTR) {
+		int member = ctlv_blob_member(child->attr_id);
+
+		*bad = child;
+		if (child->flags & ~CTLV_ATTR_F_NESTED)
+			return CTLV_VALIDATION_REASON_UNKNOWN_FLAG;
+		if (child->flags & CTLV_ATTR_F_NESTED)
+			return CTLV_VALIDATION_REASON_MALFORMED_MESSAGE;
+		if (member < 0)
+			return CTLV_VALIDATION_REASON_UNKNOWN_ATTR;
+		if (ctlv_message_attr_payload_len(child) != sizeof(u64))
+			return CTLV_VALIDATION_REASON_BAD_LENGTH;
+		if (desc->present & BIT(member))
+			return CTLV_VALIDATION_REASON_BAD_BLOB_DESCRIPTOR;
+		desc->present |= BIT(member);
+		desc->member[member] = *(const u64 *)ctlv_message_attr_payload(child);
+	}
+	*bad = NULL;
+	if (step == CTLV_MESSAGE_STEP_BAD)
+		return CTLV_VALIDATION_REASON_MALFORMED_MESSAGE;
+	return 0;
+}
+
+static u32 ctlv_blob_variant(const struct ctlv_blob_desc *desc)
+{
+	u32 required = BIT(CTLV_BLOB_MEMBER_TYPE) | BIT(CTLV_BLOB_MEMBER_LENGTH);
+
+	switch (desc->member[CTLV_BLOB_MEMBER_TYPE]) {
+	case CTLV_BLOB_TYPE_VA:
+		required |= BIT(CTLV_BLOB_MEMBER_ADDRESS);
+		break;
+	default:
+		return CTLV_VALIDATION_REASON_BAD_BLOB_DESCRIPTOR;
+	}
+	if (desc->present != required)
+		return CTLV_VALIDATION_REASON_BAD_BLOB_DESCRIPTOR;
+	return 0;
+}
+
+u32 ctlv_blob_desc_check(const struct ctlv_blob_desc *desc, const struct ctlv_node_schema *node)
+{
+	u64 start, length, end;
+	u32 reason;
+
+	reason = ctlv_blob_variant(desc);
+	if (reason)
+		return reason;
+	if (!(node->blob.backings & BIT(desc->member[CTLV_BLOB_MEMBER_TYPE])))
+		return CTLV_VALIDATION_REASON_BAD_BLOB_DESCRIPTOR;
+
+	length = desc->member[CTLV_BLOB_MEMBER_LENGTH];
+	if (!length || length > node->blob.max_len)
+		return CTLV_VALIDATION_REASON_BAD_BLOB_DESCRIPTOR;
+	start = desc->member[desc->present & BIT(CTLV_BLOB_MEMBER_ADDRESS) ?
+				     CTLV_BLOB_MEMBER_ADDRESS :
+				     CTLV_BLOB_MEMBER_OFFSET];
+	if (!IS_ALIGNED(start, node->blob.alignment) || check_add_overflow(start, length, &end))
+		return CTLV_VALIDATION_REASON_BAD_BLOB_DESCRIPTOR;
+	return 0;
+}
diff --git a/drivers/ctlv/blob_desc.h b/drivers/ctlv/blob_desc.h
new file mode 100644
index 000000000000..27f77af16f01
--- /dev/null
+++ b/drivers/ctlv/blob_desc.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _CTLV_BLOB_DESC_H
+#define _CTLV_BLOB_DESC_H
+
+#include <linux/ctlv_family.h>
+#include <linux/types.h>
+
+#include <uapi/linux/ctlv.h>
+
+/* The members of a descriptor, in the order the root family declares them. */
+enum {
+	CTLV_BLOB_MEMBER_TYPE,
+	CTLV_BLOB_MEMBER_ADDRESS,
+	CTLV_BLOB_MEMBER_FD,
+	CTLV_BLOB_MEMBER_OFFSET,
+	CTLV_BLOB_MEMBER_LENGTH,
+	CTLV_BLOB_MEMBERS,
+};
+
+struct ctlv_blob_desc {
+	u64 member[CTLV_BLOB_MEMBERS];
+	u32 present;
+};
+
+u32 ctlv_blob_desc_read(const struct ctlv_attr *blob, struct ctlv_blob_desc *desc,
+			const struct ctlv_attr **bad);
+u32 ctlv_blob_desc_check(const struct ctlv_blob_desc *desc, const struct ctlv_node_schema *node);
+
+#endif /* _CTLV_BLOB_DESC_H */
-- 
2.56.0

