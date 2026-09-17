Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11020123.outbound.protection.outlook.com [52.101.46.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B7C4AF9D3;
	Thu, 17 Sep 2026 22:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.123
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789685983; cv=fail; b=u29uo2zgmYuX0FwfGG94IX+MRtQx8IpNNupKDNn5dTHgwXxwtE3bWIjZ6M/xMJ+1zuCS2OxH+BPeWmhJ6bHZ8+DSNtv2xGRQEO4wMFCj/WwYSZOI7BkbcWpxJraeojK7A1JY3WMpSrdEmISRsjV9B50Rd5i0tuhCogImYhqGO3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789685983; c=relaxed/simple;
	bh=KPid1DvbKZYJ6cuOZsaYd2mTDanxKfz4CaOu/0iEp84=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iuCnG7UVtaMSiSZHuZqptb3h1/OTisZI0dpl/OuWRAk8FjxlKtxLeXU72T4O01zPUK4DoS2sLs48y0jdTioXsOEXuq7Fh26WjvsVYUUmuvrKxOoKhYKHqimjJ+V46+SWQVWIvLNYu1SwmEAPLa9K1JmMd16IlamS1g0ehSIqBtU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=4mEq/oRE; arc=fail smtp.client-ip=52.101.46.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="4mEq/oRE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vxZPIjd06lLNEM1j0uZN8O9Yb3hq4m0v2x81YL9RgjOBUEuYZrGIlgn/OYTw2YQWNOXN4t/vP7MJ8aNvah2cDiZ/kPpvUzq0DKGGVQoaD41w4axrGDJbeDpfNDzs+rr1c0Xik/j8fqDCC8e87PbzXxUmNPtgLKh3wQASV/Ou7N+G5xzHEiR5stQP3VQ+iDapEo4cPBXMXnfqYeWYv9l3gHF4xYR/6sgQllPx4Lydx2Egcwupq0I0B0CyZKHarbTOZAFrJO6m6Az5IsmlZJkCaA98oHSGpQFZk8jYtjmn8BgrEXx7Iddc4D9pCIU2J1wZ03t3IBaPVEhDXYqhQknO6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O2rRE5vHcfB+4uDNq3iMXQNPfUjpQDF8HPLSPe7ddFc=;
 b=LTLOu5I9rMCQe0F3AAck026MALOZGgjZIwyTtFcYILWlqNYttlse+o1i6x4cy0itIoG+wGkCrUDA5MF6LVHBf6io5dCCM9aRkjkXh9tSVeVF1zqRa5eVbLIkWWPx97twNmoobh0VP5h+gX1hymukZJhWK2osrHodsv6s1HPqK65/IZBySMwYB2C+oA06ZPCDc1BLhU8hgTzBb/0CZYsxV7XFEmo6m/0/kwrnEO5i7YKFAatKB9g3PVOnkhwQhbedta9zl1RrvoFTQcjouontf/MjHgeQ566jRURHrA/6Xek49t2hMBYRfNroCmHRYBvPUb4fccHPx/RNPFFvN+pKPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O2rRE5vHcfB+4uDNq3iMXQNPfUjpQDF8HPLSPe7ddFc=;
 b=4mEq/oREjyeKdx6/M/cddLtB2UufVY5j3zOkjcYYnVeQUhQWY8Z3MY1XcZbflfJ/R2habK4XVQ49dlS3sRGVj3J5l7E8dtBwNGNelpj43Uzg5m97Wc7h0lEIAHA9ne+gxvqBUS+TIPY5ajdafTX6ZxP4dnD/GRAQUHXpEMvF885CfPrZKfDMbj5ob1SKq2zdoUqWM3U4BnP9+5oD/lPoMVXUmqNJz1a7P7/99tA00qq7jaeydd87E2ETU9RXhKLyXhFH6J3rv8t11qBaPffgxsHvynsCDZcAaJCGis+qNB9itdPyTzGM2VAd5EScdH8eMNHM6HRlxsM+iDlAOdpRtA==
Received: from SJ0PR03CA0034.namprd03.prod.outlook.com (2603:10b6:a03:33e::9)
 by DS0PR04MB9344.namprd04.prod.outlook.com (2603:10b6:8:1fb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Thu, 17 Sep
 2026 22:59:33 +0000
Received: from SJ1PEPF000026C3.namprd04.prod.outlook.com
 (2603:10b6:a03:33e:cafe::55) by SJ0PR03CA0034.outlook.office365.com
 (2603:10b6:a03:33e::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Thu,
 17 Sep 2026 22:59:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 SJ1PEPF000026C3.mail.protection.outlook.com (10.167.244.100) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8
 via Frontend Transport; Thu, 17 Sep 2026 22:59:31 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTP id A3BC01801748;
	Thu, 17 Sep 2026 22:59:31 +0000 (UTC)
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
Subject: [PATCH v5 00/19] crypto: cmh - add Rambus CryptoManager Hub driver
Date: Thu, 17 Sep 2026 15:59:09 -0700
Message-ID: <20260917225929.2494111-1-aousherovitch@rambus.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C3:EE_|DS0PR04MB9344:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 017cc748-e20f-4a05-e204-08df150f55d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|36860700016|1800799024|376014|23010399003|13003099007|921020|3023799007|7136999003|11063799006|56012099006|5023799004|6133799003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	kPP1JKV/10yVxSDwy/YzH3K2fW8W//Ex8gD/d+/i1G/8xB3SycPR/auoFqy1qtNXCyyugs/9nQu5U2gt3jm3JcMghrVb4uuHtyKSiWR5e/nP/+YQwA2tHNO0+WesYBLzmYX5NsNmt0ydPKDMr6rlC3O+mjSQM9YtFtp6XW6QpQEN0kMWlaacbpLe/YxVG8x1ZBtg5fhg0qfwHFYWsmEcOI24rBdZAmYnMO7Km4aZehvdPJqQTyWYf1qRWUhUDB6qmyBYRKsXelKMpoynQcMPKRe5dmJZ6CQbp2UuRcYTtBextT81n2NW0qyHjAUkbVFT9HIZddDrIrd9KX3IRP/n/C1UG4HnswNsaT9uUjEaV4Uu0pFyAyYO3ExWTuhvYQBRNoNdTgahW595cSrskqGN4ge7VsVcH2ogDXnVVz2CedIppEGIdbK/adoiroR4XVRh74325Tm+/UZUGr5ZamF5GuiFSupVfB8Q8zIsC4+g7Eeaqo93kZQBOgo5LUm+1M4APySTB4oCNbXptOBQISjoMHcLQ2LnUrRgB4JoDIUX3yStpDMg/gsSleFDWpfO+w7IH2+DQU2USF+65sZ2cnz3M9UbQ3U2a+EwEDr5Rp51LykhYvc5rpN/+zOcl2YHFpXFd2SePJOWTh3Tf3LDvfS1RPb5S3wgZNB6TGXxZwyd5u87QSRyc0nP6DzzrwnIIkcN9j9qjruVlNxk9cMP4ymh4e8gageM34SSzx4c7xw02eZ9Ax12ia+cJ4XYtpc1vHpU
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(36860700016)(1800799024)(376014)(23010399003)(13003099007)(921020)(3023799007)(7136999003)(11063799006)(56012099006)(5023799004)(6133799003)(18002099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OOCMzQS42fXbtruupVrWIxXf0OwXSzqDUtLPDz+qeNQ+p+3SEceHFhxAIzfWjAI/Pu+RBvas1W/eikP0Qvp2PQitZ/850dHIl3sLpdk1hWDY13Ic1QafKV9omx4RB1Gl127BCoL1TDhAqKob6yd74zVfyqYo0uRKF/XAXuoCG2E901QcSIfSNSdJul4r5DV51v39E5D5OoTeoBPBq1zgXwD7VGjaanyTudaN3Kd1FSXEnB6YmOIsCmz+H+iY2H81WKLiAU4tyE37qOWEWCgzeKCqMUX4Ops+BbKMDlaFAdxSNkf62NYrjYkE+wufTaiEuVvG4s3tvlwDcVfWIWjuTEkuIeeSZwrAKzIIuu8ZN8OZwT1hrs9RmKXl3uDqOnaiDhh7Uo8Ciwkaxf6DW1zgPnl4DufywFj1buDdvCFR/vMSEv9AluT59L5lVi960DEU
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 22:59:31.7925
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 017cc748-e20f-4a05-e204-08df150f55d1
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9344

crypto: cmh - add Rambus CryptoManager Hub hardware crypto accelerator

This series adds a driver for the Rambus CryptoManager Hub (CMH), a
hardware cryptographic accelerator IP from Cryptography Research at
Rambus Inc. (https://www.rambus.com/cryptographyresearch/).
CMH provides a broad set of symmetric, asymmetric, and post-quantum
cryptographic algorithms accelerated in hardware, accessed via a
mailbox-based Virtual Command Queue (VCQ) interface.

The hardware is a platform device matched via device tree
(compatible = "rambus,cmh-v1030").  It exposes a single MMIO register
region (SIC) with per-mailbox doorbell, status, and command registers.
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
  - Kernel 7.1+ minimum; developed against Herbert Xu's cryptodev-2.6
    tree (7.3.0-rc1)
  - sig_alg backend (upstream since 6.13)
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

Changes in v5:
 - dt-bindings: crypto: cmh: rework the compatible and rambus,cores per
   the DT-bindings review -- require a SoC-specific compatible ahead of
   the "rambus,cmh-v1030" IP fallback using the inside-secure,eip93
   "not: {}" idiom (which forbids a bare or placeholder compatible), and
   drop the example since none can validate until a real SoC is
   upstreamed; switch rambus,cores from hardware core-ID integers to a
   string-array of core names (hc/aes/sm4/sm3/hcq/qse/pke/ccp) and drop
   the hex-ID table; keep clocks and reset-gpios optional with a
   hardware-framed note (the management host owns clock and reset), and
   replace the ambiguous positional clocks item list with a
   count-bounded description.  The driver maps the names to core IDs and
   rejects an unknown name.
 - crypto: cmh: fix transaction-manager / response-handler races -- on a
   multi-VCQ error, FLUSH+drain instead of RESTARTing the eSW into freed
   slots; clear the watchdog-active flag before deleting the timer;
   serialise the mailbox TAIL doorbell against the wake re-poke; drain
   stragglers with -ECANCELED after a management FLUSH; ABORT on a sync
   timeout only when the request is at the mailbox HEAD; reject an
   over-large num_vcqs; and re-check the running flag under the queue lock.
 - crypto: cmh: convert the SHA-2 / SHA-3 / SHAKE, SM3, and cSHAKE ahash
   drivers to CRYPTO_AHASH_ALG_BLOCK_ONLY per the v4 review -- drop the
   hand-rolled partial-block buffering and let the Crypto API hold back
   sub-block data.  .update() hashes whole blocks and reports the leftover
   count for the API to re-buffer, .finup() also serves .final(), and
   export/import carry only the hardware checkpoint.  The drivers no longer
   set CRYPTO_ALG_REQ_VIRT (BLOCK_ONLY buffering is scatterlist-based), so
   virtual-address ahash requests are no longer accepted.
 - crypto: cmh: harden the streaming ahash drivers -- cap the bytes an
   AF_ALG client can pin per transform (HMAC / KMAC / AES-CMAC / SM4-CMAC /
   Poly1305) and give Poly1305 its own DMA-safe key buffer; reject an
   over-large one-shot hash / SM3 / cSHAKE linearisation with -EMSGSIZE;
   and make each MAC .final()/.finup() retry-safe by preserving the
   resumable state on a synchronous submit rejection.
 - crypto: cmh: management-plane hardening -- serialise the /dev/cmh_mgmt
   ioctls under one mutex; scrub transient and partially-created datastore
   objects on the SM2-ECDH-hash and KIC/KEY error paths; guard the
   added-randomness DMA unmap on the buffer and zeroise it; reject RSA key
   sizes not a multiple of 8 bits; and allow 0-length ML-DSA messages.
 - crypto: cmh: fix a mid-function declaration in the SLH-DSA sign path.
 - Rebased onto current cryptodev-2.6 (7.3.0-rc1); no driver code changes
   were required.  The 7.3 crypto changes (the lib/crypto AES-mode
   refactor, the internal xts_verify_key split, and the mod_devicetable.h
   -> device-id/ reorg) touch none of the crypto APIs the driver uses.

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
v4: https://lore.kernel.org/linux-crypto/20260825221539.255951-1-aousherovitch@rambus.com/

base-commit: 9695df3b1db4ac4534274d38ee16e3b9b0bf910e
-- 
2.43.7
