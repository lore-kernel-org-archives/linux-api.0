Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11023102.outbound.protection.outlook.com [40.93.196.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B6A37DE9D;
	Thu, 27 Aug 2026 01:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787794781; cv=fail; b=Mr3cwyBOfC0qNfIeIR90lI6vrq3mMWZLaTKS3kOxwkblZX6f2yObbrlscS3RSbJ8IMXwA+LNJd868L/w/qyTpZw17efLwGSATJ03/g63H1TfqfqT7KTQ8xMqNwAxZX8yBszaNy9YgERdcw0jwe+5enHXbdJDBLX2J0yiFucKRKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787794781; c=relaxed/simple;
	bh=mYfS2nE/M+SUeWjoUsDytITbCI52hGyeIEZd3Jo3noQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=md0VDS+WmHCkBvBmXMWYkq53baolix70Y7JafqsDQOokcZFeHp4gl5RZCtA8Itu8JuKn15QgyK82h4sUqGowXNoTEcJ658FEtQPb0IPuJaO/uN4DSLMxhwNSCyOf/aHHHPZtiLntS+Ns2Z7lczvRCh88LcNKKmf8FTJXPHmBuOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=SNWX87za; arc=fail smtp.client-ip=40.93.196.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="SNWX87za"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hbccSSNepk+BWXk9A6Y3KDchkYaB4ErSeVntLNuEPThbuDL02XEGAsGe/YdjjkEtpPvTp5tvxRYtCrrTxsSPVBLru5qyEeFEK9y/w8PJaxDQNISYPGHoz8fye8WjRCfmbtdDMM4GDv9U/9qV5XrHjfpJ3Mnx4pcGfsJb04uHRbgs/In/ab3OLXsPta5L1xi80mhPbRUcTwF/uFc1OaTfiX59xNz1kxo/evkCaWBvhc0Ivb/PkXvT4ILloxtBe7eJI3PepETPEeyvOuoMGaypALT9TrzVXb8JnAZ0ugsTg87MNfaBIoyMniiH8hRDY6k9IFmtkwfdE6sSTWSoE2qfQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BVTiGxzYlNQWq6/ZJYHk9v5r1py2KJW8WpZdrs6dX5U=;
 b=zRnrQYrAszzYOCjhV6j1QZLixvQdYDRG2nQ0uhM1Z7uOmSME0fEG4anYR0zclS6jzHRIl8ZiNKharIg8AuCIfLOO6DIfnc5QIJaAcVOcFrJBb/Msky9Bmf5mdmPHNPRfcfaApVVKRk7kpiDbHoCEoR7spsenLvBZeiBTuT4i+BY43YV1Vne3PtuV1DsSu4NqNBJC3rxG+3B5LJLZn8huf4Fsu8YsSajRSrruo1T4uqPLIIN/kIRVBfyqfB7Qo+kVfHFQGeko/AHpZwFoYe37QizGMDWrpgskAhskTcVrmhSfnEor0eNP+pPqrLGrMkF1FVusWN/tLoF31k6ZeniOHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=rambus.com; dmarc=pass action=none header.from=rambus.com;
 dkim=pass header.d=rambus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVTiGxzYlNQWq6/ZJYHk9v5r1py2KJW8WpZdrs6dX5U=;
 b=SNWX87za0eeVp/2iFgyGEy9SW6odGVSeQE6Y2qI14xC/MLk0XcwCI8oncUHUaP21V5vJXSWqDMpqEb33kIz+YaUn2jPgJLoUfsPOF2/HB1LxbNBvxeaUzEmJnAa7ybAqu6LJ3V9W/MYRYcizWS8cv/JyTHeECvGuA1cGCydlp8kadvmwa4FMqBsLBgHduRAxHnW9wmS1BXa3Xq0sDmu8ycYvmBd8wCCwcWp4zNGp8ReaA4HCTERIuXi1HgVgv9WF9RtHIU1nzGR66reWTx/ddp/z3Yy7VZ4jT4VrBmHi606ZudtyIYxCt3czIOktwQ3OajqvGmOSopwo2ay6MCbg0Q==
Received: from SA3PR04MB9001.namprd04.prod.outlook.com (2603:10b6:806:398::17)
 by MW4PR04MB7362.namprd04.prod.outlook.com (2603:10b6:303:7d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Thu, 27 Aug
 2026 01:39:35 +0000
Received: from SA3PR04MB9001.namprd04.prod.outlook.com
 ([fe80::3da3:45d7:8860:e196]) by SA3PR04MB9001.namprd04.prod.outlook.com
 ([fe80::3da3:45d7:8860:e196%4]) with mapi id 15.21.0360.008; Thu, 27 Aug 2026
 01:39:35 +0000
From: "Ousherovitch, Alex" <aousherovitch@rambus.com>
To: Conor Dooley <conor@kernel.org>
CC: Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>, Herbert Xu
	<herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul
 Walmsley <pjw@kernel.org>, Rob Herring <robh@kernel.org>, "Krishnamoorthy,
 Saravanakrishnan" <skrishnamoorthy@rambus.com>, Shuah Khan
	<shuah@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "Wittenauer, Joel"
	<Joel.Wittenauer@cryptography.com>, "linux-api@vger.kernel.org"
	<linux-api@vger.kernel.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, Shuah Khan <skhan@linuxfoundation.org>,
	"Nguyen, Thi" <thin@rambus.com>
Subject: RE: [PATCH v4 01/19] dt-bindings: crypto: add Rambus CryptoManager
 Hub
Thread-Topic: [PATCH v4 01/19] dt-bindings: crypto: add Rambus CryptoManager
 Hub
Thread-Index: AQHdNN9i2B1OC8UL1keFfzcIplhRvbawj4wAgACQXVA=
Date: Thu, 27 Aug 2026 01:39:35 +0000
Message-ID:
 <SA3PR04MB9001B48FBE7B7C3EB81C5338D7AD2@SA3PR04MB9001.namprd04.prod.outlook.com>
References: <20260825221539.255951-1-aousherovitch@rambus.com>
 <20260825221539.255951-2-aousherovitch@rambus.com>
 <20260826-unwritten-marshland-47cdf3c17cad@spud>
In-Reply-To: <20260826-unwritten-marshland-47cdf3c17cad@spud>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-version: 11.11.2.117
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=rambus.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR04MB9001:EE_|MW4PR04MB7362:EE_
x-ms-office365-filtering-correlation-id: 3fea77f4-f49a-43fd-c054-08df03dc0ce6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|10067099003|56012099006|4143699003|6133799003|11063799006|5023799004|3023799007|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 9mVAzxR17869f0SZxTyWxmvA6PppKY+mG9kR01yHN+L8hEclMAAyY28f+Ete95ZRC51DK0Lw6pOfdiAp2khmUVBvOfsm1knsIUkq0GgGB6eKn53EuuPc1ee2fPujANkhsPKPHAdm851wmlyshJnBrUFHOYZeliXt3V6NPnaHbwSaRzKLMT987JAMSTAbHlpola8t21ks22On1W3Fez0FYN168n1yI1nzvHcAVIMdLWZVldnlCSPvnasybAZnV5SJITCazxu69UyTTGhaBJYj/syZJ/njXTPG9QSUI1ZCmJkpB7LgGk3Al21uantE4130KP565o33xZgRKJhjJrsWJ033gf49JtVC+a7kqltKiZKMwOA4djRdnDX6lCQYLDeOFDmm0ZBXXUHSghpxvBO0BWeuuxjBnvAjGxmtCpJIFWldT5F/XIo5k70LLHGPFL3lLmwO2uwUM8G+tooywV6rzobQA1k9MwdnrdJZBHPDYi/HArV5cxY6mii6p8TYynFIzcJdYU2k7BQ0wz+cjtAOEFbL2ViRvee8w5G9+2D6hIXV4F0Uuo+FW1G4G11hftmtzVP/DCQHTMfqcl8sv19/IdAmCBR7pSFzM67ditf3/x16ayI+SXWCB1Az/WsAu0qWeLOqPDLGb5fNAWKge1vI6vbweAptA7T5f+J2dsPlo6jtOf875eLFaC+jxirAfVYbRHiRbmJZT/upEunv370o6KFjykrcwi1D5bDoPZRW/jQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR04MB9001.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(10067099003)(56012099006)(4143699003)(6133799003)(11063799006)(5023799004)(3023799007)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?qvYqd/e48d+O+liLZdE1jpIPF0ZDA0ltFxLM2FGt15KcRBuIN15ophOS2GF3?=
 =?us-ascii?Q?X5s0qLotMgmE/5XjKcIbY/UIFVDe/Kk5ZeHpouB6Qd9sib1GaKxfZ+rlFfwO?=
 =?us-ascii?Q?vaDvIfm9BEke7DqMnN7pn+huoj6JdLWGc8hzshQCV1OFFgKpiF/C0zcDVQ4k?=
 =?us-ascii?Q?vWwNVx/she0wCmDTx2xiG5iQOETM/9gpBu00YrtYEU8qvjbv4UM6hGazGmpS?=
 =?us-ascii?Q?b0vUV8IgR9IkRv0zzPmWpnnweEspqa49tKA6CGlDLPZAvEjzegUa455bM4KQ?=
 =?us-ascii?Q?JxOvDGL13N2zniAh8pXt0KRcyl4mKwSotEvg0M6OFpCq/lgV0nXpsVeV58q+?=
 =?us-ascii?Q?APgo9WlPhWMguyyPb2GWO9jQwg4M97UknPeGVwcff5SXSTranBhU58/tLOmW?=
 =?us-ascii?Q?hEh2ewI3spFcoAJ4PTgc3w22sXmC8VhaES3KEnK/Y78zdu2U1Rvb45ytwge2?=
 =?us-ascii?Q?CCrclraxrRWZ9hlyORJya8XCPBJmAPUHom4hbawFNMFzZDN7ztaegPmsPTS/?=
 =?us-ascii?Q?OGOJMS/hPl67o4arpcxn/Ud8EmkyjS/+SVo/l3GDWyyDtgD8WOta5FgTNElt?=
 =?us-ascii?Q?ZutuFB1t1NIcjZaUI+QmkjoNZ1XGpC80F9swEWdOQ1D+v/B+XxhWOAsuEsFO?=
 =?us-ascii?Q?uesQ4/ELYWSjS2MnQeSm6EhvPIxDL3f1RUp8qOQJHsAcmzqX/yx54ha9I7lp?=
 =?us-ascii?Q?iPq9/nX0duET8l+zePX810DYzcnKdT7nFcfyTkXBbcvW0GS7tLyY4/wxvEhU?=
 =?us-ascii?Q?eW38VtxCvLZ2UU+sAi/xT48dlk/hv4nX7DNU5OWbaUIm1GdCBgC5iPH48ArO?=
 =?us-ascii?Q?b4p7XcNvLGR9Ff+EAyV/xfeFrRP8IcHmvM94tgLbgxSTsc+XSSYuzkRJI4/y?=
 =?us-ascii?Q?VIFCNvVCf2zuJKNzsDURVep0yqmem9lc9kX+EIo5M7riR6UPu5SiI5b+B0h+?=
 =?us-ascii?Q?86YW6mRX9iQ1No2GgXwnuqYE9xJRVxkbYycY6ZYmx6/geSg18Nh5PjHKkHJP?=
 =?us-ascii?Q?5zmJAYHlpD6+MJnFw8ZUUjKy6Si/JwQLIk2FWux9zuHGsT4x4JyveqKoIkc0?=
 =?us-ascii?Q?giW2+qfTE61qFOECsw3+FD7mUdJNbxaRG6qebmgt82uLV7ODyMxTYz9qRCbL?=
 =?us-ascii?Q?jizFs3feyVSuoruZtmNVeju/SN9TxMH9sdDnhOXWbe7wGnaN2YrUa7fMsXnZ?=
 =?us-ascii?Q?gc6xviwz7a1s8dKyqEDNlYa42NgiO0hrnaxdrPvmj5yY83v1G0HEW3+KoBSX?=
 =?us-ascii?Q?2ASU3SfWnnJoVD0wqgVbm1zr+o3FyfRdkRhSo2F/jGec316ZP7MCgHNXHCpn?=
 =?us-ascii?Q?U+hJTduIHFgnTpWZAjw0qGxX24MANY0rTWYTE00DL+jQHhQDBzWOP+PTgWMD?=
 =?us-ascii?Q?QOzPiwNN3cRKuE0hJyiPX1YX0Y16f2KRPYRFWdjQyOhiQeEK5Ei0C5J5uDsJ?=
 =?us-ascii?Q?GFdHUPJVW+Wew330Hbon5kLzTBeQfaOmGVzMURQ5wkMphIVT7f8kMLg1XlQ9?=
 =?us-ascii?Q?vPld7a4PIppGqPI5n00izb51aOUvo+R+b2+X8rrN21AOuBxLMSFlrtyrRrWv?=
 =?us-ascii?Q?ynsliM+CUfU0gcQhKHrICFgK2JxdNWuNhUJr8OfPknzKgFqnxfk2vhvUpb7W?=
 =?us-ascii?Q?KQgYl8z+KUw/BUKRtQroAUwiiZjpLmdaxTeANpYmTAEjqDqsuQncLu5t69Ix?=
 =?us-ascii?Q?3/sCK4E8tFBcooPUV0lGKlIcK4HfisjwqcgRnJLnJBzsKOz19me7QxzG2NTH?=
 =?us-ascii?Q?OJA/iC3c5g=3D=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: SA3PR04MB9001.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fea77f4-f49a-43fd-c054-08df03dc0ce6
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2026 01:39:35.3798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8tYt1OmGwIEtn+qheYJR5nr0U8yX1fTsmUygluFGmUUNycjjJ1iTbv6m3msnobqaaXgQEOxs1/SStTqKP1Xo976YyU7E8Kj0oFdEAGd9NYU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7362

On Wed, Aug 26, 2026 at 06:02:16PM +0100, Conor Dooley wrote:
> On Tue, Aug 25, 2026 at 03:15:20PM -0700, Alex Ousherovitch wrote:
> > +      command ABI).  A specific SoC integration should list its own
> > +      "<vendor>,<soc>-cmh" compatible first with "rambus,cmh-v1030" as=
 a
> > +      fallback; that extended form will be added when such a platform =
is
> > +      upstreamed.
>
> This commentary should just not be here.
> Instead, do what's been done in sifive,clint.yaml for the clint2.

Will do -- I'll drop the prose and model the compatible on sifive,clint2
so the schema itself requires an SoC-specific compatible ahead of the IP
fallback:

    compatible:
      items:
        - {}
        - const: rambus,cmh-v1030

Since that makes the two-item form the only valid one, I'll also move the
binding example (and our test DTs) to it, using a placeholder SoC-specific
compatible under the now-registered rambus prefix, e.g.

    compatible =3D "rambus,<soc>-cmh", "rambus,cmh-v1030";

and swap in the real "<vendor>,<soc>-cmh" string once the first integrating
platform is upstreamed.

> > +      rambus,cores:
> > +        $ref: /schemas/types.yaml#/definitions/uint32-array
> > +        items:
> > +          enum: [0x02, 0x03, 0x04, 0x05, 0x08, 0x09, 0x0a, 0x18]
> [...]
>
> You could just make this a string array, and then you'd not need this
> mapping of unintelligible hex values. Of course then your driver has to
> do it, but I'd rather see understandable (and portable, since a new
> revision could change the IDs) values in DT.

Agreed, that's clearly better.  The next revision makes rambus,cores a
string array and maps the names to core IDs in the driver, so the
numbering can change across IP revisions without touching the DT:

    rambus,cores:
      $ref: /schemas/types.yaml#/definitions/string-array
      items:
        enum: [hc, aes, sm4, sm3, hcq, qse, pke, ccp]

(keeping the affinity semantics in the description -- a core appears on at
most one queue, unlisted cores are load-balanced -- just without the hex
table.)

> > +required:
> > +  - compatible
> > +  - reg
> > +  - "#address-cells"
> > +  - "#size-cells"
>
> Surely clocks are also mandatory?

They can't be mandatory for this binding -- there may be no clock provider
for the node to reference:

- CMH is shared between hosts.  The SIC presents up to four host
   interfaces; a designated management host owns the privileged
   configuration (clock, reset and power) while the other hosts are
   granted only a subset of mailboxes.  A node describing a non-management
   host therefore has no clock/reset provider to point at -- those lines
   are driven by the management host or an SoC power controller.

- Even where a provider exists, only the main "core" clock is always
   fitted; "core-div2" is present only on builds that include the
   side-channel-protected slow cores, and "rt" is the real-time tick,
   which is why clock-names is a oneOf of subsets rather than a fixed
   list.

So I'd keep clocks (and reset-gpios) optional.  I can add a one-line,
hardware-framed note to the description if you'd like that rationale on
record.

Thanks,
Alex
