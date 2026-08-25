Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022139.outbound.protection.outlook.com [40.93.195.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F1A4908A0;
	Tue, 25 Aug 2026 22:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787696164; cv=fail; b=npSCCf9NSRBVufIqRgxqcDTb/6pA7oek0LzAVOwY1Q45mIcKuIDrYwBKB/qahs8qdDTas2TNhVZpX4vH63aowCJxDdGhfMsIakUOMD0bFIChkEsoUhBLuudtWppkNQ0vcLtgmSqwcRXB+GbHnJpOPpMilachWUgo0tp19HL0yOc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787696164; c=relaxed/simple;
	bh=bTrQP8pNXy9Cuf5vDZflcAlizEJ4Q/li7KsD3sPbhPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JkBFjyCG64wvSwCOtLjWK82h8/MHZvk8zAzNs3LFLCrkN3nycy53Hda0nD3DueBNCASYy1qrDaoioB87pPPb7F4OJoAD95Ac9XtM4egXWYoIymaCDpAAJBytWEBKJNzBYkXBxc0QjC3z/TllU26sTcdh6fhrNHyCtR4Ha37qc7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=sSlneDQo; arc=fail smtp.client-ip=40.93.195.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="sSlneDQo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nn3IwDjNGh7pi5Kbpbuf8zeWrqKQY/1nU1MQzz2HaDosI90w0im+wDVGxAEt8we8nVCdEwGENZQ0pFwdrZ5GihKNGYP2zRs4/2KJBOOEHNg2stls754eg1Qz3uC3hZUA6cJuQPor7hvNXxQEjN8x8EVaTKZjcMdVzYXfMJ8mEn+R/Dii5J7cKAuOQ1qvDYjG1IIR5HMbvEVIHRyLhTduqJNrvmmx6JnCGE3m8+cL13EHoEQm7bbfiw0V1Slk4TFzp5Mfb1CJhLI6jW0tIm3IxlnVoW/adg8iWhER2MVb7nSzJwRNBk1B9ECtnfBkLQ4hkcppGl4x1lgc0Fe0if0FmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dFw5xgTTtQEZtSuMNPCmBsMXVO/pk1uiMdIrQvoI+CY=;
 b=jkGFEnfn2xTZ3hb6GGzisPwAiMkZSc6D4+TgLVqADLO+jcQuKxajOJdOLNHqiFg5h2arClnU6PRQgy/WyBrfm5RqfFpT/Jgb5aYfAS2gg/vz5dF4ldTuid36uz3lqRPnodjak+n7wrJC57R9iQ4OWY6q9P77zQkf799f1c4WT2jWj40uSTSgyZiwIUlh5dtVau29RhJn8BLnQKj+tPkXUuNRifp7SOeIO/Kv2oRzz7EaSCrXB/KITh5Kaw6mF6RpPvBirUeW9kJPUYSFGm4c/XQTJcRArsQ4Ytp6d5uQ72OzeloRg8v4rQgnMh6DCu41eflJXtRVObrMceOwFmtTVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFw5xgTTtQEZtSuMNPCmBsMXVO/pk1uiMdIrQvoI+CY=;
 b=sSlneDQoDfkz5APlQi7IboxuygIy7zvSMUNbyTCYjKWgEaJVgWGcXGoKuiaDs5ofHsfy6TpEOsvvpdQxSr639eZBLQIHsduNZhYsy+dkdkZX2OqY6oWugFqICt3c5eMwcCk8YN2M1koiKVeNFsFa43aIRoWsh17rEkGol1OGMgxv3Q5tSTCZ02fLHliMc+tfflZX3iRjBPBa+NGoQzwUURBmo4BQCRqLSt1EV7Q8/fbXrNHj62Rfo3opxxkYLgeA1IGU2hi075BdD1kSUCUpe+ri+y1kM9RswhW2mi4GDgL9C2IzfCic3ixJiQRCIcmDY50Li2p9F/X/jgVIZYcHng==
Received: from SJ0PR03CA0274.namprd03.prod.outlook.com (2603:10b6:a03:39e::9)
 by CH2PR04MB7109.namprd04.prod.outlook.com (2603:10b6:610:9e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Tue, 25 Aug
 2026 22:15:51 +0000
Received: from SJ1PEPF000023D0.namprd02.prod.outlook.com
 (2603:10b6:a03:39e:cafe::6d) by SJ0PR03CA0274.outlook.office365.com
 (2603:10b6:a03:39e::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.12 via Frontend Transport; Tue,
 25 Aug 2026 22:15:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy01.rambus.com; pr=C
Received: from hqxsv-psmtppxy01.rambus.com (192.86.86.210) by
 SJ1PEPF000023D0.mail.protection.outlook.com (10.167.244.4) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Tue, 25 Aug 2026 22:15:51 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy01.rambus.com (Postfix) with ESMTP id DD206180175C;
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
Subject: [PATCH v4 01/19] dt-bindings: crypto: add Rambus CryptoManager Hub
Date: Tue, 25 Aug 2026 15:15:20 -0700
Message-ID: <20260825221539.255951-2-aousherovitch@rambus.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260825221539.255951-1-aousherovitch@rambus.com>
References: <20260825221539.255951-1-aousherovitch@rambus.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D0:EE_|CH2PR04MB7109:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: aac4cfce-18f1-45c1-ced2-08df02f66c37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|82310400026|1800799024|36860700016|7416014|10067099003|56012099006|3023799007|6133799003|22082099003|18002099003|11063799006|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	igTG6sk+3LU5teQfBpY/mcX43JfmapqTA+c5sshlbSM3vwRCOFBxFJHQwSCD6Y1QQisPEtKSETf+22RcdEaGPu8LO9orZ49hi45+CdMz/VISkb/l7+YbZY3tdKtBPyN021N8DrfRySQ3MzZp0Jl469UyfETTlWSzQn1JEXhK8sFNQAmNJbKMA9caML8JOzWIbEwGCDa5Q42nxNw3fDY5NdcKrjMx/oMa8caxGN+dp24UHuI0xoo0C4v8sJRirdyiEwy2+XpZ3TDq8/yZbsw19OTRkIrMyP2EDbNgEG21jvItbTuXvpEyj1nhI8MDaBkm5qKUFpR3qoSPkOoHUWXKTr+/MTL/iRv4QpSIdlCFIJnMOm1oQV1PON/Msxo7AbzysiOEGp3f9TPbm5t2NlMZlHEOJ8L/cbU9OfrxyyJTME+fUPV0PGzaW5kdM3jtarsbnr+4nv/UdKifJBvo0+IAZT4eq0MQfPCLeiz5Tq24/W5tv5oM9aG425Lh1S2WHfTQPPysCQgMD/LN+9L/lO4mxdk+sPTcVo/GqvvyqQ0/ltYWCTaJ7b9cJIfAetkIuX4F4eFGi4P1EebPhJvCKSvjzrSSIomP99XwoskV587WxdraCNTUhjBqdp4zidhnOd8WyXMA3ojV1PIO71cjJhSN9cdWteQ+9aiKdc+lD8zRBiBJHHNo6GHII0tRBpiTcPi8
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy01.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(82310400026)(1800799024)(36860700016)(7416014)(10067099003)(56012099006)(3023799007)(6133799003)(22082099003)(18002099003)(11063799006)(13003099007)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0dyzWICsqdi41IXpZQFHAXI3D1trgLrL9gIjvIE5LXyV/z4AC6fzfbZhh+qpHD+GOHR0xMDgTmppaDeJIlwlf9wFJtr4R96+YLta+6wpTDf9kKcaLRaKkxwnRVyJEsTidZ+CSwqkkUZ4EsAJXeMGWHeP2z6ycVW9U2W03FJndgJxN8JvUfXiltaQRwYJ5cpf8OOzoecyBahv6sJb5SrNec7Sv3KDxcFILfSEZTy4BWpyD7K+nGPVkHsVPr0fNjX9v2vrP6eR3vuDdCSbhTvdp00VjY/lQ+sau/HGM8YMxtVOCNBgliemH8rdDs7sv6RHz3guXr5FIhHfwAm9LD+MGnmy5D690OpSOdAB5NCdVjP+VgvDsI20yQ3gPC58Hm+Weqlb8tkj+qOXCIPIdBOUnasjB6/ioudM39kUhDKUwARf4xqdKlzkvmiIIPIp7K1T
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 22:15:51.0246
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aac4cfce-18f1-45c1-ced2-08df02f66c37
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy01.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7109

Add device tree binding schema for the Rambus CryptoManager Hub (CMH)
hardware crypto accelerator.  The binding describes the parent
SoC-level node with its SIC register region and one queue@N child
node per mailbox the host owns, each carrying a reg (mailbox instance
index), an optional interrupt, VCQ ring geometry (rambus,num-slots /
rambus,slot-stride-bytes) and a rambus,cores affinity list.  Which crypto cores
are present is discovered from the SIC CORE_ENABLE register at probe,
not described in the device tree.

Register the 'rambus' vendor prefix for Rambus Inc.

Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
---
 .../bindings/crypto/rambus,cmh-v1030.yaml     | 194 ++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
 2 files changed, 196 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml

diff --git a/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml b/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
new file mode 100644
index 000000000000..d9598b0f3bbc
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
@@ -0,0 +1,194 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/rambus,cmh-v1030.yaml#
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
+  crypto cores are present is a fixed silicon-build property indicated by
+  the SIC CORE_ENABLE register, so cores are not described in the device
+  tree.
+
+  CMH gates access to a locked mailbox by a hardware HOST ID presented on
+  the bus with every access, permitting only the owning host's ID.  An
+  integration must present a single, stable HOST ID for all accesses to a
+  given mailbox, independent of the issuing CPU (relevant on SMP hosts
+  whose interconnect encodes the issuing CPU in the HOST ID).
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
+    items:
+      - description: Main functional clock ("core").
+      - description:
+          Half-rate "core-div2" clock (present only on configurations with
+          side-channel-protected cores) or the "rt" real-time tick clock.
+      - description: Real-time tick clock ("rt") for the internal timer.
+
+  clock-names:
+    oneOf:
+      - items:
+          - const: core
+      - items:
+          - const: core
+          - const: core-div2
+      - items:
+          - const: core
+          - const: rt
+      - items:
+          - const: core
+          - const: core-div2
+          - const: rt
+
+  reset-gpios:
+    maxItems: 1
+    description:
+      Host-controlled reset for the CryptoManager Hub.  The hub has two
+      external, active-low reset inputs -- a power-on reset and a hard
+      reset; where a board routes one of them to a host GPIO, that line is
+      described here.
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 0
+
+patternProperties:
+  "^queue@[0-9a-f]+$":
+    type: object
+    description:
+      One node per hardware mailbox (VCQ command queue) this host owns.
+      The set of owned mailboxes is fixed by the management host at
+      integration time and enumerated here.
+    properties:
+      reg:
+        maxItems: 1
+        description:
+          0-based mailbox instance index.  The instance's registers are
+          at reg * 0x1000 within the SIC region.
+
+      interrupts:
+        maxItems: 1
+        description: Completion/error interrupt for this mailbox.
+
+      rambus,num-slots:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        enum: [2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192,
+               16384, 32768]
+        default: 64
+        description:
+          Number of VCQ ring slots for this mailbox's command queue in
+          host DMA memory.  This is a per-board, per-mailbox host-memory
+          ring geometry -- boards built around the same SoC (hence the
+          same compatible) may use different ring sizes, so it is
+          described per mailbox rather than derived from the compatible.
+
+      rambus,slot-stride-bytes:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        enum: [128, 256, 512, 1024]
+        default: 512
+        description:
+          Stride in bytes between consecutive VCQ ring slots for this
+          mailbox's command queue.  Like rambus,num-slots this is a
+          per-board host-memory ring geometry, not derived from the
+          compatible.
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
+            queue@0 {
+                reg = <0>;
+                interrupts = <1>;
+                rambus,cores = <0x02 0x03 0x04 0x05 0x18>;
+            };
+
+            /* Slow asymmetric/PQC cores dedicated to mailbox 1:
+             * HCQ 0x08, QSE 0x09, PKE 0x0a */
+            queue@1 {
+                reg = <1>;
+                interrupts = <2>;
+                rambus,cores = <0x08 0x09 0x0a>;
+                rambus,num-slots = <64>;
+                rambus,slot-stride-bytes = <512>;
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

