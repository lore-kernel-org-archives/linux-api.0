Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794586146;
	b=FQJhW4k4Ur3ogNn2U93aAK5WG6XlOCTDDNbYcoY4IjuWmtA5kPYOTayD2rlF+x7c1kCS
	 rztonGIuZ7czS6Wlo8a00qpieFLvaa7im/5bTpEvn49w5wms7nqvHvOIDTahficNZqom+
	 NB4wuRaqQ41Gl3r2lrJR2CZ/rRHIToRCVgRujC892iM05vRGb7fsdl+LTgep8pcLFFuZg
	 RL1lZGnLOUU2aq2y8qEcgHKzfme87lDxeevU0nFiiXPxLmVmgiQ4qv2hef7KLk0pGwGwm
	 AoFI+AASolnYPl/14ER8P4V4DXw4T1JyOEbxt9WFNZSsc77ekEBQ5Y1JbWalNyVGhpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586146;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4K5GlaUAwj7rlWDE+PadxXcNrAnxe+HtCl8GDdjerQY=;
	b=ZwYfYcjuYObYfxA2fo7ZhLMsGd0+GMkRwhaHQNFcIMi7b2ooPmflTrL4428gfzndZsFC
	 vy4kwlx8wDF4suuARkAI3ViRELqLC4XFk9a3R9Ie3o1SR9z58uj8B9bLzJjEXYrmzPzx5
	 tddDjGmU7xSfV7HmYcggj4vnTbIT0U1VfQL2DL8txdNFH6b+DbajL0QH0zcPe0725k1MB
	 RR9wkMDJNXV7P3Nv1L4a7TNLzjjaL7eQzu6PiUSyN834PJvL9Bp+q0IhX8EuWD2Ufq7Nd
	 HMHwyjY4it8w0m05HYQfeF3KiwM5sJaQrn+9lU9x4AnJh484xh/d/oz+3WJHEP+nL9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=L5aslh9k;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825F7606D44B
	for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 16:09:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 825F7606D44B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=L5aslh9k
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-497614c95f0so541404f8f.1
        for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 08:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1794586145; x=1795190945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4K5GlaUAwj7rlWDE+PadxXcNrAnxe+HtCl8GDdjerQY=;
        b=L5aslh9k03tHIBpBWCF7LXJtSlzgiBwZaQi6ETohTvC/Xpm9VReBQUFcwWdubgvfKW
         gA50G/nbPuO+4A9BAz6iT3DxrCFemceLT8tbgtvonEC3tghMbtAFmCO00V+mz2qnjc0t
         Yjcx8gjzIenwXY0C1P+pLN06pW4qhOILA6+cA8p7s0DsCu4VRtAbIMzVpj1KTZb87BoY
         t1WXv/s7uc2Es+gPW+eIj6GHEUrmhjanxjM1RL6cqLupH4M7y4rp/toUPVbnSikae0xp
         7AFMWwwr+2dLfxXnU8eNtLJt+cMoO/Zn+pxn5C47LcxV8xb1yEK0/IKm/g9E+WYJ6FV0
         Sirw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794586145; x=1795190945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4K5GlaUAwj7rlWDE+PadxXcNrAnxe+HtCl8GDdjerQY=;
        b=bSc+33aUWhDb3HYQmVDf+7qIb4BzIW0eKIaYlAydERjKSxMeoJ5LU/AjTC11he2B4B
         BjVymkBXPLxkuWCdWDm3TkggKQ94VEXPB6C4cBiQ7So++xd8RN7PlJe6QXzNF9QO05dl
         goL1iD7SFwi3fuBI2dV9GNV6EQLnBK0xM6wBs2hop0xXlmqz/i7cn+mW+RUw7xRNhX/c
         EWB80S/84aTaeXoyj+9W/46wWIkRsUxGXRbKIpm1QeyxsPn/AR6UhkTQgatG1Ab97hBq
         vsHui+rQ4hr6iAfXZl8FlRoO+SFehLMBOSZW9AXgKoZoREHkzaqN7KeB9H+SfSekvrd2
         RYig==
X-Forwarded-Encrypted: i=1; AL+hErGrsR4m9yRfsc5g28dzvQctpVpRHnWpkD+AnMdW+11pczqPZZrOrhHB13CmxUEB2vft7iue4P6eXt8=@vger.kernel.org
X-Gm-Message-State: APuU4Z/je6M7WUTQ8uPzxX5An6RQRsciujK3qo6QU5zhRTJDZP1VyOdE
	ZkMIvLiT2FJtXnpiooPV3pn5x1/MAxTxmoXTUlv/P0bgie2nbFGc9TLx7/cLlVWnFZk=
X-Gm-Gg: AYBFou1CEt/tehWw9yt3lFLyJkKiCsTXxkxFq1tfx52U6d/F4PSEsv2vofRWu//6TkG
	natwiSroGV1KrUJNmod7cT3m04TdtfeB3Nm4tRJmwyj1iYiexr5tHdatJYSbs7AXIDEX4rh4iCP
	aUlqOUG5D96tvo7Z3EzcH6MF3s77grq54YYGb+HrZxrJY9tllN2LW4mxNBdzyAxxF1XfTuEVVkp
	tSd4Qsbxk8RThjLoGaTE2ZpA9bQ3h1JF7lN/6oBopP1NAA0Efwg75v0rPusVAAtrv4aGIfcCgi4
	cNZuioiZqcHH5khCgxfXCmVn/ACt/s4QXnatIDPH8lcTpUsECfDvPig/cIaMoOW2m0exSCEkrcZ
	kN1QJXKDu/riG4qXweTa1/mEL33IZydwWBKShiHw6c0pzFt1mers3I+XLWj1gw1XCjO89On3oK2
	8xCiQZnEYIiV53y/qVftzFy7Q9g0+ea9e84whAul7HonnS6MD8elS19zm3dajWcWWRHNHobFriF
	bY9paJlPSlmbFDMvt5cKImCAh5xhGSpDyRb4vtdem7FCBYjVYkVU3vEhVMC+0kXTLL78hWh3PmV
	866GqJM2ZT4/XNGO8GiPbmX4M4w7IAbmnXM1i0ADMuy9E/BnDHH9zNEarSP3tA==
X-Received: by 2002:a05:6000:4289:b0:492:b221:ac38 with SMTP id ffacd0b85a97d-49c7381b4e2mr6215071f8f.26.1794586144718;
        Fri, 13 Nov 2026 08:09:04 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f7828a4sm6181115f8f.23.2026.11.13.08.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 08:09:04 -0800 (PST)
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
Subject: [PATCH RFC v2 6/9] Documentation: attestation: Describe how to write a provider
Date: Fri, 13 Nov 2026 17:08:35 +0100
Message-ID: <20261113160838.2512652-7-jiri@resnulli.us>
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

Describe how a provider registers with the attestation core, how other
writers share its MRs and how it is torn down, with the kernel-doc of
the provider API.

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- split out of the provider and instance core patch
- dropped the journal from the overview
- said how other writers extend the same MRs
- added the kernel-doc to the driver API page
---
 Documentation/driver-api/attestation.rst    | 99 +++++++++++++++++++++
 Documentation/driver-api/index.rst          |  1 +
 Documentation/userspace-api/attestation.rst |  3 +-
 MAINTAINERS                                 |  1 +
 4 files changed, 103 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/driver-api/attestation.rst

diff --git a/Documentation/driver-api/attestation.rst b/Documentation/driver-api/attestation.rst
new file mode 100644
index 000000000000..4137a856aea9
--- /dev/null
+++ b/Documentation/driver-api/attestation.rst
@@ -0,0 +1,99 @@
+.. SPDX-License-Identifier: GPL-2.0-only
+
+===========
+Attestation
+===========
+
+The attestation subsystem gives each provider device a node of the
+``attestation`` class, ``/dev/attestation/attestationN``, which answers as a
+descendant of the ``ctlv-attestation`` family, one family per provider.  A
+program tells providers apart by the last entry of ``family-get`` on the
+open device, and generic tools use the ``ctlv-attestation`` operations on any
+of them.  The subsystem owns common evidence retrieval and
+measurement-register topology.  Providers retain ownership of native hardware
+access and immutable capability descriptions.
+
+Registering a provider
+======================
+
+A provider embeds ``struct attestation_dev`` first in its own structure and
+allocates both with ``attestation_alloc()``, passing its
+``struct attestation_provider`` and its family descriptor, which inherits
+``ctlv-attestation``:
+
+.. code-block:: c
+
+    struct foo {
+            struct attestation_dev att;
+            struct foo_hw *hw;
+    };
+
+    foo = attestation_alloc(parent, &foo_provider,
+                            &ctlv_attestation_foo_family, struct foo, att);
+    if (IS_ERR(foo))
+            return PTR_ERR(foo);
+    foo->hw = hw;
+    ret = attestation_register(&foo->att);
+    if (ret) {
+            attestation_put(&foo->att);
+            return ret;
+    }
+
+A provider callback gets the ``struct attestation_dev`` and reaches the
+provider's structure with ``container_of()``.  A CTLV callback of the
+provider's own family gets the CTLV instance, which
+``attestation_from_ctlv()`` turns into the device.  No provider callback runs
+before ``attestation_register()``, so the provider finishes its own setup in
+between.  The descriptor, evidence capabilities, fixed MR properties, strings
+and arrays remain immutable until the last ``attestation_put()``.
+
+The subsystem embeds the CTLV instance, and its hooks run every operation,
+those of the device's family included, under one instance mutex.  That
+serializes an operation and its native callback.
+
+Every MR can be read, so a provider with MRs implements ``mr_read``.
+Fixed MRs are listed in the provider descriptor.  Their property storage
+remains valid until the last ``attestation_put()``.
+
+The evidence capabilities list the objects ``evidence-get`` produces, each
+object's ID being its index.  An object gives its class and the formats it
+may have, ``ctlv-attestation``'s ``evidence-format`` or its family's
+``evidence-vendor-format``, and a signed object its challenge lengths.
+``attestation_alloc()`` refuses a format the family does not give.
+
+``evidence_get`` writes each object with ``attestation_evidence_write()``,
+which fails the operation with ``-EMSGSIZE`` where the caller's blob is too
+short, and tells the caller how long it has to be.  It fills in each object's
+result: the format written and its length.  A format the object does not list
+fails the call with ``-EPROTO``.
+
+Other writers
+=============
+
+This interface is not the only way to extend a measurement register, and it
+does not arbitrate between the ways there are.  Every program holding a
+read-write descriptor of the device can extend a register through
+``mr-extend``, and a register with a native interface of its own can be
+extended through that too, as a TPM's PCRs are by programs using
+``/dev/tpm0`` or ``/dev/tpmrm0`` and by IMA.  Nothing reserves a register for
+one writer.  A register two writers extend holds the extensions of both, in
+the order they arrived, and ``mr-read`` and the evidence report it as it is.
+A program that replays a register from its own records has to be its only
+writer, by agreement with whatever else runs on the system.
+
+Teardown
+========
+
+``attestation_unregister()`` first removes the node, so nothing opens the
+device again.  It then withdraws the device from the kernel registry, refusing
+the operations of files still open.  Only then does it unpublish the CTLV
+instance, which drains the operations in flight.  No provider callback runs
+once it returns, so the provider may release its native state before
+``attestation_put()``.  Open files keep the structure until they close.
+
+Kernel API
+==========
+
+.. kernel-doc:: include/linux/attestation.h
+.. kernel-doc:: drivers/attestation/core/core.c
+   :export:
diff --git a/Documentation/driver-api/index.rst b/Documentation/driver-api/index.rst
index 0c5b9d2165d8..625355c504ef 100644
--- a/Documentation/driver-api/index.rst
+++ b/Documentation/driver-api/index.rst
@@ -38,6 +38,7 @@ of interest to most developers working on device drivers.
    early-userspace/index
    connector
    ctlv
+   attestation
    device-io
    devfreq
    dma-buf
diff --git a/Documentation/userspace-api/attestation.rst b/Documentation/userspace-api/attestation.rst
index 3c610acc3382..16646d8b60d7 100644
--- a/Documentation/userspace-api/attestation.rst
+++ b/Documentation/userspace-api/attestation.rst
@@ -16,7 +16,8 @@ The node speaks CTLV, described in :doc:`ctlv`, as a descendant of the
 belongs to ``ctlv-attestation``, so a tool written against it works with any
 provider. The specification is
 ``Documentation/ctlv/specs/ctlv-attestation.yaml`` and the constants are in
-``include/uapi/ctlv/ctlv_attestation_gen.h``.
+``include/uapi/ctlv/ctlv_attestation_gen.h``. Writing a provider is
+:doc:`/driver-api/attestation`.
 
 ======================  ======  ==========  ================================
 Operation               Type    Access      Purpose
diff --git a/MAINTAINERS b/MAINTAINERS
index e57fc8bb9c1d..172b20d5fdd1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4439,6 +4439,7 @@ L:	linux-security-module@vger.kernel.org
 S:	Supported
 F:	Documentation/ctlv/abi/ctlv-attestation*
 F:	Documentation/ctlv/specs/ctlv-attestation*
+F:	Documentation/driver-api/attestation.rst
 F:	Documentation/userspace-api/attestation*.rst
 F:	drivers/attestation/
 F:	include/linux/attestation*
-- 
2.56.0

