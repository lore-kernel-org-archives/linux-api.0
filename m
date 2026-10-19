Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792452723;
	b=moY83XApsVNeG/j9HTMFfAVUASEfJEVvlKC7umnPH2CNRXwRmBTdCxEezziSnCCCtKfE
	 5CwGgqUygeuEKFD76ohHagf3iQGUq0gSIszRAMJOaKF31qzKwD6SpDleuuCKtpfd5s0JW
	 FABUN6GmQtxP6auh0JLjCVZ9/+3mTOZM/xxxca8fiLnOw8Pkx+eNR+vhKrStqZUJEYUdp
	 ITbN8J0IoinuoTw2tCPSF5U1aooixVCvbywt9yj7VoMc2+RdJ1vDQU80VBYyoNeWrf+L2
	 CFdJXGc4JBjv3sQhujRmruHr7h0iToXsnR9C0/q7j+Yg+XafsaVSv/MPbOxDtgi3jeQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792452723;
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
	bh=JKEIJrl+XE5qUFwVoKtZ9oPpqQfKCJOAbJRXyji0gbY=;
	b=pFfwcSXemLtTDWUL6Cs8ra+/ktf7W07XgpfJQlxGvCxnZvFrbEm2nLC96690HakmBkBR
	 QToFvptpQLBMh7isPLNni3Kf8ctPxdeu9l7DIwiqYYJoZ5jeBSGiKbClO45lIzbraevE9
	 /Ty9/hKKxhH4vr5HJZZakI9FcVMNIDshIyZcwTBeLaaAjRo3pwPB6/2vI+79hlSpJxWWB
	 6t4oUKrc4rubtHE8Ac5EQ/Eb95T36Ne+Ypf7xBd0IzYGjtLDkjMKZQ5zA7mCD1pxLZJZQ
	 eWg3eqnYKMawtvU89XNlEsmaxbwU5g2H0wzSOKj2b+jPZqRehYjEiiW5t7g9Otg5lvw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gZb7kXdN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.14
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010014.outbound.protection.outlook.com [52.101.61.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000BE606A325;
	Mon, 19 Oct 2026 23:32:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 000BE606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gZb7kXdN
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A3uiU88HFZFdS8JggEo4NgVR+6NlcRJe0WCf7YQj0ZfjgebDhrsYQLn8+1jC2bMDeP5iT09dFmx5N8k+Tr7L83ifi//gFAs4fWReWFS+Xhf/DcEsMgYUyK5+OUeiMago+ZE/y/9U9J2MJHQeDVp10rBeak2pvU9NWs12Q8sfvbbRO5CyuysOZ/rzQ7sVUeluTLHWe3US8In4xxqcoL7OwwwyXAyoIM+j/2d+3JRJO7BT1vLTk8eBOH2UQfNWNTnElWMwTDnA4g6uLozxhhFfgiIlyMatHs7H9lKddUg8j5PQeA2NEbhz68U9FQCcxOYQGU4iBNaXSxV5Y2SWGUz/Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKEIJrl+XE5qUFwVoKtZ9oPpqQfKCJOAbJRXyji0gbY=;
 b=q+jSgYfOQZ2loqUVNJ7Kv/1qkuy2unqD9pbZyusSnweISoqbHrfgAcozrwaB/Jr1lGq6RurGnoA771NFoN8yv6pj+/MRQvDsph0ixEm8bplvax7bIknNmd+w3h4Q5Wsjv/w3ugdrmtA8xRVLaaYcGf2Ui19g0U1geGDyK8WNaMMgMD1Wfk+jwdQgpeFXTJAmavuZCwVh8mtV4i++vqbTT8t6t7WY0KfThPrlXqaT9ce2t8Dt+k+Xkbt2VU67B301SzuDU71x2RQesWtmj7pwI9J95xKdf38leP9t6OVk2HE0113W1eaSXckyUE9VjRh4SJOwy16cX4fyN8dE/hN3BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKEIJrl+XE5qUFwVoKtZ9oPpqQfKCJOAbJRXyji0gbY=;
 b=gZb7kXdN0yQXD7GFWKW1z3ryKuLS8IdGPF8kZ+eR/RC8JQER2P2MkYRmotBaZtiURyCmj47T6eXg/nwqnR/p++gukCERXltNZeF95HjE+5VnSfVUojcQxWNEYkuc4IhMh4xoVC9SieKhPbhdcm+A1BWxS+nxDUwg1JHkDd5/AtKj6DlpAckFGr2Yy2HOSZuXM+KvwOzkhQCAZjVSBn5zOHYxlxTdALL+HxB5CfK7OEvg8zrmWr5zBK/6hmoXXZnRypMcbLkbNwdIVFl02dQrUcYCNI6ZqJA6Akd7XLiSeS+Uppp+KZu/vkK4T7fxMza4FpzU40j2S+dtvZhostmdNw==
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
Subject: Re: [PATCH RFC 03/20] ctlv: Add the root family specification and
 generated files
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
In-Reply-To: <20261015145053.3664509-4-jiri@resnulli.us>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-4-jiri@resnulli.us>
Date: Mon, 19 Oct 2026 20:29:45 -0300
Message-Id: <179245258505.58760.6060356114682279013.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: BL1PR13CA0309.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::14) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 7ebcccf7-85b5-4d38-3ef7-08df2e38ddae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|6133799003|18002099003|22082099003|10067099003|4143699003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	n9yuTonbJEgqZba6YE1/YXhXC22yhGaqE97qsI8DONic07Z3DHySknSKefvWWnc5ehEwo8c9xea4JaovMUPDYzbVPEo0eq3ND/3M8j8hYhtfWVuTKnlUqJe4lJ1FGFPPuhKLMGqstoEmbl1ktgy3PknBLViNA1jVKI161Xe0Zq4Tod3kjvo9OGiw+4dmPCXcf2t8kYPIQ8yS+d+AHQrCAhCrfoUuSz2RjtSiqB4Eu0KRg6iQJOcB5M4R2rXXCwLBDp1mcJcOwGo8+gyV+ssJTnzfZDej+4CPkaD5mwDWm8HmOFhg1ufWNKIZubDPXhSYTTmgYI+15/0YavctYCMJAzTB8xqMYFsAAZYAXi3OdW0ozPwPz427+cmjEb/88ap52bdM4K4+BFicgjWB9Y6zOQsoc9+2eJR+jsv8Q+Qm4q90WQbWaNcZd2hn7dWbkiehB1dpFtkNV1LrXhqyx5CNpnDFGu7VoGvv6eKoR+ebRKWzTda6AbD4IIUdywf8nhjytnSZQBrZJQ2TiVF2SStuMyOPnTlpusQd16QQRXmqFYaLSgm0Gi1uiRvyF8TuB2K8Ilrv6gW5Qoe3yFJj21Dbx5HHuTXc4Kol5PQ8E41EnkIeXbuOgzf4/U0+06tMDjsaUZYw5aj5/+2s+UP/hms4MpzCJYji/4X79ixSBZnmadw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(6133799003)(18002099003)(22082099003)(10067099003)(4143699003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0syaXNsYlN0amtqZ3ZpZ0pRRTU1SnNRYmx1cXl6TURlUkllbjVWV0NvdXN6?=
 =?utf-8?B?RVlHTnRZSit4dVkyZkh3c3RQU3Z0RVZ3VTJJSWIzQTBrZnRBVm5IWXJ6T2l1?=
 =?utf-8?B?dnZvTnJjcDdaSWZGa0wra3ZOWENxT0h0bVJLbkdNOEtnNzZxTDBTMVhWekdT?=
 =?utf-8?B?bGpLaGZkc2RlL2pQbm0vNy8yL3JucVpTU0M0b0pJb2hCV2Z4T1NZRzE5UE9x?=
 =?utf-8?B?aE8rQmdIVitLWTJXbWszN0dwb1U1N2UzVlF6R0JxK3NENXZDUEYvckNFVU91?=
 =?utf-8?B?TEh6TnZhR1dhUHBhZjJ2bmxRWU80aWoyTU1vZWU3cUVpekV3OUh0b1JFUnhZ?=
 =?utf-8?B?RmNOTko0Uk9WdGlrWithRTFDYWNVbWo3dHRjSUk3TUIzenRKczErMDhuMXpz?=
 =?utf-8?B?TjBKSFlOQTFQWnZXcHI1endmWE8yQkNCUUEvNzU2ZW03WjRrZEZab2tpa1NB?=
 =?utf-8?B?eDJhM3BtQ0Vod1NpcUFUdndoNEtkb0dSYWZzTGpvYmN0Uk9QVFE1S1VkNWxP?=
 =?utf-8?B?ZTgrU21yR3dPRDJKYWxLY3lpOU5mYlphQnV2QzZhbHFSYkRjaVhyMkhEdEd3?=
 =?utf-8?B?OEtMa2VJTzBJQnIwRXBHU2p6SFFWL0Q0QWg1aHJPUUdzNnEweVc3YzlZUjRM?=
 =?utf-8?B?by9YNzVqRWdZbFBtNTFwM2p5Z1dLMzV1ZGhWMXh2QnJ4WFA4SlQrTndPakQx?=
 =?utf-8?B?YjYzSFI0WFJES1ZTOXNBQWlLUi8zcWV3UEtYemx0bjVXcXVkMFdmQ0V4MGox?=
 =?utf-8?B?U0ZyN3I3ek0xUzBEUzhNVlZoREpVZVRyM1BkenplUUdpTFZSZisyRElKUk9m?=
 =?utf-8?B?LzNGbHBVRjlOTUt2cGdmbEdVS2NFTWhrTnhwdzJPZlk0QW9ObEc1UzZFc09F?=
 =?utf-8?B?SzZHbEUzYThXNkc2azFiUFBxMlpQcWUwMTlWSGdRSzBqUjhPUEhKZXA0aHEx?=
 =?utf-8?B?TmdDdVJDZHdCa2YyS2F1cVpVYzlKWlhUQ1NLSnVCT1pFMEhWbmhZampzTVRZ?=
 =?utf-8?B?UXMxczBsOTA2THZ3QlRQRFpSNms3QThac3hLWGdkMnZoSTR0V0xTR0xmamtY?=
 =?utf-8?B?R05vOW9CTU9jYTdBRk1LK21YZmRqbTE0bWlWd0JBamtER3l0K3NnNy9rVFNz?=
 =?utf-8?B?cnJQcG5EQWx6RTE2UkJPT3BHTE01UDkzakE1cWxXejJKbHBRaHNtSUd5TDAy?=
 =?utf-8?B?RHYyR3FBMmE3RWNWNzgyc0UyNU4zbHFNYUREd25mTXZPYWNmQ242SXIzL3Jy?=
 =?utf-8?B?VTBCUGIyRzQzbTR4T042VytLUmRoK2JqZ2ZCcDN4cVZzSmMvT2hZNFhZdER1?=
 =?utf-8?B?L2tocVBkVC9KUFFOQllZWkhsSlNDT0N1THd1a09TNHJSaTFtd3pLdk5nTGZI?=
 =?utf-8?B?TnJNaGc1ZjA3VFJ5UGVrTDdwSm1Qd1JZZS9wd2ViYzByWVI4bVowMXZ0TExs?=
 =?utf-8?B?cGNUN2x5SlVZdjZ0NnI2Zy93Q1Fra1g5Z3NLTHQrTzFzZjZTK3M2aEcxa2dL?=
 =?utf-8?B?YURvWWc5Ti96T0htNWFyTDBpYkZnR3lZQ1NTT1VSRE1qTW54NmtZSStRNDU3?=
 =?utf-8?B?RDFnZFZodWFrU1V2S0VFRi9XSkJiN1p0dWlkcFp0Nk83UTFTWVFTcVJOSEw0?=
 =?utf-8?B?SjZLTzZUQW5HdHFld1JZYUU0MXVaeUlVQWlDT0FzL0M3Njg4dWk3RkZmem9k?=
 =?utf-8?B?Umg1ZXovVlBSeE45blZQZ2RPa3JzRVJod3RWUzVFemhueXB0aTRSRU5taFMy?=
 =?utf-8?B?djFFbDBJSWVqUkp4YVVWWlkvSHo2OTc5OGlkNkpKWXMxSThYTGJ6RFljOFRv?=
 =?utf-8?B?eVM1bmdFMFYwNTZFZys4T2NLRW5jbEFNU1ZPdUwvQVJCQTlmQUJxSnhYaXhx?=
 =?utf-8?B?TVdodXZ2SXIxeEJpMmtOUVcxZXhMeENRNUl5K0lVSE1aRERid3cra0VrT00y?=
 =?utf-8?B?MG5aMjJGN0tSMlIrL1ppQTVPUjJPbXJJNjZIRDlhOFdHekxoa2VwKzIvOENh?=
 =?utf-8?B?TW1Pa1JDRFhCbG1CY0w3MjdxclYydDNzc3U0R2lpdU9jdldPQTRFbkxhNXIw?=
 =?utf-8?B?Wm5VdEdiZFd6R2ZlTXVRL2JNR2pTYXAyekNiWW91b09oR0s1OVo5V3ZEQTd3?=
 =?utf-8?B?MlVzcWpyVGZRU3g5Q203ZEc0b2R3dDVCOUw2Tk5yNWlWSnVRaWVnUGRtR2l5?=
 =?utf-8?B?QzN5cG9EMG91TWluLzBFeXhyWExlVU9XdmxsYkd5MlFQSnZtQWlkbnlpVXB3?=
 =?utf-8?B?d0NtSW1veVZ5bFBKaVpZblQ2L1h1QS9oVW5VMm9TYjc4eGlGY054c080Si9V?=
 =?utf-8?Q?4XyF0u9BunbgJ88khP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ebcccf7-85b5-4d38-3ef7-08df2e38ddae
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 23:29:48.4122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NpnKYL6NkT34fivCMdUBo8cPRlquRWvLwgl5tvXbdHcc097SAzc8rno+4ysyqArH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8789

> [ ... 238 lines skipped ... ]
> --- /dev/null
> +++ b/Documentation/ctlv/families.yaml
> @@ -0,0 +1,13 @@
> +# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
> +%YAML 1.2
> +---
> +# Append-only registry of CTLV family names, indexed by family ID: the entry at
> +# index N has family ID N, up to 65535. The root family owns ID 0 and heads the
> +# list, and every other entry comes after the entry of the family it inherits.
> +# An entry may be marked deprecated, but never reordered, removed, renamed or
> +# reused, its position being its wire identity. Every entry must have a
> +# specification in specs/<name>.yaml, and is added by the change that adds the
> +# implementation. Fixtures under tools/ctlv/tests/ are not registered.
> +
> +families:
> +  - ctlv

I see where you are coming from with this, but it is going to be
problematic from a global kernel perspective. Given CTLV is imagined
as a general tool for any subsystem we cannot control the tree that
things merge through. It will not be like netdev where there is one
authoritative tree with a linear history.

So if Bob and Jane maintainers both add their own subsystems by the
time it gets to Linus the IDs will get scrambled, and bisection will
be lost. 

Either changes to this file must be strictly done in a single tree
with shared branches (which is going to be a bit hard process wise)

Or we need to put the ID #s here and have some simple process to
coordinate them during the development process. Since new families are
probably rare it shouldn't be a big deal

-- 
Jason
