Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585338;
	b=WjAP2saC2yfA8Zh3/yH3VX48ntwTHWd/35baxD322sFFcQ3iF0kb6WH9W6r3UlulZpBb
	 TsMG7is0NOsYsCXA6PDVIGCb6EixPPPC9LBw4qswKyD4izIG9XOldV8M8H96IK0KCQ3T2
	 ujCwofI7PRVB6AkUBM0HIAmAQDVjUWNVxaj2RB5mpKlqOdH7jhwg245q+mK0mm5MnjrIA
	 8ml2KirDIyyc5sWE0eISa7hctxslIestU1S3EpwPRkO5qRk5VDlpo+IwN5t1p8kfiBGaO
	 b8F8apHCXKQXBtH91qMJs4sGuRWMsYyw7QFy+KuVOyn3sS7Zyx0ofMdHHBW2CwFSd0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585338;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+PRnaV7MHk9S90G5Op2i1BmFB93giGLrGqRE/tp7gFw=;
	b=KHlW+1KAvSi/fAFAu+FXjmEbbrBzUg5DykOeR8/DAEf/6zLjFEkqx+x6F9Ev9qXtIqwU
	 weZULLGMfqmL5qkyctmlLHzKwpgKsnkJZdjiLiItVkXTC5XyqY0JjvxzWgDazn1NrVGYu
	 s1TkfjvZVBoQGw00Q20sKHY1fYSLPjKw0gk7gFPg9rdLP9hjS2TAUuMr6dMx9CdmJhdEF
	 kPDC1z2DBNgyr+b3O4kO/crQYmAt/pcdHsIiFuF/ETTSTlRPIzHM70C+UoCNMwkR7zzmp
	 FnjuEhrp2dZEBgjpjZGl/tcLz7+ppFtBApeBO4rV1wL84ToIdIPmAA447jZciw4RrRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=QudtiuDS;
	arc=none smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB1F60A260B
	for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 15:55:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFB1F60A260B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=QudtiuDS
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c505b2e1cb9so210818866b.2
        for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 07:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1794585334; x=1795190134; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+PRnaV7MHk9S90G5Op2i1BmFB93giGLrGqRE/tp7gFw=;
        b=QudtiuDS0m5XAc6DPfXicDPMWdMvns+8FpGfQzM1bWzQ3ZaGZe5Ocs1PpcvSaWNTB8
         e02PJnsZsGHt+oyAdwtTmmRewILVVw7KmzPqSVWJGtZ2e2GYWBIYLrr+DioPRPZ1Gm86
         KGVIeRO5SnoX4rqhNsOaOiLH+MlBZVct/GxUepmJmaCJOyg9la1FdIzbw677o/Agyvn7
         b1bMXRND0GL8olFgv4oKq8YheOTL12G5gikVB7nsS9bOqKJePiuhKfzA2HtmjWNvHxW8
         4Y2CGbosr5eOsj1WnxXzIFL6pR3TWVT8QpifjRNlu792z1PcDY7lhHRe5bKlajWeOqK0
         CaNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794585334; x=1795190134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+PRnaV7MHk9S90G5Op2i1BmFB93giGLrGqRE/tp7gFw=;
        b=ta7WZllhl+J46usF2PaETqBLRFJ6RYRxbKpJVmzpOQFQMLapcnViJvh2sI3fU2FT3j
         dpVSzqcZYEa2zos9gIIZrWp07qmA5bbf8YzE9/vhV4WcSEnXk8bUIOyjcgqutSRW7Q9v
         ueXgjj/ycLxMEWQYI+xgQrUw8j0I8zG4z90G433Mc/ZUT6Fv0TTYV6tLHv18acoC1INm
         MH66//PrpxewMtjgy1jRWQllSXD99wrlxYWdolsRAMJ9cu7MsfVAeFbZzCnGSBJ8DjRT
         jJ4PtBEWm4ZNmpEGIBcubKaJfMmMOUXxPDiH0tZLcNTB3+Ku/fYvNbFI2jtQ34HYsluR
         QXVg==
X-Forwarded-Encrypted: i=1; AL+hErHBvuSDzOQVocSL8u2gVYhwX+qBWzq2d//EaZDcJmUmpMJ3d4WkI8Zq7Tvw5L+v7oHH0vLRVuVf82Q=@vger.kernel.org
X-Gm-Message-State: APuU4Z9Qmk9VTquK0b4dOGZ0x8slqEC1VupcIBrqO/Su5WIsoiacw5DQ
	ID12nkQ7y3ZgfryYIguZq++qiS+tPOIoHjaSJjgra5kg2P6GpUboJ4JuugQ+ZKqvKjw=
X-Gm-Gg: AYBFou3uhNYBwxz2WYl+5x65XgXL1RuXCCXwDOzrI9NFkJ/yWVNtuBC+59ad3VtK60L
	h41MRXcSg1TwM4zCq1gyKeZA25MG2e/NQvh4pOJN7Jhch92xfW4G0iwQkP1qg5ZHJHL2iDlmXsN
	bqtse915i8pEDoBWObStCWh/HojUv9lLKI3R04pr1whSXij81gLNTJpiv9Gv9tDJ4+M0S5I45EY
	joSP3cDrUM+SHdAMfWfAkAexL4KkbJnSBZojr2n4V7gGpbEeg8jbWLt+AZi10QSGTrHpL2Xzs7k
	FRzZ6EBOyjzSPI/V0aXPj/7R+yaUIOanb1l2MEFpR7DaJn6Ey+BsEMR1SP+luViYcIcVJ6GSYwn
	JnFbtI3pt5ZtBau42HY7Oro21wMrM/vCkdt7sOlWChcr50WgmUbqA1TfGpirVyCkEKt+/p7PScV
	ColP91yA3GINRHMIrAA9QTVEkl6T28fPlvVIWSkYFO8grUY9lNmb1UN2nvKkxoM6wlZC83FqudV
	BoTJ0zgA0McyIRHUYLME3Z28/a9BnPQ1Svq7o35r7rBM046y9vgALp02DeB0L5irC1+txEqRSwt
	/9M0Fxsi7h6mUIU3kJPG4kvMrWwnTzm4pTgn+kxE73NMn82eq6I6MzzxbJ474w==
X-Received: by 2002:a17:907:3e8b:b0:c16:4e5:944a with SMTP id a640c23a62f3a-c509636a315mr250316966b.21.1794585333800;
        Fri, 13 Nov 2026 07:55:33 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b23b09sm113836266b.26.2026.11.13.07.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 07:55:33 -0800 (PST)
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
Subject: [PATCH RFC v2 03/15] ctlv: Add the root family specification and generated files
Date: Fri, 13 Nov 2026 16:55:02 +0100
Message-ID: <20261113155515.2510194-4-jiri@resnulli.us>
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

Define the root family used by every CTLV device. Add its ABI snapshot,
registry and manifest entries, and generated outputs.

The generated kernel descriptor is preparatory and is linked after its
handlers arrive with operation dispatch.

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- reported the error information length of actions and queries
- dropped the root family's priv and its hooks
- dropped the event ops, the events and the sets, groups and attrs only
  they use
- warned against adding a family before agreeing its position
- wrote the spec as op trees and records
- added required-length to the error information
- said node instead of placement
- said record instead of nest, the root being one
- numbered every enum member
- moved the generated UAPI headers to include/uapi/ctlv/
- documented every item of the spec
- put each field's doc above its generated helpers
- renamed families-dump and ops-dump to family-get and op-get
- put ctlv_gen.c in lib/ctlv/
- said message instead of wire
---
 Documentation/ctlv/abi/ctlv.yaml              | 111 +++++++
 Documentation/ctlv/abi/families.registry.yaml |   7 +
 Documentation/ctlv/families.yaml              |  17 ++
 Documentation/ctlv/generated-files.yaml       |  17 ++
 Documentation/ctlv/specs/ctlv.yaml            | 211 +++++++++++++
 include/linux/ctlv_gen.h                      | 154 ++++++++++
 include/uapi/ctlv/ctlv_families_gen.h         |  17 ++
 include/uapi/ctlv/ctlv_gen.h                  | 278 ++++++++++++++++++
 lib/ctlv/ctlv_gen.c                           | 161 ++++++++++
 9 files changed, 973 insertions(+)
 create mode 100644 Documentation/ctlv/abi/ctlv.yaml
 create mode 100644 Documentation/ctlv/abi/families.registry.yaml
 create mode 100644 Documentation/ctlv/families.yaml
 create mode 100644 Documentation/ctlv/generated-files.yaml
 create mode 100644 Documentation/ctlv/specs/ctlv.yaml
 create mode 100644 include/linux/ctlv_gen.h
 create mode 100644 include/uapi/ctlv/ctlv_families_gen.h
 create mode 100644 include/uapi/ctlv/ctlv_gen.h
 create mode 100644 lib/ctlv/ctlv_gen.c

diff --git a/Documentation/ctlv/abi/ctlv.yaml b/Documentation/ctlv/abi/ctlv.yaml
new file mode 100644
index 000000000000..dc26ba575a68
--- /dev/null
+++ b/Documentation/ctlv/abi/ctlv.yaml
@@ -0,0 +1,111 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+%YAML 1.2
+---
+# Checked-in ABI snapshot of the ctlv family, from
+# Documentation/ctlv/specs/ctlv.yaml, written by
+# "make -C tools/ctlv regen".
+#
+# Updating the file is how a UAPI change gets reviewed; an update that
+# removes or renumbers anything, narrows a bound, or makes a member required
+# is an ABI break, whatever the file says afterwards.
+family: {name: ctlv, id: 0}
+enums:
+  op-type: {action: 1, query: 2}
+  op-availability: {fixed: 1, dynamic: 2}
+  blob-type: {va: 1}
+  blob-direction: {input: 1, output: 2, inout: 3}
+  validation-reason: {malformed-message: 1, unknown-type: 2, unknown-flag: 3,
+                      record-too-deep: 4, missing-field: 5,
+                      too-many-occurrences: 6, value-out-of-range: 7,
+                      bad-length: 8, bad-string: 9, bad-blob-descriptor: 10,
+                      stale-generation: 11, noncontiguous-type: 12}
+  op-fd-access: {read: 1, read-write: 2}
+records:
+  blob:
+    id: 0x00010000
+    fields:
+      type: {number: 1, enum: blob-type}
+      address: {number: 2, type: uint, optional: true}
+      fd: {number: 3, type: uint, max: s32-max, optional: true}
+      offset: {number: 4, type: uint, optional: true}
+      length: {number: 5, type: uint, min: 1}
+  error-info:
+    id: 0x00020000
+    fields:
+      reason: {number: 1, enum: validation-reason, optional: true}
+      message: {number: 2, type: string, max-length: 255, optional: true}
+      bad-tlv-offset: {number: 3, type: uint, optional: true}
+      record-offset: {number: 4, type: uint, optional: true}
+      missing-type: {number: 5, type: uint, optional: true}
+      expected-generation: {number: 6, type: uint, optional: true}
+      current-generation: {number: 7, type: uint, optional: true}
+      required-length: {number: 8, type: uint, optional: true}
+  schema-node:
+    id: 0x00030000
+    fields:
+      type: {number: 1, type: uint}
+      kind: {number: 2, type: uint}
+      max-occurrences: {number: 3, type: uint}
+      min: {number: 4, type: uint, optional: true}
+      max: {number: 5, type: uint, optional: true}
+      min-length: {number: 6, type: uint, optional: true}
+      max-length: {number: 7, type: uint, optional: true}
+      flags-mask: {number: 8, type: uint, optional: true}
+      unit: {number: 9, type: uint, optional: true}
+      scale: {number: 10, type: sint, optional: true}
+      blob-direction: {number: 11, enum: blob-direction, optional: true}
+      blob-backings: {number: 12, type: uint, optional: true}
+      blob-max-length: {number: 13, type: uint, optional: true}
+      blob-alignment: {number: 14, type: uint, optional: true}
+      reenters: {number: 15, type: uint, min: 1, optional: true}
+      fields: {number: 16, record: schema-node, max-occurrences: unlimited,
+               optional: true}
+      optional-fields: {number: 17, record: schema-node,
+                        max-occurrences: unlimited, optional: true}
+  family-get request:
+    id: 0x80010000
+  family-get reply:
+    id: 0xc0010000
+    fields:
+      families: {number: 1, record: family-get families,
+                 max-occurrences: unlimited}
+  family-get families:
+    id: 0xc0011000
+    fields:
+      id: {number: 1, type: uint}
+      name: {number: 2, type: string, max-length: 63}
+  op-get request:
+    id: 0x80020000
+  op-get reply:
+    id: 0xc0020000
+    fields:
+      ops: {number: 1, record: op-get ops, max-occurrences: unlimited}
+  op-get ops:
+    id: 0xc0021000
+    fields:
+      id: {number: 1, type: uint, min: 1}
+      type: {number: 2, enum: op-type}
+      availability: {number: 3, enum: op-availability, optional: true}
+      disabled: {number: 4, type: bool, optional: true}
+      request-max-len: {number: 5, type: uint, optional: true}
+      action-reply-max-len: {number: 6, type: uint, optional: true}
+      query-reply-min-len: {number: 7, type: uint, optional: true}
+      query-reply-suggested-len: {number: 8, type: uint, optional: true}
+      fd-access: {number: 9, enum: op-fd-access, optional: true}
+      error-info-max-len: {number: 10, type: uint, optional: true}
+  op-schema-get request:
+    id: 0x80030000
+    fields:
+      id: {number: 1, type: uint, min: 1}
+  op-schema-get reply:
+    id: 0xc0030000
+    fields:
+      request: {number: 1, record: schema-node, optional: true}
+      reply: {number: 2, record: schema-node, optional: true}
+ops:
+  family-get: {id: 1, type: query, fd-access: read, request: family-get request,
+               reply: family-get reply}
+  op-get: {id: 2, type: query, fd-access: read, request: op-get request,
+           reply: op-get reply}
+  op-schema-get: {id: 3, type: query, fd-access: read,
+                  request: op-schema-get request, reply: op-schema-get reply}
diff --git a/Documentation/ctlv/abi/families.registry.yaml b/Documentation/ctlv/abi/families.registry.yaml
new file mode 100644
index 000000000000..5845e7457771
--- /dev/null
+++ b/Documentation/ctlv/abi/families.registry.yaml
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+%YAML 1.2
+---
+# Checked-in ABI baseline of the ordered CTLV family registry.
+# Written by "make -C tools/ctlv regen".
+families:
+  - ctlv
diff --git a/Documentation/ctlv/families.yaml b/Documentation/ctlv/families.yaml
new file mode 100644
index 000000000000..4d219d7af74a
--- /dev/null
+++ b/Documentation/ctlv/families.yaml
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+%YAML 1.2
+---
+# Do not add a family without agreeing its position with the CTLV
+# maintainers (CTLV SUBSYSTEM in MAINTAINERS) first. The position is the
+# family ID, so families added in parallel trees end up with the same ID.
+#
+# Append-only registry of CTLV family names, indexed by family ID: the entry at
+# index N has family ID N, up to 65535. The root family owns ID 0 and heads the
+# list, and every other entry comes after the entry of the family it inherits.
+# An entry may be marked deprecated, but never reordered, removed, renamed or
+# reused, its position being its family ID. Every entry must have a
+# specification in specs/<name>.yaml, and is added by the change that adds the
+# implementation. Fixtures under tools/ctlv/tests/ are not registered.
+
+families:
+  - ctlv
diff --git a/Documentation/ctlv/generated-files.yaml b/Documentation/ctlv/generated-files.yaml
new file mode 100644
index 000000000000..5488ddf40e17
--- /dev/null
+++ b/Documentation/ctlv/generated-files.yaml
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+%YAML 1.2
+---
+# Generated files for registered families.
+version: 1
+registry:
+  source: Documentation/ctlv/families.yaml
+  outputs:
+    uapi-header: include/uapi/ctlv/ctlv_families_gen.h
+
+families:
+  - name: ctlv
+    source: Documentation/ctlv/specs/ctlv.yaml
+    outputs:
+      uapi-header: include/uapi/ctlv/ctlv_gen.h
+      kernel-header: include/linux/ctlv_gen.h
+      kernel-source: lib/ctlv/ctlv_gen.c
diff --git a/Documentation/ctlv/specs/ctlv.yaml b/Documentation/ctlv/specs/ctlv.yaml
new file mode 100644
index 000000000000..a7108f59c267
--- /dev/null
+++ b/Documentation/ctlv/specs/ctlv.yaml
@@ -0,0 +1,211 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+%YAML 1.2
+---
+# The root CTLV family, family ID 0 and the first entry in families.yaml. It
+# inherits nothing, and every other family name begins with "ctlv-". Every
+# CTLV device answers these ops in addition to its own family's. Every blob
+# field of every family carries the blob record, and every failure may write
+# error-info. Nothing here may be reordered or removed.
+family: ctlv
+
+enums:
+  # What an op is, which decides the messages it has.
+  op-type:
+    # Executed and acknowledged.
+    - action
+    # Executed and answered, in as many fragments as the answer needs.
+    - query
+  # A permission, not a state: what a device currently allows is disabled.
+  op-availability:
+    # A device that publishes the op always answers it.
+    - fixed
+    # A device may disable and enable the op at any time.
+    - dynamic
+  # What holds the bytes of a blob.
+  blob-type:
+    # Anonymous memory of the calling process, at address.
+    - va
+  # Which way the bytes of a blob go.
+  blob-direction:
+    # From the caller to the device, which only reads the blob.
+    - input
+    # From the device to the caller.
+    - output
+    # Both ways: the device reads the blob and writes it.
+    - inout
+  # The first rule a refused message broke.
+  validation-reason:
+    # The TLVs do not frame: the root is not one, a length runs past its
+    # record, or a TLV is a record where its schema has a scalar or the
+    # reverse.
+    - malformed-message
+    # A TLV of a type its record does not place there, not marked
+    # IGNORE_IF_UNKNOWN or of a type the schema places elsewhere.
+    - unknown-type
+    # A header flag the message may not carry, or a flags payload with a bit
+    # its field does not declare.
+    - unknown-flag
+    # Records nested deeper than the core follows.
+    - record-too-deep
+    # A required field is absent, and missing-type says which.
+    - missing-field
+    # A field occurs more often than its schema allows.
+    - too-many-occurrences
+    # An integer, an enum value or a bool outside what its field takes.
+    - value-out-of-range
+    # A payload of the wrong length for its kind, or outside its field's
+    # length bounds.
+    - bad-length
+    # A string payload that is not exactly one NUL-terminated string.
+    - bad-string
+    # A blob descriptor its field does not take, or one whose memory could
+    # not be acquired or is too short for what the op writes there.
+    - bad-blob-descriptor
+    # A query continuation of a generation the query no longer has.
+    - stale-generation
+    # The TLVs of one type are not contiguous in their record.
+    - noncontiguous-type
+  # What an op asks of the file description that executes it.
+  op-fd-access:
+    # Read access, which an observation fd has as well as a full-control one.
+    - read
+    # Read-write access, which only a full-control fd has.
+    - read-write
+
+records:
+  # va takes address; fd and offset are reserved for later fd-backed
+  # types.
+  blob:
+    # What holds the bytes, which says which of the fields below are present.
+    type: blob-type
+    # Where a va blob starts in the calling process.
+    address?: uint
+    # Reserved for a later fd-backed type.
+    fd?: uint(..s32-max)
+    # Reserved for a later fd-backed type.
+    offset?: uint
+    # The length of the blob in bytes, at most what its field takes.
+    length: uint(1..)
+
+  # Only what describes the first failure is present.
+  error-info:
+    # The rule the message broke.
+    reason?: validation-reason
+    # What went wrong, for a person to read.
+    message?: string(..255)
+    # The offset of the offending TLV from the start of the message, or of
+    # its record when what is wrong is something the record lacks.
+    bad-tlv-offset?: uint
+    # The offset of the record holding it, from the start of the message.
+    record-offset?: uint
+    # The type of the required field that is absent.
+    missing-type?: uint
+    # The generation the query continuation carried.
+    expected-generation?: uint
+    # The generation the query has now.
+    current-generation?: uint
+    # How long the output blob at bad-tlv-offset has to be for the op.
+    required-length?: uint
+
+  # One node of an op's request or reply tree. Only the members the node's
+  # schema kind has are present. Nothing here is a name: a caller matches the
+  # family chain from family-get to find the generated UAPI.
+  schema-node:
+    # Zero in a message root node, as in the root TLV.
+    type: uint
+    # enum ctlv_schema_kind.
+    kind: uint
+    # Zero where the node may repeat as often as the message has room.
+    max-occurrences: uint
+    # The inclusive lower bound of an integer or enum payload, a raw 64-bit
+    # value read according to kind. An enum's values are numbered without
+    # gaps.
+    min?: uint
+    # The inclusive upper bound, read the same way.
+    max?: uint
+    # The shortest payload of a string or binary field, a string's terminator
+    # excluded.
+    min-length?: uint
+    # The longest payload, likewise.
+    max-length?: uint
+    # The bits a flags payload may carry.
+    flags-mask?: uint
+    # enum ctlv_unit, absent when the payload is dimensionless.
+    unit?: uint
+    # The decimal exponent of the unit, a payload being value * 10^scale of
+    # it, present only with a unit.
+    scale?: sint
+    # Which way a blob field's bytes go.
+    blob-direction?: blob-direction
+    # Mask of BIT(enum ctlv_blob_type): the backings this node takes.
+    blob-backings?: uint
+    # Maximum external payload length, unrelated to the inline message limit.
+    blob-max-length?: uint
+    # The power of two a blob's address or offset is a multiple of.
+    blob-alignment?: uint
+    # Levels to climb to the node whose members are this one's as well, one
+    # meaning the node this one is a member of. A node that carries it lists
+    # no members itself.
+    reenters?: uint(1..)
+    # The required nodes one level in.
+    fields[]?: record schema-node
+    # The optional nodes one level in.
+    optional-fields[]?: record schema-node
+
+ops:
+  # The families this device answers, this one first and the device family
+  # last. The only names any reply of this family carries.
+  family-get:
+    type: query
+    fd-access: read
+    reply:
+      # One entry per family of the chain.
+      families[]:
+        # The family ID, which bits 63..48 of the family's types carry.
+        id: uint
+        # The registry name, also what a uevent carries. Bounded here, this
+        # being the only place a message carries a family name.
+        name: string(..63)
+
+  # One entry per effective op. Length fields that do not apply to an
+  # entry's op type are absent.
+  op-get:
+    type: query
+    fd-access: read
+    reply:
+      # One entry per op the device publishes.
+      ops[]:
+        # The op ID, which CTLV_IOC_OP_EXEC carries.
+        id: uint(1..)
+        # Action or query.
+        type: op-type
+        # Whether the device may disable and enable the op.
+        availability?: op-availability
+        # Whether the device has the op disabled right now.
+        disabled?: bool
+        # The longest request composed from the schema.
+        request-max-len?: uint
+        # The reply buffer an action needs, zero for one that answers nothing.
+        action-reply-max-len?: uint
+        # The shortest reply buffer a query takes.
+        query-reply-min-len?: uint
+        # The reply buffer length the family suggests for a query.
+        query-reply-suggested-len?: uint
+        # The access a file description needs to execute the op.
+        fd-access?: op-fd-access
+        # The longest error information the op can return.
+        error-info-max-len?: uint
+
+  # The request and reply ABI of one op, whether or not it can be called right
+  # now. A removed op answers as one that was never declared.
+  op-schema-get:
+    type: query
+    fd-access: read
+    request:
+      # The ID of the op to describe.
+      id: uint(1..)
+    reply:
+      # The root of the op's request tree, absent when it has no request.
+      request?: record schema-node
+      # The root of its reply tree, absent when it has no reply.
+      reply?: record schema-node
diff --git a/include/linux/ctlv_gen.h b/include/linux/ctlv_gen.h
new file mode 100644
index 000000000000..117e5714c3fe
--- /dev/null
+++ b/include/linux/ctlv_gen.h
@@ -0,0 +1,154 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/*
+ * Generated from Documentation/ctlv/specs/ctlv.yaml by
+ * tools/ctlv/ctlv-regen.sh. Do not edit.
+ */
+/* CTLV-GEN kernel header */
+
+/* Kernel metadata and family API of the ctlv CTLV family. */
+
+#ifndef _LINUX_CTLV_GEN_H
+#define _LINUX_CTLV_GEN_H
+
+#include <linux/ctlv_family.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+
+#include <uapi/ctlv/ctlv_gen.h>
+
+/* Ops this family declares, in declaration order. */
+extern const struct ctlv_op_schema ctlv_op_schemas[];
+
+extern const struct ctlv_family_schema ctlv_schema;
+
+/* The error-info message, built by the core. */
+#define CTLV_ERROR_INFO_MAX_LEN 456
+
+extern const struct ctlv_schema_tree ctlv_error_info_schema;
+
+/* Implemented by the CTLV core, one per action and query it declares. */
+int ctlv_family_get_query(struct ctlv *ctlv, struct ctlv_op_ctx *ctx,
+			  const struct ctlv_cursor *request, struct ctlv_cursor *reply);
+int ctlv_op_get_query(struct ctlv *ctlv, struct ctlv_op_ctx *ctx, const struct ctlv_cursor *request,
+		      struct ctlv_cursor *reply);
+int ctlv_op_schema_get_query(struct ctlv *ctlv, struct ctlv_op_ctx *ctx,
+			     const struct ctlv_cursor *request, struct ctlv_cursor *reply);
+
+extern const struct ctlv_family ctlv_family;
+
+#ifndef _CTLV_GENERATED_METADATA_ONLY
+
+/* Reading a validated message. A blob has a resolver instead of a getter. */
+/* The ID of the op to describe. */
+CTLV_IN_REF(ctlv_op_schema_get_id, CTLV_T_OP_SCHEMA_GET_ID, CTLV_SCHEMA_UINT)
+CTLV_IN_HAS(ctlv_op_schema_get_id)
+CTLV_IN_U64(ctlv_op_schema_get_id)
+
+/* Writing a reply. An append is atomic; a record ends with ctlv_record_end(). */
+/* One entry per family of the chain. */
+CTLV_RECORD_START(ctlv_family_get_families, CTLV_T_FAMILY_GET_FAMILIES, CTLV_SCHEMA_RECORD)
+/* The family ID, which bits 63..48 of the family's types carry. */
+CTLV_PUT_U64(ctlv_family_get_families_id, CTLV_T_FAMILY_GET_FAMILIES_ID, CTLV_SCHEMA_UINT)
+/*
+ * The registry name, also what a uevent carries. Bounded here, this being the only place a message
+ * carries a family name.
+ */
+CTLV_PUT_STRING(ctlv_family_get_families_name, CTLV_T_FAMILY_GET_FAMILIES_NAME, CTLV_SCHEMA_STRING)
+/* One entry per op the device publishes. */
+CTLV_RECORD_START(ctlv_op_get_ops, CTLV_T_OP_GET_OPS, CTLV_SCHEMA_RECORD)
+/* The op ID, which CTLV_IOC_OP_EXEC carries. */
+CTLV_PUT_U64(ctlv_op_get_ops_id, CTLV_T_OP_GET_OPS_ID, CTLV_SCHEMA_UINT)
+/* Action or query. */
+CTLV_PUT_U64(ctlv_op_get_ops_type, CTLV_T_OP_GET_OPS_TYPE, CTLV_SCHEMA_ENUM)
+/* Whether the device may disable and enable the op. */
+CTLV_PUT_U64(ctlv_op_get_ops_availability, CTLV_T_OP_GET_OPS_AVAILABILITY, CTLV_SCHEMA_ENUM)
+/* Whether the device has the op disabled right now. */
+CTLV_PUT_BOOL(ctlv_op_get_ops_disabled, CTLV_T_OP_GET_OPS_DISABLED, CTLV_SCHEMA_BOOL)
+/* The longest request composed from the schema. */
+CTLV_PUT_U64(ctlv_op_get_ops_request_max_len, CTLV_T_OP_GET_OPS_REQUEST_MAX_LEN, CTLV_SCHEMA_UINT)
+/* The reply buffer an action needs, zero for one that answers nothing. */
+CTLV_PUT_U64(ctlv_op_get_ops_action_reply_max_len, CTLV_T_OP_GET_OPS_ACTION_REPLY_MAX_LEN,
+	     CTLV_SCHEMA_UINT)
+/* The shortest reply buffer a query takes. */
+CTLV_PUT_U64(ctlv_op_get_ops_query_reply_min_len, CTLV_T_OP_GET_OPS_QUERY_REPLY_MIN_LEN,
+	     CTLV_SCHEMA_UINT)
+/* The reply buffer length the family suggests for a query. */
+CTLV_PUT_U64(ctlv_op_get_ops_query_reply_suggested_len, CTLV_T_OP_GET_OPS_QUERY_REPLY_SUGGESTED_LEN,
+	     CTLV_SCHEMA_UINT)
+/* The access a file description needs to execute the op. */
+CTLV_PUT_U64(ctlv_op_get_ops_fd_access, CTLV_T_OP_GET_OPS_FD_ACCESS, CTLV_SCHEMA_ENUM)
+/* The longest error information the op can return. */
+CTLV_PUT_U64(ctlv_op_get_ops_error_info_max_len, CTLV_T_OP_GET_OPS_ERROR_INFO_MAX_LEN,
+	     CTLV_SCHEMA_UINT)
+/* The root of the op's request tree, absent when it has no request. */
+CTLV_RECORD_START(ctlv_op_schema_get_request, CTLV_T_OP_SCHEMA_GET_REQUEST, CTLV_SCHEMA_RECORD)
+/* Zero in a message root node, as in the root TLV. */
+CTLV_PUT_U64(ctlv_schema_node_type, CTLV_T_SCHEMA_NODE_TYPE, CTLV_SCHEMA_UINT)
+/* enum ctlv_schema_kind. */
+CTLV_PUT_U64(ctlv_schema_node_kind, CTLV_T_SCHEMA_NODE_KIND, CTLV_SCHEMA_UINT)
+/* Zero where the node may repeat as often as the message has room. */
+CTLV_PUT_U64(ctlv_schema_node_max_occurrences, CTLV_T_SCHEMA_NODE_MAX_OCCURRENCES, CTLV_SCHEMA_UINT)
+/*
+ * The inclusive lower bound of an integer or enum payload, a raw 64-bit value read according to
+ * kind. An enum's values are numbered without gaps.
+ */
+CTLV_PUT_U64(ctlv_schema_node_min, CTLV_T_SCHEMA_NODE_MIN, CTLV_SCHEMA_UINT)
+/* The inclusive upper bound, read the same way. */
+CTLV_PUT_U64(ctlv_schema_node_max, CTLV_T_SCHEMA_NODE_MAX, CTLV_SCHEMA_UINT)
+/* The shortest payload of a string or binary field, a string's terminator excluded. */
+CTLV_PUT_U64(ctlv_schema_node_min_length, CTLV_T_SCHEMA_NODE_MIN_LENGTH, CTLV_SCHEMA_UINT)
+/* The longest payload, likewise. */
+CTLV_PUT_U64(ctlv_schema_node_max_length, CTLV_T_SCHEMA_NODE_MAX_LENGTH, CTLV_SCHEMA_UINT)
+/* The bits a flags payload may carry. */
+CTLV_PUT_U64(ctlv_schema_node_flags_mask, CTLV_T_SCHEMA_NODE_FLAGS_MASK, CTLV_SCHEMA_UINT)
+/* enum ctlv_unit, absent when the payload is dimensionless. */
+CTLV_PUT_U64(ctlv_schema_node_unit, CTLV_T_SCHEMA_NODE_UNIT, CTLV_SCHEMA_UINT)
+/*
+ * The decimal exponent of the unit, a payload being value * 10^scale of it, present only with a
+ * unit.
+ */
+CTLV_PUT_S64(ctlv_schema_node_scale, CTLV_T_SCHEMA_NODE_SCALE, CTLV_SCHEMA_SINT)
+/* Which way a blob field's bytes go. */
+CTLV_PUT_U64(ctlv_schema_node_blob_direction, CTLV_T_SCHEMA_NODE_BLOB_DIRECTION, CTLV_SCHEMA_ENUM)
+/* Mask of BIT(enum ctlv_blob_type): the backings this node takes. */
+CTLV_PUT_U64(ctlv_schema_node_blob_backings, CTLV_T_SCHEMA_NODE_BLOB_BACKINGS, CTLV_SCHEMA_UINT)
+/* Maximum external payload length, unrelated to the inline message limit. */
+CTLV_PUT_U64(ctlv_schema_node_blob_max_length, CTLV_T_SCHEMA_NODE_BLOB_MAX_LENGTH, CTLV_SCHEMA_UINT)
+/* The power of two a blob's address or offset is a multiple of. */
+CTLV_PUT_U64(ctlv_schema_node_blob_alignment, CTLV_T_SCHEMA_NODE_BLOB_ALIGNMENT, CTLV_SCHEMA_UINT)
+/*
+ * Levels to climb to the node whose members are this one's as well, one meaning the node this one
+ * is a member of. A node that carries it lists no members itself.
+ */
+CTLV_PUT_U64(ctlv_schema_node_reenters, CTLV_T_SCHEMA_NODE_REENTERS, CTLV_SCHEMA_UINT)
+/* The required nodes one level in. */
+CTLV_RECORD_START(ctlv_schema_node_fields, CTLV_T_SCHEMA_NODE_FIELDS, CTLV_SCHEMA_RECORD)
+/* The optional nodes one level in. */
+CTLV_RECORD_START(ctlv_schema_node_optional_fields, CTLV_T_SCHEMA_NODE_OPTIONAL_FIELDS,
+		  CTLV_SCHEMA_RECORD)
+/* The root of its reply tree, absent when it has no reply. */
+CTLV_RECORD_START(ctlv_op_schema_get_reply, CTLV_T_OP_SCHEMA_GET_REPLY, CTLV_SCHEMA_RECORD)
+/* The rule the message broke. */
+CTLV_PUT_U64(ctlv_error_info_reason, CTLV_T_ERROR_INFO_REASON, CTLV_SCHEMA_ENUM)
+/* What went wrong, for a person to read. */
+CTLV_PUT_STRING(ctlv_error_info_message, CTLV_T_ERROR_INFO_MESSAGE, CTLV_SCHEMA_STRING)
+/*
+ * The offset of the offending TLV from the start of the message, or of its record when what is
+ * wrong is something the record lacks.
+ */
+CTLV_PUT_U64(ctlv_error_info_bad_tlv_offset, CTLV_T_ERROR_INFO_BAD_TLV_OFFSET, CTLV_SCHEMA_UINT)
+/* The offset of the record holding it, from the start of the message. */
+CTLV_PUT_U64(ctlv_error_info_record_offset, CTLV_T_ERROR_INFO_RECORD_OFFSET, CTLV_SCHEMA_UINT)
+/* The type of the required field that is absent. */
+CTLV_PUT_U64(ctlv_error_info_missing_type, CTLV_T_ERROR_INFO_MISSING_TYPE, CTLV_SCHEMA_UINT)
+/* The generation the query continuation carried. */
+CTLV_PUT_U64(ctlv_error_info_expected_generation, CTLV_T_ERROR_INFO_EXPECTED_GENERATION,
+	     CTLV_SCHEMA_UINT)
+/* The generation the query has now. */
+CTLV_PUT_U64(ctlv_error_info_current_generation, CTLV_T_ERROR_INFO_CURRENT_GENERATION,
+	     CTLV_SCHEMA_UINT)
+/* How long the output blob at bad-tlv-offset has to be for the op. */
+CTLV_PUT_U64(ctlv_error_info_required_length, CTLV_T_ERROR_INFO_REQUIRED_LENGTH, CTLV_SCHEMA_UINT)
+#endif /* _CTLV_GENERATED_METADATA_ONLY */
+
+#endif /* _LINUX_CTLV_GEN_H */
diff --git a/include/uapi/ctlv/ctlv_families_gen.h b/include/uapi/ctlv/ctlv_families_gen.h
new file mode 100644
index 000000000000..83f1719c89aa
--- /dev/null
+++ b/include/uapi/ctlv/ctlv_families_gen.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/*
+ * Generated from Documentation/ctlv/families.yaml by
+ * tools/ctlv/ctlv-regen.sh. Do not edit.
+ */
+/* CTLV-GEN uapi header */
+
+/* CTLV family numbers. */
+
+#ifndef _UAPI_CTLV_CTLV_FAMILIES_GEN_H
+#define _UAPI_CTLV_CTLV_FAMILIES_GEN_H
+
+enum _ctlv_family {
+	CTLV_FAMILY_ROOT = 0,
+};
+
+#endif /* _UAPI_CTLV_CTLV_FAMILIES_GEN_H */
diff --git a/include/uapi/ctlv/ctlv_gen.h b/include/uapi/ctlv/ctlv_gen.h
new file mode 100644
index 000000000000..1eff51c0dd58
--- /dev/null
+++ b/include/uapi/ctlv/ctlv_gen.h
@@ -0,0 +1,278 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/*
+ * Generated from Documentation/ctlv/specs/ctlv.yaml by
+ * tools/ctlv/ctlv-regen.sh. Do not edit.
+ */
+/* CTLV-GEN uapi header */
+
+/*
+ * Constants of the ctlv CTLV family. Types and op IDs are complete; the message format carrying
+ * them is in <ctlv/ctlv.h>.
+ */
+
+#ifndef _UAPI_CTLV_CTLV_GEN_H
+#define _UAPI_CTLV_CTLV_GEN_H
+
+#include <ctlv/ctlv.h>
+#include <ctlv/ctlv_families_gen.h>
+
+/* enum op-type */
+enum _ctlv_op_type {
+	/* Executed and acknowledged. */
+	CTLV_OP_TYPE_ACTION = 1,
+	/* Executed and answered, in as many fragments as the answer needs. */
+	CTLV_OP_TYPE_QUERY = 2,
+};
+
+/* enum op-availability */
+enum _ctlv_op_availability {
+	/* A device that publishes the op always answers it. */
+	CTLV_OP_AVAILABILITY_FIXED = 1,
+	/* A device may disable and enable the op at any time. */
+	CTLV_OP_AVAILABILITY_DYNAMIC = 2,
+};
+
+/* enum blob-type */
+enum _ctlv_blob_type {
+	/* Anonymous memory of the calling process, at address. */
+	CTLV_BLOB_TYPE_VA = 1,
+};
+
+/* enum blob-direction */
+enum _ctlv_blob_direction {
+	/* From the caller to the device, which only reads the blob. */
+	CTLV_BLOB_DIRECTION_INPUT = 1,
+	/* From the device to the caller. */
+	CTLV_BLOB_DIRECTION_OUTPUT = 2,
+	/* Both ways: the device reads the blob and writes it. */
+	CTLV_BLOB_DIRECTION_INOUT = 3,
+};
+
+/* enum validation-reason */
+enum _ctlv_validation_reason {
+	/*
+	 * The TLVs do not frame: the root is not one, a length runs past its record, or a TLV is a
+	 * record where its schema has a scalar or the reverse.
+	 */
+	CTLV_VALIDATION_REASON_MALFORMED_MESSAGE = 1,
+	/*
+	 * A TLV of a type its record does not place there, not marked IGNORE_IF_UNKNOWN or of a
+	 * type the schema places elsewhere.
+	 */
+	CTLV_VALIDATION_REASON_UNKNOWN_TYPE = 2,
+	/*
+	 * A header flag the message may not carry, or a flags payload with a bit its field does not
+	 * declare.
+	 */
+	CTLV_VALIDATION_REASON_UNKNOWN_FLAG = 3,
+	/* Records nested deeper than the core follows. */
+	CTLV_VALIDATION_REASON_RECORD_TOO_DEEP = 4,
+	/* A required field is absent, and missing-type says which. */
+	CTLV_VALIDATION_REASON_MISSING_FIELD = 5,
+	/* A field occurs more often than its schema allows. */
+	CTLV_VALIDATION_REASON_TOO_MANY_OCCURRENCES = 6,
+	/* An integer, an enum value or a bool outside what its field takes. */
+	CTLV_VALIDATION_REASON_VALUE_OUT_OF_RANGE = 7,
+	/* A payload of the wrong length for its kind, or outside its field's length bounds. */
+	CTLV_VALIDATION_REASON_BAD_LENGTH = 8,
+	/* A string payload that is not exactly one NUL-terminated string. */
+	CTLV_VALIDATION_REASON_BAD_STRING = 9,
+	/*
+	 * A blob descriptor its field does not take, or one whose memory could not be acquired or
+	 * is too short for what the op writes there.
+	 */
+	CTLV_VALIDATION_REASON_BAD_BLOB_DESCRIPTOR = 10,
+	/* A query continuation of a generation the query no longer has. */
+	CTLV_VALIDATION_REASON_STALE_GENERATION = 11,
+	/* The TLVs of one type are not contiguous in their record. */
+	CTLV_VALIDATION_REASON_NONCONTIGUOUS_TYPE = 12,
+};
+
+/* enum op-fd-access */
+enum _ctlv_op_fd_access {
+	/* Read access, which an observation fd has as well as a full-control one. */
+	CTLV_OP_FD_ACCESS_READ = 1,
+	/* Read-write access, which only a full-control fd has. */
+	CTLV_OP_FD_ACCESS_READ_WRITE = 2,
+};
+
+/* blob */
+/* What holds the bytes, which says which of the fields below are present. */
+#define CTLV_T_BLOB_TYPE \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00010000, 1)
+/* Where a va blob starts in the calling process. */
+#define CTLV_T_BLOB_ADDRESS \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00010000, 2)
+/* Reserved for a later fd-backed type. */
+#define CTLV_T_BLOB_FD \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00010000, 3)
+/* Reserved for a later fd-backed type. */
+#define CTLV_T_BLOB_OFFSET \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00010000, 4)
+/* The length of the blob in bytes, at most what its field takes. */
+#define CTLV_T_BLOB_LENGTH \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00010000, 5)
+
+/* error-info */
+/* The rule the message broke. */
+#define CTLV_T_ERROR_INFO_REASON \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00020000, 1)
+/* What went wrong, for a person to read. */
+#define CTLV_T_ERROR_INFO_MESSAGE \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00020000, 2)
+/*
+ * The offset of the offending TLV from the start of the message, or of its record when what is
+ * wrong is something the record lacks.
+ */
+#define CTLV_T_ERROR_INFO_BAD_TLV_OFFSET \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00020000, 3)
+/* The offset of the record holding it, from the start of the message. */
+#define CTLV_T_ERROR_INFO_RECORD_OFFSET \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00020000, 4)
+/* The type of the required field that is absent. */
+#define CTLV_T_ERROR_INFO_MISSING_TYPE \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00020000, 5)
+/* The generation the query continuation carried. */
+#define CTLV_T_ERROR_INFO_EXPECTED_GENERATION \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00020000, 6)
+/* The generation the query has now. */
+#define CTLV_T_ERROR_INFO_CURRENT_GENERATION \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00020000, 7)
+/* How long the output blob at bad-tlv-offset has to be for the op. */
+#define CTLV_T_ERROR_INFO_REQUIRED_LENGTH \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00020000, 8)
+
+/* schema-node */
+/* Zero in a message root node, as in the root TLV. */
+#define CTLV_T_SCHEMA_NODE_TYPE \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00030000, 1)
+/* enum ctlv_schema_kind. */
+#define CTLV_T_SCHEMA_NODE_KIND \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00030000, 2)
+/* Zero where the node may repeat as often as the message has room. */
+#define CTLV_T_SCHEMA_NODE_MAX_OCCURRENCES \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00030000, 3)
+/*
+ * The inclusive lower bound of an integer or enum payload, a raw 64-bit value read according to
+ * kind. An enum's values are numbered without gaps.
+ */
+#define CTLV_T_SCHEMA_NODE_MIN \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00030000, 4)
+/* The inclusive upper bound, read the same way. */
+#define CTLV_T_SCHEMA_NODE_MAX \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00030000, 5)
+/* The shortest payload of a string or binary field, a string's terminator excluded. */
+#define CTLV_T_SCHEMA_NODE_MIN_LENGTH \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00030000, 6)
+/* The longest payload, likewise. */
+#define CTLV_T_SCHEMA_NODE_MAX_LENGTH \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00030000, 7)
+/* The bits a flags payload may carry. */
+#define CTLV_T_SCHEMA_NODE_FLAGS_MASK \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00030000, 8)
+/* enum ctlv_unit, absent when the payload is dimensionless. */
+#define CTLV_T_SCHEMA_NODE_UNIT \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00030000, 9)
+/*
+ * The decimal exponent of the unit, a payload being value * 10^scale of it, present only with a
+ * unit.
+ */
+#define CTLV_T_SCHEMA_NODE_SCALE \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00030000, 10)
+/* Which way a blob field's bytes go. */
+#define CTLV_T_SCHEMA_NODE_BLOB_DIRECTION \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00030000, 11)
+/* Mask of BIT(enum ctlv_blob_type): the backings this node takes. */
+#define CTLV_T_SCHEMA_NODE_BLOB_BACKINGS \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00030000, 12)
+/* Maximum external payload length, unrelated to the inline message limit. */
+#define CTLV_T_SCHEMA_NODE_BLOB_MAX_LENGTH \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00030000, 13)
+/* The power of two a blob's address or offset is a multiple of. */
+#define CTLV_T_SCHEMA_NODE_BLOB_ALIGNMENT \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00030000, 14)
+/*
+ * Levels to climb to the node whose members are this one's as well, one meaning the node this one
+ * is a member of. A node that carries it lists no members itself.
+ */
+#define CTLV_T_SCHEMA_NODE_REENTERS \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00030000, 15)
+/* The required nodes one level in. */
+#define CTLV_T_SCHEMA_NODE_FIELDS \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00030000, 16)
+/* The optional nodes one level in. */
+#define CTLV_T_SCHEMA_NODE_OPTIONAL_FIELDS \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x00030000, 17)
+
+/* family-get reply */
+/* One entry per family of the chain. */
+#define CTLV_T_FAMILY_GET_FAMILIES \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0xc0010000, 1)
+
+/* family-get families */
+/* The family ID, which bits 63..48 of the family's types carry. */
+#define CTLV_T_FAMILY_GET_FAMILIES_ID \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0xc0011000, 1)
+/*
+ * The registry name, also what a uevent carries. Bounded here, this being the only place a message
+ * carries a family name.
+ */
+#define CTLV_T_FAMILY_GET_FAMILIES_NAME \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0xc0011000, 2)
+
+/* op-get reply */
+/* One entry per op the device publishes. */
+#define CTLV_T_OP_GET_OPS \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0xc0020000, 1)
+
+/* op-get ops */
+/* The op ID, which CTLV_IOC_OP_EXEC carries. */
+#define CTLV_T_OP_GET_OPS_ID \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0xc0021000, 1)
+/* Action or query. */
+#define CTLV_T_OP_GET_OPS_TYPE \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0xc0021000, 2)
+/* Whether the device may disable and enable the op. */
+#define CTLV_T_OP_GET_OPS_AVAILABILITY \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0xc0021000, 3)
+/* Whether the device has the op disabled right now. */
+#define CTLV_T_OP_GET_OPS_DISABLED \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0xc0021000, 4)
+/* The longest request composed from the schema. */
+#define CTLV_T_OP_GET_OPS_REQUEST_MAX_LEN \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0xc0021000, 5)
+/* The reply buffer an action needs, zero for one that answers nothing. */
+#define CTLV_T_OP_GET_OPS_ACTION_REPLY_MAX_LEN \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0xc0021000, 6)
+/* The shortest reply buffer a query takes. */
+#define CTLV_T_OP_GET_OPS_QUERY_REPLY_MIN_LEN \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0xc0021000, 7)
+/* The reply buffer length the family suggests for a query. */
+#define CTLV_T_OP_GET_OPS_QUERY_REPLY_SUGGESTED_LEN \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0xc0021000, 8)
+/* The access a file description needs to execute the op. */
+#define CTLV_T_OP_GET_OPS_FD_ACCESS \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0xc0021000, 9)
+/* The longest error information the op can return. */
+#define CTLV_T_OP_GET_OPS_ERROR_INFO_MAX_LEN \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0xc0021000, 10)
+
+/* op-schema-get request */
+/* The ID of the op to describe. */
+#define CTLV_T_OP_SCHEMA_GET_ID \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0x80030000, 1)
+
+/* op-schema-get reply */
+/* The root of the op's request tree, absent when it has no request. */
+#define CTLV_T_OP_SCHEMA_GET_REQUEST \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0xc0030000, 1)
+/* The root of its reply tree, absent when it has no reply. */
+#define CTLV_T_OP_SCHEMA_GET_REPLY \
+	CTLV_TYPE(CTLV_FAMILY_ROOT, 0xc0030000, 2)
+
+/* ops */
+#define CTLV_OP_FAMILY_GET CTLV_OP(CTLV_FAMILY_ROOT, 1)
+#define CTLV_OP_OP_GET CTLV_OP(CTLV_FAMILY_ROOT, 2)
+#define CTLV_OP_OP_SCHEMA_GET CTLV_OP(CTLV_FAMILY_ROOT, 3)
+
+#endif /* _UAPI_CTLV_CTLV_GEN_H */
diff --git a/lib/ctlv/ctlv_gen.c b/lib/ctlv/ctlv_gen.c
new file mode 100644
index 000000000000..78b322507711
--- /dev/null
+++ b/lib/ctlv/ctlv_gen.c
@@ -0,0 +1,161 @@
+// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+/*
+ * Generated from Documentation/ctlv/specs/ctlv.yaml by
+ * tools/ctlv/ctlv-regen.sh. Do not edit.
+ */
+/* CTLV-GEN kernel source */
+
+#define _CTLV_GENERATED_METADATA_ONLY
+#include <linux/array_size.h>
+#include <linux/build_bug.h>
+#include <linux/ctlv_family.h>
+#include <linux/export.h>
+#include <linux/limits.h>
+
+#include <uapi/ctlv/ctlv_gen.h>
+
+#include <linux/ctlv_gen.h>
+
+static const struct ctlv_node_schema family_get_request_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(0, 0, 0),
+};
+
+static const struct ctlv_node_schema family_get_reply_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(1, 1, 1),
+	CTLV_NODE_SCHEMA_RECORD(CTLV_T_FAMILY_GET_FAMILIES, CTLV_NODE_SCHEMA_UNLIMITED, 2, 2, 2),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_FAMILY_GET_FAMILIES_ID, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_STRING(CTLV_T_FAMILY_GET_FAMILIES_NAME, 1, 0, 63),
+};
+
+static const struct ctlv_node_schema op_get_request_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(0, 0, 0),
+};
+
+static const struct ctlv_node_schema op_get_reply_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(1, 1, 1),
+	CTLV_NODE_SCHEMA_RECORD(CTLV_T_OP_GET_OPS, CTLV_NODE_SCHEMA_UNLIMITED, 2, 10, 2),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_OP_GET_OPS_ID, 1, 1, U64_MAX),
+	CTLV_NODE_SCHEMA_ENUM(CTLV_T_OP_GET_OPS_TYPE, 1, 2),
+	CTLV_NODE_SCHEMA_ENUM(CTLV_T_OP_GET_OPS_AVAILABILITY, 1, 2),
+	CTLV_NODE_SCHEMA_BOOL(CTLV_T_OP_GET_OPS_DISABLED, 1),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_OP_GET_OPS_REQUEST_MAX_LEN, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_OP_GET_OPS_ACTION_REPLY_MAX_LEN, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_OP_GET_OPS_QUERY_REPLY_MIN_LEN, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_OP_GET_OPS_QUERY_REPLY_SUGGESTED_LEN, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_ENUM(CTLV_T_OP_GET_OPS_FD_ACCESS, 1, 2),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_OP_GET_OPS_ERROR_INFO_MAX_LEN, 1, 0, U64_MAX),
+};
+
+static const struct ctlv_node_schema op_schema_get_request_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(1, 1, 1),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_OP_SCHEMA_GET_ID, 1, 1, U64_MAX),
+};
+
+static const struct ctlv_node_schema op_schema_get_reply_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(1, 2, 0),
+	CTLV_NODE_SCHEMA_RECORD(CTLV_T_OP_SCHEMA_GET_REQUEST, 1, 3, 17, 3),
+	CTLV_NODE_SCHEMA_RECORD(CTLV_T_OP_SCHEMA_GET_REPLY, 1, 20, 17, 3),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_TYPE, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_KIND, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_MAX_OCCURRENCES, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_MIN, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_MAX, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_MIN_LENGTH, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_MAX_LENGTH, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_FLAGS_MASK, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_UNIT, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_SINT(CTLV_T_SCHEMA_NODE_SCALE, 1, S64_MIN, S64_MAX),
+	CTLV_NODE_SCHEMA_ENUM(CTLV_T_SCHEMA_NODE_BLOB_DIRECTION, 1, 3),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_BLOB_BACKINGS, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_BLOB_MAX_LENGTH, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_BLOB_ALIGNMENT, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_REENTERS, 1, 1, U64_MAX),
+	CTLV_NODE_SCHEMA_RECORD_REENTERS(CTLV_T_SCHEMA_NODE_FIELDS, CTLV_NODE_SCHEMA_UNLIMITED, 3,
+					 17, 3),
+	CTLV_NODE_SCHEMA_RECORD_REENTERS(CTLV_T_SCHEMA_NODE_OPTIONAL_FIELDS,
+					 CTLV_NODE_SCHEMA_UNLIMITED, 3, 17, 3),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_TYPE, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_KIND, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_MAX_OCCURRENCES, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_MIN, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_MAX, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_MIN_LENGTH, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_MAX_LENGTH, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_FLAGS_MASK, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_UNIT, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_SINT(CTLV_T_SCHEMA_NODE_SCALE, 1, S64_MIN, S64_MAX),
+	CTLV_NODE_SCHEMA_ENUM(CTLV_T_SCHEMA_NODE_BLOB_DIRECTION, 1, 3),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_BLOB_BACKINGS, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_BLOB_MAX_LENGTH, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_BLOB_ALIGNMENT, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_SCHEMA_NODE_REENTERS, 1, 1, U64_MAX),
+	CTLV_NODE_SCHEMA_RECORD_REENTERS(CTLV_T_SCHEMA_NODE_FIELDS, CTLV_NODE_SCHEMA_UNLIMITED, 20,
+					 17, 3),
+	CTLV_NODE_SCHEMA_RECORD_REENTERS(CTLV_T_SCHEMA_NODE_OPTIONAL_FIELDS,
+					 CTLV_NODE_SCHEMA_UNLIMITED, 20, 17, 3),
+};
+
+static const struct ctlv_node_schema error_info_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(1, 8, 0),
+	CTLV_NODE_SCHEMA_ENUM(CTLV_T_ERROR_INFO_REASON, 1, 12),
+	CTLV_NODE_SCHEMA_STRING(CTLV_T_ERROR_INFO_MESSAGE, 1, 0, 255),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_ERROR_INFO_BAD_TLV_OFFSET, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_ERROR_INFO_RECORD_OFFSET, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_ERROR_INFO_MISSING_TYPE, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_ERROR_INFO_EXPECTED_GENERATION, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_ERROR_INFO_CURRENT_GENERATION, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_T_ERROR_INFO_REQUIRED_LENGTH, 1, 0, U64_MAX),
+};
+
+const struct ctlv_schema_tree ctlv_error_info_schema = {
+	.node_schemas = error_info_node_schemas,
+	.node_schemas_count =
+		ARRAY_SIZE(error_info_node_schemas),
+};
+
+static_assert(CTLV_ERROR_INFO_MAX_LEN <= CTLV_MAX_ERROR_LEN);
+
+/* The ops this family declares, in declaration order. */
+const struct ctlv_op_schema ctlv_op_schemas[] = {
+	CTLV_OP_SCHEMA_QUERY(CTLV_OP_FAMILY_GET, CTLV_OP_FD_ACCESS_READ, CTLV_OP_AVAILABILITY_FIXED,
+			     16, 112, 65536, CTLV_SCHEMA_TREE(family_get_request),
+			     CTLV_SCHEMA_TREE(family_get_reply)),
+	CTLV_OP_SCHEMA_QUERY(CTLV_OP_OP_GET, CTLV_OP_FD_ACCESS_READ, CTLV_OP_AVAILABILITY_FIXED, 16,
+			     56, 65536, CTLV_SCHEMA_TREE(op_get_request),
+			     CTLV_SCHEMA_TREE(op_get_reply)),
+	CTLV_OP_SCHEMA_QUERY(CTLV_OP_OP_SCHEMA_GET, CTLV_OP_FD_ACCESS_READ,
+			     CTLV_OP_AVAILABILITY_FIXED, 40, 168, 65536,
+			     CTLV_SCHEMA_TREE(op_schema_get_request),
+			     CTLV_SCHEMA_TREE(op_schema_get_reply)),
+};
+
+/* The family ID is its position in the central registry. */
+const struct ctlv_family_schema ctlv_schema = {
+	.name = "ctlv",
+	.family_id = 0,
+	.ops = ctlv_op_schemas,
+	.ops_count = ARRAY_SIZE(ctlv_op_schemas),
+};
+
+/* Maximum uevent cost for this family chain. */
+static_assert(60 <= CTLV_UEVENT_MAX_LEN);
+static_assert(3 <= CTLV_UEVENT_MAX_VARS);
+
+/* Guards for generated maxima. */
+static_assert(65536 <= CTLV_MAX_INLINE_MESSAGE_LEN);
+static_assert(2 <= CTLV_MAX_DECLARED_RECORD_DEPTH);
+
+/* Local action and query bindings in declaration order. */
+static const struct ctlv_op ctlv_ops[] = {
+	CTLV_OP_QUERY(ctlv_family_get),
+	CTLV_OP_QUERY(ctlv_op_get),
+	CTLV_OP_QUERY(ctlv_op_schema_get),
+};
+
+/* Root-family descriptor used by the CTLV core. */
+const struct ctlv_family ctlv_family = {
+	.schema = &ctlv_schema,
+	.ops = ctlv_ops,
+	.ops_count = ARRAY_SIZE(ctlv_ops),
+};
+EXPORT_SYMBOL_NS_GPL(ctlv_family, "CTLV");
-- 
2.56.0

