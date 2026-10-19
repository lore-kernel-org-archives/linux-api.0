Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792452722;
	b=cogv1VBcgTyTFeVYNtDzflztBr7NUDv7Or7+rVwZ8V2Y17W4R8P0f132lYlFsOKsyIX+
	 UZiun2Z+LOUfLdmk40ySuA/Ulv3S1Ad+FOtLTaKlF2wI/YtVSsIEaoaMxYN0EuNTQ5n6V
	 FCpFtTrbN6IjclkajbEXeTqWuTaoEb1A53c5zbt2ZP+39WfW+gnLlW17hKdrn8Dt2YfqX
	 qBd1RjfrxPZ3NINtovj6IxkVBRIpcf0LgkTF+BbpNwZb4fecMylm23BktvGuRIbuZ2UET
	 1XvPOjycG9HIxOtHF/zlx/gUG95hYZreA0EZv2itNAEmYdKMvDV8a/PXX2s9SkEOfRQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792452722;
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
	bh=XurHn7PBficQudHZlPD1TRUytIJFextNLeSaVIs4jMY=;
	b=47GSlUmBrDjrTTGKkgjlA5LTyjWXwpTbGTDX+iEl9O5KYzbSPoq/pihzRi3pIyjh+l/C
	 gHq4cIow5wqiKpxueCzDW9dlQqsCaBIktWvz/1pku7EKXANS/Br0XI/FZto06l1C5FxM/
	 7GwIvCWzqYlbclwtHu7BMQL1TUZefB+gTogstEBwUJS1yXTOILf6kATzyXqeMwSA1KcVJ
	 OzJAtPAM8MoA8PAnZifBA8mMcJ9nNHNnvRtv+wG/A1YVzQJfhN/IH7DLLejpfajAP4xkt
	 iEe58HhCar65JrkjdKMw/DqU4nD1IbZGDXQAg4eF5Ffi244r97zkcKldTOM4w3iI9jw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Q6WjXF2G;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.14
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010014.outbound.protection.outlook.com [52.101.61.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F815606A320;
	Mon, 19 Oct 2026 23:32:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F815606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Q6WjXF2G
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kwv498/DJ10+ViuqNfCJx0T21Xqz2QMYcFtUyyFCZVjGv6UR75bSV4+Ps3HbQ5gMXwmNBWkCvwvFuzz5US683QV13Wnuz7zAyg7N+BCergiUKG3DzsO+zs6LqeBCowxIjoH2UmzUYoYEPietrNe6iawCtT9WVuCUE/mc5mvBG3E9tiLDxxnUKdseppJIOa3ph4P26EuD3ZegbLbQn3qqXjxEV5L4ItVbSwYL7EEkPDxhU2dut94Vgg+p3Vh899D0sqpTOfTePy/jd95u5DLfN5oARtHLHKo2DE39NeIn30tLRKBhuTuvnzz+F7dnf7zit7ykts96ECjanignW8/bEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XurHn7PBficQudHZlPD1TRUytIJFextNLeSaVIs4jMY=;
 b=DAn/9J8bpI8Aw4ZqIXoLHPt1DEZJsLAf6wzJ61Ufg7WHTLm1MSmiQJxY203Up0/3wBJtfKK3CTC+pLOkGTMJTD2PAYA26nGOuy140Fna7ccavVYiP6fDVtVEbbXkpf8XbyTNvABIhiS3SrIgPLAFh9Esze+MhSa3q7gnZEahAupNiGCaNxBxs6nn6YdaAms33uOO5plKI++vWQyDhu+KYBMTU014Q07yEmfoSTwRy6eu0f+yAZ9nxwC6hMyNtluokALFg1GuZv9iO33mVBoPw7CaQrMv6E+JuSMKYRvV87ei2as85HE7ODOE5AJjJ81OxeQtpA87CWiqrQ0SSxAW8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XurHn7PBficQudHZlPD1TRUytIJFextNLeSaVIs4jMY=;
 b=Q6WjXF2GjQT+HSxUeOPkWiTmEf8pFC74ES4rbwgn3R3yfiVj5r0bBjmUXnzN8vMAXhZ3Tv/G8x1Zv6qXLgzhKzWBH3GIgU3m61tg0vXn4LV+9k3gOj0W6rvBCi8jPR2BnnBjzOtE33+FyMRj8fKjo3ctcXV96mL/oi9B2kUbQg8wGbwcD/BHSHduRRjJsRNqfkD/p1i8VrGkhTtaTZ7f58CSqUZc5TZorO6VttCWlHxy4+f+30tYLq5GW7tmBQzS8orZLM3qrzllmPErf7o/W//P5R9KtnavFK0fiTIimU8930IjnjrUSkvWN0Q8i6NFHuDKaR43t7QLPwUZmHW6QA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SN7PR12MB8789.namprd12.prod.outlook.com
 (2603:10b6:806:34b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.18; Mon, 19 Oct
 2026 23:29:49 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 23:29:49 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH RFC 15/20] attestation: Prepare provider and instance
 core
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
In-Reply-To: <20261015145053.3664509-16-jiri@resnulli.us>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-16-jiri@resnulli.us>
Date: Mon, 19 Oct 2026 20:29:45 -0300
Message-Id: <179245258506.58760.1633805100070716498.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: BN9P223CA0010.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::15) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|SN7PR12MB8789:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bf0576b-f574-49e6-66f4-08df2e38ddaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|18002099003|22082099003|10067099003|4143699003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	OYBkZ+DFoJVRmo/BWsL4SM/6cWVUIF30du4Qw6L8qwXUedFEjsUoRkk//B1hQrh1eyd+PP9slHSR1oAQX34WqYOqC56jJ0HJHjWI3XEvL1T3XbyLPzymGxjTmkgOw1csDbZJWcLi4kgbFHXHROtkD/t1b1X4kVXdGx1VxYI489xEch96HGyqGJtj+XnKIm78w0bSu3OIB90YKzsYi6M65COzn7X1wySm04y6XfFfD59w2K5G2PWg53T+ZnwqnGPbSUIIKvoK5qaZxjGp2ZYUCOKqcf7dIM5MMW3KV4nHG6GFfqY84HShacgnpDZH8Ir1Slijzg9Sciy3mC/bnHSAzuxTBH+5e61BTatI0cLhkycC83b2bxYJdhUdDVL5wk5fp/VAo2k8j/hci0z2zQcuh58jsJel4aLI+q4d1WFuFPYChICG4W6vQ+f3pmss8gAyY33MKotaI4I5p2xCvtnWrn7PzksHKd6CGZVcHcts76ZCOo27SDwka2BdzJIR3DRrkH50+X6kvYtYGOQtnZgokwSIVabtBiTsvUchvUJHUhhZdqg1vJDybvZoCIXKYq5zvt+Rlr3gQ2H4OuMMRhEzekJ9Xhbue3KTEXoLTeVTu7XXrkKbm5arjvrhwSU+DjOPMuH4jTTeCRJ9Se2JfraKg3REpGVDQ+zN6Q+PMDwG2wE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(10067099003)(4143699003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OFFEdG56TWJIZGhkcnNiMEExYldCWmV1b014cnJDUzh1eUhNeWZpcjh4M1pM?=
 =?utf-8?B?YXRFSW1kZVZ4M3ZOQ3ZnNU40YnRBWm9ucFpKK29IS3Q4L0VGb3JkSFF5MDUr?=
 =?utf-8?B?R3d5NlhyMGFuc29HRXVPVlVoSmdFMWVJUzhqMzAzSjNpc2FVTk5GcThoWVNT?=
 =?utf-8?B?elo4MktxWHl3anU3MTdzZDNudVNyTHkxK0JoZGhrcXF2RU5PL04xMmtlZWVr?=
 =?utf-8?B?NDBCeHl4YkZtZGNrTDVnU2VFTzRUdU80eDQ5MU1VMHhPSFRSMHY4UDBwSXF2?=
 =?utf-8?B?cm5iWUdSQjR4V0RCNXowcXdPbHl6RUNnemNxN1p3a0lObllkM3VOODlHR0pV?=
 =?utf-8?B?MW1GYXQxLzdxNWRBVVNMZjlJc1RZNkJubllESTNqV2xxVGRPVXBzWElzVnpH?=
 =?utf-8?B?L1Z4alpRbnNwaUZiVGREcGlFTWlnc1cvbTJUcTFyMUdjU3NCamk4d2ZZbG9h?=
 =?utf-8?B?R0J4SDlKeEFiNTYxVUZPZTRBN200RURXOExYOFgrRGxYNWdZNGtRRXhNYzNB?=
 =?utf-8?B?VDZudkw5MW9ZVGRnMlp0L2VSL2VpY0x3Zy9VWlpTZW10TGFSSCt5RkNpT3Fs?=
 =?utf-8?B?TCtZUncrYzIvS0plQ21JU2NJaEdxbkw5QW5WZkUyeEo2bUFpT2F3R2dWSUZC?=
 =?utf-8?B?SHlUaWJYVG1uTDVIWDMremhUbm9tRm82L0hRbS9GcXZwWDBESXJiZEJGSHgx?=
 =?utf-8?B?MTVVd1QvbFpQcmorV3dKMXh0cEVWcnp3TGl1WjFIMkRTUFM0ZGdYcklZN3R5?=
 =?utf-8?B?bUt6L1RFUzM3YVpmY25GSkx4YzJPRHVMUXJlUUJISnZMRnRMa0xSQmFGOEl1?=
 =?utf-8?B?bEJDQzBEZWVjVk5WMXE3eks0MnNxVDY4cWE2YnpxdzQ3NVpuYUdndWJ3TkZ1?=
 =?utf-8?B?NmpvRzNyNUh5aGVacTlhZUFvTms2TGpzVkhwaG5qa1F0eXFJZFVLMmllekE4?=
 =?utf-8?B?TmM1Yzc4eHJrWWJwYVBOOFEzVCs3M0k4cjAwcFE4WjRMSkRwZnk3a0J0SGlV?=
 =?utf-8?B?czR0ZXo4Y3FDVFBmMXJWRkxBZlFFcWpHWjdHSlJQeWdGRkRXb3F6M3hoZTll?=
 =?utf-8?B?d0grNmYzSlF1L3NKS0lGTXQrcmFmKy91QW56L1Z2dnlRSWpUci9NTzNxZURn?=
 =?utf-8?B?a2k4TFZ5Snl4dVlaN0ZKN0l4V09rSmpoTkM3MmxqdVRHdTVNclI0T0Zob2dN?=
 =?utf-8?B?cGJwcGxMNjBheXlUcE9mNXJzcGlnR0pqQVFKdEhjY0lYS2s3RjVSNklteVJw?=
 =?utf-8?B?Qks2bGM3VjBNSWxTakhCYjZNeEhRVUJ6NTRZdDROVUxmVW1WcXV1Nkt0bG84?=
 =?utf-8?B?VVkrdmpEb2JERUY2Y0VvUTRSVEN2a3FCdlRwKzhtNzZEKytoUHZiZTdseGlZ?=
 =?utf-8?B?RGFMeEVSWTBwbWtwVk1wYmVVdTNCeHhoL1hJakJPNGtxSitqSjNGTTh5Ry9V?=
 =?utf-8?B?RWx1RWY2RlBCOU9BYjFVRDNDZ0dXVHZPaUM1czlOa0lhNTJ3bWttNjVuYmwz?=
 =?utf-8?B?OEc1SGwreXBTLzhiREc0VTJwdHcwSTFiYUZjOHFvZDNJNEFNNE1XbFBpcVJz?=
 =?utf-8?B?VGE2QjlOa2FNMVJLSDdLWUl2MTZrYlpqUElsQmNQQlM3d3hQWUUzb3BIemRF?=
 =?utf-8?B?MzFMTEZKZmV6aEFGTjRkdnM5OHhML1cra0RpOEV4RDl5YnhDTGdjSUlDeWdT?=
 =?utf-8?B?K0J4TVJuMFM2R04yRmR1ZUFwWnUxSXFDWExVRENHaEI1eEYzblhxNWNsdzQv?=
 =?utf-8?B?aTFOR3BiMExmZUxDVHQyVlNaczlnN3ZwTHZhSWwvRkpjbm94NDFBckVvbjU5?=
 =?utf-8?B?c1hNYkxQVVQxK2dyZjQ4cG5GRnBEVG5ZT3FzYWZpZ1BaSnIvM2tnYjZRMFhh?=
 =?utf-8?B?ek03UDdua0FGV1JJWm85M3hEQVlnb3VZMzRpRGpUeVEza2h4NElHbnBWTzF3?=
 =?utf-8?B?bVJlUFNHdUg5R2xSbm5seHhEbS8xYWZPbEs5SU1XaFNiN3VHaTNONFNYbktL?=
 =?utf-8?B?RXdwelExaTZBdUtIYWRidSt6VWpxTXMvdGlsMmJtci9lcTZoTWs2dy8zYU5D?=
 =?utf-8?B?WXFpOVcxMXQwaHF0VWZtejEyMTdxaU9oQ00vbHd6aEo3c0IvWjZZei9uUHlO?=
 =?utf-8?B?YmZUelFRcVFxTFpuUkx0L1BVTGQrdEN1M05sTlg4TTY3b3lIbjMrM1h3Ri9z?=
 =?utf-8?B?L2ZUNDE5N3VhY0pCMmlwSlVJZVZTTVUwbFE3Mkd3K1hMVElKb3VKU0NwZEJZ?=
 =?utf-8?B?YXVYRHhFWnllYUQxQ3JZQmgvZW5YRHoycVQ1UjRuVUd4MFpKb2VSWEswL1I3?=
 =?utf-8?Q?o+k48xVQgOCl5yTwsM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bf0576b-f574-49e6-66f4-08df2e38ddaf
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 23:29:48.3188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WXTtX1KYR6TJg7PR2R8Sk4JARJmLVd0Qw301aolO7bTPPJ3UCugedRbZO4Zs0jWG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8789

> [ ... 99 lines skipped ... ]
> +++ b/drivers/attestation/Kconfig
> @@ -0,0 +1,12 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +menuconfig ATTESTATION
> +	tristate "Attestation"
> +	depends on CTLV

ld.lld-21: error: undefined symbol: hash_digest_size
>>> referenced by ctlv.c
>>>               drivers/attestation/core/ctlv.o:(ctlv_attestation_mr_read_query) in archive vmlinux.a
>>> referenced by ctlv.c

Needs a:

+       select CRYPTO_HASH_INFO

-- 
Jason
