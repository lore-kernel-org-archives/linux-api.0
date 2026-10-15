Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D105326AC
	for <linux-api@vger.kernel.org>; Thu, 15 Oct 2026 14:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075900; cv=none; b=q9VQC3vLRfqSGUuFHTakyw7kSqr2hjkKW8p4zRE6bcZG8XC8ySecnnS3euipH7v8/DwZsymOI4105z9/jq07Byg48AerTYDzQRDFaz5bAsg1b13LEWQysXlogS/0W6lBaUzbtzZppflv2L9UemSauukHbtqkW35+tell81LC+XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075900; c=relaxed/simple;
	bh=fKRXQApxRracOK9iO3PsguEnx9JSOhV86iGIFjRJQnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awxFyibmP6kO5f/oO1gT9Hn26++HApdVaqv3i7zxEcz+p/T/RWTWIQqWFs5M4LDd/WMn2Yua52M3AgYgFAra1f7lQQsSJiui64tDY+MBEKllz2tJuoIE7ZP03UUW9uF1bD6WYkRR5DkX8EfIZKbh3/Xf4lvN8PXX/hMTxKQSw7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=HygI2Gy2; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="HygI2Gy2"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c2e6df2742cso825589966b.2
        for <linux-api@vger.kernel.org>; Thu, 15 Oct 2026 07:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1792075890; x=1792680690; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QyMIHmNJAF5G39LSXXcEccaYws7vqMec+M+6H32WarE=;
        b=HygI2Gy28zc0zzbK+LNEVNuLF/4jW1tAwLJ0PekoCwOkei8TJy2sQyNIrrudrTmNpb
         japUWXtZeTDtNBbe4lEEG5gcZDmB/HsR7ckTR0Gs8ST35mh6RjHPXQVLMArxuJLqztxQ
         OncG78FKK1VMfx9nCq5sMwPTt98wFznKyZAPfmBkns/X7wxFQyu86/Df/gabQ9dTofel
         KYUlQ+UmFVCTHoD+EXVKSEnG+MJi6UDL5cyFE+C4C6k7SpyV2rlpaPZ1BRxOSurptjsa
         3oLILm2rRPTBveWN1bNsRalNJPmIv/7XgLMEcq1Fir+Tx2ltypvcVpr9r4D7k3JDknzS
         czeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075890; x=1792680690;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QyMIHmNJAF5G39LSXXcEccaYws7vqMec+M+6H32WarE=;
        b=tCAUXipuQvL7NJ2q4lPcwAaj1neY9VP88IxWQOT/XvFik+j5WGK3zA+bs2piKEI8Ne
         xjU2qHAA1GK6rSOSP7oD9c9mkkc2Qf4YB1zhh33gm/k7e/f6szAuVDDrNIVt98N9/NEt
         c7i/+DbTfoSMmGB584HXfu8M31d6/7iiwexWrLUYGgfqN29TXsrDW/uC6Nlgz8D7t6pI
         rtLPlQq6BySHSgpGgCDWrjj6RqWmJIdrs6E2cwIkS24EgJVpB9zYNORiDY93Jx3LAHY+
         TAQO0PkTNdVp3obKm5zrDrPsP04ZZCki7t7KsGwaA4HXLBNTn30hmXxn7esUKAeYsF8k
         1aPw==
X-Forwarded-Encrypted: i=1; AKwUvBzVAPaigRD2ZO5fInhBS26mwviZ1/8/6WPesJoGt5vFELELdQAh5kAEOjz/il6UUaD1iHAyLL0viZs=@vger.kernel.org
X-Gm-Message-State: AFq9FYKbSC4jo44zlZB+nvgNK3ig0xAVrLQzJWncYAyTAa28xH4uhiC1
	VXAffKzmcqBmxplECWjxu725hXokOBm+ZkoDvjidblWTvKfCDqURd1PT2storV5OmoQ=
X-Gm-Gg: AYBFou0rDbRwNCvconwcXmziv8yu7v535N0jB4Uk0Xlna4/DvNu7oyiykzS5haI3bsj
	nMuxZpDgIdjWjCBom6bEulhHjaL4xP8LtGONcpzrRiI9n2RLkUGCR8fncekjp/fn4LonvuJd4xt
	PfRHzzIund6HB6gop9rtWtpY0hotRdZLm3/VxQNkZTE1xfGMcr2sL9stJomOaDKEx/HI4USQ3Cj
	+U3plWEYiFK4plwahBplLmqCTYsrkHNNuyt2qqPgT3wf7SLJpYW0OTXz/LIgw3VvnVvI5wBPIrQ
	Qy11lAyWvndnqAOvzvntCfXaH+LPoBV2gbYlkvICB4LVwumcnTbWGni6R/DG4ihpIWeLVIguE44
	swZFRVp+HK+VjCcCITw1hUuABS4vjvp8+6cXcdQA1nS1ntRYa1/k6J8wvooDnFJl7WPJ0M5O5Zh
	r7RPfeT/kOER31RCu2hlyAa7fL7YMQPQ26TJTbURU/kqMiH+SLDE0YitpabQ7CdS4LGsK3nbvDn
	ia0ay/eow==
X-Received: by 2002:a17:907:961a:b0:c20:1bc5:7002 with SMTP id a640c23a62f3a-c31a9a04de6mr1962869166b.3.1792075890244;
        Thu, 15 Oct 2026 07:51:30 -0700 (PDT)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3ed9b3f081sm137391166b.35.2026.10.15.07.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:51:29 -0700 (PDT)
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
Subject: [PATCH RFC 08/20] ctlv: Prepare message output handling
Date: Thu, 15 Oct 2026 16:50:41 +0200
Message-ID: <20261015145053.3664509-9-jiri@resnulli.us>
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

Add schema-aware reply construction, generated output accessors,
operation errors and query fragment completion.

Keep CONFIG_CTLV unwired until dispatch completes the module.

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/ctlv/Makefile       |   2 +-
 drivers/ctlv/builder.c      | 374 ++++++++++++++++++++++++++++++++++++
 drivers/ctlv/builder.h      |  14 ++
 include/linux/ctlv.h        |  71 +++++++
 include/linux/ctlv_family.h |  41 ++++
 5 files changed, 501 insertions(+), 1 deletion(-)
 create mode 100644 drivers/ctlv/builder.c
 create mode 100644 drivers/ctlv/builder.h

diff --git a/drivers/ctlv/Makefile b/drivers/ctlv/Makefile
index 3fd656835b8a..e1a22a199ef1 100644
--- a/drivers/ctlv/Makefile
+++ b/drivers/ctlv/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_CTLV) += ctlv.o
 
-ctlv-y += blob_desc.o message.o schema.o
+ctlv-y += blob_desc.o builder.o message.o schema.o
diff --git a/drivers/ctlv/builder.c b/drivers/ctlv/builder.c
new file mode 100644
index 000000000000..41748ceae1a3
--- /dev/null
+++ b/drivers/ctlv/builder.c
@@ -0,0 +1,374 @@
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
+#include <uapi/linux/ctlv.h>
+#include <uapi/linux/ctlv_gen.h>
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
+	*msg->root = (struct ctlv_attr){
+		.len = sizeof(*msg->root),
+		.flags = CTLV_ATTR_F_NESTED,
+		.attr_id = CTLV_ATTR_ROOT,
+	};
+}
+
+/* The first thing that went wrong is what the op ends up failing with. */
+static bool ctlv_message_output_poison(struct ctlv_cursor *nest, int error)
+{
+	if (!nest->msg->poison)
+		nest->msg->poison = error;
+	return false;
+}
+
+/* A poisoned message is refused silently: whatever poisoned it has warned. */
+static bool ctlv_message_output_ready(struct ctlv_cursor *nest)
+{
+	if (WARN_ON_ONCE(!nest->msg || !nest->attr))
+		return false;
+	/* Also what refuses a cursor that reads a request. */
+	if (WARN_ON_ONCE(!nest->msg->ctx))
+		return false;
+	if (nest->msg->poison)
+		return false;
+	if (WARN_ON_ONCE(nest->msg->ctx->deepest != nest))
+		return ctlv_message_output_poison(nest, -EINVAL);
+	return true;
+}
+
+/* What the schema places in this nest under one ID, as one kind. */
+static const struct ctlv_node_schema *ctlv_message_output_member(struct ctlv_cursor *nest,
+								 u64 attr_id, u8 kind,
+								 struct ctlv_schema_pos *pos)
+{
+	const struct ctlv_node_schema *node;
+
+	if (!ctlv_message_output_ready(nest))
+		return NULL;
+	if (WARN_ON_ONCE(!ctlv_schema_member(nest->msg->family, nest->tree,
+					     nest->node, attr_id, pos))) {
+		ctlv_message_output_poison(nest, -EINVAL);
+		return NULL;
+	}
+	node = &pos->tree->node_schemas[pos->node];
+	if (WARN_ON_ONCE(node->kind != kind)) {
+		ctlv_message_output_poison(nest, -EINVAL);
+		return NULL;
+	}
+	return node;
+}
+
+/*
+ * A query is offered whatever room its caller had, so running out ends a
+ * fragment. Anything else wrote a message its own schema does not describe.
+ */
+static bool ctlv_message_output_full(struct ctlv_cursor *nest)
+{
+	const struct ctlv_op_schema *op = nest->msg->ctx->op->schema;
+
+	if (op->type == CTLV_OP_TYPE_QUERY)
+		return false;
+	WARN_ONCE(1, "ctlv: op %#018llx wrote past the reply length its schema declares\n",
+		  op->op_id);
+	return ctlv_message_output_poison(nest, -EMSGSIZE);
+}
+
+/* What one cursor stands on, as the buffer this direction may change. */
+static struct ctlv_attr *ctlv_message_output_attr(const struct ctlv_cursor *nest)
+{
+	return (struct ctlv_attr *)((u8 *)nest->msg->root + nest->start);
+}
+
+/* The pad is written rather than left as it was: it belongs to the nest. */
+static struct ctlv_attr *ctlv_message_output_write(struct ctlv_cursor *nest, u64 attr_id, u32 flags,
+						   const void *payload, u32 payload_len)
+{
+	u32 len = sizeof(struct ctlv_attr) + payload_len;
+	size_t step = ALIGN((size_t)len, CTLV_ALIGNTO);
+	struct ctlv_msg *msg = nest->msg;
+	struct ctlv_cursor *open;
+	struct ctlv_attr *attr;
+	size_t offset;
+
+	offset = nest->start + ctlv_message_output_attr(nest)->len;
+	if (offset + step > msg->len) {
+		ctlv_message_output_full(nest);
+		return NULL;
+	}
+
+	attr = (struct ctlv_attr *)((u8 *)msg->root + offset);
+	*attr = (struct ctlv_attr){
+		.len = len,
+		.flags = flags,
+		.attr_id = attr_id,
+	};
+	if (payload_len)
+		memcpy(attr + 1, payload, payload_len);
+	memset((u8 *)attr + len, 0, step - len);
+	if (!(flags & CTLV_ATTR_F_NESTED))
+		msg->ctx->frag.progress = true;
+
+	/* Every nest the attr landed in is that much longer, the root too. */
+	for (open = nest; open; open = open->up)
+		ctlv_message_output_attr(open)->len += step;
+	return attr;
+}
+
+/* The 64-bit payload that every integer, enum and flags attr carries. */
+static bool ctlv_message_put_scalar(struct ctlv_cursor *nest, u64 attr_id, u8 kind, u64 value)
+{
+	const struct ctlv_node_schema *node;
+	struct ctlv_schema_pos pos;
+
+	node = ctlv_message_output_member(nest, attr_id, kind, &pos);
+	if (!node)
+		return false;
+	/* A value outside what the attr declares is one nothing may be told. */
+	if (WARN_ON_ONCE(!ctlv_schema_value_ok(node, value)))
+		return ctlv_message_output_poison(nest, -EINVAL);
+	return ctlv_message_output_write(nest, attr_id, 0, &value, sizeof(value));
+}
+
+bool ctlv_put_u64(struct ctlv_cursor *nest, u64 attr_id, u8 kind, u64 value)
+{
+	return ctlv_message_put_scalar(nest, attr_id, kind, value);
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_put_u64, "CTLV");
+
+bool ctlv_put_s64(struct ctlv_cursor *nest, u64 attr_id, u8 kind, s64 value)
+{
+	return ctlv_message_put_scalar(nest, attr_id, kind, value);
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_put_s64, "CTLV");
+
+bool ctlv_put_bool(struct ctlv_cursor *nest, u64 attr_id, u8 kind, bool value)
+{
+	u8 payload = value;
+	struct ctlv_schema_pos pos;
+
+	if (!ctlv_message_output_member(nest, attr_id, kind, &pos))
+		return false;
+	return ctlv_message_output_write(nest, attr_id, 0, &payload, sizeof(payload));
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_put_bool, "CTLV");
+
+bool ctlv_put_string(struct ctlv_cursor *nest, u64 attr_id, u8 kind, const char *value)
+{
+	const struct ctlv_node_schema *node;
+	struct ctlv_schema_pos pos;
+	size_t len;
+
+	node = ctlv_message_output_member(nest, attr_id, kind, &pos);
+	if (!node)
+		return false;
+	len = strnlen(value, (size_t)node->length.max_len + 1);
+	if (WARN_ON_ONCE(len > node->length.max_len || !ctlv_schema_length_ok(node, len)))
+		return ctlv_message_output_poison(nest, -EINVAL);
+	return ctlv_message_output_write(nest, attr_id, 0, value, len + 1);
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_put_string, "CTLV");
+
+bool ctlv_put_binary(struct ctlv_cursor *nest, u64 attr_id, u8 kind, const void *value, u32 len)
+{
+	const struct ctlv_node_schema *node;
+	struct ctlv_schema_pos pos;
+
+	node = ctlv_message_output_member(nest, attr_id, kind, &pos);
+	if (!node)
+		return false;
+	if (WARN_ON_ONCE(!ctlv_schema_length_ok(node, len)))
+		return ctlv_message_output_poison(nest, -EINVAL);
+	return ctlv_message_output_write(nest, attr_id, 0, value, len);
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_put_binary, "CTLV");
+
+bool ctlv_nest_start(struct ctlv_cursor *nest, struct ctlv_cursor *child, u64 attr_id, u8 kind)
+{
+	struct ctlv_schema_pos pos;
+	struct ctlv_attr *attr;
+
+	*child = (struct ctlv_cursor){};
+	if (!ctlv_message_output_member(nest, attr_id, kind, &pos))
+		return false;
+	/* Unreachable through any schema the generator would have accepted. */
+	if (WARN_ON_ONCE(nest->depth + 1 > CTLV_MAX_NEST_DEPTH))
+		return ctlv_message_output_poison(nest, -EINVAL);
+
+	attr = ctlv_message_output_write(nest, attr_id, CTLV_ATTR_F_NESTED, NULL, 0);
+	if (!attr)
+		return false;
+
+	*child = (struct ctlv_cursor){
+		.msg = nest->msg,
+		.attr = attr,
+		.up = nest,
+		.start = ctlv_message_offset(nest->msg, attr),
+		.tree = pos.tree,
+		.node = pos.node,
+		.depth = nest->depth + 1,
+	};
+	nest->msg->ctx->deepest = child;
+	return true;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_nest_start, "CTLV");
+
+void ctlv_nest_end(struct ctlv_cursor *child)
+{
+	struct ctlv_op_ctx *ctx;
+
+	if (WARN_ON_ONCE(!child->msg || !child->msg->ctx || !child->up))
+		return;
+	ctx = child->msg->ctx;
+	if (child->msg->poison)
+		return;
+	if (WARN_ON_ONCE(ctx->deepest != child)) {
+		ctlv_message_output_poison(child, -EINVAL);
+		return;
+	}
+	if (ctlv_message_output_attr(child)->len == sizeof(struct ctlv_attr))
+		ctx->frag.progress = true;
+	ctx->deepest = child->up;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_nest_end, "CTLV");
+
+static bool ctlv_op_error_valid(int error)
+{
+	return !WARN_ON_ONCE(error >= 0 || error < -MAX_ERRNO);
+}
+
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
+u64 ctlv_op_query_generation(const struct ctlv_op_ctx *ctx)
+{
+	if (!ctlv_op_is_query(ctx))
+		return 0;
+	return ctx->frag.generation;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_op_query_generation, "CTLV");
+
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
+		ctlv_message_output_attr(open)->flags |= CTLV_ATTR_F_FRAG_MORE;
+	ctx->deepest = &ctx->output_root;
+}
diff --git a/drivers/ctlv/builder.h b/drivers/ctlv/builder.h
new file mode 100644
index 000000000000..744595ebd88e
--- /dev/null
+++ b/drivers/ctlv/builder.h
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
diff --git a/include/linux/ctlv.h b/include/linux/ctlv.h
index addb893f4b8d..45f0c53b56ea 100644
--- a/include/linux/ctlv.h
+++ b/include/linux/ctlv.h
@@ -52,4 +52,75 @@ struct ctlv_cursor {
 	u32 index_scope;
 };
 
+/**
+ * ctlv_nest_end - Finish an output nest.
+ * @child: nest cursor returned by a generated start helper
+ */
+void ctlv_nest_end(struct ctlv_cursor *child);
+
+/**
+ * ctlv_op_error - Record an operation error message.
+ * @ctx: operation context
+ * @error: negative error to return
+ * @message: message copied into the operation result
+ *
+ * Return: @error, or -EINVAL if @error is invalid.
+ */
+int ctlv_op_error(struct ctlv_op_ctx *ctx, int error, const char *message);
+
+/**
+ * ctlv_op_errorf - Format an operation error message.
+ * @ctx: operation context
+ * @error: negative error to return
+ * @fmt: printf format and arguments
+ *
+ * Return: @error, or -EINVAL if @error is invalid.
+ */
+__printf(3, 4)
+int ctlv_op_errorf(struct ctlv_op_ctx *ctx, int error, const char *fmt, ...);
+
+/*
+ * The core retains no query state. A continuation repeats the request and
+ * passes back the family's generation and nonzero cursor. It fails with
+ * -ESTALE if the generation changed. Each fragment must complete a logical
+ * leaf and return a cursor different from its input.
+ *
+ * ctlv_op_query_more() marks still-open nests, whose cursors must remain live.
+ */
+/**
+ * ctlv_op_query_generation - Get a query continuation generation.
+ * @ctx: query operation context
+ *
+ * Return: generation supplied by the previous fragment, or zero initially.
+ */
+u64 ctlv_op_query_generation(const struct ctlv_op_ctx *ctx);
+
+/**
+ * ctlv_op_query_cursor - Get a query continuation cursor.
+ * @ctx: query operation context
+ *
+ * Return: cursor supplied by the previous fragment, or zero initially.
+ */
+u64 ctlv_op_query_cursor(const struct ctlv_op_ctx *ctx);
+
+/**
+ * ctlv_op_query_more - Complete a query fragment with more data pending.
+ * @ctx: query operation context
+ * @generation: current data generation
+ * @next_cursor: nonzero cursor for the next fragment
+ *
+ * Return: 0, or a negative error.
+ */
+int ctlv_op_query_more(struct ctlv_op_ctx *ctx, u64 generation,
+		       u64 next_cursor);
+
+/**
+ * ctlv_op_query_done - Complete the last query fragment.
+ * @ctx: query operation context
+ * @generation: current data generation
+ *
+ * Return: 0, or a negative error.
+ */
+int ctlv_op_query_done(struct ctlv_op_ctx *ctx, u64 generation);
+
 #endif /* _LINUX_CTLV_H */
diff --git a/include/linux/ctlv_family.h b/include/linux/ctlv_family.h
index eae690b9c1d5..d2598ec686f1 100644
--- a/include/linux/ctlv_family.h
+++ b/include/linux/ctlv_family.h
@@ -326,6 +326,47 @@ bool ctlv_attr_bool(const struct ctlv_cursor *cursor);
 const char *ctlv_attr_string(const struct ctlv_cursor *cursor);
 const void *ctlv_attr_binary(const struct ctlv_cursor *cursor, u32 *len);
 
+bool ctlv_put_u64(struct ctlv_cursor *nest, u64 attr_id, u8 kind, u64 value);
+bool ctlv_put_s64(struct ctlv_cursor *nest, u64 attr_id, u8 kind, s64 value);
+bool ctlv_put_bool(struct ctlv_cursor *nest, u64 attr_id, u8 kind, bool value);
+bool ctlv_put_string(struct ctlv_cursor *nest, u64 attr_id, u8 kind,
+		     const char *value);
+bool ctlv_put_binary(struct ctlv_cursor *nest, u64 attr_id, u8 kind,
+		     const void *value, u32 len);
+bool ctlv_nest_start(struct ctlv_cursor *nest, struct ctlv_cursor *child,
+		     u64 attr_id, u8 kind);
+
+#define __CTLV_DEFINE_PUT(_name, _type, _put_fn, _attr_id, _kind) \
+static inline bool _name##_put(struct ctlv_cursor *nest,		\
+			       _type value)			\
+{								\
+	return _put_fn(nest, (_attr_id), (_kind), value);		\
+}
+
+#define CTLV_PUT_U64(_name, _attr_id, _kind)			\
+	__CTLV_DEFINE_PUT(_name, u64, ctlv_put_u64, _attr_id, _kind)
+#define CTLV_PUT_S64(_name, _attr_id, _kind)			\
+	__CTLV_DEFINE_PUT(_name, s64, ctlv_put_s64, _attr_id, _kind)
+#define CTLV_PUT_BOOL(_name, _attr_id, _kind)			\
+	__CTLV_DEFINE_PUT(_name, bool, ctlv_put_bool, _attr_id, _kind)
+#define CTLV_PUT_STRING(_name, _attr_id, _kind)			\
+	__CTLV_DEFINE_PUT(_name, const char *, ctlv_put_string,	\
+			  _attr_id, _kind)
+
+#define CTLV_PUT_BINARY(_name, _attr_id, _kind)			\
+static inline bool _name##_put(struct ctlv_cursor *nest,		\
+			       const void *value, u32 len)		\
+{								\
+	return ctlv_put_binary(nest, (_attr_id), (_kind), value, len); \
+}
+
+#define CTLV_NEST_START(_name, _attr_id, _kind)			\
+static inline bool _name##_start(struct ctlv_cursor *nest,	\
+				 struct ctlv_cursor *nested)	\
+{								\
+	return ctlv_nest_start(nest, nested, (_attr_id), (_kind));	\
+}
+
 #define CTLV_IN_REF(_name, _tree, _attr_id, _node, _slot, _kind) \
 static inline struct ctlv_input_ref _name##_ref(void)		\
 {								\
-- 
2.56.0

