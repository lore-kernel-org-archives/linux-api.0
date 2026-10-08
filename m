Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020104.outbound.protection.outlook.com [52.101.56.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9FD36E48C;
	Thu,  8 Oct 2026 18:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791483610; cv=fail; b=m3JYm97U0IgJV/5z6vl6qesBvMhFEIZBu2T1Xd19VPPQvqEk3M1Jy2Yf4CXUmJWU62QA+R/UeYpyz3UAcGUozmF26iAn8SfxKRSs9XL+Alz1WEN+GSyBPSfmcxbgbyqwRr8OiSSJ7VyttpgsKEAchCZpi/9y2jzxfwJNswpJQTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791483610; c=relaxed/simple;
	bh=vfOa0WoP3ohJy3yx+7k0uueQcsBb4QvOks71QoKW2KE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UH82qNlDJO0IhiEWq8Emj+USWkU6y/Li7Pv4yJDJStmUHNGtBv88or7P0ze7O4iDFKvFKO6CToT66whY8aEW/APnSLJsTaGyQdI8JWZx83/24R2XZ2m8SdoaxG82xp6IBbJ90ff133Wh+NDat5N6pJD0bsmwfKAqePE6tO/Vs+k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=Q5xoA++N; arc=fail smtp.client-ip=52.101.56.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="Q5xoA++N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EMUGRBIE4ozThttg/kgf5Cshkn/01B81vD5pcWl1fEh61nRLKj4jVgaPoUgtHLeOPuBtHgpD0bF0M11ALQe4gu/o39FlEr8a7TMyvFBAmMn46Vz0K0LMPZI9dylMEOyats46AaG+3VCZ+PpPs8W7oaeop8o91ENr+RnkDdjd/QvCfl18JTVrbcmPG26Wkj1L5X1+DVHi9/8VtNcyUDGTjcN0vaVjSqezFNVeFpFutxBAnvzOAdkIIXuZRvlIDMpf/2xwYea9DPaCHjeeQoVJIDLWN8J/oRnkD0ztPr4qTr0v5sYj8EYC1vr8xvBS4/WO1icVgmfAmDuNjWpmxHsD5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ssCbM4lze5TdRVBfa0tj1p3TCgY7ESwxHbfD+3f9jqg=;
 b=qtKDOtimhOEvWt0cLxRN6otqqAzNquKunw8hdUb1nkRjisMr6IqQa4uDWQxarbVUbamBkZw0CCodin7II6fkQgPeO5K5lLD52kTFT3AkWG+Yi+UCIgkly73x+ChXZARkF0w8XOJSFNCNoQMBWA/DTcnmLfBTD3syIMWxgsJYWpugJKBYK0wc36BR8A5vqabt2Hyy+Oqb9K3ArMiTiF9/EkbnhR282HOQU75z1SUZzc+4TR89b20q/qlrqEODr8+dU6TRdq5ReAamra8xj1tgPkDjAyXqwtZCNOwUqIA94009xDCVFdzk2SqqvVlC9retlaiEOav2TT/8lUlbzjy83g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=rambus.com; dmarc=pass action=none header.from=rambus.com;
 dkim=pass header.d=rambus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssCbM4lze5TdRVBfa0tj1p3TCgY7ESwxHbfD+3f9jqg=;
 b=Q5xoA++NxQz6h80+WChnqQOdcGlsmxsrEqAOdJcf86Sx/lvwUqkcFsi76s3KmdjMhHQv32quCZpuFUP0UMTb/PAxZQTCNK0fm8xYWda3dqLo813/UjaH+qGFS9OlXKtuQ9SvGdAn7AG1RmpoAfScB35pVRXCLsGDKxaCbFtWr9aekPZi1sViAUlEv14Vsvv7jjjsAM5B7eE1XkDDZPc5tWniik1KrArpsBKz5utRLIPyINbTWW4DXOkop0Gv4oH3mzKXGicYGFTn4rClPcRVChloyIZVhxESGKbxcrxMzV63gxnNXaQx2JF1soj/8uGB3k3XPyADp+aa212sPgBwWQ==
Received: from SJ0PR04MB8406.namprd04.prod.outlook.com (2603:10b6:a03:3d3::14)
 by CH3PR04MB8902.namprd04.prod.outlook.com (2603:10b6:610:17a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Thu, 8 Oct
 2026 18:19:53 +0000
Received: from SJ0PR04MB8406.namprd04.prod.outlook.com
 ([fe80::cbad:dfcc:82:7dbf]) by SJ0PR04MB8406.namprd04.prod.outlook.com
 ([fe80::cbad:dfcc:82:7dbf%6]) with mapi id 15.21.0496.015; Thu, 8 Oct 2026
 18:19:53 +0000
From: "Ousherovitch, Alex" <aousherovitch@rambus.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>, Jonathan Corbet <corbet@lwn.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Palmer Dabbelt
	<palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, Rob Herring
	<robh@kernel.org>, "Krishnamoorthy, Saravanakrishnan"
	<skrishnamoorthy@rambus.com>, Shuah Khan <shuah@kernel.org>, Alexandre Ghiti
	<alex@ghiti.fr>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"Wittenauer, Joel" <Joel.Wittenauer@cryptography.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, Shuah
 Khan <skhan@linuxfoundation.org>, "Nguyen, Thi" <thin@rambus.com>
Subject: RE: [PATCH v5 04/19] crypto: cmh - add SHA-2/SHA-3/SHAKE ahash
Thread-Topic: [PATCH v5 04/19] crypto: cmh - add SHA-2/SHA-3/SHAKE ahash
Thread-Index:
 AQHdRvg30t1+45dAjEm+KmT5OENVbLbbsCeAgAD8JwCABtcDgIALxW1QgAQlDwCAAKYC4A==
Date: Thu, 8 Oct 2026 18:19:53 +0000
Message-ID:
 <SJ0PR04MB8406F204459FE399C89BC5DFD7932@SJ0PR04MB8406.namprd04.prod.outlook.com>
References: <20260917225929.2494111-1-aousherovitch@rambus.com>
 <20260917225929.2494111-5-aousherovitch@rambus.com>
 <arNn_fjy4jamSitO@gondor.apana.org.au>
 <LV8PR04MB9006374FD8621EBF3C7E7F6CD7822@LV8PR04MB9006.namprd04.prod.outlook.com>
 <arn4XYwPYt6i2k7d@gondor.apana.org.au>
 <SJ0PR04MB8406AD1C92438FBCBA2EEED4D7962@SJ0PR04MB8406.namprd04.prod.outlook.com>
 <asdSSjBML72-YaGq@gondor.apana.org.au>
In-Reply-To: <asdSSjBML72-YaGq@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-version: 11.14.0.414
dlp-reaction: no-action
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=rambus.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR04MB8406:EE_|CH3PR04MB8902:EE_
x-ms-office365-filtering-correlation-id: 5146bbbd-4f09-4a4f-14ed-08df2568bfb8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|38070700021|5023799004|4143699003|11063799006|10067099003|56012099006|18002099003|22082099003;
x-microsoft-antispam-message-info:
 eI4krPpkxanR297Kb7p+Qo+mA35CeL1baB9lJ+kdL7gxShPGs6PQrYSrK6gDCbsCl7LlflbYBCXadX10Us0GgZVxVneZHrJVYDwcsm+ysa6A1mKDpFTdmgZWkhfhZyZDSLvLlE8EcAcS7SHqAlHvRIr9PkV9xA3sBgnbCfw5AqsU7x0DnGX9zU6qjzZ7hvhsn2hfi7gGWZrOvIKKRLZQ3LaNP5WMua39PgMKLIhWHmf1DqF4KNW6GPwnYVh/WS4w/MICeRHk0D/nq3Apv9OurjiGyswT7mawGgYwzNu4igfbJoy6kz0AGMqxFO2rGfGUU4rl8EmvNNubKeX87DIuBcLIO2iotw4eTjqdfThm33cHMdovBJ2OjcBM1ZVKy+vBriIQbgee6oJYz3HAZeyD0Ode8ZB43SEqk2TWRS2RJd2pxzAIwkF/0aAgpbO84nUpkDMol850CwY8NKQB08nrlq7yWgDwk6JTanVvxaqmQFezM4WiI1GsJK5RTMVUG66naCQUhdY28+R0kIjRmfpREE8NyVyOHKdF+Xe3FPprIl8krQkSgV726WFYWMVGDjPKS/3QM/Suj+Q9BLEZOKDd5Ve7jqAQUuhnPi2rwOntGMSB95kWO1lnEx8I4oBlXeBUJnS3hhQ4czUBpS4+rDi8WOZ0ult2EchyRP5Jpm2rPUYNak+NW4vFSIwqmqypn+TT6Ax9aivohvRzbxDw8YRuMDRb5dnaZz9bQtKxy8DZbJE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB8406.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(38070700021)(5023799004)(4143699003)(11063799006)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?18cAvaDIcOi9Tep2oa6nqTeeypMQiV5mkOTAL80thdJ5/wAueYUIirQ0RP/T?=
 =?us-ascii?Q?itEihVsrz6dJhdIrIgL2lmtNrDZOxqYDh7Nt4EELaAafQZGTT2/hUY1s0n/t?=
 =?us-ascii?Q?eTbWEcErjJzPnf62TFPmW/sYilv5BGTPkNZHIuvzsi8IZriCHT0ESbVHO4HJ?=
 =?us-ascii?Q?cjuQm5Ra1cA74qCn/Y607h4eWUtl3r+LLtMz1BG45h5U4wcOpb92oA9wlVME?=
 =?us-ascii?Q?easVRw00kBYJvIhWwKGEl6X3uCQh/3tK5Tx0efi2h+4bOVwpr1QLLirRoAHn?=
 =?us-ascii?Q?sfOiFpD81Dkdk8eRMr7K7HcJGYcvTYtEAqhT+O2Ah0LdhAFTuuzLkUBtHivj?=
 =?us-ascii?Q?UvyqD2qzwhrkQ4p/HsyyTW3Bz+RCqeyTTR9abUZ7X08E+sDFln+kBMEH9tZ9?=
 =?us-ascii?Q?QEkdg9wEtlvc7LgIHouQ/D1ChsscnP6HkTaa5+IGwCHKuMky8mzq3cyvbATS?=
 =?us-ascii?Q?nR7NMHOqBMDcUiqoOQY0k9hy3BjXurZ6+Za6r4wGfibV7Nxr/FI2M//GrtKE?=
 =?us-ascii?Q?iDXmYQCXLWCw5H+SqF2mnVSW7tAPh2AWj/H++2MJsdJDKDncm/bkTOsG3WWV?=
 =?us-ascii?Q?HqkuuYcmfYlpN0J37tGm3CzuwMPew8GhYI1iuboQQw52Ni9eILQ9i3ymfPw9?=
 =?us-ascii?Q?pqZKO4botyEJk9DGXW9ga0UwnXPPYsn7C8jkMniM5rSA/Uut1F+GdweLiMDo?=
 =?us-ascii?Q?d/CBkdt6362R8LjQ2HEm/go4suFA/WaxKKRTPcRcZmtCDFeZa6phNVWTx9wu?=
 =?us-ascii?Q?EkiRvKLaXSk28t+8ezPgQVgUHqH5XYd3cZ/8fCuYLwczHiVBuKn3PBHA4RIT?=
 =?us-ascii?Q?mlnO7X5rUbFwz56GMIB53hdgYsOo3A5hAxN9h0FfPCRyUTn3YZkWomQY+WtN?=
 =?us-ascii?Q?4O3eGoH+P+r/GCkfGPtyOPCkpLHc9iHG1+GuiGlrjeLR79Wo/S4+HyNLJ5ML?=
 =?us-ascii?Q?GKuBdrXVsxMb/Kwg2jZdK5IW8bplDG3CAWb+cg8dlwSDI/KdPQSoSt4RzRFW?=
 =?us-ascii?Q?cT6l8aOVmdyJ9F08cjuiVgJeSdCqvW0ZhKI/Aq4E0oJSNYQ7IYwOYvgKyHlA?=
 =?us-ascii?Q?4ikFSqFsD+BPNRF1Ye+yKhLnF5Rs3RJkGKH3KPjpXvE2PrmqZxwDO7ocsWb5?=
 =?us-ascii?Q?AJGZwUEiGWhVZrnGL2RjRXG5se8rHCwny8/WFusi4Vmrds7pr0pC2CAtXUL6?=
 =?us-ascii?Q?bUZmWz1xO+tW5Je2kaNAVuw4V/BmtCi4uK0yRxwDNAvJQMZCBqx1RNV8YGw4?=
 =?us-ascii?Q?eW4x5RQ1Uet+WyDz9yGUjSL+7MZYjBmAtLNcW7FVg//IykhhXdSBihYIjN4w?=
 =?us-ascii?Q?XY2vlJpybsAGYha7TJFqRcEU/WUPElbZYaCjlfSbsCYXJzrxtF9wsfS9qoJX?=
 =?us-ascii?Q?MsfCJb4l2imE/kVWRY/9nfXpCQDINdVNVHYjFu9KW7eQiTp4sexqWzusWufx?=
 =?us-ascii?Q?B8X93GzH+p9+2dfnpJxeXy7baZX7LAK9L8svL3FJqnvbdOqDGVMbgIKX7IRx?=
 =?us-ascii?Q?2o57r4rLvIklMeQscWZSrxuUAKW3BtiTB2d5weBrRhwR7DF73lKWyIMozqwt?=
 =?us-ascii?Q?4Dqe3McDzQ20DW+khVGdLYC09inLmkwFUvEMHFANUA8ETo9BV50X23+5/UK+?=
 =?us-ascii?Q?d5b/+c/dQcvWZBoBxuEThnctSQlAlIbheDM+VLABWsPympiOVNMRSqBSfKDh?=
 =?us-ascii?Q?YOCulmdf6fJiZbQ3wsizoWKx5dlXBxUmsxH2S4rHWVDV3blLVAtLraAEPp3q?=
 =?us-ascii?Q?27ljfLsl+Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB8406.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5146bbbd-4f09-4a4f-14ed-08df2568bfb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2026 18:19:53.2616
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1kA4Nv8EoPLAK8r5VuB8uuAOq6VjveHwhkkbLGpue5D31d2uiJ6Jmq6KFX10iUCyo9OlVOAZOG80J+MOTASgGH96NjWBOWqgfpzcXIvGNAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR04MB8902

On Thu, Oct 08, 2026 at 07:20:26PM +1100, Herbert Xu wrote:
> So it sounds like the info is there.  Is it possible to transform
> this to the format that we use?

Not on this device -- there is no canonical state to transcribe.

The working state exists only inside the core, in SCA-masked (two-share)
form; the mask entropy is generated and consumed entirely in hardware
and never leaves it, so software cannot reconstruct the plain chaining
state.  The only snapshot the device offers is a fixed-size opaque
container (a flat word array with a CRC, no portable layout) -- not the
canonical state and not convertible to it.  Keyed modes (HMAC) cannot be
snapshotted at all.

So export()/import() has nothing to transcribe.  v6 therefore does what
you described: for the hashes (SHA-2/SHA-3, SM3) and HMAC the driver
registers with the generic fallback and hardware-accelerates .digest()
only; the incremental and export/import paths use the generic state.
SHAKE/cSHAKE/KMAC and the standalone Poly1305 are dropped per your
earlier note.

> I would appreciate it if you can break the series into smaller
> chunks.  Perhaps add the algorithms which are the least problematic
> first.

Will do -- a few self-contained, bisect-clean series, least problematic
first, each sent once the previous is applied.  Tentatively:

  1. Core: platform driver (probe, DMA, mailbox/VCQ, transaction
     manager) + DT binding + MAINTAINERS; registers no algorithms.
  2. Symmetric: AES, SM4, ChaCha20-Poly1305, and the DRBG hwrng.
  3. Hashes: SHA-2/SHA-3, SM3, HMAC (fallback/digest-only as above).
  4. Asymmetric and post-quantum algorithms and their key-management
     interface.

I'll start with (1); happy to adjust the granularity.

Thanks,
Alex
