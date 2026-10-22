Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.36
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792696888;
	b=v4GB322FchHK6aQVkQK6aee3+/pT6xKqRp6qMHesmTEdlE1mbpwax7rZNPDqOF0FwZKA
	 Ftt4u070BCc3plMnN0PFcRyRZrAoqhP2751LEoK/GkNNPgygc/lrSvprxGINA++RHV1HL
	 hhdCNqYE9GBMU+stsOm0Kj3zNTCrV9UUbs/8hdhrT0dMNkrPRyTuBzaXPNcZNSpJtDuKD
	 br1YUOsLwYjVdHCCxOr5Rtcai0ioSreWQf9PjHuDd3KK2ybk41p+hAdtrkSFVoR6ZkCuN
	 vAmlGrovrwtC8NvNVBkedbl9ZqpnuF10Sooiwn4FsiyGaWaDwmyCrvIJwjpkhKN520A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792696888;
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
	bh=EIKAsxWNpoMKa9iMHtAAao5QueWmuVQJqQdCGRMIe7U=;
	b=G9WEB64yKTwdBZwd+uXo1pIGfRwUiPQAytUVzRXdonWvxdN1nMkPkfV6ZxhjBCyKd/oA
	 zOQQ0VmemYoYDVOcQu7I6B8mxkHJbxNitW8pijKkczXBzaxP/6TFZ2gBgBfmCZPZ2rV9R
	 k9A8s3bZ3sw6rLhc7xZauVrPircLZykcYy+R+Rdw3qM+hxI0TdDspLCZcAeEwCp2yK/f+
	 99wA0YqboZ0aJQb3reKY3dbPCUXViY2dSwPRAnvep0FC5ZhhnKlxS2xLyW5U9frzulja0
	 GgT9UF66Z5GxN+CjL7a92tuTcFADtYf/tGO8Rvspa34umAxypncO4pw5Nm3Tq1/KTOw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=TPBeNRzQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.36
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011036.outbound.protection.outlook.com [40.107.208.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B134A606A31A;
	Thu, 22 Oct 2026 19:21:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B134A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=TPBeNRzQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FoVNQvh4wcJIP1L2p69MZMYb5NVRstosXgN/s9mVewAX/v71y/xgZO45bp8Ae7zAelwxhckAqPY/k+lc34Faf17DL5gFaDzQOATxXvkmFuagGI3K1/cOjYvMJ+r5Q2X4vnjvoMx2Ub09mCgRapzeHIBRPXCeI2o1JybnBnpl9G1HJrS9iU9Uq84rC2oNb6YnZaZfxYreY3p4HhrrPSdZjhzCjlcsHCHWESrjZkR+cIHNojTiTPVMFYdF5f3GaugBw5OdGLr5nOF9mmF7ahdwc0yKbc93bCzrhdykNaxIhtf99KyfYVw7Ah5DBWCAycI5bDblcEfLiWtu0nTJL4sjKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EIKAsxWNpoMKa9iMHtAAao5QueWmuVQJqQdCGRMIe7U=;
 b=cjHrH3NFno+Wrf3PAL1CoGnLKimFR/Y103tgzmOJ4qn/h1mLG+2p3PoQV/GxPojPOsvQQGWIMiiOHmnWuv8buS53duV3iXSnz0GY3iTE74Vn82GsD+ymzONYs+4eddKQBzlO6fm4G6TKg+P2p/MpxY1D+2ybIJUe1krBqFO1Kaj7GlRB77GcTvK7/T2iPape0itBV+Xal/5I2nKLiVxWllKNf+UaaIRnTwP1auItGIOUlxLWxDoTCQ3qJgmc+nV9trpFJrSGvyzy2Yfjs6zmBHVcrX3/j2DcttBoN+ls5v8BbuSA9Nj8+VMn1vTW1+gt1dTWeaiE4XnUtJPhC0wDXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EIKAsxWNpoMKa9iMHtAAao5QueWmuVQJqQdCGRMIe7U=;
 b=TPBeNRzQcIIvHLFpcbazMiwgoCdNquk1chDS4u1ztmvRsD1UuqzIy2/E4BT4uHsMiNmHcQqtUBfUSvokqLvLvclZZIK+Ql7D/TXnMo9ZgylChD1/Zh4vJrxwijRWxCJYU3LyRXOSyg0NMZHtiYmyBUiiIyuG+rfTu5Ylylg5P1+JQL+DAoMAwLyguMxNxCDstyoT4nsCCsm8tsrTQdEGhcOzgc4aTTpS5c2EnhSH27vRboM1s2t7CYiCOSOJjVzMXiYhY/7DEANevYZD5B4PvQRWjPuk8XIm725mNvP7lurmHIOqSjh/AUq1dVvRhtuXxcxCAeddPxPsfTwO13zmeQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB9468.namprd12.prod.outlook.com
 (2603:10b6:208:596::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Thu, 22 Oct
 2026 19:21:21 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.016; Thu, 22 Oct 2026
 19:21:20 +0000
Date: Thu, 22 Oct 2026 16:21:18 -0300
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
Message-ID: <20261022192118.GC3746973@nvidia.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-14-jiri@resnulli.us>
 <179245258505.58760.3972297562218204862.b4-review@b4>
 <atjEgLYpgbZNzfkZ@FV6GYCPJ69>
 <20261021144951.GR3008132@nvidia.com>
 <atjiW8bnqDZ8zb5t@FV6GYCPJ69>
 <20261021164857.GT3008132@nvidia.com>
 <atnGniIHxIV-vzVC@FV6GYCPJ69>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atnGniIHxIV-vzVC@FV6GYCPJ69>
X-ClientProxiedBy: YT4PR01CA0156.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ac::10) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA1PR12MB9468:EE_
X-MS-Office365-Filtering-Correlation-Id: d8817f70-210c-4f78-780c-08df3071a6db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|261021121427099003|56012099006|10067099003|261021123027099003|4143699003|11063799006|6133799003|18002099003|22082099003|261022105027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	Ak69W0f9WbkHLmmQtMqo21x5T6mYMAwR1KY481W3kOuru3i1Y3nrT+IyY7Qii10qgue52YxSBg4YPXEcNLvpJPOvQzD68SA89ywjZwJ7htj4BADi7LCVO3zto4gZkiUB+4aqQD6WovD+Zh/+t4FVfZ8/FtfYLyPGuc5BNN34CqpQnI0ZrrU8RzaVI7tmLWeY8x2uKTiY262rHjoUkWY8YSPuxvam2Gw0WkZTyN/ziv/3mYhXxDKW7NdFHd1hLxnQuSzhKr4Cpktcb6Zvh5d5MjyaMUJBaC/TTS1yKEJZ87limWTNkdvUna56l8h1kV0G8DtVHYT2lI4Ajoi7otui7XSj/L3zjXK6u6SQ4mcq1ZNJjUnK2NnY7pqEq18Udam+O3O71iLz7PoQC18cA7aGmEbDHRhSZU8wb5X6M72vLYHVHnHCrfbe5Cpc8qygT6rTaYRYrjQ1VKUVTiVEGdSnhSOHXnhtl3wL2/clRSOLIuXxwwTvti/c/hYhIfQ4mBHgtiSXNHUYaBFVuzLtd9G1jMIKb284fJEJC8iteu7n+om0eFlVuVi0VVhj0LvtqyT1W068gZPX41CqWsJgYURT9feUYbpn82/TaTCxFrdNNbbKMm+37Fsx8v8PRIaJqyKs/7WB+on8xOjTSywtJOh2lV1wp+9yPYCfY/Ajc31JTeo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(261021121427099003)(56012099006)(10067099003)(261021123027099003)(4143699003)(11063799006)(6133799003)(18002099003)(22082099003)(261022105027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QiYOMshpkpEuEFgzmE1bwDKUb7KSYnhfr2aK9lFRNhhe3p1LWz6jblJjfN51?=
 =?us-ascii?Q?ndUP8As6UI9tn/3jXb9+DCOVElXIeYkmDchvd1pzCGzGoUYDWfa46ZlYuGwx?=
 =?us-ascii?Q?pcqYHschdLlFem6apqhSYB2MNM5UMkWiYsLm2oCJio0yyIxtKeOYDU0JGM+2?=
 =?us-ascii?Q?31W4z608zyS9hY6H5cGO6/OH2LfIdoc0LkJUmxlYmONr1qK47Nq4icWO0q9C?=
 =?us-ascii?Q?5gvik6jr/wuzkEf/Md7igrvpsSRBk4k9nVdGQ+9M9NCXZnWm6pd2EEZa6aDb?=
 =?us-ascii?Q?TyCWCbqEVSyeYcxI6uAJfwxZJgbY6Y1JVGSsoEGpm4BoFkxliaHE2tFDPyks?=
 =?us-ascii?Q?jccoFtGBF0tEJBdvDuBsU5H7sRZcIHZ3V84Slhkx6Y7ZJgM6PSXd0e6jKMrq?=
 =?us-ascii?Q?6EecmQWC4vHQa20TfGkoxvyTBchx0Zfj5k8Dm0c7qFZKuwqijCTt8fqVwaaU?=
 =?us-ascii?Q?uisyIpQlPiDIm8RgqaftnPxmBx+/vwOCbjo844etwptW312ZiN6aA34mE5Di?=
 =?us-ascii?Q?eu6qoLe73X14BoeGrAL4W9+8MdeuP0w0b7gI+Or68yzfDs2UtcYsApfQNSbD?=
 =?us-ascii?Q?V1r1ZEbMpenUDJmy1JWLwMop6MYuj6Y6Yae8BPwMb/5Q7wi2VRME9WzcJS3J?=
 =?us-ascii?Q?UYHdVCGsLxvObHWErJnz3KZ9SKABqISngHaFc4LCvyhSpHd6T/wcfoLLCFZJ?=
 =?us-ascii?Q?6Pdv79Muj3P1hrs/4t4zX+uuk2H0CMQ5e8VT6dWq2ecp3FkuBzNWSRHKgLx7?=
 =?us-ascii?Q?6rlPa6+S1PgO8NVJTfpGJ8ShFKr3mbzsOBtRm5IJJ17zQe0eo4JCtwUFsVgE?=
 =?us-ascii?Q?H6xPxBICHDQcUNX7nLfZNDjJso37ZGE8nsxuWGJxIq2a+884WYOyESXCwGHo?=
 =?us-ascii?Q?ARWP3pK7NQ/snDrm0HdS7vW3aFxYuUmnxYdN68oCMghnvy8VafJ53viHGHNt?=
 =?us-ascii?Q?J6X3NhJfKR1kTNkcx+HzUgahCBMMQnOyt6thI8oNMX8cdWFWGuqPQJBNhjjz?=
 =?us-ascii?Q?4pSltQJc7cwUAzkV863W8/iCo9RBNuprRbqcDZMSkjhj8T6aYNcVx9sVM1vU?=
 =?us-ascii?Q?yNYh2c7NqcFRFz+5KWvrMPn0BSZpzCqjbp8dBHRgGA2mYzU52ztMSGVbW/f2?=
 =?us-ascii?Q?C2gCe1OxVkivGGvExwob3hcs4GZMmTLMZWw+RWiLbQBjoer+kz+mpoN7FyNe?=
 =?us-ascii?Q?dXClVn+tJUML5ZeIUwBVv0IG5xCTPf9Bc1yDrp0rJZxwXDPRM90BjJ1ZqySz?=
 =?us-ascii?Q?zwRtL7gbtkey4CMiAvp2pGQmvfRqveOStWe7o1eQUfc5Wu5/ojaNBys98hfl?=
 =?us-ascii?Q?O4I3L7kxQAbutIQSO/uTVsUi1FL+LwDsmibh/HNIg81tNjQP77/mGDBjnDl+?=
 =?us-ascii?Q?svv/kSEtAbLAigQjB+TnRB/nkMIgMoo/804/wPh0dJ/cGMSGMquf2O0fleek?=
 =?us-ascii?Q?Xt+1yme34WrNXiaeR63f+bIfU0ZqoIbxMsSRWJQSj+elc6tKske8cYgYKtsS?=
 =?us-ascii?Q?pGnrwHbUYXUaitF82dIOwsb9HjE1ylEbDs2YslNDngoUHSSFJI8aIMsxmi2l?=
 =?us-ascii?Q?DTmikXBYpCYXEZUQVqtW3dvXTOV3w1/WtkzUpgTu/fqzENKWuhXdjxPhqBrf?=
 =?us-ascii?Q?2PK3//a3QkHjQvx916/oTfNCULvHhxx4WrgeYohfBKkxnLyXWmcM2RGB10Qq?=
 =?us-ascii?Q?7C3/USsC9xxk7D4uWLz/K0bZCTcAqpIFayo/jOwCmBNzlcqj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8817f70-210c-4f78-780c-08df3071a6db
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 19:21:19.9557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ejvkqHqkWL+JZcMM7S+/sniG3bsPmihDmGv7Q52T1K91ZMUipaz1euPbA4pLNve4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9468

On Thu, Oct 22, 2026 at 10:22:55AM +0200, Jiri Pirko wrote:

> >But it does work well here, and matches what rdma and fwctl did as
> >well. So maybe iommufd is weird.
> 
> Well, one CTLV chardev is always backed by one device. I think this 1:1
> mapping is clear in the device model. Iommufd indeed looks weird in this
> matter.

iommufd doesn't do 1:1 with a device..

It is more like netlink where it talks to all the devices in the
system concurrently.

> >> Depends on the user/subsystem. Either families_dump op could be used of
> >> udev uvevents that also carry family inheritance chain:
> >>     CTLV_FAMILY=ctlv-attestation-tdx
> >>     CTLV_COMPATIBLE_0=ctlv
> >>     CTLV_COMPATIBLE_1=ctlv-attestation
> >>     CTLV_COMPATIBLE_2=ctlv-attestation-tdx
> >>     CTLV_COMPATIBLE_N=3
> >
> >I wouldn't try to link it to udev either, by the time some userspace
> >uses the cdev the udev information is gone, and may be unreachable
> >from inside a container or similar..
> 
> This just gives possibility for udev to work properly. Depends on
> the user/usecase if it's going to be used or not. Not sure what you mean
> by "udev information is gone". Udev might use these uevent info to do
> aliases, similar to dev/disk/by-*

I don't know if you can encode N compatible strings into a file name.

And in a container or something you can't get the uevent, so no client
software could rely on this information.

Jason
