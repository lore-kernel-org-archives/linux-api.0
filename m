Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.22
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793299416;
	b=gLPP7deBKwcBKLzofr+yclIAhQyYchjf0z648jm7IIUGOXZGroPxQWAx20Wp1aTbolfT
	 MQwcEn3/RnaLry5Rkoh+lXqTZGkATkj+96SrpbdFhtBmVllCPL3oPa70Bc64WUoIZUMul
	 bZa5VYLD/ZpLdw/ydVfiKKXd7e1ia71vzB4jzOFWSmL2jOdvia1r5gRzqingUzi6FuBdT
	 jnrkYC2JrSnTLUH8xckpsgIrIamx1Lx2iMLBf+GCltY2UHkEJiSDr90J3m0LxTUK1N7Rw
	 Ttmkg9OJU3KR5fT9CrIIQ/EpjhsdGyf9dWuk5vp1LWMcyp9l2jXFi7e1W4eW8W1Nq+g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793299416;
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
	bh=ry+CDb+yJCC8w5K5tQWHKlcwqLC9+2T1t4oKed4/sKQ=;
	b=N3qptXhwyA8Z9GlZriztCAdINFmmxKHZJf08do6SujQJsN+B6gqaHkmp6TjYIWVPFXvE
	 6IJ8v5JIJ3nyYqbE4fIiWuRPufr+fQFjEfK0FeitDBu6ojEzG3vZHy+UhsYUrQbMI1dwJ
	 9FQF5LhTY06ILWsj29dmHmzV+UgZU96KTOSVmXSJwr3x92ORthrer2qOBmIqz/CHQ/jtD
	 QVT1+qS3r2ZlpTf9ZGBfiP6jV/64KNm7xUspKs+C0CY9iHABBhUgBs6v0JTXXFapLOy78
	 wlgA7pdb5/V8ekMMXBvOO+iefdxzCVRk1ETVF1CBhcosGzxWFx1FKmp7i/WwsDBLbXA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Fp0hwjIO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.22
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012022.outbound.protection.outlook.com [52.101.53.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A260606A31E;
	Thu, 29 Oct 2026 18:43:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A260606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Fp0hwjIO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KD5Vzw9lWcF6KRZd4nRbo6t2pY1zrspyr4ip37dvivT7Ai3M7m62qDOANyhKGjJNcFDDPNJ/Q0UnDQVdjvVdXc3mFSPzW9WHiEvqRQDXK5cjhdaSF8lpz+vJzUuchLx+QKDyZSY44//aolaVdlu1gHG/56c1+C35hodAVVZ5peCYpU7Tp3F/XLzdbTjDXZc7POk1r1p0US7/Dp8F2K57hRRBja3mtm3svzxd+b7npV1j3pR8nIGGbrj1qACSg6Q/2Sutz/owsUNLNGrxoVIH8E0Iu/XfI0yy/4b11EP/0yadQn0MV0MKFaj0LktAdUh0yTNV6A/qpkR8Ty4PK0FMDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ry+CDb+yJCC8w5K5tQWHKlcwqLC9+2T1t4oKed4/sKQ=;
 b=Tm5lyHHvueztoBNtPWjrgXlMwpDBFaFviGgzNOetxAiA0sa+qe7AJFWt/d3IBz0yJhMj6C/VFKFYLj20GszDAN59XPWv23lZ/Epp0Fm0RqFMfiibk1rIt0q/Zd100zKf+2YpnyMOP8ZM4YZBDzRrTACvtFL3jx5/EkJjUa6fhfuC0PROzBX6aSxu/TGWu4sBfMGBCm4ApxKpJaQavXPlz4jTBwYv2qToe1Tltn+YdjNyIUgrhuwkXg+rSm93G0RQaS3xxjIYbpz3U0IFcTb+6DCMYQCe448M5l6n8Ac9U4+fMZCUHSOvuyuJ8ryQ5rZJwQC9ZZ63B/1beNrReP22sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ry+CDb+yJCC8w5K5tQWHKlcwqLC9+2T1t4oKed4/sKQ=;
 b=Fp0hwjIOqpltloh03Z4hBYSzHWO0oEptYM3fVEySNHx+IIVeHIQRCRH0UmXYkZvbRyBBdq37qAlBJ374zAjjMOe8ENYoLIJIIpHfLcr35VmTA9GypxdVkqllMPkybgb5AHQECFtjA5phId4BZxpmq8VwWckR/lIB3/+y1mAkgRT7ivER1SkdKQMe3R1/tG6O5icsmDL4FnOqS6MUaklDilgzgLft3KHfSXm51HqWJxWjiGXmHuNAsQPe5C0mYLIAVclPwHgetpEOVRRv6alqAWgcDGZiHOMJMOqzgAsE0RRDdFPB42z76vGviJQhjyZ5Ub3acxitvT/9iMXD3SbiQw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SJ2PR12MB7896.namprd12.prod.outlook.com
 (2603:10b6:a03:4c6::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Thu, 29 Oct
 2026 18:43:24 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0569.007; Thu, 29 Oct 2026
 18:43:24 +0000
Date: Thu, 29 Oct 2026 15:43:24 -0300
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
Subject: Re: [PATCH RFC 14/20] attestation: Add the base family specification
 and generated files
Message-ID: <20261029184324.GE3734323@nvidia.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-15-jiri@resnulli.us>
 <179302367452.58760.3782556786585774917.b4-review@b4>
 <auMX4kbsflE9kK3Q@FV6GYCPJ69>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auMX4kbsflE9kK3Q@FV6GYCPJ69>
X-ClientProxiedBy: YT4PR01CA0124.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d5::21) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|SJ2PR12MB7896:EE_
X-MS-Office365-Filtering-Correlation-Id: a7ec08b6-5c9d-44c3-beec-08df35ec83a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|4143699003|261028144727099003|11063799006|56012099006|261026140227099003|261009223027099003|261026121527099003|261022113327099003|261022075727099003|261022105027099003|261021121427099003|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Fvcq/YH5nct9U0JXc1/luJty9ZCwjr2qhcJ9ldDeO3XY1ew1Bs7ciprbpOIa1lv8jBEFVTHJu/bL/u6EpiB0/G5ICVCOuo2JRy9OMCqk8NkFWzPFXgK3zWklwMw9yDP2Cap2/6nQJeeM0f5aPjWYXJCMRLnScv48fQwSHeNqqSHoy9N5EzK+hcCB5Ixz6nE3GdsG7Skaaa/IR9BKB5LHum7A59TLK/0dVmqIZXFX/Ho6hhSCSiBxZJk/5FAZGkJK5/CInQApTNaiRQ18zhLZRWQwPMFPXj8xTGWz5ivEUMIwkxe/3TOLtPKgx0ax86BIl8to3r+uo2bYoE5qcplsiu/8kmEBrpccIPR0p+7vihAbyZr8FbfIcM/aCdqULAvI27foJsMMIwuksvN6D3tb7Hl9OmEBcxP4R0/B4flk27kIU7FIoDIXRnNDFVUkLZdOtmkSNXSG8ApGOq36A6M9j2g5zRbL1J0Qs0ydxpGwK5yERsIq/4X9unHD7wkdu4ItvX9Laz2HsiiM/GlDlaPdghYsJp/IbY+b4wLYAWK2TNu4EkKTtZkhnm19KDyYB5DW9xYhRlnLyx+tT3DUBaM9exyysdqLP7I08Fy/8I1GeeijkUisa3XPTZKS5sITc6XKMoPZHoYrn44RpzpK5YUqTR3RhWS/vXDBLblAEVTOrm8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(4143699003)(261028144727099003)(11063799006)(56012099006)(261026140227099003)(261009223027099003)(261026121527099003)(261022113327099003)(261022075727099003)(261022105027099003)(261021121427099003)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tEdOb0JACC4ErLhHwWdnTnau8IaHoTBYmiByQRgSRjT9B0QyHDtRhKVeBRu/?=
 =?us-ascii?Q?+webhL7F3FdQ4v70+BnpfE1v4o8ebBJILhQIaZGjHDR4jrzGFZ6kIDlzsSpA?=
 =?us-ascii?Q?nijO1iHpOFDwpSNL7r5+3wCOdZ6UMNsFPFPWuHLIPDuH0Csjj/82vRBtl9QE?=
 =?us-ascii?Q?1/lVO3h5JiBkZdv/rT03TpxZ3SnqNWWAxjq8x2vhq2QXcGYRnhsIi315tT2/?=
 =?us-ascii?Q?Bi0IyWuElUE5QcBeEm9VK8Yk0mv7LuplVezL5+msjGHk7HUOjQugLlq5gYza?=
 =?us-ascii?Q?2lZdn0XOv7/rAbs9AevW+MCoDrkbuwcWAqISfw+xzqG9cwqXOd7WcN7gqKpE?=
 =?us-ascii?Q?mRf5XeKujLEx5Mm9FxQ/2jBqVlUilz4HZb/ranbpV+Hf0kaZOlqNibyQQzty?=
 =?us-ascii?Q?QknAx3odrwof7XjplPTYGfJ3pexO1xRsH7LvghYPMBjG5Yo2Ku5414+jE9o3?=
 =?us-ascii?Q?lHM/lJIHFJB11vZzQ2i6AENs3VhUeGUKaKNgHn43VTPvlmQ9ABE/DDJi0kk6?=
 =?us-ascii?Q?9glPq2lc6U9BxkXf/nI5yIUFDt+KmMC77aBws8q3TezODS/imcM70/Hts+c8?=
 =?us-ascii?Q?djlGWRZhWsF0QkhwnyqDQCM0t6N70wQnONvzg1I++TUf6hzPETuMCwMAkoPA?=
 =?us-ascii?Q?VD+jLLvvbsscrHWv7MjdqOoaPduur3fkccEfvj8WVkSfBEnz2U9Q0tLq6j62?=
 =?us-ascii?Q?9XSY/TZBT3pkoyHHaPfntoCwiJ6hxnTG9JboCu1T2vYmx/IWplC2NdXSJX1R?=
 =?us-ascii?Q?JJElgX3mf3V+PNL5FdSwiGPeXVJ2MgwXVlW5FtfWcypnzypFHTbbt3atQfxK?=
 =?us-ascii?Q?j12BPMYOWuh2PyMriLo5mdf6vQPYOy/HXs8Lnk7rhYCKTJZHqUpLruaHtlY+?=
 =?us-ascii?Q?mT6QNfIpFpqlsDpKFXo3Wb9lgzus+M6wPxuho9Hxh/TEjWeE3QlZrFuLNcNw?=
 =?us-ascii?Q?dN0TKTgEWRcjcTIV7tsxB0V+W0QrLZIbm+zne7rCc+Lbu9NVz2xKQvmDJAuT?=
 =?us-ascii?Q?Yfey/1qBiMCyZ4E3WtMfd5EBISuI2i4gHXsVZqpGMrBf4l71GMRV92LcTMMh?=
 =?us-ascii?Q?xYbaDkVYIUIExbbwU1jQv9GCeIUd9tMVt51yY90c+0NQ6JLKS0j2NEn6KZrM?=
 =?us-ascii?Q?b6X8g7uXdiq6PA3xWV2RMFtRbElvKP0l7QeJMhzgoPTxvYC5G3yKAHCvzPkU?=
 =?us-ascii?Q?E955yDw0NhbOopL3YDkWam0ZXRbT7Sk+FkiSNEy73TprkWDON8cmnmm5E+TB?=
 =?us-ascii?Q?oHHuRvC+6Fli4CYlLWcOtT+baODh1wUW3X1HtxKlsRxYdXV0oFb5h320zBjJ?=
 =?us-ascii?Q?rmBHXDfGI1AsN0B0LgZfPV037FhDh/z5xAXDZilIzyHhtC/hN3nI5lTAIcYV?=
 =?us-ascii?Q?anf7rfgh8/BZTkZ3f/U+3UUc/vHlBwJ7M1j2ymfDfqJ1gsricNJ6WOP1ygkX?=
 =?us-ascii?Q?hwF+7bU6BUx+CwpAXFb3ipE5RlfB6cKwRAhMGHoSZowz3E47LESmC0JaT220?=
 =?us-ascii?Q?5wZ6NT8ZLGU4jlNJzXx0OEaVsbKutuhfZbRYAewWuSGSRowNbv+2kB4lm74X?=
 =?us-ascii?Q?Sr6MxfxttD7mRiVEb+Htd/mnXOf/VgbjzdPtbNO4AOsv5REvmsjTI9spln87?=
 =?us-ascii?Q?nAa9dZkXhxz8kM+Tx1F2i//g74U2pV/I/5cnJATs+f3rjKKVcamAfZ+nD1Qm?=
 =?us-ascii?Q?S8oFbAZHRioyh/PkwxJIoXBvOxrUzipwuXB4bV7S+ucf6RAS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7ec08b6-5c9d-44c3-beec-08df35ec83a8
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2026 18:43:24.8380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KzUAISG5VeulnmerdJTXZ6gGRdSQHZ7VU0OWrpjoTw+nRhfeP88LMzlAkz9g+vP8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7896

On Thu, Oct 29, 2026 at 11:04:58AM +0100, Jiri Pirko wrote:
> Mon, Oct 26, 2026 at 03:07:54PM +0100, jgg@nvidia.com wrote:
> 
> [..]
> 
> >
> >=======
> >
> >device-get:
> >  request: {}
> >  reply:
> >    caps:
> >      evidence?:
> >        min-challenge-length: uint
> >        max-challenge-length: uint
> >
> >Did anyone implement a variable length challenge? That seems a bit
> >strange. There is also a very important crypto warning here that the
> 
> Yes. TPM2_Quote accepts variable-length qualifyingData, represented by
> TPM2B_DATA with an explicit length. This varies per request on the same
> TPM:
> 
> [1] TPM Library Part 2, section 10.3.3, page 136: TPM2B_DATA.
> https://medias.cdn.trustedcomputinggroup.org/production/Trusted_Platform_Module_2_0_Library_Part_2_Structures_Version_185_pub_c0a962a931.pdf#page=136
> 
> [2] Part 3, section 18.4.2, page 158: TPM2_Quote qualifyingData.
> https://medias.cdn.trustedcomputinggroup.org/production/Trusted_Platform_Module_2_0_Library_Part_3_Commands_Version_185_pub_87a5c10230.pdf#page=158
> 
> The PSA Attestation API, section 4.4, also requires one implementation to
> support 32-, 48-, and 64-byte challenges:
> https://arm-software.github.io/psa-api/attestation/1.0/api/api.html
> 
> FIRME DEN0149 1.0 ALP2, section 8.12, Table 8.23, page 100, likewise
> defines an explicit Platform challenge size parameter in x4[31:0].
> FIRME itself does not mandate the specific 32/48/64-byte set:
> https://documentation-service.arm.com/static/699c3b70b60ef220b14ec14d?token=#page=100

I feel like userspace needs to know the difference between 'any size
between 0 and 100 and 'exactly one of 32, 64, 128' ?

Jason
