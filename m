Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585363;
	b=hNSRx4gmyOPQUm+s/4agnpsc6Zb5hguwrKEBLSIpE2SGCnWNdZ/IxST2prz/5HoyYuOQ
	 /BPxkBtHC3tj+sCCvkxop+V/lGglN3ECsaQXbjemPhVmnYLuqc5ksRNM0v+LFk+2TZ2VI
	 Cg29ECoqYjlb99ooEYlPtajjvpju8ADckBIsXUF+wiIuwDwfSJtU2AMwaDhM5E31zKB09
	 3ySc+DSI3LySpIuTK65tfQALH9gIvLXBSNOSnYkTGJraccWbUwR0QO66PXqbMS9TxR4Hr
	 AzGcixd33SSGYNFpDea6uK2AyD6yQ8ZQmG0wWz9ycWwYU6eO2dmrhl3Dr0Qvbv0DwbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585363;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SqSOMLlgNYqrdAahJUcBEY9hyvikJuhwkxWdK8FO/sU=;
	b=Gdua/5X7ZFKIw02kTUFzHTRm+rNJRMKXoQY3zOtmTdlZHKamdQLXxPzEjzXT4Z7L9HYa
	 /Q/2YmUE38DlGDBpMzfcfEMjK7A7sbn2dj3ZeUwq9sXWsP7cD15QtlK4GHxt8ouWN0u6j
	 +xwiFPb2lPLFjhrRxiLgG/mrDbX/DadnjOkndtlXcv5Rl8FL6tGY1fSz5PQgeDVpC5t+3
	 tX5kGS/UtD34ESzl0RGRR+s1qI8akJ6Ao4Ka3HbCGldqgyxDqt2m5P5eAr9qfjvoLCNUe
	 O+qB3X7FVVzUC7cQzSFU4+3n6rN7txXg+5+O5cFTfL41XGp+hqWQC/9SdgtioreATSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b="i1cN/i98";
	arc=none smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149BF60A6F78
	for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 15:56:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 149BF60A6F78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=i1cN/i98
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c4cb6834eaaso262456266b.2
        for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 07:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1794585360; x=1795190160; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SqSOMLlgNYqrdAahJUcBEY9hyvikJuhwkxWdK8FO/sU=;
        b=i1cN/i98jfHXQVTMitG8989Rz8yPknv5VA6vlRKxBc+vRx7TKDnKnFuXLIZ0/D9wui
         dLiUNXatpq4CN0+iWgDqnZlNg1r88Y3vxQQq6jVA7BiuaITfJTy9qX5uI39GuZk20s1t
         JI1FyBFXmWJfmDTHevBqhIl7lanS9N/207SeZw8YFfo42X6owB1IfcBXhjzEy1mRcR6T
         m9d1SW48IshRuhBEO7cpgn4VY+ZgJnnGxAKpKysj9+VTvbiKezXkgKb++CfZU+EfgJ8f
         9sCHaYZTr3KdjPXRB2Y6cyHx9hJO4mCV4wAcKhGaIgcSpNDNPmCfLLSE8NVCUHFlvQGl
         MlaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794585360; x=1795190160;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SqSOMLlgNYqrdAahJUcBEY9hyvikJuhwkxWdK8FO/sU=;
        b=b8pY35mbEkthzcUmuoL4whnmBJqCFOrO9hqjpdT1cOJ4y08slF7kwRQ/8TLAXjRVOd
         h5RO0quCBub2rByMAZgmbycwMpaUbsKQJuDkuSdnr2X/dWZ1Zz1y8gfcyL1VVR/9cYAn
         oJrBAbrBYGMxyB7iGoJ5F3sBBtoVv6hynx4O1lSxTD5wbUYJVt/0LriXKw2oOGmnR6yC
         5TpaxCldpNGeCgSVAalmQqbX8mMEnrxUTLHuM0+z6CXeBgitCe11JpfNMlSQAqQsbEpD
         jSJhzwgHYXHgTNPHr2Ka1F/RuZBUJBkPN90N/rcd8D0rcjarhuQv7EjZIJ71pKcFEE69
         9xKA==
X-Forwarded-Encrypted: i=1; AL+hErHBMLq12gRXN8hiIwlNIDdJHpU7Qg4LhqY04FNkbfFle8uv1HuYwUGxqTzWPz6LaOMW96tyx4DlRXE=@vger.kernel.org
X-Gm-Message-State: APuU4Z/f75l16vz+U1tX7xx93LLo1WG0duP02006voSZJL3rGEH1koaJ
	qRUhW4r6cxzug+NB6IITcKCGkv78VYHmCe8I4mAWq3WNCG1tAUJ2PvKNU6Ir2xn4B1E=
X-Gm-Gg: AYBFou15ytu+wSmkbGDf1rJYjYiHBUJMuI19feWPqHSsM5IVcsqzFWurI5UNFVzkXM6
	+swVIHNjw0H6gyfwApP8yX7BWpBIdRwu4rMT0vSo3IsrRY4y1S5kFta9SjIWn2cp/361xQxM7wN
	pFnpEiGaoE/6cqto+KX+Tha6v6sHTk7O43y02DlrI8QXsfpdr9AZzRClJ7sicXSTY7jRiePSxe0
	TfLJ/MuOemZabVvtXX1yFjelA/tJS9wObha4yGfKp8EW+B5Pjyjs0JbMDKf2p3nGCfe7RJuLaZk
	RNmZEj0eMav2PGCXL2+pA+qPjH5R9g+jd3adZBYHk5GdDzC+o5Yb4PydVhBD4rtI5qmyoct6sdv
	krvFimky7cVyvKeftU6yTBEsK4D9kX7LuQDMkF3DfDF5vrji5EV5iKjEXHvkAsd6WWIHHFaF2iG
	pU34mUwTmIAkC1sb83WWvCUDjFXHErEImhjp8x4GXDrNGxnIl6y1mnEK3noOnI4RO2kP/GujGt2
	ekG7Q6PhU8MgGs7xq6neQYB157D9WNzl22IbMchJhZKiWcQ3JNYPBjzJUn9m+KSEDETPyYy3fLj
	tmZFs38A9reGIOk76tGmFyA/qwN2QKguIkQTHuIx
X-Received: by 2002:a17:906:ee85:b0:c4d:2895:e492 with SMTP id a640c23a62f3a-c509636a10dmr240061566b.21.1794585360413;
        Fri, 13 Nov 2026 07:56:00 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b7d1b7sm116345166b.74.2026.11.13.07.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 07:55:59 -0800 (PST)
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
Subject: [PATCH RFC v2 09/15] ctlv: Prepare VA blob handling
Date: Fri, 13 Nov 2026 16:55:08 +0100
Message-ID: <20261113155515.2510194-10-jiri@resnulli.us>
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

Add task-bound VA blob resolution and CPU read/write access for CTLV
families.

The blob object can be compile-checked individually. CONFIG_CTLV remains
unwired until operation dispatch completes the module.

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- released a context's blobs from any task
- returned EOVERFLOW for a blob range that wraps
- moved the function kernel-doc to the definitions
- said TLV, type, record and field instead of attr
- said record instead of nest, the root being one
- added ctlv_blob_too_short() for an output blob too short
- took the UAPI headers from include/uapi/ctlv/
- moved to lib/ctlv/
---
 include/linux/ctlv.h        |   9 +
 include/linux/ctlv_family.h |  23 ++
 lib/ctlv/Makefile           |   2 +-
 lib/ctlv/blob.c             | 421 ++++++++++++++++++++++++++++++++++++
 lib/ctlv/blob.h             |  15 ++
 lib/ctlv/internal.h         |   8 +
 6 files changed, 477 insertions(+), 1 deletion(-)
 create mode 100644 lib/ctlv/blob.c
 create mode 100644 lib/ctlv/blob.h

diff --git a/include/linux/ctlv.h b/include/linux/ctlv.h
index 5b75550de678..afb71cc643d3 100644
--- a/include/linux/ctlv.h
+++ b/include/linux/ctlv.h
@@ -78,4 +78,13 @@ int ctlv_op_query_more(struct ctlv_op_ctx *ctx, u64 generation,
 		       u64 next_cursor);
 int ctlv_op_query_done(struct ctlv_op_ctx *ctx, u64 generation);
 
+struct ctlv_blob;
+
+int ctlv_blob_put(struct ctlv_blob *blob);
+u64 ctlv_blob_len(const struct ctlv_blob *blob);
+int ctlv_blob_read(struct ctlv_blob *blob, u64 offset, void *dst, size_t len);
+int ctlv_blob_write(struct ctlv_blob *blob, u64 offset, const void *src,
+		    size_t len);
+int ctlv_blob_too_short(struct ctlv_blob *blob, u64 len);
+
 #endif /* _LINUX_CTLV_H */
diff --git a/include/linux/ctlv_family.h b/include/linux/ctlv_family.h
index 4d7d4fb65fec..61ae5b7cec83 100644
--- a/include/linux/ctlv_family.h
+++ b/include/linux/ctlv_family.h
@@ -451,6 +451,8 @@ bool ctlv_put_binary(struct ctlv_cursor *record, u64 type, u8 kind,
 bool ctlv_record_start(struct ctlv_cursor *record, struct ctlv_cursor *child,
 		       u64 type, u8 kind);
 
+struct ctlv_blob *ctlv_blob_resolve(struct ctlv_op_ctx *ctx,
+				    const struct ctlv_cursor *blob);
 #define __CTLV_DEFINE_PUT(_name, _ctype, _put_fn, _type, _kind)	\
 static inline bool _name##_put(struct ctlv_cursor *record,	\
 			       _ctype value)			\
@@ -560,6 +562,17 @@ static inline void _name##_get(struct ctlv_cursor *inner,	\
 	ctlv_input_field(inner, record, _name##_ref());		\
 }
 
+#define CTLV_IN_BLOB(_name)					\
+static inline struct ctlv_blob *				\
+_name##_resolve(struct ctlv_op_ctx *ctx,			\
+		const struct ctlv_cursor *record)		\
+{								\
+	struct ctlv_cursor cursor;				\
+								\
+	ctlv_input_field(&cursor, record, _name##_ref());	\
+	return ctlv_blob_resolve(ctx, &cursor);			\
+}
+
 #define CTLV_IN_EACH_U64(_name)					\
 static inline u64 _name##_get(const struct ctlv_cursor *cursor)	\
 {								\
@@ -604,4 +617,14 @@ _name##_get(const struct ctlv_cursor *cursor, u32 *len)		\
 	return ctlv_cursor_binary(cursor, len);			\
 }
 
+#define CTLV_IN_EACH_BLOB(_name)				\
+static inline struct ctlv_blob *				\
+_name##_resolve(struct ctlv_op_ctx *ctx,			\
+		const struct ctlv_cursor *cursor)		\
+{								\
+	if (!ctlv_input_cursor(cursor, _name##_ref()))		\
+		return ERR_PTR(-EINVAL);			\
+	return ctlv_blob_resolve(ctx, cursor);			\
+}
+
 #endif /* _LINUX_CTLV_FAMILY_H */
diff --git a/lib/ctlv/Makefile b/lib/ctlv/Makefile
index e1a22a199ef1..4455062f83d7 100644
--- a/lib/ctlv/Makefile
+++ b/lib/ctlv/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_CTLV) += ctlv.o
 
-ctlv-y += blob_desc.o builder.o message.o schema.o
+ctlv-y += blob.o blob_desc.o builder.o message.o schema.o
diff --git a/lib/ctlv/blob.c b/lib/ctlv/blob.c
new file mode 100644
index 000000000000..14cbbc4bcab1
--- /dev/null
+++ b/lib/ctlv/blob.c
@@ -0,0 +1,421 @@
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
+#include <uapi/ctlv/ctlv.h>
+#include <uapi/ctlv/ctlv_gen.h>
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
+	/* Where the descriptor sat in the request, for error information. */
+	u32 tlv_offset;
+	u32 record_offset;
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
+	if (check_add_overflow(address, len, &end))
+		return -EOVERFLOW;
+	if (end > TASK_SIZE)
+		return -EFAULT;
+
+	/* Bounded by an unsigned long above, so nothing below loses a bit. */
+	first = (unsigned long)address & PAGE_MASK;
+	last = ((unsigned long)end - 1) & PAGE_MASK;
+	if (check_sub_overflow(last, first, &span) ||
+	    check_add_overflow(span >> PAGE_SHIFT, 1UL, &count) ||
+	    check_mul_overflow(count, sizeof(struct page *), &bytes))
+		return -EOVERFLOW;
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
+/**
+ * ctlv_blob_len - Get a resolved blob's length.
+ * @blob: resolved blob
+ *
+ * Return: blob length in bytes.
+ */
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
+/**
+ * ctlv_blob_read - Copy bytes from a resolved input blob.
+ * @blob: resolved blob
+ * @offset: byte offset
+ * @dst: destination buffer
+ * @len: number of bytes
+ *
+ * Return: 0, or a negative error.
+ */
+int ctlv_blob_read(struct ctlv_blob *blob, u64 offset, void *dst, size_t len)
+{
+	return ctlv_blob_copy(blob, offset, dst, len, false);
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_blob_read, "CTLV");
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
+int ctlv_blob_write(struct ctlv_blob *blob, u64 offset, const void *src, size_t len)
+{
+	return ctlv_blob_copy(blob, offset, (void *)src, len, true);
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_blob_write, "CTLV");
+
+/* Any task can release: a VA blob unpins through the mm it pinned from. */
+static int ctlv_blob_release(struct ctlv_blob *blob)
+{
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
+
+/**
+ * ctlv_blob_put - Release a resolved blob.
+ * @blob: blob returned by a generated resolve helper
+ *
+ * Return: 0, or a negative error.
+ */
+int ctlv_blob_put(struct ctlv_blob *blob)
+{
+	if (!blob)
+		return 0;
+	if (WARN_ON_ONCE(!ctlv_blob_same_task(blob)))
+		return -EINVAL;
+	return ctlv_blob_release(blob);
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
+		ctlv_blob_release(blob);
+	}
+	return ctx->blob_error;
+}
+
+/*
+ * Which of an op's blobs was the unusable one, in the shape validation would
+ * have used. The errno the family returns says what went wrong.
+ */
+static void ctlv_blob_context_fail(struct ctlv_op_ctx *ctx, u32 tlv_offset, u32 record_offset,
+				   u64 required_length)
+{
+	if (ctx->error.reason)
+		return;
+	ctx->error.reason = CTLV_VALIDATION_REASON_BAD_BLOB_DESCRIPTOR;
+	ctx->error.bad_tlv_offset = tlv_offset;
+	ctx->error.record_offset = record_offset;
+	ctx->error.required_length = required_length;
+}
+
+/**
+ * ctlv_blob_too_short - Fail an op on an output blob too short for its data.
+ * @blob: resolved output blob
+ * @len: length the op needs @blob to have, more than it has
+ *
+ * Reports @blob and @len in the op's error information, unless an earlier
+ * failure is reported there already, so that the caller can retry with a
+ * blob that long.
+ *
+ * Return: -EMSGSIZE, for the family to return.
+ */
+int ctlv_blob_too_short(struct ctlv_blob *blob, u64 len)
+{
+	if (WARN_ON_ONCE(!ctlv_blob_writable(blob) || !blob->ctx || len <= blob->len))
+		return -EINVAL;
+	ctlv_blob_context_fail(blob->ctx, blob->tlv_offset, blob->record_offset, len);
+	return -EMSGSIZE;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_blob_too_short, "CTLV");
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
+	const struct ctlv_hdr *bad = NULL;
+	const struct ctlv_node_schema *node;
+	u32 tlv_offset, record_offset;
+	struct ctlv_blob_desc desc;
+	struct ctlv_blob *acquired;
+
+	/* An absent blob, or a cursor from some other execution entirely. */
+	if (WARN_ON_ONCE(blob->msg != &ctx->request || !ctlv_cursor_ok(blob)))
+		return ERR_PTR(-EINVAL);
+	node = &blob->tree->node_schemas[blob->node];
+	if (WARN_ON_ONCE(node->kind != CTLV_SCHEMA_BLOB))
+		return ERR_PTR(-EINVAL);
+	if (WARN_ON_ONCE(!ctx->blobs_live || !ctx->submitter || ctx->submitter != current))
+		return ERR_PTR(-EINVAL);
+	/* Validated before the callback, so anything wrong with it is a bug. */
+	if (WARN_ON_ONCE(ctlv_blob_desc_read(blob->hdr, &desc, &bad) ||
+			 ctlv_blob_desc_check(&desc, node)))
+		return ERR_PTR(-EINVAL);
+
+	tlv_offset = ctlv_message_offset(blob->msg, blob->hdr);
+	record_offset = ctlv_message_offset(blob->msg, blob->parent);
+	acquired = ctlv_blob_acquire(&desc, node->blob.direction);
+	if (IS_ERR(acquired)) {
+		ctlv_blob_context_fail(ctx, tlv_offset, record_offset, 0);
+		return acquired;
+	}
+	acquired->tlv_offset = tlv_offset;
+	acquired->record_offset = record_offset;
+	ctlv_blob_context_track(acquired, ctx);
+	return acquired;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_blob_resolve, "CTLV");
diff --git a/lib/ctlv/blob.h b/lib/ctlv/blob.h
new file mode 100644
index 000000000000..bb7b933a1ced
--- /dev/null
+++ b/lib/ctlv/blob.h
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
diff --git a/lib/ctlv/internal.h b/lib/ctlv/internal.h
index 90d07d2638d3..1dbab9709261 100644
--- a/lib/ctlv/internal.h
+++ b/lib/ctlv/internal.h
@@ -9,6 +9,7 @@
 
 #include <linux/bug.h>
 #include <linux/ctlv_family.h>
+#include <linux/list.h>
 #include <linux/types.h>
 
 #include <uapi/ctlv/ctlv.h>
@@ -22,6 +23,8 @@
 #define CTLV_ASSERT(cond) BUILD_BUG_ON_INVALID(cond)
 #endif
 
+struct task_struct;
+
 #define CTLV_ERROR_MESSAGE_LEN 256
 
 /* An op that is always enabled has no per-device availability state. */
@@ -58,6 +61,8 @@ struct ctlv_query_fragment {
 
 struct ctlv_op_ctx {
 	const struct ctlv_family *family;
+	/* Compared against current and never followed: identity, not a hold. */
+	const struct task_struct *submitter;
 	const struct ctlv_op_entry *op;
 
 	struct ctlv_msg request;
@@ -68,6 +73,9 @@ struct ctlv_op_ctx {
 	struct ctlv_cursor *deepest;
 
 	struct ctlv_query_fragment frag;
+	struct list_head blobs;
+	bool blobs_live;
+	int blob_error;
 	struct ctlv_error error;
 };
 
-- 
2.56.0

