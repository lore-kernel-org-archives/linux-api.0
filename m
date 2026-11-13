Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585371;
	b=5bPnz37RTKJTauOnG+B1DFh3A0/zT0orGft83mwAwN5xmYrBdtqXzD1TbR2IsRsZRFDO
	 1UKB1eme2ZbMXrZ+TM0mEh1lVmmOB8ZYI6/+KSQFei3kSiCOPcH47bzaKyxZALXKPNvv9
	 zDh+lPKgz4WhbSN/Q84PUDxtrJxlvy6YlFpNbJnY3lM33W3F2MXw3p95no0i1TFmOwK17
	 XYIgNzHB9wwde9psUYSnXnnk2BQGnqiKHyXtc8XWljwZJHk0aa+HbyWsdIF/jq1OSc+bW
	 /eWGr/0Lh14eLjEzYv5wdfpjGiB5r/pRLhjXIhfDeFkFe26RCWWxVkTsqWJUTLMilCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585371;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LGLEOym6U6XI2HhF9sgdf9oEYDm6152SMOzFToqBrz8=;
	b=4BYzFPGWW7od+oQqWOKB0eUn27HsMu7caehpkNqIfXeiVgBJ1Cms3FvbbrIFlPNpgIyO
	 1BJ1hMlKe7nje9hGKvWy+Et6Fzaa/F7XBcxN7T5hPCUJkYO9TOhtQBZ8y/qDj3w2sF52P
	 z2Rl288DDy56uiR+zUK+Sd9ShRPjvQJkrNXd3nue2DXMAx8oYsg+xEWBNCQIUn6mfjXP9
	 rA71dCIpKuJKgHSUsirmj/7JPOmKwlvegy3c1ZUDlcoQVPaIHXJrqNUyh0TWOo8Xp53mC
	 LdGj6feOMioI3x4aft3d2X7tCTVp7gnrWotLE9/x8IF7VXvmRQKi1sOqBtgrzXUMQPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=LeaHfWWy;
	arc=none smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECFE60A2610
	for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 15:56:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EECFE60A2610
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=LeaHfWWy
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c50a2efbe1dso196566766b.3
        for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 07:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1794585367; x=1795190167; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LGLEOym6U6XI2HhF9sgdf9oEYDm6152SMOzFToqBrz8=;
        b=LeaHfWWyhSM0K9iMoxicEshjAt76ssRD9+zyq3PI4mfdL8G6wXXUsfMwtBu+39cO0W
         wM+rOM8zgbQX5hCI0kty/9CeudGaXYd+qsGVXcgQDANb9t9aqJ7ypbYV0/oxMIbySh9t
         0tT3h+1kYll942b1Ep4wfJkBzeLsQQccw3jTCAhmCvdU4oU38tEjwfPV0vkTxFhx88ZX
         iljpryGyn2B9J6mH5nSuNN88fh1vNnBVEPhXUoff6Gd3fOp/zd5twrW95nc9kGhBo8AM
         JTGq/AnDUj/IwcXv5YHJdZyToZ+4BUgcjZr/mVXAWXhdj2Q7u26Riz6HSdMXYhU9r/To
         gxbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794585367; x=1795190167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LGLEOym6U6XI2HhF9sgdf9oEYDm6152SMOzFToqBrz8=;
        b=vQqudQoNnutfvok2sd5byOP8L5fToLgJjRtG1tajrmIYWZS0azDujuYtiTfq5UQg+S
         USATpi4BXxTmIyZXLshl/caPF3e8qCA24UmEpcbjHRJCKdsoasGDnDAg6HTAqTYjMf8c
         RXHn4Ptq0/rm34bjxERm1HzOUa8L+9oTfAWXgWZoQ5NKg1UCZ8FUe8rhDkBwFxcTb6iQ
         GhtLR1mlpV5rZ11Fc176v2bk5uVdRqQmTQaNcQetz6dX9oxdnwB1761cpv92jl91kask
         zPsdqkV5nEn8esqdyI7sG7Q0+RDhqVaFTZRlPqaOHtprnR74Bbmo4A0B9DZ7blrsT8Wn
         rP9Q==
X-Forwarded-Encrypted: i=1; AL+hErHYjL84vzu6ZsM9apNx7EnIGbKMitxl90I3Yj9qP0Uf8yTCHBj3b9vfRatHuwNaQqDVWkFZ3j864rs=@vger.kernel.org
X-Gm-Message-State: APuU4Z/VjxJ+LcgKFFillp5FF2jJqOlRMu4fixw3/BVFM0YFNamDtcyL
	SwE7DFIIpmdsL8avYZ7fvVMddMQv1EeGT0p96KHjfbX0WsCl0WXoUecNSOc8dEDyNmU=
X-Gm-Gg: AYBFou3LQgNAa5YzKasbYj5waxvfINPQe6OsawxvnnulStRG+NXt0NqFf7vwp1Q5Y99
	o80rKCtO2lW935oaUjJj6NkJ174bnV3AThmHTd9aEJnckBq8E9z61p8jPuC7l7RnaDFLjr+BfP1
	eJzErRhK88nlmJvVabJRmMzb0VQ7sTGixJVdT0DFSFUuExU7zYogpygjTgfGq3tJ4WtuC8Mcn9L
	vmWHRxMG8PIiLBt5ZUCP1xnMQ3BZtzzeAdVNjU8VIXiQeewxK/ubfUs13/4N4dLx1+7DqmBTQpT
	6r6z7oYCiL1O8dMX68JbCQBWEtXd2JZItphYkMIUtZJJBQXrndsx+aQ8O+25emhSatdFMwjyPLJ
	dhUuV/92oOCBxNVvv0Cue+JQhOy5QWNf1w0rwS1cby3AOh86PqbVU2LK7ypxyOCqwrWddMcw5FP
	zdUT+kOjP7BhRTdgksn2MU2ufHADL9QmdHq8lmlZgGdWe55trzwgmmCwTPuwYcGCWMG2Fg6Bk3M
	uSBU0n5DEGeaYOSbb9jCgmyxsMA5cphhOwQIqA4bbfRf/4wiQuZ2DZc3cID8yO+kydR5dME8lV2
	KLU5S/Y3zV9iVNTm8V2m4bPiiNW+abStGbLNa7b2
X-Received: by 2002:a17:907:944e:b0:c49:9383:a28 with SMTP id a640c23a62f3a-c509634b56cmr279039066b.35.1794585367024;
        Fri, 13 Nov 2026 07:56:07 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095a5a78csm116841366b.4.2026.11.13.07.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 07:56:06 -0800 (PST)
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
Subject: [PATCH RFC v2 11/15] ctlv: Add operation dispatch
Date: Fri, 13 Nov 2026 16:55:10 +0100
Message-ID: <20261113155515.2510194-12-jiri@resnulli.us>
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

Let a subsystem embed a CTLV instance in a device of its own, resolve
family chains and dispatch operations through validated messages. Wire
CONFIG_CTLV and the generated root family into lib/ after all module
objects are present.

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- let the subsystem allocate the device and embed CTLV, as fwctl does
- let a subsystem route the CTLV ioctl from its own file operations
- moved to lib/ctlv/, and the device nodes to the next patch
- dropped the family lifecycle hooks and the per-family privs
- used only gotos in ctlv_op_exec()
- read struct ctlv_op_exec with copy_struct_from_user()
- took a reply buffer of any length
- made plain what the breaks in ctlv_file_open() leave
- kept each guard() on one line
- moved the function kernel-doc to the definitions
- dropped read(), poll() and the op state and removal events
- renamed ctlv_stub_fill() to ctlv_ext_fill()
- said TLV, type, record and field instead of attr
- said record instead of nest, the root being one
- reported the length an output blob needs as required-length
- separated the steps of the longer functions
- took the UAPI headers from include/uapi/ctlv/
- said message instead of wire
- registered the ioctl number, which this patch handles first
---
 .../userspace-api/ioctl/ioctl-number.rst      |    2 +
 include/linux/ctlv.h                          |   33 +
 include/linux/ctlv_family.h                   |   22 +
 lib/Kconfig                                   |    2 +
 lib/Makefile                                  |    2 +
 lib/ctlv/Makefile                             |    4 +-
 lib/ctlv/core.c                               | 1152 +++++++++++++++++
 7 files changed, 1215 insertions(+), 2 deletions(-)
 create mode 100644 lib/ctlv/core.c

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index dbe462040999..f257b1a22ec2 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -387,6 +387,8 @@ Code  Seq#    Include File                                             Comments
                                                                        <mailto:linux-hyperv@vger.kernel.org>
 0xBA  00-0F  uapi/linux/liveupdate.h                                   Pasha Tatashin
                                                                        <mailto:pasha.tatashin@soleen.com>
+0xBB  00-0F  uapi/ctlv/ctlv.h                                          CTLV
+                                                                       <mailto:jiri@resnulli.us>
 0xC0  00-0F  linux/usb/iowarrior.h
 0xCA  00-0F  uapi/misc/cxl.h                                           Dead since 6.15
 0xCA  10-2F  uapi/misc/ocxl.h
diff --git a/include/linux/ctlv.h b/include/linux/ctlv.h
index 3847f8411edf..f075d0a99b80 100644
--- a/include/linux/ctlv.h
+++ b/include/linux/ctlv.h
@@ -8,17 +8,20 @@
 #define _LINUX_CTLV_H
 
 #include <linux/device.h>
+#include <linux/rwsem.h>
 #include <linux/spinlock_types.h>
 #include <linux/types.h>
 
 #include <uapi/ctlv/ctlv.h>
 
 struct ctlv_family;
+struct ctlv_file;
 struct ctlv;
 struct ctlv_msg;
 struct ctlv_op_ctx;
 struct ctlv_op_entry;
 struct ctlv_schema_tree;
+struct file;
 
 /**
  * struct ctlv_cursor - One TLV position in one message.
@@ -60,6 +63,16 @@ struct ctlv_cursor {
 	bool progress;
 };
 
+/**
+ * struct ctlv_hooks - What a device runs around the ops of its instance.
+ * @pre: entered before every op the core does not answer, and may refuse it
+ * @post: entered after every op whose @pre succeeded
+ */
+struct ctlv_hooks {
+	int (*pre)(struct ctlv *ctlv, struct ctlv_op_ctx *ctx);
+	void (*post)(struct ctlv *ctlv, struct ctlv_op_ctx *ctx);
+};
+
 /**
  * struct ctlv - The CTLV state of one device, embedded by its subsystem.
  * @dev: device whose release frees the structure embedding this instance;
@@ -71,6 +84,9 @@ struct ctlv_cursor {
 struct ctlv {
 	struct device *dev;
 	/* private: */
+	const struct ctlv_hooks *hooks;
+	struct rw_semaphore registration_lock;
+	bool registered;
 	const struct ctlv_family *family;
 
 	struct ctlv_op_entry *ops;
@@ -78,14 +94,31 @@ struct ctlv {
 
 	/* Op publication and state writers, never the dispatch path. */
 	spinlock_t transition_lock;
+	bool published;
+	bool destroying;
 	u64 state_generation;
 	u32 dynamic_ops_count;
 	unsigned long *disabled;
 };
 
+int ctlv_init(struct ctlv *ctlv, struct device *dev,
+	      const struct ctlv_family *family, const struct ctlv_hooks *hooks);
+void ctlv_publish(struct ctlv *ctlv);
+void ctlv_unpublish(struct ctlv *ctlv);
+void ctlv_fini(struct ctlv *ctlv);
+bool ctlv_family_inherits(const struct ctlv_family *family,
+			  const struct ctlv_family *ancestor);
+
+struct ctlv_file *ctlv_file_open(struct ctlv *ctlv, struct file *filp);
+long ctlv_file_ioctl(struct ctlv_file *cfile, unsigned int cmd,
+		     unsigned long arg);
+void ctlv_file_close(struct ctlv_file *cfile);
+
 void ctlv_record_end(struct ctlv_cursor *child);
 void ctlv_record_cancel(struct ctlv_cursor *child);
 
+int ctlv_ext_fill(struct ctlv_op_ctx *ctx, const struct ctlv_cursor *request,
+		  struct ctlv_cursor *record);
 int ctlv_op_error(struct ctlv_op_ctx *ctx, int error, const char *message);
 __printf(3, 4)
 int ctlv_op_errorf(struct ctlv_op_ctx *ctx, int error, const char *fmt, ...);
diff --git a/include/linux/ctlv_family.h b/include/linux/ctlv_family.h
index 61ae5b7cec83..d8abdd4964c9 100644
--- a/include/linux/ctlv_family.h
+++ b/include/linux/ctlv_family.h
@@ -428,6 +428,9 @@ extern const struct ctlv_family ctlv_family;
 
 u32 ctlv_enum_ext_max(const struct ctlv_family *family, u16 family_id, u32 ext_id);
 
+void ctlv_op_provide(struct ctlv *ctlv, u64 op_id);
+void ctlv_op_state_set(struct ctlv *ctlv, u64 op_id, bool disabled);
+
 struct ctlv_cursor *
 ctlv_input_field(struct ctlv_cursor *cursor, const struct ctlv_cursor *record,
 		 struct ctlv_input_ref ref);
@@ -453,6 +456,25 @@ bool ctlv_record_start(struct ctlv_cursor *record, struct ctlv_cursor *child,
 
 struct ctlv_blob *ctlv_blob_resolve(struct ctlv_op_ctx *ctx,
 				    const struct ctlv_cursor *blob);
+
+#define CTLV_OP_PROVIDE(_name, _op_id)				\
+static inline void _name##_provide(struct ctlv *ctlv)	\
+{								\
+	ctlv_op_provide(ctlv, (_op_id));		\
+}
+
+#define CTLV_OP_ENABLE(_name, _op_id)				\
+static inline void _name##_enable(struct ctlv *ctlv)	\
+{								\
+	ctlv_op_state_set(ctlv, (_op_id), false);	\
+}
+
+#define CTLV_OP_DISABLE(_name, _op_id)				\
+static inline void _name##_disable(struct ctlv *ctlv)	\
+{								\
+	ctlv_op_state_set(ctlv, (_op_id), true);	\
+}
+
 #define __CTLV_DEFINE_PUT(_name, _ctype, _put_fn, _type, _kind)	\
 static inline bool _name##_put(struct ctlv_cursor *record,	\
 			       _ctype value)			\
diff --git a/lib/Kconfig b/lib/Kconfig
index 1e42f5167c68..7d81e1d502d1 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -496,6 +496,8 @@ source "lib/vdso/Kconfig"
 
 source "lib/fonts/Kconfig"
 
+source "lib/ctlv/Kconfig"
+
 config SG_SPLIT
 	def_bool n
 	help
diff --git a/lib/Makefile b/lib/Makefile
index a2afe954805c..db7e4fcc2c6f 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -342,6 +342,8 @@ obj-$(CONFIG_OBJAGG) += objagg.o
 # pldmfw library
 obj-$(CONFIG_PLDMFW) += pldmfw/
 
+obj-$(CONFIG_CTLV) += ctlv/
+
 obj-$(CONFIG_GENERIC_LIB_DEVMEM_IS_ALLOWED) += devmem_is_allowed.o
 
 obj-$(CONFIG_FIRMWARE_TABLE) += fw_table.o
diff --git a/lib/ctlv/Makefile b/lib/ctlv/Makefile
index 76010d52dd8a..73acdbdf387d 100644
--- a/lib/ctlv/Makefile
+++ b/lib/ctlv/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_CTLV) += ctlv.o
 
-ctlv-y += blob.o blob_desc.o builder.o introspection.o message.o \
-	  schema.o
+ctlv-y += blob.o blob_desc.o builder.o core.o introspection.o \
+	  message.o schema.o ctlv_gen.o
diff --git a/lib/ctlv/core.c b/lib/ctlv/core.c
new file mode 100644
index 000000000000..605f191de77b
--- /dev/null
+++ b/lib/ctlv/core.c
@@ -0,0 +1,1152 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ */
+#define pr_fmt(fmt) "ctlv: " fmt
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
+#include <linux/build_bug.h>
+#include <linux/cleanup.h>
+#include <linux/container_of.h>
+#include <linux/ctlv.h>
+#include <linux/ctlv_gen.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/kobject.h>
+#include <linux/list.h>
+#include <linux/lockdep.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/overflow.h>
+#include <linux/slab.h>
+#include <linux/stddef.h>
+#include <linux/string.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+
+#include <uapi/ctlv/ctlv.h>
+
+#include "blob.h"
+#include "builder.h"
+#include "internal.h"
+#include "schema.h"
+
+/*
+ * One layout on every ABI, including compat. Alignment is asserted too because
+ * a 32-bit ABI aligns a plain __u64 to four bytes.
+ */
+static_assert(sizeof(struct ctlv_hdr) == 16);
+static_assert(__alignof__(struct ctlv_hdr) == CTLV_ALIGNTO);
+
+static_assert(sizeof(struct ctlv_op_exec) == 56);
+static_assert(__alignof__(struct ctlv_op_exec) == CTLV_ALIGNTO);
+
+/* Claims persist across unload so one ID cannot later name another family. */
+struct ctlv_family_claim {
+	struct list_head entry;
+	char *name;
+	u16 family_id;
+};
+
+static LIST_HEAD(ctlv_family_claims);
+static DEFINE_MUTEX(ctlv_family_claims_lock);
+
+static int ctlv_family_claim_add(const struct ctlv_family_schema *schema)
+{
+	struct ctlv_family_claim *claim;
+
+	guard(mutex)(&ctlv_family_claims_lock);
+	list_for_each_entry(claim, &ctlv_family_claims, entry) {
+		bool same_id = claim->family_id == schema->family_id;
+		bool same_name = !strcmp(claim->name, schema->name);
+
+		if (same_id && same_name)
+			return 0;
+		if (same_id || same_name) {
+			pr_err("family %s wants ID %u, which belongs to %s\n", schema->name,
+			       schema->family_id, claim->name);
+			return -EEXIST;
+		}
+	}
+
+	claim = kzalloc_obj(*claim, GFP_KERNEL);
+	if (!claim)
+		return -ENOMEM;
+	claim->name = kstrdup(schema->name, GFP_KERNEL);
+	if (!claim->name) {
+		kfree(claim);
+		return -ENOMEM;
+	}
+	claim->family_id = schema->family_id;
+	list_add_tail(&claim->entry, &ctlv_family_claims);
+	return 0;
+}
+
+static void ctlv_family_claims_free(void)
+{
+	struct ctlv_family_claim *claim, *next;
+
+	list_for_each_entry_safe(claim, next, &ctlv_family_claims, entry) {
+		list_del(&claim->entry);
+		kfree(claim->name);
+		kfree(claim);
+	}
+}
+
+/*
+ * Everything resolved below is generated, so a failure here is a bug, checked
+ * anyway because an out-of-tree family comes from another generator.
+ */
+
+static const char *ctlv_family_name(const struct ctlv_family *family)
+{
+	if (!family->schema || !family->schema->name)
+		return "(unnamed)";
+	return family->schema->name;
+}
+
+static int ctlv_family_bad(const struct ctlv_family *family, const char *what)
+{
+	pr_err("family %s: %s\n", ctlv_family_name(family), what);
+	return -EINVAL;
+}
+
+static int ctlv_op_bad(const struct ctlv_family *family, u64 op_id, const char *what)
+{
+	pr_err("family %s: op %#018llx %s\n", ctlv_family_name(family), op_id, what);
+	return -EINVAL;
+}
+
+/*
+ * A family is named its parent's whole name plus a suffix, so one name states
+ * the chain it belongs to and every family of this core is ctlv-something.
+ */
+static int ctlv_family_chain_check(const struct ctlv_family *family)
+{
+	const struct ctlv_family *child;
+
+	for (child = family; child != &ctlv_family; child = child->parent) {
+		const struct ctlv_family *parent;
+		size_t len;
+
+		if (!child)
+			return ctlv_family_bad(family, "heads no chain of the core's");
+		parent = child->parent;
+		if (!child->schema || !parent || !parent->schema)
+			return ctlv_family_bad(child, "does not name a complete parent descriptor");
+		if (!child->schema->name || !parent->schema->name)
+			return ctlv_family_bad(family, "inherits a family with no name");
+		if (parent->schema->family_id >= child->schema->family_id)
+			return ctlv_family_bad(child, "does not follow its parent in the registry");
+		len = strlen(parent->schema->name);
+		if (!len || strncmp(child->schema->name, parent->schema->name, len) ||
+		    child->schema->name[len] != '-')
+			return ctlv_family_bad(family, "is not named after the family it inherits");
+	}
+	return 0;
+}
+
+/* One descriptor of a chain: what it answers with, and what it fills. */
+static int ctlv_family_descriptor_check(const struct ctlv_family *family)
+{
+	const struct ctlv_family_schema *schema = family->schema;
+	u32 index;
+
+	/*
+	 * A family that declares no op of its own binds nothing: what it
+	 * inherited is answered where it was declared.
+	 */
+	if (!schema || !schema->name || !*schema->name || (family->ops_count && !family->ops))
+		return ctlv_family_bad(family, "descriptor is incomplete");
+	/* Every device answers the root family already, as the core. */
+	if (schema->family_id == CTLV_FAMILY_ROOT && family != &ctlv_family)
+		return ctlv_family_bad(family, "claims the root family ID");
+	/* An extension point is answered by whichever family filled it. */
+	if (family->ext_ops_count != schema->ext_fill_schemas_count)
+		return ctlv_family_bad(family, "answers other extension points than it fills");
+	for (index = 0; index < family->ext_ops_count; index++) {
+		const struct ctlv_ext_fill_schema *fill_schema = &schema->ext_fill_schemas[index];
+		const struct ctlv_ext_ops *ext_ops = &family->ext_ops[index];
+
+		if (ext_ops->family_id == fill_schema->family_id &&
+		    ext_ops->ext_id == fill_schema->ext_id)
+			continue;
+		return ctlv_family_bad(family, "answers an extension point it does not fill");
+	}
+	return 0;
+}
+
+/* Every descriptor binds its local schema. */
+static int ctlv_family_descriptors_check(const struct ctlv_family *family)
+{
+	const struct ctlv_family *descriptor;
+
+	for (descriptor = family; descriptor; descriptor = descriptor->parent) {
+		int ret;
+
+		ret = ctlv_family_descriptor_check(descriptor);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+/* The graph a device answers over, and the descriptors standing on it. */
+static int ctlv_family_check(const struct ctlv_family *family)
+{
+	int ret;
+
+	if (!family->schema)
+		return ctlv_family_bad(family, "descriptor is incomplete");
+	ret = ctlv_family_chain_check(family);
+	if (ret)
+		return ret;
+	return ctlv_family_descriptors_check(family);
+}
+
+/* What one walk of the chain has accounted for so far. */
+struct ctlv_op_resolution {
+	const struct ctlv_family *target;
+	const struct ctlv_family *family;
+	u32 bound;
+	u32 dynamic;
+	u64 previous;
+};
+
+/* Every binding of one family answers an op, so a spare one answers nothing. */
+static int ctlv_op_resolution_family_bound(const struct ctlv_op_resolution *state)
+{
+	const struct ctlv_family *family = state->family;
+
+	if (!family || state->bound == family->ops_count)
+		return 0;
+	/* The core's own table is this core's bug, not a family's. */
+	if (WARN_ON_ONCE(family == &ctlv_family))
+		return -EINVAL;
+	return ctlv_family_bad(family, "binds more than its schema asks for");
+}
+
+/*
+ * The ops of one family are contiguous in the walk, so the family before this
+ * one is complete as soon as another family's op arrives.
+ */
+static int ctlv_op_resolution_family_enter(struct ctlv_op_resolution *state,
+					   const struct ctlv_family *family)
+{
+	int ret;
+
+	if (state->family == family)
+		return 0;
+	ret = ctlv_op_resolution_family_bound(state);
+	if (ret)
+		return ret;
+	state->family = family;
+	state->bound = 0;
+	return 0;
+}
+
+static int ctlv_op_resolution_add(struct ctlv_op_resolution *state, const struct ctlv_family *owner,
+				  const struct ctlv_op_schema *op, struct ctlv_op_entry *entry)
+{
+	const struct ctlv_family *target = state->target;
+	const struct ctlv_family *family = state->family;
+	int ret;
+
+	entry->schema = op;
+	entry->state_index = CTLV_OP_STATE_NONE;
+
+	/*
+	 * An op ID is its family's ID and a number within it, so a walk from
+	 * the oldest ancestor down ascends, which covers uniqueness too.
+	 */
+	if (!CTLV_OP_NUMBER(op->op_id) || CTLV_OP_FAMILY(op->op_id) != owner->schema->family_id)
+		return ctlv_op_bad(target, op->op_id, "belongs to another family");
+	if (op->op_id <= state->previous)
+		return ctlv_op_bad(target, op->op_id, "is out of order");
+	state->previous = op->op_id;
+
+	switch (op->type) {
+	case CTLV_OP_TYPE_ACTION:
+	case CTLV_OP_TYPE_QUERY:
+		if (op->fd_access != CTLV_OP_FD_ACCESS_READ &&
+		    op->fd_access != CTLV_OP_FD_ACCESS_READ_WRITE)
+			return ctlv_op_bad(family, op->op_id, "has an unknown fd access");
+		/* The family that declared the op is the one that answers it. */
+		if (state->bound >= family->ops_count)
+			return ctlv_op_bad(family, op->op_id, "has nothing bound to it");
+		entry->binding = &family->ops[state->bound++];
+		/* Required even for an op this device disables or withholds. */
+		if (!entry->binding->action)
+			return ctlv_op_bad(family, op->op_id, "has no callback");
+		/* An optional op arrives absent, for the opt-in to clear. */
+		entry->absent = op->optional;
+		/* An op has a whole pair of hooks of its own, or none. */
+		if (!entry->binding->pre != !entry->binding->post)
+			return ctlv_op_bad(family, op->op_id, "has half a hook pair");
+		/* No message carries a pair, so this is the only check of it. */
+		if (!entry->binding->pre != !op->pre_post)
+			return ctlv_op_bad(family, op->op_id, "disagrees about its hook pair");
+		break;
+	default:
+		return ctlv_op_bad(target, op->op_id, "has an unknown type");
+	}
+
+	switch (op->availability) {
+	case CTLV_OP_AVAILABILITY_FIXED:
+		break;
+	case CTLV_OP_AVAILABILITY_DYNAMIC:
+		/*
+		 * Numbered from zero as the walk meets them, per device: two
+		 * families of one chain need not have the same ops.
+		 */
+		entry->state_index = state->dynamic++;
+		break;
+	default:
+		return ctlv_op_bad(target, op->op_id, "has an unknown availability");
+	}
+
+	/*
+	 * Once per device: what an inherited op may carry depends on the
+	 * extension points this family filled and on nothing that changes later.
+	 */
+	ret = ctlv_schema_op_sizes(target, op, &entry->sizes);
+	if (ret)
+		return ctlv_op_bad(target, op->op_id, "needs messages this core cannot carry");
+	return 0;
+}
+
+static int ctlv_op_resolution_init(struct ctlv *ctlv, const struct ctlv_family *family)
+{
+	struct ctlv_op_resolution state = {
+		.target = family,
+	};
+	const struct ctlv_family *owner;
+	const struct ctlv_op_schema *op;
+	struct ctlv_schema_cursor cursor;
+	u32 ops_count = 0;
+	int ret;
+
+	ret = ctlv_family_check(family);
+	if (ret)
+		return ret;
+
+	ctlv_schema_cursor_init(&cursor, family);
+	while (ctlv_schema_next_op(&cursor, &owner))
+		ops_count++;
+	if (!ops_count)
+		return ctlv_family_bad(family, "has an effective schema with no op");
+
+	ctlv->ops = kcalloc(ops_count, sizeof(*ctlv->ops), GFP_KERNEL);
+	if (!ctlv->ops)
+		return -ENOMEM;
+	ctlv->ops_count = ops_count;
+
+	ops_count = 0;
+	ctlv_schema_cursor_init(&cursor, family);
+	while ((op = ctlv_schema_next_op(&cursor, &owner))) {
+		ret = ctlv_op_resolution_family_enter(&state, owner);
+		if (ret)
+			return ret;
+		ret = ctlv_op_resolution_add(&state, owner, op, &ctlv->ops[ops_count++]);
+		if (ret)
+			return ret;
+	}
+	/* The device family, no op of another having ended its table. */
+	ret = ctlv_op_resolution_family_bound(&state);
+	if (ret)
+		return ret;
+	ctlv->dynamic_ops_count = state.dynamic;
+	return 0;
+}
+
+/**
+ * ctlv_family_inherits - Check a family's ancestry.
+ * @family: family
+ * @ancestor: family that may be @family or one of its ancestors
+ *
+ * Return: whether @family is @ancestor or inherits from it.
+ */
+bool ctlv_family_inherits(const struct ctlv_family *family,
+			  const struct ctlv_family *ancestor)
+{
+	for (; family; family = family->parent)
+		if (family == ancestor)
+			return true;
+	return false;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_family_inherits, "CTLV");
+
+/*
+ * Dispatch reads the availability bit under no lock, so an op already admitted
+ * is neither cancelled nor waited for by a disable.
+ */
+
+struct ctlv_op_entry *ctlv_op_find(struct ctlv *ctlv, u64 op_id)
+{
+	u32 index;
+
+	/* The index ascends by op ID, so a miss stops early. */
+	for (index = 0; index < ctlv->ops_count; index++) {
+		if (ctlv->ops[index].schema->op_id == op_id)
+			return &ctlv->ops[index];
+		if (ctlv->ops[index].schema->op_id > op_id)
+			break;
+	}
+	return NULL;
+}
+
+static bool ctlv_op_disabled(struct ctlv *ctlv, const struct ctlv_op_entry *op)
+{
+	if (op->state_index == CTLV_OP_STATE_NONE)
+		return false;
+	/* Acquire, so what the family prepared before enabling is visible. */
+	return test_bit_acquire(op->state_index, ctlv->disabled);
+}
+
+static void ctlv_op_publish_all(struct ctlv *ctlv)
+{
+	u32 published = 0;
+	u32 index;
+
+	/* Against a family still opting in as this is called. */
+	guard(spinlock)(&ctlv->transition_lock);
+	for (index = 0; index < ctlv->ops_count; index++) {
+		if (ctlv->ops[index].absent)
+			continue;
+		ctlv->ops[published++] = ctlv->ops[index];
+	}
+	ctlv->ops_count = published;
+	ctlv->published = true;
+}
+
+void ctlv_op_provide(struct ctlv *ctlv, u64 op_id)
+{
+	struct ctlv_op_entry *op;
+
+	guard(spinlock)(&ctlv->transition_lock);
+	if (WARN_ON_ONCE(ctlv->published || ctlv->destroying))
+		return;
+	op = ctlv_op_find(ctlv, op_id);
+	if (WARN_ON_ONCE(!op))
+		return;
+	op->absent = false;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_op_provide, "CTLV");
+
+void ctlv_op_state_set(struct ctlv *ctlv, u64 op_id, bool disabled)
+{
+	const struct ctlv_op_entry *op;
+
+	/*
+	 * Also serializes lookup against publication, which compacts the
+	 * array, and against teardown stopping state changes.
+	 */
+	guard(spinlock)(&ctlv->transition_lock);
+	if (ctlv->destroying)
+		return;
+
+	op = ctlv_op_find(ctlv, op_id);
+	if (WARN_ON_ONCE(!op) || WARN_ON_ONCE(op->state_index == CTLV_OP_STATE_NONE))
+		return;
+	/* An op this device never took on has no state to change. */
+	if (WARN_ON_ONCE(op->absent))
+		return;
+
+	/*
+	 * Fully ordered, releasing what the family prepared to the acquire in
+	 * ctlv_op_disabled(). The old state makes a repeat change nothing.
+	 */
+	if (disabled ? test_and_set_bit(op->state_index, ctlv->disabled) :
+		       !test_and_clear_bit(op->state_index, ctlv->disabled))
+		return;
+
+	if (!ctlv->published)
+		return;
+	ctlv->state_generation++;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_op_state_set, "CTLV");
+
+static int ctlv_op_check_mode(const struct file *filp, const struct ctlv_op_entry *op)
+{
+	switch (op->schema->fd_access) {
+	case CTLV_OP_FD_ACCESS_READ:
+		return filp->f_mode & FMODE_READ ? 0 : -EACCES;
+	case CTLV_OP_FD_ACCESS_READ_WRITE:
+		return (filp->f_mode & (FMODE_READ | FMODE_WRITE)) == (FMODE_READ | FMODE_WRITE) ?
+			       0 :
+			       -EACCES;
+	default:
+		/* Registration rejects this before the device is visible. */
+		return -EACCES;
+	}
+}
+
+static u32 ctlv_reply_needed(const struct ctlv_op_entry *op)
+{
+	if (op->schema->type == CTLV_OP_TYPE_QUERY)
+		return op->sizes.query_reply_min_len;
+	return op->sizes.action_reply_max_len;
+}
+
+/*
+ * request_len is the copy boundary; root length frames the message. Ignored
+ * unknown TLVs may exceed the schema maximum up to the transport limit.
+ */
+static int ctlv_request_frame(struct ctlv_op_ctx *ctx, const struct ctlv_op_exec *exec,
+			      const struct ctlv_hdr *root)
+{
+	if (root->len < sizeof(*root) || root->len > exec->request_len ||
+	    root->type != CTLV_TYPE_ROOT || root->flags != CTLV_HDR_F_RECORD) {
+		ctx->error.reason = CTLV_VALIDATION_REASON_MALFORMED_MESSAGE;
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int ctlv_request_validate(struct ctlv_op_ctx *ctx, const struct ctlv_op_exec *exec,
+				 struct ctlv_hdr *root)
+{
+	int ret;
+
+	ret = ctlv_request_frame(ctx, exec, root);
+	if (ret)
+		return ret;
+	if (!ctx->op->schema->request.node_schemas)
+		return 0;
+
+	ctx->request = (struct ctlv_msg){
+		.root = root,
+		.len = exec->request_len,
+		.tree = &ctx->op->schema->request,
+		.family = ctx->family,
+		.request = true,
+	};
+	return ctlv_schema_validate(&ctx->request, &ctx->error);
+}
+
+/*
+ * An action is given exactly the maximum its schema allows, so running out of
+ * room is this kernel's mistake. A query is given whatever the caller offered,
+ * up to the longest fragment this core builds.
+ */
+static u32 ctlv_reply_capacity(const struct ctlv_op_entry *op, const struct ctlv_op_exec *exec)
+{
+	if (!op->schema->reply.node_schemas)
+		return 0;
+	if (op->schema->type == CTLV_OP_TYPE_QUERY)
+		return min(exec->reply_len, CTLV_MAX_INLINE_MESSAGE_LEN);
+	return op->sizes.action_reply_max_len;
+}
+
+/* Actions and final query fragments must be complete schema-valid replies. */
+static int ctlv_reply_finish(struct ctlv_op_ctx *ctx)
+{
+	struct ctlv_error refused = {};
+
+	if (!ctx->output.root)
+		return 0;
+	/* Whatever poisoned it has warned about it already. */
+	if (ctx->output.poison)
+		return ctx->output.poison;
+	/* A query was held to its open records by the ending it came to. */
+	if (ctx->op->schema->type == CTLV_OP_TYPE_QUERY) {
+		if (ctx->frag.cursor || ctx->frag.next_cursor)
+			return 0;
+	} else if (WARN_ON_ONCE(ctx->deepest != &ctx->output_root)) {
+		/* A cursor of a returned frame is reset, never followed. */
+		ctx->deepest = &ctx->output_root;
+		return -EINVAL;
+	}
+	if (WARN_ON_ONCE(ctlv_schema_validate(&ctx->output, &refused)))
+		return -EINVAL;
+	return 0;
+}
+
+/* A successful query callback must end exactly one fragment. */
+static int ctlv_query_fragment_result(struct ctlv_op_ctx *ctx)
+{
+	if (WARN_ON_ONCE(!ctx->frag.answered))
+		return -EINVAL;
+	return ctx->frag.result;
+}
+
+static int ctlv_op_call(struct ctlv_op_ctx *ctx)
+{
+	const struct ctlv_op_entry *op = ctx->op;
+	struct ctlv_cursor *request = NULL;
+	struct ctlv_cursor *reply = NULL;
+	int blob_ret;
+	int ret;
+
+	if (ctx->request.root) {
+		ctlv_message_root(&ctx->request_root, &ctx->request);
+		request = &ctx->request_root;
+	}
+	if (ctx->output.root)
+		reply = &ctx->output_root;
+
+	ctlv_blob_context_init(ctx);
+	if (op->schema->type == CTLV_OP_TYPE_ACTION) {
+		ret = op->binding->action(ctx->ctlv, ctx, request, reply);
+	} else {
+		ret = op->binding->query(ctx->ctlv, ctx, request, reply);
+		if (!ret)
+			ret = ctlv_query_fragment_result(ctx);
+	}
+	blob_ret = ctlv_blob_context_finish(ctx);
+	if (!ret)
+		ret = blob_ret;
+	if (ret)
+		return ret;
+	return ctlv_reply_finish(ctx);
+}
+
+/*
+ * The device's hooks around the declaring op's, except around a core op. The
+ * availability check is innermost.
+ */
+static int ctlv_op_dispatch(struct ctlv_op_ctx *ctx)
+{
+	const struct ctlv_hooks *hooks = ctx->ctlv->hooks;
+	const struct ctlv_op *op = ctx->op->binding;
+	struct ctlv *ctlv = ctx->ctlv;
+	int ret;
+
+	if (CTLV_OP_FAMILY(ctx->op->schema->op_id) == CTLV_FAMILY_ROOT)
+		hooks = NULL;
+	if (hooks) {
+		ret = hooks->pre(ctlv, ctx);
+		if (ret)
+			return ret;
+	}
+
+	if (op->pre) {
+		ret = op->pre(ctlv, ctx);
+		if (ret)
+			goto out;
+	}
+
+	/* The only authoritative check: introspection is advisory. */
+	if (ctlv_op_disabled(ctlv, ctx->op))
+		ret = -EOPNOTSUPP;
+	else
+		ret = ctlv_op_call(ctx);
+
+	if (op->post)
+		op->post(ctlv, ctx);
+out:
+	if (hooks)
+		hooks->post(ctlv, ctx);
+	return ret;
+}
+
+/* Error information replaces the reply atomically; errno remains authoritative. */
+static void ctlv_error_info(struct ctlv_op_ctx *ctx, u32 room, void **reply, u32 *reply_len)
+{
+	const struct ctlv_error *error = &ctx->error;
+	struct ctlv_cursor *root = &ctx->output_root;
+	void *buf;
+
+	if ((!error->reason && !error->message[0]) || !room)
+		return;
+	buf = kvmalloc(CTLV_ERROR_INFO_MAX_LEN, GFP_KERNEL_ACCOUNT);
+	if (!buf)
+		return;
+
+	/* The same builder over another schema, and a buffer of its own. */
+	ctlv_message_output_init(&ctx->output, ctx, buf, CTLV_ERROR_INFO_MAX_LEN,
+				 &ctlv_error_info_schema);
+	ctlv_message_root(root, &ctx->output);
+	ctx->deepest = root;
+
+	if (error->reason)
+		ctlv_put_u64(root, CTLV_T_ERROR_INFO_REASON, CTLV_SCHEMA_ENUM, error->reason);
+	if (error->message[0])
+		ctlv_error_info_message_put(root, error->message);
+	if (error->reason == CTLV_VALIDATION_REASON_STALE_GENERATION) {
+		/* The one failure that is about no part of any message. */
+		ctlv_put_u64(root, CTLV_T_ERROR_INFO_EXPECTED_GENERATION, CTLV_SCHEMA_UINT,
+			     error->expected_generation);
+		ctlv_put_u64(root, CTLV_T_ERROR_INFO_CURRENT_GENERATION, CTLV_SCHEMA_UINT,
+			     error->current_generation);
+	} else if (error->reason) {
+		ctlv_put_u64(root, CTLV_T_ERROR_INFO_BAD_TLV_OFFSET, CTLV_SCHEMA_UINT,
+			     error->bad_tlv_offset);
+		ctlv_put_u64(root, CTLV_T_ERROR_INFO_RECORD_OFFSET, CTLV_SCHEMA_UINT,
+			     error->record_offset);
+		/* No field's type is zero, so a zero names nothing. */
+		if (error->missing_type)
+			ctlv_put_u64(root, CTLV_T_ERROR_INFO_MISSING_TYPE, CTLV_SCHEMA_UINT,
+				     error->missing_type);
+		if (error->required_length)
+			ctlv_put_u64(root, CTLV_T_ERROR_INFO_REQUIRED_LENGTH, CTLV_SCHEMA_UINT,
+				     error->required_length);
+	}
+
+	if (ctx->output.poison || ctx->output.root->len > room) {
+		kvfree(buf);
+		return;
+	}
+	*reply = buf;
+	*reply_len = ctx->output.root->len;
+}
+
+struct ctlv_file {
+	struct ctlv *ctlv;
+	/* The device file, whose release frees this. */
+	struct file *filp;
+};
+
+/*
+ * Everything that needs the device to still have a family. @reply is built
+ * here and becomes the caller's to free, to copy out once the family is gone.
+ */
+static int ctlv_op_exec(struct ctlv_file *cfile, struct ctlv_op_exec *exec,
+			void *snapshot, void **reply, u32 *reply_len)
+{
+	struct ctlv *ctlv = cfile->ctlv;
+	const struct ctlv_op_entry *op;
+	struct ctlv_op_ctx ctx = {};
+	void *out = NULL;
+	u32 capacity;
+	int ret;
+
+	/* No family numbers an op zero, so a zero here is an unset field. */
+	if (!exec->op_id)
+		return -EINVAL;
+	op = ctlv_op_find(ctlv, exec->op_id);
+	if (!op)
+		return -EOPNOTSUPP;
+	ret = ctlv_op_check_mode(cfile->filp, op);
+	if (ret)
+		return ret;
+
+	/*
+	 * Only a query resumes. A cursor says which fragment this is, so a
+	 * generation without one continues what was never started.
+	 */
+	if (op->schema->type == CTLV_OP_TYPE_QUERY) {
+		if (!exec->cursor && exec->generation)
+			return -EINVAL;
+		ctx.frag.generation = exec->generation;
+		ctx.frag.cursor = exec->cursor;
+	} else if (exec->generation || exec->cursor) {
+		return -EINVAL;
+	}
+
+	/* Before the callback, so a buffer too small mutates nothing. */
+	if (exec->reply_len < ctlv_reply_needed(op))
+		return -EMSGSIZE;
+
+	ctx.ctlv = ctlv;
+	ctx.family = ctlv->family;
+	/* Whose memory a blob descriptor of this request describes. */
+	ctx.submitter = current;
+	ctx.op = op;
+
+	/* Before any hook, so that no family code sees an unchecked TLV. */
+	ret = ctlv_request_validate(&ctx, exec, snapshot);
+	if (ret)
+		goto out_error_info;
+
+	capacity = ctlv_reply_capacity(op, exec);
+	if (capacity) {
+		/*
+		 * Not zeroed: a byte is copied out only once the root's
+		 * length covers it, padding included.
+		 */
+		out = kvmalloc(capacity, GFP_KERNEL_ACCOUNT);
+		if (!out) {
+			ret = -ENOMEM;
+			goto out_request;
+		}
+		ctlv_message_output_init(&ctx.output, &ctx, out, capacity, &op->schema->reply);
+		ctlv_message_root(&ctx.output_root, &ctx.output);
+		ctx.deepest = &ctx.output_root;
+	}
+
+	ret = ctlv_op_dispatch(&ctx);
+	if (ret)
+		goto out_error_info;
+
+	/* Where the caller carries on from, zero for anything but a query. */
+	exec->generation = ctx.frag.reported;
+	exec->cursor = ctx.frag.next_cursor;
+	*reply_len = ctx.output.root ? ctx.output.root->len : 0;
+	*reply = out;
+	out = NULL;
+	ret = 0;
+	goto out_request;
+
+out_error_info:
+	ctlv_error_info(&ctx, exec->reply_len, reply, reply_len);
+out_request:
+	ctlv_message_index_free(&ctx.request);
+	kvfree(out);
+	return ret;
+}
+
+/* What one family of this device's chain does with one extension point. */
+static const struct ctlv_ext_ops *ctlv_ext_ops_find(const struct ctlv *ctlv,
+						    const struct ctlv_ext_schema *ext_schema)
+{
+	const struct ctlv_family *family;
+	u32 index;
+
+	/* From the device family towards the core, where the fill was found. */
+	for (family = ctlv->family; family; family = family->parent)
+		for (index = 0; index < family->ext_ops_count; index++)
+			if (family->ext_ops[index].family_id == ext_schema->family_id &&
+			    family->ext_ops[index].ext_id == ext_schema->ext_id)
+				return &family->ext_ops[index];
+	return NULL;
+}
+
+/**
+ * ctlv_ext_fill - Delegate an extension-point output record.
+ * @ctx: operation context
+ * @request: validated request root
+ * @record: output record selected by the generated helper
+ *
+ * Return: filling callback result, or 0 for an unfilled point.
+ */
+int ctlv_ext_fill(struct ctlv_op_ctx *ctx, const struct ctlv_cursor *request,
+		  struct ctlv_cursor *record)
+{
+	const struct ctlv_schema_tree *tree;
+	u32 index;
+
+	if (WARN_ON_ONCE(!record->tree))
+		return -EINVAL;
+	tree = record->tree;
+
+	for (index = 0; index < tree->ext_schemas_count; index++) {
+		const struct ctlv_ext_schema *ext_schema = &tree->ext_schemas[index];
+		const struct ctlv_cursor *filled_request = request;
+		const struct ctlv_ext_fill_schema *fill_schema;
+		const struct ctlv_ext_ops *ext_ops;
+		struct ctlv_cursor filled;
+		int ret;
+
+		if (ext_schema->node != record->node)
+			continue;
+		ext_ops = ctlv_ext_ops_find(ctx->ctlv, ext_schema);
+		if (!ext_ops || !ext_ops->fill)
+			continue;
+
+		if (request) {
+			fill_schema = ctlv_schema_fill(ctx->family, ext_schema->family_id,
+						       ext_schema->ext_id);
+			if (WARN_ON_ONCE(!fill_schema))
+				return -EINVAL;
+			filled = *request;
+			if (ctlv_message_input_rebind(&filled, &fill_schema->members, 0))
+				filled_request = &filled;
+			else
+				filled_request = NULL;
+		}
+
+		ret = ext_ops->fill(ctx->ctlv, ctx, filled_request, record);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_ext_fill, "CTLV");
+
+static long ctlv_op_exec_ioctl(struct ctlv_file *cfile, unsigned long arg)
+{
+	struct ctlv_op_exec __user *uexec = (struct ctlv_op_exec __user *)arg;
+	struct ctlv *ctlv = cfile->ctlv;
+	struct ctlv_op_exec exec;
+	u32 reply_len = 0;
+	u32 size;
+	int ret;
+
+	if (get_user(size, &uexec->size))
+		return -EFAULT;
+	/* The first version ends at cursor, so every size covers the write-back. */
+	if (size < offsetofend(struct ctlv_op_exec, cursor))
+		return -EINVAL;
+	ret = copy_struct_from_user(&exec, sizeof(exec), uexec, size);
+	if (ret)
+		return ret;
+	if (exec.flags)
+		return -EINVAL;
+	if (exec.request_len < sizeof(struct ctlv_hdr) ||
+	    exec.request_len > CTLV_MAX_INLINE_MESSAGE_LEN)
+		return -EINVAL;
+
+	/*
+	 * Before the lock, which destruction must not wait on for a faulting
+	 * copy. Everything after this reads the snapshot, never userspace.
+	 */
+	void *snapshot __free(kvfree) = kvmalloc(exec.request_len, GFP_KERNEL_ACCOUNT);
+	if (!snapshot)
+		return -ENOMEM;
+	if (copy_from_user(snapshot, u64_to_user_ptr(exec.request), exec.request_len))
+		return -EFAULT;
+
+	void *reply __free(kvfree) = NULL;
+
+	scoped_guard(rwsem_read, &ctlv->registration_lock) {
+		if (!ctlv->registered || !ctlv->family)
+			return -ENODEV;
+		ret = ctlv_op_exec(cfile, &exec, snapshot, &reply, &reply_len);
+	}
+	/* Do not make destruction wait for a faulting userspace copy. */
+	if (reply_len && copy_to_user(u64_to_user_ptr(exec.reply), reply, reply_len))
+		return ret ?: -EFAULT;
+	/*
+	 * The only fields the kernel writes back, a field at a time so that
+	 * what the caller stated about its own buffers stays the caller's.
+	 */
+	if (!ret && (put_user(exec.generation, &uexec->generation) ||
+		     put_user(exec.cursor, &uexec->cursor)))
+		return -EFAULT;
+	return ret;
+}
+
+/**
+ * ctlv_file_ioctl - Run a CTLV ioctl on a device file.
+ * @cfile: state returned by ctlv_file_open()
+ * @cmd: ioctl command
+ * @arg: ioctl argument
+ *
+ * Return: ioctl result, or -ENOIOCTLCMD for a command that is not CTLV's.
+ */
+long ctlv_file_ioctl(struct ctlv_file *cfile, unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+	case CTLV_IOC_OP_EXEC:
+		return ctlv_op_exec_ioctl(cfile, arg);
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_file_ioctl, "CTLV");
+
+static bool ctlv_file_open_allowed(struct ctlv *ctlv)
+{
+	lockdep_assert_held_read(&ctlv->registration_lock);
+	return ctlv->registered && ctlv->family;
+}
+
+/**
+ * ctlv_file_open - Attach CTLV to one open file of its device.
+ * @ctlv: published instance
+ * @filp: device file, open for reading
+ *
+ * Return: per-open state, or an error pointer.
+ */
+struct ctlv_file *ctlv_file_open(struct ctlv *ctlv, struct file *filp)
+{
+	struct ctlv_file *cfile;
+	int ret;
+
+	/*
+	 * A failed registration can withdraw the node while an open is waiting
+	 * for the registration lock, so admission itself first pins the device.
+	 */
+	get_device(ctlv->dev);
+
+	do {
+		guard(rwsem_read)(&ctlv->registration_lock);
+		if (!ctlv_file_open_allowed(ctlv)) {
+			ret = -ENODEV;
+			break;
+		}
+		if (!(filp->f_mode & FMODE_READ)) {
+			ret = -EACCES;
+			break;
+		}
+
+		cfile = kzalloc_obj(*cfile, GFP_KERNEL_ACCOUNT);
+		if (!cfile) {
+			ret = -ENOMEM;
+			break;
+		}
+		cfile->ctlv = ctlv;
+		cfile->filp = filp;
+		/* This description keeps the reference taken on entry. */
+		return cfile;
+	} while (0);
+
+	put_device(ctlv->dev);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_file_open, "CTLV");
+
+/**
+ * ctlv_file_close - Detach CTLV from a device file.
+ * @cfile: state returned by ctlv_file_open()
+ *
+ * For the release of the device file.
+ */
+void ctlv_file_close(struct ctlv_file *cfile)
+{
+	struct device *dev = cfile->ctlv->dev;
+
+	kfree(cfile);
+	put_device(dev);
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_file_close, "CTLV");
+
+/* Uevent identity is available to rules before the device can be opened. */
+static int ctlv_uevent_families(struct kobj_uevent_env *env,
+				const struct ctlv_family *family)
+{
+	u32 levels = ctlv_family_levels(family);
+	u32 level;
+	int ret;
+
+	ret = add_uevent_var(env, "CTLV_FAMILY=%s", family->schema->name);
+	if (ret)
+		return ret;
+	for (level = 0; level < levels; level++) {
+		const struct ctlv_family *ancestor =
+			ctlv_family_ancestor(family, levels - 1 - level);
+
+		ret = add_uevent_var(env, "CTLV_COMPATIBLE_%u=%s", level, ancestor->schema->name);
+		if (ret)
+			return ret;
+	}
+	return add_uevent_var(env, "CTLV_COMPATIBLE_N=%u", levels);
+}
+
+static int ctlv_uevent_check(const struct ctlv_family *family)
+{
+	struct kobj_uevent_env *env;
+	int ret;
+
+	env = kzalloc_obj(*env, GFP_KERNEL);
+	if (!env)
+		return -ENOMEM;
+	ret = ctlv_uevent_families(env, family);
+	if (!ret && (env->buflen > CTLV_UEVENT_MAX_LEN || env->envp_idx > CTLV_UEVENT_MAX_VARS)) {
+		pr_err("family %s: its chain of names needs %d bytes in %d properties of a uevent, more than the %d in %d it may take\n",
+		       family->schema->name, env->buflen, env->envp_idx, CTLV_UEVENT_MAX_LEN,
+		       CTLV_UEVENT_MAX_VARS);
+		ret = -E2BIG;
+	}
+	kfree(env);
+	return ret;
+}
+
+/**
+ * ctlv_init - Prepare an embedded instance for one family.
+ * @ctlv: zeroed instance
+ * @dev: device
+ * @family: device family
+ * @hooks: pair around every op the core does not answer, or NULL
+ *
+ * Until ctlv_publish(), the family decides its optional and dynamic
+ * ops through its generated helpers.
+ *
+ * Return: 0, or a negative error. ctlv_fini() applies either way.
+ */
+int ctlv_init(struct ctlv *ctlv, struct device *dev,
+	      const struct ctlv_family *family, const struct ctlv_hooks *hooks)
+{
+	int ret;
+
+	/* Nothing in common means no pair, not half of one. */
+	if (!dev || !family || (hooks && (!hooks->pre || !hooks->post)))
+		return -EINVAL;
+
+	ctlv->dev = dev;
+	ctlv->hooks = hooks;
+	init_rwsem(&ctlv->registration_lock);
+	spin_lock_init(&ctlv->transition_lock);
+
+	/* Before anything reads the schema through this instance. */
+	ret = ctlv_op_resolution_init(ctlv, family);
+	if (ret)
+		return ret;
+
+	/* Before a subsystem announces a device that could not be. */
+	ret = ctlv_uevent_check(family);
+	if (ret)
+		return ret;
+
+	if (ctlv->dynamic_ops_count) {
+		ctlv->disabled = bitmap_zalloc(ctlv->dynamic_ops_count, GFP_KERNEL);
+		if (!ctlv->disabled)
+			return -ENOMEM;
+	}
+
+	ret = ctlv_family_claim_add(family->schema);
+	if (ret)
+		return ret;
+	ctlv->family = family;
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_init, "CTLV");
+
+/**
+ * ctlv_publish - Fix the op table and accept operations.
+ * @ctlv: initialized instance
+ */
+void ctlv_publish(struct ctlv *ctlv)
+{
+	ctlv_op_publish_all(ctlv);
+	scoped_guard(rwsem_write, &ctlv->registration_lock)
+		ctlv->registered = true;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_publish, "CTLV");
+
+/**
+ * ctlv_unpublish - Stop operations.
+ * @ctlv: published instance
+ *
+ * Waits for the operations in flight. No family callback runs afterwards.
+ */
+void ctlv_unpublish(struct ctlv *ctlv)
+{
+	u32 index;
+
+	lockdep_assert_not_held(&ctlv->registration_lock);
+	lockdep_assert_not_held(&ctlv->transition_lock);
+
+	/*
+	 * The write side waits for admitted callbacks. Once held, registration
+	 * state keeps every later ioctl out.
+	 */
+	scoped_guard(rwsem_write, &ctlv->registration_lock)
+		ctlv->registered = false;
+
+	scoped_guard(spinlock, &ctlv->transition_lock)
+		ctlv->destroying = true;
+
+	/* No callback can reach what the family owns after this. */
+	scoped_guard(rwsem_write, &ctlv->registration_lock)
+		WRITE_ONCE(ctlv->family, NULL);
+	for (index = 0; index < ctlv->ops_count; index++)
+		ctlv->ops[index].binding = NULL;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_unpublish, "CTLV");
+
+/**
+ * ctlv_fini - Free what an instance allocated.
+ * @ctlv: instance never published, or unpublished
+ *
+ * For the release of the device.
+ */
+void ctlv_fini(struct ctlv *ctlv)
+{
+	bitmap_free(ctlv->disabled);
+	ctlv->disabled = NULL;
+	kfree(ctlv->ops);
+	ctlv->ops = NULL;
+}
+EXPORT_SYMBOL_NS_GPL(ctlv_fini, "CTLV");
+
+static void __exit ctlv_module_exit(void)
+{
+	ctlv_family_claims_free();
+}
+
+module_exit(ctlv_module_exit);
+MODULE_DESCRIPTION("CTLV character device TLV UAPI core");
+MODULE_LICENSE("GPL");
-- 
2.56.0

