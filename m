Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9203B71AC
	for <linux-api@vger.kernel.org>; Thu, 15 Oct 2026 14:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075865; cv=none; b=C9hSBP1FBdRza9Du3qUU5SXvMw4ML4BawYinkMpNIfqPIZPWbEXftlEBxd/c5KxvCQTLewpv4tvGYiW/hYGZhUwDMD3ASrkIQcCZKpQnr4SCC3lEqP1AU9wT9V7P0b1FP+o85fW50Umt2W0BPLhGpqTkI7FCW4gn5k3/6Dtib6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075865; c=relaxed/simple;
	bh=30pkOtZgf9ME4AwuW1ixELazskhl9vK+QR4jNkkbEPw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Via36PJpWdcBWv2mM2nxeh5wd8mgpO/axN3OY1HQPqQCvqxzyOLl9MKKPTFmbT+Z1tXK6czx3OUbFqytFi4TpeP1e7Fx8Sw+YnKm+y+Aj9nGg/F3b8/ooXMLytffJWUJrtBrafJRKI2hs7R3BOEf45EhBNBNdb5QBwg+DYWiFO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=cZBl14wu; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="cZBl14wu"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6acbdbc1725so3113032a12.3
        for <linux-api@vger.kernel.org>; Thu, 15 Oct 2026 07:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1792075860; x=1792680660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wJJUWKqlF+gd3ZMu1go4tClyLr+/3z2AgdparxQCI4I=;
        b=cZBl14wuxRuixyycotbT0uMHXxHkmNJJ38y2m94hJK3eB6Iqhx+Hq2HS30+2GLIZgC
         VFXB+4YAwncKqySEhsGr53Hh0n5zh8RgjX4Q0a9bK7VAUtRSrZ6y9AaANDWMWyavbbuj
         1q1WMfqXu00VupsxKqE9hpslw+CZcwIY98xKXOunrucjpn5gNOAHokYjreaErxSY7WgW
         1K8Bi2Xty6ABUoYW9IQRLw4MwAWxIbra/1sapDJH/ozgxGXPYiGZrf2ZLbUs5zUKD/T+
         9dZCfqEFU6GO4s/oXPFilGh/zJQMdR3hAODtRs5Gl8aNo3fd9rkqRcBmSyxRTZb/T64g
         Nq6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075860; x=1792680660;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wJJUWKqlF+gd3ZMu1go4tClyLr+/3z2AgdparxQCI4I=;
        b=nr0834bRRkN+JTjFr32nHzytn5jCcI37W/9JYrzYBQ6DQmjEtNDEirJbi2LSb5mVnI
         IcHEA9X/qvFABPlwrJ1f/GXBsJpKCb+XB7k3CT0pZ67uzJ560GPV0PO0wzoqY3kkg+SJ
         syPInDTdhiXvP4ZLLcb0/BKzl6HLNcemO7qve97xU93qH9QEX51Gl6irOoiUm1jlUllN
         wktBSczHutvJ2T21IJ9FOD1xPcWzLnFDQI5rZppqHWmUG/BfrVpY9eBxourKv7wEazXf
         gjb3WstQRDs65+xxpKJ+MaS9v3hE4KGm9q1cQtznDZaLYdZcGQJApDWptkLWHqgLoM5Q
         yymg==
X-Forwarded-Encrypted: i=1; AKwUvByrB2zOlI1I5xK7VxdaJHpBpZ74sDjrqol4uzh+Tb0S483NJK61etDfjGccTMGKpHfoG/xVhxr96GA=@vger.kernel.org
X-Gm-Message-State: AFq9FYJr9q0yuy1GU4d0mrB5ga97YclqqRBpMUCB8GxBGK+XP/sqtUP6
	50ZfMZhVnPRz6gG3488jnus3H12r+vMBuqnopP790Nc4afYwsoCJjBmxHHaRsk4Eo+M=
X-Gm-Gg: AYBFou0B8HJhg/fXcBN5fDQaNmGXKD1xD0fnZDPCe+pghtbGX8PpFUc0zc1X/WZCvxH
	lA4m39de7PGKQCDSKrhzPWtniSTWtkU3RXieBtHKg2Yiz8HL0MPSnLjTqSIuNfwakV01Jh0A0sl
	Ueb6Adip2FVbyn2akfZGy8s7AjIgLdgNU4vhHQQQn8z53qSOBi4IeTrrHhAEvKjJ+OBZmtn5NSU
	dBdwngTVrVIicL4ZMLcmcjQGXpUHb7661JN7UTDlLpnYkt8nhIR5x5toN25oWnrIZEFvc8KKZIT
	Ddd3KX7eBPAxcOBDyPJ70WdifY/ooaBiDu+l6dHums26Emsjjdy6Pe4fiqCRXookriDiEfuT011
	Uo/TmqCcx0q2uUvYjWZUH9wrTi1eCEfyW9v1fFm6EYlxxA1StuqRjm/fVi89kSVibCgwZsErt1s
	boop26yVyrVC1wdLLc3G1trhPjJhDW4UHjxLbKEBTmaH+1EQeThc1Hc98az/Lrkk9wLSSJE4FGG
	WpwXv5r/Q==
X-Received: by 2002:a05:6402:27c8:b0:6ac:94cf:9f1d with SMTP id 4fb4d7f45d1cf-6b1e49eb8bcmr7444996a12.21.1792075859704;
        Thu, 15 Oct 2026 07:50:59 -0700 (PDT)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b203862c4esm2665322a12.16.2026.10.15.07.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:50:59 -0700 (PDT)
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
	peter.fang@intel.com
Subject: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX support
Date: Thu, 15 Oct 2026 16:50:33 +0200
Message-ID: <20261015145053.3664509-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

Linux has several attestation interfaces tied to individual technologies.
That makes evidence retrieval, measurement registers, device state and
kernel consumers provider-specific.

This series introduces a common attestation subsystem. Its goal is to
support platform, TEE and device providers through one model, including
TPM2, TDX, SEV-SNP, Arm CCA, FIRME, Caliptra and PCI/TSM-backed devices.
This first series implements the common subsystem and a TDX provider.
Existing native TDX tsm_mr and tsm_report interfaces remain independent.

Attestation devices use CTLV, a schema-driven character-device TLV UAPI.
Compared with sysfs or configfs, CTLV executes one validated request
atomically instead of assembling a transaction through several files.
Compared with netlink, an opened device fd directly identifies authority
and lifetime, can be delegated normally, and owns its event queue. CTLV
also provides:

  - generated kernel metadata, UAPI constants and documentation;
  - strict type, bounds, nesting and required-field validation;
  - runtime operation and schema introspection;
  - family inheritance and extension points;
  - fragmented queries with generation checks;
  - per-fd event subscription, overflow reporting and removal notification;
  - large input and output blobs.

The attestation family exposes capabilities, evidence, measurement-register
topology and operations, an append-only MR journal and journal
notifications. This first ABI contains the paths exercised by TDX. Extended
evidence classes, dynamic registers, record payloads, verdict recording and
device-security transitions follow with providers that need them and are out
of scope of this initial patchset. The broader direction is illustrated here:

https://github.com/jpirko/linux_mlxsw/commits/wip_attestation_all_1

That branch also contains additional providers (test and sim),
attestation core extensions, libctlv and ctlvctl. With the tools
and kernel specifications, an attestation device can be used as follows:

  # Discover CTLV devices and their family chains.
  ctlvctl --spec-dir Documentation/ctlv/specs list

  # Inspect the root-family lineage and attestation capabilities.
  ctlvctl --spec-dir Documentation/ctlv/specs query ctlv0 families-dump
  ctlvctl --spec-dir Documentation/ctlv/specs query ctlv0 device-get

  # List the measurement registers of the attestation device.
  ctlvctl --spec-dir Documentation/ctlv/specs query ctlv0 mr-dump

  # Read RTMR0 (MR 1).
  ctlvctl --spec-dir Documentation/ctlv/specs \
          query ctlv0 mr-read mr.id=1

  # Extend RTMR0 with 48 zero bytes (SHA-384).
  digest=$(printf '%096d' 0)
  ctlvctl --spec-dir Documentation/ctlv/specs \
          exec ctlv0 mr-extend --json \
          '{"id":1,"value":[{"hash-algo":5,"data":"hex:'"$digest"'"}]}'

  # Retrieve the RTMR0 journal.
  ctlvctl --spec-dir Documentation/ctlv/specs \
          query ctlv0 mr-log-get --json '{"selection":[{"id":1}]}'

The 20 patches are organized as follows:

  1-13    add CTLV, its generator and documentation
  14-17   add the base attestation family and implementation
  18-20   expose the native TDX service and add the TDX family

Note to reviewers: Please focus on the overall design, UAPI and internal
attestation-provider API. The internal CTLV and attestation implementations
remain rough around the edges.

Jiri Pirko (20):
  ctlv: Add the schema language and generator
  ctlv: Add the UAPI wire format and family API
  ctlv: Add the root family specification and generated files
  Documentation: ctlv: Add userspace ABI
  ctlv: Prepare message input handling
  ctlv: Prepare blob descriptor validation
  ctlv: Prepare schema validation
  ctlv: Prepare message output handling
  ctlv: Prepare VA blob handling
  ctlv: Prepare event queue support
  ctlv: Prepare runtime introspection
  ctlv: Add device and operation dispatch
  Documentation: ctlv: Describe how to write a family
  attestation: Add the base family specification and generated files
  attestation: Prepare provider and instance core
  attestation: Prepare measurement register journal
  attestation: Add CTLV operation handling
  tdx-guest: Expose the native attestation service API
  attestation: Add the TDX family specification and generated files
  attestation: Add the TDX family implementation

 .../ctlv/abi/ctlv-attestation-tdx.yaml        |   22 +
 Documentation/ctlv/abi/ctlv-attestation.yaml  |  184 ++
 Documentation/ctlv/abi/ctlv.yaml              |  186 ++
 Documentation/ctlv/abi/families.registry.yaml |    9 +
 Documentation/ctlv/ctlv-registry-schema.yaml  |   38 +
 Documentation/ctlv/ctlv-schema.yaml           |  359 ++++
 Documentation/ctlv/families.yaml              |   15 +
 .../ctlv/generated-files-schema.yaml          |   64 +
 Documentation/ctlv/generated-files.yaml       |   31 +
 .../ctlv/specs/ctlv-attestation-tdx.yaml      |   30 +
 .../ctlv/specs/ctlv-attestation.yaml          |  347 ++++
 Documentation/ctlv/specs/ctlv.yaml            |  379 ++++
 Documentation/driver-api/attestation.rst      |   64 +
 Documentation/driver-api/ctlv.rst             |  422 +++++
 Documentation/driver-api/index.rst            |    2 +
 Documentation/userspace-api/ctlv.rst          |  507 ++++++
 Documentation/userspace-api/index.rst         |    1 +
 .../userspace-api/ioctl/ioctl-number.rst      |    2 +
 Documentation/virt/coco/tdx-guest.rst         |   18 +
 MAINTAINERS                                   |   26 +
 drivers/Kconfig                               |    4 +
 drivers/Makefile                              |    2 +
 drivers/attestation/Kconfig                   |   26 +
 drivers/attestation/Makefile                  |   10 +
 drivers/attestation/core/core.c               |  354 ++++
 drivers/attestation/core/ctlv.c               |  520 ++++++
 drivers/attestation/core/events.c             |   65 +
 drivers/attestation/core/internal.h           |  108 ++
 drivers/attestation/core/mr.c                 |  376 ++++
 .../generated/ctlv_attestation_gen.c          |  234 +++
 .../generated/ctlv_attestation_gen.h          |  198 +++
 .../generated/ctlv_attestation_tdx_gen.c      |   61 +
 .../generated/ctlv_attestation_tdx_gen.h      |   66 +
 drivers/attestation/providers/tdx.c           |  277 +++
 drivers/ctlv/Kconfig                          |   12 +
 drivers/ctlv/Makefile                         |    5 +
 drivers/ctlv/blob.c                           |  355 ++++
 drivers/ctlv/blob.h                           |   15 +
 drivers/ctlv/blob_desc.c                      |  102 ++
 drivers/ctlv/blob_desc.h                      |   29 +
 drivers/ctlv/builder.c                        |  374 ++++
 drivers/ctlv/builder.h                        |   14 +
 drivers/ctlv/core.c                           | 1517 +++++++++++++++++
 drivers/ctlv/ctlv_gen.c                       |  229 +++
 drivers/ctlv/device.h                         |   55 +
 drivers/ctlv/event.c                          |  713 ++++++++
 drivers/ctlv/event.h                          |   69 +
 drivers/ctlv/internal.h                       |   81 +
 drivers/ctlv/introspection.c                  |  512 ++++++
 drivers/ctlv/message.c                        |  403 +++++
 drivers/ctlv/message.h                        |   92 +
 drivers/ctlv/schema.c                         | 1047 ++++++++++++
 drivers/ctlv/schema.h                         |   50 +
 drivers/virt/coco/tdx-guest/tdx-guest.c       |  258 ++-
 include/linux/attestation.h                   |  138 ++
 include/linux/ctlv.h                          |  249 +++
 include/linux/ctlv_family.h                   |  551 ++++++
 include/linux/ctlv_gen.h                      |  137 ++
 include/linux/tdx-guest.h                     |   75 +
 include/uapi/linux/ctlv.h                     |  183 ++
 include/uapi/linux/ctlv_attestation_gen.h     |  252 +++
 include/uapi/linux/ctlv_attestation_tdx_gen.h |   44 +
 include/uapi/linux/ctlv_families_gen.h        |   17 +
 include/uapi/linux/ctlv_gen.h                 |  271 +++
 tools/ctlv/Makefile                           |   59 +
 tools/ctlv/ctlv-regen.sh                      |   55 +
 tools/ctlv/ctlvgen/__init__.py                |    1 +
 tools/ctlv/ctlvgen/cli.py                     |  172 ++
 tools/ctlv/ctlvgen/lib/__init__.py            |    1 +
 tools/ctlv/ctlvgen/lib/cgen.py                |  825 +++++++++
 tools/ctlv/ctlvgen/lib/compat.py              |  821 +++++++++
 tools/ctlv/ctlvgen/lib/errors.py              |   14 +
 tools/ctlv/ctlvgen/lib/gen_family.py          |  347 ++++
 tools/ctlv/ctlvgen/lib/gen_kernel.py          |  517 ++++++
 tools/ctlv/ctlvgen/lib/gen_uapi.py            |  223 +++
 tools/ctlv/ctlvgen/lib/outputs.py             |  329 ++++
 tools/ctlv/ctlvgen/lib/semantics.py           |  893 ++++++++++
 tools/ctlv/ctlvgen/lib/sizes.py               |  238 +++
 tools/ctlv/ctlvgen/lib/spec.py                |  583 +++++++
 tools/ctlv/ctlvgen/lib/tree.py                |   71 +
 tools/ctlv/ctlvgen/lib/yamlload.py            |   83 +
 tools/ctlv/pyproject.toml                     |   22 +
 tools/ctlv/requirements.txt                   |    2 +
 83 files changed, 18084 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/ctlv/abi/ctlv-attestation-tdx.yaml
 create mode 100644 Documentation/ctlv/abi/ctlv-attestation.yaml
 create mode 100644 Documentation/ctlv/abi/ctlv.yaml
 create mode 100644 Documentation/ctlv/abi/families.registry.yaml
 create mode 100644 Documentation/ctlv/ctlv-registry-schema.yaml
 create mode 100644 Documentation/ctlv/ctlv-schema.yaml
 create mode 100644 Documentation/ctlv/families.yaml
 create mode 100644 Documentation/ctlv/generated-files-schema.yaml
 create mode 100644 Documentation/ctlv/generated-files.yaml
 create mode 100644 Documentation/ctlv/specs/ctlv-attestation-tdx.yaml
 create mode 100644 Documentation/ctlv/specs/ctlv-attestation.yaml
 create mode 100644 Documentation/ctlv/specs/ctlv.yaml
 create mode 100644 Documentation/driver-api/attestation.rst
 create mode 100644 Documentation/driver-api/ctlv.rst
 create mode 100644 Documentation/userspace-api/ctlv.rst
 create mode 100644 drivers/attestation/Kconfig
 create mode 100644 drivers/attestation/Makefile
 create mode 100644 drivers/attestation/core/core.c
 create mode 100644 drivers/attestation/core/ctlv.c
 create mode 100644 drivers/attestation/core/events.c
 create mode 100644 drivers/attestation/core/internal.h
 create mode 100644 drivers/attestation/core/mr.c
 create mode 100644 drivers/attestation/generated/ctlv_attestation_gen.c
 create mode 100644 drivers/attestation/generated/ctlv_attestation_gen.h
 create mode 100644 drivers/attestation/generated/ctlv_attestation_tdx_gen.c
 create mode 100644 drivers/attestation/generated/ctlv_attestation_tdx_gen.h
 create mode 100644 drivers/attestation/providers/tdx.c
 create mode 100644 drivers/ctlv/Kconfig
 create mode 100644 drivers/ctlv/Makefile
 create mode 100644 drivers/ctlv/blob.c
 create mode 100644 drivers/ctlv/blob.h
 create mode 100644 drivers/ctlv/blob_desc.c
 create mode 100644 drivers/ctlv/blob_desc.h
 create mode 100644 drivers/ctlv/builder.c
 create mode 100644 drivers/ctlv/builder.h
 create mode 100644 drivers/ctlv/core.c
 create mode 100644 drivers/ctlv/ctlv_gen.c
 create mode 100644 drivers/ctlv/device.h
 create mode 100644 drivers/ctlv/event.c
 create mode 100644 drivers/ctlv/event.h
 create mode 100644 drivers/ctlv/internal.h
 create mode 100644 drivers/ctlv/introspection.c
 create mode 100644 drivers/ctlv/message.c
 create mode 100644 drivers/ctlv/message.h
 create mode 100644 drivers/ctlv/schema.c
 create mode 100644 drivers/ctlv/schema.h
 create mode 100644 include/linux/attestation.h
 create mode 100644 include/linux/ctlv.h
 create mode 100644 include/linux/ctlv_family.h
 create mode 100644 include/linux/ctlv_gen.h
 create mode 100644 include/linux/tdx-guest.h
 create mode 100644 include/uapi/linux/ctlv.h
 create mode 100644 include/uapi/linux/ctlv_attestation_gen.h
 create mode 100644 include/uapi/linux/ctlv_attestation_tdx_gen.h
 create mode 100644 include/uapi/linux/ctlv_families_gen.h
 create mode 100644 include/uapi/linux/ctlv_gen.h
 create mode 100644 tools/ctlv/Makefile
 create mode 100755 tools/ctlv/ctlv-regen.sh
 create mode 100644 tools/ctlv/ctlvgen/__init__.py
 create mode 100755 tools/ctlv/ctlvgen/cli.py
 create mode 100644 tools/ctlv/ctlvgen/lib/__init__.py
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

-- 
2.56.0

