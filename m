Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795739153;
	b=K/Eiq9b50zoRn8ZevvWgSKzFqlW3u0SsU7jq0jGdPceGfgyTMwKB4CvdlFpKFCU93Qwg
	 y2wDBRbPm5c89g9E8uYvxdCAcJbTPDP13Q4BLVQ7ECd8HDZkmDoubqIwJwqSru4xsqsLh
	 zEQSRg3DKhPOLSfB2x/7we8Oe6mMYb5dXawzWaKYzN60iNxB4kLAUNJXB+gFIwWAXwr9g
	 JeUshH2dasSE4ULOuF9WB1zGJoDFMFsxmsowewZ+75HAdO+EVx8L3HRlFxIU6crFglcSA
	 RotMQlI5Txwmn6qX8L9Sq3YsbS/PGlJ6STuQkCEKIjbOf1S3rXHeDk+fg2GTgF51SOA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795739153;
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
	bh=gyBBuEqNOo6oS0WY2TUpfVOWyzRuNWgUlH7zs9cYBVQ=;
	b=nXjLJyXYAH3yw8gllxvkwPjOMUIujmdlEgHpo1WZeFEx7Ky7adfv8aAdOq6BWCNF9Xpa
	 jeYW1IaklUGpThi4pt33j5+O6WNocyBp8NyXHndTEeEsTC8Ok9WOhN8rhwX41Zu6SO0Pv
	 X77CmkdeE8o6Ft9Zd69Ap9D6T0LDReQb4mHQY6FJqUBSFdiU19ZpjmfxY68HJpE2HBMlO
	 SXKSFZh2CL0Ktw/9C8X0k3M8noprDlSL9kTb+yrIO/d0jJbzoMi/VCY9w5MjuAHGGqPPo
	 YhbQtGSrjGfl1kFzSQRWGpge8Hlj+LRVmuoxnV4BpXaoEGYujZj13gF0kUY7K0j1UMg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mDFQfdEs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.15
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012015.outbound.protection.outlook.com [40.107.209.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BDE606A31C;
	Fri, 27 Nov 2026 00:25:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84BDE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mDFQfdEs
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RNnNEdscVuKKtbKGTTsweI8+p3Eui1DffawJly6FCk+l0s46AisWpDeJAO+Bsta7NhXMu5UZXOB8UBbzSEvqdVOGye0v2qsf1IiggZZPK/ph86sCckS2PW1VKt7xCY8+VSpt2bCWOgsmgkDlhHCRGLNp45I3jqKqFEMQFDSvNtDp/vaViFBG14gLj0ysSZculbETzia1SOWAwAuvdzcK4/x+LUXQ6+dk+hJ1cY28JwlU3tmcaOIzD+e96sLsU/5JfvSM+Z4TMrCB7E4rcA54i7/RhfdEM/AXcEySNb8q6SMalP6EhYyXHde3pNr6JZKsHe/KRnou/O38b2qJBv3ZNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gyBBuEqNOo6oS0WY2TUpfVOWyzRuNWgUlH7zs9cYBVQ=;
 b=wPg6KQq55CcfBiEZwLxNlAPKBq/eHc3QsXTZrLKj5OfAtxuzbljabEzCek17xwhDkNiFHBqf0R6DNlLR2F4T9Dj/lu/ZjYm49s6/saGAWCWcFtxwQj/58YM0YHwVJixttmD2M7dKxw9LS3QRgLM5K2fYVNYc+/bHeftm2TBUqiX9BwdaJpUWwogjM2Aw1yAkM32SkoNa5z7JEtL0uGq3dFpOm9z+5GgVWkDK3VPH4rqPUtKA1IdKKxwzzXFTPV5aGTJzhg9S8WKA/FXCm3t2ra/NX/zUk0cQojaYYIKTlSG0JoxOeVjtyuuwALVAnt0MUf+06J/nnt6nbWaJ3uNL5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gyBBuEqNOo6oS0WY2TUpfVOWyzRuNWgUlH7zs9cYBVQ=;
 b=mDFQfdEsNEdLbrjTuArSMQRfpbbOgxcXHVSBDRo/eVmbqntIpWqxTfrUTy1O+t1JP//SjZZNFkYExHcPvXS4BWCLZ5tzabXNuTG0ucVd+DnVAKnHNURLU6bMXnOYsQ+DpPwA55HnO0szm39u/MnGHFLtdrytbL/RXtRXlsdNvWyTS/yfrCMpJyqqzTuppmdVskx47zE//THqyAGC8qbR8nhKD4wZ+3tA9UsJVoPX0bmfAtBWrPyq9tNQzACJMntsJP3Zq9cTviXbzluu4r5P9AZXiTjiWa4vjA/UvhZw9acnSCobsHCwoWQg8bo8ncOHU5M1gzIRq1SEmjAHGe78nw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM4PR12MB6326.namprd12.prod.outlook.com
 (2603:10b6:8:a3::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.9; Fri, 27 Nov
 2026 00:25:42 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 00:25:42 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH RFC v2 1/9] attestation: Add the base family
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
 peter.fang@intel.com, jarkko@kernel.org, zohar@linux.ibm.com, 
 yeoreum.yun@arm.com, aneesh.kumar@kernel.org, dave.jiang@intel.com, 
 nik.borisov@suse.com, sergii.dmytruk@3mdeb.com, 
 Jason Gunthorpe <jgg@nvidia.com>
In-Reply-To: <20261113160838.2512652-2-jiri@resnulli.us>
References: <20261113160838.2512652-1-jiri@resnulli.us>
 <20261113160838.2512652-2-jiri@resnulli.us>
Date: Thu, 26 Nov 2026 20:25:39 -0400
Message-Id: <179573913907.519186.8407997114208887089.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: YT1PR01CA0089.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::28) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DM4PR12MB6326:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c3b5f63-6cb4-40cb-34cd-08df4c1cf86c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|11063799006|4143699003|6133799003|5023799004|261009223027099003|18002099003|22082099003|3023799007|10067099003|56012099006|261102124527099003|261102123227099003|261028144727099003|261022113327099003|261022105027099003|261022075727099003|261026121527099003|261026140227099003|261021135927099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	Hs3RdvEkYWr53thsz2V1IF69qAGS57O1RqM7Xl/5cd0zKUgg6iNr0y6seWmWw1OnZSmIP0k/DGVwYNsjyWA/E730bEKJIqf5mECCkJlAA0qDn82ovDoGcNexts2Wu+DQwBuVcJj1SbHeeWcsxiAV7bsATbTAp3OWRsub3A/s3rhu/spdSqfRf4nH55Oi0KoHmQwzjZCyirF91s0DxiIzE9xMvqMrDMQvsCeTPnDHuE3kvqW7Y6W2qB6mF0HXKBy8sDi3VIMjijMFC6AHDdAgjoT5Wg43hIRTG1WIPjOqcB5exrG3u9wZ845gkVtrNxFdS9Fx+6gfGvf3mq34WjdPEmhalf45UoqcdioInhNYkel9NrZEMQHXRgDDppFtaPiq3AlUHQFuJgwouSNgfzqhSQciWgjphMS72PjBOu2MdEc7EvNiCSe8LiYl4QOQ+GiNOf1gdos8jqKoZa+RZdib9BecITwxeK+XC3ldFZvnaKpNthyyNkXbXbILp4PGssqxowIsZavCfNukF9W1BKXl9KTZHoIdO+QF0Zsk1y/RWXbyVn/X3p1wi4eQHuCz52uiR6YsHP7wLNYanrI3gm+eINcBxhW9jU/4x7QzsnAxVKuVnW3JbblzpBqAxhceVu1fazR7GNaQe4lqT3MrDvdBFQeTS5XjclSrHeaQE33jUvA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(11063799006)(4143699003)(6133799003)(5023799004)(261009223027099003)(18002099003)(22082099003)(3023799007)(10067099003)(56012099006)(261102124527099003)(261102123227099003)(261028144727099003)(261022113327099003)(261022105027099003)(261022075727099003)(261026121527099003)(261026140227099003)(261021135927099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WWx6Y1RITmd3TCtDRFZSMGM1NmVpdjErajZmNXlnVmVHQlo3WkphenF1blRx?=
 =?utf-8?B?bFNQYlZ3Y2ZJbk91elNTQ01LWkNpT1FoN2Z5MERZNTVCeEZXSGNaMForY2hN?=
 =?utf-8?B?Vkl6eWZMT1hPNVFDTDgyVDNuYU1sOUNxeXZka1FqTFF5QTdrY1MxazJZcGkw?=
 =?utf-8?B?VHFSeUdxRTlyY204ZklFb2JkVlh5MExEa1Y4T2tINm4wWnVMY1h2V0xCaVdN?=
 =?utf-8?B?b1RyZDRaOHFhb3drMGE1Ky9td1d3Mm05ZmlBaTcxR0JrTHRpcU5PQXdCbERZ?=
 =?utf-8?B?VkxKSllkR05YcEo1cVhKZjN3OEhXREI5VjI5eW54NGl0MW9rR0NHdHN1cmJV?=
 =?utf-8?B?RFIwUlhlZ3hKMS9YVEE1bkhDaHN5enVIN0NCbkFnZXhyaHdSaW01RkpqZjhq?=
 =?utf-8?B?cjVsN2Q2djB1M0tlZHdMb3RYWlNNR1JHcmc5MFhoL0UzaS9BN3RqeUdnRWhS?=
 =?utf-8?B?V0xiNEtDWFlScjNwcW1HYlo0b04wc2FuSEJuOU1DbWxsTEhiTENLZlRCQlA0?=
 =?utf-8?B?RCtYdlJFUWFLSTFSWFNqVEpQUVpuV0kyNEoxUmtwUFJLLzFiNjF4RlExcnkx?=
 =?utf-8?B?YTZZc1UwYStmRkErVm9vcW8wTG44TFp0QnBDL0xnRGhiTlhqRE5NZEN0aE5Y?=
 =?utf-8?B?NndXMW9oTkdoSHZ1UEh2cmR5UVJUWHVjc29Bajl3Q2VuWTBJc3IwSGdRRTQ2?=
 =?utf-8?B?cDdSM3c0dEtGT2p4NlVFeU9FVmpOd0ZBTnFjb2tDaWlDTEhsRWFmNjgyT2FX?=
 =?utf-8?B?N1ExSHV1M1RiTTFSTjUzUjFiR21ZdjF5V21EczV0K1U2NGwwd1hvRFFOUTNj?=
 =?utf-8?B?RXgzR2dRc25ESUY2aW4zdHQ5WTl2aWd6cW5Yc0VneEVUVHEwZ2p5MS9yc3lU?=
 =?utf-8?B?RXd5NjVtTzRwQkZRS01zRmhTc1lyNDJyejREYWtvSm95MXNlMDFSSm5MY3pm?=
 =?utf-8?B?blloQkFNYTd5SWdTZGpKME1oTC91aGEydUhvQ2hucmRSMHZaTkdpVEFqcUhG?=
 =?utf-8?B?UXBRRE83ei9Ub0F3WWY4ZFpqR0FzTmdXTWlsSHZhbm8yUnZxclZhRC9ldWhJ?=
 =?utf-8?B?ZGFpTk5LQ1dhZnlCWjBkV2VDckcwejNtdytWLzBjbGt0ZkExMzlyRFhJS2tJ?=
 =?utf-8?B?SkJKNjNsOW14NFYyRlR2QmRKRURsc2RqRm9DNVpzdDltTDlWNmRVRkpOZHFD?=
 =?utf-8?B?dG4wYXhsR2ZjaEFseGd3RFg4QzU1eWxncE9MczU4cVRBWG12T1BpNzR1YldW?=
 =?utf-8?B?aExqdXdwRStqa0hWWnZyQmVYeDRaMllKNitpWXk0WHhGTjIvZ3pkaUhCREZT?=
 =?utf-8?B?UGtOMlNyOURnN1FQRlo1NnJJOUJ3TjFZSE5Ybm9hY2dRTGNnbVhDbm9TRnds?=
 =?utf-8?B?UDN1eVBPQ2hkci9pV2hvV0pVUWlCYjhGemd1U3JKellpbmFXUnhkc0tmSnZT?=
 =?utf-8?B?RGlpUW15UmExeFVBTlphSmxmenAwUnBkVlZ1V2NEUVpHeXp2ZUtMZ2lrYXdx?=
 =?utf-8?B?cWgrM3g4ZmdsNDU3blVrd096anRoU2FXRS9UNkV1VEFDSFRZL2ZUb1VVVC95?=
 =?utf-8?B?bFUvZnBSQzJzRTc3eTcwQnB3OUdvbXhyck5Kdjl1ek5MaUtuak9ncFY1TG5y?=
 =?utf-8?B?U1VUcDBBejlmMklpaVlaN2svR2N6Q3prSmlTaXNtajBqMzh3b0xvRm9SMTlv?=
 =?utf-8?B?emtVbVpOL0lmTkZ0OE9oemNZOGtGaEFqVHV3RnluWnB4VWE3Z1J6a1JFUTl4?=
 =?utf-8?B?ZGFqUksrZDBZYmR1WlRKQnU0VDJoZlNiVlQ4ejArUlBzaEIvdFBHaktESVFJ?=
 =?utf-8?B?SEZKcld5T2YySXJsNFBhNVJ6VzJCKzQrLzE5akpRSXJrbmFTbUdScjVHQVNB?=
 =?utf-8?B?SGEwclMzQ3h0V0l1ZEo4aEVidUkxSGFWTnBpcy95OWhnMk5BZFZBbXVtMEVX?=
 =?utf-8?B?Mmt4LzdMYkhMNlE5OEVsNGNnaUZtL0Vxa0dGR1JPS3BhVjh1SUlzOUJHcnJq?=
 =?utf-8?B?K2ZGelBwckFwWnNra0RFT3o4V0thY1NpdDQzY3pzc0tsK2lCVEJnRWNOWXpq?=
 =?utf-8?B?VXpQQWtYdk9MZ3JyZmllQTIvN3cvZy84MmNoekJOU2dQTHZzVFV1dmozTUxu?=
 =?utf-8?B?V3ZXQ3FPeU85NWJYMzVsK2NZTUtkbGZSdGRVQXZZUVpFRytqRXVKQ2dQeStQ?=
 =?utf-8?B?eml4RjVRcElrWTFhUzNYKzYvalhBZ2dHU01KS1IveSthOUgzSzhTL25UYzB1?=
 =?utf-8?B?dDBXMFlkb1ZwYzZjb3B5OXRBbWY4bmNDOEVRbEg0NE5Fa3NhVWhlU0FwOUdP?=
 =?utf-8?Q?zaAqjf6vTdgtbp/QOS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c3b5f63-6cb4-40cb-34cd-08df4c1cf86c
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 00:25:42.4546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HKeCVNjuX8b51BevBjVC4J+qpDpS0+vDeGwdq+9LW7NIIz9mWy/LMxH7YM9Cct1e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6326

> [ ... 60 lines skipped ... ]
> +++ b/Documentation/ctlv/abi/ctlv-attestation.yaml
> @@ -0,0 +1,147 @@
> +# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
> +%YAML 1.2
> +---
> +# Checked-in ABI snapshot of the ctlv-attestation family, from
> +# Documentation/ctlv/specs/ctlv-attestation.yaml, written by
> +# "make -C tools/ctlv regen".
> +#
> +# Updating the file is how a UAPI change gets reviewed; an update that
> +# removes or renumbers anything, narrows a bound, or makes a member required
> +# is an ABI break, whatever the file says afterwards.
> +family: {name: ctlv-attestation, id: 1, inherits: ctlv}
> +enums:
> +  evidence-class: {signed: 1, event-log: 2}
> +  evidence-format: {ccel: 1}
> +  hash-algo: {$header: linux/hash_info.h, $enum: hash_algo,
> +              $end: HASH_ALGO__LAST}

I feel like this should parse the C enum into numbers here so the ABI
can be checked too?

> +flags:
> +  mr-device-caps: {extend: 0}
> +  mr-caps: {extend: 0}
> +records:
> +  mr-desc:
> +    id: 0x00010000
> +    fields:
> +      name: {number: 1, type: string, min-length: 1, max-length: 128}
> +      supported-hash-algorithms: {number: 2, enum: hash-algo,
> +                                  max-occurrences: hash-algo}
> +      caps: {number: 3, flags: mr-caps}
> +      register-index: {number: 4, type: uint, max: u32-max, optional: true}
> +  mr-value:
> +    id: 0x00020000
> +    fields:
> +      hash-algo: {number: 1, enum: hash-algo}
> +      data: {number: 2, type: binary, min-length: 16, max-length: 64}
> +  mr-generation:
> +    id: 0x00030000
> +    fields:
> +      mr-generation: {number: 1, type: uint, max: u32-max}
> +  mr-values:
> +    id: 0x00040000
> +    fields:
> +      mr-values: {number: 1, record: mr-value, max-occurrences: hash-algo}
> +  device-get request:
> +    id: 0x80010000
> +  device-get reply:
> +    id: 0xc0010000
> +    fields:
> +      caps: {number: 1, record: device-get caps}
> +      info: {number: 2, extension: device-info}
> +  device-get caps:
> +    id: 0xc0011000
> +    fields:
> +      evidence: {number: 1, record: device-get caps.evidence, optional: true}
> +      mr: {number: 2, record: device-get caps.mr, optional: true}
> +  device-get caps.evidence:
> +    id: 0xc0011100
> +    fields:
> +      objects: {number: 1, record: device-get caps.evidence.objects,
> +                max-occurrences: 16}
> +  device-get caps.evidence.objects:
> +    id: 0xc0011110
> +    fields:
> +      id: {number: 1, type: uint, max: 15}
> +      class: {number: 2, enum: evidence-class}
> +      formats: {number: 3, enum: evidence-format, max-occurrences: 4,
> +                optional: true}
> +      vendor-formats: {number: 4, enum: evidence-vendor-format,
> +                       max-occurrences: 4, optional: true}
> +      max-length: {number: 5, type: uint}
> +      challenge-lengths:
> +        {number: 6, record: device-get caps.evidence.objects.challenge-lengths,
> +         max-occurrences: 8, optional: true}
> +  device-get caps.evidence.objects.challenge-lengths:
> +    id: 0xc0011111
> +    fields:
> +      length: {number: 1, type: uint, min: 1, max: 4K, unit: bytes,
> +               optional: true}
> +      min-length: {number: 2, type: uint, min: 1, max: 4K, unit: bytes,
> +                   optional: true}
> +      max-length: {number: 3, type: uint, min: 1, max: 4K, unit: bytes,
> +                   optional: true}
> +  device-get caps.mr:
> +    id: 0xc0011200
> +    fields:
> +      flags: {number: 1, flags: mr-device-caps}
> +  evidence-get request:
> +    id: 0x80020000
> +    fields:
> +      challenge: {number: 1, type: binary, min-length: 1, max-length: 4K,
> +                  optional: true}
> +      objects: {number: 2, record: evidence-get objects, max-occurrences: 16}
> +  evidence-get objects:
> +    id: 0x80021000
> +    fields:
> +      id: {number: 1, type: uint, max: 15}
> +      data: {number: 2, blob: output, backings: [va], max-length: u32-max}
> +  evidence-get reply:
> +    id: 0xc0020000
> +    fields:
> +      results: {number: 1, record: evidence-get results, max-occurrences: 16}
> +    members: ['record mr-generation?']
> +  evidence-get results:
> +    id: 0xc0021000
> +    fields:
> +      format: {number: 1, enum: evidence-format, optional: true}
> +      vendor-format: {number: 2, enum: evidence-vendor-format, optional: true}
> +      length: {number: 3, type: uint}
> +  mr-get request:
> +    id: 0x80030000
> +    fields:
> +      id: {number: 1, type: uint, max: u32-max, optional: true}
> +  mr-get reply:
> +    id: 0xc0030000
> +    fields:
> +      items: {number: 1, record: mr-get items, max-occurrences: unlimited}
> +  mr-get items:
> +    id: 0xc0031000
> +    fields:
> +      id: {number: 1, type: uint, max: u32-max}
> +    members: [$include mr-desc]
> +  mr-read request:
> +    id: 0x80040000
> +    fields:
> +      id: {number: 1, type: uint, max: u32-max}
> +  mr-read reply:
> +    id: 0xc0040000
> +    members: [record mr-generation, record mr-values]
> +  mr-extend request:
> +    id: 0x80050000
> +    fields:
> +      id: {number: 1, type: uint, max: u32-max}
> +    members: [record mr-values]
> +  mr-extend reply:
> +    id: 0xc0050000
> +    members: [record mr-generation]
> +extensions: {device-info: 1}
> +enum-extensions: {evidence-vendor-format: 1}
> +ops:
> +  device-get: {id: 1, type: action, fd-access: read,
> +               request: device-get request, reply: device-get reply}
> +  evidence-get: {id: 2, type: action, availability: dynamic, optional: true,
> +                 request: evidence-get request, reply: evidence-get reply}
> +  mr-get: {id: 3, type: query, fd-access: read, optional: true,
> +           request: mr-get request, reply: mr-get reply}
> +  mr-read: {id: 4, type: query, fd-access: read, optional: true,
> +            request: mr-read request, reply: mr-read reply}
> +  mr-extend: {id: 5, type: action, optional: true, request: mr-extend request,
> +              reply: mr-extend reply}
> diff --git a/Documentation/ctlv/abi/families.registry.yaml b/Documentation/ctlv/abi/families.registry.yaml
> index 5845e745777150..7a5c6af2956578 100644
> --- a/Documentation/ctlv/abi/families.registry.yaml
> +++ b/Documentation/ctlv/abi/families.registry.yaml
> @@ -5,3 +5,4 @@
>  # Written by "make -C tools/ctlv regen".
>  families:
>    - ctlv
> +  - ctlv-attestation
> diff --git a/Documentation/ctlv/families.yaml b/Documentation/ctlv/families.yaml
> index 4d219d7af74a79..dbb0243b873d68 100644
> --- a/Documentation/ctlv/families.yaml
> +++ b/Documentation/ctlv/families.yaml
> @@ -15,3 +15,4 @@
>  
>  families:
>    - ctlv
> +  - ctlv-attestation
> diff --git a/Documentation/ctlv/generated-files.yaml b/Documentation/ctlv/generated-files.yaml
> index d4766b176ceb98..00a56634805d40 100644
> --- a/Documentation/ctlv/generated-files.yaml
> +++ b/Documentation/ctlv/generated-files.yaml
> @@ -16,3 +16,10 @@ families:
>        kernel-header: include/linux/ctlv_gen.h
>        kernel-source: lib/ctlv/ctlv_gen.c
>        user-source: tools/ctlv/libctlv/ctlv_user_gen.c
> +
> +  - name: ctlv-attestation
> +    source: Documentation/ctlv/specs/ctlv-attestation.yaml
> +    outputs:
> +      uapi-header: include/uapi/ctlv/ctlv_attestation_gen.h
> +      kernel-header: drivers/attestation/generated/ctlv_attestation_gen.h
> +      kernel-source: drivers/attestation/generated/ctlv_attestation_gen.c
> diff --git a/Documentation/ctlv/specs/ctlv-attestation.yaml b/Documentation/ctlv/specs/ctlv-attestation.yaml
> new file mode 100644
> index 00000000000000..78b2dad6318a6f
> --- /dev/null
> +++ b/Documentation/ctlv/specs/ctlv-attestation.yaml
> @@ -0,0 +1,181 @@
> +# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
> +%YAML 1.2
> +---
> +# Attestation devices: evidence and measurement registers (MRs). The device's
> +# family inherits this one, fills device-info and gives evidence-vendor-format
> +# the formats its vendor defines.
> +family: ctlv-attestation
> +inherits: ctlv

This is much easier to read, I think it works well like this!

> +
> +enums:
> +  # What an evidence object is.
> +  evidence-class:
> +    # Made by evidence-get over its challenge, and signed by the root of
> +    # trust.
> +    - signed
> +    # The platform's log of what firmware and the boot chain measured into
> +    # the MRs. Later extends, through mr-extend or otherwise, are not in it.
> +    - event-log
> +  # A layout of an evidence object that a standard defines.
> +  evidence-format:
> +    # The log area of an ACPI CCEL table, a TCG crypto-agile event log.
> +    - ccel

Lets be in the habit of including a detailed spec reference for things
that are standards.

> +  # A layout of an evidence object that one vendor defines, given by the
> +  # device's family.
> +  evidence-vendor-format: extension

I find this 'standard' 'vendor' distinction confusing. Is this an
artifact of the compilation process?

This would be more usable if there was one enum but both this yaml and
the driver yaml can contribute values to it. If we made an 'extendable
enum' then the values could be full 64 bit ID numbers with the tree
coding so that the extension works the same way as a op and record?

Though I'm a bit nervous about what happens if something in a driver
turns into a standard. It would be nice to be able to make the
driver's ID promoted to a global ID without changing the ID. That
sounds like something the generator could learn to do later I guess.

The comment should be improved to define what consitutes a 'format'. I
was advocating that the format should define enough to check the
signature and the challenge universally.

Like Peter described the new TDX evidence as "tdx-quote-eat-cwt-1.0".

Poking at the IETF RFCs with AI a bit I think it should be described
as "CWT EAT" in this language. The EAT RFC defines the location of the
challenge and uses the CWT packaging which defines how the signature
is placed.

I think ARM uses this format too, IDK what AMD uses.

The EAT itself should have information inside that describes the
"tdx-quote-1.0" idea, so we don't need it externally.

> +  # The kernel's hash algorithms.
> +  hash-algo:
> +    $header: linux/hash_info.h
> +    $enum: hash_algo
> +    $end: HASH_ALGO__LAST
> +
> +flags:
> +  # What a device offers for its MRs.
> +  mr-device-caps:
> +    # mr-extend is provided.
> +    - extend

I guessed the userspace should learn what operations are supported
using introspection directly on the operation? Do we need to specify
what ops are implemented in device-get?

> [ ... 5 lines skipped ... ]
> +records:
> +  # One MR, as mr-get describes it.
> +  mr-desc:
> +    # The platform's name for the MR, such as rtmr0.
> +    name: string(1..128)
> +    # Its banks, each once, in the provider's order.
> +    supported-hash-algorithms[hash-algo]: hash-algo

I wonder if it would be wise to put a bit more syntax here:
    supported-hash-algorithms[num_entries(hash-algo)]: hash-algo

Just to be clear about exactly what is being extracted from
hash_algo.. It is the total number of entries, not the maximum value
or something else.

> +    # What it allows.
> +    caps: mr-caps
> +    # The hardware's number for the MR, where it has one: 0 for rtmr0.
> +    register-index?: uint(..u32-max)
> +
> +  # One bank of an MR.
> +  mr-value:
> +    # The bank's algorithm.
> +    hash-algo: hash-algo
> +    # The digest, as long as hash-algo's.
> +    data: binary(16..64)
> +
> +  # The device's MR generation, which each extend bumps.
> +  mr-generation: uint(..u32-max)
> +
> +  # Values for banks of the MR, each bank once.
> +  mr-values[hash-algo]: record mr-value
> +
> +ops:
> +  # What the device can do, and its family's fields.
> +  device-get:
> +    type: action
> +    fd-access: read
> +    reply:
> +      # What the device supports, fixed for its life.
> +      caps:
> +        # Present when the device produces evidence.
> +        evidence?:
> +          # One per object evidence-get can produce.
> +          objects[16]:
> +            # The device's handle for the object in requests.
> +            id: uint(..15)
> +            # What the object is.
> +            class: evidence-class
> +            # The layouts a standard defines that the object may have. At
> +            # least one of formats and vendor-formats is present.
> +            formats[4]?: evidence-format
> +            # The layouts its vendor defines that the object may have.
> +            vendor-formats[4]?: evidence-vendor-format

How do we want to fit AMD's unique GUID scheme into this?

I'm not sure we should be passing a GUID from userspace to select an
opaque blob. If not then the kernel could have the GUID list and
report the correct evidence formats as options here?

But then this is maybe a bit limiting because the format is supposed
to be the basic envelope, but the AMD version uses almost the same
format but they are still different. Though I suppose the difference
in the nonce calculation warrants a second format.

And then how does generic userspace even know which one to pick? List
them all? Should kernel give some 'default signed evidence' ID ?

So many questions :(

> +            # The longest the object gets; a blob this long always holds it.
> +            max-length: uint
> +            # A signed object's challenge lengths: each entry is one length,
> +            # or a range from min-length to max-length.
> +            challenge-lengths[8]?:
> +              # A single length.
> +              length?: uint(1..4K, bytes)
> +              # The shortest of a range.
> +              min-length?: uint(1..4K, bytes)
> +              # The longest of a range.
> +              max-length?: uint(1..4K, bytes)

The comments should be more prescriptive on how userspace has to
handle this. I guess if length appears then that length must be used,
otherwise within the range described by min/max length

But I wonder if this is worth some additional schema support to define
a tagged union?

> +        # Present when the device has MRs.
> +        mr?:
> +          # The MR operations the device provides.
> +          flags: mr-device-caps
> +      # The device's family's fields.
> +      info: extension device-info
> +
> +  # Evidence objects, written into the caller's blobs. A signed object is made
> +  # by the call, over the challenge, and never reused; the others are read as
> +  # they stand at the call.
> +  evidence-get:
> +    type: action
> +    fd-access: read-write
> +    availability: dynamic
> +    optional: true
> +    request:
> +      # Bound into each signed object named: pass a verifier's nonce, or a hash
> +      # binding one to your context, never data a peer chose. Present exactly
> +      # when a signed object is named, and of a length each of them takes.
> +      challenge?: binary(1..4K)
> +      # The objects to produce, each named once.
> +      objects[16]:
> +        # The object, by the ID device-get lists.
> +        id: uint(..15)
> +        # Where the object is written. One too short for it fails the op with
> +        # EMSGSIZE, and error-info's required-length says how long it has to
> +        # be.
> +        data: blob(out, va)

What will this be like when we add memfd later?

> +    reply:
> +      # One per object, in request order.
> +      results[16]:
> +        # The layout it came in, where a standard defines it. Exactly one of
> +        # format and vendor-format is present.
> +        format?: evidence-format
> +        # The layout it came in, where its vendor defines it.
> +        vendor-format?: evidence-vendor-format
> +        # The bytes written to its blob.
> +        length: uint
> +      # Present when the evidence depends on the MRs.
> +      mr-generation?: record

Later we will need to add 'tsm controlled challenge' meaning the challenge is
an output not an input,

> +
> +  # The MRs' IDs and descriptions, which do not change; mr-read returns
> +  # values, which change with every extension and are read from the hardware.
> +  mr-get:
> +    type: query
> +    fd-access: read
> +    optional: true
> +    suggested-reply-length: 4K
> +    request:
> +      # Only this MR; every MR without it.
> +      id?: uint(..u32-max)
> +    reply:
> +      # One per MR, ordered by ID.
> +      items[]:
> +        # The device's handle for the MR in requests.
> +        id: uint(..u32-max)
> +        $include: mr-desc
> +
> +  # One MR's values, and the MR generation they belong to.
> +  mr-read:
> +    type: query
> +    fd-access: read
> +    optional: true
> +    suggested-reply-length: 4K
> +    request:
> +      # The MR to read, by the ID mr-get lists.
> +      id: uint(..u32-max)
> +    reply:
> +      mr-generation: record
> +      mr-values: record

Can we leave the generation for a followup with more understanding
what it will be used for and how it is computed?

> +
> +  # Extends banks of the MR by digests, as TPM2_PCR_Extend.
> +  mr-extend:
> +    type: action
> +    fd-access: read-write
> +    optional: true
> +    request:
> +      # The MR to extend, by the ID mr-get lists.
> +      id: uint(..u32-max)
> +      # For the banks to extend, each once, in any order.
> +      mr-values: record
> +    reply:
> +      mr-generation: record

The comment should say that mr-values must include exactly every bank
inside the MR, not more or less.

If we want to later add something like a log entry as an option this
is easy to extend for that, right?

This API eventually needs certificates. I expect that Intel is
including the certificates embedded within the EAT returned here as
signed evidence. AFAIK ARM does the same

But AMD seems to pass them through 'auxblob' in tsm_report, so there
should be a certificates API here to get them. SPDM also has them
detached from the evidence.

-- 
Jason
