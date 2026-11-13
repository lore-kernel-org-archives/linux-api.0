Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585322;
	b=SxfbYIIFWImfBMAHp9+Br6k2WacYxW4sQYELsfto6DsZCAmmddu2R0M2/fV5jG2KLn25
	 +qJTS5Wh8iOU7F7yWRbcY39yE8KQjLzFE7jXGBYJEVA4SJFXqmqt9yRmXcRNVRNiUiKqM
	 ApHQXuAT4a5Pc+RvskiQtpSG2paHHLrtqrEJIe8PTdhY5saYbaCc4ncNc0qF4cIqXtL0P
	 42Yga+WhPJt7AWVvpr3rxM5jmPhZt8eRaSlgdaVRHfX5IR5HKXvCTYqNLpmCzhqxXmTL1
	 STuw0fZq8p/K63neWDch4Sf5MAHU4qV1stx5ojIal+CVbx1C9zMB0ekD+qL7BZ/GSMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585322;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6xcp/FeLn1YPBPmx1dJrjJqV8j6qXm5M1lsk6bRflvc=;
	b=0pLBh0/qYHJvbTEkBonByCBicY9t7R1eaGrp0Qfnx8ZmCQUSAa6cPQTIkrgRgtLWG5+V
	 iUtSit4KBlJPZJT+vnLLOtJgKvsTebDCWLvq9n447fhTYTlM1aHkufLA3oY/dogMXXXQa
	 JrfE4SlzG8oQog5azwBk3YIHAwwZlTMuA2vDE4K1RZDVKb7nX41zsA8IlYfsAJYjm7La1
	 R0e145Xa/sNyXYuL6In5GnwKG4vawJgIrKcX68SaDsJHgf9wjBWjviBDZmJnmDhYtqg1U
	 ZigB2QmhyDaUHMIpf7njNKtCXT+/GEYzrYlDci4xiBlViM0vUnVFSYg3s9gca02G2og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=TrVGUPOh;
	arc=none smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053E3606A330
	for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 15:55:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 053E3606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=TrVGUPOh
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4d28f75d62so288838366b.0
        for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 07:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1794585319; x=1795190119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6xcp/FeLn1YPBPmx1dJrjJqV8j6qXm5M1lsk6bRflvc=;
        b=TrVGUPOhEqEMZako23g1Vx5L+qC6FBfUs/AA9CghETY9GuC9mn896GJJkeZ0tHCkQU
         MDlKi3cxGNf3HYfODx09CeJW4lqG9p/N5tUP8p3cdpPvrJPll9bji5eejV9Mtfb7cJhQ
         yYQC/gjBlC3BXQdclmiozZnxe4B9qjRMWOlQSXaPYGqMft4ZMa6ylCjiJPlFecW5+BKY
         m85x49KvwipQ7JiG7RuH1qsp84rAUwCQqskBULl2+Nof/lluB6YgaHa86W5UPx+w8F6l
         KIQPUie+IU3o9G9A0w+zLC1rDbJZG2ZW/HZUdYkfUIWoyg76NKOtKGfU9U2QhL6jRhQG
         JAiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794585319; x=1795190119;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6xcp/FeLn1YPBPmx1dJrjJqV8j6qXm5M1lsk6bRflvc=;
        b=KMVbQGcEc043ZO/kh3iUMuM7UVtG2xvfcZXsJXXBVOA8ctjnBHMph0OJZWXtgd56uC
         aa/kz1pq5QRX0bjWzyR+W7v9xcBVJ/w+J9n87camUqFOh/UQsFzQ7cY33kJxvwWgbqSD
         0UVwl9u3IwEudt/C4uhKYsIzg9vp+vaOmjg/Td6rfV7646OQt+6ThsQGi9p41zYYe5/2
         DsvzBMfFz9/WSkSV/sXy7EeiW5ZHzfxKYwUckQ65SGPDK6niICohTR5kVNZBzIzMIWho
         QPVgXc7Bh23QGREDU4rrDXxcM5JWKrxLWNWfU5x5GdBzVhz6VF/mYeZrc53jYtjXwzeT
         r/xQ==
X-Forwarded-Encrypted: i=1; AL+hErGi9kLLyJZ+r48X0Cml9mMzE7YL2i58RbT+JXDDMtO/VpXDA5U+FM7M+6m+UzLQAFA/pidBY2Ujlrw=@vger.kernel.org
X-Gm-Message-State: APuU4Z/uAxruZcBwDw2V4pqR1ZDHJm3p5ZhMw7n4ByNep/sxSLHRh11/
	vebIwBbaBkw2DHW1gSbdCDuYp3OtkqW8CQejudEEVRyPM3dX7DBybY6U9GqKtRIPX0I=
X-Gm-Gg: AYBFou1LgnDey5FcFAzp5scpAVAIQi4boIBO4cTzQ5NgslBpP1ocyHlrrouN1E14hIP
	KlIa9RXK4UT9va8lFySttrowW7rRWCnldDYrxcdvwXcFEwpLuPir1IG/WkoeJfL3nwUQZdJaUSD
	wlVE+b7UmoRRL+SqAPYSKDcN/uFAk1/6lhWBDvWaWlP3r12opK3f8wauvcjt3avBIWBxDrY+qWy
	7RvjPmQ9CoxQkYDGrxSMdeFhFlOjnCOYahBQCZ1XtdKeCAyO3JN54BJyVow2y+sh7v6UFGt9hDH
	8NZvImJ8aRZecKOFWRvyGnU17s1VZOt/TGeGLDP4KOdreBWf1w80tthuHRci6TyPEXgmLuQjelU
	AQEeUZhWhE7WJcA65BN24WaexT2Kq8Z74d0A4RDXVgwnxqOwwGILdGmsDK6HpQRIfkbxn7rVxHm
	Ic3+YwOfXdCO1rX7b7LrerfHsQvBKXSKAOOiXivBblucxpWPIf6m7Ze0+4yDiHjMU5ckptbXtMZ
	3IPA17ZfuqY+kT6XCdte9nJT1gtZTgCaABILQQ3MaPnTlxAMukke6n9wi12xNzqYsRFBS/9QJR/
	4MGXMwLPlpdYT6MxrO4K/R/15l+BiT8tZ9M/Wbck
X-Received: by 2002:a17:907:3f8e:b0:c42:73df:933b with SMTP id a640c23a62f3a-c509632817cmr303309666b.12.1794585319075;
        Fri, 13 Nov 2026 07:55:19 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b72868sm112171666b.65.2026.11.13.07.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 07:55:18 -0800 (PST)
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
Subject: [PATCH RFC v2 00/15] ctlv: Add a schema-driven TLV uAPI for character devices
Date: Fri, 13 Nov 2026 16:54:59 +0100
Message-ID: <20261113155515.2510194-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.56.0
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

RFC v1 [1] posted CTLV together with its first user, the attestation
subsystem. v2 posts them as two series: this one, and the attestation
series, which applies on top of it and is posted alongside as

  [PATCH RFC v2 0/9] attestation: Add a common subsystem and TDX support

CTLV is a schema-driven TLV uAPI on a character device, meant for uAPIs
too unconstrained for fixed structures: lists of records, nested and
variable-sized data, optional fields. Every request is checked against
the family's YAML schema before the driver sees it, and the UAPI
header, the bindings and the docs are generated from the same schema.
A family grows without versions, by new ops and optional fields. One
ioctl over a global number space lets strace or a seccomp supervisor
decode any family, and a query whose answer is larger than the
caller's buffer is answered in parts, with a cursor and a generation
that keep them consistent.

An ioctl with structures of its own fixes their layout, needs pointers
to more structures for variable data, and has to be validated and
decoded on its own. sysfs and configfs would assemble one request
through several files, where CTLV checks and executes it at once.
Netlink is built around sockets and network namespaces, while these
devices want an fd and the DAC model of a device node, and it was
turned down for the TSM's SPDM uAPI [2]. For a value or two, sysfs or a
plain ioctl stays simpler, and CTLV is not meant for that.

The uAPI is one ioctl on the device's fd:

  struct ctlv_op_exec {
          __u32 size;
          __u32 flags;
          __aligned_u64 op_id;
          __aligned_u64 request;
          __aligned_u64 reply;
          __u32 request_len;
          __u32 reply_len;
          __aligned_u64 generation;
          __aligned_u64 cursor;
  };

  ioctl(fd, CTLV_IOC_OP_EXEC, &exec);

An op is an action, executed once, or a query, which the generation
and the cursor carry across replies. Each op needs read or read-write
access, checked against the mode the device was opened with. A failed
op returns an errno, and in the reply buffer why the request was
refused and the offset of the offending TLV.

A family is specified in YAML. The root family, which every device
answers, lets a program not compiled against a family discover it. Its
first op:

  ops:
    # The families this device answers, this one first and the device family
    # last. The only names any reply of this family carries.
    family-get:
      type: query
      fd-access: read
      reply:
        # One entry per family of the chain.
        families[]:
          # The family ID, which bits 63..48 of the family's types carry.
          id: uint
          # The registry name, also what a uevent carries. Bounded here, this
          # being the only place a message carries a family name.
          name: string(..63)

ctlvgen --signatures prints a family's ops as calls, ? marking what
may be absent and [] what may repeat. The root family's three, with
the purpose of each:

  # The device's family chain, root first.
  family-get() -> { families[]: { id, name } }

  # Every op the device publishes, with its type, access and lengths.
  op-get() ->
      { ops[]: { id, type, availability?, disabled?, request-max-len?,
                 action-reply-max-len?, query-reply-min-len?,
                 query-reply-suggested-len?, fd-access?, error-info-max-len? } }

  # The tree of one op's request and reply.
  op-schema-get(id) -> { request?: schema-node, reply?: schema-node }

libctlv is a small C library for the mechanical parts: opening a
device by its family, building requests, parsing replies, reassembling
queries and building blob descriptors, with typed bindings generated
per family. ctlvctl needs no generated code, only the family's
specification, or the .json the build writes from it, for the names.
Both build with the kernel's CROSS_COMPILE, LLVM and O=. Here they
run in a VM, on a device of the simulation provider from the branch
[3], with CTLV_SPEC_DIR pointing at Documentation/ctlv/specs. The
device's MR 1 can be extended, and its evidence object 2 is an event
log:

  # Every CTLV device and its family chain.
  $ ctlvctl list
  attestation/attestation0        ctlv/ctlv-attestation/ctlv-attestation-sim

  # The ops the device publishes.
  $ ctlvctl ops attestation/attestation0
  # ctlv/ctlv-attestation/ctlv-attestation-sim, generation 0
  family-get     query   read        fixed  request 16    reply 112..65536
  op-get         query   read        fixed  request 16    reply 56..65536
  op-schema-get  query   read        fixed  request 40    reply 168..65536
  ...
  mr-read        query   read        fixed  request 80    reply 112..4096
  mr-extend      action  read-write  fixed  request 7232  reply 2824
  ...

  # mr-read's request and reply.
  $ ctlvctl schema attestation/attestation0 mr-read
  mr-read (query)
  request:
    root record
      mr-read id required uint [0, 4294967295]
      device-generation optional uint [0, 4294967295]
      mr-read options optional record
  reply:
    root record
      device-generation required uint [0, 4294967295]
      mr-generation required uint [0, 4294967295]
      mr-values required record x23
        mr-value.hash-algo required enum [0, 22] {HASH_ALGO_MD4, ...}
        mr-value.data required binary len [16, 64]

  # MR 1's banks.
  $ ctlvctl exec attestation/attestation0 mr-read id=1
  # mr-read, 1 fragment, generation 0
    device-generation 0
    mr-generation 2
    mr-values
      mr-value.hash-algo HASH_ALGO_SHA256
      mr-value.data hex:0000000000000000000000000000000000000000000000000000000000000000
    mr-values
      mr-value.hash-algo HASH_ALGO_SHA384
      mr-value.data hex:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

  # Extend MR 1 by a digest for each of its banks.
  $ ctlvctl exec attestation/attestation0 mr-extend --json '{"id":1,
          "mr-values":[
            {"hash-algo":"HASH_ALGO_SHA256","data":"hex:b1a3c4fc2b10743a5f79ce443178df6e99b4426fcae2ef3e1f76a6a26d8f0860"},
            {"hash-algo":"HASH_ALGO_SHA384","data":"hex:c8a6d5e64f03a5f3cad5125670fccff0c065a9db91f00a81eb6630836629a85969802308430aa28ea0d6fdd8b1eb0cc8"}]}'
  # mr-extend, 1 fragment, generation 0
    device-generation 0
    mr-generation 3
    mr-values
      mr-value.hash-algo HASH_ALGO_SHA256
      mr-value.data hex:b1a3c4fc2b10743a5f79ce443178df6e99b4426fcae2ef3e1f76a6a26d8f0860
    mr-values
      mr-value.hash-algo HASH_ALGO_SHA384
      mr-value.data hex:c8a6d5e64f03a5f3cad5125670fccff0c065a9db91f00a81eb6630836629a85969802308430aa28ea0d6fdd8b1eb0cc8

  # MR 1 again, with its new value and generation.
  $ ctlvctl exec attestation/attestation0 mr-read id=1
  # mr-read, 1 fragment, generation 1
    device-generation 0
    mr-generation 3
    mr-values
      mr-value.hash-algo HASH_ALGO_SHA256
      mr-value.data hex:a4fb91fd25115ec617cc4f17a40590e685cc58de5a65bb119e821e09d780a158
    mr-values
      mr-value.hash-algo HASH_ALGO_SHA384
      mr-value.data hex:1dcbf559ca9d6b48d782d268933c07a9e33c96bb21e1b868c2db7be929a852d3c5dbc5cf44427400c268a2f557c38c75

  # The event log, an output blob, written to a file.
  $ ctlvctl exec attestation/attestation0 evidence-get --json \
          '{"objects":[{"id":2,"data":{"file":"log.bin"}}]}'
  # evidence-get, 1 fragment, generation 0
    device-generation 0
    evidence-get evidence-generation 1
    evidence-get results
      evidence-get results.format ccel
      evidence-get results.length 65

There are no versions. struct ctlv_op_exec carries its size and grows
only at its end. A family grows by new ops and new optional fields,
and anything incompatible is a new op. Each family has a checked-in
ABI snapshot, and regen refuses a change that breaks it.

Events, a per-fd queue of what changed on a device, are left out until
their first user is posted, and so are memfd and dma-buf blobs. Both
are on the branch [3], with the generator's tests, KUnit, test
families and selftests.

The series adds 23787 lines:

  generator, Python                 7864
  core, C                           5643
  ctlvctl                           3519
  libctlv                           3242
  docs                              1510
  generated files                   1161
  meta-schemas, registry             368
  root family specification          211
  ABI snapshots                      118
  build                              151

Changes since RFC v1, each patch listing its own:

- Specs are written as Jason suggested: enums, flags, records and ops,
  each op the tree of its request and reply, every type derived from
  where its field sits. Attribute groups and sets are gone. The
  comment above an item is its doc, in the UAPI headers and the
  rendered docs, and ctlvgen --signatures prints the ops as above.
- TLV, type, record and field replace attr and nest.
- The events are left out, with read() and poll().
- A subsystem allocates its device and embeds CTLV, as fwctl does, and
  may route the ioctl from its own file operations. The engine is in
  lib/ctlv/, and a subsystem's class gets its nodes from CTLV, and
  there is no ctlv class.
- struct ctlv_op_exec is sized by its size field and read with
  copy_struct_from_user(). A reply buffer may be any length, and an
  output blob too short fails with EMSGSIZE and the length it needs.
- Enum extension points: an enum whose values a descendant family
  gives.
- An op that reads is <object>-get: families-dump and ops-dump are
  family-get and op-get.
- Inline messages are at most 64 KiB, and records nest at most 8 deep.
- The UAPI headers are in include/uapi/ctlv/.
- regen writes the ABI snapshots too, and refuses an ABI break unless
  ABI_BREAK=1.
- The userspace ABI opens with the goals, a worked example and a
  glossary, and collects the compatibility rules. The family guide is
  built around a worked example family.
- libctlv and ctlvctl are posted. ctlvctl runs every op with exec,
  takes a blob in --json as a file, as Aneesh's patched copy did, and
  sizes an output blob by the length the op fails with.

The patches:

  1-3    the spec language and generator, the message format and the
         family API, and the root family
  4      the userspace ABI
  5-11   messages, blobs, validation and introspection, then dispatch
  12     character device nodes
  13     how to write a family
  14-15  libctlv and ctlvctl

Note to reviewers: the uAPI, in 1, 2 and 4, and the family API, in 2
and 13, matter most at this stage.

[1] https://lore.kernel.org/all/20261015145053.3664509-1-jiri@resnulli.us/
[2] https://lore.kernel.org/all/20260921131911.532d81f4@kernel.org/
[3] https://github.com/jpirko/linux_mlxsw/commits/wip_attestation_all_2

Jiri Pirko (15):
  ctlv: Add the schema language and generator
  ctlv: Add the UAPI message format and family API
  ctlv: Add the root family specification and generated files
  Documentation: ctlv: Add userspace ABI
  ctlv: Prepare message input handling
  ctlv: Prepare blob descriptor validation
  ctlv: Prepare schema validation
  ctlv: Prepare message output handling
  ctlv: Prepare VA blob handling
  ctlv: Prepare runtime introspection
  ctlv: Add operation dispatch
  ctlv: Add character device nodes
  Documentation: ctlv: Describe how to write a family
  tools/ctlv: Add the userspace library
  tools/ctlv: Add ctlvctl

 Documentation/ctlv/abi/ctlv.yaml              |  111 +
 Documentation/ctlv/abi/families.registry.yaml |    7 +
 Documentation/ctlv/ctlv-registry-schema.yaml  |   38 +
 Documentation/ctlv/ctlv-schema.yaml           |  227 ++
 Documentation/ctlv/families.yaml              |   17 +
 .../ctlv/generated-files-schema.yaml          |   68 +
 Documentation/ctlv/generated-files.yaml       |   18 +
 Documentation/ctlv/specs/ctlv.yaml            |  211 ++
 Documentation/driver-api/ctlv.rst             |  723 +++++
 Documentation/driver-api/index.rst            |    1 +
 Documentation/userspace-api/ctlv.rst          |  783 +++++
 Documentation/userspace-api/index.rst         |    1 +
 .../userspace-api/ioctl/ioctl-number.rst      |    2 +
 MAINTAINERS                                   |   12 +
 include/linux/ctlv.h                          |  149 +
 include/linux/ctlv_device.h                   |   57 +
 include/linux/ctlv_family.h                   |  652 ++++
 include/linux/ctlv_gen.h                      |  154 +
 include/uapi/ctlv/ctlv.h                      |  180 ++
 include/uapi/ctlv/ctlv_families_gen.h         |   17 +
 include/uapi/ctlv/ctlv_gen.h                  |  278 ++
 lib/Kconfig                                   |    2 +
 lib/Makefile                                  |    2 +
 lib/ctlv/Kconfig                              |   13 +
 lib/ctlv/Makefile                             |    5 +
 lib/ctlv/blob.c                               |  421 +++
 lib/ctlv/blob.h                               |   15 +
 lib/ctlv/blob_desc.c                          |  101 +
 lib/ctlv/blob_desc.h                          |   29 +
 lib/ctlv/builder.c                            |  455 +++
 lib/ctlv/builder.h                            |   14 +
 lib/ctlv/core.c                               | 1169 +++++++
 lib/ctlv/ctlv_gen.c                           |  161 +
 lib/ctlv/device.c                             |  179 ++
 lib/ctlv/internal.h                           |   87 +
 lib/ctlv/introspection.c                      |  505 +++
 lib/ctlv/message.c                            |  393 +++
 lib/ctlv/message.h                            |   91 +
 lib/ctlv/schema.c                             | 1092 +++++++
 lib/ctlv/schema.h                             |   54 +
 tools/Makefile                                |    9 +-
 tools/ctlv/Makefile                           |   62 +
 tools/ctlv/ctlv-regen.sh                      |   64 +
 tools/ctlv/ctlvctl/.gitignore                 |    4 +
 tools/ctlv/ctlvctl/Makefile                   |   64 +
 tools/ctlv/ctlvctl/ctlvctl.c                  | 2787 +++++++++++++++++
 tools/ctlv/ctlvctl/spec.c                     |  672 ++++
 tools/ctlv/ctlvctl/spec.h                     |   60 +
 tools/ctlv/ctlvgen/__init__.py                |    1 +
 tools/ctlv/ctlvgen/cli.py                     |  178 ++
 tools/ctlv/ctlvgen/lib/__init__.py            |    1 +
 tools/ctlv/ctlvgen/lib/cenum.py               |  178 ++
 tools/ctlv/ctlvgen/lib/cgen.py                |  763 +++++
 tools/ctlv/ctlvgen/lib/compat.py              |  877 ++++++
 tools/ctlv/ctlvgen/lib/dump.py                |  161 +
 tools/ctlv/ctlvgen/lib/errors.py              |   16 +
 tools/ctlv/ctlvgen/lib/gen_doc.py             |  684 ++++
 tools/ctlv/ctlvgen/lib/gen_family.py          |  285 ++
 tools/ctlv/ctlvgen/lib/gen_kernel.py          |  576 ++++
 tools/ctlv/ctlvgen/lib/gen_runtime.py         |   66 +
 tools/ctlv/ctlvgen/lib/gen_uapi.py            |  182 ++
 tools/ctlv/ctlvgen/lib/gen_user.py            |  808 +++++
 tools/ctlv/ctlvgen/lib/outputs.py             |  363 +++
 tools/ctlv/ctlvgen/lib/semantics.py           | 1219 +++++++
 tools/ctlv/ctlvgen/lib/sizes.py               |  239 ++
 tools/ctlv/ctlvgen/lib/spec.py                |  813 +++++
 tools/ctlv/ctlvgen/lib/tree.py                |  158 +
 tools/ctlv/ctlvgen/lib/yamlload.py            |  138 +
 tools/ctlv/libctlv/Makefile                   |   41 +
 tools/ctlv/libctlv/ctlv.h                     |  413 +++
 tools/ctlv/libctlv/ctlv_user_gen.c            |  551 ++++
 tools/ctlv/libctlv/device.c                   |  412 +++
 tools/ctlv/libctlv/internal.h                 |  161 +
 tools/ctlv/libctlv/introspection.c            |  238 ++
 tools/ctlv/libctlv/message.c                  |  518 +++
 tools/ctlv/libctlv/schema.c                   |  742 +++++
 tools/ctlv/libctlv/spec.c                     |  186 ++
 tools/ctlv/libctlv/transport.c                |  572 ++++
 tools/ctlv/pyproject.toml                     |   30 +
 tools/ctlv/requirements.txt                   |    2 +
 80 files changed, 23787 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ctlv/abi/ctlv.yaml
 create mode 100644 Documentation/ctlv/abi/families.registry.yaml
 create mode 100644 Documentation/ctlv/ctlv-registry-schema.yaml
 create mode 100644 Documentation/ctlv/ctlv-schema.yaml
 create mode 100644 Documentation/ctlv/families.yaml
 create mode 100644 Documentation/ctlv/generated-files-schema.yaml
 create mode 100644 Documentation/ctlv/generated-files.yaml
 create mode 100644 Documentation/ctlv/specs/ctlv.yaml
 create mode 100644 Documentation/driver-api/ctlv.rst
 create mode 100644 Documentation/userspace-api/ctlv.rst
 create mode 100644 include/linux/ctlv.h
 create mode 100644 include/linux/ctlv_device.h
 create mode 100644 include/linux/ctlv_family.h
 create mode 100644 include/linux/ctlv_gen.h
 create mode 100644 include/uapi/ctlv/ctlv.h
 create mode 100644 include/uapi/ctlv/ctlv_families_gen.h
 create mode 100644 include/uapi/ctlv/ctlv_gen.h
 create mode 100644 lib/ctlv/Kconfig
 create mode 100644 lib/ctlv/Makefile
 create mode 100644 lib/ctlv/blob.c
 create mode 100644 lib/ctlv/blob.h
 create mode 100644 lib/ctlv/blob_desc.c
 create mode 100644 lib/ctlv/blob_desc.h
 create mode 100644 lib/ctlv/builder.c
 create mode 100644 lib/ctlv/builder.h
 create mode 100644 lib/ctlv/core.c
 create mode 100644 lib/ctlv/ctlv_gen.c
 create mode 100644 lib/ctlv/device.c
 create mode 100644 lib/ctlv/internal.h
 create mode 100644 lib/ctlv/introspection.c
 create mode 100644 lib/ctlv/message.c
 create mode 100644 lib/ctlv/message.h
 create mode 100644 lib/ctlv/schema.c
 create mode 100644 lib/ctlv/schema.h
 create mode 100644 tools/ctlv/Makefile
 create mode 100755 tools/ctlv/ctlv-regen.sh
 create mode 100644 tools/ctlv/ctlvctl/.gitignore
 create mode 100644 tools/ctlv/ctlvctl/Makefile
 create mode 100644 tools/ctlv/ctlvctl/ctlvctl.c
 create mode 100644 tools/ctlv/ctlvctl/spec.c
 create mode 100644 tools/ctlv/ctlvctl/spec.h
 create mode 100644 tools/ctlv/ctlvgen/__init__.py
 create mode 100755 tools/ctlv/ctlvgen/cli.py
 create mode 100644 tools/ctlv/ctlvgen/lib/__init__.py
 create mode 100644 tools/ctlv/ctlvgen/lib/cenum.py
 create mode 100644 tools/ctlv/ctlvgen/lib/cgen.py
 create mode 100644 tools/ctlv/ctlvgen/lib/compat.py
 create mode 100644 tools/ctlv/ctlvgen/lib/dump.py
 create mode 100644 tools/ctlv/ctlvgen/lib/errors.py
 create mode 100644 tools/ctlv/ctlvgen/lib/gen_doc.py
 create mode 100644 tools/ctlv/ctlvgen/lib/gen_family.py
 create mode 100644 tools/ctlv/ctlvgen/lib/gen_kernel.py
 create mode 100644 tools/ctlv/ctlvgen/lib/gen_runtime.py
 create mode 100644 tools/ctlv/ctlvgen/lib/gen_uapi.py
 create mode 100644 tools/ctlv/ctlvgen/lib/gen_user.py
 create mode 100644 tools/ctlv/ctlvgen/lib/outputs.py
 create mode 100644 tools/ctlv/ctlvgen/lib/semantics.py
 create mode 100644 tools/ctlv/ctlvgen/lib/sizes.py
 create mode 100644 tools/ctlv/ctlvgen/lib/spec.py
 create mode 100644 tools/ctlv/ctlvgen/lib/tree.py
 create mode 100644 tools/ctlv/ctlvgen/lib/yamlload.py
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
 create mode 100644 tools/ctlv/pyproject.toml
 create mode 100644 tools/ctlv/requirements.txt

-- 
2.56.0

