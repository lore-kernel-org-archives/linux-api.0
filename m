Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585385;
	b=dRcZNqrGYlXA0rYLXnXDsIhaDSmyOIvOuCsn8WGF3MplruT3sMR+S1wdo1aMrDPT5dgM
	 U0AwzppWMTcrSr9U3XVfxpf2VjhNfQ9LZcdO9vKCfOIUWxow0K5T2gwCf3xyZTjGRFxBU
	 encJrSLS4BMBnXtnItbyqB8dtH37KsXhC2GqgR3DvEHOTltNANf4l1t7Es/dWH2txLEmG
	 XiSVNxcS+J5P+Qa3M+QauK27FRofXu4VRwZTRf0pzq8Z0wp19v5lXHqzvzIsAk9UGnnsm
	 xsJ/DZhmkQbFZCixNLYKRdrIuWLwi3C0Dxka49DY5rxBtCVoPckL2RTkwEKhtAZyi7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585385;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ViWUsNtArpQaeI/uRHSB0U3BV7ZktxAAxWhCe8LOG40=;
	b=YfCNpWyQel3Vp6J7PFRRTsc9V0IcZsXRz8JBXpNOx2Rju84zFvXjnADGsU1xmlmTlRpo
	 ZXPaPzx9GLEgI6h/5UUrq3GpeDLQ7e1QyyPQ0OpqPylDnSXRdkXUmZxQycLlQctGP/HdH
	 70K6SJleRQimPSr6YCn78c6Pym8ZHqBMbYIceizYV8ka8qJ08SygFkA+Epb/xxwEEKjq4
	 rA3g5W58sGKa+f9YLtkdZzp7etARdfuF6+JX/BGdRxhDa8Hdq1uOk1Js2xd7a9ycWc0Np
	 Kev2Q+2KPOSQz/v3Yi2/zOHRh3v1Ptq89zw9TuK9EI8p9IYYeIE6qZL4Ltb/DR5n1vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=y0D5upDx;
	arc=none smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305F560A2610
	for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 15:56:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 305F560A2610
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=y0D5upDx
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c247f6687dcso284479866b.2
        for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 07:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1794585382; x=1795190182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ViWUsNtArpQaeI/uRHSB0U3BV7ZktxAAxWhCe8LOG40=;
        b=y0D5upDxTMRwg4B1+c1pNLwC2rHjWqLW+EmRkAw6iET26cmaAjyThTHYbzNdM6mxYE
         hHHM8SCESNu2ITa2cgzdjt2uIWMKbQTL2E369xytuiy5NfO+fF2jeg5SaNLtHg+DZcw7
         wFNHTaqMgFkG56p6+mDgbum9IlYw1ztKoc481mg32wYm6+IpciJnHus/MFwtvGjKpVPP
         +1uVmE+L1WsuV9WxWv9+NXtUHUpARHMp6WGhzNVt3xR3I3oUYlWKVQD7mPTooKs0FDsk
         iuqMmHTEjsqKCB5fX+a9gCnuca9768Hbyn1IkMFoUstWDikhQSehBFRdsONFNkbmFyJY
         RF4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794585382; x=1795190182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ViWUsNtArpQaeI/uRHSB0U3BV7ZktxAAxWhCe8LOG40=;
        b=Ohpzki8Pje+SpfaJEjuAxar73zutw2Z/T+eeRw8DS06pFSFL+zcWJA8pL3N7n3FMsu
         AVgAQtlr+2LBVZ9284pFYsxEOLFy4ld51KCAZHKl2sc3UVA4Qd6nxNy/cyyJl53E/X58
         RKH4Y3CNUnAwbmOKZycOrJyFLTTHXG6Ew+f/OjV6Mv5aWcX0JPFhUDk6MfdaYlaxXTbY
         4Rh70RsyjfJndCsSJtfbhKshkyAOkxaO5CXYC4q2WdL49xnLF/lWrjdCleZoqQDytBHQ
         Bccx915SSFPcHDTN73DMY/XsMldA0YIglqTASC4eg/mGaSyxArRGcyqDbgcPjKeG5nyV
         mbsA==
X-Forwarded-Encrypted: i=1; AL+hErEXMwd7aALOBX4kA3BRCmWXkk6wNeUo3H13sP68A+UWJGzGm1p5taGFVIv3x2mVR7qcKFKO5Uo/6DY=@vger.kernel.org
X-Gm-Message-State: APuU4Z+WkUuyHop9Sp0K1VgqK422WfrmwPZeMBmwBgrYvw4jPjGUYZsd
	LWjVWJmrHj9WWM4YrwnDG3lF/sxEJcJBIzrrFga17cz10xZJXd2NNRzbMGg6tp4s+bA=
X-Gm-Gg: AYBFou0a2qDTdlRvgE07bDphx/7FWTcZKSiJCUCdipRumfNk0IT9pH1DosRQU7913gN
	PzAgKdTstNXSOa7jeoFpfPrbdIacw5wHrPt4l4XnkjB2IeNOi7WnWSmbEzNxcI4LR3pjrv5QJMq
	DGI5UkQbpXrrwRW+l+LI+o+0YtBt7d0KiqsZouEvARd5WRotD8lLftgzdz/5YlgX7oZ4fZnya9v
	iR5440+R9yEkcZATnwlygTlOMZGIHWVNNj2lcXI79b9CsV83ChLDBwckxdXsGm8diX9dbMJijnc
	+woLqhvP5rCr/zK5w9/3KgB/sJVrjU0wBRXJmY4bKYLy3jjowrUEh3VuHHm55hBNWz5h8VcCIG/
	XLKFdCORvBPQ6N3FqJWgpQHVwuPAQCJIwjHGfySr0jqJLKHILOBSBJwFRzbl+QRCSGqpVAx/SUE
	HHD797vEJsehmIRFxdy8ACHLAdmCU6CKXfp7a1Vpfkqnw/blDrKhmhBneHua8DNw9mTr2Bv85ii
	kzy2E8a/x0BQ9IMjDGr/643D7Wr/SRvfLUZjBf2qtO/2atd0k+iDS12Y2d6hY7OuK04/Mtm/tac
	MiSv2ImiV3DYFDv2RkMFDS2sgBK4EmirM7R0n/hYO8Zi7JwPBS9vNGKRhFoh1Q==
X-Received: by 2002:a17:907:3f91:b0:c42:102f:15d7 with SMTP id a640c23a62f3a-c5096398ac9mr244692866b.10.1794585379767;
        Fri, 13 Nov 2026 07:56:19 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b3f8d3sm115575566b.33.2026.11.13.07.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 07:56:19 -0800 (PST)
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
Subject: [PATCH RFC v2 14/15] tools/ctlv: Add the userspace library
Date: Fri, 13 Nov 2026 16:55:13 +0100
Message-ID: <20261113155515.2510194-15-jiri@resnulli.us>
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

Provide family-independent userspace transport, message handling,
discovery, schemas and blob descriptors. Generated bindings build on
this API.

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ctlv/generated-files-schema.yaml          |   4 +
 Documentation/ctlv/generated-files.yaml       |   1 +
 Documentation/driver-api/ctlv.rst             |   2 +-
 Documentation/userspace-api/ctlv.rst          |  17 +
 tools/ctlv/Makefile                           |   8 +-
 tools/ctlv/ctlvgen/cli.py                     |   8 +-
 tools/ctlv/ctlvgen/lib/gen_user.py            | 808 ++++++++++++++++++
 tools/ctlv/ctlvgen/lib/outputs.py             |  12 +-
 tools/ctlv/libctlv/Makefile                   |  41 +
 tools/ctlv/libctlv/ctlv.h                     | 413 +++++++++
 tools/ctlv/libctlv/ctlv_user_gen.c            | 551 ++++++++++++
 tools/ctlv/libctlv/device.c                   | 412 +++++++++
 tools/ctlv/libctlv/internal.h                 | 161 ++++
 tools/ctlv/libctlv/introspection.c            | 238 ++++++
 tools/ctlv/libctlv/message.c                  | 518 +++++++++++
 tools/ctlv/libctlv/schema.c                   | 742 ++++++++++++++++
 tools/ctlv/libctlv/spec.c                     | 186 ++++
 tools/ctlv/libctlv/transport.c                | 572 +++++++++++++
 18 files changed, 4689 insertions(+), 5 deletions(-)
 create mode 100644 tools/ctlv/ctlvgen/lib/gen_user.py
 create mode 100644 tools/ctlv/libctlv/Makefile
 create mode 100644 tools/ctlv/libctlv/ctlv.h
 create mode 100644 tools/ctlv/libctlv/ctlv_user_gen.c
 create mode 100644 tools/ctlv/libctlv/device.c
 create mode 100644 tools/ctlv/libctlv/internal.h
 create mode 100644 tools/ctlv/libctlv/introspection.c
 create mode 100644 tools/ctlv/libctlv/message.c
 create mode 100644 tools/ctlv/libctlv/schema.c
 create mode 100644 tools/ctlv/libctlv/spec.c
 create mode 100644 tools/ctlv/libctlv/transport.c

diff --git a/Documentation/ctlv/generated-files-schema.yaml b/Documentation/ctlv/generated-files-schema.yaml
index d3529ce6e8e7..d5f2d3763c48 100644
--- a/Documentation/ctlv/generated-files-schema.yaml
+++ b/Documentation/ctlv/generated-files-schema.yaml
@@ -20,6 +20,10 @@ $defs:
         $ref: '#/$defs/path'
       kernel-source:
         $ref: '#/$defs/path'
+      user-header:
+        $ref: '#/$defs/path'
+      user-source:
+        $ref: '#/$defs/path'
 
   registry:
     type: object
diff --git a/Documentation/ctlv/generated-files.yaml b/Documentation/ctlv/generated-files.yaml
index 5488ddf40e17..d4766b176ceb 100644
--- a/Documentation/ctlv/generated-files.yaml
+++ b/Documentation/ctlv/generated-files.yaml
@@ -15,3 +15,4 @@ families:
       uapi-header: include/uapi/ctlv/ctlv_gen.h
       kernel-header: include/linux/ctlv_gen.h
       kernel-source: lib/ctlv/ctlv_gen.c
+      user-source: tools/ctlv/libctlv/ctlv_user_gen.c
diff --git a/Documentation/driver-api/ctlv.rst b/Documentation/driver-api/ctlv.rst
index 34d20c14a9bf..f6a4f9632e3a 100644
--- a/Documentation/driver-api/ctlv.rst
+++ b/Documentation/driver-api/ctlv.rst
@@ -312,7 +312,7 @@ driver selects its optional operations and their initial dynamic state, see
 Hooks and availability. ``ctlv_publish()`` makes operations live, and only then
 may the node be added, as a program may open it as soon as it appears.
 ``ctlv_device_add()`` adds the node, whose uevent names the family; that is how
-udev finds the device. Destruction is the reverse:
+libctlv and udev find the device. Destruction is the reverse:
 
 .. code-block:: c
 
diff --git a/Documentation/userspace-api/ctlv.rst b/Documentation/userspace-api/ctlv.rst
index f1f775071a78..8a8ade33b490 100644
--- a/Documentation/userspace-api/ctlv.rst
+++ b/Documentation/userspace-api/ctlv.rst
@@ -118,6 +118,21 @@ The op ID and the types come from the family's generated UAPI header.
 Before the family sees the request, the kernel checks it against the
 specification: ``index`` must be at most 4095 and ``label`` at most 63 bytes.
 
+``libctlv`` and the generated bindings build and send the same message:
+
+.. code-block:: c
+
+    struct ctlv_error error;
+    struct ctlv_msg *req;
+    struct ctlv_dev *dev;
+
+    /* Error checks left out. */
+    ctlv_open("ctlv-example", 0, O_RDWR, &dev);
+    ctlv_example_item_set_request_new(&req);
+    ctlv_example_item_set_index_put(req, 3);
+    ctlv_example_item_set_label_put(req, "ab");
+    ctlv_example_item_set(dev, req, &error);
+
 The sections below define each piece: the device, the message format, the
 ioctl, queries, blobs and introspection, and then the rules of compatibility.
 
@@ -410,6 +425,8 @@ defined flags. The root cannot carry the flag, and replies never do.
 
 So the kernel acts on what it knows and ignores the rest. A caller that needs
 to know which of its fields will be acted on asks ``op-schema-get`` first.
+``libctlv`` sets the flag with ``ctlv_msg_ignore_if_unknown()`` on the TLV
+written last.
 
 Executing an operation
 ======================
diff --git a/tools/ctlv/Makefile b/tools/ctlv/Makefile
index bdec011595aa..881fae9127c7 100644
--- a/tools/ctlv/Makefile
+++ b/tools/ctlv/Makefile
@@ -30,10 +30,16 @@ lint:
 	python3 -m pyflakes $(PYSRC)
 	python3 -m mypy $(PYSRC)
 
+# The C half of this directory: the userspace library, which is not generated
+# and not Python, so it is its own target rather than part of the checks above.
+programs:
+	$(MAKE) -C libctlv
+
 clean:
 	rm -rf ctlvgen/__pycache__
 	rm -rf ctlvgen/lib/__pycache__
 	rm -rf ctlvgen.egg-info
 	rm -rf build
+	$(MAKE) -C libctlv clean
 
-.PHONY: all regen lint clean
+.PHONY: all regen lint programs clean
diff --git a/tools/ctlv/ctlvgen/cli.py b/tools/ctlv/ctlvgen/cli.py
index 78e09cfd620e..59180f9757e8 100755
--- a/tools/ctlv/ctlvgen/cli.py
+++ b/tools/ctlv/ctlvgen/cli.py
@@ -16,6 +16,7 @@ sys.path.append(pathlib.Path(__file__).resolve().parents[1].as_posix())
 from ctlvgen.lib import cgen  # noqa: E402
 from ctlvgen.lib import gen_kernel  # noqa: E402
 from ctlvgen.lib import gen_uapi  # noqa: E402
+from ctlvgen.lib import gen_user  # noqa: E402
 from ctlvgen.lib import semantics  # noqa: E402
 from ctlvgen.lib import spec  # noqa: E402
 from ctlvgen.lib import tree  # noqa: E402
@@ -27,6 +28,8 @@ GENERATORS: dict[tuple[str, str], Callable[..., str]] = {
     ('uapi', 'header'): gen_uapi.render,
     ('kernel', 'header'): gen_kernel.render_header,
     ('kernel', 'source'): gen_kernel.render_source,
+    ('user', 'header'): gen_user.render_header,
+    ('user', 'source'): gen_user.render_source,
 }
 
 
@@ -50,7 +53,7 @@ def main() -> int:
                         help='regenerate every file in the output manifests '
                              'and every ABI snapshot')
     action.add_argument('--mode',
-                        choices=('uapi', 'kernel'),
+                        choices=('uapi', 'kernel', 'user'),
                         help='generate the files of this mode')
     parser.add_argument('--schema-only', action='store_true',
                         help='omit the family API from kernel output')
@@ -105,6 +108,9 @@ def main() -> int:
         family = semantics.load(paths)
         if args.validate:
             cgen.symbols(family)
+            # The root family has no binding: libctlv is that binding.
+            if family.name != spec.CORE_FAMILY_NAME:
+                cgen.user_symbols(family)
         else:
             assert file is not None
             _generate(args, file, family)
diff --git a/tools/ctlv/ctlvgen/lib/gen_user.py b/tools/ctlv/ctlvgen/lib/gen_user.py
new file mode 100644
index 000000000000..060a142ba813
--- /dev/null
+++ b/tools/ctlv/ctlvgen/lib/gen_user.py
@@ -0,0 +1,808 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+"""The userspace binding of one family.
+
+The header is names, and a child's includes its parent's. The source is the
+specification as data: one struct ctlv_node_schema tree per op message, in the
+shape op-schema-get reports, so a device can be compared with it.
+"""
+
+from __future__ import annotations
+
+import dataclasses
+
+from . import cgen
+from . import semantics
+from . import sizes
+from . import spec
+from .errors import CtlvError
+
+# What every wrapper starts and ends with. A caller wanting only the errno
+# passes NULL for the error.
+DEV_PARAM: str = 'struct ctlv_dev *dev'
+ERROR_PARAM: str = 'struct ctlv_error *error'
+
+# What a request is built in, and what an answer arrives in.
+REQUEST_PARAM: str = 'struct ctlv_msg *request'
+REPLY_PARAM: str = 'struct ctlv_reply **reply'
+
+# The record a reader reads from, and the one TLV it found there.
+RECORD_PARAM: str = 'const struct ctlv_hdr *record'
+FOUND: str = 'hdr'
+
+# What a getter of each schema kind hands back, and the libctlv reader that
+# answers it. An enum and a flags payload are read as the integer they are.
+READERS: dict[str, tuple[tuple[str, ...], str, tuple[str, ...]]] = {
+    'uint': (('__u64 *value',), 'ctlv_get_u64', ()),
+    'sint': (('__s64 *value',), 'ctlv_get_s64', ()),
+    'bool': (('bool *value',), 'ctlv_get_bool', ()),
+    'string': (('const char **value',), 'ctlv_get_str', ()),
+    'binary': (('const void **value', '__u32 *len'), 'ctlv_get_bin',
+               ('value', 'len')),
+    'enum': (('__u64 *value', 'bool *known'), 'ctlv_get_enum',
+             ('value', 'known')),
+    'flags': (('__u64 *value', '__u64 *unknown'), 'ctlv_get_flags',
+              ('value', 'unknown')),
+}
+
+# What a putter of each schema kind takes, and the libctlv append it wraps.
+WRITERS: dict[str, tuple[tuple[str, ...], str]] = {
+    'uint': (('__u64 value',), 'ctlv_put_u64'),
+    'sint': (('__s64 value',), 'ctlv_put_s64'),
+    'bool': (('bool value',), 'ctlv_put_bool'),
+    'string': (('const char *value',), 'ctlv_put_str'),
+    'binary': (('const void *value', '__u32 len'), 'ctlv_put_bin'),
+    'enum': (('__u64 value',), 'ctlv_put_u64'),
+    'flags': (('__u64 value',), 'ctlv_put_u64'),
+}
+
+# Which schema member each length of an op fills, and its name in the header.
+LENGTHS: tuple[tuple[str, str], ...] = tuple(cgen.USER_LENGTHS.items())
+
+# The lengths an op table entry holds, by sizes.OpSizes member.
+TABLE_LENGTHS: tuple[str, ...] = tuple(
+    field.name for field in dataclasses.fields(sizes.OpSizes))
+
+# Bits of struct ctlv_node_schema's present mask, by the member they cover.
+PRESENT: dict[str, str] = {
+    'min': 'CTLV_NODE_SCHEMA_HAS_MIN',
+    'max': 'CTLV_NODE_SCHEMA_HAS_MAX',
+    'min_length': 'CTLV_NODE_SCHEMA_HAS_MIN_LENGTH',
+    'max_length': 'CTLV_NODE_SCHEMA_HAS_MAX_LENGTH',
+    'flags_mask': 'CTLV_NODE_SCHEMA_HAS_FLAGS_MASK',
+    'unit': 'CTLV_NODE_SCHEMA_HAS_UNIT',
+    'scale': 'CTLV_NODE_SCHEMA_HAS_SCALE',
+    'blob': 'CTLV_NODE_SCHEMA_HAS_BLOB',
+    'reenters': 'CTLV_NODE_SCHEMA_HAS_REENTERS',
+}
+
+# What a blob node contributes, in the order the core reports it, and the
+# root family's enum naming the backings it allows.
+BLOB_MEMBERS: tuple[str, ...] = ('blob_direction', 'blob_backings',
+                                 'blob_max_length', 'blob_alignment')
+BLOB_TYPES: str = 'blob-type'
+
+# The extremes of an unbounded integer bound, stored as the unsigned pattern of
+# the value. The most negative signed one has no literal.
+EXTREMES: dict[tuple[str, int], str] = {
+    ('uint', spec.U64_MAX): 'UINT64_MAX',
+    ('sint', spec.S64_MIN): '(__u64)INT64_MIN',
+    ('sint', spec.S64_MAX): 'INT64_MAX',
+}
+
+OP_TYPES: dict[str, str] = {
+    op_type: cgen.macro(spec.CORE_FAMILY_NAME, 'op-type', op_type)
+    for op_type in ('action', 'query')
+}
+
+FD_ACCESSES: dict[str, str] = {
+    access: cgen.macro(spec.CORE_FAMILY_NAME, 'op-fd-access', access)
+    for access in spec.FD_ACCESSES
+}
+
+AVAILABILITIES: dict[str, str] = {
+    availability: cgen.macro(spec.CORE_FAMILY_NAME, 'op-availability',
+                             availability)
+    for availability in spec.AVAILABILITIES
+}
+
+
+def _reject_root(family: semantics.Family) -> None:
+    """The root family's userspace API is provided by libctlv."""
+    if family.name == spec.CORE_FAMILY_NAME:
+        raise CtlvError(f'{family.path}: family {family.name}',
+                        'the root family has no generated userspace binding, '
+                        'because libctlv implements its ops directly as the '
+                        'bootstrap every caller starts from')
+
+
+def render_header(family: semantics.Family) -> str:
+    """Return the userspace binding header of family as text."""
+    _reject_root(family)
+    names = cgen.Names(family)
+    cgen.symbols(family)
+    cgen.user_symbols(family)
+    guard = names.user_guard()
+
+    writer = cgen.preamble(family, 'user', 'header')
+    writer.comment(f'Userspace binding of the {family.name} CTLV family.')
+    writer.line()
+    writer.open_guard(guard)
+    writer.includes(*_includes(family, names))
+
+    writer.comment('What this family\'s specification says, for holding a '
+                   'device against it.')
+    writer.declaration('extern const struct ctlv_family_spec',
+                       f'{names.user_spec()};')
+    _ops(writer, names, family)
+    _writers(writer, names, family)
+    _readers(writer, names, family)
+    writer.line()
+    writer.close_guard(guard)
+    return writer.text()
+
+
+def _includes(family: semantics.Family, names: cgen.Names) -> tuple[str, ...]:
+    """libctlv, this family's constants, and the parent's binding."""
+    headers = ['<ctlv.h>', '', names.uapi_header()]
+    if family.parent != spec.CORE_FAMILY_NAME:
+        headers += ['', cgen.Names(family.chain[-2]).user_header()]
+    return tuple(headers)
+
+
+def _ops(writer: cgen.Writer, names: cgen.Names,
+         family: semantics.Family) -> None:
+    """One call per action and query this family declares.
+
+    A wrapper needing a reply buffer asks the device for the length.
+    """
+    ops = family.local_ops
+    if not ops:
+        return
+    writer.line()
+    writer.comment('Executing an op. A query is reassembled into the one '
+                   'reply it fills.')
+    for op in ops:
+        writer.line()
+        if op.request is not None:
+            _lengths(writer, names, op)
+            _request_new(writer, names, op)
+            writer.line()
+        _wrapper(writer, names, op)
+
+
+def _lengths(writer: cgen.Writer, names: cgen.Names, op: semantics.Op) -> None:
+    """The longest request of one op, as this specification computed."""
+    for field, what in LENGTHS:
+        value = getattr(op.sizes, field)
+        if value:
+            writer.define(names.user_op_len(op, what), str(value))
+    writer.line()
+
+
+def _request_new(writer: cgen.Writer, names: cgen.Names,
+                 op: semantics.Op) -> None:
+    """A request buffer this op's longest request fits in.
+
+    Only the size to start at: past it the message grows to what the transport
+    allows, a descendant's device taking more.
+    """
+    writer.signature('static inline int',
+                     names.user_op_helper(op, 'request_new'),
+                     ('struct ctlv_msg **request',), ')')
+    writer.line('{')
+    writer.declaration('\tconst __u32 len =',
+                       f'{names.user_op_len(op, "request-max-len")};')
+    writer.line()
+    writer.line('\treturn ctlv_msg_new(len, request);')
+    writer.line('}')
+
+
+def _wrapper(writer: cgen.Writer, names: cgen.Names, op: semantics.Op) -> None:
+    """The one call that executes one op."""
+    params = [DEV_PARAM]
+    if op.request is not None:
+        params.append(REQUEST_PARAM)
+    if op.reply is not None:
+        params.append(REPLY_PARAM)
+    params.append(ERROR_PARAM)
+    writer.signature('static inline int', names.user_op(op), tuple(params),
+                     ')')
+    writer.line('{')
+    request = 'request' if op.request is not None else 'NULL'
+    reply = 'reply' if op.reply is not None else 'NULL'
+    call = 'ctlv_query' if op.type == 'query' else 'ctlv_action'
+    arguments = ('dev', names.op_id(op), request, reply, 'error')
+    writer.parenthesized(f'\treturn {call}(', arguments, ');')
+    writer.line('}')
+
+
+def _writers(writer: cgen.Writer, names: cgen.Names,
+             family: semantics.Family) -> None:
+    """What an application puts into a request, one putter per field.
+
+    Every field has one, so a test can put a field where it does not belong.
+    """
+    fields = family.local_fields
+    if not fields:
+        return
+    writer.line()
+    writer.comment('Building a request. ctlv_msg_err() reports the first '
+                   'failure.')
+    for field in fields:
+        writer.line()
+        writer.doc(field.decl.doc)
+        if field.decl.kind == 'blob':
+            _blob_putters(writer, names, field)
+        elif field.decl.kind == 'record':
+            _record_opener(writer, names, field)
+        else:
+            _putter(writer, names, field)
+
+
+def _record_opener(writer: cgen.Writer, names: cgen.Names,
+                   field: semantics.Field) -> None:
+    writer.signature('static inline int', names.field_helper(field, 'start'),
+                     ('struct ctlv_msg *msg',), ')')
+    writer.line('{')
+    writer.parenthesized('\treturn ctlv_record_start(',
+                         ('msg', names.field(field)), ');')
+    writer.line('}')
+
+
+def _putter(writer: cgen.Writer, names: cgen.Names,
+            field: semantics.Field) -> None:
+    params, put = WRITERS[field.decl.kind]
+    values = tuple(param.split()[-1].lstrip('*') for param in params)
+    writer.signature('static inline int', names.field_helper(field, 'put'),
+                     ('struct ctlv_msg *msg', *params), ')')
+    writer.line('{')
+    writer.parenthesized(f'\treturn {put}(',
+                         ('msg', names.field(field), *values), ');')
+    writer.line('}')
+
+
+def _blob_putters(writer: cgen.Writer, names: cgen.Names,
+                  field: semantics.Field) -> None:
+    """One descriptor writer per backing this field allows."""
+    assert field.decl.blob is not None
+    for first, backing in enumerate(field.decl.blob.backings):
+        suffix, params = cgen.BLOB_PUTTERS[backing]
+        if first:
+            writer.line()
+        values = tuple(param.split()[-1].lstrip('*') for param in params)
+        writer.signature('static inline int',
+                         names.field_helper(field, f'put_{suffix}'),
+                         ('struct ctlv_msg *msg', *params), ')')
+        writer.line('{')
+        writer.parenthesized(f'\treturn ctlv_put_blob_{suffix}(',
+                             ('msg', names.field(field), *values), ');')
+        writer.line('}')
+
+
+def _readers(writer: cgen.Writer, names: cgen.Names,
+             family: semantics.Family) -> None:
+    """What an application reads out of a reply.
+
+    A getter answers whether it read anything: a device wrote it, not the
+    validator.
+    """
+    fields = [field for field in family.local_fields
+              if cgen.user_readers(names, field)]
+    if not fields:
+        return
+    writer.line()
+    writer.comment('Reading a reply. A getter answers whether it could '
+                   'read.')
+    for field in fields:
+        writer.line()
+        writer.doc(field.decl.doc)
+        if field.decl.max_occurrences != 1:
+            _iterator(writer, names, field)
+        else:
+            _present(writer, names, field)
+        if cgen.getter_value(field):
+            writer.line()
+            _getter(writer, names, field)
+
+
+def _present(writer: cgen.Writer, names: cgen.Names,
+             field: semantics.Field) -> None:
+    writer.signature('static inline bool',
+                     names.field_helper(field, 'present'), (RECORD_PARAM,),
+                     ')')
+    writer.line('{')
+    writer.parenthesized('\treturn ctlv_hdr_find(',
+                         ('record', names.field(field)), ');')
+    writer.line('}')
+
+
+def _iterator(writer: cgen.Writer, names: cgen.Names,
+              field: semantics.Field) -> None:
+    """Every occurrence of a repeated field, in the device's own order."""
+    writer.define_call(
+        f'{names.field_helper(field, "for_each")}(_hdr, _record)',
+        'ctlv_for_each_type', '_hdr', '_record', names.field(field))
+
+
+def _getter(writer: cgen.Writer, names: cgen.Names,
+            field: semantics.Field) -> None:
+    """What one field holds, or that it did not hold it.
+
+    A single field is looked up in the record it is given, a repeated one is
+    read where its iterator left the cursor.
+    """
+    getter = names.field_helper(field, 'get')
+    single = field.decl.max_occurrences == 1
+    found = RECORD_PARAM if single else f'const struct ctlv_hdr *{FOUND}'
+
+    if field.decl.kind == 'record':
+        # A record holds no value of its own: what a caller wants is itself.
+        writer.signature('static inline const struct ctlv_hdr',
+                         f'*{getter}', (RECORD_PARAM,), ')')
+        writer.line('{')
+        writer.parenthesized('\treturn ctlv_hdr_find(',
+                             ('record', names.field(field)), ');')
+        writer.line('}')
+        return
+
+    kind = field.decl.kind
+    if _extension_enum(names, field):
+        # What is known depends on the device's family, so it is a number.
+        kind = 'uint'
+    params, reader, extra = READERS[kind]
+    writer.signature('static inline bool', getter, (found, *params), ')')
+    writer.line('{')
+    if single:
+        writer.line(f'\tconst struct ctlv_hdr *{FOUND};')
+        writer.line()
+        writer.parenthesized(f'\t{FOUND} = ctlv_hdr_find(',
+                             ('record', names.field(field)), ');')
+    arguments = (FOUND,) + _reader_arguments(names, field, extra)
+    writer.parenthesized(f'\treturn {FOUND} && !{reader}(', arguments, ');')
+    writer.line('}')
+
+
+def _reader_arguments(names: cgen.Names, field: semantics.Field,
+                      extra: tuple[str, ...]) -> tuple[str, ...]:
+    """What the libctlv reader takes beyond the TLV it reads.
+
+    An enum and a flags payload are read against what this caller knows, so
+    anything outside is reported as a newer device's.
+    """
+    if (field.decl.kind not in ('enum', 'flags') or
+            _extension_enum(names, field)):
+        return extra or ('value',)
+    assert field.decl.ref is not None
+    definition = names.effective.definitions[field.decl.ref]
+    if field.decl.kind == 'flags':
+        return (names.value_mask(definition),) + extra
+    if definition.header:
+        return cgen.header_bounds(definition) + extra
+    numbers = definition.numbers()
+    return (str(min(numbers)), str(max(numbers))) + extra
+
+
+def _extension_enum(names: cgen.Names, field: semantics.Field) -> bool:
+    if field.decl.kind != 'enum':
+        return False
+    assert field.decl.ref is not None
+    return names.effective.definitions[field.decl.ref].extension is not None
+
+
+class ComposedNode:
+    """One node of a composed tree, with the members that arrive at it.
+
+    A composed tree is what a device answers, extension points filled in.
+    """
+
+    def __init__(self, node: semantics.Node, reenters: int = 0) -> None:
+        self.node = node
+        self.reenters = reenters
+        self.fields: list[ComposedNode] = []
+        self.optional_fields: list[ComposedNode] = []
+        # The arrays holding this node's members, once they have a name.
+        self.fields_symbol: str | None = None
+        self.optional_symbol: str | None = None
+
+    @property
+    def members(self) -> list[ComposedNode]:
+        return self.fields + self.optional_fields
+
+
+def compose(family: semantics.Family, root: semantics.Node) -> ComposedNode:
+    """Return the composed tree of one op message."""
+    return _place(family, root, ())
+
+
+def _place(family: semantics.Family, node: semantics.Node,
+           stack: tuple[semantics.Node, ...]) -> ComposedNode:
+    """One node and everything below it, fills spliced in."""
+    if node.reenters is not None:
+        return ComposedNode(node, reenters=_levels(node, stack))
+    place = ComposedNode(node)
+    _splice(family, node, False, stack + (node,), place)
+    return place
+
+
+def _levels(node: semantics.Node, stack: tuple[semantics.Node, ...]) -> int:
+    """How far up the node whose members are this one's as well.
+
+    One means the node this one is a member of, as the core reports it.
+    """
+    for levels, above in enumerate(reversed(stack), start=1):
+        if above.expands == node.reenters:
+            return levels
+    # The resolver rejects a re-entry of a record nothing expanded above.
+    raise AssertionError(f'{node.child_field.full_name} re-enters '
+                         f'{node.reenters} below nothing that expands it')
+
+
+def _splice(family: semantics.Family, node: semantics.Node,
+            force_optional: bool, stack: tuple[semantics.Node, ...],
+            place: ComposedNode) -> None:
+    """The members of one level: what it declares, then what filled it."""
+    for child in node.required_children:
+        target = place.optional_fields if force_optional else place.fields
+        target.append(_place(family, child, stack))
+    for child in node.optional_children:
+        place.optional_fields.append(_place(family, child, stack))
+    for extension in node.extensions:
+        fill = family.fill_of(extension)
+        if fill is None:
+            # Nothing in this chain filled it, so it contributes no member.
+            continue
+        _splice(family, fill.root, force_optional or extension.optional, stack,
+                place)
+
+
+def _sizing(place: ComposedNode) -> semantics.Node:
+    """One composed tree as an IR node, for the length arithmetic."""
+    if place.reenters:
+        return place.node
+    return dataclasses.replace(
+        place.node,
+        required_children=tuple(_sizing(member) for member in place.fields),
+        optional_children=tuple(_sizing(member)
+                                for member in place.optional_fields),
+        extensions=())
+
+
+def render_source(family: semantics.Family) -> str:
+    """Return the userspace binding source of family as text."""
+    names = cgen.Names(family)
+    cgen.symbols(family)
+    if family.name != spec.CORE_FAMILY_NAME:
+        cgen.user_symbols(family)
+
+    ops = _spec_ops(family)
+    writer = cgen.preamble(family, 'user', 'source')
+    writer.includes(*_source_includes(family, names, ops))
+    writer.comment('Effective request and reply schemas.')
+    writer.line()
+    for entry in ops:
+        for which, place in (('request', entry.request),
+                             ('reply', entry.reply)):
+            if place is not None:
+                _tree(writer, names, entry.op, which, place)
+    _table(writer, names, ops)
+    _spec(writer, names, family, ops)
+    return writer.text()
+
+
+def _source_includes(family: semantics.Family, names: cgen.Names,
+                     ops: tuple[Entry, ...]) -> tuple[str, ...]:
+    """libctlv, and this family's own names where it has any."""
+    headers = ['<ctlv.h>']
+    if _has_integer(ops):
+        headers = ['<stdint.h>', '', '<ctlv.h>']
+    if family.name != spec.CORE_FAMILY_NAME:
+        headers += ['', names.user_header()]
+    return tuple(headers)
+
+
+def _has_integer(ops: tuple[Entry, ...]) -> bool:
+    """Whether any bound of any tree of these ops is an integer's."""
+    def integers(place: ComposedNode) -> bool:
+        node = place.node
+        if not node.is_root and node.child_field.decl.kind in ('uint', 'sint'):
+            return True
+        return any(integers(member) for member in place.members)
+
+    return any(integers(place) for entry in ops
+               for place in (entry.request, entry.reply) if place)
+
+
+class Entry:
+    """One op of a specification table: the op and its composed messages."""
+
+    def __init__(self, family: semantics.Family, op: semantics.Op) -> None:
+        self.op = op
+        self.request = compose(family, op.request) if op.request else None
+        self.reply = compose(family, op.reply) if op.reply else None
+        where = f'{family.path}: op {op.name}'
+        self.sizes = sizes.composed(where, op,
+                                    _sizing(self.request) if self.request
+                                    else None,
+                                    _sizing(self.reply) if self.reply
+                                    else None)
+
+
+def _spec_ops(family: semantics.Family) -> tuple[Entry, ...]:
+    """Every op a device of this family answers, as the family composes it.
+
+    An inherited op is described again, since a fill anywhere in the chain
+    widens its message. The root's ops are libctlv's own table.
+    """
+    if family.name == spec.CORE_FAMILY_NAME:
+        _reject_root_extension(family)
+        ops = family.local_ops
+    else:
+        ops = tuple(op for op in family.ops
+                    if family.owners[op.family_id] != spec.CORE_FAMILY_NAME)
+    return tuple(Entry(family, op) for op in ops)
+
+
+def _reject_root_extension(family: semantics.Family) -> None:
+    """One table serves every chain, so the root may not be widened."""
+    for extension in family.local_extensions:
+        raise CtlvError(f'{family.path}: extension {extension.name}',
+                        'the root family cannot declare an extension '
+                        'point, because its ops are described once for '
+                        'every chain')
+
+
+def _tree(writer: cgen.Writer, names: cgen.Names, op: semantics.Op, which: str,
+          place: ComposedNode) -> None:
+    """One message: the arrays of its levels, deepest first, then its root."""
+    symbol = names.user_node_schema(op, which)
+    _arrays(writer, names, cgen.ident(op.name, which), place, set())
+    writer.declaration('static const struct ctlv_node_schema',
+                       f'{symbol} = {{')
+    _members(writer, names, place, 1)
+    writer.line('};')
+    writer.line()
+
+
+def _arrays(writer: cgen.Writer, names: cgen.Names, path: str,
+            place: ComposedNode, taken: set[str]) -> None:
+    """The member arrays below place, each emitted before whoever holds it.
+
+    An array is named after the path down to the node it carries.
+    """
+    for member in place.members:
+        if member.members:
+            _arrays(writer, names, _path(path, member, taken), member, taken)
+    for what, members in (('fields', place.fields),
+                          ('optional_fields', place.optional_fields)):
+        if not members:
+            continue
+        symbol = f'{path}_{what.removesuffix("s")}_node_schemas'
+        if what == 'fields':
+            place.fields_symbol = symbol
+        else:
+            place.optional_symbol = symbol
+        where = 'root' if place.node.is_root else \
+            place.node.child_field.full_name
+        writer.comment(f'{where}, {what.replace("_", " ")}')
+        writer.declaration('static const struct ctlv_node_schema',
+                           f'{symbol}[] = {{')
+        for member in members:
+            _node(writer, names, member)
+        writer.line('};')
+        writer.line()
+
+
+def _path(path: str, place: ComposedNode, taken: set[str]) -> str:
+    """The name of one node below path, which no other node has.
+
+    One field twice in one record is two nodes, so repeats are counted.
+    """
+    candidate = f'{path}_{cgen.ident(place.node.child_field.name)}'
+    symbol = candidate
+    repeat = 1
+    while symbol in taken:
+        repeat += 1
+        symbol = f'{candidate}_{repeat}'
+    taken.add(symbol)
+    return symbol
+
+
+def _node(writer: cgen.Writer, names: cgen.Names, place: ComposedNode) -> None:
+    """One member, as an element of the array that holds it."""
+    writer.line('\t{')
+    _members(writer, names, place, 2)
+    writer.line('\t},')
+
+
+def _members(writer: cgen.Writer, names: cgen.Names, place: ComposedNode,
+             depth: int) -> None:
+    """What one node says about itself, in the order the core reports it."""
+    node = place.node
+    tab = '\t' * depth
+    if node.is_root:
+        writer.line(f'{tab}.type = CTLV_TYPE_ROOT,')
+        writer.line(f'{tab}.kind = CTLV_SCHEMA_RECORD,')
+    else:
+        writer.declaration(f'{tab}.type =',
+                           f'{names.field(node.child_field)},')
+        writer.line(f'{tab}.kind = {cgen.KINDS[node.child_field.decl.kind]},')
+    if node.max_occurrences:
+        writer.line(f'{tab}.max_occurrences = {node.max_occurrences},')
+    else:
+        writer.line(f'{tab}.max_occurrences = 0, /* unlimited */')
+    _bounds(writer, names, place, tab)
+    if place.fields_symbol:
+        writer.declaration(f'{tab}.fields =', f'{place.fields_symbol},')
+        writer.line(f'{tab}.fields_count = {len(place.fields)},')
+    if place.optional_symbol:
+        writer.declaration(f'{tab}.optional_fields =',
+                           f'{place.optional_symbol},')
+        writer.line(f'{tab}.optional_fields_count = '
+                    f'{len(place.optional_fields)},')
+
+
+def _bounds(writer: cgen.Writer, names: cgen.Names, place: ComposedNode,
+            tab: str) -> None:
+    """The bounds of the schema kind this node has, with the present mask."""
+    bounds = _bounded(names, place)
+    if not bounds:
+        return
+    bits = [PRESENT[name] for name, _ in bounds]
+    _or_lines(writer, f'{tab}.present = ', bits)
+    for name, value in bounds:
+        if name == 'blob':
+            for member, part in zip(BLOB_MEMBERS, value):
+                writer.line(f'{tab}.{member} = {part},')
+        else:
+            writer.line(f'{tab}.{name} = {value},')
+
+
+def _or_lines(writer: cgen.Writer, opening: str, terms: list[str]) -> None:
+    """One or-ed list of bits, broken after an operator where it must be."""
+    column = cgen.width(opening)
+    indent = '\t' * (column // cgen.TAB_WIDTH) + ' ' * (column %
+                                                        cgen.TAB_WIDTH)
+    line = opening
+    for first, term in enumerate(terms):
+        part = term if not first else f' | {term}'
+        if first and cgen.width(f'{line}{part} |') > cgen.LINE_LIMIT:
+            writer.line(f'{line} |')
+            line = indent + term
+        else:
+            line += part
+    writer.line(f'{line},')
+
+
+def _bounded(
+        names: cgen.Names,
+        place: ComposedNode) -> tuple[tuple[str, str | tuple[str, ...]], ...]:
+    """Every bounded member of one node, with the value the core reports."""
+    node = place.node
+    if node.is_root:
+        return ()
+    decl = node.child_field.decl
+    bounds: list[tuple[str, str | tuple[str, ...]]] = []
+    if decl.kind in ('uint', 'sint'):
+        assert decl.min is not None and decl.max is not None
+        bounds += [('min', _bound(decl.kind, decl.min)),
+                   ('max', _bound(decl.kind, decl.max))]
+    elif decl.kind == 'enum':
+        assert decl.ref is not None
+        definition = names.effective.definitions[decl.ref]
+        if definition.extension is not None:
+            # As the device's family fills it, so nothing when none did.
+            bounds += [('min', '1'), ('max', str(definition.max_value))]
+        elif definition.header:
+            low, high = cgen.header_bounds(definition)
+            bounds += [('min', low), ('max', high)]
+        else:
+            numbers = definition.numbers()
+            bounds += [('min', str(min(numbers))),
+                       ('max', str(max(numbers)))]
+    elif decl.kind == 'flags':
+        assert decl.ref is not None
+        mask = 0
+        for bit in _numbers(names, decl.ref):
+            mask |= 1 << bit
+        bounds.append(('flags_mask', _u64(mask)))
+    elif decl.kind in ('string', 'binary'):
+        assert decl.min_length is not None and decl.max_length is not None
+        bounds += [('min_length', _u64(decl.min_length)),
+                   ('max_length', _u64(decl.max_length))]
+    elif decl.kind == 'blob':
+        assert decl.blob is not None
+        bounds.append(('blob', _blob(names, decl.blob)))
+    if decl.unit is not None:
+        bounds += [('unit', f'CTLV_UNIT_{cgen.macro(decl.unit)}'),
+                   ('scale', str(decl.scale))]
+    if place.reenters:
+        bounds.append(('reenters', str(place.reenters)))
+    return tuple(bounds)
+
+
+def _numbers(names: cgen.Names, ref: str) -> tuple[int, ...]:
+    """The numbers of the definition one field refers to."""
+    return names.effective.definitions[ref].numbers()
+
+
+def _blob(names: cgen.Names, blob: spec.BlobDecl) -> tuple[str, ...]:
+    """What a blob node allows, in the order the core reports it."""
+    direction = cgen.macro(spec.CORE_FAMILY_NAME, 'blob-direction',
+                           blob.direction)
+    types = dict(names.effective.definitions[BLOB_TYPES].values)
+    mask = 0
+    for backing in blob.backings:
+        mask |= 1 << types[backing]
+    return (direction, _u64(mask), _u64(blob.max_length),
+            _u64(blob.alignment))
+
+
+def _bound(kind: str, value: int) -> str:
+    extreme = EXTREMES.get((kind, value))
+    if extreme:
+        return extreme
+    if kind == 'sint':
+        return _s64(value)
+    return _u64(value)
+
+
+def _u64(value: int) -> str:
+    """One unsigned value, hexadecimal once decimal stops being readable."""
+    if value < 1 << 16:
+        return str(value)
+    return f'{value:#x}ULL'
+
+
+def _s64(value: int) -> str:
+    """One signed bound, as the unsigned payload a message carries."""
+    if value >= 0:
+        return _u64(value)
+    return f'(__u64)(__s64){value}'
+
+
+def _table(writer: cgen.Writer, names: cgen.Names,
+           ops: tuple[Entry, ...]) -> None:
+    """Every op of one table, with what its messages may hold."""
+    if not ops:
+        return
+    writer.comment('Effective ops in declaration order.')
+    writer.declaration('static const struct ctlv_op_spec',
+                       f'{names.user_op_specs()}[] = {{')
+    for entry in ops:
+        op = entry.op
+        writer.line('\t{')
+        writer.declaration('\t\t.op_id =', f'{names.op_id(op)},')
+        writer.line(f'\t\t.type = {OP_TYPES[op.type]},')
+        writer.line(f'\t\t.fd_access = {FD_ACCESSES[op.fd_access]},')
+        writer.line('\t\t.availability = '
+                    f'{AVAILABILITIES[op.availability]},')
+        if op.optional:
+            writer.line('\t\t.optional = true,')
+        for field in TABLE_LENGTHS:
+            value = getattr(entry.sizes, field)
+            if value:
+                writer.line(f'\t\t.{field} = {value},')
+        for which in ('request', 'reply'):
+            if getattr(entry, which) is not None:
+                writer.line(f'\t\t.{which} = '
+                            f'&{names.user_node_schema(op, which)},')
+        writer.line('\t},')
+    writer.line('};')
+    writer.line()
+
+
+def _spec(writer: cgen.Writer, names: cgen.Names, family: semantics.Family,
+          ops: tuple[Entry, ...]) -> None:
+    """This family's node of the specification graph."""
+    writer.comment('Family specification descriptor.')
+    writer.declaration('const struct ctlv_family_spec',
+                       f'{names.user_spec()} = {{')
+    writer.line(f'\t.name = "{family.name}",')
+    writer.line(f'\t.family_id = {family.family_id},')
+    if family.name != spec.CORE_FAMILY_NAME:
+        parent = cgen.Names(family.chain[-2]).user_spec()
+        writer.line(f'\t.parent = &{parent},')
+    if ops:
+        writer.line(f'\t.ops = {names.user_op_specs()},')
+        writer.line(f'\t.ops_count = {len(ops)},')
+    writer.line('};')
diff --git a/tools/ctlv/ctlvgen/lib/outputs.py b/tools/ctlv/ctlvgen/lib/outputs.py
index a295055c46b2..6ee8abe7f765 100644
--- a/tools/ctlv/ctlvgen/lib/outputs.py
+++ b/tools/ctlv/ctlvgen/lib/outputs.py
@@ -14,6 +14,7 @@ from typing import Optional
 from . import cgen
 from . import gen_kernel
 from . import gen_uapi
+from . import gen_user
 from . import semantics
 from . import spec
 from . import yamlload
@@ -24,16 +25,21 @@ FLAVOURS: dict[str, Callable[..., str]] = {
     'uapi-header': gen_uapi.render,
     'kernel-header': gen_kernel.render_header,
     'kernel-source': gen_kernel.render_source,
+    'user-header': gen_user.render_header,
+    'user-source': gen_user.render_source,
 }
 
 IDENTITIES: dict[str, tuple[str, str, str]] = {
     'uapi-header': ('uapi', 'header', '.h'),
     'kernel-header': ('kernel', 'header', '.h'),
     'kernel-source': ('kernel', 'source', '.c'),
+    'user-header': ('user', 'header', '.h'),
+    'user-source': ('user', 'source', '.c'),
 }
 
-ROOT_FLAVOURS = frozenset(FLAVOURS)
-FAMILY_FLAVOURS: frozenset[str] = frozenset(FLAVOURS)
+USER_FLAVOURS = frozenset({'user-header', 'user-source'})
+ROOT_FLAVOURS = frozenset(FLAVOURS) - {'user-header'}
+FAMILY_FLAVOURS: frozenset[str] = frozenset(FLAVOURS) - USER_FLAVOURS
 FIXTURE_FLAVOURS: frozenset[str] = frozenset({
     'uapi-header', 'kernel-header', 'kernel-source',
 })
@@ -143,6 +149,8 @@ def load(paths: spec.Paths) -> tuple[Output, ...]:
             if not fixture and name == spec.CORE_FAMILY_NAME:
                 required = ROOT_FLAVOURS
             flavours = frozenset(record['outputs'])
+            if required == FAMILY_FLAVOURS and flavours & USER_FLAVOURS:
+                required |= USER_FLAVOURS
             if flavours != required:
                 missing = sorted(required - flavours)
                 extra = sorted(flavours - required)
diff --git a/tools/ctlv/libctlv/Makefile b/tools/ctlv/libctlv/Makefile
new file mode 100644
index 000000000000..8e4e40118db2
--- /dev/null
+++ b/tools/ctlv/libctlv/Makefile
@@ -0,0 +1,41 @@
+# SPDX-License-Identifier: GPL-2.0
+
+KDIR ?= ../../..
+
+CFLAGS ?= -O2 -g
+
+include ../../scripts/Makefile.include
+
+# What make headers_install leaves behind, which is where <ctlv/ctlv.h> and
+# every generated family header come from.
+KHDR_INCLUDES ?= -isystem $(or $(ABSOLUTE_O),$(KDIR))/usr/include
+
+CFLAGS += -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers
+CFLAGS += -D_GNU_SOURCE -I. $(KHDR_INCLUDES)
+
+LIB = $(OUTPUT)libctlv.a
+
+# ctlv_user_gen.o is the root family's specification, generated from the same
+# YAML the core is generated from: the ops this library implements directly are
+# described by the tool that describes every other family's.
+OBJS = $(addprefix $(OUTPUT),	\
+	ctlv_user_gen.o			\
+	device.o			\
+	introspection.o			\
+	message.o			\
+	schema.o			\
+	spec.o				\
+	transport.o)
+
+all: $(LIB)
+
+$(LIB): $(OBJS)
+	$(QUIET_AR)$(AR) rcs $@ $^
+
+$(OUTPUT)%.o: %.c ctlv.h internal.h
+	$(QUIET_CC)$(CC) $(CFLAGS) -c -o $@ $<
+
+clean:
+	rm -f $(OBJS) $(LIB)
+
+.PHONY: all clean
diff --git a/tools/ctlv/libctlv/ctlv.h b/tools/ctlv/libctlv/ctlv.h
new file mode 100644
index 000000000000..cd643531ab64
--- /dev/null
+++ b/tools/ctlv/libctlv/ctlv.h
@@ -0,0 +1,413 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/*
+ * Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Family-independent userspace API; generated bindings build on it.
+ * int functions return zero or a negative errno; builders retain first error.
+ */
+#ifndef _CTLV_H
+#define _CTLV_H
+
+#include <ctlv/ctlv.h>
+#include <ctlv/ctlv_gen.h>
+#include <linux/types.h>
+#include <stdbool.h>
+#include <stddef.h>
+
+/* Room for the device's message in struct ctlv_error; a longer one is cut. */
+#define CTLV_ERROR_MESSAGE_LEN 256
+
+/* Which members of struct ctlv_error the failure came with. */
+#define CTLV_ERROR_HAS_REASON			(1U << 0)
+#define CTLV_ERROR_HAS_MESSAGE			(1U << 1)
+#define CTLV_ERROR_HAS_BAD_TLV_OFFSET		(1U << 2)
+#define CTLV_ERROR_HAS_RECORD_OFFSET		(1U << 3)
+#define CTLV_ERROR_HAS_MISSING_TYPE		(1U << 4)
+#define CTLV_ERROR_HAS_EXPECTED_GENERATION	(1U << 5)
+#define CTLV_ERROR_HAS_CURRENT_GENERATION	(1U << 6)
+#define CTLV_ERROR_HAS_REQUIRED_LENGTH		(1U << 7)
+
+/**
+ * struct ctlv_error - Why one op failed, as the device explained it.
+ * @err: the negative errno the op failed with, zero when it did not
+ * @present: CTLV_ERROR_HAS_* bits saying which members below were reported
+ * @reason: enum ctlv_validation_reason
+ * @message: what the device said, NUL terminated
+ * @bad_tlv_offset: offset in the request of the TLV that was refused
+ * @record_offset: offset in the request of the record holding it
+ * @missing_type: type of a required field that was absent
+ * @expected_generation: the generation a stale continuation carried
+ * @current_generation: the generation the device is on now
+ * @required_length: how long the output blob at @bad_tlv_offset has to be
+ *
+ * Everything beyond @err is optional, and a caller that wants only the errno
+ * may pass NULL wherever this is asked for.
+ */
+struct ctlv_error {
+	int err;
+	__u32 present;
+	__u32 reason;
+	char message[CTLV_ERROR_MESSAGE_LEN];
+	__u64 bad_tlv_offset;
+	__u64 record_offset;
+	__u64 missing_type;
+	__u64 expected_generation;
+	__u64 current_generation;
+	__u64 required_length;
+};
+
+/* Renders @error into @buf and returns it, for a diagnostic of one line. */
+const char *ctlv_error_str(const struct ctlv_error *error, char *buf,
+			   size_t len);
+
+/* An open device, its family chain resolved. */
+struct ctlv_dev;
+/* A message being built. */
+struct ctlv_msg;
+/* A complete reply, however many fragments it arrived in. */
+struct ctlv_reply;
+/* One op's request or reply tree, as numbers. */
+struct ctlv_schema;
+
+int ctlv_open(const char *family, unsigned int which, int flags,
+	      struct ctlv_dev **devp);
+int ctlv_open_path(const char *path, int flags, struct ctlv_dev **devp);
+/* A file its own subsystem opened, which ctlv_close() leaves open. */
+int ctlv_open_fd(int fd, struct ctlv_dev **devp);
+void ctlv_close(struct ctlv_dev *dev);
+
+int ctlv_dev_fd(const struct ctlv_dev *dev);
+const char *ctlv_dev_name(const struct ctlv_dev *dev);
+
+/* The chain of the opened device, root first and the device family last. */
+unsigned int ctlv_chain_len(const struct ctlv_dev *dev);
+__u16 ctlv_chain_id(const struct ctlv_dev *dev, unsigned int level);
+const char *ctlv_chain_name(const struct ctlv_dev *dev, unsigned int level);
+/* The family the device answers as. */
+const char *ctlv_dev_family(const struct ctlv_dev *dev);
+/* Whether @family is anywhere in the chain, so an inherited op applies. */
+bool ctlv_dev_inherits(const struct ctlv_dev *dev, const char *family);
+
+/**
+ * struct ctlv_dev_list - Every CTLV device this system has.
+ * @names: device names as they appear in /dev
+ * @names_count: number of names
+ */
+struct ctlv_dev_list {
+	char **names;
+	unsigned int names_count;
+};
+
+int ctlv_enumerate(struct ctlv_dev_list *list);
+void ctlv_dev_list_free(struct ctlv_dev_list *list);
+
+int ctlv_msg_new(__u32 capacity, struct ctlv_msg **msgp);
+/* The same with a ceiling, so an over-long request fails as it is built. */
+int ctlv_msg_new_max(__u32 capacity, __u32 max, struct ctlv_msg **msgp);
+void ctlv_msg_free(struct ctlv_msg *msg);
+void ctlv_msg_reset(struct ctlv_msg *msg);
+
+/* The first failure since the last reset, or 0. */
+int ctlv_msg_err(const struct ctlv_msg *msg);
+/* Closes whatever is still open and returns the message, or the failure. */
+int ctlv_msg_done(struct ctlv_msg *msg);
+const struct ctlv_hdr *ctlv_msg_root(const struct ctlv_msg *msg);
+__u32 ctlv_msg_len(const struct ctlv_msg *msg);
+
+int ctlv_put_u64(struct ctlv_msg *msg, __u64 type, __u64 value);
+int ctlv_put_s64(struct ctlv_msg *msg, __u64 type, __s64 value);
+int ctlv_put_bool(struct ctlv_msg *msg, __u64 type, bool value);
+int ctlv_put_str(struct ctlv_msg *msg, __u64 type, const char *value);
+int ctlv_put_bin(struct ctlv_msg *msg, __u64 type, const void *value,
+		 __u32 len);
+int ctlv_record_start(struct ctlv_msg *msg, __u64 type);
+int ctlv_record_end(struct ctlv_msg *msg);
+
+/*
+ * Says of the TLV written last, a record just ended included, that a device
+ * whose schema does not declare its type should skip it rather than refuse
+ * the request. A type the device does declare is held to its schema as ever,
+ * so this covers a field a newer version of a family added and nothing more.
+ */
+int ctlv_msg_ignore_if_unknown(struct ctlv_msg *msg);
+
+/* A blob TLV carries a record describing memory; these write all of it. */
+int ctlv_put_blob_va(struct ctlv_msg *msg, __u64 type, const void *address,
+		     __u64 length);
+
+/* Fails when framing, lengths or records are not self-consistent. */
+int ctlv_msg_check(const void *buf, __u32 len);
+
+bool ctlv_hdr_is_record(const struct ctlv_hdr *hdr);
+const void *ctlv_hdr_payload(const struct ctlv_hdr *hdr, __u32 *len);
+__u32 ctlv_hdr_payload_len(const struct ctlv_hdr *hdr);
+
+const struct ctlv_hdr *ctlv_hdr_first(const struct ctlv_hdr *record);
+const struct ctlv_hdr *ctlv_hdr_next(const struct ctlv_hdr *record,
+				     const struct ctlv_hdr *child);
+const struct ctlv_hdr *ctlv_hdr_find(const struct ctlv_hdr *record,
+				     __u64 type);
+const struct ctlv_hdr *ctlv_hdr_find_next(const struct ctlv_hdr *record,
+					  const struct ctlv_hdr *hdr,
+					  __u64 type);
+unsigned int ctlv_hdr_count(const struct ctlv_hdr *record, __u64 type);
+
+/* Every child of @record, in the order the device wrote them. */
+#define ctlv_for_each(_child, _record)					\
+	for ((_child) = ctlv_hdr_first(_record); (_child);		\
+	     (_child) = ctlv_hdr_next((_record), (_child)))
+
+/* Every occurrence of a field that may repeat. */
+#define ctlv_for_each_type(_child, _record, _type)			\
+	for ((_child) = ctlv_hdr_find((_record), (_type)); (_child);	\
+	     (_child) = ctlv_hdr_find_next((_record), (_child),		\
+					   (_type)))
+
+int ctlv_get_u64(const struct ctlv_hdr *hdr, __u64 *value);
+int ctlv_get_s64(const struct ctlv_hdr *hdr, __s64 *value);
+int ctlv_get_bool(const struct ctlv_hdr *hdr, bool *value);
+int ctlv_get_str(const struct ctlv_hdr *hdr, const char **value);
+int ctlv_get_bin(const struct ctlv_hdr *hdr, const void **value, __u32 *len);
+
+/*
+ * Neither refuses a value a device newer than its caller sent: @known says
+ * whether the value is from @min to @max, @unknown collects the bits outside
+ * @mask.
+ */
+int ctlv_get_enum(const struct ctlv_hdr *hdr, __u64 min, __u64 max,
+		  __u64 *value, bool *known);
+int ctlv_get_flags(const struct ctlv_hdr *hdr, __u64 mask, __u64 *value,
+		   __u64 *unknown);
+
+/*
+ * An action is one ioctl. A query is as many as its answer takes, reassembled
+ * here into the one reply the device would have sent given room for all of it.
+ */
+int ctlv_action(struct ctlv_dev *dev, __u64 op_id, struct ctlv_msg *request,
+		struct ctlv_reply **replyp, struct ctlv_error *error);
+int ctlv_query(struct ctlv_dev *dev, __u64 op_id, struct ctlv_msg *request,
+	       struct ctlv_reply **replyp, struct ctlv_error *error);
+
+/*
+ * The same two with the reply buffer sized, sparing the fallback dump. A sized
+ * action keeps error information only if @reply_len has room for it, and a
+ * sized query does not restart a stale dump, so a caller learns that it went
+ * stale.
+ */
+int ctlv_action_sized(struct ctlv_dev *dev, __u64 op_id,
+		      struct ctlv_msg *request, __u32 reply_len,
+		      struct ctlv_reply **replyp, struct ctlv_error *error);
+int ctlv_query_sized(struct ctlv_dev *dev, __u64 op_id,
+		     struct ctlv_msg *request, __u32 buf_len,
+		     struct ctlv_reply **replyp, struct ctlv_error *error);
+
+const struct ctlv_hdr *ctlv_reply_root(const struct ctlv_reply *reply);
+/* The generation the answer belongs to. */
+__u64 ctlv_reply_generation(const struct ctlv_reply *reply);
+/* How many ioctls it took, a property of the buffer, not the reply. */
+unsigned int ctlv_reply_fragments(const struct ctlv_reply *reply);
+void ctlv_reply_free(struct ctlv_reply *reply);
+
+/*
+ * What op-schema-get reports, in the shape the generator computes the same
+ * numbers into, so a device and its specification compare member by member.
+ */
+
+/* Which members of struct ctlv_node_schema the node declares. */
+#define CTLV_NODE_SCHEMA_HAS_MIN		(1U << 0)
+#define CTLV_NODE_SCHEMA_HAS_MAX		(1U << 1)
+#define CTLV_NODE_SCHEMA_HAS_MIN_LENGTH		(1U << 2)
+#define CTLV_NODE_SCHEMA_HAS_MAX_LENGTH		(1U << 3)
+#define CTLV_NODE_SCHEMA_HAS_FLAGS_MASK		(1U << 4)
+#define CTLV_NODE_SCHEMA_HAS_UNIT		(1U << 5)
+#define CTLV_NODE_SCHEMA_HAS_SCALE		(1U << 6)
+#define CTLV_NODE_SCHEMA_HAS_BLOB		(1U << 7)
+#define CTLV_NODE_SCHEMA_HAS_REENTERS		(1U << 8)
+
+/**
+ * struct ctlv_node_schema - One node of an op's request or reply tree.
+ * @type: the field's type, or CTLV_TYPE_ROOT for the message root
+ * @kind: enum ctlv_schema_kind, the one schema kind this payload takes
+ * @max_occurrences: how often it may appear, zero meaning as often as fits
+ * @present: CTLV_NODE_SCHEMA_HAS_* bits saying which members below apply
+ * @min: inclusive lower bound of an integer or enum payload
+ * @max: inclusive upper bound of the same
+ * @min_length: shortest string or binary payload, a terminator excluded
+ * @max_length: longest of the same
+ * @flags_mask: every bit a flags payload may carry
+ * @unit: enum ctlv_unit of an integer payload
+ * @scale: decimal scale that accompanies @unit
+ * @blob_direction: enum ctlv_blob_direction of a blob
+ * @blob_backings: mask of BIT(enum ctlv_blob_type) this blob takes
+ * @blob_max_length: longest external payload the blob may describe
+ * @blob_alignment: alignment the blob's address or offset must have
+ * @reenters: levels to climb to the node whose members are this one's too
+ * @fields: the required nodes one level in
+ * @fields_count: how many
+ * @optional_fields: the optional nodes one level in
+ * @optional_fields_count: how many
+ *
+ * The same field in two places is two nodes, each required or not.
+ */
+struct ctlv_node_schema {
+	__u64 type;
+	__u32 kind;
+	__u64 max_occurrences;
+	__u32 present;
+	__u64 min;
+	__u64 max;
+	__u64 min_length;
+	__u64 max_length;
+	__u64 flags_mask;
+	__u32 unit;
+	__s64 scale;
+	__u32 blob_direction;
+	__u64 blob_backings;
+	__u64 blob_max_length;
+	__u64 blob_alignment;
+	__u64 reenters;
+	const struct ctlv_node_schema *fields;
+	unsigned int fields_count;
+	const struct ctlv_node_schema *optional_fields;
+	unsigned int optional_fields_count;
+};
+
+/* Either tree is absent when the op has no such message. */
+int ctlv_op_schema_get(struct ctlv_dev *dev, __u64 op_id,
+		       struct ctlv_schema **schemap, struct ctlv_error *error);
+const struct ctlv_node_schema *ctlv_schema_request(const struct ctlv_schema *s);
+const struct ctlv_node_schema *ctlv_schema_reply(const struct ctlv_schema *s);
+void ctlv_schema_free(struct ctlv_schema *schema);
+
+/*
+ * Whether two trees agree, and where they first differ. @expected is what a
+ * specification generated, @actual what a device reported.
+ */
+bool ctlv_schema_equal(const struct ctlv_node_schema *expected,
+		       const struct ctlv_node_schema *actual, char *diff,
+		       size_t len);
+
+/* One line describing a node; @indent is how deep it sits. */
+void ctlv_schema_render(const struct ctlv_node_schema *node,
+			unsigned int indent, char *buf, size_t len);
+
+/* What every device answers, whatever family it belongs to. */
+
+/**
+ * struct ctlv_op_info - One entry of an ops dump.
+ * @op_id: complete op ID
+ * @type: enum ctlv_op_type
+ * @fd_access: enum ctlv_op_fd_access
+ * @availability: enum ctlv_op_availability
+ * @disabled: whether this device refuses the op right now
+ * @request_max_len: longest request made from known fields
+ * @action_reply_max_len: longest action reply, zero when it is not an action
+ * @query_reply_min_len: smallest buffer a query fragment needs
+ * @query_reply_suggested_len: buffer size the device would rather have
+ * @error_info_max_len: longest error information
+ */
+struct ctlv_op_info {
+	__u64 op_id;
+	__u32 type;
+	__u32 fd_access;
+	__u32 availability;
+	bool disabled;
+	__u64 request_max_len;
+	__u64 action_reply_max_len;
+	__u64 query_reply_min_len;
+	__u64 query_reply_suggested_len;
+	__u64 error_info_max_len;
+};
+
+/**
+ * struct ctlv_ops - Every op one device publishes.
+ * @ops: entries in the order the device reported them
+ * @ops_count: number of entries
+ * @generation: the op-state generation the whole dump belongs to
+ */
+struct ctlv_ops {
+	struct ctlv_op_info *ops;
+	unsigned int ops_count;
+	__u64 generation;
+};
+
+int ctlv_ops_get(struct ctlv_dev *dev, struct ctlv_ops **opsp,
+		 struct ctlv_error *error);
+void ctlv_ops_free(struct ctlv_ops *ops);
+const struct ctlv_op_info *ctlv_ops_find(const struct ctlv_ops *ops,
+					 __u64 op_id);
+
+/*
+ * What a family's specification says, as its generated binding carries it.
+ * Comparing it against what a device reports says whether the two agree.
+ */
+
+/**
+ * struct ctlv_op_spec - What a specification says about one op.
+ * @op_id: complete op ID
+ * @type: enum ctlv_op_type
+ * @fd_access: enum ctlv_op_fd_access
+ * @availability: enum ctlv_op_availability
+ * @optional: whether a device may omit this op
+ * @request_max_len: longest request made from known fields
+ * @action_reply_max_len: longest action reply, zero when it is not an action
+ * @query_reply_min_len: smallest buffer a query fragment needs
+ * @query_reply_suggested_len: buffer size worth offering a query
+ * @error_info_max_len: longest error information
+ * @request: the request tree, NULL when the op takes no request
+ * @reply: the reply tree, NULL when it answers none
+ *
+ * An ops dump says whether a particular device offers an optional op.
+ */
+struct ctlv_op_spec {
+	__u64 op_id;
+	__u32 type;
+	__u32 fd_access;
+	__u32 availability;
+	bool optional;
+	__u64 request_max_len;
+	__u64 action_reply_max_len;
+	__u64 query_reply_min_len;
+	__u64 query_reply_suggested_len;
+	__u64 error_info_max_len;
+	const struct ctlv_node_schema *request;
+	const struct ctlv_node_schema *reply;
+};
+
+/**
+ * struct ctlv_family_spec - What a specification says about one family.
+ * @name: the family name, as a device's uevent carries it
+ * @family_id: its position in the central registry
+ * @parent: the family it inherits, NULL for the root
+ * @ops: every op a device of the family answers below the root, in the order
+ *	its chain declared them
+ * @ops_count: number of entries
+ *
+ * A chain is these linked upwards, one per family. An inherited op is
+ * described again in each, because every length that touches it differs.
+ */
+struct ctlv_family_spec {
+	const char *name;
+	__u16 family_id;
+	const struct ctlv_family_spec *parent;
+	const struct ctlv_op_spec *ops;
+	unsigned int ops_count;
+};
+
+/* The root family, which every chain starts from and every device answers. */
+extern const struct ctlv_family_spec ctlv_spec;
+
+/* The op of @spec's chain with @op_id, or NULL for one it does not describe. */
+const struct ctlv_op_spec *ctlv_spec_find(const struct ctlv_family_spec *spec,
+					  __u64 op_id);
+
+/*
+ * Whether @dev agrees with @spec about its published ops: 0 when they do,
+ * -ENOMSG when they do not with @diff saying where, -EINVAL when @spec is not
+ * the family @dev registered as, another errno when the device could not be
+ * asked. Every mandatory op must be published; an optional one may be absent.
+ */
+int ctlv_spec_check(struct ctlv_dev *dev, const struct ctlv_family_spec *spec,
+		    char *diff, size_t len, struct ctlv_error *error);
+
+#endif /* _CTLV_H */
diff --git a/tools/ctlv/libctlv/ctlv_user_gen.c b/tools/ctlv/libctlv/ctlv_user_gen.c
new file mode 100644
index 000000000000..606dbf93b746
--- /dev/null
+++ b/tools/ctlv/libctlv/ctlv_user_gen.c
@@ -0,0 +1,551 @@
+// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+/*
+ * Generated from Documentation/ctlv/specs/ctlv.yaml by
+ * tools/ctlv/ctlv-regen.sh. Do not edit.
+ */
+/* CTLV-GEN user source */
+
+#include <stdint.h>
+
+#include <ctlv.h>
+
+/* Effective request and reply schemas. */
+
+static const struct ctlv_node_schema family_get_request_node_schema = {
+	.type = CTLV_TYPE_ROOT,
+	.kind = CTLV_SCHEMA_RECORD,
+	.max_occurrences = 1,
+};
+
+/* family-get families, fields */
+static const struct ctlv_node_schema family_get_reply_families_field_node_schemas[] = {
+	{
+		.type = CTLV_T_FAMILY_GET_FAMILIES_ID,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_FAMILY_GET_FAMILIES_NAME,
+		.kind = CTLV_SCHEMA_STRING,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 0,
+		.max_length = 63,
+	},
+};
+
+/* root, fields */
+static const struct ctlv_node_schema family_get_reply_field_node_schemas[] = {
+	{
+		.type = CTLV_T_FAMILY_GET_FAMILIES,
+		.kind = CTLV_SCHEMA_RECORD,
+		.max_occurrences = 0, /* unlimited */
+		.fields = family_get_reply_families_field_node_schemas,
+		.fields_count = 2,
+	},
+};
+
+static const struct ctlv_node_schema family_get_reply_node_schema = {
+	.type = CTLV_TYPE_ROOT,
+	.kind = CTLV_SCHEMA_RECORD,
+	.max_occurrences = 1,
+	.fields = family_get_reply_field_node_schemas,
+	.fields_count = 1,
+};
+
+static const struct ctlv_node_schema op_get_request_node_schema = {
+	.type = CTLV_TYPE_ROOT,
+	.kind = CTLV_SCHEMA_RECORD,
+	.max_occurrences = 1,
+};
+
+/* op-get ops, fields */
+static const struct ctlv_node_schema op_get_reply_ops_field_node_schemas[] = {
+	{
+		.type = CTLV_T_OP_GET_OPS_ID,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 1,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_OP_GET_OPS_TYPE,
+		.kind = CTLV_SCHEMA_ENUM,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 1,
+		.max = 2,
+	},
+};
+
+/* op-get ops, optional fields */
+static const struct ctlv_node_schema op_get_reply_ops_optional_field_node_schemas[] = {
+	{
+		.type = CTLV_T_OP_GET_OPS_AVAILABILITY,
+		.kind = CTLV_SCHEMA_ENUM,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 1,
+		.max = 2,
+	},
+	{
+		.type = CTLV_T_OP_GET_OPS_DISABLED,
+		.kind = CTLV_SCHEMA_BOOL,
+		.max_occurrences = 1,
+	},
+	{
+		.type = CTLV_T_OP_GET_OPS_REQUEST_MAX_LEN,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_OP_GET_OPS_ACTION_REPLY_MAX_LEN,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_OP_GET_OPS_QUERY_REPLY_MIN_LEN,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_OP_GET_OPS_QUERY_REPLY_SUGGESTED_LEN,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_OP_GET_OPS_FD_ACCESS,
+		.kind = CTLV_SCHEMA_ENUM,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 1,
+		.max = 2,
+	},
+	{
+		.type = CTLV_T_OP_GET_OPS_ERROR_INFO_MAX_LEN,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+};
+
+/* root, fields */
+static const struct ctlv_node_schema op_get_reply_field_node_schemas[] = {
+	{
+		.type = CTLV_T_OP_GET_OPS,
+		.kind = CTLV_SCHEMA_RECORD,
+		.max_occurrences = 0, /* unlimited */
+		.fields = op_get_reply_ops_field_node_schemas,
+		.fields_count = 2,
+		.optional_fields = op_get_reply_ops_optional_field_node_schemas,
+		.optional_fields_count = 8,
+	},
+};
+
+static const struct ctlv_node_schema op_get_reply_node_schema = {
+	.type = CTLV_TYPE_ROOT,
+	.kind = CTLV_SCHEMA_RECORD,
+	.max_occurrences = 1,
+	.fields = op_get_reply_field_node_schemas,
+	.fields_count = 1,
+};
+
+/* root, fields */
+static const struct ctlv_node_schema op_schema_get_request_field_node_schemas[] = {
+	{
+		.type = CTLV_T_OP_SCHEMA_GET_ID,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 1,
+		.max = UINT64_MAX,
+	},
+};
+
+static const struct ctlv_node_schema op_schema_get_request_node_schema = {
+	.type = CTLV_TYPE_ROOT,
+	.kind = CTLV_SCHEMA_RECORD,
+	.max_occurrences = 1,
+	.fields = op_schema_get_request_field_node_schemas,
+	.fields_count = 1,
+};
+
+/* op-schema-get request, fields */
+static const struct ctlv_node_schema op_schema_get_reply_request_field_node_schemas[] = {
+	{
+		.type = CTLV_T_SCHEMA_NODE_TYPE,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_KIND,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_MAX_OCCURRENCES,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+};
+
+/* op-schema-get request, optional fields */
+static const struct ctlv_node_schema op_schema_get_reply_request_optional_field_node_schemas[] = {
+	{
+		.type = CTLV_T_SCHEMA_NODE_MIN,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_MAX,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_MIN_LENGTH,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_MAX_LENGTH,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_FLAGS_MASK,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_UNIT,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_SCALE,
+		.kind = CTLV_SCHEMA_SINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = (__u64)INT64_MIN,
+		.max = INT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_BLOB_DIRECTION,
+		.kind = CTLV_SCHEMA_ENUM,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 1,
+		.max = 3,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_BLOB_BACKINGS,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_BLOB_MAX_LENGTH,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_BLOB_ALIGNMENT,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_REENTERS,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 1,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_FIELDS,
+		.kind = CTLV_SCHEMA_RECORD,
+		.max_occurrences = 0, /* unlimited */
+		.present = CTLV_NODE_SCHEMA_HAS_REENTERS,
+		.reenters = 1,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_OPTIONAL_FIELDS,
+		.kind = CTLV_SCHEMA_RECORD,
+		.max_occurrences = 0, /* unlimited */
+		.present = CTLV_NODE_SCHEMA_HAS_REENTERS,
+		.reenters = 1,
+	},
+};
+
+/* op-schema-get reply, fields */
+static const struct ctlv_node_schema op_schema_get_reply_reply_field_node_schemas[] = {
+	{
+		.type = CTLV_T_SCHEMA_NODE_TYPE,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_KIND,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_MAX_OCCURRENCES,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+};
+
+/* op-schema-get reply, optional fields */
+static const struct ctlv_node_schema op_schema_get_reply_reply_optional_field_node_schemas[] = {
+	{
+		.type = CTLV_T_SCHEMA_NODE_MIN,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_MAX,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_MIN_LENGTH,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_MAX_LENGTH,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_FLAGS_MASK,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_UNIT,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_SCALE,
+		.kind = CTLV_SCHEMA_SINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = (__u64)INT64_MIN,
+		.max = INT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_BLOB_DIRECTION,
+		.kind = CTLV_SCHEMA_ENUM,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 1,
+		.max = 3,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_BLOB_BACKINGS,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_BLOB_MAX_LENGTH,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_BLOB_ALIGNMENT,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_REENTERS,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 1,
+		.max = UINT64_MAX,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_FIELDS,
+		.kind = CTLV_SCHEMA_RECORD,
+		.max_occurrences = 0, /* unlimited */
+		.present = CTLV_NODE_SCHEMA_HAS_REENTERS,
+		.reenters = 1,
+	},
+	{
+		.type = CTLV_T_SCHEMA_NODE_OPTIONAL_FIELDS,
+		.kind = CTLV_SCHEMA_RECORD,
+		.max_occurrences = 0, /* unlimited */
+		.present = CTLV_NODE_SCHEMA_HAS_REENTERS,
+		.reenters = 1,
+	},
+};
+
+/* root, optional fields */
+static const struct ctlv_node_schema op_schema_get_reply_optional_field_node_schemas[] = {
+	{
+		.type = CTLV_T_OP_SCHEMA_GET_REQUEST,
+		.kind = CTLV_SCHEMA_RECORD,
+		.max_occurrences = 1,
+		.fields = op_schema_get_reply_request_field_node_schemas,
+		.fields_count = 3,
+		.optional_fields = op_schema_get_reply_request_optional_field_node_schemas,
+		.optional_fields_count = 14,
+	},
+	{
+		.type = CTLV_T_OP_SCHEMA_GET_REPLY,
+		.kind = CTLV_SCHEMA_RECORD,
+		.max_occurrences = 1,
+		.fields = op_schema_get_reply_reply_field_node_schemas,
+		.fields_count = 3,
+		.optional_fields = op_schema_get_reply_reply_optional_field_node_schemas,
+		.optional_fields_count = 14,
+	},
+};
+
+static const struct ctlv_node_schema op_schema_get_reply_node_schema = {
+	.type = CTLV_TYPE_ROOT,
+	.kind = CTLV_SCHEMA_RECORD,
+	.max_occurrences = 1,
+	.optional_fields = op_schema_get_reply_optional_field_node_schemas,
+	.optional_fields_count = 2,
+};
+
+/* Effective ops in declaration order. */
+static const struct ctlv_op_spec ctlv_op_specs[] = {
+	{
+		.op_id = CTLV_OP_FAMILY_GET,
+		.type = CTLV_OP_TYPE_QUERY,
+		.fd_access = CTLV_OP_FD_ACCESS_READ,
+		.availability = CTLV_OP_AVAILABILITY_FIXED,
+		.request_max_len = 16,
+		.query_reply_min_len = 112,
+		.query_reply_suggested_len = 65536,
+		.error_info_max_len = 456,
+		.request = &family_get_request_node_schema,
+		.reply = &family_get_reply_node_schema,
+	},
+	{
+		.op_id = CTLV_OP_OP_GET,
+		.type = CTLV_OP_TYPE_QUERY,
+		.fd_access = CTLV_OP_FD_ACCESS_READ,
+		.availability = CTLV_OP_AVAILABILITY_FIXED,
+		.request_max_len = 16,
+		.query_reply_min_len = 56,
+		.query_reply_suggested_len = 65536,
+		.error_info_max_len = 456,
+		.request = &op_get_request_node_schema,
+		.reply = &op_get_reply_node_schema,
+	},
+	{
+		.op_id = CTLV_OP_OP_SCHEMA_GET,
+		.type = CTLV_OP_TYPE_QUERY,
+		.fd_access = CTLV_OP_FD_ACCESS_READ,
+		.availability = CTLV_OP_AVAILABILITY_FIXED,
+		.request_max_len = 40,
+		.query_reply_min_len = 168,
+		.query_reply_suggested_len = 65536,
+		.error_info_max_len = 456,
+		.request = &op_schema_get_request_node_schema,
+		.reply = &op_schema_get_reply_node_schema,
+	},
+};
+
+/* Family specification descriptor. */
+const struct ctlv_family_spec ctlv_spec = {
+	.name = "ctlv",
+	.family_id = 0,
+	.ops = ctlv_op_specs,
+	.ops_count = 3,
+};
diff --git a/tools/ctlv/libctlv/device.c b/tools/ctlv/libctlv/device.c
new file mode 100644
index 000000000000..468ec2fb563a
--- /dev/null
+++ b/tools/ctlv/libctlv/device.c
@@ -0,0 +1,412 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Device discovery, opening, and family-chain verification.
+ */
+
+#include <dirent.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <unistd.h>
+
+#include "internal.h"
+
+/* Whichever subsystem a device is in announces its family, so all are here. */
+#define CHAR_DIR "/sys/dev/char"
+#define DEV_DIR "/dev"
+
+/* Longest device or family name, and longest path naming one. */
+#define NAME_LEN 256
+#define PATH_LEN 1024
+
+/* One line of a uevent file, PROPERTY=value. */
+#define UEVENT_LINE_LEN 512
+
+static int name_dup(const char *name, char **out)
+{
+	char *copy = strdup(name);
+
+	if (!copy)
+		return -ENOMEM;
+	*out = copy;
+	return 0;
+}
+
+/* The value @line gives @property, its newline dropped, or NULL. */
+static const char *uevent_value(char *line, const char *property)
+{
+	size_t prefix = strlen(property);
+	char *end;
+
+	if (strncmp(line, property, prefix) || line[prefix] != '=')
+		return NULL;
+	end = strchr(line, '\n');
+	if (end)
+		*end = '\0';
+	return line + prefix + 1;
+}
+
+/*
+ * The family of one char device and its name under /dev, NAME_LEN each, or
+ * -ENOENT for a device that is not a CTLV one.
+ */
+static int uevent_read(const char *devnum, char *family, char *devname)
+{
+	char line[UEVENT_LINE_LEN];
+	char path[PATH_LEN];
+	FILE *file;
+
+	family[0] = '\0';
+	devname[0] = '\0';
+	snprintf(path, sizeof(path), "%s/%s/uevent", CHAR_DIR, devnum);
+	file = fopen(path, "re");
+	if (!file)
+		return -errno;
+	while (fgets(line, sizeof(line), file)) {
+		const char *value = uevent_value(line, "CTLV_FAMILY");
+		char *out = family;
+		size_t len;
+
+		if (!value) {
+			value = uevent_value(line, "DEVNAME");
+			out = devname;
+		}
+		if (!value)
+			continue;
+		len = strlen(value);
+		/* A property this reader cannot hold is not one it matched. */
+		if (len < NAME_LEN)
+			memcpy(out, value, len + 1);
+	}
+	fclose(file);
+	return *family && *devname ? 0 : -ENOENT;
+}
+
+static int name_cmp(const void *a, const void *b)
+{
+	return strcmp(*(const char *const *)a, *(const char *const *)b);
+}
+
+/* Every CTLV device, or only those registered as @family. */
+static int dev_scan(struct ctlv_dev_list *list, const char *family)
+{
+	char found[NAME_LEN], devname[NAME_LEN];
+	struct dirent *entry;
+	char **name = NULL;
+	unsigned int n = 0;
+	DIR *dir;
+	int ret = 0;
+
+	memset(list, 0, sizeof(*list));
+	dir = opendir(CHAR_DIR);
+	if (!dir)
+		return -errno;
+	while ((entry = readdir(dir))) {
+		char **grown;
+
+		if (entry->d_name[0] == '.' ||
+		    uevent_read(entry->d_name, found, devname) ||
+		    (family && strcmp(found, family)))
+			continue;
+		grown = realloc(name, (n + 1) * sizeof(*name));
+		if (!grown) {
+			ret = -ENOMEM;
+			break;
+		}
+		name = grown;
+		ret = name_dup(devname, &name[n]);
+		if (ret)
+			break;
+		n++;
+	}
+	closedir(dir);
+	list->names_count = n;
+	list->names = name;
+	if (ret) {
+		ctlv_dev_list_free(list);
+		return ret;
+	}
+	/* Ordered, so that a tool listing devices lists them the same twice. */
+	if (name)
+		qsort(name, n, sizeof(*name), name_cmp);
+	return 0;
+}
+
+int ctlv_enumerate(struct ctlv_dev_list *list)
+{
+	return dev_scan(list, NULL);
+}
+
+void ctlv_dev_list_free(struct ctlv_dev_list *list)
+{
+	unsigned int i;
+
+	for (i = 0; i < list->names_count; i++)
+		free(list->names[i]);
+	free(list->names);
+	memset(list, 0, sizeof(*list));
+}
+
+/* The chain the device reports, root family first and device family last. */
+int ctlv_chain_load(struct ctlv_dev *dev)
+{
+	const struct ctlv_hdr *root, *entry;
+	struct ctlv_reply *reply = NULL;
+	unsigned int n = 0;
+	int ret;
+
+	ret = ctlv_query_sized(dev, CTLV_OP_FAMILY_GET, NULL, 0, &reply,
+			       NULL);
+	if (ret)
+		return ret;
+
+	root = ctlv_reply_root(reply);
+	ret = ctlv_bootstrap_validate(root, reply->msg->len,
+				      CTLV_OP_FAMILY_GET);
+	if (ret)
+		goto out;
+	n = ctlv_hdr_count(root, CTLV_T_FAMILY_GET_FAMILIES);
+	dev->chain_id = calloc(n, sizeof(*dev->chain_id));
+	dev->chain_name = calloc(n, sizeof(*dev->chain_name));
+	if (!dev->chain_id || !dev->chain_name) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ctlv_for_each_type(entry, root, CTLV_T_FAMILY_GET_FAMILIES) {
+		const struct ctlv_hdr *hdr;
+		const char *name;
+		__u64 id;
+
+		hdr = ctlv_hdr_find(entry, CTLV_T_FAMILY_GET_FAMILIES_ID);
+		if (!hdr || ctlv_get_u64(hdr, &id) || id > UINT16_MAX) {
+			ret = -EPROTO;
+			goto out;
+		}
+		hdr = ctlv_hdr_find(entry, CTLV_T_FAMILY_GET_FAMILIES_NAME);
+		if (!hdr || ctlv_get_str(hdr, &name)) {
+			ret = -EPROTO;
+			goto out;
+		}
+		dev->chain_id[dev->chain_len] = id;
+		ret = name_dup(name, &dev->chain_name[dev->chain_len]);
+		if (ret)
+			goto out;
+		dev->chain_len++;
+	}
+	ret = 0;
+out:
+	ctlv_reply_free(reply);
+	return ret;
+}
+
+static void dev_free(struct ctlv_dev *dev)
+{
+	unsigned int i;
+
+	for (i = 0; i < dev->chain_len; i++)
+		free(dev->chain_name[i]);
+	free(dev->chain_name);
+	free(dev->chain_id);
+	free(dev->name);
+	ctlv_ops_free(dev->sizes);
+	if (dev->fd >= 0 && dev->owns_fd)
+		close(dev->fd);
+	free(dev);
+}
+
+/* @fd's device, whose family chain it is asked for over that same fd. */
+static int dev_attach(const char *name, int fd, bool owns_fd,
+		      struct ctlv_dev **devp)
+{
+	struct ctlv_dev *dev;
+	int ret;
+
+	dev = calloc(1, sizeof(*dev));
+	if (!dev) {
+		if (owns_fd)
+			close(fd);
+		return -ENOMEM;
+	}
+	dev->fd = fd;
+	dev->owns_fd = owns_fd;
+	ret = name_dup(name, &dev->name);
+	if (!ret)
+		ret = ctlv_chain_load(dev);
+	if (ret) {
+		dev_free(dev);
+		return ret;
+	}
+	*devp = dev;
+	return 0;
+}
+
+static int dev_open(const char *name, const char *path, int flags,
+		    struct ctlv_dev **devp)
+{
+	int fd = open(path, flags | O_CLOEXEC);
+
+	if (fd < 0)
+		return -errno;
+	return dev_attach(name, fd, true, devp);
+}
+
+int ctlv_open_path(const char *path, int flags, struct ctlv_dev **devp)
+{
+	const char *name = strrchr(path, '/');
+
+	return dev_open(name ? name + 1 : path, path, flags, devp);
+}
+
+int ctlv_open_fd(int fd, struct ctlv_dev **devp)
+{
+	char link[PATH_LEN], target[PATH_LEN];
+	const char *name = target;
+	ssize_t len;
+
+	if (fd < 0)
+		return -EBADF;
+	/* Named for messages only, after the file if /proc can say which. */
+	snprintf(link, sizeof(link), "/proc/self/fd/%d", fd);
+	len = readlink(link, target, sizeof(target) - 1);
+	if (len < 0) {
+		snprintf(target, sizeof(target), "fd%d", fd);
+	} else {
+		target[len] = '\0';
+		if (strrchr(target, '/'))
+			name = strrchr(target, '/') + 1;
+	}
+	return dev_attach(name, fd, false, devp);
+}
+
+/*
+ * The @which'th device of @family, matched against its registered family
+ * rather than any it inherits.
+ */
+int ctlv_open(const char *family, unsigned int which, int flags,
+	      struct ctlv_dev **devp)
+{
+	char path[PATH_LEN];
+	struct ctlv_dev_list list;
+	int ret;
+
+	ret = dev_scan(&list, family);
+	if (ret)
+		return ret;
+	ret = -ENODEV;
+	if (which < list.names_count) {
+		snprintf(path, sizeof(path), "%s/%s", DEV_DIR,
+			 list.names[which]);
+		ret = dev_open(list.names[which], path, flags, devp);
+	}
+	ctlv_dev_list_free(&list);
+	return ret;
+}
+
+void ctlv_close(struct ctlv_dev *dev)
+{
+	if (dev)
+		dev_free(dev);
+}
+
+int ctlv_dev_fd(const struct ctlv_dev *dev)
+{
+	return dev->fd;
+}
+
+const char *ctlv_dev_name(const struct ctlv_dev *dev)
+{
+	return dev->name;
+}
+
+unsigned int ctlv_chain_len(const struct ctlv_dev *dev)
+{
+	return dev->chain_len;
+}
+
+__u16 ctlv_chain_id(const struct ctlv_dev *dev, unsigned int level)
+{
+	return level < dev->chain_len ? dev->chain_id[level] : 0;
+}
+
+const char *ctlv_chain_name(const struct ctlv_dev *dev, unsigned int level)
+{
+	return level < dev->chain_len ? dev->chain_name[level] : NULL;
+}
+
+const char *ctlv_dev_family(const struct ctlv_dev *dev)
+{
+	return ctlv_chain_name(dev, dev->chain_len - 1);
+}
+
+bool ctlv_dev_inherits(const struct ctlv_dev *dev, const char *family)
+{
+	unsigned int i;
+
+	for (i = 0; i < dev->chain_len; i++)
+		if (!strcmp(dev->chain_name[i], family))
+			return true;
+	return false;
+}
+
+/*
+ * The dump is taken once: its lengths follow from the schema and cannot go out
+ * of date.
+ */
+const struct ctlv_ops *ctlv_dev_sizes(struct ctlv_dev *dev)
+{
+	if (!dev->sizes && ctlv_ops_get(dev, &dev->sizes, NULL))
+		return NULL;
+	return dev->sizes;
+}
+
+/* What one op answers with, for the two calls that were not told. */
+static const struct ctlv_op_info *op_sizes(struct ctlv_dev *dev, __u64 op_id)
+{
+	const struct ctlv_ops *sizes = ctlv_dev_sizes(dev);
+
+	return sizes ? ctlv_ops_find(sizes, op_id) : NULL;
+}
+
+/*
+ * Room for a refusal's error information as well: an action cannot be retried
+ * into a larger buffer the way a query can, it has happened.
+ */
+int ctlv_action(struct ctlv_dev *dev, __u64 op_id, struct ctlv_msg *request,
+		struct ctlv_reply **replyp, struct ctlv_error *error)
+{
+	const struct ctlv_op_info *info = op_sizes(dev, op_id);
+	__u64 reply_len = 0;
+
+	if (info) {
+		reply_len = info->action_reply_max_len;
+		if (reply_len < info->error_info_max_len)
+			reply_len = info->error_info_max_len;
+	}
+	return ctlv_action_sized(dev, op_id, request, reply_len, replyp,
+				 error);
+}
+
+/*
+ * A dump that went stale is started again, the fragments of two answers not
+ * being an answer. A caller wanting the -ESTALE instead asks for a size.
+ */
+int ctlv_query(struct ctlv_dev *dev, __u64 op_id, struct ctlv_msg *request,
+	       struct ctlv_reply **replyp, struct ctlv_error *error)
+{
+	const struct ctlv_op_info *info = op_sizes(dev, op_id);
+	__u32 buf_len = 0;
+	unsigned int try;
+	int ret;
+
+	if (info)
+		buf_len = info->query_reply_suggested_len;
+	for (try = 0; try < QUERY_RESTARTS; try++) {
+		ret = ctlv_query_sized(dev, op_id, request, buf_len, replyp,
+				       error);
+		if (ret != -ESTALE)
+			return ret;
+	}
+	return ret;
+}
diff --git a/tools/ctlv/libctlv/internal.h b/tools/ctlv/libctlv/internal.h
new file mode 100644
index 000000000000..ff3553561ac6
--- /dev/null
+++ b/tools/ctlv/libctlv/internal.h
@@ -0,0 +1,161 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/*
+ * Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Private libctlv declarations.
+ */
+#ifndef _CTLV_INTERNAL_H
+#define _CTLV_INTERNAL_H
+
+#include <errno.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "ctlv.h"
+
+#define CTLV_ARRAY_SIZE(_a) (sizeof(_a) / sizeof((_a)[0]))
+
+/*
+ * How many times a query is started over when the answer changed underneath
+ * it. More than this is a device changing faster than it can be described.
+ */
+#define QUERY_RESTARTS 8
+
+/*
+ * The deepest level a message may reach, the root at depth zero. No device
+ * goes deeper today, so a message that does is malformed.
+ */
+#define CTLV_RECORD_DEPTH_MAX 32
+
+/* The root is at depth zero, hence one more than the levels below it. */
+#define CTLV_DEPTH_MAX (CTLV_RECORD_DEPTH_MAX + 1)
+
+/* Stops a runaway builder: no device today takes a longer request. */
+#define CTLV_REQUEST_LEN_MAX 0x10000
+
+/*
+ * Reassembly needs a bound of its own, a query reply not being held to the
+ * inline limit. A message cannot describe more anyway: a record's length is
+ * u32.
+ */
+#define CTLV_REPLY_LEN_MAX (64U << 20)
+
+/* Bounds the cursor history retained for one query. */
+#define CTLV_QUERY_FRAGMENTS_MAX (64U << 10)
+
+/**
+ * struct ctlv_msg - One message being written.
+ * @buf: the bytes, grown as needed and aligned as a root must be
+ * @capacity: how much @buf holds
+ * @max: how far @capacity may grow before appending fails
+ * @len: how much of it is written
+ * @open: offsets of the record headers not yet ended, the root first
+ * @depth: how many of those there are
+ * @last: offset of the TLV written last, or of a record just ended; zero while
+ *	that is the root, which no per-TLV choice applies to
+ * @err: the first failure since the last reset
+ *
+ * A TLV is tracked by offset because a record's length is only known once its
+ * children are written, and because growing @buf moves it.
+ */
+struct ctlv_msg {
+	__u8 *buf;
+	__u32 capacity;
+	__u32 max;
+	__u32 len;
+	__u32 open[CTLV_DEPTH_MAX];
+	unsigned int depth;
+	__u32 last;
+	int err;
+};
+
+int ctlv_msg_new_max(__u32 capacity, __u32 max, struct ctlv_msg **msgp);
+int ctlv_msg_put(struct ctlv_msg *msg, __u64 type, __u32 flags,
+		 const void *payload, __u32 len);
+/* Appends a copy of one TLV, header and payload, without its flags. */
+int ctlv_msg_copy(struct ctlv_msg *msg, const struct ctlv_hdr *hdr);
+
+struct ctlv_frag_path {
+	__u64 type[CTLV_RECORD_DEPTH_MAX];
+	unsigned int depth;
+};
+
+int ctlv_frag_splice(struct ctlv_msg *out, const struct ctlv_hdr *root,
+		     struct ctlv_frag_path *open, bool *progress);
+
+struct ctlv_query_guard {
+	__u64 *cursors;
+	unsigned int cursors_capacity;
+	unsigned int cursors_count;
+};
+
+int ctlv_query_guard_next(struct ctlv_query_guard *guard, __u64 cursor,
+			  bool progress);
+void ctlv_query_guard_free(struct ctlv_query_guard *guard);
+
+/**
+ * struct ctlv_dev - One open device.
+ * @fd: the character device
+ * @owns_fd: whether ctlv_close() closes @fd
+ * @name: what it is called under /dev
+ * @chain_len: how many families it answers
+ * @chain_id: their registry IDs, the root first
+ * @chain_name: their names, in the same order
+ * @sizes: one ops dump, kept for the message lengths it reports
+ *
+ * @sizes is filled the first time a length is needed and was not named, and
+ * only its length members are read: they cannot go out of date.
+ */
+struct ctlv_dev {
+	int fd;
+	bool owns_fd;
+	char *name;
+	unsigned int chain_len;
+	__u16 *chain_id;
+	char **chain_name;
+	struct ctlv_ops *sizes;
+};
+
+/**
+ * struct ctlv_reply - One complete answer.
+ * @msg: the reassembled message, whose root is the reply's
+ * @generation: what the device reported the answer belongs to
+ * @fragments: how many ioctls it took
+ */
+struct ctlv_reply {
+	struct ctlv_msg *msg;
+	__u64 generation;
+	unsigned int fragments;
+};
+
+/**
+ * struct ctlv_schema - One op's trees and their node schemas.
+ * @node_schemas: every node schema of both trees, owned as one allocation
+ * @node_schemas_count: number of node schemas
+ * @request: the root of the request tree, or NULL
+ * @reply: the root of the reply tree, or NULL
+ */
+struct ctlv_schema {
+	struct ctlv_node_schema *node_schemas;
+	unsigned int node_schemas_count;
+	const struct ctlv_node_schema *request;
+	const struct ctlv_node_schema *reply;
+};
+
+void ctlv_error_clear(struct ctlv_error *error);
+void ctlv_error_set(struct ctlv_error *error, int err);
+/* Reads whatever error information a failed op wrote into the reply buffer. */
+void ctlv_error_parse(struct ctlv_error *error, int err, const void *buf,
+		      __u32 len);
+
+int ctlv_chain_load(struct ctlv_dev *dev);
+/* @dev's @sizes, dumped on first use; NULL when the dump failed. */
+const struct ctlv_ops *ctlv_dev_sizes(struct ctlv_dev *dev);
+int ctlv_bootstrap_validate(const void *buf, __u32 len, __u64 op_id);
+int ctlv_schema_parse(const struct ctlv_hdr *root, __u32 len,
+		      struct ctlv_schema **sp);
+int ctlv_ops_parse(const struct ctlv_hdr *root, __u32 len,
+		   __u64 generation, struct ctlv_ops **opsp);
+
+#endif /* _CTLV_INTERNAL_H */
diff --git a/tools/ctlv/libctlv/introspection.c b/tools/ctlv/libctlv/introspection.c
new file mode 100644
index 000000000000..1bd2662e5831
--- /dev/null
+++ b/tools/ctlv/libctlv/introspection.c
@@ -0,0 +1,238 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Root-family introspection.
+ */
+
+#include "internal.h"
+
+enum op_info_ctype {
+	OP_INFO_U32 = 0,
+	OP_INFO_U64 = 1,
+	OP_INFO_BOOL = 2,
+};
+
+enum op_info_type {
+	OP_INFO_ACTION = 1,
+	OP_INFO_QUERY = 2,
+};
+
+static int op_info_read(struct ctlv_op_info *info,
+			const struct ctlv_hdr *entry)
+{
+	static const struct {
+		__u64 type;
+		size_t offset;
+		unsigned int applies;
+		enum op_info_ctype ctype;
+	} fields[] = {
+		{ CTLV_T_OP_GET_OPS_FD_ACCESS,
+		  offsetof(struct ctlv_op_info, fd_access),
+		  OP_INFO_ACTION | OP_INFO_QUERY, OP_INFO_U32 },
+		{ CTLV_T_OP_GET_OPS_AVAILABILITY,
+		  offsetof(struct ctlv_op_info, availability),
+		  OP_INFO_ACTION | OP_INFO_QUERY, OP_INFO_U32 },
+		{ CTLV_T_OP_GET_OPS_DISABLED,
+		  offsetof(struct ctlv_op_info, disabled),
+		  OP_INFO_ACTION | OP_INFO_QUERY, OP_INFO_BOOL },
+		{ CTLV_T_OP_GET_OPS_REQUEST_MAX_LEN,
+		  offsetof(struct ctlv_op_info, request_max_len),
+		  OP_INFO_ACTION | OP_INFO_QUERY, OP_INFO_U64 },
+		{ CTLV_T_OP_GET_OPS_ACTION_REPLY_MAX_LEN,
+		  offsetof(struct ctlv_op_info, action_reply_max_len),
+		  OP_INFO_ACTION, OP_INFO_U64 },
+		{ CTLV_T_OP_GET_OPS_QUERY_REPLY_MIN_LEN,
+		  offsetof(struct ctlv_op_info, query_reply_min_len),
+		  OP_INFO_QUERY, OP_INFO_U64 },
+		{ CTLV_T_OP_GET_OPS_QUERY_REPLY_SUGGESTED_LEN,
+		  offsetof(struct ctlv_op_info, query_reply_suggested_len),
+		  OP_INFO_QUERY, OP_INFO_U64 },
+		{ CTLV_T_OP_GET_OPS_ERROR_INFO_MAX_LEN,
+		  offsetof(struct ctlv_op_info, error_info_max_len),
+		  OP_INFO_ACTION | OP_INFO_QUERY, OP_INFO_U64 },
+	};
+	const struct ctlv_hdr *hdr;
+	unsigned int applies = 0;
+	unsigned int i;
+	__u64 value;
+	bool boolean;
+
+	hdr = ctlv_hdr_find(entry, CTLV_T_OP_GET_OPS_ID);
+	if (!hdr || ctlv_get_u64(hdr, &info->op_id))
+		return -EPROTO;
+	hdr = ctlv_hdr_find(entry, CTLV_T_OP_GET_OPS_TYPE);
+	if (!hdr || ctlv_get_u64(hdr, &value) || value > UINT32_MAX)
+		return -EPROTO;
+	info->type = value;
+	if (value == CTLV_OP_TYPE_ACTION)
+		applies = OP_INFO_ACTION;
+	else if (value == CTLV_OP_TYPE_QUERY)
+		applies = OP_INFO_QUERY;
+
+	for (i = 0; i < CTLV_ARRAY_SIZE(fields); i++) {
+		hdr = ctlv_hdr_find(entry, fields[i].type);
+		if (applies && !!hdr != !!(fields[i].applies & applies))
+			return -EPROTO;
+		if (!hdr)
+			continue;
+		if (fields[i].ctype == OP_INFO_BOOL) {
+			if (ctlv_get_bool(hdr, &boolean))
+				return -EPROTO;
+			*(bool *)((char *)info + fields[i].offset) = boolean;
+			continue;
+		}
+		if (ctlv_get_u64(hdr, &value))
+			return -EPROTO;
+		if (fields[i].ctype == OP_INFO_U32) {
+			if (value > UINT32_MAX)
+				return -EPROTO;
+			*(__u32 *)((char *)info + fields[i].offset) = value;
+		} else {
+			*(__u64 *)((char *)info + fields[i].offset) = value;
+		}
+	}
+	if ((applies & (OP_INFO_ACTION | OP_INFO_QUERY)) &&
+	    info->availability == CTLV_OP_AVAILABILITY_FIXED &&
+	    info->disabled)
+		return -EPROTO;
+	if (applies == OP_INFO_QUERY &&
+	    info->query_reply_suggested_len < info->query_reply_min_len)
+		return -EPROTO;
+	return 0;
+}
+
+static int op_id_compare(const void *left, const void *right)
+{
+	const __u64 *a = left;
+	const __u64 *b = right;
+
+	return (*a > *b) - (*a < *b);
+}
+
+int ctlv_ops_parse(const struct ctlv_hdr *root, __u32 len,
+		   __u64 generation, struct ctlv_ops **opsp)
+{
+	const struct ctlv_hdr *entry;
+	struct ctlv_ops *ops;
+	__u64 *ids = NULL;
+	unsigned int i;
+	unsigned int n = 0;
+	int ret;
+
+	ret = ctlv_bootstrap_validate(root, len, CTLV_OP_OP_GET);
+	if (ret)
+		return ret;
+
+	ops = calloc(1, sizeof(*ops));
+	if (!ops)
+		return -ENOMEM;
+	n = ctlv_hdr_count(root, CTLV_T_OP_GET_OPS);
+	if (n) {
+		ops->ops = calloc(n, sizeof(*ops->ops));
+		if (!ops->ops) {
+			ret = -ENOMEM;
+			goto out_free_ops;
+		}
+		ids = calloc(n, sizeof(*ids));
+		if (!ids) {
+			ret = -ENOMEM;
+			goto out_free_op;
+		}
+	}
+	ctlv_for_each_type(entry, root, CTLV_T_OP_GET_OPS) {
+		ret = op_info_read(&ops->ops[ops->ops_count], entry);
+		if (ret)
+			goto out_free_ids;
+		ids[ops->ops_count] = ops->ops[ops->ops_count].op_id;
+		ops->ops_count++;
+	}
+	if (n > 1)
+		qsort(ids, n, sizeof(*ids), op_id_compare);
+	for (i = 1; i < n; i++) {
+		if (ids[i] == ids[i - 1]) {
+			ret = -EPROTO;
+			goto out_free_ids;
+		}
+	}
+	free(ids);
+	ops->generation = generation;
+
+	*opsp = ops;
+	return 0;
+
+out_free_ids:
+	free(ids);
+out_free_op:
+	free(ops->ops);
+out_free_ops:
+	free(ops);
+	return ret;
+}
+
+int ctlv_ops_get(struct ctlv_dev *dev, struct ctlv_ops **opsp,
+		 struct ctlv_error *error)
+{
+	struct ctlv_reply *reply = NULL;
+	int ret;
+
+	/* Sized, or the dump kept for op lengths would ask for itself. */
+	ret = ctlv_query_sized(dev, CTLV_OP_OP_GET, NULL, 0, &reply, error);
+	if (ret)
+		return ret;
+
+	ret = ctlv_ops_parse(ctlv_reply_root(reply), reply->msg->len,
+			     ctlv_reply_generation(reply), opsp);
+	if (ret)
+		ctlv_error_set(error, ret);
+	ctlv_reply_free(reply);
+	return ret;
+}
+
+void ctlv_ops_free(struct ctlv_ops *ops)
+{
+	if (!ops)
+		return;
+	free(ops->ops);
+	free(ops);
+}
+
+const struct ctlv_op_info *ctlv_ops_find(const struct ctlv_ops *ops,
+					 __u64 op_id)
+{
+	unsigned int i;
+
+	if (!ops)
+		return NULL;
+	for (i = 0; i < ops->ops_count; i++)
+		if (ops->ops[i].op_id == op_id)
+			return &ops->ops[i];
+	return NULL;
+}
+
+int ctlv_op_schema_get(struct ctlv_dev *dev, __u64 op_id,
+		       struct ctlv_schema **schemap, struct ctlv_error *error)
+{
+	struct ctlv_reply *reply = NULL;
+	struct ctlv_msg *request;
+	int ret;
+
+	ret = ctlv_msg_new(64, &request);
+	if (ret) {
+		ctlv_error_set(error, ret);
+		return ret;
+	}
+	ctlv_put_u64(request, CTLV_T_OP_SCHEMA_GET_ID, op_id);
+
+	ret = ctlv_query(dev, CTLV_OP_OP_SCHEMA_GET, request, &reply, error);
+	ctlv_msg_free(request);
+	if (ret)
+		return ret;
+
+	ret = ctlv_schema_parse(ctlv_reply_root(reply), reply->msg->len,
+				schemap);
+	if (ret)
+		ctlv_error_set(error, ret);
+	ctlv_reply_free(reply);
+	return ret;
+}
diff --git a/tools/ctlv/libctlv/message.c b/tools/ctlv/libctlv/message.c
new file mode 100644
index 000000000000..ab4464fb8af2
--- /dev/null
+++ b/tools/ctlv/libctlv/message.c
@@ -0,0 +1,518 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * CTLV message builder and parser.
+ */
+
+#include <stdint.h>
+
+#include "internal.h"
+
+/* The TLV alignment applied to a length that may be close to overflowing. */
+static int aligned(__u32 len, __u32 *out)
+{
+	if (len > UINT32_MAX - (CTLV_ALIGNTO - 1))
+		return -EMSGSIZE;
+	*out = CTLV_ALIGN(len);
+	return 0;
+}
+
+static int msg_room(struct ctlv_msg *msg, __u32 need)
+{
+	__u32 capacity = msg->capacity;
+	__u8 *buf;
+
+	if (need > msg->max - msg->len)
+		return -EMSGSIZE;
+	need += msg->len;
+	if (need <= capacity)
+		return 0;
+	while (capacity < need) {
+		if (capacity > msg->max / 2) {
+			capacity = msg->max;
+			break;
+		}
+		capacity *= 2;
+	}
+	buf = realloc(msg->buf, capacity);
+	if (!buf)
+		return -ENOMEM;
+	msg->buf = buf;
+	msg->capacity = capacity;
+	return 0;
+}
+
+/* Zeroes up to the next TLV boundary; a message's padding is zero. */
+static int msg_pad(struct ctlv_msg *msg)
+{
+	__u32 padded;
+	int ret;
+
+	ret = aligned(msg->len, &padded);
+	if (ret)
+		return ret;
+	ret = msg_room(msg, padded - msg->len);
+	if (ret)
+		return ret;
+	memset(msg->buf + msg->len, 0, padded - msg->len);
+	msg->len = padded;
+	return 0;
+}
+
+static struct ctlv_hdr *msg_hdr(struct ctlv_msg *msg, __u32 offset)
+{
+	return (struct ctlv_hdr *)(msg->buf + offset);
+}
+
+/* One TLV at the next boundary; a writer holding an error appends none. */
+int ctlv_msg_put(struct ctlv_msg *msg, __u64 type, __u32 flags,
+		 const void *payload, __u32 len)
+{
+	struct ctlv_hdr hdr = {
+		.flags = flags,
+		.type = type,
+	};
+	int ret;
+
+	if (msg->err)
+		return msg->err;
+	if (len > UINT32_MAX - sizeof(hdr)) {
+		msg->err = -EMSGSIZE;
+		return msg->err;
+	}
+	hdr.len = sizeof(hdr) + len;
+
+	ret = msg_pad(msg);
+	if (!ret)
+		ret = msg_room(msg, hdr.len);
+	if (ret) {
+		msg->err = ret;
+		return ret;
+	}
+	msg->last = msg->len;
+	memcpy(msg->buf + msg->len, &hdr, sizeof(hdr));
+	msg->len += sizeof(hdr);
+	if (len) {
+		memcpy(msg->buf + msg->len, payload, len);
+		msg->len += len;
+	}
+	return 0;
+}
+
+int ctlv_msg_copy(struct ctlv_msg *msg, const struct ctlv_hdr *hdr)
+{
+	return ctlv_msg_put(msg, hdr->type,
+			    hdr->flags & ~CTLV_HDR_F_FRAG_MORE, hdr + 1,
+			    hdr->len - sizeof(*hdr));
+}
+
+int ctlv_msg_new_max(__u32 capacity, __u32 max, struct ctlv_msg **msgp)
+{
+	struct ctlv_msg *msg;
+
+	if (!capacity || capacity > max)
+		return -EINVAL;
+	msg = calloc(1, sizeof(*msg));
+	if (!msg)
+		return -ENOMEM;
+	/* Separate from the handle, so growing the buffer does not move it. */
+	msg->buf = malloc(capacity);
+	if (!msg->buf) {
+		free(msg);
+		return -ENOMEM;
+	}
+	msg->capacity = capacity;
+	msg->max = max;
+	*msgp = msg;
+	return ctlv_record_start(msg, CTLV_TYPE_ROOT);
+}
+
+int ctlv_msg_new(__u32 capacity, struct ctlv_msg **msgp)
+{
+	return ctlv_msg_new_max(capacity, CTLV_REQUEST_LEN_MAX, msgp);
+}
+
+void ctlv_msg_free(struct ctlv_msg *msg)
+{
+	if (!msg)
+		return;
+	free(msg->buf);
+	free(msg);
+}
+
+void ctlv_msg_reset(struct ctlv_msg *msg)
+{
+	msg->len = 0;
+	msg->depth = 0;
+	msg->last = 0;
+	msg->err = 0;
+	ctlv_record_start(msg, CTLV_TYPE_ROOT);
+}
+
+int ctlv_msg_err(const struct ctlv_msg *msg)
+{
+	return msg->err;
+}
+
+int ctlv_record_start(struct ctlv_msg *msg, __u64 type)
+{
+	__u32 offset;
+	int ret;
+
+	if (msg->err)
+		return msg->err;
+	if (msg->depth == CTLV_DEPTH_MAX) {
+		msg->err = -ELOOP;
+		return msg->err;
+	}
+	/* Pad first, so the saved offset is where the header lands. */
+	ret = msg_pad(msg);
+	if (ret) {
+		msg->err = ret;
+		return ret;
+	}
+	offset = msg->len;
+	ret = ctlv_msg_put(msg, type, CTLV_HDR_F_RECORD, NULL, 0);
+	if (ret)
+		return ret;
+	msg->open[msg->depth++] = offset;
+	return 0;
+}
+
+/* A record counts the padding of its last child, so a walk steps aligned. */
+int ctlv_record_end(struct ctlv_msg *msg)
+{
+	int ret;
+
+	if (msg->err)
+		return msg->err;
+	if (!msg->depth) {
+		msg->err = -EINVAL;
+		return msg->err;
+	}
+	ret = msg_pad(msg);
+	if (ret) {
+		msg->err = ret;
+		return ret;
+	}
+	msg->depth--;
+	msg_hdr(msg, msg->open[msg->depth])->len =
+		msg->len - msg->open[msg->depth];
+	/* A closed record is the TLV a per-TLV choice now applies to. */
+	msg->last = msg->open[msg->depth];
+	return 0;
+}
+
+/*
+ * The bit is a per-occurrence choice, so it belongs to a call of its own after
+ * whatever wrote the TLV, a generated putter included.
+ */
+int ctlv_msg_ignore_if_unknown(struct ctlv_msg *msg)
+{
+	if (msg->err)
+		return msg->err;
+	/* The root frames the message and is nothing a device may skip. */
+	if (!msg->last) {
+		msg->err = -EINVAL;
+		return msg->err;
+	}
+	msg_hdr(msg, msg->last)->flags |= CTLV_HDR_F_IGNORE_IF_UNKNOWN;
+	return 0;
+}
+
+int ctlv_msg_done(struct ctlv_msg *msg)
+{
+	while (msg->depth && !msg->err)
+		ctlv_record_end(msg);
+	return msg->err;
+}
+
+const struct ctlv_hdr *ctlv_msg_root(const struct ctlv_msg *msg)
+{
+	return (const struct ctlv_hdr *)msg->buf;
+}
+
+__u32 ctlv_msg_len(const struct ctlv_msg *msg)
+{
+	return msg->len;
+}
+
+int ctlv_put_u64(struct ctlv_msg *msg, __u64 type, __u64 value)
+{
+	return ctlv_msg_put(msg, type, 0, &value, sizeof(value));
+}
+
+int ctlv_put_s64(struct ctlv_msg *msg, __u64 type, __s64 value)
+{
+	return ctlv_msg_put(msg, type, 0, &value, sizeof(value));
+}
+
+int ctlv_put_bool(struct ctlv_msg *msg, __u64 type, bool value)
+{
+	__u8 byte = value;
+
+	return ctlv_msg_put(msg, type, 0, &byte, sizeof(byte));
+}
+
+/* The terminator is part of the payload, and a declared length excludes it. */
+int ctlv_put_str(struct ctlv_msg *msg, __u64 type, const char *value)
+{
+	size_t len = strlen(value) + 1;
+
+	if (len > UINT32_MAX)
+		return -EMSGSIZE;
+	return ctlv_msg_put(msg, type, 0, value, len);
+}
+
+int ctlv_put_bin(struct ctlv_msg *msg, __u64 type, const void *value,
+		 __u32 len)
+{
+	return ctlv_msg_put(msg, type, 0, value, len);
+}
+
+/* A blob TLV carries a record of core members, chosen by the backing. */
+int ctlv_put_blob_va(struct ctlv_msg *msg, __u64 type, const void *address,
+		     __u64 length)
+{
+	ctlv_record_start(msg, type);
+	ctlv_put_u64(msg, CTLV_T_BLOB_TYPE, CTLV_BLOB_TYPE_VA);
+	ctlv_put_u64(msg, CTLV_T_BLOB_ADDRESS, (__u64)(uintptr_t)address);
+	ctlv_put_u64(msg, CTLV_T_BLOB_LENGTH, length);
+	return ctlv_record_end(msg);
+}
+
+bool ctlv_hdr_is_record(const struct ctlv_hdr *hdr)
+{
+	return hdr->flags & CTLV_HDR_F_RECORD;
+}
+
+__u32 ctlv_hdr_payload_len(const struct ctlv_hdr *hdr)
+{
+	return hdr->len - sizeof(*hdr);
+}
+
+const void *ctlv_hdr_payload(const struct ctlv_hdr *hdr, __u32 *len)
+{
+	if (len)
+		*len = ctlv_hdr_payload_len(hdr);
+	return hdr + 1;
+}
+
+const struct ctlv_hdr *ctlv_hdr_first(const struct ctlv_hdr *record)
+{
+	if (record->len <= sizeof(*record))
+		return NULL;
+	/* A record too short to hold the header it announces holds no child. */
+	if (record->len - sizeof(*record) < sizeof(*record))
+		return NULL;
+	return record + 1;
+}
+
+/*
+ * The next child is a step of this one's aligned length. Both the step and the
+ * header it lands on have to stay inside the record.
+ */
+const struct ctlv_hdr *ctlv_hdr_next(const struct ctlv_hdr *record,
+				     const struct ctlv_hdr *child)
+{
+	const char *end = (const char *)record + record->len;
+	const char *next = (const char *)child;
+	__u32 step;
+
+	if (aligned(child->len, &step))
+		return NULL;
+	next += step;
+	if (next < (const char *)child || next > end)
+		return NULL;
+	if ((size_t)(end - next) < sizeof(*child))
+		return NULL;
+	return (const struct ctlv_hdr *)next;
+}
+
+const struct ctlv_hdr *ctlv_hdr_find(const struct ctlv_hdr *record,
+				     __u64 type)
+{
+	const struct ctlv_hdr *child;
+
+	ctlv_for_each(child, record)
+		if (child->type == type)
+			return child;
+	return NULL;
+}
+
+const struct ctlv_hdr *ctlv_hdr_find_next(const struct ctlv_hdr *record,
+					  const struct ctlv_hdr *hdr,
+					  __u64 type)
+{
+	while ((hdr = ctlv_hdr_next(record, hdr)))
+		if (hdr->type == type)
+			return hdr;
+	return NULL;
+}
+
+unsigned int ctlv_hdr_count(const struct ctlv_hdr *record, __u64 type)
+{
+	const struct ctlv_hdr *child;
+	unsigned int n = 0;
+
+	ctlv_for_each(child, record)
+		if (child->type == type)
+			n++;
+	return n;
+}
+
+/*
+ * Framing, checked before anything reads it: a message that fails this is not
+ * walked, which is what lets the walkers above trust the lengths they step.
+ */
+static int check_record(const struct ctlv_hdr *record, unsigned int depth)
+{
+	const char *p = (const char *)(record + 1);
+	const char *end = (const char *)record + record->len;
+
+	if (depth >= CTLV_DEPTH_MAX)
+		return -ELOOP;
+	while (p < end) {
+		const struct ctlv_hdr *child = (const struct ctlv_hdr *)p;
+		__u32 step;
+		int ret;
+
+		if ((size_t)(end - p) < sizeof(*child))
+			return -EBADMSG;
+		if (child->len < sizeof(*child))
+			return -EBADMSG;
+		if (child->len > (__u32)(end - p))
+			return -EBADMSG;
+		if (child->flags & CTLV_HDR_F_RECORD) {
+			ret = check_record(child, depth + 1);
+			if (ret)
+				return ret;
+		}
+		ret = aligned(child->len, &step);
+		if (ret)
+			return ret;
+		/* Padding is in the record, so the step lands on its end. */
+		if (step > (__u32)(end - p))
+			return -EBADMSG;
+		p += step;
+	}
+	return 0;
+}
+
+int ctlv_msg_check(const void *buf, __u32 len)
+{
+	const struct ctlv_hdr *root = buf;
+
+	if (len < sizeof(*root))
+		return -EBADMSG;
+	if (root->type != CTLV_TYPE_ROOT)
+		return -EBADMSG;
+	if (!(root->flags & CTLV_HDR_F_RECORD))
+		return -EBADMSG;
+	if (root->len < sizeof(*root) || root->len > len)
+		return -EBADMSG;
+	return check_record(root, 0);
+}
+
+/*
+ * A scalar payload is eight bytes in a message whatever it holds, so another
+ * width is a corrupt message rather than something to interpret.
+ */
+static int get_scalar(const struct ctlv_hdr *hdr, __u64 *value)
+{
+	__u64 raw;
+
+	if (ctlv_hdr_is_record(hdr))
+		return -EINVAL;
+	if (ctlv_hdr_payload_len(hdr) != sizeof(raw))
+		return -EBADMSG;
+	memcpy(&raw, hdr + 1, sizeof(raw));
+	*value = raw;
+	return 0;
+}
+
+int ctlv_get_u64(const struct ctlv_hdr *hdr, __u64 *value)
+{
+	return get_scalar(hdr, value);
+}
+
+int ctlv_get_s64(const struct ctlv_hdr *hdr, __s64 *value)
+{
+	__u64 raw;
+	int ret;
+
+	ret = get_scalar(hdr, &raw);
+	if (ret)
+		return ret;
+	*value = (__s64)raw;
+	return 0;
+}
+
+int ctlv_get_bool(const struct ctlv_hdr *hdr, bool *value)
+{
+	const __u8 *byte;
+
+	if (ctlv_hdr_is_record(hdr))
+		return -EINVAL;
+	if (ctlv_hdr_payload_len(hdr) != sizeof(*byte))
+		return -EBADMSG;
+	byte = (const __u8 *)(hdr + 1);
+	if (*byte > 1)
+		return -EBADMSG;
+	*value = *byte;
+	return 0;
+}
+
+int ctlv_get_str(const struct ctlv_hdr *hdr, const char **value)
+{
+	const char *str = (const char *)(hdr + 1);
+	__u32 len = ctlv_hdr_payload_len(hdr);
+
+	if (ctlv_hdr_is_record(hdr))
+		return -EINVAL;
+	if (!len || str[len - 1] != '\0')
+		return -EBADMSG;
+	*value = str;
+	return 0;
+}
+
+int ctlv_get_bin(const struct ctlv_hdr *hdr, const void **value, __u32 *len)
+{
+	if (ctlv_hdr_is_record(hdr))
+		return -EINVAL;
+	*value = hdr + 1;
+	if (len)
+		*len = ctlv_hdr_payload_len(hdr);
+	return 0;
+}
+
+/*
+ * Neither refuses a value from a device newer than its caller: dropping the
+ * reply would make every added value an ABI break.
+ */
+int ctlv_get_enum(const struct ctlv_hdr *hdr, __u64 min, __u64 max,
+		  __u64 *value, bool *known)
+{
+	int ret;
+
+	ret = get_scalar(hdr, value);
+	if (ret)
+		return ret;
+	if (known)
+		*known = *value >= min && *value <= max;
+	return 0;
+}
+
+int ctlv_get_flags(const struct ctlv_hdr *hdr, __u64 mask, __u64 *value,
+		   __u64 *unknown)
+{
+	int ret;
+
+	ret = get_scalar(hdr, value);
+	if (ret)
+		return ret;
+	if (unknown)
+		*unknown = *value & ~mask;
+	return 0;
+}
diff --git a/tools/ctlv/libctlv/schema.c b/tools/ctlv/libctlv/schema.c
new file mode 100644
index 000000000000..cd68d237b568
--- /dev/null
+++ b/tools/ctlv/libctlv/schema.c
@@ -0,0 +1,742 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Numeric schema parsing and comparison.
+ */
+
+#include <limits.h>
+#include <stddef.h>
+#include <stdarg.h>
+#include <stdio.h>
+
+#include "internal.h"
+
+struct validate {
+	const struct ctlv_node_schema *node[CTLV_DEPTH_MAX];
+};
+
+static const struct ctlv_node_schema *
+schema_member(const struct ctlv_node_schema *parent, __u64 type)
+{
+	unsigned int i;
+
+	for (i = 0; i < parent->fields_count; i++)
+		if (parent->fields[i].type == type)
+			return &parent->fields[i];
+	for (i = 0; i < parent->optional_fields_count; i++)
+		if (parent->optional_fields[i].type == type)
+			return &parent->optional_fields[i];
+	return NULL;
+}
+
+static int schema_members(const struct ctlv_hdr *record,
+			  const struct ctlv_node_schema *parent)
+{
+	const struct ctlv_node_schema *child;
+	unsigned int count;
+	unsigned int i;
+
+	for (i = 0; i < parent->fields_count; i++) {
+		child = &parent->fields[i];
+		count = ctlv_hdr_count(record, child->type);
+		if (!count)
+			return -EPROTO;
+		if (child->max_occurrences &&
+		    count > child->max_occurrences)
+			return -EPROTO;
+	}
+	for (i = 0; i < parent->optional_fields_count; i++) {
+		child = &parent->optional_fields[i];
+		count = ctlv_hdr_count(record, child->type);
+		if (child->max_occurrences &&
+		    count > child->max_occurrences)
+			return -EPROTO;
+	}
+	return 0;
+}
+
+static bool schema_length_ok(const struct ctlv_node_schema *node, __u64 len)
+{
+	if ((node->present & CTLV_NODE_SCHEMA_HAS_MIN_LENGTH) &&
+	    len < node->min_length)
+		return false;
+	if ((node->present & CTLV_NODE_SCHEMA_HAS_MAX_LENGTH) &&
+	    len > node->max_length)
+		return false;
+	return true;
+}
+
+static int schema_scalar(const struct ctlv_hdr *hdr,
+			 const struct ctlv_node_schema *node)
+{
+	const char *string;
+	__s64 signed_value;
+	__u64 value;
+	__u32 len;
+	bool boolean;
+	int ret;
+
+	switch (node->kind) {
+	case CTLV_SCHEMA_UINT:
+	case CTLV_SCHEMA_ENUM:
+	case CTLV_SCHEMA_FLAGS:
+		ret = ctlv_get_u64(hdr, &value);
+		if (ret)
+			return -EPROTO;
+		if (node->kind == CTLV_SCHEMA_FLAGS)
+			return 0;
+		if ((node->present & CTLV_NODE_SCHEMA_HAS_MIN) &&
+		    value < node->min)
+			return -EPROTO;
+		/* New output enum values are appended above the known range. */
+		if (node->kind == CTLV_SCHEMA_ENUM)
+			return 0;
+		if ((node->present & CTLV_NODE_SCHEMA_HAS_MAX) &&
+		    value > node->max)
+			return -EPROTO;
+		return 0;
+	case CTLV_SCHEMA_SINT:
+		ret = ctlv_get_s64(hdr, &signed_value);
+		if (ret)
+			return -EPROTO;
+		if ((node->present & CTLV_NODE_SCHEMA_HAS_MIN) &&
+		    signed_value < (__s64)node->min)
+			return -EPROTO;
+		if ((node->present & CTLV_NODE_SCHEMA_HAS_MAX) &&
+		    signed_value > (__s64)node->max)
+			return -EPROTO;
+		return 0;
+	case CTLV_SCHEMA_BOOL:
+		return ctlv_get_bool(hdr, &boolean) ? -EPROTO : 0;
+	case CTLV_SCHEMA_STRING:
+		ret = ctlv_get_str(hdr, &string);
+		if (ret)
+			return -EPROTO;
+		len = ctlv_hdr_payload_len(hdr);
+		if (memchr(string, '\0', len - 1))
+			return -EPROTO;
+		return schema_length_ok(node, len - 1) ? 0 : -EPROTO;
+	case CTLV_SCHEMA_BINARY:
+		len = ctlv_hdr_payload_len(hdr);
+		return schema_length_ok(node, len) ? 0 : -EPROTO;
+	default:
+		return -EPROTO;
+	}
+}
+
+static int schema_record(struct validate *validate,
+			 const struct ctlv_hdr *record, unsigned int depth);
+
+static int schema_tlv(struct validate *validate,
+		      const struct ctlv_hdr *hdr,
+		      const struct ctlv_node_schema *node,
+		      unsigned int depth)
+{
+	bool is_record = node->kind == CTLV_SCHEMA_RECORD ||
+		      node->kind == CTLV_SCHEMA_BLOB;
+	__u32 flags = is_record ? CTLV_HDR_F_RECORD : 0;
+
+	if (is_record && depth >= CTLV_DEPTH_MAX)
+		return -ELOOP;
+	if (hdr->type != node->type || hdr->flags != flags)
+		return -EPROTO;
+	if (!is_record)
+		return schema_scalar(hdr, node);
+	if (node->kind == CTLV_SCHEMA_BLOB)
+		return -EPROTO;
+
+	validate->node[depth] = node;
+	return schema_record(validate, hdr, depth);
+}
+
+static int schema_record(struct validate *validate,
+			 const struct ctlv_hdr *record, unsigned int depth)
+{
+	const struct ctlv_node_schema *parent = validate->node[depth];
+	const struct ctlv_node_schema *child_node;
+	const struct ctlv_hdr *child;
+	unsigned int level = depth;
+	int ret;
+
+	while (parent->present & CTLV_NODE_SCHEMA_HAS_REENTERS) {
+		if (!parent->reenters || parent->reenters > level)
+			return -EPROTO;
+		level -= parent->reenters;
+		parent = validate->node[level];
+	}
+
+	ret = schema_members(record, parent);
+	if (ret)
+		return ret;
+	ctlv_for_each(child, record) {
+		child_node = schema_member(parent, child->type);
+		if (!child_node) {
+			if (!child->type ||
+			    child->flags & ~CTLV_HDR_F_RECORD)
+				return -EPROTO;
+			continue;
+		}
+		ret = schema_tlv(validate, child, child_node, depth + 1);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+int ctlv_bootstrap_validate(const void *buf, __u32 len, __u64 op_id)
+{
+	const struct ctlv_node_schema *schema;
+	const struct ctlv_op_spec *op;
+	const struct ctlv_hdr *root = buf;
+	struct validate validate = {};
+	int ret;
+
+	op = ctlv_spec_find(&ctlv_spec, op_id);
+	if (!op || !op->reply)
+		return -EINVAL;
+	ret = ctlv_msg_check(buf, len);
+	if (ret)
+		return ret;
+	if (root->len != len)
+		return -EPROTO;
+
+	schema = op->reply;
+	if (schema->type != CTLV_TYPE_ROOT ||
+	    schema->kind != CTLV_SCHEMA_RECORD)
+		return -EINVAL;
+	return schema_tlv(&validate, root, schema, 0);
+}
+
+/* A node's members occupy one contiguous range in the pool. */
+struct build {
+	struct ctlv_node_schema *node_schemas;
+	const struct ctlv_node_schema *path[CTLV_DEPTH_MAX];
+	unsigned int node_schemas_count;
+	unsigned int used;
+};
+
+static size_t text_append(char *buf, size_t len, size_t used,
+			  const char *format, ...)
+{
+	va_list args;
+	int written;
+
+	if (!len)
+		return 0;
+	if (used >= len - 1) {
+		buf[len - 1] = '\0';
+		return len - 1;
+	}
+
+	va_start(args, format);
+	written = vsnprintf(buf + used, len - used, format, args);
+	va_end(args);
+	if (written < 0) {
+		buf[used] = '\0';
+		return used;
+	}
+	if ((size_t)written >= len - used)
+		return len - 1;
+	return used + written;
+}
+
+static bool node_u64(const struct ctlv_hdr *src, __u64 type, __u64 *value)
+{
+	const struct ctlv_hdr *hdr = ctlv_hdr_find(src, type);
+
+	return hdr && !ctlv_get_u64(hdr, value);
+}
+
+/* An optional member, and the bit that says it was there. */
+static void node_opt(const struct ctlv_hdr *src, __u64 type, __u32 bit,
+		     __u64 *value, __u32 *present)
+{
+	if (node_u64(src, type, value))
+		*present |= bit;
+}
+
+static bool node_has(const struct ctlv_hdr *src, __u64 type)
+{
+	return ctlv_hdr_find(src, type);
+}
+
+static int node_id_compare(const void *left, const void *right)
+{
+	const __u64 *a = left;
+	const __u64 *b = right;
+
+	return (*a > *b) - (*a < *b);
+}
+
+static int node_children_check(const struct ctlv_hdr *src,
+			       unsigned int count)
+{
+	const struct ctlv_hdr *child;
+	__u64 *ids;
+	unsigned int i = 0;
+	int ret = 0;
+
+	if (!count)
+		return 0;
+	ids = calloc(count, sizeof(*ids));
+	if (!ids)
+		return -ENOMEM;
+	ctlv_for_each_type(child, src, CTLV_T_SCHEMA_NODE_FIELDS) {
+		if (!node_u64(child, CTLV_T_SCHEMA_NODE_TYPE, &ids[i++])) {
+			ret = -EPROTO;
+			goto out;
+		}
+	}
+	ctlv_for_each_type(child, src, CTLV_T_SCHEMA_NODE_OPTIONAL_FIELDS) {
+		if (!node_u64(child, CTLV_T_SCHEMA_NODE_TYPE, &ids[i++])) {
+			ret = -EPROTO;
+			goto out;
+		}
+	}
+	if (i != count) {
+		ret = -EPROTO;
+		goto out;
+	}
+	if (count > 1)
+		qsort(ids, count, sizeof(*ids), node_id_compare);
+	for (i = 1; i < count; i++) {
+		if (ids[i] == ids[i - 1]) {
+			ret = -EPROTO;
+			break;
+		}
+	}
+out:
+	free(ids);
+	return ret;
+}
+
+static int node_kind_check(const struct ctlv_hdr *src,
+			   const struct ctlv_node_schema *node,
+			   unsigned int depth)
+{
+	bool range = node->kind == CTLV_SCHEMA_UINT ||
+		     node->kind == CTLV_SCHEMA_SINT ||
+		     node->kind == CTLV_SCHEMA_ENUM;
+	bool length = node->kind == CTLV_SCHEMA_STRING ||
+		      node->kind == CTLV_SCHEMA_BINARY;
+	bool blob = node->kind == CTLV_SCHEMA_BLOB;
+	bool flags = node->kind == CTLV_SCHEMA_FLAGS;
+	bool children = node->fields_count || node->optional_fields_count;
+	bool reenters = node_has(src, CTLV_T_SCHEMA_NODE_REENTERS);
+	bool unit = node_has(src, CTLV_T_SCHEMA_NODE_UNIT);
+	bool scale = node_has(src, CTLV_T_SCHEMA_NODE_SCALE);
+
+	if ((!depth && (node->type != CTLV_TYPE_ROOT ||
+			node->kind != CTLV_SCHEMA_RECORD ||
+			node->max_occurrences != 1)) ||
+	    (depth && node->type == CTLV_TYPE_ROOT))
+		return -EPROTO;
+
+	/* A later library may understand an appended schema kind. */
+	if (node->kind > CTLV_SCHEMA_BLOB)
+		return 0;
+	if (node_has(src, CTLV_T_SCHEMA_NODE_MIN) != range ||
+	    node_has(src, CTLV_T_SCHEMA_NODE_MAX) != range ||
+	    node_has(src, CTLV_T_SCHEMA_NODE_MIN_LENGTH) != length ||
+	    node_has(src, CTLV_T_SCHEMA_NODE_MAX_LENGTH) != length ||
+	    node_has(src, CTLV_T_SCHEMA_NODE_FLAGS_MASK) != flags ||
+	    node_has(src, CTLV_T_SCHEMA_NODE_BLOB_DIRECTION) != blob ||
+	    node_has(src, CTLV_T_SCHEMA_NODE_BLOB_BACKINGS) != blob ||
+	    node_has(src, CTLV_T_SCHEMA_NODE_BLOB_MAX_LENGTH) != blob ||
+	    node_has(src, CTLV_T_SCHEMA_NODE_BLOB_ALIGNMENT) != blob)
+		return -EPROTO;
+	if (unit != scale ||
+	    (unit && !node->unit) ||
+	    (unit && node->kind != CTLV_SCHEMA_UINT &&
+	     node->kind != CTLV_SCHEMA_SINT))
+		return -EPROTO;
+	if ((children && node->kind != CTLV_SCHEMA_RECORD) ||
+	    (reenters && (node->kind != CTLV_SCHEMA_RECORD || children)))
+		return -EPROTO;
+
+	if (range) {
+		if (node->kind == CTLV_SCHEMA_SINT)
+			return (__s64)node->min <= (__s64)node->max ?
+			       0 : -EPROTO;
+		/* An enum extension point the device's family leaves unfilled. */
+		if (node->kind == CTLV_SCHEMA_ENUM && node->min == 1 &&
+		    !node->max)
+			return 0;
+		return node->min <= node->max ? 0 : -EPROTO;
+	}
+	if (length && node->min_length > node->max_length)
+		return -EPROTO;
+	if (flags && !node->flags_mask)
+		return -EPROTO;
+	if (blob && (!node->blob_backings || !node->blob_max_length ||
+		     !node->blob_alignment ||
+		     node->blob_alignment & (node->blob_alignment - 1)))
+		return -EPROTO;
+	return 0;
+}
+
+static bool node_is_a_node(const struct ctlv_hdr *hdr)
+{
+	return hdr->type == CTLV_T_SCHEMA_NODE_FIELDS ||
+	       hdr->type == CTLV_T_SCHEMA_NODE_OPTIONAL_FIELDS;
+}
+
+static int count_nodes(const struct ctlv_hdr *src, unsigned int depth,
+		       unsigned int *count)
+{
+	const struct ctlv_hdr *child;
+	int ret;
+
+	if (depth > CTLV_RECORD_DEPTH_MAX)
+		return -ELOOP;
+	if (*count == UINT_MAX)
+		return -EOVERFLOW;
+	(*count)++;
+	ctlv_for_each(child, src) {
+		if (!node_is_a_node(child))
+			continue;
+		if (!ctlv_hdr_is_record(child))
+			return -EPROTO;
+		ret = count_nodes(child, depth + 1, count);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int fill(struct build *build, const struct ctlv_hdr *src,
+		struct ctlv_node_schema *dst, unsigned int depth)
+{
+	struct ctlv_node_schema *required, *optional;
+	const struct ctlv_hdr *child;
+	unsigned int required_count, optional_count, i;
+	__u64 value;
+	int ret;
+
+	if (depth > CTLV_RECORD_DEPTH_MAX)
+		return -ELOOP;
+	build->path[depth] = dst;
+	if (!node_u64(src, CTLV_T_SCHEMA_NODE_TYPE, &dst->type))
+		return -EPROTO;
+	if (!node_u64(src, CTLV_T_SCHEMA_NODE_KIND, &value))
+		return -EPROTO;
+	if (value > UINT32_MAX)
+		return -EPROTO;
+	dst->kind = value;
+	if (!node_u64(src, CTLV_T_SCHEMA_NODE_MAX_OCCURRENCES,
+		      &dst->max_occurrences))
+		return -EPROTO;
+
+	node_opt(src, CTLV_T_SCHEMA_NODE_MIN, CTLV_NODE_SCHEMA_HAS_MIN,
+		 &dst->min, &dst->present);
+	node_opt(src, CTLV_T_SCHEMA_NODE_MAX, CTLV_NODE_SCHEMA_HAS_MAX,
+		 &dst->max, &dst->present);
+	node_opt(src, CTLV_T_SCHEMA_NODE_MIN_LENGTH,
+		 CTLV_NODE_SCHEMA_HAS_MIN_LENGTH, &dst->min_length,
+		 &dst->present);
+	node_opt(src, CTLV_T_SCHEMA_NODE_MAX_LENGTH,
+		 CTLV_NODE_SCHEMA_HAS_MAX_LENGTH, &dst->max_length,
+		 &dst->present);
+	node_opt(src, CTLV_T_SCHEMA_NODE_FLAGS_MASK,
+		 CTLV_NODE_SCHEMA_HAS_FLAGS_MASK, &dst->flags_mask,
+		 &dst->present);
+	node_opt(src, CTLV_T_SCHEMA_NODE_REENTERS,
+		 CTLV_NODE_SCHEMA_HAS_REENTERS, &dst->reenters, &dst->present);
+	if (node_u64(src, CTLV_T_SCHEMA_NODE_UNIT, &value)) {
+		if (value > UINT32_MAX)
+			return -EPROTO;
+		dst->unit = value;
+		dst->present |= CTLV_NODE_SCHEMA_HAS_UNIT;
+	}
+	/* A scale only ever accompanies a unit, and may be negative. */
+	if (node_u64(src, CTLV_T_SCHEMA_NODE_SCALE, &value)) {
+		dst->scale = (__s64)value;
+		dst->present |= CTLV_NODE_SCHEMA_HAS_SCALE;
+	}
+	if (node_u64(src, CTLV_T_SCHEMA_NODE_BLOB_DIRECTION, &value)) {
+		if (value > UINT32_MAX)
+			return -EPROTO;
+		dst->blob_direction = value;
+		dst->present |= CTLV_NODE_SCHEMA_HAS_BLOB;
+		node_u64(src, CTLV_T_SCHEMA_NODE_BLOB_BACKINGS,
+			 &dst->blob_backings);
+		node_u64(src, CTLV_T_SCHEMA_NODE_BLOB_MAX_LENGTH,
+			 &dst->blob_max_length);
+		node_u64(src, CTLV_T_SCHEMA_NODE_BLOB_ALIGNMENT,
+			 &dst->blob_alignment);
+	}
+
+	required_count = ctlv_hdr_count(src, CTLV_T_SCHEMA_NODE_FIELDS);
+	optional_count = ctlv_hdr_count(src,
+					CTLV_T_SCHEMA_NODE_OPTIONAL_FIELDS);
+	if (build->used > build->node_schemas_count ||
+	    required_count > build->node_schemas_count - build->used ||
+	    optional_count > build->node_schemas_count - build->used - required_count)
+		return -EPROTO;
+	ret = node_children_check(src, required_count + optional_count);
+	if (ret)
+		return ret;
+	required = &build->node_schemas[build->used];
+	build->used += required_count;
+	optional = &build->node_schemas[build->used];
+	build->used += optional_count;
+	dst->fields = required;
+	dst->fields_count = required_count;
+	dst->optional_fields = optional;
+	dst->optional_fields_count = optional_count;
+
+	i = 0;
+	ctlv_for_each_type(child, src, CTLV_T_SCHEMA_NODE_FIELDS) {
+		ret = fill(build, child, &required[i++], depth + 1);
+		if (ret)
+			return ret;
+	}
+	i = 0;
+	ctlv_for_each_type(child, src, CTLV_T_SCHEMA_NODE_OPTIONAL_FIELDS) {
+		ret = fill(build, child, &optional[i++], depth + 1);
+		if (ret)
+			return ret;
+	}
+	if ((dst->present & CTLV_NODE_SCHEMA_HAS_REENTERS) &&
+	    (!dst->reenters || dst->reenters > depth ||
+	     required_count || optional_count ||
+	     build->path[depth - dst->reenters]->kind !=
+			CTLV_SCHEMA_RECORD))
+		return -EPROTO;
+	return node_kind_check(src, dst, depth);
+}
+
+/* The two trees of one op. Either may be absent. */
+int ctlv_schema_parse(const struct ctlv_hdr *root, __u32 len,
+		      struct ctlv_schema **sp)
+{
+	const struct ctlv_hdr *request, *reply;
+	struct ctlv_schema *schema;
+	struct build build = {};
+	int ret;
+
+	ret = ctlv_bootstrap_validate(root, len, CTLV_OP_OP_SCHEMA_GET);
+	if (ret)
+		return ret;
+	request = ctlv_hdr_find(root, CTLV_T_OP_SCHEMA_GET_REQUEST);
+	reply = ctlv_hdr_find(root, CTLV_T_OP_SCHEMA_GET_REPLY);
+
+	schema = calloc(1, sizeof(*schema));
+	if (!schema)
+		return -ENOMEM;
+	if (request) {
+		ret = count_nodes(request, 0, &build.node_schemas_count);
+		if (ret)
+			goto err;
+	}
+	if (reply) {
+		ret = count_nodes(reply, 0, &build.node_schemas_count);
+		if (ret)
+			goto err;
+	}
+	if (build.node_schemas_count) {
+		build.node_schemas = calloc(build.node_schemas_count, sizeof(*build.node_schemas));
+		if (!build.node_schemas) {
+			free(schema);
+			return -ENOMEM;
+		}
+	}
+	schema->node_schemas = build.node_schemas;
+	schema->node_schemas_count = build.node_schemas_count;
+
+	if (request) {
+		schema->request = &build.node_schemas[build.used++];
+		ret = fill(&build, request,
+			   (struct ctlv_node_schema *)schema->request, 0);
+		if (ret)
+			goto err;
+	}
+	if (reply) {
+		schema->reply = &build.node_schemas[build.used++];
+		ret = fill(&build, reply,
+			   (struct ctlv_node_schema *)schema->reply, 0);
+		if (ret)
+			goto err;
+	}
+	if (build.used != build.node_schemas_count) {
+		ret = -EPROTO;
+		goto err;
+	}
+	*sp = schema;
+	return 0;
+err:
+	ctlv_schema_free(schema);
+	return ret;
+}
+
+void ctlv_schema_free(struct ctlv_schema *schema)
+{
+	if (!schema)
+		return;
+	free(schema->node_schemas);
+	free(schema);
+}
+
+const struct ctlv_node_schema *ctlv_schema_request(const struct ctlv_schema *s)
+{
+	return s->request;
+}
+
+const struct ctlv_node_schema *ctlv_schema_reply(const struct ctlv_schema *s)
+{
+	return s->reply;
+}
+
+/*
+ * Whether two descriptions of one op agree. The first difference is reported,
+ * with the path to it, a drift in one place having many consequences.
+ */
+
+#define DIFFER(_member, _expected, _actual) do {			\
+	if ((_expected) != (_actual)) {					\
+		snprintf(diff, len, "%s: %s %llu != %llu", path,	\
+			 _member, (unsigned long long)(_expected),	\
+			 (unsigned long long)(_actual));		\
+		return false;						\
+	}								\
+} while (0)
+
+static bool node_equal(const struct ctlv_node_schema *expected,
+		       const struct ctlv_node_schema *actual, char *path,
+		       size_t path_len, size_t at, char *diff, size_t len)
+{
+	unsigned int i;
+
+	DIFFER("type", expected->type, actual->type);
+	DIFFER("kind", expected->kind, actual->kind);
+	DIFFER("max-occurrences", expected->max_occurrences,
+	       actual->max_occurrences);
+	DIFFER("present", expected->present, actual->present);
+	DIFFER("min", expected->min, actual->min);
+	DIFFER("max", expected->max, actual->max);
+	DIFFER("min-length", expected->min_length, actual->min_length);
+	DIFFER("max-length", expected->max_length, actual->max_length);
+	DIFFER("flags-mask", expected->flags_mask, actual->flags_mask);
+	DIFFER("unit", expected->unit, actual->unit);
+	DIFFER("scale", expected->scale, actual->scale);
+	DIFFER("blob-direction", expected->blob_direction,
+	       actual->blob_direction);
+	DIFFER("blob-backings", expected->blob_backings,
+	       actual->blob_backings);
+	DIFFER("blob-max-length", expected->blob_max_length,
+	       actual->blob_max_length);
+	DIFFER("blob-alignment", expected->blob_alignment,
+	       actual->blob_alignment);
+	DIFFER("reenters", expected->reenters, actual->reenters);
+	DIFFER("fields", expected->fields_count, actual->fields_count);
+	DIFFER("optional-fields", expected->optional_fields_count,
+	       actual->optional_fields_count);
+
+	for (i = 0; i < expected->fields_count; i++) {
+		size_t used = text_append(path, path_len, at, ".fields[%u]", i);
+
+		if (!node_equal(&expected->fields[i], &actual->fields[i], path,
+				path_len, used, diff, len))
+			return false;
+	}
+	for (i = 0; i < expected->optional_fields_count; i++) {
+		size_t used = text_append(path, path_len, at,
+					  ".optional-fields[%u]", i);
+
+		if (!node_equal(&expected->optional_fields[i],
+				&actual->optional_fields[i], path, path_len,
+				used, diff, len))
+			return false;
+	}
+	path[at] = '\0';
+	return true;
+}
+
+bool ctlv_schema_equal(const struct ctlv_node_schema *expected,
+		       const struct ctlv_node_schema *actual, char *diff,
+		       size_t len)
+{
+	char path[512] = "root";
+
+	if (!expected || !actual) {
+		if (expected == actual)
+			return true;
+		snprintf(diff, len, "one tree is absent: %s expected, %s got",
+			 expected ? "present" : "absent",
+			 actual ? "present" : "absent");
+		return false;
+	}
+	return node_equal(expected, actual, path, sizeof(path), strlen(path),
+			  diff, len);
+}
+
+static const char *const kinds[] = {
+	[CTLV_SCHEMA_UINT] = "uint",
+	[CTLV_SCHEMA_SINT] = "sint",
+	[CTLV_SCHEMA_BOOL] = "bool",
+	[CTLV_SCHEMA_STRING] = "string",
+	[CTLV_SCHEMA_BINARY] = "binary",
+	[CTLV_SCHEMA_ENUM] = "enum",
+	[CTLV_SCHEMA_FLAGS] = "flags",
+	[CTLV_SCHEMA_RECORD] = "record",
+	[CTLV_SCHEMA_BLOB] = "blob",
+};
+
+/* One line for one node, for a tool that has no names to print. */
+void ctlv_schema_render(const struct ctlv_node_schema *node,
+			unsigned int indent, char *buf, size_t len)
+{
+	const char *kind = "?";
+	size_t used;
+
+	if (node->kind < CTLV_ARRAY_SIZE(kinds) && kinds[node->kind])
+		kind = kinds[node->kind];
+
+	used = text_append(buf, len, 0, "%*s", indent * 2, "");
+	if (node->type == CTLV_TYPE_ROOT)
+		used = text_append(buf, len, used, "root %s", kind);
+	else
+		used = text_append(buf, len, used, "field %#llx %s",
+				   (unsigned long long)node->type, kind);
+
+	if (node->max_occurrences == 1)
+		;
+	else if (!node->max_occurrences)
+		used = text_append(buf, len, used, " xN");
+	else
+		used = text_append(buf, len, used, " x%llu",
+				   (unsigned long long)node->max_occurrences);
+
+	/* One pair of members serves sint and uint, read by the schema kind. */
+	if (node->present & (CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX)) {
+		if (node->kind == CTLV_SCHEMA_SINT)
+			used = text_append(buf, len, used, " [%lld, %lld]",
+					   (long long)node->min,
+					   (long long)node->max);
+		else
+			used = text_append(buf, len, used, " [%llu, %llu]",
+					   (unsigned long long)node->min,
+					   (unsigned long long)node->max);
+	}
+	if (node->present & CTLV_NODE_SCHEMA_HAS_MAX_LENGTH)
+		used = text_append(buf, len, used, " len [%llu, %llu]",
+				   (unsigned long long)node->min_length,
+				   (unsigned long long)node->max_length);
+	if (node->present & CTLV_NODE_SCHEMA_HAS_FLAGS_MASK)
+		used = text_append(buf, len, used, " mask %#llx",
+				   (unsigned long long)node->flags_mask);
+	if (node->present & CTLV_NODE_SCHEMA_HAS_UNIT)
+		used = text_append(buf, len, used, " unit %u scale %lld",
+				   node->unit, (long long)node->scale);
+	if (node->present & CTLV_NODE_SCHEMA_HAS_BLOB)
+		used = text_append(buf, len, used,
+				   " blob dir %u backings %#llx max %llu align %llu",
+				   node->blob_direction,
+				   (unsigned long long)node->blob_backings,
+				   (unsigned long long)node->blob_max_length,
+				   (unsigned long long)node->blob_alignment);
+	if (node->present & CTLV_NODE_SCHEMA_HAS_REENTERS)
+		text_append(buf, len, used, " reenters %llu",
+			    (unsigned long long)node->reenters);
+}
diff --git a/tools/ctlv/libctlv/spec.c b/tools/ctlv/libctlv/spec.c
new file mode 100644
index 000000000000..194966e29e2d
--- /dev/null
+++ b/tools/ctlv/libctlv/spec.c
@@ -0,0 +1,186 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Runtime device/specification conformance.
+ */
+
+#include <stdio.h>
+
+#include "internal.h"
+
+/* Where a difference is written, long enough for a path and two numbers. */
+#define DIFF_LEN 512
+
+#define UNEQUAL(_what, _expected, _actual) do {				\
+	if ((_expected) != (_actual)) {					\
+		snprintf(diff, len, "op %#llx: %s %llu != %llu",		\
+			 (unsigned long long)spec->op_id, _what,		\
+			 (unsigned long long)(_expected),		\
+			 (unsigned long long)(_actual));		\
+		return -ENOMSG;						\
+	}								\
+} while (0)
+
+const struct ctlv_op_spec *ctlv_spec_find(const struct ctlv_family_spec *spec,
+					  __u64 op_id)
+{
+	unsigned int i;
+
+	for (; spec; spec = spec->parent)
+		for (i = 0; i < spec->ops_count; i++)
+			if (spec->ops[i].op_id == op_id)
+				return &spec->ops[i];
+	return NULL;
+}
+
+/* What an ops dump reports about an op, against what the family says it is. */
+static int info_check(const struct ctlv_op_spec *spec,
+		      const struct ctlv_op_info *info, char *diff, size_t len)
+{
+	UNEQUAL("type", spec->type, info->type);
+	UNEQUAL("fd-access", spec->fd_access, info->fd_access);
+	UNEQUAL("availability", spec->availability, info->availability);
+	UNEQUAL("request-max-len", spec->request_max_len,
+		info->request_max_len);
+	UNEQUAL("action-reply-max-len", spec->action_reply_max_len,
+		info->action_reply_max_len);
+	UNEQUAL("query-reply-min-len", spec->query_reply_min_len,
+		info->query_reply_min_len);
+	UNEQUAL("query-reply-suggested-len", spec->query_reply_suggested_len,
+		info->query_reply_suggested_len);
+	UNEQUAL("error-info-max-len", spec->error_info_max_len,
+		info->error_info_max_len);
+	return 0;
+}
+
+/* Both trees of one op, as the device describes them. */
+static int schema_check(struct ctlv_dev *dev, const struct ctlv_op_spec *spec,
+			char *diff, size_t len, struct ctlv_error *error)
+{
+	char where[DIFF_LEN];
+	struct ctlv_schema *schema;
+	int ret;
+
+	ret = ctlv_op_schema_get(dev, spec->op_id, &schema, error);
+	if (ret)
+		return ret;
+
+	ret = 0;
+	if (!ctlv_schema_equal(spec->request, ctlv_schema_request(schema),
+			       where, sizeof(where))) {
+		snprintf(diff, len, "op %#llx request: %s",
+			 (unsigned long long)spec->op_id, where);
+		ret = -ENOMSG;
+	} else if (!ctlv_schema_equal(spec->reply, ctlv_schema_reply(schema),
+				      where, sizeof(where))) {
+		snprintf(diff, len, "op %#llx reply: %s",
+			 (unsigned long long)spec->op_id, where);
+		ret = -ENOMSG;
+	}
+	ctlv_schema_free(schema);
+	return ret;
+}
+
+/* Whether the chain @spec describes is the chain @dev resolved. */
+static int chain_check(struct ctlv_dev *dev,
+		       const struct ctlv_family_spec *spec, char *diff,
+		       size_t len)
+{
+	const struct ctlv_family_spec *walk;
+	unsigned int level;
+
+	if (strcmp(spec->name, ctlv_dev_family(dev))) {
+		snprintf(diff, len, "%s describes a %s, not a %s",
+			 spec->name, spec->name, ctlv_dev_family(dev));
+		return -EINVAL;
+	}
+
+	level = ctlv_chain_len(dev);
+	for (walk = spec; walk; walk = walk->parent) {
+		if (!level--) {
+			snprintf(diff, len,
+				 "the device's chain never reaches %s",
+				 walk->name);
+			return -ENOMSG;
+		}
+		if (walk->family_id != ctlv_chain_id(dev, level) ||
+		    strcmp(walk->name, ctlv_chain_name(dev, level))) {
+			snprintf(diff, len,
+				 "chain level %u: %s (%u) != %s (%u)", level,
+				 walk->name, walk->family_id,
+				 ctlv_chain_name(dev, level),
+				 ctlv_chain_id(dev, level));
+			return -ENOMSG;
+		}
+	}
+	if (level) {
+		snprintf(diff, len, "%s describes %u families too few",
+			 spec->name, level);
+		return -ENOMSG;
+	}
+	return 0;
+}
+
+static int required_ops_check(const struct ctlv_family_spec *spec,
+			      const struct ctlv_ops *ops, char *diff,
+			      size_t len)
+{
+	const struct ctlv_family_spec *family;
+	unsigned int i;
+
+	/* Parsing already rejected duplicate published IDs. */
+	for (family = spec; family; family = family->parent) {
+		for (i = 0; i < family->ops_count; i++) {
+			const struct ctlv_op_spec *op = &family->ops[i];
+
+			if (op->optional || ctlv_ops_find(ops, op->op_id))
+				continue;
+			snprintf(diff, len, "op %#llx: mandatory, but not published",
+				 (unsigned long long)op->op_id);
+			return -ENOMSG;
+		}
+	}
+	return 0;
+}
+
+int ctlv_spec_check(struct ctlv_dev *dev, const struct ctlv_family_spec *spec,
+		    char *diff, size_t len, struct ctlv_error *error)
+{
+	struct ctlv_ops *ops;
+	unsigned int i;
+	int ret;
+
+	if (diff && len)
+		*diff = '\0';
+	ret = chain_check(dev, spec, diff, len);
+	if (ret)
+		return ret;
+	ret = ctlv_ops_get(dev, &ops, error);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < ops->ops_count; i++) {
+		const struct ctlv_op_info *info = &ops->ops[i];
+		const struct ctlv_op_spec *described;
+
+		described = ctlv_spec_find(spec, info->op_id);
+		if (!described) {
+			snprintf(diff, len,
+				 "op %#llx: published, and %s has no such op",
+				 (unsigned long long)info->op_id, spec->name);
+			ret = -ENOMSG;
+			break;
+		}
+		ret = info_check(described, info, diff, len);
+		if (ret)
+			break;
+		ret = schema_check(dev, described, diff, len, error);
+		if (ret)
+			break;
+	}
+	if (!ret)
+		ret = required_ops_check(spec, ops, diff, len);
+	ctlv_ops_free(ops);
+	return ret;
+}
diff --git a/tools/ctlv/libctlv/transport.c b/tools/ctlv/libctlv/transport.c
new file mode 100644
index 000000000000..647bab085c9e
--- /dev/null
+++ b/tools/ctlv/libctlv/transport.c
@@ -0,0 +1,572 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Operation execution, query reassembly, and error decoding.
+ */
+
+#include <stdio.h>
+#include <sys/ioctl.h>
+
+#include "internal.h"
+
+/* Where a query's buffer starts when nothing said how long its answer is. */
+#define QUERY_BUF_LEN 0x10000
+
+void ctlv_error_clear(struct ctlv_error *error)
+{
+	if (error)
+		memset(error, 0, sizeof(*error));
+}
+
+void ctlv_error_set(struct ctlv_error *error, int err)
+{
+	if (!error)
+		return;
+	memset(error, 0, sizeof(*error));
+	error->err = err;
+}
+
+static void error_u64(struct ctlv_error *error, const struct ctlv_hdr *root,
+		      __u64 type, __u32 bit, __u64 *value)
+{
+	const struct ctlv_hdr *hdr = ctlv_hdr_find(root, type);
+
+	if (!hdr || ctlv_get_u64(hdr, value))
+		return;
+	error->present |= bit;
+}
+
+/*
+ * What a device wrote about the failure. A buffer holding nothing, or nothing
+ * this reader can parse, leaves the errno as the whole of the report.
+ */
+void ctlv_error_parse(struct ctlv_error *error, int err, const void *buf,
+		      __u32 len)
+{
+	const struct ctlv_hdr *root = buf;
+	const struct ctlv_hdr *hdr;
+	__u64 value;
+
+	if (!error)
+		return;
+	memset(error, 0, sizeof(*error));
+	error->err = err;
+	if (!buf || ctlv_msg_check(buf, len))
+		return;
+
+	hdr = ctlv_hdr_find(root, CTLV_T_ERROR_INFO_REASON);
+	if (hdr && !ctlv_get_enum(hdr, 1,
+				  CTLV_VALIDATION_REASON_STALE_GENERATION,
+				  &value, NULL)) {
+		error->reason = value;
+		error->present |= CTLV_ERROR_HAS_REASON;
+	}
+	hdr = ctlv_hdr_find(root, CTLV_T_ERROR_INFO_MESSAGE);
+	if (hdr) {
+		const char *message;
+
+		if (!ctlv_get_str(hdr, &message)) {
+			snprintf(error->message, sizeof(error->message), "%s",
+				 message);
+			error->present |= CTLV_ERROR_HAS_MESSAGE;
+		}
+	}
+	error_u64(error, root, CTLV_T_ERROR_INFO_BAD_TLV_OFFSET,
+		  CTLV_ERROR_HAS_BAD_TLV_OFFSET, &error->bad_tlv_offset);
+	error_u64(error, root, CTLV_T_ERROR_INFO_RECORD_OFFSET,
+		  CTLV_ERROR_HAS_RECORD_OFFSET, &error->record_offset);
+	error_u64(error, root, CTLV_T_ERROR_INFO_MISSING_TYPE,
+		  CTLV_ERROR_HAS_MISSING_TYPE, &error->missing_type);
+	error_u64(error, root, CTLV_T_ERROR_INFO_EXPECTED_GENERATION,
+		  CTLV_ERROR_HAS_EXPECTED_GENERATION,
+		  &error->expected_generation);
+	error_u64(error, root, CTLV_T_ERROR_INFO_CURRENT_GENERATION,
+		  CTLV_ERROR_HAS_CURRENT_GENERATION,
+		  &error->current_generation);
+	error_u64(error, root, CTLV_T_ERROR_INFO_REQUIRED_LENGTH,
+		  CTLV_ERROR_HAS_REQUIRED_LENGTH, &error->required_length);
+}
+
+static const char *const reasons[] = {
+	[CTLV_VALIDATION_REASON_MALFORMED_MESSAGE] = "malformed message",
+	[CTLV_VALIDATION_REASON_UNKNOWN_TYPE] = "unknown type",
+	[CTLV_VALIDATION_REASON_UNKNOWN_FLAG] = "unknown flag",
+	[CTLV_VALIDATION_REASON_RECORD_TOO_DEEP] = "record too deep",
+	[CTLV_VALIDATION_REASON_MISSING_FIELD] = "missing field",
+	[CTLV_VALIDATION_REASON_TOO_MANY_OCCURRENCES] = "too many occurrences",
+	[CTLV_VALIDATION_REASON_VALUE_OUT_OF_RANGE] = "value out of range",
+	[CTLV_VALIDATION_REASON_BAD_LENGTH] = "bad length",
+	[CTLV_VALIDATION_REASON_BAD_STRING] = "bad string",
+	[CTLV_VALIDATION_REASON_BAD_BLOB_DESCRIPTOR] = "bad blob descriptor",
+	[CTLV_VALIDATION_REASON_STALE_GENERATION] = "stale generation",
+	[CTLV_VALIDATION_REASON_NONCONTIGUOUS_TYPE] = "noncontiguous type",
+};
+
+const char *ctlv_error_str(const struct ctlv_error *error, char *buf,
+			   size_t len)
+{
+	const char *reason = NULL;
+	size_t used;
+
+	if (error->present & CTLV_ERROR_HAS_REASON &&
+	    error->reason < CTLV_ARRAY_SIZE(reasons))
+		reason = reasons[error->reason];
+	used = snprintf(buf, len, "%s", strerror(-error->err));
+	if (reason && used < len)
+		used += snprintf(buf + used, len - used, ": %s", reason);
+	if (error->present & CTLV_ERROR_HAS_MESSAGE && used < len)
+		used += snprintf(buf + used, len - used, ": %s",
+				 error->message);
+	if (error->present & CTLV_ERROR_HAS_MISSING_TYPE && used < len)
+		used += snprintf(buf + used, len - used, " (type %#llx)",
+				 (unsigned long long)error->missing_type);
+	if (error->present & CTLV_ERROR_HAS_REQUIRED_LENGTH && used < len)
+		used += snprintf(buf + used, len - used, " (needs %llu bytes)",
+				 (unsigned long long)error->required_length);
+	if (error->present & CTLV_ERROR_HAS_BAD_TLV_OFFSET && used < len)
+		snprintf(buf + used, len - used, " (at offset %llu)",
+			 (unsigned long long)error->bad_tlv_offset);
+	return buf;
+}
+
+static int exec(struct ctlv_dev *dev, struct ctlv_op_exec *arg)
+{
+	if (ioctl(dev->fd, CTLV_IOC_OP_EXEC, arg))
+		return -errno;
+	return 0;
+}
+
+static int reply_new(__u32 capacity, struct ctlv_reply **replyp)
+{
+	struct ctlv_reply *reply;
+	int ret;
+
+	reply = calloc(1, sizeof(*reply));
+	if (!reply)
+		return -ENOMEM;
+	ret = ctlv_msg_new_max(capacity, CTLV_REPLY_LEN_MAX, &reply->msg);
+	if (ret) {
+		free(reply);
+		return ret;
+	}
+	*replyp = reply;
+	return 0;
+}
+
+void ctlv_reply_free(struct ctlv_reply *reply)
+{
+	if (!reply)
+		return;
+	ctlv_msg_free(reply->msg);
+	free(reply);
+}
+
+const struct ctlv_hdr *ctlv_reply_root(const struct ctlv_reply *reply)
+{
+	return ctlv_msg_root(reply->msg);
+}
+
+__u64 ctlv_reply_generation(const struct ctlv_reply *reply)
+{
+	return reply->generation;
+}
+
+unsigned int ctlv_reply_fragments(const struct ctlv_reply *reply)
+{
+	return reply->fragments;
+}
+
+static const struct ctlv_hdr empty_request = {
+	.len = sizeof(struct ctlv_hdr),
+	.flags = CTLV_HDR_F_RECORD,
+	.type = CTLV_TYPE_ROOT,
+};
+
+/* The request bytes an op takes, an empty root when it takes no fields. */
+static int request_of(struct ctlv_msg *request, __u64 *ptr, __u32 *len)
+{
+	int ret;
+
+	if (!request) {
+		*ptr = (__u64)(uintptr_t)&empty_request;
+		*len = sizeof(empty_request);
+		return 0;
+	}
+	ret = ctlv_msg_done(request);
+	if (ret)
+		return ret;
+	*ptr = (__u64)(uintptr_t)request->buf;
+	*len = request->len;
+	return 0;
+}
+
+int ctlv_action_sized(struct ctlv_dev *dev, __u64 op_id,
+		      struct ctlv_msg *request, __u32 reply_len,
+		      struct ctlv_reply **replyp, struct ctlv_error *error)
+{
+	struct ctlv_op_exec arg = { .size = sizeof(arg), .op_id = op_id };
+	struct ctlv_reply *reply = NULL;
+	int ret;
+
+	ctlv_error_clear(error);
+	ret = request_of(request, &arg.request, &arg.request_len);
+	if (ret) {
+		ctlv_error_set(error, ret);
+		return ret;
+	}
+
+	/* A zeroed root says nothing was written, a real one being longer. */
+	if (reply_len < sizeof(struct ctlv_hdr))
+		reply_len = sizeof(struct ctlv_hdr);
+	ret = reply_new(reply_len, &reply);
+	if (ret) {
+		ctlv_error_set(error, ret);
+		return ret;
+	}
+	memset(reply->msg->buf, 0, sizeof(struct ctlv_hdr));
+	arg.reply = (__u64)(uintptr_t)reply->msg->buf;
+	arg.reply_len = reply_len;
+
+	ret = exec(dev, &arg);
+	if (ret) {
+		ctlv_error_parse(error, ret, reply->msg->buf, reply_len);
+		ctlv_reply_free(reply);
+		return ret;
+	}
+
+	reply->fragments = 1;
+	reply->msg->len = ctlv_msg_root(reply->msg)->len;
+	if (!reply->msg->len) {
+		/* Acknowledged, and there is nothing to read. */
+		ctlv_reply_free(reply);
+		reply = NULL;
+	} else {
+		ret = ctlv_msg_check(reply->msg->buf, reply_len);
+		if (ret) {
+			ctlv_error_set(error, ret);
+			ctlv_reply_free(reply);
+			return ret;
+		}
+	}
+	if (replyp)
+		*replyp = reply;
+	else
+		ctlv_reply_free(reply);
+	return 0;
+}
+
+static unsigned int query_cursor_slot(__u64 cursor, unsigned int capacity)
+{
+	cursor ^= cursor >> 30;
+	cursor *= 0xbf58476d1ce4e5b9ULL;
+	cursor ^= cursor >> 27;
+	cursor *= 0x94d049bb133111ebULL;
+	cursor ^= cursor >> 31;
+	return cursor & (capacity - 1);
+}
+
+static void query_cursor_insert(__u64 *slots, unsigned int capacity,
+				__u64 cursor)
+{
+	unsigned int slot = query_cursor_slot(cursor, capacity);
+
+	while (slots[slot])
+		slot = (slot + 1) & (capacity - 1);
+	slots[slot] = cursor;
+}
+
+static int query_guard_grow(struct ctlv_query_guard *guard)
+{
+	unsigned int capacity = guard->cursors_capacity ?
+		guard->cursors_capacity * 2 : 64;
+	__u64 *cursor;
+	unsigned int i;
+
+	cursor = calloc(capacity, sizeof(*cursor));
+	if (!cursor)
+		return -ENOMEM;
+	for (i = 0; i < guard->cursors_capacity; i++)
+		if (guard->cursors[i])
+			query_cursor_insert(cursor, capacity, guard->cursors[i]);
+	free(guard->cursors);
+	guard->cursors = cursor;
+	guard->cursors_capacity = capacity;
+	return 0;
+}
+
+int ctlv_query_guard_next(struct ctlv_query_guard *guard, __u64 cursor,
+			  bool progress)
+{
+	unsigned int slot;
+	int ret;
+
+	if (!cursor)
+		return 0;
+	if (!progress)
+		return -EPROTO;
+	if (guard->cursors_count >= CTLV_QUERY_FRAGMENTS_MAX - 1)
+		return -E2BIG;
+	if (guard->cursors_count * 2 >= guard->cursors_capacity) {
+		ret = query_guard_grow(guard);
+		if (ret)
+			return ret;
+	}
+	slot = query_cursor_slot(cursor, guard->cursors_capacity);
+	while (guard->cursors[slot]) {
+		if (guard->cursors[slot] == cursor)
+			return -ELOOP;
+		slot = (slot + 1) & (guard->cursors_capacity - 1);
+	}
+	guard->cursors[slot] = cursor;
+	guard->cursors_count++;
+	return 0;
+}
+
+void ctlv_query_guard_free(struct ctlv_query_guard *guard)
+{
+	free(guard->cursors);
+	*guard = (struct ctlv_query_guard){};
+}
+
+/* No continuation marker may hide below a record that was completed. */
+static int frag_closed(const struct ctlv_hdr *record)
+{
+	const struct ctlv_hdr *child;
+	int ret;
+
+	ctlv_for_each(child, record) {
+		if (child->flags & CTLV_HDR_F_FRAG_MORE)
+			return -EPROTO;
+		if (!ctlv_hdr_is_record(child))
+			continue;
+		ret = frag_closed(child);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+/* Remember the one last-child path this fragment leaves open. */
+static int frag_path_build(const struct ctlv_hdr *record,
+			   struct ctlv_frag_path *path)
+{
+	const struct ctlv_hdr *child, *last = NULL;
+	int ret;
+
+	ctlv_for_each(child, record)
+		last = child;
+	ctlv_for_each(child, record) {
+		if (child == last)
+			break;
+		if (child->flags & CTLV_HDR_F_FRAG_MORE)
+			return -EPROTO;
+		if (!ctlv_hdr_is_record(child))
+			continue;
+		ret = frag_closed(child);
+		if (ret)
+			return ret;
+	}
+	if (!last)
+		return 0;
+	if (!(last->flags & CTLV_HDR_F_FRAG_MORE))
+		return ctlv_hdr_is_record(last) ? frag_closed(last) : 0;
+	if (!ctlv_hdr_is_record(last))
+		return -EPROTO;
+	if (path->depth == CTLV_ARRAY_SIZE(path->type))
+		return -ELOOP;
+	path->type[path->depth++] = last->type;
+	return frag_path_build(last, path);
+}
+
+static int frag_path_read(const struct ctlv_hdr *root,
+			  struct ctlv_frag_path *path)
+{
+	*path = (struct ctlv_frag_path){};
+	if (!(root->flags & CTLV_HDR_F_FRAG_MORE))
+		return frag_closed(root);
+	return frag_path_build(root, path);
+}
+
+/* The next fragment begins by repeating every record still open. */
+static int frag_path_repeat(const struct ctlv_hdr *root,
+			    const struct ctlv_frag_path *path)
+{
+	const struct ctlv_hdr *record = root;
+	const struct ctlv_hdr *child;
+	unsigned int i;
+
+	for (i = 0; i < path->depth; i++) {
+		child = ctlv_hdr_first(record);
+		if (!child || !ctlv_hdr_is_record(child) ||
+		    child->type != path->type[i])
+			return -EPROTO;
+		record = child;
+	}
+	return 0;
+}
+
+/*
+ * One fragment, appended to the reply being assembled. @skip levels of
+ * re-emitted path are descended into rather than appended, being still open in
+ * @out; a record left marked open stays open for the next fragment.
+ */
+static int splice(struct ctlv_msg *out, const struct ctlv_hdr *record,
+		  unsigned int skip, bool *progress)
+{
+	const struct ctlv_hdr *child;
+	bool first = true;
+	int ret;
+
+	ctlv_for_each(child, record) {
+		bool more = child->flags & CTLV_HDR_F_FRAG_MORE;
+
+		if (first && skip) {
+			ret = splice(out, child, skip - 1, progress);
+			if (!ret && !more)
+				ret = ctlv_record_end(out);
+		} else if (more) {
+			ret = ctlv_record_start(out, child->type);
+			if (!ret)
+				ret = splice(out, child, 0, progress);
+		} else {
+			/* Complete: nothing inside waits for a continuation. */
+			ret = ctlv_msg_copy(out, child);
+			if (!ret)
+				*progress = true;
+		}
+		if (ret)
+			return ret;
+		first = false;
+	}
+	return 0;
+}
+
+int ctlv_frag_splice(struct ctlv_msg *out, const struct ctlv_hdr *root,
+		     struct ctlv_frag_path *open, bool *progress)
+{
+	struct ctlv_frag_path next;
+	bool made_progress = false;
+	int ret;
+
+	if (progress)
+		*progress = false;
+	ret = frag_path_read(root, &next);
+	if (ret)
+		return ret;
+	ret = frag_path_repeat(root, open);
+	if (ret)
+		return ret;
+	ret = splice(out, root, open->depth, &made_progress);
+	if (!ret) {
+		*open = next;
+		if (progress)
+			*progress = made_progress;
+	}
+	return ret;
+}
+
+int ctlv_query_sized(struct ctlv_dev *dev, __u64 op_id,
+		     struct ctlv_msg *request, __u32 buf_len,
+		     struct ctlv_reply **replyp, struct ctlv_error *error)
+{
+	struct ctlv_op_exec arg = { .size = sizeof(arg), .op_id = op_id };
+	struct ctlv_query_guard guard = {};
+	struct ctlv_reply *reply = NULL;
+	struct ctlv_frag_path open = {};
+	void *buf;
+	int ret;
+
+	ctlv_error_clear(error);
+	if (!buf_len)
+		buf_len = QUERY_BUF_LEN;
+	if (buf_len < sizeof(struct ctlv_hdr))
+		buf_len = sizeof(struct ctlv_hdr);
+	ret = request_of(request, &arg.request, &arg.request_len);
+	if (ret)
+		goto out_err;
+
+	buf = malloc(buf_len);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto out_err;
+	}
+	arg.reply = (__u64)(uintptr_t)buf;
+	arg.reply_len = buf_len;
+
+	ret = reply_new(buf_len, &reply);
+	if (ret)
+		goto out_free_buf;
+
+	do {
+		const struct ctlv_hdr *root = buf;
+		bool progress;
+
+		/* A failure that writes nothing leaves the root zeroed. */
+		memset(buf, 0, sizeof(struct ctlv_hdr));
+		ret = exec(dev, &arg);
+		if (ret) {
+			ctlv_error_parse(error, ret, buf, buf_len);
+			goto out_free_reply;
+		}
+		ret = ctlv_msg_check(buf, buf_len);
+		if (ret)
+			goto out_set_err;
+
+		/*
+		 * The root's mark and the cursor both say whether there is
+		 * more, and disagreeing is not something to reassemble.
+		 */
+		if (!(root->flags & CTLV_HDR_F_FRAG_MORE) != !arg.cursor) {
+			ret = -EPROTO;
+			goto out_set_err;
+		}
+
+		ret = ctlv_frag_splice(reply->msg, root, &open, &progress);
+		if (ret)
+			goto out_set_err;
+		ret = ctlv_query_guard_next(&guard, arg.cursor, progress);
+		if (ret)
+			goto out_set_err;
+		if (!arg.cursor && open.depth) {
+			ret = -EPROTO;
+			goto out_set_err;
+		}
+
+		reply->fragments++;
+		reply->generation = arg.generation;
+	} while (arg.cursor);
+
+	/* The answer having ended, the root is the only record still open. */
+	if (reply->msg->depth != 1) {
+		ret = -EPROTO;
+		goto out_set_err;
+	}
+	ret = ctlv_msg_done(reply->msg);
+	if (ret)
+		goto out_set_err;
+	/* The reassembled tree is a message in its own right, or nothing is. */
+	ret = ctlv_msg_check(reply->msg->buf, reply->msg->len);
+	if (ret)
+		goto out_set_err;
+
+	ctlv_query_guard_free(&guard);
+	free(buf);
+	if (replyp)
+		*replyp = reply;
+	else
+		ctlv_reply_free(reply);
+	return 0;
+
+out_set_err:
+	ctlv_error_set(error, ret);
+out_free_reply:
+	ctlv_reply_free(reply);
+out_free_buf:
+	ctlv_query_guard_free(&guard);
+	free(buf);
+	return ret;
+out_err:
+	ctlv_error_set(error, ret);
+	return ret;
+}
-- 
2.56.0

