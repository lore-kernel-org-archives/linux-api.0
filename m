Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792452725;
	b=KtkPfBu1b+gnDSfWio0crnAzsUTvFZqc+zxtUYkzknK5X5TpRdTBZV9yrYMiwNYrFYhA
	 9gQqcH3MS/qhUqRC4+B1dPV3cRJZMdc1++HFTzEUZlJfWOZHZv/bf/HkXbA0CvlmurpbN
	 SGsyHb1c9KbnTUwDw2UzIqqEGOgmi0C406g2UwIhm77dXpZ45LyHmZ3IjpFpRrTZqz3rA
	 rqKiRp2JpAm+EgoMZvObt7QoS+lMfX5oxffYwQJxPYfR6/QSP5OAvRv7vnUVTMhvDlBFp
	 AGMneboOVYc0VVclzmmqSVYf5ErDIbPI7vuDmHcrH4RaylY8zyNr1YwRZmN9bG2SOhA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792452725;
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
	bh=/pkZm3oCAJ0oKR6LIjsRJIZaSRSQBa73V4PGUUc4QHk=;
	b=cYHVrR6cfG6FRhd24XimUUgcu0nnhCJxi/btXYv1ErLugiEGak8BgoksppRcrEJeJFEK
	 59Y24Hkq8fxexOXTrc152OGTgqRvovZXxhhlIhrYi2ITyNH0D2W0GoalRC4NNeogLzbKz
	 t+HC+CMLxuabPqb6ejVrHq+cduF+MQaHag9PduS50FriPZCSPd866DIfDkRK8Z0cI3krY
	 k6OpTcXEGggdnlU7IcXjrnVUFdwpMFOcHYFdtBoZHXPzt6jXFRVcm1Rpl5wnB/i3Xm2m1
	 iHsBW/IIz2mCPI4QCWsSkbv8f3BTRkUA9UP+tUALt1fktdGp2Zb3EjRSE95gZD+AO6A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=azmzXoYV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.14
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010014.outbound.protection.outlook.com [52.101.61.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893D7606A32C;
	Mon, 19 Oct 2026 23:32:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 893D7606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=azmzXoYV
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BfRyQHytzTZv+rOub+EKsJ1CbbiTtrhEZYlPxuxYRE3thdSQOU9bBY8oTAOEjsoCLEBs253DRX67fjk+IFOuXCwtebM3UioPJfFBc1+nUX+QZ1SQ9sGjZT2b2v0QKBKD7ncIKXQX2yp1V/wXbCKovXSfcY0cjFiWorEsuZ6zVxmc98/v4O/qBoImcHvz1PzbPtRuhV7i1fuTAs/9ibUlPooNSlYayeqOLLqh8zxoH0saT3jyw66UXa4MjLfjs0jkP3WkZBxJcncBWW/um4gbWGDJYkbMNDqF7UrBIsnhhDD/es6rq5s3ZPrCZIZtheXm0DlCnJpobJUCC7JJ7BCXZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/pkZm3oCAJ0oKR6LIjsRJIZaSRSQBa73V4PGUUc4QHk=;
 b=WAf1e6wSqYv6McEtPK0WDP4d1aEdDySQKb7isgiAOIVjT66LQfegxXXEFl5O4IdYEc9iOOvdVyl1V9T8y4iS72aoKzNN2cvcWMElgVV4UEswjhBYxVQecaFq+p64KsrPg+XNTu9Id0ZOMpaoqMe87Mudaf9h8PL/nwUUYxEII9FQZloWa/gb4vWoz4/eVwyOp0f+Jb4O5kZW6MEbe0b0n2jvtg6s8hrTUMSOapRX5s/FnV+zyv6Lo8VJ4hL7XmeEvWpdO2HX1BXjHcSxoFawp+ZH2YHSFcKIWgNPcmB6Z5sEcL0V6jMnyBbYkYOoZC7UDq7GBmhXEy+WqZzlJivrew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/pkZm3oCAJ0oKR6LIjsRJIZaSRSQBa73V4PGUUc4QHk=;
 b=azmzXoYV8AmOFuhX7NGq7oPxgW95LYzCruo7lg7XY1F30NnXNrUMelgmQUmMsNFp+LqN2QscWZu375c1RDILORXIhLJRkTpB6D2EWJMtaFerl3grp4os8O3p0haEvq7nNHML1sWmyR9sFYvXbFIiPGQUg5yT9eBbt0ZuFGRbUjQJIWIjCTDaW8QkXtMKgNrXndL0YvZMfUsQZpXft22l7q4AyA9QbcvJLyk5ht+JP9MLXpj+RweKqOLVCqUbRiaaysVYC7ZucNDlV851ZIPjuBItH4QkFMzoqOr6x+KTWZUVswbrTz12wJRk2qV1/xWsdom1HRW4eUoOi/1LYNkfCw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SN7PR12MB8789.namprd12.prod.outlook.com
 (2603:10b6:806:34b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.18; Mon, 19 Oct
 2026 23:29:48 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 23:29:48 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH RFC 04/20] Documentation: ctlv: Add userspace ABI
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
In-Reply-To: <20261015145053.3664509-5-jiri@resnulli.us>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-5-jiri@resnulli.us>
Date: Mon, 19 Oct 2026 20:29:45 -0300
Message-Id: <179245258505.58760.6612247594755628055.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: BN0PR04CA0053.namprd04.prod.outlook.com
 (2603:10b6:408:e8::28) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 97ceb4dd-a0be-4eff-72ce-08df2e38dd8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|6133799003|9063799003|18002099003|22082099003|10067099003|3023799007|4143699003|11063799006|261009223027099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	PW+jf1yRnOfflKrF779lwYcKj5fw1cNSuEpGIAQYveYE/X4g1cVjR7gkKKpThMD7zmOYJfB1RsKrHUh/eaM2XQQEUydPQKXRiBNiWAxNzsHfu86yeRF122ZdNmyoVfIMysX4uVslGL3rRVpHfDqyyzTPI5P/s9cRMZH656S4gvyS6diUYGqaZyLG3/ReKSm2mAIHGI9ZHpxlGtWKFSv8sU4jzaQ0IbX6PsCL4ovbRIqTRF+n+O1HrL1LGx49WUD3PekKBmLvw/3at9ua2b9NGVKA5Sl127DfjgMM9y5/5nSY3AcexirCf8TDBc3Zg/0k9dWzICsQV1UG3y9P90kqhdw4bpzwg6p8Kh2z3FzRdmkvq2yNuVwtmGuoD/z04XBXZCld0QzVz7AZ/fws/i53R46AtWBvQ+qegmk/sBTM3bDQVKtmTrr83ixyp6OJU90xyrRjBoUfqutxA6u6o1QHKb7w2Y7gJl4iOyB6/zn4D/BAC7cqDocB6R69+CkizZ0+TMf4oNASm4ag22gYhrNVxT2x1kVtDzLa2FAZ0mzEae9dJnQipDN3P2N3x/CGeK9agj4TZGIjIS+eg76u7GLnIHt+PpnuNsSYJNX6V8UGM8WFgno2t44L9yYuiBuqBOsrzRbby74Oc8m8E6btHpmzHIEophWg/UHord2ILWe3sCc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(6133799003)(9063799003)(18002099003)(22082099003)(10067099003)(3023799007)(4143699003)(11063799006)(261009223027099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OUZjYUkwanZJSHMxSEFlQUprSXRBNlRqeEJ4MW1NRTVvRXhtNEQ1WE9XK0NC?=
 =?utf-8?B?WkMrNFhuWEk2M3p4U3RyVTFPSlJMSmxXT3JlZlR5dGhob0JOQTMvZEhJSEY2?=
 =?utf-8?B?Nm5ORzBMUGNZTlFYUFEvTlFvOVZUQW5YRUhPSk5GMWd6ODhpVGNSbEFLT3BF?=
 =?utf-8?B?TitPcXZoR3ovQ1hkM2JnS21aeTNJc3NYQWFkRk5OWTBmNHQzUUJ2ZkVPRVBu?=
 =?utf-8?B?TVlDMGpNVzFFSGFDVW1zM0UrTjh2SzFnT2F3cy9rSmRQeXprOXk2Tll0OEVw?=
 =?utf-8?B?dWZpZ0laKzBsQlpmTXpUOG50QlNTUHgzMkFnanBtRVUrMEI2TXQvalN4dG9U?=
 =?utf-8?B?VTIvYlg3blZqSytEaGhzenJ3R1Q0YWFSYnF1L3VYSGxUT3VIRmlLZ2hwSUMy?=
 =?utf-8?B?YmZHeWgrYWM1bVhOVDlyZXFOMU9YdVNFcGwwTmJSNWVvNGl0YVVZM09TdnVE?=
 =?utf-8?B?ekpRbkFtSUNQbEFIcTZPV21sZU1NQVRHTkgxdGlUOXNKM2E3eEdUY09wTmlo?=
 =?utf-8?B?OTlPQmZ5bTRoNnB2VXNaTmFxYWEvNW5vNFVsUWd6d1kxYVNvMUtTVlA2TVMy?=
 =?utf-8?B?L2JiQ2UrbjRnRlpDd200dDdNKy9KVjRsdW8weUk1aWJXcTFkSFJsZFhneE5W?=
 =?utf-8?B?K2I2WXRZZ2RLRUNjdlgrZkpmeHdRc3QrcE15LzBBV1Yvb2UzNUwzLzJwS0tW?=
 =?utf-8?B?VWVLYUJlbkFzdS9Cd3lmODBlc3VSQ3hXZDZ3RWZZY2ozVklTSWM4ajRwVG9B?=
 =?utf-8?B?UWhDSklkdEFGOGt1aWVSYURWQS9FWm5jZ09jUmwyd0JPcXArWi8vWVpwc2wv?=
 =?utf-8?B?QmpGVUxhWW1ycExmV2swb3l2MWhBU2hCTjRPcGk2Mm53WG5VcW9ZcUZnOFgw?=
 =?utf-8?B?WHlVcGY5aytoNEdySjJER2dLM2VWZmMwUkppRWkwNlBYTzFzRGhxdUYwZWdJ?=
 =?utf-8?B?dm54b3h3MmpLSDgxenNzSFZTcE1EVG03Uk9XU0RWWi9JeW9UYVVJZ1p5M0Z3?=
 =?utf-8?B?UHVVOGcwM1hwWE50N1l3c2ttSUhteXJnZDBlajFwM0FyNkFWREY5UjB6dmt4?=
 =?utf-8?B?VWlrY1ExS05TenhCc2gxdFVEZlNSK3BVWHlJRGszZEwvNjJCNHZMQk5PWWNM?=
 =?utf-8?B?WFBJRkRrdGhPNUVoNHlFWW4xd0tYQU9iUkd0b1dFR0V4bk9IVFJ0djV4ejhh?=
 =?utf-8?B?VWs4aTVZUlBRV054YWZkMitJUDhZOW5QKzJPRWcvVTQvZFdHb2hwcE1lcTcw?=
 =?utf-8?B?dTVLMEpYUEVvbGtqUUxiYXljaGxTeng3SklqVDV0T2hPOEFmcnc0ZXVHMjNw?=
 =?utf-8?B?b3JoaHZXNWVPVG9CWGhQMW4yOVZzUE1pL2VDNjNpQnBXYXRlUzUrMm5qdHhY?=
 =?utf-8?B?UjVzejBXNnV4Q3g5Skk5NVFxM0JrWUlxKzNERDBJcGhXS3VPVStnU05UdENT?=
 =?utf-8?B?UUFBOVVyOFpHdGVJaTBWRzRRRmtqNEs1czlwTi9DOE1WVVV5WEtla1l1TFlS?=
 =?utf-8?B?a2dWWXduQzVBcTFMY2t0azhmOXNONDlGdnhoeUF2ZjVVZGlzenFKUVVJUVNB?=
 =?utf-8?B?VUNRRUhZdUlaYVpNb2RUbkY5VUQ1MEZoejdIWTR3RkJhbVgxdGhnNWpFQng5?=
 =?utf-8?B?WFhUWDByL3FxeEpYUXJHWHFMOGp3Rnp3SkFIRVk4Wk4xOVg2cDVFMjNUdStT?=
 =?utf-8?B?VTVRMnpaRWJRK2tpUDMyMmVBdHJhM2hLa0NMem5xbm1iWGNkYkczamNhWWNs?=
 =?utf-8?B?SHZ6b0k1ZGRNY3oxT2M2ZUN6OVVLamVXUW9pZm8zTjNnbTRWMXV6Q0VwMlp5?=
 =?utf-8?B?V05hK3dXQlRhOWtodEdidFV6SmtXbDZ1MGJSdXJuQ1ZteDFnTSswY2hWWlVy?=
 =?utf-8?B?bC9jaUl6aXE2QUh3cUtsWDJHNmhubUVSNTM0bTFOVTlLNVhUQ1ZvVVRBVFor?=
 =?utf-8?B?dU0wRm4yZTkvNUJEeUg2V3ZqQVcrMDBwSFpzWEJqVk5EK0R5azBOZW42a1V2?=
 =?utf-8?B?aVViWGNod3k2bWNRaWxvNVZodEZ4WllKSllqbm1FSUF5TzMvTm5nQlpPSEdR?=
 =?utf-8?B?R1BsMWVVR1JzRmJKYUk0UkZCZTJvZ1QycXZ3OFNVZGxzSUQ4dlBHRGF4QnZz?=
 =?utf-8?B?ZnRnZEpwZkR4OHdPSXphaWg0UTVOOG9SSUdTbmk4ZnViemRYUG8zYU5nZ1Rw?=
 =?utf-8?B?aU5rcUJXTk5XUVhqOGJFWUJ2dFZJRE5MYTlYVlVyYU4wV3hFL0ZvVUloaHVZ?=
 =?utf-8?B?TXVybW5hQ1hlMHhYZVd4NHVkSkJYek5VSmZDQ0JRRmdoRlg1cklJaVRENDRa?=
 =?utf-8?Q?TwRuF7YqFhtEcvyc4Z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97ceb4dd-a0be-4eff-72ce-08df2e38dd8c
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 23:29:48.1490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z3B7fzKXxjeFH+2abDyP8M9pP9zPJeb5J8uuhOlpZe8ZFfJEe5yjrmSVOSWT3DMr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8789

> Describe the CTLV transport, discovery, wire format and userspace
> compatibility rules.
> 
> Assisted-by: Cursor: GPT-5.6 Sol
> Assisted-by: Cursor: Claude Opus 5.5
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  Documentation/userspace-api/ctlv.rst  | 507 ++++++++++++++++++++++++++
>  Documentation/userspace-api/index.rst |   1 +
>  MAINTAINERS                           |   1 +
>  3 files changed, 509 insertions(+)
>  create mode 100644 Documentation/userspace-api/ctlv.rst
>
> diff --git a/Documentation/userspace-api/ctlv.rst b/Documentation/userspace-api/ctlv.rst
> new file mode 100644
> index 00000000000000..5ebca3d4d94af8
> --- /dev/null
> +++ b/Documentation/userspace-api/ctlv.rst
> @@ -0,0 +1,507 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +==================
> +CTLV userspace ABI
> +==================
> +
> +:Author: Jiri Pirko
> +

This could use an introduction:

Char-Device Tag Length Value (CTLV) is a flexible way to describe system calls
delivered over ioctl for a kernel subsystem. It provides a 64 bit operation
number with variable length input/output arguments described in a YAML schema.
The arguments are serialized using a TLV scheme. Strong support for
forwards/backward compatability is baked into the schema design.

CTLV excels for uAPIs that are too unconstrained to fit in simple structs.
Things that have arrays of arrays, variable size structs, variable sized data,
strings and similar which are challenging to represent.

As a transport CTLV uses a global number space. Inspection tools like
strace/seccomp can always decode a CTLV ioctl without having to know what
subsystem is using it. The global number space is organized into families, which
roughly corresponds to a subsystem.

A family describes what its devices accept in YAML, a generator turns that into
kernel metadata and UAPI headers, and CTLV validates every message before a
family callback sees it. Userspace sees one character device per instance, one
ioctl, and ``read()`` for events.

> +CTLV is a transport for device control interfaces. A family describes what its
> +devices accept in YAML, a generator turns that into kernel metadata and UAPI
> +headers, and CTLV validates every message before a family callback sees it.
> +Userspace sees one character device per instance, one ioctl, and ``read()`` for
> +events.
> +
> +This document is the ABI. What each family accepts is specified under
> +``Documentation/ctlv/specs``; writing a family is :doc:`/driver-api/ctlv`.
> +
> +Why a TLV transport
> +===================
> +
> +CTLV puts the rules of every operation in one description and validates them
> +once:
> +
> +- One ioctl carries every operation of every family, so a new operation is a
> +  new specification entry, not a new ioctl number.
> +- Attributes are optional or required by declaration, so a message can grow
> +  without breaking a caller that does not know the new attribute.
> +- An unknown attribute is refused on a request and tolerated on a reply, so a
> +  new kernel can say more to an old program. A request may mark an attribute an
> +  old kernel is welcome to skip, so a new program can say more too.
> +- Bounds, lengths, occurrence counts and nesting depth are checked before a
> +  family callback runs.
> +
> +Devices
> +=======
> +
> +Each registered instance appears as a character device in the ``ctlv`` class
> +with a dynamic minor::
> +
> +    /dev/ctlv0
> +    /sys/class/ctlv/ctlv0
> +
> +Sysfs shows class membership, the ``dev`` number and the device-model link to
> +the parent device. There is no family sysfs attribute; ``families-dump`` on an
> +open descriptor is the authoritative answer to what a device is.

I've tried to like this but, I really am not a fan. I think it
reflects too much of a netlink influence.

My two biggest problems:

1) This prevents us from incrementally using CTLV as a more robust
   uAPI. Like if I wanted to start using it in vfio for new uAPI I
   cannot

2) It destroys the kernel concept of a cdev subsystem, where we have a
   distinct class, /dev/ directory and cdev nodes.

   Lots of tooling and userspace is geared toward working this way. A
   completely unstable /dev/ctlvX that could be *anything* will need a
   meaningful new methodology in userspace. For instance anyone doing
   containers that wants to pass these is going to need special
   tooling.

> [ ... 143 lines skipped ... ]
> +An attribute ID names the family that declared it, a group within that family
> +and an attribute within that group::
> +
> +    63           48 47           32 31                             0
> +    +--------------+--------------+--------------------------------+
> +    |    family    |    group     |             attr               |
> +    +--------------+--------------+--------------------------------+
> +
> +    CTLV_ATTR(family, group, attr)
> +    CTLV_ATTR_FAMILY(attr) / CTLV_ATTR_GROUP(attr) / CTLV_ATTR_NUMBER(attr)
> +
> +An operation ID is the same shape with the group bits zero::
> +
> +    CTLV_OP(family, op)
> +    CTLV_OP_FAMILY(op) / CTLV_OP_NUMBER(op)
> +
> +Use generated complete IDs. A family's header defines every ID it declares
> +and includes its parent's.

I'm OK with this, it seems like a fine design, very netlink inspired.

One of the nice properties is an external tool, like strace or a
seccomp does have enough information to capture the entire operation,
including all parameters.

Though I wonder how much trouble it will be for userspace to form
these things.. It has to pre-determine how much memory it needs then
fill in this structure. That's not so easy to use.

How hard would it be to accept a linked list, or array, of buffer
frags? With some strict rule that a leaf attribute cannot span frags?

My thinking is userspace could allocate frag by frag as it builds the
message instead of being forced to do a size, allocate, fill sequence?

> +
> +Request occurrence order
> +------------------------
> +
> +Occurrences of one attribute ID must be contiguous within each request root or
> +nest. ``A A B`` is valid, while ``A B A`` is not. An ignored unknown attribute
> +is not an occurrence of any known attribute, but it ends the preceding run, so
> +``A ignored-unknown A`` is also invalid. Different IDs otherwise have no
> +required numeric or schema order.

I'm not entirely sure what this is trying to say. Is it just a single
ID must be contiguous if it is repeated?

> +
> +Attributes a kernel may skip
> +----------------------------
> +
> +A request attribute, the root aside, may carry
> +``CTLV_ATTR_F_IGNORE_IF_UNKNOWN``. If no family the device answers declares
> +that complete ID, the kernel steps over the whole attribute without looking
> +inside it; without the bit, an attribute the schema does not place where it
> +appears fails the request as it always has.
> +
> +The bit forgives an ID this kernel has never heard of and nothing else. An ID
> +the device's schema declares somewhere is held to that schema, so an attribute
> +sent where it does not belong fails whether the bit is set or not, and one sent
> +where it does belong is checked as usual. Every other rule applies too: the
> +length has to fit its nest and the header may carry no bit the format does not
> +define. Replies and events never carry it.

This is pretty hard to read. AI?

> +
> +This is how a program built against a newer version of a family talks to an
> +older kernel. What that kernel knows is validated, what it does not is
> +ignored, and a caller that has to know which is which asks ``op-schema-get``
> +first.
> +
> +Executing an operation
> +======================
> +
> +One ioctl executes every operation::
> +
> +    struct ctlv_op_exec {
> +            __aligned_u64 op_id;
> +            __aligned_u64 request;      /* struct ctlv_attr __user * */
> +            __aligned_u64 reply;        /* struct ctlv_attr __user * */
> +            __u32 request_len;
> +            __u32 reply_len;
> +            __aligned_u64 generation;   /* queries only */
> +            __aligned_u64 cursor;       /* queries only */
> +            __aligned_u64 reserved[2];  /* must be zero */
> +    };
> +
> +    #define CTLV_IOC_OP_EXEC _IOWR(0xBB, 0x00, struct ctlv_op_exec)

Generally I've ben frowning on using the size arugment for ioctl. This
means you can never make that struct bigger, and that's historically
been a bad choice...

I've mostly been using this:

  #define IOMMU_DESTROY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_DESTROY)

And then put a length at the top of the struct and do the

        ret = copy_struct_from_user(ucmd.cmd, op->size, ucmd.ubuffer,
                                    ucmd.user_size);

Kind of thing so there is a solid compatability story.

> [ ... 81 lines skipped ... ]
> +``ENOMEM``
> +    The kernel could not allocate what the operation needed.
> +

EOVERFLOW for check_overflow failures

-- 
Jason
