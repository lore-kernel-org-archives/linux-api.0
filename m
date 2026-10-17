Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011054.outbound.protection.outlook.com [52.101.62.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8C13BBA04;
	Sat, 17 Oct 2026 21:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792270826; cv=fail; b=mkB0MKRFWooAbcdiUnWOszz6BSxPRDiWNP/ihNa9KtySr1SOEp2HjFycWFYtvkqNaNO8x3GDybmmdr1MZSehuJ0gVjGBCpGHK+MK5xYj9tb3hE/Rjzl3DeFiWydUyWWca1mz2laXHXv+HkdOOHz4RN2Y7Y6cqVm3eLHAY8nzLmc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792270826; c=relaxed/simple;
	bh=ISkV8QxZyhvLyUmWXxLM22JD+eGQEPd6JZKSem2ERmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JmiVA3P/tYg4aDU45la/Im3kyDunt7Enugs8m+7jZPrcPLVUf2h0dZsLO1TU3Ri1syTWvuxs9a6eVw8s1qzIlR+f7s5MnaG8MtgEcKvdgudnzc02nrOHzeTcVNLm+aRHTtp+06H6fu8uXK25STarMxBhWgl93b25+SDdgjTgbps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SlyMZFbH; arc=fail smtp.client-ip=52.101.62.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SlyMZFbH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y0od4i6IouNekqwbqPJLOFZV/2tecaR9dksW2Y6j1V7zFAukp2H40Gr+YiRV8aNN9IDfz8v88stsVXTZMHBIkklSkHy2zVyNiqs9SYivg7MPv/9VnHIggrM5T6kXkG3nN8cIF7J9n9oY0YQLXNrqQmTuS9ctI+WR/KUqEXP8Sxg7So5OhBJQh/qNDLbaZl2Yx1t07gVjogSMjfd7jGyzjGb1juwydkxfa8ag8erUDnjmpRa46fgWu+U4VIBOe8DsgKngQq2VwlrcDCXUXfcaSi0fWuh5iPcDnVQqM7SEcm4uRl/XX75nIKeGl/uyW68V9eywPb4l0c80jJ4nefMqEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PObwut0C4VOZCbQ4QKuiRqwWAFRt/2/Nc7NW67nhcFw=;
 b=zNp/BLQV/6TzAczZA4W4BSejg1tD+qugt5ZHmvdBOiaBmKs1hyION8ypJpXSPGRL9hrFJwz/QTTRh9gMq2V1/Iu4pbaKF0YuB02rNiHAY7u2IWKUrBhakuEs77s3x4oywScK0GTGd06W6xzIX6JD2JpvQug2TwQUHZgfr6AFPybEp8d6l4ZSPvlFicA9XDJEIYkLz44ITfk/B35k8i/7dJQ5dzJ+x7HIChIunX/oO/0XHP9RfS9rChPvA6O9bNeHFdvikr09TVao4s8G1HUW7fkmr+Nt2KbUVfJCEQyte1bk93T/gX/7IR1t4v7OXCvfv6wiSTDr6lsn5cwFyLQi0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PObwut0C4VOZCbQ4QKuiRqwWAFRt/2/Nc7NW67nhcFw=;
 b=SlyMZFbHbd9G+JVEacrkmVgD9Wg9gMUbhTli1qgrmkmewAGVoQRHWdtFnQdQf4OfjXPi77NyqAB2xcroaB8r0Wk4YNLUKcJpmB1Ndv8LFe1g1l9C44NZxM7CUoSS02odgiOza40Xfd92pWdLKkGUMzHQdIKxX6esxJGAs3cq6RivWgcJ/AwLx0vt3FTtwLY2qROeu2w+FTN7GRvZ/x5qSlwTJZ2f+AVWldiqUFm9ak/1EpD7WLQQVLy3NDn1NZUMi+2C754hze4n0mmcPlR+xNDrydb+QncF9SBLPYn3Pe9cpCxwmi69oCB69vmzNrepRYYX1Njxykktr+/qRzeHlA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS0PR12MB8318.namprd12.prod.outlook.com
 (2603:10b6:8:f6::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Sat, 17 Oct
 2026 20:55:58 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0522.017; Sat, 17 Oct 2026
 20:55:58 +0000
Date: Sat, 17 Oct 2026 17:55:57 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Dionna Glaze <drdeeglaze@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
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
Message-ID: <20261017205557.GN13920@nvidia.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261016234354.GA664420@nvidia.com>
 <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
 <atPHHNVJ2w0bkJIC@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atPHHNVJ2w0bkJIC@kernel.org>
X-ClientProxiedBy: YT4P288CA0049.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::6) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS0PR12MB8318:EE_
X-MS-Office365-Filtering-Correlation-Id: da0fdac0-7ec4-40ae-ddb9-08df2c910b39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|7416014|1800799024|23010399003|366016|376014|4143699003|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 CsrdRVUiFxeWxDxi/GewiAPTt58eqHuPNAeKyYDRUiVZHUSAPRjo7ksCe7dgVCrr5i1QXzG9Ysd+TZE7m5vIjarTHR0fSNVkFnutaLUJr45TbeROK55ySdRKlsP+nbTSHTZRy39IvnG1RJRZVNJiPlJcw4eHJyrx/HrUXlOmneJaIYaed59/+v2Esg+CTakUaKJ1IZTwe/O/8ZQXhKZVlfIEfAVYXcglvzkMRa/JLt/eJVJfHEqGRtp60sbs1cHSKXZVgKZumQfcc7R+RaD993Lw95S+6M31at+8/MgZyXKXWBTA5FEphtAQjhQGN7N9N8xdGiVJXL43A2JAb6n6XY3lvIqUBytf0nXyJEzb5wGhYeobj9dnBQg/Agtx3PyWk/kXRi/TnsSPHKTM7QoVd1+igSk+rG/fgIDvh/l4XCmlYpnwtrvcMdmXXJfLnmZp5jUfzq8NjK+97wECTSKh1KV8GMasNZXrSnjbgNFqhXozJuMFuIdzHNr90sVI2DgOjgnS2kuVjCcR8AOu4jYowr2bOrQA4WaqasbV0rVNl9oqAjFZo/k/+M0hUOlOAW2Zzzl44hg0KE8XEaKkg+ZOZ6G/oxtnAYtx06Lsj8wD7jj/lpY/RU4wVbN57jDkhQ4e1sqztuA+gAQpAhQ48SI0b+3Sx56iQxWuEZyiNWwf0CI=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(23010399003)(366016)(376014)(4143699003)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?t68Cu5GgXjWdbvw03SEw9f1a9kzapp2NLNk4TPnDHN7dzeyhJIgCE2/k29ZI?=
 =?us-ascii?Q?KnNFCM4PkJfSchwgUdXAwprd64leMtGLD9TwJb+Xdl4iV0wd6GuZVjYREl9m?=
 =?us-ascii?Q?xf7XOnUe36fojAkH+U653SyPoNn/XKJ2tJhQDDqnTYyN2MRn9Gg9Gd2D9wyT?=
 =?us-ascii?Q?7dOKIQZ5YZpjoQyQCOfu1uOmbfJDqE3fj44Zau17NSMVgtajUpFcolYUjkk5?=
 =?us-ascii?Q?IUAXF5FthjG6W1iwWCjT6dKs605LcIt6e7vN4mxauukrCOD3WU6kGKkpest1?=
 =?us-ascii?Q?luCDhYd+2ba7qLKhMMHKka/PAtcCU/9fsj7Ty6XwtDEuPn51L9881PxIV7Tz?=
 =?us-ascii?Q?PDwAjx01ImhsxweL2R2dG3eQjzblPtUA2w++AFJMhSIhEGRtjY7bhHmPVvcp?=
 =?us-ascii?Q?HEKn+hCk/vIxOg54JO3VXEAHPZ5Nu8YwAy1e78RujpvtH3wEJpbfyHoSa6Rx?=
 =?us-ascii?Q?pij4m3PqJbRGNshcOKcZKjUOOnvFDViP0clzNPhwXCAhNsXYO882UeOisY0R?=
 =?us-ascii?Q?BLtP0jaBNJUntq0Xz9WuYyTWl+yLEypgNnNPlYCPP3wAynk9NenwTIwSTsut?=
 =?us-ascii?Q?auH06C+74q5kpTLOhgbtF4qQex9ysTii+tz/FmJyT7K1Vwyp0+JktqvE8IZ0?=
 =?us-ascii?Q?NAc5UrpmRe4A+9lUE94E0E2VKEWvAnCeEsTsL+0VN6FfM5Au9xe/dkKHo463?=
 =?us-ascii?Q?A/YLbFcKgbI78aVbNbwBmDQWPDKbiAOAT9QwI+bViU6OglOANYhzqOuSntg6?=
 =?us-ascii?Q?TB59XkQ5IQtostTRkBGdIRLbXCV2YrBMhTybaaaMFyxdkE0NKVYcV+9pIajv?=
 =?us-ascii?Q?Ox7mcl8BDZPkspM2qbAAiWHmsZUp25TjPzlptGiFNVLB5BZ0Qzq4qi/USJV9?=
 =?us-ascii?Q?Nqr2u8BzTaeORWqcAos7T6xFd30X5ullNIvGiGeKOZSyL86phlN9UfvN2xAO?=
 =?us-ascii?Q?20si3zmDt7CPUu3wRa2x1tXEKb+BPNgF+DeJIIS8zsXw5KQjWQ839TcquKVQ?=
 =?us-ascii?Q?JEXgR2WyyloNzvd/SvFVJ8HOaTK3AzBYVh9BrM9QEB08hy2GFAS78apVflSS?=
 =?us-ascii?Q?fSfSBOVnK0/LpsBa14mcfztK6XoLn4FePMa/5C0M1wuwlhRfDKoWq1kCOE/2?=
 =?us-ascii?Q?+zUGIjoZx+PQLB7bukYvU2yh7xpBHQnIcIS6uAlorMEfQ8cHhAog/6ECVdbV?=
 =?us-ascii?Q?tzlMVIn63p7n9oPEamZ+XkQi17EDB7t+qATj75OxifKtKHBNIEZFpRovgpPl?=
 =?us-ascii?Q?AIHSfkH/exCOJwpnlnoYG3CJOlQyah+ssXEd0/MlthMFqum0pBUVGNlF47FA?=
 =?us-ascii?Q?s4SYh7OUCGCvqvHDKooo2wUF6u0kVD4sqXVn1IX1rM0Rnn0m3vDajqFam0+j?=
 =?us-ascii?Q?/NvQs4IK6sh6G7fAG777PdRATxGcHLp0ITZW/EOaHESUqnP81lucAf6Ijhxb?=
 =?us-ascii?Q?LWUIkTCouW16NXLfnQXZoDA51ITkcflavbnCmr+spA/tvcIXFq/cM7YDxZDk?=
 =?us-ascii?Q?mUQVD/9Kduv0BP0hkLKAAFC/qtXDwvCKIcuURrdNeoLdAIDW82QsN43ErHzJ?=
 =?us-ascii?Q?J7TUs3kx50H+iFxreh8LRv1HXu4lD3p29U3cSPFmNaxBS0wZrsAn5YuaIWkc?=
 =?us-ascii?Q?cNEyLkiN6MtSDHhBYc29zuQB9LkZ9+JW48lpQON4okZo5HFODlNhkuZZoMne?=
 =?us-ascii?Q?fs/Y8HM7HW2TqOtF9HZs0wu7NCPola3yE6BJVPVi1tRnxIWI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da0fdac0-7ec4-40ae-ddb9-08df2c910b39
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2026 20:55:58.0978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bDspOVmu8mKIPzpehbkSCmZG54ozFJOyOIB8i0bjNWa5BObanA9BpP/XcfGifYQG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8318

On Sat, Oct 17, 2026 at 10:06:04PM +0300, Jarkko Sakkinen wrote:
> On Sat, Oct 17, 2026 at 11:16:07AM -0700, Dionna Glaze wrote:
> > +Jarkko
> > The TPM driver is pretty entrenched and heavily used by different user
> > space applications, so it seems really ambitious to bundle in TPM
> > here.
> 
> This is something on the table thanks to Trenchboot and its early boot
> code.

I've proposed that there be no early TPM in the Linux DRTM
implementation. The trampoline would just do a bit of additional work
with its existing TPM code before it reaches Linux.

https://lore.kernel.org/all/20261016165135.GA494690@nvidia.com/

My intention with attestation subsystem: tpm and DRTM is to follow the
ARM design and get ACPI up enough to reach a HW driver. Attestation
subsystem will multiplex the DRTM "PCR" logging to which ever ROT that
DRTM launch selected. This is another reason why I dont like early TPM
because it turns from just early TPM, already hard, into
early-every-ROT which is much worse.

I view all the stuff you are listing to make tpm early work as too
difficult compared to just having the trampoline do it since it
already must have a TPM extend operation inside it.

Jason
