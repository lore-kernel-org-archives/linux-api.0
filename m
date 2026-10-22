Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792697011;
	b=HmMJdwlt2GDF6RDkv+SSLwcL7qvTYINv8ZhOGpcmvWnnR15paNRy07JjYSq2xKs/KzPZ
	 W0fW0u0BksiXrl9T7DfVE623+xIMlPIKn8is+Y74JSEsGN5Pqd7JdRazKVD42hGKHFtGr
	 IVLv+C42xpdBg1Q+L5Q6LNdArsk60MnK18eQHS5btZx+wyUNRwvrq/n0sTYLY17thT8ym
	 u8DZs0HyPR7wZsVsCag9gTRsScLhTpaD5QLt1YAxbEjpMHi0Hqy3FDM02CbC2TyLubePQ
	 OZAD+w5hIENLhyM7IzCaKwURxCaVTBGkQpaD5c/GGZq+Dlu3kZgXGToagJI9fpMGfug==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792697011;
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
	bh=PLyrkMm8nY0jAxBadd0cbp6Hlx0M7Wt0XEhSm4DDXZ4=;
	b=Znlt0L7h7+t2lnThaeacGFiUfDeR3YhUfu2l40F9uJaCjD0ikfzmAnIsfFho14tglP95
	 z9ujGPNxWJxniOLvcEHSPbYNfsLdv4hCVcahfc/3Oo0tMT5tQjrURWchR5IgW4SdyZf0E
	 1BHIusnQUIdnH1KLNRHBznzSaoZsuPBySoFw0CatjRXs0RxRqb5B2LAajyGL/cBUzSK8J
	 uD5V59YPlF7GNqIARQf4FCklYkBy54sBguCaMYj/+OLNv6f/Jqdn8+6o8e6N4GZs5Ga0D
	 J1s7/4ibHaXLD9QH+1CpnJP+Ka85Pc51lO+KZViJl/WGKrgJqe02qJWT/+3xQkj38pw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iaBorhAY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.21
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012021.outbound.protection.outlook.com [52.101.48.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D0D606A319;
	Thu, 22 Oct 2026 19:23:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19D0D606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iaBorhAY
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iDDNBzuFi4UWsFWCm8j6f/lJQjOyg4LYbJRSFizhkT3/89VJ7Xj7SLWgwEsMo5VIGvZxVgN3SP3YWmvscrUrnOS0jVLMkw/r65LePBq4sdN3jeyw3msbDpFGt1dcbJctWb0XiEqrV2TsxeCxQX3hhu7IFxwJ5yQOsgsnuxQadqNYGoQsEd+oJWWrlgkH02Ubab3Gn4ASkCIIf+S3kyHzlzThu/GGNMerS5UNNikojpiMDZ2sZQ2RnCV3XTTUraZkTsD4OtQ9x5MFW+U1bjq6UsUxrDgJi629FHR/ZQZ3+f2FwOz5jmPEnWd2dxfns2yRBcCh/90PLmAHrYkS8s8VIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PLyrkMm8nY0jAxBadd0cbp6Hlx0M7Wt0XEhSm4DDXZ4=;
 b=HjfuiVT5F9/kc210AggwJzeqVNJuA/L4egBPXHEkoHjEnurj6Xp+skchXc/RMrwG4IOToxa/5Fyv3GtCuyASp6fhNn3Kd8MBT0qRiVaHL00ZYDgb6vtlpbueH0lKMYF2VrSKzUNMMWRhKmFcagl1PydQ62WJJ0iK/s20UsoT1VU1dVKZQPZCTThL6zDD4q1Xo+iMJ314nHDBoHsknuq2tBqMa0b4F5HF3253T8sXZPq1yW5eecq/aN7hdBlEJCjeXa4nw5SToLEAExTT5FNMqPCJ8a+n71tNUNcVO9X/nJKjeY0L6muqQ0WSI79aB0CQMmH6WdPJfBOST2K4dKCFjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PLyrkMm8nY0jAxBadd0cbp6Hlx0M7Wt0XEhSm4DDXZ4=;
 b=iaBorhAY8KNJ1UfVAJJ6te9Dpte4RM5aKsN8f4aY40h53cuQsTeoRIDjNONZyI8rInFMh3AWiejzChRT+ACi7hpt2RIto+f1Sj/sKKZNONOJ/LswqqzV8VMe6RcmZYgCQmQyQvjH4QG4V/bewM9FwO3A+a196aSEuKLEPU9AyJK6OVKCzKJ4hZZ6gb79aWJJXsZxaShRmyuDwHHDekDzNIeyPlaNN7U2YPO9iuXdVX7IpRTep3PtHdmycSR6tW4PoRaQ3X1MmzVgeTPt0AFaddUxeTyNUTiY0dxowZEk3ZqOvq/q337lOaAgVj5XsDup4RTLAaKM98xb3VccYSjFAg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by BN7PPF7C0ACC722.namprd12.prod.outlook.com
 (2603:10b6:40f:fc02::6d5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.18; Thu, 22 Oct
 2026 19:23:23 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.016; Thu, 22 Oct 2026
 19:23:23 +0000
Date: Thu, 22 Oct 2026 16:23:22 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Mimi Zohar <zohar@linux.ibm.com>, Jiri Pirko <jiri@resnulli.us>,
	Dionna Glaze <drdeeglaze@gmail.com>, linux-coco@lists.linux.dev,
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
	roberto.sassu@huawei.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <20261022192322.GD3746973@nvidia.com>
References: <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
 <20261019225658.GS13920@nvidia.com>
 <ath4vwt7KGyDXKVJ@FV6GYCPJ69>
 <103486a4a29ecc7b72940dd051c00ae59266bd05.camel@linux.ibm.com>
 <20261021143529.GP3008132@nvidia.com>
 <8d8833fac61558a94af415143530884349584a2f.camel@linux.ibm.com>
 <atnqmDhgaJycTf_Q@FV6GYCPJ69>
 <2342b42699292d4e5fc85e5dd4d351a3f29ae336.camel@linux.ibm.com>
 <20261022185133.GA3746973@nvidia.com>
 <atphzdVThE9L5Kmv@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <atphzdVThE9L5Kmv@kernel.org>
X-ClientProxiedBy: CH2PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:610:52::32) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|BN7PPF7C0ACC722:EE_
X-MS-Office365-Filtering-Correlation-Id: 28f186a6-75a2-4f7a-e0f8-08df3071f042
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|6133799003|18002099003|22082099003|261022105027099003|11063799006|4143699003|10067099003|261021121427099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	cgNuFHWy0VLXiUyinLgMOi6hWobFLjL74SxpFO6X9vb8cBwf+pfBWL1IRyXe2vtmQDQB30CkJvqpvILrJPTop3i4zljpBwhFOi1ksGu2az9oemIMZGsyBfPA2mhfVnmtCAY7aJ+WLXItZGCMMVMi78hcC2nJrfhL5f3+qwdBj1S5vQE8/p6rutOsK0J2KiSspeAgil+QSeJcR2zwlKxcd73WwqVoIb21ngykavTW55FcumyFq64+dMAsYZPXOzVTXPkQi8TcIBbgplsC7zYzHQEG96H5NytAx1+84GgGq3yGK+dTwL1KK/mi8cWf/QA/bVeOvNQ7Zm9WaSSQBGCb+CERQGYuQ1z/ZSRp/QhALaipdbG+e4W3SIhNVnVb98tm7WTgcFQ4CgV+lBLHBbY24L4L5Tsy7LCBjxY3Xq6+2pCEddIjI7arAgstII6a+6rXJO5LnL2quGdUvehBby3yHjCQxhiwCosMArFghsjbd9u8W3nB8dvBnTOsh0OGU99qe5VGwns8UqEkzvcieljCV0vU+j0QF4CvejNJ4+7GksmxnRFfE6J6CGDsgMH1s8aMT/n1dn2jJS+YLCdX5p6yTt4dnCxDPZRy/w3uJtxlMo3XhEyxv75vQxX8SRPiTHv84vftEsGoH4FHw91MP7o2sfeTUqZf0Y8j5dKM8lLjI0Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(6133799003)(18002099003)(22082099003)(261022105027099003)(11063799006)(4143699003)(10067099003)(261021121427099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dXRPOUd2YVFLNTZsTDF1c09wakw5ZHdxTndXVDJBN3kwVDIrZGVudmtwa2RJ?=
 =?utf-8?B?WGJOVVUwU2FQeFF5Vkd3aHpVcUY5TnMwRWNQcDQ0YldFQlA1QWdZL2NvUytU?=
 =?utf-8?B?RmFSdTlPcnhDb1kyZS93cTBST1ZHeTBBdWJHYmw4SWVKc2NTZVBvTk8zOUp6?=
 =?utf-8?B?ZW1McE1WdjdwUlV5TGJ4MVNVRm15Ylk3SVg4c3VvTFFrM0d2ak5QMGp6RWFR?=
 =?utf-8?B?YVI4djRlb2VydDhZYjhZOEtqVFc2eklkbGNlbDF6RTF2MEk5THFid1o3UG9j?=
 =?utf-8?B?RENGMHIxNTBZYm9XRGlkU2twNEwwSkRTckZ1RmEwRWMwWTFoQUFtY091ZE5R?=
 =?utf-8?B?eTZMRkI2dTJLNmkxM1YyeUJEMUMyMmxjTXpsYmlOcDlCL1I1RTZUUld1bThy?=
 =?utf-8?B?NEpSekRxaE5HR1lnVEJzZk81dExpbzErNGRYNG1hVmN2WU5pWFdQaVU3TTFR?=
 =?utf-8?B?RHJUSCttZEpTRm1CdkhhY0xNeUl2RFM5UWZVWW5LamE2NUZjYVFhR25IV25r?=
 =?utf-8?B?T0YyUDJ4QXZyQWgvVitoL1AzVEg4ZkxMZENTdSszVDViOU81Z1cwV3VubXF1?=
 =?utf-8?B?eThWUWtqMzJObFVkZXU0ZURIZ0JTSytCUUJlL0ExaWtOR3UraVJ5WUFlSXEz?=
 =?utf-8?B?YXF6bjlpczM5S0dudXNsK0VKWXJrV21tbUJnTktkNFJKbXVjVnU3ZWpuUkhW?=
 =?utf-8?B?UG5Jd0dhNHFTUlAyM2ZoY2hIYXI3RUNvYzkvU0sxUkc1WTlwYXB4UC9NbGdk?=
 =?utf-8?B?Wi9MWTk1Tkt2ZWk4UktQSVJHV2hpdzAwWEVQVktSRmxITG5OYUJjNjREOUdj?=
 =?utf-8?B?MXRYZzZucTcrTTFLWG9JM1JOakgzU0RFS0VXUUY5T2dOM2hYb0Q5S1dMQlFm?=
 =?utf-8?B?SUY3NTZ3YnBuQmxHenpWa29KUVlKNjVEdnZ5RDhwZGlNRTBrZ2tWeURiZVJG?=
 =?utf-8?B?S05lWk1pSDVHUk5MOW5ZQTAwVExDenkzQUV5WW93eXdpQmxnTHBvVElPaHM2?=
 =?utf-8?B?TEdMSWswWXJQWVh0bTBhbjF1My83WG1qeXdoYi9CdlYydytQbDJURDdNMzMr?=
 =?utf-8?B?R0VXL0pRY2NlbnJNUDlyUXV6K0htd0cvaE42ZTMyZWo3TUpuSm0yV1ZaZmlQ?=
 =?utf-8?B?aFhxdUgrdUE4V3NUQ3BqQldWQTJteFF3YU9adE50ZmZmcFYvQ0R2MmQ1dU8v?=
 =?utf-8?B?YngxbkRDdkZaN3VrZWFJOWp2ZTlDNC85WVBSUTF1M241aUZnQ0RnODd0QWp0?=
 =?utf-8?B?OVNkbjM3akkvTWxYUVNXMjkvd1pma0hZOGJ2aGlGSW4zbkY5K2EzUW9yQ2Iy?=
 =?utf-8?B?K1JwMGV6VEFWaWFxTTdNS3FPbTBGUUN4UFJ1QXAxVGs2QjVTYXN0OXQ1Y1Ax?=
 =?utf-8?B?Rm5HZm4ybHdSeFlKK0hwcTV3ME52bGxiUHh6d0ZOQmdxOEtneVg3NG9hN2Zh?=
 =?utf-8?B?bVdiTS9jYlZxeE9rTGgzZFUzbWlISndiWk1jcjVaV3o0UlA4UHEybTg3cUYy?=
 =?utf-8?B?ajBHaGpqWEk4TjZQZTcyYzJPY3EwY25OUXkxSGI5YjhmK0t6Y3dKNzR6WktD?=
 =?utf-8?B?MkwrZnRuZDZySVl4RXpXei9HY21EWVovNkk2ZmVTVmNNQVRUcVJZK3ltZ1RN?=
 =?utf-8?B?VWpaN0p1aDNjR2ZlTUllMVhjcFQvOTBKWStBR3dmQ3FXSEx6R0pBd1M4VWlr?=
 =?utf-8?B?WUJGcHpSR0tCdHFrWENLV3JrVUp3cU1uWUlPM0pMM05nYzhzZjc5c0xUeFVP?=
 =?utf-8?B?R0RpWU9PZm1rM3R5d3JiNlN6L21Ob0c0TUJUck5KZUYzMjMyeGVqSFBZVjg0?=
 =?utf-8?B?R1B4L2ZmSjRQT1Z4QzVLRVJzOHZmWnk3NFZRb3BQUjF5NUtKemdCQXRmQ2lx?=
 =?utf-8?B?L0plYy9XUVF0T1I3c3BGK1prS1kySzJVNmR5WnRZRjE4OXkwODFYTGljZzJz?=
 =?utf-8?B?S1FVMkNxeUI3cUZQeU16TXBtc1NSTm85Z2t2N0tNYkxuU1hUZnRtZWpzNGxQ?=
 =?utf-8?B?SUhRZGJST2VLSENJcEg1L1R6ZEdMb2JaWWs1NHAvbXkzNnA5c20xRWErdU1O?=
 =?utf-8?B?U0RCU0tJVmhKZUxQQjN5Si9ISmFVRGhDZEpWWkVRSmRza25lbytqZHV1NnRz?=
 =?utf-8?B?RVVxbk5GamVaN2RWTXkvUTdyQllrdnExYUwvQmJFZFkrM1I5VHRMOXVRemdC?=
 =?utf-8?B?VFFWU1dMZHgzWmUrQ05ITlpyaFdvbXh5S1dCcU8xTHZ3NWY3OEUxdHhpVXI0?=
 =?utf-8?B?a1NubmprQllieXJDckJEL21iSmlFM1JzWjgzRnorN0NtK2ljaHdqUGJGRENR?=
 =?utf-8?Q?QalOFzN1G0byBRt0NU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f186a6-75a2-4f7a-e0f8-08df3071f042
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 19:23:23.1091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f4M0qD83hKsdqjrg8WxP+OCz6cMEdrj0d9nQS6vSErb0ugcYuZ9qgf9hA9ec+7/u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF7C0ACC722

On Thu, Oct 22, 2026 at 10:19:41PM +0300, Jarkko Sakkinen wrote:
> On Thu, Oct 22, 2026 at 03:51:33PM -0300, Jason Gunthorpe wrote:
> > On Thu, Oct 22, 2026 at 07:24:57AM -0400, Mimi Zohar wrote:
> > > > Isn't the hypervisor what we are doing now? I mean multiple extension
> > > > originators share the same register and eventually the same log. Or do
> > > > you suggest to go even further having a "generic_registerX" exposed for
> > > > every hw implementation allowing the user to have full abstraction?
> > > > The "generic_registerX" would be always alias to something hw specific,
> > > > like RTMR2 for example of TDX.
> > > 
> > > I definitely prefer the latter, as everything continues to work as is with
> > > minimal, if any, change.
> > > 
> > > AI's wording:
> > > • The Virtual Mapping: The [attestation] subsystem exposes "Virtual RTMRs"
> > > (vRTMRs) internally to the kernel.
> > > 
> > > • IMA's Dedicated Lane: The kernel config routes IMA to vRTMR_IMA.
> > 
> > I was thinking something similar too
> > 
> > I called this "PCR policy" in my previous posting, but in-kernel I
> > would expect something like IMA to request the "IMA PCR" from the
> > current attestation policy.
> > 
> > This could be a locality 0 TPM PCR, a locality 2 PCR for a DRTM
> > launch, a TDX RTMR, etc. It keeps the layout in one place, and lets
> > the multiplexor steer it to different hardware.
> 
> 5 Authenticated hibernate [1]
> 
> This is on the table at least.

Yeah, any in-kernel use of PCRs has to fit into the overall system
policy. Like maybe you don't want to use PCR 5 if you have DRTM, or
you want to do hibernation using an alternative ROT from TPM..

Jason
