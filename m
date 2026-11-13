Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794586159;
	b=ZOdiKJLi807ctXi+dZh6EjGoJxLGdIzaXM25IQJTo/EV/sIX+X8hFeHnDZR+Xi10ZxNB
	 UgNXJ21L0KfzQoQ6wyPdzDxtWcIutJUy6dnkQgE7QVI9KuiUEko5MjgxLcJZbI6j/T9dp
	 uVZSVvyJ1AbsxbK6HLZlohwYz+axZ5ZJD53BeOR7SUEzSaRsvOJ4mHnsIqmgivMhnWJDA
	 J5mrGbekRfIR8+IjVtV6oPllz2hyJ1aR+uwgH+4QutXDnYCaL1Ow4jNOcTfbU/Otr/A/p
	 a4jrD4fMq+PDgGN42WJhR3TY77SXMhLpKneQq0HWyQYSgCZg5tivKJ4fT4xyUBOeO6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586159;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fe4bgBaIiB/j0pKiN/Uekhorosg6jaRf4sL0ssWap9g=;
	b=ekAM+mre9IJ5ZxQhVpY/KKvNvGlEAvrMXKhFnNJ1Dh6hHSx0LYvrFq0ue1Ij9/S5M1za
	 mqtAkJAf52j7qIe4uKP9MAV9iY8UtfuOAs3opKXofe7fGgqtosWD3C0voSquezX85aH8J
	 AdlynZH3hAECS/+tdgqcc6PRBBRKm+YmJhe+g23jMU6ZACX64mdq30Gvrd0GlbNOnW2TY
	 fbCqwH+yYzdSOjfTODnR4wRyiKFyjDInrtQQGdXlpNF+hocEY52ZxCfm4o840qPXSscmG
	 qcPaJ7N7lO3uN+D65CSweamC0VoMYbfjcuLQBpRI+a98S/6Hn0Tfv1JQX8cHDP/u13Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=SIDcPU+u;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36496607A330
	for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 16:09:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36496607A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=SIDcPU+u
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so7418535e9.3
        for <linux-api@vger.kernel.org>; Fri, 13 Nov 2026 08:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1794586156; x=1795190956; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fe4bgBaIiB/j0pKiN/Uekhorosg6jaRf4sL0ssWap9g=;
        b=SIDcPU+uQqoAogegEVS7lN2CxfVxk7pkHC9tpj2/TdU/+gJ/EWpSrfRsv84JhesIp/
         r887uh8hOsR3lEKBj+cnnEhFbgHOr0wdSIPiKc7SGK/x+HmLvIx5Yra/oh3Y4037Ctnu
         apVg2qOEdT28tZu4DEl57JRyXPa5PRrnYUCGNE9DX+E2UZoFWGr2h9ioLz2excqc1YZa
         N5CUVXuLnINZGjzW/j+1is9WZIbbhMZdNA6yNdTgZw+ADHrzcCRuvdhNDDKuHllqDWk3
         sMFt6rv2pibUuT+uCOQX9pRxyKyBueLYc+v0TU5ZeKY5LfUK/8NmazTSlGbvco3Og1yA
         h7EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794586156; x=1795190956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fe4bgBaIiB/j0pKiN/Uekhorosg6jaRf4sL0ssWap9g=;
        b=sV1nCJH9Ulzmo0slEd9A5GhfZDlBBm+2MylON62KnXC1vo46JLIIAkVh+V5pA2zreM
         GuQ9TBJXTTA2nbe9PjRy209bNFWzvxLKEKmsAWNVLtuxvxBtHiEGhdTp/qSGgHSCO6oM
         oSHgODczsreR9gqJ0CH5bszxnKu4mKKT0xwypn0LoAI6OpZWPlHMd1nvTCt8p/A12rCM
         ifbv3RWHUnEeUkurI0n0slBKZspizm3jsqzH66XZtu2IQlnlEsj83/iMh2PW6d5/+7Eu
         gaJQJhzvGxiCNfgZUaAmklQEwqnxYNgYyIc9bZsPb/wznaq6Hs0fJTalr9jxrGAtejA7
         5j7w==
X-Forwarded-Encrypted: i=1; AL+hErGz2OAiSLuYbwyEKgHz5KWCyHcQGXvTR7J8pBxyNSfugHoblmWIRBEyZ1guLpmQvWguslY6g3AjBtc=@vger.kernel.org
X-Gm-Message-State: APuU4Z8G7gAEkTuf4zxu42NHYZpv4bZ6dxPtGOw69xWcznUphYEa9BWU
	tbdXOpyPNxZKIBpfpU5LpkM/uheB8HcQa7GjrEiGXz7U8dccvl0xUaRAor1YkoIqCrdr85SONDX
	VQmaF
X-Gm-Gg: AYBFou0M3NrI2W8FMRGAtiN25zr26+pGMBIzTn05BAubTqGsNDyRYldw7wAysrAMPDI
	MUUBR8KsMkv8pNf+ENVnG9vHpHkCaSMmRkpPLEzUDlDUVtZ/e4r1CYg7AqQ3x8Mi0w7oFao/MmR
	Q69EL9Ltfehhf7ssYKVnf/XuMcZLYwd/kppbkgLKREIt6ivTG6v9hCY3np/DBpCY/Pd91hCzoDH
	EyP+H3H4d0XbVq1WA5p2ifmUrv+EvRZGlxlPaa6dAWR6d77tGFW3nDUpfeB1iZaegX6syqVT7VK
	V7sArfCW1wgbneFbTCc0DR/AuxUakp0fhZlo9GFDYLO1tp6ZBR+pQzRTauhWICp4TFtefQ5h0CH
	FfRsmou6NOLeM+E9UOKRTDRlYJ48+js3irmZpiVKqqpoT30ZDA6zRpAhVrhzYGir8JLMd9iyVGA
	6fdPz5fTHUvBZFlfeyU3PvQCuYg1qmEBq5+aCdfqKcL2jGi0Lru6maQ+IVrdMyWjiRuAlEfLJoj
	yndBm9hmcWA52oz6+SUXVW1archwU63TjTsBVD6QdL8aVuGfV1Yj+lyOos3yk6nNBQPxNTigkAS
	A4sM4LxATsK78u1Meu1LsJ59plcjTUxCeWqP8D4=
X-Received: by 2002:a05:600c:4ecd:b0:4a1:e6a9:4086 with SMTP id 5b1f17b1804b1-4bb5599a73fmr72240055e9.0.1794586156386;
        Fri, 13 Nov 2026 08:09:16 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb566cec2esm49224095e9.1.2026.11.13.08.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 08:09:15 -0800 (PST)
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
Subject: [PATCH RFC v2 9/9] attestation: Add the TDX family implementation
Date: Fri, 13 Nov 2026 17:08:38 +0100
Message-ID: <20261113160838.2512652-10-jiri@resnulli.us>
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

Build the TDX attestation provider into tdx-guest when attestation is
enabled. Expose the Quote, MRTD and RTMR operations through the same
helpers as the native interfaces, which stay as they are, and label
each Quote as a legacy or a DICE one by its first bytes [1]. Where
ACPI describes a CCEL table, also return the firmware's event log as
evidence, for a verifier replaying the RTMRs.

[1] https://lore.kernel.org/all/avNfZ0lLl-OrkCHs@intel.com/

Assisted-by: Cursor: GPT-5.6 Sol
Assisted-by: Cursor: Claude Opus 5.5
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- built the provider into tdx-guest in place of the attestation-tdx
  module
- embedded struct attestation_dev in the provider's state
- accounted the evidence buffer to its caller's memcg
- dropped the MR-journal boundary claim from the TDX documentation
- returned the CCEL event log as an event-log evidence object
- dropped the total output length
- documented the provider as part of tdx-guest
- reported the 64-byte challenge length as a list entry
- used the helpers generated for the rewritten spec
- wrote the evidence objects with attestation_evidence_write()
- dropped the RTMR read caps, as every MR can be read
- said record instead of nest, the root being one
- took the UAPI headers from include/uapi/ctlv/
- dropped the TDREPORT evidence object, which /dev/tdx_guest keeps,
  and labelled each Quote as a legacy or a DICE one
- described the provider for userspace in a document of its own
---
 .../userspace-api/attestation-tdx.rst         |  59 ++++
 Documentation/userspace-api/attestation.rst   |  10 +
 Documentation/virt/coco/tdx-guest.rst         |   8 +
 drivers/attestation/Kconfig                   |   4 +
 drivers/virt/coco/tdx-guest/Kconfig           |   4 +-
 drivers/virt/coco/tdx-guest/Makefile          |   6 +
 drivers/virt/coco/tdx-guest/attestation.c     | 313 ++++++++++++++++++
 drivers/virt/coco/tdx-guest/internal.h        |  18 +
 .../coco/tdx-guest/{tdx-guest.c => main.c}    |   7 +
 9 files changed, 428 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/userspace-api/attestation-tdx.rst
 create mode 100644 drivers/virt/coco/tdx-guest/attestation.c
 rename drivers/virt/coco/tdx-guest/{tdx-guest.c => main.c} (98%)

diff --git a/Documentation/userspace-api/attestation-tdx.rst b/Documentation/userspace-api/attestation-tdx.rst
new file mode 100644
index 000000000000..ca0ed209143b
--- /dev/null
+++ b/Documentation/userspace-api/attestation-tdx.rst
@@ -0,0 +1,59 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===============
+TDX attestation
+===============
+
+With ``CONFIG_ATTESTATION``, the TDX guest driver registers an attestation
+device of the ``ctlv-attestation-tdx`` family, whose specification is
+``Documentation/ctlv/specs/ctlv-attestation-tdx.yaml``. Its ``device-info``,
+the ``info`` of ``device-get``, carries ``mrconfigid``, ``mrowner`` and
+``mrownerconfig``, 48 bytes each.
+
+Measurement registers
+=====================
+
+==  =====  ==============  =======  ======
+ID  Name   Register index  Bank     Extend
+==  =====  ==============  =======  ======
+0   mrtd   none            SHA-384  no
+1   rtmr0  0               SHA-384  yes
+2   rtmr1  1               SHA-384  yes
+3   rtmr2  2               SHA-384  yes
+4   rtmr3  3               SHA-384  yes
+==  =====  ==============  =======  ======
+
+Each ``mr-read`` takes a TDREPORT.
+
+The TSM-MR files,
+``/sys/devices/virtual/misc/tdx_guest/measurements/rtmr[0123]:sha384``, extend
+the same RTMRs as ``mr-extend``. Firmware and the boot loader usually extend
+RTMR0 to RTMR2 before the kernel starts, which leaves RTMR3 to the running
+system.
+
+Evidence
+========
+
+==  ========  =========  =================  =========  ========
+ID  Object    Class      Formats            Challenge  Binds
+==  ========  =========  =================  =========  ========
+0   Quote     signed     quote, quote-dice  64 bytes   every MR
+1   CCEL log  event-log  ccel               none       no MR
+==  ========  =========  =================  =========  ========
+
+The challenge goes into the REPORTDATA the Quote carries. The host's quoting
+service returns a DCAP Quote or a DICE-based one, and the device names it
+``quote`` by its header's version and TEE type, or ``quote-dice`` by the CBOR
+magic it starts with. Both are ``ctlv-attestation-tdx``'s vendor formats. A
+Quote of neither fails ``evidence-get`` with ``EPROTO``.
+
+The log is there where the firmware describes its CC event log with an ACPI
+CCEL table, and is the whole log area. It does not change after boot, and one
+call returns it with the Quote.
+
+The TDREPORT is MAC'd for the platform, not signed, so it is no object;
+``TDX_CMD_GET_REPORT0`` of ``/dev/tdx_guest`` returns it.
+
+A guest has one TDX device, which a udev rule can give a stable name::
+
+    ENV{CTLV_FAMILY}=="ctlv-attestation-tdx", SYMLINK+="attestation/tdx"
diff --git a/Documentation/userspace-api/attestation.rst b/Documentation/userspace-api/attestation.rst
index 16646d8b60d7..32ecaf5cba35 100644
--- a/Documentation/userspace-api/attestation.rst
+++ b/Documentation/userspace-api/attestation.rst
@@ -282,3 +282,13 @@ The reply carries ``mr-generation``, the MR generation after the extension.
     have or repeats one, or a digest has the wrong length.
 
 Access is read-write.
+
+Providers
+=========
+
+What each provider's family adds, and what its device produces:
+
+.. toctree::
+   :maxdepth: 1
+
+   attestation-tdx
diff --git a/Documentation/virt/coco/tdx-guest.rst b/Documentation/virt/coco/tdx-guest.rst
index 46e316db6bb4..16afc8e5a6ef 100644
--- a/Documentation/virt/coco/tdx-guest.rst
+++ b/Documentation/virt/coco/tdx-guest.rst
@@ -50,3 +50,11 @@ TDX reference material is collected here:
 https://www.intel.com/content/www/us/en/developer/articles/technical/intel-trust-domain-extensions.html
 
 The driver is based on TDX module specification v1.0 and TDX GHCI specification v1.0.
+
+Attestation device
+==================
+
+With ``CONFIG_ATTESTATION``, the driver also registers an attestation device,
+described in Documentation/userspace-api/attestation-tdx.rst. It shares the
+TDREPORT, Quote and RTMR paths, and their locks, with the misc ioctl, the
+TSM-report configfs interface and the TSM-MR sysfs attributes.
diff --git a/drivers/attestation/Kconfig b/drivers/attestation/Kconfig
index a6bfb17dd480..4307b28e679e 100644
--- a/drivers/attestation/Kconfig
+++ b/drivers/attestation/Kconfig
@@ -10,3 +10,7 @@ menuconfig ATTESTATION
 	  translate the common operations to their native service.
 
 	  If you are unsure, say N.
+
+if ATTESTATION
+
+endif # ATTESTATION
diff --git a/drivers/virt/coco/tdx-guest/Kconfig b/drivers/virt/coco/tdx-guest/Kconfig
index dbbdc14383b1..aa6687979a6f 100644
--- a/drivers/virt/coco/tdx-guest/Kconfig
+++ b/drivers/virt/coco/tdx-guest/Kconfig
@@ -1,12 +1,14 @@
 config TDX_GUEST_DRIVER
 	tristate "TDX Guest driver"
 	depends on INTEL_TDX_GUEST
+	depends on ATTESTATION || !ATTESTATION
 	select TSM_REPORTS
 	select TSM_MEASUREMENTS
 	help
 	  The driver provides userspace interface to communicate with
 	  the TDX module to request the TDX guest details like attestation
-	  report.
+	  report. With ATTESTATION, it also registers a TDX attestation
+	  device.
 
 	  To compile this driver as module, choose M here. The module will
 	  be called tdx-guest.
diff --git a/drivers/virt/coco/tdx-guest/Makefile b/drivers/virt/coco/tdx-guest/Makefile
index 775cb463f9c8..027cc16e1df3 100644
--- a/drivers/virt/coco/tdx-guest/Makefile
+++ b/drivers/virt/coco/tdx-guest/Makefile
@@ -1,2 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_TDX_GUEST_DRIVER) += tdx-guest.o
+
+tdx-guest-y := main.o
+tdx-guest-$(CONFIG_ATTESTATION) += attestation.o ctlv_attestation_tdx_gen.o
+
+# The generated family header includes its parent's.
+ccflags-y += -I $(srctree)/drivers/attestation/generated
diff --git a/drivers/virt/coco/tdx-guest/attestation.c b/drivers/virt/coco/tdx-guest/attestation.c
new file mode 100644
index 000000000000..1bb2e7b66928
--- /dev/null
+++ b/drivers/virt/coco/tdx-guest/attestation.c
@@ -0,0 +1,313 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <crypto/sha2.h>
+#include <linux/acpi.h>
+#include <linux/attestation.h>
+#include <linux/ctlv.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/unaligned.h>
+
+#include <uapi/linux/tdx-guest.h>
+
+#include "ctlv_attestation_tdx_gen.h"
+#include "internal.h"
+
+struct tdx_attestation {
+	struct attestation_dev att;
+	const struct tdx_guest_info *info;
+	void __iomem *log;
+	size_t log_length;
+};
+
+static struct tdx_attestation *tdx_att;
+
+static struct tdx_attestation *to_tdx_attestation(struct attestation_dev *att)
+{
+	return container_of(att, struct tdx_attestation, att);
+}
+
+static const enum hash_algo tdx_attestation_algorithms[] = {
+	HASH_ALGO_SHA384,
+};
+
+static const struct attestation_mr_props tdx_attestation_mrs[] = {
+	{
+		.id = 0,
+		.name = "mrtd",
+		.algorithms = tdx_attestation_algorithms,
+		.algorithms_count = ARRAY_SIZE(tdx_attestation_algorithms),
+	},
+	{
+		.id = 1,
+		.name = "rtmr0",
+		.algorithms = tdx_attestation_algorithms,
+		.algorithms_count = ARRAY_SIZE(tdx_attestation_algorithms),
+		.has_register_index = true,
+		.register_index = 0,
+		.extendable = true,
+	},
+	{
+		.id = 2,
+		.name = "rtmr1",
+		.algorithms = tdx_attestation_algorithms,
+		.algorithms_count = ARRAY_SIZE(tdx_attestation_algorithms),
+		.has_register_index = true,
+		.register_index = 1,
+		.extendable = true,
+	},
+	{
+		.id = 3,
+		.name = "rtmr2",
+		.algorithms = tdx_attestation_algorithms,
+		.algorithms_count = ARRAY_SIZE(tdx_attestation_algorithms),
+		.has_register_index = true,
+		.register_index = 2,
+		.extendable = true,
+	},
+	{
+		.id = 4,
+		.name = "rtmr3",
+		.algorithms = tdx_attestation_algorithms,
+		.algorithms_count = ARRAY_SIZE(tdx_attestation_algorithms),
+		.has_register_index = true,
+		.register_index = 3,
+		.extendable = true,
+	},
+};
+
+#define TDX_QUOTE_HEADER_LEN 48
+#define TDX_QUOTE_TEE_TYPE_TDX 0x81
+
+static const struct attestation_evidence_format tdx_attestation_quote_formats[] = {
+	{ .vendor = true, .value = CTLV_ATTESTATION_TDX_EVIDENCE_VENDOR_FORMAT_QUOTE },
+	{ .vendor = true, .value = CTLV_ATTESTATION_TDX_EVIDENCE_VENDOR_FORMAT_QUOTE_DICE },
+};
+
+static const struct attestation_evidence_format tdx_attestation_log_formats[] = {
+	{ .value = CTLV_ATTESTATION_EVIDENCE_FORMAT_CCEL },
+};
+
+static const struct attestation_evidence_challenge_length
+tdx_attestation_challenge_lengths[] = {
+	{ .min = TDX_REPORTDATA_LEN, .max = TDX_REPORTDATA_LEN },
+};
+
+/* The log comes last, so a guest without a CCEL table can leave it out. */
+static struct attestation_evidence_supported_object
+tdx_attestation_evidence_objects[] = {
+	{
+		.evidence_class = ATTESTATION_EVIDENCE_SIGNED,
+		.formats = tdx_attestation_quote_formats,
+		.formats_count = ARRAY_SIZE(tdx_attestation_quote_formats),
+		.challenge_lengths = tdx_attestation_challenge_lengths,
+		.challenge_lengths_count =
+			ARRAY_SIZE(tdx_attestation_challenge_lengths),
+		.max_length = TDX_GUEST_QUOTE_MAX_LEN,
+		.binds_mrs = true,
+	},
+	{
+		.evidence_class = ATTESTATION_EVIDENCE_EVENT_LOG,
+		.formats = tdx_attestation_log_formats,
+		.formats_count = ARRAY_SIZE(tdx_attestation_log_formats),
+	},
+};
+
+/* The object count and the total length are set at init. */
+static struct attestation_evidence_caps tdx_attestation_evidence_caps = {
+	.objects = tdx_attestation_evidence_objects,
+};
+
+/*
+ * A DCAP Quote's header starts with its version, 4 or 5, and TEE type. A
+ * DICE-based Quote, a CBOR Web Token, starts with the CBOR magic, d9 d9 f7.
+ */
+static int tdx_attestation_quote_label(const u8 *quote, size_t length,
+				       struct attestation_evidence_format *format)
+{
+	format->vendor = true;
+	if (length >= TDX_QUOTE_HEADER_LEN &&
+	    (get_unaligned_le16(quote) == 4 || get_unaligned_le16(quote) == 5) &&
+	    get_unaligned_le32(quote + 4) == TDX_QUOTE_TEE_TYPE_TDX) {
+		format->value = CTLV_ATTESTATION_TDX_EVIDENCE_VENDOR_FORMAT_QUOTE;
+		return 0;
+	}
+	if (length >= 3 && !memcmp(quote, "\xd9\xd9\xf7", 3)) {
+		format->value = CTLV_ATTESTATION_TDX_EVIDENCE_VENDOR_FORMAT_QUOTE_DICE;
+		return 0;
+	}
+	return -EPROTO;
+}
+
+static void __iomem *tdx_attestation_log_map(size_t *length)
+{
+	struct acpi_table_header *header;
+	struct acpi_table_ccel *ccel;
+	void __iomem *log = NULL;
+
+	if (ACPI_FAILURE(acpi_get_table(ACPI_SIG_CCEL, 0, &header)))
+		return NULL;
+	ccel = container_of(header, struct acpi_table_ccel, header);
+	if (header->length >= sizeof(*ccel) && ccel->log_area_start_address &&
+	    ccel->log_area_minimum_length &&
+	    ccel->log_area_minimum_length <= UINT_MAX)
+		log = acpi_os_map_iomem(ccel->log_area_start_address,
+					ccel->log_area_minimum_length);
+	if (log)
+		*length = ccel->log_area_minimum_length;
+	acpi_put_table(header);
+	return log;
+}
+
+static int
+tdx_attestation_evidence_get(struct attestation_dev *att,
+			     const struct attestation_evidence_request *request,
+			     struct attestation_evidence_result *result)
+{
+	struct tdx_attestation *tdx = to_tdx_attestation(att);
+	size_t index, length;
+	void *buffer;
+	int ret = 0;
+
+	for (index = 0; !ret && index < request->objects_count; index++) {
+		const struct attestation_evidence_object_request *object =
+			&request->objects[index];
+		struct attestation_evidence_object_result *produced =
+			&result->objects[index];
+
+		buffer = kvmalloc(object->supported_object->max_length,
+				  GFP_KERNEL_ACCOUNT);
+		if (!buffer)
+			return -ENOMEM;
+
+		if (object->supported_object == &tdx_attestation_evidence_objects[0]) {
+			ret = tdx_guest_quote_get(request->challenge, buffer,
+						  &length);
+			if (!ret)
+				ret = tdx_attestation_quote_label(buffer, length,
+								  &produced->format);
+		} else {
+			memcpy_fromio(buffer, tdx->log, tdx->log_length);
+			length = tdx->log_length;
+			produced->format = tdx_attestation_log_formats[0];
+		}
+
+		if (!ret)
+			ret = attestation_evidence_write(object, buffer, length);
+		if (!ret)
+			produced->length = length;
+		kvfree(buffer);
+	}
+	return ret;
+}
+
+static int tdx_attestation_mr_read(struct attestation_dev *att, unsigned int mr_id,
+				   struct attestation_digest_set *values)
+{
+	static const enum tdx_guest_mr native_mrs[] = {
+		TDX_GUEST_MR_MRTD,
+		TDX_GUEST_MR_RTMR0,
+		TDX_GUEST_MR_RTMR1,
+		TDX_GUEST_MR_RTMR2,
+		TDX_GUEST_MR_RTMR3,
+	};
+
+	if (mr_id >= ARRAY_SIZE(native_mrs) ||
+	    values->values_count != 1 ||
+	    values->values[0].algorithm != HASH_ALGO_SHA384)
+		return -EINVAL;
+	return tdx_guest_mr_read(native_mrs[mr_id], values->values[0].data);
+}
+
+static int
+tdx_attestation_mr_extend(struct attestation_dev *att, unsigned int mr_id,
+			  const struct attestation_digest_set *values)
+{
+	if (mr_id < 1 || mr_id > 4)
+		return -EOPNOTSUPP;
+	if (values->values_count != 1 ||
+	    values->values[0].algorithm != HASH_ALGO_SHA384)
+		return -EINVAL;
+	return tdx_guest_rtmr_extend(mr_id - 1, values->values[0].data);
+}
+
+static const struct attestation_provider tdx_attestation_provider = {
+	.evidence_get = tdx_attestation_evidence_get,
+	.mr_read = tdx_attestation_mr_read,
+	.mr_extend = tdx_attestation_mr_extend,
+	.evidence_caps = &tdx_attestation_evidence_caps,
+	.mrs = tdx_attestation_mrs,
+	.mrs_count = ARRAY_SIZE(tdx_attestation_mrs),
+};
+
+int ctlv_attestation_tdx_device_info_fill(struct ctlv *ctlv,
+					  struct ctlv_op_ctx *ctx,
+					  const struct ctlv_cursor *request,
+					  struct ctlv_cursor *record)
+{
+	const struct tdx_guest_info *info =
+		to_tdx_attestation(attestation_from_ctlv(ctlv))->info;
+	bool ok;
+
+	ok = ctlv_attestation_tdx_device_info_mrconfigid_put(record, info->mrconfigid,
+							     sizeof(info->mrconfigid));
+	ok &= ctlv_attestation_tdx_device_info_mrowner_put(record, info->mrowner,
+							   sizeof(info->mrowner));
+	ok &= ctlv_attestation_tdx_device_info_mrownerconfig_put(record,
+								 info->mrownerconfig,
+								 sizeof(info->mrownerconfig));
+	return ok ? 0 : -EMSGSIZE;
+}
+
+int tdx_attestation_register(struct device *parent,
+			     const struct tdx_guest_info *info)
+{
+	struct attestation_evidence_caps *caps = &tdx_attestation_evidence_caps;
+	struct tdx_attestation *tdx;
+	size_t log_length = 0;
+	void __iomem *log;
+	int ret;
+
+	log = tdx_attestation_log_map(&log_length);
+	tdx_attestation_evidence_objects[1].max_length = log_length;
+	caps->objects_count = ARRAY_SIZE(tdx_attestation_evidence_objects);
+	if (!log)
+		caps->objects_count--;
+
+	tdx = attestation_alloc(parent, &tdx_attestation_provider,
+				&ctlv_attestation_tdx_family, struct tdx_attestation, att);
+	if (IS_ERR(tdx)) {
+		ret = PTR_ERR(tdx);
+		goto err_unmap;
+	}
+	tdx->info = info;
+	tdx->log = log;
+	tdx->log_length = log_length;
+	ret = attestation_register(&tdx->att);
+	if (ret) {
+		attestation_put(&tdx->att);
+		goto err_unmap;
+	}
+	tdx_att = tdx;
+	return 0;
+
+err_unmap:
+	if (log)
+		acpi_os_unmap_iomem(log, log_length);
+	return ret;
+}
+
+void tdx_attestation_unregister(void)
+{
+	if (!tdx_att)
+		return;
+	attestation_unregister(&tdx_att->att);
+	if (tdx_att->log)
+		acpi_os_unmap_iomem(tdx_att->log, tdx_att->log_length);
+	attestation_put(&tdx_att->att);
+	tdx_att = NULL;
+}
+
+MODULE_IMPORT_NS("ATTESTATION");
+MODULE_IMPORT_NS("CTLV");
diff --git a/drivers/virt/coco/tdx-guest/internal.h b/drivers/virt/coco/tdx-guest/internal.h
index d57a8c385aff..fc10e68d231a 100644
--- a/drivers/virt/coco/tdx-guest/internal.h
+++ b/drivers/virt/coco/tdx-guest/internal.h
@@ -5,6 +5,8 @@
 #include <crypto/sha2.h>
 #include <linux/types.h>
 
+struct device;
+
 #define TDX_GUEST_QUOTE_MAX_LEN ((128 * 1024) - 24)
 
 struct tdx_guest_info {
@@ -27,4 +29,20 @@ int tdx_guest_mr_read(enum tdx_guest_mr mr, u8 value[SHA384_DIGEST_SIZE]);
 int tdx_guest_rtmr_extend(unsigned int rtmr,
 			  const u8 value[SHA384_DIGEST_SIZE]);
 
+#if IS_ENABLED(CONFIG_ATTESTATION)
+int tdx_attestation_register(struct device *parent,
+			     const struct tdx_guest_info *info);
+void tdx_attestation_unregister(void);
+#else
+static inline int tdx_attestation_register(struct device *parent,
+					   const struct tdx_guest_info *info)
+{
+	return 0;
+}
+
+static inline void tdx_attestation_unregister(void)
+{
+}
+#endif
+
 #endif /* _TDX_GUEST_INTERNAL_H */
diff --git a/drivers/virt/coco/tdx-guest/tdx-guest.c b/drivers/virt/coco/tdx-guest/main.c
similarity index 98%
rename from drivers/virt/coco/tdx-guest/tdx-guest.c
rename to drivers/virt/coco/tdx-guest/main.c
index c49454ec0b18..bcda631a0232 100644
--- a/drivers/virt/coco/tdx-guest/tdx-guest.c
+++ b/drivers/virt/coco/tdx-guest/main.c
@@ -522,6 +522,12 @@ static int __init tdx_guest_init(void)
 	if (ret)
 		goto free_quote;
 
+	/* The other interfaces stay up without the attestation device. */
+	ret = tdx_attestation_register(tdx_misc_dev.this_device,
+				       &tdx_guest_info);
+	if (ret)
+		pr_warn("attestation device registration failed: %d\n", ret);
+
 	return 0;
 
 free_quote:
@@ -537,6 +543,7 @@ module_init(tdx_guest_init);
 
 static void __exit tdx_guest_exit(void)
 {
+	tdx_attestation_unregister();
 	tsm_report_unregister(&tdx_tsm_ops);
 	free_quote_buf(quote_buf);
 	misc_deregister(&tdx_misc_dev);
-- 
2.56.0

