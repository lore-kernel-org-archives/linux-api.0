Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794586129;
	b=2jDQ9AqHVcFtPJG+DBS/jDb8mUwUv6llHEBv1uBkWZHIdwskYiKmFLh5QowoMIK8ETbG
	 CtG59braXh2T9YRLwS3vamTAFA4h9jtDAdWjeXTCW1u9hKg/xr3cNGvMe5dtqjVaeMRjv
	 xAFQV/IxJ/Ec9KsPdCuJR0531ajtVdj//vqTkWROCe+7RFMjwW7coWgnHwZnJGXDZpdmT
	 OIocZok0TBL/bR99jsetSOIm3vHrPHTuLiTYLnqJmq+mg0rSJOxF9fazYBwjut2yVIszE
	 a7tG19cOUdJxG4sHF1k0cz7LLHnh9OYQWYZRtJQFXbeuRGAZCPW/qVbaLtUgoZpAqcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586129;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fzc1mK2O1Uu0li4mTjJOEQZLCa4gCDCltQDdoo8XfiU=;
	b=yC/ceytyULWZre6iA/477eAMzRrOzDk2R1GY84i4DsXv5ofT/aNTzt0AE38sRjhQxllI
	 jGqo3wMEfb0JdS5wv0uaQYaH/ld739KH8O9Q0gIOydkiS8CQVBw4KeS6ocSgx0LlOFpIv
	 KD6zpHiyo1mfT/lliNq0s1YuUu+fflUQIDOAA08ErDDfkQnHQ8AnIH/8tli2qSXOEgxzy
	 B14kZuqVk8RECgS7InDBnTTfBYIDIriaGC7MS+3f5K+IWsS135nwQDjgYwiLQqpoIyZ53
	 B+ywu2fTb57HvEC6Uzs7GSStcRt8ceS4FkNe97H2GsSuZz9u/oaSUGG6Jee2u8dEGGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=ueHVSYHH;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A17A60A3803
	for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 16:08:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A17A60A3803
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=ueHVSYHH
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so1329065f8f.1
        for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 08:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1794586126; x=1795190926; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fzc1mK2O1Uu0li4mTjJOEQZLCa4gCDCltQDdoo8XfiU=;
        b=ueHVSYHH9ctuLZX/nxNaNdHV7n5EzTgQKhwRQVR/huoLQ6/Q/AxNTib9opuATC146s
         suDLWpONQNsBYwAGq4ktw+nxxdJEW8qB+9azqpuNpivUB1PRISatpjih3ijCrj+C/hpc
         gxQRKQxOtATpQeaNrdJxBs6o5K62jBc2uAVE9yaVG6b6+q9qlvdBIF5J+/NFBbcF7dpO
         lT/n4Mr01iNoEbWeaRuzn6BLPPzyCydy1SE3NULU1IOEWxDwjOVEJTrEl2VoFw7MPE6+
         vO0akEmsSdJf3FRmvnEgOxTpRe/OHxpflBwlBlQN85UtOaVl8IDDnonL1dyXwsPf1OlL
         mRDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794586126; x=1795190926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fzc1mK2O1Uu0li4mTjJOEQZLCa4gCDCltQDdoo8XfiU=;
        b=uEUFCYf8fIMDgokOnF+tuqD2KJtwP4BoAYLStN/XYtp4Bs74FK5ykXvrJA/p8fMq1i
         lhRcRWoNjMBSpYuFBKSXjSzpUiiPGmLE1qyrZaiav2ZUgkeTDdWh7CNB7mPCS9nTYcGO
         +OH0o2xSM0qD3Yl/zAOgU2x/mKds66lIL9Z8zDFn3qjvLz7wghdUVvKI/CaqiEFru4wt
         VBsKN8A4WKQ4CpaAri9mk7YER/Pk2QFyvaCeq7YmdOjsrFAEGQGubXfibEVNSggTKfjU
         hvsyvEfBS5kX5nUkp6M7havGGMNlnki6g7QaEPRzugbyvGn8FP6auYJ2k5CVJJQJjidw
         YNBQ==
X-Forwarded-Encrypted: i=1; AL+hErFJnoduoIMMsO/AowjStwZYC3zsrjAjUsNgMjeWiA4pe13y2wZSZSdiSmistj5hSfsgmukgUOV73oA=@vger.kernel.org
X-Gm-Message-State: APuU4Z8I+Th4ujQi5JCVZuwMiT7Eban6j7WyDPbjiYpxXwULa0itjthp
	ogEbz8CnTEZDTsqtuKY2ixRBJo009/NsoTXuvcVuYNdSxini9gssPIm8oeZELImAhnE=
X-Gm-Gg: AYBFou3ERgqY1IYhvw60W6SN7nah/pKLmKfSrgt340G1YB4hI2VVJ6S209LU+fvSgJJ
	JxiEc/GQBInAYRvH3h9yQiPmJcILcT74cZvl+X+Lr+hhnQUmJvTvn0fJmSAG7kl4ZowdZf2fd+b
	lwK3kMpmBbiISsviIipZI3HQuZ4MjIgMiRhRJfblX2h9kDu9ex+nF/32bnPh1r3a+SRopOXczL7
	qJ4XNAp7PmpybJUDQ581W08iaCYq36rqNwwFoSirDEN5xArFuXeGSnGf7RPHxhi94z3UfrXTOLY
	wsCYwrAZkbhYrgLaGyBzy6XHc5HpQXTUTc5+4Mai6K25GhnFWG3U6DGdOL8ojeUbK4rgjyvF0VL
	dT/UIBUjX0rNnSnomSgGdlUzqjTttQjDgjJW8l3BV5rc++6wqu4FYYLk9Zfyp67VP5REVecWlaM
	DP8Hzt+5pa/Jms5qGKsFBZg614icryFJaEJljHrEm3Gi+9mi1e8Ov8pF6Z+PdfNWO0CDbKYXj8y
	+HPwkQGs3YqFmoWmRr3LvhfTyre6XEF266xPHayvpfpgFf7lYbPwsWl5D2tk/6NKlbDynLSrj81
	P31C9H8KZanDKVBeTl/lHHPDc49bTCUPlJ6XeH+Z
X-Received: by 2002:a5d:6f19:0:b0:490:a3e7:8af3 with SMTP id ffacd0b85a97d-49c71a6547bmr5913924f8f.35.1794586126008;
        Fri, 13 Nov 2026 08:08:46 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5fb58fefsm6731068f8f.26.2026.11.13.08.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 08:08:45 -0800 (PST)
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
Subject: [PATCH RFC v2 1/9] attestation: Add the base family specification and generated files
Date: Fri, 13 Nov 2026 17:08:30 +0100
Message-ID: <20261113160838.2512652-2-jiri@resnulli.us>
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

Define the base attestation family. Reserve its family ID and add the
ABI snapshot, registry entry and generated kernel and UAPI files.

The ABI is intentionally specification-first. The generated descriptor
is linked after the provider and operation handlers arrive.

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- dropped the MR log ops and the sets, groups and attrs only they use
- dropped the family's priv lifecycle hooks
- made the hash algorithm attrs an enum of <linux/hash_info.h>
- replaced the blob class and representation with an evidence class,
  signed or event-log
- dropped max-total-output-length
- renamed stubs to extension points
- commented the values, operations and fields
- wrote the spec as op trees and records
- reported each signed object's challenge lengths, in bytes, as a list
  of up to 8 lengths and ranges
- let evidence-get omit the challenge
- took output blobs of any length
- merged mr-dump into mr-get, a query whose id is an optional filter
- listed an MR's banks in the provider's order, each once
- let mr-extend extend some of an MR's banks
- dropped the MR read caps, as every MR can be read
- numbered every enum member and flag bit
- moved the generated UAPI headers to include/uapi/ctlv/
- documented every item of the spec
- put each field's doc above its generated helpers
- said that every evidence-get produces new evidence
- replaced the format strings with the evidence-format enum and the
  evidence-vendor-format enum extension point
- named an evidence-get object by its ID
- said message instead of wire
- bounded an MR's banks by hash-algo, not a number
---
 Documentation/ctlv/abi/ctlv-attestation.yaml  | 147 +++++++++++
 Documentation/ctlv/abi/families.registry.yaml |   1 +
 Documentation/ctlv/families.yaml              |   1 +
 Documentation/ctlv/generated-files.yaml       |   7 +
 .../ctlv/specs/ctlv-attestation.yaml          | 181 ++++++++++++++
 MAINTAINERS                                   |   9 +
 .../generated/ctlv_attestation_gen.c          | 179 ++++++++++++++
 .../generated/ctlv_attestation_gen.h          | 204 +++++++++++++++
 include/uapi/ctlv/ctlv_attestation_gen.h      | 234 ++++++++++++++++++
 include/uapi/ctlv/ctlv_families_gen.h         |   1 +
 10 files changed, 964 insertions(+)
 create mode 100644 Documentation/ctlv/abi/ctlv-attestation.yaml
 create mode 100644 Documentation/ctlv/specs/ctlv-attestation.yaml
 create mode 100644 drivers/attestation/generated/ctlv_attestation_gen.c
 create mode 100644 drivers/attestation/generated/ctlv_attestation_gen.h
 create mode 100644 include/uapi/ctlv/ctlv_attestation_gen.h

diff --git a/Documentation/ctlv/abi/ctlv-attestation.yaml b/Documentation/ctlv/abi/ctlv-attestation.yaml
new file mode 100644
index 000000000000..16b7be1fbc70
--- /dev/null
+++ b/Documentation/ctlv/abi/ctlv-attestation.yaml
@@ -0,0 +1,147 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+%YAML 1.2
+---
+# Checked-in ABI snapshot of the ctlv-attestation family, from
+# Documentation/ctlv/specs/ctlv-attestation.yaml, written by
+# "make -C tools/ctlv regen".
+#
+# Updating the file is how a UAPI change gets reviewed; an update that
+# removes or renumbers anything, narrows a bound, or makes a member required
+# is an ABI break, whatever the file says afterwards.
+family: {name: ctlv-attestation, id: 1, inherits: ctlv}
+enums:
+  evidence-class: {signed: 1, event-log: 2}
+  evidence-format: {ccel: 1}
+  hash-algo: {$header: linux/hash_info.h, $enum: hash_algo,
+              $end: HASH_ALGO__LAST}
+flags:
+  mr-device-caps: {extend: 0}
+  mr-caps: {extend: 0}
+records:
+  mr-desc:
+    id: 0x00010000
+    fields:
+      name: {number: 1, type: string, min-length: 1, max-length: 128}
+      supported-hash-algorithms: {number: 2, enum: hash-algo,
+                                  max-occurrences: hash-algo}
+      caps: {number: 3, flags: mr-caps}
+      register-index: {number: 4, type: uint, max: u32-max, optional: true}
+  mr-value:
+    id: 0x00020000
+    fields:
+      hash-algo: {number: 1, enum: hash-algo}
+      data: {number: 2, type: binary, min-length: 16, max-length: 64}
+  mr-generation:
+    id: 0x00030000
+    fields:
+      mr-generation: {number: 1, type: uint, max: u32-max}
+  mr-values:
+    id: 0x00040000
+    fields:
+      mr-values: {number: 1, record: mr-value, max-occurrences: hash-algo}
+  device-get request:
+    id: 0x80010000
+  device-get reply:
+    id: 0xc0010000
+    fields:
+      caps: {number: 1, record: device-get caps}
+      info: {number: 2, extension: device-info}
+  device-get caps:
+    id: 0xc0011000
+    fields:
+      evidence: {number: 1, record: device-get caps.evidence, optional: true}
+      mr: {number: 2, record: device-get caps.mr, optional: true}
+  device-get caps.evidence:
+    id: 0xc0011100
+    fields:
+      objects: {number: 1, record: device-get caps.evidence.objects,
+                max-occurrences: 16}
+  device-get caps.evidence.objects:
+    id: 0xc0011110
+    fields:
+      id: {number: 1, type: uint, max: 15}
+      class: {number: 2, enum: evidence-class}
+      formats: {number: 3, enum: evidence-format, max-occurrences: 4,
+                optional: true}
+      vendor-formats: {number: 4, enum: evidence-vendor-format,
+                       max-occurrences: 4, optional: true}
+      max-length: {number: 5, type: uint}
+      challenge-lengths:
+        {number: 6, record: device-get caps.evidence.objects.challenge-lengths,
+         max-occurrences: 8, optional: true}
+  device-get caps.evidence.objects.challenge-lengths:
+    id: 0xc0011111
+    fields:
+      length: {number: 1, type: uint, min: 1, max: 4K, unit: bytes,
+               optional: true}
+      min-length: {number: 2, type: uint, min: 1, max: 4K, unit: bytes,
+                   optional: true}
+      max-length: {number: 3, type: uint, min: 1, max: 4K, unit: bytes,
+                   optional: true}
+  device-get caps.mr:
+    id: 0xc0011200
+    fields:
+      flags: {number: 1, flags: mr-device-caps}
+  evidence-get request:
+    id: 0x80020000
+    fields:
+      challenge: {number: 1, type: binary, min-length: 1, max-length: 4K,
+                  optional: true}
+      objects: {number: 2, record: evidence-get objects, max-occurrences: 16}
+  evidence-get objects:
+    id: 0x80021000
+    fields:
+      id: {number: 1, type: uint, max: 15}
+      data: {number: 2, blob: output, backings: [va], max-length: u32-max}
+  evidence-get reply:
+    id: 0xc0020000
+    fields:
+      results: {number: 1, record: evidence-get results, max-occurrences: 16}
+    members: ['record mr-generation?']
+  evidence-get results:
+    id: 0xc0021000
+    fields:
+      format: {number: 1, enum: evidence-format, optional: true}
+      vendor-format: {number: 2, enum: evidence-vendor-format, optional: true}
+      length: {number: 3, type: uint}
+  mr-get request:
+    id: 0x80030000
+    fields:
+      id: {number: 1, type: uint, max: u32-max, optional: true}
+  mr-get reply:
+    id: 0xc0030000
+    fields:
+      items: {number: 1, record: mr-get items, max-occurrences: unlimited}
+  mr-get items:
+    id: 0xc0031000
+    fields:
+      id: {number: 1, type: uint, max: u32-max}
+    members: [$include mr-desc]
+  mr-read request:
+    id: 0x80040000
+    fields:
+      id: {number: 1, type: uint, max: u32-max}
+  mr-read reply:
+    id: 0xc0040000
+    members: [record mr-generation, record mr-values]
+  mr-extend request:
+    id: 0x80050000
+    fields:
+      id: {number: 1, type: uint, max: u32-max}
+    members: [record mr-values]
+  mr-extend reply:
+    id: 0xc0050000
+    members: [record mr-generation]
+extensions: {device-info: 1}
+enum-extensions: {evidence-vendor-format: 1}
+ops:
+  device-get: {id: 1, type: action, fd-access: read,
+               request: device-get request, reply: device-get reply}
+  evidence-get: {id: 2, type: action, availability: dynamic, optional: true,
+                 request: evidence-get request, reply: evidence-get reply}
+  mr-get: {id: 3, type: query, fd-access: read, optional: true,
+           request: mr-get request, reply: mr-get reply}
+  mr-read: {id: 4, type: query, fd-access: read, optional: true,
+            request: mr-read request, reply: mr-read reply}
+  mr-extend: {id: 5, type: action, optional: true, request: mr-extend request,
+              reply: mr-extend reply}
diff --git a/Documentation/ctlv/abi/families.registry.yaml b/Documentation/ctlv/abi/families.registry.yaml
index 5845e7457771..7a5c6af29565 100644
--- a/Documentation/ctlv/abi/families.registry.yaml
+++ b/Documentation/ctlv/abi/families.registry.yaml
@@ -5,3 +5,4 @@
 # Written by "make -C tools/ctlv regen".
 families:
   - ctlv
+  - ctlv-attestation
diff --git a/Documentation/ctlv/families.yaml b/Documentation/ctlv/families.yaml
index 4d219d7af74a..dbb0243b873d 100644
--- a/Documentation/ctlv/families.yaml
+++ b/Documentation/ctlv/families.yaml
@@ -15,3 +15,4 @@
 
 families:
   - ctlv
+  - ctlv-attestation
diff --git a/Documentation/ctlv/generated-files.yaml b/Documentation/ctlv/generated-files.yaml
index d4766b176ceb..00a56634805d 100644
--- a/Documentation/ctlv/generated-files.yaml
+++ b/Documentation/ctlv/generated-files.yaml
@@ -16,3 +16,10 @@ families:
       kernel-header: include/linux/ctlv_gen.h
       kernel-source: lib/ctlv/ctlv_gen.c
       user-source: tools/ctlv/libctlv/ctlv_user_gen.c
+
+  - name: ctlv-attestation
+    source: Documentation/ctlv/specs/ctlv-attestation.yaml
+    outputs:
+      uapi-header: include/uapi/ctlv/ctlv_attestation_gen.h
+      kernel-header: drivers/attestation/generated/ctlv_attestation_gen.h
+      kernel-source: drivers/attestation/generated/ctlv_attestation_gen.c
diff --git a/Documentation/ctlv/specs/ctlv-attestation.yaml b/Documentation/ctlv/specs/ctlv-attestation.yaml
new file mode 100644
index 000000000000..78b2dad6318a
--- /dev/null
+++ b/Documentation/ctlv/specs/ctlv-attestation.yaml
@@ -0,0 +1,181 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+%YAML 1.2
+---
+# Attestation devices: evidence and measurement registers (MRs). The device's
+# family inherits this one, fills device-info and gives evidence-vendor-format
+# the formats its vendor defines.
+family: ctlv-attestation
+inherits: ctlv
+
+enums:
+  # What an evidence object is.
+  evidence-class:
+    # Made by evidence-get over its challenge, and signed by the root of
+    # trust.
+    - signed
+    # The platform's log of what firmware and the boot chain measured into
+    # the MRs. Later extends, through mr-extend or otherwise, are not in it.
+    - event-log
+  # A layout of an evidence object that a standard defines.
+  evidence-format:
+    # The log area of an ACPI CCEL table, a TCG crypto-agile event log.
+    - ccel
+  # A layout of an evidence object that one vendor defines, given by the
+  # device's family.
+  evidence-vendor-format: extension
+  # The kernel's hash algorithms.
+  hash-algo:
+    $header: linux/hash_info.h
+    $enum: hash_algo
+    $end: HASH_ALGO__LAST
+
+flags:
+  # What a device offers for its MRs.
+  mr-device-caps:
+    # mr-extend is provided.
+    - extend
+  # What one MR allows.
+  mr-caps:
+    # The MR may be extended.
+    - extend
+
+records:
+  # One MR, as mr-get describes it.
+  mr-desc:
+    # The platform's name for the MR, such as rtmr0.
+    name: string(1..128)
+    # Its banks, each once, in the provider's order.
+    supported-hash-algorithms[hash-algo]: hash-algo
+    # What it allows.
+    caps: mr-caps
+    # The hardware's number for the MR, where it has one: 0 for rtmr0.
+    register-index?: uint(..u32-max)
+
+  # One bank of an MR.
+  mr-value:
+    # The bank's algorithm.
+    hash-algo: hash-algo
+    # The digest, as long as hash-algo's.
+    data: binary(16..64)
+
+  # The device's MR generation, which each extend bumps.
+  mr-generation: uint(..u32-max)
+
+  # Values for banks of the MR, each bank once.
+  mr-values[hash-algo]: record mr-value
+
+ops:
+  # What the device can do, and its family's fields.
+  device-get:
+    type: action
+    fd-access: read
+    reply:
+      # What the device supports, fixed for its life.
+      caps:
+        # Present when the device produces evidence.
+        evidence?:
+          # One per object evidence-get can produce.
+          objects[16]:
+            # The device's handle for the object in requests.
+            id: uint(..15)
+            # What the object is.
+            class: evidence-class
+            # The layouts a standard defines that the object may have. At
+            # least one of formats and vendor-formats is present.
+            formats[4]?: evidence-format
+            # The layouts its vendor defines that the object may have.
+            vendor-formats[4]?: evidence-vendor-format
+            # The longest the object gets; a blob this long always holds it.
+            max-length: uint
+            # A signed object's challenge lengths: each entry is one length,
+            # or a range from min-length to max-length.
+            challenge-lengths[8]?:
+              # A single length.
+              length?: uint(1..4K, bytes)
+              # The shortest of a range.
+              min-length?: uint(1..4K, bytes)
+              # The longest of a range.
+              max-length?: uint(1..4K, bytes)
+        # Present when the device has MRs.
+        mr?:
+          # The MR operations the device provides.
+          flags: mr-device-caps
+      # The device's family's fields.
+      info: extension device-info
+
+  # Evidence objects, written into the caller's blobs. A signed object is made
+  # by the call, over the challenge, and never reused; the others are read as
+  # they stand at the call.
+  evidence-get:
+    type: action
+    fd-access: read-write
+    availability: dynamic
+    optional: true
+    request:
+      # Bound into each signed object named: pass a verifier's nonce, or a hash
+      # binding one to your context, never data a peer chose. Present exactly
+      # when a signed object is named, and of a length each of them takes.
+      challenge?: binary(1..4K)
+      # The objects to produce, each named once.
+      objects[16]:
+        # The object, by the ID device-get lists.
+        id: uint(..15)
+        # Where the object is written. One too short for it fails the op with
+        # EMSGSIZE, and error-info's required-length says how long it has to
+        # be.
+        data: blob(out, va)
+    reply:
+      # One per object, in request order.
+      results[16]:
+        # The layout it came in, where a standard defines it. Exactly one of
+        # format and vendor-format is present.
+        format?: evidence-format
+        # The layout it came in, where its vendor defines it.
+        vendor-format?: evidence-vendor-format
+        # The bytes written to its blob.
+        length: uint
+      # Present when the evidence depends on the MRs.
+      mr-generation?: record
+
+  # The MRs' IDs and descriptions, which do not change; mr-read returns
+  # values, which change with every extension and are read from the hardware.
+  mr-get:
+    type: query
+    fd-access: read
+    optional: true
+    suggested-reply-length: 4K
+    request:
+      # Only this MR; every MR without it.
+      id?: uint(..u32-max)
+    reply:
+      # One per MR, ordered by ID.
+      items[]:
+        # The device's handle for the MR in requests.
+        id: uint(..u32-max)
+        $include: mr-desc
+
+  # One MR's values, and the MR generation they belong to.
+  mr-read:
+    type: query
+    fd-access: read
+    optional: true
+    suggested-reply-length: 4K
+    request:
+      # The MR to read, by the ID mr-get lists.
+      id: uint(..u32-max)
+    reply:
+      mr-generation: record
+      mr-values: record
+
+  # Extends banks of the MR by digests, as TPM2_PCR_Extend.
+  mr-extend:
+    type: action
+    fd-access: read-write
+    optional: true
+    request:
+      # The MR to extend, by the ID mr-get lists.
+      id: uint(..u32-max)
+      # For the banks to extend, each once, in any order.
+      mr-values: record
+    reply:
+      mr-generation: record
diff --git a/MAINTAINERS b/MAINTAINERS
index b16bedbbe0b6..fa450924b921 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4433,6 +4433,15 @@ F:	rust/kernel/sync/atomic.rs
 F:	rust/kernel/sync/atomic/
 F:	rust/kernel/sync/refcount.rs
 
+ATTESTATION SUBSYSTEM
+M:	Jiri Pirko <jiri@nvidia.com>
+L:	linux-security-module@vger.kernel.org
+S:	Supported
+F:	Documentation/ctlv/abi/ctlv-attestation*
+F:	Documentation/ctlv/specs/ctlv-attestation*
+F:	drivers/attestation/
+F:	include/uapi/ctlv/ctlv_attestation*
+
 ATTO EXPRESSSAS SAS/SATA RAID SCSI DRIVER
 M:	Bradley Grove <linuxdrivers@attotech.com>
 L:	linux-scsi@vger.kernel.org
diff --git a/drivers/attestation/generated/ctlv_attestation_gen.c b/drivers/attestation/generated/ctlv_attestation_gen.c
new file mode 100644
index 000000000000..e1c759d6fd8a
--- /dev/null
+++ b/drivers/attestation/generated/ctlv_attestation_gen.c
@@ -0,0 +1,179 @@
+// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+/*
+ * Generated from Documentation/ctlv/specs/ctlv-attestation.yaml by
+ * tools/ctlv/ctlv-regen.sh. Do not edit.
+ */
+/* CTLV-GEN kernel source */
+
+#define _CTLV_GENERATED_METADATA_ONLY
+#include <linux/array_size.h>
+#include <linux/bits.h>
+#include <linux/build_bug.h>
+#include <linux/ctlv_family.h>
+#include <linux/export.h>
+#include <linux/limits.h>
+#include <linux/sizes.h>
+
+#include <uapi/ctlv/ctlv_gen.h>
+#include <uapi/ctlv/ctlv_attestation_gen.h>
+
+#include "ctlv_attestation_gen.h"
+
+static const struct ctlv_node_schema device_get_request_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(0, 0, 0),
+};
+
+static const struct ctlv_node_schema device_get_reply_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(1, 2, 2),
+	CTLV_NODE_SCHEMA_RECORD(CTLV_ATTESTATION_T_DEVICE_GET_CAPS, 1, 3, 2, 0),
+	CTLV_NODE_SCHEMA_RECORD(CTLV_ATTESTATION_T_DEVICE_GET_INFO, 1, 0, 0, 0),
+	CTLV_NODE_SCHEMA_RECORD(CTLV_ATTESTATION_T_DEVICE_GET_CAPS_EVIDENCE, 1, 5, 1, 1),
+	CTLV_NODE_SCHEMA_RECORD(CTLV_ATTESTATION_T_DEVICE_GET_CAPS_MR, 1, 6, 1, 1),
+	CTLV_NODE_SCHEMA_RECORD(CTLV_ATTESTATION_T_DEVICE_GET_EVIDENCE_OBJECTS, 16, 7, 6, 3),
+	CTLV_NODE_SCHEMA_FLAGS(CTLV_ATTESTATION_T_DEVICE_GET_MR_FLAGS, 1,
+			       CTLV_ATTESTATION_MR_DEVICE_CAPS_MASK),
+	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_T_DEVICE_GET_OBJECTS_ID, 1, 0, 15),
+	CTLV_NODE_SCHEMA_ENUM(CTLV_ATTESTATION_T_DEVICE_GET_OBJECTS_CLASS, 1, 2),
+	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_T_DEVICE_GET_OBJECTS_MAX_LENGTH, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_ENUM(CTLV_ATTESTATION_T_DEVICE_GET_OBJECTS_FORMATS, 4, 1),
+	CTLV_NODE_SCHEMA_ENUM_EXT(CTLV_ATTESTATION_T_DEVICE_GET_OBJECTS_VENDOR_FORMATS, 4,
+				  CTLV_FAMILY_ATTESTATION,
+				  CTLV_ATTESTATION_ENUM_EXT_EVIDENCE_VENDOR_FORMAT),
+	CTLV_NODE_SCHEMA_RECORD(CTLV_ATTESTATION_T_DEVICE_GET_OBJECTS_CHALLENGE_LENGTHS, 8, 13, 3,
+				0),
+	CTLV_NODE_SCHEMA_UINT_UNIT(CTLV_ATTESTATION_T_DEVICE_GET_CHALLENGE_LENGTHS_LENGTH, 1, 1,
+				   4096, CTLV_UNIT_BYTES, 0),
+	CTLV_NODE_SCHEMA_UINT_UNIT(CTLV_ATTESTATION_T_DEVICE_GET_CHALLENGE_LENGTHS_MIN_LENGTH, 1, 1,
+				   4096, CTLV_UNIT_BYTES, 0),
+	CTLV_NODE_SCHEMA_UINT_UNIT(CTLV_ATTESTATION_T_DEVICE_GET_CHALLENGE_LENGTHS_MAX_LENGTH, 1, 1,
+				   4096, CTLV_UNIT_BYTES, 0),
+};
+
+/* Extension points selected by this tree. */
+static const struct ctlv_ext_schema device_get_reply_ext_schemas[] = {
+	CTLV_EXT_SCHEMA(CTLV_FAMILY_ATTESTATION, CTLV_ATTESTATION_EXT_DEVICE_INFO, 2),
+};
+
+static const struct ctlv_node_schema evidence_get_request_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(1, 2, 1),
+	CTLV_NODE_SCHEMA_RECORD(CTLV_ATTESTATION_T_EVIDENCE_GET_OBJECTS, 16, 3, 2, 2),
+	CTLV_NODE_SCHEMA_BINARY(CTLV_ATTESTATION_T_EVIDENCE_GET_CHALLENGE, 1, 1, SZ_4K),
+	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_T_EVIDENCE_GET_OBJECTS_ID, 1, 0, 15),
+	CTLV_NODE_SCHEMA_BLOB(CTLV_ATTESTATION_T_EVIDENCE_GET_OBJECTS_DATA, 1, U32_MAX, 1,
+			      BIT(CTLV_BLOB_TYPE_VA),
+			      CTLV_BLOB_DIRECTION_OUTPUT),
+};
+
+static const struct ctlv_node_schema evidence_get_reply_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(1, 2, 1),
+	CTLV_NODE_SCHEMA_RECORD(CTLV_ATTESTATION_T_EVIDENCE_GET_RESULTS, 16, 3, 3, 1),
+	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_T_MR_GENERATION, 1, 0, U32_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_T_EVIDENCE_GET_RESULTS_LENGTH, 1, 0, U64_MAX),
+	CTLV_NODE_SCHEMA_ENUM(CTLV_ATTESTATION_T_EVIDENCE_GET_RESULTS_FORMAT, 1, 1),
+	CTLV_NODE_SCHEMA_ENUM_EXT(CTLV_ATTESTATION_T_EVIDENCE_GET_RESULTS_VENDOR_FORMAT, 1,
+				  CTLV_FAMILY_ATTESTATION,
+				  CTLV_ATTESTATION_ENUM_EXT_EVIDENCE_VENDOR_FORMAT),
+};
+
+static const struct ctlv_node_schema mr_get_request_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(1, 1, 0),
+	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_T_MR_GET_ID, 1, 0, U32_MAX),
+};
+
+static const struct ctlv_node_schema mr_get_reply_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(1, 1, 1),
+	CTLV_NODE_SCHEMA_RECORD(CTLV_ATTESTATION_T_MR_GET_ITEMS, CTLV_NODE_SCHEMA_UNLIMITED, 2, 5,
+				4),
+	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_T_MR_GET_ITEMS_ID, 1, 0, U32_MAX),
+	CTLV_NODE_SCHEMA_STRING(CTLV_ATTESTATION_T_MR_DESC_NAME, 1, 1, 128),
+	CTLV_NODE_SCHEMA_ENUM_RANGE(CTLV_ATTESTATION_T_MR_DESC_SUPPORTED_HASH_ALGORITHMS, 23,
+				    HASH_ALGO_MD4, HASH_ALGO__LAST - 1),
+	CTLV_NODE_SCHEMA_FLAGS(CTLV_ATTESTATION_T_MR_DESC_CAPS, 1, CTLV_ATTESTATION_MR_CAPS_MASK),
+	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_T_MR_DESC_REGISTER_INDEX, 1, 0, U32_MAX),
+};
+
+static const struct ctlv_node_schema mr_read_request_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(1, 1, 1),
+	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_T_MR_READ_ID, 1, 0, U32_MAX),
+};
+
+static const struct ctlv_node_schema mr_read_reply_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(1, 2, 2),
+	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_T_MR_GENERATION, 1, 0, U32_MAX),
+	CTLV_NODE_SCHEMA_RECORD(CTLV_ATTESTATION_T_MR_VALUES, 23, 3, 2, 2),
+	CTLV_NODE_SCHEMA_ENUM_RANGE(CTLV_ATTESTATION_T_MR_VALUE_HASH_ALGO, 1, HASH_ALGO_MD4,
+				    HASH_ALGO__LAST - 1),
+	CTLV_NODE_SCHEMA_BINARY(CTLV_ATTESTATION_T_MR_VALUE_DATA, 1, 16, 64),
+};
+
+static const struct ctlv_node_schema mr_extend_request_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(1, 2, 2),
+	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_T_MR_EXTEND_ID, 1, 0, U32_MAX),
+	CTLV_NODE_SCHEMA_RECORD(CTLV_ATTESTATION_T_MR_VALUES, 23, 3, 2, 2),
+	CTLV_NODE_SCHEMA_ENUM_RANGE(CTLV_ATTESTATION_T_MR_VALUE_HASH_ALGO, 1, HASH_ALGO_MD4,
+				    HASH_ALGO__LAST - 1),
+	CTLV_NODE_SCHEMA_BINARY(CTLV_ATTESTATION_T_MR_VALUE_DATA, 1, 16, 64),
+};
+
+static const struct ctlv_node_schema mr_extend_reply_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(1, 1, 1),
+	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_T_MR_GENERATION, 1, 0, U32_MAX),
+};
+
+/* The ops this family declares, in declaration order. */
+const struct ctlv_op_schema ctlv_attestation_op_schemas[] = {
+	CTLV_OP_SCHEMA_ACTION(CTLV_ATTESTATION_OP_DEVICE_GET, CTLV_OP_FD_ACCESS_READ,
+			      CTLV_OP_AVAILABILITY_FIXED, 16, 15848,
+			      CTLV_SCHEMA_TREE(device_get_request),
+			      CTLV_SCHEMA_TREE_EXTS(device_get_reply)),
+	CTLV_OP_SCHEMA_ACTION(CTLV_ATTESTATION_OP_EVIDENCE_GET, CTLV_OP_FD_ACCESS_READ_WRITE,
+			      CTLV_OP_AVAILABILITY_DYNAMIC, 6176, 1448,
+			      CTLV_SCHEMA_TREE(evidence_get_request),
+			      CTLV_SCHEMA_TREE(evidence_get_reply), .optional = true),
+	CTLV_OP_SCHEMA_QUERY(CTLV_ATTESTATION_OP_MR_GET, CTLV_OP_FD_ACCESS_READ,
+			     CTLV_OP_AVAILABILITY_FIXED, 40, 184, 4096,
+			     CTLV_SCHEMA_TREE(mr_get_request), CTLV_SCHEMA_TREE(mr_get_reply),
+			     .optional = true),
+	CTLV_OP_SCHEMA_QUERY(CTLV_ATTESTATION_OP_MR_READ, CTLV_OP_FD_ACCESS_READ,
+			     CTLV_OP_AVAILABILITY_FIXED, 40, 112, 4096,
+			     CTLV_SCHEMA_TREE(mr_read_request), CTLV_SCHEMA_TREE(mr_read_reply),
+			     .optional = true),
+	CTLV_OP_SCHEMA_ACTION(CTLV_ATTESTATION_OP_MR_EXTEND, CTLV_OP_FD_ACCESS_READ_WRITE,
+			      CTLV_OP_AVAILABILITY_FIXED, 2800, 40,
+			      CTLV_SCHEMA_TREE(mr_extend_request),
+			      CTLV_SCHEMA_TREE(mr_extend_reply), .optional = true),
+};
+
+/* The family ID is its position in the central registry. */
+const struct ctlv_family_schema ctlv_attestation_schema = {
+	.name = "ctlv-attestation",
+	.family_id = 1,
+	.ops = ctlv_attestation_op_schemas,
+	.ops_count = ARRAY_SIZE(ctlv_attestation_op_schemas),
+};
+
+/* Maximum uevent cost for this family chain. */
+static_assert(107 <= CTLV_UEVENT_MAX_LEN);
+static_assert(4 <= CTLV_UEVENT_MAX_VARS);
+
+/* Guards for generated maxima. */
+static_assert(15848 <= CTLV_MAX_INLINE_MESSAGE_LEN);
+static_assert(4 <= CTLV_MAX_DECLARED_RECORD_DEPTH);
+
+/* Local action and query bindings in declaration order. */
+static const struct ctlv_op ctlv_attestation_ops[] = {
+	CTLV_OP_ACTION(ctlv_attestation_device_get),
+	CTLV_OP_ACTION(ctlv_attestation_evidence_get),
+	CTLV_OP_QUERY(ctlv_attestation_mr_get),
+	CTLV_OP_QUERY(ctlv_attestation_mr_read),
+	CTLV_OP_ACTION(ctlv_attestation_mr_extend),
+};
+
+/* Family descriptor used by ctlv_init(). */
+const struct ctlv_family ctlv_attestation_family = {
+	.schema = &ctlv_attestation_schema,
+	.parent = &ctlv_family,
+	.ops = ctlv_attestation_ops,
+	.ops_count = ARRAY_SIZE(ctlv_attestation_ops),
+};
+EXPORT_SYMBOL_NS_GPL(ctlv_attestation_family, "CTLV");
diff --git a/drivers/attestation/generated/ctlv_attestation_gen.h b/drivers/attestation/generated/ctlv_attestation_gen.h
new file mode 100644
index 000000000000..5ff54385b42e
--- /dev/null
+++ b/drivers/attestation/generated/ctlv_attestation_gen.h
@@ -0,0 +1,204 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/*
+ * Generated from Documentation/ctlv/specs/ctlv-attestation.yaml by
+ * tools/ctlv/ctlv-regen.sh. Do not edit.
+ */
+/* CTLV-GEN kernel header */
+
+/* Kernel metadata and family API of the ctlv-attestation CTLV family. */
+
+#ifndef _LINUX_CTLV_ATTESTATION_GEN_H
+#define _LINUX_CTLV_ATTESTATION_GEN_H
+
+#include <linux/ctlv_family.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+
+#include <uapi/ctlv/ctlv_attestation_gen.h>
+
+/* Extension points, as a descendant's fill names one. */
+#define CTLV_ATTESTATION_EXT_DEVICE_INFO 1
+
+/* Enum extension points, numbered apart from the others. */
+#define CTLV_ATTESTATION_ENUM_EXT_EVIDENCE_VENDOR_FORMAT 1
+
+/* Ops this family declares, in declaration order. */
+extern const struct ctlv_op_schema ctlv_attestation_op_schemas[];
+
+extern const struct ctlv_family_schema ctlv_attestation_schema;
+
+/* Implemented by this family, one per action and query it declares. */
+int ctlv_attestation_device_get_action(struct ctlv *ctlv, struct ctlv_op_ctx *ctx,
+				       const struct ctlv_cursor *request,
+				       struct ctlv_cursor *reply);
+int ctlv_attestation_evidence_get_action(struct ctlv *ctlv, struct ctlv_op_ctx *ctx,
+					 const struct ctlv_cursor *request,
+					 struct ctlv_cursor *reply);
+int ctlv_attestation_mr_get_query(struct ctlv *ctlv, struct ctlv_op_ctx *ctx,
+				  const struct ctlv_cursor *request, struct ctlv_cursor *reply);
+int ctlv_attestation_mr_read_query(struct ctlv *ctlv, struct ctlv_op_ctx *ctx,
+				   const struct ctlv_cursor *request, struct ctlv_cursor *reply);
+int ctlv_attestation_mr_extend_action(struct ctlv *ctlv, struct ctlv_op_ctx *ctx,
+				      const struct ctlv_cursor *request, struct ctlv_cursor *reply);
+
+extern const struct ctlv_family ctlv_attestation_family;
+
+#ifndef _CTLV_GENERATED_METADATA_ONLY
+
+/* Optional publication and dynamic availability helpers. */
+CTLV_OP_PROVIDE(ctlv_attestation_evidence_get, CTLV_ATTESTATION_OP_EVIDENCE_GET)
+CTLV_OP_ENABLE(ctlv_attestation_evidence_get, CTLV_ATTESTATION_OP_EVIDENCE_GET)
+CTLV_OP_DISABLE(ctlv_attestation_evidence_get, CTLV_ATTESTATION_OP_EVIDENCE_GET)
+CTLV_OP_PROVIDE(ctlv_attestation_mr_get, CTLV_ATTESTATION_OP_MR_GET)
+CTLV_OP_PROVIDE(ctlv_attestation_mr_read, CTLV_ATTESTATION_OP_MR_READ)
+CTLV_OP_PROVIDE(ctlv_attestation_mr_extend, CTLV_ATTESTATION_OP_MR_EXTEND)
+
+/* Reading a validated message. A blob has a resolver instead of a getter. */
+/* The objects to produce, each named once. */
+CTLV_IN_REF(ctlv_attestation_evidence_get_objects, CTLV_ATTESTATION_T_EVIDENCE_GET_OBJECTS,
+	    CTLV_SCHEMA_RECORD)
+#define ctlv_attestation_evidence_get_objects_for_each(_cursor, _record) \
+	CTLV_IN_FOR_EACH(ctlv_attestation_evidence_get_objects, _cursor, _record)
+/* The object, by the ID device-get lists. */
+CTLV_IN_REF(ctlv_attestation_evidence_get_objects_id, CTLV_ATTESTATION_T_EVIDENCE_GET_OBJECTS_ID,
+	    CTLV_SCHEMA_UINT)
+CTLV_IN_HAS(ctlv_attestation_evidence_get_objects_id)
+CTLV_IN_U64(ctlv_attestation_evidence_get_objects_id)
+/*
+ * Where the object is written. One too short for it fails the op with EMSGSIZE, and error-info's
+ * required-length says how long it has to be.
+ */
+CTLV_IN_REF(ctlv_attestation_evidence_get_objects_data,
+	    CTLV_ATTESTATION_T_EVIDENCE_GET_OBJECTS_DATA, CTLV_SCHEMA_BLOB)
+CTLV_IN_HAS(ctlv_attestation_evidence_get_objects_data)
+CTLV_IN_BLOB(ctlv_attestation_evidence_get_objects_data)
+/*
+ * Bound into each signed object named: pass a verifier's nonce, or a hash binding one to your
+ * context, never data a peer chose. Present exactly when a signed object is named, and of a length
+ * each of them takes.
+ */
+CTLV_IN_REF(ctlv_attestation_evidence_get_challenge, CTLV_ATTESTATION_T_EVIDENCE_GET_CHALLENGE,
+	    CTLV_SCHEMA_BINARY)
+CTLV_IN_HAS(ctlv_attestation_evidence_get_challenge)
+CTLV_IN_BINARY(ctlv_attestation_evidence_get_challenge)
+/* Only this MR; every MR without it. */
+CTLV_IN_REF(ctlv_attestation_mr_get_id, CTLV_ATTESTATION_T_MR_GET_ID, CTLV_SCHEMA_UINT)
+CTLV_IN_HAS(ctlv_attestation_mr_get_id)
+CTLV_IN_U64(ctlv_attestation_mr_get_id)
+/* The MR to read, by the ID mr-get lists. */
+CTLV_IN_REF(ctlv_attestation_mr_read_id, CTLV_ATTESTATION_T_MR_READ_ID, CTLV_SCHEMA_UINT)
+CTLV_IN_HAS(ctlv_attestation_mr_read_id)
+CTLV_IN_U64(ctlv_attestation_mr_read_id)
+/* The MR to extend, by the ID mr-get lists. */
+CTLV_IN_REF(ctlv_attestation_mr_extend_id, CTLV_ATTESTATION_T_MR_EXTEND_ID, CTLV_SCHEMA_UINT)
+CTLV_IN_HAS(ctlv_attestation_mr_extend_id)
+CTLV_IN_U64(ctlv_attestation_mr_extend_id)
+/* Values for banks of the MR, each bank once. */
+CTLV_IN_REF(ctlv_attestation_mr_values, CTLV_ATTESTATION_T_MR_VALUES, CTLV_SCHEMA_RECORD)
+#define ctlv_attestation_mr_values_for_each(_cursor, _record) \
+	CTLV_IN_FOR_EACH(ctlv_attestation_mr_values, _cursor, _record)
+/* The bank's algorithm. */
+CTLV_IN_REF(ctlv_attestation_mr_value_hash_algo, CTLV_ATTESTATION_T_MR_VALUE_HASH_ALGO,
+	    CTLV_SCHEMA_ENUM)
+CTLV_IN_HAS(ctlv_attestation_mr_value_hash_algo)
+CTLV_IN_U64(ctlv_attestation_mr_value_hash_algo)
+/* The digest, as long as hash-algo's. */
+CTLV_IN_REF(ctlv_attestation_mr_value_data, CTLV_ATTESTATION_T_MR_VALUE_DATA, CTLV_SCHEMA_BINARY)
+CTLV_IN_HAS(ctlv_attestation_mr_value_data)
+CTLV_IN_BINARY(ctlv_attestation_mr_value_data)
+
+/* Writing a reply. An append is atomic; a record ends with ctlv_record_end(). */
+/* What the device supports, fixed for its life. */
+CTLV_RECORD_START(ctlv_attestation_device_get_caps, CTLV_ATTESTATION_T_DEVICE_GET_CAPS,
+		  CTLV_SCHEMA_RECORD)
+/* Present when the device produces evidence. */
+CTLV_RECORD_START(ctlv_attestation_device_get_caps_evidence,
+		  CTLV_ATTESTATION_T_DEVICE_GET_CAPS_EVIDENCE, CTLV_SCHEMA_RECORD)
+/* One per object evidence-get can produce. */
+CTLV_RECORD_START(ctlv_attestation_device_get_evidence_objects,
+		  CTLV_ATTESTATION_T_DEVICE_GET_EVIDENCE_OBJECTS, CTLV_SCHEMA_RECORD)
+/* The device's handle for the object in requests. */
+CTLV_PUT_U64(ctlv_attestation_device_get_objects_id, CTLV_ATTESTATION_T_DEVICE_GET_OBJECTS_ID,
+	     CTLV_SCHEMA_UINT)
+/* What the object is. */
+CTLV_PUT_U64(ctlv_attestation_device_get_objects_class, CTLV_ATTESTATION_T_DEVICE_GET_OBJECTS_CLASS,
+	     CTLV_SCHEMA_ENUM)
+/* The longest the object gets; a blob this long always holds it. */
+CTLV_PUT_U64(ctlv_attestation_device_get_objects_max_length,
+	     CTLV_ATTESTATION_T_DEVICE_GET_OBJECTS_MAX_LENGTH, CTLV_SCHEMA_UINT)
+/*
+ * The layouts a standard defines that the object may have. At least one of formats and
+ * vendor-formats is present.
+ */
+CTLV_PUT_U64(ctlv_attestation_device_get_objects_formats,
+	     CTLV_ATTESTATION_T_DEVICE_GET_OBJECTS_FORMATS, CTLV_SCHEMA_ENUM)
+/* The layouts its vendor defines that the object may have. */
+CTLV_PUT_U64(ctlv_attestation_device_get_objects_vendor_formats,
+	     CTLV_ATTESTATION_T_DEVICE_GET_OBJECTS_VENDOR_FORMATS, CTLV_SCHEMA_ENUM)
+/*
+ * A signed object's challenge lengths: each entry is one length, or a range from min-length to
+ * max-length.
+ */
+CTLV_RECORD_START(ctlv_attestation_device_get_objects_challenge_lengths,
+		  CTLV_ATTESTATION_T_DEVICE_GET_OBJECTS_CHALLENGE_LENGTHS, CTLV_SCHEMA_RECORD)
+/* A single length. */
+CTLV_PUT_U64(ctlv_attestation_device_get_challenge_lengths_length,
+	     CTLV_ATTESTATION_T_DEVICE_GET_CHALLENGE_LENGTHS_LENGTH, CTLV_SCHEMA_UINT)
+/* The shortest of a range. */
+CTLV_PUT_U64(ctlv_attestation_device_get_challenge_lengths_min_length,
+	     CTLV_ATTESTATION_T_DEVICE_GET_CHALLENGE_LENGTHS_MIN_LENGTH, CTLV_SCHEMA_UINT)
+/* The longest of a range. */
+CTLV_PUT_U64(ctlv_attestation_device_get_challenge_lengths_max_length,
+	     CTLV_ATTESTATION_T_DEVICE_GET_CHALLENGE_LENGTHS_MAX_LENGTH, CTLV_SCHEMA_UINT)
+/* Present when the device has MRs. */
+CTLV_RECORD_START(ctlv_attestation_device_get_caps_mr, CTLV_ATTESTATION_T_DEVICE_GET_CAPS_MR,
+		  CTLV_SCHEMA_RECORD)
+/* The MR operations the device provides. */
+CTLV_PUT_U64(ctlv_attestation_device_get_mr_flags, CTLV_ATTESTATION_T_DEVICE_GET_MR_FLAGS,
+	     CTLV_SCHEMA_FLAGS)
+/* The device's family's fields. */
+CTLV_RECORD_START(ctlv_attestation_device_get_info, CTLV_ATTESTATION_T_DEVICE_GET_INFO,
+		  CTLV_SCHEMA_RECORD)
+/* One per object, in request order. */
+CTLV_RECORD_START(ctlv_attestation_evidence_get_results, CTLV_ATTESTATION_T_EVIDENCE_GET_RESULTS,
+		  CTLV_SCHEMA_RECORD)
+/* The bytes written to its blob. */
+CTLV_PUT_U64(ctlv_attestation_evidence_get_results_length,
+	     CTLV_ATTESTATION_T_EVIDENCE_GET_RESULTS_LENGTH, CTLV_SCHEMA_UINT)
+/*
+ * The layout it came in, where a standard defines it. Exactly one of format and vendor-format is
+ * present.
+ */
+CTLV_PUT_U64(ctlv_attestation_evidence_get_results_format,
+	     CTLV_ATTESTATION_T_EVIDENCE_GET_RESULTS_FORMAT, CTLV_SCHEMA_ENUM)
+/* The layout it came in, where its vendor defines it. */
+CTLV_PUT_U64(ctlv_attestation_evidence_get_results_vendor_format,
+	     CTLV_ATTESTATION_T_EVIDENCE_GET_RESULTS_VENDOR_FORMAT, CTLV_SCHEMA_ENUM)
+/* The device's MR generation, which each extend bumps. */
+CTLV_PUT_U64(ctlv_attestation_mr_generation, CTLV_ATTESTATION_T_MR_GENERATION, CTLV_SCHEMA_UINT)
+/* One per MR, ordered by ID. */
+CTLV_RECORD_START(ctlv_attestation_mr_get_items, CTLV_ATTESTATION_T_MR_GET_ITEMS,
+		  CTLV_SCHEMA_RECORD)
+/* The device's handle for the MR in requests. */
+CTLV_PUT_U64(ctlv_attestation_mr_get_items_id, CTLV_ATTESTATION_T_MR_GET_ITEMS_ID, CTLV_SCHEMA_UINT)
+/* The platform's name for the MR, such as rtmr0. */
+CTLV_PUT_STRING(ctlv_attestation_mr_desc_name, CTLV_ATTESTATION_T_MR_DESC_NAME, CTLV_SCHEMA_STRING)
+/* Its banks, each once, in the provider's order. */
+CTLV_PUT_U64(ctlv_attestation_mr_desc_supported_hash_algorithms,
+	     CTLV_ATTESTATION_T_MR_DESC_SUPPORTED_HASH_ALGORITHMS, CTLV_SCHEMA_ENUM)
+/* What it allows. */
+CTLV_PUT_U64(ctlv_attestation_mr_desc_caps, CTLV_ATTESTATION_T_MR_DESC_CAPS, CTLV_SCHEMA_FLAGS)
+/* The hardware's number for the MR, where it has one: 0 for rtmr0. */
+CTLV_PUT_U64(ctlv_attestation_mr_desc_register_index, CTLV_ATTESTATION_T_MR_DESC_REGISTER_INDEX,
+	     CTLV_SCHEMA_UINT)
+/* Values for banks of the MR, each bank once. */
+CTLV_RECORD_START(ctlv_attestation_mr_values, CTLV_ATTESTATION_T_MR_VALUES, CTLV_SCHEMA_RECORD)
+/* The bank's algorithm. */
+CTLV_PUT_U64(ctlv_attestation_mr_value_hash_algo, CTLV_ATTESTATION_T_MR_VALUE_HASH_ALGO,
+	     CTLV_SCHEMA_ENUM)
+/* The digest, as long as hash-algo's. */
+CTLV_PUT_BINARY(ctlv_attestation_mr_value_data, CTLV_ATTESTATION_T_MR_VALUE_DATA,
+		CTLV_SCHEMA_BINARY)
+#endif /* _CTLV_GENERATED_METADATA_ONLY */
+
+#endif /* _LINUX_CTLV_ATTESTATION_GEN_H */
diff --git a/include/uapi/ctlv/ctlv_attestation_gen.h b/include/uapi/ctlv/ctlv_attestation_gen.h
new file mode 100644
index 000000000000..f4a1cfe02bb2
--- /dev/null
+++ b/include/uapi/ctlv/ctlv_attestation_gen.h
@@ -0,0 +1,234 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/*
+ * Generated from Documentation/ctlv/specs/ctlv-attestation.yaml by
+ * tools/ctlv/ctlv-regen.sh. Do not edit.
+ */
+/* CTLV-GEN uapi header */
+
+/*
+ * Constants of the ctlv-attestation CTLV family. Types and op IDs are complete; the message format
+ * carrying them is in <ctlv/ctlv.h>.
+ *
+ * The inherited ctlv header is included here, so one include covers the whole effective schema.
+ */
+
+#ifndef _UAPI_CTLV_CTLV_ATTESTATION_GEN_H
+#define _UAPI_CTLV_CTLV_ATTESTATION_GEN_H
+
+#include <ctlv/ctlv.h>
+#include <ctlv/ctlv_families_gen.h>
+#include <ctlv/ctlv_gen.h>
+#include <linux/const.h>
+#include <linux/hash_info.h>
+
+/* enum evidence-class */
+enum _ctlv_attestation_evidence_class {
+	/* Made by evidence-get over its challenge, and signed by the root of trust. */
+	CTLV_ATTESTATION_EVIDENCE_CLASS_SIGNED = 1,
+	/*
+	 * The platform's log of what firmware and the boot chain measured into the MRs. Later
+	 * extends, through mr-extend or otherwise, are not in it.
+	 */
+	CTLV_ATTESTATION_EVIDENCE_CLASS_EVENT_LOG = 2,
+};
+
+/* enum evidence-format */
+enum _ctlv_attestation_evidence_format {
+	/* The log area of an ACPI CCEL table, a TCG crypto-agile event log. */
+	CTLV_ATTESTATION_EVIDENCE_FORMAT_CCEL = 1,
+};
+
+/* flags mr-device-caps */
+enum _ctlv_attestation_mr_device_caps_bit {
+	CTLV_ATTESTATION_MR_DEVICE_CAPS_EXTEND_BIT = 0,
+};
+
+/* mr-extend is provided. */
+#define CTLV_ATTESTATION_MR_DEVICE_CAPS_EXTEND _BITULL(CTLV_ATTESTATION_MR_DEVICE_CAPS_EXTEND_BIT)
+#define CTLV_ATTESTATION_MR_DEVICE_CAPS_MASK CTLV_ATTESTATION_MR_DEVICE_CAPS_EXTEND
+
+/* flags mr-caps */
+enum _ctlv_attestation_mr_caps_bit {
+	CTLV_ATTESTATION_MR_CAPS_EXTEND_BIT = 0,
+};
+
+/* The MR may be extended. */
+#define CTLV_ATTESTATION_MR_CAPS_EXTEND _BITULL(CTLV_ATTESTATION_MR_CAPS_EXTEND_BIT)
+#define CTLV_ATTESTATION_MR_CAPS_MASK CTLV_ATTESTATION_MR_CAPS_EXTEND
+
+/* mr-desc */
+/* The platform's name for the MR, such as rtmr0. */
+#define CTLV_ATTESTATION_T_MR_DESC_NAME \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0x00010000, 1)
+/* Its banks, each once, in the provider's order. */
+#define CTLV_ATTESTATION_T_MR_DESC_SUPPORTED_HASH_ALGORITHMS \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0x00010000, 2)
+/* What it allows. */
+#define CTLV_ATTESTATION_T_MR_DESC_CAPS \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0x00010000, 3)
+/* The hardware's number for the MR, where it has one: 0 for rtmr0. */
+#define CTLV_ATTESTATION_T_MR_DESC_REGISTER_INDEX \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0x00010000, 4)
+
+/* mr-value */
+/* The bank's algorithm. */
+#define CTLV_ATTESTATION_T_MR_VALUE_HASH_ALGO \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0x00020000, 1)
+/* The digest, as long as hash-algo's. */
+#define CTLV_ATTESTATION_T_MR_VALUE_DATA \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0x00020000, 2)
+
+/* mr-generation */
+/* The device's MR generation, which each extend bumps. */
+#define CTLV_ATTESTATION_T_MR_GENERATION \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0x00030000, 1)
+
+/* mr-values */
+/* Values for banks of the MR, each bank once. */
+#define CTLV_ATTESTATION_T_MR_VALUES \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0x00040000, 1)
+
+/* device-get reply */
+/* What the device supports, fixed for its life. */
+#define CTLV_ATTESTATION_T_DEVICE_GET_CAPS \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0xc0010000, 1)
+/* The device's family's fields. */
+#define CTLV_ATTESTATION_T_DEVICE_GET_INFO \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0xc0010000, 2)
+
+/* device-get caps */
+/* Present when the device produces evidence. */
+#define CTLV_ATTESTATION_T_DEVICE_GET_CAPS_EVIDENCE \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0xc0011000, 1)
+/* Present when the device has MRs. */
+#define CTLV_ATTESTATION_T_DEVICE_GET_CAPS_MR \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0xc0011000, 2)
+
+/* device-get caps.evidence */
+/* One per object evidence-get can produce. */
+#define CTLV_ATTESTATION_T_DEVICE_GET_EVIDENCE_OBJECTS \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0xc0011100, 1)
+
+/* device-get caps.evidence.objects */
+/* The device's handle for the object in requests. */
+#define CTLV_ATTESTATION_T_DEVICE_GET_OBJECTS_ID \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0xc0011110, 1)
+/* What the object is. */
+#define CTLV_ATTESTATION_T_DEVICE_GET_OBJECTS_CLASS \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0xc0011110, 2)
+/*
+ * The layouts a standard defines that the object may have. At least one of formats and
+ * vendor-formats is present.
+ */
+#define CTLV_ATTESTATION_T_DEVICE_GET_OBJECTS_FORMATS \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0xc0011110, 3)
+/* The layouts its vendor defines that the object may have. */
+#define CTLV_ATTESTATION_T_DEVICE_GET_OBJECTS_VENDOR_FORMATS \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0xc0011110, 4)
+/* The longest the object gets; a blob this long always holds it. */
+#define CTLV_ATTESTATION_T_DEVICE_GET_OBJECTS_MAX_LENGTH \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0xc0011110, 5)
+/*
+ * A signed object's challenge lengths: each entry is one length, or a range from min-length to
+ * max-length.
+ */
+#define CTLV_ATTESTATION_T_DEVICE_GET_OBJECTS_CHALLENGE_LENGTHS \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0xc0011110, 6)
+
+/* device-get caps.evidence.objects.challenge-lengths */
+/* A single length. */
+#define CTLV_ATTESTATION_T_DEVICE_GET_CHALLENGE_LENGTHS_LENGTH \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0xc0011111, 1)
+#define CTLV_ATTESTATION_T_DEVICE_GET_CHALLENGE_LENGTHS_LENGTH_UNIT CTLV_UNIT_BYTES
+#define CTLV_ATTESTATION_T_DEVICE_GET_CHALLENGE_LENGTHS_LENGTH_SCALE 0
+/* The shortest of a range. */
+#define CTLV_ATTESTATION_T_DEVICE_GET_CHALLENGE_LENGTHS_MIN_LENGTH \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0xc0011111, 2)
+#define CTLV_ATTESTATION_T_DEVICE_GET_CHALLENGE_LENGTHS_MIN_LENGTH_UNIT CTLV_UNIT_BYTES
+#define CTLV_ATTESTATION_T_DEVICE_GET_CHALLENGE_LENGTHS_MIN_LENGTH_SCALE 0
+/* The longest of a range. */
+#define CTLV_ATTESTATION_T_DEVICE_GET_CHALLENGE_LENGTHS_MAX_LENGTH \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0xc0011111, 3)
+#define CTLV_ATTESTATION_T_DEVICE_GET_CHALLENGE_LENGTHS_MAX_LENGTH_UNIT CTLV_UNIT_BYTES
+#define CTLV_ATTESTATION_T_DEVICE_GET_CHALLENGE_LENGTHS_MAX_LENGTH_SCALE 0
+
+/* device-get caps.mr */
+/* The MR operations the device provides. */
+#define CTLV_ATTESTATION_T_DEVICE_GET_MR_FLAGS \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0xc0011200, 1)
+
+/* evidence-get request */
+/*
+ * Bound into each signed object named: pass a verifier's nonce, or a hash binding one to your
+ * context, never data a peer chose. Present exactly when a signed object is named, and of a length
+ * each of them takes.
+ */
+#define CTLV_ATTESTATION_T_EVIDENCE_GET_CHALLENGE \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0x80020000, 1)
+/* The objects to produce, each named once. */
+#define CTLV_ATTESTATION_T_EVIDENCE_GET_OBJECTS \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0x80020000, 2)
+
+/* evidence-get objects */
+/* The object, by the ID device-get lists. */
+#define CTLV_ATTESTATION_T_EVIDENCE_GET_OBJECTS_ID \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0x80021000, 1)
+/*
+ * Where the object is written. One too short for it fails the op with EMSGSIZE, and error-info's
+ * required-length says how long it has to be.
+ */
+#define CTLV_ATTESTATION_T_EVIDENCE_GET_OBJECTS_DATA \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0x80021000, 2)
+
+/* evidence-get reply */
+/* One per object, in request order. */
+#define CTLV_ATTESTATION_T_EVIDENCE_GET_RESULTS \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0xc0020000, 1)
+
+/* evidence-get results */
+/*
+ * The layout it came in, where a standard defines it. Exactly one of format and vendor-format is
+ * present.
+ */
+#define CTLV_ATTESTATION_T_EVIDENCE_GET_RESULTS_FORMAT \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0xc0021000, 1)
+/* The layout it came in, where its vendor defines it. */
+#define CTLV_ATTESTATION_T_EVIDENCE_GET_RESULTS_VENDOR_FORMAT \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0xc0021000, 2)
+/* The bytes written to its blob. */
+#define CTLV_ATTESTATION_T_EVIDENCE_GET_RESULTS_LENGTH \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0xc0021000, 3)
+
+/* mr-get request */
+/* Only this MR; every MR without it. */
+#define CTLV_ATTESTATION_T_MR_GET_ID \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0x80030000, 1)
+
+/* mr-get reply */
+/* One per MR, ordered by ID. */
+#define CTLV_ATTESTATION_T_MR_GET_ITEMS \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0xc0030000, 1)
+
+/* mr-get items */
+/* The device's handle for the MR in requests. */
+#define CTLV_ATTESTATION_T_MR_GET_ITEMS_ID \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0xc0031000, 1)
+
+/* mr-read request */
+/* The MR to read, by the ID mr-get lists. */
+#define CTLV_ATTESTATION_T_MR_READ_ID \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0x80040000, 1)
+
+/* mr-extend request */
+/* The MR to extend, by the ID mr-get lists. */
+#define CTLV_ATTESTATION_T_MR_EXTEND_ID \
+	CTLV_TYPE(CTLV_FAMILY_ATTESTATION, 0x80050000, 1)
+
+/* ops */
+#define CTLV_ATTESTATION_OP_DEVICE_GET CTLV_OP(CTLV_FAMILY_ATTESTATION, 1)
+#define CTLV_ATTESTATION_OP_EVIDENCE_GET CTLV_OP(CTLV_FAMILY_ATTESTATION, 2)
+#define CTLV_ATTESTATION_OP_MR_GET CTLV_OP(CTLV_FAMILY_ATTESTATION, 3)
+#define CTLV_ATTESTATION_OP_MR_READ CTLV_OP(CTLV_FAMILY_ATTESTATION, 4)
+#define CTLV_ATTESTATION_OP_MR_EXTEND CTLV_OP(CTLV_FAMILY_ATTESTATION, 5)
+
+#endif /* _UAPI_CTLV_CTLV_ATTESTATION_GEN_H */
diff --git a/include/uapi/ctlv/ctlv_families_gen.h b/include/uapi/ctlv/ctlv_families_gen.h
index 83f1719c89aa..83f6a257ddf2 100644
--- a/include/uapi/ctlv/ctlv_families_gen.h
+++ b/include/uapi/ctlv/ctlv_families_gen.h
@@ -12,6 +12,7 @@
 
 enum _ctlv_family {
 	CTLV_FAMILY_ROOT = 0,
+	CTLV_FAMILY_ATTESTATION = 1,
 };
 
 #endif /* _UAPI_CTLV_CTLV_FAMILIES_GEN_H */
-- 
2.56.0

