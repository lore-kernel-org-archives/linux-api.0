Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793023705;
	b=Xr1lh48ok/kTjdabUMN/FjwDprYO8QsqaClDOE+AD1s+ynLZ5EWtdT17YqG9XURXjo7M
	 cCAnFu+49ekWKWWaKlTbvDH1DudLGux8Ged6mMNkNZqmse6tkUh7LEksMtXWjsYGFyrFU
	 iT+E5GY6co2Gbm1Z/VwAH32DOXu/5mV45Bl3trbDLJ+mzVTwynZjtgPNXGbWKbUXafzCx
	 hRX2tWgM9HwogKD7vwGPshWX6eR7ESZeqFQ4PkPWYOpDyYzqbfWjVMl9i5VDcNoNHQj6L
	 wNS1ZmvMu087sLx5AtkUvJQ3TPEctJRbIFJ3Hlck7YLUZhHVEqlBAbTQ4NRwRH/vEMA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793023705;
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
	bh=1uRCslZB4s/z9iMsP0GaZYFj+XIIs2RGM+qGTVO/lEA=;
	b=uPSXF0hkHXEFIYMKF8NaSlRzYNwXdIpHV7ns0qJGdjPw4y6vrGgsgNVyiIFWs/cNt0Kf
	 mFbsGy3UT8viPb+O4bNa2IRgVAh6uSfz+vNkl9LpdRlcrRAREKQgaBT9kUaTUPsrt8N5B
	 4xDkUVPwXww9lcKEiSRASR5ht4bjho4X8xviG1Hhpe3ry1NfDzgbOYPAu+caL2fHbtRuh
	 V1Q4CBr0bxNDrQUfsn4NvBKTqWUYAKLhMmoo009yJrFTJrF6EoOpC8JOIIBUqABblmLBR
	 /Pj3tBg8iIG0Y5SXb9++bmWYjhP1/7lDX4wT5tNU1GYlyZvHcpFrGqBPpoihRe2rgZA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="n+/rnzCQ";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.33
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010033.outbound.protection.outlook.com [52.101.201.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EBA606A328;
	Mon, 26 Oct 2026 14:08:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43EBA606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=n+/rnzCQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gBzuMfqZkR6Y47UxLeBx5Tpy4hdW4zByVtMvHvu5RAzTmJD2UtWhQARA5al60z868aEczxdg/Edzfe274YNV0jDngUQtdhUEZAUviBOwlzcNor6lxZXYMy8OTwGD/KzJ1AC7krG8D3WQwR30Vsz00Oy1WEdoOF6IcJUKMmef+wETce1lFpOjvtLc6A+INSbKzUUm0IfUL3cdBf171r/n2CcLTc28VPejJm9C4I9V0kNSjtUeHJtfyxpp+LYhtgdqXibJ4vGuFqZDJV3tNKVf2HhsE1LQFRUaYxtI8GrRr+Np7dCmrAD5R6UMXCca2udTXnXy2jNYtFpqzUYCknm5DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1uRCslZB4s/z9iMsP0GaZYFj+XIIs2RGM+qGTVO/lEA=;
 b=ZhukPLX1/l0XMFlDbkriBLAO+50AJjtKwQpFdVQc1qnANjH13oqhCVM1BACeZ8PRGVylGogYo5fvL0HFM+zqIYv+E+DpdCISk4d9YXBh1WAuhEcUfwQVknoUIlyHPzrc1GRlirlKoJU5HTNJcTLCdsCiZCGv4f6ff8tfVSwMhGYK+7j2llxFmdCDpxvFb2EgXqZWe/8elOhO4bssOicUQyyPSPU3oSY+FXw/tYIpBacsBE/Pe4o5iZPvcciiKXexoI0fahIeapa2S2LOaE54dnp8DRR+Z89XDqkasM2HBzQgAWtK9GORZ9ulIG9cKNLz2YzHANGa396h15k0hES6yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1uRCslZB4s/z9iMsP0GaZYFj+XIIs2RGM+qGTVO/lEA=;
 b=n+/rnzCQpw6mqLxh+cbJNdEcdL8MlbLm0l+Yle0HQFTO2AqO5m33DQU+uXRBA6NuQ0WoG0XerTo4zQIy5+XXgTM5+GDLES+608W859Qv50NgPweVOEdmBdU2e6N+hogC3o/SHGxJvedc9jfTip6+IHengQw9w+8qvT85f1BzMcGL+kr4uqZg9lNBEcuPAEYhPAxc09J2NwEZQ30gdOvhjvSUsmcSoRWle8q37ArKVLagRVGscvjVC4kR2J0cPZ9BhysAWVECFwY+6dMiBcd1xgDVYof8IByg5txqa8JDfvY3XtMOXor2Qczw4LfpKulXlOsElf9JXbD3FwoiD5SVqw==
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
Subject: Re: [PATCH RFC 18/20] tdx-guest: Expose the native attestation
 service API
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
In-Reply-To: <20261015145053.3664509-19-jiri@resnulli.us>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-19-jiri@resnulli.us>
Date: Mon, 26 Oct 2026 11:07:54 -0300
Message-Id: <179302367453.58760.3338436189030317197.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: YT4PR01CA0239.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:eb::27) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 1d3bbc1b-9e55-4e91-9352-08df336a8c55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|4143699003|56012099006|11063799006|261021121427099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	ieE2f9pHy9JYkDBsDqb7Acm9QMpMYbjguvt6Cl5nNZAHWm8chUcrho3pHhXKbgeTodfxWWi1lTEewGkQqKpz9+f+6HYa22gQV5/hrceqM3SHhiOQrl2jgH90rCtTnvofvS5ba8ALyg88TqeOVAoApyqqNPgSXHLByfqnGjkFnyg8hvpyarQX4tnMQxC/s0SFFWLFPO+4d8Qkh7nv0cESzxcrOTgYrFJoi3iIueQ2L8DWkiA86r07lXj3W4hUo9raumX+3dkRW9McSPVFn8UMeaLIIRByT6HyVeImW6gigUg/vg5EAwT7/CXKVgUoGsYdyfkM04AoKTWkb6NK6ReXIrB5wNPibQV5BBBmJznMPA/ekj+mp9juUzXpLToGOOiwQr2E2pPntmdjoXGIgZGrgbxaxQc77zCm3EHAqPdoPzCocGBpDELbMAXmwOEmBZrE3Q6fC/GYREqoANo44KkLQRwUWvswojtSxtFIPEscdmPNZGlaIAu++F2Z651jEAQ0krJQU4qMEhy7bugy869agSsmOVP1THzmw0xUMabu9htZSGDPrs6cUWwT3Jk+n4jUPPupOBYeSiCwVRyQGqRjWkG/jbSZ74vaV3kBpy9dfqVx/tEP4Ol9u8PRgUEG3yTlvnJxEGcKnsQ1dukLjg0GAjD6YP6feAlud2j7VesOoJs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(4143699003)(56012099006)(11063799006)(261021121427099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SEVqNllKeUUyQm9ja3YzeXBmM0ZyTXlKK1lPTWRQME5SV2s1OFlNTUt4UFRq?=
 =?utf-8?B?V2VrbVZQYVhCN2lXTDlqSnlhajV3M3JFcngwZzdSVEphbTArQndZSE9iam1k?=
 =?utf-8?B?U2tHTDluVTFEUVo4c1M1MFhFVmQ1MlBXeUJheFZEZndNbU1oWnhyQnhRYVBN?=
 =?utf-8?B?djFhVGt4dURKWjV2SWYxbU5wb1BnT1FseE5WVVRGdnFWLzk5VklIaG5NazF4?=
 =?utf-8?B?QjJCMXUxdVZrSloyUE1xU3hnV2FIMjRXUzg0RnFtM1Zhbk84T1NwckhpV3Bm?=
 =?utf-8?B?bDJSOExLekNzNTlBeGMrUXBYQjJCZFFWZTNwWGtOVEY4c1F3RzhyY2RKektl?=
 =?utf-8?B?Z3lQQ2pJdDlpTTlMSlN0RXBqd3hSTFJYSThmNlJKdW00RjB3SVFTeklTcmxE?=
 =?utf-8?B?K0FJT2NwSVI1T0tnd2txcHltQUxNQk00TGlHUU90T0IvMEExYU00KzAxN1pM?=
 =?utf-8?B?aElzYmUxekVuOXIxZXpVamMyS2taV3hwdXd1bHRVVE5sRElmM09FZXg1Ukta?=
 =?utf-8?B?ZW5qL2daUThEdnUzem9hQkthemdaaEdvSmY4VDRqNklOeFZCWk1sd1ExNVNE?=
 =?utf-8?B?a0NMWHVvU0NpejBGNUd3R1JGY2g3cUtLZzduZm54YzRWYTlYYlQxVllXMHJq?=
 =?utf-8?B?dTJtMVh2THFpUTJLcjQ1OEc4eVlnMXdIZDd6YldtbHBVMDJqMXVYSW15a1E1?=
 =?utf-8?B?bUNBY3ZyNmxCd2NXQ2FYVFovZUxhbXYyNS9zdVFsdUFBd0g3blRKZnVjSVVS?=
 =?utf-8?B?TmZUNUNjTUpSTG5aa1pDQ3huUi9NVldSQzV1VTY3VzJHVk5JZnU4UFpBM0lN?=
 =?utf-8?B?cG5WcFlnTWgzMHEyYWpCNWFUM1B2MGJTanlXbStRN25Hc2FUUTFpengzSTJk?=
 =?utf-8?B?UmluRk9Zc3hNaVVFN3NGZFlmSVQyRDFNQ212K21Rejl4WUp0d3J0MCs1dXNx?=
 =?utf-8?B?U0JiVFJOL09ZQVl1N2xDMFB6TVNkTFNBdWdJTEx4dXNTemRMeVczandNQXZT?=
 =?utf-8?B?aG83NnpLN3V1dENxeVg4UC9sT2JGR0xZdXNhZDBlMG5OY3NOKytrOUY4N3p6?=
 =?utf-8?B?RE85bU1nOVdjZ1Y1TWhhTkFxSjlySUJPWFJQd2wybloxcnJzb2RRUHRhdkVY?=
 =?utf-8?B?N1NtTmtacW5OZW40a1U3Nm9pem9EZzZOclMzcmpyTExwUEh3U0N6Ri9yNlc4?=
 =?utf-8?B?MW4vUy9sWDVuRzV1VHNQWTE3L1lYRk9tSk43eXhKS2wxZ0QzWW9qeGh5a3ZW?=
 =?utf-8?B?UDVYQVlneVNiOHlzek1ZZzdiUm9BN1lmVDgzb3ZrWFBmd3psbHVhcUc2eEhB?=
 =?utf-8?B?aTVNMmROdHovbGs2akFXd3hhSWQycER5bjByTUh1Yjh1VDRLdHQrNDdxREZo?=
 =?utf-8?B?ZnBYWW1uekVySmlpcFFycVNLbnNkSG1RL2d2Mk5TTXl4dlI0a0tzQXpNb3p1?=
 =?utf-8?B?VWZwRkZBd0dNbEdFOTJYZldRZnlQY3RiWlU1TzU5c20zUGIrSUVRZDhFNWR4?=
 =?utf-8?B?cDI0cXdNQXkrVVBDaHdicFdvTk1GanNaTHFoTW1wdllrWU1TOXltRk1Yb2ZG?=
 =?utf-8?B?WWc3cXpHNDdWckh4Mzc4dHFTUjZoWGFpcTdUQ04vdG04N3JiYmxZM0YyWVFM?=
 =?utf-8?B?T2svOVMvRnBCYjNLRHFuTVY0TThKWGZZdE9rZVY1bFVXR1FnTEFoMVlKK0FL?=
 =?utf-8?B?K2J1S09EU2ZLaW9TVFdleXRPZU1YVVdZNGVDVlVqZlk5QXdQSlUrdUZkbURU?=
 =?utf-8?B?anl4ZHNHU2lwZEhiZmZOY2Y0MFFCcUpHYkVyNFV1azNyYnZpYmptbk1IdVVp?=
 =?utf-8?B?eStmbDI5bXNUU0psMGJERUJSeEJVNXZKcjdPNVRVcUVqdFRaY1pVaFdXYXpL?=
 =?utf-8?B?YlNBRUxadnFUNjBlN3lJbTFxWUU0N29Ca2N2TDZaaG9ySUI4VVBndEVBTDRF?=
 =?utf-8?B?a0VWazU0UGhVU29DcDBuUHdnZUhPUXFSejBJL3RXckJLYlJmTURKRkZIUzc3?=
 =?utf-8?B?N3dnR3RnZnVCbEtLSHQ3WXNCWVR6YUZKWVhyN1UrVmtLQUdqSWxwK3ZFRzRj?=
 =?utf-8?B?QStYZzVLV2pZNVVTRDBYNUtmYVM0M1RpRzRXeDV3Vlk3Mmp2bTUzVFBlSmc5?=
 =?utf-8?B?ckh1SStyY1Q5Qk0vSlNpZXVxQ0NXK21XUnBhcjNNVnZuQktFdkxiSDM3NEVG?=
 =?utf-8?B?b29iZkU5dThUaUFIY05yTTVYM2hlL0Y1aDRnVCtWWHpKK1plRFFDNlAxM1lr?=
 =?utf-8?B?WlM3Um80c2JJdGExL3ZVWkt5Z2EvQTdWL2o1S1AxQmgyRnBJdURCUjIwNlgw?=
 =?utf-8?Q?iKsvS6kGdm2kZnaN7O?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d3bbc1b-9e55-4e91-9352-08df336a8c55
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 14:08:02.4802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8rg8yUWkbvku/eAZYcgpEYPsIhHTRQ+Vlv/pHXWQILS9JNDeVjOgJ7f1FelPok+z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5961

> Share TDREPORT, Quote and measurement-register operations with one
> in-kernel client while preserving the existing misc, TSM report and TSM
> MR interfaces. Tie clients to service initialization and removal.

The tdx stuff should just be an attestation driver, we don't need to
make these kinds of linkages..

-- 
Jason
