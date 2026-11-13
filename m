Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585345;
	b=D0QgEBJQqEUnYOsoa0hcp8kg5cJvtx2ooJX9rCiwJlpqCUBGvRMdWH4j0Ma5wPP+ZKu8
	 XqXsbQgTkfXYOFVMbUaXqqxPPpQDOTipjTctc4rPTtmZxoN2sDTs5/myRPOiGVtmJncsd
	 ZF98TWxHHZZf0o2e1D6KUkqoGOLuG3Afh9Drz4BILsjmxIz4nKz6wXj8afQ0N9qQuapg/
	 2gQXJ9c8vuqu5SbjFgBO6F11x7gFULe3BajykF+mx8t4ZF+Qes8Euuc4EXmrt4eeBUDkz
	 Q3dRmnW4Py+9CODI9aWKuU69r9MzcIvi04i2zRCb83dDoQNhb9kBhbhmSGqOYGoCtYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585345;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ubN1mk+i7nW1H7WusoRpMOgl6Ah5cfrVaEroJUTQ41Y=;
	b=ceZht6LISURsLDb95nO3MElxxMgmCcN8l69mCitRTWkPd+IbIbmLGI+xvI6RpnMkSgiL
	 3EOnBB/O0H8sTsAx8eRloq+o4LNlfcjh/PnNClGs3YQZPPp0NcAGQero1SwvD7evezqCx
	 wI5M6Ej2zLXYrA8dNHXGYQ/1Uof1NsuaKgBqJPKMp9v8xdoZqz1nkCtssz0VRp7HyOgHK
	 vrzZx2sbx9rCiDxklgaQo/0KQBcotyZZTbzkurZ0BPtNnHHY6AFZQNd1jsqmsTDZgfwJz
	 wIpegNIeB7V766ZMSCSRENxVj5RH+Eu6MHCfW7ZyzP2twh1pMD4loVZuY/VBHAlcKmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=CNmVl7IN;
	arc=none smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2017460A380D
	for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 15:55:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2017460A380D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=CNmVl7IN
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c40e30c26a4so273803666b.0
        for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 07:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1794585342; x=1795190142; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ubN1mk+i7nW1H7WusoRpMOgl6Ah5cfrVaEroJUTQ41Y=;
        b=CNmVl7IN47J6sDNagDeK0zxryt9/DPUMBdMcWg/98Y1S8/+BXTTbRXpgCk9L6rwLng
         q/m7a7D+uYExrPHsMQ7e1q3pgH8uBi9z8c+jF89CQA1L7vTxzCL8bshwZFvfEaqH5ydq
         t5ngGnO5vdk2oAutbRBYmK81pycO+ePOzFlvQhpuE97gw99HdjEeUAMBewpuM993AeK6
         NakF4VNufAjy7DNYWp72uCa1utjNhLcC7DthGyWU7/8fHQVdaoOILixZkYc2Sv0uB68h
         tWGQHSk9JFRfVHE7boJYYn38L4C1bCjqhCWpLnOVATgcbn4UGxV1VQA55fMHq7w3YlR0
         Lv/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794585342; x=1795190142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ubN1mk+i7nW1H7WusoRpMOgl6Ah5cfrVaEroJUTQ41Y=;
        b=p2qqmvjLE+Q747Rsa0QX8Fdpn7qKYrsNEqMXoIXJoz+5F4vDPWOnH6jlqZW+TlZeff
         gzCMVYY8U5UZmU60gTMR+zi4Ax5T86ncmDfUaACG7sALGDWlOS8K7uphywbS5sX8kmXB
         t4Ph4Ttew9rM0elq3EU2LQT8bZlOGxreYv9YuvHu9QLYa6+S1ACDKD8RXSH+fhFOdK1s
         CAFKzd1jQNkX4RILmG7po2f77DN/zFO2cLqvyW2Za4+07bFsyYYEKeCi+cp0/UJ8D4XU
         RI1f7vy7bCBdNiAnpzmJ1X/uwAuENKw2CQN82DMKcDNK9K6XkyH2aGUNbDf0NZ9HevPJ
         0Uvw==
X-Forwarded-Encrypted: i=1; AL+hErFvJy09gpyBLazv8he2P/Yg2dmk955bP2XXhzekOkV2QcAGXYN8JWBP2pc/OdUe3+QtC7x0uzgpCDc=@vger.kernel.org
X-Gm-Message-State: APuU4Z+EdgD+niJT9nrTwU5xbFUg7dcqiratTH5aaXX9AjM2fMunvDzS
	XLodm2ppccLLYg5gxUgOEtEBx2qpac8A6e8GpTDIfxaJRM9PIF47a0zt6ElXpkBp1CU=
X-Gm-Gg: AYBFou00GrN4gl/MfP9zCJz9HhAbOmZEwYxUNXDr3FQvVLUKAnFSw0RUJWwpIvCnTiC
	iQ9mVs1VOuvwiXjFimKz5NAlF+7C+I1DKD6GWFopCp7FVzBMjh5P6SnTparKa3c0E5RokHY7gbN
	lMbELqou6iqSRygaEtEJvq5ZIFSCIHdW0TmUkEOz5CMcTVYahluMU1BPLo8/ufse2BOyR689nbq
	OkfNokPJx3IhZD7nSyTUuGnNSS04u8aw81Z06lsX54ZebA48vd154GLeAnK0+BbBq8UIGvNhE0N
	bQ0ZP+zhGCrrg8FvsYsqUT0o72NROcksKRtGc1L3JUjTwoKnPCah2BTTj9VD+CLY7Z6n9bnmPVc
	CWoaPY7dMxwEZ8k6nRiEpWeKKeyvxcU0gVht7vgV57pW+PQ3rpi5uckyh1BUTSSzE+ZPzvMR2hc
	Bs0yHZ8JgWXbCBcGee3n1W0Z5DkMZv6PxRDrx+p+7G0sNQNdOE2z85lbJ9jMUo1alSNU3tK4on9
	onDLJ27Q0k6CSLmQ3gGme6KoTMJxEbtkvTRANNsDSDoiu2+6lbpBlHa9weZhsizSUbeYq3dYAME
	EoZQOdzOrFx7S4jRxrD84yQI6sVu6QFoua5Y/0mi
X-Received: by 2002:a17:907:9285:b0:c49:8bf8:a7a7 with SMTP id a640c23a62f3a-c50963173bamr262363966b.7.1794585342405;
        Fri, 13 Nov 2026 07:55:42 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b4214fsm117253966b.35.2026.11.13.07.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 07:55:41 -0800 (PST)
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
Subject: [PATCH RFC v2 05/15] ctlv: Prepare message input handling
Date: Fri, 13 Nov 2026 16:55:04 +0100
Message-ID: <20261113155515.2510194-6-jiri@resnulli.us>
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

Add TLV walking, request indexing and validated input accessors for
generated family readers, and CTLV_ASSERT() for the core's invariants
that no error path depends on, checked only with CONFIG_CTLV_DEBUG.

Keep CONFIG_CTLV unwired until dispatch completes the module.

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- made ctlv_attr_next() end the walk on an attr overrunning its scope
- made CTLV a symbol its users select, with no prompt or help
- used void pointer arithmetic for attr addresses
- scoped the rebind loop variable to its loop
- cleared the binary attr length once
- dropped the comment ending message.c
- added CTLV_ASSERT(), checked only with CONFIG_CTLV_DEBUG
- said TLV, type, record and field instead of attr
- said record instead of nest, the root being one
- kept the length an output blob needs with the error
- separated the steps of the longer functions
- numbered every enum member
- took the UAPI headers from include/uapi/ctlv/
- moved to lib/ctlv/
---
 MAINTAINERS                 |   1 +
 include/linux/ctlv_family.h | 135 +++++++++++++
 lib/ctlv/Kconfig            |  13 ++
 lib/ctlv/Makefile           |   4 +
 lib/ctlv/internal.h         |  74 +++++++
 lib/ctlv/message.c          | 393 ++++++++++++++++++++++++++++++++++++
 lib/ctlv/message.h          |  91 +++++++++
 7 files changed, 711 insertions(+)
 create mode 100644 lib/ctlv/Kconfig
 create mode 100644 lib/ctlv/Makefile
 create mode 100644 lib/ctlv/internal.h
 create mode 100644 lib/ctlv/message.c
 create mode 100644 lib/ctlv/message.h

diff --git a/MAINTAINERS b/MAINTAINERS
index e6748a4ad282..29bdb4de915d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7191,6 +7191,7 @@ F:	Documentation/ctlv/
 F:	Documentation/userspace-api/ctlv.rst
 F:	include/linux/ctlv*.h
 F:	include/uapi/ctlv/
+F:	lib/ctlv/
 F:	tools/ctlv/
 
 CTU CAN FD DRIVER
diff --git a/include/linux/ctlv_family.h b/include/linux/ctlv_family.h
index 360eb6e30974..ae8ed69df5ea 100644
--- a/include/linux/ctlv_family.h
+++ b/include/linux/ctlv_family.h
@@ -428,4 +428,139 @@ extern const struct ctlv_family ctlv_family;
 
 u32 ctlv_enum_ext_max(const struct ctlv_family *family, u16 family_id, u32 ext_id);
 
+struct ctlv_cursor *
+ctlv_input_field(struct ctlv_cursor *cursor, const struct ctlv_cursor *record,
+		 struct ctlv_input_ref ref);
+bool ctlv_input_cursor(const struct ctlv_cursor *cursor,
+		       struct ctlv_input_ref ref);
+void ctlv_cursor_next(struct ctlv_cursor *cursor);
+bool ctlv_cursor_ok(const struct ctlv_cursor *cursor);
+u64 ctlv_cursor_u64(const struct ctlv_cursor *cursor);
+s64 ctlv_cursor_s64(const struct ctlv_cursor *cursor);
+bool ctlv_cursor_bool(const struct ctlv_cursor *cursor);
+const char *ctlv_cursor_string(const struct ctlv_cursor *cursor);
+const void *ctlv_cursor_binary(const struct ctlv_cursor *cursor, u32 *len);
+
+#define CTLV_IN_REF(_name, _type, _kind)			\
+static inline struct ctlv_input_ref _name##_ref(void)		\
+{								\
+	return (struct ctlv_input_ref){				\
+		.type = (_type),				\
+		.kind = (_kind),				\
+	};							\
+}
+
+#define CTLV_IN_FOR_EACH(_name, _cursor, _record)		\
+	for (struct ctlv_cursor *__ctlv_cursor =		\
+		ctlv_input_field(_cursor, _record, _name##_ref()); \
+	     ctlv_cursor_ok(__ctlv_cursor);			\
+	     ctlv_cursor_next(__ctlv_cursor))
+
+#define CTLV_IN_HAS(_name)					\
+static inline bool _name##_present(const struct ctlv_cursor *record) \
+{								\
+	struct ctlv_cursor cursor;				\
+								\
+	ctlv_input_field(&cursor, record, _name##_ref());	\
+	return ctlv_cursor_ok(&cursor);				\
+}
+
+#define CTLV_IN_U64(_name)					\
+static inline u64 _name##_get(const struct ctlv_cursor *record)	\
+{								\
+	struct ctlv_cursor cursor;				\
+								\
+	ctlv_input_field(&cursor, record, _name##_ref());	\
+	return ctlv_cursor_u64(&cursor);			\
+}
+
+#define CTLV_IN_S64(_name)					\
+static inline s64 _name##_get(const struct ctlv_cursor *record)	\
+{								\
+	struct ctlv_cursor cursor;				\
+								\
+	ctlv_input_field(&cursor, record, _name##_ref());	\
+	return ctlv_cursor_s64(&cursor);			\
+}
+
+#define CTLV_IN_BOOL(_name)					\
+static inline bool _name##_get(const struct ctlv_cursor *record) \
+{								\
+	struct ctlv_cursor cursor;				\
+								\
+	ctlv_input_field(&cursor, record, _name##_ref());	\
+	return ctlv_cursor_bool(&cursor);			\
+}
+
+#define CTLV_IN_STRING(_name)					\
+static inline const char *					\
+_name##_get(const struct ctlv_cursor *record)			\
+{								\
+	struct ctlv_cursor cursor;				\
+								\
+	ctlv_input_field(&cursor, record, _name##_ref());	\
+	return ctlv_cursor_string(&cursor);			\
+}
+
+#define CTLV_IN_BINARY(_name)					\
+static inline const void *					\
+_name##_get(const struct ctlv_cursor *record, u32 *len)		\
+{								\
+	struct ctlv_cursor cursor;				\
+								\
+	ctlv_input_field(&cursor, record, _name##_ref());	\
+	return ctlv_cursor_binary(&cursor, len);		\
+}
+
+#define CTLV_IN_RECORD(_name)					\
+static inline void _name##_get(struct ctlv_cursor *inner,	\
+			       const struct ctlv_cursor *record) \
+{								\
+	ctlv_input_field(inner, record, _name##_ref());		\
+}
+
+#define CTLV_IN_EACH_U64(_name)					\
+static inline u64 _name##_get(const struct ctlv_cursor *cursor)	\
+{								\
+	if (!ctlv_input_cursor(cursor, _name##_ref()))		\
+		return 0;					\
+	return ctlv_cursor_u64(cursor);				\
+}
+
+#define CTLV_IN_EACH_S64(_name)					\
+static inline s64 _name##_get(const struct ctlv_cursor *cursor)	\
+{								\
+	if (!ctlv_input_cursor(cursor, _name##_ref()))		\
+		return 0;					\
+	return ctlv_cursor_s64(cursor);				\
+}
+
+#define CTLV_IN_EACH_BOOL(_name)				\
+static inline bool _name##_get(const struct ctlv_cursor *cursor) \
+{								\
+	if (!ctlv_input_cursor(cursor, _name##_ref()))		\
+		return false;					\
+	return ctlv_cursor_bool(cursor);			\
+}
+
+#define CTLV_IN_EACH_STRING(_name)				\
+static inline const char *					\
+_name##_get(const struct ctlv_cursor *cursor)			\
+{								\
+	if (!ctlv_input_cursor(cursor, _name##_ref()))		\
+		return NULL;					\
+	return ctlv_cursor_string(cursor);			\
+}
+
+#define CTLV_IN_EACH_BINARY(_name)				\
+static inline const void *					\
+_name##_get(const struct ctlv_cursor *cursor, u32 *len)		\
+{								\
+	if (!ctlv_input_cursor(cursor, _name##_ref())) {	\
+		*len = 0;					\
+		return NULL;					\
+	}							\
+	return ctlv_cursor_binary(cursor, len);			\
+}
+
 #endif /* _LINUX_CTLV_FAMILY_H */
diff --git a/lib/ctlv/Kconfig b/lib/ctlv/Kconfig
new file mode 100644
index 000000000000..465663bb7efa
--- /dev/null
+++ b/lib/ctlv/Kconfig
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config CTLV
+	tristate
+
+config CTLV_DEBUG
+	bool "CTLV core self-checks"
+	depends on CTLV
+	help
+	  Checks the CTLV core's own bookkeeping where no error path depends
+	  on the result, and warns once when it is wrong. The checks that do
+	  guard an error path are made either way.
+
+	  If you are unsure, say N.
diff --git a/lib/ctlv/Makefile b/lib/ctlv/Makefile
new file mode 100644
index 000000000000..4f0fe41bc9e1
--- /dev/null
+++ b/lib/ctlv/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_CTLV) += ctlv.o
+
+ctlv-y += message.o
diff --git a/lib/ctlv/internal.h b/lib/ctlv/internal.h
new file mode 100644
index 000000000000..90d07d2638d3
--- /dev/null
+++ b/lib/ctlv/internal.h
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * CTLV core internals.
+ */
+#ifndef _CTLV_INTERNAL_H
+#define _CTLV_INTERNAL_H
+
+#include <linux/bug.h>
+#include <linux/ctlv_family.h>
+#include <linux/types.h>
+
+#include <uapi/ctlv/ctlv.h>
+
+#include "message.h"
+
+/* Without CONFIG_CTLV_DEBUG @cond is not evaluated, so nothing may rely on it. */
+#ifdef CONFIG_CTLV_DEBUG
+#define CTLV_ASSERT(cond) ((void)WARN_ON_ONCE(!(cond)))
+#else
+#define CTLV_ASSERT(cond) BUILD_BUG_ON_INVALID(cond)
+#endif
+
+#define CTLV_ERROR_MESSAGE_LEN 256
+
+/* An op that is always enabled has no per-device availability state. */
+#define CTLV_OP_STATE_NONE U32_MAX
+
+struct ctlv_op_entry {
+	const struct ctlv_op_schema *schema;
+	const struct ctlv_op *binding;
+	struct ctlv_op_sizes sizes;
+	u32 state_index;
+	bool absent;
+};
+
+struct ctlv_error {
+	u32 reason;
+	char message[CTLV_ERROR_MESSAGE_LEN];
+	u32 bad_tlv_offset;
+	u32 record_offset;
+	u64 missing_type;
+	u64 expected_generation;
+	u64 current_generation;
+	u64 required_length;
+};
+
+struct ctlv_query_fragment {
+	u64 generation;
+	u64 cursor;
+	u64 reported;
+	u64 next_cursor;
+	bool progress;
+	bool answered;
+	int result;
+};
+
+struct ctlv_op_ctx {
+	const struct ctlv_family *family;
+	const struct ctlv_op_entry *op;
+
+	struct ctlv_msg request;
+	struct ctlv_cursor request_root;
+
+	struct ctlv_msg output;
+	struct ctlv_cursor output_root;
+	struct ctlv_cursor *deepest;
+
+	struct ctlv_query_fragment frag;
+	struct ctlv_error error;
+};
+
+#endif /* _CTLV_INTERNAL_H */
diff --git a/lib/ctlv/message.c b/lib/ctlv/message.c
new file mode 100644
index 000000000000..8d672e42cbe3
--- /dev/null
+++ b/lib/ctlv/message.c
@@ -0,0 +1,393 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Message walking, indexing, and generated-accessor primitives.
+ */
+#include <linux/align.h>
+#include <linux/bits.h>
+#include <linux/bug.h>
+#include <linux/ctlv.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/export.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#include <uapi/ctlv/ctlv.h>
+#include <uapi/ctlv/ctlv_gen.h>
+
+#include "internal.h"
+#include "message.h"
+
+enum ctlv_message_step ctlv_message_next(const struct ctlv_hdr *record,
+					 const struct ctlv_hdr **child)
+{
+	const u8 *end = (const u8 *)record + record->len;
+	const u8 *next;
+	size_t room;
+
+	if (record->len < sizeof(*record))
+		return CTLV_MESSAGE_STEP_BAD;
+	if (*child)
+		next = (const u8 *)*child + ALIGN((size_t)(*child)->len, CTLV_ALIGNTO);
+	else
+		next = (const u8 *)(record + 1);
+	if (next >= end)
+		return next == end ? CTLV_MESSAGE_STEP_END : CTLV_MESSAGE_STEP_BAD;
+
+	room = end - next;
+	if (room < sizeof(**child))
+		return CTLV_MESSAGE_STEP_BAD;
+	*child = (const struct ctlv_hdr *)next;
+	/*
+	 * Length before alignment, so that aligning a length this record could
+	 * never hold is not what overflows.
+	 */
+	if ((*child)->len < sizeof(**child) || (*child)->len > room)
+		return CTLV_MESSAGE_STEP_BAD;
+	if (ALIGN((size_t)(*child)->len, CTLV_ALIGNTO) > room)
+		return CTLV_MESSAGE_STEP_BAD;
+	return CTLV_MESSAGE_STEP_TLV;
+}
+
+u32 ctlv_message_offset(const struct ctlv_msg *msg, const struct ctlv_hdr *hdr)
+{
+	return (const u8 *)hdr - (const u8 *)msg->root;
+}
+
+void ctlv_message_root(struct ctlv_cursor *cursor, struct ctlv_msg *msg)
+{
+	*cursor = (struct ctlv_cursor){
+		.msg = msg,
+		.hdr = msg->root,
+		.tree = msg->tree,
+		.index_record_scope = CTLV_MESSAGE_INPUT_INDEX_NONE,
+		.index_scope = CTLV_MESSAGE_INPUT_INDEX_NONE,
+	};
+	if (msg->request && msg->index)
+		cursor->index_record_scope = msg->index->records[0].first_scope;
+}
+
+static bool ctlv_message_record_index_ok(const struct ctlv_cursor *record)
+{
+	const struct ctlv_message_input_index *index = record->msg->index;
+	const struct ctlv_message_input_record *indexed;
+	const struct ctlv_message_input_scope *scope;
+	const struct ctlv_hdr *hdr;
+
+	if (WARN_ON_ONCE(!record->msg->request || !index ||
+			 record->index_record_scope >= index->scopes_count))
+		return false;
+	scope = &index->scopes[record->index_record_scope];
+	if (WARN_ON_ONCE(scope->record >= index->records_count))
+		return false;
+	indexed = &index->records[scope->record];
+	hdr = (const void *)record->msg->root + indexed->offset;
+	if (WARN_ON_ONCE(hdr != record->hdr))
+		return false;
+	return !WARN_ON_ONCE(scope->tree != record->tree || scope->node != record->node);
+}
+
+static bool ctlv_message_input_scope_ok(const struct ctlv_message_input_index *index,
+					const struct ctlv_message_input_scope *scope)
+{
+	return !WARN_ON_ONCE(scope->first_slot > index->slots_count ||
+			     scope->slots_count > index->slots_count - scope->first_slot);
+}
+
+/* A reader names a field its record lacks only by a family's mistake. */
+static bool ctlv_message_input_slot(const struct ctlv_cursor *record, struct ctlv_input_ref ref,
+				    u32 *slot)
+{
+	const struct ctlv_schema_tree *tree = record->tree;
+	const struct ctlv_node_schema *parent;
+	const struct ctlv_node_schema *node;
+
+	if (WARN_ON_ONCE(!tree || !tree->node_schemas || record->node >= tree->node_schemas_count))
+		return false;
+	parent = &tree->node_schemas[record->node];
+	if (WARN_ON_ONCE(parent->first_child > tree->node_schemas_count ||
+			 parent->children_count > tree->node_schemas_count - parent->first_child))
+		return false;
+	for (*slot = 0; *slot < parent->children_count; (*slot)++) {
+		node = &tree->node_schemas[parent->first_child + *slot];
+		if (node->type == ref.type)
+			return !WARN_ON_ONCE(node->kind != ref.kind);
+	}
+	WARN_ON_ONCE(1);
+	return false;
+}
+
+static const struct ctlv_message_input_slot *
+ctlv_message_cursor_index(const struct ctlv_cursor *cursor)
+{
+	const struct ctlv_message_input_index *index;
+	const struct ctlv_message_input_scope *scope;
+	const struct ctlv_node_schema *parent;
+	const struct ctlv_node_schema *node;
+	const struct ctlv_message_input_slot *slot;
+	const struct ctlv_message_input_record *record;
+	u32 local_slot;
+	u32 offset;
+
+	if (WARN_ON_ONCE(!cursor->msg || !cursor->tree || !cursor->msg->request ||
+			 !cursor->msg->index))
+		return NULL;
+
+	index = cursor->msg->index;
+	if (WARN_ON_ONCE(cursor->index_scope >= index->scopes_count))
+		return NULL;
+	scope = &index->scopes[cursor->index_scope];
+	if (!ctlv_message_input_scope_ok(index, scope))
+		return NULL;
+
+	parent = &scope->tree->node_schemas[scope->node];
+	if (WARN_ON_ONCE(scope->tree != cursor->tree || cursor->node < parent->first_child ||
+			 cursor->node >= parent->first_child + scope->slots_count))
+		return NULL;
+
+	local_slot = cursor->node - parent->first_child;
+	node = &cursor->tree->node_schemas[cursor->node];
+	slot = &index->slots[scope->first_slot + local_slot];
+	if (!cursor->hdr)
+		return slot;
+
+	if (WARN_ON_ONCE(cursor->hdr->type != node->type))
+		return NULL;
+	if (WARN_ON_ONCE(scope->record >= index->records_count))
+		return NULL;
+	record = &index->records[scope->record];
+	if (WARN_ON_ONCE(cursor->parent != (const void *)cursor->msg->root + record->offset))
+		return NULL;
+	offset = ctlv_message_offset(cursor->msg, cursor->hdr);
+	if (WARN_ON_ONCE(offset < slot->first_offset || offset >= slot->end_offset ||
+			 offset + ALIGN((size_t)cursor->hdr->len, CTLV_ALIGNTO) >
+				 slot->end_offset))
+		return NULL;
+
+	if (node->kind == CTLV_SCHEMA_RECORD) {
+		const struct ctlv_message_input_scope *record_scope;
+
+		if (WARN_ON_ONCE(cursor->index_record_scope >= index->scopes_count))
+			return NULL;
+		record_scope = &index->scopes[cursor->index_record_scope];
+		if (WARN_ON_ONCE(record_scope->record >= index->records_count ||
+				 index->records[record_scope->record].offset != offset ||
+				 record_scope->tree != cursor->tree ||
+				 record_scope->node != cursor->node))
+			return NULL;
+	} else if (WARN_ON_ONCE(cursor->index_record_scope != CTLV_MESSAGE_INPUT_INDEX_NONE)) {
+		return NULL;
+	}
+	return slot;
+}
+
+bool ctlv_message_input_rebind(struct ctlv_cursor *record, const struct ctlv_schema_tree *tree,
+			       u32 node)
+{
+	const struct ctlv_message_input_scope *bound_scope;
+	const struct ctlv_message_input_record *indexed;
+
+	if (WARN_ON_ONCE(!record->hdr || !record->msg || !record->msg->index))
+		return false;
+	if (!ctlv_message_record_index_ok(record))
+		return false;
+	bound_scope = &record->msg->index->scopes[record->index_record_scope];
+	indexed = &record->msg->index->records[bound_scope->record];
+	for (u32 i = 0; i < indexed->scopes_count; i++) {
+		u32 scope_index = indexed->first_scope + i;
+		const struct ctlv_message_input_scope *scope =
+			&record->msg->index->scopes[scope_index];
+
+		if (scope->tree != tree || scope->node != node)
+			continue;
+		record->tree = tree;
+		record->node = node;
+		record->index_record_scope = scope_index;
+		return true;
+	}
+	return false;
+}
+
+struct ctlv_cursor *ctlv_input_field(struct ctlv_cursor *cursor, const struct ctlv_cursor *record,
+				     struct ctlv_input_ref ref)
+{
+	const struct ctlv_message_input_index *index;
+	const struct ctlv_message_input_scope *scope;
+	const struct ctlv_message_input_slot *indexed;
+	u32 slot;
+
+	*cursor = (struct ctlv_cursor){
+		.index_record_scope = CTLV_MESSAGE_INPUT_INDEX_NONE,
+		.index_scope = CTLV_MESSAGE_INPUT_INDEX_NONE,
+	};
+
+	if (WARN_ON_ONCE(!record->hdr || !record->msg))
+		return cursor;
+	if (!ctlv_message_record_index_ok(record))
+		return cursor;
+
+	index = record->msg->index;
+	if (WARN_ON_ONCE(record->index_record_scope >= index->scopes_count))
+		return cursor;
+	scope = &index->scopes[record->index_record_scope];
+	if (!ctlv_message_input_scope_ok(index, scope))
+		return cursor;
+	if (!ctlv_message_input_slot(record, ref, &slot) ||
+	    WARN_ON_ONCE(slot >= scope->slots_count))
+		return cursor;
+
+	indexed = &index->slots[scope->first_slot + slot];
+	*cursor = (struct ctlv_cursor){
+		.msg = record->msg,
+		.parent = record->hdr,
+		.hdr = indexed->count ?
+			(const void *)record->msg->root + indexed->first_offset : NULL,
+		.tree = record->tree,
+		.node = record->tree->node_schemas[record->node].first_child + slot,
+		.depth = record->depth + 1,
+		.index_record_scope = CTLV_MESSAGE_INPUT_INDEX_NONE,
+		.index_scope = record->index_record_scope,
+	};
+
+	if (indexed->count && ref.kind == CTLV_SCHEMA_RECORD) {
+		if (WARN_ON_ONCE(indexed->first_record >= index->records_count))
+			return cursor;
+		cursor->index_record_scope = index->records[indexed->first_record].first_scope;
+	}
+	return cursor;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_input_field, "CTLV");
+
+bool ctlv_input_cursor(const struct ctlv_cursor *cursor, struct ctlv_input_ref ref)
+{
+	const struct ctlv_node_schema *node;
+
+	if (!ctlv_message_cursor_index(cursor))
+		return false;
+	node = &cursor->tree->node_schemas[cursor->node];
+	return !WARN_ON_ONCE(node->type != ref.type || node->kind != ref.kind);
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_input_cursor, "CTLV");
+
+void ctlv_cursor_next(struct ctlv_cursor *cursor)
+{
+	const struct ctlv_message_input_slot *slot;
+	const struct ctlv_message_input_scope *scope;
+	const struct ctlv_node_schema *node;
+	const struct ctlv_hdr *next;
+	u32 next_record;
+	u32 next_offset;
+
+	slot = ctlv_message_cursor_index(cursor);
+	if (!slot || WARN_ON_ONCE(!cursor->hdr))
+		return;
+
+	next = (const void *)cursor->hdr +
+	       ALIGN((size_t)cursor->hdr->len, CTLV_ALIGNTO);
+	next_offset = ctlv_message_offset(cursor->msg, next);
+	if (next_offset >= slot->end_offset) {
+		CTLV_ASSERT(next_offset == slot->end_offset);
+		cursor->hdr = NULL;
+		cursor->index_record_scope = CTLV_MESSAGE_INPUT_INDEX_NONE;
+		return;
+	}
+
+	cursor->hdr = next;
+	node = &cursor->tree->node_schemas[cursor->node];
+	if (node->kind == CTLV_SCHEMA_RECORD) {
+		if (WARN_ON_ONCE(cursor->index_record_scope >= cursor->msg->index->scopes_count))
+			return;
+		scope = &cursor->msg->index->scopes[cursor->index_record_scope];
+		if (WARN_ON_ONCE(scope->record >= cursor->msg->index->records_count))
+			return;
+		next_record = cursor->msg->index->records[scope->record].next;
+		if (WARN_ON_ONCE(next_record == CTLV_MESSAGE_INPUT_INDEX_NONE ||
+				 next_record >= cursor->msg->index->records_count))
+			return;
+		cursor->index_record_scope = cursor->msg->index->records[next_record].first_scope;
+	}
+	CTLV_ASSERT(ctlv_message_cursor_index(cursor));
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_cursor_next, "CTLV");
+
+bool ctlv_cursor_ok(const struct ctlv_cursor *cursor)
+{
+	return cursor && cursor->hdr && ctlv_message_cursor_index(cursor);
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_cursor_ok, "CTLV");
+
+/* The payload, checked against the schema kinds a reader of this C type accepts. */
+static const void *ctlv_message_cursor_payload(const struct ctlv_cursor *cursor, u32 kinds,
+					       u32 *len)
+{
+	const struct ctlv_node_schema *node;
+
+	if (!ctlv_message_cursor_index(cursor) || WARN_ON_ONCE(!cursor->hdr))
+		return NULL;
+	node = &cursor->tree->node_schemas[cursor->node];
+	if (WARN_ON_ONCE(!(kinds & BIT(node->kind))))
+		return NULL;
+	*len = ctlv_message_hdr_payload_len(cursor->hdr);
+	return ctlv_message_hdr_payload(cursor->hdr);
+}
+
+/* A length disagreeing with a validated schema kind is this core's mistake. */
+static const void *ctlv_message_cursor_fixed(const struct ctlv_cursor *cursor, u32 kinds,
+					     u32 expected)
+{
+	const void *payload;
+	u32 len;
+
+	payload = ctlv_message_cursor_payload(cursor, kinds, &len);
+	if (!payload || WARN_ON_ONCE(len != expected))
+		return NULL;
+	return payload;
+}
+
+u64 ctlv_cursor_u64(const struct ctlv_cursor *cursor)
+{
+	const u64 *value = ctlv_message_cursor_fixed(cursor,
+						     BIT(CTLV_SCHEMA_UINT) | BIT(CTLV_SCHEMA_ENUM) |
+							     BIT(CTLV_SCHEMA_FLAGS),
+						     sizeof(u64));
+
+	return value ? *value : 0;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_cursor_u64, "CTLV");
+
+s64 ctlv_cursor_s64(const struct ctlv_cursor *cursor)
+{
+	const s64 *value = ctlv_message_cursor_fixed(cursor, BIT(CTLV_SCHEMA_SINT), sizeof(s64));
+
+	return value ? *value : 0;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_cursor_s64, "CTLV");
+
+bool ctlv_cursor_bool(const struct ctlv_cursor *cursor)
+{
+	const u8 *value = ctlv_message_cursor_fixed(cursor, BIT(CTLV_SCHEMA_BOOL), sizeof(u8));
+
+	return value ? *value : false;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_cursor_bool, "CTLV");
+
+const char *ctlv_cursor_string(const struct ctlv_cursor *cursor)
+{
+	const char *value;
+	u32 len;
+
+	value = ctlv_message_cursor_payload(cursor, BIT(CTLV_SCHEMA_STRING), &len);
+	if (!value || WARN_ON_ONCE(!len || value[len - 1]))
+		return NULL;
+	return value;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_cursor_string, "CTLV");
+
+const void *ctlv_cursor_binary(const struct ctlv_cursor *cursor, u32 *len)
+{
+	*len = 0;
+	return ctlv_message_cursor_payload(cursor, BIT(CTLV_SCHEMA_BINARY), len);
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_cursor_binary, "CTLV");
diff --git a/lib/ctlv/message.h b/lib/ctlv/message.h
new file mode 100644
index 000000000000..c177021be88a
--- /dev/null
+++ b/lib/ctlv/message.h
@@ -0,0 +1,91 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Private message representation and record walking.
+ */
+#ifndef _CTLV_MESSAGE_H
+#define _CTLV_MESSAGE_H
+
+#include <linux/ctlv_family.h>
+#include <linux/types.h>
+
+#include <uapi/ctlv/ctlv.h>
+
+#define CTLV_MESSAGE_INPUT_INDEX_NONE U32_MAX
+
+/* A field's type remains in the generated schema, not in this request index. */
+struct ctlv_message_input_slot {
+	u32 first_offset;
+	u32 end_offset;
+	u32 count;
+	u32 excess_offset;
+	u32 first_record;
+	u32 last_record;
+};
+
+struct ctlv_message_input_scope {
+	const struct ctlv_schema_tree *tree;
+	u32 record;
+	u32 node;
+	u32 first_slot;
+	u32 slots_count;
+	bool optional;
+};
+
+struct ctlv_message_input_record {
+	u32 offset;
+	u32 first_scope;
+	u32 scopes_count;
+	u32 next;
+};
+
+struct ctlv_message_input_index {
+	struct ctlv_message_input_record *records;
+	struct ctlv_message_input_scope *scopes;
+	struct ctlv_message_input_slot *slots;
+	u32 records_count;
+	u32 records_capacity;
+	u32 scopes_count;
+	u32 scopes_capacity;
+	u32 slots_count;
+	u32 slots_capacity;
+};
+
+struct ctlv_msg {
+	struct ctlv_hdr *root;
+	size_t len;
+	const struct ctlv_schema_tree *tree;
+	const struct ctlv_family *family;
+	struct ctlv_op_ctx *ctx;
+	struct ctlv_message_input_index *index;
+	bool request;
+	int poison;
+};
+
+enum ctlv_message_step {
+	CTLV_MESSAGE_STEP_TLV = 0,
+	CTLV_MESSAGE_STEP_END = 1,
+	CTLV_MESSAGE_STEP_BAD = 2,
+};
+
+enum ctlv_message_step ctlv_message_next(const struct ctlv_hdr *record,
+					 const struct ctlv_hdr **child);
+u32 ctlv_message_offset(const struct ctlv_msg *msg,
+			const struct ctlv_hdr *hdr);
+void ctlv_message_root(struct ctlv_cursor *cursor, struct ctlv_msg *msg);
+bool ctlv_message_input_rebind(struct ctlv_cursor *record,
+			       const struct ctlv_schema_tree *tree, u32 node);
+
+static inline u32 ctlv_message_hdr_payload_len(const struct ctlv_hdr *hdr)
+{
+	return hdr->len - sizeof(*hdr);
+}
+
+static inline const void *
+ctlv_message_hdr_payload(const struct ctlv_hdr *hdr)
+{
+	return hdr + 1;
+}
+
+#endif /* _CTLV_MESSAGE_H */
-- 
2.56.0

