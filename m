Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590670;
	b=tjBcPZ7BX6mhVZZDdEgkc7FJ67mfH4NMplwse4i/VaXhvefijuf7ZA6ZEny9Oh8+dkEH
	 GIkpWOWtNcQIF7+Yu/k4wC0rw6qVx9X+DQ3odhvLPaamzeSdZtiFc76nWoXkcda57wbr3
	 Rkg5aS/aiDkXRLP9ODsRu9B4pzzz6GJzEi84TYLlaTqXmWIwSUsBlzfz3ByTLJUyupT/9
	 KrrBI1QfJwdKlJ2CWX7+pl5aQgYLrtulrZtgW8eAbIuUZzA/M16GN2U9fXnE6mCTdwrrm
	 bkDGCaNGxFxJ8eB/C2jlwCrXk7/+NVfDZrOM2Nsem8FWLDkQc+uF4jsv46vfYCpKkjA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590670;
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
	bh=2Lsdu9ZU7Knt2vBPqwo7rP4ey4yHzUbeyrn8C37mBuk=;
	b=YQLN3MI7XYevD1AvU9AwFc3DNcS/3MNka6pnvn0p8s4MD3XDXzepIJAbiUmvQxUfD6mp
	 OsOGhpCHjF22oiwiHwyZLlj/8sT8wex4ljAw4XUgi55jGjao63y7EaEq53olbXwE0g8vK
	 TKOw7R8pUQ3oL9BP7VDRgGj2c112WS56DW3EdaR/8k/fzSRTW1K2CF8wQuO52ZP+rDIsM
	 MtbJE6pPSbn2+TsB6XK4bZe0bz7CFtZs7col4AEOGa0dVvj+L4m5MZnpEMd77WzV7o124
	 2S4HZ8NsN3U5q2BpKO7UAeNHTY2VFtoNKgYLmYWJHYAjttfWzqae9nfgT8oEHCjbAMA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bQ9rvFKl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.51
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012051.outbound.protection.outlook.com [40.107.209.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842BF606A31A;
	Wed, 21 Oct 2026 13:51:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 842BF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bQ9rvFKl
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DuNgANq31QWjY0fU7Xu7luBVEj22Vj/IzRq5LJk2N9xI3R0aDPsIb1/Fi5o674XyF1EIJ8A3b1OXpCJmwfRC/bah8JCKSinhNNIX+3hYRv7kdE0dOavlRbaHewxSc+LKkEwucMa/nGKJo5eqbM3unlpd4GeaDbDjfXlrSac/JLvpXpIFi1QqjkBm0l9kSyZZdy5ZXLjBTS2eD2MoajRVKI0uopx+wQ2cg01vlk6ZuUfnKFne3zn/d32jo2jqu0mViEBrkjDc4iD64ubM/IRVXL10uAApS1UK4Wvh9rd01Ow1NZlh87fEens/eg7iCiZC/pjAbNERl+j5smpNBzBGig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Lsdu9ZU7Knt2vBPqwo7rP4ey4yHzUbeyrn8C37mBuk=;
 b=dDLMlp63EMVUxPSt3dcsKJ53Y3SP9DrLCuRSkLAl5CUQUYLVQE3dwc+Nt31EGlEeZIc4C2TZTQB9pUOFgky3UGvpKiQpEHBlc4FR9wEloUdF/5bXoaS44Fz6KL48ywHErbAGW/qT7g+US+LrUMKaklsiuggDLJ5PPDOZK7iVxAgxdhnIUrjqVBb5e0BiYXWTA2kdJimC13NZunWqe1nsYmN47EaM2wdH7Hy+PhTULZf1u5E/ERWTV8arBjO9EMGS5Aiik34YtjQ6iM6VSpfCrxEHCT64SO2PNiWt3AJFjmg5t4Wqg1KMcR4GrfSTzxsYVD6gKSMQXPcKNQp+jp2BUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Lsdu9ZU7Knt2vBPqwo7rP4ey4yHzUbeyrn8C37mBuk=;
 b=bQ9rvFKlU+k4qzwMmXWEcK+tchPHRc3CeDGLD6Pla6ag042vCsDKDWWqhak+EwCGcVdcluTdgK48RbuZYYTYlF2tQN9lSCIuLT1HlBuL9TP6zuLi5RxooQ2u5szHe9rlbyiz9+uyi7i+A411YSyd9j1aQlOL9H1LaVNsnLj/eePeWoqDj8WC8yMXN96QXZ/xMyLuAOFi260kFlk1N8ieOKxtsk/FFsB8P+05uHeJdQ4Oy2lC8eXdvCw8cGIQyfT9hPPVEXZYfeQ3m4tmy+bnU09xqmozxlrKaqudFEd0x8e6D4iIGVDyqZ9dzOS0DATOqupS5KBsO/ZFjnwycWGm3g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by BY5PR12MB4162.namprd12.prod.outlook.com
 (2603:10b6:a03:201::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Wed, 21 Oct
 2026 13:51:03 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 13:51:03 +0000
Date: Wed, 21 Oct 2026 10:51:02 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Dionna Glaze <drdeeglaze@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>, Jarkko Sakkinen <jarkko@kernel.org>,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de,
	ksinyuk@kernel.org, rodrigo.vivi@intel.com, cedric.xing@intel.com,
	sameo@meta.com, James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com,
	roberto.sassu@huawei.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <20261021135102.GM3008132@nvidia.com>
References: <20261017231007.GP13920@nvidia.com>
 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
 <atX9fugGUsI0hGcA@FV6GYCPJ69>
 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
 <a69c7e7ac4fd07a9c375faadc599e96bb8c8534e.camel@linux.ibm.com>
 <20261020140655.GV13920@nvidia.com>
 <aa00515a0f364fea0150cf1550a09d9400e4632f.camel@linux.ibm.com>
 <ateSly15N5mLrM1m@e129823.arm.com>
 <20261020165251.GG3008132@nvidia.com>
 <ae372ed03da3cd2d57c922850b3b017bcb83ca07.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ae372ed03da3cd2d57c922850b3b017bcb83ca07.camel@linux.ibm.com>
X-ClientProxiedBy: YT3PR01CA0057.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::27) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|BY5PR12MB4162:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ef3c088-b354-4b0f-8a07-08df2f7a5909
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|56012099006|4143699003|11063799006|10067099003|18002099003|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info:
	qZlgpAS0pAnhec+qgoJmfwibUBu2Oq4URE7+IHeU5YH+d+pUaq39NZo7GZtnK74o8HgbUPnvMRYOISBldyrgFt+p9b5z1l4gf8f3LieQVWeviqaM+WcwcjOw2djV5s8fsTAGUCCfd+eMNolX1xv+LM6+4xvLNHfPDo9BTe5j1aj9ABmS+0dy/8nWN8HuTWn5QzUSJRwyFmj2xg51iszQKobdQKTxDy+TUL8EgMlPPyqkYNxVHF/3FBeL4KjUCAWOLZgRdbcaxgwUpeqfBRxnQH5e9N2zWaFZW57hjMtcxPUtTO4V0FOmuHSxVfSgFIJmbQkOYCs+fJdPx+79QeUOV/2C8GqKyxZdxVlFZvXXMwEkb4sl0otuiIZsMY/B2sTzqZPQFvnrEhO5QidBihQZgKtK5WE1rpsyFNBn82VvjUJdnEcEx9mmguY8VdUFEWa3U4EZdS8O6GskcbiV1PZG3sCd24X4O9DO0iOWmdxGMGJuSTLHMI4YHf8Ge8s7yq9sPK+fqLGX44p2ZLCE/ezVIdjPgX8pMw7LZo284WImfrjujOszOEXorAxr/iR5fBkcWMEmx2S5aq71LFUs/usLWmDD4qJn2fndU8o8cJ89324XCLiP6LQAnSJFJ4NBX74Hb2cJiKwoxyFZ+aZ827DjeVOJPuVmctxs1XByvT7+fQo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(56012099006)(4143699003)(11063799006)(10067099003)(18002099003)(6133799003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0JrUCtCWE1LZHd2ZEZyV09RSE1lSGtzWHZEUXJYZEh2Qm5HK1FMeWp0YVN6?=
 =?utf-8?B?YWtrek1Ed25hSENTMmNMWG1QbGxwTWIyYUhZNUxncCtrVUk4UnUrOVdVUDc3?=
 =?utf-8?B?Q1VnMVhRekx3TTZCYm1vbG9TZ0JrcHdrMDQycWl5REkrb205a1gxekp1eFdr?=
 =?utf-8?B?ZUpGUVRoTVVENGtEaktvS2lVOUttT1hWUFNkWHNnL28rb1ROOWVOUEZQT2RM?=
 =?utf-8?B?TUIxYzdYVFQyVkswTjdYaThRSWxpYWU2VXVnNFdGaG15NVhpR0xNV2tuaVRP?=
 =?utf-8?B?ZEN3SmdxbUtWZy9WeEx1ZGJkem55ajk3eHNJVzhNOW0zRXlFOTlpWjV5Qy9L?=
 =?utf-8?B?T0dFWkltMWQwT0VVZFdRT0tTVVEzZ0szMHpVYlRlVnRPcDI5TEt0WnYwYUdQ?=
 =?utf-8?B?K2FLbXIydWMrZDc3T0lrUVJRWXJGUGtnWEJHTkRMSFJHQXRCUXhUNXdkMWpx?=
 =?utf-8?B?MW53VDFxRXNQVjRna1ZVMzJTS2JzaWFKczNPc0VUeWdFV0F2MHhyUHhpU1Vl?=
 =?utf-8?B?MXZyd0ZHdktLQ2NZUTlUYXdGQ1dFM29OSTF5bktmeFpGVEYyRFVDWkczZFI4?=
 =?utf-8?B?YzhJdDI3UDBtTXJFcFFPUXpGdFF6UkxMeURoSkgyVTh3SGw4UzZSS0poVlFN?=
 =?utf-8?B?eXFYbzRNakdLYjdwQm53VXV1cDFocGF0c21VZjhydXRJUnRWYU5MZWRjMWJU?=
 =?utf-8?B?RVRIMkNYQmRvYWVjOFJodE1UcGRZWVY2c3pwVmU2RFc0c2o0cW5UeWRQb1BC?=
 =?utf-8?B?RjVEUDRTTHRNalRXUkppY1RXakxkaGYydGZjQ3l3N3RCMDFWSlJNdGpRaWda?=
 =?utf-8?B?S2xlaVpaTGtFRmJWc0NwMHc3ZG43RDk1K1B1V2pNa1phNjNUSHFucWVFenF1?=
 =?utf-8?B?MUJzUHBYdi9DQ0QrKzA5UFVJZUwwdmZUVWdDUzQ3ZHpjY2wxL1hyb1FEOEFp?=
 =?utf-8?B?UXVHZkpNbXN6ZjVyMHV1bEsxYVNEdUJmRFdWeEFmUzVLNlZHVmpFaSswZWtj?=
 =?utf-8?B?UUVJY2xmRXBDOURtVnFnSnV0UmMybVVrbjNLMXFOYTVuTEl3WnA4NjFwbmc2?=
 =?utf-8?B?RmdXclZOUWloRmtNMnJ3ZjZVOEdFOE9udkZnYlZndjZaek5mVVBWMW9TcmNh?=
 =?utf-8?B?MDdTdnVYZG0zM2NvbWFaOGQyelJOUmwvdndPeGFvSitTQmxjbUczMC9YVVJB?=
 =?utf-8?B?b1A1ZW1RajFLYWI1TkYvL29UMFd1TzlieTE5VU1MTWxBWXJHTVV3ZGNCMU5a?=
 =?utf-8?B?Mm1QRmZ6Q1ZSd1ArZVdZVUp6MzBrZ3VubCtya04zSFRlQSt6Z09CK2g3Yzhj?=
 =?utf-8?B?YmlQZ204aWEyYkxrS3lYSDZZSHRDS3c4OTE2TGNQeTJiTE9yK3F3U2J4Tmhu?=
 =?utf-8?B?c2t2aEFjd1RmM3N2MHI5RlU2eW1pajhObTZnUkhjUHJYQjlaSXU0WnNLM24x?=
 =?utf-8?B?dEVZRFE4ZURueEJDSnFaaDZ1R2JXQ0ttNUlvRll1N2RzK3Rwc2hUTnhUZXJv?=
 =?utf-8?B?ekdmdEhOQzk4Z21oeUl1TTllS3d2ekNRQS8vMkhPMDgrWjZQRmlKL3hjcStR?=
 =?utf-8?B?ZDBtNmtBdE9lcjdpL1ltVC9TcEhPL1ovTVlnZFcrOTBNT010bFc2TVJkZkR1?=
 =?utf-8?B?WU01Y2k0QmI2RTR0NTBxek9yZHpSTHBFU3hvY1NMaFEzK25oZm5CeTVMSzZk?=
 =?utf-8?B?U3dtZjJtb2JHR2RvM2E3Zm9WYk5lNStKL2FlM3hHbk00NWpjUmpGVDNuNVBD?=
 =?utf-8?B?RjB6alMxREs4ZjVuSFhJd3F5bzBUeVhWWDU0Z2E3bkNDUjNoMk9VVUVkYzFM?=
 =?utf-8?B?VWpxd0dkbWRTWG1wckhYaDd1R1M2cWhHSVdUWTF2M3FNeHBVcjNHS25BdFRx?=
 =?utf-8?B?WWQzanM2bkJhdWFYVEdjU3dBTjhQcEx2MUFzM3hDUXd0SHFXcmdhYmY0cXFk?=
 =?utf-8?B?ZHNqK2doMVpTTWI5TFpsRUtCQ1dpMjhObFhnRURPZks4MW5naG1rYXBCN0dP?=
 =?utf-8?B?eWFGSUptSEErYzRwak02RzFFc2JWSGJ1eEgxK3dBWENmWCs1Z0I3VmhyN3Yx?=
 =?utf-8?B?aDhxMVh1RUhSa1RuRlFFeHNoa3RJb3pYZkh2OWovNnBYQkZOdjQ0Qmhsdzht?=
 =?utf-8?B?UjFuSjduOVZtb21NbXgrRERkVkR3bWFPb1o3bFQyVEFYeU44Ykh2Y2hFOFB3?=
 =?utf-8?B?M08ySzBQZkZZZXA0bUMyNGk1QXRJOGVDbjZZNTdFdEoxQ3ZQZXJkQ0kvQTEz?=
 =?utf-8?B?ZVNEb3FBV09RY0Z4WVVLT3h3K0FSSzBqeDh0TXRYcGdFSlFMN1RFNHlFZlIr?=
 =?utf-8?Q?TevV0EvTkLB9zYC3Vv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ef3c088-b354-4b0f-8a07-08df2f7a5909
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:51:03.7302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mEnns8sFcXkBBaSFWuosCJXFuv3mm9v6F9dZW78HHSeq8hJWazK0h9XghAtAkWQh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4162

On Wed, Oct 21, 2026 at 08:23:05AM -0400, Mimi Zohar wrote:
> On Tue, 2026-10-20 at 13:52 -0300, Jason Gunthorpe wrote:
> > On Tue, Oct 20, 2026 at 05:11:03PM +0100, Yeoreum Yun wrote:
> > > But, I have a related concern about deferred probing of RoT devices.
> > > 
> > > For example, if TPM probing is deferred until after the attestation
> > > subsystem has been initialized, how would the subsystem handle the
> > > TPM becoming available later (This is reason for
> > > IMA_INIT_LATE_SYNC).
> 
> FYI, this patch set initializes at module_initcall(), not even late_initcall().

Yeah, it's fine for where this patch series is.

> > I don't think it would be any different, the mechanism for TPM would
> > become generalized and apply to any attestation driver.
> > 
> > This series doesn't attempt to do that flow yet, moving ima over and
> > dealing with this is another series :)
> 
> When TPM device initialization is deferred, it is retried during
> late_initcall().
> 
> As there is no way of ordering within an initcall level, there is a race between
> the device driver probing and the call to late_initcall(). The solution was to
> allow IMA to register at late_initcall_sync() based on a Kconfig.
> 
> Both device_initcall() and module_initcall() are at level 6. Are you sure:
> • the PCIe SPDM Devices will be ready at module_initcall()?
> • the PCIe SPDM Devices are not deferred to late_initcall()?

Why does SPDM need to get involved here? The device acceptance flow
and SPDM stuff will be managed in the initrd. The subsystem can accept
drivers and load a TPM/etc earlier while doing SPDM later. That's fine.

AFAICT IMA needs its ROT to be loaded before we reach the initrd.

DRTM also needs a ROT loaded much earlier as we need to measure ACPI
(and the initrd?).

I imagine attestation subsystem will eventually have to be ready to
accept drivers prior to ACPI.

ARM's DRTM architecture splits the ACPI into parts that are already
secured/measured somehow, and then other parts that the OS is
responsible to measure itself. This split is arranged so the OS can
discover the TPM through ACPI using only secured ACPI tables.

Thus we need to parse enough of the ACPI to get the TPM driver loaded,
an attestation driver for it, and then continue to parse the rest of
the ACPI that wasn't already secured.

Yikes! I dread making all of those things.. But that's an option for
the required shape of things.

Jason
