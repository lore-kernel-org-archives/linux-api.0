Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793023704;
	b=GMez/e+MvBuwydNE485SIEeq5fo/CzhUmcZhq7Bd/PrmfmlMffTW6x+K08TsYMltQgaa
	 RhoZjEkNAyP1PDMKGAC951BDXhAVq3aE9IawkysfZTuIRL5BiKh20t1NICYfmL9aAsi6w
	 XutilryWu7AvvxcbMn+OyxQEMkw8x3pr130Sg54mRQ1ld7AAoS+qLGGwzDCJZL3oqtwDq
	 9QjYor2pf/fDDibwk1sHJzu1MLNXjSe9VramsKqoBsvYWSEITnv59ejFhRU18tHwNpKRI
	 XGJjSh4AxTTLPu2Sj9v4Kfg0/qqJqa90REPRGYm0rWLHkfTdUuL8u/DTiPgvmudjoJg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793023704;
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
	bh=6LwOu0dfOUIgci3N9UeGaV0JbgtoJlEfgo8kW4WiCn0=;
	b=bdxd7iBHmbpGox2s7dCdoiUJOExLHfI1wqBeU1aGyHODY/1td4CAt2+yWCqFKYXi9aMg
	 VDjgzYkXVLuBJnh4hqQBlAh2tHOxMrj+gS//ZX5iQiBOoOt6ZK3tyzzeG2ao8aOYuw5tY
	 WTREd/HlHgWoqlj4GUdj+FVI/ZAyoAailaDMAqibzPUBlZuDQTHRa+4aY+adfFv45w/mt
	 F52pYa6iMd6zDCFAAi1xp7wbrmbiFF9mwIXD7CP7t+EnqoEicDs6gCOqmz5PMO1a62X0K
	 NRdL65wCyQMfeNQnAJWvOVvh6H5Po8b3cwKYXUUmF1DgWjDR1iYsedSYREhD9FJwQyA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=TQnEwSGp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.33
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010033.outbound.protection.outlook.com [52.101.201.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C66606A335;
	Mon, 26 Oct 2026 14:08:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46C66606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=TQnEwSGp
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y0z8u146hPkZIgeydoc9QE1cMzkDVZQJVR4OOHJwX1/cMhX8EpKVbmOaALHvZ37Ep3Qpfxldj/NKWy2e8LW4pqcVtX4r/YpdPIEhTADr9n9X6wkeIvjeiUHANJSvKh+yyuyq7dsMj0haLmt0Q1ni29uSe1ZD48VzePaoqW/DWOwCCeWABbuzjTibrxFXQv6SqIFCiusYhhR+RqfSP8a/aOoJdiaUdLvs9dE8aoMqMPSbWf/KojrZcHU10uQiUVIP2Ke1kwNLs0obVANmyPle608JElPvtsdM7MmfqMKpl9pe368R97qBDVfoHF8z3mcxYtwg6WLnnA77eYEW0SM2AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6LwOu0dfOUIgci3N9UeGaV0JbgtoJlEfgo8kW4WiCn0=;
 b=F9TmqL4qDZiQaE1XMetlQong8ABkoDLw+CWIkZaz0WnUIQu83CghOldHMC0abnoCKALNYloXYNvkLUeDT33dhFfX+IB36D702jmYN/gA4Q4KuWDBCjRya+3FkFwT5f6TjEPMaICvwjVX6M37FQE1/3b5VKgTYjj5WQFm3Lxy0DJ2pNRmwnwe77+o8ghnPrxukbQlmcXQqq5t1ZbTcmUpKFtNA4mnVCksMB9jG6W5rbfuq/MA/XWz/MKPCPDnDPc+waw6fFEHTWv9Bjz0cLM3Qcau/N67uJtlyWkaKiG6Ks4ozbInoUroB6xXq6yWlrb0IgiQ+tdRXXvCAz2bp/4wmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LwOu0dfOUIgci3N9UeGaV0JbgtoJlEfgo8kW4WiCn0=;
 b=TQnEwSGpZAF+H7pcIO6ECaQn6Mbz/F+1AT7E0TlAM1pBpErNKMFcjG8+aH5Z4gEDW+Z2jQGmoEJtdlOxBvoEnhefifQTdzbZn9nzCcTiUNb23KcZ2E5GIQkHcCAsMNbNCk7Z6rOh+qHUo4byXqIjAghY5nvPY1qfON5WJrUCzaJW0ZmTYx0yR0jsXGIc2sIyssNibarUk4wR4N8I+B/gNj0aNfiDuEfBWjJxmUG1j9+QE6OyOdLUmAwbG70V6v+A5G4JfRsEnSpOItwccH3Catt3ylZUdalSUWgaJQGfTOH91mXPvEjTy8Qu6+6+erC2F4YcaNz1abBEJnmOY4tSLQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM4PR12MB5961.namprd12.prod.outlook.com
 (2603:10b6:8:68::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 14:08:03 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 14:08:03 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH RFC 14/20] attestation: Add the base family
 specification and generated files
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
In-Reply-To: <20261015145053.3664509-15-jiri@resnulli.us>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-15-jiri@resnulli.us>
Date: Mon, 26 Oct 2026 11:07:54 -0300
Message-Id: <179302367452.58760.3782556786585774917.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: YT3PR01CA0076.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::19) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 6cd3a332-84fb-47a2-ad82-08df336a8bff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|260925022911599003|260925021911599003|260925021311599003|4143699003|56012099006|11063799006|5023799004|261009221227099003|261009220027099003|261009223027099003|261009223327099003|261009221727099003|261022105027099003|261022113327099003|261022075727099003|261021121427099003|261021123027099003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	OPX2KxuoOvHBSVZ3RmEzjAgdHnUILOWPPbdyLdzX+Vm/8zYpG7ad+Q6JTLGHa97GIE6gvHiYmbrPEVLn0UNnkUM74guA4E0KE34lxRU8mosuV9xhgVuKPW3TJi+ZE8hcsKJSxhraWzfIxp0L7fKad5/cgSlctQMFDDwc20nxBHp4LeqTffJvDrTTPDLx3+8mlg/tUnmiHNgGYr1JSevs4UkmoeyMslKsuQw67a703KNXl8ncRmZi47YAFo/L1QC1tU3+TKVBheL0UW8KwBi95YVpxlehpxCGXfp7qy0ES0Qk7LXbFfwJivF/DkKmXlVmNyjvBZGPP77008TadJJIekC+ycfMBdEoOiP7i0pAY2oRi3RdrbYkrXWwFrwmnej13+f0cNdlBazxx6Itb+gTj0mHOw9aT+lj/Bj8GGG6WtysOW5Fx5OrzGhaRf1fSZwlsh1W/diHLs20AK9/Nbr6eENLC5BmNrDsAuc8GK8fHGykg80M1Q9zzgLoKJOT7MeGOvhZ3BRT8bQTeBlr/AbOHvzogjUePrBI8z2s6bHVmJmLnj1ZATwQCatfkRvk+nnYYKqT4Wk5LFSZZFjPVQPx2J9yy8VW8+QNb0O8FO9n7Op7f/4hmh4gPaR2YISwewakgj6LQbx3GeZv4X++RaYgoHHiICSdJvkvRzr2tt0/1l8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(260925022911599003)(260925021911599003)(260925021311599003)(4143699003)(56012099006)(11063799006)(5023799004)(261009221227099003)(261009220027099003)(261009223027099003)(261009223327099003)(261009221727099003)(261022105027099003)(261022113327099003)(261022075727099003)(261021121427099003)(261021123027099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MlZkMGc4dWhhSWFhU0ZiTUdxRmJTY3ZHV0NkdFlPaUl4akV6NmxkejAwQ3FF?=
 =?utf-8?B?MiswMDZLeEVGT29hcWtsYjBwSnZTMUtHVG92V2o4MEllTnJJWUxtamZPWk1M?=
 =?utf-8?B?RDI3TzFmcHhkVmc1WUV0bU51TlFMeXk4OEdXb1FKYU1hQ3N2bTJxWFk1ZXU0?=
 =?utf-8?B?SitqRjJKUlVTRXhDbTZONmxUMElYZFZMMjl5WlkvNVhpYnhNRjhiNmxsREps?=
 =?utf-8?B?c0dSU2I2SXdCcnFrWE85V2dkS054L0xXYUJWZmpMMEJwV1hKZmhVdHNZZU5N?=
 =?utf-8?B?WEIxNjJjZEdmMlVnbExqQWRHR3FwalUzcm1LNDg4TVRkQ25Wc3dFaFRCam5X?=
 =?utf-8?B?TXVncnA2NTRsbkNFYlRnYXFpV3Y5U0MzWFZ2MGg0NFp5bkk3R2ZGMk5JMUMr?=
 =?utf-8?B?RDZTZ0szeUFYK2hBZEhFcjd1S3NHQ2UyQ3NHZXFwTzlpS2FsQU50MlVwSCtH?=
 =?utf-8?B?TnpBN0RPeUVGZlE3aW1KMnBxa3JpVGFnVVIyWEJsUTYwRWJOaHNXZ29wTDFS?=
 =?utf-8?B?amVidUVldlBEdFVFaEgycUpTSHFSS1BYN1pDbVlMbVdxazVDYUdWYnRWRWdW?=
 =?utf-8?B?aEQ1S0g1ZENSenRXN2pOaXowNVRmRTFlNHlrTzdYSWtRRXVzaEt1eFlHTXJa?=
 =?utf-8?B?YXBGSTNKdENWTFhHbzlLZ21ZVENxQkswUEoxU1laQTl6LzJLYnBoejdTcndN?=
 =?utf-8?B?dVNxbzVhTlZzTTM0R1pnVnRZS0tXVmhSb1Q2d2dVL0p6ZU9DelFwSXFJa0U5?=
 =?utf-8?B?Q1p2UU9QMEJITEZVVUFMNDJrNTE0WDlUQ3c1WkQvSEZxejJUVHNhUzNIUXlW?=
 =?utf-8?B?WG5VNlNLNS9nL1l2R2YvMFZBeEl5RkM5Z1JXTWY5ZkhaelJXbVZCSGRqUVFk?=
 =?utf-8?B?a2V5OHcrWFRGT2d6dlNWRHJGL2N5c0tYVEhubjdZVzdZalRpTGFuRVdKR1Vk?=
 =?utf-8?B?Q2U3YXBESGIyQWMvTmc2d3VPdkVhZG1oVUxVYm5NelMvREd2Vi9VOXpzOHdK?=
 =?utf-8?B?R0QvVmhYOEovbnZTQUJGQ3YyQVFiS3RQaTA3bU9YMDNndTR4Z1cvWFRYZ2VB?=
 =?utf-8?B?cVQ5Y0d0aENINldPS1RLYWkxVkt1WkRFYitLQUFEYytpeGtjdnNhcEl6UGpH?=
 =?utf-8?B?VVo2OVdieGowWXkyUnNETDRlcjFQQkk1U0dWWGNZSmF1d1VVNFZNTHQ4aExo?=
 =?utf-8?B?ZjdVQTB0dzJRS3JQZElyOWxXMWNGR1VORHhHZFdLTEc3bzl6STlPNUpKTzQw?=
 =?utf-8?B?V25acjVhR3FYdm5odzFvWDB4K0F4RWp0OHJFaFhlZEROck90amFYOGNlNHA0?=
 =?utf-8?B?anhEbDZpNExXSzA3MStlRDZ1bEtSUGIxWHB6NUN2Mk5mMkRxaTdubVVBa0Jx?=
 =?utf-8?B?STIrMmxZQlkzaVlaMGYzQVNMMk8zM1h6blFmZUxienVldFBRM2s5WXczK0kv?=
 =?utf-8?B?dmw5dEhiYTRnUUJ4eDF3N0RGZk9IL1A0ZzlmbEFCVkU2ci96TEpnQnJDT2p1?=
 =?utf-8?B?RUdmVnRsYjhuNE5CQlNZWVZhY0NPRzh5UXJXMEYwY0phc0kySXppb2pwM0s4?=
 =?utf-8?B?MGZkRS95Q0dEcFNYOUN2M2VicHlyV09HWWQ2dnRTLzFPc2RyMFR3NHFNVUJ2?=
 =?utf-8?B?eThIU3o2R3NTZEhQL0xlTGE3UkYwUE01ZUVKRVcydU5OTjg2ekI1NzE1L21X?=
 =?utf-8?B?QU1udzA4SkdnS1pGN1NUVFU5TDZkR2hJT1VkMmdxMjk4WmlaMU5SZFFlc2Uz?=
 =?utf-8?B?M3BuLzdxQUR5bUc1UUZQSlVQNmhSU3VwTElycEJPM3J3M3BUQXYxNjJVVXdP?=
 =?utf-8?B?ZWpUMGE4azFLNzJGaTl5QkJUb0U3eTlNVWhkNWZNdG4xaWNBTy9TU0xmT3Aw?=
 =?utf-8?B?ZHdCQnN2UUcxblNxZ3NEdzFHMHU5MVVXRWhIUUlhSXhTVmJ2dzNhSDVhcW1I?=
 =?utf-8?B?eGZzUm0wN25RMkdBcDlwbGpQMGNOeEdMckdpN0UrRklDMnZBVXYvaE9VOXBW?=
 =?utf-8?B?bFNGcVhSeUl5ZHlkdjY3akhFREd2cTRTMEswR0FkREs4aWlFemp4V2ZIV2Zs?=
 =?utf-8?B?TVdvdEtXcTNwaUFJb0tQMWtPTHlieTgwWXZqRlBUNHh3aDlpMkw3cEJseFhW?=
 =?utf-8?B?N2NscXFHUzc0LzZNcDArL2p1eVl1MHVPa2NrbnJSS2wrNnpXLy9lVUh2VnZk?=
 =?utf-8?B?RTdMVmU4TXhGaUo3b2tXN2hCY000VnVOVklpS01QdE9DclVTWUNyM0c1aGpV?=
 =?utf-8?B?MXN6ZXFjMUNiclNJYVJCM3N0NW9JVWJ2UzdYeGU1NmVIaWVtM1NicHFIWndr?=
 =?utf-8?Q?sez+ytzsxYL1GsxpXq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cd3a332-84fb-47a2-ad82-08df336a8bff
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 14:08:02.0245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KKMoql+UTcra3NzQ+ofRjN0J3S2Nl8RRf0nRE5Tau52lLSo9Pp96AtbdZjHMNH4V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5961

> Define the base attestation family. Reserve its family ID and add the ABI
> snapshot, registry entry and generated kernel and UAPI files.
> 
> The ABI is intentionally specification-first. The generated descriptor is
> linked after the provider, journal and operation handlers arrive.

This defines a complicated new uABI and not a single comment
explaining what it is or how it is meant to be used?

Documentation is possibly the most important part of this project
since it defines the actual uABI contract. Aside from the YAML being
unreadable, I'm not entirely sure what the intention is for some of
this stuff.

The cover letter should include a summary of the system calls being
introduced. There need to be structured comments and readable yaml
that clearly defines the systemcall contract itself, both in code and
in terms of purpose, usage, rules etc.

So, using AI to invert this to something organized in a operation
oriented way so I can try to follow it..

=======

device-get:
  request: {}
  reply:
    caps:
      evidence?:
        min-challenge-length: uint
        max-challenge-length: uint

Did anyone implement a variable length challenge? That seems a bit
strange. There is also a very important crypto warning here that the
userspace use of the challenge must not create a "signing oracle". Ie
do not pass naked network data into the challenge..
    
        max-total-output-length: uint

Is this the max sum of all the max-lengths below? What use is it?
Wouldn't userspace just be able to sum up all the below on its own?

        objects[]:
          blob-class: evidence-blob-class

An enum 'primary' ? Can't guess what it is for?

          format: string

The strings the kernel supports need to be documented in the uapi
describions, at least in comments.

          representation: evidence-representation

An enum 'raw'? Can't guess again.

          max-length: uint
      mr?:
        mr-flags: mr-device-caps
    info:
      $extend: device-info

=======

evidence-get:
  request:
    challenge: binary

Binary, blob, raw? Lots of words for the same idea here..

    objects[]:
      blob-class: evidence-blob-class
      format: string
      representation: evidence-representation
      data: output-blob
  reply:
    object-lengths[]: uint
    mr-generation?: uint

=======

mr-get:
  request:
    id: uint
  reply:
    name: string
    supported-hash-algorithms[]: uint

No definition what these numbers are. They should be TCG2 defined hash
algorithm constants I guess. Why not have an enum here for them?

    caps: mr-caps
    register-index?: uint

So we get a string and a small integer for every MR? Like PCR10 and 10
for TPM?

=======

mr-dump:
  request: {}
  reply:
    items[]:
      id: uint
      name: string
      supported-hash-algorithms[]: uint
      caps: mr-caps
      register-index?: uint


This returns all of the MRs at once?

=======

mr-read:
  request:
    id: uint
  reply:
    generation: uint
    values[]:
      hash-algo: uint
      data: binary

Get, dump and read? I don't get it

Should every operation be returning the string name and
register-index? This doesn't change, maybe the caps should just return
it for everyone once? Userspace needs it anyhow if you are going to
figure out what ID to use right?

=======

mr-extend:
  request:
    id: uint
    values[]:
      hash-algo: uint
      data: binary
  reply:
    generation: uint

Is this extend 'you give me an exactly sized data that is a hash' or
'you give me data and I hash it' ?

TPM/etc do both, there are good reasons to have both, and the latter
is more flexible in supporting crypto agility..

> [ ... 25 lines skipped ... ]
> +++ b/Documentation/ctlv/abi/ctlv-attestation.yaml
> @@ -0,0 +1,184 @@
> +# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
> +%YAML 1.2
> +---
> +# Checked-in ABI snapshot of the ctlv-attestation family, written by
> +# "make -C tools/ctlv abi-update".
> +#
> +# The checker compares this family's declarations and inherited stub fills
> +# against this file. Updating it is how a UAPI change gets reviewed; an update
> +# that removes or renumbers anything, narrows a bound, or makes a placement
> +# required is an ABI break, whatever this file says afterwards.

Have the generator emit a line showing the original yaml file this was
generated from?

> +family: {name: ctlv-attestation, id: 1, inherits: ctlv, post-init: true,
> +         pre-fini: true}
> +enums:
> +  evidence-representation: {raw: 1}
> +  evidence-blob-class: {primary: 1}
> +  mr-log-event: {info: 1, extend: 2}
> +flags:
> +  mr-device-caps: {read: 0, extend: 1}
> +  mr-caps: {read: 0, extend: 1}
> +attr-groups:
> +  device:
> +    id: 1
> +    attrs:
> +      generation: {id: 1, type: uint, max: 4294967295}
> +      caps: {id: 2, type: nested}
> +      info: {id: 3, type: nested}
> +  cap:
> +    id: 2
> +    attrs:
> +      evidence: {id: 1, type: nested}
> +      mr: {id: 2, type: nested}
> +      min-challenge-length: {id: 3, type: uint}
> +      max-challenge-length: {id: 4, type: uint}
> +      max-total-output-length: {id: 5, type: uint}
> +      mr-flags: {id: 6, flags: mr-device-caps}
> +      object: {id: 7, type: nested, max-occurrences: 16}
> +      blob-class: {id: 8, enum: evidence-blob-class}
> +      format: {id: 9, type: string, min-length: 1, max-length: 128}
> +      representation: {id: 10, enum: evidence-representation}
> +      max-length: {id: 11, type: uint}
> +  evidence:
> +    id: 3
> +    attrs:
> +      challenge: {id: 1, type: binary, max-length: 4096}
> +      object: {id: 2, type: nested, max-occurrences: 16}
> +      blob-class: {id: 3, enum: evidence-blob-class}
> +      format: {id: 4, type: string, min-length: 1, max-length: 128}
> +      representation: {id: 5, enum: evidence-representation}
> +      data: {id: 6, blob: output, backings: [va], max-length: 4294967295}
> +      object-length: {id: 7, type: uint, max-occurrences: 16}
> +  mr:
> +    id: 4
> +    attrs:
> +      id: {id: 1, type: uint, max: 4294967295}
> +      name: {id: 2, type: string, min-length: 1, max-length: 128}
> +      hash-algo: {id: 3, type: uint, max: 20}
> +      supported-hash-algo: {id: 4, type: uint, max: 20, max-occurrences: 21}
> +      register-index: {id: 5, type: uint, max: 4294967295}
> +      caps: {id: 6, flags: mr-caps}
> +      item: {id: 7, type: nested, max-occurrences: unlimited}
> +      value: {id: 8, type: nested, max-occurrences: 21}
> +      data: {id: 9, type: binary, min-length: 16, max-length: 64}
> +      generation: {id: 10, type: uint, max: 4294967295}
> +      selection: {id: 11, type: nested, max-occurrences: 256}
> +      start-generation: {id: 12, type: uint, max: 4294967295}
> +      end-generation: {id: 13, type: uint, max: 4294967295}
> +  log:
> +    id: 5
> +    attrs:
> +      entry: {id: 1, type: nested, max-occurrences: unlimited}
> +      event: {id: 2, enum: mr-log-event}
> +      mr: {id: 3, type: nested}
> +  notification:
> +    id: 6
> +    attrs:
> +      entry: {id: 1, type: nested}
> +attr-sets:
> +  device-info: {id: 1, stub: true}
> +  evidence-object-cap: {id: 2}
> +  evidence-cap: {id: 3}
> +  mr-device-cap: {id: 4}
> +  device-caps: {id: 5}
> +  device-reply: {id: 6}
> +  evidence-object-request: {id: 7}
> +  evidence-request: {id: 8}
> +  evidence-reply: {id: 9}
> +  mr-props: {id: 10}
> +  mr-dump-entry: {id: 11}
> +  mr-id-request: {id: 12}
> +  mr-read-request: {id: 13}
> +  mr-value: {id: 14}
> +  mr-read-reply: {id: 15}
> +  mr-extend-request: {id: 16}
> +  mr-change-reply: {id: 17}
> +  mr-log-info: {id: 18}
> +  mr-log-entry: {id: 19}
> +  mr-log-event: {id: 20}
> +  mr-log-selection: {id: 21}
> +  mr-log-request: {id: 22}
> +  mr-log-reply: {id: 23}
> +ops:
> +  device-get:
> +    abi: {id: 1, type: action, fd-access: read}
> +    reply:
> +      attrs:
> +        - device.caps:
> +            optional-attrs:
> +              - cap.evidence:
> +                  attrs:
> +                    - cap.min-challenge-length
> +                    - cap.max-challenge-length
> +                    - cap.max-total-output-length
> +                    - cap.object:
> +                        attrs: [cap.blob-class, cap.format, cap.representation,
> +                                cap.max-length]
> +              - cap.mr: {attrs: [cap.mr-flags]}
> +        - device.info: {attrs: [device-info]}
> +  evidence-get:
> +    abi: {id: 2, type: action, availability: dynamic, optional: true}
> +    request:
> +      attrs:
> +        - evidence.challenge
> +        - evidence.object:
> +            attrs: [evidence.blob-class, evidence.format,
> +                    evidence.representation, evidence.data]
> +    reply:
> +      attrs: [evidence.object-length]
> +      optional-attrs: [mr.generation]
> +  mr-get:
> +    abi: {id: 3, type: action, fd-access: read, optional: true}
> +    request: {attrs: [mr.id]}
> +    reply:
> +      attrs: [mr.name, mr.supported-hash-algo, mr.caps]
> +      optional-attrs: [mr.register-index]
> +  mr-dump:
> +    abi: {id: 4, type: query, fd-access: read, optional: true}
> +    reply:
> +      attrs:
> +        - mr.item:
> +            attrs: [mr.id, mr.name, mr.supported-hash-algo, mr.caps]
> +            optional-attrs: [mr.register-index]
> +  mr-read:
> +    abi: {id: 5, type: query, fd-access: read, optional: true}
> +    request: {attrs: [mr.id]}
> +    reply:
> +      attrs:
> +        - mr.generation
> +        - mr.value: {attrs: [mr.hash-algo, mr.data]}
> +  mr-extend:
> +    abi: {id: 6, type: action, optional: true}
> +    request:
> +      attrs:
> +        - mr.id
> +        - mr.value: {attrs: [mr.hash-algo, mr.data]}
> +    reply: {attrs: [mr.generation]}
> +  mr-log-entry-appended:
> +    abi: {id: 7, type: event}
> +    reply:
> +      attrs:
> +        - notification.entry:
> +            attrs: [mr.generation, mr.id, log.event]
> +            optional-attrs:
> +              - mr.value: {attrs: [mr.hash-algo, mr.data]}
> +              - log.mr:
> +                  attrs: [mr.name, mr.supported-hash-algo, mr.caps]
> +                  optional-attrs: [mr.register-index]
> +  mr-log-get:
> +    abi: {id: 8, type: query, fd-access: read, optional: true}
> +    request:
> +      optional-attrs:
> +        - mr.selection: {attrs: [mr.id]}
> +        - mr.start-generation
> +        - mr.end-generation
> +    reply:
> +      optional-attrs:
> +        - mr.start-generation
> +        - mr.end-generation
> +        - log.entry:
> +            attrs: [mr.generation, mr.id, log.event]
> +            optional-attrs:
> +              - mr.value: {attrs: [mr.hash-algo, mr.data]}
> +              - log.mr:
> +                  attrs: [mr.name, mr.supported-hash-algo, mr.caps]
> +                  optional-attrs: [mr.register-index]
> diff --git a/Documentation/ctlv/abi/families.registry.yaml b/Documentation/ctlv/abi/families.registry.yaml
> index 2c9b9e7eee15fc..fa511b709fc1c2 100644
> --- a/Documentation/ctlv/abi/families.registry.yaml
> +++ b/Documentation/ctlv/abi/families.registry.yaml
> @@ -5,3 +5,4 @@
>  # Updated deliberately by "make -C tools/ctlv abi-update".
>  families:
>    - ctlv
> +  - ctlv-attestation
> diff --git a/Documentation/ctlv/families.yaml b/Documentation/ctlv/families.yaml
> index bf1dabdba5c989..d78025a9072c88 100644
> --- a/Documentation/ctlv/families.yaml
> +++ b/Documentation/ctlv/families.yaml
> @@ -11,3 +11,4 @@
>  
>  families:
>    - ctlv
> +  - ctlv-attestation
> diff --git a/Documentation/ctlv/generated-files.yaml b/Documentation/ctlv/generated-files.yaml
> index 6773e0be0883e3..669f1f8d51b4b3 100644
> --- a/Documentation/ctlv/generated-files.yaml
> +++ b/Documentation/ctlv/generated-files.yaml
> @@ -15,3 +15,10 @@ families:
>        uapi-header: include/uapi/linux/ctlv_gen.h
>        kernel-header: include/linux/ctlv_gen.h
>        kernel-source: drivers/ctlv/ctlv_gen.c
> +
> +  - name: ctlv-attestation
> +    source: Documentation/ctlv/specs/ctlv-attestation.yaml
> +    outputs:
> +      uapi-header: include/uapi/linux/ctlv_attestation_gen.h
> +      kernel-header: drivers/attestation/generated/ctlv_attestation_gen.h
> +      kernel-source: drivers/attestation/generated/ctlv_attestation_gen.c
> diff --git a/Documentation/ctlv/specs/ctlv-attestation.yaml b/Documentation/ctlv/specs/ctlv-attestation.yaml
> new file mode 100644
> index 00000000000000..c0d7fc8db18ea0
> --- /dev/null
> +++ b/Documentation/ctlv/specs/ctlv-attestation.yaml
> @@ -0,0 +1,347 @@
> +# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
> +%YAML 1.2
> +---
> +family:
> +  name: ctlv-attestation
> +  inherits: ctlv
> +  post-init: true
> +  pre-fini: true
> +
> +enums:
> +  - name: evidence-representation
> +    values:
> +      - raw
> +
> +  - name: evidence-blob-class
> +    values:
> +      - primary
> +
> +  - name: mr-log-event
> +    values:
> +      - info
> +      - extend
> +
> +flags:
> +  - name: mr-device-caps
> +    values:
> +      - read
> +      - extend
> +
> +  - name: mr-caps
> +    values:
> +      - read
> +      - extend
> +
> +attr-groups:
> +  - name: device
> +    attrs:
> +      # Reserved until provider-driven state changes are introduced.
> +      - name: generation
> +        type: uint
> +        max: 4294967295
> +      - name: caps
> +        attrs: device-caps
> +      - name: info
> +        attrs: device-info
> +
> +  - name: cap
> +    attrs:
> +      - name: evidence
> +        attrs: evidence-cap
> +      - name: mr
> +        attrs: mr-device-cap
> +      - name: min-challenge-length
> +        type: uint
> +      - name: max-challenge-length
> +        type: uint
> +      - name: max-total-output-length
> +        type: uint
> +      - name: mr-flags
> +        flags: mr-device-caps
> +      - name: object
> +        attrs: evidence-object-cap
> +        max-occurrences: 16
> +      - name: blob-class
> +        enum: evidence-blob-class
> +      - name: format
> +        type: string
> +        min-length: 1
> +        max-length: 128
> +      - name: representation
> +        enum: evidence-representation
> +      - name: max-length
> +        type: uint
> +
> +  - name: evidence
> +    attrs:
> +      - name: challenge
> +        type: binary
> +        max-length: 4096
> +      - name: object
> +        attrs: evidence-object-request
> +        max-occurrences: 16
> +      - name: blob-class
> +        enum: evidence-blob-class
> +      - name: format
> +        type: string
> +        min-length: 1
> +        max-length: 128
> +      - name: representation
> +        enum: evidence-representation
> +      - name: data
> +        blob:
> +          direction: output
> +          allowed-backings: [ va ]
> +          max-length: 4294967295
> +          alignment: 1
> +      - name: object-length
> +        type: uint
> +        max-occurrences: 16
> +
> +  - name: mr
> +    attrs:
> +      - name: id
> +        type: uint
> +        max: 4294967295
> +      - name: name
> +        type: string
> +        min-length: 1
> +        max-length: 128
> +      - name: hash-algo
> +        type: uint
> +        max: 20
> +      - name: supported-hash-algo
> +        type: uint
> +        max: 20
> +        max-occurrences: 21
> +      - name: register-index
> +        type: uint
> +        max: 4294967295
> +      - name: caps
> +        flags: mr-caps
> +      - name: item
> +        attrs: mr-dump-entry
> +        max-occurrences: unlimited
> +      - name: value
> +        attrs: mr-value
> +        max-occurrences: 21
> +      - name: data
> +        type: binary
> +        min-length: 16
> +        max-length: 64
> +      - name: generation
> +        type: uint
> +        max: 4294967295
> +      - name: selection
> +        attrs: mr-log-selection
> +        max-occurrences: 256
> +      - name: start-generation
> +        type: uint
> +        max: 4294967295
> +      - name: end-generation
> +        type: uint
> +        max: 4294967295
> +
> +  - name: log
> +    attrs:
> +      - name: entry
> +        attrs: mr-log-entry
> +        max-occurrences: unlimited
> +      - name: event
> +        enum: mr-log-event
> +      - name: mr
> +        attrs: mr-log-info
> +
> +  - name: notification
> +    attrs:
> +      - name: entry
> +        attrs: mr-log-entry
> +
> +attr-sets:
> +  - name: device-info
> +    stub: true
> +
> +  - name: evidence-object-cap
> +    attrs:
> +      - cap.blob-class
> +      - cap.format
> +      - cap.representation
> +      - cap.max-length
> +
> +  - name: evidence-cap
> +    attrs:
> +      - cap.min-challenge-length
> +      - cap.max-challenge-length
> +      - cap.max-total-output-length
> +      - cap.object
> +
> +  - name: mr-device-cap
> +    attrs: cap.mr-flags
> +
> +  - name: device-caps
> +    optional-attrs:
> +      - cap.evidence
> +      - cap.mr
> +
> +  - name: device-reply
> +    attrs:
> +      - device.caps
> +      - device.info
> +
> +  - name: evidence-object-request
> +    attrs:
> +      - evidence.blob-class
> +      - evidence.format
> +      - evidence.representation
> +      - evidence.data
> +
> +  - name: evidence-request
> +    attrs:
> +      - evidence.challenge
> +      - evidence.object
> +
> +  - name: evidence-reply
> +    attrs: evidence.object-length
> +    optional-attrs:
> +      - mr.generation
> +
> +  - name: mr-props
> +    attrs:
> +      - mr.name
> +      - mr.supported-hash-algo
> +      - mr.caps
> +    optional-attrs: mr.register-index
> +
> +  - name: mr-dump-entry
> +    attrs:
> +      - mr.id
> +      - mr.name
> +      - mr.supported-hash-algo
> +      - mr.caps
> +    optional-attrs: mr.register-index
> +
> +  - name: mr-id-request
> +    attrs: mr.id
> +
> +  - name: mr-read-request
> +    attrs: mr.id
> +
> +  - name: mr-value
> +    attrs:
> +      - mr.hash-algo
> +      - mr.data
> +
> +  - name: mr-read-reply
> +    attrs:
> +      - mr.generation
> +      - mr.value
> +
> +  - name: mr-extend-request
> +    attrs:
> +      - mr.id
> +      - mr.value
> +
> +  - name: mr-change-reply
> +    attrs: mr.generation
> +
> +  - name: mr-log-info
> +    attrs:
> +      - mr.name
> +      - mr.supported-hash-algo
> +      - mr.caps
> +    optional-attrs: mr.register-index
> +
> +  - name: mr-log-entry
> +    attrs:
> +      - mr.generation
> +      - mr.id
> +      - log.event
> +    optional-attrs:
> +      - mr.value
> +      - log.mr
> +
> +  - name: mr-log-event
> +    attrs: notification.entry
> +
> +  - name: mr-log-selection
> +    attrs: mr.id
> +
> +  - name: mr-log-request
> +    optional-attrs:
> +      - mr.selection
> +      - mr.start-generation
> +      - mr.end-generation
> +
> +  - name: mr-log-reply
> +    optional-attrs:
> +      - mr.start-generation
> +      - mr.end-generation
> +      - log.entry
> +
> +ops:
> +  - name: device-get
> +    type: action
> +    fd-access: read
> +    reply:
> +      attrs: device-reply
> +
> +  - name: evidence-get
> +    type: action
> +    fd-access: read-write
> +    availability: dynamic
> +    optional: true
> +    request:
> +      attrs: evidence-request
> +    reply:
> +      attrs: evidence-reply
> +
> +  - name: mr-get
> +    type: action
> +    fd-access: read
> +    optional: true
> +    request:
> +      attrs: mr-id-request
> +    reply:
> +      attrs: mr-props
> +
> +  - name: mr-dump
> +    type: query
> +    fd-access: read
> +    optional: true
> +    reply:
> +      attrs: mr.item
> +    suggested-reply-length: 4096
> +
> +  - name: mr-read
> +    type: query
> +    fd-access: read
> +    optional: true
> +    request:
> +      attrs: mr-read-request
> +    reply:
> +      attrs: mr-read-reply
> +    suggested-reply-length: 4096
> +
> +  - name: mr-extend
> +    type: action
> +    fd-access: read-write
> +    optional: true
> +    request:
> +      attrs: mr-extend-request
> +    reply:
> +      attrs: mr-change-reply
> +
> +  - name: mr-log-entry-appended
> +    type: event
> +    reply:
> +      attrs: mr-log-event
> +
> +  - name: mr-log-get
> +    type: query
> +    fd-access: read
> +    optional: true
> +    request:
> +      attrs: mr-log-request
> +    reply:
> +      attrs: mr-log-reply
> +    suggested-reply-length: 131072
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d5d3c3bc2235ad..e3b3f69e17cce4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4331,6 +4331,15 @@ F:	rust/kernel/sync/atomic.rs
>  F:	rust/kernel/sync/atomic/
>  F:	rust/kernel/sync/refcount.rs
>  
> +ATTESTATION SUBSYSTEM
> +M:	Jiri Pirko <jiri@nvidia.com>
> +L:	linux-security-module@vger.kernel.org
> +S:	Supported
> +F:	Documentation/ctlv/abi/ctlv-attestation*
> +F:	Documentation/ctlv/specs/ctlv-attestation*
> +F:	drivers/attestation/
> +F:	include/uapi/linux/ctlv_attestation*
> +
>  ATTO EXPRESSSAS SAS/SATA RAID SCSI DRIVER
>  M:	Bradley Grove <linuxdrivers@attotech.com>
>  L:	linux-scsi@vger.kernel.org
> diff --git a/drivers/attestation/generated/ctlv_attestation_gen.c b/drivers/attestation/generated/ctlv_attestation_gen.c
> new file mode 100644
> index 00000000000000..c9fbeae00e3852
> --- /dev/null
> +++ b/drivers/attestation/generated/ctlv_attestation_gen.c
> @@ -0,0 +1,234 @@
> +// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
> +/* Do not edit, regenerate with tools/ctlv/ctlv-regen.sh, from: */
> +/*	Documentation/ctlv/specs/ctlv-attestation.yaml */
> +/* CTLV-GEN kernel source */
> +
> +#define _CTLV_GENERATED_METADATA_ONLY
> +#include <linux/array_size.h>
> +#include <linux/bits.h>
> +#include <linux/build_bug.h>
> +#include <linux/ctlv_family.h>
> +#include <linux/export.h>
> +#include <linux/limits.h>
> +
> +#include <uapi/linux/ctlv_gen.h>
> +#include <uapi/linux/ctlv_attestation_gen.h>
> +
> +#include "ctlv_attestation_gen.h"
> +
> +static const struct ctlv_node_schema device_get_request_node_schemas[] = {
> +	CTLV_NODE_SCHEMA_ROOT(0, 0, 0),
> +};
> +
> +static const struct ctlv_node_schema device_get_reply_node_schemas[] = {
> +	CTLV_NODE_SCHEMA_ROOT(1, 2, 2),
> +	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_DEVICE_CAPS, 1, 3, 2, 0),
> +	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_DEVICE_INFO, 1, 0, 0, 0),
> +	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_CAP_EVIDENCE, 1, 5, 4, 4),
> +	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_CAP_MR, 1, 9, 1, 1),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_CAP_MIN_CHALLENGE_LENGTH, 1, 0, U64_MAX),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_CAP_MAX_CHALLENGE_LENGTH, 1, 0, U64_MAX),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_CAP_MAX_TOTAL_OUTPUT_LENGTH, 1, 0, U64_MAX),
> +	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_CAP_OBJECT, 16, 10, 4, 4),
> +	CTLV_NODE_SCHEMA_FLAGS(CTLV_ATTESTATION_ATTR_CAP_MR_FLAGS, 1,
> +			       CTLV_ATTESTATION_MR_DEVICE_CAPS_MASK),
> +	CTLV_NODE_SCHEMA_ENUM(CTLV_ATTESTATION_ATTR_CAP_BLOB_CLASS, 1, 1),
> +	CTLV_NODE_SCHEMA_STRING(CTLV_ATTESTATION_ATTR_CAP_FORMAT, 1, 1, 128),
> +	CTLV_NODE_SCHEMA_ENUM(CTLV_ATTESTATION_ATTR_CAP_REPRESENTATION, 1, 1),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_CAP_MAX_LENGTH, 1, 0, U64_MAX),
> +};
> +
> +/* Extension points selected by this tree. */
> +static const struct ctlv_stub_schema device_get_reply_stub_schemas[] = {
> +	CTLV_STUB_SCHEMA(CTLV_FAMILY_ATTESTATION, CTLV_ATTESTATION_SET_DEVICE_INFO, 2),
> +};
> +
> +static const struct ctlv_node_schema evidence_get_request_node_schemas[] = {
> +	CTLV_NODE_SCHEMA_ROOT(1, 2, 2),
> +	CTLV_NODE_SCHEMA_BINARY(CTLV_ATTESTATION_ATTR_EVIDENCE_CHALLENGE, 1, 0, 4096),
> +	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_EVIDENCE_OBJECT, 16, 3, 4, 4),
> +	CTLV_NODE_SCHEMA_ENUM(CTLV_ATTESTATION_ATTR_EVIDENCE_BLOB_CLASS, 1, 1),
> +	CTLV_NODE_SCHEMA_STRING(CTLV_ATTESTATION_ATTR_EVIDENCE_FORMAT, 1, 1, 128),
> +	CTLV_NODE_SCHEMA_ENUM(CTLV_ATTESTATION_ATTR_EVIDENCE_REPRESENTATION, 1, 1),
> +	CTLV_NODE_SCHEMA_BLOB(CTLV_ATTESTATION_ATTR_EVIDENCE_DATA, 1, U32_MAX, 1,
> +			      BIT(CTLV_BLOB_TYPE_VA),
> +			      CTLV_BLOB_DIRECTION_OUTPUT),
> +};
> +
> +static const struct ctlv_node_schema evidence_get_reply_node_schemas[] = {
> +	CTLV_NODE_SCHEMA_ROOT(1, 2, 1),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_EVIDENCE_OBJECT_LENGTH, 16, 0, U64_MAX),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_GENERATION, 1, 0, U32_MAX),
> +};
> +
> +static const struct ctlv_node_schema mr_get_request_node_schemas[] = {
> +	CTLV_NODE_SCHEMA_ROOT(1, 1, 1),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_ID, 1, 0, U32_MAX),
> +};
> +
> +static const struct ctlv_node_schema mr_get_reply_node_schemas[] = {
> +	CTLV_NODE_SCHEMA_ROOT(1, 4, 3),
> +	CTLV_NODE_SCHEMA_STRING(CTLV_ATTESTATION_ATTR_MR_NAME, 1, 1, 128),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_SUPPORTED_HASH_ALGO, 21, 0, 20),
> +	CTLV_NODE_SCHEMA_FLAGS(CTLV_ATTESTATION_ATTR_MR_CAPS, 1, CTLV_ATTESTATION_MR_CAPS_MASK),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_REGISTER_INDEX, 1, 0, U32_MAX),
> +};
> +
> +static const struct ctlv_node_schema mr_dump_request_node_schemas[] = {
> +	CTLV_NODE_SCHEMA_ROOT(0, 0, 0),
> +};
> +
> +static const struct ctlv_node_schema mr_dump_reply_node_schemas[] = {
> +	CTLV_NODE_SCHEMA_ROOT(1, 1, 1),
> +	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_MR_ITEM, CTLV_NODE_SCHEMA_UNLIMITED, 2, 5, 4),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_ID, 1, 0, U32_MAX),
> +	CTLV_NODE_SCHEMA_STRING(CTLV_ATTESTATION_ATTR_MR_NAME, 1, 1, 128),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_SUPPORTED_HASH_ALGO, 21, 0, 20),
> +	CTLV_NODE_SCHEMA_FLAGS(CTLV_ATTESTATION_ATTR_MR_CAPS, 1, CTLV_ATTESTATION_MR_CAPS_MASK),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_REGISTER_INDEX, 1, 0, U32_MAX),
> +};
> +
> +static const struct ctlv_node_schema mr_read_request_node_schemas[] = {
> +	CTLV_NODE_SCHEMA_ROOT(1, 1, 1),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_ID, 1, 0, U32_MAX),
> +};
> +
> +static const struct ctlv_node_schema mr_read_reply_node_schemas[] = {
> +	CTLV_NODE_SCHEMA_ROOT(1, 2, 2),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_GENERATION, 1, 0, U32_MAX),
> +	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_MR_VALUE, 21, 3, 2, 2),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_HASH_ALGO, 1, 0, 20),
> +	CTLV_NODE_SCHEMA_BINARY(CTLV_ATTESTATION_ATTR_MR_DATA, 1, 16, 64),
> +};
> +
> +static const struct ctlv_node_schema mr_extend_request_node_schemas[] = {
> +	CTLV_NODE_SCHEMA_ROOT(1, 2, 2),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_ID, 1, 0, U32_MAX),
> +	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_MR_VALUE, 21, 3, 2, 2),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_HASH_ALGO, 1, 0, 20),
> +	CTLV_NODE_SCHEMA_BINARY(CTLV_ATTESTATION_ATTR_MR_DATA, 1, 16, 64),
> +};
> +
> +static const struct ctlv_node_schema mr_extend_reply_node_schemas[] = {
> +	CTLV_NODE_SCHEMA_ROOT(1, 1, 1),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_GENERATION, 1, 0, U32_MAX),
> +};
> +
> +static const struct ctlv_node_schema mr_log_entry_appended_reply_node_schemas[] = {
> +	CTLV_NODE_SCHEMA_ROOT(1, 1, 1),
> +	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_NOTIFICATION_ENTRY, 1, 2, 5, 3),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_GENERATION, 1, 0, U32_MAX),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_ID, 1, 0, U32_MAX),
> +	CTLV_NODE_SCHEMA_ENUM(CTLV_ATTESTATION_ATTR_LOG_EVENT, 1, 2),
> +	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_MR_VALUE, 21, 7, 2, 2),
> +	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_LOG_MR, 1, 9, 4, 3),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_HASH_ALGO, 1, 0, 20),
> +	CTLV_NODE_SCHEMA_BINARY(CTLV_ATTESTATION_ATTR_MR_DATA, 1, 16, 64),
> +	CTLV_NODE_SCHEMA_STRING(CTLV_ATTESTATION_ATTR_MR_NAME, 1, 1, 128),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_SUPPORTED_HASH_ALGO, 21, 0, 20),
> +	CTLV_NODE_SCHEMA_FLAGS(CTLV_ATTESTATION_ATTR_MR_CAPS, 1, CTLV_ATTESTATION_MR_CAPS_MASK),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_REGISTER_INDEX, 1, 0, U32_MAX),
> +};
> +
> +static const struct ctlv_node_schema mr_log_get_request_node_schemas[] = {
> +	CTLV_NODE_SCHEMA_ROOT(1, 3, 0),
> +	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_MR_SELECTION, 256, 4, 1, 1),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_START_GENERATION, 1, 0, U32_MAX),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_END_GENERATION, 1, 0, U32_MAX),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_ID, 1, 0, U32_MAX),
> +};
> +
> +static const struct ctlv_node_schema mr_log_get_reply_node_schemas[] = {
> +	CTLV_NODE_SCHEMA_ROOT(1, 3, 0),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_START_GENERATION, 1, 0, U32_MAX),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_END_GENERATION, 1, 0, U32_MAX),
> +	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_LOG_ENTRY, CTLV_NODE_SCHEMA_UNLIMITED, 4, 5, 3),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_GENERATION, 1, 0, U32_MAX),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_ID, 1, 0, U32_MAX),
> +	CTLV_NODE_SCHEMA_ENUM(CTLV_ATTESTATION_ATTR_LOG_EVENT, 1, 2),
> +	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_MR_VALUE, 21, 9, 2, 2),
> +	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_LOG_MR, 1, 11, 4, 3),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_HASH_ALGO, 1, 0, 20),
> +	CTLV_NODE_SCHEMA_BINARY(CTLV_ATTESTATION_ATTR_MR_DATA, 1, 16, 64),
> +	CTLV_NODE_SCHEMA_STRING(CTLV_ATTESTATION_ATTR_MR_NAME, 1, 1, 128),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_SUPPORTED_HASH_ALGO, 21, 0, 20),
> +	CTLV_NODE_SCHEMA_FLAGS(CTLV_ATTESTATION_ATTR_MR_CAPS, 1, CTLV_ATTESTATION_MR_CAPS_MASK),
> +	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_MR_REGISTER_INDEX, 1, 0, U32_MAX),
> +};
> +
> +/* The ops this family declares, in declaration order. */
> +const struct ctlv_op_schema ctlv_attestation_op_schemas[] = {
> +	CTLV_OP_SCHEMA_ACTION(CTLV_ATTESTATION_OP_DEVICE_GET, CTLV_OP_FD_ACCESS_READ,
> +			      CTLV_OP_AVAILABILITY_FIXED, 16, 4016,
> +			      CTLV_SCHEMA_TREE(device_get_request),
> +			      CTLV_SCHEMA_TREE_STUBS(device_get_reply)),
> +	CTLV_OP_SCHEMA_ACTION(CTLV_ATTESTATION_OP_EVIDENCE_GET, CTLV_OP_FD_ACCESS_READ_WRITE,
> +			      CTLV_OP_AVAILABILITY_DYNAMIC, 8992, 424,
> +			      CTLV_SCHEMA_TREE(evidence_get_request),
> +			      CTLV_SCHEMA_TREE(evidence_get_reply), .optional = true),
> +	CTLV_OP_SCHEMA_ACTION(CTLV_ATTESTATION_OP_MR_GET, CTLV_OP_FD_ACCESS_READ,
> +			      CTLV_OP_AVAILABILITY_FIXED, 40, 720, CTLV_SCHEMA_TREE(mr_get_request),
> +			      CTLV_SCHEMA_TREE(mr_get_reply), .optional = true),
> +	CTLV_OP_SCHEMA_QUERY(CTLV_ATTESTATION_OP_MR_DUMP, CTLV_OP_FD_ACCESS_READ,
> +			     CTLV_OP_AVAILABILITY_FIXED, 16, 184, 4096,
> +			     CTLV_SCHEMA_TREE(mr_dump_request), CTLV_SCHEMA_TREE(mr_dump_reply),
> +			     .optional = true),
> +	CTLV_OP_SCHEMA_QUERY(CTLV_ATTESTATION_OP_MR_READ, CTLV_OP_FD_ACCESS_READ,
> +			     CTLV_OP_AVAILABILITY_FIXED, 40, 112, 4096,
> +			     CTLV_SCHEMA_TREE(mr_read_request), CTLV_SCHEMA_TREE(mr_read_reply),
> +			     .optional = true),
> +	CTLV_OP_SCHEMA_ACTION(CTLV_ATTESTATION_OP_MR_EXTEND, CTLV_OP_FD_ACCESS_READ_WRITE,
> +			      CTLV_OP_AVAILABILITY_FIXED, 2560, 40,
> +			      CTLV_SCHEMA_TREE(mr_extend_request),
> +			      CTLV_SCHEMA_TREE(mr_extend_reply), .optional = true),
> +	CTLV_OP_SCHEMA_EVENT(CTLV_ATTESTATION_OP_MR_LOG_ENTRY_APPENDED, 3368,
> +			     CTLV_SCHEMA_TREE(mr_log_entry_appended_reply)),
> +	CTLV_OP_SCHEMA_QUERY(CTLV_ATTESTATION_OP_MR_LOG_GET, CTLV_OP_FD_ACCESS_READ,
> +			     CTLV_OP_AVAILABILITY_FIXED, 10304, 200, 131072,
> +			     CTLV_SCHEMA_TREE(mr_log_get_request),
> +			     CTLV_SCHEMA_TREE(mr_log_get_reply), .optional = true),
> +};
> +
> +/* The family ID is its position in the central registry. */
> +const struct ctlv_family_schema ctlv_attestation_schema = {
> +	.name = "ctlv-attestation",
> +	.family_id = 1,
> +	.ops = ctlv_attestation_op_schemas,
> +	.ops_count = ARRAY_SIZE(ctlv_attestation_op_schemas),
> +};
> +
> +/* Maximum uevent cost for this family chain. */
> +static_assert(107 <= CTLV_UEVENT_MAX_LEN);
> +static_assert(4 <= CTLV_UEVENT_MAX_VARS);
> +
> +/* Guards for generated maxima. */
> +static_assert(131072 <= CTLV_MAX_INLINE_MESSAGE_LEN);
> +static_assert(3368 <= CTLV_MAX_EVENT_QUEUE_LEN);
> +static_assert(3 <= CTLV_MAX_DECLARED_NEST_DEPTH);
> +
> +/* Local action and query bindings in declaration order. */
> +static const struct ctlv_op ctlv_attestation_ops[] = {
> +	CTLV_OP_ACTION(ctlv_attestation_device_get),
> +	CTLV_OP_ACTION(ctlv_attestation_evidence_get),
> +	CTLV_OP_ACTION(ctlv_attestation_mr_get),
> +	CTLV_OP_QUERY(ctlv_attestation_mr_dump),
> +	CTLV_OP_QUERY(ctlv_attestation_mr_read),
> +	CTLV_OP_ACTION(ctlv_attestation_mr_extend),
> +	CTLV_OP_QUERY(ctlv_attestation_mr_log_get),
> +};
> +
> +/* Family descriptor used by ctlv_create(). */
> +const struct ctlv_family ctlv_attestation_family = {
> +	.schema = &ctlv_attestation_schema,
> +	.parent = &ctlv_family,
> +	.ops = ctlv_attestation_ops,
> +	.ops_count = ARRAY_SIZE(ctlv_attestation_ops),
> +	.pre = ctlv_attestation_op_pre,
> +	.post = ctlv_attestation_op_post,
> +	.priv_size = ctlv_attestation_priv_size,
> +	.init = ctlv_attestation_init,
> +	.post_init = ctlv_attestation_post_init,
> +	.pre_fini = ctlv_attestation_pre_fini,
> +	.fini = ctlv_attestation_fini,
> +};
> +EXPORT_SYMBOL_NS_GPL(ctlv_attestation_family, "CTLV");
> diff --git a/drivers/attestation/generated/ctlv_attestation_gen.h b/drivers/attestation/generated/ctlv_attestation_gen.h
> new file mode 100644
> index 00000000000000..a40ed0757756b1
> --- /dev/null
> +++ b/drivers/attestation/generated/ctlv_attestation_gen.h
> @@ -0,0 +1,198 @@
> +/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
> +/* Do not edit, regenerate with tools/ctlv/ctlv-regen.sh, from: */
> +/*	Documentation/ctlv/specs/ctlv-attestation.yaml */
> +/* CTLV-GEN kernel header */
> +
> +/* Kernel metadata and family API of the ctlv-attestation CTLV family. */
> +
> +#ifndef _LINUX_CTLV_ATTESTATION_GEN_H
> +#define _LINUX_CTLV_ATTESTATION_GEN_H
> +
> +#include <linux/ctlv_family.h>
> +#include <linux/err.h>
> +#include <linux/errno.h>
> +
> +#include <uapi/linux/ctlv_attestation_gen.h>
> +
> +/* Ops this family declares, in declaration order. */
> +extern const struct ctlv_op_schema ctlv_attestation_op_schemas[];
> +
> +extern const struct ctlv_family_schema ctlv_attestation_schema;
> +
> +/* Implemented by this family, one per action and query it declares. */
> +int ctlv_attestation_device_get_action(void *priv, struct ctlv_op_ctx *ctx,
> +				       const struct ctlv_cursor *request,
> +				       struct ctlv_cursor *reply);
> +int ctlv_attestation_evidence_get_action(void *priv, struct ctlv_op_ctx *ctx,
> +					 const struct ctlv_cursor *request,
> +					 struct ctlv_cursor *reply);
> +int ctlv_attestation_mr_get_action(void *priv, struct ctlv_op_ctx *ctx,
> +				   const struct ctlv_cursor *request, struct ctlv_cursor *reply);
> +int ctlv_attestation_mr_dump_query(void *priv, struct ctlv_op_ctx *ctx,
> +				   const struct ctlv_cursor *request, struct ctlv_cursor *reply);
> +int ctlv_attestation_mr_read_query(void *priv, struct ctlv_op_ctx *ctx,
> +				   const struct ctlv_cursor *request, struct ctlv_cursor *reply);
> +int ctlv_attestation_mr_extend_action(void *priv, struct ctlv_op_ctx *ctx,
> +				      const struct ctlv_cursor *request, struct ctlv_cursor *reply);
> +int ctlv_attestation_mr_log_get_query(void *priv, struct ctlv_op_ctx *ctx,
> +				      const struct ctlv_cursor *request, struct ctlv_cursor *reply);
> +
> +/* Family-wide hooks around every effective non-core op. */
> +int ctlv_attestation_op_pre(void *priv, struct ctlv_op_ctx *ctx);
> +void ctlv_attestation_op_post(void *priv, struct ctlv_op_ctx *ctx);
> +
> +/* Core-allocated family priv lifecycle. */
> +size_t ctlv_attestation_priv_size(void);
> +int ctlv_attestation_init(struct ctlv_device *ctlvdev, const void *init_info, void *priv);
> +int ctlv_attestation_post_init(struct ctlv_device *ctlvdev, void *priv);
> +void ctlv_attestation_pre_fini(struct ctlv_device *ctlvdev, void *priv);
> +void ctlv_attestation_fini(struct ctlv_device *ctlvdev, void *priv);
> +
> +extern const struct ctlv_family ctlv_attestation_family;
> +
> +#ifndef _CTLV_GENERATED_METADATA_ONLY
> +
> +/* Optional publication and dynamic availability helpers. */
> +CTLV_OP_PROVIDE(ctlv_attestation_evidence_get, CTLV_ATTESTATION_OP_EVIDENCE_GET)
> +CTLV_OP_ENABLE(ctlv_attestation_evidence_get, CTLV_ATTESTATION_OP_EVIDENCE_GET)
> +CTLV_OP_DISABLE(ctlv_attestation_evidence_get, CTLV_ATTESTATION_OP_EVIDENCE_GET)
> +CTLV_OP_PROVIDE(ctlv_attestation_mr_get, CTLV_ATTESTATION_OP_MR_GET)
> +CTLV_OP_PROVIDE(ctlv_attestation_mr_dump, CTLV_ATTESTATION_OP_MR_DUMP)
> +CTLV_OP_PROVIDE(ctlv_attestation_mr_read, CTLV_ATTESTATION_OP_MR_READ)
> +CTLV_OP_PROVIDE(ctlv_attestation_mr_extend, CTLV_ATTESTATION_OP_MR_EXTEND)
> +CTLV_OP_PROVIDE(ctlv_attestation_mr_log_get, CTLV_ATTESTATION_OP_MR_LOG_GET)
> +
> +/* Reading a validated message. A blob has a resolver instead of a getter. */
> +CTLV_IN_REF(ctlv_attestation_evidence_get_evidence_challenge,
> +	    &ctlv_attestation_op_schemas[1].request, CTLV_ATTESTATION_ATTR_EVIDENCE_CHALLENGE, 0, 0,
> +	    CTLV_SCHEMA_BINARY)
> +CTLV_IN_HAS(ctlv_attestation_evidence_get_evidence_challenge)
> +CTLV_IN_BINARY(ctlv_attestation_evidence_get_evidence_challenge)
> +CTLV_IN_REF(ctlv_attestation_evidence_get_evidence_object, &ctlv_attestation_op_schemas[1].request,
> +	    CTLV_ATTESTATION_ATTR_EVIDENCE_OBJECT, 0, 1, CTLV_SCHEMA_NEST)
> +#define ctlv_attestation_evidence_get_evidence_object_for_each(_attr, _nest) \
> +	CTLV_IN_FOR_EACH(ctlv_attestation_evidence_get_evidence_object, _attr, _nest)
> +CTLV_IN_REF(ctlv_attestation_evidence_get_object_evidence_blob_class,
> +	    &ctlv_attestation_op_schemas[1].request, CTLV_ATTESTATION_ATTR_EVIDENCE_BLOB_CLASS, 2,
> +	    0, CTLV_SCHEMA_ENUM)
> +CTLV_IN_HAS(ctlv_attestation_evidence_get_object_evidence_blob_class)
> +CTLV_IN_U64(ctlv_attestation_evidence_get_object_evidence_blob_class)
> +CTLV_IN_REF(ctlv_attestation_evidence_get_object_evidence_format,
> +	    &ctlv_attestation_op_schemas[1].request, CTLV_ATTESTATION_ATTR_EVIDENCE_FORMAT, 2, 1,
> +	    CTLV_SCHEMA_STRING)
> +CTLV_IN_HAS(ctlv_attestation_evidence_get_object_evidence_format)
> +CTLV_IN_STRING(ctlv_attestation_evidence_get_object_evidence_format)
> +CTLV_IN_REF(ctlv_attestation_evidence_get_object_evidence_representation,
> +	    &ctlv_attestation_op_schemas[1].request, CTLV_ATTESTATION_ATTR_EVIDENCE_REPRESENTATION,
> +	    2, 2, CTLV_SCHEMA_ENUM)
> +CTLV_IN_HAS(ctlv_attestation_evidence_get_object_evidence_representation)
> +CTLV_IN_U64(ctlv_attestation_evidence_get_object_evidence_representation)
> +CTLV_IN_REF(ctlv_attestation_evidence_get_object_evidence_data,
> +	    &ctlv_attestation_op_schemas[1].request, CTLV_ATTESTATION_ATTR_EVIDENCE_DATA, 2, 3,
> +	    CTLV_SCHEMA_BLOB)
> +CTLV_IN_HAS(ctlv_attestation_evidence_get_object_evidence_data)
> +CTLV_IN_BLOB(ctlv_attestation_evidence_get_object_evidence_data)
> +CTLV_IN_REF(ctlv_attestation_mr_get_mr_id, &ctlv_attestation_op_schemas[2].request,
> +	    CTLV_ATTESTATION_ATTR_MR_ID, 0, 0, CTLV_SCHEMA_UINT)
> +CTLV_IN_HAS(ctlv_attestation_mr_get_mr_id)
> +CTLV_IN_U64(ctlv_attestation_mr_get_mr_id)
> +CTLV_IN_REF(ctlv_attestation_mr_read_mr_id, &ctlv_attestation_op_schemas[4].request,
> +	    CTLV_ATTESTATION_ATTR_MR_ID, 0, 0, CTLV_SCHEMA_UINT)
> +CTLV_IN_HAS(ctlv_attestation_mr_read_mr_id)
> +CTLV_IN_U64(ctlv_attestation_mr_read_mr_id)
> +CTLV_IN_REF(ctlv_attestation_mr_extend_mr_id, &ctlv_attestation_op_schemas[5].request,
> +	    CTLV_ATTESTATION_ATTR_MR_ID, 0, 0, CTLV_SCHEMA_UINT)
> +CTLV_IN_HAS(ctlv_attestation_mr_extend_mr_id)
> +CTLV_IN_U64(ctlv_attestation_mr_extend_mr_id)
> +CTLV_IN_REF(ctlv_attestation_mr_extend_mr_value, &ctlv_attestation_op_schemas[5].request,
> +	    CTLV_ATTESTATION_ATTR_MR_VALUE, 0, 1, CTLV_SCHEMA_NEST)
> +#define ctlv_attestation_mr_extend_mr_value_for_each(_attr, _nest) \
> +	CTLV_IN_FOR_EACH(ctlv_attestation_mr_extend_mr_value, _attr, _nest)
> +CTLV_IN_REF(ctlv_attestation_mr_extend_value_mr_hash_algo, &ctlv_attestation_op_schemas[5].request,
> +	    CTLV_ATTESTATION_ATTR_MR_HASH_ALGO, 2, 0, CTLV_SCHEMA_UINT)
> +CTLV_IN_HAS(ctlv_attestation_mr_extend_value_mr_hash_algo)
> +CTLV_IN_U64(ctlv_attestation_mr_extend_value_mr_hash_algo)
> +CTLV_IN_REF(ctlv_attestation_mr_extend_value_mr_data, &ctlv_attestation_op_schemas[5].request,
> +	    CTLV_ATTESTATION_ATTR_MR_DATA, 2, 1, CTLV_SCHEMA_BINARY)
> +CTLV_IN_HAS(ctlv_attestation_mr_extend_value_mr_data)
> +CTLV_IN_BINARY(ctlv_attestation_mr_extend_value_mr_data)
> +CTLV_IN_REF(ctlv_attestation_mr_log_get_mr_selection, &ctlv_attestation_op_schemas[7].request,
> +	    CTLV_ATTESTATION_ATTR_MR_SELECTION, 0, 0, CTLV_SCHEMA_NEST)
> +#define ctlv_attestation_mr_log_get_mr_selection_for_each(_attr, _nest) \
> +	CTLV_IN_FOR_EACH(ctlv_attestation_mr_log_get_mr_selection, _attr, _nest)
> +CTLV_IN_REF(ctlv_attestation_mr_log_get_mr_start_generation,
> +	    &ctlv_attestation_op_schemas[7].request, CTLV_ATTESTATION_ATTR_MR_START_GENERATION, 0,
> +	    1, CTLV_SCHEMA_UINT)
> +CTLV_IN_HAS(ctlv_attestation_mr_log_get_mr_start_generation)
> +CTLV_IN_U64(ctlv_attestation_mr_log_get_mr_start_generation)
> +CTLV_IN_REF(ctlv_attestation_mr_log_get_mr_end_generation, &ctlv_attestation_op_schemas[7].request,
> +	    CTLV_ATTESTATION_ATTR_MR_END_GENERATION, 0, 2, CTLV_SCHEMA_UINT)
> +CTLV_IN_HAS(ctlv_attestation_mr_log_get_mr_end_generation)
> +CTLV_IN_U64(ctlv_attestation_mr_log_get_mr_end_generation)
> +CTLV_IN_REF(ctlv_attestation_mr_log_get_selection_mr_id, &ctlv_attestation_op_schemas[7].request,
> +	    CTLV_ATTESTATION_ATTR_MR_ID, 1, 0, CTLV_SCHEMA_UINT)
> +CTLV_IN_HAS(ctlv_attestation_mr_log_get_selection_mr_id)
> +CTLV_IN_U64(ctlv_attestation_mr_log_get_selection_mr_id)
> +
> +/* Writing a reply. An append is atomic; a nest ends with ctlv_nest_end(). */
> +CTLV_PUT_U64(ctlv_attestation_device_generation, CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
> +	     CTLV_SCHEMA_UINT)
> +CTLV_NEST_START(ctlv_attestation_device_caps, CTLV_ATTESTATION_ATTR_DEVICE_CAPS, CTLV_SCHEMA_NEST)
> +CTLV_NEST_START(ctlv_attestation_device_info, CTLV_ATTESTATION_ATTR_DEVICE_INFO, CTLV_SCHEMA_NEST)
> +CTLV_NEST_START(ctlv_attestation_cap_evidence, CTLV_ATTESTATION_ATTR_CAP_EVIDENCE, CTLV_SCHEMA_NEST)
> +CTLV_NEST_START(ctlv_attestation_cap_mr, CTLV_ATTESTATION_ATTR_CAP_MR, CTLV_SCHEMA_NEST)
> +CTLV_PUT_U64(ctlv_attestation_cap_min_challenge_length,
> +	     CTLV_ATTESTATION_ATTR_CAP_MIN_CHALLENGE_LENGTH, CTLV_SCHEMA_UINT)
> +CTLV_PUT_U64(ctlv_attestation_cap_max_challenge_length,
> +	     CTLV_ATTESTATION_ATTR_CAP_MAX_CHALLENGE_LENGTH, CTLV_SCHEMA_UINT)
> +CTLV_PUT_U64(ctlv_attestation_cap_max_total_output_length,
> +	     CTLV_ATTESTATION_ATTR_CAP_MAX_TOTAL_OUTPUT_LENGTH, CTLV_SCHEMA_UINT)
> +CTLV_PUT_U64(ctlv_attestation_cap_mr_flags, CTLV_ATTESTATION_ATTR_CAP_MR_FLAGS, CTLV_SCHEMA_FLAGS)
> +CTLV_NEST_START(ctlv_attestation_cap_object, CTLV_ATTESTATION_ATTR_CAP_OBJECT, CTLV_SCHEMA_NEST)
> +CTLV_PUT_U64(ctlv_attestation_cap_blob_class, CTLV_ATTESTATION_ATTR_CAP_BLOB_CLASS,
> +	     CTLV_SCHEMA_ENUM)
> +CTLV_PUT_STRING(ctlv_attestation_cap_format, CTLV_ATTESTATION_ATTR_CAP_FORMAT, CTLV_SCHEMA_STRING)
> +CTLV_PUT_U64(ctlv_attestation_cap_representation, CTLV_ATTESTATION_ATTR_CAP_REPRESENTATION,
> +	     CTLV_SCHEMA_ENUM)
> +CTLV_PUT_U64(ctlv_attestation_cap_max_length, CTLV_ATTESTATION_ATTR_CAP_MAX_LENGTH,
> +	     CTLV_SCHEMA_UINT)
> +CTLV_PUT_BINARY(ctlv_attestation_evidence_challenge, CTLV_ATTESTATION_ATTR_EVIDENCE_CHALLENGE,
> +		CTLV_SCHEMA_BINARY)
> +CTLV_NEST_START(ctlv_attestation_evidence_object, CTLV_ATTESTATION_ATTR_EVIDENCE_OBJECT,
> +		CTLV_SCHEMA_NEST)
> +CTLV_PUT_U64(ctlv_attestation_evidence_blob_class, CTLV_ATTESTATION_ATTR_EVIDENCE_BLOB_CLASS,
> +	     CTLV_SCHEMA_ENUM)
> +CTLV_PUT_STRING(ctlv_attestation_evidence_format, CTLV_ATTESTATION_ATTR_EVIDENCE_FORMAT,
> +		CTLV_SCHEMA_STRING)
> +CTLV_PUT_U64(ctlv_attestation_evidence_representation,
> +	     CTLV_ATTESTATION_ATTR_EVIDENCE_REPRESENTATION, CTLV_SCHEMA_ENUM)
> +CTLV_PUT_U64(ctlv_attestation_evidence_object_length, CTLV_ATTESTATION_ATTR_EVIDENCE_OBJECT_LENGTH,
> +	     CTLV_SCHEMA_UINT)
> +CTLV_PUT_U64(ctlv_attestation_mr_id, CTLV_ATTESTATION_ATTR_MR_ID, CTLV_SCHEMA_UINT)
> +CTLV_PUT_STRING(ctlv_attestation_mr_name, CTLV_ATTESTATION_ATTR_MR_NAME, CTLV_SCHEMA_STRING)
> +CTLV_PUT_U64(ctlv_attestation_mr_hash_algo, CTLV_ATTESTATION_ATTR_MR_HASH_ALGO, CTLV_SCHEMA_UINT)
> +CTLV_PUT_U64(ctlv_attestation_mr_supported_hash_algo, CTLV_ATTESTATION_ATTR_MR_SUPPORTED_HASH_ALGO,
> +	     CTLV_SCHEMA_UINT)
> +CTLV_PUT_U64(ctlv_attestation_mr_register_index, CTLV_ATTESTATION_ATTR_MR_REGISTER_INDEX,
> +	     CTLV_SCHEMA_UINT)
> +CTLV_PUT_U64(ctlv_attestation_mr_caps, CTLV_ATTESTATION_ATTR_MR_CAPS, CTLV_SCHEMA_FLAGS)
> +CTLV_NEST_START(ctlv_attestation_mr_item, CTLV_ATTESTATION_ATTR_MR_ITEM, CTLV_SCHEMA_NEST)
> +CTLV_NEST_START(ctlv_attestation_mr_value, CTLV_ATTESTATION_ATTR_MR_VALUE, CTLV_SCHEMA_NEST)
> +CTLV_PUT_BINARY(ctlv_attestation_mr_data, CTLV_ATTESTATION_ATTR_MR_DATA, CTLV_SCHEMA_BINARY)
> +CTLV_PUT_U64(ctlv_attestation_mr_generation, CTLV_ATTESTATION_ATTR_MR_GENERATION, CTLV_SCHEMA_UINT)
> +CTLV_NEST_START(ctlv_attestation_mr_selection, CTLV_ATTESTATION_ATTR_MR_SELECTION, CTLV_SCHEMA_NEST)
> +CTLV_PUT_U64(ctlv_attestation_mr_start_generation, CTLV_ATTESTATION_ATTR_MR_START_GENERATION,
> +	     CTLV_SCHEMA_UINT)
> +CTLV_PUT_U64(ctlv_attestation_mr_end_generation, CTLV_ATTESTATION_ATTR_MR_END_GENERATION,
> +	     CTLV_SCHEMA_UINT)
> +CTLV_NEST_START(ctlv_attestation_log_entry, CTLV_ATTESTATION_ATTR_LOG_ENTRY, CTLV_SCHEMA_NEST)
> +CTLV_PUT_U64(ctlv_attestation_log_event, CTLV_ATTESTATION_ATTR_LOG_EVENT, CTLV_SCHEMA_ENUM)
> +CTLV_NEST_START(ctlv_attestation_log_mr, CTLV_ATTESTATION_ATTR_LOG_MR, CTLV_SCHEMA_NEST)
> +CTLV_NEST_START(ctlv_attestation_notification_entry, CTLV_ATTESTATION_ATTR_NOTIFICATION_ENTRY,
> +		CTLV_SCHEMA_NEST)
> +
> +/* Building one event, passed to ctlv_event_emit() or ctlv_event_abort() once. */
> +CTLV_EVENT_CREATE(ctlv_attestation_mr_log_entry_appended, CTLV_ATTESTATION_OP_MR_LOG_ENTRY_APPENDED)
> +#endif /* _CTLV_GENERATED_METADATA_ONLY */
> +
> +#endif /* _LINUX_CTLV_ATTESTATION_GEN_H */
> diff --git a/include/uapi/linux/ctlv_attestation_gen.h b/include/uapi/linux/ctlv_attestation_gen.h
> new file mode 100644
> index 00000000000000..888bbf06618b17
> --- /dev/null
> +++ b/include/uapi/linux/ctlv_attestation_gen.h
> @@ -0,0 +1,252 @@
> +/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
> +/* Do not edit, regenerate with tools/ctlv/ctlv-regen.sh, from: */
> +/*	Documentation/ctlv/specs/ctlv-attestation.yaml */
> +/* CTLV-GEN uapi header */
> +
> +/*
> + * Constants of the ctlv-attestation CTLV family. Attr and op IDs are complete; the wire format
> + * carrying them is in <linux/ctlv.h>.
> + *
> + * The inherited ctlv header is included here, so one include covers the whole effective schema.
> + */
> +
> +#ifndef _UAPI_LINUX_CTLV_ATTESTATION_GEN_H
> +#define _UAPI_LINUX_CTLV_ATTESTATION_GEN_H
> +
> +#include <linux/const.h>
> +#include <linux/ctlv.h>
> +#include <linux/ctlv_families_gen.h>
> +#include <linux/ctlv_gen.h>
> +
> +/* enum evidence-representation */
> +enum _ctlv_attestation_evidence_representation {
> +	CTLV_ATTESTATION_EVIDENCE_REPRESENTATION_RAW = 1,
> +};
> +
> +/* enum evidence-blob-class */
> +enum _ctlv_attestation_evidence_blob_class {
> +	CTLV_ATTESTATION_EVIDENCE_BLOB_CLASS_PRIMARY = 1,
> +};
> +
> +/* enum mr-log-event */
> +enum _ctlv_attestation_mr_log_event {
> +	CTLV_ATTESTATION_MR_LOG_EVENT_INFO = 1,
> +	CTLV_ATTESTATION_MR_LOG_EVENT_EXTEND,
> +};
> +
> +/* flags mr-device-caps */
> +enum _ctlv_attestation_mr_device_caps_bit {
> +	CTLV_ATTESTATION_MR_DEVICE_CAPS_READ_BIT,
> +	CTLV_ATTESTATION_MR_DEVICE_CAPS_EXTEND_BIT,
> +};
> +
> +#define CTLV_ATTESTATION_MR_DEVICE_CAPS_READ _BITULL(CTLV_ATTESTATION_MR_DEVICE_CAPS_READ_BIT)
> +#define CTLV_ATTESTATION_MR_DEVICE_CAPS_EXTEND _BITULL(CTLV_ATTESTATION_MR_DEVICE_CAPS_EXTEND_BIT)
> +#define CTLV_ATTESTATION_MR_DEVICE_CAPS_MASK \
> +	(CTLV_ATTESTATION_MR_DEVICE_CAPS_READ | \
> +	 CTLV_ATTESTATION_MR_DEVICE_CAPS_EXTEND)
> +
> +/* flags mr-caps */
> +enum _ctlv_attestation_mr_caps_bit {
> +	CTLV_ATTESTATION_MR_CAPS_READ_BIT,
> +	CTLV_ATTESTATION_MR_CAPS_EXTEND_BIT,
> +};
> +
> +#define CTLV_ATTESTATION_MR_CAPS_READ _BITULL(CTLV_ATTESTATION_MR_CAPS_READ_BIT)
> +#define CTLV_ATTESTATION_MR_CAPS_EXTEND _BITULL(CTLV_ATTESTATION_MR_CAPS_EXTEND_BIT)
> +#define CTLV_ATTESTATION_MR_CAPS_MASK \
> +	(CTLV_ATTESTATION_MR_CAPS_READ | \
> +	 CTLV_ATTESTATION_MR_CAPS_EXTEND)
> +
> +/* attr groups */
> +enum _ctlv_attestation_group {
> +	CTLV_ATTESTATION_GROUP_DEVICE = 1,
> +	CTLV_ATTESTATION_GROUP_CAP,
> +	CTLV_ATTESTATION_GROUP_EVIDENCE,
> +	CTLV_ATTESTATION_GROUP_MR,
> +	CTLV_ATTESTATION_GROUP_LOG,
> +	CTLV_ATTESTATION_GROUP_NOTIFICATION,
> +};
> +
> +#define _CTLV_ATTESTATION_ATTR(_group, _attr) CTLV_ATTR(CTLV_FAMILY_ATTESTATION, (_group), (_attr))
> +
> +/* attrs of group device */
> +#define _CTLV_ATTESTATION_ATTR_DEVICE(_attr) \
> +	_CTLV_ATTESTATION_ATTR(CTLV_ATTESTATION_GROUP_DEVICE, _CTLV_ATTESTATION_ATTR_DEVICE_##_attr)
> +
> +enum _ctlv_attestation_attr_device {
> +	_CTLV_ATTESTATION_ATTR_DEVICE_GENERATION = 1,
> +	_CTLV_ATTESTATION_ATTR_DEVICE_CAPS,
> +	_CTLV_ATTESTATION_ATTR_DEVICE_INFO,
> +};
> +
> +#define CTLV_ATTESTATION_ATTR_DEVICE_GENERATION _CTLV_ATTESTATION_ATTR_DEVICE(GENERATION)
> +#define CTLV_ATTESTATION_ATTR_DEVICE_CAPS _CTLV_ATTESTATION_ATTR_DEVICE(CAPS)
> +#define CTLV_ATTESTATION_ATTR_DEVICE_INFO _CTLV_ATTESTATION_ATTR_DEVICE(INFO)
> +
> +/* attrs of group cap */
> +#define _CTLV_ATTESTATION_ATTR_CAP(_attr) \
> +	_CTLV_ATTESTATION_ATTR(CTLV_ATTESTATION_GROUP_CAP, _CTLV_ATTESTATION_ATTR_CAP_##_attr)
> +
> +enum _ctlv_attestation_attr_cap {
> +	_CTLV_ATTESTATION_ATTR_CAP_EVIDENCE = 1,
> +	_CTLV_ATTESTATION_ATTR_CAP_MR,
> +	_CTLV_ATTESTATION_ATTR_CAP_MIN_CHALLENGE_LENGTH,
> +	_CTLV_ATTESTATION_ATTR_CAP_MAX_CHALLENGE_LENGTH,
> +	_CTLV_ATTESTATION_ATTR_CAP_MAX_TOTAL_OUTPUT_LENGTH,
> +	_CTLV_ATTESTATION_ATTR_CAP_MR_FLAGS,
> +	_CTLV_ATTESTATION_ATTR_CAP_OBJECT,
> +	_CTLV_ATTESTATION_ATTR_CAP_BLOB_CLASS,
> +	_CTLV_ATTESTATION_ATTR_CAP_FORMAT,
> +	_CTLV_ATTESTATION_ATTR_CAP_REPRESENTATION,
> +	_CTLV_ATTESTATION_ATTR_CAP_MAX_LENGTH,
> +};
> +
> +#define CTLV_ATTESTATION_ATTR_CAP_EVIDENCE _CTLV_ATTESTATION_ATTR_CAP(EVIDENCE)

I feel like there are too many layers here for a code generator..

enum ctvl_attestation_attributes {
   CTLV_ATTESTATION_ATTR_CAP_EVIDENCE = CTLV_ATTR(CTLV_FAMILY_ATTESTATION, 2, 1),
}

Do the intermediate constants add anything?

-- 
Jason
