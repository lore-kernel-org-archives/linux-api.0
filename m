Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792451500;
	b=FHXIgzKNchxZ6N8NIrdOZ1lFSicJJ8lwmBx8ZjPaIzJ7jd14MAHbGGy6O0UxF5zZzimo
	 BqP+g11oZOjZnPP/tQUJ+w+kTp+0JEupRDnwPNcDuNp6QbfVlStYK9RyTW2C0Fblh+yfV
	 zaaMIusv+Sm8WGNJIRUAfNUbD4GDRyjjRjzJqvpKkw+n/+sVnG5yAlORCIYDqhIDTDOtU
	 pOfWw154mu2BnuLSVkkFU7ID1Y7iRZmsrDCZTbWRwtQHNhUyDmlIsdnzE5E2C43HVyPN3
	 53POkBp0lbSKXLcqK1tCjhNiOOLfVdY9+CMY9FBc992hN50V1VYdHqRy13FjioU92Zw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792451500;
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
	bh=Pk3BetNzco22ofDGndAoQ+zxFz/nVvlehUw2PuEfUN8=;
	b=EQGY2XrXtEVLeB7QuQtazPfBvs9F3h/7n+9uD39IT0wfB54p1mbZmlI8tcKFMGB9L8hX
	 3p7ENQuxKJFOqQYeMDLckBuni1aN9FvMd+p0tuvhuzq9P4GLtbuKT1wbokc/dGh67DgYv
	 1U6O121BcYvEmBoCtubu7LDJycFitj6YbXRQjxbbV00UrqwqnFLEPP1kQyIPP1mnlw6+s
	 T5ancqUNxPPNy70gryzImNQEXUsP0m5M43BjktNti1oMKB8oq5+W9U5oSE4QK1s+IcC6n
	 7JwTLx3zCb50d/bcThAmVyztYx50QqaCXMwgLgzlGqtYaLRdOTRuz3iEwAhAgvOL4yQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aUAbArE4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.70
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013070.outbound.protection.outlook.com [40.107.201.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6B3606A31A;
	Mon, 19 Oct 2026 23:11:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D6B3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aUAbArE4
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vLh3K8VXqQjbe5TFXopGyUR0yUyfq0gkMBwC/unir6Wwqj/REexbhi94xuUKL1NevP1CyBkdNPgHqTBQCaAMQIh7n+mTM3uFz1HYgB5JyAa+kjk6cwa4xTOoM9dllw3Clgn38Jh7cUP/NglB5O4quYaDdtZaqo+kSFRpPb3FSjvpEqvYyu4Pq9zmH0ElYj7HCdfX68RnTmMskR0FKucUNP3euI6KduOF+c6umrppmjlilSsZ+EmF5Hr8bmrFRjBewzLKPwTaxqaswVfdDHHJpIVu3GLopq67i4FCf4ELxuj2kXqaAe4XFwyN26l7LoDeXdbg7o00l3i/OUj4XnnzGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pk3BetNzco22ofDGndAoQ+zxFz/nVvlehUw2PuEfUN8=;
 b=V9WKz3zskQ3W5dK2mVqn1K184VOLeWRufrf9L9vDnjnrU1jRWC8KEmTFPE1+jE8tmc3+oEWweH6Ypi3VIbtsAUulAm9X4iz3l0mz2ouNFiz0D8unx9NU85OIbAuToCGEbihFrzb00iNglZj4Q2PH1IqYShMHJcE2IscxCwrM6FNAkGvXL+aXhUhAObV0wriGAyXylULuccBPe/NnZgIO8hPGZSV6zt7i6a+xtaM90NR6vl+zY/aMRhoE8aUlkSVf5yvX7ag8ZmnL2bFodOgirvjqaMiYvF0FpZpXeEk+6FumSCj5do24Z7e/UAluD77dXJaPzwCa7X7r846DGMh/sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pk3BetNzco22ofDGndAoQ+zxFz/nVvlehUw2PuEfUN8=;
 b=aUAbArE4Gl4L8CPFXuS/7QePwriXB+en7vuv46oRJ16sgXX5qcwg5mIgd/KOI943/B1xYU7b2h5rF9leW05837ILj9XcVmr/Hycpbkcl4jJxXUtNalK9bUHRxCHFHjAZGlRnaDNWdU0Hg2Ze8tWaWdtPAd4M2/WOyC1ARtG9prqfwwiSxbkp+E2UKVkuX+YVvwk2/TXDTKJfGJBHwfvHlHzw7PlMESUfEH9IsEnUz+A3Q++fwXpIKUr8062NPPElXQgjhg57hUxC4IvLO7+wXbqpWjgVbzB4C1TWtO8Vj0t1bMUn6buC83pTo9zdpxg2+uxW18IOy+b0lxyIjymbbQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CH3PR12MB8993.namprd12.prod.outlook.com
 (2603:10b6:610:17b::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 23:11:34 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 23:11:34 +0000
Date: Mon, 19 Oct 2026 20:11:33 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Dionna Glaze <drdeeglaze@gmail.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de,
	ksinyuk@kernel.org, rodrigo.vivi@intel.com, cedric.xing@intel.com,
	sameo@meta.com, James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <20261019231133.GT13920@nvidia.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261016234354.GA664420@nvidia.com>
 <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
 <20261017203407.GM13920@nvidia.com>
 <atPgqROZZxnihYfC@kernel.org>
 <20261017231007.GP13920@nvidia.com>
 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
X-ClientProxiedBy: BN9PR03CA0253.namprd03.prod.outlook.com
 (2603:10b6:408:ff::18) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH3PR12MB8993:EE_
X-MS-Office365-Filtering-Correlation-Id: 69c2e298-2222-484c-4921-08df2e36518a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|7416014|1800799024|22082099003|18002099003|4143699003|11063799006|261009223027099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	oMoOBxApfLb+UgZHEQHm0CIIPkROq62OiKn7lZTb3Ge7pG1BK+qjrR2DJcR4wFgjeN68oYWtyd8QSu1MhvhnCMP+QKHqZRioNlvb+iUBzWSC4syC4aYYzWcsDexd0l0K7XtZLdGI4c1tilSaPmSYbFY1Qf6knwLd/wJknefzcqxNIlqH1497QGgjfsTiG7J0BaSulR4ocIf1fYqNfg6LTSU+Akhnldvidm822/8g23KX8r1oOqfkREVQNwg8uFgoSXPhjeE6SL0yQWULKX99QDAiRofQE30K53G8YSgHlxwnDKdeXXfd15BhekLCLenbhcptGl24VF7BXVgj2gzZ93XfijvklkTvtUVZfIqgcMFrl3gEtt2JZLn6jZ9kqaZRYJuUOLiX+qG4doMkasTXo2hF45fmTzFiBSDfJovN716l2epiQXbS/TFOsEiYT6Aa4SPhfotClyQmcIvpe4l7Z86+gkzV7h1VrYJS05Zi/14arPERnnbXE89nBNnIGeEv7b1oU0NbUluIMYQDbPEJIi9R64g4KyWSkOtIZ8pIuZFAYpLuNQT7r8lf5K7Jy8eqsuIAG+P63wycMYG6AMWhbEkKZSizGDIjdftn0x6XcwEJk0m1A7CNb/MZQJTSjIKAcC381aIwORPkzuZ1OQNFbSGNV3keX9Fq5rPedDoRnO8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(7416014)(1800799024)(22082099003)(18002099003)(4143699003)(11063799006)(261009223027099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Cq8NXeTQakZh3CrmJqoJnx34STvs2XRiC+/7PwqkAJH/U9xb4ddWW3WNt4/m?=
 =?us-ascii?Q?OgGtQvUHc60tK0pZ2MB97+lCC8aZSqm9mmG/gkod20tiQk4RdE5XI9kzYMLI?=
 =?us-ascii?Q?4aQ1hYxHVY/OlItXPWq6kWbnTJWZeLKtKL3dTNp82qZyKjpnUT5Qm3AaYMcZ?=
 =?us-ascii?Q?oTP11zsasDTr3ab2PSt2QvMs2Qxgv8hLf3n0AHcVggcsN/nkUDctOoQlWLl8?=
 =?us-ascii?Q?Of333krYWd1uJKqpQ7SJalgLjbn6/uaWSKRj2aKYCmp7yw0KwYpCnypCUB2t?=
 =?us-ascii?Q?Lcl9B19KnuzhKwUOcZZFOluHGEh818UO69XO9zCswLUlR9r1F4rQ6t6AFP5a?=
 =?us-ascii?Q?dpGhXg+/Y02E7IA45ABX364gfZX4+hxcDEYisW2gK4wMixac7iLmlhEtO7IN?=
 =?us-ascii?Q?wmULbDyM0LGhS+0BpxLYFaggddMM4Ml9ICgJ4Vp7TW07T3TT/60yw3NW8v4w?=
 =?us-ascii?Q?NMq4V5u7B9cS8cyko7a/vdWlqVqfMisURFC5H4iG7Z8B7mzvKX9+h8qoJiZh?=
 =?us-ascii?Q?AzV6zIq3H7G7QkyuyFPwlIpSFA9ESxJG6B7i7c8sS957YB4dICpPdX5y7gmb?=
 =?us-ascii?Q?9h6pAYAG0/klxe09YfhkXR/qkgTGx/BhRGgr3QQs57FM+q8x+5/jzZVhI3J7?=
 =?us-ascii?Q?DBQfwtpuHz/d/s6JTxXKdhrI+cNfX9iwuInOFwxO19CtubTRJ06Zdn2qLJ7A?=
 =?us-ascii?Q?cfI13dC3NFwxd+iJvTOfyTe5Czp2I+ELnF1fHfCn/32YPLyQKM92rwBotNiq?=
 =?us-ascii?Q?lj/SFf/s4oSOqKPczaL4tL9NzIs9oOVVWNQG8W1AQVoI0mYVlJbBUhZ08/AG?=
 =?us-ascii?Q?QN7/zXqPwbQY2GsCqewYC6kSwnuMIjEKK9Vjh8PK0WA89o2QJLH2NYL6nBo3?=
 =?us-ascii?Q?LYD92cdfejzzFYUQBYVU0o1dQWl3Cfi0RmraSvFxI3HdYz79i2L9PHjRXU/D?=
 =?us-ascii?Q?TfMMLPw+q2tkl7RkvonalD02B1LpTjhaMk17Vm2F7c1zE+VSBY3zfef6leec?=
 =?us-ascii?Q?XcExPPRyPVIcab4mgcYOfBPg66JKcTxNWa6xygJVijbK9PRdzHBzZKkVjmS3?=
 =?us-ascii?Q?SRTQjSRajPtDylaHiHsXl+11LUf1ARhSie6jBRXfaMfMjRll5WoII8OCly3M?=
 =?us-ascii?Q?O2kTeHtRNin5m9mBnLmFDxW+3ihoYMJNKKS8mYWSkjcn5elBnlk9igDEtmob?=
 =?us-ascii?Q?VHFCeVEuQr8Vq73gtm8nKzi+NeQa2sgByd3J15HBRxPpBhj4+28WZXHEvmGs?=
 =?us-ascii?Q?fnTULFzsQDnI9MMQlFF2xss7j9xCLHUEgG+DI7O9GmVYrLI/v+mHJ7TcZB1F?=
 =?us-ascii?Q?shLQYGYQ7PyWNnrCMMPYuIcaJ2vKYcCghuTLVI8vQxcbl49Cjytb57gqSjqA?=
 =?us-ascii?Q?baQ2J6kgjMVeQL4a4yzeBcdcZnJBoDehQC75K4RGHTrk4ziYlUF4mM+zh5YI?=
 =?us-ascii?Q?BwGeKaG6w4qkCBqfEhZRvu65Guvsw5dzgo4m2kkG2Q8rMLgYILzbkPRMZJuW?=
 =?us-ascii?Q?l8rAqSadMatSOiiF8y5EicW+Djse0TmJO5PV8c3zMSuoFCNEgv6i0SPCTeyI?=
 =?us-ascii?Q?ASDxhhlAWxNi2vJr3gWwSByK4TPqYEnT4zHshilL2+1P0Lj/x0hqmZhf/yK4?=
 =?us-ascii?Q?Lh0/jYLPhyjEJUvSiuKt2LElyEQ/z9ODA/jfO2BhDTNPWohi1TWaldlo26JM?=
 =?us-ascii?Q?J3/aOxXUyHoTrMpWlfjWBBD+0Py3C8GololpVFlXzF7RyVM5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69c2e298-2222-484c-4921-08df2e36518a
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 23:11:34.1963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4928tsZ4Imjas5Uzn9QC/hSc/bNr839fEWpWM8maay7GeT04u+aG+gPyCtFs52SO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8993

On Sun, Oct 18, 2026 at 04:53:28PM -0700, Dionna Glaze wrote:
> > On Sat, Oct 17, 2026 at 11:55:05PM +0300, Jarkko Sakkinen wrote:
> > > I wish I had a better picture what is going on.
> 
> Me too. I've spent my Sunday with Claude trying to build some
> understanding of all this stuff, and put together a static site about
> this series.
> 
> https://deeglaze.github.io/scratch/ctlv-site/index.html
> 
> It includes a review that I've personally walked through to ensure it
> wasn't off base, but of course we're all fallible here.
> I haven't decided to email the review comments to the list yet because
> it's pretty thorough for something posted here as an RFC.

It is a really fascinating summary with an interesting construction
for the CTLV part, I hope to read it more carefully this week. Thanks
for preparing it

I'm still digesting the documentation as well and have made some notes
about improvements. I feel like it goes straight to a highly technical
summary and perhaps some kind of more gradual build up would be nicer.

> > Currently we don't have an intention to flow TPM command packets
> 
> If you're not intercepting all extends through other interfaces to the
> registers (e.g., /dev/tpmrm0), then it needs to be clearer in the
> documentation that users not using the interface will break users of
> the interface when they both target overlapping sets of registers.

This is sort of already the existing case with all of this. There is
no way to 'lock' a measurement register so that only one use can write
to it. eg you can't prevent some other user app from opening
/dev/tpmrm0 and trashing the MR your app is using.

That you can do it through this interface is, to me, just more of the
same ...

But yes, it should be made clear where all the overlaps lie. Hopefully
nobody finds this surprising and there already shouldn't be two
userspaces using the same MR.

Jason
