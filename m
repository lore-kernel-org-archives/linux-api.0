Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020133.outbound.protection.outlook.com [52.101.193.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607DE49A3AA;
	Thu, 17 Sep 2026 22:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.133
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789685980; cv=fail; b=hDvaQHXXctqU3v+u9k4I+SWmcgdHnSSaEOZr4nC/hC21o5GxQQF+dKQMWgt1rpK3AUvFYMTvz8GAn+J+ba+aT/wBBlThLEsTNzCxDLq3Yi4Jkc+dfkZMbPT/aAKpLYZ69emShM4u7mPJTsKUR1F7fR+qB6GSwIKbfdcedwhn+Ps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789685980; c=relaxed/simple;
	bh=3OFVAQgfwvvfpf4nlrXDFyGecnrLNdgtKUC2v1GeEGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=As9Dya8sA6IVGLgDiWsMK6XLNYRZy4TwPBVIGg4G1QTe9GYHOZ3fuEr2APv8bK7OlUqQ0vcRLJZfPoIfQaAevTMs3bb9K+qmv6+VFjbfBEGIwfaWMfCj06Lx3x+GsnnXYYG3i15MFSrVCaRX3dcmtoNls3zJ2NwwUyVHSbemXzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=0w3k9DjE; arc=fail smtp.client-ip=52.101.193.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="0w3k9DjE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v8BbifW1DdYYpHepq9LDbW+ckfReTFYmYarjta/BPBx7hCXmhlvxYuiaLS/EVlfAE/F47KgNFEPMUL47TqPED2h8GuoT/OvTSL3Q6zsf/X1+Oir+gdgXtrjwg97EiKqOpNk9lCNZt1za/bGRH6hTOdqwjoFqK1PxB4BQP6H8pKTOnRvJNPhqlQdt3jv3aFTu68N6iGFbFSQ6RjBCfI5hZOhJAviW4UHrY7+XRB4/MA1o1XwJgTytszSZVtC8/iOqUjWi8aUpIhRpw+gwwA7gftujkQO/YhT58V4dWPHCiWsNgP22CNAtMA14EVeUyRZt/0j/yM9ye/Sofz02PUl4Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oWic5r/uY4GNDLvn/cXWGegwvbClQwzTywLe77NBz08=;
 b=IIeAbQzMPtESIdoVNo3u9QZNr7kRfJNJHJhnfX/EzofQ+1u/oxF2D47pXMb52D+/0jZs3/V3P58a4mv6A01wGkkitoDtgkiis5I30bo7QRxy2mN6DhmJxIji/Ozzm34O8O4LehMBJaBYUHN0YDZcLbz+uQ4Zg5s/3eQCBI1DBa2lwfQdjLBqZouRAeb8o+bLAaxH8gbT80DRhvz1+T022aKOXg5pJWK0cZIs6Mr37E+0O0a04W20pT81EWa8zO1j83VdjYXo9kRCs9eWiQSbPhR6UvageTtjL/03cRlbJRuAJEQeIibtFMOnHxyXNv8BCkiXaTBb7M2eSmkh6sHrUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWic5r/uY4GNDLvn/cXWGegwvbClQwzTywLe77NBz08=;
 b=0w3k9DjEg6juptFBkSlMZR08wgrjX6YqWnNGVC/cMJ1SuA0tFHsAUYBWjyL5BySOT64oTT0zKPTIYXpQz/u/coCDmZFunSlzTA213RefFJMFl1cNLW+xrcbaZolrdJ6SH9HxoqiPswOidYLiGhn1oPop029mkacldMfNGz/xj6U0hrMgwfBpHr51cSjIkLJcmzZj8wDvqZMV84ygbqRmozV+OJobnItfGjm8V8ITPRoRMLzvuhLQxXmhRXeLNtSAkjAmyoVJZdf3HorVqHRhPMRXBqQJjFOdlztpXEG9yqpT0i38r2MSyp9w6o+hSWmVGvBHUAFFRXW5aJxR1MxYbg==
Received: from SJ0PR03CA0354.namprd03.prod.outlook.com (2603:10b6:a03:39c::29)
 by SA5PR04MB9915.namprd04.prod.outlook.com (2603:10b6:806:4d6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Thu, 17 Sep
 2026 22:59:32 +0000
Received: from SJ1PEPF000026CA.namprd04.prod.outlook.com
 (2603:10b6:a03:39c:cafe::32) by SJ0PR03CA0354.outlook.office365.com
 (2603:10b6:a03:39c::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Thu,
 17 Sep 2026 22:59:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 SJ1PEPF000026CA.mail.protection.outlook.com (10.167.244.107) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8
 via Frontend Transport; Thu, 17 Sep 2026 22:59:31 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTP id AC28C180174C;
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
Subject: [PATCH v5 01/19] dt-bindings: crypto: add Rambus CryptoManager Hub
Date: Thu, 17 Sep 2026 15:59:10 -0700
Message-ID: <20260917225929.2494111-2-aousherovitch@rambus.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260917225929.2494111-1-aousherovitch@rambus.com>
References: <20260917225929.2494111-1-aousherovitch@rambus.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026CA:EE_|SA5PR04MB9915:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 4af533a3-d748-459e-2827-08df150f55d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|376014|7416014|82310400026|10067099003|3023799007|11063799006|6133799003|56012099006|921020|13003099007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Jat0p+NpCRzMdkCjVNxLK+x85aVjDctb7n8AHpzI49KAD1c4egz3ICqxUyF3KbmYiMg8gZAeLUoh7BF0b3Jl9SUjJHl/yjc9TpdJL4UQ+zZeTJJ+mibInLBUp5j0rjRdlrAx/KEmKdm25ByOlV+6dUP1ErE+oWO9FuvPRADTdeecf/Tpd7edmXXmHoSt+I1cMy4lPhDfYPaAVoBPt3MfJRK+G4RxZKpZVdEvuZV5OifksAqKkvvm02TU0XFFJBt2m/nEXfM5aiZcmbg0VOLfwPAyKgHzLni0lqPsDzpL08eHVR+eZr7cGfFlqS+C2zw4OnpfJBIlCC2w48ipjavik637iUDnpSE21SQRC9Piy04u+d8ssZbjG1Sba0aeE65sy3+G1sTQf7mIdJ46tz4LoX7NRWEzBX5Ubns2NVOfd9AUiwyrXwrF0csPw+QeIK4eqzv4xPbX3/fE3nnLIhTEMI9Coauhtw6hf5srk9YoFKZQrAsiZ9jiXR5R9eNNuvpwzTA0cdiwLIpl43yJB5wJrVjatbwVtcSyoc7k/8Do/fesgkFH7AU+nP146EI9GWSM3IqFO96rXavGiHM0gc9Hn9tJtMWveDvvq0Ym2GTXUHGA50wRMSGcnfvW6mLu64Iy5pUShkdjRKLgxUKIcvtb1kxI3QtsvWL4RtbZ3zE1Y1Yq7lm3LcWGIZMSlPZatZ8U
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(376014)(7416014)(82310400026)(10067099003)(3023799007)(11063799006)(6133799003)(56012099006)(921020)(13003099007)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jk0xWmwaFE2Ek7/w4QrITOxybJ2q2rqihYlaggrGeNN8y9DVh2QwzOqbc1pj85TSHYLnzhj+psVp2Jnz7w/5zwUP03mMVsYQFTRpHBJUBKCunTzhRc5wda0GiaruW1OnAlUdsTayLMvpGf88GORb1tB7klSO2zMf5YAqgUCR6iXWe7jeAorwdXiiwzZ8jCTtLcidCj1Kfk3Hz9RoI+DitEy/NN1LOc5glpUIIWsJDz40mO+n2rhYOmLixYCCcEXt6jLhN8/wb5rwEUX2kkQoNL913XdD288zx9+VbQJMIpldRlDUQQ6bRI+Y2BpZY060aSH/XOiHQyofKhzfh6WSaMFgG3tMBI0UaDaNh1VaQxAxvFkvdaxuqeENjKyOAcpJj7In9ZFAVmgqvWdRNo6iJhk/YdSOlprfvcIuGpYl3dTP3PVqekwvALeu+bNSsc9A
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 22:59:31.8171
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4af533a3-d748-459e-2827-08df150f55d5
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026CA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PR04MB9915

Add device tree binding schema for the Rambus CryptoManager Hub (CMH)
hardware crypto accelerator.  The binding describes the parent
SoC-level node with its SIC register region and one queue@N child
node per mailbox the host owns, each carrying a reg (mailbox instance
index), an optional interrupt, VCQ ring geometry (rambus,num-slots /
rambus,slot-stride-bytes) and a rambus,cores affinity list.  Which
crypto cores are present is discovered from the SIC CORE_ENABLE
register at probe, not described in the device tree.

Register the 'rambus' vendor prefix for Rambus Inc.

Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
---
 .../bindings/crypto/rambus,cmh-v1030.yaml     | 151 ++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
 2 files changed, 153 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml

diff --git a/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml b/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
new file mode 100644
index 000000000000..a0df35bdc371
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
@@ -0,0 +1,151 @@
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
+  tree.  Clock and reset are owned by the management host; a node
+  describing a non-management host has no clock or reset provider of its
+  own, so clocks and reset-gpios are optional.
+
+  CMH gates access to a locked mailbox by a hardware HOST ID presented on
+  the bus with every access, permitting only the owning host's ID.  An
+  integration must present a single, stable HOST ID for all accesses to a
+  given mailbox, independent of the issuing CPU (relevant on SMP hosts
+  whose interconnect encodes the issuing CPU in the HOST ID).
+
+properties:
+  compatible:
+    items:
+      - not: {}
+        description: SoC-specific compatible, e.g. vendor,soc-cmh
+      - const: rambus,cmh-v1030
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
+      The "core" functional clock, and optionally the half-rate "core-div2"
+      clock (present only on configurations with side-channel-protected
+      cores) and/or the "rt" real-time tick clock.  See clock-names for the
+      valid combinations.
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
+        $ref: /schemas/types.yaml#/definitions/string-array
+        items:
+          enum: [hc, aes, sm4, sm3, hcq, qse, pke, ccp]
+        description: |
+          Core-affinity list: the crypto cores whose work is dispatched to
+          this mailbox.  A core may appear on at most one mailbox.  Cores
+          not listed on any mailbox are load-balanced across all mailboxes.
+          Optional (default: none -- the mailbox only serves the
+          load-balanced pool).
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
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index ba2002969373..364e53c31045 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1397,6 +1397,8 @@ patternProperties:
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

