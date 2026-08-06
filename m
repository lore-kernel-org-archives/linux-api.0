Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11022104.outbound.protection.outlook.com [40.107.209.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78633B47D2;
	Thu,  6 Aug 2026 19:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786046138; cv=fail; b=Bs6l4vNbEK24Go5DKcSZ+tllFiiEHhKKqYZXSwz6ICCQrYpp4LsoEfHqCPvfLryFVWqYuhL+ypDhxz7kB2/8RqCMvQYKFATknan07VMismu3HVYlJfwJ3Q4AXXe1WHiDDfAnnjeQA3IByCJfCZN2kLFX71VW4fdnBZYVszGVWPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786046138; c=relaxed/simple;
	bh=gW/vt6DcLmqtuvVdmCZs6kdOvx4kdLL06eMNL5nVnBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NR2ZWfpyPI30FX05JlEpmKXQ6/q8N6OovZtdWnWLpAQfkShfBzFvm47hAX8Vj+R3VPHS3xM35WaruDHX0z147rTtnRBx7BjeUdaH+cHrfw9qXFlURnxgRmbQ/QFtPwDu2YrlcIWw5s0mEEkqeBzfie6VXD6VKLO8yEOe7Z1urwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=p9a3G7IA; arc=fail smtp.client-ip=40.107.209.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="p9a3G7IA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tl4YnH/x01yu5vDeTYsNoKr3C1HMhXoN5zD3ipA/8joXzrLBC7oxLfZTUoeANhP31/5At1zpKZ5eZllLvU0HlKRW0GpAOFiZqYjrghgOiAlynxJr5uidaebcWHh7say1Lk43KZgigzByhbKrCZX6M1RVfL+29dDvHzvk4cVQvNwCdJfDYHTu08bhG92ebe8Wlp5W6XVAeOO307iaP8TFzsGWIL5jdaPvetwtxiLdAwpMj2DaNaWqSUU/CD1VYv10GG7iQ+nXZuZj2tDx5+JpkCxMKDAdn64siYvRZyecF0xxANi2ShsohCTUSx4dDCgyv68SPdAgk5Gx/q87aGcTMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bjO/NHtTBty0hfd9lbJTuZ8iZuxLCHqQSdz9YT9kwZI=;
 b=w5faXL23ljXwXodGT8bHIE6doFriWfdWXo0SckmF1YqnEbcRkOr3HYakWcDvOhaG5Yd2cwM6osnlxmPYLmWZs1tjTuhmAOxdOeqYSxFseIV8tOClyb5geDYIDdoH2nJYz//Aseg9UbdHfyONtPUi+xgmKr4QR2X7fk1hT7x+OwZwu3HxQyTBf9tG5BFmiYBJ7kbcanP681XbVkXlxAI+cOaeyfXaKVvApBDS+jhHVvx46U8R9evPyvgzTjTPJG6Fk7lBTdF09O9LxfJ+bNNZu06nm75uM/VcdCHyI1rOxMua+v5GslcN/zK3DMfuARdGphNJphkNaQeLsDJFefxYSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjO/NHtTBty0hfd9lbJTuZ8iZuxLCHqQSdz9YT9kwZI=;
 b=p9a3G7IAfanJ2wP36ghltzw/iiw624JbyTnqMMW6rnuRblTjxSVrIUASvoSlQothF7iD8u1BcfnQHJtUyCrpBFMrj4LUHlpBseYUmnIza3cYRL80gX91NOeNWwVCVJphnMAyTVPGq9CuWABGviLXbEYsZ94o42HBuTNojEXmh9Sc834KWuBbKKHA/30Z2B0DZhT4iDlSMUNjzRYeBL+NC5OsLeOIoV9UxHjkFFn5Ssr5U1mzdlbVCtaYAzTElh0qClqjBEoWxfdpoY0+BBTS7cA3w66MMgfzNP75sNzkDzaZo4tKnTxuIZRhaez5oxuw3TfVpQCoGxmsm/2PQXUf8Q==
Received: from CY8PR12CA0041.namprd12.prod.outlook.com (2603:10b6:930:49::18)
 by PH8PR04MB9930.namprd04.prod.outlook.com (2603:10b6:510:3a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Thu, 6 Aug
 2026 19:55:28 +0000
Received: from CY4PEPF0000EE30.namprd05.prod.outlook.com
 (2603:10b6:930:49:cafe::22) by CY8PR12CA0041.outlook.office365.com
 (2603:10b6:930:49::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.21 via Frontend Transport; Thu, 6
 Aug 2026 19:55:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 CY4PEPF0000EE30.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Thu, 6 Aug 2026 19:55:27 +0000
Received: from hqxsv-cmdev3-skrishnamoorthy.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTPS id 263CC1801748;
	Thu,  6 Aug 2026 19:55:27 +0000 (UTC)
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
Subject: [PATCH v3 01/19] dt-bindings: crypto: add Rambus CryptoManager Hub
Date: Thu,  6 Aug 2026 12:55:00 -0700
Message-ID: <20260806195519.2703224-2-skrishnamoorthy@rambus.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260806195519.2703224-1-skrishnamoorthy@rambus.com>
References: <20260806195519.2703224-1-skrishnamoorthy@rambus.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE30:EE_|PH8PR04MB9930:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 4708c3d0-0fe0-4127-0f65-08def3f4a9ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|82310400026|376014|1800799024|36860700016|10067099003|56012099006|11063799006|6133799003|3023799007|921020|18002099003|22082099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	Tv9K8tO8GIXsm9B/t44rnU4xS1B5c/pqVqd0Gkr0mOZG/WfTYBcdkgNw0kif7u+VaDfgywMFZa9Blz1B+Wmw6pALewlrXHR93sUHepflLliwOslNaNNv9f4MzeaJJMOBb6Zbbe2Hq6kaD0oMCdejvJQ88KLKFPwH1mYhShrNRjbc9jxZOVUllz+p8+G4AT1IZrHE6lpGf8wui/CiceU27xkytnJJFKUQz88MVBUUQV2DxKmqKvuoUKw7wV8skyaGHvWoo6KouMr41sUwei5ocEZc/Jc0fBKwx62FQF3mhnlYgbgdT7iemgnmuXDpvKc3SK8ekg8YFKBresRDsu9U1lBB3UI1IZVLpOYYRX+csoS4/4uclIKA2RCnPl7sRiTmDjAXK5Ucss1R8+BJSCMdpm0ItC5PgLzgHwSqhYeHLugw44054DIimqiBf2XyYyO8tFrjSy9mil3b9SoHhxjmUYTu6aF8UdWnQfTWXLZQhyx+jzh7uB+C6Xs0SzhW4855H9PsgPUu2ITgb3xtbv4L3H+XNaKQqsXrqSSk48gZegUbWjBD/pIjISjo7aqUFXO+xj9H0uSPS6APUlg7gz9YZrJTlhN0Romgff0b4FulVQlY1cs8Qy+DV4gnI6tr2XeNoPLf1kvr8chp0/yL37uB/EeRGg3PNkWmUPuqZszOkWdJvGKw/3bpY/cfrpQYNhStap8MbZUvyEDBlCVZlUZPIQdDpoH1mHHdUYpf4i1gMqAARvehKGLmFNkxuf4fFTxN
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(82310400026)(376014)(1800799024)(36860700016)(10067099003)(56012099006)(11063799006)(6133799003)(3023799007)(921020)(18002099003)(22082099003)(13003099007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tmKtLv0SjJkwr9K3O7XyqkP1GdLAhqq+Q5x1DyTIMwEhZZoQ9Mu+GiMIWgqHvkGhX+Du+p3K7BE2CMdDJ8Knwidrf7DxQPo+oISN79CtmLStUwfRbSbixo1tCkCpGlZ/veMFIOBEZYSFHfxgLFAd6yLvC03ZAMF9GaNDn0wLxagOY9gmMkfMDIWqtjYzz8I4vB5orpLdwzkI8gH+2s84l82FmeQvoBcw36vHAtLKuyEiZCYyhhtcaeXcRpcH6EtTwv2n553NsL+21QgrNw8SB2HoZxfne22l2qCmDrZz7RkqV6rysuGWC7LegIHYRE53w4acW0cm5ZSxDNhsoXB1MvDW08odj+L7fEYanD2XzA9s8bD2oWHlmuEj9jVKo9fqInvh5/uqbGrJyM35melCF2fb/TPAsGx6c5j8IpIS5ogSWmvsHCW85eaCT1TMxkzg
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 19:55:27.6040
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4708c3d0-0fe0-4127-0f65-08def3f4a9ab
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE30.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR04MB9930

From: Alex Ousherovitch <aousherovitch@rambus.com>

Add device tree binding schema for the Rambus CryptoManager Hub (CMH)
hardware crypto accelerator.  The binding describes the parent
SoC-level node with its SIC register region and one mailbox@N child
node per mailbox the host owns, each carrying a reg (mailbox instance
index), an optional interrupt, VCQ ring geometry (rambus,slots-log2 /
rambus,strides-log2) and a rambus,cores affinity list.  Which crypto cores
are present is discovered from the SIC CORE_ENABLE register at probe,
not described in the device tree.

Register the 'rambus' vendor prefix for Rambus Inc.

Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Reviewed-by: Joel Wittenauer <Joel.Wittenauer@cryptography.com>
Reviewed-by: Thi Nguyen <thin@rambus.com>
---
 .../bindings/crypto/rambus,cmh.yaml           | 207 ++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
 2 files changed, 209 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/rambus,cmh.yaml

diff --git a/Documentation/devicetree/bindings/crypto/rambus,cmh.yaml b/Documentation/devicetree/bindings/crypto/rambus,cmh.yaml
new file mode 100644
index 000000000000..2709e20fb76f
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/rambus,cmh.yaml
@@ -0,0 +1,207 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/rambus,cmh.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Rambus CryptoManager Hub (CMH) Hardware Crypto Accelerator
+
+maintainers:
+  - Alex Ousherovitch <aousherovitch@rambus.com>
+  - Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
+  - Joel Wittenauer <Joel.Wittenauer@cryptography.com>
+
+description: |
+  The Rambus CryptoManager Hub (CMH) is a hardware cryptographic accelerator
+  accessed via a mailbox-based VCQ (Virtual Command Queue) interface.  The
+  host writes VCQ command sequences into per-mailbox DMA queue buffers and
+  rings a doorbell; the CMH eSW processes them and signals completion via
+  interrupt.
+
+  The management host statically partitions the hardware mailboxes across
+  the SoC's host interfaces at integration time; the set of mailboxes a
+  given host owns is therefore fixed and not runtime-discoverable (a
+  mailbox locked to a host reads as unavailable in the SIC availability
+  register).  Each owned mailbox is described by a child node.  Which
+  crypto cores are present, by contrast, is a fixed silicon-build property
+  the driver reads from the hardware at probe (the SIC CORE_ENABLE
+  register), so cores are not described in the device tree.
+
+  CMH identifies the host that owns a mailbox by a hardware HOST ID
+  presented on the bus with every access, and permits only that HOST ID
+  to access a mailbox while it is locked.  An integration must therefore
+  present a single, stable HOST ID for all accesses to a given mailbox,
+  independent of which CPU issues them.  On SMP hosts whose interconnect
+  encodes the issuing CPU in the HOST ID, the integration must provide a
+  single consistent HOST ID for the set of CPUs that share a mailbox; the
+  driver neither selects nor can override the HOST ID presented by the
+  hardware.
+
+  Supported algorithm families: SHA-2, SHA-3, SM3, AES, SM4,
+  ChaCha20-Poly1305, RSA, ECDSA, EdDSA, ECDH, SM2, ML-KEM, ML-DSA,
+  SLH-DSA, LMS, XMSS, DRBG.
+
+properties:
+  compatible:
+    const: rambus,cmh-v1030
+    description:
+      Identifies the CryptoManager Hub v1.030 IP revision (register map and
+      command ABI).  A specific SoC integration should list its own
+      "<vendor>,<soc>-cmh" compatible first with "rambus,cmh-v1030" as a
+      fallback; that extended form will be added when such a platform is
+      upstreamed.
+
+  reg:
+    maxItems: 1
+    description:
+      SIC (System Interface Controller) MMIO region.  The registers of
+      mailbox instance N are at offset N * 0x1000 within this region.
+
+  clocks:
+    minItems: 1
+    maxItems: 3
+    description:
+      Functional clocks driving the CryptoManager Hub.  The block gates its
+      clocks internally (integrated clock-gating cell); the host does not
+      gate them, so these describe the input pins only.  The names, in
+      order, are "core" (the main functional clock), "core-div2" (a
+      half-rate clock present only on configurations with
+      side-channel-protected cores) and "rt" (the real-time tick clock
+      for the internal timer).  Absent on integrations where a separate
+      management/power controller owns the clocks and Linux has no clock
+      handle.
+
+  clock-names:
+    minItems: 1
+    items:
+      - const: core
+      - const: core-div2
+      - const: rt
+
+  reset-gpios:
+    maxItems: 1
+    description:
+      Optional host-driven reset for the CryptoManager Hub.  The hub has
+      two external, active-low reset inputs -- a power-on reset and a hard
+      reset; where a board routes one of them to a host-controlled GPIO,
+      that line is described here.  Present only on integrations where the
+      Linux host is the management host; where a separate management
+      controller owns reset (the usual case) it is absent and Linux does
+      not drive reset.
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 0
+
+patternProperties:
+  "^mailbox@[0-9a-f]+$":
+    type: object
+    description:
+      One node per hardware mailbox owned by this host.  The mailboxes a
+      host owns are assigned by the management host at integration time
+      and cannot be probed, so they are enumerated here.
+    properties:
+      reg:
+        maxItems: 1
+        description:
+          0-based mailbox instance index.  The instance's registers are
+          at reg * 0x1000 within the SIC region.
+
+      interrupts:
+        maxItems: 1
+        description:
+          Completion/error interrupt for this mailbox.  Optional; when no
+          mailbox has an interrupt the driver falls back to polling.
+
+      rambus,slots-log2:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        minimum: 1
+        maximum: 15
+        description:
+          log2 of the number of VCQ ring slots the driver provisions for
+          this mailbox in host DMA memory.  This is a per-board,
+          per-mailbox host-memory layout choice programmed into the
+          mailbox QUEUE/SLOTS registers, not a silicon constant --
+          boards built around the same SoC (hence the same compatible)
+          may provision different ring geometry, so it is described per
+          mailbox here rather than derived from the compatible.  The
+          upper bound is imposed by the hardware.  Optional; defaults to
+          6 (64 slots).
+
+      rambus,strides-log2:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        minimum: 7
+        maximum: 10
+        description:
+          log2 of the per-slot stride in bytes for this mailbox's VCQ
+          ring.  Like rambus,slots-log2 this is a per-board layout
+          choice, not derived from the compatible.  The range is imposed
+          by the hardware.  Optional; defaults to 9 (512 bytes per slot).
+
+      rambus,cores:
+        $ref: /schemas/types.yaml#/definitions/uint32-array
+        items:
+          enum: [0x02, 0x03, 0x04, 0x05, 0x08, 0x09, 0x0a, 0x18]
+        description: |
+          Core-affinity list: the hardware core IDs whose work is
+          dispatched to this mailbox.  A core ID may appear on at most one
+          mailbox.  Cores not listed on any mailbox are load-balanced
+          across all mailboxes.  Optional (default: none -- the mailbox
+          only serves the load-balanced pool).
+
+          Because each core instance has a distinct ID, separate
+          instances of the same core type can be pinned to different
+          mailboxes.
+
+          Core IDs:
+            0x02 HC, 0x03 AES, 0x04 SM4, 0x05 SM3,
+            0x08 HCQ, 0x09 QSE, 0x0a PKE, 0x18 CCP.
+
+    required:
+      - reg
+
+    additionalProperties: false
+
+required:
+  - compatible
+  - reg
+  - "#address-cells"
+  - "#size-cells"
+
+additionalProperties: false
+
+examples:
+  - |
+    soc {
+        #address-cells = <2>;
+        #size-cells = <2>;
+
+        crypto@a4800000 {
+            compatible = "rambus,cmh-v1030";
+            reg = <0x0 0xa4800000 0x0 0x41000>;
+            clocks = <&cmh_core_clk>;
+            clock-names = "core";
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            /* Fast symmetric cores dedicated to mailbox 0:
+             * HC 0x02, AES 0x03, SM4 0x04, SM3 0x05, CCP 0x18 */
+            mailbox@0 {
+                reg = <0>;
+                interrupts = <1>;
+                rambus,cores = <0x02 0x03 0x04 0x05 0x18>;
+            };
+
+            /* Slow asymmetric/PQC cores dedicated to mailbox 1:
+             * HCQ 0x08, QSE 0x09, PKE 0x0a */
+            mailbox@1 {
+                reg = <1>;
+                interrupts = <2>;
+                rambus,cores = <0x08 0x09 0x0a>;
+                rambus,slots-log2 = <6>;
+                rambus,strides-log2 = <9>;
+            };
+        };
+    };
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 396044f368e7..8b1a8f0a673d 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1371,6 +1371,8 @@ patternProperties:
     description: RaidSonic Technology GmbH
   "^ralink,.*":
     description: Mediatek/Ralink Technology Corp.
+  "^rambus,.*":
+    description: Rambus Inc.
   "^ramtron,.*":
     description: Ramtron International
   "^raspberrypi,.*":
-- 
2.43.7

