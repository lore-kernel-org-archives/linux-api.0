Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793023706;
	b=2iqQA2H84ePz736wIJkadUMEDLDVa7IVF1ILGV65Wls1xMjx3+JHxNcDZeXAbqvtClxx
	 wjAm3xWUsEkNPVoHAGGhvngvCI9H2YZXazKCYaxnGMaoF8nn/WqHWayP9R/NO7vjYCnBh
	 pQMBksWwC65o7j7/mmYW9AbPpMb7pLdwzBdqD/BU+IGDi/TjXgLFV/cmD+fh0R7iGNZhT
	 cmUV9XWcdEd2imZE+81oF+kazA1hX+pd45nMWKQ7DigMXnY8QqWG6AmVI69TyGLZJjhto
	 amkmT1x4mRznLyRiT1R+Aph6HJ6kWb3Vi2gqE+KDCOZSP/Cu8h34f/tTmEfhiNmxXQw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793023706;
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
	bh=HmN6qMj2q/RAN3RMFibA/CYYSvxqf1Qovxi1RH4w5v8=;
	b=JiqYc4awWcBGYCnzp0uovcsZWeJxW7I/XxN9EP2DXUyuDgM7xNvL75ig1v4lQwbvuW+I
	 tCnrlyQLNg9AXklGC7Vhh548tqAdTP3TGEa0n0QhJ2S7A1SoUHJ4Xzsz8XWT6vASHBOyk
	 UdggQa40qfQ2om3nyPhOwKgeflbB5EkdDjjhRikjDyVdKIzcLC2wlKpdbSrw4t7Jtqmx+
	 obfGlSEMxun1T1v8cvdvPSDhnNCGq6BinXKv+0C5l6HKYNPxLpfZQd1QRBkIQodQQ0+lW
	 9kCzCubYcbwpI1UYBxD+3jdI6yZzpZxLhLGAMM6SciU7rSDDxfLLK/i2f6qTtrS5s7A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=rMZAwtyb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.33
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010033.outbound.protection.outlook.com [52.101.201.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F105606A32C;
	Mon, 26 Oct 2026 14:08:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F105606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=rMZAwtyb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=haNA8r5xEQpJgsdAdD0ig93q9MnG1LPFYFlKT2ZVvaH9mnsdnE8VkI8UFfl6V/96K0llLv8GYnXzHJ+iBIK9sfL/YsE8lwYLfXxHQSlgJ2D4abcaJc3BnKVRmbsngph5xmAB/kT00w/gtNS4efoMPuX8Olwmd3CccG9hPUOc1XOCl8LFZ98qx18jtUOsQ0Cjp0IFhn0j+0uKtNtGEwI95XNS4JFIQyVETb/mv4e5rBzl+eWYFp5C5NSVNsKIdGVFq03t0hNOng0Co4wuHH+kcxFvtqwQ5ycn0OBwa55awfy19RWLESwFtkPalhSsfZlvea8+XDlWOYt3MX5j8anjLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HmN6qMj2q/RAN3RMFibA/CYYSvxqf1Qovxi1RH4w5v8=;
 b=n8AYUN8J8I6LPadDVZ0TRBJTlla95Te6bU2iKrTI9A4BRASUf0l35pbLO15X7P1NNoIBSBR/VQd+rLoBVjWr2froOwZOTCnPNq20YASXYIdqR8Yij3wHSfJiKrVRsF3f7o0izYYc8c8cDKSqgSsCsV8dKVZf4WFBXK7gQ3566pd7K25Nc/uulhFlz2C/FsQowlX85VU0PWFzQoISoZw7j9pi5u9pOv9D2dP7T8gtnfHaMDCsD8PY8dUvK06VhWabXZ0SxMLM3Xil11FbiyJTd+gSMwRxsUohW3N4Oqb9VTVog/KTVsFGNuJ1IUlGDZcbGPe/95SAKQmnprithUul8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmN6qMj2q/RAN3RMFibA/CYYSvxqf1Qovxi1RH4w5v8=;
 b=rMZAwtybCs+6KTY6yX34T+BA6zPfwz56C+66Z/qwo50zZ8BsHK9MSn5fvOwAZ13TaZeHBijpep9toHCjCm8l8rSofTQtX8k8TLzUOY182x9s8PtN1Ck62ZXE64E2Egh6Yy7Hzkn9rUHZhLImwhHmQqKMYX5WpuTnsN45dgLbmIwENuEty12UCj0pmelBjWBRZpiwyALk9bDGoTjvZqnn5R9jcihaNecag6ew0dP9+DMotuKWUcHXYuIpam1BKXf/tNyQOu7ErfZaWr27txnBsARZ8V+niNW/cBlAkm3KdtEkN0XiQzePf0nL7yMaWTaH0aHM07MGj/y/3c0vqS2C0g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM4PR12MB5961.namprd12.prod.outlook.com
 (2603:10b6:8:68::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 14:08:04 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 14:08:04 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH RFC 12/20] ctlv: Add device and operation dispatch
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
In-Reply-To: <20261015145053.3664509-13-jiri@resnulli.us>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-13-jiri@resnulli.us>
Date: Mon, 26 Oct 2026 11:07:54 -0300
Message-Id: <179302367452.58760.16195458599265885835.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: YT4PR01CA0265.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::29) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: bb905a0e-14dd-4147-0ffd-08df336a8c67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|4143699003|56012099006|11063799006|261022105027099003|261021135927099003|261021121427099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	+PrnCe0w3lSl2NzsDSCEKNFjyUA0uqC/OJlOCCHf2gNBBbiDjGuBxrU3U49W/XUGp1InzFXcOZ5R7ps2ss4BUxVwYx/5zAX5nraPwgKjoKVVreCeBYXYAp4pEopO9D7Im534x7Hd3FlxB3RNC9ck7/cehyaX1E0FrOjPFSI0+uVUbWdHmgfvtXPVbBxSIw/bljsrqvOEsvF7pOtzj8ClbDzpjBUJI352Uz2okCbe6yDNsNNSncOcQcMjYElKRirAXDtBhA8+urJOEppIoY2PXDap65EubpWNgYUoj+j+yv6Hf4VGGbt5k9ahE52TmHiuUG/q7YeJ1wG+s4Ls59qjHYtBAtoc7KarFAvoPa0L1YCqBXreMZ+wp8FCM3SgZmVi0/jxkefFgCNuKDfFQZgZTB9LlonCbDaFZSVndXHHwQ2J09x7zhQ5h9m4iHIkgZ34rKyTI2+fCRxJVIvxDE/5pRJPD1Z0WHXFDX93rzXdFKYHOFdTVAL26uhBAV8sHH/+blVdfMF2IxPLHAd1uXjeQwtqq9i+wMAl5fNG6tA3Yb9BfhCl5PuXzZYvSFwNmyrkIvD10s3QODyI7+MyGZ0WJzzze7JWnPpz5qb+qsHCD19ADPG3XmPTdBHdJPoyOuoHdfOFWx2/bzukVGvmxW4Y40JUZ4SXN+9L7EGSj+amXYI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(4143699003)(56012099006)(11063799006)(261022105027099003)(261021135927099003)(261021121427099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Rzc5K2FBbXpXb1FNY0daa3ZyeWZJNDRNWUc4bTAyOXllS3Q5L3N3MEFsdlNO?=
 =?utf-8?B?ekVlZm5FZ0NsYXUyTTZxREdRVWMvMEpic0xnbXBMT1B6RkNhK2pyRlpFSWdR?=
 =?utf-8?B?dWRCOTRsdjRwRExMakxQTlFRT0JPV2RPZUhPS080UFVtSVVnN3FKaWF0ZU5a?=
 =?utf-8?B?THNXQXRRcmtld1Z0R2kvSm53SlhUVjA1Y2lnbGlZTE1DQlJPQ2VseTY4ME9h?=
 =?utf-8?B?b09DVnZvMksxV2ZVUUo5SmpEOURMVmtmTlhrbzhGR2c5Vk1POVFPbmpySTRi?=
 =?utf-8?B?SldtTkhmNTZSUEVoaU9jWUlQKzlUay9pa2NnbTdiL2V1enAxT3RYdVhJMS9j?=
 =?utf-8?B?MURqYmlLYmUvbjNMaXBCb3ZEUTJ0WlVyeS9qYnR3UlBjNmVLN3ZLSWlHOHVR?=
 =?utf-8?B?dndQcEUvOG1Rb2p3YjcvTlRFZ0dDVEhENXNJRVd5UG5BemE2N2x3NWk1Y3hn?=
 =?utf-8?B?VVd0NStjeG01ZlV4Uk9aVlhtamYyaCtRVXVKdm5YQ2cwM0JnWWlkeHBTcy8y?=
 =?utf-8?B?U0ZjUnJlY3lwNURiK0ZtQUNKenZtNWh5TlJHbTNlMTlVTDFzMWo0Zm9Ia3JC?=
 =?utf-8?B?eVZ0ejJVUGhvQUZTdE56cDNWbklLT0R4NE56TTdxN2doL09WWG5EUzJjYlBD?=
 =?utf-8?B?V0NyVEQyd1E4SHVDVFZpcUpmVmUyS01IQm9IMldqTEJ0NzRlVW42bWpmWHhV?=
 =?utf-8?B?NXhFZWNJdnlsVzhUL2wwTk9xZUVXWVlLbHd6VTRPOG5ZS0twMmNyUGhieWFi?=
 =?utf-8?B?REVabkZQdDZxT3FFL3pWRE1BckNCU3FIRFRBTWdlbHlOZFdrQ1pJZHpOWURh?=
 =?utf-8?B?Y0hpVk5ialFGUWxVbDVmQlRTUzVxVm1Kdkd5ejdJRzRnVkg1TktXeERsQUFh?=
 =?utf-8?B?RmJYallPK0M5QjczdTd5RGtwdW1zeFVsMjVFVkE0dE4rNFRCUkw1SWE5TmVV?=
 =?utf-8?B?Q0JaaTJUQ3FwQUdRd2FyVk1WTFNnK3BxREVoYVNFKzU2YkRrODViY0NZOGdS?=
 =?utf-8?B?ekFCTWw1Y2ptM0ZEbGZPRFduOTh6MGZxUzZua244WXkxd2tEbUJma3FSdkx0?=
 =?utf-8?B?MEJ5ME9LSlNxRGZ5bE9ZNjF1ZXBKL0tHM09tTUZRR2loTDRjT1o5T21ELzAr?=
 =?utf-8?B?OUdXeXB6ZGZuQ1BuenZ2OStobkQxcVRTZU9TamJXSHB2dGY3UmdBYkR4Rng3?=
 =?utf-8?B?OVh1MFF3WUl6QW96VWlzTW9ud3lBZjhHQVJGWmU4a05FMThKUnpWVzRLc2tj?=
 =?utf-8?B?c3FwWWcyV1BDVlRIRkVDS29VdU5rb1BnTDQ4a0F4cUpkcmRHTzczU2kyTVdW?=
 =?utf-8?B?Tlk2aVRKRGpaWTFjZTJONS9YQ1hHN3MvajFTTnFhb0tPcWZVSklGQ29Ld0dP?=
 =?utf-8?B?OEdKb0t0NHdwWGd1aVBVNWRzQ1JjcVZ6T096QzVxV2plREZLTlJjZEZ3eXU1?=
 =?utf-8?B?ZEFaVXRuOWRtQ25FODdYVC9NanJjeTNsQ2VnQS9NWEkvZWtkaFFUWTVEdWNF?=
 =?utf-8?B?akxhdUFWelY3Wm44aVdCb3JoL1pDYjFRQXE1ZHBUOHpacFMySzNpUSszTy9T?=
 =?utf-8?B?bFhtVnhQK3poc3dwYU83bkljbzNFbjU0TmpnMkRJNW11dXYzYmg0MkRXYlRs?=
 =?utf-8?B?VTNuamJsUHphd2RlYUpVOHRYZUIyZGpBTmZPV0hNVzd5L0gveFZGNUN1Sll4?=
 =?utf-8?B?NFg2YmtWdGl0b1R3YitCVjd3V09QY005TlZIeGtkK2dhV21SR0t0ZXd5K0Rv?=
 =?utf-8?B?cElxZ3ZFUlRrQWsxTVA0UFhHK2xSK1FKR0hTRmZXeE5nUy9jVzFHYkFUL0pR?=
 =?utf-8?B?RHdVTVgxUHAwNUEveldhbkZtdDNNMFY2UU5hbjg4aC9Cd0FGL2x1K3NlQ0ZZ?=
 =?utf-8?B?VGlMM093Vml5djNML2pDYzkyY3FGcjArY1pGS3ZCMThkWlNNWUZCRnVqVndp?=
 =?utf-8?B?bXZjTjVaTUhZbEZEYS9FOEJqRXFzb0hURUF5MHBKamk4TXB0TllWdDEzNCtE?=
 =?utf-8?B?a0NYTTc2UmpQRFd0WkdOck5OUFM5YkFxaExMcEtxb29QSXFQalg0Wno0R1F6?=
 =?utf-8?B?OTk4Snd4c0FVTjlHY25uM0s2bDAxQU9EYmxEWEhOQVk3OHhEd0t3Um0zQVQy?=
 =?utf-8?B?dDVjV2haSEJpNEtaaE5EdFdUK3VXMlhaYm5WSnZETGdaRlFwM2ZCV21wb2NI?=
 =?utf-8?B?aGJURCtMcDE0eHRnemdTZHg3MWJXK3JqU1VyczVrRjkvWVhSSENPY0lhMXdy?=
 =?utf-8?B?Q2hScVMyVy9rYWFrM29IWGNoTVdYdVVqWFRDNFNJT04vV3dCTmxMblk5eHIv?=
 =?utf-8?Q?MhnKZAJPAHi3t5rgjp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb905a0e-14dd-4147-0ffd-08df336a8c67
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 14:08:02.6151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QBg0p7i6LjUecL3lUcpkP3Up84iqFEB5PD7MngNaemRFsxE9J75JuQybCVmHkYp4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5961

> [ ... 125 lines skipped ... ]
> +struct ctlv_priv_container {
> +	struct ctlv_priv_container *parent;
> +	struct ctlv_priv_container *child;
> +	u8 priv[] __aligned(CTLV_PRIV_ALIGN);
> +};

This scheme with priv is very clever, but..

The usage in the tdx driver ends up having both the 
ctlv_priv_parent() and ctlv_priv_child() calls, but there isn't any
type safety and it just seems worse off than using the normal
container_of approach.

I think it is a nice thing to have for someday if we get to a place
that needs more than two things, but for attestation subsystem I think
it would be clearer to have the normal container_of relationship and
some reliable way to get the 'struct attestation'

At the very least the parent/priv functions should take in the family
ID they are trying to seek too, for an assertin, and many cases are
probably better off with just a simple:
   ctlv_priv_get(ctx, family);
That is slower but always gives the right thing..

-- 
Jason
