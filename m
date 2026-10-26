Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793023691;
	b=1EeMTjMKberCnqe72XzpFAjSWGPVCPVbW22w2rXOikyj+viB58A2Zn/vZx1qb6ZX5K5j
	 M7kEP2MOA/ZuscL8xXGgqah55YwWc+DOWFx419qInkJ6L991Q4CEYm38UgwkjUGE+JiC5
	 YLv44Rmr+T4VFVI85ppBP5o4YSQvc+MvgW7dE1qpswkmGaX7EN8Q/cAOEFO5N/gBGrgv8
	 DWHgOPjZDzDgvw00reLRHiuRmkgizDdZrL8saxP3Ys3/PVhvXXaG8BLj+nCC8OKEhr7OO
	 7blHqlR0Oce+8TKdqUP1zYPCnJ2HWvCM4KJJMvGjlILxZqiC3LTHUNGVQsCRwxrCsTw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793023691;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Content-Type:
	 Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:References:
	 Date:Message-Id:X-Mailer:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=qO5Q/+Qq8g5kS1BG8gogQRkCnmX/WNdhAWCYDcRQ3RM=;
	b=13ndIEx9hOgbpFq3cPlICkmxkYPCeKstLGCVQ5Yl1bemMcAqQLW3++wfEf74DYBGpuNd
	 zSbJ2WcAtd2Q15uEt6emQk4aEewKsDCDHzNwTHWcBHgQn8oNt30g2OmKewNbQ7jsVtH0Q
	 BJsEoCS18pknsRihX/fB3+qDkV1UX1rukptZigxzjqAO1vVErZJwtaWUNyVHfmu949QOw
	 AH7OBCSJH0eLllzDG6msN1pxY7AjjWxkiDdLNwIRp9ilxuASxv/NQn/QHEH7H8Byuc/eD
	 yoMS2KteFyYNHvc51BWuxw5pSkeNL6qX31jDfH4rzupzwZ7A96hIvGVQdn3o4XkuvqA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ox5WsBzY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.33
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010033.outbound.protection.outlook.com [52.101.201.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF6A606A31B;
	Mon, 26 Oct 2026 14:08:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFF6A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ox5WsBzY
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Td2IQWTgmTNOqrxDTu0cU+vBSlBbaGrcB//biwv7JlhJuXXqFM2stdmnCraymxBA39axQAmJyrhwuULQxZjYVLiDuY+4G5BEyLoe2tlS7m4MbSH2AiZbESVkSBOubmkF5bIIl3nqDdcuHCBnEroLuTMZA/ZBC5gsMnfgUQdeKHog1+eSBblzRWuSwjx0+7xEr0nmhdRDCgWsIkR8uCJjfG5RJoORuUYB6OqnW/qNnG3ZT1h8oz/3nH9+/XDmaGqa94G7OUvsOShpM+d+hAEugyNg9B74xK1V3qmngbkN5VcTOl4tUK6a2Uva2Yuww/vgDCO/xl8OATR7VuiTKoawZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qO5Q/+Qq8g5kS1BG8gogQRkCnmX/WNdhAWCYDcRQ3RM=;
 b=okMxBkQ5iH78LfsE+m+e01dAlcLJg0BBchIfEuTYIOoIJe/3adSqgaRLNdMBm+dteNRVf2VnEZIHao2vobIoiz9fM3eVXM6tt3H45jiZIcokmJmYAeQx4Wg3DGBUIfoQyIAOwuTIr+jpVmW+Y8LyhtaW2QDBTVZl2Kcb3Ar/vobvLd9XmjI9MEKGmrMoyUlafvC1AAUQQRSKsTz11JnNO4iBIr0xWoPX9+pGdOZIYwRjidQhfvM72PwZh/L6gH1IE/dkjZX52LkGVp8k4cN2eWyGV2V/MnzRZcBr9XOBb9S+rl80h60jbLS6uFPximRGi5T1rm39RW6arAxZQJbLFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qO5Q/+Qq8g5kS1BG8gogQRkCnmX/WNdhAWCYDcRQ3RM=;
 b=ox5WsBzYWFaSmRMZmcBptg1Va4na/YapRlVyZwz7kD0b1evGHtgJpKW82K4Sc4oL2KMv+54lVgt+Csmpi2U3pUx/sIV45fYXeD4flCuWNWexT+yqEtrH0fvKAR4s0qsxe3XHtA+eLRxcANHNXBqU07kdh3tz6BcqqTyRjLZlgsiZ5cYIfX77tqR9AU4sMfQVoOGbBF1pjIyzKMghV2mKcTcfSBFF4SiUdsYbLbr9ElY0wVCFEilPx0YWEEBKIRZPWE3ar52xswF0eNuZOYUMd9NKxEh61EFbcBrY2d0B1ZQWuEHw+Vo2xJB9iwQNs4DVmyFRG91tXFl38RdeLbAA8w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM4PR12MB5961.namprd12.prod.outlook.com
 (2603:10b6:8:68::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 14:08:02 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 14:08:01 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH RFC 08/20] ctlv: Prepare message output handling
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, jgg@ziepe.ca, david.quigley@intel.com, 
 lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com, 
 cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
 James.Bottomley@HansenPartnership.com, aik@amd.com, jpiotrowski@nvidia.com, 
 qinkun@google.com, pgonda@google.com, jic23@kernel.org, 
 alistair.francis@wdc.com, ankita@nvidia.com, suzuki.poulose@arm.com, 
 kas@kernel.org, rick.p.edgecombe@intel.com, elena.reshetova@intel.com, 
 dave.hansen@linux.intel.com, sathyanarayanan.kuppuswamy@linux.intel.com, 
 peter.fang@intel.com
In-Reply-To: <20261015145053.3664509-9-jiri@resnulli.us>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-9-jiri@resnulli.us>
Date: Mon, 26 Oct 2026 11:07:54 -0300
Message-Id: <179302367451.58760.3909701518454079333.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: YT4PR01CA0047.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::26) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DM4PR12MB5961:EE_
X-MS-Office365-Filtering-Correlation-Id: e9f7af9c-1573-48d5-8a19-08df336a8bdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|4143699003|56012099006|11063799006|261021121427099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	OeSNXRrMa+2j9+PgXoY7xYFux9iSaljVBv40symLscMIhGEGWFnQ3tUXbRBPKfVIzvRlG173ooBM7zyNf4igLYHt3OW90d9kjydSKPfYaNDO/Wu55XWE4iwe/UQiZjG0FzfruzVvKPZHY8yG8TafQ3WdHnutObkrsRo6CKgFBDBAFymLMMQOcUOvEc5h0OQwkciMpo5Su/RRBgZAi0HKeFpk5kT9PNPYSXGXnAm/a05toDQHh/VuTwhLKNvP7SggAJ3acenC/e+urtkJVRn049lO/fYyW9fAd/NUrUnN02o5qKHhw6d5uDWIiSTOpXvRF50RdpOS1QgDv6f0u+M0oUP7extWltci4xL3dwZtWBg8F+s+IeD0Dqs+hKoVGqjx+IfC9RvURiVpdgXojeYWnnB736B+eB/2zs8OUQs/C2iMycHay9UI88ncyvxV5D/HVbYXe3DuOi4dJAlZmzrjDG9in/Jirf1oGpAl763PykiUcE87gDlYfdkg2jhSALOTctB980eTv7ZaQ3S9BP9zno6R5TsWwz1vDYRY7xayrGxpeFlaIov0g3i/IlFCPTaMPQ8u1zIPpBs5QpcW2/OgV/2XDHvUrfpQ+HnTJXjAjI9NTfqDzpWQQBSiEkM3sgsJiE9cJkRM7HnxoLNlz6jkpbhO9YJsIOBpYLX2Kp3X0/8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(4143699003)(56012099006)(11063799006)(261021121427099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R1lhUEdNWWlsVTUyWnl1TjdkdlN1NmdCM0xzN1MxamNJWmZ4S2o4SmlqaVF5?=
 =?utf-8?B?NzRrcTVYMy9SVm5VU0sxLzAxM3k2NUNBcEVtSW5KNGp0K1FURW1NcEo4TWRM?=
 =?utf-8?B?c0ZKQjExSFRUTzM3WnhtNDlmMXpIeE1hdjd0NWZUSytXTk1kMWV1OVh2Yi9y?=
 =?utf-8?B?cURDNHluelF5UGorbWdIQ0lDVGdpbWdGdEFJWVdud0IyN012YXFZZzFpbFRW?=
 =?utf-8?B?WEI0ejB6aE5TOVpWNm1FYVZCQ1MrZFVsZFVFUUozbzJvWlpjanhENFBoTXVl?=
 =?utf-8?B?KzUzL2duQktjaFQ5T2Z4WVZEd1RJYmk3Z0VqdnQ3a1FlOWVCMnpqRGkyWUVS?=
 =?utf-8?B?eDRieXI2WWRCd1Q4RUU4Y1ZZbTBjMkFKZDJmQk5UaHpIQi9GZUw0M0VoNE1k?=
 =?utf-8?B?bGd2dnFNWWV6Lzk5S20vZW11Zm5taFZoZXpCMU9DS3ZaTjBzTWJBUm1hSWI3?=
 =?utf-8?B?eGZaNXdXVUVPdlVzM3IxbVN4ZEQ5QnEvZGtVU3ZqcE11cDEweG40Q1pYY05n?=
 =?utf-8?B?ZUJCaFpOUE1sNmdrb2ZsTTlzYklKalVCK3FEaWh6L24vY2tFQXJISkxRc3Uz?=
 =?utf-8?B?YS92anhvYzVEYy9UQUNmQXVuRGRsc2JDN01mYVlxMzVyK3oyVHhOV0R2cVRm?=
 =?utf-8?B?RGdLRkdWT2szdFZ6cUZmQlNNSjRPSUt0dGNnd3dRTTdOZlI2M3VFVlgwZHRM?=
 =?utf-8?B?YnBSV3hmYW5QczZTQXJPdzRMTFNHYzErUXl2Y3VpQzNFUEZVSm9BaTRrTG5U?=
 =?utf-8?B?NHdHZHNDNHBGK2NaWlc2akFNeGVGem4zcWY2alorTXFvdHMzRTI3di9HV091?=
 =?utf-8?B?bUxmTlZUTEhHUEdyV3dWVEF3R2hvL3RxNnVWeEpGVU92VFlkK0FxMlpibldN?=
 =?utf-8?B?MXlBSE12Ui90R2NLRUhHQUkxanFIbjNtaldKNFRBa3poZTlLY1A4RnRQRFli?=
 =?utf-8?B?RCtNQVVuVzRHOGduY25PblAyRTZqTkltbmo5VjRlUVo1RFZnVURFeGJTUWdK?=
 =?utf-8?B?NTNDOFpnOUo1SjJOdnoreEFLUm9MYmp5MzUrZEMrcCtLTS9FUDBuRXN6S3lm?=
 =?utf-8?B?SGNDY3VRRTRRRHFtMU9ydmI0L3BKK2J3TUV3TEd1U0haNFA5T2kyVFNucHB5?=
 =?utf-8?B?eW5FQmc2VnBaOEpiY3lDVU12RHRkYVZoVmNvRG1SQ21uV0xsRGltaFZIZ1dw?=
 =?utf-8?B?YXFjT05CaWZTaVUra1EwZU41dnNhN29pMkM0SFlvMmpzTDlHRDNXTjJBV2tT?=
 =?utf-8?B?MWkzUXhSRmR0dVNwaU4vUGFPd0cvTUxYSXY0a01seFNFSC9zY2hxSXZERnJp?=
 =?utf-8?B?ZlVlMWY0M1M2cDRRdnRrY1BZb1M4Q3JGaXR4VEdlQ01SbGNvN0FURndoOFZD?=
 =?utf-8?B?RjV3SzdmQUt3ME1KYVRZWml5djdPOG9iS3lOMlpNLy81eHFwZk5sOGh5OVNn?=
 =?utf-8?B?eXpYQUVtenZnNWpBMVNxTCtiZjhIc01wc3ZRd1A4bUFiYmdwMGx0V2JQMHZ2?=
 =?utf-8?B?VHZKa3JRejJmODhLUmh3NndGT0VFVDJUZjNUVVZjeGlEYStYeFFidGh3dWxN?=
 =?utf-8?B?L1BYT0lpWjdGWDhnS1RUR3F6d3R6WDdkWG1QbytlMjF4ZUM4SUI5TlR5a0pJ?=
 =?utf-8?B?RHY3VzdLMlZsZFZGd0tSa2FKaTlPUTZ3MlNBSUhGMnV4YjZvZmcyWGdnK0tt?=
 =?utf-8?B?RWw1M1ZxaUZlZ05NV0lzcGdKb0RlcG9BbmpWMnBGMTh4K2thWXdhd2tXbmx3?=
 =?utf-8?B?MXo3OCsyVXFjQWV5bElIVjU3VmRkSURGYm5VSEwwbDBJZVA1Vm1TN1p2LzY2?=
 =?utf-8?B?OTY0eFl6SnRCdDBQMGhFTWRXdUIvWTRSakxwWkMzTWV0RFlKSWZVa0llOW53?=
 =?utf-8?B?MWR0MERSZmxaVUFJSkxja0xoQTZLY3lReHovU2xCSWc4REZ4RGxQMnpuMUZt?=
 =?utf-8?B?anMrZTZWZFBDSExna1RkMjlNT3pHbjNBVWloQ2tDYkJ2Y2Rwam1PK3V5c2lC?=
 =?utf-8?B?Tnl4SzRISUU5ZUh2WThHRkg0bnYyYTE1NWpTYTNjUE9wSzhST1B4UGlCYVg0?=
 =?utf-8?B?V2RDMFZaRERTU2lKZVhFVkhiMDRKODE1N0p1Q2tZMWYzSUdQeUVmNlhoYUo5?=
 =?utf-8?B?MjhneGFjbWhHdVRNdlpPOEdpbGtQZWxZQXd3SXY4cnBVYmVaMFNWL29aOGJI?=
 =?utf-8?B?SkNjUk01NUc1YTBNeUgwTzZPelNMaHMveUorZzZRLzJYWFVMUmVFMm1XMTF4?=
 =?utf-8?B?d1JpZzJVTXBzRE9MRFh4RlVPcFl3bzArK3lPVGtUQnltdjZCK2VxRFNuUW9B?=
 =?utf-8?Q?DS9LR7sbmRJLPvIV15?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9f7af9c-1573-48d5-8a19-08df336a8bdc
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 14:08:01.7080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: etgD/ftINCks2JbkgLZCqNOkCMKn4SarjolBAp2HFD6bsMQSzr8tZlzuX8uRDNV6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5961

> [ ... 498 lines skipped ... ]
> +/**
> + * ctlv_op_query_done - Complete the last query fragment.
> + * @ctx: query operation context
> + * @generation: current data generation
> + *
> + * Return: 0, or a negative error.
> + */
> +int ctlv_op_query_done(struct ctlv_op_ctx *ctx, u64 generation);

Typical kernel style has kdocs in the C files along side the function
body not the header file

-- 
Jason
