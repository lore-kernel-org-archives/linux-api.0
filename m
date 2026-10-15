Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6815335AB
	for <linux-api@vger.kernel.org>; Thu, 15 Oct 2026 14:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075901; cv=none; b=cKlVP87mI7U83+KPIBON55ZuNGaVGy8s6pWsSkN6kAuozoRLSHK/y+Gb9FeunwSYyO5aB+ktE5W5dCQTxRH3Xg10thFSQRglJTOKUH2CaKUUFmu6ooJome757amyUD7TFoEtiVCqvZpCCNJ8LIaGN7T1ZQXvxgkfym/Lu36rJ9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075901; c=relaxed/simple;
	bh=zbxbsxAx2fY3VSJXc4jue1YhE9hiDuy/RY5BDkG9DPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7p/598C7KjUTZV5Q3+DKOZ/201C5GiOH6pqzW0ARoPzhmI7fbrFyWKZG7cejv0iWTDMzR+baHbLT4LO9mcv6z2Z081qrtR4JtlpL7bpIYmiBzlFEUsYoCL/WECwsFc/XF04o7iVQKrGy4VUc58QeL9DKPqxdpbHrihSBhACDLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=XGx3Mps4; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="XGx3Mps4"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c31a34de844so344779066b.3
        for <linux-api@vger.kernel.org>; Thu, 15 Oct 2026 07:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1792075894; x=1792680694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7WZvB85HojFW4aEueXmiS/vX3qFsIOD9n4WvVcSSvYY=;
        b=XGx3Mps46JfdLJo/r5gv4thGaF3FfFUSPv1QlE7xcuL1Nmo/UWpvuEJtj9QX4YT4/j
         oFqftTUa0U6JwDxDyuxPjfb3+nLIgfwifUYV0Ti70I92nzWHOoIsd60ofqhVcG3rXYae
         TM7zPgH2GXLRtrqvP4A3MipsMARN4Cc0Qt1GAlHypoYT3B1Cswn2+TcCRSAdsjhY1nv2
         /dPYmrvRJQU33q0RGMxmNl00DC27gcZiDVUw5b5N2cPNjrUiHDf4KMi+aV3aDVBfNqL4
         y0A6VnUqIPxoD8Ayt1PIyaTFhdwOMqTRfxuF9ljOp9FF6KKzmIj84e6wihyrKfn/Z3iq
         wxRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075894; x=1792680694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7WZvB85HojFW4aEueXmiS/vX3qFsIOD9n4WvVcSSvYY=;
        b=t9W0AqD/GdTXrDag9BJAkfQEZ0oqLqh/KmAmrwXPh0W4F2P9ZajwNWEgtSh6qEE2m8
         0njFEoov8Eftvp8HpK9ucJWTmirem4F8hhD1OJqTFpiaNjIxKbxcewNDgSo2HhnfnYpb
         gfvlD7nP5xC3asw+vAgkiYb0Fe+HUTy05Exz4xLECWM825d2r3PIIknxqU7uihBiUf2J
         vD6ykD3yofxt6knWEZDoLE7qDaoIYzeL608U5jBRyY2yDsOAWGdDDZzRMdM4W4dyVexn
         imkgA7dur0k+EsNaouun0K+yzKo/Xo9t1xMnxtAt7+pjFoDEEAqMkfXlVuRU5/jtdvwP
         FIkg==
X-Forwarded-Encrypted: i=1; AKwUvBxNzHRdeu2nSEwD4ynPXrxOcVBhJkUzrmJ4CLA1vObv/kPZXULOvtl39VyK7BsaZooyRLD0YtVm7/I=@vger.kernel.org
X-Gm-Message-State: AFq9FYLwcwF3zJYUrx6HGR8GEKVSNP1QxWF8DfdukDOdRxb1YWul5njf
	xQ9ybkRatk+zy4Gx3BGRG7PepYYkfmeGx9YSI+rvWHvQJsoaPM4ZShveHK4LfwrWqvI=
X-Gm-Gg: AYBFou0kNmkf0/qwwYswUMr3gW4ew7+zAKSW2lkG77zlPkNrvzQHQuIF+0nciQa8Sce
	JEG5Br7LU9A1DXMfmDfFaMMCUwC/CWo94unUIqR6egWjyhcZw/483k0vhXTwNENvLIOsGLHp1R4
	gAO0JCQFGax3+fHwyGr/o3X46MLlxlDyI2F1g8UX0TLqPl7XSZNnZ/t3ZmybgAxsKAzvXAvAWJA
	oSPgz7+4Kq04qnKsCVi1LwFhrv4V7Kq9cMOLnk2TeSqtG3d2AHrDNEYqn+Nn4eqs2R6i2Ynf5vB
	wV9jTiuHbq3cO61Xkux7Ec4/oCnjPJXEU93aKR5bDbl6Ms2UYidqQHg2IfKvjqJRyw6Ha1jDfWF
	uQrQu/Ad2l3WSZj0VF0oHlpnehN3CmU29XqdMACOXWTuCwygRR9UxBF1PlcEHMuaBcgPgLFqEDw
	1Aqewok4j3Di77RDOafn5T64IlmOWRqjX3tiMrVBF1GOE0SQmIsntUqHHGyONw0wa2HrwlDeWA+
	WWObWpKZw==
X-Received: by 2002:a17:907:608d:b0:c21:1b58:fa96 with SMTP id a640c23a62f3a-c31a9a28c37mr1817626166b.3.1792075893999;
        Thu, 15 Oct 2026 07:51:33 -0700 (PDT)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3eda62d2ebsm136202766b.74.2026.10.15.07.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:51:33 -0700 (PDT)
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
Subject: [PATCH RFC 09/20] ctlv: Prepare VA blob handling
Date: Thu, 15 Oct 2026 16:50:42 +0200
Message-ID: <20261015145053.3664509-10-jiri@resnulli.us>
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

Add task-bound VA blob resolution and CPU read/write access for CTLV
families.

The blob object can be compile-checked individually. CONFIG_CTLV remains
unwired until device dispatch completes the module.

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/ctlv/Makefile       |   2 +-
 drivers/ctlv/blob.c         | 355 ++++++++++++++++++++++++++++++++++++
 drivers/ctlv/blob.h         |  15 ++
 drivers/ctlv/internal.h     |   8 +
 include/linux/ctlv.h        |  41 +++++
 include/linux/ctlv_family.h |  23 +++
 6 files changed, 443 insertions(+), 1 deletion(-)
 create mode 100644 drivers/ctlv/blob.c
 create mode 100644 drivers/ctlv/blob.h

diff --git a/drivers/ctlv/Makefile b/drivers/ctlv/Makefile
index e1a22a199ef1..4455062f83d7 100644
--- a/drivers/ctlv/Makefile
+++ b/drivers/ctlv/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_CTLV) += ctlv.o
 
-ctlv-y += blob_desc.o builder.o message.o schema.o
+ctlv-y += blob.o blob_desc.o builder.o message.o schema.o
diff --git a/drivers/ctlv/blob.c b/drivers/ctlv/blob.c
new file mode 100644
index 000000000000..2c93da62b201
--- /dev/null
+++ b/drivers/ctlv/blob.c
@@ -0,0 +1,355 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Blob backing is acquired lazily in the submitting task and held until put.
+ */
+#include <linux/align.h>
+#include <linux/atomic.h>
+#include <linux/bits.h>
+#include <linux/capability.h>
+#include <linux/ctlv.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/highmem.h>
+#include <linux/limits.h>
+#include <linux/minmax.h>
+#include <linux/mm.h>
+#include <linux/mm_types.h>
+#include <linux/overflow.h>
+#include <linux/sched.h>
+#include <linux/sched/mm.h>
+#include <linux/sched/signal.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#include <uapi/linux/ctlv.h>
+#include <uapi/linux/ctlv_gen.h>
+
+#include "blob.h"
+#include "blob_desc.h"
+#include "internal.h"
+#include "message.h"
+
+struct ctlv_blob {
+	u64 len;
+	u8 direction;
+	u8 type;
+	struct ctlv_op_ctx *ctx;
+	struct list_head entry;
+	union {
+		struct {
+			struct mm_struct *mm;
+			struct page **pages;
+			unsigned long pages_count;
+			u32 start;
+		} va;
+	};
+};
+
+static bool ctlv_blob_readable(const struct ctlv_blob *blob)
+{
+	return blob->direction != CTLV_BLOB_DIRECTION_OUTPUT;
+}
+
+static bool ctlv_blob_writable(const struct ctlv_blob *blob)
+{
+	return blob->direction != CTLV_BLOB_DIRECTION_INPUT;
+}
+
+static bool ctlv_blob_same_task(const struct ctlv_blob *blob)
+{
+	return !blob->ctx || !blob->ctx->submitter || blob->ctx->submitter == current;
+}
+
+static bool ctlv_blob_access_live(const struct ctlv_blob *blob)
+{
+	return ctlv_blob_same_task(blob) && (!blob->ctx || blob->ctx->blobs_live);
+}
+
+/*
+ * Charged against RLIMIT_MEMLOCK of the address space the pages came from. A
+ * pin lasts one op, which is why it is not FOLL_LONGTERM.
+ */
+static int ctlv_blob_pin_charge(struct mm_struct *mm, unsigned long pages_count)
+{
+	unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+
+	if (atomic64_add_return(pages_count, &mm->pinned_vm) > limit && !capable(CAP_IPC_LOCK)) {
+		atomic64_sub(pages_count, &mm->pinned_vm);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static int ctlv_blob_va_range(u64 address, u64 len, unsigned long *first_page,
+			      unsigned long *pages_count)
+{
+	unsigned long first, last, span, count;
+	size_t bytes;
+	u64 end;
+
+	if (!len)
+		return -EINVAL;
+	if (check_add_overflow(address, len, &end) || end > TASK_SIZE)
+		return -EFAULT;
+
+	/* Bounded by an unsigned long above, so nothing below loses a bit. */
+	first = (unsigned long)address & PAGE_MASK;
+	last = ((unsigned long)end - 1) & PAGE_MASK;
+	if (check_sub_overflow(last, first, &span) ||
+	    check_add_overflow(span >> PAGE_SHIFT, 1UL, &count) ||
+	    check_mul_overflow(count, sizeof(struct page *), &bytes))
+		return -EFAULT;
+
+	*first_page = first;
+	*pages_count = count;
+	return 0;
+}
+
+static int ctlv_blob_va_acquire(struct ctlv_blob *blob, u64 address)
+{
+	unsigned long pinned = 0, first, pages_count;
+	unsigned int gup_flags = 0;
+	struct page **pages;
+	int ret;
+
+	/* Before charging or allocating, both of which this sizes. */
+	ret = ctlv_blob_va_range(address, blob->len, &first, &pages_count);
+	if (ret)
+		return ret;
+
+	pages = kvmalloc_array(pages_count, sizeof(*pages), GFP_KERNEL_ACCOUNT);
+	if (!pages)
+		return -ENOMEM;
+
+	if (ctlv_blob_writable(blob))
+		gup_flags |= FOLL_WRITE;
+	ret = ctlv_blob_pin_charge(current->mm, pages_count);
+	if (ret)
+		goto err_free_pages;
+
+	while (pinned < pages_count) {
+		long got = pin_user_pages_fast(first + (pinned << PAGE_SHIFT),
+					       min_t(unsigned long, pages_count - pinned, INT_MAX),
+					       gup_flags, pages + pinned);
+
+		/* A short pin is progress; nothing pinned is the caller's. */
+		if (got <= 0) {
+			ret = got ? (int)got : -EFAULT;
+			goto err_unpin;
+		}
+		pinned += got;
+	}
+
+	/* Referenced, so the unpin is safe however far the submitter got. */
+	mmgrab(current->mm);
+	blob->va.start = offset_in_page(address);
+	blob->va.mm = current->mm;
+	blob->va.pages = pages;
+	blob->va.pages_count = pages_count;
+	return 0;
+
+	/* The pins taken, and the whole charge, which covered every page. */
+err_unpin:
+	unpin_user_pages(pages, pinned);
+	atomic64_sub(pages_count, &current->mm->pinned_vm);
+err_free_pages:
+	kvfree(pages);
+	return ret;
+}
+
+static void ctlv_blob_va_release(struct ctlv_blob *blob)
+{
+	/* Dirtied, so that what the kernel wrote survives the unpin. */
+	unpin_user_pages_dirty_lock(blob->va.pages, blob->va.pages_count, ctlv_blob_writable(blob));
+	atomic64_sub(blob->va.pages_count, &blob->va.mm->pinned_vm);
+	kvfree(blob->va.pages);
+	mmdrop(blob->va.mm);
+}
+
+static void ctlv_blob_va_copy(struct ctlv_blob *blob, u64 offset, void *buf, size_t len, bool write)
+{
+	u64 at = blob->va.start + offset;
+	unsigned long index = at >> PAGE_SHIFT;
+	u32 in_page = offset_in_page(at);
+	u8 *bytes = buf;
+
+	while (len) {
+		struct page *page = blob->va.pages[index++];
+		size_t step = min_t(size_t, len, PAGE_SIZE - in_page);
+
+		if (write)
+			memcpy_to_page(page, in_page, bytes, step);
+		else
+			memcpy_from_page(bytes, page, in_page, step);
+		bytes += step;
+		len -= step;
+		in_page = 0;
+	}
+}
+
+u64 ctlv_blob_len(const struct ctlv_blob *blob)
+{
+	return blob->len;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_blob_len, "CTLV");
+
+/*
+ * The length, the direction and addressing from zero are all the family's own
+ * to know, so getting one wrong is a kernel bug rather than a caller's.
+ */
+static bool ctlv_blob_range_ok(struct ctlv_blob *blob, u64 offset, size_t len, bool write)
+{
+	u64 end;
+
+	if (WARN_ON_ONCE(write ? !ctlv_blob_writable(blob) : !ctlv_blob_readable(blob)))
+		return false;
+	if (WARN_ON_ONCE(!ctlv_blob_access_live(blob)))
+		return false;
+	if (WARN_ON_ONCE(check_add_overflow(offset, (u64)len, &end) || end > blob->len))
+		return false;
+	return true;
+}
+
+static int ctlv_blob_copy(struct ctlv_blob *blob, u64 offset, void *buf, size_t len, bool write)
+{
+	if (!ctlv_blob_range_ok(blob, offset, len, write))
+		return -EINVAL;
+	if (!len)
+		return 0;
+
+	switch (blob->type) {
+	case CTLV_BLOB_TYPE_VA:
+		ctlv_blob_va_copy(blob, offset, buf, len, write);
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+int ctlv_blob_read(struct ctlv_blob *blob, u64 offset, void *dst, size_t len)
+{
+	return ctlv_blob_copy(blob, offset, dst, len, false);
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_blob_read, "CTLV");
+
+int ctlv_blob_write(struct ctlv_blob *blob, u64 offset, const void *src, size_t len)
+{
+	return ctlv_blob_copy(blob, offset, (void *)src, len, true);
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_blob_write, "CTLV");
+
+int ctlv_blob_put(struct ctlv_blob *blob)
+{
+	if (!blob)
+		return 0;
+	if (WARN_ON_ONCE(!ctlv_blob_same_task(blob)))
+		return -EINVAL;
+
+	switch (blob->type) {
+	case CTLV_BLOB_TYPE_VA:
+		ctlv_blob_va_release(blob);
+		break;
+	}
+	if (blob->ctx) {
+		list_del(&blob->entry);
+		blob->ctx = NULL;
+	}
+	kfree(blob);
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_blob_put, "CTLV");
+
+void ctlv_blob_context_init(struct ctlv_op_ctx *ctx)
+{
+	INIT_LIST_HEAD(&ctx->blobs);
+	ctx->blobs_live = true;
+	ctx->blob_error = 0;
+}
+
+void ctlv_blob_context_track(struct ctlv_blob *blob, struct ctlv_op_ctx *ctx)
+{
+	blob->ctx = ctx;
+	list_add_tail(&blob->entry, &ctx->blobs);
+}
+
+int ctlv_blob_context_finish(struct ctlv_op_ctx *ctx)
+{
+	ctx->blobs_live = false;
+	if (WARN_ON_ONCE(!list_empty(&ctx->blobs)) && !ctx->blob_error)
+		ctx->blob_error = -EINVAL;
+	while (!list_empty(&ctx->blobs)) {
+		struct ctlv_blob *blob = list_first_entry(&ctx->blobs, struct ctlv_blob, entry);
+
+		ctlv_blob_put(blob);
+	}
+	return ctx->blob_error;
+}
+
+/*
+ * Which of an op's blobs was the unusable one, in the shape validation would
+ * have used. The errno the family returns says what went wrong.
+ */
+static void ctlv_blob_context_fail(struct ctlv_op_ctx *ctx, const struct ctlv_cursor *cursor)
+{
+	if (ctx->error.reason)
+		return;
+	ctx->error = (struct ctlv_error){
+		.reason = CTLV_VALIDATION_REASON_BAD_BLOB_DESCRIPTOR,
+		.bad_attr_offset = ctlv_message_offset(cursor->msg, cursor->attr),
+		.nest_offset = ctlv_message_offset(cursor->msg, cursor->parent),
+	};
+}
+
+static struct ctlv_blob *ctlv_blob_acquire(const struct ctlv_blob_desc *desc, u8 direction)
+{
+	u64 address = desc->member[CTLV_BLOB_MEMBER_ADDRESS];
+	u64 len = desc->member[CTLV_BLOB_MEMBER_LENGTH];
+	struct ctlv_blob *blob;
+	int ret;
+
+	blob = kzalloc_obj(*blob, GFP_KERNEL_ACCOUNT);
+	if (!blob)
+		return ERR_PTR(-ENOMEM);
+	INIT_LIST_HEAD(&blob->entry);
+	blob->len = len;
+	blob->direction = direction;
+	blob->type = desc->member[CTLV_BLOB_MEMBER_TYPE];
+
+	ret = ctlv_blob_va_acquire(blob, address);
+	if (ret) {
+		kfree(blob);
+		return ERR_PTR(ret);
+	}
+	return blob;
+}
+
+struct ctlv_blob *ctlv_blob_resolve(struct ctlv_op_ctx *ctx, const struct ctlv_cursor *blob)
+{
+	const struct ctlv_attr *bad = NULL;
+	const struct ctlv_node_schema *node;
+	struct ctlv_blob_desc desc;
+	struct ctlv_blob *acquired;
+
+	/* An absent blob, or a cursor from some other execution entirely. */
+	if (WARN_ON_ONCE(blob->msg != &ctx->request || !ctlv_attr_ok(blob)))
+		return ERR_PTR(-EINVAL);
+	node = &blob->tree->node_schemas[blob->node];
+	if (WARN_ON_ONCE(node->kind != CTLV_SCHEMA_BLOB))
+		return ERR_PTR(-EINVAL);
+	if (WARN_ON_ONCE(!ctx->blobs_live || !ctx->submitter || ctx->submitter != current))
+		return ERR_PTR(-EINVAL);
+	/* Validated before the callback, so anything wrong with it is a bug. */
+	if (WARN_ON_ONCE(ctlv_blob_desc_read(blob->attr, &desc, &bad) ||
+			 ctlv_blob_desc_check(&desc, node)))
+		return ERR_PTR(-EINVAL);
+
+	acquired = ctlv_blob_acquire(&desc, node->blob.direction);
+	if (IS_ERR(acquired))
+		ctlv_blob_context_fail(ctx, blob);
+	else
+		ctlv_blob_context_track(acquired, ctx);
+	return acquired;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_blob_resolve, "CTLV");
diff --git a/drivers/ctlv/blob.h b/drivers/ctlv/blob.h
new file mode 100644
index 000000000000..bb7b933a1ced
--- /dev/null
+++ b/drivers/ctlv/blob.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _CTLV_BLOB_H
+#define _CTLV_BLOB_H
+
+#include <linux/types.h>
+
+struct ctlv_blob;
+struct ctlv_op_ctx;
+
+void ctlv_blob_context_init(struct ctlv_op_ctx *ctx);
+void ctlv_blob_context_track(struct ctlv_blob *blob,
+			     struct ctlv_op_ctx *ctx);
+int ctlv_blob_context_finish(struct ctlv_op_ctx *ctx);
+
+#endif /* _CTLV_BLOB_H */
diff --git a/drivers/ctlv/internal.h b/drivers/ctlv/internal.h
index 7d2b43857299..f74724269628 100644
--- a/drivers/ctlv/internal.h
+++ b/drivers/ctlv/internal.h
@@ -8,12 +8,15 @@
 #define _CTLV_INTERNAL_H
 
 #include <linux/ctlv_family.h>
+#include <linux/list.h>
 #include <linux/types.h>
 
 #include <uapi/linux/ctlv.h>
 
 #include "message.h"
 
+struct task_struct;
+
 #define CTLV_ERROR_MESSAGE_LEN 256
 
 /* An op that is always enabled has no per-device availability state. */
@@ -50,6 +53,8 @@ struct ctlv_query_fragment {
 
 struct ctlv_op_ctx {
 	const struct ctlv_family *family;
+	/* Compared against current and never followed: identity, not a hold. */
+	const struct task_struct *submitter;
 	const struct ctlv_op_entry *op;
 
 	struct ctlv_msg request;
@@ -60,6 +65,9 @@ struct ctlv_op_ctx {
 	struct ctlv_cursor *deepest;
 
 	struct ctlv_query_fragment frag;
+	struct list_head blobs;
+	bool blobs_live;
+	int blob_error;
 	struct ctlv_error error;
 };
 
diff --git a/include/linux/ctlv.h b/include/linux/ctlv.h
index 45f0c53b56ea..dd2206cccfb5 100644
--- a/include/linux/ctlv.h
+++ b/include/linux/ctlv.h
@@ -123,4 +123,45 @@ int ctlv_op_query_more(struct ctlv_op_ctx *ctx, u64 generation,
  */
 int ctlv_op_query_done(struct ctlv_op_ctx *ctx, u64 generation);
 
+struct ctlv_blob;
+
+/**
+ * ctlv_blob_put - Release a resolved blob.
+ * @blob: blob returned by a generated resolve helper
+ *
+ * Return: 0, or a negative error.
+ */
+int ctlv_blob_put(struct ctlv_blob *blob);
+
+/**
+ * ctlv_blob_len - Get a resolved blob's length.
+ * @blob: resolved blob
+ *
+ * Return: blob length in bytes.
+ */
+u64 ctlv_blob_len(const struct ctlv_blob *blob);
+
+/**
+ * ctlv_blob_read - Copy bytes from a resolved input blob.
+ * @blob: resolved blob
+ * @offset: byte offset
+ * @dst: destination buffer
+ * @len: number of bytes
+ *
+ * Return: 0, or a negative error.
+ */
+int ctlv_blob_read(struct ctlv_blob *blob, u64 offset, void *dst, size_t len);
+
+/**
+ * ctlv_blob_write - Copy bytes to a resolved output blob.
+ * @blob: resolved blob
+ * @offset: byte offset
+ * @src: source buffer
+ * @len: number of bytes
+ *
+ * Return: 0, or a negative error.
+ */
+int ctlv_blob_write(struct ctlv_blob *blob, u64 offset, const void *src,
+		    size_t len);
+
 #endif /* _LINUX_CTLV_H */
diff --git a/include/linux/ctlv_family.h b/include/linux/ctlv_family.h
index d2598ec686f1..5cdcdfeec651 100644
--- a/include/linux/ctlv_family.h
+++ b/include/linux/ctlv_family.h
@@ -336,6 +336,8 @@ bool ctlv_put_binary(struct ctlv_cursor *nest, u64 attr_id, u8 kind,
 bool ctlv_nest_start(struct ctlv_cursor *nest, struct ctlv_cursor *child,
 		     u64 attr_id, u8 kind);
 
+struct ctlv_blob *ctlv_blob_resolve(struct ctlv_op_ctx *ctx,
+				    const struct ctlv_cursor *blob);
 #define __CTLV_DEFINE_PUT(_name, _type, _put_fn, _attr_id, _kind) \
 static inline bool _name##_put(struct ctlv_cursor *nest,		\
 			       _type value)			\
@@ -448,6 +450,17 @@ static inline void _name##_get(struct ctlv_cursor *nested,	\
 	ctlv_input_attr(nested, nest, _name##_ref());		\
 }
 
+#define CTLV_IN_BLOB(_name)					\
+static inline struct ctlv_blob *				\
+_name##_resolve(struct ctlv_op_ctx *ctx,			\
+		const struct ctlv_cursor *nest)			\
+{								\
+	struct ctlv_cursor attr;				\
+								\
+	ctlv_input_attr(&attr, nest, _name##_ref());		\
+	return ctlv_blob_resolve(ctx, &attr);			\
+}
+
 #define CTLV_IN_EACH_U64(_name)					\
 static inline u64 _name##_get(const struct ctlv_cursor *attr)	\
 {								\
@@ -492,4 +505,14 @@ _name##_get(const struct ctlv_cursor *attr, u32 *len)		\
 	return ctlv_attr_binary(attr, len);			\
 }
 
+#define CTLV_IN_EACH_BLOB(_name)				\
+static inline struct ctlv_blob *				\
+_name##_resolve(struct ctlv_op_ctx *ctx,			\
+		const struct ctlv_cursor *attr)			\
+{								\
+	if (!ctlv_input_cursor(attr, _name##_ref()))		\
+		return ERR_PTR(-EINVAL);				\
+	return ctlv_blob_resolve(ctx, attr);			\
+}
+
 #endif /* _LINUX_CTLV_FAMILY_H */
-- 
2.56.0

