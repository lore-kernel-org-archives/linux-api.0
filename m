Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794586132;
	b=uRnmP3IuzWVBuIRNFzDIXkXBETVnNnKMdD6i2k50eH7++lZ/2cOHIMCVpHXPgpjBgz3E
	 he1tMiKj1xoiXUr1+d6XfTXyohcOjXyPyWyBvxKydapSgWo8uX/TN6ZLcnVaxeB3j0Ygh
	 gkcs7u2KT46p6c2WRBXOeL1SR8YS4PKyJEp5+tb7g32zv0HkoGNR98X/yAp6cscH4aV8V
	 wFyGVo7U7viErXDCZBTxrIig+d71gOYWegQRPToepvIWZnxW6Z9KQJWK9t5NF62AgJDWl
	 8wGwzr3WXN1c27V7VJWvimPq7eDKSthbNcfAbSZ/nsaw/aSTvF4Xu15b/DJxJSlJZDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586132;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pJiGPKb05r7Ps0IqRcz9AK5sRc4J5QU8pwZ2VZ2K32o=;
	b=Bp23tR3WXeSbRXdpQJ9ZAk25YJkyKWgk4TQRxdC25g62Rkinbyz0EyTqr54ijYgiMKO6
	 TWhVp5GYqRX+YKrvlGX8fyCHIEn4PHcd0Yr276Th1CIxQRXn9AQnggrm2+ySieMRq6R9+
	 fF7KQWHaCusxb1boFmnnUJEIIpBuLFnN23kgWwQY08H9y+fzUU7W5ywGO2c1DotFC6Vr/
	 /02EQqg2Ibgbk5XLGfGJQHNg3KF5+SZJquAQcvS/xjKMSr3rIb1/nDRVxn4ygYCkRX3O5
	 pF/aqljkTmEkTgCxAWoz/npLaxMZV45SVNcp7zF+SG6CmwN7xF2mz5JqAk7s2XGIGEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=PocBPvpa;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CDF60A381C
	for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 16:08:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44CDF60A381C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=PocBPvpa
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4910b863b84so1338420f8f.0
        for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 08:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1794586130; x=1795190930; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pJiGPKb05r7Ps0IqRcz9AK5sRc4J5QU8pwZ2VZ2K32o=;
        b=PocBPvpa1aKBMXFiCHl7eqNoaLxGmbamzQcisVGlvW2U9sJRsR3swyvK1Y5ug+oZjq
         veWU1XrSYLaglvZIDCiEVY1Kj4eWP39E5wVaOv97f5E39Wqvv5lPGkW7KDLELunMD2IA
         tPmW11YS57jtsLS/S82+aWaGQx1PRwG9ont4K0+c6+DfnhKn7nxs+BL52iEoIDhI+PFD
         ky76CxONTFAwlSKF5Uw7JLaLZtEch+BtNUL11ua+Tm7kO5QQOVsbUXi3DMhvIVwhgyaE
         Qw/DpVbuDM9fEh1kUHDNWeRSBukPV7I51e20V4EzlZVFnabTj4kxghudGLfoQO5nz0QN
         tk7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794586130; x=1795190930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pJiGPKb05r7Ps0IqRcz9AK5sRc4J5QU8pwZ2VZ2K32o=;
        b=uCZIIZ+eQb5HQSK87RQWeLH1D/4Hp19PuJZPfZUMDoWPN/uGqXxYbP2ZdIviCAeFkl
         KYopgWzeGD/aFdWxhlmgsaIkskB9noKVf2wsiO9TGshA9JN87SB4Nym/T5oJdJQpHqIw
         i1388tL2xpNOwaZ6WFgqSNVFsLqTapNJupS1iRUlfo+zqnTAkFxkZ+cISTLH2mDDGVLF
         CHsin5RRUmHMWJGqYUsb4CHm7b1oTlpPATRG69ApGvbl7dvdEFZuSyQYjlesTn5YnE45
         MDC6mop/qTOLTw6zxtcVOX0C/lT1kWGnO4vX0TjH+oT16L08i2aKTdJ7nr5ykzc3hLKg
         gE1g==
X-Forwarded-Encrypted: i=1; AL+hErEAoIxiZdpgk1IxTq34mI1mbhj4QJR+peWCAFWFhZDYLKdsNOJsgUGXdvh+stgqzaU6ppcwHinSZFM=@vger.kernel.org
X-Gm-Message-State: APuU4Z8p5KU5EUCwWOAGUdiqha0QCMtYvohiU8vqcSUmP8fwAsj9Jr1I
	k1hl3MKu1aMMCNLUXg16k80/Tenq9adcwus5p9EnHGbylSAs/MoNB8U8T6UY1Mjq+Ow=
X-Gm-Gg: AYBFou0dU9rQt4RUporTuUJlZJQKhm6Q2Ae3odFp51G25rF9+WzVnbHw9kKuYwGj7Fw
	dYuWOHpbVCyp+nhzARdTdg2BaQeq26rScoEbY1+F8HD0EmlqmKh1RcXhI9LJACiquXwomKxUdYE
	cmUf6xLkSIwWEJ76epVZ4jA6Mr2ImenTNTzhpPSZykArROT1S/PRXNHb+SqD7STFOtysemrx2Z1
	okIIaq+FFAN1DiciNBHyd6zLHd6MC1gPzNhH0jn4Wtok0E4JnrPICwvE9OocQqYgbkLyIKW0jRa
	d2E0swURt3IAllfq4IscBkV4RjN2GAf2vOeJQg3i8/MnqP6qCJGbilAFRuUEQLIznV6jSJfNyL8
	FAuQYmxi2CmvqqZ9Np0JAfFHhuzijLgq113mPrcC+GEGM3GYLYMEXM/sCyVkONQGu0aNtGar7Bq
	x4idJ43sUglIR8+apCwzSgZpZQBhx0gykwhMNq8aUkLLaXAi/kSi+RUjlJKhlK9J8ZgsS6EkTnF
	0O+ERN+xbsq/5NFFAhwqNxicZ+6ggLaCTbOEjxhxKjnUMOB0B4jqJ9iqxN05x6vdDHVaA34NViy
	Oj52QMKRDFhcx5qmsRG+5jF9XioXx2NIMSp+G5Id
X-Received: by 2002:a05:6000:41d7:b0:491:e477:6820 with SMTP id ffacd0b85a97d-49c70824309mr6707809f8f.20.1794586129450;
        Fri, 13 Nov 2026 08:08:49 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c605e4a2asm6254640f8f.39.2026.11.13.08.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 08:08:49 -0800 (PST)
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
Subject: [PATCH RFC v2 2/9] Documentation: attestation: Add userspace ABI
Date: Fri, 13 Nov 2026 17:08:31 +0100
Message-ID: <20261113160838.2512652-3-jiri@resnulli.us>
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

Describe the attestation family for userspace: its operations and their
errors, the evidence objects and the measurement registers.

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 Documentation/userspace-api/attestation.rst | 283 ++++++++++++++++++++
 Documentation/userspace-api/index.rst       |   1 +
 MAINTAINERS                                 |   1 +
 3 files changed, 285 insertions(+)
 create mode 100644 Documentation/userspace-api/attestation.rst

diff --git a/Documentation/userspace-api/attestation.rst b/Documentation/userspace-api/attestation.rst
new file mode 100644
index 000000000000..3c610acc3382
--- /dev/null
+++ b/Documentation/userspace-api/attestation.rst
@@ -0,0 +1,283 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
+Attestation userspace ABI
+=========================
+
+A confidential guest proves what it runs to a remote verifier with evidence: a
+statement of its measurements, signed by its root of trust and carrying a
+challenge the verifier chose, and the logs behind those measurements. An
+attestation provider gives its device a node, ``/dev/attestation/attestationN``.
+Through it a program asks for evidence, and reads and extends the measurement
+registers (MRs) the evidence reports.
+
+The node speaks CTLV, described in :doc:`ctlv`, as a descendant of the
+``ctlv-attestation`` family, one family per provider. Every operation below
+belongs to ``ctlv-attestation``, so a tool written against it works with any
+provider. The specification is
+``Documentation/ctlv/specs/ctlv-attestation.yaml`` and the constants are in
+``include/uapi/ctlv/ctlv_attestation_gen.h``.
+
+======================  ======  ==========  ================================
+Operation               Type    Access      Purpose
+======================  ======  ==========  ================================
+device-get              action  read        what the device supports
+evidence-get            action  read-write  evidence objects
+mr-get                  query   read        describe the MRs
+mr-read                 query   read        one MR's values
+mr-extend               action  read-write  extend one MR
+======================  ======  ==========  ================================
+
+``device-get`` is always provided. Every other operation is optional, and a
+device provides those its provider implements, which ``op-get`` lists. The
+errors below are the family's own. Those of the transport, such as ``EACCES``
+for a descriptor without the access an operation needs, are in :doc:`ctlv`,
+and once a device is gone or has stopped, every operation fails with
+``ENODEV``. A provider's own failure returns its errno, such as ``EIO``.
+
+Generations
+===========
+
+A counter tells a program whether what it holds is still current. It is 32
+bits wide. An operation that would advance it past its maximum fails with
+``EOVERFLOW`` and stops the device.
+
+``mr-generation``
+    The state of the MRs. It advances with every extension, and a reply that
+    depends on MR state carries the generation it reflects.
+
+Evidence
+========
+
+``device-get``
+--------------
+
+Describes the device: what it supports and the provider's own information. It
+takes no request. The reply carries:
+
+``caps``
+    A record for each part the device has:
+
+    ``caps.evidence``
+        With ``evidence-get``: one of ``objects`` for each object the device
+        produces, up to 16, as `Objects`_ describes.
+
+    ``caps.mr``
+        With MRs: ``flags``, which has ``extend`` where ``mr-extend`` is
+        provided. ``mr-read`` is always provided with MRs.
+
+``info``
+    The device's family's fields, its ``device-info``.
+
+``evidence-get``
+----------------
+
+Writes each object the request names into a blob the caller supplies. A
+signed object is made by the call, over the challenge, and never reused. The
+others, such as an event log, are read as they stand at the call. One call so
+returns signed evidence with the log needed to check it. The request carries:
+
+``challenge``
+    The challenge, described below. Present exactly when a signed object is
+    named.
+
+``objects``
+    1 to 16 objects, each naming one of the ``caps.evidence.objects`` of
+    ``device-get`` by its ``id`` and giving ``data``, the output blob it is
+    written to, sized as described below.
+
+The reply carries:
+
+``results``
+    One per object, in request order, each giving the object's format in
+    exactly one of ``format`` and ``vendor-format``, and its ``length``, the
+    bytes written to its blob.
+
+``mr-generation``
+    Where an object binds MRs, the MR generation the evidence reflects.
+
+``EINVAL``
+    A signed object is named without a challenge, a challenge is given
+    without one, or its length is one a signed object named does not take.
+    Two objects are the same.
+
+``EMSGSIZE``
+    An object's blob is too short for it. The error information's
+    ``required-length`` says how long it has to be.
+
+``ENOENT``
+    An object's ``id`` is not one ``device-get`` lists.
+
+``EPROTO``
+    The root of trust returned an object in a format the device does not
+    list for it.
+
+Access is read-write. Availability is dynamic: a device may switch the
+operation off for a time, and meanwhile it fails with ``EOPNOTSUPP``.
+
+The challenge
+~~~~~~~~~~~~~
+
+A signed object binds the challenge. Each signed object lists its
+``challenge-lengths``, up to 8, each one ``length`` or a range from
+``min-length`` to ``max-length``, and the subsystem keeps them within 1 to 4K.
+The challenge has to be of a length every signed object named lists.
+
+Pass a nonce from the verifier, or a hash that binds such a nonce to the
+caller's own context, such as a key the evidence is to vouch for. Never pass
+data a peer chose. Any process that can run ``evidence-get`` can have the
+device sign what it passes, and one that passes a peer's bytes makes the
+device a signing oracle for that peer.
+
+Objects
+~~~~~~~
+
+Each of ``caps.evidence.objects`` describes one object:
+
+``id``
+    0 to 15, which a request names it by.
+
+``class``
+    What the object is, as ``evidence-class`` below says.
+
+``formats`` and ``vendor-formats``
+    The formats it may have.
+
+``max-length``
+    The longest it gets, however many objects a call asks for.
+
+``challenge-lengths``
+    For a signed object, the challenge lengths it takes.
+
+``evidence-class`` says what an object is:
+
+``signed``
+    Evidence the root of trust signs over the challenge. It carries its own
+    signature.
+
+``event-log``
+    The platform's log of what firmware and the boot chain measured into the
+    MRs, for a verifier to replay. Later extends, through ``mr-extend`` or
+    otherwise, are not in it.
+
+A blob of the object's ``max-length`` always holds it. A shorter one saves
+memory where objects run shorter than their bound, as certificate chains do:
+where the object does not fit, ``evidence-get`` fails with ``EMSGSIZE`` and
+returns no evidence, and ``required-length`` in the error information is the
+length to retry with. The retry collects the evidence anew, and may pass the
+same challenge.
+
+Two enums name the formats:
+
+``evidence-format``
+    ``ctlv-attestation``'s, for a layout a standard defines, such as the
+    CCEL, so every family that produces it uses the same value.
+
+``evidence-vendor-format``
+    For a layout one vendor defines, whose values the device's family gives
+    through a CTLV enum extension point.
+
+The ABI check of ``regen`` covers both enums. An object lists the formats it
+may have, from either enum, in ``formats`` and ``vendor-formats``, and the
+reply names the one written in exactly one of ``format`` and
+``vendor-format``. A new layout is a new value.
+
+Measurement registers
+=====================
+
+Extending an MR folds a digest into its value, so the value commits to every
+extension in order. An MR has a value for each hash algorithm it supports, a
+bank. An MR's ``id`` is the device's handle for it, and ``mr-desc`` describes
+it:
+
+``name``
+    The platform's name for the MR, such as ``rtmr0``.
+
+``supported-hash-algorithms``
+    One for each bank, in the provider's order.
+
+``register-index``
+    The hardware's number for the MR, where it has one.
+
+``caps``
+    ``extend`` where the MR may be extended. A provider still refuses an
+    extend the platform forbids at the time, as with ``EPERM`` for a TPM PCR
+    the current locality may not extend.
+
+Every MR can be read, though a read can still fail, as when the caller lacks
+authorization or the platform's state forbids it.
+
+The name, banks, caps and register index describe an MR, and do not change.
+The values change with every extension, so the two are read apart.
+``mr-get`` describes every MR, which is how a program learns the IDs, or the
+one an ID names. It is answered from what the device keeps, while
+``mr-read``, which returns one MR's values, asks the hardware. ``mr-read`` and
+``mr-extend`` take only the ID.
+
+A hash algorithm is a constant of ``enum hash_algo`` in
+``include/uapi/linux/hash_info.h``, such as ``HASH_ALGO_SHA384``.
+
+Nothing reserves an MR, and the kernel does not arbitrate between its
+writers. Any program with a read-write descriptor can extend it, and so can
+the register's own interface, as for a TPM's PCRs. A program that replays an
+MR from its own records has to make sure, through the system's configuration,
+that it is the only writer; ``mr-generation`` counts only the extensions made
+through the device.
+
+``mr-get``
+----------
+
+Describes every MR, in fragments ordered by ID, or only the MR whose ``id``
+the request carries. Each is one of ``items``, with its ``id`` and its
+``mr-desc``, as `Measurement registers`_ lists it. The query's generation is
+the MR generation, so a continuation fails with ``ESTALE`` once any MR has
+changed.
+
+``ENOENT``
+    No MR has that ID.
+
+Access is read.
+
+``mr-read``
+-----------
+
+Returns the current values of the MR whose ``id`` the request carries. The
+reply carries:
+
+``mr-generation``
+    The MR generation of the values.
+
+``mr-values``
+    One for each bank, in ``mr-get``'s order, with its ``hash-algo`` and
+    ``data``.
+
+``ENOENT``
+    No MR has that ID.
+
+Access is read.
+
+``mr-extend``
+-------------
+
+Extends the MR whose ``id`` the request carries. The request carries one of
+``mr-values`` for each bank of the MR to extend, in any order, each a
+``hash-algo`` and a ``data`` of exactly that algorithm's digest size. The
+banks left out keep their values. The device hashes nothing for the caller.
+
+The reply carries ``mr-generation``, the MR generation after the extension.
+
+``ENOENT``
+    No MR has that ID.
+
+``EOPNOTSUPP``
+    The MR cannot be extended, or the provider cannot extend only some of its
+    banks.
+
+``EPERM``
+    The platform forbids extending the MR at the time.
+
+``EINVAL``
+    The request carries no ``mr-values``, a value is for a bank the MR does not
+    have or repeats one, or a digest has the wrong length.
+
+Access is read-write.
diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index d1b53c4e16eb..61051cd28fd1 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -36,6 +36,7 @@ Security-related interfaces
    mfd_noexec
    spec_ctrl
    tee
+   attestation
    check_exec
 
 Devices and I/O
diff --git a/MAINTAINERS b/MAINTAINERS
index fa450924b921..0c1778e676ed 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4439,6 +4439,7 @@ L:	linux-security-module@vger.kernel.org
 S:	Supported
 F:	Documentation/ctlv/abi/ctlv-attestation*
 F:	Documentation/ctlv/specs/ctlv-attestation*
+F:	Documentation/userspace-api/attestation*.rst
 F:	drivers/attestation/
 F:	include/uapi/ctlv/ctlv_attestation*
 
-- 
2.56.0

