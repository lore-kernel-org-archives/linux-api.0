Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031154;
	b=cD0ySkrke2HmrpnXwObjV4yJ/3itIFRRUxl7juy4msXZn9J2P1SSJnPCd6XUFaoFt0N1
	 RSoALeLPQmF1+NtHsswyO8cLas+oiSz8hzSeobW5yEDgX64SI0RqwEcuRLoJTlJDppLbj
	 t/9JqpS9nfmkD/dgW06jZevyYBWi6Pc1TBqMUukjzIQcr9x+M0qaRBcaXmzbfSvV0AxCA
	 J8bH4UN7YDOsAGFK0kHD07DDjKveKKiv8KXd7LnaFVqZYJ8+YrRvVMQa6+Fr5mh2QaXqs
	 jXs2nv0EvjJYhrgMLIk21Pp8YXK0K5GIyWcJ4Rhi3xjs9/HyVF3T6mYomg5srIneKZw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031154;
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
	bh=jlkPzgTlmUMOKrW11p2Wj2h4Qapw8gJ3Mse34u5Vu34=;
	b=OwEKztxgqakw7Iibc4RxFrw+d0aMSGVAQyPR+SysaBJf7mI9rc2wmuWHy+k3YDFkrHg/
	 AMMgLmmV0J8Ai92S3HUm1bnBxFJzwsyBA98jbnX0FA/Y8N9082iEOdzHh7MBkME24yXK6
	 xh5P1wk0TpqVOC4PfaHOOUvnyb54azKEBJL9dVs8YBJnWU0QEdTmeaQZA5uQ6vAdwiW+3
	 6piwexxZE3s0RTqKNWVNgXB9QGue5sQLITlHrlXCJCC36JF8wVDObO1CrI/jlguan+KQg
	 6v+fpQDJevEzA8zAzZg4i4edD8d5/PSnQ/Z8DQLv1fKFOZFUtMNJxd1vBkCl/cHAArQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VNkRZ8gs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.48
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013048.outbound.protection.outlook.com [40.93.201.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FA1606A31A;
	Mon, 26 Oct 2026 16:12:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33FA1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VNkRZ8gs
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WmHCN5CcKMI7Inqcr4hQND48iB4MZYug+znLE845FJuPkThTvxGYRFAOAFTcR3y04e4DtuVyDvl8FtzskSAsNDMOVrW/sjLKpuAIMjyIiUyvtkFePGaAvJJ9G6RAXx1OjK8s9mcidD7jRrH6XH5rP1aye9I9Cd4kGHmu/Pfy4SEl30mz20fQfI+DO0UUYjREBrRJpEjy4UtdBBwqKTz5D9yuxh+zixhMy4g4x9Sv075yrKAgXBSFOjvo4Bl0Og78yvOAN1CBDrr1/4/h3qob2MPMkC8hzj/sm2iakurRdOy72Om3Ok8H1foTKGeW/oOkrQIhWKarp6/XG6Ykstx/ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jlkPzgTlmUMOKrW11p2Wj2h4Qapw8gJ3Mse34u5Vu34=;
 b=I9k6kg41OTMnva3aeO+aq+ia3RNxKWIaEZR/Qa1LXdSh2KsBuwdGmRdGxNpC6DPziKR3s7bpsWbJxoKo0STTMtsjxs7Z5Wdqf+QkDJ6w3/K35yVHKCjzDh15KP7o5dzMpQB30uKecR9qN/Nbl3XX4pSJ+Gi/UsMPDZtHe2ACsonuSMq2Wx/O/sxnkdcs2ckd1cUalf7opxmSIIilDfg23jlWvIZfIE2Af2GrL8QSzznXB47RkOgABZgBAfBJerP2TdOS0czy/iB+HIWcKdjNd5dJRdl4hCb9Vz29YcSQ5v0pRjDymdcz5x5ZjzSiMvv6E4FaPuRivYfZKMl31yVUkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jlkPzgTlmUMOKrW11p2Wj2h4Qapw8gJ3Mse34u5Vu34=;
 b=VNkRZ8gsVSwVIYc9y3gPHhzxGpt1F4fSTi7KNVOpgxm90QDs0Aqmw0lAFQO5LUA1XmOkVPozfhpjTE2l8iEHpmk42x7LKpasMFYZeMjt9Pae8Z+ITLUqn1fo8cPHDu2CnXSxzT4ZatO8bTQ8UevWPmMHGxhU7V11+/5ujyH5ASxDA+uK2YSxvYyVLWmXc8nN2cm67y5r+qw0gd9kLEVqHdhqX9w/1X5JPMlK7ME3fS4iIaFzfEp4yvZXPooWrXkW06LlvoISMq1vu8e0uzXj9OFTwdct+zkpx0uL8bStpmW7rw8wlrMi8m4u5QBUENfIhILhEyNCwv/qgSiYwRuWPQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CH2PR12MB4312.namprd12.prod.outlook.com
 (2603:10b6:610:af::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:12:21 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:12:21 +0000
Date: Mon, 26 Oct 2026 13:12:20 -0300
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
Subject: Re: [PATCH RFC 11/20] ctlv: Prepare runtime introspection
Message-ID: <20261026161220.GA1671235@nvidia.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-12-jiri@resnulli.us>
 <179302367452.58760.11808905856343064399.b4-review@b4>
 <at9nsxtGOl3N5PJR@FV6GYCPJ69>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <at9nsxtGOl3N5PJR@FV6GYCPJ69>
X-ClientProxiedBy: BN9PR03CA0373.namprd03.prod.outlook.com
 (2603:10b6:408:f7::18) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH2PR12MB4312:EE_
X-MS-Office365-Filtering-Correlation-Id: bbdb8a00-d070-40de-0138-08df337bea5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|22082099003|261026121527099003|3023799007|56012099006|11063799006|4143699003|261021121427099003|10067099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	F6w0XDT9LyST6qOcKb2CDq+wuUDQb3azPD+hJHg7dQzVw+/rFtGAEU8D2nVi+JRvEwbjQCsE6ayM1ARCjAZzhIObxDbCLX5RMb+TfnvGOVSCOwhL8SO1BK9+9YxRnpKJnZBy30vm2nYxTrS84ZqNtaBTy6LC+h9FXEVTcmhTFXxqEiFSr5U5mFvZBXKpZPG2UXotTEIwYjp/F96HcMVDVs/lqyMEWjadjkfTEiD0WWZrn6ADUR6E1FnzuIdGWhe2LZm9T5mrQPo19Sf4wQQTNrYtKYwtQi17l4pOtsojYpwpMWzakHT6ORm3ZJT4rMqjYBLQb+KD1owNHUuT7wp2WmG3q22Bz0rFK0ifry4I6szig+TPiTrCG27s2BnrdyjDSmChDska942Cb6n0KZOiYvUa+Si62Z7fqGQ5BSkjxN3sJixQydsaKrsCe/kBMGH2I7/jSMzDAZcwBkLeyFN1JGbHP2CLe/ZdMWFPxMRdkKP/f8TKTtRtBV3VN2ekH3JDMESXZ873rStfAT7mqGQwldTs2vCdKQaviUO/R9POBfHUoHPtq2vcvl0inE0NnssEG0ypNDVhd+YgqZ4rRVPW/yaPzYHenbIWgPaAIgQ9DTJwqWzoujPRIKlhnD72aj+odH56w87woTwpKmhebwYDYme7IIQ2oN9RXpvZwPVQZSY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(261026121527099003)(3023799007)(56012099006)(11063799006)(4143699003)(261021121427099003)(10067099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QPF5V16Gu8NFRhgj/OAzwLAMqP6iS7NPDPhFOAr/XpJ/RK2ZuTOF3S68GG3H?=
 =?us-ascii?Q?hQEMiM216Xodwp+uV3MGvA6sQZ305F7BhxvkMw1lE9SuNQzYlSISLVUL9XGA?=
 =?us-ascii?Q?2Kf15koZpSDGlNPNu3rbz6XNCLL0+tZ79V0Z3rLMHUSCHj2oAuXiJD3k8Xgs?=
 =?us-ascii?Q?3vV59wuav2UuSD2vt40rJIdYAH8veinOqgtBbyAe5ld+hU/TfW4fPT1JuQBe?=
 =?us-ascii?Q?EErot6t8BVhW/ExLcbrTLLLomnvr+PXZ6YO5Gt/BTix20tqEzy1W3VaJ/+hv?=
 =?us-ascii?Q?GwOoB5IRwsZbtDDvrEl+zUxaMsTWqw28U4Mq/qHl3CHlFw3HHe35URJ3oZTv?=
 =?us-ascii?Q?vSfmqMrkbcb27qgFfP2Myys3HOhJ4jpeKIC58xrsm5vwcISec5KJlr6O2xBb?=
 =?us-ascii?Q?cF/q2QE1q04wrj4BzsD/d9ux/fLNqaUM4ALm5TQEtLT7a/SKxD3vaHBUCu49?=
 =?us-ascii?Q?DcGfIUVCtj+YER+oScaTProtCUluXTSsiQKoq10kWW3izmpNzPACfe9LadBK?=
 =?us-ascii?Q?hIQzXpxAMofLg39qsPsIb+BMD+Z/ABCuXxuLS8u3rhhV7fop3bJRbqz7J75N?=
 =?us-ascii?Q?WFCagsGAwR1GH5HJkUd7JdSeCUhweBgmNyOBbn2IjiiG4aRmDw4fcI97bqnZ?=
 =?us-ascii?Q?5m+9vV9c2uyL8WjG5mFAyUZ3GLcTynmtwk/X9eVfoAohpLhnyPbNN00DNi9Q?=
 =?us-ascii?Q?WjZKtiioRDXznzs4DloD3jZvRuEgq7Ch9Ygb56smRqjPjoiL0AMBiUqxmIo0?=
 =?us-ascii?Q?mL7wlrXMqap+egTC6jMpbwKGsDgxPUz4tQdRdDR5xbHT5eXgQ3g149u4zLq/?=
 =?us-ascii?Q?uPawnYlikcP0BTioqwrC7fUs/Jpru0k/Ju/jjchg0wBrjWNtDRQJwo7qtGQ5?=
 =?us-ascii?Q?nr+8IPEL72S3ZG57gP6ewdxoWRS5qPVNCxi0nJeLyPcpAg9ysqF7W8qzKUJM?=
 =?us-ascii?Q?CESOiAbxWd0749c7qpnUuXEFnCmfAfh87rbxX+GVnDXa5+VtEmQ7rU8pbJAq?=
 =?us-ascii?Q?Wzd1lIL9NJeaDMhZgQ+teScoQEI79ABkiKMeUqBX7E0SnYPhVPVS9EMQG5bh?=
 =?us-ascii?Q?vq7/pI3Zl9B2kuXAwbwI2WRWkQkcF2oFa02iidJUHl7F55U0aFTbK8P15HwG?=
 =?us-ascii?Q?op06xsLN9+tmlLS9qa6ry8remCb3q6lO1UgDipVC1+wGvWNlcLwIBjsWUBxb?=
 =?us-ascii?Q?jrRrMEB2n77g5/f+KqIr+GabsT1Wvd8S9oyqGOhuCmexIbksULI9CG2MCwWh?=
 =?us-ascii?Q?61f6mcWaM+bE4uWjSFTAjgheE0N1S6Adot7tgCL9fzXf3hu2/ei3k1cnWHTg?=
 =?us-ascii?Q?oEGqtMop6Epdoj4wk03CHLoNVHUCWGBHN5CsqkArD7qY8PkwJkF1jJmihTZZ?=
 =?us-ascii?Q?lfMJIHuisFk1qk+r6vGby2ff0xeySMTrYHCPSEgdWZBwfKmqaiOkq/wdpcr4?=
 =?us-ascii?Q?OdigYp18hpDE6DY/sj8uwKbYRoqTR5+Vze9m8eAWSR2sJNnU8XnCsox46zsq?=
 =?us-ascii?Q?jWAlq38ETsIDUyWhWhkj5WYzMHbe3QFdYDiq+j4eEVC6SibSPm/qlTgGm8bA?=
 =?us-ascii?Q?u1ndEsiAHAOHmwRgWi5nMu17XG8R8YRYZw6etkDrGe+tG83sBx0SIKBjjQhD?=
 =?us-ascii?Q?baXmqOdbyqtuolsZPxl2HFPRFFh3KCe4WDcS4gpiqt524efSRJ3+687hTPA4?=
 =?us-ascii?Q?gsiBfVfI8fYwRDAUMV+jBIhX7483J7ponXdvOoyW2rSbmGFS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbdb8a00-d070-40de-0138-08df337bea5d
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:12:21.6990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D4tUu3CnIgi7PfZwokGmK419h3hSMflqsHwC8zEWObXc3+dVIoXy+5vrwPvgF0CX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4312

On Mon, Oct 26, 2026 at 03:52:30PM +0100, Jiri Pirko wrote:
> >device-get:
> >  request: {}
> >  reply:
> >    caps:
> >      evidence?:
> >        min-challenge-length: uint
> >        max-challenge-length: uint
> >        max-total-output-length: uint
> >        objects[]:
> >          blob-class: evidence-blob-class
> >          format: string
> >          representation: evidence-representation
> >          max-length: uint
> >      mr?:
> >        mr-flags: mr-device-caps
> >    info:
> >      $extend: device-info
> >
> >So.. how about could we drop the sets, use a direct description of the
> >layout and do something else for the ID numbering? Maybe the numbering
> >can be solved directly by only listing the names in:
> 
> I didn't want to have a lot of duplications. Netlink show us that the
> same attr, or attr group (or nest) is often used in multiple ops. It is
> not good to repeat them each time (multiple obvious reasons), so I came
> with the sets and groups. But I will think about how to make this
> possible to be formatted in more readable way.

If a "record" is re-used in multiple places, then sure, put it in one
spot, not disagreeing with that.

That can still work out with a clearer top down flow, more like C:

records:
   evidence-object:
          blob-class: evidence-blob-class
          format: string
          representation: evidence-representation
          max-length: uint

ops:
  device-get:
    reply:
      caps:
       evidence?:
	 objects[]: record evidence-object

Jason
