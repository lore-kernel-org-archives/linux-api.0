Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792695102;
	b=UqN/eJ7iKoLj5t5KoFBP2I8LzY3Sduo3k3D2ThO+2JyRaSFOX2a6oKsVoAnrLspdyTjk
	 ANqgAf3O7qKC7p+5lUx0AXZVrDphDHF3vCim0msUtNJNLt+96XMnhfhMdTNjGi1+UUgFz
	 k60fo58A/46px6h2LUQx723bDz1iJqKmXyxj89Bru1lmHNz6N3nnEhR8dhiG332FNo4BI
	 LNtiPNbDWhVmsJxSYTLK5TJ9Ur7PUA+07641otQAUqbJWwBMoWZN8S60tKhwdlL5MiqPK
	 cBl/9trbhf+n4BH67p+70hPTpVIGSXX0auDVrZBeB0u9WMr2SK4fZzF7A2s1kphfNfw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792695102;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-ClientProxiedBy:MIME-Version:
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
	bh=5o3kAR4I+myZW+mzmskVMU71phcJkpzYJ0t478Co9oA=;
	b=E/3UJjtlYWAc9PkfnepFQszixGb2AcYJwhT035QtaN94dSi2aIRiREzfUkLmpRuLy7n8
	 wpS9VZVLIeUZICHXFncyec98XI4ysDo1fgxGijp2G7k17MT6NtlauqN1yowC/E0tbUil/
	 +KAJVTvXftPTv7g5vnKGNHExjm2016oe1/p6nIONP0JLsqBM3GuPq4kLgmKDo0vJ/DC6g
	 vAOf2rwEEPdSW62rOupm0a+bqILwsKnOMqrKIbWiWD/Dc8xi5NjR7x0sN4wCK6P/68sLa
	 0q8ZlwqyUrwg0QE/8prrk5cCTIGjALxUd3XywefIqrAkKM/efuBJG2Ak0Jp1NvfGPBg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=E7TVp1Np;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.54
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010054.outbound.protection.outlook.com [52.101.85.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF86606A31A;
	Thu, 22 Oct 2026 18:51:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFF86606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=E7TVp1Np
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u0Y+aaV4i2DYCex0EyAtIRBVxMumg5vdPad4eQtZCWuPiZpthewL7PfJMLlTRlh5LXAOZZyU/tmYgAnPb5B3lnG3Jmn2DDiEW8dUA9WBcBdmqi0ZAgyT4sVQfm2AsBBmvprGx+GMCFTQCGIpuPAa9DsKakkkqi8Td0HZGFXl/50s9HgX/A2EcIfSTA7wA6FkDniwfMFjVfLuIxHpAoBbav+L3Gyk/ydMErCtM7UKmskOq8gOrJ/RVOKxXBjGbNwwZqKASQ+/IK96sPp5R3wrwZkz49Io6bmRI90Ik29UWFQp9CPOunGbmhBIgisdfP9kmbZ+prUG6c1SVA12W2aPRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5o3kAR4I+myZW+mzmskVMU71phcJkpzYJ0t478Co9oA=;
 b=ljyrm9IVgCRVZfwFoRWxi4NBSGzB1nJplEl5zeF7yyhnx6f0lPuNKZ2Y8TmusH/JyEDJzUednqXkppxgDA/2QwDGQV8SwHeQUGCGlTNSVd2+dtY8xhaSY0ToNRznyZEypWEcRYCh5oY9vNKlAjg8/Qf2r9kM5GrDhEIqOjgPudVWaGrNabAscN4XSOcZWB+9qpANhNZUAlkBLbPC1yREeiJzXm35tsQX2QGzE2w71VFMNYU2Qb0HNwmLrlchLGPB436IjTxfdnD1nUpgGsmLVQcMgY5y2QrsfX1lpPMH+JJ6RYzZbKOwPZnW6FMIlGwCg/kFSLYt4fqzYuklXgRCGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5o3kAR4I+myZW+mzmskVMU71phcJkpzYJ0t478Co9oA=;
 b=E7TVp1Np7qw0Vcbr5No31FvC976PjW9F27H/wiXCvPCk6rAdnvUKox/eONBSbbn6S51YSrpAeIqytpZ2nMQI/JO7Kfi89Od7Avyxpr2DyXarUV4ROMmq6vIGmIKw7Kg/safkMZo+8Mp29uiND0ajxTnYv2RCkP/zRIr4H6jfPe1i46DWkPM7MTkt2sar+Znec+HA7WsfB6BlUM4GBUXcAG3Y1i1hwKV0nkqfzLIGvKD5mPQrXcshzzByx1duYRsLN6HtL9C5z+8kCImWx/KAub94frRZoysJdMx2ufhfV4VkwxLsO5Ls6XTQk2s+ohCA0w9lBZAB5dCo87A2BWtvyg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS7PR12MB5934.namprd12.prod.outlook.com
 (2603:10b6:8:7d::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Thu, 22 Oct
 2026 18:51:34 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.016; Thu, 22 Oct 2026
 18:51:34 +0000
Date: Thu, 22 Oct 2026 15:51:33 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Jiri Pirko <jiri@resnulli.us>, Dionna Glaze <drdeeglaze@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org,
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com,
	James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com,
	roberto.sassu@huawei.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <20261022185133.GA3746973@nvidia.com>
References: <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
 <atX9fugGUsI0hGcA@FV6GYCPJ69>
 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
 <20261019225658.GS13920@nvidia.com>
 <ath4vwt7KGyDXKVJ@FV6GYCPJ69>
 <103486a4a29ecc7b72940dd051c00ae59266bd05.camel@linux.ibm.com>
 <20261021143529.GP3008132@nvidia.com>
 <8d8833fac61558a94af415143530884349584a2f.camel@linux.ibm.com>
 <atnqmDhgaJycTf_Q@FV6GYCPJ69>
 <2342b42699292d4e5fc85e5dd4d351a3f29ae336.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2342b42699292d4e5fc85e5dd4d351a3f29ae336.camel@linux.ibm.com>
X-ClientProxiedBy: YT4P288CA0011.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::22) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS7PR12MB5934:EE_
X-MS-Office365-Filtering-Correlation-Id: c2675357-a066-4556-c06a-08df306d7ec7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|4143699003|261022105027099003|56012099006|11063799006|18002099003|10067099003|22082099003|6133799003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	X06dTl+/Ve2pMA63luPSQ9XtLbIN3w5zIYbEiQVYJuj2X1jhUnDDPPCFgtkE82bS1kj+/mFKWo56DqfgNrOd8cYYxDht5a1RqRgmEOvhfwyV6sAS8+EfnQbjJw8yx5c5/m5XTWrg7lZflyEdd/DHA7xkiPaImuT+ZWNWKMaDxD17REjoQqUoofJLTj31zyHA9YGT+kQhmvrjEmsKWYJgXk0/LTwqj58dXyeQGABcnv6H0mTfpRmTN/FMjE1Clf0S2b/gImyiRPk1guz2yOKEWWNX8bfYSU/3v1MeYQ9ZdIxb3YTmEQ9zJoUabSj8BKy7yI7ymHmHXNresOU6yN+6qfbxRescM9uj8bWSJhRXHUKafgzT3z2WkNMFYvIqhZFaHyctRgR9606506aGtPqrbSgyQ2uTFoe7LF9ae8yXtxmt/b+95VR/sZgKr3Ve2NG+9UAyQSNSlydVmvBd7hlheJ3S6E4/JGHGBnZtiJ5Ed30rr0Oaffs+OLMzriovUR79pgjvD07F6NfNxM9ey8uU2Kr2KN9w2YUb4HWDj1fGNAuf61YHgO7o4FDNKkA6drAup30zz0SC29eSmzqpf0x0zX8DiqV6EjjHf83qbKQeDTNBejbPlCsCiAR7clIuypY5LOwhfDipOyA1HcuJiRGA7oj5kp5O3j7Mrfw4DMSTMwQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(4143699003)(261022105027099003)(56012099006)(11063799006)(18002099003)(10067099003)(22082099003)(6133799003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cmtWeUltYTFwdkhPQXkyTFd2b2N6cEhyZzMzdWZSRFRLY3FaSDRpZTdsd0to?=
 =?utf-8?B?OUJQOGlXU2JScDBIQWgxeWZhYTB6ZmhBbUZpMDlvdzYrYWlqRnpWMitYcW01?=
 =?utf-8?B?eXRTQWVhZXFrWDFWYkRGQW9WTnhPMTVwajJ2WVU2R1dYRWtTRXU0clVobTJ0?=
 =?utf-8?B?ek0vTHZFbFh0N25PdjRldmx5NDIzdEJwVytXSDViZG1icEl3dVRpeXFqdFdm?=
 =?utf-8?B?dWU0Rk01UGdRYUxKLy9kaHhqNGxuV0pPcTM1WU9iOGhFUmVRTmxGeGR1a2Q3?=
 =?utf-8?B?ZWVSSnZNR2pNaitnL21NR1ZOcng1M29HQk9DZ01lT0hjR2FMQUc0MjRlcG5y?=
 =?utf-8?B?OGNwU05tU3VRQnhzVjJ5ck4yc2xuQW5YWS9BampEQWxSTWpIZkhFK1FPMGJa?=
 =?utf-8?B?R1VhVm9COXhSNXBJK2xQWmNyODJFdzQvUlcxSjJBQ2xpSzJSWDZhdzA2M2Zr?=
 =?utf-8?B?Yi9ZeGFKZzF0TUVYZ3k2eDlMVmlwL1NHdldQdU9LaytLWGQvazRDSWRocjlj?=
 =?utf-8?B?QXhvUTk4MzJ0NTZSZW1SU05LZTZIeGQvRGNqUEgvVEczVHVGWm41c0dkMzY0?=
 =?utf-8?B?SHVJYlFubGhHVXdnOFBlYmRMUG5iZzFGMUNobGdiM2VvRGNwSjVZalprb096?=
 =?utf-8?B?VHFOWGloVVpTdng4akF5eURDcDB3VElKQjVKd2Q1UnBqNnBpYnFIbHJRQk5y?=
 =?utf-8?B?WXh5ckpBUVk3SDl0azFqZTBSZnNxOWFqWU9wRXhIS0FVSk1PQ1dRdmovTmVS?=
 =?utf-8?B?Ti9KRUlmRVVjZGU4UjloWU9zRzBXN1RacWRIaUpybDlEcUxZYjN6Tm95UjdU?=
 =?utf-8?B?L0o0bUFyMHd1ZWx3UktLUFVIbmRsNm9hamw4d2FyNFg3dTROS1hwQWJBay9J?=
 =?utf-8?B?QTczdnNJNTN3MlFINGVSVmNkcWp3Yk5DT25iVzNMOUxVbWhtdzBMckZBZ21I?=
 =?utf-8?B?REFITnVaRTh6cFNpUlQ4bC9aenJCdWVFNmhlOHRXbWZtRGZDM1FJRHgzK1Aw?=
 =?utf-8?B?T2sxMFRodk5YcHZFcXhNZHhZSjhLZkg4Z2RYTHE1RW0za3FPZFQ3VVhYenhv?=
 =?utf-8?B?S0RTdS9jVStoNXZWL0cvQS9CVmgxaENGUnZKVllWSWd2WHFoaWh6T3kzMmN2?=
 =?utf-8?B?REQ3SWwreWdsUHdKdDk2bDJOTWZ3N25pcGNaTlc3QmpQMlNnWkh6ZEdCNHc0?=
 =?utf-8?B?SWg4blRLVEVyUFpJekNRcDZ0QWxEbkgxOXpjcTY4ZXdNVmdRYWlrd3Q4SmxM?=
 =?utf-8?B?MzE1T1puNENVZzkzZDI5cXlOaXpvbkxDMkFKMEpXSXlXMjVFcEN6ZmxRZlhn?=
 =?utf-8?B?SzljR0VMOFFzZXF6eDV6dlpXVlpNOStocTVwUE8rTDJoUnh1b0pXSVo3d0Ju?=
 =?utf-8?B?NG80dXNESUI4czZIbVlxZFVvVzFhUE5PT0hNc0ljdExvaXllSVVHRXBodkdW?=
 =?utf-8?B?YUlqckFPdG0yeEZRR3RGUG9veHlYK0FDOFU1SFFoNkQzYys1RUNYb3o0NktW?=
 =?utf-8?B?WjRKTGlKbEJ1WDJwRjZ6YWNKOE50N0N5ZlJ2L0cvUlJuSzhMaXY2Ry9HNTU0?=
 =?utf-8?B?dHVleVg5c1M4S05pRHlqMUtRdEpPaUN6VjNIdnNqNnpncWxKdVZHZ1JGWFJE?=
 =?utf-8?B?MHBmTnRoRDhKNE5RbnRaMk1zamdRNlJGTk1iSlhYaDRUQkFORm5oZW5lRzVI?=
 =?utf-8?B?K2QvLzN6VXU5eDU4VzVyRm4wT01XZkhqZTRWVVVONUE0MmlDa2RQMWU5ZHl3?=
 =?utf-8?B?Rm5nSXhmVWdrSjlOd2w3N25EeUd0MFRaSmFrM1c0YmpyM3F2aDRDWVc4RVVa?=
 =?utf-8?B?THhBT0ZqbktwQzdiZm1jbTNDRCt2MW03MzlzR2h5RmhTUTVJMEg0R0VNZmhM?=
 =?utf-8?B?RXBUYjluWmQxelVLM0ZLS1packJjYmhuL1F2cUJKSUFJdXdsYlg3cmo2NEVy?=
 =?utf-8?B?dWVaU2lNMTFpQ0ZkT1BOWGw5emxLcXJvT0hNWU1RV1NEUWZSZG4xNjJXbmJD?=
 =?utf-8?B?Q2hoYW8vbVBQUVNjeEtKQTA4QTJ5TkRMa21rZmpxK3dHNkpxM2pzTm5seUl4?=
 =?utf-8?B?aWJlazJhQ2E0T2ttZ1FpRXozS2ZjNm1OVW80bjZ6dkJXRkZhTlp2Wm8zL0w3?=
 =?utf-8?B?Y0QvN3crVUROT0hKSklkRXNIZDVSd0R0U1dhWitNbFV2c0RhbnF5bEJPQVJQ?=
 =?utf-8?B?TUhaOEhyRDJvV0R1Qk5Ed3h2RXdJK3E3ckpGT0o0TmRoYmtoWDY5dWJTZjhW?=
 =?utf-8?B?K3dqY3ZPc0RFRVpVemJNR3VuWU5JZG9KQWRZWW1VeFJrRVlIdDMxV2Y4Y29w?=
 =?utf-8?Q?T2BKRJkolQXNt8gqxU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2675357-a066-4556-c06a-08df306d7ec7
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 18:51:34.7558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zCvzDhzz2CijEnc4Od6CyffwwJAprNd2xSiySw1EXBDUklBkT2aYW3y5GhCdFpTj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5934

On Thu, Oct 22, 2026 at 07:24:57AM -0400, Mimi Zohar wrote:
> > Isn't the hypervisor what we are doing now? I mean multiple extension
> > originators share the same register and eventually the same log. Or do
> > you suggest to go even further having a "generic_registerX" exposed for
> > every hw implementation allowing the user to have full abstraction?
> > The "generic_registerX" would be always alias to something hw specific,
> > like RTMR2 for example of TDX.
> 
> I definitely prefer the latter, as everything continues to work as is with
> minimal, if any, change.
> 
> AI's wording:
> • The Virtual Mapping: The [attestation] subsystem exposes "Virtual RTMRs"
> (vRTMRs) internally to the kernel.
> 
> • IMA's Dedicated Lane: The kernel config routes IMA to vRTMR_IMA.

I was thinking something similar too

I called this "PCR policy" in my previous posting, but in-kernel I
would expect something like IMA to request the "IMA PCR" from the
current attestation policy.

This could be a locality 0 TPM PCR, a locality 2 PCR for a DRTM
launch, a TDX RTMR, etc. It keeps the layout in one place, and lets
the multiplexor steer it to different hardware.

The policy would outline all the in-kernel users, and probably provide
some how give a recommendation to userspace like 'systemd log goes
here'

Jason
