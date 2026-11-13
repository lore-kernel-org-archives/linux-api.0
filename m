Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585359;
	b=A6psqcCeREfO9Fg5TcmxWEWWyRM/qz0+vVwqflI7oTlrwG5MVf6dm41LqkqgAP/opGgP
	 rJheUXET1p28QigGkpLLRX8Hh+24BGWyahbFCtOV8VrxPZEOxy001HjXTBsyM7EvgSI3W
	 wLCe6X9msLweWkOwE278vOs4xoBNHFMHZD7tzaTi2wHbLqldAnFJRx8VWYtLwMZTUpaUW
	 N9hmt2grbZvY0vsC6pyKly22V46Ng+EySVpcaDRJm6UfT73NEXxF2LemPz/LY190a+Uj2
	 WRteKlJPNqHhzc8FzWM4Hkd8K2F12PeDI7xDI9/b+45YS2loLLPeo8prVcGPEeMaPcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585359;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zmnF/kKy5Wrp/bNacpeMudszRd8TJ6e7PGiKCMlvKU0=;
	b=BraXefvvbRNwjaYhQxwyXEAASSJ0yUqeqg8T8miwsxlk6pNiCn+yPng+fLR4cCFEZD8s
	 AzCAX/ROmMvbQ/IX3fLys+il1vXDy2xWwnFUHpsfDhKGymjSuwhKcyy2fpM7pa2H9yuYB
	 U6Wzed5Tn+4wtkFUjpnS1rSblTaKGlpxqRAZ4IajL4d4MU8N8kyPiez94vlmzu3Cn/Z8g
	 JplbLLvBnFka2OS+hU6x0Ibwz6q0qOVruk5ZjiVt1LlZsaoycNMI+ijYM0ldEA1Z/GltA
	 oyAnlfxqMGtvG9hiu8aTDqrwQq0tkFQ/G5cYUpTq4rljkpo/bpat33ZqAUtXHJHEa3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=vtxciYmI;
	arc=none smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BDC60A6F45
	for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 15:55:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38BDC60A6F45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=vtxciYmI
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b571979178so2358501a12.2
        for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 07:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1794585357; x=1795190157; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zmnF/kKy5Wrp/bNacpeMudszRd8TJ6e7PGiKCMlvKU0=;
        b=vtxciYmI3XbyL+6FWXOzsSBZKp5WSwBXGvNkKy0cfALpSMnwfj+tafUfpEE6zL1XaW
         BA4zYqKzQ+bPP8E9eaDUtIWZ1n7cgHdLgOWLgftT+3Jl3Ot1mYkzVwXtQzDqR/janNDV
         emvynbEcQAOEBn9XeLFnlU+lzjL1rGTYDB4aE+ddoTjk2Tfv1Nbg8DoF1LqAt+nr2qDt
         iBlsq+jnqypI+/dTIlb99J3asrAqIKdy4CdRVy6PEyGNeX1ifEhWfY9o0otIyZMYJKMB
         vBZtVQJ81Lc2cFMi7ip6A52qZpu/uF1mVuxr8dLVxDanxP0kpHlO3DzWyiXIgAFQ2oSK
         jVjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794585357; x=1795190157;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zmnF/kKy5Wrp/bNacpeMudszRd8TJ6e7PGiKCMlvKU0=;
        b=dBdfT3LjJYxBx95OAJzPoxOKVpN9wcGi3J/Yp7idlrvWgIqHqByXWdGGoFkiKL22jU
         bw2nfHdA6dfCJ8eVzbG1BJnN0rFIsIsEcsbDCb4p/F2RIi5hYcFBXWMUmA24EJmqViZA
         u0EMqtrJrBPXlKhc+64tUuXXPVtWcT+KFXgV+fBSA0z072mO5Y0h+Zuxi4TzY9z9I4MR
         H4UNKmjlHjgd+Ymm8Ss0xCRJSkeeUk/CPbW9Qq90jpWMq7A3eAxNOuxuuiwXTbM+5US8
         VfAaB/LkNW0zf0fOm6uQSeN8acRSd/BFsNpXeCo5KQPHet9genBM12YUZV2VfP4MNw7Z
         ENfg==
X-Forwarded-Encrypted: i=1; AL+hErFqqwKe2Dp9cYfXerYsNoLJErLzZBCiGAw1AeoKpj4laktxow/o49a93lUceHQ/Jxf5aKNhzc+5Zuc=@vger.kernel.org
X-Gm-Message-State: APuU4Z+ez6TaHV0lsVzxwlhUxk2ASr96Cz6/tgZhVxG9xG9ETqVWBe1D
	9F/Nussr+mqiwTu3IjZNLABAHILTFCjP9CUXA380CjVgeuVTe9xyAOZb0T8/yu5glqI=
X-Gm-Gg: AYBFou3WzWli46RVdIFrbQHrzTDeSpjCfjXH1WwfmnsovDA875spmYUt0S1M9ulxTzD
	3MIuWkcmdJvsaUlnWKEgwXS0oVbvfLzsoElG26Ec59JXxhftO8kjTp3RI5eoc81ABVJK/R7U1Dn
	SUQ6t1T1EIB7yGS1w7s89HRiGkqSz6VwLvzV6Gc6DnLHhhxmG7fD6njC4uRLpIdb5rfcJqhMoM2
	UboQcwpcI6LvtqHQAvnBGaV4fGjzWq+H2Uy1YSgaKX0qKZszKTRY7P9vLXre7LuO2/aC/LbFWI1
	2SSAm2mjnczL9wmZ6FJNho2ku23vPb/7NVKOowAJyOQnrwTEo509Ng09Nfy03Wc7UZWT+OlI8mU
	f3X6FtD1EAzc0IAJYTazo/dmW4USgZKqRsBrKKcbxqoM0JS7rixCrUIOLVyn90Th2k4o60FqE/Z
	PII8OOorwVsbHQAlCBD5PAWQCk88wyYn+QYaCFf1IBLQm9PMNVSN8dkTKo+x9OJH5sglLCAgnOI
	D23BUgStymd2RmlZeFSQEgVOYmHeecY86nihc2Jtfw4RaFQP1G+1+X1HC0Ocz6yMIwJiktF9f45
	bI+H/mujh7Wo0d4gFw4Qip3aPThej7OPxd6yUwPDvpUgWDC/WLcnZosQQn8q9Q==
X-Received: by 2002:a17:906:ee85:b0:c33:923b:ad66 with SMTP id a640c23a62f3a-c50963ce0c7mr240922566b.43.1794585356462;
        Fri, 13 Nov 2026 07:55:56 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b236d4sm115287166b.18.2026.11.13.07.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 07:55:55 -0800 (PST)
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
Subject: [PATCH RFC v2 08/15] ctlv: Prepare message output handling
Date: Fri, 13 Nov 2026 16:55:07 +0100
Message-ID: <20261113155515.2510194-9-jiri@resnulli.us>
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

Add schema-aware reply construction, generated output accessors,
operation errors and query fragment completion.

Keep CONFIG_CTLV unwired until dispatch completes the module.

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- added ctlv_record_cancel()
- moved the function kernel-doc to the definitions
- made the warning for a reply past its declared length a CTLV_ASSERT()
- said TLV, type, record and field instead of attr
- said record instead of nest, the root being one
- took the UAPI headers from include/uapi/ctlv/
- moved to lib/ctlv/
---
 include/linux/ctlv.h        |  24 ++
 include/linux/ctlv_family.h |  41 ++++
 lib/ctlv/Makefile           |   2 +-
 lib/ctlv/builder.c          | 455 ++++++++++++++++++++++++++++++++++++
 lib/ctlv/builder.h          |  14 ++
 5 files changed, 535 insertions(+), 1 deletion(-)
 create mode 100644 lib/ctlv/builder.c
 create mode 100644 lib/ctlv/builder.h

diff --git a/include/linux/ctlv.h b/include/linux/ctlv.h
index e151e32a0ffd..5b75550de678 100644
--- a/include/linux/ctlv.h
+++ b/include/linux/ctlv.h
@@ -34,6 +34,8 @@ struct ctlv_schema_tree;
  * @depth: record levels above this position, the root being zero
  * @index_record_scope: schema scope used to read the members of @hdr, a record
  * @index_scope: core-private schema scope containing this TLV
+ * @progress: writing, whether the fragment had progressed before this record
+ *	opened
  *
  * Fixed-size, so family code can put a child cursor on the stack.
  * ctlv_record_start() opens at most CTLV_MAX_RECORD_DEPTH levels, which bounds
@@ -52,6 +54,28 @@ struct ctlv_cursor {
 	u32 depth;
 	u32 index_record_scope;
 	u32 index_scope;
+	bool progress;
 };
 
+void ctlv_record_end(struct ctlv_cursor *child);
+void ctlv_record_cancel(struct ctlv_cursor *child);
+
+int ctlv_op_error(struct ctlv_op_ctx *ctx, int error, const char *message);
+__printf(3, 4)
+int ctlv_op_errorf(struct ctlv_op_ctx *ctx, int error, const char *fmt, ...);
+
+/*
+ * The core retains no query state. A continuation repeats the request and
+ * passes back the family's generation and nonzero cursor. It fails with
+ * -ESTALE if the generation changed. Each fragment must complete a logical
+ * leaf and return a cursor different from its input.
+ *
+ * ctlv_op_query_more() marks still-open records, whose cursors must stay live.
+ */
+u64 ctlv_op_query_generation(const struct ctlv_op_ctx *ctx);
+u64 ctlv_op_query_cursor(const struct ctlv_op_ctx *ctx);
+int ctlv_op_query_more(struct ctlv_op_ctx *ctx, u64 generation,
+		       u64 next_cursor);
+int ctlv_op_query_done(struct ctlv_op_ctx *ctx, u64 generation);
+
 #endif /* _LINUX_CTLV_H */
diff --git a/include/linux/ctlv_family.h b/include/linux/ctlv_family.h
index ae8ed69df5ea..4d7d4fb65fec 100644
--- a/include/linux/ctlv_family.h
+++ b/include/linux/ctlv_family.h
@@ -441,6 +441,47 @@ bool ctlv_cursor_bool(const struct ctlv_cursor *cursor);
 const char *ctlv_cursor_string(const struct ctlv_cursor *cursor);
 const void *ctlv_cursor_binary(const struct ctlv_cursor *cursor, u32 *len);
 
+bool ctlv_put_u64(struct ctlv_cursor *record, u64 type, u8 kind, u64 value);
+bool ctlv_put_s64(struct ctlv_cursor *record, u64 type, u8 kind, s64 value);
+bool ctlv_put_bool(struct ctlv_cursor *record, u64 type, u8 kind, bool value);
+bool ctlv_put_string(struct ctlv_cursor *record, u64 type, u8 kind,
+		     const char *value);
+bool ctlv_put_binary(struct ctlv_cursor *record, u64 type, u8 kind,
+		     const void *value, u32 len);
+bool ctlv_record_start(struct ctlv_cursor *record, struct ctlv_cursor *child,
+		       u64 type, u8 kind);
+
+#define __CTLV_DEFINE_PUT(_name, _ctype, _put_fn, _type, _kind)	\
+static inline bool _name##_put(struct ctlv_cursor *record,	\
+			       _ctype value)			\
+{								\
+	return _put_fn(record, (_type), (_kind), value);	\
+}
+
+#define CTLV_PUT_U64(_name, _type, _kind)			\
+	__CTLV_DEFINE_PUT(_name, u64, ctlv_put_u64, _type, _kind)
+#define CTLV_PUT_S64(_name, _type, _kind)			\
+	__CTLV_DEFINE_PUT(_name, s64, ctlv_put_s64, _type, _kind)
+#define CTLV_PUT_BOOL(_name, _type, _kind)			\
+	__CTLV_DEFINE_PUT(_name, bool, ctlv_put_bool, _type, _kind)
+#define CTLV_PUT_STRING(_name, _type, _kind)			\
+	__CTLV_DEFINE_PUT(_name, const char *, ctlv_put_string,	\
+			  _type, _kind)
+
+#define CTLV_PUT_BINARY(_name, _type, _kind)			\
+static inline bool _name##_put(struct ctlv_cursor *record,	\
+			       const void *value, u32 len)	\
+{								\
+	return ctlv_put_binary(record, (_type), (_kind), value, len); \
+}
+
+#define CTLV_RECORD_START(_name, _type, _kind)			\
+static inline bool _name##_start(struct ctlv_cursor *record,	\
+				 struct ctlv_cursor *inner)	\
+{								\
+	return ctlv_record_start(record, inner, (_type), (_kind)); \
+}
+
 #define CTLV_IN_REF(_name, _type, _kind)			\
 static inline struct ctlv_input_ref _name##_ref(void)		\
 {								\
diff --git a/lib/ctlv/Makefile b/lib/ctlv/Makefile
index 3fd656835b8a..e1a22a199ef1 100644
--- a/lib/ctlv/Makefile
+++ b/lib/ctlv/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_CTLV) += ctlv.o
 
-ctlv-y += blob_desc.o message.o schema.o
+ctlv-y += blob_desc.o builder.o message.o schema.o
diff --git a/lib/ctlv/builder.c b/lib/ctlv/builder.c
new file mode 100644
index 000000000000..976e2f8d1aaa
--- /dev/null
+++ b/lib/ctlv/builder.c
@@ -0,0 +1,455 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Schema-aware reply construction and operation completion.
+ */
+#include <linux/align.h>
+#include <linux/bug.h>
+#include <linux/ctlv.h>
+#include <linux/errno.h>
+#include <linux/export.h>
+#include <linux/stdarg.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#include <uapi/ctlv/ctlv.h>
+#include <uapi/ctlv/ctlv_gen.h>
+
+#include "builder.h"
+#include "internal.h"
+#include "message.h"
+#include "schema.h"
+
+static void ctlv_message_output_frag_mark(struct ctlv_op_ctx *ctx);
+
+void ctlv_message_output_init(struct ctlv_msg *msg, struct ctlv_op_ctx *ctx, void *buf, size_t len,
+			      const struct ctlv_schema_tree *tree)
+{
+	*msg = (struct ctlv_msg){
+		.root = buf,
+		.len = len,
+		.tree = tree,
+		.family = ctx->family,
+		.ctx = ctx,
+	};
+	*msg->root = (struct ctlv_hdr){
+		.len = sizeof(*msg->root),
+		.flags = CTLV_HDR_F_RECORD,
+		.type = CTLV_TYPE_ROOT,
+	};
+}
+
+/* The first thing that went wrong is what the op ends up failing with. */
+static bool ctlv_message_output_poison(struct ctlv_cursor *record, int error)
+{
+	if (!record->msg->poison)
+		record->msg->poison = error;
+	return false;
+}
+
+/* A poisoned message is refused silently: whatever poisoned it has warned. */
+static bool ctlv_message_output_ready(struct ctlv_cursor *record)
+{
+	if (WARN_ON_ONCE(!record->msg || !record->hdr))
+		return false;
+	/* Also what refuses a cursor that reads a request. */
+	if (WARN_ON_ONCE(!record->msg->ctx))
+		return false;
+	if (record->msg->poison)
+		return false;
+	if (WARN_ON_ONCE(record->msg->ctx->deepest != record))
+		return ctlv_message_output_poison(record, -EINVAL);
+	return true;
+}
+
+/* What the schema places in this record under one type, as one schema kind. */
+static const struct ctlv_node_schema *ctlv_message_output_member(struct ctlv_cursor *record,
+								 u64 type, u8 kind,
+								 struct ctlv_schema_pos *pos)
+{
+	const struct ctlv_node_schema *node;
+
+	if (!ctlv_message_output_ready(record))
+		return NULL;
+	if (WARN_ON_ONCE(!ctlv_schema_member(record->msg->family, record->tree,
+					     record->node, type, pos))) {
+		ctlv_message_output_poison(record, -EINVAL);
+		return NULL;
+	}
+	node = &pos->tree->node_schemas[pos->node];
+	if (WARN_ON_ONCE(node->kind != kind)) {
+		ctlv_message_output_poison(record, -EINVAL);
+		return NULL;
+	}
+	return node;
+}
+
+/*
+ * A query is offered whatever room its caller had, so running out ends a
+ * fragment. Anything else wrote a message its own schema does not describe.
+ */
+static bool ctlv_message_output_full(struct ctlv_cursor *record)
+{
+	const struct ctlv_op_schema *op = record->msg->ctx->op->schema;
+
+	if (op->type == CTLV_OP_TYPE_QUERY)
+		return false;
+	CTLV_ASSERT(0);
+	return ctlv_message_output_poison(record, -EMSGSIZE);
+}
+
+/* What one cursor stands on, as the buffer this direction may change. */
+static struct ctlv_hdr *ctlv_message_output_hdr(const struct ctlv_cursor *record)
+{
+	return (struct ctlv_hdr *)((u8 *)record->msg->root + record->start);
+}
+
+/* The pad is written rather than left as it was: it belongs to the record. */
+static struct ctlv_hdr *ctlv_message_output_write(struct ctlv_cursor *record, u64 type, u32 flags,
+						  const void *payload, u32 payload_len)
+{
+	u32 len = sizeof(struct ctlv_hdr) + payload_len;
+	size_t step = ALIGN((size_t)len, CTLV_ALIGNTO);
+	struct ctlv_msg *msg = record->msg;
+	struct ctlv_cursor *open;
+	struct ctlv_hdr *hdr;
+	size_t offset;
+
+	offset = record->start + ctlv_message_output_hdr(record)->len;
+	if (offset + step > msg->len) {
+		ctlv_message_output_full(record);
+		return NULL;
+	}
+
+	hdr = (struct ctlv_hdr *)((u8 *)msg->root + offset);
+	*hdr = (struct ctlv_hdr){
+		.len = len,
+		.flags = flags,
+		.type = type,
+	};
+	if (payload_len)
+		memcpy(hdr + 1, payload, payload_len);
+	memset((u8 *)hdr + len, 0, step - len);
+	if (!(flags & CTLV_HDR_F_RECORD))
+		msg->ctx->frag.progress = true;
+
+	/* Every record the TLV landed in is that much longer, the root too. */
+	for (open = record; open; open = open->up)
+		ctlv_message_output_hdr(open)->len += step;
+	return hdr;
+}
+
+/* The 64-bit payload that every integer, enum and flags field carries. */
+static bool ctlv_message_put_scalar(struct ctlv_cursor *record, u64 type, u8 kind, u64 value)
+{
+	const struct ctlv_node_schema *node;
+	struct ctlv_schema_pos pos;
+
+	node = ctlv_message_output_member(record, type, kind, &pos);
+	if (!node)
+		return false;
+	/* A value outside what the field declares is one nothing may be told. */
+	if (WARN_ON_ONCE(!ctlv_schema_value_ok(record->msg->family, node, value)))
+		return ctlv_message_output_poison(record, -EINVAL);
+	return ctlv_message_output_write(record, type, 0, &value, sizeof(value));
+}
+
+bool ctlv_put_u64(struct ctlv_cursor *record, u64 type, u8 kind, u64 value)
+{
+	return ctlv_message_put_scalar(record, type, kind, value);
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_put_u64, "CTLV");
+
+bool ctlv_put_s64(struct ctlv_cursor *record, u64 type, u8 kind, s64 value)
+{
+	return ctlv_message_put_scalar(record, type, kind, value);
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_put_s64, "CTLV");
+
+bool ctlv_put_bool(struct ctlv_cursor *record, u64 type, u8 kind, bool value)
+{
+	u8 payload = value;
+	struct ctlv_schema_pos pos;
+
+	if (!ctlv_message_output_member(record, type, kind, &pos))
+		return false;
+	return ctlv_message_output_write(record, type, 0, &payload, sizeof(payload));
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_put_bool, "CTLV");
+
+bool ctlv_put_string(struct ctlv_cursor *record, u64 type, u8 kind, const char *value)
+{
+	const struct ctlv_node_schema *node;
+	struct ctlv_schema_pos pos;
+	size_t len;
+
+	node = ctlv_message_output_member(record, type, kind, &pos);
+	if (!node)
+		return false;
+	len = strnlen(value, (size_t)node->length.max_len + 1);
+	if (WARN_ON_ONCE(len > node->length.max_len || !ctlv_schema_length_ok(node, len)))
+		return ctlv_message_output_poison(record, -EINVAL);
+	return ctlv_message_output_write(record, type, 0, value, len + 1);
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_put_string, "CTLV");
+
+bool ctlv_put_binary(struct ctlv_cursor *record, u64 type, u8 kind, const void *value, u32 len)
+{
+	const struct ctlv_node_schema *node;
+	struct ctlv_schema_pos pos;
+
+	node = ctlv_message_output_member(record, type, kind, &pos);
+	if (!node)
+		return false;
+	if (WARN_ON_ONCE(!ctlv_schema_length_ok(node, len)))
+		return ctlv_message_output_poison(record, -EINVAL);
+	return ctlv_message_output_write(record, type, 0, value, len);
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_put_binary, "CTLV");
+
+bool ctlv_record_start(struct ctlv_cursor *record, struct ctlv_cursor *child, u64 type, u8 kind)
+{
+	struct ctlv_schema_pos pos;
+	struct ctlv_hdr *hdr;
+
+	*child = (struct ctlv_cursor){};
+	if (!ctlv_message_output_member(record, type, kind, &pos))
+		return false;
+	/* Unreachable through any schema the generator would have accepted. */
+	if (WARN_ON_ONCE(record->depth + 1 > CTLV_MAX_RECORD_DEPTH))
+		return ctlv_message_output_poison(record, -EINVAL);
+
+	hdr = ctlv_message_output_write(record, type, CTLV_HDR_F_RECORD, NULL, 0);
+	if (!hdr)
+		return false;
+
+	*child = (struct ctlv_cursor){
+		.msg = record->msg,
+		.hdr = hdr,
+		.up = record,
+		.start = ctlv_message_offset(record->msg, hdr),
+		.tree = pos.tree,
+		.node = pos.node,
+		.depth = record->depth + 1,
+		.progress = record->msg->ctx->frag.progress,
+	};
+	record->msg->ctx->deepest = child;
+	return true;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_record_start, "CTLV");
+
+/* Only the innermost open record of an unpoisoned message can be closed. */
+static struct ctlv_op_ctx *ctlv_message_output_closing(struct ctlv_cursor *child)
+{
+	struct ctlv_op_ctx *ctx;
+
+	if (WARN_ON_ONCE(!child->msg || !child->msg->ctx || !child->up))
+		return NULL;
+	ctx = child->msg->ctx;
+	if (child->msg->poison)
+		return NULL;
+	if (WARN_ON_ONCE(ctx->deepest != child)) {
+		ctlv_message_output_poison(child, -EINVAL);
+		return NULL;
+	}
+	return ctx;
+}
+
+/**
+ * ctlv_record_end - Finish an output record.
+ * @child: record cursor returned by a generated start helper
+ */
+void ctlv_record_end(struct ctlv_cursor *child)
+{
+	struct ctlv_op_ctx *ctx = ctlv_message_output_closing(child);
+
+	if (!ctx)
+		return;
+	if (ctlv_message_output_hdr(child)->len == sizeof(struct ctlv_hdr))
+		ctx->frag.progress = true;
+	ctx->deepest = child->up;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_record_end, "CTLV");
+
+/**
+ * ctlv_record_cancel - Drop an output record and everything written into it.
+ * @child: innermost open record cursor returned by a generated start helper
+ *
+ * For a query that ran out of room partway through a record: the fragment then
+ * ends before it, and the next fragment writes it again.
+ */
+void ctlv_record_cancel(struct ctlv_cursor *child)
+{
+	struct ctlv_op_ctx *ctx = ctlv_message_output_closing(child);
+	struct ctlv_cursor *open;
+	u32 len;
+
+	if (!ctx)
+		return;
+	/* The record lengthened each one holding it by exactly its length. */
+	len = ctlv_message_output_hdr(child)->len;
+	for (open = child->up; open; open = open->up)
+		ctlv_message_output_hdr(open)->len -= len;
+	ctx->frag.progress = child->progress;
+	ctx->deepest = child->up;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_record_cancel, "CTLV");
+
+static bool ctlv_op_error_valid(int error)
+{
+	return !WARN_ON_ONCE(error >= 0 || error < -MAX_ERRNO);
+}
+
+/**
+ * ctlv_op_error - Record an operation error message.
+ * @ctx: operation context
+ * @error: negative error to return
+ * @message: message copied into the operation result
+ *
+ * Return: @error, or -EINVAL if @error is invalid.
+ */
+int ctlv_op_error(struct ctlv_op_ctx *ctx, int error, const char *message)
+{
+	if (!ctlv_op_error_valid(error))
+		return error < 0 && error >= -MAX_ERRNO ? error : -EINVAL;
+	if (!ctx->error.message[0])
+		strscpy(ctx->error.message, message, sizeof(ctx->error.message));
+	return error;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_op_error, "CTLV");
+
+/**
+ * ctlv_op_errorf - Format an operation error message.
+ * @ctx: operation context
+ * @error: negative error to return
+ * @fmt: printf format and arguments
+ *
+ * Return: @error, or -EINVAL if @error is invalid.
+ */
+int ctlv_op_errorf(struct ctlv_op_ctx *ctx, int error, const char *fmt, ...)
+{
+	va_list args;
+
+	if (!ctlv_op_error_valid(error))
+		return error < 0 && error >= -MAX_ERRNO ? error : -EINVAL;
+	if (ctx->error.message[0])
+		return error;
+	va_start(args, fmt);
+	vscnprintf(ctx->error.message, sizeof(ctx->error.message), fmt, args);
+	va_end(args);
+	return error;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_op_errorf, "CTLV");
+
+/* Continuation is a query's, so asking about one anywhere else is a bug. */
+static bool ctlv_op_is_query(const struct ctlv_op_ctx *ctx)
+{
+	return !WARN_ON_ONCE(ctx->op->schema->type != CTLV_OP_TYPE_QUERY);
+}
+
+/**
+ * ctlv_op_query_generation - Get a query continuation generation.
+ * @ctx: query operation context
+ *
+ * Return: generation supplied by the previous fragment, or zero initially.
+ */
+u64 ctlv_op_query_generation(const struct ctlv_op_ctx *ctx)
+{
+	if (!ctlv_op_is_query(ctx))
+		return 0;
+	return ctx->frag.generation;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_op_query_generation, "CTLV");
+
+/**
+ * ctlv_op_query_cursor - Get a query continuation cursor.
+ * @ctx: query operation context
+ *
+ * Return: cursor supplied by the previous fragment, or zero initially.
+ */
+u64 ctlv_op_query_cursor(const struct ctlv_op_ctx *ctx)
+{
+	if (!ctlv_op_is_query(ctx))
+		return 0;
+	return ctx->frag.cursor;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_op_query_cursor, "CTLV");
+
+/*
+ * What both endings check: a query, one ending, and a generation that has not
+ * moved under a continuation, which no fragment can be delivered across.
+ */
+static int ctlv_query_fragment_end(struct ctlv_op_ctx *ctx, u64 generation)
+{
+	if (!ctlv_op_is_query(ctx))
+		return -EINVAL;
+	if (WARN_ON_ONCE(ctx->frag.answered))
+		return -EINVAL;
+	ctx->frag.answered = true;
+	/* Whatever the builder gave up on has warned about it already. */
+	if (ctx->output.poison)
+		return ctx->output.poison;
+	if (ctx->frag.cursor && generation != ctx->frag.generation) {
+		ctx->error.reason = CTLV_VALIDATION_REASON_STALE_GENERATION;
+		ctx->error.expected_generation = ctx->frag.generation;
+		ctx->error.current_generation = generation;
+		return -ESTALE;
+	}
+	ctx->frag.reported = generation;
+	return 0;
+}
+
+/**
+ * ctlv_op_query_more - Complete a query fragment with more data pending.
+ * @ctx: query operation context
+ * @generation: current data generation
+ * @next_cursor: nonzero cursor for the next fragment
+ *
+ * Return: 0, or a negative error.
+ */
+int ctlv_op_query_more(struct ctlv_op_ctx *ctx, u64 generation, u64 next_cursor)
+{
+	int ret = ctlv_query_fragment_end(ctx, generation);
+
+	if (!ret &&
+	    WARN_ON_ONCE(!ctx->frag.progress || !next_cursor || next_cursor == ctx->frag.cursor))
+		ret = -EINVAL;
+	if (!ret) {
+		ctlv_message_output_frag_mark(ctx);
+		ctx->frag.next_cursor = next_cursor;
+	}
+	ctx->frag.result = ret;
+	return ret;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_op_query_more, "CTLV");
+
+/**
+ * ctlv_op_query_done - Complete the last query fragment.
+ * @ctx: query operation context
+ * @generation: current data generation
+ *
+ * Return: 0, or a negative error.
+ */
+int ctlv_op_query_done(struct ctlv_op_ctx *ctx, u64 generation)
+{
+	int ret = ctlv_query_fragment_end(ctx, generation);
+
+	if (!ret && WARN_ON_ONCE(ctx->deepest != &ctx->output_root)) {
+		/* A cursor of a frame that has returned is not followed. */
+		ctx->deepest = &ctx->output_root;
+		ret = -EINVAL;
+	}
+	ctx->frag.result = ret;
+	return ret;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_op_query_done, "CTLV");
+
+static void ctlv_message_output_frag_mark(struct ctlv_op_ctx *ctx)
+{
+	struct ctlv_cursor *open;
+
+	for (open = ctx->deepest; open; open = open->up)
+		ctlv_message_output_hdr(open)->flags |= CTLV_HDR_F_FRAG_MORE;
+	ctx->deepest = &ctx->output_root;
+}
diff --git a/lib/ctlv/builder.h b/lib/ctlv/builder.h
new file mode 100644
index 000000000000..744595ebd88e
--- /dev/null
+++ b/lib/ctlv/builder.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _CTLV_BUILDER_H
+#define _CTLV_BUILDER_H
+
+#include <linux/types.h>
+
+struct ctlv_msg;
+struct ctlv_op_ctx;
+struct ctlv_schema_tree;
+
+void ctlv_message_output_init(struct ctlv_msg *msg, struct ctlv_op_ctx *ctx, void *buf, size_t len,
+			      const struct ctlv_schema_tree *tree);
+
+#endif /* _CTLV_BUILDER_H */
-- 
2.56.0

