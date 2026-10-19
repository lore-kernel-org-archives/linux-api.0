Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.1
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792452675;
	b=esRLpNzeKW5knM0eLFoyAY8pBfWJBzRe0Go0fvHe6Zb6CoFJsNtbH8UoqIdR5ZdLZcc4
	 h5nkrdSuVtkyfI/OUfGAmcNoiCFaeH1y3gOmvax6CZgzfAnPdAzmGh34fsTLseNReq1uU
	 /obmKMkP+ODXe+DUtGn4wdYHfgdZsF9zgrZ2v5Ei0n9NZQ6crdJg3EACyzeLcLgW8QLvw
	 H2TrW2oBFmjlWPLKnC4T6QcNL635aWlusazK3G8IzK+T0C1FOsJq32GIQAX/2IHPrD2JE
	 z+yurpAheyl+/GQJu3MW67Lelr3tgFCuFOGAjnIXrlCZQhmpxLOHOrzIHzPSzkHvKhQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792452675;
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
	bh=sPcz3Cd0fEAnxGXGD00/IHYBSS+7FIbuI0zdvcPMghw=;
	b=3WhLPJLxB92z3OSrPIS0OJVMpmkrhk6dmYs7d+GY0MDH6I6YyNEAFBXSlHaPBJwA4FVs
	 x+4KC3wp4D/tCn4rh6DmhR4uVkE2GwChhDSb0QRtrqfbLK+Os+f5GfJtqmPte7b6L54um
	 N9iOvmdkLEVzvAQtbcbyg8aRKAJQAwV2E6XRqNTb/jwEJeuCS2SvS9CDuFWbTt/c/J9YO
	 aKgflybztQQIuvzp3gFTvsJIoYv3op4qkCcWryZsEo7zpmX8U+VYy6K4cGVKW8QR02syO
	 foCi9YPxF6odCdPc/2FJSvS8ZlsrJrg8TH6NxKnm85YKYinNra+5KWWbbS7sXTZ6bRg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gCP59ENz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.1
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011001.outbound.protection.outlook.com [52.101.62.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512FC606A31A;
	Mon, 19 Oct 2026 23:31:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 512FC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gCP59ENz
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mNoH4VQr231NMbfUlxlrP8j2/qKEReWeMq7fVjXERtE/I1qktYeRsI08+swxQTxXdUZMCWb117YnaOae8wFC5cmAkYLvDF8cxPM6hXrl64m19Nculgzb/YffoR+P8OmmN9lCZQH+OW02aob2I1K1F5TvGv/YbHqIasFDd649k8nZOojPlmKa5GwnQs4XP10QcvpYCKpa8UawMWM0JliNGMsIaWj1oaKDbP1Z4ksVOFUI5hD3djLmxkgBhkbQVwu8uT9YB7a3pgHQrsWIoTvQ1rtVjXoHF4/3GOgjES7m+iSkfEfogt2V+TT8UNlWB3s3paylpw/rzQVXVwYzbTHxKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sPcz3Cd0fEAnxGXGD00/IHYBSS+7FIbuI0zdvcPMghw=;
 b=vhRzskK+wmNf3wMg7rz1T9i8eC9eDuVsbyt1bED5CIiI0Vrzz071QxQ9yLM8lOSaJlUxk/GrxQb1KRwhjFicYsygIo/TteL5aYIjob0OljZIHU5oJxAVnpPDSFUsrL2dLp8UmDW73eD5ecqR+nO+Vlo5OGiV/8M8AsWzFyCZ8rsA4nSjzfu43YBh0dCDvf64RLlUGJJsEbyu6eFdn0nJHkohhJpbpaiAWxElUOOSYtwrhbT78ZmNpEgOsDGfQ/CZSCxRlmZJw9tVFfW9SRRqKduyMEpDS4AVbVKmj1K7uqISDojaUt5PLlDps4q3QNl4acIu59eZ1PBfHau1BH8rmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sPcz3Cd0fEAnxGXGD00/IHYBSS+7FIbuI0zdvcPMghw=;
 b=gCP59ENzxIRfRL6bVmUgMyiKB5W9IOtBkOqdyKckQNcTVFU7UHGZB2+U50MIzTWUCN4YkNBdPq34tOO1X0nNQ2QeP8HFgR8TlRuDNz2rzz0LgJF378Vl5b10ej45dgbZ75qXrPPiGOlRqZL1eHVZLqMDbh88zlEtzPsxXXldVfHy5XMwcriQxfCKO/2yUMi96RTxTevPQCKnqciQGzdEiX5ePgHeP74Ga3xmOwRl1/KL5YOhbz/JnGxAQorY6PbxewD0BW834lFjuESA0+czGsUgkDsV8AU/6kfC+hat7iHub9JA4AUuEB6HCsYeNvn/mfn0b1oonrE34l8+4CVqPA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SN7PR12MB8789.namprd12.prod.outlook.com
 (2603:10b6:806:34b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.18; Mon, 19 Oct
 2026 23:29:49 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 23:29:49 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH RFC 02/20] ctlv: Add the UAPI wire format and family
 API
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
In-Reply-To: <20261015145053.3664509-3-jiri@resnulli.us>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-3-jiri@resnulli.us>
Date: Mon, 19 Oct 2026 20:29:45 -0300
Message-Id: <179245258504.58760.15790996354033644110.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: BN0PR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:408:e8::6) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 06751bff-ff36-4636-9785-08df2e38dd9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|18002099003|22082099003|10067099003|3023799007|4143699003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	yl5wLznsRU3MgUkJBDe+Ube34vJZYFO9N92hVlxS4fK7YYFbCY8+UPlu9vCsTmVRoKFL/h5AF6dilUoZDw61hrDS8KnxGj7uyEtpF/B+PPjqk6Ugjq0onUgE2djWklwUPR6y5U3xfDtv3h+I66DtyNy4D96Hbr23TmYP3uYakwlWDQSVR4gOR3bZRBJK+IrhIiRACHrYATOaOto8ULCeS5dsFyubh1b/mx3Q1xMzyJa2Xuu63cpPewWUK1fLCHkllNKBVaR7XtELw5UqsK693E9IKOcRILQoQ/pMiQMmpzDc/xUjeylnP5VNHYweA6zkyoOZi9DMacs9L+ILSb32S2vHKpm6d/UPO9eouYuLS2uBq+Ii3g3b4i+zo4onGYzMSFEUsvC9vpgIrMlq3cdM5Qa47ptREAVP+v1pkBIojVPiZ+zyB02zcW5bsMLpxY4eSqpaV0wPa2rdCjBAkUZtE72dkjB0E+T4UHO6gSgHzWiQ79t0irpm3KaCtzLxI0PzSMRU+mKlJNfGe707uZoL4n3W63knbduWLtmWm/d8ZPLds8bM4xJTQoI7ek2WXuGdNZDsvUu1WSGHy7PaK1x5P+2cvegYzh6dOFR/XGa5BYJUAIY+usKI/D+S/OmB8xLBBfAe3FEF84IyitvPE9+rcGpqQj4AQ0ZIk7tw+sfUF5M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(10067099003)(3023799007)(4143699003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dlIvb2lHbHduemcxK2tHVjhaSG1BdEdxam85YkxDWXh5M1dzRDFpQVFNZDh2?=
 =?utf-8?B?VjM1MTZCNW14T2E2dDZpQVI4MFM0MVZtMDJOMmcrT1ptZE5Rb3pQa205dmd4?=
 =?utf-8?B?bE43VVdGZ0tSbXBkRGcxT3VmaWtCdmNqanNLUlVWdXVURE93d1Q0L0FNRExl?=
 =?utf-8?B?VmxnVmIrV2c3ZFp3Zk5ybzFJcGZTRzI1V1g1OFFYdmJpZUhrdGY0clh0bWhU?=
 =?utf-8?B?NEJXR3o4NkVodldNOHdkTm5mdU9lcVRpTkFvckt1c3ZkVldMN1ZJUDlnQVQx?=
 =?utf-8?B?NHJVU2pnOEVPMWZBTGIycmhPc2pnczVSL3VOOTVCUGVGT2NqRFI0dEpxYTZv?=
 =?utf-8?B?TVBLSVFBdW9RSXcxMzE4YlRVVHdXSGJaVi9MZjNoUlorU0wzQjlTQmRFUTNh?=
 =?utf-8?B?WjdWcy85MFpnSWtVT0k0VGx2dlNoWmI4Z3luS0RoUFZSYkZ4MW5mbWwzeEFm?=
 =?utf-8?B?UTdHYnRnVzhqaE9FUjNxQmZtVUl3QVFWaS9PaTZaOGZpaEFYTDN3S0dPbzhP?=
 =?utf-8?B?eEFUUzhuVU1IeFI0S1c5S2RDMDRZcFdNdGhreXRWZmEzemVxRkh1TlJvSnVJ?=
 =?utf-8?B?ZzhSTUE5RkRIK0lCcEFYZVl0ZE1rWGJPODY2cU9OcldIaU5BN0RhMi9mTVp0?=
 =?utf-8?B?dElvY1duZVhZc1RGUnQ2R1R1NGdtYXdtVVZ3bkM1M0hBZkJrMnl3WEV0U2lZ?=
 =?utf-8?B?TS95VXozelBKYzBFSlZLQS9rWU82ZXM1MkJQRCtXa1I4R3JqbUY3bXI0Ym9l?=
 =?utf-8?B?QThwRndTMUMwQVVHRG1GeVZoRnNRc1dwa1NRT1U3T1V4dGk2aDJBLzN3anlB?=
 =?utf-8?B?WUNWdUtNTWtPQ3pFZXB2L2Zways0aEZCVXJoLzc5cDYyY1JVTXJlTlRQSG9D?=
 =?utf-8?B?YmFYeGVNREF4Q0xDaDJkdFBKK0tVZWdkZ0ZDUDl1Q3lsV0FwZFVsZ3pUZlVD?=
 =?utf-8?B?VllTeGxBc1IzbFlUZXIwaExOYS96Rk42NHlnalhTZHBFeWhTTVdlNW9yTDM1?=
 =?utf-8?B?YTNmc0NmdEVNMDNhK3k3b2hKTUQvRnhtOXY1bTNQYWxTQksrWENWZUtpaUVO?=
 =?utf-8?B?T1FUWkZnTkZ1bkR6Vk5EZEhGRHFVYkl4NUN1eklhQzRQYnI2aXd4anBaYjZa?=
 =?utf-8?B?cDZLSUJtbEJuN3ZxemI3Um5QR0YzR0s1UUsxY3ZaaEZhcm9JYnlkcGlqbFBh?=
 =?utf-8?B?dEtqdHVIRXYrMTN3VDQzejVRaUtETHpldXNnNFoyMzBxaDN0cUkzWDl1S3Fn?=
 =?utf-8?B?alFJSDk1RitPbllJbjlsRkhBYVZ2Q3RDNFZtSnp3d3ZPSkMwVVJUaElHdHVF?=
 =?utf-8?B?NDM2RkpQMEhVMnNjZkFOV2lvcjV1dFQrblNtSVhub0hYQWxzM1ZnbVBMYUpk?=
 =?utf-8?B?bUNsNWUwQXFuVi9UVUhmdVptNmV3QmFnMUhLcWVwUW5IQ210RUpKczZIVG9Z?=
 =?utf-8?B?Y3dMcTVMdU9reTlYVWIyaHBocnduaCs1Nkx3eEEwa2c4cCtDTStOTVdiMXcw?=
 =?utf-8?B?d3M0eEgwNDlCK1liT3ptd01KeTVGUjZDb1FvQkNWS3FJWS9uQi8xTzhwenpR?=
 =?utf-8?B?dEFqdFlteVpOVjYrSGE1bktiSGhPeWh1bW1RaTdKUU1WYlZqKzRJWGsyL3hU?=
 =?utf-8?B?dnllRjNFaDJQZ2tkdjlFa1FCQVBGeE9TbFFpQnJ0d3UyYXMwNk1KZmFUNCts?=
 =?utf-8?B?MFBzVVVPUEc1Q2tkdnU5b3VaTjArTTRJa3d5Y3dhVnRFTWVTMnRpYU02RkF6?=
 =?utf-8?B?QlNheDdKalZEWlhJaW9WUjM1eThCeHU5ZEtoeStHK2RlUXZDN3J6VWJtQlB3?=
 =?utf-8?B?clMrWjd5ZlQ5d3NmUWlUQVRhOGdHVU1tNmFBTWZ3Mm1zc2RWNjlnNzZpSGlV?=
 =?utf-8?B?NHlqdzF1QUdzMVBJWkFXYzZtVkgvT3FYQzBVWXNHby80czF2THpZQkZ1bXd5?=
 =?utf-8?B?Q1NqK2duSnJCeDVBNjIvYXFDLzREMEpqVm44QmdWVHRsWlJoaXJrNktaS3NY?=
 =?utf-8?B?ZTlZWFNMVFFVNUd3ZDlDb1JjR3hIeUplTmZ4VFhvVkJRVy9sM09pK1dmSGlQ?=
 =?utf-8?B?cFYxM01BTGNFYUlQUXArVEM4Y3FacVdQV2dCaWpKV1dKT28zcG5rTlE5eERu?=
 =?utf-8?B?cmpYQW8ySzB3VzdtQlNKRDRPYkR1TkJ2MXh1L3hYTG9BNkp6YzRUNXBWcEh4?=
 =?utf-8?B?V09lYW9MNUNFcW9QQXcydW1lYjhmUXdyWWVmcjY4ZEw1c3lSY01iekJDcTN3?=
 =?utf-8?B?SnNTa0QyNm1uRjB3YmNCMForcVhCWXY4QTFQaUNMVmQ4NTF0Yi9EUnBBOWNa?=
 =?utf-8?Q?vnfiJkhH4VOuDOiW6E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06751bff-ff36-4636-9785-08df2e38dd9a
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 23:29:48.2115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y5TN5RuWEeRG8yrr4zbg6ltMOr+p+Y9Jg4/jnyMu4NFlwtYZfNVwgTedU8KcjAdK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8789

> [ ... 159 lines skipped ... ]
> +#define CTLV_NODE_SCHEMA_UNLIMITED 0
> +
> +#define __CTLV_NODE_SCHEMA(_attr, _kind, _occurrences, ...)	\
> +	{ .attr_id = (_attr), .kind = (_kind),			\
> +	  .max_occurrences = (_occurrences), __VA_ARGS__ }

This reads alot better without the extra macro layer. The point of
this is to allow the codegen output to be concise it is worth being a
bit more verbose here so the exact form is easier to see.

> +
> +#define __CTLV_NODE_SCHEMA_CHILDREN(_first, _count, _required)	\
> +	.first_child = (_first), .children_count = (_count),	\
> +	.required_children_count = (_required)
> +
> +#define CTLV_NODE_SCHEMA_ROOT(_first, _count, _required)	\
> +	__CTLV_NODE_SCHEMA(CTLV_ATTR_ROOT, CTLV_SCHEMA_NEST, 1,	\
> +			   __CTLV_NODE_SCHEMA_CHILDREN(_first, _count, _required))

For instance this is much more directly readable:

#define CTLV_NODE_SCHEMA_ROOT(_first, _count, _required) \
	((struct ctlv_node_schema){                      \
		.attr_id = CTLV_ATTR_ROOT,               \
		.kind = CTLV_SCHEMA_NEST,                \
		.max_occurrences = 1,                    \
		.first_child = _first,                   \
		.children_count = _count,                \
		.required_children_count = _required,    \
	})

Even if it is longer, and and clangd can now jump to the struct members

I also think each of these should have a one line comment explaining
when it is used.

> [ ... 61 lines skipped ... ]
> +#define __CTLV_STUB_SCHEMA(_family, _set, _node, _optional)	\
> +	{ .family_id = (_family), .set_id = (_set),		\
> +	  .node = (_node), .optional = (_optional) }

Same here

> +
> +#define CTLV_STUB_SCHEMA(_family, _set, _node)			\
> +	__CTLV_STUB_SCHEMA(_family, _set, _node, false)
> +
> +#define CTLV_STUB_SCHEMA_OPTIONAL(_family, _set, _node)		\
> +	__CTLV_STUB_SCHEMA(_family, _set, _node, true)
> +
> +struct ctlv_schema_tree {
> +	const struct ctlv_node_schema *node_schemas;
> +	u32 node_schemas_count;
> +	const struct ctlv_stub_schema *stub_schemas;
> +	u32 stub_schemas_count;
> +};

I've been ponding for a while what 'stub' means in this context.

AI suggested "extension_points would be a clearer name here." I guess
because ctlv.rst calls it "Inheritance and extension points" ?

> +
> +#define CTLV_SCHEMA_TREE(_name) {				\
> +	.node_schemas = _name##_node_schemas,			\
> +	.node_schemas_count = ARRAY_SIZE(_name##_node_schemas),	\
> +}

It is helpful to put the struct on these macros ((struct X){})

#define CTLV_SCHEMA_TREE(_name)                                         \
	((struct ctlv_schema_tree){                                     \
		.node_schemas = _name##_node_schemas,                   \
		.node_schemas_count = ARRAY_SIZE(_name##_node_schemas), \
	})

> [ ... 127 lines skipped ... ]
> +typedef size_t (*ctlv_family_priv_size_fn)(void);
> +typedef const void *(*ctlv_family_pre_init_fn)(const void *init_info);
> +typedef int (*ctlv_family_init_fn)(struct ctlv_device *ctlvdev,
> +				   const void *init_info, void *priv);
> +typedef int (*ctlv_family_post_init_fn)(struct ctlv_device *ctlvdev,
> +					void *priv);
> +typedef void (*ctlv_family_pre_fini_fn)(struct ctlv_device *ctlvdev,
> +					void *priv);
> +typedef void (*ctlv_family_fini_fn)(struct ctlv_device *ctlvdev, void *priv);
> +
> +typedef int (*ctlv_stub_fill_fn)(void *priv, struct ctlv_op_ctx *ctx,
> +				 const struct ctlv_cursor *request,
> +				 struct ctlv_cursor *nest);
> +
> +struct ctlv_stub_ops {
> +	u16 family_id;
> +	u32 set_id;
> +	ctlv_stub_fill_fn fill;
> +};
> +
> +#define CTLV_STUB_OPS(_family, _set, _name) {			\
> +	.family_id = (_family),					\
> +	.set_id = (_set),					\
> +	.fill = _name##_fill,					\
> +}
> +
> +struct ctlv_family {
> +	const struct ctlv_family_schema *schema;
> +	const struct ctlv_family *parent;
> +	const struct ctlv_op *ops;
> +	u32 ops_count;
> +	ctlv_op_pre_fn pre;
> +	ctlv_op_post_fn post;
> +	ctlv_family_priv_size_fn priv_size;
> +	ctlv_family_pre_init_fn pre_init;
> +	ctlv_family_init_fn init;
> +	ctlv_family_post_init_fn post_init;
> +	ctlv_family_pre_fini_fn pre_fini;
> +	ctlv_family_fini_fn fini;
> +	const struct ctlv_stub_ops *stub_ops;
> +	u32 stub_ops_count;

Having the function ops in a struct use typedefs instead of just
coding the signature is unkernelly, I couldn't figure out what this
was done, it seems there is no user of the typedef

> [ ... 182 lines skipped ... ]
> +/* Implementation limits, not wire-field maxima: raising them is compatible. */
> +
> +/* Request roots, action replies, query reply fragments and event roots. */
> +#define CTLV_MAX_INLINE_MESSAGE_LEN	0x100000	/* 1 MiB */
> +/* Includes the error information root. */
> +#define CTLV_MAX_ERROR_LEN		0x4000		/* 16 KiB */
> +/* The root attr is at depth zero. */
> +#define CTLV_MAX_NEST_DEPTH		32
> +#define CTLV_DEFAULT_QUERY_REPLY_LEN	0x10000		/* 64 KiB */
> +#define CTLV_MAX_EVENT_QUEUE_LEN	0x1000000	/* 16 MiB */

If they are just random kernel limits I'm not sure they should be in
this uapi header?

-- 
Jason
