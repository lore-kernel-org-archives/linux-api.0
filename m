Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792696762;
	b=dQovvJ8At34MtZcsSR1iJdSpUs/iI5vNDmOYIAwKKuWa0JF/swWYqIuBpNEdU1OPEDOY
	 iosVTFgf9LkwoMNdHoEDEK/LX2XgmD9i+I7wx/wUr1mVza5vso8BuWzQyFN2HlkVO89vq
	 /kksfU39KnGZR69xJFL3utfIitkPOQpylZD97Et5XWzx0lo9k1n76uV9ha9ll3AYwdUll
	 sp/7wF/dtP007fQrWLkQVOwKKOlZm6IGLI8FBJIg0xuXt0V4PqO6sXNL88lyuXUUGSSND
	 IPCh+mAMS+rhtuPGpkKwiAkmEbmvunBNiDZ+Palx7oN98tjuZfJWqsHYUA94xlZzPuA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792696762;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-ClientProxiedBy:MIME-Version:
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
	bh=WUKD8HVpBpiHoOzWeII/L5k3RDhJY/AmZP5sWs1Rf3w=;
	b=kEA3chOI/ZJpKRhHpTvtzK3dte3AWtyumA+ujCoC6ClHV2yd60Tfjwq2q9Ht28lHZwyE
	 BpDsI6B30sSwu8i5uZNIba0cfpw5EggWdHBgX6o2jtMxOM2LXnsgGmEk47/x4wnv0osRt
	 omyIxZuH1YdDx6BKOiCmg+TTsABbGgvupCPQsKSHa/dnruCPh2qf7SZfmjx9fhnSbvSoP
	 sY9ZmYJXsglzKSWnIajsTjbdhj52iIwWwUXoGQqjNZsjZp8Vf2wvuJLIc2zHrK/s7XwU4
	 RevoDAbIrP1mA7g+iGhE+76eUnMYGzG1sT6UUlp4+fMO6C0f/c0VSNt0+RG0Qe7jVwA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="nLE/L+xA";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.21
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012021.outbound.protection.outlook.com [52.101.53.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5815606A31A;
	Thu, 22 Oct 2026 19:19:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5815606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=nLE/L+xA
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ac3CQScfPBaFlucFAivxGXjHCHRLvSVgVszzGiEzdp8i1xp6jqvL30nIOf1dU/hNYgEMqFl15kfZpKvWM024nEE/YqLe3l7sFIJxd5cccY7CKC+wAJWPDK5ERZz4E3bvJWDEtxlKJmPmjuONX8nAGn1f70VYHDW9Ke4UZYVfDaZkWtZLb7iQ7i/H1N+AY3chKwhG5dijw17088dCLxw49h37OqFi1JcRaRHdbek5Qo7Jz5Qz74xp8NhmYM8d/t5GZU8FhAp1Rd0i4TAofpguJcGAPYSzdu7owGw2y0syC4ZY7KG1RftkIzI2qd/mq/LHrs3sxe6uzOCi0WKSrpEbjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WUKD8HVpBpiHoOzWeII/L5k3RDhJY/AmZP5sWs1Rf3w=;
 b=eMk4Twvj/bD6Sxlm7QAPoNPWSaJzaCmfY2wGUT83X/fuOyLUcHoIRDng4S1w5CInwMuel90AbnarCeT3Nmr1lEzi7/yqc/6VHVyP06cfxTLPTIJbqXgNX+LMlVKM/ZgD8XBKxOfqzi+KNgJhXrLdldu2a0j/dXkJvw0lv6R8g7LqiOCWq+feVB9Ze+QPUI0UifjySZJvKAWV9S3dtN1+Vl6fYUK17MmYZ7dgbcKbrk0A6SyIspoyzj1HsV/jhpOW1Yi3XNr/D3FwYeAz7Who7Hb1wdLwKp0xLHP7ZIb2YvpweM0t5Q8d6NGmejz85C+rEG3DS/xQOSLGV4yUvj7aCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUKD8HVpBpiHoOzWeII/L5k3RDhJY/AmZP5sWs1Rf3w=;
 b=nLE/L+xAreHHGhu6+L/teyz/mggr1YBWc16vaJrzuaKXBQ5V0+TOVsrixGoj02qIfhzWld6YHzi0ZqxTqfgCXq5LGnoASbAY3f6U8Jli5yf9lbG0/1BzRfJBQmLmFmZy0gPOG/0k5rYVHGERsiKnxIZs5WLCUy140x1o5/5P+QwDeoMa//22dtWr/ZvQynXcK+jCTMaojj0GIOWrRysqem7i7nODIso02NKbe2s6+yvv22Ae561lvuY2D7yw/197tAGrya2xcUZg6SNxs+G/I/sh2T57I3eGWrf+BwY0AZoSv3+YcO0vx1mLRALNpJmshAeaQJOAkf69Zm+nB2DP9A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CH1PR12MB9576.namprd12.prod.outlook.com
 (2603:10b6:610:2ad::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Thu, 22 Oct
 2026 19:19:13 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.016; Thu, 22 Oct 2026
 19:19:13 +0000
Date: Thu, 22 Oct 2026 16:19:11 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, Jiri Pirko <jiri@resnulli.us>,
	Dionna Glaze <drdeeglaze@gmail.com>,
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
Message-ID: <20261022191911.GB3746973@nvidia.com>
References: <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
 <atX9fugGUsI0hGcA@FV6GYCPJ69>
 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
 <20261019225658.GS13920@nvidia.com>
 <ath4vwt7KGyDXKVJ@FV6GYCPJ69>
 <103486a4a29ecc7b72940dd051c00ae59266bd05.camel@linux.ibm.com>
 <20261021143529.GP3008132@nvidia.com>
 <95b895522bb314187ac1cdc5d0c143c01f0705a9.camel@HansenPartnership.com>
 <20261022131141.GD3008132@nvidia.com>
 <db0f90dde6421c3f2ca0164ea042e73d13b4d02b.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <db0f90dde6421c3f2ca0164ea042e73d13b4d02b.camel@HansenPartnership.com>
X-ClientProxiedBy: YT1PR01CA0085.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::24) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH1PR12MB9576:EE_
X-MS-Office365-Filtering-Correlation-Id: 36690524-d2f5-4aab-0931-08df30715b20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|261021121427099003|56012099006|4143699003|11063799006|18002099003|10067099003|261022105027099003|22082099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	Jj5Lt8INE5X5ulHClNJr6yafddncSELHAgNfPQns/XhSIMFDXSY+ceTPCiJyzKi+f/BbZGh92KTSVC6cSmUmCkdzO1r5Vaf64JMfpLvIIVdqHlookSqVf59W2++0QzmDLV05o4ZFIlSzhotrHrprsMLmxFpx3QU0rHaeriiZCrvADtdxgr09ipi0SP/bFwtttKzwe43YOh1BNWEhWuOI32mqXahG5JLxSUNzfWHivdPT/qKQziJgSCobafdMelRwT4ArnsYg3Hhce9weOSYYS21WWva4li0SYkD1UA8ujlCAmYtGJHgq9cS5Dq2IA8cri54szOB3yZWw/XKblSxPy111CGUgQIUgXEr1m7gnmqQtUfs7TotkSyDys4L/CTQTNOH+ylFuejHz8G0EOD675JCy9ZAkvji3mEqBceWJfArKhhkBfgFeoX3ZqxGnF4aSG9jjThHCTKtIVpvf+VHXKYjLNVw8sEOAnXgOrB3nn37hZA38uUhCnCPkCL+4wR1Bpk8RQlae7c2RMRWcWLegWYbUzN63nsXNDEAmyulKoAQCFl86UXoUq/5lQEtkjKkqMdIFyDrno0+G6EAkmskhNv7R0/I1DTAxBkrVn0snJ1IiYDGOusT1U0XNOs8/IiSvdeZv7Uo6yZJbK9itHUvms5Ku/ODvw+IoUm9O0ITM4Y4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(261021121427099003)(56012099006)(4143699003)(11063799006)(18002099003)(10067099003)(261022105027099003)(22082099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TklHWmdJbmdOeWx5V05WZlZCa1BtZ2dUWVJkaFIwVE9rRFh6d1VPMUdCTnNG?=
 =?utf-8?B?YW12ZVFKYSt1UDYwaEV0WnBROXBTMHNQaXJxL01xRTNCSnhxRm16VmxxWnM2?=
 =?utf-8?B?THV5TFllaVZiY2ZZN1kyV3dheW9GbVBqeC9KSVN3dSszbFc3QTZTdi9LaEpl?=
 =?utf-8?B?RjZsTjlMbUxnZlo1ak9QQ2cwcmQ4eWVuWlJrMUhYSmp0V0gwQ2d5TW9CWnEy?=
 =?utf-8?B?T1B3bEFDWnhQQmhTSGJYRGtMNG1lNEZVRm1QanEyOEV3NHlmYXlPdEx5WEcv?=
 =?utf-8?B?LzBmZlUzamhGL3MzWFB2VmVXdkhhMTVmNDVVRVNVbTExK2NWNDN3cVRYYW5s?=
 =?utf-8?B?MTd0a0dkdUppcE05dmd0c3E3Vk1qdFVrOWJVWk1uOEJXMklYbWxCY1NySEQ0?=
 =?utf-8?B?QmJOWlRMNC9qdFdTbTJqTUFrLzhkMGRXa1N6Y3ZLcnNseVNkZEl1d0lrV2xj?=
 =?utf-8?B?NTBZazBGdXA2VVhkWVdFazBHWWFTREV2K0xYbzdDRUlXWWl5ZEM4Q0RSdFZj?=
 =?utf-8?B?emV5aFVKSEdFS29vMkRqZ1VZUEhtQnFUcU9hcGt2aUVqRHl3N1dlSVBvS1dX?=
 =?utf-8?B?MzRSeG9DVjVQOFpKcjNCcnB0d21LVFJNbjBLSkZoNTVwb2MwZVZwM0UxQlJH?=
 =?utf-8?B?ejE5WGF0UlorMkdmUHBUTjRZeHU3aGZaNjRoZ2xYSlh5U0EvVjhBS2twQ05Z?=
 =?utf-8?B?YVp6MXRrd1Z4R3pYM2p1TVhsNUpDMi8wcUJ1a2ttWWdZZjFtYWw4eG4yOUY0?=
 =?utf-8?B?d3ZqZS9neHkycVphVEZsSDJ1SThKWUZ0WUY0K0U5bjFZbUZZY056akV5MUFW?=
 =?utf-8?B?cTdGQUhXa3VtYi9rZjFUdS9UQWtNb2t5cFRFT0VhWVZwaitQM1FsVUZGSSs3?=
 =?utf-8?B?WjRVejVQNmszUlVyOVBLR21MTW11U1ZhRDhIVXNWY01lNlVOaFBqWjdsL2hQ?=
 =?utf-8?B?cmd2R2pmNUJRMTV5VTFzaWljdm1DTFBHcGo5UEtkWmRJT1JBeGlUM3pZWFVy?=
 =?utf-8?B?bTZRUFVqMjcxeCtJMWtiZjlnM3g3OS9vUEpidENsb2QvTm8yTitzWXlqYlZF?=
 =?utf-8?B?Zk1Ba1pmSlZHUWdRaHhaV3BZek9tb2ljdVBaNGMwL0pBdTJsT2kzcG5KT01s?=
 =?utf-8?B?ZU9kL2NPeUZYK2ZUcGVDRE5SaGlaZjhyZFZtcDlHTlpWSXdXY0toWTVBOWVs?=
 =?utf-8?B?UDVOanJXbnF0UFNHU1ZxN2VPaXRrWDFrN0g1STQxc2k1MkwzcnFmekNUZWMr?=
 =?utf-8?B?NkYrTDRSL2xBMHY2QmNMeHlHQXNDWE5VV2FwWThzY2ZUWUUyMC90d0grTXE4?=
 =?utf-8?B?eGM1dFNMY1JERDdLdFJmNkZYUWRJbHRrOFl0Tmo4bXhVdzEzMjREZWpiTTND?=
 =?utf-8?B?eVV6ODA3VlhqcW1JUjZIK0hKTmNwbi82SGpVc2szTE11NGc0V1NYS1BFU3JL?=
 =?utf-8?B?TWV4bngrR1RsWE14eXExWWpzRkpBczJaKzFIWStaR0Q3cUpXcS84R3NLUkd4?=
 =?utf-8?B?eGo5V2J2U04rSld5VklxQ0gyeHdDaW9FaFQwOUFFdTdqYlRnV3hDNDVFSmZK?=
 =?utf-8?B?S2REVzd6RXFQYnh6ZkcxelV5T2VvekkvSTRBMXBLaGFreVdVcFRJTWFMcmJv?=
 =?utf-8?B?RzRJM3RDVTNnTVp0UUtiVmNiOFIvVUx5bkxjYW93ejFUTjZ0YVlXYWRBbTVx?=
 =?utf-8?B?eWpYdjI2cFc0N1hvSkxTWml5TVV0VFgvYzZNZ20zdFZFcEJpMWlyWHVKU1ZW?=
 =?utf-8?B?TzYxTGd5NkxrM3llZDV5dTRzcFZRS3RSaW1FaVVBOUpkOEY5c3pYOXNsVE9o?=
 =?utf-8?B?bTBGN09hNjlTbkdCb1lTdEg3T1JvQzhROHl2aGVrMWN1aWdQR0V1ZzBzb2JM?=
 =?utf-8?B?M1U4M2tNMXFWakN4NG5jdnBmbnVVK3JzcXVMZTJhdTFxRUkvc0M0dTlQTllZ?=
 =?utf-8?B?NndSblZCUmdIUlh1cGZEMUlqalYzd3pTbkVzREp1RUUxcHplMmNmNHMwTFRU?=
 =?utf-8?B?ZWpUNmRyYmwzTE95bzc4TC9tT3FSZDV4UkNBNTJXMlZnUVJGdFRzYThHek1L?=
 =?utf-8?B?d25BMkpxVnJCUW56RlhoaEgzS2RHendhUXBxVnUzaks1NnBOQW5yUFlZRThS?=
 =?utf-8?B?WTdsL2pGSnY4R1NXN2RsMTR1UmRyRGhacjZuWDdvYVFLV2dNaTE0YjZvNmx5?=
 =?utf-8?B?Y1U5NkxVdUpmUkFLRzBXWlhZaENGZXpXN1J5eWFnNnFQZ250QXR5K2JaYXRj?=
 =?utf-8?B?TzBqVVN6azdudTBhUHBOcmJEcmd5aWw2ekhHSkk0ZzRoTTZMTkRNaXlOcHlw?=
 =?utf-8?Q?lqnhB4e5luzmWCxwWC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36690524-d2f5-4aab-0931-08df30715b20
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 19:19:12.9141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f4yCsGG2NGlivkZB6XHagi9rRHaIl7aZERWtnNMoy/qmQNzK40MC5C48XVhULUhA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9576

On Thu, Oct 22, 2026 at 10:07:33AM -0400, James Bottomley wrote:
> On Thu, 2026-10-22 at 10:11 -0300, Jason Gunthorpe wrote:
> > On Thu, Oct 22, 2026 at 08:26:29AM -0400, James Bottomley wrote:
> > > On Wed, 2026-10-21 at 11:35 -0300, Jason Gunthorpe wrote:
> > > > Maybe we can build a multiplexed scheme on the spare? I don't
> > > > know.
> > > 
> > > Direct sharing of PCRs is certainly possible, but not in all
> > > circumstances. To share a log, each logging entity must record
> > > entries in such a way that the relying party can disentangle them
> > > with absolute certainty.  The problem with the latter is that both
> > > the TCG and the IMA log format have unmeasured (or advisory) log
> > > entries.  You can fool a relying party trying to disentangle a
> > > combined log simply by converting the advisory entry of one logging
> > > entity to being the advisory entry of another and bingo, it
> > > disappears from the other log.
> > 
> > My understanding was the unmeasured entries exist only to help the
> > verifier understand the log structure, and what data is in the
> > log. Like you might record a firmware version so that the verifier
> > can locate the reference measurement.
> > 
> > If they are corrupted somehow then the verifier should fail to
> > understand or reconstruct the log and fail the verification. 
> 
> That's true, but only if you know the entire log consists of your
> measurements.  Because you know, ipso facto, that you should be able to
> understand them all.

Yes, you cannot start processing any log entries whatsoever until they
have been verified by the Merkle tree calculations.

With a shared PCR the Merkle validation would have to be done in one
pass, with knowledge of how to put together all the shared logs.

For example, if we imagine a scheme where we create vPCRs then every
vPCR extend could have a common log bound to a RTMR of
something like:
 {extend vPCR #10 to hash XYZ}

The first verifier pass evaluates this log, confirms its merkle is OK
and ends up with current values for all the vPCRs. Then the individual
logs associated with the vPCR are merkled up just like a real TPM
would have done.

Advisory entries shouldn't matter with a scheme like this.

There are other ways to do this, but the general notion requires that
the log entries are, in some way, self describing so anyone can do the
Merkle calculation for them.

It doesn't work for sealing, but for remote verification systems it
seems like it might be something interesting for userspace to do?

Jason
