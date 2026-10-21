Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792601345;
	b=HVk9xUkAK4ayzSQmmMNVcEuKQPeUXvPfN8LOa2CZqvzXNmYAiunkjG0WKr58O7Qh7m2V
	 NpGm3Kn7moQV5K2gRjaauWKEPNqltG6DPRr7sX0T/By+9Ur83lBdBDgjbGpxx+o20MRX9
	 4oxeRuDz1HYmg9IdmsDucYNZYv6qqjmGFhFcv1HdvYOKjd2LLGWd/bjzLkf0iQa9IV+as
	 N91t3QyT/hKfhHJ3O4ZITe/MG9Vbh46lMDqly36WI0lLHZxv8QvJNiB2wYNenrdDdPgdH
	 PlI+J/xxqzoMT3lmnqCBigVAD5pJ+pC5/71gXrR/yKC5wR7E4fnQ4aJWBn95NPynCQA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792601345;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=lDwQsZQhtOa/FuGwxo9sR73VmAR9ZS5qdLqliJxxgvo=;
	b=TNd/klG2Ly79vLQW3j8Vizb2gpRy1jkgaK+MIH49mLV3SSEWTem6wOK3kiOIy2lyJaz1
	 PxDsEa+qSObOJPa8b+5y8yoPlF0qq2QoX6YoSxcqKdJww29K2cvX7by7Ywlz+Ru0B4GfT
	 mCer4JlatiRTzLdfHm4wXyPsHqdiluXKOvHTPYmyAqpxS26V0U8luW6D0LS7W+BjOKHYL
	 vol240iuD1uDTXuv/dybYZeZmv5sRlFJFHbd3pXaOjBS05B12VmZGdluFv3jgOCdun8V0
	 YnMEynq23MwtII7riq6PcikeRn6mwnKxVxWTZofBuQNlfhBgkuYEpocu5m5+qcdPf5g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bhx2X7f2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.35
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012035.outbound.protection.outlook.com [52.101.43.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076E3606A319;
	Wed, 21 Oct 2026 16:49:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 076E3606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bhx2X7f2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HaQ4o/MSg2BJgwqvIp3at0SkZoorxzNuhl0EVQ6iCaLBF/ltVcjJTLySs/46l0imgDevF3yOmmsuaNe6sbZ8Gq1kuU4U6PwxJIoRHOK66no0rKg42N4PEYg/ycAXJmvyROLNZJZkCVKKXA5v3JhXYGdxLF9cjsSFPpYMbyrvcEPJnQP+bntTWwVtKaUYvIZQ6os0WD05t4VJ8m+rNirilX9aPbYB0bnACeFHZpSQVFwclLikHtLH8+Y/MKkyUBzPsON1HWBlhM2yAA6cndg3meM+0vWdDN8jc4eYQRIAWcmYTrFAIsfGkRAxPeHYreOORo2dU7+kmQtf5r0Up4bisg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lDwQsZQhtOa/FuGwxo9sR73VmAR9ZS5qdLqliJxxgvo=;
 b=psPUIm8xsTUtaPa2fi6NDcZTi6FKigAAHfVYbCTizG0EF7BvlYn6EeRjq8xk8vQYfYTi7p4Oa3Y8afvMFtmuThudgVPh+etGzgvbBBO9H/OdodgCYGh/50LWDKkm84l0aZS+cZ0lLhHPkaUO/Op9cci2l0HhRKjmqWkJqA6VKXh2dkbSIsMJYwjG9qIO9OosdkM3sNNYi2XGlDiVubYLvqBwNMmQ8HIZO6IwRm4JEwTCQ1eO1QYCRaGCOCBPMasdgW6fUaGqBG2s0G9bjDEBYEeeMjFLy8ThXGFXVnD81GrbBxrvfQ/sSChlYMgh579L6Qewj/GyZPDWCeoeAjkNmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDwQsZQhtOa/FuGwxo9sR73VmAR9ZS5qdLqliJxxgvo=;
 b=bhx2X7f2Ov7kZPlDqxnUK/6aNhOskvFRfAQkm3o22Bc9cWxyDaoq7mtZ7SXVJL41zINl32YrQGXY/k4JbQN9UT5YglTacPkvP705bxyL1mkbckWrXy6vnkCf7sB1cAQOTZQc/8Y0BLxoD94XOcd0gIqMGCh4J5tpLkzT2f28FLALsTulJp02VjB1qNBbKiMWQRx4M5n7iZ8a1LYwuCGcPst4Z3uYKQ8OLsdqFIey3fMtjsTllYUbtA9nuPBbqnNcrJQrYNAztKH7M2xzlfkA6yUoNqM0oEGd8J3grbNcCTlclkLhX7jtsbsjhOjTviFEbTSeXsZ6zlR712+nhNC8Tg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by FT1PR12MB689230.namprd12.prod.outlook.com
 (2603:10b6:170:c::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 16:48:58 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 16:48:58 +0000
Date: Wed, 21 Oct 2026 13:48:57 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de,
	ksinyuk@kernel.org, rodrigo.vivi@intel.com, cedric.xing@intel.com,
	sameo@meta.com, drdeeglaze@gmail.com,
	James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 13/20] Documentation: ctlv: Describe how to write a
 family
Message-ID: <20261021164857.GT3008132@nvidia.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-14-jiri@resnulli.us>
 <179245258505.58760.3972297562218204862.b4-review@b4>
 <atjEgLYpgbZNzfkZ@FV6GYCPJ69>
 <20261021144951.GR3008132@nvidia.com>
 <atjiW8bnqDZ8zb5t@FV6GYCPJ69>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atjiW8bnqDZ8zb5t@FV6GYCPJ69>
X-ClientProxiedBy: YT4PR01CA0503.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::21) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|FT1PR12MB689230:EE_
X-MS-Office365-Filtering-Correlation-Id: db3ccbc5-bb11-4faa-2319-08df2f9333a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|23010399003|1800799024|261021123027099002|4143699003|11063799006|56012099006|10067099003|261021121427099002|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	+9bq4/bbABHpm0JJh2/LdhxAku5GUfTp3gpdNUKgqkEhFfr4samPXjdBhs8aimkkqoX2U0jhE0MlibCCQdZW3q4wsnyxe7U4AS6RZbMGfh71xbxJZq/V0RWut+ymI9gas4j0FtwzcGMacD6LM9s8XZnsj922BBAKzSfAxEI67jhQja33poJ2EmRJ0eRce8HbN7eaPKHzqXZjtfrqVXZdVIc/L4RNj0KAo3XMsTODVhyqBiCmJwp3UWEU6aB3OKgxNI//rQA2dFJoQUbbH1aP0MTsiJN9k7YJHbHPixQMMKD8YvGH0wCFzDCukLjAdAOjHucg9EAcYSiP7TO+/sET0yPZ+uZrsOcX1t6l5KgFkiUZfVWlBhGYRqIdFp9vKoDFkt/5c+QBCHueuwFl5/oNq1ZbqXOrTaIT8GsDmIep+GVQ1uDYkWwf8SqtoZeTZg9D99O7k+Ns0cGTXkyRMMOeGkzRgIHcDCTgXAcquwSoTwx/iac5vkv1m+1ajR9SS7O6JC8BhgLh+zMdXEnKCBEp9U2+JKdQAIUQ7+atm4jRctnVcffdoQW6Pz/Af6wM5D/qmPUcM83lfC3bmucnOei2e2sbAr6OkJDOyAm66aTcHMWJy/l1elC+KAZ8xrLrUwptxdqs03nWbIsh6xEJ2ZzGnZPojI9MG5evyRiPoKemNZY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(23010399003)(1800799024)(261021123027099002)(4143699003)(11063799006)(56012099006)(10067099003)(261021121427099002)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W0M0w7zBFqg4DVlNt4nd/MveKQeso/1rMEfafcd41uX+9HE1AQTvhcvJBQaP?=
 =?us-ascii?Q?kYLjzbCJh9k3dmaqUhjqdDn2nfcwrd0YR8p2TD/O8Is05un9YBUt99IFEfH0?=
 =?us-ascii?Q?ehn4ToBFDjuGsj5aC8mojUIM9lXPGK2kv+aG4PBoSIrlSMviTw2pDcfBbQt0?=
 =?us-ascii?Q?AtlAVMM2juFpMJ/qw02H6rpeAcPH7hp1AEU/m+WdIb+2GsmCeEVddt6doLpz?=
 =?us-ascii?Q?fQWJPuvQQ8jKq1kYyyMfBOYwTOMOnqGxwW/S3oPrK0kECxKCpQFQGK4hjeTc?=
 =?us-ascii?Q?iOOHNIshsI1GAuatrwmAgCgG2NervTE6IR9pnIe+5TFvmEboRJ9+PksUkjHN?=
 =?us-ascii?Q?5i7v2Ml8j6/V+ibz2nrdP+J4bMkwWJsQcHVcn1ubtzzmBlBE6KazWXtb6exq?=
 =?us-ascii?Q?H3sjVSFZ7ftKNEDgyoyIBCTzu0BqbsYyNL1RP/EmusIRzVCi7t3nGAccGKY7?=
 =?us-ascii?Q?LHjmdSEbmnXthofZRBosgxudg/3Gx3yXGCmdmnma8DtceT2qK40W9tlRHL7N?=
 =?us-ascii?Q?mLU1Z03D17xvuOml37z49+N8O3c2dx1Mf4yzCAz89iDt81ctChaFgjz5zJxS?=
 =?us-ascii?Q?r53e5ZgyVlhvc2NNMZOV4v0OrH1iBPmxVuO5NpWuKrbH9JELvTGz+eCnvEmC?=
 =?us-ascii?Q?Be3VOe9Le2jq2kst4AIocp+C+McH1J9AMeN/4yEn3NCmUDt9oUP2jxZsOEIw?=
 =?us-ascii?Q?kQcPIP7VqaykLuW5m25NSM61GUdBwmwhgox8ZFYpc1hHs9CmAFug1lEDj6x/?=
 =?us-ascii?Q?oecCHio9hoTKL+5tjSyEcGVCv3IYMxmnKG8cKW2Iin81wFDo8BZTo0Gm6kq2?=
 =?us-ascii?Q?M9DseGFxEZsbKcxRQYvDt5vlNBlFDCFi5I/3WFYPNuwNjHehZ9lz8hZ9vX0h?=
 =?us-ascii?Q?xskMAbztYvZO3vJ53tH/9zMxUtfixKPDWSHeUBg+UqDFkjgHVTY8PSv/+mvk?=
 =?us-ascii?Q?Jp+lRi5efsmiIDvRHizYQQZGI++nmdy54ZFOs+xOBeC/psIlCqOI1gWKS2D2?=
 =?us-ascii?Q?rwZ0C1GLMNUXRtrbzvkNG7744qzEQ+MwsiRBnwvj/xtph2g5h4ObrT536Xm3?=
 =?us-ascii?Q?cHAUeVDoTVmHfU+tFo5oCiFWtGRpOxVH4eWqzi55x9R49yF2KDAGREKwj3NX?=
 =?us-ascii?Q?WCg79H86i6fTHRfv3cKRJ/Yo8cWZjxZSHulAYKBZ+XWLytpm6W3cCNT55UkR?=
 =?us-ascii?Q?0lyzXTJYTIuhmv/oWRGXwYp0gQHF/QY2xZTxkIeQq0Vw0/BZh0A+8cfVA+ZO?=
 =?us-ascii?Q?iSq3Uhno/gj/UwaDOffzLKKIjp591+hIhkqaNpEF07m4vAiFErO6R1zEM0YB?=
 =?us-ascii?Q?LOwrhyMBTWEhULPh0JgdkNIrmpxNjAoS6yTW0RR3uvd/+Vm3p0Dc5AHqYID4?=
 =?us-ascii?Q?066LYlvRN/lJMBR3vQof9CkDOX12ddXw+vkIrrRKwU66psjHfC1J57vuuOMQ?=
 =?us-ascii?Q?1vOyHXOkN62jtPAcHZQhnqUFMxYgCxJX6KkmYHJ/QlxAKa8L6Y4nAoH6nNzL?=
 =?us-ascii?Q?cPVqmMY6bDcs9lBwTt5HPLUzGF18hVtYHmJwsvicByUgnG0KV6rysbAtXAbS?=
 =?us-ascii?Q?QJyYbjB/OINPJkVLwcMH6X9QhqB8R5iZxp6e6yTeOjdnbbizG+TyEc4K9T4z?=
 =?us-ascii?Q?5tqgSeBDWlehNurxME6ZZ2CaHph3bKOi1K2AiLBuahfNeHiSxGBt2g6pEhbR?=
 =?us-ascii?Q?ROrqNOQOtAu0oGC+4fiJQDXtkKOXBWTYi6jYU5xri2joYc5J?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db3ccbc5-bb11-4faa-2319-08df2f9333a8
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 16:48:58.4486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tv8QLRxtcQpxc79gV/ktfWGGQeEv6DldUDauKfzpHr+atbGgJZVQQ6OVXL8xiPbF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FT1PR12MB689230

On Wed, Oct 21, 2026 at 06:24:12PM +0200, Jiri Pirko wrote:
> >I haven't got that far in the patches, but I think it would be good to
> >spend more time here explaining the fundamentals of how the extension
> >mechanism is expected to be used..
> >
> >It looks like RDMA to me where you have some 'common' and some
> >'driver' parts but at this point in the docs it isn't clear how that
> >is reached. Like does each driver gets its own family? What is a
> 
> Depends on the consumer/subsystem. But esentially yes. That is what I'm
> doing for "attestation". This patchset introduces ctlv-attestation-tdx.
> Next we will have ctlv-attestation-tpm, ctlv-attestation-firme,
> ctlv-attestation-armcca ctlv-attestation-spdm and others.

Hmm one of the things iommufd does is to have several different
drivers active at once within the same FD. There is only one char dev
for the whole system and the VMM would operate all the hardware
through it.

So in that model individual calls are marked with the driver's
identity when any driver specific data is passed.

I guess that doesn't quite work in this model with multiple-families?

But it does work well here, and matches what rdma and fwctl did as
well. So maybe iommufd is weird.

> >> >What about userspace, it "knows" somehow what to do?
> >> 
> >> Userspace sees the family chain. It also has ability to do introspection
> >> seeing right away which op supports with attrs in which nests.
> >
> >I was hoping the introspection would not be essential to use the
> >interface..
> 
> Depends on the user/subsystem. Either families_dump op could be used of
> udev uvevents that also carry family inheritance chain:
>     CTLV_FAMILY=ctlv-attestation-tdx
>     CTLV_COMPATIBLE_0=ctlv
>     CTLV_COMPATIBLE_1=ctlv-attestation
>     CTLV_COMPATIBLE_2=ctlv-attestation-tdx
>     CTLV_COMPATIBLE_N=3

I wouldn't try to link it to udev either, by the time some userspace
uses the cdev the udev information is gone, and may be unreachable
from inside a container or similar..

So there should probably be documentation in the subsystem how
userspace should learn the driver family via introspection.

Jason
