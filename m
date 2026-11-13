Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585331;
	b=gbyl7xe7+CTbcanqtUmRxNq0W9lqLXZYdKnXoR/LEsZEZ+3JmXja/GPLHXupH29S44WA
	 nuiFT9Cliq5KCy15oA3921A4SM2pRP73xy6Yo5vY0/kng8r14nnhgd7ZTNncjj1GhgjEt
	 zfFGKGj8UCV+eeqqEWjQX0XOeYDyc3YMrTOOVuEcjDRMMwq9pC7dafAkI5aCqhS4l1Uel
	 iJ0kHzHj/hQaIrEtw670KZT8jrMDgzx7ycrGAMey7DBuw2r2Sx2WJ3ebHUG80ZDkJJFCn
	 DJbcJigMYc42cMN7r2DtojatwInsDAhxFQPCLy8oyvzyMoLJgc7wW4PhEx7fMGenysg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585331;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FECVH+xBG6o5KmuK23vk6BJ2ajkH9Wa0T0KONFTPFCI=;
	b=LgDKJXSDjJUYfnxfuWaPsRrn00Ppe/YeP1d9rm03fzdDh/KyHwtZb/Rtm/G4jFmwCWwo
	 C2Rv3jmTE+cR0S4Wo34AMgp8hgWj6kOnEEdO6OXTRc3JbD7a4zRcrdVIjHP7h9HFGU+rV
	 zTFVMpWNh79uLMFCZq3yHmoZrIfrsanDbKKLUJlbseM7c+QyLlni6+U/SrCIMFaMb1MXn
	 axO2AlmJLfCga94rkQ+GIjLgdFzQffYNbcNpOLJ96vPDPEJ3BEj+5oTjW/J/SLTjkCnwD
	 vQASEJzUzKn9ielCAmCU9OV9qqv0FtnHw5UgRRhF4dYaY8vnp4srYq+lp2WXPsE0Q8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=rfCx1Rgc;
	arc=none smtp.remote-ip=209.85.218.49
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DC2606A334
	for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 15:55:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8DC2606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=rfCx1Rgc
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c468bd799ecso217823466b.1
        for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 07:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1794585327; x=1795190127; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FECVH+xBG6o5KmuK23vk6BJ2ajkH9Wa0T0KONFTPFCI=;
        b=rfCx1RgcBaA+X9mSENddkMygdixktgyIWJMZgpaiPW5zKaNh7OG8zdscAKCi78ytqH
         zM/Gce9yfsPoUGd3SfpuqZbdz+pAdZA+gefDCLFTpc3KhiP96BFkQtZ69oOitlShgeW7
         LyY1/qNE8ayRzEhNAcnRTIyDXwagBmFgi7f2UEAFOgB3/h9Yol9kJPGBpPY5Rslf/pSt
         9gcSw3IKik8iS32vR08VbZesvfalGRE8GJM4+CtDyXwcphvDs+SGVlhvMx2ki/rgroPC
         8mTVW4aXXIaMxMZGG0UwHT1VvIF8wgT9EDgHuCSXnievqzAU3NetgzxmkSJKNUjWrmm0
         KEcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794585327; x=1795190127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FECVH+xBG6o5KmuK23vk6BJ2ajkH9Wa0T0KONFTPFCI=;
        b=SzflSfYaoMjsibFkReR7qIPHUL20yQk8AnRgyLO8oTbFB/4rP1ue4XWBOQhFtbqlD3
         kJg9s6rhdpPbhYtTywhtsbBMOCU2ojs2PcbID6KGR9aZSCtA3ytYBne0Bhm4l+Bj9MA2
         5x6R9uA19oZRIAuHgnVYngag2mAHpMpTn4fvW5HUTBhvhxRmo7BlX6Z3bM9/p0fGlw29
         uz07Z+aNkaUB67DIjygcomJ/77d8FQOwpfQvo1mXQbB41932OR+J6wYHhs7fOfg22EAk
         mp8KWFF99UY9BvY3l9LLv1XEEz4VzME0twCDZnnfT55tDLUF/9RI7kbyrxQCriEdh7wW
         j4MA==
X-Forwarded-Encrypted: i=1; AL+hErFG8KIJZ/1Nz4q1K9mDuYeWx6YKtHmWKGfsfvdreOa8pPqwPSPiJ84ybeq/bKZhJv35+JbjP31f0KY=@vger.kernel.org
X-Gm-Message-State: APuU4Z9GPkqeWcfeb65E/VPyv0feMM2cHpvbHJ/4LXW6Trp9q1GNTe27
	CoRJ2dnTtcwww4avjO4IwwQJ8xVsHiXb696HV9Z+MnrpIsP8jHMQojeWfTpECmJg38I=
X-Gm-Gg: AYBFou2JIhklVCvXwI4889FnBGGNXpTtAlV0/f+PqscGpzh7B1IfDsFabnh8WoQoyOn
	OmYACaV+5kk7u/u7uDx6TkOtt7enWHs6GKEDPnh4wSm+RnglWPvV8Dm9Pl11mEhTbeFYAld6eLC
	fS6+Z7xtUanpwR4e2PxBflw6M5x6fVpw8WiNVCWSOroYXgp2n2JzMWciQe8kTtNVQffDZ0wEnAf
	mPbrXs72UNpp7tV5x2WuQdaX6e8JUTczRKS4j1dI52leetkUN1Ssxtyb7WBiSCVV2MaS9NwnYKa
	0BvTV9MxXqpl8BsNzpj0SlcSOr2H85tFDfxZxXkHIk+025ggWAI8TdXbmLVWZek5b7Wl94u1rH5
	zX4tVceVomoQBhSi72fE2i908OgxTED9GjahK0yBOj8l12HOAiQINC77fl4IJaCdSbdCr4PnZcC
	43IJ2wmh83avBIC1WxKmdd8YQtX9mzQzHwP2TUKMIIuVySb3rpngk3t79ylUizOsklWE1WXNQ7A
	F1Ppii4Bef5oTxUHzmmXOdXgE2YZg4We5DETHEuEnMkJ/uDidVribvawlZjCB51wFd9LRaTW9Ht
	IjsDlKdBuOaRX9G21qAx/RvLfYB8Gw2jDPL3aaKD
X-Received: by 2002:a17:907:3f23:b0:c4d:22e2:1a2b with SMTP id a640c23a62f3a-c509614f546mr255052866b.1.1794585325168;
        Fri, 13 Nov 2026 07:55:25 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b72868sm112177366b.65.2026.11.13.07.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 07:55:23 -0800 (PST)
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
Subject: [PATCH RFC v2 01/15] ctlv: Add the schema language and generator
Date: Fri, 13 Nov 2026 16:55:00 +0100
Message-ID: <20261113155515.2510194-2-jiri@resnulli.us>
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

Define the YAML schema and append-only family registry. Add ctlvgen to
validate specifications and emit kernel and UAPI outputs.

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- dropped the family priv and its lifecycle hooks, handing callbacks
  the CTLV instance
- fixed the ABI check to accept max-occurrences widened to unlimited
- made a --mode and file kind pair with no generator a usage error
- stated the attr form rules in the meta-schema
- computed each op's error information length
- generated no reply lengths into user headers
- checked the limits against <linux/ctlv_family.h>
- lowered the inline message limit to 64 KiB
- lowered the record depth limit to 8
- stopped reserving the callback typedef names
- dropped the event op type
- renamed stubs to extension points
- let an enum take its values from a C header
- made abi-check report a changed attr kind, not fail on its bounds
- left an optional blob below the root out of a reply
- wrote each op's request and reply as a tree of fields, naming a
  record only where it is reused
- derived every type from where its field sits, so a spec carries no
  numbers and the ABI snapshot only checks them
- named the spec in every generated file, and gave each field and op
  one constant
- said TLV, type, record and field instead of attr
- said record instead of nest, the root being one
- said node, field or placed record instead of placement
- numbered every enum member and flag bit in the generated headers
- generated the UAPI headers into include/uapi/ctlv/
- type-checked ctlvgen with mypy --strict in make lint
- required a comment on every spec item, each enum member and flag
- printed each enum member's comment in the UAPI headers
- put each field's doc above its generated helpers
- folded abi-update into regen, refusing a break of the committed ABI
  unless ABI_BREAK=1, and validate, abi-check and check-regen into all
- added enum extension points, whose values a descendant family gives
- said message instead of wire
- let a count name an enum, one entry per value
- let an integer in bytes take K, M and G
- kept a hyphenated name whole when wrapping a generated comment
---
 Documentation/ctlv/ctlv-registry-schema.yaml  |   38 +
 Documentation/ctlv/ctlv-schema.yaml           |  227 +++
 .../ctlv/generated-files-schema.yaml          |   64 +
 MAINTAINERS                                   |    7 +
 tools/ctlv/Makefile                           |   39 +
 tools/ctlv/ctlv-regen.sh                      |   64 +
 tools/ctlv/ctlvgen/__init__.py                |    1 +
 tools/ctlv/ctlvgen/cli.py                     |  137 ++
 tools/ctlv/ctlvgen/lib/__init__.py            |    1 +
 tools/ctlv/ctlvgen/lib/cenum.py               |  178 +++
 tools/ctlv/ctlvgen/lib/cgen.py                |  763 +++++++++++
 tools/ctlv/ctlvgen/lib/compat.py              |  877 ++++++++++++
 tools/ctlv/ctlvgen/lib/errors.py              |   16 +
 tools/ctlv/ctlvgen/lib/gen_family.py          |  285 ++++
 tools/ctlv/ctlvgen/lib/gen_kernel.py          |  576 ++++++++
 tools/ctlv/ctlvgen/lib/gen_uapi.py            |  182 +++
 tools/ctlv/ctlvgen/lib/outputs.py             |  355 +++++
 tools/ctlv/ctlvgen/lib/semantics.py           | 1219 +++++++++++++++++
 tools/ctlv/ctlvgen/lib/sizes.py               |  239 ++++
 tools/ctlv/ctlvgen/lib/spec.py                |  813 +++++++++++
 tools/ctlv/ctlvgen/lib/tree.py                |  158 +++
 tools/ctlv/ctlvgen/lib/yamlload.py            |  138 ++
 tools/ctlv/pyproject.toml                     |   30 +
 tools/ctlv/requirements.txt                   |    2 +
 24 files changed, 6409 insertions(+)
 create mode 100644 Documentation/ctlv/ctlv-registry-schema.yaml
 create mode 100644 Documentation/ctlv/ctlv-schema.yaml
 create mode 100644 Documentation/ctlv/generated-files-schema.yaml
 create mode 100644 tools/ctlv/Makefile
 create mode 100755 tools/ctlv/ctlv-regen.sh
 create mode 100644 tools/ctlv/ctlvgen/__init__.py
 create mode 100755 tools/ctlv/ctlvgen/cli.py
 create mode 100644 tools/ctlv/ctlvgen/lib/__init__.py
 create mode 100644 tools/ctlv/ctlvgen/lib/cenum.py
 create mode 100644 tools/ctlv/ctlvgen/lib/cgen.py
 create mode 100644 tools/ctlv/ctlvgen/lib/compat.py
 create mode 100644 tools/ctlv/ctlvgen/lib/errors.py
 create mode 100644 tools/ctlv/ctlvgen/lib/gen_family.py
 create mode 100644 tools/ctlv/ctlvgen/lib/gen_kernel.py
 create mode 100644 tools/ctlv/ctlvgen/lib/gen_uapi.py
 create mode 100644 tools/ctlv/ctlvgen/lib/outputs.py
 create mode 100644 tools/ctlv/ctlvgen/lib/semantics.py
 create mode 100644 tools/ctlv/ctlvgen/lib/sizes.py
 create mode 100644 tools/ctlv/ctlvgen/lib/spec.py
 create mode 100644 tools/ctlv/ctlvgen/lib/tree.py
 create mode 100644 tools/ctlv/ctlvgen/lib/yamlload.py
 create mode 100644 tools/ctlv/pyproject.toml
 create mode 100644 tools/ctlv/requirements.txt

diff --git a/Documentation/ctlv/ctlv-registry-schema.yaml b/Documentation/ctlv/ctlv-registry-schema.yaml
new file mode 100644
index 000000000000..d9a2840fc230
--- /dev/null
+++ b/Documentation/ctlv/ctlv-registry-schema.yaml
@@ -0,0 +1,38 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+%YAML 1.2
+---
+$id: http://kernel.org/schemas/ctlv/ctlv-registry-schema.yaml#
+$schema: https://json-schema.org/draft-07/schema
+
+$defs:
+  name:
+    type: string
+    maxLength: 63
+    pattern: ^[a-z0-9]+(-[a-z0-9]+)*$
+
+title: CTLV family registry
+description: Append-only list of CTLV family names, indexed by family ID
+type: object
+required: [ families ]
+additionalProperties: false
+properties:
+  families:
+    description: |
+      Family names in family ID order: the entry at index N has family ID N.
+      The root family owns ID 0 and so is the first entry, and cannot be
+      deprecated. Every other entry comes after the entry of the family it
+      inherits. A deprecated entry keeps its ID reserved.
+    type: array
+    minItems: 1
+    maxItems: 65536
+    items:
+      oneOf:
+        - $ref: '#/$defs/name'
+        - type: object
+          required: [ name, deprecated ]
+          additionalProperties: false
+          properties:
+            name:
+              $ref: '#/$defs/name'
+            deprecated:
+              const: true
diff --git a/Documentation/ctlv/ctlv-schema.yaml b/Documentation/ctlv/ctlv-schema.yaml
new file mode 100644
index 000000000000..c61d8bffc0c7
--- /dev/null
+++ b/Documentation/ctlv/ctlv-schema.yaml
@@ -0,0 +1,227 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+%YAML 1.2
+---
+$id: http://kernel.org/schemas/ctlv/ctlv-schema.yaml#
+$schema: https://json-schema.org/draft-07/schema
+
+# The syntax gate for a CTLV family specification: permitted keys and their
+# shapes. A field's schema kind and its bounds are parsed, and anything needing
+# more than one declaration at a time is checked, by tools/ctlv/ctlvgen/lib/.
+
+$defs:
+  name:
+    description: Kebab-case identifier.
+    type: string
+    pattern: ^[a-z0-9]+(-[a-z0-9]+)*$
+
+  c-name:
+    description: C identifier.
+    type: string
+    pattern: ^[A-Za-z_][A-Za-z0-9_]*$
+
+  family-name:
+    description: Name carried by family discovery.
+    allOf:
+      - $ref: '#/$defs/name'
+      - maxLength: 63
+
+  field-key:
+    description:
+      A field's name, then [N] for 1 to N occurrences, [enum] for one per
+      value of an enum, or [] for any number, which only a query reply can
+      hold, then ? when it may be absent.
+    type: string
+    pattern: ^[a-z0-9]+(-[a-z0-9]+)*(\[([0-9]*|[a-z0-9]+(-[a-z0-9]+)*)\])?\??$
+
+  include:
+    description:
+      A named record whose fields are spliced in with their IDs, all of them
+      optional when the name ends in ?.
+    type: string
+    pattern: ^[a-z0-9]+(-[a-z0-9]+)*\??$
+
+  field:
+    description:
+      A schema kind with its bounds, an enum or flags by name, "record X" for
+      a field holding named record X, "extension X" for a record a descendant
+      family fills, bare "record" for a field of records:, or an indented
+      map for an unnamed record.
+    oneOf:
+      - type: string
+        minLength: 1
+      - $ref: '#/$defs/record'
+
+  record:
+    description: Fields in the order they are numbered.
+    type: object
+    minProperties: 1
+    propertyNames:
+      anyOf:
+        - $ref: '#/$defs/field-key'
+        - const: $include
+    properties:
+      $include:
+        oneOf:
+          - $ref: '#/$defs/include'
+          - type: array
+            minItems: 1
+            items:
+              $ref: '#/$defs/include'
+    additionalProperties:
+      $ref: '#/$defs/field'
+
+  message:
+    description:
+      Omitted, empty or {} for no fields, "record X" to use named record X,
+      or the record written in place.
+    oneOf:
+      - type: 'null'
+      - type: object
+        maxProperties: 0
+      - type: string
+        pattern: ^record [a-z0-9]+(-[a-z0-9]+)*$
+      - $ref: '#/$defs/record'
+
+  value-list:
+    type: array
+    minItems: 1
+    items:
+      $ref: '#/$defs/name'
+
+  enum:
+    description:
+      Value names in declaration order, numbered from 1 because 0 is
+      reserved, and append-only. A $header enum is enum $enum of
+      include/uapi/<$header>, whose constants are its values, under their
+      own names and numbers; with $end, only those before that constant.
+      "extension" is an enum extension point, whose values one descendant
+      family gives.
+    oneOf:
+      - $ref: '#/$defs/value-list'
+      - type: object
+        required: [ $header, $enum ]
+        additionalProperties: false
+        properties:
+          $header:
+            type: string
+            pattern: ^[a-z0-9_-]+(/[a-z0-9_-]+)*\.h$
+          $enum:
+            $ref: '#/$defs/c-name'
+          $end:
+            $ref: '#/$defs/c-name'
+      - const: extension
+
+  flags:
+    description: Bit names, numbered from bit 0 and append-only.
+    allOf:
+      - $ref: '#/$defs/value-list'
+      - maxItems: 64
+
+  op:
+    type: object
+    required: [ type ]
+    additionalProperties: false
+    properties:
+      type:
+        description:
+          action is invoked once and never fragments, and query may fragment
+          its reply.
+        enum: [ action, query ]
+      fd-access:
+        description:
+          Authority needed to execute an action or query. read permits an
+          observation fd; read-write, the default, requires a full-control fd.
+        enum: [ read, read-write ]
+      availability:
+        description: >
+          Whether a family may enable and disable this op per device. fixed,
+          the default, is always enabled. dynamic is a permission rather than
+          a state: every device starts with the op enabled.
+        enum: [ fixed, dynamic ]
+      optional:
+        description:
+          Whether family initialization must opt in before publication for
+          this op to exist on the device. False by default. An op not opted
+          into is absent from introspection.
+        type: boolean
+      pre-post:
+        description: >
+          Whether this op gets a generated pre/post hook pair of its own,
+          which its declaring family implements. It runs inside the pair of
+          the device family, or the core family for a core op.
+          False by default. Kernel implementation metadata: it reaches
+          neither UAPI nor op-schema introspection.
+        type: boolean
+      request:
+        description: An op's request.
+        $ref: '#/$defs/message'
+      reply:
+        description:
+          Required on a query. Omitted on an action means ACK-only.
+        $ref: '#/$defs/message'
+      suggested-reply-length:
+        description:
+          Query only, in bytes. An omitted value is 64K raised to the
+          computed minimum. A declared value must be between that minimum
+          and the kernel's inline message limit.
+        oneOf:
+          - type: integer
+            minimum: 1
+          - type: string
+            pattern: ^[0-9]+[KMG]$
+
+title: CTLV family
+description: Specification of one CTLV family schema
+type: object
+required: [ family ]
+additionalProperties: false
+properties:
+  family:
+    description:
+      Registered family name. It carries no numeric ID; the ID comes from
+      the position in Documentation/ctlv/families.yaml.
+    $ref: '#/$defs/family-name'
+  inherits:
+    description:
+      Name of the single direct parent family, which every family but the
+      root one names. The complete parent schema is inherited and its
+      definitions keep the parent's IDs. The name above must be this name,
+      one dash, and a local suffix.
+    $ref: '#/$defs/family-name'
+  enums:
+    description:
+      A family that inherits may also fill an inherited enum extension point
+      here, by declaring an enum of the same name with its values.
+    type: object
+    minProperties: 1
+    propertyNames:
+      $ref: '#/$defs/name'
+    additionalProperties:
+      $ref: '#/$defs/enum'
+  flags:
+    type: object
+    minProperties: 1
+    propertyNames:
+      $ref: '#/$defs/name'
+    additionalProperties:
+      $ref: '#/$defs/flags'
+  records:
+    description:
+      Named records, which an op's message, "record X" or $include uses, and
+      fields of records:, written with their schema kind, which bare "record"
+      places. A family that inherits may also fill an inherited extension
+      point here, by declaring a record of the same name.
+    type: object
+    minProperties: 1
+    propertyNames:
+      $ref: '#/$defs/field-key'
+    additionalProperties:
+      $ref: '#/$defs/field'
+  ops:
+    description: Numbered from 1 in the order listed, and append-only.
+    type: object
+    minProperties: 1
+    propertyNames:
+      $ref: '#/$defs/name'
+    additionalProperties:
+      $ref: '#/$defs/op'
diff --git a/Documentation/ctlv/generated-files-schema.yaml b/Documentation/ctlv/generated-files-schema.yaml
new file mode 100644
index 000000000000..d3529ce6e8e7
--- /dev/null
+++ b/Documentation/ctlv/generated-files-schema.yaml
@@ -0,0 +1,64 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+%YAML 1.2
+---
+$schema: https://json-schema.org/draft-07/schema
+
+$defs:
+  path:
+    type: string
+    minLength: 1
+    pattern: ^[^/].*$
+
+  outputs:
+    type: object
+    minProperties: 1
+    additionalProperties: false
+    properties:
+      uapi-header:
+        $ref: '#/$defs/path'
+      kernel-header:
+        $ref: '#/$defs/path'
+      kernel-source:
+        $ref: '#/$defs/path'
+
+  registry:
+    type: object
+    required: [ source, outputs ]
+    additionalProperties: false
+    properties:
+      source:
+        $ref: '#/$defs/path'
+      outputs:
+        type: object
+        required: [ uapi-header ]
+        additionalProperties: false
+        properties:
+          uapi-header:
+            $ref: '#/$defs/path'
+
+  family:
+    type: object
+    required: [ name, source, outputs ]
+    additionalProperties: false
+    properties:
+      name:
+        type: string
+      source:
+        $ref: '#/$defs/path'
+      outputs:
+        $ref: '#/$defs/outputs'
+
+title: CTLV generated-file manifest
+type: object
+required: [ version, registry, families ]
+additionalProperties: false
+properties:
+  version:
+    const: 1
+  registry:
+    $ref: '#/$defs/registry'
+  families:
+    type: array
+    minItems: 1
+    items:
+      $ref: '#/$defs/family'
diff --git a/MAINTAINERS b/MAINTAINERS
index 93abbb315065..5c8e7ad9b599 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7183,6 +7183,13 @@ M:	Jaya Kumar <jayakumar.alsa@gmail.com>
 S:	Maintained
 F:	sound/pci/cs5535audio/
 
+CTLV SUBSYSTEM
+M:	Jiri Pirko <jiri@resnulli.us>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	Documentation/ctlv/
+F:	tools/ctlv/
+
 CTU CAN FD DRIVER
 M:	Pavel Pisa <pisa@cmp.felk.cvut.cz>
 M:	Ondrej Ille <ondrej.ille@gmail.com>
diff --git a/tools/ctlv/Makefile b/tools/ctlv/Makefile
new file mode 100644
index 000000000000..bdec011595aa
--- /dev/null
+++ b/tools/ctlv/Makefile
@@ -0,0 +1,39 @@
+# SPDX-License-Identifier: GPL-2.0
+
+KDIR = ../..
+DOCDIR = $(KDIR)/Documentation/ctlv
+
+# Writes nothing. Fails on an invalid specification, and on any generated file
+# or ABI snapshot that regen would change.
+all:
+	@./ctlv-regen.sh -c
+
+# Rewrites every generated file and ABI snapshot, and names each one it writes.
+# A specification change that breaks the committed ABI is refused unless
+# ABI_BREAK=1 says it is meant.
+regen:
+	@./ctlv-regen.sh $(if $(filter 1,$(ABI_BREAK)),-b)
+
+# Style and type checks, needing yamllint, pycodestyle, pyflakes, and mypy
+# with types-PyYAML and types-jsonschema, which the tool itself does not use.
+#
+# A flow sequence is written "[ one, two ]" here, as in the tree's other
+# meta-schemas, which stock yamllint rejects; the same relaxation is in
+# Documentation/devicetree/bindings/.yamllint.
+YAMLLINT_CONF = {extends: default, rules: {brackets: {max-spaces-inside: 1}}}
+
+PYSRC = ctlvgen
+
+lint:
+	yamllint -d "$(YAMLLINT_CONF)" $(DOCDIR)
+	python3 -m pycodestyle $(PYSRC)
+	python3 -m pyflakes $(PYSRC)
+	python3 -m mypy $(PYSRC)
+
+clean:
+	rm -rf ctlvgen/__pycache__
+	rm -rf ctlvgen/lib/__pycache__
+	rm -rf ctlvgen.egg-info
+	rm -rf build
+
+.PHONY: all regen lint clean
diff --git a/tools/ctlv/ctlv-regen.sh b/tools/ctlv/ctlv-regen.sh
new file mode 100755
index 000000000000..1fdf5f49a8db
--- /dev/null
+++ b/tools/ctlv/ctlv-regen.sh
@@ -0,0 +1,64 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+#
+# Reconcile the checked-in files against the independent output manifests,
+# and the ABI snapshots against the specifications.
+#
+#   -b  write even a change that breaks the committed ABI
+#   -f  accepted for compatibility; reconciliation always renders everything
+#   -c  do not write anything, fail if any output differs from what the
+#       generator produces now
+#   -p  search the given directory instead of the kernel tree
+
+TOOL=$(dirname "$(realpath "$0")")/ctlvgen/cli.py
+abi_break=
+check=
+search=
+
+while getopts ':bfcp:' option; do
+	case "$option" in
+	b)
+		abi_break=yes
+		;;
+	f)
+		;;
+	c)
+		check=yes
+		;;
+	p)
+		if [ -z "$OPTARG" ]; then
+			echo "Option -p needs a nonempty directory" >&2
+			exit 1
+		fi
+		search=$OPTARG
+		;;
+	:)
+		echo "Option -$OPTARG needs an argument" >&2
+		exit 1
+		;;
+	?)
+		echo "Unrecognized option '-$OPTARG'" >&2
+		exit 1
+		;;
+	esac
+done
+shift $((OPTIND - 1))
+if [ "$#" -ne 0 ]; then
+	echo "Unexpected argument '$1'" >&2
+	exit 1
+fi
+
+KDIR=$(realpath "$(dirname "$0")/../..")
+args=(--spec "$KDIR/Documentation/ctlv/specs/ctlv.yaml")
+if [ -n "$search" ]; then
+	args+=(--output-root "$search")
+fi
+if [ -n "$check" ]; then
+	args+=(--outputs-check)
+else
+	args+=(--outputs-update)
+fi
+if [ -n "$abi_break" ]; then
+	args+=(--abi-break)
+fi
+exec "$TOOL" "${args[@]}"
diff --git a/tools/ctlv/ctlvgen/__init__.py b/tools/ctlv/ctlvgen/__init__.py
new file mode 100644
index 000000000000..f84069cb2c3d
--- /dev/null
+++ b/tools/ctlv/ctlvgen/__init__.py
@@ -0,0 +1 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
diff --git a/tools/ctlv/ctlvgen/cli.py b/tools/ctlv/ctlvgen/cli.py
new file mode 100755
index 000000000000..78e09cfd620e
--- /dev/null
+++ b/tools/ctlv/ctlvgen/cli.py
@@ -0,0 +1,137 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+"""Command line front end of the CTLV schema tool."""
+
+from __future__ import annotations
+
+import argparse
+import pathlib
+import sys
+from collections.abc import Callable
+
+# So that this file works both as a module of the ctlvgen package and as the
+# script the Makefile and ctlv-regen.sh run. The imports below have to follow.
+sys.path.append(pathlib.Path(__file__).resolve().parents[1].as_posix())
+
+from ctlvgen.lib import cgen  # noqa: E402
+from ctlvgen.lib import gen_kernel  # noqa: E402
+from ctlvgen.lib import gen_uapi  # noqa: E402
+from ctlvgen.lib import semantics  # noqa: E402
+from ctlvgen.lib import spec  # noqa: E402
+from ctlvgen.lib import tree  # noqa: E402
+from ctlvgen.lib.errors import CtlvError  # noqa: E402
+
+
+# What each --mode and file generates.
+GENERATORS: dict[tuple[str, str], Callable[..., str]] = {
+    ('uapi', 'header'): gen_uapi.render,
+    ('kernel', 'header'): gen_kernel.render_header,
+    ('kernel', 'source'): gen_kernel.render_source,
+}
+
+
+def main() -> int:
+    parser = argparse.ArgumentParser(description='CTLV schema tool')
+    parser.add_argument('--spec', type=str, required=True,
+                        help='path to a CTLV family specification')
+    parser.add_argument('--schema', type=str,
+                        help='path to the meta-schema, derived from --spec '
+                             'when not given')
+    parser.add_argument('--registry', type=str,
+                        help='path to the family registry, derived from '
+                             '--spec when not given')
+    action = parser.add_mutually_exclusive_group(required=True)
+    action.add_argument('--validate', action='store_true',
+                        help='validate the specification and exit')
+    action.add_argument('--outputs-check', action='store_true',
+                        help='check every file in the output manifests and '
+                             'every ABI snapshot')
+    action.add_argument('--outputs-update', action='store_true',
+                        help='regenerate every file in the output manifests '
+                             'and every ABI snapshot')
+    action.add_argument('--mode',
+                        choices=('uapi', 'kernel'),
+                        help='generate the files of this mode')
+    parser.add_argument('--schema-only', action='store_true',
+                        help='omit the family API from kernel output')
+    files = parser.add_mutually_exclusive_group()
+    files.add_argument('--header', action='store_true',
+                       help='generate the header of --mode')
+    files.add_argument('--source', action='store_true',
+                       help='generate the source of --mode')
+    parser.add_argument('-o', '--output', type=str,
+                        help='write to this file instead of standard output')
+    parser.add_argument('--cmp-out', action='store_true',
+                        help='leave the output file alone when its contents '
+                             'would not change')
+    parser.add_argument('--output-root', type=str,
+                        help='alternate destination root for generated files')
+    parser.add_argument('--abi-break', action='store_true',
+                        help='let --outputs-update break the committed ABI')
+    args = parser.parse_args()
+
+    file = next((name for name in ('header', 'source')
+                 if getattr(args, name)), None)
+    if args.mode and not file:
+        parser.error('--mode needs --header or --source')
+    if file and not args.mode:
+        parser.error('--header and --source need --mode')
+    if args.mode and (args.mode, file) not in GENERATORS:
+        parser.error(f'--mode {args.mode} cannot generate --{file}')
+    if args.schema_only and args.mode != 'kernel':
+        parser.error('--schema-only needs --mode kernel')
+    output_action = args.outputs_check or args.outputs_update
+    if args.output is not None and not args.mode:
+        parser.error('-o/--output needs --mode')
+    if args.cmp_out and (not args.mode or args.output is None):
+        parser.error('--cmp-out needs --mode and --output')
+    if args.output_root is not None:
+        if not output_action:
+            parser.error('--output-root needs an outputs action')
+        if not args.output_root:
+            parser.error('--output-root cannot be empty')
+    if args.abi_break and not args.outputs_update:
+        parser.error('--abi-break needs --outputs-update')
+
+    paths = spec.Paths(args.spec, schema=args.schema, registry=args.registry)
+    try:
+        if args.outputs_check:
+            tree.check(paths, args.output_root)
+            return 0
+        elif args.outputs_update:
+            for item in tree.update(paths, args.output_root, args.abi_break):
+                print(f'ctlvgen: {item}', file=sys.stderr)
+            return 0
+        family = semantics.load(paths)
+        if args.validate:
+            cgen.symbols(family)
+        else:
+            assert file is not None
+            _generate(args, file, family)
+    except CtlvError as exc:
+        print(f'ctlvgen: {exc}', file=sys.stderr)
+        return 1
+    return 0
+
+
+def _generate(args: argparse.Namespace, file: str,
+              family: semantics.Family) -> None:
+    render = GENERATORS[(args.mode, file)]
+    if args.mode == 'kernel':
+        text = render(family, family_api=not args.schema_only)
+    else:
+        text = render(family)
+    if args.output is None:
+        sys.stdout.write(text)
+        return
+    path = pathlib.Path(args.output)
+    # Leaving an unchanged file untouched keeps its timestamp, which is what
+    # ctlv-regen.sh compares against the specification.
+    if args.cmp_out and path.exists() and \
+            path.read_text(encoding='utf-8') == text:
+        return
+    path.write_text(text, encoding='utf-8')
+
+
+if __name__ == '__main__':
+    sys.exit(main())
diff --git a/tools/ctlv/ctlvgen/lib/__init__.py b/tools/ctlv/ctlvgen/lib/__init__.py
new file mode 100644
index 000000000000..f84069cb2c3d
--- /dev/null
+++ b/tools/ctlv/ctlvgen/lib/__init__.py
@@ -0,0 +1 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
diff --git a/tools/ctlv/ctlvgen/lib/cenum.py b/tools/ctlv/ctlvgen/lib/cenum.py
new file mode 100644
index 000000000000..0b3b67d335f4
--- /dev/null
+++ b/tools/ctlv/ctlvgen/lib/cenum.py
@@ -0,0 +1,178 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+"""The constants of an enum in a uapi header.
+
+Only what a uapi enum needs is understood: integer literals, the enum's
+earlier constants, parentheses and integer operators. Anything else, a macro
+included, is refused rather than guessed at.
+"""
+
+from __future__ import annotations
+
+import pathlib
+import re
+from typing import NoReturn
+
+from .errors import CtlvError
+
+_COMMENT = re.compile(r'/\*.*?\*/|//[^\n]*', re.S)
+_TOKEN = re.compile(r'\s*(?:(?P<number>0[xX][0-9a-fA-F]+|[0-9]+)[uUlL]*|'
+                    r'(?P<name>[A-Za-z_]\w*)|(?P<op><<|>>|[-+*/%&|^~()]))')
+_IDENT = re.compile(r'[A-Za-z_]\w*')
+
+# The binary operators by C precedence, loosest first.
+_BINARY: tuple[tuple[str, ...], ...] = (
+    ('|',), ('^',), ('&',), ('<<', '>>'), ('+', '-'), ('*', '/', '%'))
+
+
+def read(where: str, include: pathlib.Path, header: str, tag: str,
+         end: str | None) -> tuple[tuple[str, int], ...]:
+    """Return enum tag of include/header, as constants before end."""
+    try:
+        text = (include / header).read_text(encoding='utf-8')
+    except OSError:
+        raise CtlvError(where, f'<{header}> is not a uapi header') from None
+    return parse(where, text, f'<{header}>', tag, end)
+
+
+def parse(where: str, text: str, header: str, tag: str,
+          end: str | None) -> tuple[tuple[str, int], ...]:
+    """Return enum tag of header text, as constants before end."""
+    found = re.search(rf'\benum\s+{re.escape(tag)}\s*{{([^}}]*)}}',
+                      _COMMENT.sub(' ', text))
+    if found is None:
+        raise CtlvError(where, f'{header} has no enum {tag}')
+    constants: list[tuple[str, int]] = []
+    numbers: dict[str, int] = {}
+    number = -1
+    for item in _items(found.group(1)):
+        name, equals, value = (part.strip() for part in item.partition('='))
+        if not _IDENT.fullmatch(name):
+            raise CtlvError(where, f'enum {tag} has {item!r}, which is not a '
+                                   'constant')
+        if equals:
+            number = _Expression(where, tag, name, value, numbers).value()
+        else:
+            number += 1
+        if number < 0:
+            raise CtlvError(where, f'{name} of enum {tag} is {number}, a '
+                                   'negative value')
+        constants.append((name, number))
+        numbers[name] = number
+    if end is None:
+        return tuple(constants)
+    if end not in numbers:
+        raise CtlvError(where, f'enum {tag} has no {end}')
+    kept = tuple(constants[:[name for name, _ in constants].index(end)])
+    if not kept:
+        raise CtlvError(where, f'enum {tag} has no constant before {end}')
+    for name, number in kept:
+        if number >= numbers[end]:
+            raise CtlvError(where, f'{name} of enum {tag} is {number}, not '
+                                   f'below {end}')
+    return kept
+
+
+def _items(body: str) -> list[str]:
+    """The enumerators of an enum body, split at the commas outside ()."""
+    items: list[str] = []
+    depth = start = 0
+    for index, char in enumerate(body):
+        depth += {'(': 1, ')': -1}.get(char, 0)
+        if char == ',' and depth == 0:
+            items.append(body[start:index])
+            start = index + 1
+    items.append(body[start:])
+    return [item.strip() for item in items if item.strip()]
+
+
+class _Expression:
+    """One constant's initializer, evaluated as C evaluates it."""
+
+    def __init__(self, where: str, tag: str, name: str, text: str,
+                 numbers: dict[str, int]) -> None:
+        self.what = f'{name} of enum {tag}'
+        self.where = where
+        self.tag = tag
+        self.numbers = numbers
+        self.tokens: list[tuple[str, str]] = []
+        position = 0
+        text = text.rstrip()
+        while position < len(text):
+            found = _TOKEN.match(text, position)
+            if found is None or found.lastgroup is None:
+                self._fail(f'cannot read {text!r}')
+            self.tokens.append((found.lastgroup,
+                                found.group(found.lastgroup)))
+            position = found.end()
+        self.position = 0
+
+    def _fail(self, problem: str) -> NoReturn:
+        raise CtlvError(self.where, f'{self.what}: {problem}')
+
+    def value(self) -> int:
+        result = self._binary(0)
+        if self.position != len(self.tokens):
+            self._fail(f'cannot read {self.tokens[self.position][1]!r}')
+        return result
+
+    def _peek(self) -> str | None:
+        if self.position == len(self.tokens):
+            return None
+        return self.tokens[self.position][1]
+
+    def _next(self) -> tuple[str, str]:
+        if self.position == len(self.tokens):
+            self._fail('the value ends too soon')
+        self.position += 1
+        return self.tokens[self.position - 1]
+
+    def _binary(self, level: int) -> int:
+        if level == len(_BINARY):
+            return self._unary()
+        left = self._binary(level + 1)
+        while self._peek() in _BINARY[level]:
+            operator = self._next()[1]
+            left = self._apply(operator, left, self._binary(level + 1))
+        return left
+
+    def _unary(self) -> int:
+        kind, token = self._next()
+        if token in ('-', '+', '~'):
+            operand = self._unary()
+            return {'-': -operand, '+': operand, '~': ~operand}[token]
+        if token == '(':
+            inner = self._binary(0)
+            if self._next()[1] != ')':
+                self._fail('a ( is not closed')
+            return inner
+        if kind == 'number':
+            if len(token) > 1 and token[0] == '0' and token[1] not in 'xX':
+                return int(token, 8)
+            return int(token, 0)
+        if kind == 'name' and token in self.numbers:
+            return self.numbers[token]
+        if kind == 'name':
+            self._fail(f'{token} is not an earlier constant of enum '
+                       f'{self.tag}')
+        self._fail(f'cannot read {token!r}')
+
+    def _apply(self, operator: str, left: int, right: int) -> int:
+        if operator in ('/', '%'):
+            if right == 0:
+                self._fail('divides by zero')
+            quotient = abs(left) // abs(right)
+            if (left < 0) != (right < 0):
+                quotient = -quotient
+            return quotient if operator == '/' else left - right * quotient
+        if operator in ('<<', '>>') and right < 0:
+            self._fail('shifts by a negative count')
+        return {
+            '|': lambda: left | right,
+            '^': lambda: left ^ right,
+            '&': lambda: left & right,
+            '<<': lambda: left << right,
+            '>>': lambda: left >> right,
+            '+': lambda: left + right,
+            '-': lambda: left - right,
+            '*': lambda: left * right,
+        }[operator]()
diff --git a/tools/ctlv/ctlvgen/lib/cgen.py b/tools/ctlv/ctlvgen/lib/cgen.py
new file mode 100644
index 000000000000..4fa7bd4c3735
--- /dev/null
+++ b/tools/ctlv/ctlvgen/lib/cgen.py
@@ -0,0 +1,763 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+"""C output scaffolding shared by the CTLV generators.
+
+The preamble ctlv-regen.sh recovers a file's specification and mode from, which
+is why the specification stays directly above the marker.
+"""
+
+from __future__ import annotations
+
+import os
+import pathlib
+import textwrap
+from collections.abc import Callable
+
+from . import semantics
+from . import spec
+from .errors import CtlvError
+
+REGEN: str = 'tools/ctlv/ctlv-regen.sh'
+
+LINE_LIMIT: int = 100
+HARD_LINE_LIMIT: int = 100
+TAB_WIDTH: int = 8
+
+# " * " plus the text has to stay inside the line limit.
+COMMENT_WIDTH: int = LINE_LIMIT - 3
+
+# C spelling of each schema kind. A test checks these against
+# enum ctlv_schema_kind.
+KINDS: dict[str, str] = {
+    'uint': 'CTLV_SCHEMA_UINT',
+    'sint': 'CTLV_SCHEMA_SINT',
+    'bool': 'CTLV_SCHEMA_BOOL',
+    'string': 'CTLV_SCHEMA_STRING',
+    'binary': 'CTLV_SCHEMA_BINARY',
+    'enum': 'CTLV_SCHEMA_ENUM',
+    'flags': 'CTLV_SCHEMA_FLAGS',
+    'record': 'CTLV_SCHEMA_RECORD',
+    'blob': 'CTLV_SCHEMA_BLOB',
+}
+
+LIFECYCLE_API_SYMBOLS: tuple[str, ...] = (
+    'ctlv_init',
+    'ctlv_publish',
+    'ctlv_unpublish',
+    'ctlv_fini',
+    'ctlv_uevent',
+    'ctlv_family_of',
+    'ctlv_op_provide',
+    'ctlv_op_state_set',
+    'ctlv_device_class_register',
+    'ctlv_device_class_unregister',
+    'ctlv_device_init',
+    'ctlv_device_fini',
+    'ctlv_device_add',
+    'ctlv_device_del',
+)
+
+
+def width(line: str) -> int:
+    """Return the display width of one line, a tab being eight columns."""
+    return len(line.expandtabs(TAB_WIDTH))
+
+
+def ident(*names: str) -> str:
+    """Return the lower case C spelling of one or more schema names."""
+    return '_'.join(name.replace('-', '_') for name in names)
+
+
+def macro(*names: str) -> str:
+    """Return the upper case C spelling of one or more schema names."""
+    return ident(*names).upper()
+
+
+def enum_tag(*names: str) -> str:
+    return f'_{ident(*names)}'
+
+
+def header_bounds(definition: semantics.Definition) -> tuple[str, str]:
+    """A header enum's lowest constant and $end - 1, or its highest.
+
+    A number in a gap between constants is in range, for the family to refuse.
+    """
+    assert definition.header is not None
+    low = min(definition.values, key=lambda value: value[1])[0]
+    if definition.header.end:
+        return low, f'{definition.header.end} - 1'
+    return low, max(definition.values, key=lambda value: value[1])[0]
+
+
+def family_suffix(family_name: str) -> str:
+    suffix = family_name
+    if family_name.startswith('ctlv-'):
+        suffix = family_name.removeprefix('ctlv-')
+    return macro(suffix)
+
+
+def family_const(family_name: str) -> str:
+    if family_name == 'ctlv':
+        return 'CTLV_FAMILY_ROOT'
+    return f'CTLV_FAMILY_{family_suffix(family_name)}'
+
+
+def uapi_header(family_name: str, in_kernel: bool = False) -> str:
+    """Return the include of the generated UAPI header of family_name."""
+    prefix = 'uapi/' if in_kernel else ''
+    return f'<{prefix}ctlv/{ident(family_name)}_gen.h>'
+
+
+def families_uapi_header(in_kernel: bool = False) -> str:
+    prefix = 'uapi/' if in_kernel else ''
+    return f'<{prefix}ctlv/ctlv_families_gen.h>'
+
+
+def kernel_header(family_name: str) -> str:
+    """Return the include of the generated kernel header of family_name.
+
+    The root family's interface is installed beside <linux/ctlv.h>; any other
+    family's is private to the family implementation compiling it.
+    """
+    name = f'{ident(family_name)}_gen.h'
+    if family_name == spec.CORE_FAMILY_NAME:
+        return f'<linux/{name}>'
+    return f'"{name}"'
+
+
+def spec_path(path: pathlib.Path | str) -> str:
+    """Return path relative to the kernel tree that holds it.
+
+    ctlv-regen.sh resolves it from the tree root, so it must not depend on how
+    the generator was invoked. Outside a kernel tree it is recorded as given.
+    """
+    full = os.path.abspath(path)
+    relative = ''
+    while True:
+        relative = os.path.join(os.path.basename(full), relative)
+        parent = os.path.dirname(full)
+        if os.path.exists(os.path.join(parent, 'MAINTAINERS')):
+            return relative[:-1]
+        if parent == full:
+            return str(path)
+        full = parent
+
+
+def wrapped(opening: str, items: tuple[str, ...], closing: str,
+            trailer: str = '', adaptive: bool = False) -> list[str]:
+    """Return the lines of one parenthesized list, wrapped at the limit.
+
+    trailer is what a continued line ends with beyond the item: a backslash
+    inside a macro definition, nothing elsewhere.
+    """
+    parts = [f'{item}, ' for item in items[:-1]] + [items[-1] + closing]
+    column = width(opening)
+    part_width = max(width(part.rstrip() + trailer) for part in parts)
+    indent_column = column
+    if adaptive:
+        indent_column = min(column, max(0, LINE_LIMIT - part_width))
+    indent = '\t' * (indent_column // TAB_WIDTH) + \
+        ' ' * (indent_column % TAB_WIDTH)
+    lines = []
+    line = opening
+    for part in parts:
+        if width(line + part.rstrip() + trailer) > LINE_LIMIT:
+            if line != opening:
+                lines.append(line.rstrip())
+            elif adaptive and opening.rstrip():
+                lines.append(opening.rstrip())
+            else:
+                line += part
+                continue
+            line = indent
+        line += part
+    lines.append(line.rstrip())
+    return lines
+
+
+class Writer:
+    """The lines of one generated file."""
+
+    def __init__(self) -> None:
+        self._lines: list[str] = []
+
+    def line(self, text: str = '') -> None:
+        self._lines.append(text)
+
+    def comment(self, *lines: str) -> None:
+        """One comment block, one input line per output line."""
+        if len(lines) == 1:
+            self.line(f'/* {lines[0]} */')
+            return
+        self.line('/*')
+        for text in lines:
+            self.line(f' * {text}'.rstrip())
+        self.line(' */')
+
+    def doc(self, doc: str | None, indent: str = '') -> None:
+        """One declaration's doc, as one comment."""
+        if not doc:
+            return
+        text = ' '.join(doc.split())
+        if width(f'{indent}/* {text} */') <= LINE_LIMIT:
+            self.line(f'{indent}/* {text} */')
+            return
+        self.line(f'{indent}/*')
+        for line in textwrap.wrap(text, COMMENT_WIDTH - width(indent),
+                                  break_on_hyphens=False):
+            self.line(f'{indent} * {line}')
+        self.line(f'{indent} */')
+
+    def define_block(self, name: str, *lines: str) -> None:
+        """One #define whose value takes more than the one line."""
+        header = f'#define {name} \\'
+        if width(header) > LINE_LIMIT and '(' in name:
+            macro, params = name.removesuffix(')').split('(', 1)
+            for text in wrapped(f'#define {macro}(',
+                                tuple(params.split(', ')), ')', ' \\',
+                                adaptive=True):
+                self.line(f'{text} \\')
+        else:
+            self.line(header)
+        for text in lines[:-1]:
+            self.line(f'{text} \\')
+        self.line(lines[-1])
+
+    def define(self, name: str, value: str) -> None:
+        """One #define, continued when it would run past the line limit."""
+        text = f'#define {name} {value}'
+        if width(text) <= LINE_LIMIT:
+            self.line(text)
+            return
+        self.define_block(name, f'\t{value}')
+
+    def define_call(self, name: str, function: str, *args: str) -> None:
+        """One #define whose value is a call, wrapped where it has to be."""
+        call = f'{function}({", ".join(args)})'
+        if width(f'#define {name} {call}') <= LINE_LIMIT:
+            self.line(f'#define {name} {call}')
+            return
+        if width(f'\t{call}') <= LINE_LIMIT:
+            self.define_block(name, f'\t{call}')
+            return
+        self.define_block(
+            name, *wrapped(f'\t{function}(', args, ')', ' \\',
+                           adaptive=True))
+
+    def declaration(self, prefix: str, declarator: str) -> None:
+        """One declaration, continued when it would run past the limit."""
+        text = f'{prefix} {declarator}'
+        if width(text) <= LINE_LIMIT:
+            self.line(text)
+            return
+        indent = prefix[:len(prefix) - len(prefix.lstrip('\t'))]
+        self.line(prefix)
+        continuation = f'{indent}\t'
+        if width(f'{continuation}{declarator}') > LINE_LIMIT:
+            continuation = '\t'
+        self.line(f'{continuation}{declarator}')
+
+    def parenthesized(self, opening: str, items: tuple[str, ...],
+                      closing: str) -> None:
+        """One parenthesized list, wrapped at the line limit."""
+        for text in wrapped(opening, items, closing, adaptive=True):
+            self.line(text)
+
+    def assertion(self, left: str, operator: str, right: int | str) -> None:
+        """One static_assert, broken after its operator when it must be."""
+        opening = 'static_assert('
+        text = f'{opening}{left} {operator} {right});'
+        if width(text) <= LINE_LIMIT:
+            self.line(text)
+            return
+        column = width(opening)
+        indent = '\t' * (column // TAB_WIDTH) + ' ' * (column % TAB_WIDTH)
+        self.line(f'{opening}{left} {operator}')
+        self.line(f'{indent}{right});')
+
+    def signature(self, prefix: str, name: str, params: tuple[str, ...],
+                  closing: str = ');') -> None:
+        """One function signature, wrapped at the line limit."""
+        lines = wrapped(f'{prefix} {name}(', params, closing)
+        one_line = f'{prefix} {name}({", ".join(params)}{closing}'
+        if lines[0].endswith('(') and width(one_line) <= HARD_LINE_LIMIT:
+            self.line(one_line)
+            return
+        if max(width(line) for line in lines) <= LINE_LIMIT:
+            for text in lines:
+                self.line(text)
+            return
+        if name.startswith('*'):
+            self.line(f'{prefix} *')
+            name = name.removeprefix('*')
+        else:
+            self.line(prefix)
+        declarator = f'{name}({", ".join(params)}{closing}'
+        if width(declarator) <= HARD_LINE_LIMIT:
+            self.line(declarator)
+            return
+        opening = f'{name}('
+        lines = wrapped(opening, params, closing)
+        if max(width(line) for line in lines) > LINE_LIMIT:
+            self.line(opening)
+            self.parenthesized('\t', params, closing)
+        else:
+            for text in lines:
+                self.line(text)
+
+    def open_guard(self, guard: str) -> None:
+        self.line(f'#ifndef {guard}')
+        self.line(f'#define {guard}')
+        self.line()
+
+    def close_guard(self, guard: str) -> None:
+        self.line(f'#endif /* {guard} */')
+
+    def includes(self, *headers: str) -> None:
+        """One include block, an empty entry separating two groups."""
+        for header in headers:
+            self.line(f'#include {header}' if header else '')
+        self.line()
+
+    def text(self) -> str:
+        while self._lines and not self._lines[-1]:
+            self._lines.pop()
+        return '\n'.join(self._lines) + '\n'
+
+
+def preamble(origin: semantics.Family | spec.Registry, mode: str, file: str,
+             source: str | None = None) -> Writer:
+    """Return a Writer holding the preamble of one generated file."""
+    writer = Writer()
+    if file == 'source':
+        writer.line(f'// SPDX-License-Identifier: {origin.license}')
+    else:
+        writer.line(f'/* SPDX-License-Identifier: {origin.license} */')
+    writer.line('/*')
+    writer.line(f' * Generated from {spec_path(source or origin.path)} by')
+    writer.line(f' * {REGEN}. Do not edit.')
+    writer.line(' */')
+    writer.line(f'/* CTLV-GEN {mode} {file} */')
+    writer.line()
+    return writer
+
+
+class Names:
+    """The C names of one effective family's declarations.
+
+    A declaration is named after the family that owns it, so an inherited
+    field keeps the name its own family's header gives it.
+    """
+
+    def __init__(self, family: semantics.Family | spec.FamilySpec) -> None:
+        self.family = family
+        self.prefix = macro(family.name)
+        self.ident = ident(family.name)
+
+    @property
+    def effective(self) -> semantics.Family:
+        """The resolved family, which every name but its files' needs."""
+        assert isinstance(self.family, semantics.Family)
+        return self.family
+
+    def owner_prefix(self, family_id: int) -> str:
+        return macro(self.effective.owners[family_id])
+
+    def owner_ident(self, family_id: int) -> str:
+        return ident(self.effective.owners[family_id])
+
+    # Names that a family's UAPI header defines.
+
+    def family_const(self) -> str:
+        return family_const(self.family.name)
+
+    def field(self, field: semantics.Field) -> str:
+        """The type of one field, after the record holding it."""
+        return f'{self.owner_prefix(field.family_id)}_T_{macro(field.c_name)}'
+
+    def field_unit(self, field: semantics.Field) -> str:
+        return f'{self.field(field)}_UNIT'
+
+    def field_scale(self, field: semantics.Field) -> str:
+        return f'{self.field(field)}_SCALE'
+
+    def op_id(self, op: semantics.Op) -> str:
+        return f'{self.owner_prefix(op.family_id)}_OP_{macro(op.name)}'
+
+    def definition(self, definition: semantics.Definition) -> str:
+        """The C type name of an enum definition."""
+        return enum_tag(self.effective.owners[definition.family_id],
+                        definition.name)
+
+    def value(self, definition: semantics.Definition, value_name: str) -> str:
+        """One enum value or flag bit."""
+        if definition.header:
+            return value_name
+        return f'{self.owner_prefix(definition.family_id)}_' \
+               f'{macro(definition.name, value_name)}'
+
+    def value_bit(self, definition: semantics.Definition,
+                  value_name: str) -> str:
+        return f'{self.value(definition, value_name)}_BIT'
+
+    def bit_enum(self, definition: semantics.Definition) -> str:
+        return enum_tag(self.effective.owners[definition.family_id],
+                        definition.name, 'bit')
+
+    def value_mask(self, definition: semantics.Definition) -> str:
+        """The mask of every bit a flags definition declares."""
+        return f'{self.owner_prefix(definition.family_id)}_' \
+               f'{macro(definition.name)}_MASK'
+
+    # Names that a family's kernel metadata defines: its own ops, its
+    # extension points and the ones it fills.
+
+    def extension(self, extension: semantics.Extension) -> str:
+        """The ID one extension point has among its family's."""
+        return f'{self.owner_prefix(extension.family_id)}_EXT_' \
+               f'{macro(extension.name)}'
+
+    def enum_extension(self, extension: semantics.EnumExtension) -> str:
+        """The ID one enum extension point has among its family's."""
+        return f'{self.owner_prefix(extension.family_id)}_ENUM_EXT_' \
+               f'{macro(extension.name)}'
+
+    def enum_fill_schemas(self) -> str:
+        return f'{self.ident}_enum_fill_schemas'
+
+    def op_schemas(self) -> str:
+        return f'{self.ident}_op_schemas'
+
+    def schema(self) -> str:
+        return f'{self.ident}_schema'
+
+    def ext_fill_schemas(self) -> str:
+        return f'{self.ident}_ext_fill_schemas'
+
+    def node_schemas(self, op: semantics.Op, which: str) -> str:
+        # File scope, so no family prefix: an op name is unique within its
+        # effective family.
+        return f'{ident(op.name)}_{which}_node_schemas'
+
+    def ext_schemas(self, op: semantics.Op, which: str) -> str:
+        return f'{ident(op.name)}_{which}_ext_schemas'
+
+    def fill_node_schemas(self, fill: semantics.Fill) -> str:
+        return f'{ident(fill.name)}_fill_node_schemas'
+
+    def message_node_schemas(self, message: semantics.Message) -> str:
+        return f'{ident(message.name)}_node_schemas'
+
+    def message_schema(self, message: semantics.Message) -> str:
+        """The tree the core builds one of its own messages against."""
+        return f'{self.ident}_{ident(message.name)}_schema'
+
+    def message_max_len(self, message: semantics.Message) -> str:
+        return f'{self.prefix}_{macro(message.name)}_MAX_LEN'
+
+    # Names that a family's device descriptor defines. Named after the family
+    # that declared what they answer: an inherited op is answered by that
+    # family implementation, on whatever device it arrived at.
+
+    def descriptor(self) -> str:
+        return f'{self.ident}_family'
+
+    def ops(self) -> str:
+        return f'{self.ident}_ops'
+
+    def ext_ops(self) -> str:
+        return f'{self.ident}_ext_ops'
+
+    def ext_ident(self, fill: semantics.Fill) -> str:
+        return f'{self.ident}_{ident(fill.name)}'
+
+    def ext_callback(self, fill: semantics.Fill, which: str) -> str:
+        """One half of what this family does with an extension point."""
+        return f'{self.ext_ident(fill)}_{which}'
+
+    def op_ident(self, op: semantics.Op) -> str:
+        return f'{self.owner_ident(op.family_id)}_{ident(op.name)}'
+
+    def callback(self, op: semantics.Op) -> str:
+        return f'{self.op_ident(op)}_{op.type}'
+
+    def op_helper(self, op: semantics.Op, what: str) -> str:
+        """What one device decides about one op."""
+        return f'{self.op_ident(op)}_{what}'
+
+    def field_ident(self, field: semantics.Field) -> str:
+        """The stem of every helper of one field, after its constant."""
+        return f'{self.owner_ident(field.family_id)}_{ident(field.c_name)}'
+
+    def field_helper(self, field: semantics.Field, what: str) -> str:
+        """One helper of one field: reading it, or appending it."""
+        return f'{self.field_ident(field)}_{what}'
+
+    def op_hook(self, op: semantics.Op, which: str) -> str:
+        """One half of the pair that wraps this op alone."""
+        return f'{self.op_ident(op)}_{which}'
+
+    # Where a generated file lives: the installed constants, the schema
+    # metadata a family compiles, and the descriptor it registers.
+
+    def uapi_guard(self) -> str:
+        return f'_UAPI_CTLV_{self.prefix}_GEN_H'
+
+    def uapi_header(self, in_kernel: bool = False) -> str:
+        return uapi_header(self.family.name, in_kernel)
+
+    def kernel_guard(self) -> str:
+        return f'_LINUX_{self.prefix}_GEN_H'
+
+    def kernel_header(self) -> str:
+        return kernel_header(self.family.name)
+
+    def user_guard(self) -> str:
+        return f'_CTLV_{self.prefix}_USER_GEN_H'
+
+    def user_header(self) -> str:
+        return f'"{self.ident}_user_gen.h"'
+
+    # Names that a family's userspace binding defines, after the family that
+    # declared the op, as a per-op helper is in the kernel.
+
+    def user_op(self, op: semantics.Op) -> str:
+        return f'{self.owner_ident(op.family_id)}_{ident(op.name)}'
+
+    def user_op_helper(self, op: semantics.Op, what: str) -> str:
+        return f'{self.user_op(op)}_{what}'
+
+    def user_op_len(self, op: semantics.Op, what: str) -> str:
+        """One length of one op, as its specification computed it."""
+        return f'{self.op_id(op)}_{macro(what)}'
+
+    def user_node_schema(self, op: semantics.Op, which: str) -> str:
+        # File scope, so no family prefix, as on the kernel side.
+        return f'{ident(op.name)}_{which}_node_schema'
+
+    def user_spec(self) -> str:
+        """What this family's specification says, to compare a device to."""
+        return f'{self.ident}_spec'
+
+    def user_op_specs(self) -> str:
+        return f'{self.ident}_op_specs'
+
+
+def getter_value(field: semantics.Field) -> bool:
+    """Whether a field has a getter beside the reader that locates it."""
+    return field.decl.kind != 'blob' and \
+        not (field.decl.kind == 'record' and field.decl.max_occurrences != 1)
+
+
+def input_readers(names: Names, field: semantics.Field) -> tuple[str, ...]:
+    """The names of what reads one field of a request."""
+    readers = [names.field_helper(field, 'ref')]
+    readers.append(names.field_helper(field, 'for_each')
+                   if field.decl.max_occurrences != 1
+                   else names.field_helper(field, 'present'))
+    if field.decl.kind == 'blob':
+        readers.append(names.field_helper(field, 'resolve'))
+    elif getter_value(field):
+        readers.append(names.field_helper(field, 'get'))
+    return tuple(readers)
+
+
+def output_writers(names: Names, field: semantics.Field) -> tuple[str, ...]:
+    """The names of what appends one field to a reply.
+
+    A blob has none: a request carries one and a reply never does.
+    """
+    if field.decl.kind == 'blob':
+        return ()
+    what = 'start' if field.decl.kind == 'record' else 'put'
+    return (names.field_helper(field, what),)
+
+
+# What a blob field may be backed by, and the libctlv call describing one. A
+# putter exists per backing the field permits, so what a caller may
+# describe is decided by the specification.
+BLOB_PUTTERS: dict[str, tuple[str, tuple[str, ...]]] = {
+    'va': ('va', ('const void *address', '__u64 length')),
+}
+
+# The lengths a user-mode header states for one op, by sizes.OpSizes member.
+# What a device answers with, its descendants' fills included, op-get says.
+USER_LENGTHS: dict[str, str] = {
+    'request_max_len': 'request-max-len',
+}
+
+
+def user_readers(names: Names, field: semantics.Field) -> tuple[str, ...]:
+    """The names of what reads one field in the userspace binding."""
+    if field.decl.kind == 'blob':
+        return ()
+    readers = [names.field_helper(field, 'for_each')
+               if field.decl.max_occurrences != 1
+               else names.field_helper(field, 'present')]
+    if getter_value(field):
+        readers.append(names.field_helper(field, 'get'))
+    return tuple(readers)
+
+
+def user_writers(names: Names, field: semantics.Field) -> tuple[str, ...]:
+    """The names of what appends one field in the userspace binding.
+
+    A blob has one putter per backing the field allows, where the kernel
+    side has none.
+    """
+    if field.decl.kind == 'blob':
+        assert field.decl.blob is not None
+        return tuple(names.field_helper(field,
+                                        f'put_{BLOB_PUTTERS[backing][0]}')
+                     for backing in field.decl.blob.backings)
+    what = 'start' if field.decl.kind == 'record' else 'put'
+    return (names.field_helper(field, what),)
+
+
+class _Table:
+    """Generated C names, each mapped to what it was generated for."""
+
+    def __init__(self, family: semantics.Family) -> None:
+        self.family = family
+        self.names: dict[str, str] = {}
+
+    def add(self, name: str, origin: str) -> None:
+        previous = self.names.get(name)
+        if previous is not None:
+            raise CtlvError(f'{self.family.path}: {origin}',
+                            f'generated name {name} is already used by '
+                            f'{previous}')
+        self.names[name] = origin
+
+
+def user_symbols(family: semantics.Family) -> dict[str, str]:
+    """Return every C name of family's binding, mapped to its origin.
+
+    The binding covers this family's own fields and ops, reaching the rest
+    through the parent's header.
+    """
+    names = Names(family)
+    table = _Table(family)
+
+    for field in family.local_fields:
+        what = f'field {field.full_name}'
+        for helper in user_readers(names, field) + \
+                user_writers(names, field):
+            table.add(helper, what)
+    for op in family.local_ops:
+        what = f'op {op.name}'
+        table.add(names.user_op(op), what)
+        if op.request is not None:
+            table.add(names.user_op_helper(op, 'request_new'), what)
+        for member, what_len in USER_LENGTHS.items():
+            if getattr(op.sizes, member):
+                table.add(names.user_op_len(op, what_len), what)
+    return table.names
+
+
+def _extensions_anywhere(node: semantics.Node) -> bool:
+    return bool(node.extensions) or any(_extensions_anywhere(child)
+                                        for child in node.children())
+
+
+def symbols(family: semantics.Family) -> dict[str, str]:
+    """Return every generated C name of family, mapped to its declaration.
+
+    Dashes become underscores, so two YAML names can spell one C name. That
+    has to be an error: one of the two constants would silently not exist.
+    """
+    names = Names(family)
+    table = _Table(family)
+    add = table.add
+
+    for name in LIFECYCLE_API_SYMBOLS:
+        add(name, 'the CTLV lifecycle API')
+    add(names.family_const(), f'family {family.name}')
+    # A child header may include every ancestor's family API, and built-in
+    # families also share one linker namespace with the root.
+    for family_id, owner in family.owners.items():
+        owner_ident = ident(owner)
+        if any(op.family_id == family_id for op in family.ops):
+            add(f'{owner_ident}_op_schemas', f'family {owner}')
+        add(f'{owner_ident}_schema', f'family {owner}')
+        add(f'{owner_ident}_family', f'family {owner}')
+    for fill in family.fills:
+        for which in ('fill', 'read'):
+            add(names.ext_callback(fill, which), f'record {fill.name}')
+    for definition in family.definitions.values():
+        if definition.header or definition.is_extension_point:
+            continue
+        what = f'{definition.kind} {definition.name}'
+        if definition.kind == 'enum':
+            add(f'enum {names.definition(definition)}', what)
+        else:
+            add(f'enum {names.bit_enum(definition)}', what)
+            add(names.value_mask(definition), what)
+        for value_name, _ in definition.values:
+            if definition.kind == 'flags':
+                add(names.value_bit(definition, value_name), what)
+            add(names.value(definition, value_name), what)
+    for field in family.fields.values():
+        what = f'field {field.full_name}'
+        add(names.field(field), what)
+        if field.decl.unit is not None:
+            add(names.field_unit(field), what)
+            add(names.field_scale(field), what)
+    for extension in family.extensions.values():
+        add(names.extension(extension), f'extension {extension.name}')
+    for enum_extension in family.enum_extensions.values():
+        add(names.enum_extension(enum_extension),
+            f'enum {enum_extension.name}')
+    _helper_symbols(family, add)
+    for op in family.ops:
+        what = f'op {op.name}'
+        add(names.op_id(op), what)
+        add(names.callback(op), what)
+        if op.optional:
+            add(names.op_helper(op, 'provide'), what)
+        if op.availability == 'dynamic':
+            add(names.op_helper(op, 'enable'), what)
+            add(names.op_helper(op, 'disable'), what)
+        if op.pre_post:
+            add(names.op_hook(op, 'pre'), what)
+            add(names.op_hook(op, 'post'), what)
+    for message in family.messages:
+        what = f'record {message.name}'
+        add(names.message_node_schemas(message), what)
+        add(names.message_schema(message), what)
+        add(names.message_max_len(message), what)
+    if family.fills:
+        add(names.ext_fill_schemas(), f'family {family.name}')
+        add(names.ext_ops(), f'family {family.name}')
+    if family.enum_fills:
+        add(names.enum_fill_schemas(), f'family {family.name}')
+    if family.local_ops:
+        add(names.ops(), f'family {family.name}')
+    for op in family.local_ops:
+        what = f'op {op.name}'
+        for which in ('request', 'reply'):
+            root = getattr(op, which)
+            if root is None:
+                continue
+            add(names.node_schemas(op, which), what)
+            if _extensions_anywhere(root):
+                add(names.ext_schemas(op, which), what)
+    for fill in family.fills:
+        add(names.fill_node_schemas(fill), f'record {fill.name}')
+    return table.names
+
+
+def _helper_symbols(family: semantics.Family,
+                    add: Callable[[str, str], None]) -> None:
+    """The readers and writers of the whole chain, each where it is emitted.
+
+    Every family of the chain emits the helpers its own uses add, so the
+    chain's helpers are those of each prefix of it.
+    """
+    names = Names(family)
+    inputs, outputs = semantics.field_uses(family)
+    for field in inputs.values():
+        for helper in input_readers(names, field):
+            add(helper, f'field {field.full_name}')
+    for field in outputs.values():
+        for helper in output_writers(names, field):
+            add(helper, f'field {field.full_name}')
diff --git a/tools/ctlv/ctlvgen/lib/compat.py b/tools/ctlv/ctlvgen/lib/compat.py
new file mode 100644
index 000000000000..76bd14f60750
--- /dev/null
+++ b/tools/ctlv/ctlvgen/lib/compat.py
@@ -0,0 +1,877 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+"""ABI snapshots and the compatibility checker.
+
+A change is compatible only if the new schema still contains everything the
+checked-in snapshot describes, with the same IDs, no narrowed bound, no
+member that became required and no member of a reply that became optional.
+A new member has to be optional. Regenerating
+rewrites a snapshot, refusing an incompatible one unless the break is meant,
+so the snapshot's diff is how the change gets reviewed.
+
+The snapshot is keyed by record path. A record's ID comes from where it is in
+the spec and a field's type from its record and number, so the checker only
+compares them; it assigns nothing.
+"""
+
+from __future__ import annotations
+
+import pathlib
+import re
+from typing import Any
+
+import yaml
+
+from . import cgen
+from . import semantics
+from . import spec
+from . import yamlload
+from .errors import CtlvError
+
+HEADER: str = '''\
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+%YAML 1.2
+---
+# Checked-in ABI snapshot of the {name} family, from
+# {spec}, written by
+# "make -C tools/ctlv regen".
+#
+# Updating the file is how a UAPI change gets reviewed; an update that
+# removes or renumbers anything, narrows a bound, or makes a member required
+# is an ABI break, whatever the file says afterwards.
+'''
+
+REGISTRY_HEADER: str = '''\
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+%YAML 1.2
+---
+# Checked-in ABI baseline of the ordered CTLV family registry.
+# Written by "make -C tools/ctlv regen".
+'''
+
+SNAPSHOT_INDENT: int = 2
+
+_SIZE: re.Pattern[str] = re.compile(r'(?P<value>[0-9]+)(?P<suffix>[KMG])')
+
+# The bounds that are byte counts, which a snapshot writes as a spec does.
+_LENGTHS: tuple[str, ...] = ('min-length', 'max-length', 'length', 'alignment')
+
+
+class _Dumper(yaml.SafeDumper):
+    """Dumper that never emits anchors, which the strict loader rejects."""
+
+    def ignore_aliases(self, data: object) -> bool:
+        return True
+
+    def increase_indent(self, flow: bool = False,
+                        indentless: bool = False) -> None:
+        # Indent a sequence under its key, not flush left as pyyaml does.
+        return super().increase_indent(flow, False)
+
+
+class _FlowMap(dict[str, Any]):
+    pass
+
+
+class _FlowSeq(list[str]):
+    pass
+
+
+class _Hex(int):
+    pass
+
+
+_Dumper.add_representer(
+    _FlowMap,
+    lambda dumper, value: dumper.represent_mapping(
+        'tag:yaml.org,2002:map', value, flow_style=True))
+_Dumper.add_representer(
+    _FlowSeq,
+    lambda dumper, value: dumper.represent_sequence(
+        'tag:yaml.org,2002:seq', value, flow_style=True))
+_Dumper.add_representer(
+    _Hex,
+    lambda dumper, value: dumper.represent_scalar(
+        'tag:yaml.org,2002:int', f'{value:#010x}'))
+
+
+def build(family: semantics.Family) -> dict[str, Any]:
+    """Return one family's ABI in the comparison form."""
+    return {
+        'family': family.name,
+        'family-id': family.family_id,
+        'parent': family.parent,
+        'spec': cgen.spec_path(family.path),
+        'definitions': _definitions(family.local_definitions),
+        'records': _records(family),
+        'extensions': {extension.name: extension.ext_id
+                       for extension in family.local_extensions},
+        'enum-extensions': {extension.name: extension.ext_id
+                            for extension in family.local_enum_extensions},
+        'fills': {fill.name: fill.record.path for fill in family.fills},
+        'ops': _ops(family.local_ops),
+    }
+
+
+def render(family: semantics.Family) -> str:
+    """Return one family's compact snapshot as YAML text."""
+    return render_data(build(family))
+
+
+def render_data(data: dict[str, Any]) -> str:
+    """Render comparison-form data as a compact snapshot."""
+    body = yaml.dump(_compact(data), Dumper=_Dumper, sort_keys=False,
+                     default_flow_style=False, width=1000000,
+                     indent=SNAPSHOT_INDENT)
+    body = '\n'.join(line for source in body.splitlines()
+                     for line in _wrap_flow(source)) + '\n'
+    return HEADER.format(name=data['family'], spec=data['spec']) + body
+
+
+def _wrap_flow(line: str, width: int = 80) -> tuple[str, ...]:
+    """Wrap one flow collection with continuations aligned after its opener.
+
+    Where an item does not fit there, the collection starts a line of its own
+    below its key.
+    """
+    if len(line) <= width:
+        return (line,)
+    starts = [index for index in (line.find('{'), line.find('['))
+              if index >= 0]
+    if not starts:
+        return (line,)
+    start = min(starts)
+    end, items = _flow_items(line, start)
+    if end is None:
+        return (line,)
+
+    wrapped = _wrap_items(line[:start + 1], line[end:], start + 1, items,
+                          width)
+    key = line[:start].rstrip()
+    if max(map(len, wrapped)) <= width or not key.endswith(':'):
+        return wrapped
+    indent = len(line) - len(line.lstrip()) + SNAPSHOT_INDENT
+    return (key,) + _wrap_items(' ' * indent + line[start], line[end:],
+                                indent + 1, items, width)
+
+
+def _wrap_items(prefix: str, suffix: str, indent_width: int,
+                items: tuple[str, ...], width: int) -> tuple[str, ...]:
+    indent = ' ' * indent_width
+    wrapped = []
+    current = prefix
+    for index, item in enumerate(items):
+        last = index + 1 == len(items)
+        token = item + ('' if last else ',')
+        separator = '' if current.endswith(('{', '[')) else ' '
+        closing = len(suffix) if last else 0
+        if len(current) + len(separator) + len(token) + closing > width:
+            wrapped.append(current)
+            current = indent + token
+        else:
+            current += separator + token
+    current += suffix
+    wrapped.append(current)
+    return tuple(wrapped)
+
+
+def _flow_items(line: str,
+                start: int) -> tuple[int | None, tuple[str, ...]]:
+    pairs = {'{': '}', '[': ']'}
+    stack = [line[start]]
+    quote = None
+    escape = False
+    item_start = start + 1
+    items = []
+    for index in range(start + 1, len(line)):
+        char = line[index]
+        if quote is not None:
+            if escape:
+                escape = False
+            elif char == '\\':
+                escape = True
+            elif char == quote:
+                quote = None
+            continue
+        if char in ('"', "'"):
+            quote = char
+        elif char in pairs:
+            stack.append(char)
+        elif char in pairs.values():
+            if pairs[stack[-1]] != char:
+                return None, ()
+            stack.pop()
+            if not stack:
+                items.append(line[item_start:index].strip())
+                return index, tuple(item for item in items if item)
+        elif char == ',' and len(stack) == 1:
+            items.append(line[item_start:index].strip())
+            item_start = index + 1
+    return None, ()
+
+
+def breaks(family: semantics.Family, path: pathlib.Path | str,
+           text: str | None = None) -> list[str]:
+    """Every way family breaks the snapshot in path, or the one in text."""
+    return _compare(_expand(yamlload.load(path, text)), build(family),
+                    _reply_records(family))
+
+
+def check(family: semantics.Family, path: pathlib.Path) -> None:
+    """Compare a family against its snapshot, or raise with every problem."""
+    problems = breaks(family, path)
+    if problems:
+        raise CtlvError(f'{family.name} against {path}',
+                        'the schema is not compatible with its snapshot\n' +
+                        '\n'.join(f'  {problem}' for problem in problems))
+
+
+# The comparison form, from a resolved family.
+
+def _definitions(
+        items: tuple[semantics.Definition, ...]) -> dict[str, dict[str, Any]]:
+    return {definition.name: _definition(definition)
+            for definition in items if not definition.is_extension_point}
+
+
+def _definition(definition: semantics.Definition) -> dict[str, Any]:
+    entry: dict[str, Any] = {'kind': definition.kind,
+                             'values': dict(definition.values)}
+    if definition.header:
+        entry['header'] = _header_keys(definition.header)
+    return entry
+
+
+def _header_keys(header: spec.HeaderEnum) -> dict[str, str]:
+    keys = {'$header': header.path, '$enum': header.tag}
+    if header.end:
+        keys['$end'] = header.end
+    return keys
+
+
+def _records(family: semantics.Family) -> dict[str, dict[str, Any]]:
+    records = {}
+    for record in family.local_records:
+        own = {field.type for field in record.fields}
+        records[record.path] = {
+            'record-id': record.record_id,
+            'fields': {member.field.name: _field(member.field,
+                                                 member.required)
+                       for member in record.members
+                       if member.field.type in own},
+            'members': _foreign(family, record, own),
+        }
+    return records
+
+
+def _foreign(family: semantics.Family, record: semantics.Record,
+             own: set[int]) -> dict[str, bool]:
+    """What a record has that it does not declare: placed records and includes.
+
+    An include is one member, optional when it made a field optional that the
+    record it splices requires.
+    """
+    members = {}
+    for member in record.members:
+        field = member.field
+        if field.type in own:
+            continue
+        if field.shared:
+            members[f'record {field.name}'] = member.required
+            continue
+        key = f'$include {field.record}'
+        source = family.records[field.record]
+        declared = any(item.required for item in source.members
+                       if item.field.type == field.type)
+        members.setdefault(key, True)
+        if declared and not member.required:
+            members[key] = False
+    return members
+
+
+def _reply_records(family: semantics.Family) -> set[str]:
+    """The paths of the records a reply of the chain carries, fills too."""
+    owners = {field.type: record.path for record in family.records.values()
+              for field in record.fields}
+    found: set[str] = set()
+
+    def walk(node: semantics.Node) -> None:
+        for extension in node.extensions:
+            fill = family.fill_of(extension)
+            if fill is not None:
+                found.add(fill.record.path)
+        for child, _optional in semantics.composed_members(family, node):
+            found.add(owners[child.child_field.type])
+            if child.child_field.holds is not None:
+                found.add(child.child_field.holds)
+            walk(child)
+
+    for op in family.ops:
+        if op.reply is not None:
+            assert op.reply_record is not None
+            found.add(op.reply_record.path)
+            walk(op.reply)
+    return found
+
+
+def _field(field: semantics.Field, required: bool) -> dict[str, Any]:
+    decl = field.decl
+    entry = {'number': field.number, 'kind': decl.kind,
+             'required': required,
+             'max-occurrences': decl.count_enum or decl.max_occurrences}
+    if decl.kind in ('enum', 'flags'):
+        entry['definition'] = decl.ref
+    if decl.kind == 'record':
+        if decl.extension is not None:
+            entry['extension'] = decl.extension
+        else:
+            entry['record'] = field.holds
+    for name, value in (('min', decl.min), ('max', decl.max),
+                        ('min-length', decl.min_length),
+                        ('max-length', decl.max_length),
+                        ('unit', decl.unit), ('scale', decl.scale)):
+        if value is not None:
+            entry[name] = value
+    if decl.blob is not None:
+        entry['blob'] = {
+            'direction': decl.blob.direction,
+            'backings': list(decl.blob.backings),
+            'max-length': decl.blob.max_length,
+            'alignment': decl.blob.alignment,
+        }
+    return entry
+
+
+def _ops(items: tuple[semantics.Op, ...]) -> dict[str, dict[str, Any]]:
+    ops = {}
+    for op in items:
+        ops[op.name] = {
+            'op-id': op.local_id,
+            'type': op.type,
+            'availability': op.availability,
+            'optional': op.optional,
+            'pre-post': op.pre_post,
+            'request': op.request_record.path if op.request_record else None,
+            'reply': op.reply_record.path if op.reply_record else None,
+            'fd-access': op.fd_access,
+        }
+    return ops
+
+
+# The compact form a snapshot is written in.
+
+def _compact(data: dict[str, Any]) -> dict[str, Any]:
+    family = _FlowMap({
+        'name': data['family'],
+        'id': data['family-id'],
+    })
+    if data['parent'] is not None:
+        family['inherits'] = data['parent']
+
+    compact: dict[str, Any] = {'family': family}
+    for kind, section in (('enum', 'enums'), ('flags', 'flags')):
+        definitions = {
+            name: _FlowMap(entry.get('header', entry['values']))
+            for name, entry in data['definitions'].items()
+            if entry['kind'] == kind
+        }
+        if definitions:
+            compact[section] = definitions
+    if data['records']:
+        compact['records'] = {path: _compact_record(record)
+                              for path, record in data['records'].items()}
+    if data['extensions']:
+        compact['extensions'] = _FlowMap(data['extensions'])
+    if data['enum-extensions']:
+        compact['enum-extensions'] = _FlowMap(data['enum-extensions'])
+    if data['fills']:
+        compact['fills'] = _FlowMap(data['fills'])
+    if data['ops']:
+        compact['ops'] = {name: _compact_op(entry)
+                          for name, entry in data['ops'].items()}
+    return compact
+
+
+def _compact_record(record: dict[str, Any]) -> dict[str, Any]:
+    compact: dict[str, Any] = {'id': _Hex(record['record-id'])}
+    if record['fields']:
+        compact['fields'] = {name: _compact_field(field)
+                             for name, field in record['fields'].items()}
+    if record['members']:
+        compact['members'] = _FlowSeq(
+            key + ('' if required else '?')
+            for key, required in record['members'].items())
+    return compact
+
+
+def _compact_field(field: dict[str, Any]) -> _FlowMap:
+    kind = field['kind']
+    compact = _FlowMap({'number': field['number']})
+    if kind in ('enum', 'flags'):
+        compact[kind] = field['definition']
+    elif kind == 'blob':
+        blob = field['blob']
+        compact['blob'] = blob['direction']
+        compact['backings'] = _FlowSeq(blob['backings'])
+        compact['max-length'] = _size(blob['max-length'])
+        if blob['alignment'] != 1:
+            compact['alignment'] = _size(blob['alignment'])
+    elif kind == 'record':
+        if 'extension' in field:
+            compact['extension'] = field['extension']
+        else:
+            compact['record'] = field['record']
+    else:
+        compact['type'] = kind
+
+    if kind in ('uint', 'sint'):
+        low, high = _integer_extremes(kind)
+        bound = _size if field.get('unit') == 'bytes' else _integer
+        if field.get('min', low) != low:
+            compact['min'] = bound(field['min'])
+        if field.get('max', high) != high:
+            compact['max'] = bound(field['max'])
+        if 'unit' in field:
+            compact['unit'] = field['unit']
+            if field['scale']:
+                compact['scale'] = field['scale']
+    elif kind in ('string', 'binary'):
+        minimum = field.get('min-length', 0)
+        maximum = field['max-length']
+        if kind == 'binary' and minimum == maximum:
+            compact['length'] = _size(maximum)
+        else:
+            if minimum:
+                compact['min-length'] = _size(minimum)
+            compact['max-length'] = _size(maximum)
+
+    maximum = field['max-occurrences']
+    if maximum != 1:
+        compact['max-occurrences'] = (
+            'unlimited' if maximum == spec.UNLIMITED else maximum)
+    if not field['required']:
+        compact['optional'] = True
+    return compact
+
+
+def _integer(value: int) -> int | str:
+    """An integer bound as a spec writes it, a plain one as a number."""
+    text = spec.number_text(value)
+    return value if text == str(value) else text
+
+
+def _size(value: int) -> int | str:
+    """A byte count as a spec writes it, a plain one as a number."""
+    text = spec.size_text(value)
+    return value if text == str(value) else text
+
+
+def _integer_extremes(kind: str) -> tuple[int, int]:
+    return (0, spec.U64_MAX) if kind == 'uint' else (spec.S64_MIN,
+                                                     spec.S64_MAX)
+
+
+def _compact_op(op: dict[str, Any]) -> _FlowMap:
+    abi = _FlowMap({
+        'id': op['op-id'],
+        'type': op['type'],
+    })
+    if op.get('fd-access') != spec.DEFAULT_FD_ACCESS:
+        abi['fd-access'] = op.get('fd-access')
+    availability = op.get('availability', spec.DEFAULT_AVAILABILITY)
+    if availability != spec.DEFAULT_AVAILABILITY:
+        abi['availability'] = availability
+    if op.get('optional', False):
+        abi['optional'] = True
+    if op.get('pre-post', False):
+        abi['pre-post'] = True
+    if op.get('request') is not None:
+        abi['request'] = op['request']
+    if op.get('reply') is not None:
+        abi['reply'] = op['reply']
+    return abi
+
+
+def _expand(compact: dict[str, Any]) -> dict[str, Any]:
+    family = compact['family']
+    definitions = {}
+    for kind, section in (('enum', 'enums'), ('flags', 'flags')):
+        for name, values in compact.get(section, {}).items():
+            definitions[name] = {
+                'kind': kind,
+                'values': {} if '$header' in values else values,
+            }
+            if '$header' in values:
+                definitions[name]['header'] = dict(values)
+    return {
+        'family': family['name'],
+        'family-id': family['id'],
+        'parent': family.get('inherits'),
+        'definitions': definitions,
+        'records': {path: _expand_record(path, record)
+                    for path, record in compact.get('records', {}).items()},
+        'extensions': dict(compact.get('extensions', {})),
+        'enum-extensions': dict(compact.get('enum-extensions', {})),
+        'fills': dict(compact.get('fills', {})),
+        'ops': _expand_ops(compact.get('ops', {})),
+    }
+
+
+def _expand_record(path: str, compact: dict[str, Any]) -> dict[str, Any]:
+    members = {}
+    for item in compact.get('members', []):
+        members[item.removesuffix('?')] = not item.endswith('?')
+    return {
+        'record-id': compact['id'],
+        'fields': {name: _expand_field(f'{path}.{name}', field)
+                   for name, field in compact.get('fields', {}).items()},
+        'members': members,
+    }
+
+
+def _expand_field(where: str, compact: dict[str, Any]) -> dict[str, Any]:
+    primary = [name for name in ('type', 'enum', 'flags', 'blob', 'record',
+                                 'extension')
+               if name in compact]
+    if len(primary) != 1:
+        raise CtlvError(f'ABI snapshot field {where}',
+                        'expected one of type, enum, flags, blob, record or '
+                        'extension')
+    kind = primary[0]
+    if kind == 'type':
+        kind = compact['type']
+    elif kind in ('record', 'extension'):
+        kind = 'record'
+    field = {
+        'number': compact['number'],
+        'kind': kind,
+        'required': not compact.get('optional', False),
+        'max-occurrences': compact.get('max-occurrences', 1),
+    }
+    if field['max-occurrences'] == 'unlimited':
+        field['max-occurrences'] = spec.UNLIMITED
+    if kind in ('enum', 'flags'):
+        field['definition'] = compact[kind]
+    elif kind == 'record':
+        for key in ('record', 'extension'):
+            if key in compact:
+                field[key] = compact[key]
+    elif kind in ('uint', 'sint'):
+        low, high = _integer_extremes(kind)
+        field['min'] = _number(where, compact.get('min', low))
+        field['max'] = _number(where, compact.get('max', high))
+        if 'unit' in compact:
+            field['unit'] = compact['unit']
+            field['scale'] = compact.get('scale', 0)
+    elif kind in ('string', 'binary'):
+        if 'length' in compact:
+            field['min-length'] = _number(where, compact['length'])
+            field['max-length'] = field['min-length']
+        else:
+            field['min-length'] = _number(where,
+                                          compact.get('min-length', 0))
+            field['max-length'] = _number(where, compact['max-length'])
+    elif kind == 'blob':
+        field['blob'] = {
+            'direction': compact['blob'],
+            'backings': list(compact['backings']),
+            'max-length': _number(where, compact['max-length']),
+            'alignment': _number(where, compact.get('alignment', 1)),
+        }
+    return field
+
+
+def _number(where: str, value: int | str) -> int:
+    """A number as a snapshot writes it: plain, a limit's name or a size."""
+    if isinstance(value, int):
+        return value
+    if value in spec.NAMED_NUMBERS:
+        return spec.NAMED_NUMBERS[value]
+    found = _SIZE.fullmatch(str(value))
+    if found is None:
+        raise CtlvError(f'ABI snapshot field {where}',
+                        f'"{value}" is not a number')
+    scale = dict(spec.SIZE_SUFFIXES)[found['suffix']]
+    return int(found['value']) * scale
+
+
+def _expand_ops(ops: dict[str, Any]) -> dict[str, dict[str, Any]]:
+    expanded = {}
+    for name, abi in ops.items():
+        expanded[name] = {
+            'op-id': abi['id'],
+            'type': abi['type'],
+            'availability': abi.get(
+                'availability', spec.DEFAULT_AVAILABILITY),
+            'optional': abi.get('optional', False),
+            'pre-post': abi.get('pre-post', False),
+            'request': abi.get('request'),
+            'reply': abi.get('reply'),
+            'fd-access': abi.get('fd-access', spec.DEFAULT_FD_ACCESS),
+        }
+    return expanded
+
+
+def registry_build(
+        registry: spec.Registry) -> dict[str, list[str | dict[str, Any]]]:
+    """Return the registry in the same normalized form as its source."""
+    families: list[str | dict[str, Any]] = []
+    for entry in registry.entries:
+        if entry.deprecated:
+            families.append({'name': entry.name, 'deprecated': True})
+        else:
+            families.append(entry.name)
+    return {'families': families}
+
+
+def registry_render(registry: spec.Registry) -> str:
+    body = yaml.dump(registry_build(registry), Dumper=_Dumper,
+                     sort_keys=False, default_flow_style=False, width=76)
+    return REGISTRY_HEADER + body
+
+
+def registry_problems(old: spec.Registry,
+                      current: spec.Registry) -> list[str]:
+    problems = []
+    for family_id, was in enumerate(old.entries):
+        if family_id >= len(current.entries):
+            problems.append(f'family ID {family_id} ({was.name}) was removed')
+            continue
+        now = current.entries[family_id]
+        if now.name != was.name:
+            problems.append(f'family ID {family_id} was {was.name}, now '
+                            f'{now.name}')
+        elif was.deprecated and not now.deprecated:
+            problems.append(f'family ID {family_id} ({was.name}) was reused '
+                            'after deprecation')
+    return problems
+
+
+# The comparison.
+
+def _compare(old: dict[str, Any], new: dict[str, Any],
+             replies: set[str]) -> list[str]:
+    problems = []
+    if old['family'] != new['family']:
+        problems.append(f'family was renamed from {old["family"]} to '
+                        f'{new["family"]}')
+    if old['family-id'] != new['family-id']:
+        problems.append(f'family-id was {old["family-id"]}, now '
+                        f'{new["family-id"]}')
+    # A name carries its ancestry, so reparenting renames every symbol.
+    if old['parent'] != new['parent']:
+        problems.append(f'the inherited family was {old["parent"]}, now '
+                        f'{new["parent"]}')
+    _compare_definitions(problems, old['definitions'], new['definitions'])
+    _compare_records(problems, old['records'], new['records'], replies)
+    _compare_extensions(problems, 'extension point', old['extensions'],
+                        new['extensions'])
+    _compare_extensions(problems, 'enum extension point',
+                        old['enum-extensions'], new['enum-extensions'])
+    _compare_fills(problems, old['fills'], new['fills'])
+    _compare_ops(problems, old['ops'], new['ops'])
+    return problems
+
+
+def _compare_definitions(problems: list[str], old: dict[str, dict[str, Any]],
+                         new: dict[str, dict[str, Any]]) -> None:
+    for name, was in old.items():
+        now = new.get(name)
+        if now is None:
+            problems.append(f'{was["kind"]} {name} was removed')
+            continue
+        where = f'{was["kind"]} {name}'
+        if now['kind'] != was['kind']:
+            problems.append(f'{where} is now a {now["kind"]} definition')
+        if 'header' in was or 'header' in now:
+            _compare_header(problems, where, was, now)
+            continue
+        for value, number in was['values'].items():
+            if value not in now['values']:
+                problems.append(f'{where}: value {value} was removed')
+            elif now['values'][value] != number:
+                problems.append(f'{where}: value {value} was {number}, now '
+                                f'{now["values"][value]}')
+
+
+def _compare_header(problems: list[str], where: str, was: dict[str, Any],
+                    now: dict[str, Any]) -> None:
+    """A header numbers its enum, so only its $end may change, to later."""
+    old, new = was.get('header'), now.get('header')
+    if old is None or new is None:
+        source = new or old
+        assert source is not None
+        problems.append(f'{where} {"now" if old is None else "no longer"} '
+                        f'takes its values from <{source["$header"]}>')
+        return
+    if (old['$header'], old['$enum']) != (new['$header'], new['$enum']):
+        problems.append(f'{where} was enum {old["$enum"]} of '
+                        f'<{old["$header"]}>, now enum {new["$enum"]} of '
+                        f'<{new["$header"]}>')
+        return
+    end = old.get('$end')
+    if end == new.get('$end'):
+        return
+    if end is None:
+        problems.append(f'{where}: $end {new["$end"]} leaves values out')
+    elif end not in now['values']:
+        problems.append(f'{where}: $end was {end}, and may only move later')
+
+
+def _compare_records(problems: list[str], old: dict[str, dict[str, Any]],
+                     new: dict[str, dict[str, Any]],
+                     replies: set[str]) -> None:
+    for path, was in old.items():
+        now = new.get(path)
+        where = f'record {path}'
+        if now is None:
+            problems.append(f'{where} was removed')
+            continue
+        if was['record-id'] != now['record-id']:
+            problems.append(f'{where}: ID was {was["record-id"]:#010x}, now '
+                            f'{now["record-id"]:#010x}')
+        reply = path in replies
+        for name, field_was in was['fields'].items():
+            field_now = now['fields'].get(name)
+            if field_now is None:
+                problems.append(f'field {path}.{name} was removed')
+                continue
+            _compare_field(problems, f'field {path}.{name}', field_was,
+                           field_now, reply)
+        for name, field_now in now['fields'].items():
+            if name not in was['fields'] and field_now['required']:
+                problems.append(f'{where}: new field {name} must be '
+                                'optional')
+        _compare_members(problems, where, was['members'], now['members'],
+                         reply)
+
+
+def _compare_field(problems: list[str], where: str, was: dict[str, Any],
+                   now: dict[str, Any], reply: bool) -> None:
+    for key in ('number', 'kind', 'definition', 'record', 'extension',
+                'unit', 'scale'):
+        if was.get(key) != now.get(key):
+            problems.append(f'{where}: {key} was {was.get(key)}, now '
+                            f'{now.get(key)}')
+    if now['required'] and not was['required']:
+        problems.append(f'{where} became required')
+    if reply and was['required'] and not now['required']:
+        problems.append(f'{where} became optional')
+    # The bounds of one schema kind say nothing about another's.
+    if was['kind'] != now['kind']:
+        return
+    for key in ('min', 'min-length'):
+        if key in was and now.get(key, 0) > was[key]:
+            problems.append(f'{where}: {key} was narrowed from '
+                            f'{_text(key, was[key])} to '
+                            f'{_text(key, now[key])}')
+    for key in ('max', 'max-length'):
+        if key in was and now.get(key, 0) < was[key]:
+            problems.append(f'{where}: {key} was narrowed from '
+                            f'{_text(key, was[key])} to '
+                            f'{_text(key, now[key])}')
+    _compare_occurrences(problems, where, was, now)
+    if 'blob' in was:
+        _compare_blob(problems, where, was['blob'], now.get('blob', {}))
+
+
+def _text(key: str, value: int) -> str:
+    return spec.size_text(value) if key in _LENGTHS else \
+        spec.number_text(value)
+
+
+def _compare_occurrences(problems: list[str], where: str, was: dict[str, Any],
+                         now: dict[str, Any]) -> None:
+    old_max = was['max-occurrences']
+    new_max = now['max-occurrences']
+    if old_max == new_max or new_max == spec.UNLIMITED:
+        return
+    # One enum's count only grows; another's, or a number, is not comparable.
+    if isinstance(old_max, str) or isinstance(new_max, str):
+        problems.append(f'{where}: max-occurrences was '
+                        f'{_occurrences(old_max)}, now '
+                        f'{_occurrences(new_max)}')
+    elif old_max == spec.UNLIMITED or new_max < old_max:
+        problems.append(f'{where}: max-occurrences was narrowed from '
+                        f'{_occurrences(old_max)} to {_occurrences(new_max)}')
+
+
+def _compare_blob(problems: list[str], where: str, was: dict[str, Any],
+                  now: dict[str, Any]) -> None:
+    for key in ('direction', 'alignment'):
+        if was.get(key) != now.get(key):
+            problems.append(f'{where}: blob {key} was {was.get(key)}, now '
+                            f'{now.get(key)}')
+    for backing in was.get('backings', []):
+        if backing not in now.get('backings', []):
+            problems.append(f'{where}: blob backing {backing} was removed')
+    if now.get('max-length', 0) < was.get('max-length', 0):
+        problems.append(f'{where}: blob max-length was narrowed from '
+                        f'{spec.size_text(was["max-length"])} to '
+                        f'{spec.size_text(now["max-length"])}')
+
+
+def _compare_members(problems: list[str], where: str, old: dict[str, bool],
+                     new: dict[str, bool], reply: bool) -> None:
+    for key, required in old.items():
+        if key not in new:
+            problems.append(f'{where}: {key} was removed')
+        elif new[key] and not required:
+            problems.append(f'{where}: {key} became required')
+        elif reply and required and not new[key]:
+            problems.append(f'{where}: {key} became optional')
+    for key, required in new.items():
+        if key not in old and required:
+            problems.append(f'{where}: new {key} must be optional')
+
+
+def _compare_extensions(problems: list[str], what: str, old: dict[str, int],
+                        new: dict[str, int]) -> None:
+    for name, ext_id in old.items():
+        if name not in new:
+            problems.append(f'{what} {name} was removed')
+        elif new[name] != ext_id:
+            problems.append(f'{what} {name}: ID was {ext_id}, now '
+                            f'{new[name]}')
+
+
+def _compare_fills(problems: list[str], old: dict[str, str],
+                   new: dict[str, str]) -> None:
+    for name, path in old.items():
+        if name not in new:
+            problems.append(f'extension fill {name} was removed')
+        elif new[name] != path:
+            problems.append(f'extension fill {name} was record {path}, now '
+                            f'{new[name]}')
+
+
+def _compare_ops(problems: list[str], old: dict[str, dict[str, Any]],
+                 new: dict[str, dict[str, Any]]) -> None:
+    for name, was in old.items():
+        now = new.get(name)
+        if now is None:
+            problems.append(f'op {name} was removed')
+            continue
+        where = f'op {name}'
+        # Whether an op may be disabled or withheld is what userspace compiles
+        # against; whether it is either right now is per device.
+        for key in ('op-id', 'type', 'fd-access',
+                    'availability', 'optional', 'pre-post'):
+            if was.get(key) != now.get(key):
+                problems.append(f'{where}: {key} was {was.get(key)}, now '
+                                f'{now.get(key)}')
+        for what in ('request', 'reply'):
+            if (what == 'reply' and was['type'] == 'action' and
+                    was[what] is None and now[what] is not None):
+                problems.append(f'{where}: an ACK-only action gained a '
+                                'reply schema')
+            elif was[what] is not None and now[what] is None:
+                problems.append(f'{where}: the {what} schema was removed')
+            elif was[what] is not None and was[what] != now[what]:
+                problems.append(f'{where}: the {what} was record '
+                                f'{was[what]}, now {now[what]}')
+
+
+def _occurrences(max_occurrences: int | str) -> str:
+    if max_occurrences == spec.UNLIMITED:
+        return 'unlimited'
+    return str(max_occurrences)
diff --git a/tools/ctlv/ctlvgen/lib/errors.py b/tools/ctlv/ctlvgen/lib/errors.py
new file mode 100644
index 000000000000..f6d557d90f38
--- /dev/null
+++ b/tools/ctlv/ctlvgen/lib/errors.py
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+"""The single error type reported by the CTLV schema tool."""
+
+from __future__ import annotations
+
+
+class CtlvError(Exception):
+    """A specification, registry or ABI snapshot is not acceptable.
+
+    The test suite matches diagnostics, so a message's wording is contract.
+    """
+
+    def __init__(self, where: str | None, what: str) -> None:
+        self.where = where
+        self.what = what
+        super().__init__(f'{where}: {what}' if where else what)
diff --git a/tools/ctlv/ctlvgen/lib/gen_family.py b/tools/ctlv/ctlvgen/lib/gen_family.py
new file mode 100644
index 000000000000..7ce96331803a
--- /dev/null
+++ b/tools/ctlv/ctlvgen/lib/gen_family.py
@@ -0,0 +1,285 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+"""The descriptor of one family: who answers each of its ops.
+
+One struct ctlv_family and one struct ctlv_op per action or query
+this family declares, plus the helpers a device uses to decide them. A family
+answers what it declared: an inherited op is answered through the descriptor
+of the family that declared it, by that family implementation.
+"""
+
+from __future__ import annotations
+
+from collections.abc import Iterable
+
+from . import cgen
+from . import semantics
+from . import spec
+
+# The instance, the request/reply, and a context for core helpers. A device
+# embeds the instance, so a callback reaches its state with container_of().
+CALLBACK_PARAMS: tuple[str, ...] = (
+    'struct ctlv *ctlv', 'struct ctlv_op_ctx *ctx',
+    'const struct ctlv_cursor *request', 'struct ctlv_cursor *reply')
+
+# What a hook takes, and what each half returns: a pre may refuse the op.
+HOOK_PARAMS: tuple[str, ...] = ('struct ctlv *ctlv',
+                                'struct ctlv_op_ctx *ctx')
+HOOK_RETURNS: tuple[tuple[str, str], ...] = (('pre', 'int'), ('post', 'void'))
+
+# The reply-side callback for an extension point.
+EXT_HOOKS: tuple[tuple[str, str, tuple[str, ...]], ...] = (
+    ('fill', 'int', ('struct ctlv *ctlv', 'struct ctlv_op_ctx *ctx',
+                     'const struct ctlv_cursor *request',
+                     'struct ctlv_cursor *record')),
+)
+
+# The state helpers of a dynamically available op.
+STATES: tuple[str, ...] = ('enable', 'disable')
+
+INPUT_MACROS: dict[str, str] = {
+    'uint': 'U64',
+    'sint': 'S64',
+    'bool': 'BOOL',
+    'string': 'STRING',
+    'binary': 'BINARY',
+    'enum': 'U64',
+    'flags': 'U64',
+    'record': 'RECORD',
+    'blob': 'BLOB',
+}
+
+PUT_MACROS: dict[str, str] = {
+    'uint': 'U64',
+    'sint': 'S64',
+    'bool': 'BOOL',
+    'string': 'STRING',
+    'binary': 'BINARY',
+    'enum': 'U64',
+    'flags': 'U64',
+}
+
+
+def bindings(family: semantics.Family) -> tuple[semantics.Op, ...]:
+    """The ops family binds, in the order it binds them.
+
+    Its own ops, in declaration order. An op it inherited is answered by the
+    family that declared it.
+    """
+    return tuple(family.local_ops)
+
+
+def _implementer(family: semantics.Family) -> str:
+    """Who writes the callbacks of a family."""
+    if family.name == spec.CORE_FAMILY_NAME:
+        return 'the CTLV core'
+    return 'this family'
+
+
+def _macro(writer: cgen.Writer, name: str, args: tuple[str, ...]) -> None:
+    writer.parenthesized(f'{name}(', args, ')')
+
+
+def emit_header(writer: cgen.Writer, names: cgen.Names,
+                family: semantics.Family) -> None:
+    """Append the family API to a generated kernel header."""
+    inputs, outputs = semantics.own_uses(family)
+    bound = bindings(family)
+    if bound:
+        writer.comment(f'Implemented by {_implementer(family)}, one per '
+                       'action and query it declares.')
+        for op in bound:
+            writer.signature('int', names.callback(op), CALLBACK_PARAMS)
+        writer.line()
+    _hooks(writer, names, family)
+    _ext_hooks(writer, names, family)
+    writer.declaration('extern const struct ctlv_family',
+                       f'{names.descriptor()};')
+    writer.line()
+    writer.line('#ifndef _CTLV_GENERATED_METADATA_ONLY')
+    _helpers(writer, names, family)
+    _readers(writer, names, inputs.values())
+    _writers(writer, names, outputs.values())
+    writer.line('#endif /* _CTLV_GENERATED_METADATA_ONLY */')
+    writer.line()
+
+
+def _hooks(writer: cgen.Writer, names: cgen.Names,
+           family: semantics.Family) -> None:
+    """The pair around one op, for each op that asked for one."""
+    marked = [op for op in bindings(family) if op.pre_post]
+    if not marked:
+        return
+    writer.comment('Per-op hooks inside the device pair.')
+    for first, op in enumerate(marked):
+        if first:
+            writer.line()
+        for which, returns in HOOK_RETURNS:
+            writer.signature(returns, names.op_hook(op, which), HOOK_PARAMS)
+    writer.line()
+
+
+def _ext_hooks(writer: cgen.Writer, names: cgen.Names,
+               family: semantics.Family) -> None:
+    """The fill and read callbacks of each extension point the family fills."""
+    for fill in family.fills:
+        owner = family.owners[fill.family_id]
+        writer.comment(f'{fill.name} of {owner}: fill callback.')
+        for which, returns, params in EXT_HOOKS:
+            writer.signature(returns, names.ext_callback(fill, which),
+                             params)
+        writer.line()
+
+
+def _helpers(writer: cgen.Writer, names: cgen.Names,
+             family: semantics.Family) -> None:
+    """What one device may decide about each op this family declares."""
+    ops = [op for op in family.local_ops
+           if op.optional or op.availability == 'dynamic']
+    if not ops:
+        return
+    writer.line()
+    writer.comment('Optional publication and dynamic availability helpers.')
+    for op in ops:
+        if op.optional:
+            _macro(writer, 'CTLV_OP_PROVIDE',
+                   (names.op_ident(op), names.op_id(op)))
+        if op.availability == 'dynamic':
+            for state in STATES:
+                _macro(writer, f'CTLV_OP_{state.upper()}',
+                       (names.op_ident(op), names.op_id(op)))
+
+
+def _readers(writer: cgen.Writer, names: cgen.Names,
+             fields: Iterable[semantics.Field]) -> None:
+    """What reads one field of a validated request, wherever it is placed.
+
+    A reader finds its field by type among the members of the record it is
+    handed.
+    """
+    fields = tuple(fields)
+    if not fields:
+        return
+    writer.line()
+    writer.comment('Reading a validated message. A blob has a resolver '
+                   'instead of a getter.')
+    for field in fields:
+        repeated = field.decl.max_occurrences != 1
+        name = names.field_ident(field)
+        writer.doc(field.decl.doc)
+        _macro(writer, 'CTLV_IN_REF',
+               (name, names.field(field), cgen.KINDS[field.decl.kind]))
+        if repeated:
+            _iterator(writer, names, field)
+        else:
+            _macro(writer, 'CTLV_IN_HAS', (name,))
+        if field.decl.kind == 'blob':
+            macro = 'CTLV_IN_' + ('EACH_' if repeated else '') + 'BLOB'
+            _macro(writer, macro, (name,))
+        elif cgen.getter_value(field):
+            macro = 'CTLV_IN_' + ('EACH_' if repeated else '') + \
+                    INPUT_MACROS[field.decl.kind]
+            _macro(writer, macro, (name,))
+
+
+def _writers(writer: cgen.Writer, names: cgen.Names,
+             fields: Iterable[semantics.Field]) -> None:
+    """What a callback appends to the reply it was handed.
+
+    One helper per field, returning whether its TLV made it into the message.
+    """
+    fields = tuple(field for field in fields
+                   if cgen.output_writers(names, field))
+    if not fields:
+        return
+    writer.line()
+    writer.comment('Writing a reply. An append is atomic; a record ends with '
+                   'ctlv_record_end().')
+    for field in fields:
+        if field.decl.kind == 'record':
+            macro = 'CTLV_RECORD_START'
+        else:
+            macro = f'CTLV_PUT_{PUT_MACROS[field.decl.kind]}'
+        writer.doc(field.decl.doc)
+        _macro(writer, macro,
+               (names.field_ident(field), names.field(field),
+                cgen.KINDS[field.decl.kind]))
+
+
+def _iterator(writer: cgen.Writer, names: cgen.Names,
+              field: semantics.Field) -> None:
+    """Every occurrence of a repeated field, in message order."""
+    writer.define_call(
+        f'{names.field_helper(field, "for_each")}(_cursor, _record)',
+        'CTLV_IN_FOR_EACH', names.field_ident(field), '_cursor', '_record')
+
+
+def emit_source(writer: cgen.Writer, names: cgen.Names,
+                family: semantics.Family) -> None:
+    """Append the family bindings to a generated kernel source."""
+    _bindings(writer, names, family)
+    _ext_ops(writer, names, family)
+    _descriptor(writer, names, family)
+
+
+def _bindings(writer: cgen.Writer, names: cgen.Names,
+              family: semantics.Family) -> None:
+    bound = bindings(family)
+    if not bound:
+        return
+    writer.comment('Local action and query bindings in declaration order.')
+    writer.declaration('static const struct ctlv_op',
+                       f'{names.ops()}[] = {{')
+    for op in bound:
+        suffix = '_PRE_POST' if op.pre_post else ''
+        writer.line(f'\tCTLV_OP_{op.type.upper()}{suffix}('
+                    f'{names.op_ident(op)}),')
+    writer.line('};')
+    writer.line()
+
+
+def _ext_ops(writer: cgen.Writer, names: cgen.Names,
+             family: semantics.Family) -> None:
+    """One entry per extension point this family fills, in the same order."""
+    if not family.fills:
+        return
+    writer.comment('Extension-point callbacks.')
+    writer.declaration('static const struct ctlv_ext_ops',
+                       f'{names.ext_ops()}[] = {{')
+    for fill in family.fills:
+        args = (cgen.family_const(family.owners[fill.family_id]),
+                names.extension(family.extensions[fill.name]),
+                names.ext_ident(fill))
+        writer.parenthesized('\tCTLV_EXT_OPS(', args, '),')
+    writer.line('};')
+    writer.line()
+
+
+def _descriptor(writer: cgen.Writer, names: cgen.Names,
+                family: semantics.Family) -> None:
+    if family.name == spec.CORE_FAMILY_NAME:
+        writer.comment('Root-family descriptor used by the CTLV core.')
+    else:
+        writer.comment('Family descriptor used by ctlv_init().')
+    writer.declaration('const struct ctlv_family',
+                       f'{names.descriptor()} = {{')
+    writer.line(f'\t.schema = &{names.schema()},')
+    parent = _parent_descriptor(family)
+    if parent:
+        writer.line(f'\t.parent = &{parent},')
+    if bindings(family):
+        writer.line(f'\t.ops = {names.ops()},')
+        writer.line(f'\t.ops_count = ARRAY_SIZE({names.ops()}),')
+    if family.fills:
+        ext_ops = names.ext_ops()
+        writer.line(f'\t.ext_ops = {ext_ops},')
+        writer.line(f'\t.ext_ops_count = ARRAY_SIZE({ext_ops}),')
+    writer.line('};')
+    # The one symbol an inheriting family's module needs of this one.
+    writer.line(f'EXPORT_SYMBOL_NS_GPL({names.descriptor()}, "CTLV");')
+
+
+def _parent_descriptor(family: semantics.Family) -> str | None:
+    """The direct parent descriptor, none only for the root family."""
+    if family.parent is None:
+        return None
+    return cgen.Names(family.chain[-2]).descriptor()
diff --git a/tools/ctlv/ctlvgen/lib/gen_kernel.py b/tools/ctlv/ctlvgen/lib/gen_kernel.py
new file mode 100644
index 000000000000..f4721013693c
--- /dev/null
+++ b/tools/ctlv/ctlvgen/lib/gen_kernel.py
@@ -0,0 +1,576 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+"""The kernel metadata of one family.
+
+Each family describes only what it declares. Each op request and reply becomes
+one flat, breadth-first array of struct ctlv_node_schema the core walks by
+index.
+"""
+
+from __future__ import annotations
+
+import dataclasses
+import re
+
+from . import cgen
+from . import gen_family
+from . import semantics
+from . import spec
+
+
+def root_macro(*names: str) -> str:
+    """Return a constant of the root family's generated UAPI header."""
+    return cgen.macro(spec.CORE_FAMILY_NAME, *names)
+
+
+FD_ACCESSES: dict[str, str] = {access: root_macro('op-fd-access', access)
+                               for access in spec.FD_ACCESSES}
+
+AVAILABILITIES: dict[str, str] = {
+    availability: root_macro('op-availability', availability)
+    for availability in spec.AVAILABILITIES
+}
+
+# Lengths that have to fit the inline message limit.
+INLINE_FIELDS: tuple[str, ...] = (
+    'request_max_len', 'action_reply_max_len', 'query_reply_min_len',
+    'query_reply_suggested_len')
+
+# The limits a spec writes by name, as <linux/limits.h> spells them.
+LIMITS: dict[int, str] = {value: cgen.macro(name)
+                          for name, value in spec.NAMED_NUMBERS.items()}
+
+_USES_LIMITS: re.Pattern[str] = re.compile(
+    r'\b[SU](?:8|16|32|64)_(?:MIN|MAX)\b')
+_USES_SIZES: re.Pattern[str] = re.compile(r'\bSZ_[0-9]+[KMG]\b')
+
+
+@dataclasses.dataclass(frozen=True)
+class FlatNode:
+    """One node of a flattened tree, with its children as an index range."""
+
+    node: semantics.Node
+    first_child: int
+    children_count: int
+    required_children_count: int
+
+
+def flatten(root: semantics.Node) -> tuple[FlatNode, ...]:
+    """Return the nodes of one tree breadth first, the root first.
+
+    A re-entering node points back at nodes already laid out, which is what
+    keeps the array finite.
+    """
+    flat = []
+    levels: dict[str, tuple[int, int, int]] = {}
+    queue = [(root, levels)]
+    next_index = 1
+    while queue:
+        node, levels = queue.pop(0)
+        if node.reenters is not None:
+            first_child, children_count, required_count = levels[node.reenters]
+            flat.append(FlatNode(node=node, first_child=first_child,
+                                 children_count=children_count,
+                                 required_children_count=required_count))
+            continue
+        children = node.children()
+        level = (next_index if children else 0, len(children),
+                 len(node.required_children))
+        flat.append(FlatNode(node=node, first_child=level[0],
+                             children_count=level[1],
+                             required_children_count=level[2]))
+        next_index += len(children)
+        if node.expands:
+            levels = levels | {node.expands: level}
+        queue += [(child, levels) for child in children]
+    return tuple(flat)
+
+
+def ext_schemas(
+        root: semantics.Node) -> tuple[tuple[int, semantics.Extension], ...]:
+    """Return each extension point schema with the node index it joins."""
+    schemas = []
+    for index, flat in enumerate(flatten(root)):
+        for extension in flat.node.extensions:
+            schemas.append((index, extension))
+    return tuple(schemas)
+
+
+def render_header(family: semantics.Family, *, family_api: bool) -> str:
+    """Return one family's generated kernel header."""
+    names = cgen.Names(family)
+    cgen.symbols(family)
+    guard = names.kernel_guard()
+    local = family.local_ops
+
+    writer = cgen.preamble(family, 'kernel', 'header')
+    what = 'Kernel metadata and family API' if family_api else \
+           'Schema metadata'
+    writer.comment(f'{what} of the {family.name} CTLV family.')
+    writer.line()
+    writer.open_guard(guard)
+    writer.includes(*_header_includes(family, names, family_api))
+
+    _extensions(writer, names, family)
+    if local:
+        writer.comment('Ops this family declares, in declaration order.')
+        writer.declaration('extern const struct ctlv_op_schema',
+                           f'{names.op_schemas()}[];')
+        writer.line()
+    writer.declaration('extern const struct ctlv_family_schema',
+                       f'{names.schema()};')
+    writer.line()
+    _message_decls(writer, names, family)
+    if family_api:
+        gen_family.emit_header(writer, names, family)
+    writer.close_guard(guard)
+    return writer.text()
+
+
+def _extensions(writer: cgen.Writer, names: cgen.Names,
+                family: semantics.Family) -> None:
+    """The ID of each extension point this family declares."""
+    own = family.local_extensions
+    if own:
+        writer.comment('Extension points, as a descendant\'s fill names '
+                       'one.')
+        for extension in own:
+            writer.define(names.extension(extension), str(extension.ext_id))
+        writer.line()
+    enums = family.local_enum_extensions
+    if enums:
+        writer.comment('Enum extension points, numbered apart from the '
+                       'others.')
+        for enum_extension in enums:
+            writer.define(names.enum_extension(enum_extension),
+                          str(enum_extension.ext_id))
+        writer.line()
+
+
+def _message_decls(writer: cgen.Writer, names: cgen.Names,
+                   family: semantics.Family) -> None:
+    """The messages the core builds itself, and the room each one needs."""
+    for message in family.messages:
+        writer.comment(f'The {message.name} message, built by the core.')
+        writer.define(names.message_max_len(message), str(message.max_len))
+        writer.line()
+        writer.declaration('extern const struct ctlv_schema_tree',
+                           f'{names.message_schema(message)};')
+        writer.line()
+
+
+def _header_includes(family: semantics.Family, names: cgen.Names,
+                     family_api: bool) -> tuple[str, ...]:
+    """The generated types, constants and direct parent API."""
+    headers = ['<linux/ctlv_family.h>']
+    parent = []
+    if family.parent not in (None, spec.CORE_FAMILY_NAME):
+        # Its extension IDs, which this family's fills name.
+        parent = ['', cgen.Names(family.chain[-2]).kernel_header()]
+    if not family_api:
+        return tuple(headers + parent)
+    headers += ['<linux/err.h>', '<linux/errno.h>', '',
+                names.uapi_header(in_kernel=True)]
+    return tuple(headers + parent)
+
+
+def render_source(family: semantics.Family, *, family_api: bool) -> str:
+    """Return one family's generated kernel source."""
+    names = cgen.Names(family)
+    cgen.symbols(family)
+    trees = _trees(family)
+
+    body = cgen.Writer()
+    for op, which, root in trees:
+        _node_schemas(body, family, names, names.node_schemas(op, which),
+                      root)
+        _ext_schemas(body, names, op, which, root)
+    _ext_fill_schemas(body, family, names)
+    _enum_fill_schemas(body, family, names)
+    _messages(body, family, names)
+    _table(body, names, family)
+    _descriptor(body, names, family)
+    _uevent(body, family)
+    _limits(body, family, trees)
+    if family_api:
+        if family.local_ops:
+            body.line()
+        gen_family.emit_source(body, names, family)
+    text = body.text()
+
+    writer = cgen.preamble(family, 'kernel', 'source')
+    if family_api:
+        writer.line('#define _CTLV_GENERATED_METADATA_ONLY')
+    writer.includes(*_includes(names, family, family_api, text))
+    return f'{writer.text()}\n{text}'
+
+
+_Tree = tuple[semantics.Op, str, semantics.Node]
+
+
+def _trees(family: semantics.Family) -> list[_Tree]:
+    """Every tree of every local op, in the order they are emitted."""
+    trees = []
+    for op in family.local_ops:
+        if op.request is not None:
+            trees.append((op, 'request', op.request))
+        if op.reply is not None:
+            trees.append((op, 'reply', op.reply))
+    return trees
+
+
+def _roots(family: semantics.Family,
+           trees: list[_Tree]) -> list[semantics.Node]:
+    """Every emitted tree root: an op's, a fill's and a core message's."""
+    return [root for _, _, root in trees] + \
+           [fill.root for fill in family.fills] + \
+           [message.root for message in family.messages]
+
+
+def _includes(names: cgen.Names, family: semantics.Family, family_api: bool,
+              body: str) -> list[str]:
+    headers = ['<linux/array_size.h>', '<linux/build_bug.h>',
+               '<linux/ctlv_family.h>']
+    if family_api:
+        headers.append('<linux/export.h>')
+    # The root family's enums name op types, availabilities and blob backings.
+    uapi = [cgen.uapi_header(spec.CORE_FAMILY_NAME, in_kernel=True)]
+    if family.name != spec.CORE_FAMILY_NAME:
+        uapi.append(names.uapi_header(in_kernel=family_api))
+    if 'BIT(' in body:
+        # The mask of permitted blob backings.
+        headers.append('<linux/bits.h>')
+    if _USES_LIMITS.search(body):
+        headers.append('<linux/limits.h>')
+    if _USES_SIZES.search(body):
+        headers.append('<linux/sizes.h>')
+    groups = [sorted(headers), uapi, [names.kernel_header()]]
+    lines: list[str] = []
+    for group in groups:
+        if not group:
+            continue
+        if lines:
+            lines.append('')
+        lines += group
+    return lines
+
+
+def _node_schemas(writer: cgen.Writer, family: semantics.Family,
+                  names: cgen.Names, symbol: str,
+                  root: semantics.Node) -> None:
+    writer.declaration('static const struct ctlv_node_schema',
+                       f'{symbol}[] = {{')
+    for flat in flatten(root):
+        _node(writer, family, names, flat)
+    writer.line('};')
+    writer.line()
+
+
+def _node(writer: cgen.Writer, family: semantics.Family, names: cgen.Names,
+          flat: FlatNode) -> None:
+    macro, args = _node_initializer(family, names, flat)
+    if macro == 'CTLV_NODE_SCHEMA_BLOB':
+        _blob_node(writer, macro, args)
+    else:
+        writer.parenthesized(f'\t{macro}(', args, '),')
+
+
+def _blob_node(writer: cgen.Writer, macro: str, args: tuple[str, ...]) -> None:
+    opening = f'\t{macro}('
+
+    for line in cgen.wrapped(opening, args[:4], ','):
+        writer.line(line)
+    column = cgen.width(opening)
+    indent = '\t' * (column // cgen.TAB_WIDTH) + \
+        ' ' * (column % cgen.TAB_WIDTH)
+    backings = args[4].split(' | ')
+    for backing in backings[:-1]:
+        writer.line(f'{indent}{backing} |')
+    writer.line(f'{indent}{backings[-1]},')
+    writer.line(f'{indent}{args[5]}),')
+
+
+def _node_initializer(family: semantics.Family, names: cgen.Names,
+                      flat: FlatNode) -> tuple[str, tuple[str, ...]]:
+    node = flat.node
+
+    if node.is_root:
+        return 'CTLV_NODE_SCHEMA_ROOT', (
+            str(flat.first_child),
+            str(flat.children_count),
+            str(flat.required_children_count),
+        )
+
+    decl = node.child_field.decl
+    kind = cgen.KINDS[decl.kind].removeprefix('CTLV_SCHEMA_')
+    macro = f'CTLV_NODE_SCHEMA_{kind}'
+    occurrences = str(node.max_occurrences) if node.max_occurrences else \
+        'CTLV_NODE_SCHEMA_UNLIMITED'
+    args = [names.field(node.child_field), occurrences]
+    if decl.kind == 'record':
+        if node.reenters is not None:
+            macro += '_REENTERS'
+        args += [str(flat.first_child), str(flat.children_count),
+                 str(flat.required_children_count)]
+    else:
+        if decl.kind in ('uint', 'sint') and decl.unit is not None:
+            macro += '_UNIT'
+        if decl.kind == 'enum':
+            assert decl.ref is not None
+            definition = family.definitions[decl.ref]
+            if definition.header:
+                macro += '_RANGE'
+            elif definition.extension is not None:
+                macro += '_EXT'
+        args += _constraint_args(family, names, decl)
+    return macro, tuple(args)
+
+
+def _ext_schemas(writer: cgen.Writer, names: cgen.Names, op: semantics.Op,
+                 which: str, root: semantics.Node) -> None:
+    """The extension points of one tree, by the node they widen."""
+    schemas = ext_schemas(root)
+    if not schemas:
+        return
+    writer.comment('Extension points selected by this tree.')
+    writer.declaration('static const struct ctlv_ext_schema',
+                       f'{names.ext_schemas(op, which)}[] = {{')
+    for index, extension in schemas:
+        macro = 'CTLV_EXT_SCHEMA_OPTIONAL' if extension.optional else \
+            'CTLV_EXT_SCHEMA'
+        args = (cgen.family_const(names.effective.owners[extension.family_id]),
+                names.extension(extension), str(index))
+        writer.parenthesized(f'\t{macro}(', args, '),')
+    writer.line('};')
+    writer.line()
+
+
+def _ext_fill_schemas(writer: cgen.Writer, family: semantics.Family,
+                      names: cgen.Names) -> None:
+    """The members this family puts into the extension points it inherited."""
+    if not family.fills:
+        return
+    for fill in family.fills:
+        _node_schemas(writer, family, names,
+                      names.fill_node_schemas(fill), fill.root)
+    writer.comment('The extension points this family fills.')
+    writer.declaration('static const struct ctlv_ext_fill_schema',
+                       f'{names.ext_fill_schemas()}[] = {{')
+    for fill in family.fills:
+        extension = family.extensions[fill.name]
+        args = (cgen.family_const(family.owners[fill.family_id]),
+                names.extension(extension), cgen.ident(fill.name))
+        writer.parenthesized('\tCTLV_EXT_FILL_SCHEMA(', args, '),')
+    writer.line('};')
+    writer.line()
+
+
+def _enum_fill_schemas(writer: cgen.Writer, family: semantics.Family,
+                       names: cgen.Names) -> None:
+    """How many values this family gives each enum extension point."""
+    fills = family.enum_fills
+    if not fills:
+        return
+    writer.comment('The enum extension points this family fills.')
+    writer.declaration('static const struct ctlv_enum_fill_schema',
+                       f'{names.enum_fill_schemas()}[] = {{')
+    for fill in fills:
+        assert fill.extension is not None
+        args = (cgen.family_const(family.owners[fill.extension.family_id]),
+                names.enum_extension(fill.extension), str(fill.max_value))
+        writer.parenthesized('\tCTLV_ENUM_FILL_SCHEMA(', args, '),')
+    writer.line('};')
+    writer.line()
+
+
+def _messages(writer: cgen.Writer, family: semantics.Family,
+              names: cgen.Names) -> None:
+    """The messages the core builds where no op declared one."""
+    for message in family.messages:
+        _node_schemas(writer, family, names,
+                      names.message_node_schemas(message), message.root)
+        writer.declaration('const struct ctlv_schema_tree',
+                           f'{names.message_schema(message)} = {{')
+        node_schemas = names.message_node_schemas(message)
+        writer.line(f'\t.node_schemas = {node_schemas},')
+        writer.line('\t.node_schemas_count =')
+        writer.line(f'\t\tARRAY_SIZE({node_schemas}),')
+        writer.line('};')
+        writer.line()
+        writer.assertion(names.message_max_len(message), '<=', message.limit)
+        writer.line()
+
+
+def _constraint_args(family: semantics.Family, names: cgen.Names,
+                     decl: spec.FieldDecl) -> list[str]:
+    """The schema kind's arguments of one node-schema macro."""
+    if decl.kind in ('uint', 'sint'):
+        assert decl.min is not None and decl.max is not None
+        args = [_bound(decl.kind, decl.min), _bound(decl.kind, decl.max)]
+        if decl.unit is not None:
+            args += [f'CTLV_UNIT_{cgen.macro(decl.unit)}', str(decl.scale)]
+        return args
+    if decl.kind == 'enum':
+        assert decl.ref is not None
+        definition = family.definitions[decl.ref]
+        if definition.header:
+            return list(cgen.header_bounds(definition))
+        if definition.extension is not None:
+            extension = definition.extension
+            owner = names.effective.owners[extension.family_id]
+            return [cgen.family_const(owner),
+                    names.enum_extension(extension)]
+        return [str(max(definition.numbers()))]
+    if decl.kind == 'flags':
+        assert decl.ref is not None
+        return [names.value_mask(family.definitions[decl.ref])]
+    if decl.kind in ('string', 'binary'):
+        assert decl.min_length is not None and decl.max_length is not None
+        return [_length(decl.min_length), _length(decl.max_length)]
+    if decl.kind == 'blob':
+        assert decl.blob is not None
+        return _blob_args(decl.blob)
+    return []
+
+
+def _bound(kind: str, value: int) -> str:
+    """One integer bound, a limit by the name the spec gives it."""
+    if value in LIMITS:
+        return LIMITS[value]
+    if kind == 'uint' and value > spec.S64_MAX:
+        return f'{value}ULL'
+    return str(value)
+
+
+def _length(value: int) -> str:
+    """One byte count, as <linux/sizes.h> spells a power of two."""
+    # Its largest G name is SZ_512G.
+    if 1 << 10 <= value <= 1 << 39 and not value & (value - 1):
+        return f'SZ_{spec.size_text(value)}'
+    if value in (spec.U32_MAX, spec.U64_MAX):
+        return LIMITS[value]
+    if value > spec.S64_MAX:
+        return f'{value}ULL'
+    return str(value)
+
+
+def _blob_args(blob: spec.BlobDecl) -> list[str]:
+    direction = root_macro('blob-direction', blob.direction)
+    return [_length(blob.max_length), _length(blob.alignment),
+            _backings(blob.backings), direction]
+
+
+def _backings(backings: tuple[str, ...]) -> str:
+    terms = [f'BIT({root_macro("blob-type", backing)})'
+             for backing in backings]
+    return ' | '.join(terms)
+
+
+def _table(writer: cgen.Writer, names: cgen.Names,
+           family: semantics.Family) -> None:
+    local = family.local_ops
+    if not local:
+        return
+    writer.comment('The ops this family declares, in declaration order.')
+    writer.declaration('const struct ctlv_op_schema',
+                       f'{names.op_schemas()}[] = {{')
+    for op in local:
+        macro, args = _op_schema_initializer(names, op)
+        writer.parenthesized(f'\t{macro}(', args, '),')
+    writer.line('};')
+    writer.line()
+
+
+def _op_schema_initializer(names: cgen.Names,
+                           op: semantics.Op) -> tuple[str, tuple[str, ...]]:
+    sizes = op.sizes
+    if op.type == 'action':
+        macro = 'CTLV_OP_SCHEMA_ACTION'
+        args = [names.op_id(op), FD_ACCESSES[op.fd_access],
+                AVAILABILITIES[op.availability],
+                str(sizes.request_max_len),
+                str(sizes.action_reply_max_len),
+                _op_tree(op, 'request'), _op_tree(op, 'reply')]
+    else:
+        macro = 'CTLV_OP_SCHEMA_QUERY'
+        args = [names.op_id(op), FD_ACCESSES[op.fd_access],
+                AVAILABILITIES[op.availability],
+                str(sizes.request_max_len),
+                str(sizes.query_reply_min_len),
+                str(sizes.query_reply_suggested_len),
+                _op_tree(op, 'request'), _op_tree(op, 'reply')]
+    if op.optional:
+        args.append('.optional = true')
+    if op.pre_post:
+        args.append('.pre_post = true')
+    return macro, tuple(args)
+
+
+def _op_tree(op: semantics.Op, which: str) -> str:
+    root = getattr(op, which)
+    if root is None:
+        return 'CTLV_SCHEMA_TREE_NONE()'
+    macro = 'CTLV_SCHEMA_TREE_EXTS' if ext_schemas(root) else \
+        'CTLV_SCHEMA_TREE'
+    return f'{macro}({cgen.ident(op.name, which)})'
+
+
+def _descriptor(writer: cgen.Writer, names: cgen.Names,
+                family: semantics.Family) -> None:
+    """This family's node of the schema graph."""
+    writer.comment('The family ID is its position in the central registry.')
+    writer.declaration('const struct ctlv_family_schema',
+                       f'{names.schema()} = {{')
+    writer.line(f'\t.name = "{family.name}",')
+    writer.line(f'\t.family_id = {family.family_id},')
+    if family.local_ops:
+        writer.line(f'\t.ops = {names.op_schemas()},')
+        writer.line(f'\t.ops_count = ARRAY_SIZE({names.op_schemas()}),')
+    if family.fills:
+        ext_fill_schemas = names.ext_fill_schemas()
+        writer.line(f'\t.ext_fill_schemas = {ext_fill_schemas},')
+        writer.line(f'\t.ext_fill_schemas_count = '
+                    f'ARRAY_SIZE({ext_fill_schemas}),')
+    if family.enum_fills:
+        enum_fill_schemas = names.enum_fill_schemas()
+        writer.line(f'\t.enum_fill_schemas = {enum_fill_schemas},')
+        writer.line(f'\t.enum_fill_schemas_count = '
+                    f'ARRAY_SIZE({enum_fill_schemas}),')
+    writer.line('};')
+    writer.line()
+
+
+def _uevent(writer: cgen.Writer, family: semantics.Family) -> None:
+    """What this chain's names cost a device's uevent environment."""
+    names = [item.name for item in family.chain]
+    variables = [f'CTLV_FAMILY={names[-1]}']
+    variables += [f'CTLV_COMPATIBLE_{index}={name}'
+                  for index, name in enumerate(names)]
+    variables.append(f'CTLV_COMPATIBLE_N={len(names)}')
+    # "KEY=value" plus the NUL, as add_uevent_var() charges it.
+    writer.comment('Maximum uevent cost for this family chain.')
+    writer.line(f'static_assert({sum(len(item) + 1 for item in variables)} <= '
+                'CTLV_UEVENT_MAX_LEN);')
+    writer.line(f'static_assert({len(variables)} <= CTLV_UEVENT_MAX_VARS);')
+    writer.line()
+
+
+def _limits(writer: cgen.Writer, family: semantics.Family,
+            trees: list[tuple[semantics.Op, str, semantics.Node]]) -> None:
+    local = family.local_ops
+    if not local:
+        return
+    writer.comment('Guards for generated maxima.')
+    inline = max(getattr(op.sizes, field)
+                 for op in local for field in INLINE_FIELDS)
+    writer.line(f'static_assert({inline} <= CTLV_MAX_INLINE_MESSAGE_LEN);')
+    depth = max(_record_depth(root) for root in _roots(family, trees))
+    if depth:
+        writer.line(f'static_assert({depth} <= '
+                    'CTLV_MAX_DECLARED_RECORD_DEPTH);')
+
+
+def _record_depth(node: semantics.Node) -> int:
+    """Deepest record below node, which is itself at depth zero."""
+    depths = [1 + _record_depth(child) for child in node.children()
+              if child.child_field.decl.kind == 'record']
+    return max(depths, default=0)
diff --git a/tools/ctlv/ctlvgen/lib/gen_uapi.py b/tools/ctlv/ctlvgen/lib/gen_uapi.py
new file mode 100644
index 000000000000..25f9a21d0feb
--- /dev/null
+++ b/tools/ctlv/ctlvgen/lib/gen_uapi.py
@@ -0,0 +1,182 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+"""The UAPI header of one family.
+
+Names for numbers: the type of every field and the ID of every op, complete,
+enum values, flag bits and units. The message format is the transport
+header's. An inherited declaration is not repeated, already having a name in
+the header of the family that owns it.
+"""
+
+from __future__ import annotations
+
+import textwrap
+from collections.abc import Iterable
+
+from . import cgen
+from . import semantics
+from . import spec
+
+
+def render(family: semantics.Family) -> str:
+    """Return the UAPI header of family as text."""
+    names = cgen.Names(family)
+    cgen.symbols(family)
+    guard = names.uapi_guard()
+
+    writer = cgen.preamble(family, 'uapi', 'header')
+    _file_comment(writer, family)
+    writer.line()
+    writer.open_guard(guard)
+    writer.includes(*_includes(family))
+
+    _definitions(writer, family, names)
+    _records(writer, family, names)
+    _ops(writer, family, names)
+
+    writer.close_guard(guard)
+    return writer.text()
+
+
+def render_families(registry: spec.Registry) -> str:
+    """Return the family-number header of one registry."""
+    guard = '_UAPI_CTLV_CTLV_FAMILIES_GEN_H'
+    values = [(cgen.family_const(entry.name), family_id, None)
+              for family_id, entry in enumerate(registry.entries)]
+    writer = cgen.preamble(registry, 'uapi', 'header', registry.path)
+
+    writer.comment('CTLV family numbers.')
+    writer.line()
+    writer.open_guard(guard)
+    _numbered_enum(writer, '_ctlv_family', values)
+    writer.line()
+    writer.close_guard(guard)
+    return writer.text()
+
+
+def _includes(family: semantics.Family) -> list[str]:
+    headers = ['<ctlv/ctlv.h>', cgen.families_uapi_header()]
+    if family.parent:
+        # Inherited constants live in the parent's header, so one include is
+        # enough for the whole effective schema.
+        headers.append(cgen.uapi_header(family.parent))
+    own = family.local_definitions
+    if any(definition.kind == 'flags' for definition in own):
+        # _BITULL(), which is the form of BIT_ULL() that userspace has.
+        headers.append('<linux/const.h>')
+    headers += [f'<{definition.header.path}>' for definition in own
+                if definition.header]
+    return sorted(set(headers))
+
+
+def _file_comment(writer: cgen.Writer, family: semantics.Family) -> None:
+    paragraphs = [
+        f'Constants of the {family.name} CTLV family. Types and op IDs are '
+        'complete; the message format carrying them is in <ctlv/ctlv.h>.',
+    ]
+    if family.parent:
+        paragraphs.append(
+            f'The inherited {family.parent} header is included here, so one '
+            'include covers the whole effective schema.')
+    lines: list[str] = []
+    for paragraph in paragraphs:
+        if lines:
+            lines.append('')
+        lines += textwrap.wrap(paragraph, cgen.COMMENT_WIDTH,
+                               break_on_hyphens=False)
+    writer.comment(*lines)
+
+
+def _definitions(writer: cgen.Writer, family: semantics.Family,
+                 names: cgen.Names) -> None:
+    for definition in family.local_definitions:
+        if definition.header or definition.is_extension_point:
+            continue
+        if definition.kind == 'enum':
+            _enum(writer, names, definition)
+        else:
+            _flags(writer, names, definition)
+        writer.line()
+
+
+def _enum(writer: cgen.Writer, names: cgen.Names,
+          definition: semantics.Definition) -> None:
+    if definition.extension is not None:
+        owner = names.effective.owners[definition.extension.family_id]
+        writer.comment(f'enum {definition.name}, an extension point of '
+                       f'{owner}')
+    else:
+        writer.comment(f'enum {definition.name}')
+    values = [(names.value(definition, value_name), number, doc)
+              for (value_name, number), doc in zip(definition.values,
+                                                   definition.value_docs)]
+    _numbered_enum(writer, names.definition(definition), values)
+
+
+def _flags(writer: cgen.Writer, names: cgen.Names,
+           definition: semantics.Definition) -> None:
+    writer.comment(f'flags {definition.name}')
+    bits = [(names.value_bit(definition, value_name), bit, None)
+            for value_name, bit in definition.values]
+    _numbered_enum(writer, names.bit_enum(definition), bits)
+    writer.line()
+    values = []
+    for (value_name, _bit), doc in zip(definition.values,
+                                       definition.value_docs):
+        value = names.value(definition, value_name)
+        writer.doc(doc)
+        writer.define(value,
+                      f'_BITULL({names.value_bit(definition, value_name)})')
+        values.append(value)
+    _flags_mask(writer, names.value_mask(definition), values)
+
+
+def _records(writer: cgen.Writer, family: semantics.Family,
+             names: cgen.Names) -> None:
+    """One #define per field, under the record that holds it."""
+    for record in family.local_records:
+        if not record.fields:
+            continue
+        writer.comment(record.path)
+        for field in record.fields:
+            writer.doc(field.decl.doc)
+            writer.define_block(
+                names.field(field),
+                f'\tCTLV_TYPE({names.family_const()}, '
+                f'{record.record_id:#010x}, {field.number})')
+            if field.decl.unit is not None:
+                writer.define(names.field_unit(field),
+                              f'CTLV_UNIT_{cgen.macro(field.decl.unit)}')
+                writer.define(names.field_scale(field), str(field.decl.scale))
+        writer.line()
+
+
+def _numbered_enum(writer: cgen.Writer, name: str,
+                   values: Iterable[tuple[str, int, str | None]]) -> None:
+    # Every member says its value, so that none moves with its neighbours.
+    writer.line(f'enum {name} {{')
+    for value, number, doc in values:
+        writer.doc(doc, '\t')
+        writer.line(f'\t{value} = {number},')
+    writer.line('};')
+
+
+def _flags_mask(writer: cgen.Writer, name: str, values: list[str]) -> None:
+    if len(values) == 1:
+        writer.define(name, values[0])
+        return
+    lines = [f'\t({values[0]} |']
+    lines += [f'\t {value} |' for value in values[1:-1]]
+    lines.append(f'\t {values[-1]})')
+    writer.define_block(name, *lines)
+
+
+def _ops(writer: cgen.Writer, family: semantics.Family,
+         names: cgen.Names) -> None:
+    own = family.local_ops
+    if not own:
+        return
+    writer.comment('ops')
+    for op in own:
+        writer.define_call(names.op_id(op), 'CTLV_OP', names.family_const(),
+                           str(op.local_id))
+    writer.line()
diff --git a/tools/ctlv/ctlvgen/lib/outputs.py b/tools/ctlv/ctlvgen/lib/outputs.py
new file mode 100644
index 000000000000..a295055c46b2
--- /dev/null
+++ b/tools/ctlv/ctlvgen/lib/outputs.py
@@ -0,0 +1,355 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+"""The complete set of generated files and its reconciliation."""
+
+from __future__ import annotations
+
+import dataclasses
+import os
+import pathlib
+import subprocess
+import tempfile
+from collections.abc import Callable, Mapping
+from typing import Optional
+
+from . import cgen
+from . import gen_kernel
+from . import gen_uapi
+from . import semantics
+from . import spec
+from . import yamlload
+from .errors import CtlvError
+
+
+FLAVOURS: dict[str, Callable[..., str]] = {
+    'uapi-header': gen_uapi.render,
+    'kernel-header': gen_kernel.render_header,
+    'kernel-source': gen_kernel.render_source,
+}
+
+IDENTITIES: dict[str, tuple[str, str, str]] = {
+    'uapi-header': ('uapi', 'header', '.h'),
+    'kernel-header': ('kernel', 'header', '.h'),
+    'kernel-source': ('kernel', 'source', '.c'),
+}
+
+ROOT_FLAVOURS = frozenset(FLAVOURS)
+FAMILY_FLAVOURS: frozenset[str] = frozenset(FLAVOURS)
+FIXTURE_FLAVOURS: frozenset[str] = frozenset({
+    'uapi-header', 'kernel-header', 'kernel-source',
+})
+
+
+@dataclasses.dataclass(frozen=True)
+class Output:
+    family: str | None
+    source: pathlib.PurePosixPath
+    registry: pathlib.PurePosixPath
+    flavour: str
+    path: pathlib.PurePosixPath
+
+
+def _spec_paths(paths: spec.Paths, source: pathlib.PurePosixPath,
+                registry: pathlib.PurePosixPath) -> spec.Paths:
+    return spec.Paths(paths.kernel_dir / source, schema=paths.schema,
+                      registry=paths.kernel_dir / registry)
+
+
+def _relative(where: str, value: str) -> pathlib.PurePosixPath:
+    path = pathlib.PurePosixPath(value)
+    if path.is_absolute() or '..' in path.parts or \
+            any(part.startswith('.') for part in path.parts) or \
+            str(path) != value:
+        raise CtlvError(where, f'"{value}" is not a normalized relative path')
+    return path
+
+
+def _repository_path(paths: spec.Paths,
+                     path: pathlib.Path) -> pathlib.PurePosixPath:
+    return pathlib.PurePosixPath(
+        pathlib.Path(path).relative_to(paths.kernel_dir).as_posix())
+
+
+_Context = tuple[pathlib.Path, pathlib.PurePosixPath, pathlib.PurePosixPath,
+                 Optional[list[str]], bool]
+
+
+def _manifest_contexts(paths: spec.Paths) -> tuple[_Context, ...]:
+    fixtures_dir = paths.kernel_dir / 'tools/ctlv/tests/specs'
+    contexts: list[_Context] = [
+        (paths.generated, _repository_path(paths, paths.registry),
+         _repository_path(paths, paths.spec_dir), None, False),
+    ]
+    manifest = fixtures_dir.parent / 'generated-files.yaml'
+    if manifest.exists():
+        fixtures = sorted(path.stem for path in fixtures_dir.glob('*.yaml'))
+        contexts.append((
+            manifest,
+            _repository_path(paths, fixtures_dir.parent / 'families.yaml'),
+            _repository_path(paths, fixtures_dir), fixtures, True))
+    return tuple(contexts)
+
+
+def load(paths: spec.Paths) -> tuple[Output, ...]:
+    """Load and validate every generated-file manifest."""
+    outputs = []
+    families = set()
+    destinations = set()
+    for manifest, expected_registry, source_dir, expected_names, fixture in \
+            _manifest_contexts(paths):
+        data = yamlload.load(manifest)
+        spec._validate_syntax(manifest, data, paths.generated_schema)
+        registry_record = data['registry']
+        where = f'{manifest}: registry'
+        registry_source = _relative(where, registry_record['source'])
+        if registry_source != expected_registry:
+            raise CtlvError(where, f'source is {registry_source}, expected '
+                                   f'{expected_registry}')
+        registry = spec.load_registry(
+            paths, paths.kernel_dir / registry_source)
+        if expected_names is None:
+            expected_names = [entry.name for entry in registry.entries]
+        records = data['families']
+        if [record['name'] for record in records] != expected_names:
+            raise CtlvError(str(manifest),
+                            'manifest families do not match their sources')
+
+        for flavour, value in registry_record['outputs'].items():
+            destination = _relative(f'{where} {flavour}', value)
+            suffix = IDENTITIES[flavour][2]
+            if destination.suffix != suffix:
+                raise CtlvError(f'{where} {flavour}',
+                                f'output must end in {suffix}')
+            if destination in destinations:
+                raise CtlvError(f'{where} {flavour}',
+                                f'duplicate output path {destination}')
+            destinations.add(destination)
+            outputs.append(Output(None, registry_source, registry_source,
+                                  flavour, destination))
+
+        for record in records:
+            name = record['name']
+            where = f'{manifest}: family {name}'
+            if name in families:
+                raise CtlvError(where, 'duplicate family')
+            families.add(name)
+
+            expected_source = source_dir / f'{name}.yaml'
+            source = _relative(where, record['source'])
+            if source != expected_source:
+                raise CtlvError(where, f'source is {source}, expected '
+                                       f'{expected_source}')
+
+            required = FIXTURE_FLAVOURS if fixture else FAMILY_FLAVOURS
+            if not fixture and name == spec.CORE_FAMILY_NAME:
+                required = ROOT_FLAVOURS
+            flavours = frozenset(record['outputs'])
+            if flavours != required:
+                missing = sorted(required - flavours)
+                extra = sorted(flavours - required)
+                detail = []
+                if missing:
+                    detail.append(f'missing {", ".join(missing)}')
+                if extra:
+                    detail.append(f'unexpected {", ".join(extra)}')
+                raise CtlvError(where, '; '.join(detail))
+
+            family = semantics.load(
+                _spec_paths(paths, source, registry_source))
+            if family.name != name:
+                raise CtlvError(where, f'source declares family '
+                                       f'{family.name}')
+            for flavour, value in record['outputs'].items():
+                destination = _relative(f'{where} {flavour}', value)
+                suffix = IDENTITIES[flavour][2]
+                if destination.suffix != suffix:
+                    raise CtlvError(f'{where} {flavour}',
+                                    f'output must end in {suffix}')
+                if destination in destinations:
+                    raise CtlvError(f'{where} {flavour}',
+                                    f'duplicate output path {destination}')
+                destinations.add(destination)
+                outputs.append(Output(name, source, registry_source, flavour,
+                                      destination))
+    return tuple(outputs)
+
+
+def render(paths: spec.Paths,
+           plan: tuple[Output, ...]) -> dict[pathlib.PurePosixPath, str]:
+    """Render every planned output before any destination is changed."""
+    families: dict[tuple[pathlib.PurePosixPath, pathlib.PurePosixPath],
+                   semantics.Family] = {}
+    rendered = {}
+    registered_registry = _repository_path(paths, paths.registry)
+    for output in plan:
+        source = _output_source(output)
+        if output.family is None:
+            registry = spec.load_registry(
+                paths, paths.kernel_dir / output.registry)
+            text = gen_uapi.render_families(registry)
+        else:
+            key = (output.source, output.registry)
+            family = families.get(key)
+            if family is None:
+                family = semantics.load(
+                    _spec_paths(paths, output.source, output.registry))
+                families[key] = family
+            renderer = FLAVOURS[output.flavour]
+            if output.flavour in ('kernel-header', 'kernel-source'):
+                text = renderer(
+                    family, family_api=output.registry == registered_registry)
+            else:
+                text = renderer(family)
+        mode, file, _ = IDENTITIES[output.flavour]
+        if _identity(text) != (source, mode, file):
+            raise CtlvError(str(output.path),
+                            'generator emitted the wrong output marker')
+        rendered[output.path] = text
+    return rendered
+
+
+def _output_source(output: Output) -> str:
+    return output.source.as_posix()
+
+
+def _marked_files(root: pathlib.Path) -> set[str]:
+    if (root / '.git').exists():
+        result = subprocess.run(
+            ['git', 'grep', '--untracked', '--files-with-matches',
+             'CTLV-GEN', '--', '*.c', '*.h', '*.rst'],
+            cwd=root, capture_output=True, text=True, check=False)
+        if result.returncode not in (0, 1):
+            raise CtlvError(str(root), result.stderr.strip())
+        candidates = (root / line for line in result.stdout.splitlines())
+    else:
+        candidates = (path for suffix in ('*.c', '*.h', '*.rst')
+                      for path in root.rglob(suffix))
+
+    marked = set()
+    for path in candidates:
+        if path.is_symlink() or not path.is_file():
+            continue
+        text = path.read_text(encoding='utf-8', errors='replace')
+        if _identity(text) is not None:
+            marked.add(path.relative_to(root).as_posix())
+    return marked
+
+
+def _destination(root: pathlib.Path,
+                 relative: pathlib.PurePosixPath) -> pathlib.Path:
+    destination = root.joinpath(*relative.parts)
+    if destination.is_symlink():
+        raise CtlvError(str(destination),
+                        'generated output cannot be a symlink')
+    parent = destination.parent
+    while parent != root and not parent.exists():
+        parent = parent.parent
+    if parent.is_symlink() or root.resolve() not in (
+            parent.resolve(), *parent.resolve().parents):
+        raise CtlvError(str(destination),
+                        'generated output escapes its output root')
+    return destination
+
+
+def _replace(destination: pathlib.Path, text: str) -> None:
+    destination.parent.mkdir(parents=True, exist_ok=True)
+    fd, temporary = tempfile.mkstemp(dir=destination.parent,
+                                     prefix=f'.{destination.name}.')
+    try:
+        with os.fdopen(fd, 'w', encoding='utf-8') as stream:
+            stream.write(text)
+        os.chmod(temporary, 0o644)
+        os.replace(temporary, destination)
+    finally:
+        if os.path.exists(temporary):
+            os.unlink(temporary)
+
+
+def _source(line: str, prefix: str) -> str | None:
+    """The spec a 'Generated from <spec> by' line names, or None."""
+    if not line.startswith(prefix) or not line.endswith(' by'):
+        return None
+    return line[len(prefix):-len(' by')]
+
+
+def _identity(text: str) -> tuple[str | None, str, str] | None:
+    """The source, mode and file a generated file's preamble names."""
+    lines = text.splitlines()
+    if len(lines) < 6:
+        return None
+    c_spdx = (lines[0].startswith('// SPDX-License-Identifier: ') or
+              (lines[0].startswith('/* SPDX-License-Identifier: ') and
+               lines[0].endswith(' */')))
+    if c_spdx and lines[1] == '/*' and \
+            _source(lines[2], ' * Generated from ') and \
+            lines[3] == f' * {cgen.REGEN}. Do not edit.' and \
+            lines[4] == ' */' and \
+            lines[5].startswith('/* CTLV-GEN ') and lines[5].endswith(' */'):
+        source = _source(lines[2], ' * Generated from ')
+        fields = lines[5][3:-3].split()
+    elif lines[0].startswith('.. SPDX-License-Identifier: ') and \
+            _source(lines[1], '.. Generated from ') and \
+            lines[2] == f'   {cgen.REGEN}. Do not edit.' and \
+            lines[3].startswith('.. CTLV-GEN '):
+        source = _source(lines[1], '.. Generated from ')
+        fields = lines[3][3:].split()
+    else:
+        return None
+    if len(fields) == 3 and fields[0] == 'CTLV-GEN':
+        return source, fields[1], fields[2]
+    return None
+
+
+def reconcile(paths: spec.Paths, output_root: pathlib.Path | str | None = None,
+              check: bool = False,
+              extra: Mapping[pathlib.PurePosixPath, str] | None = None
+              ) -> tuple[str, ...]:
+    """Check or atomically update every generated output.
+
+    extra are files without a marker, checked and written with the rest.
+    """
+    plan = load(paths)
+    rendered = render(paths, plan)
+    rendered.update(extra or {})
+    root = pathlib.Path(paths.kernel_dir if output_root is None
+                        else output_root)
+    if not root.is_dir():
+        raise CtlvError(str(root), 'output root is not a directory')
+    expected = {output.path.as_posix() for output in plan}
+    unexpected = sorted(_marked_files(root) - expected)
+    if unexpected:
+        raise CtlvError('generated outputs',
+                        'unexpected files\n' +
+                        '\n'.join(f'  {path}' for path in unexpected))
+
+    states = {}
+    problems = []
+    unsafe = []
+    by_path = {output.path: output for output in plan}
+    for relative, text in rendered.items():
+        destination = _destination(root, relative)
+        if not destination.exists():
+            problems.append(f'missing {relative}')
+            states[relative] = (destination, text)
+            continue
+        if not destination.is_file():
+            raise CtlvError(str(destination),
+                            'generated output is not a regular file')
+        current = destination.read_text(encoding='utf-8')
+        if current == text:
+            continue
+        problems.append(f'stale {relative}')
+        output = by_path.get(relative)
+        if output is not None and not check:
+            mode, file, _ = IDENTITIES[output.flavour]
+            if _identity(current) != (_output_source(output), mode, file):
+                unsafe.append(f'{relative} is not the planned generated file')
+        states[relative] = (destination, text)
+    if unsafe:
+        raise CtlvError('generated outputs',
+                        'refusing to overwrite files\n' +
+                        '\n'.join(f'  {problem}' for problem in unsafe))
+    if check and problems:
+        raise CtlvError('generated outputs', '\n'.join(problems))
+    for destination, text in states.values():
+        _replace(destination, text)
+    return tuple(problems)
diff --git a/tools/ctlv/ctlvgen/lib/semantics.py b/tools/ctlv/ctlvgen/lib/semantics.py
new file mode 100644
index 000000000000..86725e7c1d69
--- /dev/null
+++ b/tools/ctlv/ctlvgen/lib/semantics.py
@@ -0,0 +1,1219 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+"""The effective form of a CTLV family.
+
+The specifications of one inheritance chain resolved into one schema: a type
+for every field from where it is declared, every record composed of its own
+fields and what it places and includes, and one tree per op request and reply.
+A rule enforced here is not re-enforced downstream.
+"""
+
+from __future__ import annotations
+
+import dataclasses
+from collections.abc import Iterable
+from typing import TypeVar
+
+from . import sizes
+from . import spec
+from .errors import CtlvError
+
+MAX_FLAG_BITS: int = 64
+
+# These root enums are stored more narrowly than a generic enum range.
+ROOT_ENUM_VALUES_MAX: dict[str, int] = {
+    'op-type': spec.U8_MAX,
+    'op-availability': spec.U8_MAX,
+    'op-fd-access': spec.U8_MAX,
+    'blob-direction': spec.U8_MAX,
+    # BIT(value) is stored in struct ctlv_node_schema.blob.backings.
+    'blob-type': 15,
+}
+
+# Type kinds, bits 47..46 of a type, as enum ctlv_type_kind has them.
+TYPE_KIND_NAMED: int = 0
+TYPE_KIND_REQUEST: int = 2
+TYPE_KIND_REPLY: int = 3
+TYPE_KINDS: dict[str, int] = {
+    'named': TYPE_KIND_NAMED, 'field': TYPE_KIND_NAMED,
+    'request': TYPE_KIND_REQUEST, 'reply': TYPE_KIND_REPLY,
+}
+
+# What the 64 bits of a type hold room for.
+MAX_RECORD_INDEX: int = (1 << 14) - 1
+MAX_UNNAMED_DEPTH: int = 4
+MAX_UNNAMED_PEERS: int = 15
+MAX_FIELD_NUMBER: int = spec.U16_MAX
+
+
+def _check_count(where: str, what: str, count: int, maximum: int) -> None:
+    if count > maximum:
+        raise CtlvError(where, f'{count} {what} exceed the {maximum} maximum')
+
+
+def record_id(role: str, index: int) -> int:
+    """The record of a type: its type kind, then its index."""
+    return (TYPE_KINDS[role] << 30) | (index << 16)
+
+
+def type_of(family_id: int, record: int, number: int) -> int:
+    return (family_id << 48) | (record << 16) | number
+
+
+@dataclasses.dataclass(frozen=True)
+class EnumExtension:
+    """An enum extension point, whose values one descendant family gives."""
+
+    name: str
+    family_id: int
+    ext_id: int
+
+
+@dataclasses.dataclass(frozen=True)
+class Definition:
+    """An effective enum or flags definition, value_docs in values' order.
+
+    extension is set on an enum extension point, which has no values, and on
+    the enum filling it, which belongs to the family that fills it.
+    """
+
+    name: str
+    kind: str
+    family_id: int
+    values: tuple[tuple[str, int], ...]
+    value_docs: tuple[str | None, ...]
+    header: spec.HeaderEnum | None = None
+    doc: str | None = None
+    extension: EnumExtension | None = None
+
+    def numbers(self) -> tuple[int, ...]:
+        return tuple(number for _, number in self.values)
+
+    @property
+    def is_extension_point(self) -> bool:
+        return (self.extension is not None and
+                self.extension.family_id == self.family_id)
+
+    @property
+    def is_fill(self) -> bool:
+        return (self.extension is not None and
+                self.extension.family_id != self.family_id)
+
+    @property
+    def max_value(self) -> int:
+        """The highest value, 0 for an extension point nothing filled."""
+        return max(self.numbers(), default=0)
+
+
+@dataclasses.dataclass(frozen=True)
+class Field:
+    """A field, with its complete TLV type.
+
+    record is the name of the record declaring it, which its constant and
+    helpers take; shared marks a field of records:, which takes its own.
+    full_name says where it is, and holds is the path of the record it holds.
+    """
+
+    record: str
+    name: str
+    family_id: int
+    record_id: int
+    number: int
+    type: int
+    decl: spec.FieldDecl
+    full_name: str
+    shared: bool = False
+    holds: str | None = None
+
+    @property
+    def c_name(self) -> str:
+        return self.name if self.shared else f'{self.record}-{self.name}'
+
+
+@dataclasses.dataclass(frozen=True)
+class Member:
+    """A field as one record has it: its own, placed or included."""
+
+    field: Field
+    required: bool
+    doc: str | None = None
+
+
+@dataclasses.dataclass(frozen=True)
+class Record:
+    """A named record, a field of records:, an op's request or reply root,
+    or an unnamed record inside one of them.
+
+    role says which: named, field, request, reply or unnamed. path is
+    unique, name is what constants and helpers take. fields are the ones
+    declared here, members the whole record.
+    """
+
+    name: str
+    family_id: int
+    record_id: int
+    role: str
+    path: str
+    fields: tuple[Field, ...]
+    members: tuple[Member, ...]
+    doc: str | None = None
+
+
+@dataclasses.dataclass(frozen=True)
+class Extension:
+    """An extension point, which one descendant family's record fills."""
+
+    name: str
+    family_id: int
+    ext_id: int
+    optional: bool = False
+
+
+@dataclasses.dataclass(frozen=True)
+class Fill:
+    """The record one family puts into an extension point it inherited.
+
+    root stands for the extension point, so its children are what splices in.
+    """
+
+    name: str
+    owner_family_id: int
+    family_id: int
+    ext_id: int
+    root: Node
+    record: Record
+
+
+@dataclasses.dataclass(frozen=True)
+class Node:
+    """One node of an expanded op tree. The root has no field.
+
+    extensions are the extension points this record holds. A recursive record
+    becomes a node naming its record in expands and childless nodes below it
+    naming it in reenters, so walking children terminates.
+    """
+
+    field: Field | None
+    required: bool
+    max_occurrences: int
+    required_children: tuple[Node, ...]
+    optional_children: tuple[Node, ...]
+    extensions: tuple[Extension, ...] = ()
+    expands: str | None = None
+    reenters: str | None = None
+
+    @property
+    def is_root(self) -> bool:
+        return self.field is None
+
+    @property
+    def child_field(self) -> Field:
+        """The field of a node below the root, which every one has."""
+        assert self.field is not None
+        return self.field
+
+    def children(self) -> tuple[Node, ...]:
+        return self.required_children + self.optional_children
+
+
+@dataclasses.dataclass(frozen=True)
+class Message:
+    """One message root that no op declares, built by the core unasked.
+
+    Only the root family declares one.
+    """
+
+    name: str
+    family_id: int
+    record_id: int
+    root: Node
+    max_len: int
+    limit: str
+
+
+@dataclasses.dataclass(frozen=True)
+class Op:
+    """An effective op.
+
+    availability is the permission to enable and disable the op per device,
+    not a state. optional means a device has the op only once its family opts
+    in. pre_post asks for a pair of this op's own, inside the one the device
+    puts around every op.
+    """
+
+    name: str
+    type: str
+    fd_access: str
+    availability: str
+    optional: bool
+    pre_post: bool
+    family_id: int
+    local_id: int
+    op_id: int
+    request: Node | None
+    reply: Node | None
+    sizes: sizes.OpSizes
+    doc: str | None = None
+    request_record: Record | None = None
+    reply_record: Record | None = None
+
+
+_Owned = TypeVar('_Owned', Definition, Record, Field, Extension,
+                 EnumExtension, Op)
+
+
+@dataclasses.dataclass(frozen=True)
+class Family:
+    """One effective family: itself plus everything it inherits.
+
+    owners maps a family ID to its name for every family in the chain. fills
+    is what a generator emits, chain_fills what a device answers with.
+    """
+
+    name: str
+    family_id: int
+    path: str
+    chain: tuple[spec.FamilySpec, ...]
+    owners: dict[int, str]
+    definitions: dict[str, Definition]
+    records: dict[str, Record]
+    fields: dict[str, Field]
+    extensions: dict[str, Extension]
+    ops: tuple[Op, ...]
+    fills: tuple[Fill, ...]
+    chain_fills: tuple[Fill, ...]
+    messages: tuple[Message, ...]
+    enum_extensions: dict[str, EnumExtension] = dataclasses.field(
+        default_factory=dict)
+
+    @property
+    def parent(self) -> str | None:
+        return self.chain[-1].inherits
+
+    @property
+    def license(self) -> str:
+        return self.chain[-1].license
+
+    @property
+    def doc(self) -> str | None:
+        return self.chain[-1].doc
+
+    def _local(self, items: Iterable[_Owned]) -> tuple[_Owned, ...]:
+        return tuple(item for item in items
+                     if item.family_id == self.family_id)
+
+    @property
+    def local_definitions(self) -> tuple[Definition, ...]:
+        return self._local(self.definitions.values())
+
+    @property
+    def local_records(self) -> tuple[Record, ...]:
+        return self._local(self.records.values())
+
+    @property
+    def local_fields(self) -> tuple[Field, ...]:
+        return self._local(self.fields.values())
+
+    @property
+    def local_extensions(self) -> tuple[Extension, ...]:
+        return self._local(self.extensions.values())
+
+    @property
+    def local_enum_extensions(self) -> tuple[EnumExtension, ...]:
+        return self._local(self.enum_extensions.values())
+
+    @property
+    def enum_fills(self) -> tuple[Definition, ...]:
+        """The enum extension points this family fills, as it fills them."""
+        return tuple(definition for definition in self.local_definitions
+                     if definition.is_fill)
+
+    @property
+    def local_ops(self) -> tuple[Op, ...]:
+        return self._local(self.ops)
+
+    def fill_of(self, extension: Extension) -> Fill | None:
+        """What this chain put into one extension point, if anything did."""
+        for fill in self.chain_fills:
+            if (fill.family_id, fill.ext_id) == (extension.family_id,
+                                                 extension.ext_id):
+                return fill
+        return None
+
+
+def field_uses(family: Family, family_ids: set[int] | None = None
+               ) -> tuple[dict[int, Field], dict[int, Field]]:
+    """The fields read in a request and written in a reply.
+
+    Two dicts by type, in the order the fields are met, over the ops and
+    fills of the families in family_ids, the whole chain by default.
+    """
+    ids = set(family.owners) if family_ids is None else set(family_ids)
+    inputs: dict[int, Field] = {}
+    outputs: dict[int, Field] = {}
+
+    def walk(node: Node, found: dict[int, Field]) -> None:
+        for child in node.children():
+            found.setdefault(child.child_field.type, child.child_field)
+            walk(child, found)
+        for extension in node.extensions:
+            fill = family.fill_of(extension)
+            if fill is not None and fill.owner_family_id in ids:
+                walk(fill.root, found)
+
+    for op in family.ops:
+        if op.family_id not in ids:
+            continue
+        if op.request is not None:
+            walk(op.request, inputs)
+        if op.reply is not None:
+            walk(op.reply, outputs)
+    for message in family.messages:
+        if message.family_id in ids:
+            walk(message.root, outputs)
+    return inputs, outputs
+
+
+def own_uses(family: Family) -> tuple[dict[int, Field], dict[int, Field]]:
+    """The uses this family adds to its parent's, which it has helpers for.
+
+    A helper is named after the family declaring the field, and emitted by
+    the first family of the chain whose ops or fills read or write it.
+    """
+    inputs, outputs = field_uses(family)
+    parent_inputs, parent_outputs = field_uses(
+        family, set(family.owners) - {family.family_id})
+    return ({key: field for key, field in inputs.items()
+             if key not in parent_inputs},
+            {key: field for key, field in outputs.items()
+             if key not in parent_outputs})
+
+
+def load(paths: spec.Paths) -> Family:
+    """Load the family at paths.spec, resolved against its whole chain."""
+    registry = spec.load_registry(paths)
+    return _Resolver(paths, registry).resolve()
+
+
+class _Resolver:
+    def __init__(self, paths: spec.Paths, registry: spec.Registry) -> None:
+        self.paths = paths
+        self.registry = registry
+        self.definitions: dict[str, Definition] = {}
+        self.records: dict[str, Record] = {}
+        # Named records and fields of records:, by name, and where each is.
+        self.named: dict[str, Record] = {}
+        self.declared: dict[str, tuple[int, str, int, spec.RecordSpec]] = {}
+        self.fields: dict[str, Field] = {}
+        self.c_names: dict[tuple[int, str], Field] = {}
+        self.extensions: dict[str, Extension] = {}
+        self.enum_extensions: dict[str, EnumExtension] = {}
+        self.fill_records: dict[str, Record] = {}
+        self.fillers: dict[str, str] = {}
+        # Where each extension point sits: message, context, record level.
+        self.sites: dict[str, list[tuple[str, str, int]]] = {}
+        self.ops: list[Op] = []
+        self.used: set[str] = set()
+        self.building: tuple[str, ...] = ()
+
+    def resolve(self) -> Family:
+        chain = self._load_chain()
+        self._check_names(chain)
+        self._check_order(chain)
+        target = chain[-1]
+        for family in chain:
+            family_id = self._family_id(family)
+            self._add_definitions(family, family_id, family.enums, 'enum')
+            self._add_definitions(family, family_id, family.flags, 'flags')
+            self._add_records(family, family_id)
+            self._add_ops(family, family_id)
+            self._check_used(family, family_id)
+        fills = self._fills(target)
+        chain_fills = self._fills(None)
+        self._check_fills(chain_fills)
+        _check_count(f'{target.path}: family {target.name}',
+                     'extension fills', len(fills), spec.U32_MAX)
+        records = sorted(self.records.values(), key=_record_order)
+        resolved = Family(
+            name=target.name,
+            family_id=self._family_id(target),
+            path=target.path,
+            chain=chain,
+            owners={self._family_id(item): item.name for item in chain},
+            definitions=self.definitions,
+            records={record.path: record for record in records},
+            fields=self.fields,
+            extensions=self.extensions,
+            ops=tuple(self.ops),
+            fills=fills,
+            chain_fills=chain_fills,
+            messages=self._messages(target),
+            enum_extensions=self.enum_extensions,
+        )
+        _check_composed(resolved)
+        _check_docs(target)
+        return resolved
+
+    def _messages(self, family: spec.FamilySpec) -> tuple[Message, ...]:
+        """The message roots this family declares that no op uses.
+
+        The root family alone has them, and has to have them.
+        """
+        messages = []
+        for name in sizes.CORE_MESSAGES:
+            record = self.named.get(name)
+            if record is None or record.role != 'named':
+                if family.name != spec.CORE_FAMILY_NAME:
+                    continue
+                raise CtlvError(f'{family.path}: family {family.name}',
+                                f'the root family has to declare the "{name}" '
+                                'record, which the core builds a message of')
+            if record.family_id != self._family_id(family):
+                continue
+            where = self.declared[name][1]
+            root = self._root(record.members, where, ())
+            if _extensions_anywhere(root):
+                raise CtlvError(where, 'a message the core builds cannot '
+                                       'hold an extension point')
+            self._check_subtree(where, root, 'message')
+            _check_tree_size(where, root)
+            messages.append(Message(
+                name=name,
+                family_id=record.family_id,
+                record_id=record.record_id,
+                root=root,
+                max_len=sizes.message_max_len(where, name, root),
+                limit=sizes.CORE_MESSAGES[name][0],
+            ))
+        return tuple(messages)
+
+    def _error_info_max_len(self) -> int:
+        """The longest error information the core builds, 0 without one."""
+        record = self.named.get(sizes.ERROR_INFO)
+        if record is None:
+            return 0
+        where = self.declared[record.name][1]
+        root = self._root(record.members, where, ())
+        self._check_subtree(where, root, 'message')
+        return sizes.root_max_len(root)
+
+    def _fills(self, family: spec.FamilySpec | None) -> tuple[Fill, ...]:
+        """The extension points one family fills, with what it puts in each.
+
+        Passing None asks for the fills of the whole chain.
+        """
+        fills = []
+        for name, filler in self.fillers.items():
+            if family is not None and filler != family.name:
+                continue
+            extension = self.extensions[name]
+            record = self.fill_records[name]
+            where = self.declared[name][1]
+            root = self._root(record.members, where, ())
+            _check_tree_size(where, root)
+            if _reenters_anywhere(root):
+                raise CtlvError(where, 'a fill cannot re-enter a record')
+            owner_family_id = self.registry.family_id(filler)
+            assert owner_family_id is not None
+            fills.append(Fill(
+                name=name,
+                owner_family_id=owner_family_id,
+                family_id=extension.family_id,
+                ext_id=extension.ext_id,
+                root=root,
+                record=record,
+            ))
+        return tuple(fills)
+
+    # Loading and identity
+
+    def _load_chain(self) -> tuple[spec.FamilySpec, ...]:
+        family = spec.load(self.paths.spec, self.paths.schema)
+        if self.paths.spec.stem != family.name:
+            raise CtlvError(f'{family.path}: family {family.name}',
+                            'a specification must be named after its family, '
+                            f'so this file must be {family.name}.yaml')
+        chain = [family]
+        seen = [family.name]
+        self._check_root(family)
+        while chain[0].inherits:
+            parent_name = chain[0].inherits
+            child = chain[0]
+            if parent_name in seen:
+                # seen runs from the selected family to its ancestors.
+                raise CtlvError(f'{child.path}: family {child.name}',
+                                'inheritance cycle: ' +
+                                ' -> '.join(seen + [parent_name]))
+            parent_path = self.paths.sibling_spec(parent_name)
+            parent = spec.load(parent_path, self.paths.schema)
+            if parent.name != parent_name:
+                raise CtlvError(f'{parent_path}: family {parent.name}',
+                                f'expected family {parent_name}')
+            self._check_root(parent)
+            seen.append(parent_name)
+            chain.insert(0, parent)
+        return tuple(chain)
+
+    def _check_root(self, family: spec.FamilySpec) -> None:
+        """Require every family but the root one to name what it inherits."""
+        if family.name == spec.CORE_FAMILY_NAME:
+            if family.inherits:
+                raise CtlvError(f'{family.path}: family {family.name}',
+                                'the root family heads every chain, so it '
+                                'inherits nothing')
+        elif not family.inherits:
+            raise CtlvError(f'{family.path}: family {family.name}',
+                            'must name the family it inherits, which is the '
+                            f'root {spec.CORE_FAMILY_NAME} for a family '
+                            'directly below it')
+
+    def _check_names(self, chain: tuple[spec.FamilySpec, ...]) -> None:
+        """Require every child family name to carry its whole ancestry."""
+        for parent, child in zip(chain, chain[1:]):
+            suffix = child.name.removeprefix(f'{parent.name}-')
+            if not suffix or suffix == child.name:
+                raise CtlvError(f'{child.path}: family {child.name}',
+                                f'a family that inherits {parent.name} must '
+                                f'be named {parent.name}-<suffix>')
+
+    def _check_order(self, chain: tuple[spec.FamilySpec, ...]) -> None:
+        """Require a parent to be registered before what inherits it.
+
+        Ascending positions let the core walk a chain once and index it.
+        """
+        for parent, child in zip(chain, chain[1:]):
+            if self._family_id(parent) >= self._family_id(child):
+                raise CtlvError(f'{child.path}: family {child.name}',
+                                f'is registered before {parent.name}, the '
+                                'family it inherits')
+
+    def _family_id(self, family: spec.FamilySpec) -> int:
+        family_id = self.registry.family_id(family.name)
+        if family_id is None:
+            raise CtlvError(f'{family.path}: family {family.name}',
+                            f'not registered in {self.registry.path}')
+        return family_id
+
+    # Definitions
+
+    def _add_definitions(self, family: spec.FamilySpec, family_id: int,
+                         definitions: tuple[spec.ValueList, ...],
+                         kind: str) -> None:
+        for definition in definitions:
+            where = f'{family.path}: {kind} {definition.name}'
+            existing = self.definitions.get(definition.name)
+            if (existing is not None and existing.is_extension_point and
+                    kind == 'enum'):
+                self._fill_enum(definition, family_id, existing, where)
+                continue
+            if existing is not None:
+                owner = self._owner_name(existing.family_id)
+                if existing.is_fill:
+                    raise CtlvError(where, 'enum extension point '
+                                           f'{definition.name} was already '
+                                           f'filled by family {owner}')
+                raise CtlvError(where, f'{definition.name} is already '
+                                       f'declared by {owner}')
+            if definition.extension:
+                self._enum_extension(definition, family_id, where)
+                continue
+            if kind == 'flags' and len(definition.values) > MAX_FLAG_BITS:
+                raise CtlvError(where, f'more than {MAX_FLAG_BITS} flag bits')
+            if kind == 'enum':
+                _check_count(where, 'enum values', len(definition.values),
+                             spec.U32_MAX)
+                if family_id == spec.CORE_FAMILY_ID:
+                    maximum = ROOT_ENUM_VALUES_MAX.get(definition.name)
+                    if maximum is not None:
+                        _check_count(where, 'enum values',
+                                     len(definition.values), maximum)
+            # Enum values from one, zero being reserved, unless a header
+            # numbers them; flag bits from zero.
+            first = 1 if kind == 'enum' else 0
+            values = tuple((value.name, first + index
+                            if value.number is None else value.number)
+                           for index, value in enumerate(definition.values))
+            self.definitions[definition.name] = Definition(
+                definition.name, kind, family_id, values,
+                tuple(value.doc for value in definition.values),
+                definition.header, definition.doc)
+
+    def _enum_extension(self, definition: spec.ValueList, family_id: int,
+                        where: str) -> None:
+        if family_id == spec.CORE_FAMILY_ID:
+            raise CtlvError(where, 'the root family has no extension points')
+        ext_id = 1 + sum(point.family_id == family_id
+                         for point in self.enum_extensions.values())
+        _check_count(where, 'enum extension points', ext_id, spec.U32_MAX)
+        extension = EnumExtension(definition.name, family_id, ext_id)
+        self.enum_extensions[definition.name] = extension
+        self.definitions[definition.name] = Definition(
+            definition.name, 'enum', family_id, (), (), None, definition.doc,
+            extension)
+
+    def _fill_enum(self, definition: spec.ValueList, family_id: int,
+                   point: Definition, where: str) -> None:
+        """Give an inherited enum extension point its values."""
+        if definition.extension:
+            owner = self._owner_name(point.family_id)
+            raise CtlvError(where, f'enum extension point {definition.name} '
+                                   f'is declared by {owner}; a further one '
+                                   'needs a new name')
+        if definition.header:
+            raise CtlvError(where, 'a fill numbers its own values, which a '
+                                   'header cannot')
+        _check_count(where, 'enum values', len(definition.values),
+                     spec.U32_MAX)
+        self.definitions[definition.name] = Definition(
+            definition.name, 'enum', family_id,
+            tuple((value.name, 1 + index)
+                  for index, value in enumerate(definition.values)),
+            tuple(value.doc for value in definition.values), None,
+            definition.doc, point.extension)
+
+    def _definition(self, decl: spec.FieldDecl) -> spec.FieldDecl:
+        """Resolve a field naming an enum or flags into which one it is, and
+        a count naming an enum into one occurrence per value."""
+        if decl.count_enum is not None:
+            decl = dataclasses.replace(decl,
+                                       max_occurrences=self._count(decl))
+        if decl.kind != 'definition':
+            return decl
+        assert decl.ref is not None
+        definition = self.definitions.get(decl.ref)
+        if definition is None:
+            raise CtlvError(decl.where, f'"{decl.ref}" is not a schema kind, '
+                                        'an enum or flags')
+        return dataclasses.replace(decl, kind=definition.kind)
+
+    def _count(self, decl: spec.FieldDecl) -> int:
+        name = decl.count_enum
+        assert name is not None
+        definition = self.definitions.get(name)
+        if definition is None or definition.kind != 'enum':
+            raise CtlvError(decl.where, f'count {name} is not an enum')
+        if definition.is_extension_point:
+            raise CtlvError(decl.where, f'count {name} is an enum extension '
+                                        'point, whose values a descendant '
+                                        'family gives')
+        return len(definition.values)
+
+    # Records
+
+    def _owner_name(self, family_id: int) -> str:
+        return self.registry.entries[family_id].name
+
+    def _add_records(self, family: spec.FamilySpec, family_id: int) -> None:
+        where = f'{family.path}: family {family.name}'
+        _check_count(where, 'named records', len(family.records),
+                     MAX_RECORD_INDEX)
+        own = []
+        for index, record in enumerate(family.records, start=1):
+            self._check_new_record(record)
+            self.declared[record.name] = (family_id, record.where, index,
+                                          record)
+            own.append(record.name)
+        self.used = set()
+        for name in own:
+            self._named(name, None)
+        for name in own:
+            if name in self.extensions and name not in self.fillers:
+                self._fill(family, name)
+
+    def _check_new_record(self, record: spec.RecordSpec) -> None:
+        name = record.name
+        extension = self.extensions.get(name)
+        if extension is not None:
+            if name in self.fillers:
+                raise CtlvError(record.where, 'extension point was already '
+                                              'filled by family '
+                                              f'{self.fillers[name]}')
+            if record.body is None:
+                raise CtlvError(record.where, 'a fill is a record, not a '
+                                              'field of records:')
+            return
+        if name in self.declared:
+            owner = self._owner_name(self.declared[name][0])
+            raise CtlvError(record.where, f'already declared by {owner}')
+
+    def _fill(self, family: spec.FamilySpec, name: str) -> None:
+        self.fillers[name] = family.name
+        self.fill_records[name] = self.named[name]
+
+    def _check_used(self, family: spec.FamilySpec, family_id: int) -> None:
+        """A family that inherits declares a record to fill or to use."""
+        if family_id == spec.CORE_FAMILY_ID:
+            return
+        for record in family.records:
+            if record.name in self.used or record.name in self.fill_records:
+                continue
+            raise CtlvError(record.where,
+                            f'no inherited extension point is called '
+                            f'{record.name}, and nothing in {family.name} '
+                            'uses it')
+
+    def _named(self, name: str, where: str | None) -> Record:
+        """Return the named record or field of records: called name."""
+        if name in self.named:
+            return self.named[name]
+        if name not in self.declared:
+            if name in self.extensions:
+                raise CtlvError(where, f'{name} is an extension point, which '
+                                       'extension names')
+            raise CtlvError(where, f'no record is called {name}')
+        if name in self.building:
+            raise CtlvError(where, 'record cycle: ' +
+                                   ' -> '.join(self.building + (name,)))
+        family_id, declared_at, index, record_spec = self.declared[name]
+        self.building += (name,)
+        try:
+            if record_spec.body is not None:
+                record = self._record(record_spec.body, name, family_id,
+                                      record_id('named', index), 'named',
+                                      name, name, 0, declared_at,
+                                      record_spec.doc)
+            else:
+                record = self._field_record(record_spec, family_id, index)
+        finally:
+            self.building = self.building[:-1]
+        self.named[name] = record
+        return record
+
+    def _field_record(self, record_spec: spec.RecordSpec, family_id: int,
+                      index: int) -> Record:
+        """A field of records:: a record of one field, under its name."""
+        name = record_spec.name
+        identifier = record_id('field', index)
+        assert record_spec.field is not None
+        decl = self._definition(record_spec.field)
+        holds = None
+        if decl.kind == 'record' and decl.ref is not None:
+            holds = self._held(decl.ref, decl.where)
+        field = self._new_field(Field(
+            record=name, name=name, family_id=family_id,
+            record_id=identifier, number=1,
+            type=type_of(family_id, identifier, 1), decl=decl,
+            full_name=name, shared=True, holds=holds))
+        record = Record(name=name, family_id=family_id,
+                        record_id=identifier, role='field', path=name,
+                        fields=(field,), members=(Member(field, True),),
+                        doc=record_spec.doc)
+        self.records[name] = record
+        return record
+
+    def _held(self, name: str, where: str) -> str:
+        """Return the path of the named record a field holds."""
+        self.used.add(name)
+        if name in self.building:
+            # A record holding itself, which the tree re-enters.
+            is_field = self.declared[name][3].body is None
+        else:
+            is_field = self._named(name, where).role == 'field'
+        if is_field:
+            raise CtlvError(where, f'record {name} holds a named record, and '
+                                   f'{name} is a field of records:, which '
+                                   'bare record places')
+        return name
+
+    def _record(self, body: spec.Body, name: str, family_id: int,
+                identifier: int, role: str, path: str, owner: str, depth: int,
+                where: str, doc: str | None = None) -> Record:
+        """Number the fields of one record and compose its members."""
+        own, members, unnamed, number = [], [], 0, 0
+        for item in body.items:
+            if isinstance(item, spec.Include):
+                members += self._include(item)
+                continue
+            if isinstance(item, spec.Place):
+                target = self._named(item.name, item.where)
+                self.used.add(item.name)
+                if target.role != 'field':
+                    raise CtlvError(item.where, f'bare record places a field '
+                                                f'of records:, and '
+                                                f'{item.name} is a record, '
+                                                f'which record {item.name} '
+                                                'holds or $include splices')
+                members.append(Member(target.fields[0], not item.optional,
+                                      item.doc))
+                continue
+            number += 1
+            _check_count(item.where, 'fields', number, MAX_FIELD_NUMBER)
+            decl = self._definition(item)
+            if role in ('request', 'reply'):
+                full_name = f'{owner} {decl.name}'
+            else:
+                full_name = f'{path}.{decl.name}'
+            holds = None
+            if decl.kind == 'record' and decl.body is not None:
+                unnamed += 1
+                if unnamed > MAX_UNNAMED_PEERS:
+                    raise CtlvError(item.where, f'more than '
+                                                f'{MAX_UNNAMED_PEERS} '
+                                                'unnamed records side by '
+                                                f'side in {path}; name one '
+                                                'in records:')
+                if depth >= MAX_UNNAMED_DEPTH:
+                    raise CtlvError(item.where, f'unnamed records go more '
+                                                f'than {MAX_UNNAMED_DEPTH} '
+                                                f'deep below {owner}; name '
+                                                'one in records:')
+                holds = self._record(
+                    decl.body, f'{owner}-{decl.name}', family_id,
+                    identifier | (unnamed << (12 - 4 * depth)), 'unnamed',
+                    full_name, owner, depth + 1, item.where).path
+            elif decl.kind == 'record' and decl.ref is not None:
+                holds = self._held(decl.ref, decl.where)
+            elif decl.extension is not None:
+                self._extension(decl.extension, family_id, decl.where)
+            field = self._new_field(Field(
+                record=name, name=decl.name, family_id=family_id,
+                record_id=identifier, number=number,
+                type=type_of(family_id, identifier, number), decl=decl,
+                full_name=full_name, holds=holds))
+            own.append(field)
+            members.append(Member(field, not decl.optional, decl.doc))
+        self._check_members(where, path, members)
+        record = Record(name=name, family_id=family_id, record_id=identifier,
+                        role=role, path=path, fields=tuple(own),
+                        members=tuple(members), doc=doc)
+        self.records[path] = record
+        return record
+
+    def _include(self, item: spec.Include) -> list[Member]:
+        target = self._named(item.name, item.where)
+        self.used.add(item.name)
+        if target.role == 'field':
+            raise CtlvError(item.where, f'$include splices a named record, '
+                                        f'and {item.name} is a field of '
+                                        'records:, which bare record places')
+        return [dataclasses.replace(member,
+                                    required=member.required and
+                                    not item.optional)
+                for member in target.members]
+
+    def _check_members(self, where: str, path: str,
+                       members: list[Member]) -> None:
+        names: dict[str, str] = {}
+        types: set[int] = set()
+        for member in members:
+            field = member.field
+            if field.type in types:
+                raise CtlvError(where, f'{field.full_name} is in {path} '
+                                       'twice')
+            if field.name in names:
+                raise CtlvError(where, f'two fields of {path} are called '
+                                       f'{field.name}: {names[field.name]} '
+                                       f'and {field.full_name}')
+            names[field.name] = field.full_name
+            types.add(field.type)
+
+    def _new_field(self, field: Field) -> Field:
+        clash = self.c_names.get((field.family_id, field.c_name))
+        if clash is not None:
+            hint = ''
+            kinds = {clash.record_id >> 30, field.record_id >> 30}
+            if (clash.record_id >> 16 & MAX_RECORD_INDEX ==
+                    field.record_id >> 16 & MAX_RECORD_INDEX and
+                    kinds == {TYPE_KIND_REQUEST, TYPE_KIND_REPLY}):
+                hint = ('; a field an op has in both its request and its '
+                        'reply is a field of records:')
+            raise CtlvError(field.decl.where, f'{clash.full_name} and '
+                                              f'{field.full_name} would both '
+                                              f'be named {field.c_name}'
+                                              f'{hint}')
+        self.c_names[(field.family_id, field.c_name)] = field
+        self.fields[field.full_name] = field
+        return field
+
+    def _extension(self, name: str, family_id: int, where: str) -> Extension:
+        extension = self.extensions.get(name)
+        if extension is not None:
+            if extension.family_id != family_id:
+                owner = self._owner_name(extension.family_id)
+                raise CtlvError(where, f'extension point {name} is '
+                                       f'declared by {owner}; a further one '
+                                       'needs a new name')
+            return extension
+        if name in self.declared:
+            raise CtlvError(where, f'{name} is a record, which record '
+                                   f'{name} holds')
+        if family_id == spec.CORE_FAMILY_ID:
+            raise CtlvError(where, 'the root family has no extension points')
+        ext_id = 1 + sum(point.family_id == family_id
+                         for point in self.extensions.values())
+        _check_count(where, 'extension points', ext_id, spec.U32_MAX)
+        extension = Extension(name, family_id, ext_id)
+        self.extensions[name] = extension
+        return extension
+
+    # Ops
+
+    def _add_ops(self, family: spec.FamilySpec, family_id: int) -> None:
+        _check_count(f'{family.path}: family {family.name}', 'ops',
+                     len(family.ops), MAX_RECORD_INDEX)
+        error_info_max_len = self._error_info_max_len()
+        for local_id, op in enumerate(family.ops, start=1):
+            where = f'{family.path}: op {op.name}'
+            if any(existing.name == op.name for existing in self.ops):
+                raise CtlvError(where, f'op "{op.name}" is already declared')
+            request_record = reply_record = None
+            request = reply = None
+            if op.request is not None:
+                request_record = self._message(op, op.request, family_id,
+                                               local_id, 'request')
+                request = self._tree(request_record, where + ' request')
+            if op.reply is not None:
+                reply_record = self._message(op, op.reply, family_id,
+                                             local_id, 'reply')
+                reply = self._tree(reply_record, where + ' reply')
+            self._check_context(where, op, request, reply)
+            self.ops.append(Op(
+                name=op.name,
+                type=op.type,
+                fd_access=op.fd_access,
+                availability=op.availability,
+                optional=op.optional,
+                pre_post=op.pre_post,
+                family_id=family_id,
+                local_id=local_id,
+                op_id=(family_id << 48) | local_id,
+                request=request,
+                reply=reply,
+                sizes=sizes.compute(where, op, request, reply,
+                                    error_info_max_len),
+                doc=op.doc,
+                request_record=request_record,
+                reply_record=reply_record,
+            ))
+
+    def _message(self, op: spec.OpSpec, message: spec.MessageSpec,
+                 family_id: int, local_id: int, which: str) -> Record:
+        if message.ref is not None:
+            return self.named[self._held(message.ref, message.where)]
+        return self._record(message.body, op.name, family_id,
+                            record_id(which, local_id), which,
+                            f'{op.name} {which}', op.name, 0, message.where,
+                            message.doc)
+
+    def _tree(self, record: Record, where: str) -> Node:
+        root = self._root(record.members, where, ())
+        _check_tree_size(where, root)
+        return root
+
+    def _root(self, members: tuple[Member, ...], where: str,
+              opened: tuple[str, ...]) -> Node:
+        children = self._children(members, where, opened, 0)
+        return Node(None, True, 1,
+                    tuple(node for node in children if node.required),
+                    tuple(node for node in children if not node.required))
+
+    def _children(self, members: tuple[Member, ...], where: str,
+                  opened: tuple[str, ...], depth: int) -> list[Node]:
+        return [self._node(member.field, member.required, where, opened,
+                           depth)
+                for member in members]
+
+    def _node(self, field: Field, required: bool, where: str,
+              opened: tuple[str, ...], depth: int) -> Node:
+        decl = field.decl
+        if decl.kind != 'record':
+            return Node(field, required, decl.max_occurrences, (), ())
+        if decl.extension is not None:
+            return Node(field, required, decl.max_occurrences, (), (),
+                        extensions=(self.extensions[decl.extension],))
+        assert field.holds is not None
+        record = self.records[field.holds]
+        named = record.role == 'named'
+        if named and record.name in opened:
+            # Open above, so one level further down rather than a new one.
+            return Node(field, required, decl.max_occurrences, (), (),
+                        reenters=record.name)
+        if depth + 1 > sizes.MAX_DECLARED_RECORD_DEPTH:
+            raise CtlvError(where, f'{field.full_name} goes deeper than the '
+                                   f'{sizes.MAX_DECLARED_RECORD_DEPTH} level '
+                                   'limit')
+        children = self._children(record.members, where,
+                                  opened + ((record.name,) if named else ()),
+                                  depth + 1)
+        return Node(field, required, decl.max_occurrences,
+                    tuple(child for child in children if child.required),
+                    tuple(child for child in children if not child.required),
+                    expands=record.name if named else None)
+
+    def _check_context(self, where: str, op: spec.OpSpec, request: Node | None,
+                       reply: Node | None) -> None:
+        if request is not None:
+            self._check_subtree(where, request, 'request')
+        if reply is None:
+            return
+        if op.type == 'query':
+            self._check_subtree(where, reply, 'query reply')
+            self._check_reentry(where, reply)
+        else:
+            self._check_subtree(where, reply, 'action reply')
+
+    def _check_reentry(self, where: str, root: Node) -> None:
+        """A repeating level cannot also be widened by a descendant."""
+        if not _reenters_anywhere(root) or not _extensions_anywhere(root):
+            return
+        raise CtlvError(f'{where} query reply',
+                        're-enters a record and holds an extension point, '
+                        'and a descendant cannot widen a level that repeats')
+
+    def _check_fills(self, fills: tuple[Fill, ...]) -> None:
+        """Hold each fill to every place its extension point sits.
+
+        A fill nested in another is met after it, so its places are known.
+        """
+        for fill in fills:
+            where = self.declared[fill.name][1]
+            for site, context, level in self.sites.get(fill.name, []):
+                self._check_subtree(f'{where} in {site}', fill.root, context,
+                                    level)
+
+    def _check_subtree(self, where: str, node: Node, context: str,
+                       level: int = 0) -> None:
+        """Hold a tree to its context and note where its extensions sit.
+
+        level is how many records deep node is, the root being 0.
+        """
+        if node.field is not None:
+            name = node.field.full_name
+            if (node.max_occurrences == spec.UNLIMITED and
+                    context != 'query reply'):
+                raise CtlvError(f'{where} {context}',
+                                f'{name} has no count limit, which only a '
+                                'query reply may contain')
+            if node.reenters is not None and context != 'query reply':
+                raise CtlvError(f'{where} {context}',
+                                f'{name} re-enters {node.reenters}, so it '
+                                'has no maximum length, which only a query '
+                                'reply may contain')
+            if node.field.decl.kind == 'blob' and context != 'request':
+                raise CtlvError(f'{where} {context}',
+                                f'{name} is a blob, which only a request '
+                                'may contain')
+            if (node.field.decl.kind == 'record' and
+                    level > sizes.MAX_DECLARED_RECORD_DEPTH):
+                raise CtlvError(f'{where} {context}',
+                                f'{name} goes deeper than the '
+                                f'{sizes.MAX_DECLARED_RECORD_DEPTH} level '
+                                'limit')
+        for extension in node.extensions:
+            self.sites.setdefault(extension.name, []).append(
+                (where, context, level))
+        for child in node.children():
+            self._check_subtree(where, child, context, level + 1)
+
+
+def _record_order(record: Record) -> tuple[int, bool, int, int, int]:
+    """Named records first, each before the records it holds, then ops."""
+    kind = record.record_id >> 30
+    index = record.record_id >> 16 & MAX_RECORD_INDEX
+    return (record.family_id, kind != TYPE_KIND_NAMED, index, kind,
+            record.record_id & 0xffff)
+
+
+def _reenters_anywhere(node: Node) -> bool:
+    return any(child.reenters is not None or _reenters_anywhere(child)
+               for child in node.children())
+
+
+def _extensions_anywhere(node: Node) -> bool:
+    return bool(node.extensions) or any(_extensions_anywhere(child)
+                                        for child in node.children())
+
+
+def composed_members(family: Family, node: Node) -> list[tuple[Node, bool]]:
+    """The children of node with the fills of its extension points."""
+    members = [(child, False) for child in node.required_children]
+    members += [(child, True) for child in node.optional_children]
+    for extension in node.extensions:
+        fill = family.fill_of(extension)
+        if fill is not None:
+            members += composed_members(family, fill.root)
+    return members
+
+
+def _check_composed(family: Family) -> None:
+    def walk_composed(where: str, node: Node) -> int:
+        members = composed_members(family, node)
+        required = sum(not optional for _child, optional in members)
+        optional = len(members) - required
+
+        _check_count(where, 'composed required fields', required,
+                     spec.U32_MAX)
+        _check_count(where, 'composed optional fields', optional,
+                     spec.U32_MAX)
+        count = 1
+        for child, _optional in members:
+            count += walk_composed(where, child)
+        return count
+
+    for op in family.ops:
+        total = 0
+        for which, root in (('request', op.request), ('reply', op.reply)):
+            if root is None:
+                continue
+            where = f'{family.path}: op {op.name} {which}'
+            count = walk_composed(where, root)
+            _check_count(where, 'composed schema nodes', count,
+                         spec.U32_MAX)
+            total += count
+        _check_count(f'{family.path}: op {op.name}',
+                     'composed request and reply nodes', total,
+                     spec.U32_MAX)
+
+
+def _check_docs(family: spec.FamilySpec) -> None:
+    """Require the comment that documents what a family declares.
+
+    The values of a set a header numbers are the header's to describe.
+    """
+    _check_doc(f'{family.path}: family {family.name}', family.doc)
+    for values in family.enums + family.flags:
+        _check_doc(values.where, values.doc)
+        if values.header:
+            continue
+        for value in values.values:
+            if not value.doc:
+                raise CtlvError(value.where, 'needs a comment of its own '
+                                             'right above it, so the values '
+                                             'go one to a line')
+    for record in family.records:
+        _check_doc(record.where, record.doc)
+        if record.body is not None:
+            _check_body_docs(record.body)
+    for op in family.ops:
+        _check_doc(op.where, op.doc)
+        for message in (op.request, op.reply):
+            if message is not None:
+                _check_body_docs(message.body)
+
+
+def _check_body_docs(body: spec.Body) -> None:
+    for item in body.items:
+        if isinstance(item, spec.FieldDecl):
+            _check_doc(item.where, item.doc)
+            if item.body is not None:
+                _check_body_docs(item.body)
+
+
+def _check_doc(where: str, doc: str | None) -> None:
+    if not doc:
+        raise CtlvError(where, 'needs a comment right above it, which is its '
+                               'documentation')
+
+
+def _node_count(node: Node) -> int:
+    return 1 + sum(_node_count(child) for child in node.children())
+
+
+def _extension_count(node: Node) -> int:
+    return len(node.extensions) + sum(_extension_count(child)
+                                      for child in node.children())
+
+
+def _check_tree_size(where: str, root: Node) -> None:
+    _check_count(where, 'schema nodes', _node_count(root), spec.U32_MAX)
+    _check_count(where, 'schema extension points', _extension_count(root),
+                 spec.U32_MAX)
diff --git a/tools/ctlv/ctlvgen/lib/sizes.py b/tools/ctlv/ctlvgen/lib/sizes.py
new file mode 100644
index 000000000000..3024eece9b5b
--- /dev/null
+++ b/tools/ctlv/ctlvgen/lib/sizes.py
@@ -0,0 +1,239 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+"""Length arithmetic over an expanded op tree.
+
+These numbers decide whether an op can run at all, so they are kept apart from
+the rest of resolution and tested against independently calculated lengths.
+The limits mirror include/linux/ctlv_family.h, and a test checks that.
+"""
+
+from __future__ import annotations
+
+import dataclasses
+from typing import TYPE_CHECKING
+
+from . import spec
+from .errors import CtlvError
+
+# semantics imports this module.
+if TYPE_CHECKING:
+    from . import semantics
+
+ALIGNTO: int = 8
+HDR_LEN: int = 16
+
+MAX_INLINE_MESSAGE_LEN: int = 0x10000
+MAX_ERROR_LEN: int = 0x4000
+MAX_RECORD_DEPTH: int = 8
+
+# The suggested reply length of a query whose spec suggests none.
+DEFAULT_QUERY_REPLY_LEN: int = 0x10000
+
+# One level short of what the transport carries: op-schema-get describes a
+# message, and a description goes one level deeper than what it describes.
+MAX_DECLARED_RECORD_DEPTH: int = MAX_RECORD_DEPTH - 1
+
+# Every integer, enum and flags payload is 64-bit.
+SCALAR_PAYLOAD_LEN: int = 8
+
+# A bool payload is one byte; only the TLV holding it is padded to eight.
+BOOL_PAYLOAD_LEN: int = 1
+
+# How many scalar descriptor fields each blob backing carries. A test checks
+# these against the root family's blob record.
+BLOB_DESCRIPTOR_FIELDS: dict[str, int] = {
+    'va': 3,
+}
+
+ERROR_INFO: str = 'error-info'
+
+# Records of the root family that are message roots in their own right, each
+# with the core's limit and the name the kernel gives it.
+CORE_MESSAGES: dict[str, tuple[str, int]] = {
+    ERROR_INFO: ('CTLV_MAX_ERROR_LEN', MAX_ERROR_LEN),
+}
+
+
+@dataclasses.dataclass(frozen=True)
+class OpSizes:
+    """Generated lengths of one op. Zero means "does not apply"."""
+
+    request_max_len: int
+    action_reply_max_len: int
+    query_reply_min_len: int
+    query_reply_suggested_len: int
+    error_info_max_len: int
+
+
+def align(length: int) -> int:
+    return (length + ALIGNTO - 1) & ~(ALIGNTO - 1)
+
+
+def tlv_max_len(node: semantics.Node) -> int:
+    """Maximum length of one occurrence of node, excluding its own padding."""
+    return HDR_LEN + _payload_max_len(node)
+
+
+def root_max_len(root: semantics.Node) -> int:
+    """Maximum length of a complete message root."""
+    return HDR_LEN + _payload_max_len(root)
+
+
+def min_reply_len(root: semantics.Node) -> int:
+    """Buffer length needed for the largest indivisible leaf and its path.
+
+    A leaf below a re-entered level sits as deep as the transport allows.
+    """
+    if _reenters(root):
+        return (MAX_RECORD_DEPTH + 1) * HDR_LEN + _largest_leaf(root)
+    return _min_walk(root, 0)
+
+
+def compute(where: str, op: spec.OpSpec, request: semantics.Node | None,
+            reply: semantics.Node | None, error_info_max_len: int) -> OpSizes:
+    """Return the generated lengths of one op."""
+    request_max_len = 0
+    if request is not None:
+        request_max_len = root_max_len(request)
+        _check_inline(where, 'request', request_max_len)
+
+    action_reply_max_len = 0
+    query_reply_min_len = 0
+    query_reply_suggested_len = 0
+
+    if op.type == 'action' and reply is not None:
+        action_reply_max_len = root_max_len(reply)
+        _check_inline(where, 'action reply', action_reply_max_len)
+    elif op.type == 'query':
+        assert reply is not None
+        query_reply_min_len = min_reply_len(reply)
+        _check_inline(where, 'largest query reply leaf and its path',
+                      query_reply_min_len)
+        query_reply_suggested_len = _suggested_len(
+            where, op.suggested_reply_length, query_reply_min_len)
+
+    return OpSizes(request_max_len=request_max_len,
+                   action_reply_max_len=action_reply_max_len,
+                   query_reply_min_len=query_reply_min_len,
+                   query_reply_suggested_len=query_reply_suggested_len,
+                   error_info_max_len=error_info_max_len)
+
+
+def composed(where: str, op: semantics.Op, request: semantics.Node | None,
+             reply: semantics.Node | None) -> OpSizes:
+    """Return the lengths one op needs for one family.
+
+    compute()'s numbers over the composed tree, fills spliced in. A suggestion
+    is raised here rather than refused.
+    """
+    sizes = OpSizes(request_max_len=root_max_len(request) if request else 0,
+                    action_reply_max_len=0, query_reply_min_len=0,
+                    query_reply_suggested_len=0,
+                    error_info_max_len=op.sizes.error_info_max_len)
+    _check_inline(where, 'request', sizes.request_max_len)
+
+    if op.type == 'action' and reply is not None:
+        sizes = dataclasses.replace(sizes,
+                                    action_reply_max_len=root_max_len(reply))
+        _check_inline(where, 'action reply', sizes.action_reply_max_len)
+    elif op.type == 'query':
+        assert reply is not None
+        minimum = min_reply_len(reply)
+        _check_inline(where, 'largest query reply leaf and its path', minimum)
+        sizes = dataclasses.replace(
+            sizes, query_reply_min_len=minimum,
+            query_reply_suggested_len=max(op.sizes.query_reply_suggested_len,
+                                          minimum))
+    return sizes
+
+
+def message_max_len(where: str, name: str, root: semantics.Node) -> int:
+    """Return the maximum length of one core message, against its limit."""
+    limit_name, limit = CORE_MESSAGES[name]
+    length = root_max_len(root)
+    if length > limit:
+        raise CtlvError(where, f'needs {length} bytes, more than the {limit} '
+                               f'of {limit_name}')
+    return length
+
+
+def _payload_max_len(node: semantics.Node) -> int:
+    if node.is_root:
+        return _children_max_len(node)
+
+    decl = node.child_field.decl
+    if decl.kind in ('uint', 'sint', 'enum', 'flags'):
+        return SCALAR_PAYLOAD_LEN
+    if decl.kind == 'bool':
+        return BOOL_PAYLOAD_LEN
+    if decl.kind == 'string':
+        assert decl.max_length is not None
+        # One terminating NUL, which max-length excludes.
+        return decl.max_length + 1
+    if decl.kind == 'binary':
+        assert decl.max_length is not None
+        return decl.max_length
+    if decl.kind == 'blob':
+        assert decl.blob is not None
+        widest = max(BLOB_DESCRIPTOR_FIELDS[backing]
+                     for backing in decl.blob.backings)
+        return widest * align(HDR_LEN + SCALAR_PAYLOAD_LEN)
+    return _children_max_len(node)
+
+
+def _children_max_len(node: semantics.Node) -> int:
+    total = 0
+    for child in node.children():
+        if child.max_occurrences == spec.UNLIMITED:
+            raise AssertionError(
+                f'{child.child_field.full_name} has unlimited occurrences, '
+                'so it has no maximum length')
+        if child.reenters is not None:
+            raise AssertionError(
+                f'{child.child_field.full_name} re-enters {child.reenters}, '
+                'so it has no maximum length')
+        total += child.max_occurrences * align(tlv_max_len(child))
+    return total
+
+
+def _min_walk(node: semantics.Node, ancestors_len: int) -> int:
+    children = node.children()
+    if children:
+        return max(_min_walk(child, ancestors_len + HDR_LEN)
+                   for child in children)
+    if node.is_root:
+        return ancestors_len + HDR_LEN
+    return ancestors_len + align(tlv_max_len(node))
+
+
+def _reenters(node: semantics.Node) -> bool:
+    return any(child.reenters is not None or _reenters(child)
+               for child in node.children())
+
+
+def _largest_leaf(node: semantics.Node) -> int:
+    """The longest node of the tree that a fragment cannot split."""
+    lengths = [align(tlv_max_len(child))
+               for child in node.children()
+               if child.child_field.decl.kind != 'record']
+    lengths += [_largest_leaf(child) for child in node.children()]
+    return max(lengths, default=0)
+
+
+def _check_inline(where: str, what: str, length: int) -> None:
+    if length > MAX_INLINE_MESSAGE_LEN:
+        raise CtlvError(where, f'{what} needs {length} bytes, more than the '
+                               f'{MAX_INLINE_MESSAGE_LEN} byte inline '
+                               'message limit')
+
+
+def _suggested_len(where: str, declared: int | None, minimum: int) -> int:
+    if declared is None:
+        return max(DEFAULT_QUERY_REPLY_LEN, minimum)
+    if declared < minimum:
+        raise CtlvError(where, f'suggested-reply-length {declared} is below '
+                               f'the computed minimum of {minimum}')
+    if declared > MAX_INLINE_MESSAGE_LEN:
+        raise CtlvError(where, f'suggested-reply-length {declared} exceeds '
+                               f'the {MAX_INLINE_MESSAGE_LEN} byte inline '
+                               'message limit')
+    return declared
diff --git a/tools/ctlv/ctlvgen/lib/spec.py b/tools/ctlv/ctlvgen/lib/spec.py
new file mode 100644
index 000000000000..7d1f2e14f70f
--- /dev/null
+++ b/tools/ctlv/ctlvgen/lib/spec.py
@@ -0,0 +1,813 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+"""The as-written form of a CTLV family specification.
+
+The strict YAML subset, the meta-schema, and every rule that one declaration
+decides on its own. Comparing declarations and walking a chain are
+semantics.py's. Omitted values are normalized here, once.
+"""
+
+from __future__ import annotations
+
+import dataclasses
+import pathlib
+import re
+from collections.abc import Callable
+from typing import Any
+
+import jsonschema
+
+from . import cenum
+from . import yamlload
+from .errors import CtlvError
+
+# A generated file carries the license of its specification's first line.
+LICENSE: re.Pattern[str] = re.compile(
+    r'#\s*SPDX-License-Identifier:\s*(\S.*?)\s*$')
+
+# The registry is indexed by family ID, so the root family is its first entry.
+CORE_FAMILY_NAME: str = 'ctlv'
+CORE_FAMILY_ID: int = 0
+
+# Where a $header is, under the kernel tree: an enum is taken from uapi only.
+UAPI_DIR: str = 'include/uapi'
+
+MAX_FAMILY_NAME_LEN: int = 63
+U8_MAX: int = (1 << 8) - 1
+U16_MAX: int = (1 << 16) - 1
+U32_MAX: int = (1 << 32) - 1
+MAX_FAMILY_ID: int = U16_MAX
+
+# Zero means unlimited, as introspection reports it.
+UNLIMITED: int = 0
+
+U64_MAX: int = (1 << 64) - 1
+S64_MIN: int = -(1 << 63)
+S64_MAX: int = (1 << 63) - 1
+S8_MIN: int = -(1 << 7)
+S8_MAX: int = (1 << 7) - 1
+
+# The limits a spec, a snapshot and the docs write by name.
+NAMED_NUMBERS: dict[str, int] = {}
+for _bits in (8, 16, 32, 64):
+    NAMED_NUMBERS[f'u{_bits}-max'] = (1 << _bits) - 1
+    NAMED_NUMBERS[f's{_bits}-min'] = -(1 << (_bits - 1))
+    NAMED_NUMBERS[f's{_bits}-max'] = (1 << (_bits - 1)) - 1
+SIZE_SUFFIXES: tuple[tuple[str, int], ...] = (
+    ('G', 1 << 30), ('M', 1 << 20), ('K', 1 << 10))
+
+INTEGER_KINDS: tuple[str, ...] = ('uint', 'sint')
+SCALAR_KINDS: tuple[str, ...] = ('uint', 'sint', 'bool', 'string', 'binary',
+                                 'enum', 'flags')
+SCHEMA_KINDS: tuple[str, ...] = ('uint', 'sint', 'bool', 'string', 'binary',
+                                 'blob')
+UNITS: tuple[str, ...] = ('seconds', 'hertz', 'bytes', 'celsius')
+BACKINGS: tuple[str, ...] = ('va',)
+DIRECTIONS: dict[str, str] = {'in': 'input', 'out': 'output', 'inout': 'inout'}
+DEFAULT_BACKINGS: tuple[str, ...] = ('va',)
+
+FD_ACCESSES: tuple[str, ...] = ('read', 'read-write')
+DEFAULT_FD_ACCESS: str = 'read-write'
+
+# Every op has one of these, and only an action or a query may be dynamic.
+AVAILABILITIES: tuple[str, ...] = ('fixed', 'dynamic')
+DEFAULT_AVAILABILITY: str = 'fixed'
+
+_NAME: str = r'[a-z0-9]+(?:-[a-z0-9]+)*'
+_FIELD_KEY: re.Pattern[str] = re.compile(
+    rf'(?P<name>{_NAME})(?:\[(?P<count>[0-9]*|{_NAME})\])?(?P<optional>\?)?')
+_KIND: re.Pattern[str] = re.compile(
+    rf'(?P<kind>{_NAME})(?:\((?P<args>[^()]*)\))?')
+_REFERENCE: re.Pattern[str] = re.compile(
+    rf'(?P<what>record|extension)(?: +(?P<name>{_NAME}))?')
+_INCLUDE: re.Pattern[str] = re.compile(rf'(?P<name>{_NAME})(?P<optional>\?)?')
+_NUMBER: re.Pattern[str] = re.compile(r'(?P<value>-?[0-9]+)(?P<suffix>[KMG]?)')
+_SCALE: re.Pattern[str] = re.compile(r'scale +(?P<value>-?[0-9]+)')
+_ALIGN: re.Pattern[str] = re.compile(r'align +(?P<value>\S+)')
+
+
+def number_text(value: int) -> str:
+    """Return an integer as a spec writes it, a limit by its name."""
+    for name, number in NAMED_NUMBERS.items():
+        if number == value:
+            return name
+    return str(value)
+
+
+def size_text(value: int) -> str:
+    """Return a byte count as a spec writes it."""
+    for suffix, scale in SIZE_SUFFIXES:
+        if value >= scale and value % scale == 0:
+            return f'{value // scale}{suffix}'
+    if value >= 1 << 10:
+        return number_text(value)
+    return str(value)
+
+
+@dataclasses.dataclass(frozen=True)
+class Value:
+    """One value of an enum or a flags definition, numbered if a header's."""
+
+    name: str
+    where: str
+    doc: str | None = None
+    number: int | None = None
+
+
+@dataclasses.dataclass(frozen=True)
+class HeaderEnum:
+    """Enum tag of include/uapi/<path>, its constants before end if given."""
+
+    path: str
+    tag: str
+    end: str | None = None
+
+
+@dataclasses.dataclass(frozen=True)
+class ValueList:
+    """An enum or a flags definition, or an enum extension point."""
+
+    name: str
+    where: str
+    values: tuple[Value, ...]
+    header: HeaderEnum | None = None
+    doc: str | None = None
+    extension: bool = False
+
+
+@dataclasses.dataclass(frozen=True)
+class BlobDecl:
+    """The blob properties of one blob field declaration."""
+
+    direction: str
+    backings: tuple[str, ...]
+    max_length: int
+    alignment: int
+
+
+@dataclasses.dataclass(frozen=True)
+class FieldDecl:
+    """One field declaration.
+
+    kind is the schema kind, enum or flags, or record for a record, which holds
+    the fields written in place in body, the named record ref, or the
+    extension point extension. A field that does not apply stays None.
+    count_enum is the enum a count names, whose values the chain counts.
+    """
+
+    name: str
+    kind: str
+    where: str
+    optional: bool = False
+    max_occurrences: int = 1
+    count_enum: str | None = None
+    ref: str | None = None
+    body: Body | None = None
+    extension: str | None = None
+    blob: BlobDecl | None = None
+    min: int | None = None
+    max: int | None = None
+    min_length: int | None = None
+    max_length: int | None = None
+    unit: str | None = None
+    scale: int | None = None
+    doc: str | None = None
+
+
+@dataclasses.dataclass(frozen=True)
+class Place:
+    """A field of records: placed by bare record, under its own name."""
+
+    name: str
+    optional: bool
+    where: str
+    doc: str | None = None
+
+
+@dataclasses.dataclass(frozen=True)
+class Include:
+    """A named record whose fields are spliced in with their IDs."""
+
+    name: str
+    optional: bool
+    where: str
+
+
+@dataclasses.dataclass(frozen=True)
+class Body:
+    """A record as written: fields, placed records and includes, in order."""
+
+    items: tuple[FieldDecl | Place | Include, ...] = ()
+
+
+@dataclasses.dataclass(frozen=True)
+class RecordSpec:
+    """One entry of records:, a named record or a field of records:."""
+
+    name: str
+    where: str
+    body: Body | None = None
+    field: FieldDecl | None = None
+    doc: str | None = None
+
+
+@dataclasses.dataclass(frozen=True)
+class MessageSpec:
+    """A request or a reply: a record in place, or a named one."""
+
+    where: str
+    body: Body = Body()
+    ref: str | None = None
+    doc: str | None = None
+
+
+@dataclasses.dataclass(frozen=True)
+class OpSpec:
+    """One op."""
+
+    name: str
+    type: str
+    where: str
+    request: MessageSpec | None
+    reply: MessageSpec | None = None
+    fd_access: str = DEFAULT_FD_ACCESS
+    availability: str = DEFAULT_AVAILABILITY
+    optional: bool = False
+    pre_post: bool = False
+    suggested_reply_length: int | None = None
+    doc: str | None = None
+
+
+@dataclasses.dataclass(frozen=True)
+class FamilySpec:
+    """One specification file, syntax-checked and normalized."""
+
+    path: str
+    name: str
+    license: str
+    inherits: str | None
+    enums: tuple[ValueList, ...]
+    flags: tuple[ValueList, ...]
+    records: tuple[RecordSpec, ...]
+    ops: tuple[OpSpec, ...]
+    doc: str | None = None
+
+
+@dataclasses.dataclass(frozen=True)
+class RegistryEntry:
+    name: str
+    deprecated: bool
+
+
+@dataclasses.dataclass(frozen=True)
+class Registry:
+    """The append-only family registry, indexed by family ID."""
+
+    path: str
+    entries: tuple[RegistryEntry, ...]
+
+    @property
+    def license(self) -> str:
+        return _license(self.path)
+
+    def family_id(self, name: str) -> int | None:
+        """Return the registered family ID of name, or None if unregistered."""
+        for family_id, entry in enumerate(self.entries):
+            if entry.name == name:
+                return family_id
+        return None
+
+
+class Paths:
+    """Where the specs, the registry and the meta-schemas are."""
+
+    def __init__(self, spec: pathlib.Path | str,
+                 schema: pathlib.Path | str | None = None,
+                 registry: pathlib.Path | str | None = None,
+                 abi: pathlib.Path | str | None = None) -> None:
+        self.spec = pathlib.Path(spec)
+        self.spec_dir = self.spec.parent
+        self.doc_dir = self.spec_dir.parent
+        self.schema = pathlib.Path(schema or self.doc_dir / 'ctlv-schema.yaml')
+        self.registry = pathlib.Path(registry or
+                                     self.doc_dir / 'families.yaml')
+        # The two meta-schemas ship together, so overriding one locates both.
+        self.registry_schema = (self.schema.parent /
+                                'ctlv-registry-schema.yaml')
+        self.abi_dir = pathlib.Path(abi or self.doc_dir / 'abi')
+        self.registry_abi = self.abi_dir / 'families.registry.yaml'
+        self.generated = self.doc_dir / 'generated-files.yaml'
+        self.generated_schema = self.doc_dir / 'generated-files-schema.yaml'
+        self.kernel_dir = self.schema.parent.parent.parent
+
+    def sibling_spec(self, name: str) -> pathlib.Path:
+        """Return the path of another family's specification.
+
+        The one root family lives where the meta-schema does, so a corpus of
+        fixtures inherits it rather than a copy.
+        """
+        if name == CORE_FAMILY_NAME:
+            return self.schema.parent / 'specs' / f'{name}.yaml'
+        return self.spec_dir / f'{name}.yaml'
+
+    def abi(self, name: str) -> pathlib.Path:
+        """Return the path of one family's checked-in ABI snapshot."""
+        return self.abi_dir / f'{name}.yaml'
+
+
+def load_registry(paths: Paths, path: pathlib.Path | str | None = None,
+                  text: str | None = None) -> Registry:
+    """Load and check the family registry, or the one in text."""
+    path = pathlib.Path(path or paths.registry)
+    data = yamlload.load(path, text)
+    _validate_syntax(path, data, paths.registry_schema)
+
+    entries = []
+    seen = set()
+    for item in data['families']:
+        if isinstance(item, dict):
+            entry = RegistryEntry(item['name'], item['deprecated'])
+        else:
+            entry = RegistryEntry(item, False)
+        _family_name(f'{path}: family {entry.name}', entry.name)
+        if entry.name in seen:
+            raise CtlvError(f'{path}: {entry.name}', 'duplicate family')
+        seen.add(entry.name)
+        entries.append(entry)
+
+    core = entries[CORE_FAMILY_ID]
+    if core.name != CORE_FAMILY_NAME:
+        raise CtlvError(f'{path}: {core.name}',
+                        f'family ID {CORE_FAMILY_ID} belongs to '
+                        f'{CORE_FAMILY_NAME}, so it must be the first entry')
+    if core.deprecated:
+        raise CtlvError(f'{path}: {core.name}',
+                        'the core family cannot be deprecated')
+    if len(entries) - 1 > MAX_FAMILY_ID:
+        raise CtlvError(str(path),
+                        f'{len(entries)} entries need a family ID past the '
+                        f'{MAX_FAMILY_ID} maximum')
+    return Registry(str(path), tuple(entries))
+
+
+def load(path: pathlib.Path | str, schema: pathlib.Path) -> FamilySpec:
+    """Load, syntax-check and normalize one family specification."""
+    path = pathlib.Path(path)
+    data, lines = yamlload.load_with_lines(path)
+    _validate_syntax(path, data, schema)
+
+    reader = _Reader(path, lines,
+                     pathlib.Path(schema).parent.parent.parent / UAPI_DIR)
+    name = _family_name(f'{path}: family {data["family"]}', data['family'])
+    inherits = data.get('inherits')
+    if inherits is not None:
+        inherits = _family_name(f'{path}: family {name} parent', inherits)
+    return FamilySpec(
+        path=str(path),
+        name=name,
+        license=_license(path),
+        inherits=inherits,
+        enums=reader.value_lists(data.get('enums', {}), 'enum'),
+        flags=reader.value_lists(data.get('flags', {}), 'flags'),
+        records=reader.records(data.get('records', {})),
+        ops=reader.ops(data.get('ops', {})),
+        doc=reader.doc(data, 'family'),
+    )
+
+
+def _license(path: pathlib.Path | str) -> str:
+    """Return the SPDX identifier the specification's first line carries."""
+    with open(path, 'r', encoding='utf-8') as stream:
+        found = LICENSE.match(stream.readline())
+    if found is None:
+        raise CtlvError(str(path),
+                        'the first line must be an SPDX-License-Identifier '
+                        'comment, which every generated file inherits')
+    return found.group(1)
+
+
+def _validate_syntax(path: pathlib.Path, data: dict[str, Any],
+                     schema_path: pathlib.Path) -> None:
+    schema = yamlload.load(schema_path)
+    validator = jsonschema.Draft7Validator(schema)
+    error = jsonschema.exceptions.best_match(validator.iter_errors(data))
+    if error is None:
+        return
+    where = f'{path}: {error.json_path}' if error.absolute_path else str(path)
+    raise CtlvError(where, error.message)
+
+
+def _family_name(where: str, name: str) -> str:
+    if len(name) > MAX_FAMILY_NAME_LEN:
+        raise CtlvError(where, f'name is {len(name)} characters, more than '
+                               f'the {MAX_FAMILY_NAME_LEN} maximum')
+    return name
+
+
+def _arguments(text: str) -> list[str]:
+    return [part.strip() for part in text.split(',')]
+
+
+class _Reader:
+    """Parses the parts of one specification, knowing its lines for docs."""
+
+    def __init__(self, path: pathlib.Path, lines: list[str],
+                 uapi: pathlib.Path | None = None) -> None:
+        self.path = path
+        self.lines = lines
+        self.uapi = uapi
+
+    def doc(self, mapping: dict[str, Any], key: str) -> str | None:
+        """Return the comment lines right above key, without their #."""
+        return self._comment(getattr(mapping, 'lines', {}).get(key))
+
+    def _comment(self, line: int | None) -> str | None:
+        if line is None:
+            return None
+        texts = []
+        for index in range(line - 1, -1, -1):
+            text = self.lines[index].strip()
+            if not text.startswith('#') or LICENSE.match(text):
+                break
+            texts.append(text[1:].strip())
+        return '\n'.join(reversed(texts)).strip() or None
+
+    def where(self, mapping: dict[str, Any], key: str, what: str) -> str:
+        return self._at(getattr(mapping, 'lines', {}).get(key), what)
+
+    def _at(self, line: int | None, what: str) -> str:
+        if line is None:
+            return f'{self.path}: {what}'
+        return f'{self.path}:{line + 1}: {what}'
+
+    def _values(self, raw: list[str], after: int | None,
+                what: str) -> tuple[Value, ...]:
+        """Each value of a set, with the comment right above its line.
+
+        after is the line of the key the values follow. A value on that line,
+        or on another value's, has no comment of its own.
+        """
+        lines = getattr(raw, 'lines', [None] * len(raw))
+        values = []
+        for name, line in zip(raw, lines):
+            doc = None if line == after else self._comment(line)
+            values.append(Value(name, self._at(line, f'{what} value {name}'),
+                                doc))
+            after = line
+        return tuple(values)
+
+    def value_lists(self, raw_lists: dict[str, Any],
+                    what: str) -> tuple[ValueList, ...]:
+        lists = []
+        for name, raw in raw_lists.items():
+            where = self.where(raw_lists, name, f'{what} {name}')
+            if name in SCHEMA_KINDS or name in ('record', 'extension'):
+                raise CtlvError(where, f'"{name}" is a keyword of the spec '
+                                       f'language, so no {what} is called '
+                                       'that')
+            if raw == 'extension':
+                lists.append(ValueList(name, where, (),
+                                       doc=self.doc(raw_lists, name),
+                                       extension=True))
+                continue
+            if isinstance(raw, dict):
+                lists.append(self._header_enum(name, where, raw,
+                                               self.doc(raw_lists, name)))
+                continue
+            after = getattr(raw_lists, 'lines', {}).get(name)
+            seen = set()
+            for value in raw:
+                if value in seen:
+                    raise CtlvError(where, f'duplicate value "{value}"')
+                seen.add(value)
+            lists.append(ValueList(name, where,
+                                   self._values(raw, after, f'{what} {name}'),
+                                   doc=self.doc(raw_lists, name)))
+        return tuple(lists)
+
+    def _header_enum(self, name: str, where: str, raw: dict[str, str],
+                     doc: str | None) -> ValueList:
+        header = HeaderEnum(raw['$header'], raw['$enum'], raw.get('$end'))
+        if self.uapi is None:
+            raise CtlvError(where, 'no kernel tree to read headers from')
+        constants = cenum.read(where, self.uapi, header.path, header.tag,
+                               header.end)
+        values = tuple(Value(constant, f'{where} value {constant}',
+                             number=number)
+                       for constant, number in constants)
+        return ValueList(name, where, values, header, doc)
+
+    def records(self, raw_records: dict[str, Any]) -> tuple[RecordSpec, ...]:
+        records = []
+        for key, raw in raw_records.items():
+            found = _FIELD_KEY.fullmatch(key)
+            assert found is not None
+            name = found['name']
+            where = self.where(raw_records, key, f'record {name}')
+            doc = self.doc(raw_records, key)
+            if found['optional']:
+                raise CtlvError(where, 'a definition cannot be optional; '
+                                       'whatever places it says so')
+            if isinstance(raw, dict):
+                if found['count'] is not None:
+                    raise CtlvError(where, 'a count belongs to a field, and '
+                                           'this is a record')
+                records.append(RecordSpec(name, body=self.body(raw, where),
+                                          doc=doc, where=where))
+                continue
+            decl = self.field(key, raw, where, doc)
+            if isinstance(decl, Place):
+                raise CtlvError(where, 'bare record places a field of '
+                                       'records:, and this is where one is '
+                                       'declared')
+            if decl.kind == 'record' and decl.ref is None:
+                raise CtlvError(where, 'a field of records: is shared by '
+                                       'name, and an extension point is '
+                                       'not shared')
+            records.append(RecordSpec(name, field=decl, doc=doc,
+                                      where=where))
+        return tuple(records)
+
+    def body(self, raw: dict[str, Any], where: str) -> Body:
+        items: list[FieldDecl | Place | Include] = []
+        names = set()
+        for key, value in raw.items():
+            if key == '$include':
+                for text in [value] if isinstance(value, str) else value:
+                    found = _INCLUDE.fullmatch(text)
+                    assert found is not None
+                    items.append(Include(found['name'],
+                                         bool(found['optional']),
+                                         self.where(raw, key,
+                                                    f'$include {text}')))
+                continue
+            item = self.field(key, value, where, self.doc(raw, key), raw)
+            if item.name in names:
+                raise CtlvError(item.where, f'two fields are called '
+                                            f'{item.name}')
+            names.add(item.name)
+            items.append(item)
+        return Body(tuple(items))
+
+    def field(self, key: str, raw: str | dict[str, Any], owner: str,
+              doc: str | None,
+              mapping: dict[str, Any] | None = None) -> FieldDecl | Place:
+        """Return the FieldDecl or the Place one key and its value say."""
+        found = _FIELD_KEY.fullmatch(key)
+        assert found is not None
+        name = found['name']
+        optional = bool(found['optional'])
+        count = found['count']
+        where = owner
+        if mapping is not None:
+            where = self.where(mapping, key, f'field {name}')
+        occurrences, count_enum = self._occurrences(where, count)
+        common: dict[str, Any] = {'name': name, 'optional': optional,
+                                  'max_occurrences': occurrences,
+                                  'count_enum': count_enum, 'doc': doc,
+                                  'where': where}
+        if isinstance(raw, dict):
+            return FieldDecl(kind='record', body=self.body(raw, where),
+                             **common)
+        text = raw.strip()
+        reference = _REFERENCE.fullmatch(text)
+        if reference is not None:
+            return self._reference(where, reference, count, common)
+        found = _KIND.fullmatch(text)
+        if found is None:
+            raise CtlvError(where, f'"{text}" is not a schema kind')
+        kind, args = found['kind'], found['args']
+        if kind in INTEGER_KINDS:
+            return FieldDecl(kind=kind, **self._integer(where, kind, args),
+                             **common)
+        if kind == 'bool':
+            if args is not None:
+                raise CtlvError(where, 'a bool takes no bounds')
+            return FieldDecl(kind=kind, **common)
+        if kind in ('string', 'binary'):
+            return FieldDecl(kind=kind, **self._lengths(where, kind, args),
+                             **common)
+        if kind == 'blob':
+            return FieldDecl(kind=kind, blob=self._blob(where, args),
+                             **common)
+        if args is not None:
+            raise CtlvError(where, f'{kind} names an enum or flags, which '
+                                   'take no bounds')
+        # Which of the two it names, the chain says.
+        return FieldDecl(kind='definition', ref=kind, **common)
+
+    def _reference(self, where: str, reference: re.Match[str],
+                   count: str | None,
+                   common: dict[str, Any]) -> FieldDecl | Place:
+        target = reference['name']
+        if reference['what'] == 'extension':
+            if target is None:
+                raise CtlvError(where, 'extension needs the name of its '
+                                       'extension point')
+            return FieldDecl(kind='record', extension=target, **common)
+        if target is not None:
+            return FieldDecl(kind='record', ref=target, **common)
+        if count is not None:
+            raise CtlvError(where, 'a field of records: takes its count '
+                                   'from its declaration, not where it is '
+                                   'placed')
+        return Place(common['name'], common['optional'], where,
+                     common['doc'])
+
+    def _occurrences(self, where: str,
+                     count: str | None) -> tuple[int, str | None]:
+        """A count, or the enum it names, which semantics.py counts."""
+        if count is None:
+            return 1, None
+        if count == '':
+            return UNLIMITED, None
+        if not count.isdigit():
+            return 1, count
+        value = int(count)
+        if value < 1 or value > U32_MAX:
+            raise CtlvError(where, f'count {value} is outside 1 to u32-max')
+        return value, None
+
+    def _integer_value(self, where: str, text: str, kind: str,
+                       unit: str | None) -> int:
+        if text in NAMED_NUMBERS:
+            return NAMED_NUMBERS[text]
+        found = _NUMBER.fullmatch(text)
+        if found is None:
+            raise CtlvError(where, f'"{text}" is not a number')
+        if found['suffix'] and unit != 'bytes':
+            raise CtlvError(where, f'"{text}": K, M and G are for byte '
+                                   f'counts; give the {kind} the bytes unit')
+        factor = dict(SIZE_SUFFIXES).get(found['suffix'], 1)
+        return int(found['value']) * factor
+
+    def _size(self, where: str, text: str, what: str,
+              limit: int = U32_MAX) -> int:
+        if text in NAMED_NUMBERS:
+            value = NAMED_NUMBERS[text]
+        else:
+            found = _NUMBER.fullmatch(text)
+            if found is None:
+                raise CtlvError(where, f'{what} "{text}" is not a number')
+            value = int(found['value'])
+            for suffix, scale in SIZE_SUFFIXES:
+                if found['suffix'] == suffix:
+                    value *= scale
+        if value < 0 or value > limit:
+            raise CtlvError(where, f'{what} {text} is outside 0 to '
+                                   f'{number_text(limit)}')
+        return value
+
+    def _range(self, where: str, text: str,
+               parse: Callable[[str], int]) -> tuple[int | None, int | None]:
+        low, _, high = text.partition('..')
+        return (parse(low.strip()) if low.strip() else None,
+                parse(high.strip()) if high.strip() else None)
+
+    def _integer(self, where: str, kind: str,
+                 args: str | None) -> dict[str, Any]:
+        low, high = (0, U64_MAX) if kind == 'uint' else (S64_MIN, S64_MAX)
+        minimum, maximum, unit, scale = low, high, None, None
+        bounds = None
+        for arg in _arguments(args) if args is not None else ():
+            scaled = _SCALE.fullmatch(arg)
+            if '..' in arg and bounds is None:
+                bounds = arg
+            elif arg in UNITS and unit is None:
+                unit = arg
+            elif scaled is not None and scale is None:
+                scale = int(scaled['value'])
+            else:
+                raise CtlvError(where, f'"{arg}" is not a range, a unit or '
+                                       'a scale, or is given twice')
+        if bounds is not None:
+            first, last = self._range(
+                where, bounds,
+                lambda text: self._integer_value(where, text, kind, unit))
+            minimum = low if first is None else first
+            maximum = high if last is None else last
+        if minimum < low or minimum > high:
+            raise CtlvError(where, f'minimum {minimum} is outside the '
+                                   f'{kind} range')
+        if maximum < low or maximum > high:
+            raise CtlvError(where, f'maximum {maximum} is outside the '
+                                   f'{kind} range')
+        if minimum > maximum:
+            raise CtlvError(where, f'minimum {minimum} is greater than '
+                                   f'maximum {maximum}')
+        if scale is not None and unit is None:
+            raise CtlvError(where, 'scale requires a unit')
+        if unit is not None and scale is None:
+            scale = 0
+        if scale is not None and (scale < S8_MIN or scale > S8_MAX):
+            raise CtlvError(where, f'scale {scale} is outside the s8 range')
+        return {'min': minimum, 'max': maximum, 'unit': unit, 'scale': scale}
+
+    def _lengths(self, where: str, kind: str,
+                 args: str | None) -> dict[str, Any]:
+        if args is None or '..' not in args and not args.strip():
+            raise CtlvError(where, f'a {kind} needs a maximum length, '
+                                   f'as {kind}(..N)')
+
+        def size(text: str) -> int:
+            return self._size(where, text, 'length')
+
+        if '..' in args:
+            minimum, maximum = self._range(where, args, size)
+        else:
+            minimum = maximum = size(args.strip())
+        if maximum is None:
+            raise CtlvError(where, f'a {kind} needs a maximum length, '
+                                   f'as {kind}(..N)')
+        minimum = minimum or 0
+        if minimum > maximum:
+            raise CtlvError(where, f'minimum length {minimum} is greater '
+                                   f'than maximum length {maximum}')
+        return {'min_length': minimum, 'max_length': maximum}
+
+    def _blob(self, where: str, args: str) -> BlobDecl:
+        parts = _arguments(args) if args is not None else ['']
+        direction = DIRECTIONS.get(parts[0])
+        if direction is None:
+            raise CtlvError(where, 'a blob starts with its direction, in, '
+                                   'out or inout')
+        maximum, alignment, backings = None, None, None
+        for arg in parts[1:]:
+            aligned = _ALIGN.fullmatch(arg)
+            if arg.startswith('..') and maximum is None:
+                maximum = self._size(where, arg[2:].strip(), 'blob length',
+                                     U64_MAX)
+            elif aligned is not None and alignment is None:
+                alignment = self._size(where, aligned['value'],
+                                       'blob alignment')
+            elif backings is None and all(word in BACKINGS
+                                          for word in arg.split()):
+                backings = tuple(arg.split())
+                if len(set(backings)) != len(backings):
+                    raise CtlvError(where, f'"{arg}" names a backing twice')
+            else:
+                raise CtlvError(where, f'"{arg}" is not a maximum length, an '
+                                       'alignment or a list of backings, or '
+                                       'is given twice')
+        maximum = U32_MAX if maximum is None else maximum
+        alignment = 1 if alignment is None else alignment
+        if maximum < 1:
+            raise CtlvError(where, 'a blob holds at least one byte')
+        if alignment < 1 or alignment & (alignment - 1):
+            raise CtlvError(where, f'blob alignment {alignment} is not a '
+                                   'power of two')
+        if maximum % alignment:
+            raise CtlvError(where, f'blob length {size_text(maximum)} is not '
+                                   'a multiple of alignment '
+                                   f'{size_text(alignment)}')
+        return BlobDecl(direction=direction,
+                        backings=backings or DEFAULT_BACKINGS,
+                        max_length=maximum, alignment=alignment)
+
+    def message(self, raw_op: dict[str, Any], key: str,
+                where: str) -> MessageSpec:
+        raw = raw_op.get(key)
+        doc = self.doc(raw_op, key)
+        if raw is None or raw == {}:
+            return MessageSpec(where=where, doc=doc)
+        if isinstance(raw, str):
+            found = _REFERENCE.fullmatch(raw)
+            assert found is not None
+            return MessageSpec(ref=found['name'], where=where, doc=doc)
+        return MessageSpec(body=self.body(raw, where), where=where, doc=doc)
+
+    def ops(self, raw_ops: dict[str, Any]) -> tuple[OpSpec, ...]:
+        ops = []
+        for name, raw in raw_ops.items():
+            where = self.where(raw_ops, name, f'op {name}')
+            op_type = raw['type']
+            suggested = raw.get('suggested-reply-length')
+            if suggested is not None:
+                suggested = self._size(where, str(suggested),
+                                       'suggested-reply-length')
+            self._check_op_keys(where, raw, op_type)
+            request = self.message(raw, 'request', f'{where} request')
+            reply = None
+            if 'reply' in raw:
+                reply = self.message(raw, 'reply', f'{where} reply')
+            ops.append(OpSpec(
+                name=name,
+                type=op_type,
+                where=where,
+                request=request,
+                reply=reply,
+                fd_access=raw.get('fd-access', DEFAULT_FD_ACCESS),
+                availability=raw.get('availability', DEFAULT_AVAILABILITY),
+                optional=raw.get('optional', False),
+                pre_post=raw.get('pre-post', False),
+                suggested_reply_length=suggested,
+                doc=self.doc(raw_ops, name),
+            ))
+        return tuple(ops)
+
+    def _check_op_keys(self, where: str, raw: dict[str, Any],
+                       op_type: str) -> None:
+        if op_type == 'query' and 'reply' not in raw:
+            raise CtlvError(where, 'a query op must declare a reply')
+        if 'suggested-reply-length' in raw and op_type != 'query':
+            raise CtlvError(where, 'suggested-reply-length is only valid on '
+                                   'a query op')
diff --git a/tools/ctlv/ctlvgen/lib/tree.py b/tools/ctlv/ctlvgen/lib/tree.py
new file mode 100644
index 000000000000..724c6569e9e3
--- /dev/null
+++ b/tools/ctlv/ctlvgen/lib/tree.py
@@ -0,0 +1,158 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+"""Whole-tree registry, specification and ABI checks, and regeneration."""
+
+from __future__ import annotations
+
+import pathlib
+import subprocess
+from collections.abc import Collection
+
+from . import compat
+from . import outputs
+from . import semantics
+from . import spec
+from .errors import CtlvError
+
+
+def _stems(directory: pathlib.Path, exclude: tuple[str, ...] = ()) -> set[str]:
+    return {path.stem for path in directory.glob('*.yaml')
+            if path.name not in exclude}
+
+
+def coverage_problems(
+        paths: spec.Paths, registry: spec.Registry, snapshots: bool = True,
+        allowed_missing_snapshots: Collection[str] = ()) -> list[str]:
+    expected = {entry.name for entry in registry.entries}
+    problems = []
+
+    actual_specs = _stems(paths.spec_dir)
+    for name in sorted(expected - actual_specs):
+        problems.append(f'missing specification {name}.yaml')
+    for name in sorted(actual_specs - expected):
+        problems.append(f'unexpected specification {name}.yaml')
+
+    if snapshots:
+        actual_abi = _stems(paths.abi_dir,
+                            exclude=(paths.registry_abi.name,))
+        missing = expected - actual_abi - set(allowed_missing_snapshots)
+        for name in sorted(missing):
+            problems.append(f'missing ABI snapshot {name}.yaml')
+        for name in sorted(actual_abi - expected):
+            problems.append(f'unexpected ABI snapshot {name}.yaml')
+    return problems
+
+
+def _relative(paths: spec.Paths,
+              path: pathlib.Path) -> pathlib.PurePosixPath:
+    return pathlib.PurePosixPath(path.relative_to(paths.kernel_dir).as_posix())
+
+
+def _families(paths: spec.Paths,
+              registry: spec.Registry) -> tuple[semantics.Family, ...]:
+    return tuple(semantics.load(spec.Paths(
+        paths.spec_dir / f'{entry.name}.yaml', schema=paths.schema,
+        registry=paths.registry)) for entry in registry.entries)
+
+
+def _snapshots(paths: spec.Paths, registry: spec.Registry,
+               families: tuple[semantics.Family, ...]
+               ) -> dict[pathlib.PurePosixPath, str]:
+    texts = {_relative(paths, paths.registry_abi):
+             compat.registry_render(registry)}
+    for family in families:
+        texts[_relative(paths, paths.abi(family.name))] = compat.render(family)
+    return texts
+
+
+def _git(root: pathlib.Path, *args: str) -> subprocess.CompletedProcess[str]:
+    return subprocess.run(['git', *args], cwd=root, capture_output=True,
+                          text=True, check=False)
+
+
+def _baseline(root: pathlib.Path, relative: pathlib.PurePosixPath,
+              committed: bool) -> tuple[str, str | None]:
+    """Where the ABI to keep is read from, and its text, or None for none.
+
+    Regeneration keeps what HEAD has, so that what it wrote but nobody
+    committed can still change. A check, or a tree without git, keeps the file.
+    """
+    if committed and (root / '.git').exists():
+        where = f'HEAD:./{relative}'
+        found = _git(root, 'rev-parse', '--verify', '--quiet', where)
+        if found.returncode == 1:
+            return where, None
+        if found.returncode == 0:
+            found = _git(root, 'cat-file', 'blob', found.stdout.strip())
+        if found.returncode:
+            raise CtlvError(str(root), found.stderr.strip())
+        return where, found.stdout
+    path = root.joinpath(*relative.parts)
+    if not path.is_file():
+        return str(path), None
+    return str(path), path.read_text(encoding='utf-8')
+
+
+def _breaks(paths: spec.Paths, root: pathlib.Path, registry: spec.Registry,
+            families: tuple[semantics.Family, ...],
+            committed: bool) -> list[str]:
+    problems = []
+    where, text = _baseline(root, _relative(paths, paths.registry_abi),
+                            committed)
+    if text is not None:
+        baseline = spec.load_registry(paths, where, text)
+        problems += [f'registry: {problem}' for problem in
+                     compat.registry_problems(baseline, registry)]
+    for family in families:
+        where, text = _baseline(root, _relative(paths, paths.abi(family.name)),
+                                committed)
+        if text is not None:
+            problems += [f'{family.name}: {problem}' for problem in
+                         compat.breaks(family, where, text)]
+    return problems
+
+
+def _root(paths: spec.Paths,
+          output_root: pathlib.Path | str | None) -> pathlib.Path:
+    return pathlib.Path(paths.kernel_dir if output_root is None
+                        else output_root)
+
+
+def check(paths: spec.Paths,
+          output_root: pathlib.Path | str | None = None) -> None:
+    """Fail on anything regeneration would change or refuse."""
+    registry = spec.load_registry(paths)
+    problems = coverage_problems(paths, registry)
+    if problems:
+        raise CtlvError('CTLV tree', '\n'.join(problems))
+    families = _families(paths, registry)
+    problems = _breaks(paths, _root(paths, output_root), registry, families,
+                       committed=False)
+    if problems:
+        raise CtlvError('the ABI snapshots', 'the specifications break them' +
+                        ''.join(f'\n  {problem}' for problem in problems))
+    outputs.reconcile(paths, output_root, check=True,
+                      extra=_snapshots(paths, registry, families))
+
+
+def update(paths: spec.Paths, output_root: pathlib.Path | str | None = None,
+           abi_break: bool = False) -> tuple[str, ...]:
+    """Regenerate every output and ABI snapshot, and say what changed.
+
+    A change that breaks the committed ABI is refused unless abi_break.
+    """
+    registry = spec.load_registry(paths)
+    problems = coverage_problems(
+        paths, registry,
+        allowed_missing_snapshots=[entry.name for entry in registry.entries])
+    if problems:
+        raise CtlvError('CTLV tree', '\n'.join(problems))
+    families = _families(paths, registry)
+    problems = _breaks(paths, _root(paths, output_root), registry, families,
+                       committed=True)
+    if problems and not abi_break:
+        raise CtlvError('the committed ABI', 'the specifications break it' +
+                        ''.join(f'\n  {problem}' for problem in problems) +
+                        '\nregen with ABI_BREAK=1 writes it anyway')
+    changed = outputs.reconcile(paths, output_root,
+                                extra=_snapshots(paths, registry, families))
+    return tuple(f'ABI break, {problem}' for problem in problems) + changed
diff --git a/tools/ctlv/ctlvgen/lib/yamlload.py b/tools/ctlv/ctlvgen/lib/yamlload.py
new file mode 100644
index 000000000000..0a470fa58d09
--- /dev/null
+++ b/tools/ctlv/ctlvgen/lib/yamlload.py
@@ -0,0 +1,138 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+"""Strict YAML subset loader.
+
+Anchors, aliases, merge keys, explicit tags, duplicate mapping keys and
+multiple documents per file are all rejected: they let two readers of a file
+that defines an ABI disagree about what it says.
+"""
+
+from __future__ import annotations
+
+import pathlib
+from collections.abc import Hashable, Iterator
+from typing import Any, NoReturn
+
+import yaml
+
+from .errors import CtlvError
+
+
+class Mapping(dict[Any, Any]):
+    """A mapping that knows the line each of its keys is on, from zero."""
+
+    def __init__(self) -> None:
+        super().__init__()
+        self.lines: dict[Any, int] = {}
+
+
+class Sequence(list[Any]):
+    """A list that knows the line each of its items starts on, from zero."""
+
+    def __init__(self) -> None:
+        super().__init__()
+        self.lines: list[int] = []
+
+
+def _mark(path: pathlib.Path | str, mark: yaml.error.Mark | None) -> str:
+    if mark is None:
+        return str(path)
+    return f'{path}:{mark.line + 1}'
+
+
+class _StrictLoader(yaml.SafeLoader):
+    """SafeLoader without the features that make a document ambiguous."""
+
+    def __init__(self, stream: str, path: pathlib.Path | str) -> None:
+        super().__init__(stream)
+        self.ctlv_path = path
+
+    def _reject(self, mark: yaml.error.Mark, what: str) -> NoReturn:
+        raise CtlvError(_mark(self.ctlv_path, mark), what)
+
+    def compose_node(self, parent: yaml.nodes.Node | None,
+                     index: int) -> yaml.nodes.Node | None:
+        event = self.peek_event()
+        mark = event.start_mark
+        if isinstance(event, yaml.events.AliasEvent):
+            self._reject(mark, 'YAML aliases are not allowed')
+        if getattr(event, 'anchor', None) is not None:
+            self._reject(mark, 'YAML anchors are not allowed')
+        if _has_explicit_tag(event):
+            self._reject(mark,
+                         f'explicit YAML tag "{event.tag}" is not allowed')
+        return super().compose_node(parent, index)
+
+    def construct_mapping(self, node: yaml.nodes.MappingNode,
+                          deep: bool = False) -> dict[Hashable, Any]:
+        seen = set()
+        for key_node, _ in node.value:
+            if key_node.tag == 'tag:yaml.org,2002:merge':
+                self._reject(key_node.start_mark,
+                             'YAML merge keys are not allowed')
+            key = self.construct_object(key_node, deep=deep)
+            if key in seen:
+                self._reject(key_node.start_mark, f'duplicate key "{key}"')
+            seen.add(key)
+        return super().construct_mapping(node, deep=deep)
+
+
+def _construct_map(loader: _StrictLoader,
+                   node: yaml.nodes.MappingNode) -> Iterator[Mapping]:
+    data = Mapping()
+    yield data
+    data.update(loader.construct_mapping(node))
+    for key_node, _value in node.value:
+        key = loader.construct_object(key_node)
+        data.lines[key] = key_node.start_mark.line
+
+
+def _construct_seq(loader: _StrictLoader,
+                   node: yaml.nodes.SequenceNode) -> Iterator[Sequence]:
+    data = Sequence()
+    yield data
+    data.extend(loader.construct_sequence(node))
+    data.lines = [item.start_mark.line for item in node.value]
+
+
+_StrictLoader.add_constructor('tag:yaml.org,2002:map', _construct_map)
+_StrictLoader.add_constructor('tag:yaml.org,2002:seq', _construct_seq)
+
+
+def _has_explicit_tag(event: yaml.events.Event) -> bool:
+    if getattr(event, 'tag', None) is None:
+        return False
+    implicit = getattr(event, 'implicit', False)
+    if isinstance(implicit, tuple):
+        return not (implicit[0] or implicit[1])
+    return not implicit
+
+
+def load(path: pathlib.Path | str, text: str | None = None) -> Mapping:
+    """Return the single YAML document in path, or in text read from it."""
+    return load_with_lines(path, text)[0]
+
+
+def load_with_lines(path: pathlib.Path | str,
+                    text: str | None = None) -> tuple[Mapping, list[str]]:
+    """Return the document in path, or in text, and the lines of its text."""
+    try:
+        if text is None:
+            with open(path, 'r', encoding='utf-8') as stream:
+                text = stream.read()
+        loader = _StrictLoader(text, path)
+        try:
+            data = loader.get_single_data()
+        finally:
+            loader.dispose()
+    except OSError as exc:
+        raise CtlvError(str(path), f'cannot read: {exc.strerror}') from exc
+    except yaml.YAMLError as exc:
+        mark = getattr(exc, 'problem_mark', None)
+        described = [getattr(exc, 'context', None),
+                     getattr(exc, 'problem', None)]
+        problem = ', '.join(part for part in described if part) or str(exc)
+        raise CtlvError(_mark(path, mark), problem) from exc
+
+    if not isinstance(data, Mapping):
+        raise CtlvError(str(path), 'expected a YAML mapping at the top level')
+    return data, text.splitlines()
diff --git a/tools/ctlv/pyproject.toml b/tools/ctlv/pyproject.toml
new file mode 100644
index 000000000000..fe1d04f589b2
--- /dev/null
+++ b/tools/ctlv/pyproject.toml
@@ -0,0 +1,30 @@
+[build-system]
+requires = ["setuptools>=61.0"]
+build-backend = "setuptools.build_meta"
+
+[project]
+name = "ctlvgen"
+authors = [
+    {name = "Jiri Pirko", email = "jiri@resnulli.us"},
+]
+description = "CTLV schema tool"
+version = "0.0.1"
+requires-python = ">=3.9"
+dependencies = [
+    "pyyaml==6.*",
+    "jsonschema==4.*"
+]
+
+[tool.setuptools.packages.find]
+include = ["ctlvgen", "ctlvgen.lib"]
+
+[project.scripts]
+ctlvgen = "ctlvgen.cli:main"
+
+[tool.mypy]
+strict = true
+
+# PyYAML's stubs leave parser methods the loader calls untyped.
+[[tool.mypy.overrides]]
+module = "ctlvgen.lib.yamlload"
+disallow_untyped_calls = false
diff --git a/tools/ctlv/requirements.txt b/tools/ctlv/requirements.txt
new file mode 100644
index 000000000000..2a73e762f9b9
--- /dev/null
+++ b/tools/ctlv/requirements.txt
@@ -0,0 +1,2 @@
+pyyaml==6.*
+jsonschema==4.*
-- 
2.56.0

