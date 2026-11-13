Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585390;
	b=K8eMgBOUJfyogWaL68+sMD5/p5eB1v8rbAfGgLhi4CxMZ59vdrdBalBwD86WQUMcIZ8L
	 x4+ZbAwjYvGBdZ6WellBErBkkCwihEn/+dTnWqxiHZ17TSK1YsR1NwtiYRmP5qftuRo7m
	 k83MkwC6cfpPEAUUB+HAhiE2zfyCt0JilJ9zw4OaigmzDt5ggS4pEEfyQ9T2AwKcNnTew
	 B/c/qrmLU87ezk/O8nypX503IceD1uYd8pNiVwWwWXRt5KXb9l0WCtyMPqd0NS/mXdkMt
	 +IpIF9ns1Yfugi9KUIvXJ4a83gH5sfHMjBKGhnC3bQHG8VhmtoMbGZ/3qA2A6rFM0Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585390;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JcTi3sxvuGcrSNBBRa/NlMOXS13wjV4ymMaAnQWU+10=;
	b=EmPpgiVpMKrdtnEumtWeNuHHfk+rjNRLazYY/DvdRoyMJcgOXgez5vsUkO5YT9eiUBlq
	 YDdekZCmA7Smwe03ebzBTGfbsmfYDHuQJkHtoIEMsaL6waLtioxP40VL/hXzkVeloMuKI
	 CneytDSmL1cYV0qrWcy5Vt5mOHtRA6ksuZlvcyiLvWKLdH9YjZuSANTGwiBDUuj+8MbNc
	 sfRa+Kn4VnSnjh6qtFjmgMfiyfB4vVWt4b6jtcmBKgo9ddgF9nSXWfYfKUJFAaOsbxEbG
	 X3gdXwrzN4H6/AJZSRGUf2C9ESi41QVzNJ61r7skMNFZPPAB5uILpcmFk4GXQywBSNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=MeR5EwUO;
	arc=none smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF6B6070239
	for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 15:56:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BF6B6070239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=MeR5EwUO
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c4cac7a7d3cso195681466b.3
        for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 07:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1794585386; x=1795190186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JcTi3sxvuGcrSNBBRa/NlMOXS13wjV4ymMaAnQWU+10=;
        b=MeR5EwUO5t8AuWJDv9SU64oybGvzFKaxAtCSFgf9NANutTjhSAisSrmuU1t12pWt9O
         V9KCFvNtEnGLiRxx/Q49mSE9keSWOS0abnjRD5OH09XZMC1CGeH02+W8CXwpbBthJKg8
         0OprNYSzmEyc9+jBcmsD46nQFXnfzYACXulgLkd9VN5gNU5YKS2y1SOCYf1amnXdnhd3
         vujQZISS4LeJv5J7btPYjnGRHfr/+e+F+hOlELP9v8FaSI5s5/BYPzxRczXnogQJEspH
         Ac8vy0I/i/DgkreQB4lG/KLvqv5rTXUiOgWtjnRml63pWP4ZYz90fmKYj+T5vOS4F+iS
         vv1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794585386; x=1795190186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JcTi3sxvuGcrSNBBRa/NlMOXS13wjV4ymMaAnQWU+10=;
        b=g6knRR5el3GT0Baj+iN78RWxHFIKmp8w+SrhH/Ut0snNBA4rfsa+5YIFo5ph5PDijT
         QzkLlrOIyNrFv1LccyqoH3gpuAjH9Wav68VL8foYfQDIAYrxuRopxUnMia1VhE+dYiSZ
         o10OmyAfJmPG5ru7LK8zRXjH6N68IDwshBVPjLbJzg8PdA5ITaz57qkAZCtho5OIbCRg
         9Df58Nv7ogRePHGLFvguH9Nzm/amGhL9Mr1MfYTqsffftWUPjU1DdKchKx94BabXJwr3
         0uojFbP0CDa/jo45tpALEbFGK+EirV/aaUvdxpBsWR68mSxNfsK6B1RaSmxNLiP/Oqs6
         CtWA==
X-Forwarded-Encrypted: i=1; AL+hErE8cRqQ0CIo2/m9OaWXWkio1FmDAEajvRikztSZMtj50eLjCs9HxeL7s72bLUIk6QIHZGVyRRN00hw=@vger.kernel.org
X-Gm-Message-State: APuU4Z92uvVWrWFD7jdAk6YtqjybuzbrJSa1IFh3fe+dfFX6PIrPoseD
	MxJu0Ub0Pkf3HuDlQhb+NIgIJj4FD+tMWIR2fpCZ64xoPxkwlVF2yP67dax6eNlQNfw=
X-Gm-Gg: AYBFou1MEqMZ2AGLexFAvwm0OLlZu22xTRLAggZwNCy+xqdFUXZRtURcwZef5NyjN2k
	pwihEVc2xPgwYTDJhwY18X9GSfvXgM1lsxBZ9IA7pO3uXmmZnxITdlKj5xLLkbde9wWVJH6dHwi
	4vzSWTjLQ9CLWU3f/eD46rHlDzoJ1UArPKrV97hh7VbAbEbWpx5hmhpzJuZ7IV8vdONsUPg+HYj
	KE08Tp4XbnUj9Y2evLP+kAaSBkfhf0KUZR91J04IgAtujwQf57uonaSF6Z8JBYEOgkDmChAGQzp
	T7Wrl+h1dzo6YM/CSIW/hk45AR2CiE5J4Kg/grVBeuKIQmoRqJEs3hB2jbhBTfhHvOIHHY1AbIx
	QkS+bgUb1tqVVeJSg3ipn0qx+ZCJkqZftQVdMYrfpgsgNwSUEoficozAs2pCwXkIck1+PLOM1GL
	x/pu9drEqUVpeBwP/QUxqWZXaOxDlGUermN5e3JHbR/8jKRof7fLdLN1CvgpqP6g1QeuQao5nen
	rYqBg3ymWhrfyK68qvc4UZ2hMTtbc7hXv8Zb/PGnBxWD87hZhLRuW6StAIzHq5NNrW2O503Brff
	x46BsKCtTnoIiBKi8vSNJjjALoNBJaH1FARfkRYrWVdzZYQSsXn9Nfb9hAIe0Q==
X-Received: by 2002:a17:907:9444:b0:c46:9ca9:f522 with SMTP id a640c23a62f3a-c5096428c34mr246003766b.26.1794585384914;
        Fri, 13 Nov 2026 07:56:24 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b42480sm114994466b.36.2026.11.13.07.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 07:56:24 -0800 (PST)
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
Subject: [PATCH RFC v2 15/15] tools/ctlv: Add ctlvctl
Date: Fri, 13 Nov 2026 16:55:14 +0100
Message-ID: <20261113155515.2510194-16-jiri@resnulli.us>
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

Add a command-line client that discovers and queries any CTLV device,
with optional names from a specification directory.

Examples:
  Root-family discovery on any CTLV device:
    ctlvctl --spec-dir Documentation/ctlv/specs \
      exec ctlv-example family-get
  The operations the same device publishes:
    ctlvctl --spec-dir Documentation/ctlv/specs ops ctlv-example

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 Documentation/driver-api/ctlv.rst     |   29 +-
 Documentation/userspace-api/ctlv.rst  |   80 +-
 tools/Makefile                        |    9 +-
 tools/ctlv/Makefile                   |   23 +-
 tools/ctlv/ctlvctl/.gitignore         |    4 +
 tools/ctlv/ctlvctl/Makefile           |   64 +
 tools/ctlv/ctlvctl/ctlvctl.c          | 2787 +++++++++++++++++++++++++
 tools/ctlv/ctlvctl/spec.c             |  672 ++++++
 tools/ctlv/ctlvctl/spec.h             |   60 +
 tools/ctlv/ctlvgen/cli.py             |   47 +-
 tools/ctlv/ctlvgen/lib/dump.py        |  161 ++
 tools/ctlv/ctlvgen/lib/gen_doc.py     |  684 ++++++
 tools/ctlv/ctlvgen/lib/gen_runtime.py |   66 +
 13 files changed, 4661 insertions(+), 25 deletions(-)
 create mode 100644 tools/ctlv/ctlvctl/.gitignore
 create mode 100644 tools/ctlv/ctlvctl/Makefile
 create mode 100644 tools/ctlv/ctlvctl/ctlvctl.c
 create mode 100644 tools/ctlv/ctlvctl/spec.c
 create mode 100644 tools/ctlv/ctlvctl/spec.h
 create mode 100644 tools/ctlv/ctlvgen/lib/dump.py
 create mode 100644 tools/ctlv/ctlvgen/lib/gen_doc.py
 create mode 100644 tools/ctlv/ctlvgen/lib/gen_runtime.py

diff --git a/Documentation/driver-api/ctlv.rst b/Documentation/driver-api/ctlv.rst
index f6a4f9632e3a..e8e6ecdf6ab6 100644
--- a/Documentation/driver-api/ctlv.rst
+++ b/Documentation/driver-api/ctlv.rst
@@ -235,6 +235,9 @@ checks the same without writing anything.
 
 Never edit a generated file; change the YAML or the generator and regenerate.
 
+``make -C tools/ctlv docs`` writes optional RST reference pages to
+``Documentation/output/ctlv/families``.
+
 Create and destroy a device
 ===========================
 
@@ -684,20 +687,24 @@ The node is of the foo driver's own class, ``foo_class``, registered as
 that ``ctlv_family_inherits()`` says is not ``ctlv-example`` or a descendant,
 then calls ``ctlv_init()``.
 
-Reporting an error
-------------------
+Tests and examples
+==================
+
+``Documentation/ctlv/specs/ctlv-test.yaml``
+    Every schema kind, records, actions, queries, blobs, availability, hooks,
+    and an extension point.
+
+``drivers/ctlv/tests/ctlv_test.c``
+    The ``ctlv-test`` family implementation.
 
-A callback returns a negative errno, and that is what the ioctl returns. Where
-CTLV itself refuses a message it also writes error information into the
-caller's reply buffer, naming the reason and the offset of the offending
-TLV. A family implementation does not build that; it adds its own errno
-and its reply.
+``drivers/ctlv/tests/ctlv_test_child.c``
+    A separately built inheriting family and extension-point fill.
 
-Configuration
-=============
+``lib/ctlv/tests/*_kunit.c``
+    Unit tests of the engine and of its nodes.
 
-``CONFIG_CTLV``
-    CTLV. A family implementation selects it.
+``tools/testing/selftests/ctlv/``
+    Raw-message, generated-binding, allocation-failure, and mutation selftests.
 
 Kernel API
 ==========
diff --git a/Documentation/userspace-api/ctlv.rst b/Documentation/userspace-api/ctlv.rst
index 8a8ade33b490..dc590f334545 100644
--- a/Documentation/userspace-api/ctlv.rst
+++ b/Documentation/userspace-api/ctlv.rst
@@ -58,8 +58,8 @@ Each part of the design serves one of the needs:
   so that a caller whose answer changed between the parts gets ``ESTALE``
   rather than a mix of two states.
 - Introspection. Every device answers ``family-get``, ``op-get`` and
-  ``op-schema-get``, so a program built without a family still learns what
-  the device accepts.
+  ``op-schema-get``, so a program built without a family, such as ``ctlvctl``,
+  still learns what the device accepts.
 
 `Compatibility`_ collects the rules for growing a family.
 
@@ -133,6 +133,11 @@ specification: ``index`` must be at most 4095 and ``label`` at most 63 bytes.
     ctlv_example_item_set_label_put(req, "ab");
     ctlv_example_item_set(dev, req, &error);
 
+and so does ``ctlvctl``, given the family's specification::
+
+    ctlvctl --spec-dir Documentation/ctlv/specs \
+            exec /dev/ctlv-example item-set index=3 label=ab
+
 The sections below define each piece: the device, the message format, the
 ioctl, queries, blobs and introspection, and then the rules of compatibility.
 
@@ -564,7 +569,7 @@ cut. The first call passes ``generation`` and ``cursor`` zero. On return:
 
 To continue, the caller repeats the call with the same ``op_id`` and request,
 the returned ``cursor`` and the returned ``generation``, and reassembles by
-concatenating the children of each still-open record.
+concatenating the children of each still-open record, which ``libctlv`` does.
 
 One answer of three items, cut by a buffer that holds two::
 
@@ -591,7 +596,8 @@ it, so a reader knows whether to append or to open a new record beside it.
 
 Every continuing fragment adds at least one complete logical TLV beyond its
 repeated path, and a cursor value cannot recur within one logical reply.
-A reader must reject either violation.
+``libctlv`` rejects either violation. It also limits one query to 65,536
+fragments and a 64 MiB reassembled reply.
 
 A continuation whose generation no longer matches fails with ``-ESTALE``, and
 the error information carries the expected and the current generation.
@@ -709,3 +715,69 @@ removing or renumbering anything, changing a field's kind or an operation's
 type, access or availability, narrowing a bound or an occurrence limit,
 making a field that the kernel writes optional, and, in any message,
 making a field required or adding a required one.
+
+Library and tools
+=================
+
+``tools/ctlv/libctlv`` is a small C library for the mechanical parts: opening
+a device, checking the chain, building requests, parsing replies, reassembling
+fragmented queries and building blob descriptors. Per-family
+bindings are generated beside it, turning operations into typed functions.
+``ctlv_open()`` finds a device by the family its uevent announces, whichever
+subsystem it is in. ``ctlv_open_fd()`` takes a file the caller opened, through
+another subsystem's interface if need be, and ``ctlv_close()`` leaves it open.
+
+``tools/ctlv/ctlvctl`` defaults to runtime introspection alone. Compiled
+against no family, it can list devices, print the operations one publishes and
+their schemas, and execute its actions and queries alike. A device is
+named as ``list`` prints it, relative to ``/dev``, or by a path::
+
+    ctlvctl list
+    ctlvctl ops /dev/ctlv-example
+    ctlvctl schema /dev/ctlv-example 0x0001000000000008
+    ctlvctl exec /dev/ctlv-example 0x0001000000000001
+    ctlvctl exec /dev/ctlv-example 0x0001000000000002 0x0001800200000001=7
+
+Passing the directory of the kernel's family specifications adds the names
+that are deliberately absent from introspection. This is the ``specs``
+directory of a CTLV documentation bundle; its registry and meta-schemas are in
+the parent directory::
+
+    ctlvctl --spec-dir Documentation/ctlv/specs ops /dev/ctlv-example
+    ctlvctl --spec-dir Documentation/ctlv/specs \
+            schema /dev/ctlv-example series-get
+    ctlvctl --spec-dir Documentation/ctlv/specs \
+            exec /dev/ctlv-example probe-get token=7
+    ctlvctl --spec-dir Documentation/ctlv/specs \
+            exec /dev/ctlv-example echo-reply \
+            --json '{"u":17,"mode":"busy","count":[3,5]}'
+    ctlvctl --spec-dir Documentation/ctlv/specs \
+            exec /dev/ctlv-example transfer --json \
+            '{"source":{"file":"in"},"target":{"file":"out","length":64}}'
+
+``CTLV_SPEC_DIR`` avoids repeating the directory. Known items are printed by
+name without IDs; ``-n`` adds them, while an item unknown to the selected
+specifications stays numeric. ``schema --json-template`` prints a minimal JSON
+request. ``--output-json`` emits one object for an action or query. A JSON
+request may be inline, read from ``@file``, or read from standard input with
+``--json -``; it cannot be combined with assignments. Specification and JSON
+support are built when json-c is available.
+
+In JSON, a blob is ``{"file": "<path>"}``, passed as ``va`` memory. An input
+blob holds the file. An output blob is written to the file whole, so give it
+the ``"length"`` the operation writes; without one it starts at a byte and
+grows to each ``required-length`` the operation fails with, the operation
+being retried. An ``inout`` blob is read from the file and written back.
+
+In the directory, ``ctlvctl`` reads a family's names from ``<family>.json``
+when it is there, and otherwise has ``ctlvgen``, with its Python dependencies,
+resolve ``<family>.yaml``. Building ``ctlvctl`` writes the ``.json`` of each of
+the tree's families beside it, so a machine with neither the source tree nor
+Python needs only that directory and json-c. ``ctlvgen --spec <family>.yaml
+--runtime-json`` prints the file for a family outside the tree.
+
+``make -C tools/ctlv programs`` builds both in the source tree. After ``make
+O=<dir> headers``, ``make O=<dir> tools/ctlv`` builds ``ctlvctl`` into
+``<dir>/tools/ctlv/ctlvctl`` against that tree's headers, for another
+architecture with ``CROSS_COMPILE`` or ``LLVM`` as the kernel takes them;
+``PKG_CONFIG`` names the ``pkg-config`` that finds the target's json-c.
diff --git a/tools/Makefile b/tools/Makefile
index cb40961a740f..d8d0003b16a5 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -13,6 +13,7 @@ help:
 	@echo '  bpf                    - misc BPF tools'
 	@echo '  counter                - counter tools'
 	@echo '  cpupower               - a tool for all things x86 CPU power'
+	@echo '  ctlv                   - CTLV library and ctlvctl, after make headers'
 	@echo '  debugging              - tools for debugging'
 	@echo '  dma                    - tools for DMA mapping'
 	@echo '  firewire               - the userspace part of nosy, an IEEE-1394 traffic sniffer'
@@ -70,6 +71,9 @@ acpi: FORCE
 cpupower: FORCE
 	$(call descend,power/$@)
 
+ctlv: FORCE
+	$(call descend,ctlv/ctlvctl)
+
 counter dma firewire hv guest bootconfig spi usb virtio mm bpf iio gpio objtool leds wmi firmware debugging tracing: FORCE
 	$(call descend,$@)
 
@@ -179,6 +183,9 @@ acpi_clean:
 cpupower_clean:
 	$(call descend,power/cpupower,clean)
 
+ctlv_clean:
+	$(call descend,ctlv/ctlvctl,clean)
+
 counter_clean dma_clean hv_clean firewire_clean bootconfig_clean spi_clean usb_clean virtio_clean mm_clean wmi_clean bpf_clean iio_clean gpio_clean objtool_clean leds_clean firmware_clean debugging_clean tracing_clean:
 	$(call descend,$(@:_clean=),clean)
 
@@ -225,7 +232,7 @@ build_clean:
 ynl_clean:
 	$(call descend,net/$(@:_clean=),clean)
 
-clean: acpi_clean counter_clean cpupower_clean dma_clean hv_clean firewire_clean \
+clean: acpi_clean counter_clean cpupower_clean ctlv_clean dma_clean hv_clean firewire_clean \
 		perf_clean selftests_clean turbostat_clean bootconfig_clean spi_clean usb_clean virtio_clean \
 		mm_clean bpf_clean iio_clean x86_energy_perf_policy_clean tmon_clean \
 		freefall_clean build_clean libbpf_clean libsubcmd_clean \
diff --git a/tools/ctlv/Makefile b/tools/ctlv/Makefile
index 881fae9127c7..83c0ece690e8 100644
--- a/tools/ctlv/Makefile
+++ b/tools/ctlv/Makefile
@@ -2,6 +2,10 @@
 
 KDIR = ../..
 DOCDIR = $(KDIR)/Documentation/ctlv
+SPECDIR = $(DOCDIR)/specs
+SPECS = $(wildcard $(SPECDIR)/*.yaml)
+TOOL = ./ctlvgen/cli.py
+DOC_OUTPUT ?= $(KDIR)/Documentation/output/ctlv/families
 
 # Writes nothing. Fails on an invalid specification, and on any generated file
 # or ABI snapshot that regen would change.
@@ -30,16 +34,29 @@ lint:
 	python3 -m pyflakes $(PYSRC)
 	python3 -m mypy $(PYSRC)
 
-# The C half of this directory: the userspace library, which is not generated
-# and not Python, so it is its own target rather than part of the checks above.
+docs:
+	@mkdir -p $(DOC_OUTPUT)
+	@for spec in $(SPECS) ; do \
+		name=$$(basename $$spec .yaml) ; \
+		echo -e "\tDOC $$name.rst" ; \
+		$(TOOL) --spec $$spec --mode doc --rst \
+			-o $(DOC_OUTPUT)/$$name.rst || exit 1 ; \
+	done
+
+# The C half of this directory: the userspace library, and the tool that drives
+# a device it was never compiled against. Neither is generated and neither is
+# Python, so they are their own target rather than part of the checks above.
 programs:
 	$(MAKE) -C libctlv
+	$(MAKE) -C ctlvctl
 
 clean:
 	rm -rf ctlvgen/__pycache__
 	rm -rf ctlvgen/lib/__pycache__
 	rm -rf ctlvgen.egg-info
 	rm -rf build
+	rm -rf $(DOC_OUTPUT)
 	$(MAKE) -C libctlv clean
+	$(MAKE) -C ctlvctl clean
 
-.PHONY: all regen lint programs clean
+.PHONY: all regen lint docs programs clean
diff --git a/tools/ctlv/ctlvctl/.gitignore b/tools/ctlv/ctlvctl/.gitignore
new file mode 100644
index 000000000000..dcade74af00e
--- /dev/null
+++ b/tools/ctlv/ctlvctl/.gitignore
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0-only
+/*.json
+/ctlvctl
+/libctlv/
diff --git a/tools/ctlv/ctlvctl/Makefile b/tools/ctlv/ctlvctl/Makefile
new file mode 100644
index 000000000000..dcfca390d402
--- /dev/null
+++ b/tools/ctlv/ctlvctl/Makefile
@@ -0,0 +1,64 @@
+# SPDX-License-Identifier: GPL-2.0
+
+KDIR ?= ../../..
+LIBDIR = ../libctlv
+
+CFLAGS ?= -O2 -g
+
+include ../../scripts/Makefile.include
+
+KHDR_INCLUDES ?= -isystem $(or $(ABSOLUTE_O),$(KDIR))/usr/include
+
+CFLAGS += -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers
+CFLAGS += -D_GNU_SOURCE -I$(LIBDIR) $(KHDR_INCLUDES)
+
+# The one that knows the target's json-c, when cross-compiling.
+PKG_CONFIG ?= $(CROSS_COMPILE)pkg-config
+
+JSON_C_CFLAGS := $(shell $(PKG_CONFIG) --atleast-version=0.14 json-c \
+			  2>/dev/null && $(PKG_CONFIG) --cflags json-c)
+JSON_C_LIBS := $(shell $(PKG_CONFIG) --atleast-version=0.14 json-c \
+			2>/dev/null && $(PKG_CONFIG) --libs json-c)
+ifneq ($(JSON_C_LIBS),)
+CFLAGS += -DHAVE_JSON_C $(JSON_C_CFLAGS)
+LDLIBS += $(JSON_C_LIBS)
+endif
+
+# With a build directory, libctlv is built for ctlvctl inside it.
+LIBCTLV_OUTPUT ?= $(if $(OUTPUT),$(OUTPUT)libctlv/)
+LIB = $(or $(LIBCTLV_OUTPUT),$(LIBDIR)/)libctlv.a
+OBJS = $(OUTPUT)ctlvctl.o $(OUTPUT)spec.o
+
+# What --spec-dir reads where there is neither the source tree nor Python:
+# the names of each of the tree's families and of the families it inherits.
+DOCDIR = $(KDIR)/Documentation/ctlv
+SPECDIR = $(DOCDIR)/specs
+SPECS = $(wildcard $(SPECDIR)/*.yaml)
+CTLVGEN = ../ctlvgen/cli.py
+CTLVGEN_INPUTS = $(SPECS) $(wildcard $(DOCDIR)/*.yaml) \
+		 $(wildcard ../ctlvgen/*.py ../ctlvgen/lib/*.py)
+MANIFESTS = $(patsubst $(SPECDIR)/%.yaml,$(OUTPUT)%.json,$(SPECS))
+
+all: $(OUTPUT)ctlvctl $(MANIFESTS)
+
+$(OUTPUT)ctlvctl: $(OBJS) $(LIB)
+	$(QUIET_LINK)$(CC) $(CFLAGS) -o $@ $(OBJS) $(LIB) $(LDLIBS)
+
+$(OUTPUT)%.o: %.c spec.h
+	$(QUIET_CC)$(CC) $(CFLAGS) -c -o $@ $<
+
+$(OUTPUT)%.json: $(SPECDIR)/%.yaml $(CTLVGEN_INPUTS)
+	$(QUIET_GEN)$(CTLVGEN) --spec $< --runtime-json > $@
+
+$(LIB): FORCE
+	$(if $(LIBCTLV_OUTPUT),$(Q)mkdir -p $(LIBCTLV_OUTPUT))
+	$(Q)$(MAKE) -C $(LIBDIR) OUTPUT=$(LIBCTLV_OUTPUT)
+
+clean:
+	rm -f $(OUTPUT)ctlvctl $(OBJS) $(MANIFESTS)
+	$(if $(LIBCTLV_OUTPUT),rm -rf $(LIBCTLV_OUTPUT))
+
+FORCE:
+
+.PHONY: all clean FORCE
+.DELETE_ON_ERROR:
diff --git a/tools/ctlv/ctlvctl/ctlvctl.c b/tools/ctlv/ctlvctl/ctlvctl.c
new file mode 100644
index 000000000000..ef9bb8536c47
--- /dev/null
+++ b/tools/ctlv/ctlvctl/ctlvctl.c
@@ -0,0 +1,2787 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Family-independent CTLV command-line client.
+ */
+
+#include <ctype.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <getopt.h>
+#include <limits.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#ifdef HAVE_JSON_C
+#include <json.h>
+#endif
+
+#include <ctlv.h>
+
+#include "spec.h"
+
+#define DEV_DIR "/dev"
+#define PATH_LEN 1024
+#define LINE_LEN 512
+#define ARRAY_SIZE(array) (sizeof(array) / sizeof((array)[0]))
+
+/*
+ * How deep a request built from the command line may go: the root and 32
+ * levels below it, as deep as any device goes today.
+ */
+#define PATH_DEPTH 33
+
+/* Where a request buffer starts; it grows as fields are added. */
+#define REQUEST_HINT 512
+
+static const char *prog = "ctlvctl";
+
+static struct {
+	const char *spec_dir;
+	bool show_ids;
+	bool output_json;
+} options;
+
+#ifdef HAVE_JSON_C
+static int json_template_print(const struct ctlv_node_schema *root,
+			       const struct ctlvctl_spec *spec);
+static void json_add_id(struct json_object *object, const char *key, __u64 id);
+static void json_add_op(struct json_object *object,
+			const struct ctlvctl_spec *spec, __u64 op_id);
+static int json_print(struct json_object *object);
+static int json_schema_print(const struct ctlv_dev *dev,
+			     const struct ctlvctl_spec *spec, __u64 op_id,
+			     const struct ctlv_schema *schema);
+
+static void json_add_string(struct json_object *object, const char *key,
+			    const char *value)
+{
+	json_object_object_add(object, key, json_object_new_string(value));
+}
+
+static void json_add_u64(struct json_object *object, const char *key,
+			 __u64 value)
+{
+	json_object_object_add(object, key, json_object_new_uint64(value));
+}
+
+static void json_add_s64(struct json_object *object, const char *key,
+			 __s64 value)
+{
+	json_object_object_add(object, key, json_object_new_int64(value));
+}
+
+static void json_add_int(struct json_object *object, const char *key, int value)
+{
+	json_object_object_add(object, key, json_object_new_int(value));
+}
+
+static void json_add_bool(struct json_object *object, const char *key,
+			  bool value)
+{
+	json_object_object_add(object, key, json_object_new_boolean(value));
+}
+
+static int json_array_add_string(struct json_object *array, const char *value)
+{
+	struct json_object *string = json_object_new_string(value);
+
+	if (!string)
+		return -ENOMEM;
+	if (json_object_array_add(array, string)) {
+		json_object_put(string);
+		return -ENOMEM;
+	}
+	return 0;
+}
+#endif
+
+static void help(FILE *out)
+{
+	fprintf(out,
+		"usage: %s [options] <command> [arguments]\n"
+		"\n"
+		"  list                       every CTLV device and its family chain\n"
+		"  ops <device>               every op the device publishes\n"
+		"  schema [--json-template] <device> <op>\n"
+		"                             the request and reply ABI of one op\n"
+		"  exec [-l len] <device> <op> [a=v]\n"
+		"                             run an op, reassembling a query's answer\n"
+		"\n"
+		"  --spec-dir DIR             use DIR/<family>.json or .yaml\n"
+		"  -n, --show-ids             show IDs beside specification names\n"
+		"  --output-json              print structured JSON\n"
+		"  --json TEXT|@FILE|-        build a request from JSON\n"
+		"\n"
+		"In --json, a blob is {\"file\": PATH}. Input is read from the file, and\n"
+		"output written to it: \"length\" bytes, or as many as the op needs.\n"
+		"\n"
+		"-l names the reply buffer, which for a query decides how many fragments\n"
+		"the answer arrives in; the device reports its smallest usable size in ops.\n"
+		"\n"
+		"With --spec-dir, operation names and top-level scalar names may be\n"
+		"used. Otherwise an operation goes by its ID and a field by its type.\n"
+		"A dotted numeric path enters a record:\n"
+		"\n"
+		"  %s exec ctlv-test0 0x3000000000009 0x3800900000001=7\n"
+		"  %s exec ctlv-test0 0x3000000000006 0x3000100000001=1 \\\n"
+		"      0x3000100000009.0x3000110000001=3\n",
+		prog, prog, prog);
+}
+
+static int parse_u64(const char *text, __u64 *value)
+{
+	char *end;
+
+	if (!*text || *text == '-' || isspace((unsigned char)*text))
+		return -EINVAL;
+	errno = 0;
+	*value = strtoull(text, &end, 0);
+	if (errno || end == text || *end)
+		return -EINVAL;
+	return 0;
+}
+
+static int parse_s64(const char *text, __s64 *value)
+{
+	char *end;
+
+	errno = 0;
+	*value = strtoll(text, &end, 0);
+	if (errno || end == text || *end)
+		return -EINVAL;
+	return 0;
+}
+
+static int dev_open(const char *name, int flags, struct ctlv_dev **devp)
+{
+	char path[PATH_LEN];
+	int ret;
+
+	/* A listed name is under /dev even when it has a directory of its own. */
+	if (name[0] == '/' || name[0] == '.')
+		snprintf(path, sizeof(path), "%s", name);
+	else
+		snprintf(path, sizeof(path), "%s/%s", DEV_DIR, name);
+	ret = ctlv_open_path(path, flags, devp);
+	if (ret)
+		fprintf(stderr, "%s: %s: %s\n", prog, path, strerror(-ret));
+	return ret;
+}
+
+static int spec_load(const struct ctlv_dev *dev, struct ctlvctl_spec **spec)
+{
+	if (!options.spec_dir) {
+		*spec = NULL;
+		return 0;
+	}
+	return ctlvctl_spec_load(prog, options.spec_dir, dev, spec);
+}
+
+static int op_resolve(const struct ctlvctl_spec *spec, const char *text,
+		      __u64 *op_id)
+{
+	const struct ctlvctl_op_name *op;
+
+	if (!parse_u64(text, op_id))
+		return 0;
+	op = ctlvctl_spec_op_name(spec, text);
+	if (op) {
+		*op_id = op->id;
+		return 0;
+	}
+	if (spec)
+		fprintf(stderr, "%s: no operation \"%s\"\n", prog, text);
+	else
+		fprintf(stderr, "%s: %s: not an op ID\n", prog, text);
+	return -ENOENT;
+}
+
+static void chain_print(const struct ctlv_dev *dev)
+{
+	unsigned int i;
+
+	for (i = 0; i < ctlv_chain_len(dev); i++)
+		printf("%s%s", i ? "/" : "", ctlv_chain_name(dev, i));
+}
+
+static int cmd_list(int argc, char **argv)
+{
+#ifdef HAVE_JSON_C
+	struct json_object *json = NULL;
+#endif
+	struct ctlv_dev_list list;
+	unsigned int i;
+	int ret;
+
+	if (argc) {
+		help(stderr);
+		return -EINVAL;
+	}
+	ret = ctlv_enumerate(&list);
+	if (ret) {
+		fprintf(stderr, "%s: no CTLV devices: %s\n", prog,
+			strerror(-ret));
+		return ret;
+	}
+#ifdef HAVE_JSON_C
+	if (options.output_json) {
+		json = json_object_new_array();
+		if (!json) {
+			ctlv_dev_list_free(&list);
+			return -ENOMEM;
+		}
+	}
+#endif
+	for (i = 0; i < list.names_count; i++) {
+		struct ctlv_dev *dev;
+
+#ifdef HAVE_JSON_C
+		if (json) {
+			struct json_object *chain = json_object_new_array();
+			struct json_object *item = json_object_new_object();
+			unsigned int level;
+
+			json_add_string(item, "device", list.names[i]);
+			if (!dev_open(list.names[i], O_RDONLY, &dev)) {
+				for (level = 0; level < ctlv_chain_len(dev);
+				     level++) {
+					struct json_object *family =
+						json_object_new_object();
+
+					json_add_string(family, "name",
+							ctlv_chain_name(dev,
+									level));
+					if (options.show_ids)
+						json_add_int(family, "id",
+							     ctlv_chain_id(dev, level));
+					json_object_array_add(chain, family);
+				}
+				ctlv_close(dev);
+			}
+			json_object_object_add(item, "chain", chain);
+			json_object_array_add(json, item);
+			continue;
+		}
+#endif
+		printf("%s", list.names[i]);
+		/* Listing should not need the right to change a device. */
+		if (!dev_open(list.names[i], O_RDONLY, &dev)) {
+			printf("\t");
+			chain_print(dev);
+			ctlv_close(dev);
+		}
+		printf("\n");
+	}
+	ctlv_dev_list_free(&list);
+#ifdef HAVE_JSON_C
+	if (json)
+		return json_print(json);
+#endif
+	return 0;
+}
+
+static const char *type_name(__u32 type)
+{
+	switch (type) {
+	case CTLV_OP_TYPE_ACTION:
+		return "action";
+	case CTLV_OP_TYPE_QUERY:
+		return "query";
+	default:
+		return "?";
+	}
+}
+
+static const char *fd_access_name(__u32 fd_access)
+{
+	return fd_access == CTLV_OP_FD_ACCESS_READ ? "read" : "read-write";
+}
+
+static bool op_matches(const struct ctlvctl_op_name *name,
+		       const struct ctlv_op_info *op)
+{
+	return name->type == op->type &&
+	       name->fd_access == op->fd_access &&
+	       name->availability == op->availability;
+}
+
+static int op_print(const struct ctlvctl_spec *spec,
+		    const struct ctlv_op_info *op)
+{
+	const struct ctlvctl_op_name *name;
+
+	name = ctlvctl_spec_op_id(spec, op->op_id);
+	if (name && !op_matches(name, op)) {
+		fprintf(stderr,
+			"%s: specification disagrees with operation %#llx\n",
+			prog, (unsigned long long)op->op_id);
+		return -ENOMSG;
+	}
+	if (name) {
+		printf("%-20s", name->name);
+		if (options.show_ids)
+			printf("\t%#018llx",
+			       (unsigned long long)op->op_id);
+	} else {
+		printf("%#018llx", (unsigned long long)op->op_id);
+	}
+	printf("\t%-6s", type_name(op->type));
+	if (op->fd_access)
+		printf("\t%s", fd_access_name(op->fd_access));
+	if (op->availability == CTLV_OP_AVAILABILITY_DYNAMIC)
+		printf("\tdynamic %s", op->disabled ? "disabled" : "enabled");
+	else if (op->availability == CTLV_OP_AVAILABILITY_FIXED)
+		printf("\tfixed");
+	if (op->request_max_len)
+		printf("\trequest %llu",
+		       (unsigned long long)op->request_max_len);
+	if (op->action_reply_max_len)
+		printf("\treply %llu",
+		       (unsigned long long)op->action_reply_max_len);
+	if (op->query_reply_min_len)
+		printf("\treply %llu..%llu",
+		       (unsigned long long)op->query_reply_min_len,
+		       (unsigned long long)op->query_reply_suggested_len);
+	printf("\n");
+	return 0;
+}
+
+static int cmd_ops(int argc, char **argv)
+{
+#ifdef HAVE_JSON_C
+	struct json_object *json = NULL;
+	struct json_object *json_ops = NULL;
+#endif
+	struct ctlvctl_spec *spec = NULL;
+	struct ctlv_error error;
+	struct ctlv_dev *dev;
+	struct ctlv_ops *ops;
+	char text[LINE_LEN];
+	unsigned int i;
+	int ret;
+
+	if (argc != 1) {
+		help(stderr);
+		return -EINVAL;
+	}
+	ret = dev_open(argv[0], O_RDONLY, &dev);
+	if (ret)
+		return ret;
+	ret = spec_load(dev, &spec);
+	if (ret)
+		goto out;
+
+	ret = ctlv_ops_get(dev, &ops, &error);
+	if (ret) {
+		fprintf(stderr, "%s: op-get: %s\n", prog,
+			ctlv_error_str(&error, text, sizeof(text)));
+		goto out;
+	}
+#ifdef HAVE_JSON_C
+	if (options.output_json) {
+		json = json_object_new_object();
+		json_ops = json_object_new_array();
+		if (!json || !json_ops) {
+			ret = -ENOMEM;
+			goto out_json;
+		}
+		json_add_string(json, "device", ctlv_dev_name(dev));
+		json_add_u64(json, "generation", ops->generation);
+		json_object_object_add(json, "ops", json_ops);
+	}
+#endif
+	if (!options.output_json) {
+		printf("# ");
+		chain_print(dev);
+		printf(", generation %llu\n",
+		       (unsigned long long)ops->generation);
+	}
+	for (i = 0; i < ops->ops_count; i++) {
+#ifdef HAVE_JSON_C
+		if (json) {
+			const struct ctlvctl_op_name *name;
+			struct json_object *item;
+
+			name = ctlvctl_spec_op_id(spec, ops->ops[i].op_id);
+			if (name && !op_matches(name, &ops->ops[i])) {
+				fprintf(stderr,
+					"%s: specification disagrees with operation %#llx\n",
+					prog, (unsigned long long)
+					ops->ops[i].op_id);
+				ret = -ENOMSG;
+				break;
+			}
+			item = json_object_new_object();
+			if (!item) {
+				ret = -ENOMEM;
+				break;
+			}
+			if (name)
+				json_add_string(item, "name", name->name);
+			if (!name || options.show_ids)
+				json_add_id(item, "id", ops->ops[i].op_id);
+			json_add_string(item, "type",
+					type_name(ops->ops[i].type));
+			if (ops->ops[i].fd_access) {
+				const char *access =
+					fd_access_name(ops->ops[i].fd_access);
+
+				json_add_string(item, "fd-access",
+						access);
+			}
+			if (ops->ops[i].availability) {
+				const char *availability;
+
+				availability = ops->ops[i].availability ==
+					CTLV_OP_AVAILABILITY_DYNAMIC ?
+					"dynamic" : "fixed";
+				json_add_string(item, "availability",
+						availability);
+				if (ops->ops[i].availability ==
+				    CTLV_OP_AVAILABILITY_DYNAMIC)
+					json_add_bool(item, "disabled",
+						      ops->ops[i].disabled);
+			}
+			json_object_array_add(json_ops, item);
+			continue;
+		}
+#endif
+		ret = op_print(spec, &ops->ops[i]);
+		if (ret)
+			break;
+	}
+#ifdef HAVE_JSON_C
+	if (!ret && json)
+		ret = json_print(json);
+	else if (json)
+		json_object_put(json);
+	json = NULL;
+	json_ops = NULL;
+out_json:
+	if (json)
+		json_object_put(json);
+	else if (json_ops)
+		json_object_put(json_ops);
+#endif
+	ctlv_ops_free(ops);
+out:
+	ctlvctl_spec_free(spec);
+	ctlv_close(dev);
+	return ret;
+}
+
+static const struct ctlvctl_field_name *
+field_name(const struct ctlvctl_spec *spec,
+	   const struct ctlv_node_schema *node)
+{
+	const struct ctlvctl_field_name *name;
+
+	if (!node)
+		return NULL;
+	name = ctlvctl_spec_field(spec, node->type);
+	if (name && name->kind != node->kind)
+		return NULL;
+	return name;
+}
+
+static int tree_names_check(const struct ctlvctl_spec *spec,
+			    const struct ctlv_node_schema *node)
+{
+	const struct ctlvctl_field_name *name;
+	__u64 known = 0;
+	unsigned int i;
+	int ret;
+
+	if (!node)
+		return 0;
+	name = ctlvctl_spec_field(spec, node->type);
+	if (name && name->kind != node->kind) {
+		fprintf(stderr,
+			"%s: specification schema kind for %s disagrees with the device\n",
+			prog, name->name);
+		return -ENOMSG;
+	}
+	if (name && name->definition) {
+		for (i = 0; i < name->definition->values_count; i++) {
+			__u64 value = name->definition->values[i].value;
+
+			known |= value;
+			if (name->kind == CTLV_SCHEMA_ENUM &&
+			    (!(node->present & CTLV_NODE_SCHEMA_HAS_MIN) ||
+			     !(node->present & CTLV_NODE_SCHEMA_HAS_MAX) ||
+			     value < node->min || value > node->max)) {
+				fprintf(stderr,
+					"%s: specification values for %s disagree with the device\n",
+					prog, name->name);
+				return -ENOMSG;
+			}
+		}
+		if (name->kind == CTLV_SCHEMA_FLAGS &&
+		    (!(node->present & CTLV_NODE_SCHEMA_HAS_FLAGS_MASK) ||
+		     (known & ~node->flags_mask))) {
+			fprintf(stderr,
+				"%s: specification flags for %s disagree with the device\n",
+				prog, name->name);
+			return -ENOMSG;
+		}
+	}
+	for (i = 0; i < node->fields_count; i++) {
+		ret = tree_names_check(spec, &node->fields[i]);
+		if (ret)
+			return ret;
+	}
+	for (i = 0; i < node->optional_fields_count; i++) {
+		ret = tree_names_check(spec, &node->optional_fields[i]);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static void tree_print(const struct ctlvctl_spec *spec,
+		       const struct ctlv_node_schema *node, unsigned int indent,
+		       int required)
+{
+	char line[LINE_LEN];
+	const struct ctlvctl_field_name *name;
+	char *detail;
+	unsigned int i;
+
+	name = field_name(spec, node);
+	ctlv_schema_render(node, 0, line, sizeof(line));
+	if (!name || node->type == CTLV_TYPE_ROOT) {
+		printf("%*s%s\n", indent * 2, "", line);
+	} else {
+		detail = strchr(line + strlen("field "), ' ');
+		printf("%*s%s", indent * 2, "", name->name);
+		if (options.show_ids)
+			printf(" (%#018llx)",
+			       (unsigned long long)node->type);
+		if (required >= 0)
+			printf(" %s", required ? "required" : "optional");
+		printf("%s", detail ? detail : "");
+		if (name->definition) {
+			unsigned int j;
+
+			printf(" {");
+			for (j = 0; j < name->definition->values_count; j++) {
+				printf("%s%s", j ? ", " : "",
+				       name->definition->values[j].name);
+				if (options.show_ids)
+					printf("=%#llx",
+					       (unsigned long long)
+					       name->definition->values[j].value);
+			}
+			printf("}");
+		}
+		printf("\n");
+	}
+	for (i = 0; i < node->fields_count; i++)
+		tree_print(spec, &node->fields[i], indent + 1, true);
+	for (i = 0; i < node->optional_fields_count; i++)
+		tree_print(spec, &node->optional_fields[i], indent + 1, false);
+}
+
+static int cmd_schema(int argc, char **argv)
+{
+	const struct ctlvctl_op_name *op_name;
+	const struct ctlv_op_info *op_info;
+	const struct ctlv_node_schema *node;
+	struct ctlvctl_spec *spec = NULL;
+	struct ctlv_schema *schema;
+	struct ctlv_ops *ops;
+	struct ctlv_error error;
+	struct ctlv_dev *dev;
+	char text[LINE_LEN];
+	__u64 op_id;
+	__u32 op_type = 0;
+	bool template = false;
+	int ret;
+
+	if (argc && !strcmp(argv[0], "--json-template")) {
+		template = true;
+		argc--;
+		argv++;
+	}
+	if (argc != 2) {
+		help(stderr);
+		return -EINVAL;
+	}
+	ret = dev_open(argv[0], O_RDONLY, &dev);
+	if (ret)
+		return ret;
+	ret = spec_load(dev, &spec);
+	if (ret)
+		goto out;
+	ret = op_resolve(spec, argv[1], &op_id);
+	if (ret)
+		goto out;
+	op_name = ctlvctl_spec_op_id(spec, op_id);
+	if (spec) {
+		ret = ctlv_ops_get(dev, &ops, &error);
+		if (ret) {
+			fprintf(stderr, "%s: op-get: %s\n", prog,
+				ctlv_error_str(&error, text, sizeof(text)));
+			goto out;
+		}
+		op_info = ctlv_ops_find(ops, op_id);
+		if (!op_info) {
+			fprintf(stderr,
+				"%s: operation is not available on %s\n",
+				prog, ctlv_dev_name(dev));
+			ret = -ENOENT;
+		} else {
+			op_type = op_info->type;
+			if (op_name && !op_matches(op_name, op_info)) {
+				fprintf(stderr,
+					"%s: specification disagrees with operation %s\n",
+					prog, op_name->name);
+				ret = -ENOMSG;
+			}
+		}
+		ctlv_ops_free(ops);
+		if (ret)
+			goto out;
+	}
+
+	ret = ctlv_op_schema_get(dev, op_id, &schema, &error);
+	if (ret) {
+		fprintf(stderr, "%s: op-schema-get: %s\n", prog,
+			ctlv_error_str(&error, text, sizeof(text)));
+		goto out;
+	}
+	ret = tree_names_check(spec, ctlv_schema_request(schema));
+	if (!ret)
+		ret = tree_names_check(spec, ctlv_schema_reply(schema));
+	if (ret)
+		goto out_schema;
+	if (template) {
+		node = ctlv_schema_request(schema);
+		if (!spec) {
+			fprintf(stderr,
+				"%s: --json-template requires --spec-dir\n", prog);
+			ret = -EINVAL;
+		} else if (!node) {
+			printf("{}\n");
+		} else {
+#ifdef HAVE_JSON_C
+			ret = json_template_print(node, spec);
+#else
+			ret = -EOPNOTSUPP;
+#endif
+		}
+		goto out_schema;
+	}
+#ifdef HAVE_JSON_C
+	if (options.output_json) {
+		ret = json_schema_print(dev, spec, op_id, schema);
+		goto out_schema;
+	}
+#endif
+	if (op_name) {
+		printf("%s (%s", op_name->name, type_name(op_name->type));
+		if (options.show_ids)
+			printf(", %#018llx", (unsigned long long)op_id);
+		printf(")\n");
+	} else if (spec) {
+		printf("%#018llx (%s)\n", (unsigned long long)op_id,
+		       type_name(op_type));
+	}
+	node = ctlv_schema_request(schema);
+	if (node) {
+		printf("request:\n");
+		tree_print(spec, node, 1, -1);
+	}
+	node = ctlv_schema_reply(schema);
+	if (node) {
+		printf("reply:\n");
+		tree_print(spec, node, 1, -1);
+	}
+out_schema:
+	ctlv_schema_free(schema);
+out:
+	ctlvctl_spec_free(spec);
+	ctlv_close(dev);
+	return ret;
+}
+
+/*
+ * An assignment names a field by its type and a dotted path enters a record.
+ * What a value means is decided by the schema kind the device reports.
+ */
+
+/* The member of @parent for @type, following any re-entry. */
+static const struct ctlv_node_schema *
+node_member(const struct ctlv_node_schema **stack, unsigned int depth,
+	    __u64 type)
+{
+	const struct ctlv_node_schema *parent = stack[depth];
+	unsigned int level = depth;
+	unsigned int i;
+
+	if (!parent)
+		return NULL;
+	while (parent->reenters) {
+		if (parent->reenters > level)
+			return NULL;
+		level -= parent->reenters;
+		parent = stack[level];
+		if (!parent)
+			return NULL;
+	}
+	for (i = 0; i < parent->fields_count; i++)
+		if (parent->fields[i].type == type)
+			return &parent->fields[i];
+	for (i = 0; i < parent->optional_fields_count; i++)
+		if (parent->optional_fields[i].type == type)
+			return &parent->optional_fields[i];
+	return NULL;
+}
+
+static int hex_digit(char c)
+{
+	if (c >= '0' && c <= '9')
+		return c - '0';
+	if (c >= 'a' && c <= 'f')
+		return c - 'a' + 10;
+	if (c >= 'A' && c <= 'F')
+		return c - 'A' + 10;
+	return -EINVAL;
+}
+
+static int put_hex(struct ctlv_msg *msg, __u64 type, const char *text)
+{
+	size_t text_len = strlen(text);
+	size_t len = text_len / 2;
+	unsigned char *bytes;
+	size_t i;
+	int ret;
+
+	if (text_len & 1)
+		return -EINVAL;
+	bytes = malloc(len ? len : 1);
+	if (!bytes)
+		return -ENOMEM;
+	for (i = 0; i < len; i++) {
+		int high = hex_digit(text[i * 2]);
+		int low = hex_digit(text[i * 2 + 1]);
+
+		if (high < 0 || low < 0) {
+			free(bytes);
+			return -EINVAL;
+		}
+		bytes[i] = high << 4 | low;
+	}
+	ret = ctlv_put_bin(msg, type, bytes, len);
+	free(bytes);
+	return ret;
+}
+
+static int flags_parse(const struct ctlvctl_field_name *field, const char *text,
+		       __u64 *value)
+{
+	char *copy, *part, *walk;
+	int ret = 0;
+
+	if (!parse_u64(text, value))
+		return 0;
+	copy = strdup(text);
+	if (!copy)
+		return -ENOMEM;
+	*value = 0;
+	walk = copy;
+	while ((part = strsep(&walk, ","))) {
+		__u64 bit;
+
+		if (!*part || ctlvctl_spec_value(field, part, &bit)) {
+			ret = -EINVAL;
+			break;
+		}
+		*value |= bit;
+	}
+	free(copy);
+	return ret;
+}
+
+static int put_value(struct ctlv_msg *msg, const struct ctlv_node_schema *node,
+		     const struct ctlvctl_spec *spec, const char *text)
+{
+	const struct ctlvctl_field_name *field = field_name(spec, node);
+	__u64 value;
+	__s64 signed_value;
+
+	switch (node->kind) {
+	case CTLV_SCHEMA_UINT:
+		if (parse_u64(text, &value))
+			return -EINVAL;
+		return ctlv_put_u64(msg, node->type, value);
+	case CTLV_SCHEMA_ENUM:
+		if (parse_u64(text, &value) &&
+		    ctlvctl_spec_value(field, text, &value))
+			return -EINVAL;
+		return ctlv_put_u64(msg, node->type, value);
+	case CTLV_SCHEMA_FLAGS:
+		if (flags_parse(field, text, &value))
+			return -EINVAL;
+		return ctlv_put_u64(msg, node->type, value);
+	case CTLV_SCHEMA_SINT:
+		if (parse_s64(text, &signed_value))
+			return -EINVAL;
+		return ctlv_put_s64(msg, node->type, signed_value);
+	case CTLV_SCHEMA_BOOL:
+		if (!strcmp(text, "true") || !strcmp(text, "1"))
+			return ctlv_put_bool(msg, node->type, true);
+		if (!strcmp(text, "false") || !strcmp(text, "0"))
+			return ctlv_put_bool(msg, node->type, false);
+		return -EINVAL;
+	case CTLV_SCHEMA_STRING:
+		return ctlv_put_str(msg, node->type, text);
+	case CTLV_SCHEMA_BINARY:
+		if (field) {
+			if (strncmp(text, "hex:", 4))
+				return -EINVAL;
+			return put_hex(msg, node->type, text + 4);
+		}
+		return ctlv_put_bin(msg, node->type, text, strlen(text));
+	default:
+		/* A command line has no memory of the caller's to describe. */
+		return -ENOTSUP;
+	}
+}
+
+static const struct ctlv_node_schema *
+node_named(const struct ctlv_node_schema *parent,
+	   const struct ctlvctl_spec *spec, const char *name, bool *ambiguous)
+{
+	const struct ctlv_node_schema *match = NULL;
+	unsigned int i;
+
+	*ambiguous = false;
+	for (i = 0; i < parent->fields_count + parent->optional_fields_count; i++) {
+		const struct ctlv_node_schema *node;
+		const struct ctlvctl_field_name *field;
+
+		if (i < parent->fields_count)
+			node = &parent->fields[i];
+		else
+			node = &parent->optional_fields[i - parent->fields_count];
+		field = field_name(spec, node);
+		if (!field)
+			continue;
+		if (!strcmp(field->name, name))
+			return node;
+		if (strcmp(field->short_name, name))
+			continue;
+		if (match)
+			*ambiguous = true;
+		match = node;
+	}
+	return *ambiguous ? NULL : match;
+}
+
+/* One path element: a type and which occurrence of it. */
+static int path_element(char *name, __u64 *type, __u64 *occurrence)
+{
+	char *at = strchr(name, '@');
+
+	*occurrence = 0;
+	if (at) {
+		*at++ = '\0';
+		if (parse_u64(at, occurrence))
+			return -EINVAL;
+	}
+	return parse_u64(name, type);
+}
+
+static int no_such_field(__u64 type)
+{
+	fprintf(stderr, "%s: %#llx: not a field of this record\n", prog,
+		(unsigned long long)type);
+	return -ENOENT;
+}
+
+static int not_a_record(__u64 type)
+{
+	fprintf(stderr, "%s: %#llx: not a record of this record\n", prog,
+		(unsigned long long)type);
+	return -ENOENT;
+}
+
+/**
+ * request_build - Turns assignments into one request.
+ * @msg: the message to append to
+ * @root: the request tree the device reported
+ * @spec: the names from --spec-dir, or NULL
+ * @argc: how many assignments
+ * @argv: the assignments, each field[@n][.field[@n]...]=value
+ *
+ * Records are opened as a path descends and closed as the next path leaves, so
+ * assignments have to be given in the order the message holds them. Two
+ * occurrences of one record are told apart by the @n suffix.
+ *
+ * Return: 0, or a negative errno naming the assignment that failed.
+ */
+static int request_build(struct ctlv_msg *msg,
+			 const struct ctlv_node_schema *root,
+			 const struct ctlvctl_spec *spec, int argc, char **argv)
+{
+	const struct ctlv_node_schema *stack[PATH_DEPTH] = { root };
+	__u64 path[PATH_DEPTH], occurrence[PATH_DEPTH];
+	unsigned int depth = 0;
+	int i, ret;
+
+	for (i = 0; i < argc; i++) {
+		char *text = strchr(argv[i], '=');
+		unsigned int level = 0;
+		char *name, *rest;
+
+		if (!text) {
+			fprintf(stderr, "%s: %s: not an assignment\n", prog,
+				argv[i]);
+			return -EINVAL;
+		}
+		*text++ = '\0';
+		rest = argv[i];
+
+		if (spec) {
+			const struct ctlv_node_schema *node;
+			bool ambiguous;
+
+			node = node_named(root, spec, rest, &ambiguous);
+			if (ambiguous) {
+				fprintf(stderr, "%s: %s: ambiguous field\n",
+					prog, rest);
+				return -EINVAL;
+			}
+			if (node) {
+				if (node->kind == CTLV_SCHEMA_RECORD ||
+				    node->kind == CTLV_SCHEMA_BLOB) {
+					fprintf(stderr,
+						"%s: %s: use --json for this field\n",
+						prog, rest);
+					return -ENOTSUP;
+				}
+				/* A named field is the root's. */
+				while (depth) {
+					ctlv_record_end(msg);
+					depth--;
+				}
+				ret = put_value(msg, node, spec, text);
+				if (ret) {
+					fprintf(stderr, "%s: %s=%s: %s\n",
+						prog, rest, text,
+						strerror(-ret));
+					return ret;
+				}
+				continue;
+			}
+		}
+
+		while ((name = strsep(&rest, "."))) {
+			const struct ctlv_node_schema *node;
+			__u64 type, which;
+
+			if (level == PATH_DEPTH - 1)
+				return -E2BIG;
+			if (path_element(name, &type, &which)) {
+				fprintf(stderr, "%s: %s: not a type\n",
+					prog, name);
+				return -EINVAL;
+			}
+
+			/*
+			 * A different record here, or the same one named again
+			 * as a second occurrence, ends what came before.
+			 */
+			if (level < depth && (path[level] != type ||
+					      occurrence[level] != which))
+				while (depth > level) {
+					ctlv_record_end(msg);
+					depth--;
+				}
+
+			if (!rest) {
+				/* The leaf, which carries the value. */
+				while (depth > level) {
+					ctlv_record_end(msg);
+					depth--;
+				}
+				node = node_member(stack, depth, type);
+				if (!node)
+					return no_such_field(type);
+				ret = put_value(msg, node, spec, text);
+				if (ret) {
+					fprintf(stderr,
+						"%s: %#llx=%s: %s\n",
+						prog,
+						(unsigned long long)type,
+						text,
+						strerror(-ret));
+					return ret;
+				}
+				break;
+			}
+
+			if (level == depth) {
+				node = node_member(stack, depth, type);
+				if (!node)
+					return no_such_field(type);
+				if (node->kind != CTLV_SCHEMA_RECORD)
+					return not_a_record(type);
+				ret = ctlv_record_start(msg, type);
+				if (ret)
+					return ret;
+				path[depth] = type;
+				occurrence[depth] = which;
+				stack[depth + 1] = node;
+				depth++;
+			}
+			level++;
+		}
+	}
+	return ctlv_msg_err(msg);
+}
+
+static int stream_read(FILE *file, char **textp, size_t *lenp)
+{
+	size_t used = 0, size = 4096;
+	char *text;
+
+	text = malloc(size);
+	if (!text)
+		return -ENOMEM;
+	for (;;) {
+		size_t n;
+
+		if (used == size - 1) {
+			char *grown;
+
+			size *= 2;
+			grown = realloc(text, size);
+			if (!grown) {
+				free(text);
+				return -ENOMEM;
+			}
+			text = grown;
+		}
+		n = fread(text + used, 1, size - used - 1, file);
+		used += n;
+		if (n)
+			continue;
+		if (feof(file))
+			break;
+		if (errno == EINTR) {
+			clearerr(file);
+			continue;
+		}
+		free(text);
+		return -errno;
+	}
+	text[used] = '\0';
+	*textp = text;
+	*lenp = used;
+	return 0;
+}
+
+static int file_read(const char *path, char **textp, size_t *lenp)
+{
+	FILE *file;
+	int ret;
+
+	file = fopen(path, "re");
+	if (!file)
+		return -errno;
+	ret = stream_read(file, textp, lenp);
+	fclose(file);
+	return ret;
+}
+
+static int json_source_read(const char *source, char **textp, size_t *lenp)
+{
+	if (source[0] != '@' && strcmp(source, "-")) {
+		*textp = strdup(source);
+		if (!*textp)
+			return -ENOMEM;
+		*lenp = strlen(*textp);
+		return 0;
+	}
+	if (!strcmp(source, "-"))
+		return stream_read(stdin, textp, lenp);
+	return file_read(source + 1, textp, lenp);
+}
+
+/* A blob --json names by its file, and the memory its descriptor names. */
+struct blob_file {
+	const struct ctlv_node_schema *node;
+	char *path;
+	void *data;
+	__u64 len;
+	/* Where its descriptor starts in the request. */
+	__u64 offset;
+	/* Whether the length is settled, rather than the op's to ask for. */
+	bool sized;
+	unsigned int grown;
+};
+
+/* A rebuilt request meets its blobs in the order the first build did. */
+struct blob_files {
+	struct blob_file *files;
+	unsigned int count;
+	/* How many of them the request being built has reached. */
+	unsigned int used;
+};
+
+/* How often one blob grows for an op that keeps asking for more. */
+#define BLOB_GROWN_MAX 2
+
+/* Zeroed and aligned as the blob requires. */
+static int blob_alloc(struct blob_file *blob, __u64 len)
+{
+	size_t align = blob->node->blob_alignment;
+	void *data;
+	int ret;
+
+	if (align < sizeof(void *))
+		align = sizeof(void *);
+	if (len > SIZE_MAX)
+		return -EFBIG;
+	ret = posix_memalign(&data, align, len);
+	if (ret)
+		return -ret;
+	memset(data, 0, len);
+	free(blob->data);
+	blob->data = data;
+	blob->len = len;
+	return 0;
+}
+
+/*
+ * Whether the op failed for want of a longer output blob that ctlvctl sizes,
+ * which then grows so that the op can be retried.
+ */
+static bool blobs_grow(struct blob_files *blobs, const struct ctlv_error *error)
+{
+	const __u32 need = CTLV_ERROR_HAS_BAD_TLV_OFFSET |
+			   CTLV_ERROR_HAS_REQUIRED_LENGTH;
+	unsigned int i;
+
+	if (error->err != -EMSGSIZE || (error->present & need) != need)
+		return false;
+	for (i = 0; i < blobs->count; i++) {
+		struct blob_file *blob = &blobs->files[i];
+
+		if (blob->offset != error->bad_tlv_offset)
+			continue;
+		if (blob->sized || blob->grown == BLOB_GROWN_MAX ||
+		    error->required_length <= blob->len ||
+		    error->required_length > blob->node->blob_max_length)
+			return false;
+		blob->grown++;
+		return !blob_alloc(blob, error->required_length);
+	}
+	return false;
+}
+
+/* The device does not say how much it wrote, so a file gets the whole blob. */
+static int blobs_save(const struct blob_files *blobs)
+{
+	unsigned int i;
+
+	for (i = 0; i < blobs->count; i++) {
+		const struct blob_file *blob = &blobs->files[i];
+		FILE *file;
+		int ret = 0;
+
+		if (blob->node->blob_direction == CTLV_BLOB_DIRECTION_INPUT)
+			continue;
+		file = fopen(blob->path, "we");
+		if (!file)
+			ret = -errno;
+		else if (fwrite(blob->data, 1, blob->len, file) != blob->len)
+			ret = errno ? -errno : -EIO;
+		if (file && fclose(file) && !ret)
+			ret = errno ? -errno : -EIO;
+		if (ret) {
+			fprintf(stderr, "%s: %s: %s\n", prog, blob->path,
+				strerror(-ret));
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static void blobs_free(struct blob_files *blobs)
+{
+	unsigned int i;
+
+	for (i = 0; i < blobs->count; i++) {
+		free(blobs->files[i].path);
+		free(blobs->files[i].data);
+	}
+	free(blobs->files);
+}
+
+#ifdef HAVE_JSON_C
+
+static const struct ctlv_node_schema *
+node_key(const struct ctlv_node_schema *parent,
+	 const struct ctlvctl_spec *spec, const char *key, bool *ambiguous)
+{
+	__u64 id;
+
+	if (!parse_u64(key, &id))
+		return node_member((const struct ctlv_node_schema *[]){ parent },
+				   0, id);
+	return node_named(parent, spec, key, ambiguous);
+}
+
+static int json_node_value(struct json_object *object,
+			   const struct ctlv_node_schema *parent,
+			   const struct ctlv_node_schema *wanted,
+			   const struct ctlvctl_spec *spec,
+			   struct json_object **value, bool *present)
+{
+	struct json_object *found = NULL;
+
+	json_object_object_foreach(object, key, item) {
+		const struct ctlv_node_schema *node;
+		bool ambiguous = false;
+
+		node = node_key(parent, spec, key, &ambiguous);
+		if (ambiguous) {
+			fprintf(stderr, "%s: %s: ambiguous field\n",
+				prog, key);
+			return -EINVAL;
+		}
+		if (!node) {
+			fprintf(stderr, "%s: %s: no such field here\n",
+				prog, key);
+			return -ENOENT;
+		}
+		if (node != wanted)
+			continue;
+		if (found) {
+			fprintf(stderr, "%s: %s: field given twice\n",
+				prog, key);
+			return -EINVAL;
+		}
+		found = item;
+	}
+	*present = !!found;
+	*value = found;
+	return 0;
+}
+
+static int json_text_value(struct json_object *value, const char **text)
+{
+	if (!json_object_is_type(value, json_type_string))
+		return -EINVAL;
+	*text = json_object_get_string(value);
+	if (strlen(*text) != (size_t)json_object_get_string_len(value))
+		return -EINVAL;
+	return 0;
+}
+
+static int json_u64_value(struct json_object *value, __u64 *number)
+{
+	const char *text;
+
+	if (json_object_is_type(value, json_type_int)) {
+		text = json_object_get_string(value);
+		return parse_u64(text, number);
+	}
+	if (!json_text_value(value, &text))
+		return parse_u64(text, number);
+	return -EINVAL;
+}
+
+static int json_s64_value(struct json_object *value, __s64 *number)
+{
+	if (json_object_is_type(value, json_type_int))
+		return parse_s64(json_object_get_string(value), number);
+	{
+		const char *text;
+
+		if (json_text_value(value, &text))
+			return -EINVAL;
+		return parse_s64(text, number);
+	}
+}
+
+static int json_flags_value(const struct ctlvctl_field_name *field,
+			    struct json_object *json, __u64 *value)
+{
+	size_t i, n;
+
+	if (!json_object_is_type(json, json_type_array))
+		return json_u64_value(json, value);
+	*value = 0;
+	n = json_object_array_length(json);
+	for (i = 0; i < n; i++) {
+		struct json_object *item = json_object_array_get_idx(json, i);
+		const char *name;
+		__u64 bit;
+
+		if (json_text_value(item, &name) ||
+		    ctlvctl_spec_value(field, name, &bit))
+			return -EINVAL;
+		*value |= bit;
+	}
+	return 0;
+}
+
+static int json_put_value(struct ctlv_msg *msg,
+			  const struct ctlv_node_schema *node,
+			  const struct ctlvctl_spec *spec,
+			  struct json_object *json)
+{
+	const struct ctlvctl_field_name *field = field_name(spec, node);
+	const char *text;
+	__u64 value;
+	__s64 signed_value;
+
+	switch (node->kind) {
+	case CTLV_SCHEMA_UINT:
+		if (json_u64_value(json, &value))
+			return -EINVAL;
+		return ctlv_put_u64(msg, node->type, value);
+	case CTLV_SCHEMA_SINT:
+		if (json_s64_value(json, &signed_value))
+			return -EINVAL;
+		return ctlv_put_s64(msg, node->type, signed_value);
+	case CTLV_SCHEMA_BOOL:
+		if (!json_object_is_type(json, json_type_boolean))
+			return -EINVAL;
+		return ctlv_put_bool(msg, node->type,
+				     json_object_get_boolean(json));
+	case CTLV_SCHEMA_STRING:
+		if (json_text_value(json, &text))
+			return -EINVAL;
+		return ctlv_put_str(msg, node->type, text);
+	case CTLV_SCHEMA_BINARY:
+		if (json_text_value(json, &text))
+			return -EINVAL;
+		if (strncmp(text, "hex:", 4))
+			return -EINVAL;
+		return put_hex(msg, node->type, text + 4);
+	case CTLV_SCHEMA_ENUM:
+		if (json_object_is_type(json, json_type_string)) {
+			if (json_text_value(json, &text) ||
+			    ctlvctl_spec_value(field, text, &value))
+				return -EINVAL;
+			return ctlv_put_u64(msg, node->type, value);
+		}
+		if (json_u64_value(json, &value))
+			return -EINVAL;
+		return ctlv_put_u64(msg, node->type, value);
+	case CTLV_SCHEMA_FLAGS:
+		if (json_flags_value(field, json, &value))
+			return -EINVAL;
+		return ctlv_put_u64(msg, node->type, value);
+	default:
+		return -ENOTSUP;
+	}
+}
+
+static const struct ctlv_node_schema *
+node_members(const struct ctlv_node_schema **stack, unsigned int depth)
+{
+	const struct ctlv_node_schema *node = stack[depth];
+	unsigned int level = depth;
+
+	if (!node)
+		return NULL;
+	while (node->reenters) {
+		if (node->reenters > level)
+			return NULL;
+		level -= node->reenters;
+		node = stack[level];
+		if (!node)
+			return NULL;
+	}
+	return node;
+}
+
+/* {"file": PATH}, and "length" for a blob the op writes. */
+static int json_blob_parse(const struct ctlv_node_schema *node,
+			   struct json_object *value, const char **path,
+			   __u64 *len, bool *sized)
+{
+	struct json_object *file = NULL, *length = NULL;
+
+	if (!json_object_is_type(value, json_type_object))
+		return -EINVAL;
+	json_object_object_foreach(value, key, item) {
+		if (!strcmp(key, "file"))
+			file = item;
+		else if (!strcmp(key, "length"))
+			length = item;
+		else
+			return -EINVAL;
+	}
+	if (!file || json_text_value(file, path) || !**path)
+		return -EINVAL;
+	*sized = !!length;
+	if (!length)
+		return 0;
+	if (node->blob_direction == CTLV_BLOB_DIRECTION_INPUT)
+		return -EINVAL;
+	return json_u64_value(length, len);
+}
+
+/* An output blob starts at a byte unless the request says how long it is. */
+static int json_blob_new(const struct ctlv_node_schema *node,
+			 struct json_object *value, struct blob_files *blobs)
+{
+	bool output = node->blob_direction == CTLV_BLOB_DIRECTION_OUTPUT;
+	struct blob_file *files, *blob;
+	char *contents = NULL;
+	const char *path;
+	size_t size = 0;
+	__u64 len = 1;
+	bool sized;
+	int ret;
+
+	if (!(node->present & CTLV_NODE_SCHEMA_HAS_BLOB) ||
+	    !(node->blob_backings & (1ULL << CTLV_BLOB_TYPE_VA)))
+		return -EOPNOTSUPP;
+	ret = json_blob_parse(node, value, &path, &len, &sized);
+	if (ret)
+		return ret;
+	if (!output) {
+		ret = file_read(path, &contents, &size);
+		if (ret)
+			return ret;
+		if (!sized)
+			len = size;
+	}
+	ret = -EINVAL;
+	if (!len)
+		goto out;
+	ret = -EFBIG;
+	if (len > node->blob_max_length || size > len)
+		goto out;
+	ret = -ENOMEM;
+	files = realloc(blobs->files, (blobs->count + 1) * sizeof(*files));
+	if (!files)
+		goto out;
+	blobs->files = files;
+	blob = &files[blobs->count];
+	*blob = (struct blob_file){
+		.node = node,
+		.path = strdup(path),
+		.sized = sized || !output,
+	};
+	if (!blob->path)
+		goto out;
+	ret = blob_alloc(blob, len);
+	if (ret) {
+		free(blob->path);
+		goto out;
+	}
+	if (size)
+		memcpy(blob->data, contents, size);
+	blobs->count++;
+out:
+	free(contents);
+	return ret;
+}
+
+static int json_blob_put(struct ctlv_msg *msg,
+			 const struct ctlv_node_schema *node,
+			 struct json_object *value, struct blob_files *blobs)
+{
+	struct blob_file *blob;
+	int ret;
+
+	if (blobs->used == blobs->count) {
+		ret = json_blob_new(node, value, blobs);
+		if (ret)
+			return ret;
+	}
+	blob = &blobs->files[blobs->used++];
+	if (blob->node != node)
+		return -EINVAL;
+	blob->offset = CTLV_ALIGN(ctlv_msg_len(msg));
+	return ctlv_put_blob_va(msg, node->type, blob->data, blob->len);
+}
+
+static int json_build_object(struct ctlv_msg *msg,
+			     const struct ctlv_node_schema **stack,
+			     unsigned int depth, struct json_object *object,
+			     const struct ctlvctl_spec *spec,
+			     struct blob_files *blobs);
+
+static int json_build_one(struct ctlv_msg *msg,
+			  const struct ctlv_node_schema **stack,
+			  unsigned int depth,
+			  const struct ctlv_node_schema *node,
+			  struct json_object *value,
+			  const struct ctlvctl_spec *spec,
+			  struct blob_files *blobs)
+{
+	int ret;
+
+	if (node->kind == CTLV_SCHEMA_BLOB)
+		return json_blob_put(msg, node, value, blobs);
+	if (node->kind != CTLV_SCHEMA_RECORD)
+		return json_put_value(msg, node, spec, value);
+	if (!json_object_is_type(value, json_type_object))
+		return -EINVAL;
+	if (depth + 1 >= PATH_DEPTH)
+		return -E2BIG;
+
+	ret = ctlv_record_start(msg, node->type);
+	if (ret)
+		return ret;
+	stack[depth + 1] = node;
+	ret = json_build_object(msg, stack, depth + 1, value, spec, blobs);
+	ctlv_record_end(msg);
+	return ret;
+}
+
+static int json_build_node(struct ctlv_msg *msg,
+			   const struct ctlv_node_schema **stack,
+			   unsigned int depth,
+			   const struct ctlv_node_schema *node,
+			   struct json_object *value,
+			   const struct ctlvctl_spec *spec,
+			   struct blob_files *blobs)
+{
+	size_t i, n;
+	int ret;
+
+	if (node->max_occurrences == 1)
+		return json_build_one(msg, stack, depth, node, value, spec,
+				      blobs);
+	if (!json_object_is_type(value, json_type_array))
+		return -EINVAL;
+	n = json_object_array_length(value);
+	if (node->max_occurrences && n > node->max_occurrences)
+		return -E2BIG;
+	for (i = 0; i < n; i++) {
+		ret = json_build_one(msg, stack, depth, node,
+				     json_object_array_get_idx(value, i), spec,
+				     blobs);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int json_build_members(struct ctlv_msg *msg,
+			      const struct ctlv_node_schema **stack,
+			      unsigned int depth,
+			      const struct ctlv_node_schema *parent,
+			      const struct ctlv_node_schema *node,
+			      unsigned int n, bool required,
+			      struct json_object *object,
+			      const struct ctlvctl_spec *spec,
+			      struct blob_files *blobs)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; i++) {
+		const struct ctlvctl_field_name *name = field_name(spec, &node[i]);
+		struct json_object *value;
+		bool present;
+		int ret;
+
+		ret = json_node_value(object, parent, &node[i], spec,
+				      &value, &present);
+		if (ret)
+			return ret;
+		if (!present) {
+			if (!required)
+				continue;
+			fprintf(stderr, "%s: %s: required field is missing\n",
+				prog, name ? name->name : "field");
+			return -EINVAL;
+		}
+		if (required && node[i].max_occurrences != 1 &&
+		    json_object_is_type(value, json_type_array) &&
+		    !json_object_array_length(value)) {
+			fprintf(stderr, "%s: %s: at least one value is required\n",
+				prog, name ? name->name : "field");
+			return -EINVAL;
+		}
+		ret = json_build_node(msg, stack, depth, &node[i], value,
+				      spec, blobs);
+		if (ret) {
+			fprintf(stderr, "%s: %s: %s\n", prog,
+				name ? name->name : "field", strerror(-ret));
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static int json_build_object(struct ctlv_msg *msg,
+			     const struct ctlv_node_schema **stack,
+			     unsigned int depth, struct json_object *object,
+			     const struct ctlvctl_spec *spec,
+			     struct blob_files *blobs)
+{
+	const struct ctlv_node_schema *parent;
+	int ret;
+
+	if (!json_object_is_type(object, json_type_object))
+		return -EINVAL;
+	parent = node_members(stack, depth);
+	if (!parent)
+		return -EINVAL;
+	json_object_object_foreach(object, key, item) {
+		bool ambiguous = false;
+
+		if (!node_key(parent, spec, key, &ambiguous)) {
+			fprintf(stderr, "%s: %s: %s field\n", prog, key,
+				ambiguous ? "ambiguous" : "no such");
+			return ambiguous ? -EINVAL : -ENOENT;
+		}
+	}
+
+	ret = json_build_members(msg, stack, depth, parent, parent->fields,
+				 parent->fields_count, true, object, spec,
+				 blobs);
+	if (ret)
+		return ret;
+	return json_build_members(msg, stack, depth, parent,
+				  parent->optional_fields,
+				  parent->optional_fields_count, false, object,
+				  spec, blobs);
+}
+
+/* A rebuild for a retry parses @text again and starts the message over. */
+static int json_request_build(struct ctlv_msg *msg,
+			      const struct ctlv_node_schema *root,
+			      const struct ctlvctl_spec *spec,
+			      const char *text, size_t text_len,
+			      struct blob_files *blobs)
+{
+	const struct ctlv_node_schema *stack[PATH_DEPTH] = { root };
+	struct json_tokener *tokener;
+	struct json_object *object;
+	enum json_tokener_error error;
+	int ret;
+
+	if (memchr(text, '\0', text_len))
+		return -EINVAL;
+	if (text_len >= INT_MAX)
+		return -E2BIG;
+	tokener = json_tokener_new_ex(PATH_DEPTH * 2 + 2);
+	if (!tokener)
+		return -ENOMEM;
+	json_tokener_set_flags(tokener, JSON_TOKENER_STRICT |
+			       JSON_TOKENER_VALIDATE_UTF8);
+	object = json_tokener_parse_ex(tokener, text, text_len + 1);
+	error = json_tokener_get_error(tokener);
+	if (error != json_tokener_success || !object) {
+		fprintf(stderr, "%s: invalid JSON request: %s\n", prog,
+			json_tokener_error_desc(error));
+		ret = -EINVAL;
+	} else {
+		ctlv_msg_reset(msg);
+		blobs->used = 0;
+		ret = json_build_object(msg, stack, 0, object, spec, blobs);
+		json_object_put(object);
+	}
+	json_tokener_free(tokener);
+	return ret;
+}
+
+#else /* HAVE_JSON_C */
+
+static int json_request_build(struct ctlv_msg *msg,
+			      const struct ctlv_node_schema *root,
+			      const struct ctlvctl_spec *spec,
+			      const char *text, size_t text_len,
+			      struct blob_files *blobs)
+{
+	fprintf(stderr, "%s: JSON support was built without json-c\n", prog);
+	return -EOPNOTSUPP;
+}
+
+#endif /* HAVE_JSON_C */
+
+#ifdef HAVE_JSON_C
+
+static char *hex_encode(const void *bytes, __u32 len, const char *prefix)
+{
+	const unsigned char *data = bytes;
+	size_t prefix_len = strlen(prefix);
+	char *text;
+	__u32 i;
+
+	text = malloc(prefix_len + (size_t)len * 2 + 1);
+	if (!text)
+		return NULL;
+	memcpy(text, prefix, prefix_len);
+	for (i = 0; i < len; i++)
+		snprintf(text + prefix_len + i * 2, 3, "%02x", data[i]);
+	return text;
+}
+
+static struct json_object *json_binary(const void *bytes, __u32 len)
+{
+	struct json_object *json;
+	char *text;
+
+	text = hex_encode(bytes, len, "hex:");
+	if (!text)
+		return NULL;
+	json = json_object_new_string(text);
+	free(text);
+	return json;
+}
+
+static struct json_object *json_invalid_utf8(const void *bytes, __u32 len)
+{
+	struct json_object *json;
+	char *text;
+
+	json = json_object_new_object();
+	text = hex_encode(bytes, len, "");
+	if (!json || !text) {
+		json_object_put(json);
+		free(text);
+		return NULL;
+	}
+	json_add_string(json, "encoding", "hex");
+	json_add_string(json, "data", text);
+	free(text);
+	return json;
+}
+
+static bool utf8_valid(const unsigned char *text, size_t len)
+{
+	size_t i = 0;
+
+	while (i < len) {
+		unsigned char first = text[i++];
+		unsigned int continuation;
+
+		if (first < 0x80)
+			continue;
+		if (first >= 0xc2 && first <= 0xdf) {
+			continuation = 1;
+		} else if (first >= 0xe0 && first <= 0xef) {
+			continuation = 2;
+			if (i >= len ||
+			    (first == 0xe0 && text[i] < 0xa0) ||
+			    (first == 0xed && text[i] >= 0xa0))
+				return false;
+		} else if (first >= 0xf0 && first <= 0xf4) {
+			continuation = 3;
+			if (i >= len ||
+			    (first == 0xf0 && text[i] < 0x90) ||
+			    (first == 0xf4 && text[i] >= 0x90))
+				return false;
+		} else {
+			return false;
+		}
+		if (continuation > len - i)
+			return false;
+		while (continuation--)
+			if ((text[i++] & 0xc0) != 0x80)
+				return false;
+	}
+	return true;
+}
+
+static struct json_object *
+json_payload(const struct ctlv_hdr *hdr,
+	     const struct ctlv_node_schema *node,
+	     const struct ctlvctl_spec *spec)
+{
+	const struct ctlvctl_field_name *name = field_name(spec, node);
+	const void *bytes;
+	const char *text;
+	struct json_object *json;
+	__u64 value;
+	__s64 signed_value;
+	__u32 len;
+	bool flag;
+	unsigned int i;
+
+	switch (node ? node->kind : CTLV_SCHEMA_BINARY) {
+	case CTLV_SCHEMA_UINT:
+		if (ctlv_get_u64(hdr, &value))
+			return NULL;
+		return json_object_new_uint64(value);
+	case CTLV_SCHEMA_SINT:
+		if (ctlv_get_s64(hdr, &signed_value))
+			return NULL;
+		return json_object_new_int64(signed_value);
+	case CTLV_SCHEMA_BOOL:
+		if (ctlv_get_bool(hdr, &flag))
+			return NULL;
+		return json_object_new_boolean(flag);
+	case CTLV_SCHEMA_STRING:
+		if (ctlv_get_str(hdr, &text))
+			return NULL;
+		len = ctlv_hdr_payload_len(hdr) - 1;
+		if (!utf8_valid((const unsigned char *)text, len))
+			return json_invalid_utf8(text, len);
+		return json_object_new_string_len(text, len);
+	case CTLV_SCHEMA_ENUM:
+		if (ctlv_get_u64(hdr, &value))
+			return NULL;
+		text = ctlvctl_spec_value_name(name, value);
+		return text ? json_object_new_string(text) :
+			      json_object_new_uint64(value);
+	case CTLV_SCHEMA_FLAGS:
+		if (ctlv_get_u64(hdr, &value))
+			return NULL;
+		if (!name || !name->definition)
+			return json_object_new_uint64(value);
+		json = json_object_new_array();
+		if (!json)
+			return NULL;
+		for (i = 0; i < name->definition->values_count; i++) {
+			const struct ctlvctl_value_name *item =
+				&name->definition->values[i];
+
+			if (!(value & item->value))
+				continue;
+			if (json_array_add_string(json, item->name)) {
+				json_object_put(json);
+				return NULL;
+			}
+			value &= ~item->value;
+		}
+		if (value) {
+			char unknown[32];
+
+			snprintf(unknown, sizeof(unknown), "%#llx",
+				 (unsigned long long)value);
+			if (json_array_add_string(json, unknown)) {
+				json_object_put(json);
+				return NULL;
+			}
+		}
+		return json;
+	default:
+		if (ctlv_get_bin(hdr, &bytes, &len))
+			return NULL;
+		return json_binary(bytes, len);
+	}
+}
+
+static int json_object_add_value(struct json_object *object, const char *key,
+				 struct json_object *value, bool repeated)
+{
+	struct json_object *array, *existing;
+	int ret;
+
+	if (!json_object_object_get_ex(object, key, &existing) && !repeated) {
+		ret = json_object_object_add(object, key, value);
+		if (ret)
+			json_object_put(value);
+		return ret ? -ENOMEM : 0;
+	}
+	if (!json_object_object_get_ex(object, key, &existing)) {
+		array = json_object_new_array();
+		if (!array) {
+			json_object_put(value);
+			return -ENOMEM;
+		}
+		ret = json_object_object_add(object, key, array);
+		if (ret) {
+			json_object_put(array);
+			json_object_put(value);
+			return -ENOMEM;
+		}
+		ret = json_object_array_add(array, value);
+		if (ret)
+			json_object_put(value);
+		return ret ? -ENOMEM : 0;
+	}
+	if (json_object_is_type(existing, json_type_array)) {
+		ret = json_object_array_add(existing, value);
+		if (ret)
+			json_object_put(value);
+		return ret ? -ENOMEM : 0;
+	}
+
+	array = json_object_new_array();
+	if (!array) {
+		json_object_put(value);
+		return -ENOMEM;
+	}
+	json_object_get(existing);
+	if (json_object_array_add(array, existing)) {
+		json_object_put(existing);
+		json_object_put(array);
+		json_object_put(value);
+		return -ENOMEM;
+	}
+	if (json_object_object_add(object, key, array)) {
+		json_object_put(array);
+		json_object_put(value);
+		return -ENOMEM;
+	}
+	ret = json_object_array_add(array, value);
+	if (ret)
+		json_object_put(value);
+	return ret ? -ENOMEM : 0;
+}
+
+static struct json_object *
+json_reply_object(const struct ctlv_hdr *record,
+		  const struct ctlv_node_schema **stack,
+		  unsigned int depth, const struct ctlvctl_spec *spec)
+{
+	struct json_object *object;
+	const struct ctlv_hdr *child;
+
+	object = json_object_new_object();
+	if (!object)
+		return NULL;
+	ctlv_for_each(child, record) {
+		const struct ctlv_node_schema *node = NULL;
+		const struct ctlvctl_field_name *name;
+		struct json_object *value;
+		char numeric[32];
+		const char *key;
+
+		if (depth < PATH_DEPTH)
+			node = node_member(stack, depth, child->type);
+		name = node ? field_name(spec, node) : NULL;
+		if (name) {
+			key = name->name;
+		} else {
+			snprintf(numeric, sizeof(numeric), "%#018llx",
+				 (unsigned long long)child->type);
+			key = numeric;
+		}
+		if (ctlv_hdr_is_record(child)) {
+			if (depth + 1 >= PATH_DEPTH) {
+				json_object_put(object);
+				return NULL;
+			}
+			stack[depth + 1] = node;
+			value = json_reply_object(child, stack, depth + 1,
+						  spec);
+		} else {
+			value = json_payload(child, node, spec);
+		}
+		if (!value ||
+		    json_object_add_value(object, key, value,
+					  node &&
+					  node->max_occurrences != 1)) {
+			json_object_put(object);
+			return NULL;
+		}
+	}
+	return object;
+}
+
+static struct json_object *
+json_reply(const struct ctlv_hdr *root,
+	   const struct ctlv_node_schema *tree,
+	   const struct ctlvctl_spec *spec)
+{
+	const struct ctlv_node_schema *stack[PATH_DEPTH] = { tree };
+
+	return json_reply_object(root, stack, 0, spec);
+}
+
+static void json_add_id(struct json_object *object, const char *key, __u64 id)
+{
+	char text[32];
+
+	snprintf(text, sizeof(text), "%#018llx", (unsigned long long)id);
+	json_object_object_add(object, key, json_object_new_string(text));
+}
+
+static void json_add_op(struct json_object *object,
+			const struct ctlvctl_spec *spec, __u64 op_id)
+{
+	const struct ctlvctl_op_name *name = ctlvctl_spec_op_id(spec, op_id);
+
+	if (name)
+		json_add_string(object, "op", name->name);
+	if (!name || options.show_ids)
+		json_add_id(object, "id", op_id);
+}
+
+static const char *schema_kind_name(__u32 kind)
+{
+	static const char *const names[] = {
+		[CTLV_SCHEMA_UINT] = "uint",
+		[CTLV_SCHEMA_SINT] = "sint",
+		[CTLV_SCHEMA_BOOL] = "bool",
+		[CTLV_SCHEMA_STRING] = "string",
+		[CTLV_SCHEMA_BINARY] = "binary",
+		[CTLV_SCHEMA_ENUM] = "enum",
+		[CTLV_SCHEMA_FLAGS] = "flags",
+		[CTLV_SCHEMA_RECORD] = "record",
+		[CTLV_SCHEMA_BLOB] = "blob",
+	};
+
+	if (kind >= ARRAY_SIZE(names) || !names[kind])
+		return "unknown";
+	return names[kind];
+}
+
+static struct json_object *
+json_schema_node(const struct ctlv_node_schema *node,
+		 const struct ctlvctl_spec *spec, bool required)
+{
+	const struct ctlvctl_field_name *name = field_name(spec, node);
+	struct json_object *object, *array;
+	unsigned int i;
+
+	object = json_object_new_object();
+	if (!object)
+		return NULL;
+	if (node->type != CTLV_TYPE_ROOT) {
+		if (name)
+			json_add_string(object, "name", name->name);
+		if (!name || options.show_ids)
+			json_add_id(object, "type", node->type);
+		json_add_bool(object, "required", required);
+	}
+	json_add_string(object, "kind", schema_kind_name(node->kind));
+	if (!node->max_occurrences)
+		json_add_string(object, "max-occurrences", "unlimited");
+	else
+		json_add_u64(object, "max-occurrences",
+			     node->max_occurrences);
+	if (node->present & CTLV_NODE_SCHEMA_HAS_MIN) {
+		if (node->kind == CTLV_SCHEMA_SINT)
+			json_add_s64(object, "min", (__s64)node->min);
+		else
+			json_add_u64(object, "min", node->min);
+	}
+	if (node->present & CTLV_NODE_SCHEMA_HAS_MAX) {
+		if (node->kind == CTLV_SCHEMA_SINT)
+			json_add_s64(object, "max", (__s64)node->max);
+		else
+			json_add_u64(object, "max", node->max);
+	}
+	if (node->present & CTLV_NODE_SCHEMA_HAS_MIN_LENGTH)
+		json_add_u64(object, "min-length", node->min_length);
+	if (node->present & CTLV_NODE_SCHEMA_HAS_MAX_LENGTH)
+		json_add_u64(object, "max-length", node->max_length);
+	if (name && name->definition) {
+		array = json_object_new_array();
+		if (!array) {
+			json_object_put(object);
+			return NULL;
+		}
+		for (i = 0; i < name->definition->values_count; i++) {
+			const char *value_name =
+				name->definition->values[i].name;
+
+			if (json_array_add_string(array, value_name)) {
+				json_object_put(array);
+				json_object_put(object);
+				return NULL;
+			}
+		}
+		json_object_object_add(object, "values", array);
+	}
+	if (node->reenters)
+		json_add_u64(object, "reenters", node->reenters);
+
+	array = json_object_new_array();
+	if (!array) {
+		json_object_put(object);
+		return NULL;
+	}
+	for (i = 0; i < node->fields_count; i++) {
+		struct json_object *child =
+			json_schema_node(&node->fields[i], spec, true);
+
+		if (!child) {
+			json_object_put(array);
+			json_object_put(object);
+			return NULL;
+		}
+		json_object_array_add(array, child);
+	}
+	for (i = 0; i < node->optional_fields_count; i++) {
+		struct json_object *child =
+			json_schema_node(&node->optional_fields[i], spec, false);
+
+		if (!child) {
+			json_object_put(array);
+			json_object_put(object);
+			return NULL;
+		}
+		json_object_array_add(array, child);
+	}
+	if (json_object_array_length(array))
+		json_object_object_add(object, "fields", array);
+	else
+		json_object_put(array);
+	return object;
+}
+
+static int json_schema_print(const struct ctlv_dev *dev,
+			     const struct ctlvctl_spec *spec, __u64 op_id,
+			     const struct ctlv_schema *schema)
+{
+	const struct ctlv_node_schema *node;
+	struct json_object *object, *tree;
+
+	object = json_object_new_object();
+	if (!object)
+		return -ENOMEM;
+	json_add_string(object, "device", ctlv_dev_name(dev));
+	json_add_op(object, spec, op_id);
+	node = ctlv_schema_request(schema);
+	if (node) {
+		tree = json_schema_node(node, spec, true);
+		if (!tree)
+			goto err;
+		json_object_object_add(object, "request", tree);
+	}
+	node = ctlv_schema_reply(schema);
+	if (node) {
+		tree = json_schema_node(node, spec, true);
+		if (!tree)
+			goto err;
+		json_object_object_add(object, "reply", tree);
+	}
+	return json_print(object);
+err:
+	json_object_put(object);
+	return -ENOMEM;
+}
+
+static int json_print(struct json_object *object)
+{
+	const char *text;
+	size_t len;
+	int ret = 0;
+
+	if (!object)
+		return -ENOMEM;
+	text = json_object_to_json_string_ext(object,
+					      JSON_C_TO_STRING_PLAIN);
+	if (!text) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	len = strlen(text);
+	if (fwrite(text, 1, len, stdout) != len ||
+	    fputc('\n', stdout) == EOF || fflush(stdout))
+		ret = errno ? -errno : -EIO;
+out:
+	json_object_put(object);
+	return ret;
+}
+
+static struct json_object *
+json_template_object(const struct ctlv_node_schema **stack,
+		     unsigned int depth, const struct ctlvctl_spec *spec);
+
+static struct json_object *
+json_template_value(const struct ctlv_node_schema **stack,
+		    unsigned int depth, const struct ctlv_node_schema *node,
+		    const struct ctlvctl_spec *spec)
+{
+	const struct ctlvctl_field_name *name = field_name(spec, node);
+	const char *text;
+	struct json_object *value;
+	__u64 number;
+
+	switch (node->kind) {
+	case CTLV_SCHEMA_UINT:
+		number = node->present & CTLV_NODE_SCHEMA_HAS_MIN ? node->min : 0;
+		value = json_object_new_uint64(number);
+		break;
+	case CTLV_SCHEMA_SINT:
+		number = node->present & CTLV_NODE_SCHEMA_HAS_MIN ? node->min : 0;
+		value = json_object_new_int64((__s64)number);
+		break;
+	case CTLV_SCHEMA_BOOL:
+		value = json_object_new_boolean(false);
+		break;
+	case CTLV_SCHEMA_STRING: {
+		size_t len = node->present & CTLV_NODE_SCHEMA_HAS_MIN_LENGTH ?
+			     node->min_length : 0;
+		char *text = calloc(len + 1, 1);
+
+		if (!text)
+			return NULL;
+		memset(text, 'x', len);
+		value = json_object_new_string_len(text, len);
+		free(text);
+		break;
+	}
+	case CTLV_SCHEMA_BINARY: {
+		size_t len = node->present & CTLV_NODE_SCHEMA_HAS_MIN_LENGTH ?
+			     node->min_length : 0;
+		unsigned char *bytes = calloc(len ? len : 1, 1);
+
+		if (!bytes)
+			return NULL;
+		value = json_binary(bytes, len);
+		free(bytes);
+		break;
+	}
+	case CTLV_SCHEMA_ENUM:
+		number = node->present & CTLV_NODE_SCHEMA_HAS_MIN ? node->min : 0;
+		text = ctlvctl_spec_value_name(name, number);
+		if (text)
+			value = json_object_new_string(text);
+		else
+			value = json_object_new_uint64(number);
+		break;
+	case CTLV_SCHEMA_FLAGS:
+		value = json_object_new_array();
+		break;
+	case CTLV_SCHEMA_RECORD:
+		if (depth + 1 >= PATH_DEPTH)
+			return NULL;
+		stack[depth + 1] = node;
+		value = json_template_object(stack, depth + 1, spec);
+		break;
+	case CTLV_SCHEMA_BLOB:
+		value = json_object_new_object();
+		if (value)
+			json_add_string(value, "file", "");
+		break;
+	default:
+		fprintf(stderr, "%s: cannot template schema kind %u\n", prog,
+			node->kind);
+		return NULL;
+	}
+	if (!value)
+		return NULL;
+	if (node->max_occurrences == 1)
+		return value;
+
+	{
+		struct json_object *array = json_object_new_array();
+
+		if (!array) {
+			json_object_put(value);
+			return NULL;
+		}
+		json_object_array_add(array, value);
+		return array;
+	}
+}
+
+static struct json_object *
+json_template_object(const struct ctlv_node_schema **stack,
+		     unsigned int depth, const struct ctlvctl_spec *spec)
+{
+	const struct ctlv_node_schema *parent = node_members(stack, depth);
+	struct json_object *object;
+	unsigned int i;
+
+	if (!parent)
+		return NULL;
+	object = json_object_new_object();
+	if (!object)
+		return NULL;
+	for (i = 0; i < parent->fields_count; i++) {
+		const struct ctlv_node_schema *node = &parent->fields[i];
+		const struct ctlvctl_field_name *name = field_name(spec, node);
+		struct json_object *value;
+		char numeric[32];
+		const char *key;
+
+		value = json_template_value(stack, depth, node, spec);
+		if (!value) {
+			json_object_put(object);
+			return NULL;
+		}
+		if (name) {
+			key = name->name;
+		} else {
+			snprintf(numeric, sizeof(numeric), "%#018llx",
+				 (unsigned long long)node->type);
+			key = numeric;
+		}
+		json_object_object_add(object, key, value);
+	}
+	return object;
+}
+
+static int json_template_print(const struct ctlv_node_schema *root,
+			       const struct ctlvctl_spec *spec)
+{
+	const struct ctlv_node_schema *stack[PATH_DEPTH] = { root };
+
+	return json_print(json_template_object(stack, 0, spec));
+}
+
+#endif /* HAVE_JSON_C */
+
+static void payload_print(const struct ctlv_hdr *hdr,
+			  const struct ctlv_node_schema *node,
+			  const struct ctlvctl_spec *spec)
+{
+	const struct ctlvctl_field_name *name = field_name(spec, node);
+	const void *bytes;
+	const char *text;
+	__u64 value;
+	__s64 signed_value;
+	bool flag;
+	__u32 len, i;
+
+	switch (node ? node->kind : CTLV_SCHEMA_BINARY) {
+	case CTLV_SCHEMA_UINT:
+		if (!ctlv_get_u64(hdr, &value))
+			printf("%llu", (unsigned long long)value);
+		return;
+	case CTLV_SCHEMA_ENUM:
+		if (ctlv_get_u64(hdr, &value))
+			return;
+		text = ctlvctl_spec_value_name(name, value);
+		if (!text) {
+			printf("%llu", (unsigned long long)value);
+			return;
+		}
+		printf("%s", text);
+		if (options.show_ids)
+			printf(" (%llu)", (unsigned long long)value);
+		return;
+	case CTLV_SCHEMA_FLAGS:
+		if (ctlv_get_u64(hdr, &value))
+			return;
+		if (name && name->definition) {
+			__u64 unknown = value;
+			bool first = true;
+
+			for (i = 0; i < name->definition->values_count; i++) {
+				const struct ctlvctl_value_name *item =
+					&name->definition->values[i];
+
+				if (!(value & item->value))
+					continue;
+				printf("%s%s", first ? "" : ",", item->name);
+				unknown &= ~item->value;
+				first = false;
+			}
+			if (unknown || first)
+				printf("%s%#llx", first ? "" : ",",
+				       (unsigned long long)unknown);
+			if (options.show_ids)
+				printf(" (%#llx)", (unsigned long long)value);
+		} else {
+			printf("%#llx", (unsigned long long)value);
+		}
+		return;
+	case CTLV_SCHEMA_SINT:
+		if (!ctlv_get_s64(hdr, &signed_value))
+			printf("%lld", (long long)signed_value);
+		return;
+	case CTLV_SCHEMA_BOOL:
+		if (!ctlv_get_bool(hdr, &flag))
+			printf("%s", flag ? "true" : "false");
+		return;
+	case CTLV_SCHEMA_STRING:
+		if (!ctlv_get_str(hdr, &text))
+			printf("%s", text);
+		return;
+	default:
+		if (ctlv_get_bin(hdr, &bytes, &len))
+			return;
+		if (name)
+			printf("hex:");
+		for (i = 0; i < len; i++)
+			printf("%02x", ((const __u8 *)bytes)[i]);
+		return;
+	}
+}
+
+/*
+ * Printed as the schema says, and a TLV the schema does not mention is
+ * printed as bytes with a "?": a device newer than this tool is not an error.
+ */
+static void reply_print(const struct ctlv_hdr *record,
+			const struct ctlv_node_schema **stack,
+			unsigned int depth, const struct ctlvctl_spec *spec)
+{
+	const struct ctlv_hdr *child;
+
+	ctlv_for_each(child, record) {
+		const struct ctlv_node_schema *node = NULL;
+		const struct ctlvctl_field_name *name;
+
+		if (depth < PATH_DEPTH)
+			node = node_member(stack, depth, child->type);
+		name = node ? field_name(spec, node) : NULL;
+		printf("%*s", (depth + 1) * 2, "");
+		if (name) {
+			printf("%s", name->name);
+			if (options.show_ids)
+				printf(" (%#018llx)",
+				       (unsigned long long)child->type);
+		} else {
+			printf("%#018llx%s",
+			       (unsigned long long)child->type,
+			       node ? "" : "?");
+		}
+		if (ctlv_hdr_is_record(child)) {
+			printf("\n");
+			if (depth + 1 < PATH_DEPTH) {
+				stack[depth + 1] = node;
+				reply_print(child, stack, depth + 1, spec);
+			}
+			continue;
+		}
+		printf(" ");
+		payload_print(child, node, spec);
+		printf("\n");
+	}
+}
+
+static void reply_dump(const struct ctlv_hdr *root,
+		       const struct ctlv_node_schema *tree,
+		       const struct ctlvctl_spec *spec)
+{
+	const struct ctlv_node_schema *stack[PATH_DEPTH] = { tree };
+
+	reply_print(root, stack, 0, spec);
+}
+
+static int run_op_info(const struct ctlv_dev *dev,
+		       const struct ctlvctl_spec *spec,
+		       const struct ctlv_ops *ops, __u64 op_id,
+		       const struct ctlv_op_info **infop)
+{
+	const struct ctlvctl_op_name *name = ctlvctl_spec_op_id(spec, op_id);
+	const struct ctlv_op_info *info = ctlv_ops_find(ops, op_id);
+
+	if (!info) {
+		fprintf(stderr, "%s: operation is not available on %s\n",
+			prog, ctlv_dev_name(dev));
+		return -ENOENT;
+	}
+	if (name && !op_matches(name, info)) {
+		fprintf(stderr, "%s: specification disagrees with operation %s\n",
+			prog, name->name);
+		return -ENOMSG;
+	}
+	if (info->fd_access != CTLV_OP_FD_ACCESS_READ &&
+	    info->fd_access != CTLV_OP_FD_ACCESS_READ_WRITE)
+		return -EPROTO;
+	*infop = info;
+	return 0;
+}
+
+static int cmd_run(int argc, char **argv)
+{
+	const struct ctlvctl_op_name *name;
+	const struct ctlv_node_schema *request_tree;
+	const struct ctlv_op_info *info;
+	struct ctlvctl_spec *spec = NULL;
+	struct ctlv_msg *request = NULL;
+	struct ctlv_reply *reply = NULL;
+	struct blob_files blobs = {};
+	struct ctlv_schema *schema;
+	struct ctlv_ops *ops = NULL;
+	struct ctlv_error error;
+	struct ctlv_dev *dev;
+	const char *json_source = NULL;
+	char *json_text = NULL;
+	char text[LINE_LEN];
+	size_t json_len = 0;
+	__u64 reply_len = 0;
+	__u64 op_id;
+	__u32 fd_access;
+	__u32 type;
+	int ret;
+
+	if (argc > 1 && !strcmp(argv[0], "-l")) {
+		ret = parse_u64(argv[1], &reply_len);
+		if (ret || !reply_len || reply_len > UINT32_MAX) {
+			fprintf(stderr, "%s: %s: not a reply length\n", prog,
+				argv[1]);
+			return ret ? ret : -EINVAL;
+		}
+		argc -= 2;
+		argv += 2;
+	}
+
+	if (argc < 2) {
+		help(stderr);
+		return -EINVAL;
+	}
+	if (argc > 2 && !strcmp(argv[2], "--json")) {
+		if (argc != 4) {
+			fprintf(stderr,
+				"%s: --json needs one source and no assignments\n",
+				prog);
+			return -EINVAL;
+		}
+		json_source = argv[3];
+	}
+	/* Discovery is always available through an observation fd. */
+	ret = dev_open(argv[0], O_RDONLY, &dev);
+	if (ret)
+		return ret;
+	ret = spec_load(dev, &spec);
+	if (ret)
+		goto out_close;
+	ret = op_resolve(spec, argv[1], &op_id);
+	if (ret)
+		goto out_close;
+
+	name = ctlvctl_spec_op_id(spec, op_id);
+	ret = ctlv_ops_get(dev, &ops, &error);
+	if (ret) {
+		fprintf(stderr, "%s: op-get: %s\n", prog,
+			ctlv_error_str(&error, text, sizeof(text)));
+		goto out_close;
+	}
+	ret = run_op_info(dev, spec, ops, op_id, &info);
+	if (ret)
+		goto out_free_ops;
+	fd_access = info->fd_access;
+	type = info->type;
+	ctlv_ops_free(ops);
+	ops = NULL;
+
+	if (fd_access == CTLV_OP_FD_ACCESS_READ_WRITE) {
+		__u64 reopened_id;
+
+		ctlvctl_spec_free(spec);
+		spec = NULL;
+		ctlv_close(dev);
+		dev = NULL;
+		ret = dev_open(argv[0], O_RDWR, &dev);
+		if (ret)
+			return ret;
+		ret = spec_load(dev, &spec);
+		if (ret)
+			goto out_close;
+		ret = op_resolve(spec, argv[1], &reopened_id);
+		if (ret)
+			goto out_close;
+		if (reopened_id != op_id) {
+			ret = -ENODEV;
+			goto out_close;
+		}
+		name = ctlvctl_spec_op_id(spec, op_id);
+		ret = ctlv_ops_get(dev, &ops, &error);
+		if (ret) {
+			fprintf(stderr, "%s: op-get: %s\n", prog,
+				ctlv_error_str(&error, text, sizeof(text)));
+			goto out_close;
+		}
+		ret = run_op_info(dev, spec, ops, op_id, &info);
+		if (ret)
+			goto out_free_ops;
+		if (info->fd_access != fd_access || info->type != type) {
+			ret = -ENODEV;
+			goto out_free_ops;
+		}
+		ctlv_ops_free(ops);
+		ops = NULL;
+	}
+
+	/* The schema first: it says how to read values and print the reply. */
+	ret = ctlv_op_schema_get(dev, op_id, &schema, &error);
+	if (ret) {
+		fprintf(stderr, "%s: op-schema-get: %s\n", prog,
+			ctlv_error_str(&error, text, sizeof(text)));
+		goto out_close;
+	}
+	ret = tree_names_check(spec, ctlv_schema_request(schema));
+	if (!ret)
+		ret = tree_names_check(spec, ctlv_schema_reply(schema));
+	if (ret)
+		goto out_free_schema;
+
+	request_tree = ctlv_schema_request(schema);
+	if ((argc > 2 || json_source) && !request_tree) {
+		fprintf(stderr, "%s: this op takes no request\n", prog);
+		ret = -EINVAL;
+		goto out_free_schema;
+	}
+	if (request_tree) {
+		ret = ctlv_msg_new(REQUEST_HINT, &request);
+		if (ret)
+			goto out_free_schema;
+		if (json_source) {
+			ret = json_source_read(json_source, &json_text,
+					       &json_len);
+			if (!ret)
+				ret = json_request_build(request, request_tree,
+							 spec, json_text,
+							 json_len, &blobs);
+		} else {
+			ret = request_build(request, request_tree, spec,
+					    argc - 2, argv + 2);
+		}
+		if (ret)
+			goto out_free_request;
+	}
+
+	for (;;) {
+		if (type == CTLV_OP_TYPE_QUERY && reply_len)
+			ret = ctlv_query_sized(dev, op_id, request, reply_len,
+					       &reply, &error);
+		else if (type == CTLV_OP_TYPE_QUERY)
+			ret = ctlv_query(dev, op_id, request, &reply, &error);
+		else if (reply_len)
+			ret = ctlv_action_sized(dev, op_id, request, reply_len,
+						&reply, &error);
+		else
+			ret = ctlv_action(dev, op_id, request, &reply, &error);
+		if (!ret || !blobs_grow(&blobs, &error))
+			break;
+		ret = json_request_build(request, request_tree, spec,
+					 json_text, json_len, &blobs);
+		if (ret)
+			goto out_free_request;
+	}
+	if (ret) {
+		fprintf(stderr, "%s: %s\n", prog,
+			ctlv_error_str(&error, text, sizeof(text)));
+		goto out_free_request;
+	}
+	ret = blobs_save(&blobs);
+	if (ret)
+		goto out_free_reply;
+
+	if (options.output_json) {
+#ifdef HAVE_JSON_C
+		struct json_object *output = json_object_new_object();
+
+		if (!output) {
+			ret = -ENOMEM;
+			goto out_free_reply;
+		}
+		json_add_string(output, "device", ctlv_dev_name(dev));
+		json_add_op(output, spec, op_id);
+		if (!reply) {
+			json_add_bool(output, "acknowledged", true);
+		} else {
+			struct json_object *body;
+
+			json_add_u64(output, "generation",
+				     ctlv_reply_generation(reply));
+			json_add_int(output, "fragments",
+				     ctlv_reply_fragments(reply));
+			body = json_reply(ctlv_reply_root(reply),
+					  ctlv_schema_reply(schema), spec);
+			if (!body) {
+				json_object_put(output);
+				ret = -ENOMEM;
+				goto out_free_reply;
+			}
+			json_object_object_add(output, "reply", body);
+		}
+		ret = json_print(output);
+#endif
+	} else if (!reply) {
+		printf("# acknowledged\n");
+	} else {
+		printf("# ");
+		if (name) {
+			printf("%s", name->name);
+			if (options.show_ids)
+				printf(" (%#018llx)",
+				       (unsigned long long)op_id);
+			printf(", ");
+		}
+		printf("%u fragment%s, generation %llu\n",
+		       ctlv_reply_fragments(reply),
+		       ctlv_reply_fragments(reply) == 1 ? "" : "s",
+		       (unsigned long long)ctlv_reply_generation(reply));
+		reply_dump(ctlv_reply_root(reply), ctlv_schema_reply(schema),
+			   spec);
+	}
+out_free_reply:
+	ctlv_reply_free(reply);
+out_free_request:
+	ctlv_msg_free(request);
+	blobs_free(&blobs);
+	free(json_text);
+out_free_schema:
+	ctlv_schema_free(schema);
+out_close:
+	ctlvctl_spec_free(spec);
+	ctlv_close(dev);
+	return ret;
+out_free_ops:
+	ctlv_ops_free(ops);
+	goto out_close;
+}
+
+int main(int argc, char **argv)
+{
+	static const struct option long_options[] = {
+		{ "spec-dir", required_argument, NULL, 1 },
+		{ "show-ids", no_argument, NULL, 'n' },
+		{ "output-json", no_argument, NULL, 2 },
+		{ "help", no_argument, NULL, 'h' },
+		{},
+	};
+	const char *command;
+	const char *spec_dir;
+	int opt;
+
+	if (argc > 0)
+		prog = argv[0];
+	while ((opt = getopt_long(argc, argv, "+nh", long_options, NULL)) != -1) {
+		switch (opt) {
+		case 1:
+			options.spec_dir = optarg;
+			break;
+		case 2:
+			options.output_json = true;
+			break;
+		case 'n':
+			options.show_ids = true;
+			break;
+		case 'h':
+			help(stdout);
+			return EXIT_SUCCESS;
+		default:
+			help(stderr);
+			return EXIT_FAILURE;
+		}
+	}
+	if (!options.spec_dir) {
+		spec_dir = getenv("CTLV_SPEC_DIR");
+		if (spec_dir && *spec_dir)
+			options.spec_dir = spec_dir;
+	}
+#ifndef HAVE_JSON_C
+	if (options.spec_dir || options.output_json) {
+		fprintf(stderr,
+			"%s: specification and JSON support require json-c\n",
+			prog);
+		return EXIT_FAILURE;
+	}
+#endif
+	if (optind == argc) {
+		help(stderr);
+		return EXIT_FAILURE;
+	}
+	command = argv[optind++];
+	argc -= optind;
+	argv += optind;
+
+	if (!strcmp(command, "list"))
+		return cmd_list(argc, argv) ? EXIT_FAILURE : EXIT_SUCCESS;
+	if (!strcmp(command, "ops"))
+		return cmd_ops(argc, argv) ? EXIT_FAILURE : EXIT_SUCCESS;
+	if (!strcmp(command, "schema"))
+		return cmd_schema(argc, argv) ? EXIT_FAILURE : EXIT_SUCCESS;
+	if (!strcmp(command, "exec"))
+		return cmd_run(argc, argv) ? EXIT_FAILURE : EXIT_SUCCESS;
+	if (!strcmp(command, "help") || !strcmp(command, "--help")) {
+		help(stdout);
+		return EXIT_SUCCESS;
+	}
+	fprintf(stderr, "%s: %s: no such command\n", prog, command);
+	help(stderr);
+	return EXIT_FAILURE;
+}
diff --git a/tools/ctlv/ctlvctl/spec.c b/tools/ctlv/ctlvctl/spec.c
new file mode 100644
index 000000000000..7fa1e3de2d33
--- /dev/null
+++ b/tools/ctlv/ctlvctl/spec.c
@@ -0,0 +1,672 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+#include <ctype.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include <ctlv.h>
+
+#include "spec.h"
+
+#define ARRAY_SIZE(array) (sizeof(array) / sizeof((array)[0]))
+
+struct ctlvctl_spec {
+	struct ctlvctl_definition *definitions;
+	unsigned int definitions_count;
+	struct ctlvctl_field_name *fields;
+	unsigned int fields_count;
+	struct ctlvctl_op_name *ops;
+	unsigned int ops_count;
+};
+
+#ifdef HAVE_JSON_C
+
+#include <json.h>
+
+static int parse_u64(const char *text, __u64 *value)
+{
+	char *end;
+
+	if (!*text || *text == '-' || isspace((unsigned char)*text))
+		return -EINVAL;
+	errno = 0;
+	*value = strtoull(text, &end, 0);
+	if (errno || end == text || *end)
+		return -EINVAL;
+	return 0;
+}
+
+static int json_member(struct json_object *parent, const char *name,
+		       enum json_type type, struct json_object **value)
+{
+	if (!json_object_object_get_ex(parent, name, value) ||
+	    !json_object_is_type(*value, type))
+		return -EINVAL;
+	return 0;
+}
+
+static int json_string_dup(struct json_object *parent, const char *name,
+			   char **value)
+{
+	struct json_object *item;
+
+	if (json_member(parent, name, json_type_string, &item))
+		return -EINVAL;
+	*value = strdup(json_object_get_string(item));
+	return *value ? 0 : -ENOMEM;
+}
+
+static int json_u64(struct json_object *parent, const char *name, __u64 *value)
+{
+	struct json_object *item;
+
+	if (!json_object_object_get_ex(parent, name, &item))
+		return -EINVAL;
+	if (json_object_is_type(item, json_type_string))
+		return parse_u64(json_object_get_string(item), value);
+	if (!json_object_is_type(item, json_type_int))
+		return -EINVAL;
+	*value = json_object_get_uint64(item);
+	return 0;
+}
+
+static int kind_parse(const char *name, __u32 *kind)
+{
+	static const char *const names[] = {
+		[CTLV_SCHEMA_UINT] = "uint",
+		[CTLV_SCHEMA_SINT] = "sint",
+		[CTLV_SCHEMA_BOOL] = "bool",
+		[CTLV_SCHEMA_STRING] = "string",
+		[CTLV_SCHEMA_BINARY] = "binary",
+		[CTLV_SCHEMA_ENUM] = "enum",
+		[CTLV_SCHEMA_FLAGS] = "flags",
+		[CTLV_SCHEMA_RECORD] = "record",
+		[CTLV_SCHEMA_BLOB] = "blob",
+	};
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(names); i++)
+		if (names[i] && !strcmp(names[i], name)) {
+			*kind = i;
+			return 0;
+		}
+	return -EINVAL;
+}
+
+static int op_type_parse(const char *name, __u32 *type)
+{
+	if (!strcmp(name, "action"))
+		*type = CTLV_OP_TYPE_ACTION;
+	else if (!strcmp(name, "query"))
+		*type = CTLV_OP_TYPE_QUERY;
+	else
+		return -EINVAL;
+	return 0;
+}
+
+static int availability_parse(const char *name, __u32 *availability)
+{
+	if (!strcmp(name, "fixed"))
+		*availability = CTLV_OP_AVAILABILITY_FIXED;
+	else if (!strcmp(name, "dynamic"))
+		*availability = CTLV_OP_AVAILABILITY_DYNAMIC;
+	else
+		return -EINVAL;
+	return 0;
+}
+
+static int fd_access_parse(const char *name, __u32 *fd_access)
+{
+	if (!strcmp(name, "read"))
+		*fd_access = CTLV_OP_FD_ACCESS_READ;
+	else if (!strcmp(name, "read-write"))
+		*fd_access = CTLV_OP_FD_ACCESS_READ_WRITE;
+	else
+		return -EINVAL;
+	return 0;
+}
+
+static struct ctlvctl_definition *
+definition_find(struct ctlvctl_spec *spec, const char *name)
+{
+	unsigned int i;
+
+	for (i = 0; i < spec->definitions_count; i++)
+		if (!strcmp(spec->definitions[i].name, name))
+			return &spec->definitions[i];
+	return NULL;
+}
+
+static int definition_parse(struct json_object *json,
+			    struct ctlvctl_definition *definition)
+{
+	struct json_object *kind, *values;
+	size_t i, n;
+	int ret;
+
+	ret = json_string_dup(json, "name", &definition->name);
+	if (ret)
+		return ret;
+	if (json_member(json, "kind", json_type_string, &kind) ||
+	    kind_parse(json_object_get_string(kind), &definition->kind))
+		return -EINVAL;
+	if (definition->kind != CTLV_SCHEMA_ENUM &&
+	    definition->kind != CTLV_SCHEMA_FLAGS)
+		return -EINVAL;
+	if (json_member(json, "values", json_type_array, &values))
+		return -EINVAL;
+
+	n = json_object_array_length(values);
+	definition->values = calloc(n, sizeof(*definition->values));
+	if (n && !definition->values)
+		return -ENOMEM;
+	definition->values_count = n;
+	for (i = 0; i < n; i++) {
+		struct json_object *item = json_object_array_get_idx(values, i);
+
+		if (!item ||
+		    json_string_dup(item, "name",
+				    &definition->values[i].name) ||
+		    json_u64(item, "value", &definition->values[i].value))
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static int definitions_parse(struct json_object *root,
+			     struct ctlvctl_spec *spec)
+{
+	struct json_object *items;
+	size_t i, n;
+	int ret;
+
+	if (json_member(root, "definitions", json_type_array, &items))
+		return -EINVAL;
+	n = json_object_array_length(items);
+	spec->definitions = calloc(n, sizeof(*spec->definitions));
+	if (n && !spec->definitions)
+		return -ENOMEM;
+	spec->definitions_count = n;
+	for (i = 0; i < n; i++) {
+		ret = definition_parse(json_object_array_get_idx(items, i),
+				       &spec->definitions[i]);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int field_parse(struct json_object *json, struct ctlvctl_spec *spec,
+		       struct ctlvctl_field_name *field)
+{
+	struct json_object *item;
+	const char *definition;
+	int ret;
+
+	ret = json_string_dup(json, "name", &field->name);
+	if (ret)
+		return ret;
+	ret = json_string_dup(json, "short", &field->short_name);
+	if (ret)
+		return ret;
+	ret = json_u64(json, "type", &field->type);
+	if (ret)
+		return ret;
+	if (json_member(json, "kind", json_type_string, &item) ||
+	    kind_parse(json_object_get_string(item), &field->kind))
+		return -EINVAL;
+
+	if (!json_object_object_get_ex(json, "definition", &item))
+		return 0;
+	if (!json_object_is_type(item, json_type_string))
+		return -EINVAL;
+	definition = json_object_get_string(item);
+	field->definition = definition_find(spec, definition);
+	return field->definition ? 0 : -EINVAL;
+}
+
+static int fields_parse(struct json_object *root, struct ctlvctl_spec *spec)
+{
+	struct json_object *items;
+	size_t i, n;
+	int ret;
+
+	if (json_member(root, "fields", json_type_array, &items))
+		return -EINVAL;
+	n = json_object_array_length(items);
+	spec->fields = calloc(n, sizeof(*spec->fields));
+	if (n && !spec->fields)
+		return -ENOMEM;
+	spec->fields_count = n;
+	for (i = 0; i < n; i++) {
+		ret = field_parse(json_object_array_get_idx(items, i),
+				  spec, &spec->fields[i]);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int op_parse(struct json_object *json, struct ctlvctl_op_name *op)
+{
+	struct json_object *item;
+	int ret;
+
+	ret = json_string_dup(json, "name", &op->name);
+	if (ret)
+		return ret;
+	ret = json_u64(json, "id", &op->id);
+	if (ret)
+		return ret;
+	if (json_member(json, "type", json_type_string, &item) ||
+	    op_type_parse(json_object_get_string(item), &op->type))
+		return -EINVAL;
+	if (json_member(json, "fd-access", json_type_string, &item) ||
+	    fd_access_parse(json_object_get_string(item), &op->fd_access) ||
+	    json_member(json, "availability", json_type_string, &item) ||
+	    availability_parse(json_object_get_string(item),
+			       &op->availability))
+		return -EINVAL;
+	if (json_u64(json, "request-max-len", &op->request_max_len) ||
+	    json_u64(json, "action-reply-max-len",
+		     &op->action_reply_max_len) ||
+	    json_u64(json, "query-reply-min-len",
+		     &op->query_reply_min_len) ||
+	    json_u64(json, "query-reply-suggested-len",
+		     &op->query_reply_suggested_len))
+		return -EINVAL;
+	return 0;
+}
+
+static int ops_parse(struct json_object *root, struct ctlvctl_spec *spec)
+{
+	struct json_object *items;
+	size_t i, n;
+	int ret;
+
+	if (json_member(root, "ops", json_type_array, &items))
+		return -EINVAL;
+	n = json_object_array_length(items);
+	spec->ops = calloc(n, sizeof(*spec->ops));
+	if (n && !spec->ops)
+		return -ENOMEM;
+	spec->ops_count = n;
+	for (i = 0; i < n; i++) {
+		ret = op_parse(json_object_array_get_idx(items, i), &spec->ops[i]);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int chain_check(struct json_object *root, const struct ctlv_dev *dev)
+{
+	struct json_object *family, *chain;
+	size_t i, n;
+
+	if (json_member(root, "family", json_type_string, &family) ||
+	    strcmp(json_object_get_string(family), ctlv_dev_family(dev)))
+		return -ENOMSG;
+	if (json_member(root, "chain", json_type_array, &chain))
+		return -EINVAL;
+	n = json_object_array_length(chain);
+	if (n != ctlv_chain_len(dev))
+		return -ENOMSG;
+
+	for (i = 0; i < n; i++) {
+		struct json_object *item, *name;
+		__u64 id;
+
+		item = json_object_array_get_idx(chain, i);
+		if (!item ||
+		    json_member(item, "name", json_type_string, &name) ||
+		    json_u64(item, "id", &id))
+			return -EINVAL;
+		if (id != ctlv_chain_id(dev, i) ||
+		    strcmp(json_object_get_string(name),
+			   ctlv_chain_name(dev, i)))
+			return -ENOMSG;
+	}
+	return 0;
+}
+
+static int manifest_parse(const char *prog, const char *text,
+			  const struct ctlv_dev *dev,
+			  struct ctlvctl_spec **specp)
+{
+	struct json_tokener *tokener;
+	struct json_object *root;
+	struct ctlvctl_spec *spec;
+	enum json_tokener_error error;
+	size_t text_len;
+	__u64 version;
+	int ret;
+
+	if (!text)
+		return -EINVAL;
+	text_len = strlen(text);
+	if (text_len >= INT_MAX)
+		return -E2BIG;
+	tokener = json_tokener_new();
+	if (!tokener)
+		return -ENOMEM;
+	json_tokener_set_flags(tokener, JSON_TOKENER_STRICT |
+			       JSON_TOKENER_VALIDATE_UTF8);
+	root = json_tokener_parse_ex(tokener, text, text_len + 1);
+	error = json_tokener_get_error(tokener);
+	json_tokener_free(tokener);
+	if (error != json_tokener_success || !root) {
+		fprintf(stderr, "%s: invalid ctlvgen manifest: %s\n", prog,
+			json_tokener_error_desc(error));
+		return -EINVAL;
+	}
+	if (!json_object_is_type(root, json_type_object) ||
+	    json_u64(root, "version", &version) || version != 1) {
+		fprintf(stderr, "%s: unsupported ctlvgen manifest\n", prog);
+		ret = -EINVAL;
+		goto out_root;
+	}
+
+	spec = calloc(1, sizeof(*spec));
+	if (!spec) {
+		ret = -ENOMEM;
+		goto out_root;
+	}
+	ret = chain_check(root, dev);
+	if (!ret)
+		ret = definitions_parse(root, spec);
+	if (!ret)
+		ret = fields_parse(root, spec);
+	if (!ret)
+		ret = ops_parse(root, spec);
+	if (ret) {
+		if (ret == -ENOMSG)
+			fprintf(stderr,
+				"%s: specifications do not match device %s\n",
+				prog, ctlv_dev_name(dev));
+		else
+			fprintf(stderr, "%s: malformed ctlvgen manifest\n",
+				prog);
+		ctlvctl_spec_free(spec);
+		goto out_root;
+	}
+	*specp = spec;
+out_root:
+	json_object_put(root);
+	return ret;
+}
+
+static int read_all(int fd, char **textp)
+{
+	size_t used = 0, size = 4096;
+	char *text;
+
+	text = malloc(size);
+	if (!text)
+		return -ENOMEM;
+	for (;;) {
+		ssize_t n;
+
+		if (used == size - 1) {
+			char *grown;
+
+			size *= 2;
+			grown = realloc(text, size);
+			if (!grown) {
+				free(text);
+				return -ENOMEM;
+			}
+			text = grown;
+		}
+		n = read(fd, text + used, size - used - 1);
+		if (n < 0) {
+			if (errno == EINTR)
+				continue;
+			free(text);
+			return -errno;
+		}
+		if (!n)
+			break;
+		used += n;
+	}
+	text[used] = '\0';
+	*textp = text;
+	return 0;
+}
+
+static void generator_exec(const char *prog, const char *spec_path)
+{
+	const char *override = getenv("CTLVGEN");
+	char executable[PATH_MAX];
+	char candidate[PATH_MAX];
+	char *slash;
+	ssize_t n;
+
+	if (override)
+		execl(override, override, "--spec", spec_path,
+		      "--runtime-json", NULL);
+
+	n = readlink("/proc/self/exe", executable, sizeof(executable) - 1);
+	if (n > 0) {
+		static const char suffix[] = "/../ctlvgen/cli.py";
+		size_t len;
+
+		executable[n] = '\0';
+		slash = strrchr(executable, '/');
+		if (slash) {
+			*slash = '\0';
+			len = strlen(executable);
+			if (len + sizeof(suffix) <= sizeof(candidate)) {
+				memcpy(candidate, executable, len);
+				memcpy(candidate + len, suffix, sizeof(suffix));
+				execl(candidate, candidate, "--spec",
+				      spec_path, "--runtime-json", NULL);
+			}
+		}
+	}
+	execlp("ctlvgen", "ctlvgen", "--spec", spec_path,
+	       "--runtime-json", NULL);
+	dprintf(STDERR_FILENO, "%s: cannot execute ctlvgen: %s\n", prog,
+		strerror(errno));
+	_exit(127);
+}
+
+static int manifest_generate(const char *prog, const char *spec_path,
+			     char **textp)
+{
+	int pipefd[2];
+	int status;
+	pid_t pid;
+	int ret;
+
+	if (pipe2(pipefd, O_CLOEXEC))
+		return -errno;
+	pid = fork();
+	if (pid < 0) {
+		ret = -errno;
+		goto out_pipe;
+	}
+	if (!pid) {
+		close(pipefd[0]);
+		if (pipefd[1] == STDOUT_FILENO) {
+			int flags = fcntl(STDOUT_FILENO, F_GETFD);
+
+			if (flags < 0 ||
+			    fcntl(STDOUT_FILENO, F_SETFD,
+				  flags & ~FD_CLOEXEC) < 0)
+				_exit(127);
+		} else {
+			if (dup2(pipefd[1], STDOUT_FILENO) < 0)
+				_exit(127);
+			close(pipefd[1]);
+		}
+		generator_exec(prog, spec_path);
+	}
+	close(pipefd[1]);
+	ret = read_all(pipefd[0], textp);
+	close(pipefd[0]);
+	while (waitpid(pid, &status, 0) < 0) {
+		if (errno != EINTR) {
+			ret = -errno;
+			goto out_text;
+		}
+	}
+	if (!ret && (!WIFEXITED(status) || WEXITSTATUS(status)))
+		ret = -EINVAL;
+out_text:
+	if (ret) {
+		free(*textp);
+		*textp = NULL;
+	}
+	return ret;
+out_pipe:
+	close(pipefd[0]);
+	close(pipefd[1]);
+	return ret;
+}
+
+static int manifest_read(const char *path, char **textp)
+{
+	int fd, ret;
+
+	fd = open(path, O_RDONLY | O_CLOEXEC);
+	if (fd < 0)
+		return -errno;
+	ret = read_all(fd, textp);
+	close(fd);
+	return ret;
+}
+
+int ctlvctl_spec_load(const char *prog, const char *dir,
+		      const struct ctlv_dev *dev, struct ctlvctl_spec **specp)
+{
+	char path[PATH_MAX];
+	char *text = NULL;
+	int ret;
+
+	if (snprintf(path, sizeof(path), "%s/%s.json", dir,
+		     ctlv_dev_family(dev)) >= (int)sizeof(path))
+		return -ENAMETOOLONG;
+	ret = manifest_read(path, &text);
+	if (ret == -ENOENT) {
+		snprintf(path, sizeof(path), "%s/%s.yaml", dir,
+			 ctlv_dev_family(dev));
+		ret = manifest_generate(prog, path, &text);
+	} else if (ret) {
+		fprintf(stderr, "%s: %s: %s\n", prog, path, strerror(-ret));
+	}
+	if (ret)
+		return ret;
+	ret = manifest_parse(prog, text, dev, specp);
+	free(text);
+	return ret;
+}
+
+#else /* HAVE_JSON_C */
+
+int ctlvctl_spec_load(const char *prog, const char *dir,
+		      const struct ctlv_dev *dev, struct ctlvctl_spec **specp)
+{
+	fprintf(stderr,
+		"%s: specification support was built without json-c\n", prog);
+	return -EOPNOTSUPP;
+}
+
+#endif /* HAVE_JSON_C */
+
+void ctlvctl_spec_free(struct ctlvctl_spec *spec)
+{
+	unsigned int i, j;
+
+	if (!spec)
+		return;
+	for (i = 0; i < spec->definitions_count; i++) {
+		for (j = 0; j < spec->definitions[i].values_count; j++)
+			free(spec->definitions[i].values[j].name);
+		free(spec->definitions[i].values);
+		free(spec->definitions[i].name);
+	}
+	for (i = 0; i < spec->fields_count; i++) {
+		free(spec->fields[i].name);
+		free(spec->fields[i].short_name);
+	}
+	for (i = 0; i < spec->ops_count; i++)
+		free(spec->ops[i].name);
+	free(spec->definitions);
+	free(spec->fields);
+	free(spec->ops);
+	free(spec);
+}
+
+const struct ctlvctl_op_name *
+ctlvctl_spec_op_id(const struct ctlvctl_spec *spec, __u64 id)
+{
+	unsigned int i;
+
+	if (!spec)
+		return NULL;
+	for (i = 0; i < spec->ops_count; i++)
+		if (spec->ops[i].id == id)
+			return &spec->ops[i];
+	return NULL;
+}
+
+const struct ctlvctl_op_name *
+ctlvctl_spec_op_name(const struct ctlvctl_spec *spec, const char *name)
+{
+	unsigned int i;
+
+	if (!spec)
+		return NULL;
+	for (i = 0; i < spec->ops_count; i++)
+		if (!strcmp(spec->ops[i].name, name))
+			return &spec->ops[i];
+	return NULL;
+}
+
+const struct ctlvctl_field_name *
+ctlvctl_spec_field(const struct ctlvctl_spec *spec, __u64 type)
+{
+	unsigned int i;
+
+	if (!spec)
+		return NULL;
+	for (i = 0; i < spec->fields_count; i++)
+		if (spec->fields[i].type == type)
+			return &spec->fields[i];
+	return NULL;
+}
+
+const char *ctlvctl_spec_value_name(const struct ctlvctl_field_name *field,
+				    __u64 value)
+{
+	unsigned int i;
+
+	if (!field || !field->definition)
+		return NULL;
+	for (i = 0; i < field->definition->values_count; i++)
+		if (field->definition->values[i].value == value)
+			return field->definition->values[i].name;
+	return NULL;
+}
+
+int ctlvctl_spec_value(const struct ctlvctl_field_name *field, const char *name,
+		       __u64 *value)
+{
+	unsigned int i;
+
+	if (!field || !field->definition)
+		return -ENOENT;
+	for (i = 0; i < field->definition->values_count; i++)
+		if (!strcmp(field->definition->values[i].name, name)) {
+			*value = field->definition->values[i].value;
+			return 0;
+		}
+	return -ENOENT;
+}
diff --git a/tools/ctlv/ctlvctl/spec.h b/tools/ctlv/ctlvctl/spec.h
new file mode 100644
index 000000000000..0ac6e314232e
--- /dev/null
+++ b/tools/ctlv/ctlvctl/spec.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+#ifndef CTLVCTL_SPEC_H
+#define CTLVCTL_SPEC_H
+
+#include <linux/types.h>
+#include <stdbool.h>
+
+struct ctlv_dev;
+
+struct ctlvctl_value_name {
+	__u64 value;
+	char *name;
+};
+
+struct ctlvctl_definition {
+	char *name;
+	__u32 kind;
+	struct ctlvctl_value_name *values;
+	unsigned int values_count;
+};
+
+struct ctlvctl_field_name {
+	__u64 type;
+	__u32 kind;
+	char *name;
+	char *short_name;
+	const struct ctlvctl_definition *definition;
+};
+
+struct ctlvctl_op_name {
+	__u64 id;
+	__u32 type;
+	__u32 fd_access;
+	__u32 availability;
+	__u64 request_max_len;
+	__u64 action_reply_max_len;
+	__u64 query_reply_min_len;
+	__u64 query_reply_suggested_len;
+	char *name;
+};
+
+struct ctlvctl_spec;
+
+int ctlvctl_spec_load(const char *prog, const char *dir,
+		      const struct ctlv_dev *dev, struct ctlvctl_spec **specp);
+void ctlvctl_spec_free(struct ctlvctl_spec *spec);
+
+const struct ctlvctl_op_name *
+ctlvctl_spec_op_id(const struct ctlvctl_spec *spec, __u64 id);
+const struct ctlvctl_op_name *
+ctlvctl_spec_op_name(const struct ctlvctl_spec *spec, const char *name);
+const struct ctlvctl_field_name *
+ctlvctl_spec_field(const struct ctlvctl_spec *spec, __u64 type);
+
+const char *ctlvctl_spec_value_name(const struct ctlvctl_field_name *field,
+				    __u64 value);
+int ctlvctl_spec_value(const struct ctlvctl_field_name *field, const char *name,
+		       __u64 *value);
+
+#endif /* CTLVCTL_SPEC_H */
diff --git a/tools/ctlv/ctlvgen/cli.py b/tools/ctlv/ctlvgen/cli.py
index 59180f9757e8..5da444984bd5 100755
--- a/tools/ctlv/ctlvgen/cli.py
+++ b/tools/ctlv/ctlvgen/cli.py
@@ -14,7 +14,10 @@ from collections.abc import Callable
 sys.path.append(pathlib.Path(__file__).resolve().parents[1].as_posix())
 
 from ctlvgen.lib import cgen  # noqa: E402
+from ctlvgen.lib import dump  # noqa: E402
+from ctlvgen.lib import gen_doc  # noqa: E402
 from ctlvgen.lib import gen_kernel  # noqa: E402
+from ctlvgen.lib import gen_runtime  # noqa: E402
 from ctlvgen.lib import gen_uapi  # noqa: E402
 from ctlvgen.lib import gen_user  # noqa: E402
 from ctlvgen.lib import semantics  # noqa: E402
@@ -30,6 +33,7 @@ GENERATORS: dict[tuple[str, str], Callable[..., str]] = {
     ('kernel', 'source'): gen_kernel.render_source,
     ('user', 'header'): gen_user.render_header,
     ('user', 'source'): gen_user.render_source,
+    ('doc', 'rst'): gen_doc.render,
 }
 
 
@@ -46,6 +50,12 @@ def main() -> int:
     action = parser.add_mutually_exclusive_group(required=True)
     action.add_argument('--validate', action='store_true',
                         help='validate the specification and exit')
+    action.add_argument('--dump', action='store_true',
+                        help='print the resolved schema in text form')
+    action.add_argument('--runtime-json', action='store_true',
+                        help='print the resolved runtime manifest as JSON')
+    action.add_argument('--signatures', action='store_true',
+                        help='print each op the family declares as a call')
     action.add_argument('--outputs-check', action='store_true',
                         help='check every file in the output manifests and '
                              'every ABI snapshot')
@@ -53,7 +63,7 @@ def main() -> int:
                         help='regenerate every file in the output manifests '
                              'and every ABI snapshot')
     action.add_argument('--mode',
-                        choices=('uapi', 'kernel', 'user'),
+                        choices=('uapi', 'kernel', 'user', 'doc'),
                         help='generate the files of this mode')
     parser.add_argument('--schema-only', action='store_true',
                         help='omit the family API from kernel output')
@@ -62,6 +72,8 @@ def main() -> int:
                        help='generate the header of --mode')
     files.add_argument('--source', action='store_true',
                        help='generate the source of --mode')
+    files.add_argument('--rst', action='store_true',
+                       help='generate the reStructuredText of --mode')
     parser.add_argument('-o', '--output', type=str,
                         help='write to this file instead of standard output')
     parser.add_argument('--cmp-out', action='store_true',
@@ -73,12 +85,12 @@ def main() -> int:
                         help='let --outputs-update break the committed ABI')
     args = parser.parse_args()
 
-    file = next((name for name in ('header', 'source')
+    file = next((name for name in ('header', 'source', 'rst')
                  if getattr(args, name)), None)
     if args.mode and not file:
-        parser.error('--mode needs --header or --source')
+        parser.error('--mode needs --header, --source or --rst')
     if file and not args.mode:
-        parser.error('--header and --source need --mode')
+        parser.error('--header, --source and --rst need --mode')
     if args.mode and (args.mode, file) not in GENERATORS:
         parser.error(f'--mode {args.mode} cannot generate --{file}')
     if args.schema_only and args.mode != 'kernel':
@@ -111,20 +123,43 @@ def main() -> int:
             # The root family has no binding: libctlv is that binding.
             if family.name != spec.CORE_FAMILY_NAME:
                 cgen.user_symbols(family)
+        elif args.dump:
+            sys.stdout.write(dump.render(family))
+        elif args.runtime_json:
+            sys.stdout.write(gen_runtime.render(family))
+        elif args.signatures:
+            sys.stdout.write(gen_doc.signatures(family))
         else:
             assert file is not None
-            _generate(args, file, family)
+            _generate(args, paths, file, family)
     except CtlvError as exc:
         print(f'ctlvgen: {exc}', file=sys.stderr)
         return 1
     return 0
 
 
-def _generate(args: argparse.Namespace, file: str,
+def _descendants(args: argparse.Namespace, paths: spec.Paths,
+                 family: semantics.Family) -> tuple[semantics.Family, ...]:
+    """Every family of the registry that inherits family."""
+    found = []
+    for entry in spec.load_registry(paths).entries:
+        path = paths.spec_dir / f'{entry.name}.yaml'
+        if entry.name == family.name or not path.exists():
+            continue
+        child = semantics.load(spec.Paths(str(path), schema=args.schema,
+                                          registry=args.registry))
+        if family.name in (item.name for item in child.chain[:-1]):
+            found.append(child)
+    return tuple(found)
+
+
+def _generate(args: argparse.Namespace, paths: spec.Paths, file: str,
               family: semantics.Family) -> None:
     render = GENERATORS[(args.mode, file)]
     if args.mode == 'kernel':
         text = render(family, family_api=not args.schema_only)
+    elif args.mode == 'doc':
+        text = render(family, _descendants(args, paths, family))
     else:
         text = render(family)
     if args.output is None:
diff --git a/tools/ctlv/ctlvgen/lib/dump.py b/tools/ctlv/ctlvgen/lib/dump.py
new file mode 100644
index 000000000000..20eca794aa11
--- /dev/null
+++ b/tools/ctlv/ctlvgen/lib/dump.py
@@ -0,0 +1,161 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+"""Deterministic text rendering of an effective family.
+
+A debugging window and a golden-test surface, not an interchange format: every
+generated ID, effective bound and computed length, in declaration order.
+"""
+
+from __future__ import annotations
+
+from . import semantics
+from . import sizes
+from . import spec
+
+INDENT: str = '  '
+
+
+def render(family: semantics.Family) -> str:
+    """Return the dump of one effective family as a string."""
+    lines = []
+    lines.append(f'family: {family.name}')
+    lines.append(f'family-id: {family.family_id}')
+    lines.append('chain: ' + ' -> '.join(item.name for item in family.chain))
+
+    _definitions(lines, family)
+    _records(lines, family)
+    _extensions(lines, family)
+    _ops(lines, family)
+    return '\n'.join(lines) + '\n'
+
+
+def _definitions(lines: list[str], family: semantics.Family) -> None:
+    if not family.definitions:
+        return
+    lines.append('')
+    lines.append('definitions:')
+    for definition in family.definitions.values():
+        extension = definition.extension
+        what = ''
+        if extension is not None:
+            what = f', extension {extension.ext_id} of family ' \
+                   f'{extension.family_id}'
+        lines.append(f'{INDENT}{definition.kind} {definition.name} '
+                     f'(family {definition.family_id}{what})')
+        for name, number in definition.values:
+            if definition.kind == 'enum':
+                lines.append(f'{INDENT * 2}{name} = {number}')
+            else:
+                lines.append(f'{INDENT * 2}{name} = bit {number}')
+
+
+def _records(lines: list[str], family: semantics.Family) -> None:
+    if not family.records:
+        return
+    lines.append('')
+    lines.append('records:')
+    for record in family.records.values():
+        lines.append(f'{INDENT}{record.path} = {record.record_id:#010x} '
+                     f'{record.role} (family {record.family_id})')
+        for member in record.members:
+            field = member.field
+            requirement = '' if member.required else '?'
+            lines.append(f'{INDENT * 2}{field.name}{requirement} = '
+                         f'{_id(field.type)} {_field_detail(field)}')
+
+
+def _field_detail(field: semantics.Field) -> str:
+    decl = field.decl
+    detail = [decl.kind]
+    if decl.kind in ('uint', 'sint'):
+        detail.append(f'[{decl.min}, {decl.max}]')
+        if decl.unit is not None:
+            detail.append(f'unit {decl.unit} scale {decl.scale}')
+    elif decl.kind in ('string', 'binary'):
+        detail.append(f'length [{decl.min_length}, {decl.max_length}]')
+    elif decl.kind in ('enum', 'flags'):
+        assert decl.ref is not None
+        detail.append(decl.ref)
+    elif decl.kind == 'blob':
+        assert decl.blob is not None
+        detail.append(decl.blob.direction)
+        detail.append('backings ' + ','.join(decl.blob.backings))
+        detail.append(f'max-length {decl.blob.max_length}')
+        detail.append(f'alignment {decl.blob.alignment}')
+    elif decl.extension is not None:
+        detail.append(f'extension {decl.extension}')
+    else:
+        detail.append(f'record {field.holds}')
+    detail.append(_occurrences(decl.max_occurrences))
+    return ' '.join(detail)
+
+
+def _extensions(lines: list[str], family: semantics.Family) -> None:
+    if not family.extensions:
+        return
+    lines.append('')
+    lines.append('extensions:')
+    for extension in family.extensions.values():
+        fill = family.fill_of(extension)
+        filled = f', filled by family {fill.owner_family_id}' if fill else ''
+        lines.append(f'{INDENT}{extension.name} = {extension.ext_id} '
+                     f'(family {extension.family_id}{filled})')
+
+
+def _ops(lines: list[str], family: semantics.Family) -> None:
+    if not family.ops:
+        return
+    lines.append('')
+    lines.append('ops:')
+    for op in family.ops:
+        lines.append(f'{INDENT}{op.name} = {_id(op.op_id)} {op.type}')
+        lines.append(f'{INDENT * 2}fd-access: {op.fd_access}')
+        if op.request is not None:
+            _tree(lines, 'request', op.request)
+        if op.reply is None:
+            lines.append(f'{INDENT * 2}reply: none')
+        else:
+            _tree(lines, 'reply', op.reply)
+        _sizes(lines, op.sizes)
+
+
+def _tree(lines: list[str], what: str, root: semantics.Node) -> None:
+    lines.append(f'{INDENT * 2}{what}:')
+    if not root.children():
+        lines.append(f'{INDENT * 3}(empty)')
+        return
+    _children(lines, root, 3)
+
+
+def _children(lines: list[str], node: semantics.Node, depth: int) -> None:
+    for child in node.children():
+        requirement = 'required' if child.required else 'optional'
+        line = (f'{INDENT * depth}{child.child_field.full_name} '
+                f'{_occurrences(child.max_occurrences)} {requirement}')
+        if child.reenters is not None:
+            line += f' -> {child.reenters}'
+        lines.append(line)
+        _children(lines, child, depth + 1)
+
+
+def _sizes(lines: list[str], op_sizes: sizes.OpSizes) -> None:
+    lines.append(f'{INDENT * 2}sizes:')
+    reported = (
+        ('request-max-len', op_sizes.request_max_len),
+        ('action-reply-max-len', op_sizes.action_reply_max_len),
+        ('query-reply-min-len', op_sizes.query_reply_min_len),
+        ('query-reply-suggested-len', op_sizes.query_reply_suggested_len),
+        ('error-info-max-len', op_sizes.error_info_max_len),
+    )
+    for name, value in reported:
+        if value:
+            lines.append(f'{INDENT * 3}{name}: {value}')
+
+
+def _occurrences(max_occurrences: int) -> str:
+    if max_occurrences == spec.UNLIMITED:
+        return 'x*'
+    return f'x{max_occurrences}'
+
+
+def _id(value: int) -> str:
+    return f'0x{value:016x}'
diff --git a/tools/ctlv/ctlvgen/lib/gen_doc.py b/tools/ctlv/ctlvgen/lib/gen_doc.py
new file mode 100644
index 000000000000..7d36d4a7dd9b
--- /dev/null
+++ b/tools/ctlv/ctlvgen/lib/gen_doc.py
@@ -0,0 +1,684 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+"""The reference documentation of one family.
+
+Each op's request and reply as the tree the core admits, with every field's
+number, schema kind, bounds and doc, and what each descendant puts into an
+extension point shown where it lands. An inherited declaration is documented
+by the family that owns it.
+"""
+
+from __future__ import annotations
+
+import textwrap
+from typing import Union
+
+from . import cgen
+from . import semantics
+from . import spec
+
+# Documentation/doc-guide/sphinx.rst asks for lines that fit a terminal, which
+# is why a generated tree is an indented literal block.
+LINE_LIMIT: int = 79
+
+# A literal block's indent, the columns of one tree row inside it, and how far
+# in from its row a doc goes.
+BLOCK_INDENT: int = 4
+NAME_WIDTH: int = 30
+NUMBER_WIDTH: int = 4
+DOC_INDENT: int = 4
+
+TYPES: dict[str, str] = {
+    'action': 'action',
+    'query': 'query',
+}
+
+# A blob's direction as a spec writes it.
+DIRECTIONS: dict[str, str] = {value: key
+                              for key, value in spec.DIRECTIONS.items()}
+
+
+def render(family: semantics.Family,
+           descendants: tuple[semantics.Family, ...] = ()) -> str:
+    """Return the reference page of family as reStructuredText.
+
+    descendants are the families inheriting this one, whose fills appear in
+    its trees.
+    """
+    writer = _Writer()
+    _preamble(writer, family)
+    _title(writer, family)
+    _intro(writer, family)
+    _definitions(writer, family)
+    _records(writer, family, descendants)
+    _extensions(writer, family, descendants)
+    _fills(writer, family, descendants)
+    _ops(writer, family, descendants)
+    _messages(writer, family, descendants)
+    return writer.text()
+
+
+def signatures(family: semantics.Family, width: int = 100) -> str:
+    """Return every op this family declares as one call per line."""
+    lines = []
+    for op in family.local_ops:
+        lines += _signature(family, op, width)
+    return '\n'.join(lines) + '\n' if lines else ''
+
+
+class _Writer:
+    """The lines of one generated page."""
+
+    def __init__(self) -> None:
+        self._lines: list[str] = []
+
+    def line(self, text: str = '') -> None:
+        self._lines.append(text.rstrip())
+
+    def lines(self, *texts: str) -> None:
+        for text in texts:
+            self.line(text)
+
+    def paragraph(self, text: str) -> None:
+        """One paragraph, wrapped, followed by a blank line.
+
+        A hyphenated family name is never broken, so a grep for one finds it.
+        """
+        for line in _wrap(text, LINE_LIMIT):
+            self.line(line)
+        self.line()
+
+    def title(self, text: str) -> None:
+        """The one title of the page, overlined and underlined."""
+        self.line('=' * len(text))
+        self.line(text)
+        self.line('=' * len(text))
+        self.line()
+
+    def heading(self, text: str, char: str) -> None:
+        """One section heading, underlined the width of its title."""
+        self.line(text)
+        self.line(char * len(text))
+        self.line()
+
+    def block(self, *texts: str) -> None:
+        """One literal block, indented, followed by a blank line."""
+        self.line('::')
+        self.line()
+        for text in texts:
+            self.line(f'{" " * BLOCK_INDENT}{text}' if text else '')
+        self.line()
+
+    def field(self, name: str, value: int | str) -> None:
+        self.line(f':{name}: {value}')
+
+    def text(self) -> str:
+        while self._lines and not self._lines[-1]:
+            self._lines.pop()
+        return '\n'.join(self._lines) + '\n'
+
+
+def _wrap(text: str, width: int) -> list[str]:
+    return textwrap.wrap(' '.join(text.split()), width,
+                         break_on_hyphens=False, break_long_words=False)
+
+
+def _preamble(writer: _Writer, family: semantics.Family) -> None:
+    """The comment ctlv-regen.sh recovers the generation parameters from."""
+    writer.lines(
+        f'.. SPDX-License-Identifier: {family.license}',
+        f'.. Generated from {cgen.spec_path(family.path)} by',
+        f'   {cgen.REGEN}. Do not edit.',
+        '.. CTLV-GEN doc rst',
+    )
+    writer.line()
+
+
+def _title(writer: _Writer, family: semantics.Family) -> None:
+    writer.title(family.name)
+
+
+def _intro(writer: _Writer, family: semantics.Family) -> None:
+    writer.field('Family ID', family.family_id)
+    writer.field('Chain', ' -> '.join(item.name for item in family.chain))
+    writer.field('Specification', cgen.spec_path(family.path))
+    writer.line()
+    if family.doc:
+        writer.paragraph(family.doc)
+    if family.parent:
+        writer.paragraph(
+            f'This family inherits ``{family.parent}`` and its page describes '
+            f'what ``{family.name}`` declares itself, together with the '
+            'extension points it fills. An inherited op or field keeps the '
+            'name and the description its own family gives it, so a program '
+            'speaking to a device of this family uses both pages.')
+    else:
+        writer.paragraph(
+            'This is the family every other family inherits: its ops are the '
+            'ones the core answers itself, on every device, whatever '
+            'family registered it.')
+    writer.paragraph(
+        'A tree lists one field per line: its name as the specification '
+        'writes it, its number and its schema kind. A field\'s type is the '
+        'family, the record above it and that number. A field of records: '
+        'is a record of its own, which its line names.')
+
+
+def _definitions(writer: _Writer, family: semantics.Family) -> None:
+    own = family.local_definitions
+    if not own:
+        return
+    writer.heading('Enumerations and flags', '=')
+    for definition in own:
+        writer.heading(definition.name, '-')
+        if definition.doc:
+            writer.paragraph(definition.doc)
+        if definition.is_extension_point:
+            writer.paragraph(
+                'An enum extension point: the family of a device gives the '
+                'values, by declaring an enum of this name. On a device '
+                'whose family gives none, no value is valid.')
+            continue
+        if definition.extension is not None:
+            owner = family.owners[definition.extension.family_id]
+            writer.paragraph(f'The values this family gives the enum '
+                             f'extension point of {owner}.')
+        if definition.kind == 'enum':
+            writer.paragraph(
+                'A payload restricted to these values. An unknown value is '
+                'refused on a request and tolerated on a reply, so a caller '
+                'built against an older specification keeps working.')
+            header = definition.header
+            if header:
+                before = f' before ``{header.end}``' if header.end else ''
+                writer.paragraph(
+                    f'These are the constants of ``enum {header.tag}`` in '
+                    f'``<{header.path}>``{before}, under its names and '
+                    'numbers. A number between two of them passes CTLV, for '
+                    'the family to refuse.')
+            rows = _value_rows(definition, '')
+        else:
+            writer.paragraph(
+                'A payload restricted to these bits. An unknown bit is '
+                'refused on a request and tolerated on a reply.')
+            rows = _value_rows(definition, 'bit ')
+        writer.block(*rows)
+
+
+def _value_rows(definition: semantics.Definition, prefix: str) -> list[str]:
+    """One line per value, its doc below."""
+    rows = []
+    width = LINE_LIMIT - BLOCK_INDENT - DOC_INDENT
+    for (name, number), doc in zip(definition.values, definition.value_docs):
+        rows.append(f'{prefix}{number} = {name}')
+        if doc:
+            rows += [f'{" " * DOC_INDENT}{line}' for line in _wrap(doc, width)]
+    return rows
+
+
+def _records(writer: _Writer, family: semantics.Family,
+             descendants: tuple[semantics.Family, ...]) -> None:
+    """The named records and the fields of records: this family declares."""
+    own = [record for record in family.local_records
+           if record.role in ('named', 'field')]
+    if not own:
+        return
+    writer.heading('Records', '=')
+    writer.paragraph(
+        'What an op places by name. A named record is placed with record or '
+        'spliced with $include; a field of records: is placed with a bare '
+        'record and has one type wherever it is.')
+    for record in own:
+        writer.heading(record.name, '-')
+        if record.doc:
+            writer.paragraph(record.doc)
+        if record.role == 'field':
+            field = record.fields[0]
+            writer.block(f'record {record.record_id:#010x}, field '
+                         f'{field.number}: {_kind_text(family, field)}')
+            continue
+        rows = [f'record {record.record_id:#010x}', '']
+        rows += _record_rows(family, descendants, record, 0, (record.name,))
+        writer.block(*rows)
+
+
+def _record_rows(family: semantics.Family,
+                 descendants: tuple[semantics.Family, ...],
+                 record: semantics.Record, depth: int,
+                 opened: tuple[str, ...] = ()) -> list[str]:
+    """One line per member of a record, in spec order, records expanded.
+
+    opened are the named records above, which a record of one re-enters.
+    """
+    rows = []
+    included = None
+    for member in record.members:
+        field = member.field
+        origin = None
+        if field.record_id != record.record_id and not field.shared:
+            origin = field.record
+        if origin is not None and origin != included:
+            source = family.records[origin]
+            rows.append(f'{"  " * depth}$include {origin}, record '
+                        f'{source.record_id:#010x}')
+        included = origin
+        inner, reenters = None, False
+        if field.decl.kind == 'record' and field.decl.extension is None:
+            assert field.holds is not None
+            inner = family.records[field.holds]
+            reenters = inner.role == 'named' and inner.name in opened
+        name = field.name + _suffix(member.required, field.decl)
+        rows += _row(family, name, field, depth, _doc(family, member),
+                     reenters)
+        if inner is not None and not reenters:
+            below = opened + ((inner.name,) if inner.role == 'named'
+                              else ())
+            rows += _record_rows(family, descendants, inner, depth + 1,
+                                 below)
+        if field.decl.extension is not None:
+            rows += _fill_rows(family, descendants,
+                               family.extensions[field.decl.extension],
+                               depth + 1)
+    return rows
+
+
+def _doc(family: semantics.Family, member: semantics.Member) -> str | None:
+    """A member's doc: where it is placed, else where it is declared."""
+    if member.doc:
+        return member.doc
+    if member.field.decl.doc:
+        return member.field.decl.doc
+    if member.field.shared:
+        return family.records[member.field.record].doc
+    return None
+
+
+def _extensions(writer: _Writer, family: semantics.Family,
+                descendants: tuple[semantics.Family, ...]) -> None:
+    own = family.local_extensions
+    if not own:
+        return
+    writer.heading('Extension points', '=')
+    writer.paragraph(
+        'A place a descendant adds members to, by declaring a record of the '
+        'same name. It is empty on this family\'s own devices; a descendant '
+        'that fills it lengthens every message that reaches it.')
+    rows = []
+    for extension in own:
+        fillers = []
+        for child in descendants:
+            fill = child.fill_of(extension)
+            if fill is not None:
+                fillers.append(child.owners[fill.owner_family_id])
+        filled = ', filled by ' + ', '.join(fillers) if fillers else ''
+        rows.append(f'{extension.name}, ID {extension.ext_id}{filled}')
+    writer.block(*rows)
+
+
+def _fills(writer: _Writer, family: semantics.Family,
+           descendants: tuple[semantics.Family, ...]) -> None:
+    if not family.fills:
+        return
+    writer.heading('Extension points this family fills', '=')
+    writer.paragraph(
+        'Each of these completes an extension point an ancestor declared. '
+        'What it adds appears in every message of every op that reaches that '
+        'point, so an inherited op admits a longer message on a device of '
+        'this family than on a device of the family that declared it.')
+    for fill in family.fills:
+        owner = family.owners.get(fill.family_id, str(fill.family_id))
+        writer.heading(f'{fill.name} of {owner}', '-')
+        if fill.record.doc:
+            writer.paragraph(fill.record.doc)
+        rows = [f'record {fill.record.record_id:#010x}', '']
+        rows += _record_rows(family, descendants, fill.record, 0)
+        writer.block(*rows)
+
+
+def _ops(writer: _Writer, family: semantics.Family,
+         descendants: tuple[semantics.Family, ...]) -> None:
+    own = family.local_ops
+    if not own:
+        return
+    writer.heading('Ops', '=')
+    writer.paragraph(
+        'One section per op this family declares. An action is executed and '
+        'acknowledged, and a query is executed and answered in as many '
+        'fragments as its answer needs. In short:')
+    lines = []
+    for op in own:
+        lines += _signature(family, op, LINE_LIMIT - BLOCK_INDENT)
+    writer.block(*lines)
+    for op in own:
+        _op(writer, family, descendants, op)
+
+
+def _op(writer: _Writer, family: semantics.Family,
+        descendants: tuple[semantics.Family, ...], op: semantics.Op) -> None:
+    writer.heading(op.name, '-')
+    writer.field('Op ID', f'``{_id(op.op_id)}``, op {op.local_id}')
+    writer.field('Type', TYPES[op.type])
+    writer.field('FD access', _fd_access(op.fd_access))
+    writer.field('Availability', _availability(op.availability))
+    writer.line()
+    if op.doc:
+        writer.paragraph(op.doc)
+    _message(writer, family, descendants, 'Request', op.request_record)
+    _message(writer, family, descendants, 'Reply', op.reply_record)
+    _sizes(writer, op)
+
+
+def _availability(availability: str) -> str:
+    if availability == 'dynamic':
+        return 'dynamic, so a device may disable and enable it at any time'
+    return 'fixed, so a device that publishes it always answers it'
+
+
+def _fd_access(fd_access: str) -> str:
+    if fd_access == 'read':
+        return 'read, so an observation or full-control fd may execute it'
+    return 'read-write, so only a full-control fd may execute it'
+
+
+def _message(writer: _Writer, family: semantics.Family,
+             descendants: tuple[semantics.Family, ...], what: str,
+             record: semantics.Record | None) -> None:
+    if record is None:
+        writer.paragraph(f'{what}: none.')
+        return
+    if record.role == 'named':
+        writer.paragraph(f'{what}: record {record.name}, '
+                         f'{record.record_id:#010x}, as Records has it.')
+        return
+    if record.doc:
+        writer.paragraph(record.doc)
+    rows = _record_rows(family, descendants, record, 0)
+    if not rows:
+        writer.paragraph(f'{what}: an empty root, record '
+                         f'{record.record_id:#010x}.')
+        return
+    writer.paragraph(f'{what}, record {record.record_id:#010x}:')
+    writer.block(*rows)
+
+
+def _fill_rows(family: semantics.Family,
+               descendants: tuple[semantics.Family, ...],
+               extension: semantics.Extension, depth: int) -> list[str]:
+    """What each family below puts into one extension point."""
+    rows = []
+    for child in (family, *descendants):
+        fill = child.fill_of(extension)
+        if fill is None or (child is not family and
+                            fill.owner_family_id != child.family_id):
+            continue
+        owner = child.owners[fill.owner_family_id]
+        rows.append(f'{"  " * depth}{owner}: record '
+                    f'{fill.record.record_id:#010x} of family '
+                    f'{fill.owner_family_id}')
+        rows += _record_rows(child, descendants, fill.record, depth + 1)
+    return rows
+
+
+def _row(family: semantics.Family, name: str, field: semantics.Field,
+         depth: int, doc: str | None, reenters: bool = False) -> list[str]:
+    """One field: name, number and schema kind, its doc below."""
+    indent = '  ' * depth
+    label = f'{indent}{name}'
+    number = str(field.number)
+    what = _kind_text(family, field, reenters)
+    if field.shared:
+        what += f', record {field.record_id:#010x}'
+    column = NAME_WIDTH + NUMBER_WIDTH
+    parts = _wrap(what, LINE_LIMIT - BLOCK_INDENT - column) or ['']
+    if len(label) >= NAME_WIDTH:
+        rows = [label, f'{" " * NAME_WIDTH}{number:<{NUMBER_WIDTH}}{parts[0]}']
+    else:
+        rows = [f'{label:<{NAME_WIDTH}}{number:<{NUMBER_WIDTH}}{parts[0]}']
+    rows += [f'{" " * column}{part}' for part in parts[1:]]
+    if doc:
+        doc_indent = indent + ' ' * DOC_INDENT
+        width = LINE_LIMIT - BLOCK_INDENT - len(doc_indent)
+        rows += [f'{doc_indent}{line}' for line in _wrap(doc, width)]
+    return rows
+
+
+def _suffix(required: bool, decl: spec.FieldDecl) -> str:
+    """The [N] and ? a spec writes after a field name."""
+    suffix = ''
+    if decl.count_enum is not None:
+        suffix = f'[{decl.count_enum}]'
+    elif decl.max_occurrences == spec.UNLIMITED:
+        suffix = '[]'
+    elif decl.max_occurrences != 1:
+        suffix = f'[{decl.max_occurrences}]'
+    return suffix + ('' if required else '?')
+
+
+def _kind_text(family: semantics.Family, field: semantics.Field,
+               reenters: bool = False) -> str:
+    """A field's schema kind and bounds, as a spec reads."""
+    decl = field.decl
+    if decl.kind in ('uint', 'sint'):
+        return decl.kind + _bounds(_integer_bounds(decl), _unit(decl))
+    if decl.kind == 'bool':
+        return 'bool'
+    if decl.kind in ('string', 'binary'):
+        return decl.kind + _bounds(_length_bounds(decl), ())
+    if decl.kind == 'enum':
+        assert decl.ref is not None
+        return decl.ref
+    if decl.kind == 'flags':
+        assert decl.ref is not None
+        names = ', '.join(name for name, _ in
+                          family.definitions[decl.ref].values)
+        return f'{decl.ref}: {names}'
+    if decl.kind == 'blob':
+        assert decl.blob is not None
+        return 'blob' + _bounds((), _blob_parts(decl.blob))
+    if decl.extension is not None:
+        return f'extension {decl.extension}'
+    assert field.holds is not None
+    record = family.records[field.holds]
+    what = f'record {record.record_id:#010x}'
+    if record.role == 'named':
+        what = f'record {record.name} {record.record_id:#010x}'
+    if reenters:
+        what += ', which this re-enters'
+    return what
+
+
+def _bounds(range_parts: tuple[str, ...], other_parts: tuple[str, ...]) -> str:
+    parts = list(range_parts) + list(other_parts)
+    return f' {", ".join(parts)}' if parts else ''
+
+
+def _integer_bounds(decl: spec.FieldDecl) -> tuple[str, ...]:
+    low = None if decl.min == _default_min(decl.kind) else decl.min
+    high = None if decl.max == _default_max(decl.kind) else decl.max
+    if low is None and high is None:
+        return ()
+    text = spec.size_text if decl.unit == 'bytes' else spec.number_text
+    low_text = text(low) if low is not None else ''
+    high_text = text(high) if high is not None else ''
+    return (f'{low_text}..{high_text}',)
+
+
+def _default_min(kind: str) -> int:
+    return 0 if kind == 'uint' else spec.S64_MIN
+
+
+def _default_max(kind: str) -> int:
+    return spec.U64_MAX if kind == 'uint' else spec.S64_MAX
+
+
+def _unit(decl: spec.FieldDecl) -> tuple[str, ...]:
+    if decl.unit is None:
+        return ()
+    parts = [decl.unit]
+    if decl.scale:
+        parts.append(f'scale {decl.scale}')
+    return tuple(parts)
+
+
+def _length_bounds(decl: spec.FieldDecl) -> tuple[str]:
+    assert decl.min_length is not None and decl.max_length is not None
+    if decl.min_length == decl.max_length:
+        return (spec.size_text(decl.max_length),)
+    low = spec.size_text(decl.min_length) if decl.min_length else ''
+    return (f'{low}..{spec.size_text(decl.max_length)}',)
+
+
+def _blob_parts(blob: spec.BlobDecl) -> tuple[str, ...]:
+    parts = [DIRECTIONS[blob.direction]]
+    if blob.max_length != spec.U32_MAX:
+        parts.append(f'..{spec.size_text(blob.max_length)}')
+    if blob.alignment != 1:
+        parts.append(f'align {spec.size_text(blob.alignment)}')
+    parts.append(' '.join(blob.backings))
+    return tuple(parts)
+
+
+def _sizes(writer: _Writer, op: semantics.Op) -> None:
+    """What a caller has to bring and what it gets back, in bytes."""
+    reported = (
+        ('a schema-known request of at most {} bytes',
+         op.sizes.request_max_len),
+        ('a reply of at most {} bytes', op.sizes.action_reply_max_len),
+        ('a reply buffer of at least {} bytes',
+         op.sizes.query_reply_min_len),
+        ('{} bytes of reply buffer suggested',
+         op.sizes.query_reply_suggested_len),
+    )
+    rows = [label.format(value) for label, value in reported if value]
+    if not rows:
+        return
+    writer.paragraph('Lengths on a device of this family:')
+    writer.block(*rows)
+
+
+def _messages(writer: _Writer, family: semantics.Family,
+              descendants: tuple[semantics.Family, ...]) -> None:
+    if not family.messages:
+        return
+    writer.heading('Messages no op declares', '=')
+    writer.paragraph(
+        'The core writes these itself, so they belong to no op: a '
+        'caller reads one out of the buffer it offered for a reply.')
+    for message in family.messages:
+        writer.heading(message.name, '-')
+        record = family.records[message.name]
+        writer.block(f'record {message.record_id:#010x}', '',
+                     *_record_rows(family, descendants, record, 0,
+                                   (record.name,)))
+        writer.paragraph(f'At most {message.max_len} bytes, bounded by '
+                         f'{message.limit}.')
+
+
+def _signature(family: semantics.Family, op: semantics.Op,
+               width: int) -> list[str]:
+    """One op as a call: what it takes, and what it answers."""
+    request = _members(family, op.request_record) if op.request_record \
+        else []
+    call = (f'{op.name}(', request, ')')
+    if op.reply_record is None:
+        return _layout((call,), width)
+    return _layout((call, ' -> ', _shape(family, op.reply_record)), width)
+
+
+_Piece = Union[str, tuple[str, list['_Piece'], str]]
+
+
+def _shape(family: semantics.Family, record: semantics.Record) -> _Piece:
+    """A message root: a named record by name, else its members."""
+    if record.role == 'named':
+        return record.name
+    members = _members(family, record)
+    return ('{ ', members, ' }') if members else '{}'
+
+
+def _layout(pieces: tuple[_Piece, ...], width: int) -> list[str]:
+    """One signature, wrapped inside its braces where it is too long.
+
+    A piece is text or a group, an opener, its members and a closer. A member
+    that does not fit goes on a line of its own, below the first one; a reply
+    that does not fit goes on an indented line.
+    """
+    lines = ['']
+    for piece in pieces:
+        if piece == ' -> ':
+            lines[-1] += piece
+            continue
+        if lines[-1].endswith(' -> ') and \
+                len(lines[-1]) + len(_flat(piece)) > width:
+            lines[-1] = lines[-1].rstrip()
+            lines.append('    ')
+        _place(piece, lines, width)
+    return lines
+
+
+def _place(item: _Piece, lines: list[str], width: int) -> None:
+    """Append item to lines, wrapping inside it where it does not fit."""
+    flat = _flat(item)
+    if isinstance(item, str) or len(lines[-1]) + len(flat) <= width:
+        lines[-1] += flat
+        return
+    opener, members, closer = item
+    lines[-1] += opener
+    inner = len(lines[-1])
+    for index, member in enumerate(members):
+        tail = closer if index == len(members) - 1 else ','
+        if index:
+            if len(lines[-1]) + 1 + len(_flat(member)) + len(tail) <= width:
+                lines[-1] += ' '
+            else:
+                lines.append(' ' * inner)
+        _place(member, lines, width - len(tail))
+        lines[-1] += tail
+
+
+def _flat(item: _Piece) -> str:
+    if isinstance(item, str):
+        return item
+    opener, members, closer = item
+    return opener + ', '.join(_flat(member) for member in members) + closer
+
+
+def _members(family: semantics.Family,
+             record: semantics.Record) -> list[_Piece]:
+    """Each member of one record, a record written out in place."""
+    parts: list[_Piece] = []
+    included = None
+    for member in record.members:
+        field = member.field
+        origin = None
+        if field.record_id != record.record_id and not field.shared:
+            origin = field.record
+        if origin is not None:
+            if origin != included:
+                parts.append(origin)
+            included = origin
+            continue
+        included = None
+        name = field.name + _suffix(member.required, field.decl)
+        parts.append(_member(family, field, name))
+    return parts
+
+
+def _member(family: semantics.Family, field: semantics.Field,
+            name: str) -> _Piece:
+    decl = field.decl
+    if decl.kind == 'blob':
+        assert decl.blob is not None
+        return f'{name}: {DIRECTIONS[decl.blob.direction]} blob'
+    if decl.kind != 'record':
+        return name
+    if decl.extension is not None:
+        return f'{name}: {decl.extension}'
+    assert field.holds is not None
+    record = family.records[field.holds]
+    if record.role == 'named':
+        return f'{name}: {record.name}'
+    return (f'{name}: {{ ', _members(family, record), ' }')
+
+
+def _id(value: int) -> str:
+    return f'0x{value:016x}'
diff --git a/tools/ctlv/ctlvgen/lib/gen_runtime.py b/tools/ctlv/ctlvgen/lib/gen_runtime.py
new file mode 100644
index 000000000000..bfb65d7d7b54
--- /dev/null
+++ b/tools/ctlv/ctlvgen/lib/gen_runtime.py
@@ -0,0 +1,66 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+"""Resolved names and values consumed by specification-aware tools."""
+
+from __future__ import annotations
+
+import json
+from typing import Any
+
+from . import semantics
+
+
+def _definition(item: semantics.Definition) -> dict[str, Any]:
+    values = []
+    for name, number in item.values:
+        value = 1 << number if item.kind == 'flags' else number
+        values.append({'name': name, 'value': value})
+    return {
+        'name': item.name,
+        'kind': item.kind,
+        'values': values,
+    }
+
+
+def _field(item: semantics.Field) -> dict[str, str]:
+    out = {
+        'name': item.full_name,
+        'short': item.name,
+        'type': f'0x{item.type:016x}',
+        'kind': item.decl.kind,
+    }
+    if item.decl.kind in ('enum', 'flags'):
+        assert item.decl.ref is not None
+        out['definition'] = item.decl.ref
+    return out
+
+
+def _op(item: semantics.Op) -> dict[str, Any]:
+    return {
+        'name': item.name,
+        'id': f'0x{item.op_id:016x}',
+        'type': item.type,
+        'availability': item.availability,
+        'request-max-len': item.sizes.request_max_len,
+        'action-reply-max-len': item.sizes.action_reply_max_len,
+        'query-reply-min-len': item.sizes.query_reply_min_len,
+        'query-reply-suggested-len':
+            item.sizes.query_reply_suggested_len,
+        'error-info-max-len': item.sizes.error_info_max_len,
+        'fd-access': item.fd_access,
+    }
+
+
+def render(family: semantics.Family) -> str:
+    """Return a versioned manifest for one effective family."""
+    chain = [{'name': name, 'id': family_id}
+             for family_id, name in family.owners.items()]
+    data = {
+        'version': 1,
+        'family': family.name,
+        'chain': chain,
+        'definitions': [_definition(item)
+                        for item in family.definitions.values()],
+        'fields': [_field(item) for item in family.fields.values()],
+        'ops': [_op(item) for item in family.ops],
+    }
+    return json.dumps(data, separators=(',', ':')) + '\n'
-- 
2.56.0

