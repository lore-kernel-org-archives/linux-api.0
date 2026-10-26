Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793023695;
	b=RR24bXopXfHDHGc+yFuCw0MH+HCFT4F3yumC1vDdrV6pVqj0WoRKE7HjzhMkPwBg6II7
	 7ZKPScA73NCAjzTqpA1d8639mfWrTZlw/yEuz0o1ckDCD8ScKMBXOYn39LGROC76ZIo31
	 FGeocdju2Y3+aQN+Adtavar11L7qr+Kh4Ug3GomcsaB7bEvnx/U4szqUVyDyEgqBibMCm
	 tpPBfvoI/xwreIMypRetKdRUZ+epr7h3gzF393bIMwBGz+hren0RP6q/VJmYmSa405IPq
	 wXz+IaRXEC0CmZIW6lsc4tjm6Db9ufK/px18D0BNa6P6lBVAQkugkAXddxhkTHsOQ5w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793023695;
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
	bh=6A9ugxWIGCXfoXiXLYwN/RGr6dW8W9ZoGwM7NmVe31I=;
	b=2CQ5pu28+KLYvuQbUToQkCdCC4GEjlJJmpKh1zg/WlvL0mG/QAoEwEIk7ey8v2vytAYL
	 JnDU8Y7WSQBrrsWZC1N+BTci08VxERXiWzWePVmnLZOoAAhT67co8Shz1sj0S4ISI3ys3
	 d+bmTM3ogJa4rtcKqk0uqq3qD6oG5gAmVAzkB0/PA2YETxHrq+OOCK9QTM3LIzP2VcK8M
	 UFBmmwSKmsVTc9AnL2KViTWAV4fZNQ8jnWOt1Wl7Cr3XwKU9Ts3YCGzDOXmX+lTmzRq5r
	 M0Ia9RZ4h8QC7K3nSIWzrMsILnhmMIO97R4aTYE8POSjO5btAbm6sqtXG8Ko2TuFHZw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GpAG9tzI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.33
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010033.outbound.protection.outlook.com [52.101.201.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E399606A336;
	Mon, 26 Oct 2026 14:08:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E399606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GpAG9tzI
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gm0JwdP8A5egER39qWE0Z62+soAKsqiyIy3PKxGT974HP/BA6ybcXFajQm/bn+AK1UQnDz2/2dXSYv/BTicnLWmDCIMGHsQe3VviE4tFNBk1d2EIuFzXwFdeOohbsdI4FpcvqHQPqXCBBQfyOLdmSac6+gDwZfzj7UL8Gkvlnah9+qpOIWq6Xba2mtuG93AFu8KAEKxLFgTLMgTW2DdYeiqnjX3wDWWLzeyWzaHGEf2ZmZba5hNm/8mphbiyht+Q2Oi4EuQG95rk+UoKB64FakSJzwwAzGva/rDcIIHmZYrr/Vt5oyWpnAtcH7/PJjA4kDAb9Cll+syErdpn5oRH3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6A9ugxWIGCXfoXiXLYwN/RGr6dW8W9ZoGwM7NmVe31I=;
 b=infyrKIQAUUKUh5DA+gXmchKh1V1rjzSIlTiWgU3D1AlvXCOmTscDZs0+P22j/h4Tr+Wjsf98EHJaC6OAHwuoL/RMpp7UpuCyXLNsiTgTpGTXsVofyPlNaUVS6i1Zqq8TVEJ6elgghIacy5xOZh6cNgpTx8Vs2p7e76y0M0D9TBUuXTQ3rQD1CqyjOM85+ijc4xgBEIk0AE2xK+cujCgOPuDm6E9py1QLweZ6/5oF2GbhUww2F/9wuQPEzW/XfqB3414r4oquT5CXZx03ZrAwQ6lluHP8U8xDMzmzUfZctZNjBa66EL689Hxcok71Zsrn7M7D78Ho5QxF5/oascOtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6A9ugxWIGCXfoXiXLYwN/RGr6dW8W9ZoGwM7NmVe31I=;
 b=GpAG9tzIXfC0SAYWxoY4ulFgOVVOzdPqaBs/5WTg00NNXtDZ8eVNZTvkzKAFSbsRD9Mzcuj924AQIqsI6HScpkYSwlssaENM8PmAA7Edilwww7Owya6GWsvRSYC5cB3rl2iz5Y2q1clwuB/FccpOs+cYN0RhnZ9/JLXFZBhLDBMXZT0zAwErFqEUoiHF20/J+TeKbrxdA644lSdjJmjbyr5zHDdQwez75azGuBDgvWVEA1yhhvtgEvrWkwhsU1/k8RjZm/mw4UU3DJhXYCwl0jSI1JwLXBLlWiDfX92KHMeWVRAtPx/KgkYNy4eS8kTX0hROWZRJL3a6KsrQJzPpVw==
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
Subject: Re: [PATCH RFC 11/20] ctlv: Prepare runtime introspection
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
In-Reply-To: <20261015145053.3664509-12-jiri@resnulli.us>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-12-jiri@resnulli.us>
Date: Mon, 26 Oct 2026 11:07:54 -0300
Message-Id: <179302367452.58760.11808905856343064399.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: YT4PR01CA0240.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:eb::14) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: ffc2f39b-53be-496c-5bc6-08df336a8c0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|4143699003|56012099006|11063799006|261009223027099003|261022105027099003|261022113327099003|261022075727099003|261021121427099003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	0p1Wi4gHodGt4kKULhHjvIlju2naX8GPp+hvAMgoV6ZgwOAzeix+/ZDJ+7iBGpDOLpW20Z3Iqasgfz4b2hrA+qNu2d/Ph8zYTn/NhuwqTQb0ZHbL++9Z1Cy6Kz71dau4Elq5gmf1QGPC/gFDfwuxEEbYWxeON779kHmuEqYFfHTFeYYcxnR7fDfjP6DM8XuWbkCmt0F2wBzRxgso5rC4bJd1IdigpvSDNAUypgVP6L9ftijfLJpvtG7AjNwbrtSj8Gh6QRAWfUGPkwuJAnz0y7GUrUUNuFVbPpW49wUZhPPAbsTUaENLu6RYdLKkhQvEqlgj9WBDteMHZt49ezWjsEbUGaKRJqvVmYiPuxlq3flqhxT+zTUA+2iNZDiXyinFCfBUoaASZVb7SE0kohQRLonsEQIrswBr5kokFn4c92kmLf7jo8sFks6uhG1jPUBef1KVD0tgPV3EiAct1aefbHy5AEtDBufMq65bz8KXhEYbetq94sztCbSIDOv28NAoYWcllc1MkdWtex6on0ksd/cCeZN6la/4PVl+LzTypEaHczv27PfhghuEzI89cyfg7FS1eCNWT7tT5J5Rmh3QCaVorQia8Uzn3iCyO+O/yQ/MWSOKuBXd5UL9OdjGuDAxfvQPDwy7a0WJIj+3YhAe45UykNjKBVw+wDWvftsJBSY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(4143699003)(56012099006)(11063799006)(261009223027099003)(261022105027099003)(261022113327099003)(261022075727099003)(261021121427099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QlhCcmRidkgwMzlEeXlpZ05QUnp4RmVQWFM1SjFlRXJXZHFkeHhMVTBJZUg4?=
 =?utf-8?B?MXIwZlEyUENmV2txaHR3ZnphOEJIK05ZWlhjdzgzMlROQ3htOGNzQ2NLTWFL?=
 =?utf-8?B?TWZoNFphZFNTT21IQjAvdWtSK0RrVnZaTHpMa0h6ZHozNzBEOTlPSzRoZDRK?=
 =?utf-8?B?dXpyeDBMK2MvZGFUcHRMQitGYUthTWZXZW1ZcVpqcUdTSlJ4bzlweFVPSmJC?=
 =?utf-8?B?cFJob28rQUczZzlyQ2ovakNlWmlkZDVCUlZBR0NZQUpZQVFSTlNiNERIMGIr?=
 =?utf-8?B?d1grbGg0aHg1QjBHQmtKVG9GbFJsVW9zdDc2TERnMGtITFhOSy9rUEJ5RVFY?=
 =?utf-8?B?RjZ1QnNoQUFZcmZwL28zTlFkQWtQbFhDaHhvUWhTdjJzdlRvOWxEak9MeTFx?=
 =?utf-8?B?Ym5WVzZxUThxZ0YxRlZhWkVQdlljMTFmenpqSkFKL2hBczUxNjdWU0NTcmdD?=
 =?utf-8?B?Q1BpTDErUS8yaW95M1RwcVhCaWp3ZHg2OGZEc3h2RVJVOWlpMkhtMHJqc0Zy?=
 =?utf-8?B?eHI3NEwwRXNrTSt2V2g2TG1zblJsdjFkbUZyOUl4ckR2L0RmYklIK3o4YTJM?=
 =?utf-8?B?V2JrWnlPbUhQbUJjbkduTkdkNUdYWFpZTENTY3pyTkFoTVVudFljN0JJWGJw?=
 =?utf-8?B?c1pQd0tNWEtpSWtPRUVHVlpLMXFHa3BYVE9kd1lHZGVHWDd2bUl0RGQyZ0do?=
 =?utf-8?B?N1JDRXJnbjZKYkpSbmtFQ1BaWmxJZm1scjdtcjY3b3IrZ0lWR20vTWdQUXJy?=
 =?utf-8?B?bktOYVptSVZpNHg0UWM3c3ZqWDFtc29vS0o0MGRidEZvWDhVb2F0NFVudHdj?=
 =?utf-8?B?ay9tOUI4WlhrQjNxYmZVbGFHcGo0U0RMOVVDbm13T1VkZXRPdUZrQTJJdGE3?=
 =?utf-8?B?UVU1cHpVYjl2c3lxK0VVK2NCcThxMzl2ZnVLYkJ0KzNhU2EwaEpVV2lWa0do?=
 =?utf-8?B?QnZ0ZkNhRlBGdTdEMm5qcDRuV2lNZHU4ZjU2L1pJa1RRd0J0NW42ZCt2SkZ1?=
 =?utf-8?B?MEZCWGp6NGFVMjNoVWpHaVpLWHpOMnM2Q3R4Yk5ESU9YV3dOU2hFc080d0Ja?=
 =?utf-8?B?K21oclphYTE0MUVRNDV5T3FVeThibENpZG4wbjRaeVZIMGNvVDNMOEkwMVc0?=
 =?utf-8?B?N3dWWFhMNkxZNU5HY1JBMmZZZk5kdzZDc0JBQlo3eG1WbWRXaWk0NDJHSFNJ?=
 =?utf-8?B?YWxIUnVhK1dZV2Ftc1YrRlp2N1cvdUdnMXRHUlhiclYvSGIwNXNOVVZSQnFB?=
 =?utf-8?B?Uk1HSDh3K1NkMjRwVnFEK096akxoWmpRMW95NklUSFh0VmZjTWZNV0F3bkNh?=
 =?utf-8?B?ejEzM0hoemhGY0VLTTF4cXBBenowbHZsZWV1N1dLeWlzZWUrZ0RMT1ZjL3h6?=
 =?utf-8?B?VW9uRTFUNVkzWXBpZEdVT29OdXlkQyt6ZnV5cklDdXl5dGM1SnVCSVNEUkNF?=
 =?utf-8?B?eG5iMGdzZWkySlh3elhRaUs1QXUxb0Z6TDM0YThoWjlONkcyOGpQZnBLdFZG?=
 =?utf-8?B?UmZxZ1ZlYkVaRHk0TDZHa3lHUXlac0l2UnB4WjRCdTlMSUVZMFRXM1hvVG40?=
 =?utf-8?B?dXNucnk2RS9CU3NrSkRaYXZXdUVUeng3clZ3eHVGdjZOTWN5TEN6dTRHZDRk?=
 =?utf-8?B?Z2k2QjByMlUyK05SN0s2aU1ZdHpIcnpPbGxJMTg0RXRmb3hnWmhPN0Fjci9o?=
 =?utf-8?B?QUhBaEdxTTRvL2ZqWFZMMFdKTmcyQTczS3FYclRDcUNneThBWlkzcmp1b0hG?=
 =?utf-8?B?bzV3K2xHNDVFSW9xZk5XS01pYVRnNVRCWms2Q1lOaXB0aHdVRmIzK2hnendG?=
 =?utf-8?B?UGJyWkRGVzJxaUVRQmpCcFZrb3pYYjFsV1QyY0JhaHplK2JFV3NQVlhNNVJL?=
 =?utf-8?B?WGFCaEQ2WU9LNEtJN1BSUlJBS1BYY2JoNlFXTzZBM1FqSXdBT21ObXBwVUdZ?=
 =?utf-8?B?OER0Z2ErWEh1d1lDL2xhWFB5TjhYaXJHK045dTVxc0JVdE5tM0lBbmlDQ2RC?=
 =?utf-8?B?c05CTHdxTk1KL3FubXA2SjhSWmZUcytlL1JyVnIyaGtPelFiSjVyRVRTUzVW?=
 =?utf-8?B?c0tGMnorRGNzck56TFFjdDhiTkRZVnd4WmFack5FTnNWTDhPQ2VKRFFId3ZK?=
 =?utf-8?B?WlBGUGZSY1dON0FIZVZCVWN1SkRGK2lreTJQOGMvWWNSU3VJZWJSQ2lucVZP?=
 =?utf-8?B?Y215T0hOVi8zeXdVa1pzUndkejRjbEJaNTZhUmlmUkNyNE5hb2E2QzJ1WVJS?=
 =?utf-8?B?NGtwSUVsbmFmTFFTNlJmUUlqTXpIdTdBWXQ0c0hvajZGUDdtcjk4dDU0akZK?=
 =?utf-8?Q?bO2Kar0XmsPGtCP3k8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc2f39b-53be-496c-5bc6-08df336a8c0b
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 14:08:01.9859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dsgrj3EwRkNShOaPOTaicY9bajEM5dlB0RDXJqSOqO/hY5dY7joMuxMxhZBGu3Mu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5961

> [ ... 53 lines skipped ... ]
> +/* A cursor packs the record and member where fragmentation resumes. */
> +#define CTLV_INTROSPECTION_MEMBER_SHIFT 48
> +#define CTLV_INTROSPECTION_RECORD_MASK GENMASK_ULL(CTLV_INTROSPECTION_MEMBER_SHIFT - 1, 0)

Use genmask for everything:

 #define CTLV_INTROSPECTION_MEMBER_MASK GENMASK_U64(63, 48)
 #define CTLV_INTROSPECTION_RECORD_MASK GENMASK_U64(47, 0)

	pos->record = FIELD_GET(CTLV_INTROSPECTION_RECORD_MASK, cursor);
	pos->member = FIELD_GET(CTLV_INTROSPECTION_MEMBER_MASK, cursor);

	return FIELD_PREP(CTLV_INTROSPECTION_RECORD_MASK, pos->record) |
	       FIELD_PREP(CTLV_INTROSPECTION_MEMBER_MASK, pos->member);

> +
> +struct ctlv_introspection_dump_position {
> +	u64 record;
> +	u32 member;

Maybe a comment describing how record and member are encoded for each
of the users?

> [ ... 13 lines skipped ... ]
> +/* The immutable root-first chain always has generation zero. */

This comment seems out of place, it should be closer to the 0's it
refers to a function below

> +static bool ctlv_introspection_family_record(struct ctlv_cursor *reply, struct ctlv_cursor *entry,
> +					     const struct ctlv_family *family,
> +					     struct ctlv_introspection_dump_position *pos)
> +{
> +	const struct ctlv_family_schema *schema = family->schema;
> +
> +	if (!ctlv_family_entry_start(reply, entry))
> +		return false;

I'm finding it quite hard to go from this statement to the YAML. I get this:

CTLV_NEST_START(ctlv_family_entry, CTLV_ATTR_FAMILY_ENTRY, CTLV_SCHEMA_NEST)

I asked AI and it said it was this:

attr-sets:
  - name: family-entry
    attrs:
      - family.id
      - family.name

Which is some cyclical reference to this one:

attr-groups:
  # One record per family of the chain a device answers, as reported by
  # families-dump.
  - name: family
    attrs:
      - name: id
        type: uint
      - name: name
        type: string
        max-length: 63
      - name: entry
        attrs: family-entry
        max-occurrences: unlimited

But having poked it some more I see that AI was wrong, and it is the
reverse..

But.. Where is the actual op? I finally see it is here:

ops:
  - name: families-dump
    type: query
    fd-access: read
    reply:
      attrs: family.entry

So.. The op points to family.entry which points back to family.id and
family.name through the attr-sets? I queried AI for a while and came
to this:

  The confusing part is that the family group contains both the leaf
  attributes and the container that holds them. Their grouping
  establishes names and attribute IDs; it doesn't imply
  nesting. Nesting comes from attrs: family-entry.

I don't have a constructive idea yet. I've been trying to understand
the yaml in this series for a while now, and I think it is just
unreadable in this organization. The information is spread about all
over the place and it is very hard to construct an idea of what is
actually in a particular system call. Maybe the missing html
generation would be helpful..

Poking at AI some more I understand it is like this because this is
how the ABI numbers are generated, things need to be in these lists so
they can be automatically numbered.

Going the other way isn't much better..

ops:
  - name: device-get
    type: action
    fd-access: read
    reply:
      attrs: device-reply

Okay, so then I see:

  - name: device-reply
    attrs:
      - device.caps
      - device.info

Uh, why do we have this extra layer? but OK..

attr-groups:
  - name: device
    attrs:
      - name: caps
        attrs: device-caps

Er.. 

  - name: device-caps
    optional-attrs:
      - cap.evidence
      - cap.mr

Getting closer!!

  - name: cap
    attrs:
      - name: evidence
        attrs: evidence-cap

Oh, apparently not..

  - name: evidence-cap
    attrs:
      - cap.min-challenge-length
      - cap.max-challenge-length
      - cap.max-total-output-length
      - cap.object

This time for sure!

  - name: cap
    attrs:
      - name: min-challenge-length
        type: uint

It is too much, this going back and forth to the sets is very
obfuscating. Everything is called attr. There is no editor aid to jump
between the sections, by the time you figure out what type a single
value is you've lost the trail for the rest of it.

This isn't even that complicated, if I ask AI to explain it in a C ish
language:

struct device_get_reply {
	struct {
		optional struct {
			uint min_challenge_length;
			uint max_challenge_length;
			uint max_total_output_length;
			struct {
				enum blob_class;
				string format;
				enum representation;
				uint max_length;
			} objects[];
		} evidence;

		optional struct {
			flags mr_flags; /* read, extend */
		} mr;
	} caps;

	struct {
		/* device-info: filled by the derived family */
	} info;
};

I think the yaml names are not helping, calling everything attrs
everywhere is really confusing. At least the transition into a nest
and an attr-set should be more clearly marked in the yaml..

The yaml would be significantly better if it was layed out according
to the actual semantic flow instead of artificially being twisted into
this need to put everything into a linear list. AI invented this:

device-get:
  request: {}
  reply:
    caps:
      evidence?:
        min-challenge-length: uint
        max-challenge-length: uint
        max-total-output-length: uint
        objects[]:
          blob-class: evidence-blob-class
          format: string
          representation: evidence-representation
          max-length: uint
      mr?:
        mr-flags: mr-device-caps
    info:
      $extend: device-info

So.. how about could we drop the sets, use a direct description of the
layout and do something else for the ID numbering? Maybe the numbering
can be solved directly by only listing the names in:

numbering:
  - device-get.reply
  - device-get.reply.caps
  - device-get.caps.evidence
  -[..]

?

-- 
Jason
