Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793023693;
	b=iVef7vGH2C8Oc6INFpPhPlX6ElEledM9zCoo6FvhF7HyOZfn17z1wNKchCAvsPukN3rL
	 XsFdmaEo8/Tx1LVoPKiy+8BFnVL/5wkE4RFPl0GibOeihb+jbiYZEPXNHZuhT+beQiwho
	 lD2ddSQKZtUckzcGU0gp/uiOBEVLD0ZZ6dtzA9l+N4RY7anUteWnbyLvfqEfvh43+0OJ7
	 ln/wS18uLSSDywzSIdnUnDMwI+8ysLaIu8DLbsmYfXIPlyFdJx7+8qXnqqAeuBuOdD4Ao
	 WsRwa7PJwgVDmnNuITkzgCGvKhSAmNFpjM/ghaErpij0rfdue7GaURd9IPumQ2lhvYQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793023693;
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
	bh=WT/3Vc56g9AVZri9yPVSIiI+UMp0M+8LgD0vE7JEXWg=;
	b=Wz+SM8s1+OlY8CpmGStZpiH/9mquwEtSjWto8Tr8pa/ioYhi9CIiCQdeOo6QFW86N/vA
	 muylB+X7ICbMIXkAmciij5mYiyd/3W4cT1aKa7Wm9vYn7cq1G4iOmwZ/rS6X9kJal1qPb
	 ooLzXAWkqpGyAESBOe/DKFa96AeRmCtvbxMQF0NNZiha3eZCkpIGe+FGu4En1IGRYSNdx
	 /m4+QAdVutlo4rdayzW4o3X419dTpungqej0KtAZAhEv60rtSlAUJ2fvMjVIhug8bP8yf
	 hB5/ibbpPLJFC2527YaqQy2FmilRE2h2YEz4pRnOeS9WPfEgtueSHgT6yH4YIrxHyCQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=V5YV3lxG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.33
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010033.outbound.protection.outlook.com [52.101.201.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF4C606A31A;
	Mon, 26 Oct 2026 14:08:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADF4C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=V5YV3lxG
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eFXRDtn4myLqMs3jfMqy5iY9rzBogZCWD49BUBvu0d34657v4ZAF8sEuzijEbwbgHL0zL+kHC+MwCFSEexTlJmNc0+3LHW8yZbAlvUng4rNm4mFyJ1EXNHO2/j7eGdQL5jdv79kO/n3VEM5hjKfXYSndfW9QMgJwAgOYb1p4Is/QbOtnISrm0YEYqQXnx+lEBMikUUJTa+DsCyrJtw3j+NwM4xas++g0S5qbyNdMK0CceKFOaSuTuKi2SbM3orJNI8HMspgTQf5haMbaUN2218H7lP+cYm0cPidtpRHHABQ/10bCtu5GC+0vm6/AOWRmqST8AhRt7cTCAYCva1Mheg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WT/3Vc56g9AVZri9yPVSIiI+UMp0M+8LgD0vE7JEXWg=;
 b=oBCkRA8AS/FvxU7+l68nQqXM73+dMDtG3gtoy6sqwIUREOAfHuEOFJNhYF4N5DCeDdpFSlAIBm4xDC1b17LQQ3Dcg7g6sGHaPpwOb/9QzG7d21WxW7822JaLwIkp1EmanVFkoFS5drBpI+EgV3i6drKcUlm5cbUomoYbCQ0WvW5Z0GFUSmmSxbkNUK7tniKaRoH6vioZK+sZNloOM++ELaYQK9icJIxTzaqx7ebT3rjwP1roJXUJZxnYN5VhGmqW/ubHiurFJP0LR2HWiaUAA86HjU7DSJR4tvHHURDLhoAt9AU5Wv1wIrnKIb/wgs4QkjEjb5/ARgGxsRsn608p/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WT/3Vc56g9AVZri9yPVSIiI+UMp0M+8LgD0vE7JEXWg=;
 b=V5YV3lxGMLa5m9FZZlJDa1IYvwRJG+fPFpjZ8IaGIhw+qBaplB01XsDg0Ocg50Qb31DKxkxoMs737Mqlsdg5CPSBcpoDiopEiSQdk1HmGJiUioYhTF/w1XCfzjJIvMKAXcnJPpT0M5Ejj0TUQ47ntCY4jCDY8/SqQ8onHB1sX68npiG/9ewQTnWXrJD50wh2s+LqGqUmxA/GjW7nFWQzhYw1oQKdZm6F7wJmAgOXsmLQuTwvBvjiCN1pYlqk5kpSw68dvfHLxS316wozsjME9czUZmk/RBgn+IEQ6XycZvPntEH1nXIMAb5nIFYa/1DekS8PsmgzPmmqCdX2yyYYbw==
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
 14:08:02 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH RFC 10/20] ctlv: Prepare event queue support
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
In-Reply-To: <20261015145053.3664509-11-jiri@resnulli.us>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-11-jiri@resnulli.us>
Date: Mon, 26 Oct 2026 11:07:54 -0300
Message-Id: <179302367451.58760.3073439917920385955.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: YT4PR01CA0287.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::9) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 0dc9ad9d-1d02-4b5f-2bc0-08df336a8bd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|4143699003|56012099006|11063799006|261009223027099003|261022105027099003|261022075727099003|261021121427099003|261021123027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	1cA3s4L9LqOgHJrbI57/FGsEyG59a4QK2rAUeQrNEChm+7tW8MYyI6eWZt9nIqb0I9cko7mx0SXWtYxMpBeQJ57Oo5TaAZ9lsUg8fl8kCZ06EX1OGaOIGu1LOrG6irZADYFz5wa/U3E8OtHmrdnuWs98vynwxEHb9qQvETRrQo+oWqlnbMPYadas9uGKsZCvSJliTGCjLts4mQYqKF/Ts5em8GMCuedUQwEudpEG9waqrYJeAlrg+GamNjvRKMmrQLSqTt72mOs0GzVGGJF/aw4xvpjR8O0Rcizo5a1Cf1E7FL9jjKirCoj2a9EYoeYB++XyuQOcPAym/OzkHhmfTXiJOaiTBZMmytXuwL5s82RClwHWtFfPQ4BtETyDxl82e7lYe/O+O85oR7mVoBnxLPIzvbic9kC3FbxBg3Ko0tcFgQ6LQNd+lM15NmPMVyw0u3gEHHjipcXBevdFohb4JKudYD4oe4zDU8QsB0GHa1fwRokRZWYdgV2e/LPfDADC95sH6TF973p6zCGSbaTQSQBYH2uvdzEVXzpjIZQilJ8sKwpifndEWnxQTkXZ8vGn36AqJPcrHeFv5xhk0Q/OkTAkktAwQCOjbSvJ07wgldsByBhZrN5TuLscygKJmUSrYRIAMdDdzLpi+PrXNGvqhRa4vCDmPNfumm5H+xvs47E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(4143699003)(56012099006)(11063799006)(261009223027099003)(261022105027099003)(261022075727099003)(261021121427099003)(261021123027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M2tHcXJHcjNFSmVqVnlsQ0wrZVY5azdmRnZaUkVFeERoYS9rd1NtVnpvam02?=
 =?utf-8?B?dkxxeGlDcS9WY0syODc2b3JyRWtCL01OWXlCdGRUU2VXMTB6b0I0TWxEdUtX?=
 =?utf-8?B?RUFPNDlSTkpVWi9mUTU1a1VRdmhrWjhmSm5NZ2lqdytQL0tRbWx3ZEZ6YUhW?=
 =?utf-8?B?OVFYL0xibDdBbjB1SExSaVBIWkVPSjZPMGZ4eVN2K1ZRNm5peEFzSHFPVHpL?=
 =?utf-8?B?bGFaQlFaTk9uUmwrcVNheUQ1M3VVWkJ0TDY4TVBBTnBPSnFMWmhJTDB3RTlH?=
 =?utf-8?B?bDB3bW1tVGRVVkM3MUdrUkV6L1h4dW03d3REL3ZoMW5zRjh3UXNzek9hdWNs?=
 =?utf-8?B?VmxZUEd2OHh2dGNuMWZmOHkwQk9jRDh1bkRaV0F6RU00endQV2NLT3JvTmda?=
 =?utf-8?B?akRBNjlDeUN3QVg5Y3Q4NS9BMWhXaUxjUUpEaXNRN2hnMG5KWXZ4MWpDZ0xp?=
 =?utf-8?B?UWZ5S01vN3o1WTlGQmdrbGZJVEZGRktmMXFBMElrckhiak8xQXpvQ3k3WDBV?=
 =?utf-8?B?dUhWV1dBaUF0ZmJJWEM2dWFQZUFielA4S2hEekZzd05ST2IzckhBY2V5dkJC?=
 =?utf-8?B?M1RMUFB4a3RnaHQvbnFpMU5zRU5DRWc2YlQ3TVlaeFJYc3duRWZPKzJVTitB?=
 =?utf-8?B?UFF3ZGRqWDBSSWZzQ29XcTZrcnZPSDNScDBPQ2hLZm1OR3JIeGk2OTRxQkpO?=
 =?utf-8?B?d3U2MzVaenR4OXMyVStZaFdHUy9Ec01Fb0owbGhWOFBuTkZXL3M4STVzaTZm?=
 =?utf-8?B?N3lMa2xDcElyOTFHRGt2bkpXNVJ6bXh1cVFPVUYzQ2tPSGQ5c1F5YWtIQ3hq?=
 =?utf-8?B?MnRzOWpXbkN5dTBnVE9rV3VLa3FMUkd6cGp2Q1JRdDhNMEwybHkzV3Y4Ykdm?=
 =?utf-8?B?RVY2TzF4Kys0N3VrN2xOQTJSeDhLdC8yNkVxbzk3enBZaVJoZHFaeHk0SnlD?=
 =?utf-8?B?VnluSWR5c24yWWthK0Y1VEZid2ZPaEdUb3pJTTdKVjBZcGZVV2U2REpCYnE0?=
 =?utf-8?B?Zno4dUxSZzRkeXBGY2JkWFg2MXVnYk5lNmNyTFkyLzZMYWcvVGx2TnJiNkxB?=
 =?utf-8?B?Ym5GYVNwU203YlJLTFFwUG9Wd2xzSlk5bVdHMWcyalJLMjJpUVBuODN0TU1a?=
 =?utf-8?B?UFRwcE4ramVkQjJqMWluUXA4MStWT0lDSDFFWmNoRjJ5OHZOWEVjbUlsdTNQ?=
 =?utf-8?B?TnliVk5BN1FRTWZ2aVRBejNzUTJERHNpZnVUMlpoVEdXaW85eC9VQ2dNcWJD?=
 =?utf-8?B?eFZKOUF5c1ROL21wWmg4NGVWYmpXV09rRGFldTV3dnNmalBRREhmYjNPOWlr?=
 =?utf-8?B?YnlFUFF0WVFVYURUblYvOSt3bVZzb09lQk14SUNXT0lkdDZEZkNITDc5RWZD?=
 =?utf-8?B?U3RUMXRqMVJmZEw0bzZjRW11c2hpR0pwZ3BPWERvY21NMjJsSnRqM1Z5UUx6?=
 =?utf-8?B?YkYwWG5QZ0lWd3hPOVQyYk1xWVZ4Q3dRcmNmN2NTUDlCU2NyVDdsMTN6YTE3?=
 =?utf-8?B?NFk5c1NYZ1gyWDVZWjFIUlgvZ1Rod3pZVHdWeUhEbkdMb1ZzanpDTjdEZmFl?=
 =?utf-8?B?TndaaVRXUzVrS2ZYdFpPMUY2c0lkY1FkUnFneTJIbzNPN1F0Q2JKc3Bjd0Qx?=
 =?utf-8?B?b3ZHUFVZb2ZhQlF2YUhYWVhtd0R4YU9saHlxUHFKRUpBek9lbmZTeUxORnlv?=
 =?utf-8?B?VWU3dzJGTVM4dmhONHNDazg1UmcwdzBwRFVuTzdTSTZKR1A0TTZLb3NHNkhB?=
 =?utf-8?B?VGhIVjNpQS9UOVJtTjREbDVKZjIrOXc0MVp1RWUybUlSSnh1TlRuUGFYNk41?=
 =?utf-8?B?dkkzVDhWV1REcE1CYy9UYW82a1BHVW5COW42akYrNmo1dlZMbXVuci9nVWxn?=
 =?utf-8?B?Ykhvc3BjU2tWQWFRN0syNktIcEttbDR0UndJbFhJZkZuUkovUjV3WkhOODlQ?=
 =?utf-8?B?N1BmckpxM3N4MTVROExBZGJHbThuMCs0eENtSExzeXlBTTVhTHlUdG5kWlFo?=
 =?utf-8?B?WjJOSkxFL1pKa2J0cWhGa01GQmlkUDBEOGVDemo0L1RGNDU4dXA0NHJ4QUIw?=
 =?utf-8?B?WFVYOEFzTGFnRWxnMmVtWlJxbHVnTHJxN1B1UkRQTDhtd0Facm16Uyt3a0ND?=
 =?utf-8?B?YjVmUHNITkMzY2d0YWJyamx6MHVuUU8xMHI1R0pCRWtTVFpHNnVkY0NsMkZN?=
 =?utf-8?B?OVZKdkcvd3FqSkN5VDNwcC9qb1I3NUwvMnhHZEN4OFN6eTNzNW9xYzcwV3VC?=
 =?utf-8?B?bUZ4YSt3MTNSem1IUlY4bkRnMnFrQy8vNC94OUVtUXY4dTFpektTOWtoUG5a?=
 =?utf-8?Q?h2y1gNEXOAo0YZi41h?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dc9ad9d-1d02-4b5f-2bc0-08df336a8bd5
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 14:08:01.7171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vJ1i7f7qabhnyEv3ivUJ7qdKIKy9MRSoPapsHy7BIvP5mKKZloPqi3XndvOtLAWa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5961

> Add per-open subscriptions, bounded event queues and event creation for
> CTLV families. Add the generated root family kernel bindings now that their
> message and event helpers are available.
> 
> The event and generated root objects can be compile-checked here.
> CONFIG_CTLV remains unwired until device dispatch completes the module.
> 
> Assisted-by: Cursor: GPT-5.6 Sol
> Assisted-by: Cursor: Claude Opus 5.5
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  drivers/ctlv/Makefile       |   2 +-
>  drivers/ctlv/device.h       |  38 ++
>  drivers/ctlv/event.c        | 713 ++++++++++++++++++++++++++++++++++++
>  drivers/ctlv/event.h        |  69 ++++
>  drivers/ctlv/internal.h     |   7 +
>  include/linux/ctlv.h        |  27 ++
>  include/linux/ctlv_family.h |  11 +
>  7 files changed, 866 insertions(+), 1 deletion(-)

If we are deferring the mr log, then events can be defered too? That
would save another 1kloc to look at right now.

-- 
Jason
