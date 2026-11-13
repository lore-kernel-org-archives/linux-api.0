Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794586155;
	b=ovTVNpEQlUOCTefb/21tdi4CsMF2feUEC2mWBlNIHjdeR8eFUT0rlsxE9OZvUbVvpZBn
	 6pUPrv3X2dTOrIZO35QzmZ0efAFShkfz7vAHz1hri9/ZViAMuJuUUtZRmFPzt8wmcoruM
	 L0xSwB7WmtB8siEkEwb2z/bgo6/ZTJRODjXsliS7Pag7SDW4xWBiwUHK2vstVYfFgPS4q
	 0Oxqc6CYCQvGOXFNlm3U/FZMaRz0uYZ8vuoxQyH3i+ED0HkHu3m0C15qil/QbDfKhjqRb
	 u4sFnJ5DIRX4GJYU7i4k62b+DCyMA1q+4P2zvF12Bp91bWjxE3YplxfE2fZcHVrPGAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586155;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lgIDHYZpE/qu0aCHlcnYkvZglETZnS1O0+wZshReRlk=;
	b=AJ7GL9u9tg16Ovim2+f7jsgZoj6P7kzzPKJDuhz1ebLZngh8+vtR+gVZIlS7bpmlpoJn
	 wVCxn2iJU07VwKb2J/LADzQmDsYWLnZjLnZjImF3daqJZdIXgnhCzXA/WlxmVlZqAdESZ
	 W4VWx8KJl91miDYtZG4azzFjHiP0tR8hqbDFpBxPoJcjebDqMNs4nRlUrTGLYx+QboK43
	 ofyT3kA+2sbX1FIxx+AxxqZBl4QROeoCB9CtA7+JjORny5etcfuzTzMxxPp5lk3kETRRB
	 y232bf4ansQrQAj2GtqKmiDyrwVihX0kYX0XwFbsAghPTyBJLuoizuTp23fuGCNmt2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b="Z9QXhik/";
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382D5606D45F
	for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 16:09:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 382D5606D45F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=Z9QXhik/
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48e3b22e971so564582f8f.0
        for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 08:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1794586153; x=1795190953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lgIDHYZpE/qu0aCHlcnYkvZglETZnS1O0+wZshReRlk=;
        b=Z9QXhik/aJBjLLFhrBp+nKTXWn1by1eMivKdLzuaEJFxAlMVms3XpdQdOLO4JaNuKF
         4PNnC+URJbNMcfkAfFAgq1smh4XGb61v7zTkyjp8c3QPz4NlzEIQowmtvNTSYJHTApFw
         MOaj7XTKgoXVGimRkzhhjs5zxmx/5/gNxnxiua6iN7Kn6FNU4p+Kg41c+umWLh369q33
         ka9X530/hr8f7flag05YHvBDMVGttt2Vz8H+CdGPy0o+mQyS5eF5EcDFQ63gXxPPRNgv
         7c4hkF31x1x59gPcS3O38BW14sWTG7XtCL4tEZm1C27KzhiqsGRSsvu5i5KBIH5q2LFH
         HZvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794586153; x=1795190953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lgIDHYZpE/qu0aCHlcnYkvZglETZnS1O0+wZshReRlk=;
        b=00UEnH9e135EpW9qe6h9+2H1mCzYWyVEg6w7U7ZUYzXIEr9ER6vzK2GCLTqqDBV4KU
         CpIhIqIsxdUw9+gKl0mvayc9Rg9QU67BSYbqOB3UdMVr4q4Xhxwc5DfaKzlybZ8MU6Bg
         nR5U4H2RcU6zfazXFrVAlc6VxD3Ev5olNKlk5BmKdA6KXNqn7H95pao9peCI9X8ztdzr
         SzQ+E+T4nETujCpRL0+FrHfjnMW/dKxPLVa3dUDAwGDFdzlXALq62RLygmX5+4bxn91S
         An8wVwxPiKsk7Mo2L2KHuleTKqSBabAdhQ8yFLyBD57MVjTUrAl/Jphm6ibCd0VnIdza
         bTqg==
X-Forwarded-Encrypted: i=1; AL+hErFlLxX7w8NMfTp7kBbnwe31xKieXVhYe+vsmfue6i23K7qtPPf5u2P8DWEKCo/TdqUfNMztoxLeZbI=@vger.kernel.org
X-Gm-Message-State: APuU4Z+f3FnxPHJ+Zv9tS+ja3VDylSGlyprYh6KCIOvfOWkT++OL+XxL
	UwWETLb56SzqL4IzV8JcRVOIrwccJo16dDKN5DB4MoNlrfdTZ1QacSzKlJ7iGV/WkXQ=
X-Gm-Gg: AYBFou2G0N4UEaSIBVktWQYmuWKmu0ocYL3dyiHTKUiRXYUx29yn6y3XzVW6yqUvnPj
	DjcMtcYv6YwNRemguHofsveg13BU0WAgYrJL8j9eCY4V+Yh5tMpSfsAj+CFkfzHHC4SWfY40edR
	EV8kkcwR0HmfTOaaeobDt/I4ixQ97P9xF/F0Vw/f+GEq/Sx04/6fWUZ9/w2zvHl/SrDyPsnSzp+
	XA6BZHo9SUQUu7UWKXGwkAvqElk9u1gNTbVRVIyTpX/m+0ox3ljGxUU252QPBf25lMzeNON3O+x
	KUEQrw7/phDwODaeGZfBW6bCVd4DfZB4N11wjhJx9S6iotjGwfBGEdzmGfiEwqfNqVXYo0ltnEN
	1wRz0Ja7U3b7Qf4MUEd23abznjfNGKidPsnE3osTLyMREZlub7YPxCOxF1ZSI8aXkSlF66ia165
	6gho7z7bokpaoZ9warMfPq3+fSLxwpu19fifH6ap9E0qUvYCNhmrBzTAVjkaFxG3IT18jMJ1TfV
	wCi44KI6rz8arVt14HnHu0VqKs0HubOFkkxSDOU3K85x/rIUPBkSQVSyD9hE7i/9TYWRAQHiI7x
	G00QMk39SBBLOpUwa3+lhpbq+5+kIZwxr+UdioeB
X-Received: by 2002:a05:6000:1603:b0:492:7969:b4d2 with SMTP id ffacd0b85a97d-49c740bcf2cmr4478882f8f.40.1794586152436;
        Fri, 13 Nov 2026 08:09:12 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c60da0a03sm4852529f8f.53.2026.11.13.08.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 08:09:12 -0800 (PST)
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
Subject: [PATCH RFC v2 8/9] attestation: Add the TDX family specification and generated files
Date: Fri, 13 Nov 2026 17:08:37 +0100
Message-ID: <20261113160838.2512652-9-jiri@resnulli.us>
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

Define the TDX attestation family and reserve family ID 2. Add its ABI
snapshot, registry entry and generated kernel and UAPI files.

The ABI is intentionally specification-first. The generated descriptor
is linked with the provider implementation in the following patch.

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- generated the kernel files into drivers/virt/coco/tdx-guest/
- dropped the family's priv lifecycle hook
- generated an extension fill in place of a stub fill
- wrote the spec as op trees and records
- numbered every enum member
- moved the generated UAPI headers to include/uapi/ctlv/
- documented every item of the spec
- put each field's doc above its generated helpers
- gave the legacy and DICE Quote formats as evidence-vendor-format
  values
- said message instead of wire
---
 .../ctlv/abi/ctlv-attestation-tdx.yaml        | 21 ++++++
 Documentation/ctlv/abi/families.registry.yaml |  1 +
 Documentation/ctlv/families.yaml              |  1 +
 Documentation/ctlv/generated-files.yaml       |  7 ++
 .../ctlv/specs/ctlv-attestation-tdx.yaml      | 25 +++++++
 MAINTAINERS                                   |  1 +
 .../coco/tdx-guest/ctlv_attestation_tdx_gen.c | 65 +++++++++++++++++++
 .../coco/tdx-guest/ctlv_attestation_tdx_gen.h | 44 +++++++++++++
 include/uapi/ctlv/ctlv_attestation_tdx_gen.h  | 42 ++++++++++++
 include/uapi/ctlv/ctlv_families_gen.h         |  1 +
 10 files changed, 208 insertions(+)
 create mode 100644 Documentation/ctlv/abi/ctlv-attestation-tdx.yaml
 create mode 100644 Documentation/ctlv/specs/ctlv-attestation-tdx.yaml
 create mode 100644 drivers/virt/coco/tdx-guest/ctlv_attestation_tdx_gen.c
 create mode 100644 drivers/virt/coco/tdx-guest/ctlv_attestation_tdx_gen.h
 create mode 100644 include/uapi/ctlv/ctlv_attestation_tdx_gen.h

diff --git a/Documentation/ctlv/abi/ctlv-attestation-tdx.yaml b/Documentation/ctlv/abi/ctlv-attestation-tdx.yaml
new file mode 100644
index 000000000000..f8dc3c085c71
--- /dev/null
+++ b/Documentation/ctlv/abi/ctlv-attestation-tdx.yaml
@@ -0,0 +1,21 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+%YAML 1.2
+---
+# Checked-in ABI snapshot of the ctlv-attestation-tdx family, from
+# Documentation/ctlv/specs/ctlv-attestation-tdx.yaml, written by
+# "make -C tools/ctlv regen".
+#
+# Updating the file is how a UAPI change gets reviewed; an update that
+# removes or renumbers anything, narrows a bound, or makes a member required
+# is an ABI break, whatever the file says afterwards.
+family: {name: ctlv-attestation-tdx, id: 2, inherits: ctlv-attestation}
+enums:
+  evidence-vendor-format: {quote: 1, quote-dice: 2}
+records:
+  device-info:
+    id: 0x00010000
+    fields:
+      mrconfigid: {number: 1, type: binary, length: 48}
+      mrowner: {number: 2, type: binary, length: 48}
+      mrownerconfig: {number: 3, type: binary, length: 48}
+fills: {device-info: device-info}
diff --git a/Documentation/ctlv/abi/families.registry.yaml b/Documentation/ctlv/abi/families.registry.yaml
index 7a5c6af29565..0f55cc4f2e35 100644
--- a/Documentation/ctlv/abi/families.registry.yaml
+++ b/Documentation/ctlv/abi/families.registry.yaml
@@ -6,3 +6,4 @@
 families:
   - ctlv
   - ctlv-attestation
+  - ctlv-attestation-tdx
diff --git a/Documentation/ctlv/families.yaml b/Documentation/ctlv/families.yaml
index dbb0243b873d..27bafae3ca66 100644
--- a/Documentation/ctlv/families.yaml
+++ b/Documentation/ctlv/families.yaml
@@ -16,3 +16,4 @@
 families:
   - ctlv
   - ctlv-attestation
+  - ctlv-attestation-tdx
diff --git a/Documentation/ctlv/generated-files.yaml b/Documentation/ctlv/generated-files.yaml
index 00a56634805d..e78997f13334 100644
--- a/Documentation/ctlv/generated-files.yaml
+++ b/Documentation/ctlv/generated-files.yaml
@@ -23,3 +23,10 @@ families:
       uapi-header: include/uapi/ctlv/ctlv_attestation_gen.h
       kernel-header: drivers/attestation/generated/ctlv_attestation_gen.h
       kernel-source: drivers/attestation/generated/ctlv_attestation_gen.c
+
+  - name: ctlv-attestation-tdx
+    source: Documentation/ctlv/specs/ctlv-attestation-tdx.yaml
+    outputs:
+      uapi-header: include/uapi/ctlv/ctlv_attestation_tdx_gen.h
+      kernel-header: drivers/virt/coco/tdx-guest/ctlv_attestation_tdx_gen.h
+      kernel-source: drivers/virt/coco/tdx-guest/ctlv_attestation_tdx_gen.c
diff --git a/Documentation/ctlv/specs/ctlv-attestation-tdx.yaml b/Documentation/ctlv/specs/ctlv-attestation-tdx.yaml
new file mode 100644
index 000000000000..0093015b4991
--- /dev/null
+++ b/Documentation/ctlv/specs/ctlv-attestation-tdx.yaml
@@ -0,0 +1,25 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+%YAML 1.2
+---
+# The attestation device of an Intel TDX guest: Quotes of its TDREPORT, the
+# CCEL event log, MRTD and RTMR0 to RTMR3.
+family: ctlv-attestation-tdx
+inherits: ctlv-attestation
+
+enums:
+  # Fills ctlv-attestation's evidence-vendor-format.
+  evidence-vendor-format:
+    # An Intel TDX DCAP Quote, from the host's quoting enclave.
+    - quote
+    # A DICE-based TDX Quote, an EAT in a CBOR Web Token.
+    - quote-dice
+
+records:
+  # Fills ctlv-attestation's device-info.
+  device-info:
+    # MRCONFIGID of the TD, the ID of its non-owner configuration.
+    mrconfigid: binary(48)
+    # MROWNER of the TD, the ID of its owner.
+    mrowner: binary(48)
+    # MROWNERCONFIG of the TD, the ID of its owner's configuration.
+    mrownerconfig: binary(48)
diff --git a/MAINTAINERS b/MAINTAINERS
index 172b20d5fdd1..0734efa1a78f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4442,6 +4442,7 @@ F:	Documentation/ctlv/specs/ctlv-attestation*
 F:	Documentation/driver-api/attestation.rst
 F:	Documentation/userspace-api/attestation*.rst
 F:	drivers/attestation/
+F:	drivers/virt/coco/tdx-guest/*attestation*
 F:	include/linux/attestation*
 F:	include/uapi/ctlv/ctlv_attestation*
 
diff --git a/drivers/virt/coco/tdx-guest/ctlv_attestation_tdx_gen.c b/drivers/virt/coco/tdx-guest/ctlv_attestation_tdx_gen.c
new file mode 100644
index 000000000000..8795febbdeeb
--- /dev/null
+++ b/drivers/virt/coco/tdx-guest/ctlv_attestation_tdx_gen.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+/*
+ * Generated from Documentation/ctlv/specs/ctlv-attestation-tdx.yaml by
+ * tools/ctlv/ctlv-regen.sh. Do not edit.
+ */
+/* CTLV-GEN kernel source */
+
+#define _CTLV_GENERATED_METADATA_ONLY
+#include <linux/array_size.h>
+#include <linux/build_bug.h>
+#include <linux/ctlv_family.h>
+#include <linux/export.h>
+
+#include <uapi/ctlv/ctlv_gen.h>
+#include <uapi/ctlv/ctlv_attestation_tdx_gen.h>
+
+#include "ctlv_attestation_tdx_gen.h"
+
+static const struct ctlv_node_schema device_info_fill_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(1, 3, 3),
+	CTLV_NODE_SCHEMA_BINARY(CTLV_ATTESTATION_TDX_T_DEVICE_INFO_MRCONFIGID, 1, 48, 48),
+	CTLV_NODE_SCHEMA_BINARY(CTLV_ATTESTATION_TDX_T_DEVICE_INFO_MROWNER, 1, 48, 48),
+	CTLV_NODE_SCHEMA_BINARY(CTLV_ATTESTATION_TDX_T_DEVICE_INFO_MROWNERCONFIG, 1, 48, 48),
+};
+
+/* The extension points this family fills. */
+static const struct ctlv_ext_fill_schema ctlv_attestation_tdx_ext_fill_schemas[] = {
+	CTLV_EXT_FILL_SCHEMA(CTLV_FAMILY_ATTESTATION, CTLV_ATTESTATION_EXT_DEVICE_INFO,
+			     device_info),
+};
+
+/* The enum extension points this family fills. */
+static const struct ctlv_enum_fill_schema ctlv_attestation_tdx_enum_fill_schemas[] = {
+	CTLV_ENUM_FILL_SCHEMA(CTLV_FAMILY_ATTESTATION,
+			      CTLV_ATTESTATION_ENUM_EXT_EVIDENCE_VENDOR_FORMAT, 2),
+};
+
+/* The family ID is its position in the central registry. */
+const struct ctlv_family_schema ctlv_attestation_tdx_schema = {
+	.name = "ctlv-attestation-tdx",
+	.family_id = 2,
+	.ext_fill_schemas = ctlv_attestation_tdx_ext_fill_schemas,
+	.ext_fill_schemas_count = ARRAY_SIZE(ctlv_attestation_tdx_ext_fill_schemas),
+	.enum_fill_schemas = ctlv_attestation_tdx_enum_fill_schemas,
+	.enum_fill_schemas_count = ARRAY_SIZE(ctlv_attestation_tdx_enum_fill_schemas),
+};
+
+/* Maximum uevent cost for this family chain. */
+static_assert(150 <= CTLV_UEVENT_MAX_LEN);
+static_assert(5 <= CTLV_UEVENT_MAX_VARS);
+
+/* Extension-point callbacks. */
+static const struct ctlv_ext_ops ctlv_attestation_tdx_ext_ops[] = {
+	CTLV_EXT_OPS(CTLV_FAMILY_ATTESTATION, CTLV_ATTESTATION_EXT_DEVICE_INFO,
+		     ctlv_attestation_tdx_device_info),
+};
+
+/* Family descriptor used by ctlv_init(). */
+const struct ctlv_family ctlv_attestation_tdx_family = {
+	.schema = &ctlv_attestation_tdx_schema,
+	.parent = &ctlv_attestation_family,
+	.ext_ops = ctlv_attestation_tdx_ext_ops,
+	.ext_ops_count = ARRAY_SIZE(ctlv_attestation_tdx_ext_ops),
+};
+EXPORT_SYMBOL_NS_GPL(ctlv_attestation_tdx_family, "CTLV");
diff --git a/drivers/virt/coco/tdx-guest/ctlv_attestation_tdx_gen.h b/drivers/virt/coco/tdx-guest/ctlv_attestation_tdx_gen.h
new file mode 100644
index 000000000000..99c3cbc41a39
--- /dev/null
+++ b/drivers/virt/coco/tdx-guest/ctlv_attestation_tdx_gen.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/*
+ * Generated from Documentation/ctlv/specs/ctlv-attestation-tdx.yaml by
+ * tools/ctlv/ctlv-regen.sh. Do not edit.
+ */
+/* CTLV-GEN kernel header */
+
+/* Kernel metadata and family API of the ctlv-attestation-tdx CTLV family. */
+
+#ifndef _LINUX_CTLV_ATTESTATION_TDX_GEN_H
+#define _LINUX_CTLV_ATTESTATION_TDX_GEN_H
+
+#include <linux/ctlv_family.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+
+#include <uapi/ctlv/ctlv_attestation_tdx_gen.h>
+
+#include "ctlv_attestation_gen.h"
+
+extern const struct ctlv_family_schema ctlv_attestation_tdx_schema;
+
+/* device-info of ctlv-attestation: fill callback. */
+int ctlv_attestation_tdx_device_info_fill(struct ctlv *ctlv, struct ctlv_op_ctx *ctx,
+					  const struct ctlv_cursor *request,
+					  struct ctlv_cursor *record);
+
+extern const struct ctlv_family ctlv_attestation_tdx_family;
+
+#ifndef _CTLV_GENERATED_METADATA_ONLY
+
+/* Writing a reply. An append is atomic; a record ends with ctlv_record_end(). */
+/* MRCONFIGID of the TD, the ID of its non-owner configuration. */
+CTLV_PUT_BINARY(ctlv_attestation_tdx_device_info_mrconfigid,
+		CTLV_ATTESTATION_TDX_T_DEVICE_INFO_MRCONFIGID, CTLV_SCHEMA_BINARY)
+/* MROWNER of the TD, the ID of its owner. */
+CTLV_PUT_BINARY(ctlv_attestation_tdx_device_info_mrowner,
+		CTLV_ATTESTATION_TDX_T_DEVICE_INFO_MROWNER, CTLV_SCHEMA_BINARY)
+/* MROWNERCONFIG of the TD, the ID of its owner's configuration. */
+CTLV_PUT_BINARY(ctlv_attestation_tdx_device_info_mrownerconfig,
+		CTLV_ATTESTATION_TDX_T_DEVICE_INFO_MROWNERCONFIG, CTLV_SCHEMA_BINARY)
+#endif /* _CTLV_GENERATED_METADATA_ONLY */
+
+#endif /* _LINUX_CTLV_ATTESTATION_TDX_GEN_H */
diff --git a/include/uapi/ctlv/ctlv_attestation_tdx_gen.h b/include/uapi/ctlv/ctlv_attestation_tdx_gen.h
new file mode 100644
index 000000000000..77339ca50ca5
--- /dev/null
+++ b/include/uapi/ctlv/ctlv_attestation_tdx_gen.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/*
+ * Generated from Documentation/ctlv/specs/ctlv-attestation-tdx.yaml by
+ * tools/ctlv/ctlv-regen.sh. Do not edit.
+ */
+/* CTLV-GEN uapi header */
+
+/*
+ * Constants of the ctlv-attestation-tdx CTLV family. Types and op IDs are complete; the message
+ * format carrying them is in <ctlv/ctlv.h>.
+ *
+ * The inherited ctlv-attestation header is included here, so one include covers the whole effective
+ * schema.
+ */
+
+#ifndef _UAPI_CTLV_CTLV_ATTESTATION_TDX_GEN_H
+#define _UAPI_CTLV_CTLV_ATTESTATION_TDX_GEN_H
+
+#include <ctlv/ctlv.h>
+#include <ctlv/ctlv_attestation_gen.h>
+#include <ctlv/ctlv_families_gen.h>
+
+/* enum evidence-vendor-format, an extension point of ctlv-attestation */
+enum _ctlv_attestation_tdx_evidence_vendor_format {
+	/* An Intel TDX DCAP Quote, from the host's quoting enclave. */
+	CTLV_ATTESTATION_TDX_EVIDENCE_VENDOR_FORMAT_QUOTE = 1,
+	/* A DICE-based TDX Quote, an EAT in a CBOR Web Token. */
+	CTLV_ATTESTATION_TDX_EVIDENCE_VENDOR_FORMAT_QUOTE_DICE = 2,
+};
+
+/* device-info */
+/* MRCONFIGID of the TD, the ID of its non-owner configuration. */
+#define CTLV_ATTESTATION_TDX_T_DEVICE_INFO_MRCONFIGID \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION_TDX, 0x00010000, 1)
+/* MROWNER of the TD, the ID of its owner. */
+#define CTLV_ATTESTATION_TDX_T_DEVICE_INFO_MROWNER \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION_TDX, 0x00010000, 2)
+/* MROWNERCONFIG of the TD, the ID of its owner's configuration. */
+#define CTLV_ATTESTATION_TDX_T_DEVICE_INFO_MROWNERCONFIG \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION_TDX, 0x00010000, 3)
+
+#endif /* _UAPI_CTLV_CTLV_ATTESTATION_TDX_GEN_H */
diff --git a/include/uapi/ctlv/ctlv_families_gen.h b/include/uapi/ctlv/ctlv_families_gen.h
index 83f6a257ddf2..849671f8681d 100644
--- a/include/uapi/ctlv/ctlv_families_gen.h
+++ b/include/uapi/ctlv/ctlv_families_gen.h
@@ -13,6 +13,7 @@
 enum _ctlv_family {
 	CTLV_FAMILY_ROOT = 0,
 	CTLV_FAMILY_ATTESTATION = 1,
+	CTLV_FAMILY_ATTESTATION_TDX = 2,
 };
 
 #endif /* _UAPI_CTLV_CTLV_FAMILIES_GEN_H */
-- 
2.56.0

