Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011007.outbound.protection.outlook.com [40.93.194.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A375D42048E;
	Sat, 17 Oct 2026 20:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792269255; cv=fail; b=Nx49BaLQEe2/L92+8HSYalFLJCVyU1+r2dBZOwkmNhRr33rTOGpssGHEsNvpPHSuzF2o0Fyj7e9RKOhBSPsWHBZDGYyzguQHSVzzWVblS3OY1befy0LXr3N4lCqdsKUIa3Ybv+1C0m65xK2n6MtcByVHzoz9Zhai1QKgWtVTEM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792269255; c=relaxed/simple;
	bh=Jd0VTCsu2HSbso1zJt/VI4y7S+3iSIbyvdBy63K5Wtw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ajm4itJ5q6vdRetYpWwC3EsqbD1TTxW4kfQASEQWMom7so+SuUnP2htRn8faXkmVLajMP6rXkQhKj/UogVRv3YdoGL17NRBORttnyEbfWDXgOKmFuW1Gox/9+9yk1WLKKW7UqJzR+OzD/W94kzNJ8IzzrzzZ3qQAVHFggv66eGc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YV4/cJf4; arc=fail smtp.client-ip=40.93.194.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YV4/cJf4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ra0bMIVTUvdC/3kGqa6Lulx7RPDPF3tAtfopVCOAS/aYu4/vWaZNJU0/Ud4sDyv5Wz3azZ/h9nyFXhkt8tfvCcAf3lE/H2kRzDsqwdO6D0tRzDVWyzVBDZBNLv46oRCskpZuhe7Hfr9NeFzfhOxO2KUzTt/eu1KgyW6b9wXRJYWuNfkAiX4cOdDBwDS/OYHSCHFIgsIrcDuDHvKBjisZGbvXpPWBLQsoFfugOOSbMZe1pNOnJu9PeNUETShZRzUQhntCY2JEOStyOjDTOhfOz2h4iWiG8iXC8PbwzVOPCEIpvAW+RFStwXZpTbWvHcGyTdt1hNilp81UO3cLy5+dsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ihHpfG0tFL1l5Te9I9eIqRqphGa9WyG2yzfDTr3gJJw=;
 b=H4H47pInVg7Uy8aC0hUs20ChPp0n3AyRtWiCQPXwlxjsHa3oCqc1YnXEHu6t/uuyqhRVSmq/KJe7lGsv0QyxJlKwRKBtl7lcL94wM/fo1jwDwIlBCLbuT2UdDmjNrSlty6O7ECXhrdX/HbfOUqKYDRHXzaBYvb19qlC9luExj4QzVObszF5M+kB25ZuYK2FRuTTKXkJ7J+p1rr/4xoZ4Ke0HIdnRIDg064FM8iPl26yB48kDk0lGunTS0i+VnytmiFiaKM6W1oSN2SRnXUdsrevi5pGmlXAzDJDBb458xvzlGyUuHSiAvP5XNMT6/H26LcaRrTRvHEK0ADOzdGGf4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihHpfG0tFL1l5Te9I9eIqRqphGa9WyG2yzfDTr3gJJw=;
 b=YV4/cJf4MPX/NcjO51N4RJvEn0kJrfUF4lx1sM+gWg7ogVfaWSjVnyLoYGaYm8l7A1WAMoAY0l3zoQZR/s+pcXc6uJZOWdhzG2qIZp2JJSgOYeJGQ3WDolqndkrQiClgoXYEZhRjqaD/HHfgLGXdIEyOrhuOCvsahdqVqi/CLfT2X76KVqjzL3f8O/OPpzEZvr98pjznb2mSzjb+4Ma+lKzm0cPfUcTMjezTYrReocNP0kwumjPFr41hHT+tDCwO+MFbPt91CP6pfZyGZOhwCfPTsi2YSP0K9Q3VSyqYC2Lptj0dIFhxSWIwjHEqGz6aCGDdy+HaDPFwbPn9/06uxg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SN7PR12MB6713.namprd12.prod.outlook.com
 (2603:10b6:806:273::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.17; Sat, 17 Oct
 2026 20:34:08 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0522.017; Sat, 17 Oct 2026
 20:34:08 +0000
Date: Sat, 17 Oct 2026 17:34:07 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Dionna Glaze <drdeeglaze@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org,
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com,
	James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com,
	jarkko@kernel.org
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <20261017203407.GM13920@nvidia.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261016234354.GA664420@nvidia.com>
 <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
X-ClientProxiedBy: BL0PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:208:91::32) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|SN7PR12MB6713:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f1fc504-1bc4-43d4-a1e7-08df2c8dfec6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|6133799003|22082099003|10067099003|18002099003|3023799007|4143699003|5023799004|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	F4xVrkRd67xITLVr0BfiQxMFHveaABIFkc/s4D1eEmwRc25CQdgkcekPadtbTS++tzw+Uo6Gq5Gr3G418CUO9P+UN4EZgm7e6SSS09qplDh5MENaAZ4NBRNV+nqVudHe8R9i7+/ruCzLzFGhrdwR5eDVUNElwtmkn4tlyVxvigyxV16TItULPqc3hos8I2OGhVnnRZKBQTe5cs+EvjR6CxuT7AsyZivb310Yqx5GgKbfM9P9QzaQ6fQeGuTMMvCud+K2UTQ+nE9tMUXXufjWSzpVr9LC0Rd5eHNkal1M7TsgSN9IsS+rYEvz/NP9zaLHL3MTKPNopyfGgWGp0AjebXKGlG6bgW/GF+ZAYzrjj8ZLdMiG7Uu3rXreiAZ4kQQ4Q+zVCczP5yB7HCqxj9xtGhNJoniVTtnG48E8Fac6kVvdAi///JsrqaqBRJp/X6QprgTd6ZQ5YFUz4NrsUqD6KOzlLrWjV6trVQKg2Ehoc5GK3LtQwxKDA2kmGxFKy+Cg875KnDrldS2YUWYSFrw3XqD1cRINgDVG49v2oB3nbFZztiipzibSiZLumaXETMZIGCgwyhBns3dxd1hTg28t8NhIWeKQAauC8dqi/j006VdQEuuZYSCF7KdU9J4TTbwJXFGffcL81lSy0eRI3TimkT9QtVtPG0MNRfCyL2jf2H4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(6133799003)(22082099003)(10067099003)(18002099003)(3023799007)(4143699003)(5023799004)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sOxqbYiGrQ1GO3cE2oZ098EEgqOCAqBByrsdJ0bmuRKsuycvDWvBKQrbSNL2?=
 =?us-ascii?Q?Yw7BUkRjbd25n/6IXsZd/kpfDbJt+BXV2bF520PT+KkTaKEiL0SPdRDc9/n1?=
 =?us-ascii?Q?vdsHqQb1Vl+WbPt1lNznCQ0BAhp+6el2didq2prmvPM8WkbPexewV0O/Omor?=
 =?us-ascii?Q?tb2eBzOCiye8xxbZcGzhsX/hrJulLS+Znor1isXxhcdeBbJjN/mV9nJNrLq3?=
 =?us-ascii?Q?RRZIHChmBzYuQrZP1+MlwisVOOTRH/jxfKf4+mG/CP6g8KIeEl5hBPVtB1uF?=
 =?us-ascii?Q?knCH+84eZNy3Yl8cuetp+73bNjAcVjUrCCG9amTZ3IuVI1YZWOyBKO4GHf0G?=
 =?us-ascii?Q?N5Chs87hMeMEV+p1tl6QmOOJIiOlvn2pvZmawkPgYq6o22qKGQ7mufslo0Dw?=
 =?us-ascii?Q?AK5JC0MTA9i3OP8097tdLiwHc/Wwf9TpfkecTipdZ95U2a9VLQIfYMbugT+K?=
 =?us-ascii?Q?T7sQ+sPol/HJZWFik/pO3DvxhAMSUg7+MNXGiepBqbsjxgV26RUwsyaxZw2g?=
 =?us-ascii?Q?4vVcfAm+uKu/UUqrGSzKUTu61KROPZZOegKxm4GsrZ2/ezTpIsgDxKF0bsgo?=
 =?us-ascii?Q?Mu3p3Md3RlQCFgqSm2i8C0GZfQNxX7ZQzlTlOP2EVeuQaEEwBPRdyCt1Dbe8?=
 =?us-ascii?Q?2800SQNiTYOt7tR+9Q/AfPNz1wTe80kBkyWCsm50sTJ9IRrGj+iZUJ56F0dz?=
 =?us-ascii?Q?Y4W+Hw1E58DsyQd/1HpRwNzihY02rjxjhOzSKeiQRfygS0cp6JLxelydQFgm?=
 =?us-ascii?Q?Z2rx+XtxYP1ZLKDO9FGgLTopRoFFChqmEa+aOl0M+B0I3L+Otf2q0eUjRI4v?=
 =?us-ascii?Q?irUGwrwo/4j1ASUVh8HehzwNOILnmWAHHZ28dUCNZsLnKB8FpP5lsgHhCW3w?=
 =?us-ascii?Q?AVVrPWN3/CAWjla+2RQNWspsBrubwd25y4GKnSsayw8ZAvohZ5bZFPpXiUFF?=
 =?us-ascii?Q?KlUGwoZks2j9dTBpRWsqtSD70B1eGl0Je6h88lkJw7QZazbbFToXY/+5Cmka?=
 =?us-ascii?Q?FTJFoBmkCPfx0W1LoaLssLwF2UDOvnlr03LAyUscEYYceeH7PbRlIz3lN7EX?=
 =?us-ascii?Q?QUe7LTlu+otnprqGZnqhnHQwRpgLORVa9ICfKeLq218GZD3OeiPaGBWGsImf?=
 =?us-ascii?Q?XfDLYDcv4V/XlwIPP6zsttUG3BgZ2WsPiF0Ui5GXZ/0Zi9TJ0jC8GkDyjRgz?=
 =?us-ascii?Q?swNPYEZAuWydnxS/cG6/dvKmk+YvxbfyowZ96nvoIgGiBPBtq0AVHxhhU5BL?=
 =?us-ascii?Q?QmTaH4YN08VL63HZBd2iLxYMw86qO7vTaUdsjnOgUw9q5NLDVCxUTa+azoxc?=
 =?us-ascii?Q?hzc7A4me8OXxMA3/jt1ZBWHRH1J6rMPjl7UZfCB8o8wTMd0QTsRJ47I1qTwO?=
 =?us-ascii?Q?fEs89U5/bCujdS/Tkd6QvxTQaAHer5QBaQEqTQR7jRXV2SjufAHlL7hw+tbm?=
 =?us-ascii?Q?Va5tN7z2Hn9x99kHz70XUYO3Uv3VUY7/6r8cuvcxrZ+hz+UwfXTKFAwpncDm?=
 =?us-ascii?Q?WU/Fw0/dKpLc2Iv9clcBG3NsAoqQkQ23ZtWROcFU9oGi3npv8mUnwyR7Wxyt?=
 =?us-ascii?Q?VPnmiHQcfn/C7FV3scJmYX3rSzIXUFtFNf3NBKuvW5dezhYdJQFYn48j9kRI?=
 =?us-ascii?Q?V38sDrAn/xilL63K1/T1gWjJ4eLSdPv33MAx/RzXFprTHgGVYZwTSmOkeXKv?=
 =?us-ascii?Q?Pour/P4FoIIGCTcaSYm2XHHWSIfuNZOgyEFWe1KfaNVmuqtw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f1fc504-1bc4-43d4-a1e7-08df2c8dfec6
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2026 20:34:08.7763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gw/o9ik7w/DpyEl+/iV41ecC8LJWNrBJa7zaDQWKXHTGu+ELCAlWhhA1XX86x4yM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6713

On Sat, Oct 17, 2026 at 11:16:07AM -0700, Dionna Glaze wrote:

> > About 3 months ago we started looking simultaneously how to support
> > roots of trust (ROT) HW in place of TPM and how to respond to the
> > feedback on the netlink proposal for the TSM SPDM.
> 
> Given that I was tagged on this thread and not that one, I'd
> appreciate a pointer to which you mean.

https://lore.kernel.org/all/20260705220819.2472765-2-djbw@kernel.org/

And then later this:

https://lore.kernel.org/all/20260921131911.532d81f4@kernel.org/

Basically: No netlink.

> > We began talking about generalizing tsm_mr to handle more than just
> > "tsm" into a broader set of roots of trust, including TPM. In this way
> > it could act as a multiplexor for any measurement user in the kernel,
> > like IMA for example. I see others have independently come to a
> > similar conclusion that IMA needs ROT agility, but I also know that
> > DRTM needs the same ROT agility too.
> 
> +Jarkko
> The TPM driver is pretty entrenched and heavily used by different user
> space applications, so it seems really ambitious to bundle in TPM
> here.

By "ROT agility" I mean if you want to do an extend operation you
should not have to know the details of the HW holding the "PCR".

One of the APIs offered here is a HW agnostic extend that can be used
to build ROT agility into user space programs that are doing
logging. That's systemd-pcr-extend for example.

The extent of the TPM support is to be able to issue a PCR extend
triggered with a TPM command by the agnostic API. Not ambitious at
all.

> Consider that you have to do a lot of command interpretation to know
> whether a user is getting or extending a PCR value, or whether it's
> systemd doing an NVPCR thingamajig.
> I don't think you can intercept commands and translate to intent for
> any kind of extension to be correctly tracked by your MR journalling
> addition here.
> Can you explain a little more what your intent is?

Just a multiplexor. We have at least IMA and DRTM in the kernel that
need to do "PCR extend", and if we have a world where the ROT isn't a
TPM that operation need to be multiplexed to the right driver to do
the extend.

There have now been two proposals to do this inside IMA between TPM
and tsm mr, the point here that multiplexer doesn't belong inside IMA.

> > Bringing in the SPDM side, the netlink TLV uAPI fits nicely and can
> > expose all the structured binary data it has. SPDM is also effectively
> > a ROT without any measurement registers.
> 
> I would push back on SPDM being a ROT because you're talking about
> different devices.

I guess there are different of terminology conventions.. When I say
ROT I mean the HW IP block that does at least a measurement extend and
signing report function. If you look at a schematic diagram of a
modern server there are a dozen of these blocks.

Yes, only one of these is the ROT used to measure the CPU's boot, and
only one of these is the lead ROT for attestation.

When I talk to people building the PCIe devices they absolutely talk
about an iROT on their chip that measures the PCIe device's boot. SPDM
is the protocol they are using to allow the OS to interact with that
ROT.

I guess "attestation subsystem" is a clearer name after all.

> Any other SPDM communication would be for composite attestation by a
> lead attester that all gets bound under the ROT that the lead attester
> uses (presumably TPM).

Right, userspace uses SPDM to connect to the ROTs in devices, get
their attestations, then bind those results to the CPU's ROT.

> > name for this expanded purpose so we start calling this attestation
> > subsystem. "root of trust" subsystem would be another way to look at
> > it.
> 
> I don't see how a trusted security module is a bad name for this.

At least half the stuff we call TSM in Linux is "TEE Security Manager"
and it is a PCIe spec term. So there is this naming conflict..

Secondly, we are imaging including things like Alistair & Lukas's
entirely software based Link IDE flow and I've had some security
people express a strong opinion that we must not call such an entirely
software model "trusted security module". In their mind TSM is
something outside the OS..

> > The general notion is any root of trust can come with a single driver
> > and expose a bunch of different uAPIs. The modern most capable one
> > would be the CTLV based ioctl interface through a char dev, but in
> > cases like TDX the legacy uAPIs will also remain supported.
> 
> What capabilities are you trying to enable, though? I'm not really
> getting the picture.

Three basic problem statements:

1) If I want to extend a measurement I need device specific flows
   for TPM, CCA, TDX, SEV - and they are not discoverable
2) If I want to request a signed quote I need a different set of device
   specific flows for TPM, CCA, TDX, SEV and SPDM
3) If I want to add a new ROT driver it doesn't have a logical home.
   You'd have to awkwardly squeeze it into tsm report and tsm mr.

> If I was right about you referencing Alistair's patch series, then
> perhaps this is a clue?

That series is about adding a software SPDM and Link IDE flow for
platforms that don't have a real firmware based TSM.

> if we're leaving the SPDM message construction and
> interpretation to user space.

All the firmware based flows for PCIe run the SPDM protocol inside
FW. The OS and userspace won't have access to the SPDM messages.

From an SPDM perspective a full system may have a mixture of FW doing
SPDM on PCIe and Software doing SPDM on somethign liek 

Userspace probably won't have access to SPDM messages. There are too
many FW managed flows for PCI TSM for this to work. The uAPI here for
SPDM will be some least common denominator. Drivers take that LCD and
map it to their specific FW calls. Alistair's series will be able to
implement that LCD entirely in software, but since most server systems
seem to lock the link IDE controls under FW a SW SPDM is not going to
be widely usable for PCIe.

> > For example the end goal is for systemd report to be able to
> > dynamically enumerate all the ROTs in the system, include them in the
> > report, and generate signatures. Without necessarily requiring ROT
> > specific code.
> 
> What other than TPM quotes and signed SPDM message transcripts are you
> trying to cover?

I also want all the stuff that tsm_mr and tsm_report currently covers,
and other ROT HW blocks like Caliptra that people are building.

> If there are NDA'd docs to get more info on these, I'd like to work on
> getting my eyes on them.
> Are there some doc numbers I can ask my hardware engineering rep to
> pull? They manage vendor engagement.

I don't know about docs, but if you have your people reach out to your
NVIDI reps and mention this conversation I'm sure we can arrange a
NDA'd briefing.

Thanks,
Jason
