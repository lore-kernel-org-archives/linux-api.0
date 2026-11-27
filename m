Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.61
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795739156;
	b=1o3vrn5hoUKYWd57ReRZj70VucbAQctW/oHlSDKyJOoXKuKrEaZgQDunmUqYnXwNbqjP
	 1UwbhHJAmKW8fBTHh4n/IoJPGZ7tnq3IDOAeTVVpxG4LGywGWKGHtIA6rA738M24QkmNH
	 ov+82PXgleTto4Tk5Zccti3R/2gGmFznS+//xr3flT8cAhaASkxNGoT8mYv63zKU1cch6
	 PFK1VXGY27cfGCY9svTGzw/9Ax1P3qRq7345zbN+9aaBiYgoKgImDLvi10mtMQYB4uyi2
	 9s48o7BZM8Mcf+sYUSE4FXnpCCQiJLGYpE7VTBM7MmyHYq7+m185rYqWeGijUHnmFtg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795739156;
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
	bh=VtM1CSgUxSOwl2mdXWciw7PPLYg6z++PnchWXsbh/FU=;
	b=1s0zzLNEww/Z/QLBH9srAszFI7wcBQhIe2EMAGfYbRql3iI3Bet7eaD7EvVC+2vT5tEl
	 6HPcMEDwDA91xWRSU304PzryAxjZy6TuJ3DMKG1Q3PmwMrNleZ43SgxrL3GFEmEVoUpBj
	 xBzB09kwMGboLFeo85QO1oiIKpOLn0WDq4fJAF8HNga5iHDNCiflxB9bNptHrvlxoTqmN
	 PBMCNGtLinztgWLw7ylQ9MzM7tzivojmvP+IPbnMggf5OOtfIioGY3tNvPyJ84Gb5L3Qv
	 llyjwlQbip7e+Wv8bqib4aL1HWmAYDmJLd0DtCR7a7+kjnK2jYi4+1Wu/NdxZyLPV0w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ihK1y3nr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.61
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013061.outbound.protection.outlook.com [40.107.201.61])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17C6606A329;
	Fri, 27 Nov 2026 00:25:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C17C6606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ihK1y3nr
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EvTNcZLIFH5xnF1cS7O7ZIkzrST8TEsjLt99aB6LSri4KP37+1Iw2Xsj1OtNGRR7GI6mOTXajpgHgA1x9Rk4aYLXHrLXRiCbVMS0SwIawhoUG8nJH3yUm9vZFuo40xjs4iWXJ+9xUE904QHMIh4AKLe5r8RiOFCvORafkPbaFpiBnweg7zC3aUf5ffUOto2ZkbiJdDQPPHKKNf/DBeJNGZ8kFcPip6XoEStvPf0uEwRZXsukGoi8eA3rX14J6wSszqsAT4MVaY5QjG0wH27SDgNPTDSOueBSG19XvF+6xQKkZtTf8VIj0nHwYP+7jmalCiVfsjhKrrz0QB1L/dNF6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VtM1CSgUxSOwl2mdXWciw7PPLYg6z++PnchWXsbh/FU=;
 b=ZqtHs51hyGnvwJqHIL2ir2i9jGCQWeEGhXZxMUQUzI+SB4JKICNWHaiK+40BKR9nSsY4+Scul+RtdwnjT/yhlb8Vl/r/bX1X7UILz0QfBYyAdEDxPGllDcJglh3o1DVMv1Fv5c4b+alkX9SYBgE+X1OEw1d2QEsHE6MKacXz5HZH3fvByCplaKPXNiuyu2W0OccKqlcT1pfNXvUyjc1IV3iXLl/rWeEy3YbsW9MBVKd31wsiLVW/vtTIaE0dtt3BW2rvn4q5jkWFboTUvwkQ02LocwfRe99e2WySCrmRxi/G/hGvgc6f5GTNsZLi96Qjcocvdbsj0h/OZpnmL0Lbeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VtM1CSgUxSOwl2mdXWciw7PPLYg6z++PnchWXsbh/FU=;
 b=ihK1y3nrp6p+ZrUVb6DUEAP9cipfDBmNLKsZq8NBRyhayzqfd+YOr7mC/lR5aVyDom5unI/Der+qaOx3oO6Obdi83hvnSh+NaLJ6MGgdbN6RD7aK9n7+xv/v9rsRxcBtPvSP112LXJMoH8LC6DI67Zv0ibDGUgQtTP9u5wkTwAuv7uSnyJnBihVSU27S6vO9E/fKGdPOS06wLj5PzU2axiJleyMuib7Xm2n0IPBszDHjK9SKvgv7+Vxl3P4PoDPIbPdMYoOIpmi4Jwmn0BCBYb9tDc14j0BEdWp/JSTjB77Oxs/coxPuYHUOE8taIANEIHNwMI10biDeT/YMSodPNA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM4PR12MB6326.namprd12.prod.outlook.com
 (2603:10b6:8:a3::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.9; Fri, 27 Nov
 2026 00:25:43 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 00:25:43 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH RFC v2 3/9] attestation: Prepare provider and instance
 core
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
 peter.fang@intel.com, jarkko@kernel.org, zohar@linux.ibm.com, 
 yeoreum.yun@arm.com, aneesh.kumar@kernel.org, dave.jiang@intel.com, 
 nik.borisov@suse.com, sergii.dmytruk@3mdeb.com, 
 Jason Gunthorpe <jgg@nvidia.com>
In-Reply-To: <20261113160838.2512652-4-jiri@resnulli.us>
References: <20261113160838.2512652-1-jiri@resnulli.us>
 <20261113160838.2512652-4-jiri@resnulli.us>
Date: Thu, 26 Nov 2026 20:25:39 -0400
Message-Id: <179573913907.519186.16798649738277789303.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: YT4PR01CA0208.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::18) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DM4PR12MB6326:EE_
X-MS-Office365-Filtering-Correlation-Id: 639311f2-0a88-40b5-6907-08df4c1cf873
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|11063799006|4143699003|6133799003|261009223027099003|18002099003|22082099003|3023799007|10067099003|56012099006|261102123227099003|261028144727099003|261022105027099003|261022075727099003|261026121527099003|261026140227099003|261022115727099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	AqJDuAhTrqzTFwxP+X7aRP7Fu2v4htVlyyyMMojqmVbdQkTnKYnYT4WI/SRUr28Ea56zxVA2is2Lbgb/CpyqRwAn0VrKa+MtbYoze3tDNeYpbSxlupfC/mrQ63UcHqBj+O6xLiXbkV2H9nlxurF8Qp3TVrcDoJE60EvnZ/tq4aj8AZmF9ZJB3itvkfMwIDWqPOzFWSyxk3W7oRkzUlibhm3kAWMfqu3+7+zivJRH5Po0wOhQpCR+bO3kgwJyN7KvKzVCx+ATUGr89ylXEeBOxseWVkR0BpvglahChahzIHjrsFH97MTy6wqQ6eKO2xuK/RtHtqH5msOgy90O3TKbaX61O+GJPquhMyslrErbv/RT+66fEvhqQz/u8ATkpCpsjtaTYzzbpwbz6hcrk7Ok6e1Bv2peXob/RwZdwmFnVkqtcglFpNpkhnIqJtr8rDBjp+m9JkvBOOPaYkmdYkdC84mNtOLcdsrAdmDEbaqremU7RIHvkCGcooQb9JsAy32z/Nv3VG1HjHVO1X5rwj1JPuG5hcuPY2c6LJ3PUU8tABbDfDYgQg/YvadI7nv3N4vt2uFzB+G+Q63x2XhxorU+Y+Ha+J7oVbMQB6ohdnxNQqlotEOMagaT9+ol7/z9Kg/xLRkPNyBkLqbYHiQYc7OGkqE5YSdsUhr1fFGRPrztLfI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(11063799006)(4143699003)(6133799003)(261009223027099003)(18002099003)(22082099003)(3023799007)(10067099003)(56012099006)(261102123227099003)(261028144727099003)(261022105027099003)(261022075727099003)(261026121527099003)(261026140227099003)(261022115727099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OUJHVGtiQ0J6dENMMUxXUjBmUG40RlJMYTZDT0F1TE5JbU9xMG5MWCtyUFhs?=
 =?utf-8?B?MXRDWmkzZmRxb3VWQmd0NEJWVTluVnl0bnAwRWI3REg0MldsWmc5emxwN3JU?=
 =?utf-8?B?ZHNMelluS0FEcXVzTnJXQ2l1VzZTUEZFaVdablFNdjh0dDVHeFRvd2UzVE5N?=
 =?utf-8?B?WU10MytLenhiZDhzSEdWMDMwNkNmTnRhZnRoRncrbG9jejkrNHlnUytGUHl6?=
 =?utf-8?B?Ujh3ZGZ1enVGbGs5SUhxcy9uNk1CeG5QMWlKNU00ZVY5L1l3a0RQU3ZFM2dI?=
 =?utf-8?B?YTZQVi85MkZ3VGZFUmtZcEM2cHkzY1RJVVh0bk90ZGFFNzdzQTBna2lJYVdL?=
 =?utf-8?B?YitOWUY5dklwMGI2K01LTVgyMGZSQVpOVExDV0twcFdjZUFBQ1VqWGJ5WWdZ?=
 =?utf-8?B?bmFWQ0FGMzRiWWRZVlY2OHBvQWR1ZWlzVjlmNkQydkZCUS96M01JMWtYZ0Mz?=
 =?utf-8?B?MUpDTjk2cm1pS3UyMCtDSlRBVDBOckpQdWVIU3BkYkFad04zSWo5RXhtZ0xt?=
 =?utf-8?B?OGhnR0MrZGJCd21rc3pmaWJvNEx3MUVFWExGUnVxYjY3SnpzL0tDRklDN1Bn?=
 =?utf-8?B?eHljbklZOEwvc01PSnJxUmp1RFNUUU1VTU5raXJ0VDd3dCsyVTBJdFEzcEU5?=
 =?utf-8?B?SGNhSHZ4S1JocHFqWmovSVoySnRJRTFtcUtLNUJ6a1grYmRMTndYYnBaT0tB?=
 =?utf-8?B?SXVRa2FiSWNNSTlUUmVpamRrZjAxd1BvV2pyTnpzOEZhOTYvcWF0c2lYOUNB?=
 =?utf-8?B?bzR0aThFVkZpeWQzOVRvay9Xbzl5VGZyZVlQM3poRHZMbGYxVkNmM3krVU16?=
 =?utf-8?B?UHVrOWlKUmVSeVlhZzJFdGJsdDhsQkxjWGZIVkY4cUllWEVXRmNIY0xCQTVG?=
 =?utf-8?B?bEN2bk5ObzYveXNRc2d3ZFQvYklOMzJsejhmRjE2ZUVUMSsvOXNudTBwYWpK?=
 =?utf-8?B?UXdROVEwSFE4NjQzOVNreHdyQStoS0FjRTlRNWxDUU5yWXE1c0pRSFRhaFh1?=
 =?utf-8?B?WnM1ZVRyQ1UvaXhxNHUyaXl0T2d5S2g4SGZITytKQytSYXliK0tPSU96Yk5s?=
 =?utf-8?B?L05kcUl3TFU2bk9KVGZ6STk3Tm84M1puY3Y2Y0xXWmRtelhtK2p1TmFPbW5C?=
 =?utf-8?B?SmpuRDIzWXFjcituSVRNV3l5VWY5MGs2NXpGTnVVV2dNK1hoVFZJZEtzUFY0?=
 =?utf-8?B?RkdCSHo5b0RXVjM1c2k5R21weGsra1l4bElxUS9SdldtUU12MW9TMWRJNEJx?=
 =?utf-8?B?MmR3KzBwYzh1Q2ZRZVBXUWhFQzlrUStRRFA5SDl2U1ZJSDlKajhuZVp0Nmw2?=
 =?utf-8?B?eHR2OGhzczFqT3ZTdThiRmlpZTFvTGlVSVdvTEdqNUljNjg5Q3kxWVdlemEz?=
 =?utf-8?B?QVpjWkRPdi9EUnJkK0xIUzRzSU9heWlXOHQwZ2w3N1RXUk9PRWQyWDlBQVFa?=
 =?utf-8?B?REdnZzZPT1ZwTW5SVHNPS1hhV1dZeEdNdEErTkxTcFZxM0VreS9GQU5QZmZk?=
 =?utf-8?B?OUdpMTFVSWYxaDNha2RFQnFEampGRWRMdFhRTUN5SnhPQ0tKYUlxSWF2THBx?=
 =?utf-8?B?djM5RlhkTjlXL1BrU21MSEs0QWZKOVJRMmtTR08zb2luZXZURDRINWdqaTdw?=
 =?utf-8?B?T21uMFBkamtMTXhwTW9NMWNZUTk2ejRQbGx4eE82VzFwa0IzcE43S212dnlY?=
 =?utf-8?B?YXFwTHlyV2xhTHBzaWR0Qy9qZEhUR3lrVTFFaytqNExkaHpZVG81eU9XbmVR?=
 =?utf-8?B?cTFXdVdkWGtkTzVYeXhrTHV3RFZjSUpaaXFDczNTdmpySURKTFd6NkNGSDE5?=
 =?utf-8?B?Q1AyOWVOQUszWnNpajNoV3lnbjZMUG03OEJxN1J4T0QxTllYZDlOT3BKM204?=
 =?utf-8?B?TnRmMUFuendMcUQzTzF5Sm9WSkh1cXA4a2R0NUZ2dkhxN3FqRU4wTnMva2dD?=
 =?utf-8?B?Qm9RQUFLSDNkNDlzLzh4R1dGUThmQXdSNzZLN2pGVDl1OTNCMDRSMFlzWTlu?=
 =?utf-8?B?a1lRaTAxL3RBaXcxeWFjWGhFTDVnMVlUdk9iTXpUa1FReFR0RmxmRnJ0THZk?=
 =?utf-8?B?YlFGNm9JcU9RU2VJN2dOODNja2dDdFNjTkVaUUlSUitYWXR3QysvZ1JxNWZv?=
 =?utf-8?B?eUNoY3FPRTlZbnpVeGd6VHQ1ZnpDSlFzakxUcjFvYmtNWUxzWENIRmU4VXdx?=
 =?utf-8?B?Vk81K3Ardy9VMmFZeHBHelNGczZnNzNRcWFZTlN1U0FETTVmT0NWNTJ0NHNu?=
 =?utf-8?B?MkJqTys1ZkVPZDBsMkp0MEpHM24reWlyTDRBUWJQbGFpa3VNajE0a0FPb0tw?=
 =?utf-8?Q?ls7B4xD/oui8X1jmeP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 639311f2-0a88-40b5-6907-08df4c1cf873
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 00:25:42.9409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dADP0CsuLCe15LvfD7dTbgeeKvSuUWZjoLFewOPnRUSe3HBjaYoaSO072aGgofFq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6326

> Add provider validation, instance registration and lifecycle management
> for the attestation family. Each instance is a device of the attestation
> class, with a node under /dev/attestation/, and embeds its CTLV
> instance and node.
> 
> The provider descriptor is one immutable evidence and MR contract; MR
> state follows in the next patch. The core object can be compile-checked
> here. CONFIG_ATTESTATION remains unwired until the CTLV handlers land.
> 
> Assisted-by: Cursor: GPT-5.6 Sol
> Assisted-by: Cursor: Claude Opus 5.5
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
> RFC->RFCv2:
> - gave attestation its own device, class and /dev/attestation/ nodes,
>   each a struct ctlv_device
> - dropped the goto from attestation_registry_insert()
> - noted that instance indexes are never reused
> - selected CRYPTO_HASH_INFO
> - selected CTLV instead of depending on it
> - kept each guard() on one line
> - dropped the journal from the Kconfig help
> - dropped read(), poll() and the event teardown
> - refused hash algorithms the hash-algo enum does not list
> - gave each evidence object a class and the formats it may have
> - dropped max_total_output_length
> - took each signed object's challenge lengths as a list, ascending
>   and disjoint
> - left the object count and challenge length limits to CTLV
> - added attestation_evidence_write(), for blobs of any length
> - let a request omit the challenge
> - separated the steps of the longer functions
> - took an MR's algorithms in any order, each once
> - let mr_extend get the digests of some of an MR's banks
> - required mr_read of a provider with MRs, as every MR can be read
> - said that an MR's extend cap is fixed
> - took the UAPI headers from include/uapi/ctlv/
> - named evidence objects by ID, and had the provider give each
>   result's format
> ---
>  MAINTAINERS                         |   1 +
>  drivers/attestation/Kconfig         |  12 +
>  drivers/attestation/Makefile        |   4 +
>  drivers/attestation/core/core.c     | 429 ++++++++++++++++++++++++++++
>  drivers/attestation/core/internal.h |  21 ++

Traditionally subsystems put their core code in the top dir and
drivers in sub dirs, or loose in the main dir too. The really big big
subsystems use a subdir for core.

I think in this case we should skip the core/ subdir. Linus has also
complained about the directory name stuttering like core/core.c in the
past.

> [ ... 78 lines skipped ... ]
> +/* A reply carries only what hash-algo in ctlv-attestation.yaml lists. */
> +static bool attestation_algorithm_valid(enum hash_algo algorithm)
> +{
> +	return algorithm >= 0 && algorithm <= HASH_ALGO_SHA3_512 && hash_digest_size[algorithm] &&
> +	       hash_digest_size[algorithm] <= HASH_MAX_DIGESTSIZE;

<= HASH_ALGO_SHA3_512 should be < ARRAY_SIZE(hash_digest_size) ?

> +}
> +
> +static int attestation_mr_props_validate(const struct attestation_provider *provider,
> +					 const struct attestation_mr_props *props)
> +{
> +	DECLARE_BITMAP(seen, HASH_ALGO__LAST) = {};
> +	size_t index;
> +
> +	if (!props || !props->name || !*props->name || strlen(props->name) > 128 ||
> +	    !props->algorithms || !props->algorithms_count || props->algorithms_count > 23)
> +		return -EINVAL;

The magic numbers should come from someplace..

> +	for (index = 0; index < props->algorithms_count; index++) {
> +		enum hash_algo algorithm = props->algorithms[index];
> +
> +		if (!attestation_algorithm_valid(algorithm) ||
> +		    __test_and_set_bit(algorithm, seen))
> +			return -EINVAL;
> +	}
> +	if (props->extendable && !provider->mr_extend)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +/* What device-get and evidence-get carry, as ctlv-attestation.yaml bounds it. */
> +#define ATTESTATION_EVIDENCE_OBJECTS_MAX 16
> +#define ATTESTATION_EVIDENCE_FORMATS_MAX 4
> +#define ATTESTATION_CHALLENGE_LENGTHS_MAX 8
> +#define ATTESTATION_CHALLENGE_MAX 4096

> +/* Moves with each value appended to evidence-format. */
> +#define ATTESTATION_EVIDENCE_FORMAT_LAST CTLV_ATTESTATION_EVIDENCE_FORMAT_CCEL

Should the general schema processor be checking these? Seems odd they
are just open coded here when it has the information..

> [ ... 110 lines skipped ... ]
> +static int attestation_registry_insert(struct attestation_dev *att)
> +{
> +	unsigned long index;
> +	void *old;
> +	int ret;
> +
> +	guard(mutex)(&attestation_registry_lock);
> +	if (attestation_next_index > UINT_MAX)
> +		return -ENOSPC;
> +	index = attestation_next_index;
> +	ret = xa_reserve(&attestation_instances, index, GFP_KERNEL);

This is usually written as xa_alloc_cyclic()

> +	if (ret)
> +		return ret;
> +
> +	xa_lock(&attestation_instances);
> +	if (attestation_parent_exists(att->node.dev.parent)) {

Why? What's the issue if a device wants a bunch of attestation end points?

> [ ... 19 lines skipped ... ]
> +bool attestation_registered(struct attestation_dev *att)
> +{
> +	bool registered;
> +
> +	lockdep_assert_held(&att->lock);
> +	xa_lock(&attestation_instances);
> +	registered = xa_get_mark(&attestation_instances, att->index, ATTESTATION_REGISTERED);
> +	xa_unlock(&attestation_instances);

No need for the spinlock here

> [ ... 50 lines skipped ... ]
> +static int attestation_op_pre(struct ctlv *ctlv, struct ctlv_op_ctx *ctx)
> +{
> +	struct attestation_dev *att = attestation_from_ctlv(ctlv);
> +
> +	mutex_lock(&att->lock);
> +	if (!attestation_registered(att)) {
> +		mutex_unlock(&att->lock);
> +		return -ENODEV;
> +	}

I'm struggling to figure out why there is an xa mark, it doesn't seem
needed by anything?

The revoke flow is already handled by the common code with:

	scoped_guard(rwsem_read, &ctlv->registration_lock) {
		if (!ctlv->registered || !ctlv->family)
			return -ENODEV;
		ret = ctlv_op_exec(cfile, &exec, snapshot, &reply, &reply_len);
	}

Why does it need two layers of the same thing?

In fact, why does the xarray exist at all? Its only purpose is to
de-duplicate the parent, which seems pointless and not something a
subsystem should do. Seems like it can be removed. It is confusing
that the xarray gives an id but then the ctlv has an idr which then
gives a different id.

> [ ... 146 lines skipped ... ]
> +static void __exit attestation_module_exit(void)
> +{
> +	WARN_ON_ONCE(!xa_empty(&attestation_instances));
> +	xa_destroy(&attestation_instances);
> +	ctlv_device_class_unregister(&attestation_class);
> +}
> +
> +module_init(attestation_module_init);
> +module_exit(attestation_module_exit);

subsys_init

-- 
Jason
