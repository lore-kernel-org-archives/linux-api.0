Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792452724;
	b=gvoArjvx8XJv+zoW3TDXf61zFJsG4Sl5Tx2191D81dRxaPNxIRBswDxgvUrg4Yih3/TE
	 uv2czH6NCkOHh9Y0XoQNZUQKOyF+Xu3S7wkuQwnbCPVC1NofW1TphmqP0Ds3eW+V6QXYi
	 2BhcXx50axgZXhbPXESh5E3hBRydj8AXN7bftgewQspR32Y+L5n4kT9O7+e/qWJzYlBqe
	 eQpHPLA0lEppYaYheSN7mNlwZb7DK3SSi4t5g0fxpS9RlvdPrm4l5cj/TFuJU2311AdpE
	 VL5jSVR41LOh4VroYSJ/e6p2m1wkZB/a+R6KHe/8SvtUpMG5BsLWsowcxAsW3eKYl+w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792452724;
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
	bh=LPnhIweAhW4UynW7YD2xT9gUh8SNgOX7jRw1weiNRHI=;
	b=YBBjlvhrULT5hivPfotaf1jjs3nIyyJZ7gGFnZFjXVkQC6OwJMsUKsFxzgW/7JbXgjxh
	 fhpWLkLfz/NXV5BpFhH9BfQ6ofWo95PFsoIXaNvfwLLUS7HVs9Y5dBe0/VHIj9iIuqMkY
	 /tIw10rCvVZ/OdlSjtQcTmKJgBGNi1QAqD2oPVkspvIaKrwL84wFXeRb8nX1G1ZSHyjl/
	 jGCinHh2dWVqY8oi+tOimlBXxgxeW62n3gNcrfGQgWtmj0DGNYPBIGYPjbl4gGEd+1YUA
	 VNw8N51lm3ApOp6Y+x+G0ezwsRQaFCjw0IUuf/Tw/zV0/fW1ikL1dYzol5OUcW75jSg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gipmJMaD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.14
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010014.outbound.protection.outlook.com [52.101.61.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62A0606A321;
	Mon, 19 Oct 2026 23:32:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B62A0606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gipmJMaD
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m82DHEWZGNu4j0uN90IMVTETHPzDxZ7VW4aRKoxWtdZmcTvriftPQczw7OjJdoPoNCjDnD0omimD7dFJYcYxFJ+64hJ0MjnVRo8gL6f8LuvAaJhu5QsDUKzUCRL84AVsIohlKMspykvpgBm4P9AsVtxLACx1bHPgmjHmK6MDkqqfLjekMi9kAkFQ9Fy7T7mWq1OOIoSCXSt5ya65agd1YDahEKTVTGfP1H+xtGE3qy1oAmCauDBlJRqDl7U+OcQUZ9yrRksOxEj2wPWzSGD0vpuxngT2Khoo/qt5FISZav/9ODHddk8ULEB7EPP8Qigpx0C62Z37vMgWYcUn6Wbh4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LPnhIweAhW4UynW7YD2xT9gUh8SNgOX7jRw1weiNRHI=;
 b=DovyZ5eiDtTBS8Pc9I3xYrSD5+VOpVTOoI5yoI8BtqNVyDEy4jPclMHkcKkIeAkbtrdaLdXNIG+JA9hBW9ObBl+zOyZxtZJ+EBDjLq7pJASzYxdKpwQhcIIs3fwaJhliu2IiY6F38DYCwpBG+ODVEYr97oU3cfj+N3lz2SaxlEaEa4rZTK5ymfEDDpFS3Z6Sq9odQika1gPtB4Q+pWETMnGn8FLBk8JQT4WTH0Y+BLHqq01/uYMkXrHFhG89T61+fwSJZIGlo6badZ8AsLLC8vanGZkV8CHyds554iSNDbZFns0f7vpAPh1tWRu6Qa8itsEPmvXPEYF53Aq5BRvkkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LPnhIweAhW4UynW7YD2xT9gUh8SNgOX7jRw1weiNRHI=;
 b=gipmJMaD0mvePZlD7Dou9MdUWMyfpreaGMYpETkMeWM4zEoNHnMZui1wyCtneFawJ7DIpTNAgEAKZe5p+oZiMLJUDzLjkt4v6XocuhLBUvkYvqFt/YuUmBnTki6v2CHi2bieT/Hlxe/b+XtMGhR8OTsEP/f8gKnDuMPcwc6thu6e8nN6azYXszCfTkjmIWnYP3XfdxcXlUFdW+FhoYPpvwbvFvrGU2ALR08QsyydOgMgdiE0eghqCZXu9UeWGlvG01ym3ZNNAyuRoQPkKvzmaIjcrT7ivAtTV4+C/+b4/F9mZwdOrT0x8Gbm9tEA5X/+yZaPpgOEZUa9k7vGuranKw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SN7PR12MB8789.namprd12.prod.outlook.com
 (2603:10b6:806:34b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.18; Mon, 19 Oct
 2026 23:29:50 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 23:29:50 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH RFC 13/20] Documentation: ctlv: Describe how to write a
 family
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
In-Reply-To: <20261015145053.3664509-14-jiri@resnulli.us>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-14-jiri@resnulli.us>
Date: Mon, 19 Oct 2026 20:29:45 -0300
Message-Id: <179245258505.58760.3972297562218204862.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: MN0P222CA0008.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::12) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: eebb7eac-2f0b-4ea7-e6eb-08df2e38ddf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|6133799003|18002099003|22082099003|10067099003|3023799007|4143699003|11063799006|261009223027099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	s1evXvf+nAQraqxg0fFjlH8LfUhVnNLVwauV9A5PcQtUSPZXVvXWv4JBmRqFx/F8PcyAfxbGoDkAeAgKARXcDJa/q9AnremNPBz48n/LXH4TrEG9uu00mc6ppFLJBe5czoa5LW5n+UlJ8U/KU2G1xiCxkRRVH74v3z+vTXuYU2QTfspLAgQ4Df8LQ172S9JUEpSJcePXwCT3oSe2+KYcSK1BdfPE20pMGymjitkV/3IXcngjtJo1qICTI2AiWSWLgpbsRGqFfKUisI0FAT+WpdV2dsdTjFk1Tht3isMa62HwkpQOXURNskDrZaCt5/e0R9DxWrB1RSA5VPWNvgIb3acNrpb+gIYGvkEIPDM19kSAUH8lTkbUoodHti+9obVv8lW4PEawl8e2Gw3bivE0x3uCZAej0DiGC4nKkeY61ZTXDtqRQpy0aCWw9Pbx435wXLX0tORZjSwxkws3GhQ7theBVwapR9jPGo+es1qS2PWtRqiL6ngN4ge8BEll2XUR+D/Ksvu94ASfO77aaNymcOkDJ1R4+tpFnZm1APky/lAEBfLwItXCM98hlgogcZt9DVk9yaowMonBpNVEh7/HMCtnMKgs3Q1t/8iP2Ed6yzN5ovsMxO6qvRPM/BA4gIATHRd7wqZ4DJBJCUBrkgko4xG8E0+pOqNVk9+dKNAb/I8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(6133799003)(18002099003)(22082099003)(10067099003)(3023799007)(4143699003)(11063799006)(261009223027099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y2h3YzVsSGhlSjlBMkY5dDZ5MzRnUk5vb1VjNm1JdnRaVTZRV0RrNUVtQzYz?=
 =?utf-8?B?NDh5bFNQM2daMmcxZTl3dTZCMEtqNDFRbDNxd0VMUng3d1htZTJvZ0VuYnVt?=
 =?utf-8?B?cW5PQ29ETjczOXBCelBxUThadTlOV1NJN1ZTRXRQZVBJeVkvVzdLeTFydHlQ?=
 =?utf-8?B?RnkwSjlCSE4yOHl5Wi91b01ZZGhwUFhNOVI1NUVPdzdPQjV3dStNUVQ3SjdZ?=
 =?utf-8?B?Q1hWL1JQcVlxV05LMjlTaksvSVcxcmRzUWdCQ0tVemg4UFJLTDNGOFBGbG1n?=
 =?utf-8?B?SWRCb0hBdlFsZ0dCcEhvUjh2M1dETFIreGkrWkdyblBVMlFxSjMySHYraldn?=
 =?utf-8?B?YU9QVStkWTk1SmVmQTFTRXVJSEVPOVVsUFRtL25CeGZjZ2hnUjN5bmJGUndX?=
 =?utf-8?B?UDQ2Y3R6NVZ4djFYMUNjUUFUeTBYSTZQSEhBN1Qrd0NSM1FBN0VLZXBPUERF?=
 =?utf-8?B?YTRXQ1lmV3Y5aUhSMlZJeVRzQUJabnhrdlBNWlB1NjBIRDJ5U25wckRGUFds?=
 =?utf-8?B?dUFYQlpvUkRjSy9FRlpNNDFqYnY2QnhWUkVUZUVsWmloVFMySlU3eDJpMDU3?=
 =?utf-8?B?ZnozWFRLWUcyeDZxakUzNzE0RGg0R29lSXcvQmdxeGtWT3lZbkl3czZ5VUV0?=
 =?utf-8?B?MTZYUFgrMDUwL3VBS0tMNWY4NWh6S1lNQUJIUTRpT282UkllRHpHTzRZd3ds?=
 =?utf-8?B?elhnNUhGaEtmSVRvdVNRd3pVak5qSUJEL0VxZnAyU2Z4ME5tL3VyMjZMbFYw?=
 =?utf-8?B?SllvSWtwVzFjVDlOR08zbW43ODY2RHJsVEd3bzJpQUFtSDV4RW1pUVNqYWpZ?=
 =?utf-8?B?blJaZlBqTkRScExJRW1kT2QyVUV1VlJUNmlTNS8xV1B1OXltcWZFWXNjTmQz?=
 =?utf-8?B?OGtkRG9GNWROQmVlQTkwM0RqL2xMdTJuTUJNL0pMTDNobTk4SHAvYnJNdXF4?=
 =?utf-8?B?MElrSzRZZ1VKSjJoc3ZRVXp6VU9VenB1Y0V3ZzBrTytuME9IYzcwVnh6NXlv?=
 =?utf-8?B?cEpaMmp0eS94bFFDUXl6NWZtbmc0SGF2OTVRVUFQZ3U0VldDeEhuMDRzamhY?=
 =?utf-8?B?aHVxWjdwSTQ2YzdtWlNqZ1VKTlFEVU01RlNoWG9TOU5QMnVoT0I3RHFsTjB1?=
 =?utf-8?B?eDhGTkdyRDRzZHhCMXlrZjV3VEdsVDVORnFFMExjdTV2VDhyeFNKZnhtMjhj?=
 =?utf-8?B?N2RIeDIzeC9Vd3AwbmJkZGlISkxyZE9CRmVUcU1reVhFOWU4TlZZRTlUamdn?=
 =?utf-8?B?VjgwVzRMVVhxcDE0QnF4YWNqMFJRTUlUenlML0RoV3E0aU4vUXJNd25vOWta?=
 =?utf-8?B?YWhEeXlUZ2xTUXpYaWplWTlSSm44WUVxRm5kNGVvNDV3eUJUSjd5UEpaa1RH?=
 =?utf-8?B?YzdRVzJLSkFIUFoxbVhYdWxXajlacm9wMVkzYmJOd2RwenQ0SWpGcFZuOEJ4?=
 =?utf-8?B?c2dRa3NFM1pCeWhyZnR5WVVwZGJaUGgxTGQzLzFwZFNvMDJRamRUQzh0ODZU?=
 =?utf-8?B?Mnlta3RoQ2ZTOXVhcERiNWVVR0tJM1RJa01CWlZyTys0aGx5Zk9XTCtzZEVY?=
 =?utf-8?B?SkVPN3JiYVkwVGsyYWFoQjlvM3ZpZmZSQVU5T2pEbXJZYUU5T0t5dk9RSTJK?=
 =?utf-8?B?alpyaS9iUDhwM21mdHlURnNRY08xM0MrMmhFd0hzWWZWN084ZndYUjA3Yk8v?=
 =?utf-8?B?Q2Rsc29CV2ZuQlAzQnpSQlRMOXlCVERhcWxOZ1FQWEFTUi9aYm4rT1FKQ2Jv?=
 =?utf-8?B?NjhWbXRsait2M1paRGZ3aVlwYXhxaVN4VnBIa2c0ck5kSlpJUjlvamc1K2Ur?=
 =?utf-8?B?UVlCYVFZbDdubGJzL0JHZy9NNDJ0Rk80UmZKTmppMUZoQklTUUpSaEFTbGQ3?=
 =?utf-8?B?OHk5MmFYZm81cHZzL2RQOHYzTUc0WUxDWE9zdjdNWElvVnJxREMxbWs2SnNl?=
 =?utf-8?B?SHNaSFR0L1NnUWVPd2kxTFN6QWxRVXIzUHRHckFKQTdralBRd1hsZHoyU2tH?=
 =?utf-8?B?QnI0RTNZQkNYSFJROU15UFk2TkVobmwybzFweGlTY1VVTFdHOVIveWZvd0FU?=
 =?utf-8?B?akJvVllzVFBCN0JhamtqeW4wWDZEcW12WGhraXd2eFpVR1NBNWRDOU1SUFhy?=
 =?utf-8?B?aU9zczJwSmpXeS9jSEVFbERDeWFLRy9LRWYrZlpwYkFMMjRHZVoxaEwrZEVw?=
 =?utf-8?B?RFdURHFnNno3Wi85SEliMnUxckZUTmdhYmNjclZZN2c2OUFuNHVmZ3REV1dj?=
 =?utf-8?B?UzczdmNFUW1QSFA3Qm9GTkJ6bHBZUk9obkpENmxWVnJuVzdIU0IwdFJvWUFC?=
 =?utf-8?Q?5j5WnaCaUXNCh8fasJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eebb7eac-2f0b-4ea7-e6eb-08df2e38ddf0
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 23:29:48.8300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IcxPwJULIrop7U48QK6hUlJ3f9bSOKiKZv2XfnrY8Tz2o0LIcK+DN4bfEMFdTS1z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8789

> [ ... 34 lines skipped ... ]
> +Add the specification, registry entry, and output manifest entry in one change::
> +
> +    Documentation/ctlv/specs/ctlv-example.yaml
> +    Documentation/ctlv/families.yaml
> +    Documentation/ctlv/generated-files.yaml
> +
> +``families.yaml`` is append-only. Its array index is the family ID and is part
> +of every generated attribute and operation ID. Never reorder, remove, rename,
> +or reuse an entry. ``Documentation/ctlv/abi/families.registry.yaml`` is the
> +checked-in registry ABI. The output manifest selects the generated UAPI,
> +kernel and userspace paths and generation modes.
> +
> +Generate and verify them with::
> +
> +    make -C tools/ctlv regen
> +    make -C tools/ctlv all
> +

Maybe mention to inspect git diff and ensure nothing unexpected
changed?

> +Never edit a generated output. Change the YAML or generator and regenerate it.
> +Optional RST reference pages are written to
> +``Documentation/output/ctlv/families`` by::
> +
> +    make -C tools/ctlv docs
> +
> +Write the specification
> +=======================
> +

Before introducing the YAML, write out in a more plain text form
exactly what system calls the example is aiming to create with. I came
up with:

For an example, define two system calls from userspace that look like this::

    item_set_action(u64 index, string label?, blob data?) -> status;
    items_dump_query() -> { u64 index; string label?; }[];

And one event::

    item_changed_event -> { u64 index; string label?; };

``index`` is 0..4095, ``label`` is at most 63 bytes excluding NUL, and ``data``
is at most 1 MiB with 8-byte alignment.

> +.. code-block:: yaml
> +
> +    # SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
> +    %YAML 1.2
> +    ---
> +    family:
> +      name: ctlv-example
> +      inherits: ctlv
> +      post-init: true
> +      pre-fini: true
> +
> +    attr-groups:
> +      - name: item
> +        attrs:
> +          - name: index
> +            type: uint
> +            max: 4095
> +          - name: label
> +            type: string
> +            max-length: 63
> +          - name: data
> +            blob:
> +              direction: input
> +              allowed-backings: [ va ]
> +              max-length: 1048576
> +              alignment: 8
> +      - name: list
> +        attrs:
> +          - name: item
> +            attrs: item-reply
> +            max-occurrences: unlimited
> +
> +    attr-sets:
> +      - name: item-request
> +        attrs: item.index
> +        optional-attrs:
> +          - item.label
> +          - item.data
> +      - name: item-reply
> +        attrs: item.index
> +        optional-attrs: item.label
> +      - name: items-reply
> +        optional-attrs: list.item

I haven't quite figured out what attr-sets is about. I think these
blocks should have some # comments with more guidance what is going on.

> +
> +    ops:
> +      - name: item-set
> +        type: action
> +        optional: true
> +        request:
> +          attrs: item-request
> +      - name: items-dump
> +        type: query
> +        availability: dynamic
> +        pre-post: true
> +        reply:
> +          attrs: items-reply
> +        suggested-reply-length: 4096
> +      - name: item-changed
> +        type: event
> +        reply:
> +          attrs: item-reply
> +
> +An attribute has one payload form: ``type``, ``enum``, ``flags``, ``attrs``, or
> +``blob``. An attr set names one message level. ``attrs`` are required and
> +``optional-attrs`` are optional. Its bounds and membership are ABI.

The attribute first point of view is maybe a little too netlinky, I
prefer to think of this as a system call first, with a first class
'query' to get a list of things

Alot of stuff this is going to deal with won't be the netlink esque
'dump a table, set a table' kind of flow, but a bunch of different
system calls with arguments.

> +
> +Inheritance and extension points
> +================================
> +
> +A descendant implements only the operations it declares. Inherited operations
> +keep the callbacks and operation hooks of their declaring family. Every module
> +therefore depends on the module containing its parent implementation.
> +

This section seems hard to understand, it is missing something
explaining the purpose an intended usage of this mechanism. I think I
get it.. 

Maybe structure this to be an improvement to the first example solving
a specific problem 'like the HW driver need to add per-driver
things to the scheme'

Also please use a more neutral term like "HW driver" not vendor
throughout.

> +A parent reserves an extension point with an empty stub set:
> +
> +.. code-block:: yaml
> +
> +    attr-groups:
> +      - name: device
> +        attrs:
> +          - name: details
> +            attrs: details-extension
> +
> +    attr-sets:
> +      - name: details-extension
> +        stub: true
> +      - name: device-reply
> +        optional-attrs: device.details
> +
> +A child fills that same set:
> +
> +.. code-block:: yaml
> +
> +    family:
> +      name: ctlv-example-vendor
> +      inherits: ctlv-example
> +      pre-init: true
> +
> +    attr-groups:
> +      - name: vendor
> +        attrs:
> +          - name: serial
> +            type: uint
> +
> +    attr-sets:
> +      - name: details-extension
> +        optional-attrs: vendor.serial
> +
> +The parent implementation opens the physical nest and delegates its members:
> +
> +.. code-block:: c
> +
> +    if (ctlv_example_device_details_start(reply, &details)) {
> +            ret = ctlv_stub_fill(ctx, request_details, &details);
> +            ctlv_nest_end(&details);
> +            if (ret)
> +                    return ret;
> +    }
> +
> +The generated child callback fills it:
> +
> +.. code-block:: c
> +
> +    int ctlv_example_vendor_details_extension_fill(
> +                            void *priv, struct ctlv_op_ctx *ctx,
> +                            const struct ctlv_cursor *request,
> +                            struct ctlv_cursor *nest)
> +    {
> +            ctlv_example_vendor_vendor_serial_put(nest,
> +                                                   example_serial(priv));
> +            return 0;
> +    }

I suppose this like RDMA and each HW driver using this gets its own
full scheme tree that only has its own stuff in it?

What about userspace, it "knows" somehow what to do?

> +
> +An unfilled stub contributes no nest or message length. Neither side names the
> +family on the other side.

One of the things I feel strongly about from iommufd is that it should
be really obvious what HW drivers is being affiliated with these
operations that have a HW driver struct linked to them.

So, like, if userspace does a query and gets back an item that has one
of these extended structs it should have a trivial way to branch to
the right handler for it. Inspecting the attributes doesn't seem like
a great way to go about that?

Is there some place to put an ID of 'ctlv-example-vendor' someplace?
Like in the nest start somehow?

-- 
Jason
