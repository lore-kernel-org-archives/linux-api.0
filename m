Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585341;
	b=T0MPFLJOtjvSiMTCu2Zp0HE8g0YvXqAsoD6ZaOPW1sSssQocK3g2HYkY6fha2knHuoM+
	 Wuu5xlBIzg2/YiZcewRIt9ToNco/f2BeZhAncsQiANMiO6pRIWav0IZqt19J9yLsKBlCq
	 P4jw91oYBrbfy0WlEFjqE7bSyO/tjSXSySKl4hYTSoonHRnrKNd7a9kMahPldPKPBABjl
	 HOM0osu7q6X7a3/Aya9VUbUPpnrgoFposkKNPe0KGGjq6UqVYRyekqy+mrRCK84i+4xp1
	 mgOzp/kO85Vn3m7bI8FtRtIdTWLgJv8QUuzIwI8iXh3FVOm0rUkCPyYA5jiTonmezSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585341;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mig6LLfGDJcFb+ay7rubnGU3N+eKca8A9LaTHp1FutE=;
	b=M558lXSUpPNhiAlPN++TDjQ9tnYKN4PyoCzrW2tLWWeX0hzoRU8AQOaykNx4mnL/w3T7
	 WVghXDlC5+SUWt/7O6RMVYMQQQXY8J9eebIg+SZpDgwNO3XbiWb2sNairJOAfE8ZeyIlJ
	 9t3aW3FjjBUfTMwcR7mJ/aJrDD+6i+H4bqjh2kN+ETCMyMgbuY8hWxwET2cjV6YneQ1eM
	 UHusKPK0ROhhMLVaIpjOBl9k9Xt0nqyY5BdqS9DL3Ce91+c0gufy6IoUP/Od/Pv3ssioH
	 NbX0nlmMmEVx1W0llBnIuhZKEHtDEygg+ZSyFdgcFnQHf9fqS7c2CVxXEnb6XqMBVgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=Ceo+SMbE;
	arc=none smtp.remote-ip=209.85.218.49
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CA160A262B
	for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 15:55:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08CA160A262B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=Ceo+SMbE
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c5080ef9b31so244845866b.1
        for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 07:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1794585338; x=1795190138; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mig6LLfGDJcFb+ay7rubnGU3N+eKca8A9LaTHp1FutE=;
        b=Ceo+SMbEoRHJPLFva0Y5vCDT7BY9yufVTQKqcNIDhAoL9IU3f5+mYRAEDfnSuH1oDM
         snfi5xRn9lAMVj6BUr6kdak1xTg8kx9U4HdThs4CRRHKza8rI9BKoHAkRZNmWo9nICWY
         y1XX5zs8iN6FlzwHJ8jZqtRlFTwG8L9f47hzgMPHeZx3JXvGnM64Exf7OogIXfBy2Ogb
         ufGvzmhOTy5iIc55fT7Atb9MmyFxjndhBVb43zmjOIWNMetuyCKRPRTiAJJfIRUJstuT
         zf/rLfaHSatAGeRaIqGUV2SVIV+RB0nJ4dx1s5jJ1QzYd2b7q4msVodFUGbinMcLIKPo
         COvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794585338; x=1795190138;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mig6LLfGDJcFb+ay7rubnGU3N+eKca8A9LaTHp1FutE=;
        b=sStlLpL8iQcTv3uBWV/zwgxX2K1OHJ7lbPirj3vMxTu2yJrWzxQfMvdlh+7IZDCxA7
         xAK71rpG6ovxxOSlOtjpe5FCqLe8byOL1DExi0vDYDe8ZVhKjuSkZ2PmhlxJC9nSc1QN
         7t47i8R2RH/IgaZG2O43l320huf+/5ASPvu/vPLYvOXo7NtBcpbrmP8Pu5SlhdRDEqz/
         n8Kq5tmWghCDLV7PsSpAgdRYmi3KO4SFqjDYFSI3BYNoSRzpKGAVkHgQqfgVP6jVhsE1
         9HFc/G7ho86SjkUVQFH58NFqYLRu18c1jKR5b1ygsEgflpwxU/Tvnuae3VFfgFaaI48T
         vGuA==
X-Forwarded-Encrypted: i=1; AL+hErFS7Rh68AIXzw8reFL8cMAKp1nKI622vSGiG25aBjIGxZNpbPHKDTUCQfm/py2ZgsXEoA+qFPUE0HA=@vger.kernel.org
X-Gm-Message-State: APuU4Z8NduJzL/OlFcBMsGKuhnLEIBxx+ENER2fsEonLopsdjti8RvxU
	PlO0ZYQwex26g2LaTqcxCzFVE4/IoUyhtLKZD0bOK4+QeofFwi8OIxcgRr8XtRdPDH0=
X-Gm-Gg: AYBFou1BZBdKLqRbfEVFQFo0rTiurX1tTMqd72P/zH6KLep9SLLwp0tdGmtjxBG35xe
	vfNsJt8O86KlnScKp+n4pcIoiaUeX1mUlGCZbTvAcOY1oTdmWBS+o9Y5YHgPKOESQIoNNrslVyH
	nIXFBl8tpVTEgx1wHYPepwfy0PkitNqRdQxBBO9pf5cpXkyTwh2eQRgvWg0EVxetydbtxtydmTu
	pshQKb3rpAkErjpkCTlvMiEGt9n01QANHZ3nZmXSAjCLGsmpJNY4uAAcYClSNtoc99PzEPizc5p
	V4u0igYqYAWbgJ2mNlICUgf2MTmr13iJPc+mc301TSdVWrw9R1S6ZC9wLZZc6+KHYmXaxci/C9a
	k2wQM7Pfww4/B7oDlrfBzfrTFY0nlsgNxojIiR6QfPoTO2AtmaRK0dTylOta9KZFWUfXqLeGg9Z
	YErPrUw02nbQFAFq6AP+xumV3AMM4/OAZ49n2Tu015zlk/MeijzMWYDSWhEx/rE0Y5IMORS5rbz
	EsR8u2D2dAAkJ86hVi9zEOhagUvoH25FzazVMF4NutAbWAYIwstuQRmhwSRuCVg3LJJNUpQPj87
	8zbHkzJqNJ8bEdgFCEcR/zA49Zl0SWvK1UdekBI=
X-Received: by 2002:a17:907:3e97:b0:c46:ba33:1f0a with SMTP id a640c23a62f3a-c509634a301mr255761866b.31.1794585338174;
        Fri, 13 Nov 2026 07:55:38 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b24608sm116958166b.30.2026.11.13.07.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 07:55:37 -0800 (PST)
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
Subject: [PATCH RFC v2 04/15] Documentation: ctlv: Add userspace ABI
Date: Fri, 13 Nov 2026 16:55:03 +0100
Message-ID: <20261113155515.2510194-5-jiri@resnulli.us>
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

Describe what CTLV is for, its terms, transport, discovery, message
format and userspace compatibility rules.

Existing interfaces each miss some of the needs listed under Goals. An
ioctl with a structure of its own fixes its layout, so variable data
needs pointers to more structures, each subsystem validates its own,
and strace needs a decoder for every ioctl. sysfs and configfs
assemble one request through several files, with no point where the
whole request is checked and executed at once. Netlink is built around
sockets and network namespaces, a poor fit for devices that have
nothing to do with either and want the DAC model of a device node.

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- documented the size and flags of struct ctlv_op_exec
- documented EOVERFLOW for a blob range that wraps
- documented that a reply buffer may be any length
- replaced the limits section with the lengths a device reports
- dropped the events
- reworked the document after review, opening with a worked example
- said how a program finds a device's family
- said what a blob descriptor is made of and how a bad one fails
- said TLV, type, record and field instead of attr
- said record instead of nest, the root being one
- said how a type is made of a family, a record and a field
- imported path_id in the udev rule that matches ID_PATH
- opened with the goals
- added a glossary, and dropped "physical"
- collected the compatibility rules in one section
- kept open()'s errors apart from the ioctls'
- documented required-length, the length an output blob needs
- took the UAPI headers from include/uapi/ctlv/
- documented enum extension points
- said message instead of wire
- added a worked type example
- led the devices section with a subsystem's own nodes
- said where stable device names come from, with a udev rule
- gave the glossary an example of an extension point
---
 Documentation/userspace-api/ctlv.rst  | 694 ++++++++++++++++++++++++++
 Documentation/userspace-api/index.rst |   1 +
 MAINTAINERS                           |   1 +
 3 files changed, 696 insertions(+)
 create mode 100644 Documentation/userspace-api/ctlv.rst

diff --git a/Documentation/userspace-api/ctlv.rst b/Documentation/userspace-api/ctlv.rst
new file mode 100644
index 000000000000..f1f775071a78
--- /dev/null
+++ b/Documentation/userspace-api/ctlv.rst
@@ -0,0 +1,694 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==================
+CTLV userspace ABI
+==================
+
+:Author: Jiri Pirko
+
+Char-Device Tag-Length-Value (CTLV) is a flexible way to describe system calls
+delivered over ioctl for a kernel subsystem. It provides a 64-bit operation
+number with variable-length input and output arguments described in a YAML
+schema. The arguments are serialized using a TLV scheme. Strong support for
+forward and backward compatibility is baked into the schema design.
+
+CTLV excels for uAPIs that are too unconstrained to fit in simple structs:
+things that have arrays of arrays, variable-size structs, variable-sized data,
+strings and similar, which are challenging to represent otherwise.
+
+As a transport, CTLV uses a global number space. Inspection tools like strace,
+or a seccomp user-notification supervisor, can always decode a CTLV ioctl
+without having to know what subsystem is using it. The global number space is
+organized into families, each roughly corresponding to a subsystem.
+
+A family describes what its devices accept in YAML, a generator turns that into
+kernel metadata, UAPI headers and userspace bindings, and CTLV validates every
+message before a family callback sees it. Userspace executes every operation
+through one ioctl.
+
+This document is the ABI. What each family accepts is specified under
+``Documentation/ctlv/specs``; writing a family is :doc:`/driver-api/ctlv`.
+
+Goals
+=====
+
+A uAPI too unconstrained for fixed structures needs four things: every request
+checked before a driver sees it, against one description that its headers and
+documentation come from too; room to grow in both directions without versions;
+one encoding that tools decode without knowing the subsystem; and answers
+larger than the caller's buffer, read in parts that stay consistent.
+
+CTLV is not worth it for a value or two, where a sysfs attribute or a plain
+ioctl is simpler.
+
+Each part of the design serves one of the needs:
+
+- The schema. CTLV checks a message's bounds, lengths, occurrence counts and
+  record depth (a record is a TLV of TLVs) against it before a family callback
+  runs, and the generator makes the kernel metadata, the UAPI header, the
+  userspace bindings and the documentation from it.
+- The tree of TLVs, for records and variable data. Fields are optional or
+  required by declaration, so a message can grow without breaking a caller
+  that does not know the new field.
+- One ioctl over a global number space. A new operation is a new
+  specification entry rather than a new ioctl number, and strace or a seccomp
+  supervisor decodes any family.
+- Queries apart from actions. Only a query can be answered in parts: the
+  kernel returns what fits with a cursor to continue from, and a generation,
+  so that a caller whose answer changed between the parts gets ``ESTALE``
+  rather than a mix of two states.
+- Introspection. Every device answers ``family-get``, ``op-get`` and
+  ``op-schema-get``, so a program built without a family still learns what
+  the device accepts.
+
+`Compatibility`_ collects the rules for growing a family.
+
+An example
+==========
+
+Take ``ctlv-example``, a small invented family whose devices hold numbered
+items, each with an optional label; :doc:`/driver-api/ctlv` writes it. Its
+system calls are::
+
+    item_set_action(u64 index, string label?, blob data?) -> status;
+    item_get_query() -> { u64 index; string label?; }[];
+
+``?`` marks an optional argument. The family's specification declares
+``item-set`` with the bounds the kernel checks:
+
+.. code-block:: yaml
+
+    ops:
+      # Sets an item's label and data.
+      item-set:
+        type: action
+        request:
+          # Which item it is.
+          index: uint(..4095)
+          # What the item is called.
+          label?: string(..63)
+          # The item's contents, which the device reads.
+          data?: blob(in, ..1M, align 8, va)
+
+To set the label of item 3 to "ab", a program builds a request of two TLVs,
+the index and the label, under the root every message starts with::
+
+    offset  TLV               len  flags   contents
+    ------  ----------------  ---  ------  ----------------
+         0  root               64  RECORD  type = 0
+        16  .. index           24  -       3
+        40  .. label           19  -       "ab" and its NUL
+        64  end of message
+
+and passes it to the device:
+
+.. code-block:: c
+
+    struct ctlv_op_exec exec = {
+            .size = sizeof(exec),
+            .op_id = CTLV_EXAMPLE_OP_ITEM_SET,
+            .request = (__u64)(uintptr_t)msg,
+            .request_len = 64,
+    };
+
+    if (ioctl(fd, CTLV_IOC_OP_EXEC, &exec))
+            err(1, "item-set");
+
+The op ID and the types come from the family's generated UAPI header.
+Before the family sees the request, the kernel checks it against the
+specification: ``index`` must be at most 4095 and ``label`` at most 63 bytes.
+
+The sections below define each piece: the device, the message format, the
+ioctl, queries, blobs and introspection, and then the rules of compatibility.
+
+Terms
+=====
+
+family
+    The specification of what a device accepts, its operations and records,
+    under one number of the global number space. A family may inherit another,
+    its parent, taking its operations and filling the extension points it
+    leaves. A device answers as one family and is compatible with each of its
+    ancestors.
+
+operation, op
+    What a family declares a device does: an action, executed once and
+    acknowledged, or a query.
+
+TLV
+    Type, length, value: a ``struct ctlv_hdr`` and its payload.
+
+record
+    A TLV whose payload is TLVs, its fields, flagged ``CTLV_HDR_F_RECORD``:
+    a named record of the family, an operation's request or reply, or a
+    record declared inside one of those.
+
+root
+    The record a message starts with, of type zero: the operation's request
+    or reply.
+
+message
+    A request or a reply: one root record.
+
+field
+    One member of a record, a value or a record, required or optional, with its
+    bounds and how often it may repeat.
+
+type
+    The 64-bit number in a TLV's header naming its family, its record and its
+    field.
+
+extension point
+    A field a family leaves for a descendant family to fill with a record of
+    its own, as ``ctlv-accelerator`` leaves ``device-info`` for
+    ``ctlv-accelerator-foo``.
+
+enum extension point
+    An enum a family leaves for a descendant family to give values, so that a
+    device takes the values its own family chain gives.
+
+query
+    An operation answered in as many fragments as its answer needs, which a
+    generation keeps consistent.
+
+fragment
+    One reply of a query: as much of the answer as fits, with a cursor to
+    continue from.
+
+Devices
+========
+
+A device appears in one of two places, and the same ioctls run its family's
+operations on both:
+
+- a character device of a subsystem, in its class and ``/dev`` directory, as
+  an accelerator subsystem would have it::
+
+      /dev/accelerator/accelerator0
+      /sys/class/accelerator/accelerator0
+
+- a file whose other operations are a subsystem's own.
+
+Sysfs shows class membership, the ``dev`` number and the device-model link to
+the parent device. There is no family sysfs attribute; ``family-get`` on an
+open descriptor is the authoritative answer to what a device is.
+
+The number in a name says nothing about the device and, like ``sdX`` or
+``eventN``, may differ between boots. Stable names come from udev rules
+matching the uevent properties described under Discovery. A container is
+given such a name, ``/dev/ctlv-example`` below, rather than whichever number
+the device got.
+
+``O_RDONLY`` opens an observation fd, ``O_RDWR`` opens a full-control fd, and
+``O_WRONLY`` is rejected with ``-EACCES``. Every action and query declares the
+authority it needs: ``read`` permits either accepted fd, while ``read-write``
+requires full control. ``dup()`` and ``SCM_RIGHTS`` preserve that authority;
+attenuation requires a separate observation open.
+
+Discovery
+---------
+
+Both uevents, addition and removal, carry the family chain as numbered
+properties::
+
+    CTLV_FAMILY=ctlv-accelerator-foo
+    CTLV_COMPATIBLE_0=ctlv
+    CTLV_COMPATIBLE_1=ctlv-accelerator
+    CTLV_COMPATIBLE_2=ctlv-accelerator-foo
+    CTLV_COMPATIBLE_N=3
+
+``CTLV_FAMILY`` is the family the device answers as, the numbered properties
+are its ancestry from the root to that family, and ``CTLV_COMPATIBLE_N`` is
+how many there are. An index never moves: changing a family's parent is an
+ABI break, adding a descendant only appends.
+
+A device's uevents carry them whichever subsystem it is in, so a program finds
+every device by ``CTLV_FAMILY`` rather than by class. A program that wants
+every device, including ones appearing while it starts, must listen before it
+looks, which closes the window between enumerating and subscribing::
+
+    1. create a udev monitor and enable it
+    2. enumerate the existing character devices whose uevent has CTLV_FAMILY
+    3. drain the events already queued on the monitor, keeping those with it
+    4. deduplicate by sysfs path
+    5. open the device node
+    6. ask family-get on the open descriptor for the authoritative chain
+
+Steps 1 to 4 are pre-open discovery, all a udev rule can match on; step 6 does
+not need a udev database. A rule matches a family through the compatibility
+properties::
+
+    # /etc/udev/rules.d/70-ctlv.rules
+    #
+    # Anything of one family, whatever family implementation registered it.
+    ENV{CTLV_FAMILY}=="ctlv-accelerator-foo", GROUP="accel", MODE="0660"
+
+    # Anything descended from a family.
+    ENV{CTLV_COMPATIBLE_1}=="ctlv-accelerator", TAG+="uaccess"
+
+    # A stable name for a family with one device per system.
+    ENV{CTLV_FAMILY}=="ctlv-example", SYMLINK+="ctlv-example"
+
+    # A stable name per parent device, for a family with several devices.
+    ENV{CTLV_FAMILY}=="ctlv-accelerator-foo", IMPORT{builtin}="path_id"
+    ENV{CTLV_FAMILY}=="ctlv-accelerator-foo", ENV{ID_PATH}=="?*", \
+        SYMLINK+="accel/by-path/$env{ID_PATH}"
+
+A device whose uevent leaves the family out has a file a program opens by the
+device's own name, and the open descriptor answers ``family-get`` all the
+same.
+
+CTLV does not standardise such aliases and does not promise that a generic
+identifier survives a reboot or a reprobe; a family with a meaningful identity
+exposes it through an operation of its own.
+
+Message format
+==============
+
+A message is a tree of TLVs. Every TLV begins with the same header, at an
+eight-byte boundary::
+
+    struct ctlv_hdr {
+            __u32 len;              /* header + payload, without padding */
+            __u32 flags;            /* CTLV_HDR_F_* */
+            __aligned_u64 type;     /* family, record, field; 0 for a root */
+    };
+
+One unsigned integer TLV with an eight-byte payload, in a message::
+
+     0                   1                   2                   3
+     0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+    +---------------------------------------------------------------+
+    |                        len = 24                               |
+    +---------------------------------------------------------------+
+    |                        flags = 0                              |
+    +---------------------------------------------------------------+
+    |                                                               |
+    +                       type                                    +
+    |                                                               |
+    +---------------------------------------------------------------+
+    |                                                               |
+    +                       payload                                 +
+    |                                                               |
+    +---------------------------------------------------------------+
+
+The rules that make a tree out of that:
+
+- ``CTLV_ALIGNTO`` is 8 and ``CTLV_ALIGN()`` rounds up to it. Every TLV
+  starts at a multiple of eight.
+- ``len`` counts this header plus this TLV's payload, not its own trailing
+  padding.
+- A record's payload is the concatenation of ``CTLV_ALIGN(child.len)`` bytes
+  per child, so a child's padding is counted inside its parent's ``len`` and
+  a leaf's own padding by nobody.
+- ``CTLV_HDR_F_RECORD`` is set exactly on a record, the root included.
+- A message begins with one root, whose ``type`` is ``CTLV_TYPE_ROOT``
+  (zero) and whose payload is the message. A root never appears inside a
+  record, and a record never carries the root type.
+- Scalar payloads are native-endian and their lengths exact: eight bytes for
+  an integer, one byte holding zero or one for a boolean, the string including
+  its NUL terminator, the declared length for binary data.
+- A message goes no deeper than its operation's schema, the root being level
+  zero.
+
+A whole message with every offset, for a request of one integer and one record
+carrying a string and a further record::
+
+    offset  TLV                             len  flags   contents
+    ------  ------------------------------  ---  ------  ----------------
+         0  root                            120  RECORD  type = 0
+        16  .. chunks                        24  -       8-byte integer
+        40  .. chunk                         80  RECORD
+        56     .. label                      19  -       "ab" and its NUL
+        80     .. item                       40  RECORD
+        96        .. value                   24  -       8-byte integer
+       120  end of message
+
+    +----------------------------------------------------------------------+ 0
+    | root: len = 120, flags = RECORD, type = 0                            |
+    |   +----------------------------------------------------------------+ | 16
+    |   | chunks: len = 24 | payload: 8 bytes                            | |
+    |   +----------------------------------------------------------------+ | 40
+    |   | chunk: len = 80, flags = RECORD                                | |
+    |   |   +----------------------------------------------------------+ | | 56
+    |   |   | label: len = 19 | payload: 'a' 'b' 0 | 5 bytes padding   | | |
+    |   |   +----------------------------------------------------------+ | | 80
+    |   |   | item: len = 40, flags = RECORD                           | | |
+    |   |   |   +----------------------------------------------------+ | | | 96
+    |   |   |   | value: len = 24 | payload: 8 bytes                 | | | |
+    |   |   |   +----------------------------------------------------+ | | | 120
+    |   |   +----------------------------------------------------------+ | |
+    |   +----------------------------------------------------------------+ |
+    +----------------------------------------------------------------------+
+
+``label.len`` is 19: its header and three payload bytes, not the five bytes of
+padding after it. ``chunk`` counts those five, its ``len`` of 80 being its
+header plus ``CTLV_ALIGN(19)`` plus ``CTLV_ALIGN(40)``. A walk over a record's
+children advances by ``CTLV_ALIGN(child.len)``, a walk of one payload by
+``child.len``.
+
+A type names the family that declared it, a record within that family and a
+field within that record::
+
+     63      48 47 46 45     32 31 28 27 24 23 20 19 16 15        0
+    +----------+-----+---------+-----+-----+-----+-----+-----------+
+    |  family  |kind |  index  | L1  | L2  | L3  | L4  |   field   |
+    +----------+-----+---------+-----+-----+-----+-----+-----------+
+               |<--------------- record -------------->|
+
+    CTLV_TYPE(family, record, field)
+    CTLV_TYPE_FAMILY(type) / CTLV_TYPE_KIND(type) / CTLV_TYPE_RECORD(type) /
+    CTLV_TYPE_FIELD(type)
+
+A record's type kind, ``enum ctlv_type_kind``, says what it starts from: a
+named record of the family (``CTLV_TYPE_KIND_NAMED``), an op's request
+(``_REQUEST``), or an op's reply (``_REPLY``). The index
+is the named record's place among the family's records, or the op's number. A
+record declared inside one of those adds a path, one hex digit a level for up
+to four levels, saying which it is among the records declared beside it,
+from 1; zero ends the path. The field is its place in its record, from 1. A
+named record has the same types in every message that carries it.
+
+If ``ctlv-example`` were family 7, ``label`` in an item of the reply of
+``item-get``, its op 2, would be ``0x0007c00210000002``. Read in blocks of
+four hex digits, ``0007`` is the family, ``c002`` op 2's reply, ``1000`` the
+path to ``items``, the reply's first record, and ``0002`` the field, the
+second of an item.
+
+An operation ID is the family and the op's number, with the record bits
+zero::
+
+    CTLV_OP(family, op)
+    CTLV_OP_FAMILY(op) / CTLV_OP_NUMBER(op)
+
+Use the generated types and op IDs. A family's header defines every type it
+declares and includes its parent's.
+
+TLV order
+---------
+
+TLVs may come in any order, with one rule: within the root and within each
+record of a request, all TLVs of one type, such as the elements of an array,
+must be next to each other. ``A A B`` and ``B A A`` are valid; ``A B A`` is
+not. An unknown TLV the kernel skips (see the next section) separates two of
+them too, so ``A X A`` is invalid even when ``X`` is skipped.
+
+TLVs an older kernel may skip
+-----------------------------
+
+A program built against a newer version of a family may want to send a field
+that an older kernel does not know. Normally an unknown type fails the
+request. Setting ``CTLV_HDR_F_IGNORE_IF_UNKNOWN`` in a TLV's header asks the
+kernel to skip it instead, together with everything in it.
+
+The flag only matters for a type that none of the device's families
+declares. A type the device knows is validated as usual, flag or not:
+it fails the request where the schema does not place it, and is checked
+against its bounds where it does. A skipped TLV still has to be well
+formed: its length must fit inside its record, and its header may carry only
+defined flags. The root cannot carry the flag, and replies never do.
+
+So the kernel acts on what it knows and ignores the rest. A caller that needs
+to know which of its fields will be acted on asks ``op-schema-get`` first.
+
+Executing an operation
+======================
+
+One ioctl executes every operation::
+
+    struct ctlv_op_exec {
+            __u32 size;                 /* sizeof(struct ctlv_op_exec) */
+            __u32 flags;                /* must be zero */
+            __aligned_u64 op_id;
+            __aligned_u64 request;      /* struct ctlv_hdr __user * */
+            __aligned_u64 reply;        /* struct ctlv_hdr __user * */
+            __u32 request_len;
+            __u32 reply_len;
+            __aligned_u64 generation;   /* queries only */
+            __aligned_u64 cursor;       /* queries only */
+    };
+
+    #define CTLV_IOC_OP_EXEC _IO(0xBB, 0x00)
+
+``size`` is the size of the structure the caller was built with, at least the
+56 bytes of this first version. The structure only grows at its end, and the
+kernel reads ``size`` bytes: a field past the end of an older caller's
+structure reads as zero, and bytes a newer caller sends past the fields this
+kernel knows must be zero. The kernel writes back only within ``size``.
+
+``request_len`` is how many bytes the kernel may read at ``request`` and
+``reply_len`` how many it may write at ``reply``. They are copy boundaries, not
+message lengths: a root's ``len`` may be shorter than ``request_len``, the
+bytes after it being ignored, and may not be longer. ``reply_len`` is never
+overwritten; the length written is the reply root's ``len``. It may be any
+length: a query's fragment stops at a limit of the kernel's own, leaving the
+rest of a longer buffer unused. The pointers are fixed-width so a 32-bit and a
+64-bit process pass the same structure.
+
+Every action and query carries a request root, even where the request is
+empty, so ``request_len`` is at least one header. The
+``request-max-len`` reported by ``op-get`` is the maximum request composed
+from the known schema; a newer caller may exceed it with well-formed unknown
+TLVs marked ``IGNORE_IF_UNKNOWN``. The kernel refuses a request longer than a
+limit of its own, which no request composed from a schema exceeds.
+
+The two op types differ in what they answer:
+
+action
+    Executed once and acknowledged. ``reply_len`` is at least the
+    ``action-reply-max-len`` in ``op-get``, zero for an action that answers
+    nothing.
+
+query
+    Executed once and answered in as many fragments as it needs, using
+    ``generation`` and ``cursor``. ``reply_len`` is at least the
+    ``query-reply-min-len`` in ``op-get``, which also suggests a length as
+    ``query-reply-suggested-len``.
+
+Errors
+------
+
+A failed operation returns a negative errno. Where the failure is a rule the
+message broke and the caller offered a reply buffer, CTLV also writes
+error information there in TLV form: a ``validation-reason`` value, a
+human-readable message, the offset of the offending TLV, the offset of the
+record it was in, the type of a missing field, the length an output blob
+needs, and for a stale query the expected and the current generation. A
+buffer of the operation's ``error-info-max-len`` in ``op-get`` has room for
+it, and one too small leaves it unwritten; the errno is authoritative either
+way.
+
+What the ioctls answer with, as against a family's own callback:
+
+``ENOTTY``
+    Any ioctl but ``CTLV_IOC_OP_EXEC``, on a file only CTLV answers. Where the
+    file is also another subsystem's, that subsystem answers any other ioctl.
+
+``EINVAL``
+    ``size`` was below 56, ``flags`` was not zero, ``op_id`` was zero,
+    ``generation`` or ``cursor`` was set on something that is not a query, or
+    the message broke a rule of the format or of the schema.
+
+``E2BIG``
+    ``size`` was larger than the structure this kernel knows, and the bytes
+    past it were not zero.
+
+``EFAULT``
+    The structure, the request or the reply was not accessible.
+
+``EOVERFLOW``
+    A blob descriptor's address or offset plus its length does not fit in 64
+    bits.
+
+``EOPNOTSUPP``
+    The device does not publish the operation, or publishes it but has it
+    disabled.
+
+``EACCES``
+    The fd lacks the operation's declared authority.
+
+``EMSGSIZE``
+    ``reply_len`` is shorter than the operation's ``action-reply-max-len`` or
+    ``query-reply-min-len``, and nothing was executed; or an ``output`` blob
+    is too short, which the error information reports with
+    ``required-length``; see `Blobs`_.
+
+``ESTALE``
+    A continuation whose ``generation`` no longer matches. Start the query
+    again.
+
+``ENODEV``
+    The device was unregistered. Descriptors stay open and every operation on
+    them fails this way.
+
+``EBADF``, ``EIO``
+    A blob descriptor named something that is not a file, or the file refused
+    the transfer.
+
+``ENOMEM``
+    The kernel could not allocate what the operation needed.
+
+``open()`` answers ``EACCES`` for ``O_WRONLY``, which no operation accepts,
+``ENODEV`` once the device has been unregistered, and ``ENOMEM`` when the
+kernel could not allocate the open file.
+
+Queries and fragments
+=====================
+
+A query's answer may be larger than the buffer the caller wants to commit, so
+the kernel fills the buffer with as much of it as fits where the tree can be
+cut. The first call passes ``generation`` and ``cursor`` zero. On return:
+
+- the kernel puts the query's generation in ``generation``;
+- ``cursor`` is nonzero when there is more to come, zero when the answer is
+  complete;
+- the reply root carries ``CTLV_HDR_F_FRAG_MORE`` when the answer continues,
+  and so does every record still logically open at the cut.
+
+To continue, the caller repeats the call with the same ``op_id`` and request,
+the returned ``cursor`` and the returned ``generation``, and reassembles by
+concatenating the children of each still-open record.
+
+One answer of three items, cut by a buffer that holds two::
+
+    call 1: cursor in = 0             call 2: cursor in = c
+            cursor out = c                    cursor out = 0
+
+    +----------------------------+    +----------------------------+
+    | root: FRAG_MORE            |    | root: (no FRAG_MORE)       |
+    |  +-----------------------+ |    |  +-----------------------+ |
+    |  | chunk: FRAG_MORE      | |    |  | chunk:                | |
+    |  |  +------------------+ | |    |  |  +------------------+ | |
+    |  |  | item: value = 1  | | |    |  |  | item: value = 3  | | |
+    |  |  +------------------+ | |    |  |  +------------------+ | |
+    |  |  | item: value = 2  | | |    |  +-----------------------+ |
+    |  |  +------------------+ | |    +----------------------------+
+    |  +-----------------------+ |
+    +----------------------------+
+
+    reassembled: root -> chunk -> item(1), item(2), item(3)
+
+``FRAG_MORE`` on the root says the answer continues; on ``chunk`` it says the
+next fragment resumes inside that same chunk. A complete record does not carry
+it, so a reader knows whether to append or to open a new record beside it.
+
+Every continuing fragment adds at least one complete logical TLV beyond its
+repeated path, and a cursor value cannot recur within one logical reply.
+A reader must reject either violation.
+
+A continuation whose generation no longer matches fails with ``-ESTALE``, and
+the error information carries the expected and the current generation.
+
+Blobs
+=====
+
+A ``binary`` field carries its bytes in the message itself, within the
+length its family declares. An operation that moves more data than a message
+should carry declares a blob field instead, and the caller passes a
+descriptor rather than the data: the root family's ``blob`` record, declared
+in ``Documentation/ctlv/specs/ctlv.yaml`` and numbered in
+``include/uapi/ctlv/ctlv_gen.h``. ``blob.type`` names the backing and
+``blob.length`` the length in bytes; the backing says which of
+``blob.address``, ``blob.fd`` and ``blob.offset`` name the memory. One
+backing is defined:
+
+``va``
+    Anonymous userspace memory of the calling process, named by an address in
+    ``blob.address``.
+
+The backings a field accepts, the direction data may flow, the maximum
+length and the required alignment are declared by the family and reported by
+``op-schema-get``. Memory is acquired for the operation and released before it
+returns; a descriptor the operation may not use is refused before the callback.
+While the operation is in flight, userspace must not modify an ``input`` blob
+or access an ``output`` or ``inout`` blob. Whether two descriptors overlap is
+also the caller's responsibility. Keep every named VA mapping valid until the
+operation returns.
+
+A descriptor is checked with the rest of the request, before any memory is
+acquired. A malformed field fails like any other. A backing the
+blob field does not accept, fields that do not fit the backing, a zero length
+or one above the maximum, or a misaligned address or offset fails with
+``EINVAL``, and a range that does not fit in 64 bits with ``EOVERFLOW``; both
+report ``bad-blob-descriptor`` at the descriptor. The memory is acquired when
+the operation first uses it, and a failure there, such as ``ENOMEM``, reports
+the same reason at the same place. An operation that
+finds an ``output`` blob too short for what it has to write there fails with
+``EMSGSIZE``, and reports the same with ``required-length``, how long the blob
+has to be, so the caller can retry with one that long.
+
+Breaking the in-flight rules harms only the caller. The kernel copies blob
+data, so what such an operation reads or writes is unspecified and the
+operation may fail, but no kernel memory is at risk.
+
+Introspection
+=============
+
+Three queries describe a device to a program that was not compiled against it.
+The CTLV core answers all three on every device.
+
+``family-get``
+    The device's family chain, root first, as a numeric ID and a name per
+    entry. The authoritative answer to what the device is.
+
+``op-get``
+    One entry per published operation: its ID, op type, required fd access,
+    whether its availability is fixed or dynamic, whether it is currently
+    disabled, and those of its lengths on this device that apply to its op type:
+    ``request-max-len``, ``action-reply-max-len``, ``query-reply-min-len``,
+    ``query-reply-suggested-len`` and ``error-info-max-len``. An unpublished
+    operation has no entry and is indistinguishable from one no family ever
+    declared.
+
+``op-schema-get``
+    The whole tree of one operation: every field of the request and the
+    reply, with its type, its schema kind, its bounds, its occurrence limit,
+    and its unit and scale where it has them.
+
+A schema that describes a schema does not end, so it is reported through
+re-entry: a node whose fields are those of a level already described carries
+``schema-node.reenters``, saying how many levels up that level is. A consumer
+that follows ``reenters`` handles any depth.
+
+The lengths in ``op-get`` include whatever a descendant family added to an
+inherited operation, so ask rather than compute: a family's generated maximum
+is right for its own devices and a lower bound on a descendant's. Likewise, an
+enum extension point's bounds are the values the device's family chain gives
+it, from 1 to 0 when it gives none, and their names are in the uapi header of
+the family that gives them.
+
+A program compiled against a family needs only ``family-get``, once, when
+it opens the device. The chain runs from ``ctlv`` to the device's family, and
+a HW driver usually has a family of its own, such as
+``ctlv-accelerator-foo``, so the last entry also says whose fields the replies
+carry. The answer comes from the open descriptor, so it works where udev never
+ran, such as inside a container; the uevent variables under Discovery are for
+udev rules. A field a descendant family adds to an inherited operation also
+carries that family's ID, in bits 63..48 of its type.
+
+Compatibility
+=============
+
+CTLV has no versions. A program built against one kernel keeps working on a
+later one, and a later program finds out what an earlier kernel acts on, by
+these rules:
+
+- ``struct ctlv_op_exec`` carries its size and grows only at its end; see
+  `Executing an operation`_.
+- A family grows by new operations and new optional fields. A field's type
+  includes its place in its record, so a new field goes last, and the others
+  keep their types.
+- A reply may carry TLVs an older program does not know, and it skips them. A
+  request TLV the kernel does not know fails the request unless the program
+  marks it ``CTLV_HDR_F_IGNORE_IF_UNKNOWN``, and ``op-schema-get`` tells a
+  newer program which of its fields the kernel acts on; see
+  `TLVs an older kernel may skip`_.
+- Anything incompatible is a new operation.
+
+Each family has a checked-in ABI snapshot under ``Documentation/ctlv/abi``, so
+a change to its uAPI shows as a change to that file. ``make -C tools/ctlv
+regen`` rewrites the snapshot from the family's specification, and refuses
+removing or renumbering anything, changing a field's kind or an operation's
+type, access or availability, narrowing a bound or an occurrence limit,
+making a field that the kernel writes optional, and, in any message,
+making a field required or adding a required one.
diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index a68b1bea57a8..d1b53c4e16eb 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -45,6 +45,7 @@ Devices and I/O
    :maxdepth: 1
 
    accelerators/ocxl
+   ctlv
    dma-buf-heaps
    dma-buf-alloc-exchange
    fwctl/index
diff --git a/MAINTAINERS b/MAINTAINERS
index bf6d5bab0da9..e6748a4ad282 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7188,6 +7188,7 @@ M:	Jiri Pirko <jiri@resnulli.us>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/ctlv/
+F:	Documentation/userspace-api/ctlv.rst
 F:	include/linux/ctlv*.h
 F:	include/uapi/ctlv/
 F:	tools/ctlv/
-- 
2.56.0

