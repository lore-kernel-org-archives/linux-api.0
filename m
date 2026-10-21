Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.56
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590946;
	b=bdiBZhkfYpJYMybivpEEAdklnsoC7oxQPn1qHZr3doESypNQh2egmmakmQe/PYnIcQqu
	 9bYpQGmApgDQJSfW2e99iFaxnKg6ck1C64DmAVql+Tfk9GE5jeGlgiGMKw9h6bl7ZGtDw
	 MO1W1xr7pvieQpHSejqFE1UhJZkhZ/6fHMcnlA4rMVnuxyDAUGwusMyIa3awFWJw81SZB
	 iQ+TOdwEH/dYAiHl593E3kwwqyREOIVLVoXzdiQuLrMgigzdpUL9TTRExV10W/pdDqxy+
	 VpcrWmWZfAYLqBmZZHUiCP0aRSbcCupnUqe0fhQv4U7jMbU9kdiV3cm+RK9dK+5/3gQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590946;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=V1Y0x827KZ5gPGFfhEMzDA78Jbu/KjnnmWcX/SAyXpE=;
	b=1ehZrPXZASZjsIApNAz7+P9zGTu6TYUJSs6zgs3lLJYJ/xKL5BJTkD4hRpX8nG0+QWCi
	 K+d1Q0lw6xfyWD0g7wosuc/dhM4qpYlOPTHRD7cvU99XWeOJLolmbgYYO3phaYknqhhdz
	 JsZlhadWvPbTHOJN0SK2nXkOj/LmrxcJvv4CSiNPSprKizJTDde94jdd86Xz/jUuJ7Ik8
	 /SHXleKBsPnhV+0lSWPJ7Jd74fo/qdkOnqMImJ8Bw6QOnnyf/k6H6cNFHG0ppU7ZRQoH7
	 8SD0+ONS9eui6qV6eNhB/j8uw31vUAMjEWzQPGZ4R4/OJoC2rCHD6UVXmrB3OvNJ6Cg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=e6bk9CVc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.56
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010056.outbound.protection.outlook.com [52.101.193.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F636606A319;
	Wed, 21 Oct 2026 13:55:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5F636606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=e6bk9CVc
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h6LU9sFLNofWGx0+G88GBRaeTSXF+N+z8qmKU/o0xE64DuSawMGsR+NhbT9fw95VvtY1zeNeMEOSsoZM3WkzvP9X71d0mh4YViE0xOM6R4Z4rx5hxwoNlpKt9jEIGAcNo6B74SH+ZIEamXuX6UNDPMsFo+E8oEGoz4b/gG4rpVWHnVZOQgGGC+ed8/2Lj6Het0zsmpwFaiCNYBzbXmP5sA0NH3bmmLEI+jPxokANYXfOngUdRYjK8I6Ylypqb4xIkHVCDiuCHpBcto05LRq5RuFPxTDGROjzFlgiA7zKpOvzfqWIn/6+RhMUSRJpOI0S3ci2/IjtYkHpHFQQGJo61Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V1Y0x827KZ5gPGFfhEMzDA78Jbu/KjnnmWcX/SAyXpE=;
 b=UKyCkCulK2MY1bPuM8UNyQXUZa+AlxkcvwI3CDNesIKFHCYREqFkeBhVLsOxJ+nLLmyHhkmCk1JDySkLkurKZB+Pubns5HQsFm1xPUdfW8AzQMQSWnTh2FUSaqQXKF3dCT/rOa1Fdr6T3IrV5ulSSaCOJJxKi86yZFpo+QUScXks2Y930nMesLg+Nt4n5IGgzJC0mAbqYdqFh1564Z/K7EFp2MpKmjwmssEukkmh/rmuY6Y2aT2jK7UxqDhD3X1pVLo9Cs47sUHNNa7BCUOQlO+Tu8xblsX+/mx+16rMqSw4OZVEs+hwn1Zwyg4bZkW1NO+UkwAXeg0IqF6Xp6Dx+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V1Y0x827KZ5gPGFfhEMzDA78Jbu/KjnnmWcX/SAyXpE=;
 b=e6bk9CVc0sRYZa5GghKu2FpZ7NSVvMemvlzVDxzIaqWECkR31fWI3OUOHZnFyribVGVSyo1REUXwWzJ7qHv3owlmGwNVeskJZwpIMK78LhmN21nCzvy6ic8dC/4RG+Npfu3bJjbfcno8C0MNurDl7V6wQs05mE/CDcWC++RzeVDLVFDL8yeoSCyNNWNIwm7pF+Tep9q4Uvw3I2gOZRQx78nn9+VwkZKdnro/0XJintF5SeK16LN53lITvCPAmUL5/QpiAD3o802CVIOwy3R4CHuikpxYiV5wGdSrdV5Vw6FjQmvOhJxflu/Zanvvpo+LLKcgM4RwYq3yMU+Fr9p0oA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CH3PR12MB8073.namprd12.prod.outlook.com
 (2603:10b6:610:126::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.14; Wed, 21 Oct
 2026 13:55:36 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 13:55:36 +0000
Date: Wed, 21 Oct 2026 10:55:35 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Mimi Zohar <zohar@linux.ibm.com>,
	Dionna Glaze <drdeeglaze@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Jarkko Sakkinen <jarkko@kernel.org>, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org,
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com,
	aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com,
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com,
	ankita@nvidia.com, suzuki.poulose@arm.com, kas@kernel.org,
	rick.p.edgecombe@intel.com, elena.reshetova@intel.com,
	dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com,
	roberto.sassu@huawei.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <20261021135535.GN3008132@nvidia.com>
References: <atPgqROZZxnihYfC@kernel.org>
 <20261017231007.GP13920@nvidia.com>
 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
 <atX9fugGUsI0hGcA@FV6GYCPJ69>
 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
 <a69c7e7ac4fd07a9c375faadc599e96bb8c8534e.camel@linux.ibm.com>
 <20261020140655.GV13920@nvidia.com>
 <aa00515a0f364fea0150cf1550a09d9400e4632f.camel@linux.ibm.com>
 <ateSly15N5mLrM1m@e129823.arm.com>
 <2641f9f5141126af8a93763fcbdd2ffd5c4e520b.camel@HansenPartnership.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2641f9f5141126af8a93763fcbdd2ffd5c4e520b.camel@HansenPartnership.com>
X-ClientProxiedBy: YT4P288CA0073.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d0::10) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH3PR12MB8073:EE_
X-MS-Office365-Filtering-Correlation-Id: f14bc077-a680-4d6b-9fe5-08df2f7afba8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|23010399003|376014|1800799024|22082099003|18002099003|10067099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	D7HMXsxV0tC6+p5LFt24XFAukGeRIxRgxrTMe25C+7aoXIj0nRsvo6smbKpAj2WtlRX/Mw7KUKltmY2dhyGL/bNFladpqlToTGIJZH+VsWAHwbEkRv+OvOdTo86DOkAqgRhkPnijcQZhYLx2RUOhny9QyokU7hzj1r1T3CZnLrmC7GgYZ0uKQx2q6DiuJ7cMLBCG04lAZR7hJrqL204ym8ap7XXpQgVm0gcZWrupl/1/L6F4OrUiAYVGmi8+z3eZNr1UEI4GR8sveAZgYKXfDuKWQBCpTgnEtSDSOmAPbKQwGZOObdDgV3O0MEVs3+ZIEn9s8tgNwcjblbPuFQFxPTG6vpbfk+vXpXNVYmZsWlvSK5plDMN+/4IuKBb2+x3bV2cQMQnBl3f5iaZT2Q5LjN59w4LDn5H2Tzqbvxmhy+gUYf2nzyuILG821t9PTmqfgTt+Tc1RlbEtiI5izWD6Jgeex2kHQcluBBcvxpGkWm9n7j1UBrr0Hgg5/6fwgUh/QIrrXfWNT6hI6FmMLxYLmqUqwr0nOmlCFJ2VELiVDtibmAbKXzZv3lUaIQYFQ2nJxAbrkMwFfHNH31yIeNwuobMaau5JkQ4zsl07ZzqMq5AVKxxwb29QyuBiVLecnwY6+oONYoNrFWle3LT4muHuVy305Vg5jDWwKMjzbMcmF1U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(23010399003)(376014)(1800799024)(22082099003)(18002099003)(10067099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vRrrm3AAAkGd6HBwV4BSMGjsw7GLLSBJC9ry8wpB1aM2SWo9V4mNFWrK64tx?=
 =?us-ascii?Q?+ehuZluGz10OslIjXr0dxdcvFy2Kk/Nv2xCeGQZtFFw5+8NNZNFyVLXuPpkz?=
 =?us-ascii?Q?QS0d0m2NWSAOVHWQ+blbBWIaS9ASIugQmHtZfAaUr2gii4jyA77ttRhJQvdd?=
 =?us-ascii?Q?i9rD/2JgpPmZpZkxJx0iNVOacHpRz/nuevTeONP7MMQAO2xQit6zDO6mKHvS?=
 =?us-ascii?Q?7zCnTABXWIKoMWZDbkMn7LlHCDBH0fu/RUSN1kIMujxm5hRrYm5TlKKuK5IL?=
 =?us-ascii?Q?ka41mKd7JmlKpy0VMglB6GOoGkC0KqAy1jBKPhpHL/25cYQ4AOIu2P8COggU?=
 =?us-ascii?Q?L/nnKCwsBNaN4RQB8RmoFG6sDqTWxm0nsglmL6cl+EDHO9Gie7ZmTxx2Pyh4?=
 =?us-ascii?Q?BOBsHC61i3ARRki4CSuRSVxhD9923HksARogS2o9i5fsrscW7HrEJkOuZ7pR?=
 =?us-ascii?Q?uIDq4olEgmrz5V5ecunbV1qFoXwd8+vje8wocH3orJ/UoQJxtKmV2sVmQl3j?=
 =?us-ascii?Q?xIXmTIyLW6CgPidwLPA9QPyfKjQYOz8IX+hia0xYb1rQPTF6XUcuQq3Fxr7i?=
 =?us-ascii?Q?ebQqFNp/WTS2o5FcKX/zt/lQWzu1sqhb4Le+1UPMxM+cFWz5ZJF6eNRabh5y?=
 =?us-ascii?Q?SK8sE5N2g96PDUlJqKNJmfI+S7IMuBXfzLhHzCPkjyAtN3E6Erp7AsduTinf?=
 =?us-ascii?Q?/7nYAlAsrSi4oTmQBjxxjrJ6rIsYMf5dtAO0h+REhqeiZTytV82+pywZxACb?=
 =?us-ascii?Q?9eYyJU1n/XqMPPzlMOOU2wxY5qvdSQDnE0rBXHHpgS0/H8Zc1bJwLg6RYvyx?=
 =?us-ascii?Q?F9CxPeRiabSNclryfu5Q2Sx8MZ8txHencXhb0U1Qzx9aPZaulUBGErcjCGeZ?=
 =?us-ascii?Q?BF2CkGVFu8M4zz0z0Q2Q99+RTSR7EOy+lN0vBlFejuCNQyckP88yDN6bZEYz?=
 =?us-ascii?Q?jA9x+TpOgCxN220SkebqkWO10nTbddvNQjyEo3cOnoEy9wVpLgCVnaSsoiGy?=
 =?us-ascii?Q?ghD367D5tZPKippP8CpE7tlvYxP5nJwJmxW/wscxMxSiOTEUWlpwM09EZia3?=
 =?us-ascii?Q?qwW23HISECdPe0KvzsxWmrZnP+QrVWpwm1hz6VciLgs/9I7KpYpCxsNvZKhV?=
 =?us-ascii?Q?RLOnJcn8F6cXbXZcu1djK8kB6FcaC5rGagDgqUyWDxw2DyXQ/PC59kF4V+wm?=
 =?us-ascii?Q?/sl9vyaJfiuFc+RF5iVdnwUHwjZIU7P3DyqVAkm4OKN6QydAJZPz1XM4pN9p?=
 =?us-ascii?Q?efrBtQnHzHSKJV8LLtbuFk27t6QCNh7oeb8RZyTXkkgT/9mdlayw3NsaIljj?=
 =?us-ascii?Q?nTbb8NPCBvTGhiXsfEjkrAB31NfOanYk8rcNTLlnLtpcUUR8VNQ9V+369DMz?=
 =?us-ascii?Q?LfC5lE7wHDIeHVPOUnNLvj3CmDz0YvDH+iZabSta0ki4zez4yXkpPzdx56Ik?=
 =?us-ascii?Q?VLCWq8mVIQsQsSI7iZJXjh4+/Dxpea9CurD085KkMMbCs5X6j9CH+SP6FO6Q?=
 =?us-ascii?Q?Mf5k224AjD3pzKBioF8Zi1P0uKX/MKNQhPQuSctl2EgEN8Bed9qawiTMUPRe?=
 =?us-ascii?Q?C7J2ugxRiJ2Soo8RlVI9EwV7DeuRKGz8Taz1OevcZxNFRO8W5ND3UcaMv8HJ?=
 =?us-ascii?Q?5g6fEZsGg19UWZYGjjWk+xrZ3rJMjPG389F2qn22ZhIuUdUCKui48QxrII6L?=
 =?us-ascii?Q?MB2of9kwiDkhRL9kEYkPRhotGezTnsnEaODebPK2+3yZhFaG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f14bc077-a680-4d6b-9fe5-08df2f7afba8
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:55:36.5515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W1jg0rKmE84u2PciMOKsFOqdbuxCGu13hpsfgJJ5LtKyjwewUKh0H+2aJ7BDKQD8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8073

On Wed, Oct 21, 2026 at 08:48:28AM -0400, James Bottomley wrote:

> initializing its own TPM driver.  I've often thought that if we could
> prevent that and have a separate callback to kill the UEFI TPM driver
> (or probably one before ExitBootServices to say please keep this driver
> and then another to say I'm done), we could effectively use that for
> early kernel measurements and then engineer a handover to the in-kernel
> driver and then not be too worried about when the in-kernel driver
> attaches.  Of course, doing all this would require a UEFI spec update,
> which means it's not a quick or easy thing.

This is effectively what DRTM is for. My plan is for th launch to
capture enough measurements as part of the launch so that kernel can
run along far enough to naturally load the TPM/ROT driver. This is
aligned with how ARM DRTM is sketched out where you can get to ACPI
TPM discovery entirely on the secure launch data.

I'm pretty against "early TPM" for DRTM, and I think non-DRTM flows
should be similar and measure enough stuff prior to Exit Boot Services
so that the kernel does not need early TPM.

Jason
