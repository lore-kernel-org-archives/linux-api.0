Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11023097.outbound.protection.outlook.com [40.107.201.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CF148CD4A;
	Tue, 25 Aug 2026 22:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.97
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787696163; cv=fail; b=SUCKU0+0t66a+Y5B7OwF3m42w6izmxQJGQTBEwQS/9AOWIV7KY7sfWmjLVuQYooxMfxmbWWK0Y8oMkKMb7sTSVeRcQYOQ5HQBNNvpvLX3lVzrhO/hwfPMkCq3ITNyg8+xgD1NDCapps1S1NAU+k8BQmScVZg/4h9ahApfcMgz2s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787696163; c=relaxed/simple;
	bh=pvY9D68kzhFHUDCPtMw5EO3/eo3e2l2ofmL/k0+FTE4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YQ9Em5P2M4Y1CQnM25KXGqlRUH9PbfV173lG5GUfayrSEiq5TSY6s+i5mkoZcOIaxv15HTbdRlKllKFU6cOuWL6aTbYI2IJgu+7Acru51TgH4P57KTFTXFPbLgXZOtTBGhpuKgxczJgT8RbYNkzX20SF1W3h9LU7PGqN4p9AUWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=qICSUDiy; arc=fail smtp.client-ip=40.107.201.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="qICSUDiy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hOzg02gxdh+v5Wl+xHmuGA2Trlm4QlMInKPjvxn0eF+xKbKI91YMb0iF/gkcS2+2n0ryNYEg7Q4v+keWfC471Z2V6Mi31L23q8Bij778Yi2XHqaw695bFCalFcijkqlxMYzTKnOv5810gYMzV0qJ8h5bLarbtrWcg/lYsM+lGbdxmnPC5FLPeZ1UjYnmKXP7cruHXrQaACuKIJadtn4lVTCRXuJ+C8tXSs12fRO234qMFlVHDBCRgUbeaTA9Y7P8d3Ed4Xpi1UoYBiUwd+8mybTOuosJ+SavF0u6J/GYvQ0+CwimMycUM5W0rtZXWnyGN8tO63Sp0lEMY+oUZNlw9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cwWpt0J21iJX6mIp3D3jnqCIZBQZhXTu9cS8jnwwkW4=;
 b=bpKsjK87KkfayTFa54PcUfCCLVb/Bixg4D6mdv73AN7lh3ZXqJI2yJkEicL/kiarb/hAczAZWSSvN9TvZ+cD2Z85GQXWIPsXHVH6FcEqQPNuasIZPsUk5vs1g9JHXlv5mL7BzgsvlSzdvbYgfO/EfMifcq4zzrbpWQAUvZMgGyMSuOQPmnybBbtZ9mA7oG/JW0yBpv8X6Ln1j27xKfHXuS/J5vaZf5D7vGW8YkhXwYcW+P7VgFity+QmHZCP6mfhvXgW3580pA1dBDMa20hrkU4wOMn8+QmCOX9WZaQYG5F9uMC23XxV7RCcsXvkg3jy9clNIt59N+H2MNMld4IiMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cwWpt0J21iJX6mIp3D3jnqCIZBQZhXTu9cS8jnwwkW4=;
 b=qICSUDiyPBejuoUf/lpSN2LHaeKs+RBCTEfk5a4eZc3YVTmjX5y1zp5WLiMHOp2v4svoLMbuRNcqtgYPt1LuICLLNVO3lM6IzqR6YPdEGnfwQ5pqECAwV7YH89gPOol8OdyLJF7FTgIq/1qJGYxh+dtckOFdoKs66kcwcQezz1WufOnjKxq4TqBLtCETEHIFp7ngvQleJU64fKU9b+idY0YwLr93DaOG5GOjzHIi9SrLnY8a+yczqvwuw7TQuK6PmmzepAxcE7z2FqTR44SSbissuIV537OTjcpBdRks/nWSJKBqcsfl5hA8f1H/OpC1OitvEXPRYu2qrjJlOPlJBw==
Received: from SJ0PR03CA0361.namprd03.prod.outlook.com (2603:10b6:a03:3a1::6)
 by MN2PR04MB6416.namprd04.prod.outlook.com (2603:10b6:208:1a3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Tue, 25 Aug
 2026 22:15:52 +0000
Received: from BY1PEPF0001AE1D.namprd04.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::72) by SJ0PR03CA0361.outlook.office365.com
 (2603:10b6:a03:3a1::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.6 via Frontend Transport; Tue, 25
 Aug 2026 22:15:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy01.rambus.com; pr=C
Received: from hqxsv-psmtppxy01.rambus.com (192.86.86.210) by
 BY1PEPF0001AE1D.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Tue, 25 Aug 2026 22:15:51 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy01.rambus.com (Postfix) with ESMTP id CDAC1180174C;
	Tue, 25 Aug 2026 18:15:50 -0400 (EDT)
From: Alex Ousherovitch <aousherovitch@rambus.com>
To: Albert Ou <aou@eecs.berkeley.edu>,
	Alex Ousherovitch <aousherovitch@rambus.com>,
	Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jonathan Corbet <corbet@lwn.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	devicetree@vger.kernel.org,
	Joel Wittenauer <Joel.Wittenauer@cryptography.com>,
	linux-api@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thi Nguyen <thin@rambus.com>
Subject: [PATCH v4 00/19] crypto: cmh - add Rambus CryptoManager Hub driver
Date: Tue, 25 Aug 2026 15:15:19 -0700
Message-ID: <20260825221539.255951-1-aousherovitch@rambus.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE1D:EE_|MN2PR04MB6416:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: d6d29307-2759-4df4-6ac6-08df02f66c39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|1800799024|23010399003|82310400026|13003099007|921020|7136999003|6133799003|3023799007|10067099003|56012099006|11063799006|5023799004|18002099003;
X-Microsoft-Antispam-Message-Info:
	Gn8nQzGDbf2+zEwAohSBwSJZ1AJOOAfBnSOrsto9JNk5n4C5UQScVPLpzQXBIBotZ7oMO2wyXUC9V/V/D0xWmFS6+JpJGt6wHyVcLPKe0DuUuYaPE53WoWM2rK1Y2cGfxvoTs4dRTrc95K+OE7CbmQ5z72XRosOA/LU5wWbmljZj0skgFjhQjCIYz/Bs/CwtG4tq2O7CetwwwvdhKwrwfVlYOX/74dViuydOPtsCnH3HbqV6waQJblfvfbiGE1doT+3ObMml4mxLS9BWK1kd/OOplU9XNUhmE2J7ZtuCEDeR5gEsmLdlUxMhpan2wnqoqV8Q3hZCYBqBC2KfGif5D0jC1pECfph/9k35M2aSlVYf89WNyl/UH/AfUXU5ExTXFvEJROfXCVZic3S4SZfrqKqiFIAv9ujHOv/xtIuZOziDMJz+bPHhEF6DIkWLveLnSumk47LUrZjzFpAlmXlRb0yhFMXAazsrODhUHPJKGk6ilaza4roPVWBD4OIyxSaBnk77cPW7u5OCOhtvRUiQqPky8JEAe3lNtzeDdH6FTDOwNKUiLmRO2bDUpiImyC3id0flLSjIUGw/lfh1BRbSg0QDCpol3cJ3QT/n2yc82LF4j+pUpptCtNrCkuxHA29gzjGnQMCoaRF3+u1sI8ek3cG74VGte4SFDhYBCRzDyAb/QYYt90YeBdv3WfgM+N8gVfJrrF7HKyXAsJfhrEKgoL37vE6GzG6hmnbKSezYSb+0SwWw8ahbjjZpZvLW/+hM
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy01.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(1800799024)(23010399003)(82310400026)(13003099007)(921020)(7136999003)(6133799003)(3023799007)(10067099003)(56012099006)(11063799006)(5023799004)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EXsOWmL6CwiMKTYDfpznUVtFN91zXT2eEeeGZS5zwvwo5jOukbXHvMkUseU5pBVTACruHEO2lBF57a9BY42aEoDQRMOmmLjYSzM23ksgVQOZKnHPt6T4QHWV16VbbY4WjXTDXlk+aCtvCwxNZYD6vW3FevoiR6TdWmvY304yhq86fHsR5C2bwjAcDShQQLcjagdjXmZn4Cd1jqXJ42rP7U7Mv5hwJadfKKtmQjDF5g3Z/MyVIPYGJv8fuPVRprwCSlhOBx6ZtjmOUGxOjGp24oc7ifMkHZeByTSXp3NFh2bghWr2moyFycSyK1CBv+iJlYxRDvLB+SV1Sh9cs+BRYz+2id6TSruUEWQgMD3J58BkGacZqc3Ml5v9vtMVwFgNH8TJ7D2dGmI3lV/uyN6OSjwb6QHNTeWhg2BRT0o4JXf4gVwLWyUTxBrUesAasDAO
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 22:15:51.0332
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6d29307-2759-4df4-6ac6-08df02f66c39
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy01.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE1D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6416

crypto: cmh - add Rambus CryptoManager Hub hardware crypto accelerator

This series adds a driver for the Rambus CryptoManager Hub (CMH), a
hardware cryptographic accelerator IP from Cryptography Research at
Rambus Inc. (https://www.rambus.com/cryptographyresearch/).
CMH provides a broad set of symmetric, asymmetric, and post-quantum
cryptographic algorithms accelerated in hardware, accessed via a
mailbox-based Virtual Command Queue (VCQ) interface.

The hardware is a platform device matched via device tree
(compatible = "rambus,cmh-v1030").  It exposes a single MMIO register region
(SIC) with per-mailbox doorbell, status, and command registers.
Each mailbox has DMA-coherent queue memory for VCQ command
submission and completion.

Driver architecture:

  In-kernel users                       /dev/cmh_mgmt (ioctl)
  (dm-crypt, IPsec, kTLS, fscrypt)      (key management)
       |                                        |
       v                                        v
  +----------------------------------------------------+
  |        Kernel Crypto API + hwrng (72 total)        |
  |   ahash | skcipher | aead | akcipher | sig | kpp   |
  +----------------------------------------------------+
       |                                           |
       v                                           v
  +------------------+    +------------------------+
  | Transaction Mgr  |--->| Key / Mgmt subsystem   |
  | (kthread, CMQ)   |    | (datastore, ioctl ops) |
  +------------------+    +------------------------+
       |
       v
  +------------------+     +-------------------+
  | MQI (VCQ pack,   |---->| Response Handler  |
  |  DMA map, submit)|     | (threaded IRQ,    |
  +------------------+     |  watchdog, unmap) |
       |                   +-------------------+
       v                          ^
  +-----------+              +-----------+
  | Hardware  |--- IRQ ----->| Hardware  |
  | (mailbox) |              | (mailbox) |
  +-----------+              +-----------+

The transaction manager runs as a dedicated kthread that pulls
requests from a central command queue, packs VCQ entries, maps DMA
buffers, and submits to the least-loaded mailbox.  Completion is
handled by per-mailbox threaded IRQs.  The driver returns
-EINPROGRESS for async crypto requests and supports the
CRYPTO_TFM_REQ_MAY_BACKLOG flag for queue-full backpressure.

Registered algorithms (72 total):

  Type       Count  Algorithms
  ---------  -----  --------------------------------------------------
  ahash         15  SHA-{224,256,384,512}, SHA3-{224,256,384,512},
                     SHAKE-{128,256}, cSHAKE-{128,256},
                     KMAC-{128,256}, SM3
  ahash(HMAC)    8  HMAC-SHA-{224,256,384,512},
                     HMAC-SHA3-{224,256,384,512}
  ahash(MAC)     4  CMAC(AES), CMAC(SM4), XCBC(SM4), Poly1305
  skcipher      11  AES-{ECB,CBC,CTR,CFB,XTS},
                     SM4-{ECB,CBC,CTR,CFB,XTS}, ChaCha20
  aead           6  AES-{GCM,CCM}, SM4-{GCM,CCM},
                     rfc7539(chacha20,poly1305),
                     rfc7539esp(chacha20,poly1305)
  akcipher       1  RSA (2048--4096 bit; 512/1024 legacy/test)
  sig           23  ECDSA P-{256,384,521}, SM2 (verify-only),
                     ML-DSA-{44,65,87},
                     SLH-DSA (12 parameter sets),
                     LMS, LMS-HSS, XMSS, XMSS-MT
  kpp            3  ECDH P-{256,384}, X25519
  hwrng          1  DRBG-backed /dev/hwrng

The keyed MACs (HMAC, CMAC, XCBC, Poly1305) accumulate input for a
single finalize-time submission -- the hardware has no keyed-MAC
save/restore -- and fall back to a generic software MAC (Poly1305 uses
the in-kernel library) once the input or a clone exceeds a 64 KB window,
so they are not input-capped.  KMAC has no software equivalent and keeps
the cap; the driver selects the generic MAC/hash and Poly1305-library
configs for the fallbacks.

Ioctl-only algorithms (not registered with the crypto API at all):
  - EdDSA (Ed25519, Ed448): sign and verify
  - ML-KEM (ML-KEM-512/768/1024): no standard kernel KEM API exists

The driver also exposes /dev/cmh_mgmt, a misc device for the hardware
key-management plane: key provisioning and hardware-held-key operations
that the in-kernel crypto API cannot express.  Some of its ioctls name
primitives the driver also registers; that overlap is deliberate and
bounded (the ioctl path keeps private keys hardware-resident).  The
"crypto: cmh - add key provisioning and management" patch explains the
split in full.  The device requires CAP_SYS_ADMIN and is built
conditionally on CONFIG_CRYPTO_DEV_CMH_MGMT (default n); when disabled
the ioctl interface is absent while all kernel crypto API algorithms
remain registered.

The ML-DSA sig algorithms are registered at priority 5001.  The
kernel's crypto/mldsa.c registers at priority 5000 with verify-only
(sign returns -EOPNOTSUPP).  Our driver provides full HW-accelerated
sign + verify, so the higher priority ensures the hardware
implementation is preferred when the driver is loaded.

Power management uses DEFINE_SIMPLE_DEV_PM_OPS.  On suspend the
transaction manager drains in-flight requests (configurable 10s
timeout, returns -ECANCELED on timeout), stops the kthread, and
masks IRQs.  On resume it re-verifies SIC/boot status and restarts
the kthread.

Dependencies:
  - Kernel 7.1+ (based on Herbert Xu's cryptodev-2.6 tree, 7.2.0-rc1)
  - sig_alg backend (upstream since 6.13)
  - CRYPTO_AHASH_REQ_VIRT (native support, no REQ_VIRT interop fallback needed)
  - CMH eSW loaded independently by hardware before driver probe

The driver registers all algorithms through the standard in-kernel
crypto API; in-kernel users (dm-crypt, fscrypt, IPsec, etc.) consume
them directly.  Key provisioning and hardware-held-key operations are
exposed to user space via /dev/cmh_mgmt ioctls.

Public hardware documentation:
  Product brief: https://go.rambus.com/ch-7xx-and-cc-7xx-product-brief
  No public datasheets are currently available.  The driver was
  developed against the Rambus CryptoManager Hub Hardware Reference
  Manual (Rambus Inc. confidential).  Detailed hardware reference is
  available under NDA from Rambus Inc.; contact the maintainers listed
  in MAINTAINERS for access during review.

Tested on RISC-V and ARM64 QEMU emulation with the CMH hardware
model (QEMU TCG, 512 MiB RAM).  Also exercised on Xilinx VMK180
FPGA board with real CMH IP.

  - testmgr: 41 CMH algorithm registrations matched by upstream
    test vectors, all pass; 30 names report "No test for" (PQC
    families, KMAC, cSHAKE - no upstream vectors yet).
  - kselftest tools/testing/selftests/drivers/crypto/cmh:
    6 pass, 0 fail.

checkpatch.pl --strict: 0 errors, 0 warnings, 0 checks on all
files (the only output is the expected per-file "does MAINTAINERS
need updating?" reminder, satisfied by the MAINTAINERS patch).
sparse (C=2): 0 warnings.
W=1 -Werror: clean.
make dt_binding_check: clean (dtschema validates the
rambus,cmh-v1030.yaml binding).

Tested with the following debug options enabled simultaneously
(submit-checklist "Test your code" item 1):
  CONFIG_PROVE_LOCKING, CONFIG_PROVE_RCU, CONFIG_DEBUG_LOCK_ALLOC,
  CONFIG_DEBUG_OBJECTS_RCU_HEAD, CONFIG_SLUB_DEBUG,
  CONFIG_DEBUG_PAGEALLOC, CONFIG_DEBUG_MUTEXES, CONFIG_DEBUG_SPINLOCK,
  CONFIG_DEBUG_PREEMPT, CONFIG_DEBUG_ATOMIC_SLEEP.
  Result: no lockdep warnings, no ODEBUG splats, no slab corruption.

Additionally tested (separate passes - mutually exclusive configs):
  - CONFIG_KASAN + CONFIG_UBSAN + CONFIG_DEBUG_KMEMLEAK + CONFIG_KFENCE:
    no sanitizer findings; KMEMLEAK scan reports 0 unreferenced objects.
  - CONFIG_KCSAN (arm64; riscv64 lacks HAVE_ARCH_KCSAN):
    0 data-race reports attributed to the driver.

Stack usage: worst-case under 1 KB on both riscv64 and arm64
(scripts/checkstack.pl).  Hardware command buffers live in
per-request context (heap-allocated by the crypto framework).

Alex Ousherovitch (19):
  dt-bindings: crypto: add Rambus CryptoManager Hub
  crypto: cmh - add core platform driver
  crypto: cmh - add key provisioning and management
  crypto: cmh - add SHA-2/SHA-3/SHAKE ahash
  crypto: cmh - add HMAC ahash
  crypto: cmh - add CSHAKE/KMAC ahash
  crypto: cmh - add SM3 ahash
  crypto: cmh - add AES skcipher/aead/cmac
  crypto: cmh - add SM4 skcipher/aead/cmac/xcbc
  crypto: cmh - add ChaCha20-Poly1305
  crypto: cmh - add DRBG hwrng
  crypto: cmh - add RSA akcipher
  crypto: cmh - add ECDSA/SM2 sig
  crypto: cmh - add ECDH/X25519 kpp
  crypto: cmh - add ML-KEM/ML-DSA (QSE)
  crypto: cmh - add SLH-DSA/LMS/XMSS (HCQ)
  Documentation: ioctl: add CMH ioctl documentation and register 'J'
  selftests: crypto: cmh - add kselftest for management ioctl
  MAINTAINERS: add Rambus CryptoManager Hub (CMH)

---

Changes in v4:
 - dt-bindings: crypto: cmh: rename the per-mailbox child node to
   queue@N and describe its ring geometry as plain counts rather than
   log2 -- replace rambus,slots-log2 with rambus,num-slots (a
   power-of-two slot count) and rambus,strides-log2 with
   rambus,slot-stride-bytes (a power-of-two byte stride); the driver
   converts each to the register log2 encoding.
 - crypto: cmh: convert the platform driver to module_platform_driver()
   and dev_err_probe(), and drop the single-instance guard.
 - crypto: cmh: remove the informational dev_info() logging from the
   probe, register, remove, suspend and resume paths.
 - crypto: cmh: drop every production module parameter -- the eSW boot
   timeout, hwrng quality and DRBG config become built-in constants and
   the command-queue/backlog depths move to debugfs (debug builds only);
   only debug-gated test knobs remain under CONFIG_CRYPTO_DEV_CMH_DEBUG.
 - dt-bindings: crypto: cmh: rename the binding file to
   rambus,cmh-v1030.yaml to match the compatible string, and trim the
   clocks and interrupts property descriptions.
 - crypto: cmh: move the /dev/cmh_mgmt rationale (why its ioctl surface
   does not duplicate the registered crypto-API transforms) from the
   cover letter into the key-management patch commit message.
 - crypto: cmh: bound the KEY_NEW/KEY_NEW_RANDOM datastore object length
   and scrub orphaned datastore objects on the management key-generation
   error paths
 - crypto: cmh: further static-analysis error-path and input-validation
   fixes (management DMA-unmap sentinels; reject absent randomness/context
   pointers in the ML-KEM/ML-DSA/SLH-DSA ioctls; guard hash/sm3 finup
   length against u32 overflow; commit RSA key state only after full
   validation; clamp the ecdsa digit count before sizing).
 - crypto: cmh: fix transaction-manager submit races and shared-IRQ
   setup (bound the multi-VCQ walk within vcq_data; arm the async
   per-request timer before the doorbell to avoid a completion race;
   de-duplicate shared mailbox virqs so probe does not fail with
   -EBUSY on platforms that share an interrupt line).
 - crypto: cmh: fix symmetric stream and out-of-place AEAD output
   (declare chunksize for the CTR/CFB stream modes so the crypto layer
   buffers sub-block data instead of splitting the keystream; copy the
   AAD verbatim into the destination for out-of-place AES/SM4 AEAD).
 - crypto: cmh: further keyed-hash and PKE hardening (validate raw NIST
   ECDH scalars with ecc_is_key_valid; reject the unimplemented PKE_ECDH
   DS-result mode instead of overrunning the output; defer the hash
   holdback update until after its allocations; bound the hmac fallback
   state to the export window; restore the management temp-dirty flag on
   flush failure; back off the hwrng blocking read on a transient DRBG
   error).
 - crypto: cmh: stream cSHAKE incrementally in hardware (absorb full
   sponge rate-blocks per update via SAVE/RESTORE and hold back only the
   sub-rate tail) instead of buffering all input in kernel memory;
   any length, matching the plain hashes.
 - crypto: cmh: make the streaming hash/sm3/cSHAKE .update() retry-safe --
   defer moving the sub-rate tail into the holdback until after an
   accepted submit, so a queue-full -EAGAIN (no MAY_BACKLOG) leaves the
   request state pristine for the caller to retry.
 - crypto: cmh: ECDH mgmt ioctl returns only the raw shared secret to
   host; drop the unimplemented DS-result flag and result_cid from the
   UAPI, with flags and the reserved fields rejected unless zero.
 - dt-bindings: crypto: cmh: allow clock-names subsets -- core with an
   optionally-independent core-div2 and/or rt (oneOf) instead of a
   positional list that could not express [core, rt].
 - crypto: cmh: register an algorithm family only when its hardware core
   is present in CORE_ENABLE, so an absent core advertises no crypto-API
   algorithms; the core-dispatch path also WARNs and bails on an absent
   core type as a backstop for the /dev/cmh_mgmt ioctl path.

Changes in v3:
 - dt-bindings: crypto: cmh: rework the mailbox topology per DT review --
   mailbox@N child nodes; cores discovered from CORE_ENABLE, not the DT.
 - dt-bindings: crypto: cmh: adopt the "rambus" vendor prefix and a
   device-specific "rambus,cmh-v1030" compatible (the IP revision) per
   DT review; rename the per-mailbox properties to rambus,slots-log2 /
   rambus,strides-log2 / rambus,cores and the crypto driver-name prefix
   to rambus-cmh-*.
 - dt-bindings: crypto: cmh: describe the optional functional clocks
   (core, core-div2, rt) and an optional host-driven reset-gpios; the
   driver enables all supplied clocks and acquires the optional reset
   line deasserted.
 - crypto: cmh: register the platform driver from module_init() without
   unregistering on probe failure; propagate -EPROBE_DEFER from
   of_irq_get().
 - crypto: cmh: harden the key-management and crypto error paths; fix
   three transaction-manager concurrency issues found by an automated
   kernel-style review of v2.
 - crypto: cmh: further automated kernel-style review fixes (hwrng bounce
   buffer and short-read, truncated export state, RSA re-key unmap, MAC
   setkey ordering, CCM fallback alignment, persistent PKE/PQC key buffer).
 - crypto: cmh: give the buffered keyed MACs (hmac, cmac, xcbc, poly1305)
   a software fallback past the 64 KB window instead of a hard input cap;
   KMAC keeps its hard cap and rejects export/import.
 - crypto: cmh: rfc7539(chacha20,poly1305): always issue the AAD-final
   command, fixing -EIO on empty-AAD requests.
 - crypto: cmh: chacha20 skcipher: leave req->iv unchanged on completion,
   matching the generic chacha20 skcipher.
 - Documentation: cmh: describe the management ioctls as a permanent
   interface and add ioctl struct layouts; document the keyed-MAC
   software fallback and KMAC exception.

Changes in v2:
 - crypto: cmh: wait for both eSW readiness bits at probe. The probe
   readiness gate polled SW_BOOT_STATUS for MISSION (bit 6, primary
   VCQ engine) only, but the sidecar engine signals readiness
   separately via MISSION2 (bit 7), asserted asynchronously. Gate on
   both bits so an operation offloaded to the sidecar cannot race an
   engine that is not yet up.
 - crypto: cmh: compute cmac(sm4) of a zero-length message in software.
   The SM4 core mishandles an empty CMAC input, so -- exactly like the
   existing xcbc(sm4) empty-message path, and per NIST SP 800-38B -- the
   driver now derives the K2 subkey and computes the tag with a software
   cipher. Surfaced by the testmgr fuzz comparison against the generic
   cmac(sm4); no change for non-empty messages.
 - Documentation: link cmh_mgmt.rst into the userspace-api/ioctl index
   toctree, fixing a "document isn't included in any toctree" htmldocs
   warning reported on the v1 posting of patch 17.
 - crypto: cmh: carry the XTS block offset (xts_offset) inline in the
   AES INIT command, matching the updated CMH hardware ABI that
   retired the separate XTS_OFFSET command. Always 0 on the skcipher
   path (data units start at block 0); no functional change.
 - MAINTAINERS: drop the internal moderated list (sipsupport@rambus.com)
   and the T: tree line from the CMH entry, per review. The driver
   goes through the crypto tree, so keep only linux-crypto@vger.kernel.org
   and no T: line.
 - Rebased onto current cryptodev-2.6 (v7.2-rc1); no code changes were
   required (the merge window touches none of the crypto APIs the driver
   uses).

v1: https://lore.kernel.org/linux-crypto/20260625173328.1140487-1-skrishnamoorthy@rambus.com/
v2: https://lore.kernel.org/linux-crypto/20260709203037.1884436-1-skrishnamoorthy@rambus.com/
v3: https://lore.kernel.org/linux-crypto/20260806195519.2703224-1-skrishnamoorthy@rambus.com/

base-commit: 68554337b4aa63d8299edd58f5059d8470bc721b
-- 
2.43.7
