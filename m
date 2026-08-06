Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11021127.outbound.protection.outlook.com [52.101.62.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8232F494830;
	Thu,  6 Aug 2026 19:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.127
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786046134; cv=fail; b=uFMMR4dMez6CN611vOAkLPzR8EHFDFfxLcD/GgrkQbc6+Gqu0/xD045Pygy21/bmx2N0WGsnd2svNAlnxviGGKKuLjnr2kIGwuYiCCAuaT6cPMCSzqxO95HMO0NYJ8WszhMqf6vyDgis19IOoQ2QZ/BjO8fqIQKdqUklVTrfKaI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786046134; c=relaxed/simple;
	bh=IJ5SBq3e6Bt1pNsfc3TGuAfLtTYBHefo+h+4Oc+xK3o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=juL0mt46mTY9RJJN6B4hmuoq52OfALHfMJzdzVOs/TS1TUevnGATwelaK68zarOVh7HVkd/uqfoHBpYtJCTaTREiX9Ma9z7WwV2DGjfXIQe2YiKvLcAu0c9lcfMA9zlNXhCLJsMD3mR73sOyCiVuyyYJInokkO5sblsdMscTi4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=ho/+IDpO; arc=fail smtp.client-ip=52.101.62.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="ho/+IDpO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uiJnMeEVWrARVeJAKxi/PtgNm4tltOI3qfIiw001ZI9Vk75BJOm7jHvwJbCE8VyGXK0VGzNLvmslepboOSNLtFj1YGKB8TIFW/Vwy/lVeXwQ/JZa9H5JEuKr3I5pqWbdQLvAJ5HyjeQE0szfuAi9J9iN/9WPBbFyf98sdR8MZuckn06jahw+jfg2w//8ybNh9lVeCDDkpvXSCu46+5RG5yrxpZ+L605TdJ5fnWw4eWYw5iP9oD39r82E3A7CcKIV88k+A4TVdDhw6J0SccX+boi19+0MI+kB9Iy080v/up8MDf8siHEEBFOCyOG+VT7gsa4llT2poNins/Gl5TiNhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YKOKyGfa2aAjHKsoye5pnQe6zvJ10LSCqxewIjsiY/4=;
 b=aot2IUFkNfwPv1f2fexuGQxg2VSPYJ/61QmVgc+4BwL5zJlZnF/1D/zN5bYhkfizrz3NsGetIbMzW1pjla6ScGxeWvqhI/VQcfLnyBgEPSHL4uipJ1CyFnqcYdOi0WOImULlJom7/ErfYPmzqDOoW8Mb4Bx86lxFOIWoVmLdFumes3Hpkguf+Sc7yoWeSksLpZylyR9K1GiIjoVkDRwkTFcMk2mkZdZ2/yWF4tHPR34Yl/zsG2vrphQ/y3YAJ6bsk9dn9gcFfA0g5D0FTHyuwO/mmwIbtq+gmLzCU667jljy0ESU1rMgerhcPKDS8LFtu/AMBDfScJJwpIH2kb0IQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YKOKyGfa2aAjHKsoye5pnQe6zvJ10LSCqxewIjsiY/4=;
 b=ho/+IDpOu717dxzmrc7el+GtE797/jh4R/F3uXTxYpkdgtOInLxyhX+VUT/bVpJE7ObfsUYjxwfbdgvvUdp+T0B9AYNYybwagBKb4KwLIhREoXt+T9++dhq/pVcsnpl1953Wjkx+Yn7yVT7UJ0n/+Gwwz1IZmXZ9mCUIdOnptF9QUoOYYCXNJGzmaFXSAKkvsOmYco7FomKxJREkBJerU6CFJCQWauMrmMbekO4aMFzXCUj/andVAqBZhXOKQGCJCDYR5IxzfvfggOr++SLyp8bYlzBjb884G+chXocKdItIGwfh23tJ2LQOK1vG+mqIwmZ4W88DgVneq/h4V0Rg1A==
Received: from SJ0PR03CA0030.namprd03.prod.outlook.com (2603:10b6:a03:33a::35)
 by MW4PR04MB7153.namprd04.prod.outlook.com (2603:10b6:303:67::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Thu, 6 Aug
 2026 19:55:26 +0000
Received: from BY1PEPF0001AE18.namprd04.prod.outlook.com
 (2603:10b6:a03:33a:cafe::30) by SJ0PR03CA0030.outlook.office365.com
 (2603:10b6:a03:33a::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.21 via Frontend Transport; Thu, 6
 Aug 2026 19:55:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 BY1PEPF0001AE18.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Thu, 6 Aug 2026 19:55:25 +0000
Received: from hqxsv-cmdev3-skrishnamoorthy.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTPS id A43111801748;
	Thu,  6 Aug 2026 19:55:25 +0000 (UTC)
From: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
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
Subject: [PATCH v3 00/19] crypto: cmh - add Rambus CryptoManager Hub driver
Date: Thu,  6 Aug 2026 12:54:59 -0700
Message-ID: <20260806195519.2703224-1-skrishnamoorthy@rambus.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE18:EE_|MW4PR04MB7153:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 8d81a04e-5164-4cc9-ed6d-08def3f4a8a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|23010399003|36860700016|7416014|376014|18002099003|11063799006|3023799007|13003099007|6133799003|10067099003|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	XduhScxT5DBYQU27E5dn7StrbTAHtMG/sCX1bY8jVPxINncVD/OkMCmE3pVN6/QLHt405yTuy7qBQEYBVE2VzczTgiNwT0F14JJOI6NJxZQqsH03Zj70rcJKaNO5ej1rRVGechItJ5IK6evKo3+Ba3jFUIN9trVYvHcQWiv8aK27p9Iov9G/ZzpGgUR0pDTQZu6TxbeK3Es5GlGXRKMFLtkgoDfneh9hIGhv1/ncPVEvc82tof3P+6lR5iMeZfjqogs+bRpMwZY58FfHgPmRhHVZxUA1Q/VV0Nb3010/1s4Ohw6o6SV/YPn5GnnjuV0EhipF1kEK+hBgXFS/ETzSKzRMiW2g8Q9ge6L1kqJLxsCoqc9jCy9BnTZjAllY81xTrickq8fP3gMfr/fpnq1U5wl3lRVOle44wzmoGNROs1XrcZOExbAz4/DWorepYL2htx62sK6Rz+TEPGOjTr+nl4rldmIw5QDh6WNrGF2H1vXKGjyy1cios84wtJ8j0NBoxL6+vGHD6d6iGzOTXjFMpeK3tvwnhugMgP9gB+9AgkEkndyQjnukn7Uec7enD57Frmy5MGAl+IW9r6FRELO/TRP3pZSvhOnbS0u6U5t9opppDrmIYakT/VOGjda6r9kuU45qYX/5feDkVELe4IbhhOoKdGV5IQjCuFuoZvDp4JyGTGFFTvh4l2oULMoTM0GanxtYBAomQhd0t8umhSF/OM7DAPJ1tKOlLKgJLNYQkgpAqBAOJiJJ/wBXrdYX88fO
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(23010399003)(36860700016)(7416014)(376014)(18002099003)(11063799006)(3023799007)(13003099007)(6133799003)(10067099003)(56012099006)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gSsU/Exyt+i+gkv0Y+9hC2i3SMBpNH/Uja2J9+o3kt1hrNO/o3B+6+zIqMuNtMjiPnrEqBGhcjLLnUw/xVMrYE+73jipNbNaKPjRmCprp+q87NZ6KFB4ml5nik/CItuIv5yuwA5z0VX0Rp0kxEVciHAO2XyBE/YfZ0CQHmXsOApaX7DiBbxgkC5Sj9g640c79TysfaN217Odwv8XiU/S5Ay924/FJYQKjCoUbJJgTO8F12bsFf18ubQIcBdFqP8LsundCOt+eq/JRBcGkpz8wRkBEx1tGKZ/uC+TVs7Cd+RxVDvbbig5PWM89zbgO9lxlAZybUp+VMGfUCLpZeHrfdESzWtcVXKrtKLBIzlShjinOgHTOwlVBE+vreoPOalkIQiidnuv5TsX2wC2bSS8o7o9/PL6CVWMXiU7SK5+16YfIPJWqyZwpT52U41qquSY
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 19:55:25.8164
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d81a04e-5164-4cc9-ed6d-08def3f4a8a8
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE18.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7153

From: Alex Ousherovitch <aousherovitch@rambus.com>

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

The driver also exposes /dev/cmh_mgmt, a misc device providing 44
ioctl commands.  Relative to the in-kernel crypto API these fall into
two groups; the distinction matters because some commands name the
same primitives the driver also registers, and that overlap is
deliberate and bounded:

(1) Operations with no crypto API representation - the large
    majority.  The crypto API has no transform type or verb for
    these, so a character device is the only available UAPI:
      - hardware key lifecycle: create, import, export, derive,
        destroy, enumerate (keystore CRUD) - no keystore verb
      - KIC key derivation (HKDF, AES-CMAC-KDF, DKEK)
      - asymmetric key generation (RSA, EC, EdDSA, ML-DSA, SLH-DSA)
        and public-key derivation - the crypto API has no keygen verb
      - ML-KEM encapsulate/decapsulate - no kernel KEM API exists
      - SM2 encrypt/decrypt and key exchange (multi-step GM/T 0003)
      - EdDSA sign/verify - not registered with the crypto API
      - EAC Chip Authentication and DRBG (re)configuration

(2) Hardware-held-key operations on algorithms that ARE also
    registered (RSA decrypt, ECDSA/ML-DSA/SLH-DSA sign, ECDH).  These
    name the same primitives as the registered akcipher/sig/kpp
    transforms, but the crypto API's set_priv_key()/set_secret()
    accept only raw key bytes supplied by the caller; they cannot
    reference a private key that is generated inside, and never
    leaves, the hardware datastore - the central security property of
    this device.  The ioctl path keeps the private key
    hardware-resident, while the registered transforms serve raw-key
    in-kernel users.  The two paths are complementary, not redundant.

The device requires CAP_SYS_ADMIN.

/dev/cmh_mgmt is built conditionally on CONFIG_CRYPTO_DEV_CMH_MGMT
(default n); when disabled the ioctl interface is absent while all
kernel crypto API algorithms remain registered.

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
rambus,cmh.yaml binding).

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

base-commit: e264401ce4776a288524e5b87593d4d864147115
-- 
2.43.7
