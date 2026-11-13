Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585366;
	b=X3SWntxDAQQNaYy04Yl4EsVPsBHtBbfzRVckYA7zdZUQfI7x/D7l8EGG9gx83QRGxXGq
	 Gq7DRx/CCFmhCPwFf2VrpGQKMI346UhhUAJbLijeg8wALX9kVo16eDNxf3Vfa/+LefXt+
	 Uek6VZ3SJi39Ku5HW5vCwnRT+3FKYxIh7qiDCoEZFZn9iYsiF0xouTvZuXj9zYkme96qD
	 /wcmfyLkpA3A0BSwN41Psu3SLJcCBPNOQPmtqPK6CybA3fw2VOS9piwxxsOJpoIIIezAB
	 c7Jetp749v5MM8LE8fgE2nUGugwG44zvc5P6G0u4JykZRi3Usw0T22SO1eJu0Zkpa6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585366;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iMA1nNIkTQMcLySN9HOcyafC2eBYLhJLhmGy3+ImBow=;
	b=uDEQHvilxsA1Y3jIzAttypsPPMbWMsl2JMWJkaX5PwGsodKfc1JX4OG91L1zlkSF+4X8
	 Iu2XafXdUh6SeapvWiBArdTbwwJlQbxbh4EkwKeEpckROag12KXopIxmMoyPvHdE/xXOF
	 02tjJk5cm5PXk/mdM8LG2xHpWWjvSdFPcbL5tU2vtogBpgCYjZ5j+juHaeVQT66alviT+
	 QRTovEyelNq3sNI3L6p1EIqbzxznrGmEfITOFwJ8Q8G1MQbSc4vSvxCEZxS2ExZI5VVku
	 EhepDBNBPnX4J9AgB5NJgglePGnJVKf3Rbr9CaMTjZxMJa+2ztyUYjgyuarfTdLhwiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=fnESBVWQ;
	arc=none smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5245C606EBA1
	for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 15:56:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5245C606EBA1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=fnESBVWQ
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c4cdc606b47so257322266b.0
        for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 07:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1794585364; x=1795190164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iMA1nNIkTQMcLySN9HOcyafC2eBYLhJLhmGy3+ImBow=;
        b=fnESBVWQ/TytaieR6uyuIGPSZ2YPt9JBZEB9DEBZxpgxOF61oXaeQdm4WW8hf9WKdn
         pzLPQzjBxaeN5+/bUQ76ice7VieryHAIzGarhQprtjnsQfEWJDDz8OyvjI0QYg/fZf6i
         lG9KotwrNfqb8IiPaK8n4tsr0VJfBkVzv9ZxQnO6FsrbyA/F3VK30EjObYP7xjzxecqe
         dFi3QAR7kFpGXFh93Hr/bwP6l7ohGPu1IIHZuy27kr459cY3Wptv2hCqR9E8G3xkXRjs
         0397gFj/F/7plD2yFafWoQ3UiqEEGin9AEoEpV6SbENT4ncrw4flcpbH1ZF4BEwSdxnm
         2eQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794585364; x=1795190164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iMA1nNIkTQMcLySN9HOcyafC2eBYLhJLhmGy3+ImBow=;
        b=uyPvPNhbLIL5OVC+mXyGWsUjOQh3xcNKs7IFZq+pDEHG9+C1nefT1zoJpwQLHrpTgN
         dLguV2EF6bgveFDZlYKc74frVQDwCVjzDW9BhNVxDRN9+U33U9saziJB5qbQM6jaOTld
         BVZkpd62/g5aR6V8TURegfcSWNVn1gPc0xW3djLonn57pT8MA0V0owIr7s5oKWVYQgKV
         /4E6N+SgSqVU1vBSgoFz1O8dRFyziSZt7b5p6JqUOdsx2DlIC5DALBcZbwoP2u1vH8oU
         FEZYgyDe4RGT3GTBjVaPJMa/0RcqZDeIjv/AoLqqsJJFNb2JP9WihZsicbfzvi5yKIOy
         izdA==
X-Forwarded-Encrypted: i=1; AL+hErG7YmzVfI1uFjIQ9Q9o9l2lCUcv+5Jz9Pv/9gPiRWz1JdAxlCPFB/C3YCoI3enV6Q1fZ/NmRwih8/w=@vger.kernel.org
X-Gm-Message-State: APuU4Z+kAicx+a9rowL6SO5mm1OdjXa3nMlQOu2THD85LnQpLrQ3oEJ8
	Tkox/qkIIiyNyRdk6yIY5zSzz59s0LiOBzqUccINjNMkelZ3IXdT4Y1juWBWmfwCOoI=
X-Gm-Gg: AYBFou3smqf63mFJ/DhvlScYetf1/pNdgy4FmI1BIB08ZQ7ZS9gwermpCuunDL5MY0k
	deA/PKU+jnjymctTELPIZDt1Jo3ssj6p2GFTlNtBk52PBBvX6zZqaBN+8GtRQ+soyWnd0Ucn4LT
	Q5Z0Q1ybLUtuedVkt+ko2z2zNNHor3VWWSxpd2i3yLHbr8GfXC+JxQwEnmG91Gu82zCCadOxR98
	ybEq3QE7CqYqMkvG6YBiF9iEf075UaEZmAcurNyiGLlnz9n3Qf4RvsbKRdG/upiKLbJPyal0Ljv
	9S2LHwn8y0j0VKKft7qX4v3yOQUz/+fW1UmBWYnx+gcDDVXZXzj4eh9/jcLqBEd3lE7C9URHjBH
	RswACv6fMjH3Dp2nuDwlHJIZ1NY2spiRqXZteGJlyIIdodaWdDmeVlVPLdrkhJB1ml/nzk3nGas
	KJ6lGpsT1UbOWs1XUZocsPkZFqXK3eeIb27fKzi1c4oocNsjutbkZvghOXFlZd8bYgQGTlqkPeD
	4F0tavPFyfezlhryvXfq/pqJKc/IZBVvxFWkwz+gi5aNjfJ9Xry2LCh6pHHyO5OGdcIj/s/MYt2
	eUkhf4+TfIHQvg8QaYDM/xv27EvlvUGFQFll1kbYWQ==
X-Received: by 2002:a17:906:99c2:b0:c29:4a1f:76be with SMTP id a640c23a62f3a-c50963adb21mr242543766b.20.1794585363416;
        Fri, 13 Nov 2026 07:56:03 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b9164bsm118044866b.82.2026.11.13.07.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 07:56:03 -0800 (PST)
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
Subject: [PATCH RFC v2 10/15] ctlv: Prepare runtime introspection
Date: Fri, 13 Nov 2026 16:55:09 +0100
Message-ID: <20261113155515.2510194-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113155515.2510194-1-jiri@resnulli.us>
References: <20261113155515.2510194-1-jiri@resnulli.us>
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

Add handlers that expose registered families, effective operations and
message schemas through the CTLV root family. Start struct ctlv with the
device, family, operations and op state they read.

The introspection object can be compile-checked here. CONFIG_CTLV
remains unwired until operation dispatch completes the module.

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- handed the introspection ops the CTLV instance
- reported each op's error information length
- emitted introspection fields without staging them
- kept each guard() on one line
- gave each dump cursor field its own mask and said what it holds
- took struct ctlv from the event patch, without the event state
- dropped the event record length from op-get
- renamed stubs to extension points
- made a check no error path depends on a CTLV_ASSERT()
- said TLV, type, record and field instead of attr
- said record instead of nest, the root being one
- said node instead of placement
- numbered every enum member
- reported the values the device's family chain gives an enum
  extension point
- moved to lib/ctlv/
---
 include/linux/ctlv.h     |  26 ++
 lib/ctlv/Makefile        |   3 +-
 lib/ctlv/internal.h      |   3 +
 lib/ctlv/introspection.c | 505 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 536 insertions(+), 1 deletion(-)
 create mode 100644 lib/ctlv/introspection.c

diff --git a/include/linux/ctlv.h b/include/linux/ctlv.h
index afb71cc643d3..3847f8411edf 100644
--- a/include/linux/ctlv.h
+++ b/include/linux/ctlv.h
@@ -7,6 +7,8 @@
 #ifndef _LINUX_CTLV_H
 #define _LINUX_CTLV_H
 
+#include <linux/device.h>
+#include <linux/spinlock_types.h>
 #include <linux/types.h>
 
 #include <uapi/ctlv/ctlv.h>
@@ -15,6 +17,7 @@ struct ctlv_family;
 struct ctlv;
 struct ctlv_msg;
 struct ctlv_op_ctx;
+struct ctlv_op_entry;
 struct ctlv_schema_tree;
 
 /**
@@ -57,6 +60,29 @@ struct ctlv_cursor {
 	bool progress;
 };
 
+/**
+ * struct ctlv - The CTLV state of one device, embedded by its subsystem.
+ * @dev: device whose release frees the structure embedding this instance;
+ *	every open file pins it
+ *
+ * A family callback is handed the instance and reaches its own state with
+ * container_of().
+ */
+struct ctlv {
+	struct device *dev;
+	/* private: */
+	const struct ctlv_family *family;
+
+	struct ctlv_op_entry *ops;
+	u32 ops_count;
+
+	/* Op publication and state writers, never the dispatch path. */
+	spinlock_t transition_lock;
+	u64 state_generation;
+	u32 dynamic_ops_count;
+	unsigned long *disabled;
+};
+
 void ctlv_record_end(struct ctlv_cursor *child);
 void ctlv_record_cancel(struct ctlv_cursor *child);
 
diff --git a/lib/ctlv/Makefile b/lib/ctlv/Makefile
index 4455062f83d7..76010d52dd8a 100644
--- a/lib/ctlv/Makefile
+++ b/lib/ctlv/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_CTLV) += ctlv.o
 
-ctlv-y += blob.o blob_desc.o builder.o message.o schema.o
+ctlv-y += blob.o blob_desc.o builder.o introspection.o message.o \
+	  schema.o
diff --git a/lib/ctlv/internal.h b/lib/ctlv/internal.h
index 1dbab9709261..2e1e36799a17 100644
--- a/lib/ctlv/internal.h
+++ b/lib/ctlv/internal.h
@@ -60,6 +60,7 @@ struct ctlv_query_fragment {
 };
 
 struct ctlv_op_ctx {
+	struct ctlv *ctlv;
 	const struct ctlv_family *family;
 	/* Compared against current and never followed: identity, not a hold. */
 	const struct task_struct *submitter;
@@ -79,4 +80,6 @@ struct ctlv_op_ctx {
 	struct ctlv_error error;
 };
 
+struct ctlv_op_entry *ctlv_op_find(struct ctlv *ctlv, u64 op_id);
+
 #endif /* _CTLV_INTERNAL_H */
diff --git a/lib/ctlv/introspection.c b/lib/ctlv/introspection.c
new file mode 100644
index 000000000000..d030debe69e3
--- /dev/null
+++ b/lib/ctlv/introspection.c
@@ -0,0 +1,505 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Root-family discovery queries and their fragmentation.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/bitmap.h>
+#include <linux/bits.h>
+#include <linux/cleanup.h>
+#include <linux/ctlv.h>
+#include <linux/ctlv_gen.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
+#include "internal.h"
+#include "schema.h"
+
+/* A cursor packs the entry and member where fragmentation resumes. */
+#define CTLV_INTROSPECTION_MEMBER_MASK GENMASK_U64(63, 48)
+#define CTLV_INTROSPECTION_ENTRY_MASK GENMASK_U64(47, 0)
+
+/*
+ * family-get: the entry is a family's position in the chain from the root,
+ * the member its next field. op-get: the entry indexes the published ops,
+ * the member is the next CTLV_INTROSPECTION_OP_FIELD_*.
+ */
+struct ctlv_introspection_dump_position {
+	u64 entry;
+	u32 member;
+};
+
+static void ctlv_introspection_dump_resume(struct ctlv_introspection_dump_position *pos, u64 cursor)
+{
+	pos->entry = FIELD_GET(CTLV_INTROSPECTION_ENTRY_MASK, cursor);
+	pos->member = FIELD_GET(CTLV_INTROSPECTION_MEMBER_MASK, cursor);
+}
+
+static u64 ctlv_introspection_dump_cursor(const struct ctlv_introspection_dump_position *pos)
+{
+	return FIELD_PREP(CTLV_INTROSPECTION_ENTRY_MASK, pos->entry) |
+	       FIELD_PREP(CTLV_INTROSPECTION_MEMBER_MASK, pos->member);
+}
+
+static bool ctlv_introspection_family_entry(struct ctlv_cursor *reply, struct ctlv_cursor *entry,
+					    const struct ctlv_family *family,
+					    struct ctlv_introspection_dump_position *pos)
+{
+	const struct ctlv_family_schema *schema = family->schema;
+
+	if (!ctlv_family_get_families_start(reply, entry))
+		return false;
+	if (pos->member == 0) {
+		if (!ctlv_family_get_families_id_put(entry, schema->family_id))
+			return false;
+		pos->member = 1;
+	}
+	if (pos->member == 1) {
+		if (!ctlv_family_get_families_name_put(entry, schema->name))
+			return false;
+		pos->member = 2;
+	}
+	ctlv_record_end(entry);
+	pos->member = 0;
+	return true;
+}
+
+int ctlv_family_get_query(struct ctlv *ctlv, struct ctlv_op_ctx *ctx,
+			  const struct ctlv_cursor *request, struct ctlv_cursor *reply)
+{
+	const struct ctlv_family *family = ctx->family;
+	u32 levels = ctlv_family_levels(family);
+	struct ctlv_cursor entry;
+	struct ctlv_introspection_dump_position pos;
+
+	ctlv_introspection_dump_resume(&pos, ctlv_op_query_cursor(ctx));
+	/* The immutable root-first chain always has generation zero. */
+	for (; pos.entry < levels; pos.entry++) {
+		const struct ctlv_family *ancestor =
+			ctlv_family_ancestor(family, levels - 1 - pos.entry);
+
+		if (!ctlv_introspection_family_entry(reply, &entry, ancestor, &pos))
+			return ctlv_op_query_more(ctx, 0, ctlv_introspection_dump_cursor(&pos));
+	}
+	return ctlv_op_query_done(ctx, 0);
+}
+
+/* Snapshot published-op state and generation once per fragment. */
+struct ctlv_op_snapshot {
+	unsigned long *disabled;
+	u64 generation;
+};
+
+static int ctlv_introspection_snapshot_take(struct ctlv *ctlv,
+					    struct ctlv_op_snapshot *snapshot)
+{
+	if (ctlv->dynamic_ops_count) {
+		snapshot->disabled = bitmap_zalloc(ctlv->dynamic_ops_count, GFP_KERNEL);
+		if (!snapshot->disabled)
+			return -ENOMEM;
+	}
+	guard(spinlock)(&ctlv->transition_lock);
+	snapshot->generation = ctlv->state_generation;
+	if (snapshot->disabled)
+		bitmap_copy(snapshot->disabled, ctlv->disabled, ctlv->dynamic_ops_count);
+	return 0;
+}
+
+static bool ctlv_introspection_op_disabled(const struct ctlv_op_snapshot *snapshot,
+					   const struct ctlv_op_entry *op)
+{
+	if (op->state_index == CTLV_OP_STATE_NONE)
+		return false;
+	return test_bit(op->state_index, snapshot->disabled);
+}
+
+/* Report effective lengths, including descendant fills. */
+enum ctlv_introspection_op_field {
+	CTLV_INTROSPECTION_OP_FIELD_ID = 0,
+	CTLV_INTROSPECTION_OP_FIELD_TYPE = 1,
+	CTLV_INTROSPECTION_OP_FIELD_AVAILABILITY = 2,
+	CTLV_INTROSPECTION_OP_FIELD_DISABLED = 3,
+	CTLV_INTROSPECTION_OP_FIELD_REQUEST_MAX_LEN = 4,
+	CTLV_INTROSPECTION_OP_FIELD_ACTION_REPLY_MAX_LEN = 5,
+	CTLV_INTROSPECTION_OP_FIELD_QUERY_REPLY_MIN_LEN = 6,
+	CTLV_INTROSPECTION_OP_FIELD_QUERY_REPLY_SUGGESTED_LEN = 7,
+	CTLV_INTROSPECTION_OP_FIELD_FD_ACCESS = 8,
+	CTLV_INTROSPECTION_OP_FIELD_ERROR_INFO_MAX_LEN = 9,
+	CTLV_INTROSPECTION_OP_FIELD_END = 10,
+};
+
+static bool ctlv_introspection_op_field_put(struct ctlv_cursor *entry,
+					    const struct ctlv_op_snapshot *snapshot,
+					    const struct ctlv_op_entry *op, u32 member)
+{
+	const struct ctlv_op_sizes *sizes = &op->sizes;
+
+	switch (member) {
+	case CTLV_INTROSPECTION_OP_FIELD_ID:
+		return ctlv_op_get_ops_id_put(entry, op->schema->op_id);
+	case CTLV_INTROSPECTION_OP_FIELD_TYPE:
+		return ctlv_op_get_ops_type_put(entry, op->schema->type);
+	case CTLV_INTROSPECTION_OP_FIELD_AVAILABILITY:
+		return ctlv_op_get_ops_availability_put(entry, op->schema->availability);
+	case CTLV_INTROSPECTION_OP_FIELD_DISABLED:
+		return ctlv_op_get_ops_disabled_put(entry,
+						    ctlv_introspection_op_disabled(snapshot, op));
+	case CTLV_INTROSPECTION_OP_FIELD_REQUEST_MAX_LEN:
+		return ctlv_op_get_ops_request_max_len_put(entry, sizes->request_max_len);
+	case CTLV_INTROSPECTION_OP_FIELD_ACTION_REPLY_MAX_LEN:
+		/* Zero is a reply that acknowledges and no more. */
+		return ctlv_op_get_ops_action_reply_max_len_put(entry,
+								sizes->action_reply_max_len);
+	case CTLV_INTROSPECTION_OP_FIELD_QUERY_REPLY_MIN_LEN:
+		return ctlv_op_get_ops_query_reply_min_len_put(entry, sizes->query_reply_min_len);
+	case CTLV_INTROSPECTION_OP_FIELD_QUERY_REPLY_SUGGESTED_LEN:
+		return ctlv_op_get_ops_query_reply_suggested_len_put(
+			entry, sizes->query_reply_suggested_len);
+	case CTLV_INTROSPECTION_OP_FIELD_FD_ACCESS:
+		return ctlv_op_get_ops_fd_access_put(entry, op->schema->fd_access);
+	default:
+		return ctlv_op_get_ops_error_info_max_len_put(entry, CTLV_ERROR_INFO_MAX_LEN);
+	}
+}
+
+static bool ctlv_introspection_op_field_applies(const struct ctlv_op_entry *op, u32 member)
+{
+	switch (member) {
+	case CTLV_INTROSPECTION_OP_FIELD_ID:
+	case CTLV_INTROSPECTION_OP_FIELD_TYPE:
+	case CTLV_INTROSPECTION_OP_FIELD_AVAILABILITY:
+	case CTLV_INTROSPECTION_OP_FIELD_DISABLED:
+	case CTLV_INTROSPECTION_OP_FIELD_REQUEST_MAX_LEN:
+	case CTLV_INTROSPECTION_OP_FIELD_FD_ACCESS:
+	case CTLV_INTROSPECTION_OP_FIELD_ERROR_INFO_MAX_LEN:
+		return true;
+	case CTLV_INTROSPECTION_OP_FIELD_ACTION_REPLY_MAX_LEN:
+		return op->schema->type == CTLV_OP_TYPE_ACTION;
+	default:
+		return op->schema->type == CTLV_OP_TYPE_QUERY;
+	}
+}
+
+static bool ctlv_introspection_op_entry(struct ctlv_cursor *reply, struct ctlv_cursor *entry,
+					const struct ctlv_op_snapshot *snapshot,
+					const struct ctlv_op_entry *op,
+					struct ctlv_introspection_dump_position *pos)
+{
+	if (!ctlv_op_get_ops_start(reply, entry))
+		return false;
+	for (; pos->member < CTLV_INTROSPECTION_OP_FIELD_END; pos->member++) {
+		if (!ctlv_introspection_op_field_applies(op, pos->member))
+			continue;
+		if (!ctlv_introspection_op_field_put(entry, snapshot, op, pos->member))
+			return false;
+	}
+	ctlv_record_end(entry);
+	pos->member = 0;
+	return true;
+}
+
+int ctlv_op_get_query(struct ctlv *ctlv, struct ctlv_op_ctx *ctx,
+		      const struct ctlv_cursor *request, struct ctlv_cursor *reply)
+{
+	struct ctlv_op_snapshot snapshot = {};
+	struct ctlv_cursor entry;
+	struct ctlv_introspection_dump_position pos;
+	int ret;
+
+	ret = ctlv_introspection_snapshot_take(ctlv, &snapshot);
+	if (ret)
+		return ret;
+	unsigned long *disabled __free(bitmap) = snapshot.disabled;
+
+	/* The published index is immutable, so a cursor into it holds. */
+	ctlv_introspection_dump_resume(&pos, ctlv_op_query_cursor(ctx));
+	for (; pos.entry < ctlv->ops_count; pos.entry++)
+		if (!ctlv_introspection_op_entry(reply, &entry, &snapshot,
+						 &ctlv->ops[pos.entry], &pos))
+			return ctlv_op_query_more(ctx, snapshot.generation,
+						  ctlv_introspection_dump_cursor(&pos));
+	return ctlv_op_query_done(ctx, snapshot.generation);
+}
+
+/* A leaf-count cursor permits a fragment boundary at any tree depth. */
+
+/* One record of the description, standing for one node of the schema. */
+struct ctlv_introspection_frame {
+	struct ctlv_cursor record;
+	u64 type;
+	bool open;
+	/* Which node this stands for, so that a re-entry can be measured. */
+	const struct ctlv_schema_tree *tree;
+	u32 node;
+};
+
+/* The frames outlive the walk, as a fragment's open records must stay alive. */
+struct ctlv_introspection_walk {
+	const struct ctlv_family *family;
+	struct ctlv_cursor *root;
+	struct ctlv_introspection_frame *frames;
+	u64 ordinal;
+	u64 resume;
+	int error;
+};
+
+/* A record is opened by the first thing written inside it. */
+static bool ctlv_introspection_open(struct ctlv_introspection_walk *walk, u32 depth)
+{
+	struct ctlv_introspection_frame *frame = &walk->frames[depth];
+	struct ctlv_cursor *up = walk->root;
+
+	if (frame->open)
+		return true;
+	if (depth) {
+		if (!ctlv_introspection_open(walk, depth - 1))
+			return false;
+		up = &walk->frames[depth - 1].record;
+	}
+	if (!ctlv_record_start(up, &frame->record, frame->type, CTLV_SCHEMA_RECORD))
+		return false;
+	frame->open = true;
+	return true;
+}
+
+/* Skipped leaves advance the ordinal; a failed write remains the resume point. */
+static bool ctlv_introspection_put(struct ctlv_introspection_walk *walk, u32 depth, u64 type,
+				   u8 kind, u64 value)
+{
+	struct ctlv_cursor *record = &walk->frames[depth].record;
+	bool ok;
+
+	if (walk->ordinal < walk->resume) {
+		walk->ordinal++;
+		return true;
+	}
+	if (!ctlv_introspection_open(walk, depth))
+		return false;
+	if (kind == CTLV_SCHEMA_SINT)
+		ok = ctlv_put_s64(record, type, kind, value);
+	else
+		ok = ctlv_put_u64(record, type, kind, value);
+	if (!ok)
+		return false;
+	walk->ordinal++;
+	return true;
+}
+
+static bool ctlv_introspection_uint(struct ctlv_introspection_walk *walk, u32 depth, u64 type,
+				    u64 value)
+{
+	return ctlv_introspection_put(walk, depth, type, CTLV_SCHEMA_UINT, value);
+}
+
+/* Emit only constraints for this node's schema kind. */
+static bool ctlv_introspection_node_fields(struct ctlv_introspection_walk *walk, u32 depth,
+					   const struct ctlv_node_schema *node, u32 reenters)
+{
+	if (!ctlv_introspection_uint(walk, depth, CTLV_T_SCHEMA_NODE_TYPE, node->type) ||
+	    !ctlv_introspection_uint(walk, depth, CTLV_T_SCHEMA_NODE_KIND, node->kind) ||
+	    !ctlv_introspection_uint(walk, depth, CTLV_T_SCHEMA_NODE_MAX_OCCURRENCES,
+				     node->max_occurrences))
+		return false;
+
+	switch (node->kind) {
+	case CTLV_SCHEMA_ENUM:
+		/* An extension point's maximum is 0 when nothing filled it. */
+		if (!ctlv_introspection_uint(walk, depth, CTLV_T_SCHEMA_NODE_MIN,
+					     node->is_enum_ext ? 1 : node->range.min) ||
+		    !ctlv_introspection_uint(walk, depth, CTLV_T_SCHEMA_NODE_MAX,
+					     ctlv_schema_enum_max(walk->family, node)))
+			return false;
+		break;
+	case CTLV_SCHEMA_UINT:
+	case CTLV_SCHEMA_SINT:
+		if (!ctlv_introspection_uint(walk, depth, CTLV_T_SCHEMA_NODE_MIN,
+					     node->range.min) ||
+		    !ctlv_introspection_uint(walk, depth, CTLV_T_SCHEMA_NODE_MAX,
+					     node->range.max))
+			return false;
+		break;
+	case CTLV_SCHEMA_FLAGS:
+		if (!ctlv_introspection_uint(walk, depth, CTLV_T_SCHEMA_NODE_FLAGS_MASK,
+					     node->flags_mask))
+			return false;
+		break;
+	case CTLV_SCHEMA_STRING:
+	case CTLV_SCHEMA_BINARY:
+		if (!ctlv_introspection_uint(walk, depth, CTLV_T_SCHEMA_NODE_MIN_LENGTH,
+					     node->length.min_len) ||
+		    !ctlv_introspection_uint(walk, depth, CTLV_T_SCHEMA_NODE_MAX_LENGTH,
+					     node->length.max_len))
+			return false;
+		break;
+	case CTLV_SCHEMA_BLOB:
+		if (!ctlv_introspection_put(walk, depth, CTLV_T_SCHEMA_NODE_BLOB_DIRECTION,
+					    CTLV_SCHEMA_ENUM, node->blob.direction) ||
+		    !ctlv_introspection_uint(walk, depth, CTLV_T_SCHEMA_NODE_BLOB_BACKINGS,
+					     node->blob.backings) ||
+		    !ctlv_introspection_uint(walk, depth, CTLV_T_SCHEMA_NODE_BLOB_MAX_LENGTH,
+					     node->blob.max_len) ||
+		    !ctlv_introspection_uint(walk, depth, CTLV_T_SCHEMA_NODE_BLOB_ALIGNMENT,
+					     node->blob.alignment))
+			return false;
+		break;
+	default:
+		break;
+	}
+
+	if (node->unit != CTLV_UNIT_NONE &&
+	    (!ctlv_introspection_uint(walk, depth, CTLV_T_SCHEMA_NODE_UNIT, node->unit) ||
+	     !ctlv_introspection_put(walk, depth, CTLV_T_SCHEMA_NODE_SCALE, CTLV_SCHEMA_SINT,
+				     node->scale)))
+		return false;
+	return !reenters ||
+	       ctlv_introspection_uint(walk, depth, CTLV_T_SCHEMA_NODE_REENTERS, reenters);
+}
+
+/* Re-entry targets an ancestor with the same child range. */
+static u32 ctlv_introspection_reenters(struct ctlv_introspection_walk *walk, u32 depth,
+				       const struct ctlv_schema_tree *tree,
+				       const struct ctlv_node_schema *node)
+{
+	u32 levels;
+
+	for (levels = 1; levels <= depth; levels++) {
+		const struct ctlv_introspection_frame *up = &walk->frames[depth - levels];
+
+		if (up->tree == tree &&
+		    tree->node_schemas[up->node].first_child == node->first_child)
+			return levels;
+	}
+	/* A back edge to nothing is metadata this core cannot describe. */
+	CTLV_ASSERT(0);
+	walk->error = -EINVAL;
+	return 0;
+}
+
+static bool ctlv_introspection_node(struct ctlv_introspection_walk *walk, u32 depth,
+				    const struct ctlv_schema_tree *tree, u32 index);
+
+/* The members of a fill inherit the optionality of its extension point. */
+static bool ctlv_introspection_children(struct ctlv_introspection_walk *walk, u32 depth,
+					const struct ctlv_schema_tree *tree, u32 index,
+					bool force_optional)
+{
+	const struct ctlv_node_schema *node = &tree->node_schemas[index];
+	u32 i;
+
+	if (WARN_ON_ONCE(depth + 1 >= CTLV_MAX_RECORD_DEPTH)) {
+		/* Deeper than a specification may declare, so unreachable. */
+		walk->error = -EINVAL;
+		return false;
+	}
+	for (i = 0; i < node->children_count; i++) {
+		u32 child = node->first_child + i;
+		bool required = !force_optional && i < node->required_children_count;
+
+		walk->frames[depth + 1] = (struct ctlv_introspection_frame){
+			.type = required ? CTLV_T_SCHEMA_NODE_FIELDS :
+					      CTLV_T_SCHEMA_NODE_OPTIONAL_FIELDS,
+			.tree = tree,
+			.node = child,
+		};
+		if (!ctlv_introspection_node(walk, depth + 1, tree, child))
+			return false;
+	}
+	for (i = 0; i < tree->ext_schemas_count; i++) {
+		const struct ctlv_ext_schema *ext_schema = &tree->ext_schemas[i];
+		const struct ctlv_ext_fill_schema *fill_schema;
+
+		if (ext_schema->node != index)
+			continue;
+		fill_schema =
+			ctlv_schema_fill(walk->family, ext_schema->family_id, ext_schema->ext_id);
+		/* Nothing of this chain filled it, so it contributes none. */
+		if (!fill_schema)
+			continue;
+		/* Its root is the extension point, its children the members. */
+		if (!ctlv_introspection_children(walk, depth, &fill_schema->members, 0,
+						 force_optional || ext_schema->optional))
+			return false;
+	}
+	return true;
+}
+
+/* One node, into the record that stands for it. */
+static bool ctlv_introspection_node(struct ctlv_introspection_walk *walk, u32 depth,
+				    const struct ctlv_schema_tree *tree, u32 index)
+{
+	const struct ctlv_node_schema *node = &tree->node_schemas[index];
+	u32 reenters = 0;
+
+	if (node->reenters) {
+		reenters = ctlv_introspection_reenters(walk, depth, tree, node);
+		if (!reenters)
+			return false;
+	}
+	if (!ctlv_introspection_node_fields(walk, depth, node, reenters))
+		return false;
+	/*
+	 * A node that re-enters a level says so instead of listing that level's
+	 * members again, which is what makes unbounded depth describable.
+	 */
+	if (!node->reenters && !ctlv_introspection_children(walk, depth, tree, index, false))
+		return false;
+	if (walk->frames[depth].open)
+		ctlv_record_end(&walk->frames[depth].record);
+	return true;
+}
+
+/* One of the two messages of an op, the root of it being a node like any. */
+static bool ctlv_introspection_message(struct ctlv_introspection_walk *walk, u64 type,
+				       const struct ctlv_schema_tree *tree)
+{
+	/* An op without such a message has nothing to describe. */
+	if (!tree->node_schemas)
+		return true;
+	walk->frames[0] = (struct ctlv_introspection_frame){
+		.type = type,
+		.tree = tree,
+	};
+	return ctlv_introspection_node(walk, 0, tree, 0);
+}
+
+int ctlv_op_schema_get_query(struct ctlv *ctlv, struct ctlv_op_ctx *ctx,
+			     const struct ctlv_cursor *request, struct ctlv_cursor *reply)
+{
+	struct ctlv_introspection_walk walk = {
+		.family = ctx->family,
+		.root = reply,
+		.resume = ctlv_op_query_cursor(ctx),
+	};
+	const struct ctlv_op_entry *op;
+
+	/* Describe published ops regardless of current dynamic state. */
+	op = ctlv_op_find(ctx->ctlv, ctlv_op_schema_get_id_get(request));
+	if (!op)
+		return -EOPNOTSUPP;
+
+	/*
+	 * One frame per level the reply may reach, too many for the stack: a
+	 * description is one level deeper than the message it describes.
+	 */
+	struct ctlv_introspection_frame *frames __free(kfree) =
+		kcalloc(CTLV_MAX_RECORD_DEPTH, sizeof(*frames), GFP_KERNEL);
+
+	if (!frames)
+		return -ENOMEM;
+	walk.frames = frames;
+
+	if (!ctlv_introspection_message(&walk, CTLV_T_OP_SCHEMA_GET_REQUEST,
+					&op->schema->request) ||
+	    !ctlv_introspection_message(&walk, CTLV_T_OP_SCHEMA_GET_REPLY,
+					&op->schema->reply)) {
+		if (walk.error)
+			return walk.error;
+		/* A schema is immutable, so there is nothing to be stale. */
+		return ctlv_op_query_more(ctx, 0, walk.ordinal);
+	}
+	return ctlv_op_query_done(ctx, 0);
+}
-- 
2.56.0

