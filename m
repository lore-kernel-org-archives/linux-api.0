Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792593565;
	b=zl+poffNI1MOB2cxJ3+X6h0xphwz6Wa+JrWow16FvJG4hE6lus2+SlvL0ypec5i6AHGr
	 AxeUlQS+v+P5O/fRLGG9j9hzXxtg3l8Ok98Tv4aMALvejtdIMNylDSvXhnnwlFPdOsI78
	 +lVMdrQEz3f7SGZBCMmzRm8EiLPB1E7hsVEsQ39f0DFkVhcRUm6IWLxoED4xDuPNaFXFo
	 NMkGIawhHSKBOavD4PQ//CcHpJaVJtnnKSdhFfEU3JGWAY1Ut/3+oFdM/MLehYzT3gBcv
	 A6CDM9V33uRkFG4QTSSx+GkUVJgNkUwZ0ZAA/4sWOPtdYDgKosviqmMPIuHeKcZ0gHA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792593565;
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
	bh=dyFPC5Ie1Utsp8QmPEaV9tntM2A99IsdSJCImODlt2k=;
	b=yoGmfJQrV4zAQm9AYlZn3ELPvfVcS0eBWloc6m1BSl50EkYkzkFH52La2p6tdYGlAgk0
	 dw5DVFg/QqvFZb7ktaqqmE2KJoOggyhfsHkxjd+KhegZ0FVnODJLu8sRMLROxPYdLTqmR
	 /rUh4n3JIoc+yjmEk7YJoIUgAyVXeHultRknu6AiGC3do1aS4amRM2Ae+ZtmGMBcz5j6o
	 BKTLgnpM4ajcd7lYmrM8ofl/c0rV/U35XbJYAszT4ZGhjGUF2Bkwvy9CVMDkDJuLELkXK
	 jgy3p0MHfyimmR+b8UTAZ342HZ8mLsUlbh9H5YuRvbAgcqE++gLwB+bwrePJi8BseCg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WTENdRIS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.53
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010053.outbound.protection.outlook.com [52.101.85.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15294606A323;
	Wed, 21 Oct 2026 14:39:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15294606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WTENdRIS
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YYq6Fsb+9OHRaWsFLEeTrn0a1tDO3uCW/3geCpHGBXz50awmohDl7Mqt8AKjNYWL0vgrK83c7xzAaX+oKDR4zJqqsVXvn+C9JWpDMZoOpXNInYHknoVtlDsTC5YlWLDHGG/E3rc+T5xxrEOAwkPgDw/vtIqRevG/rWy6jv9yMYBeigERxw7qdfyIpv0lhx/ofgaitBN2+H8hnT8EqKqGSZz+njgmoQ9sd7UCjUOe+kLQMQlPAs84hFe0ZmlCj6C5VsceWahHBoPq+BYKu04vZ563F5nECXX0jFBv90ZoOzue5GcZMmGqZplZhp7sZTg2uEaRcm6nYTbKF4fw9joDyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dyFPC5Ie1Utsp8QmPEaV9tntM2A99IsdSJCImODlt2k=;
 b=LvXHkzAvv0JxcCuJV3yfGmoWCvz/7fQINJUpax7zAQZnSJuOAiBAO3DUfuOAU3HSHgnzAfQavSRqxL1iguZ9vQnOdLwc2KtPZleTiyV+INbOYz14qBUJsQgnAiE2hycJ/sWEfJkqvpyu1NKouX3dhrYYW/yF7gaG49pnL051c21uZYwc+ZD7MdFgTlmn18g6q1iMM7jxF/34NS4UD4Mh4tvfQ+cvvPeZHrX0iBOrRER5uy8xZ3rP05FgDf68SpzMQMma9UWrGYk0DkW1edgu4UkIl18bwp655T6aiRD1Kx9TVv3aPlJND8anMFqyBjw++0YpzWOvWwx7xv4GjPeJXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyFPC5Ie1Utsp8QmPEaV9tntM2A99IsdSJCImODlt2k=;
 b=WTENdRISqxBNsJaPfsHqDiZI1wKg6jiWYn823+L2TvcBt8ASdoJ2pw9dFtRY2OPM+quWUDJNfvRJB334KwrEzjg8eG419ZseX7lPsZkfRkVEjpGPjGUMMvU42ivVIAr9Qm2Z/l5ebXzRToHu5s7k0RZobmyNPS512XRfzta3Q/p5ktiHEqbiP0kkNUNCKLg0+QauxLLk8hu1KzQL1ZyxOL3jEBfv/SFA8CI0F8qsgS7Gil+HDdfMrfXQrpEPT5CVTj39X7lQ2ccU2Rd2xtgdnkPJOavsXVTzR1sUYFzNh/0R9uc0slsCP8NkauzS7+MCVW+a2NNJgs92/q8o8vhmOw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SJ2PR12MB9242.namprd12.prod.outlook.com
 (2603:10b6:a03:56f::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Wed, 21 Oct
 2026 14:39:10 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 14:39:10 +0000
Date: Wed, 21 Oct 2026 11:39:09 -0300
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
Message-ID: <20261021143909.GQ3008132@nvidia.com>
References: <atX9fugGUsI0hGcA@FV6GYCPJ69>
 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
 <a69c7e7ac4fd07a9c375faadc599e96bb8c8534e.camel@linux.ibm.com>
 <20261020140655.GV13920@nvidia.com>
 <aa00515a0f364fea0150cf1550a09d9400e4632f.camel@linux.ibm.com>
 <ateSly15N5mLrM1m@e129823.arm.com>
 <20261020165251.GG3008132@nvidia.com>
 <ae372ed03da3cd2d57c922850b3b017bcb83ca07.camel@linux.ibm.com>
 <20261021135102.GM3008132@nvidia.com>
 <5e4032b970ae2ea34b0b616977406e3183294c82.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5e4032b970ae2ea34b0b616977406e3183294c82.camel@linux.ibm.com>
X-ClientProxiedBy: BLAPR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:208:36e::24) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|SJ2PR12MB9242:EE_
X-MS-Office365-Filtering-Correlation-Id: a004674c-476c-4548-2f1d-08df2f811199
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|11063799006|4143699003|56012099006|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	QPgnPCiOTakC5dj9v3nalCLu0mnjqYftKWHHbhy2ibc3NRxOWE0lyXKOyXzsGNoww5cfa5g/PgNAa0IXLyVkP0fvzAcS1s+dWeFQfry1Hxy3FVQI6Vj9/F9SVvwdX2ADBjex7W/NLSiWU2V/rrQQUuAuj1Hmscw/UAw+W9KHepVjoiJsZ9tKNrFC75J/QtzUacOQ58LOpz4iaX8TWQTfY0m8MA2crdX2kHpaYfso3OrayDWZvbuujWjxFB/8dVq7hi/cA6HBYCksWfJwqVrLlEU0Ws0qcnSygXvso2gPGJUzpprS+52scrkp3i18R7oC3aUuT4r0VTG1ewO23WF3OzGVF/qYUCxn9CSmgBMAFw0XL1htcztTBOaoUgJoAfYTk/yUpWDJfalagVJmq1jnwMj1UAHUSkLvBv5Sc49XC3Yhs5AHAfql6sfCp0uXHnPo5NjFoRGQUyiENKRTewv4ZNGhNIctRCi6WKxe/1H0uTq6hRB0EZCVtdgGLy0Al13vwjHEBlfSW3TMYkLtK/qelPs8jmml/2Q7VpP5iw0XRAEy6IOUpQqF5fMYOdnmV1ZJ0FBk65pXQVdzMLEHNdwpV7y1E3Fz7JDgIJMzweiLZ+mQF4faiJ3kZzzwnX8Txb8brfCVRfZA4XhuM/9efTtzcUWOJACNpEAb4Feuf0UvGfA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(11063799006)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Rm5ZSzYwcjFqWTRIZTFiWlBhM3RxUStIMjVnc002Z3FoN0o3N1dXNWtsN0ha?=
 =?utf-8?B?Y1VrekorOVQ0NkJITkdabDliUnlWb2pjVUNsbnZYM2dXbENpOTBjc01teDRj?=
 =?utf-8?B?OW1WY1FWRjNyREt1a1dGQXFkRXFvL3NjT1JMdnQyVXk1elRubnJSbTd4U09o?=
 =?utf-8?B?OW43dHBNTXBJcDc5V0tpdWpEVlJoU3BPOGkvckgwcnFaS0RKL1ZXQzBXSXVI?=
 =?utf-8?B?N3Rmd3NIV3ZqV0VGZUczSWN2TVpnODdNSGlXTk9RZTRxNE5FYVlwSmlXczVs?=
 =?utf-8?B?MmF0cCtvY3FZN2t1T2J6RnQ5bkluaHJhYjRoUVVGcmwzNU9taW1aQnZiQ0U1?=
 =?utf-8?B?V0xXd3FpZ3JOZkpScDl5a0hkY0pMUnpDYkRvcHB1ckNqcnJncm5NRVZTQnlL?=
 =?utf-8?B?bnVvZzlJNEZDbTErRnFHT3RFdXhrYTBDa2ZGMXc1K1RDb0JEMHpMdklhQzdZ?=
 =?utf-8?B?d0JpVjNZVGRSTlFvc3hyN2JtZ3dKejEzK0FRS28wL1RZczZTZUh0MjZqZEp5?=
 =?utf-8?B?OGhQSXhsWFZyczRnblcwenJmcTJXVmxHaVFLMktabG5odEtXd3R5dCtWTEJt?=
 =?utf-8?B?QlRYU0dvRllWdG1OTDVwSWQxNzZOUXJkVDgvTWROcVJxWmpFU1dTZ1Z4QzlK?=
 =?utf-8?B?L0tsTkZ2dUFVTkRaYXZ2RG1NRThYc2JEdTA4MGdlTUhqclZsN0V4ZjEySmpJ?=
 =?utf-8?B?WXZVZDlIM29MRzFZcERGSVB2NXJxNVdZcHBJNmFJZm9NOXRSbkE4bFIreC95?=
 =?utf-8?B?TmlCY3oyMGZ3K3p3MUlveFdVVDFQU0lNeUJraCtEdWJiTXBIeGpPcERCZWFC?=
 =?utf-8?B?ZWIvaUdoTjRMYmtJdlN0ei9qUE5EL0R1NWJLa3V3R3JLcjdFbXBzaUhLQnlI?=
 =?utf-8?B?Vm9QcTNVb0hDSEpIVHNZWWFGTWcvY1haNDNuUk5VRndURVE0Q2Qwa0g0cEFF?=
 =?utf-8?B?N2E1d2c0SHEvdkhCWHFIZndwSklvcVNpN3ZkYnJ4MHJmS21SUExhSCtzY3hM?=
 =?utf-8?B?OXlZbjJ4SUZYQlhSTmFVMDkxb1dORmk4Q2gvRVJjdzBqVzUxWGN5WVpWVzQ5?=
 =?utf-8?B?akFIbzRDUm41KzdmLy9ycVp5VXRnRlFMU2p6d0htN0dkWU94SkUwUVR1TEVq?=
 =?utf-8?B?WkFDaEIxeU9sdUZyU1NtaUhLampEMXZBSWZoYWJ4MkwxNVorRzRoaW9oT0JB?=
 =?utf-8?B?MUJUOXZFa0tCdFZTVjZrMTJ4eDJCNi9XZnFOZTArVEkrWkFRL3Z6SXc5MzAv?=
 =?utf-8?B?QXRtVjZHUE11aWxlUW1Lc29HSFh6TXVKdmd6cjI4Y21ud09tMU1reG0vQUhp?=
 =?utf-8?B?NEV1S25UclpaQ000eHEra1dpYkJwRU5CblgzdFEvN245aklEb1hKemFnb25j?=
 =?utf-8?B?Y0ZXdWZDaGp0K0dYS0tzWlVpWCtlWWltSG8rVUVwa0F4V0YzR2lvOENZdUFv?=
 =?utf-8?B?Y0hTRnZiVXdRbXAzTmpncDEweDg2ciswUXNMK3ZjM0dsMFlsSENUQVNNZEJn?=
 =?utf-8?B?bW0rZWNTd3QzeVh6NEpTMFdrVUl2Qm9DVHk2UFM4RmVHVVN6VVhOQXdlNU9v?=
 =?utf-8?B?OG9yTy9MUTZkY0g0b0JmNVY0VDluVElHNTlpckFWYlQrWTdKNFhiTW5WMkVE?=
 =?utf-8?B?dXBSRzJ5K2VGejBCUEh6RDltZmhNTlBpeFBobWttNWMvTVRxRFUzcjZvZEZF?=
 =?utf-8?B?UEhLRDNIckwxL2lqNlpJcXRkMjhuRFpHajhSTHRFVUZwaDFvbCtHeXoybmpT?=
 =?utf-8?B?OFBibk9LcEtJS0JEYWU3L3l0cVgrME1DaElJcWFwNmFIakhtN1UrWG9EWG1M?=
 =?utf-8?B?bzh5YlpsYVlBTjlFeDVJRXUyQzZJSHBMV1ZoTnJzc3gralUvOVQ0c08ydnhK?=
 =?utf-8?B?cXVJZnljQmw4TVdLTUFOVHl1bFgwUW8wb2lCSTZyWXVBVFFxR3NDWkl6STli?=
 =?utf-8?B?ekNqODdLZGFEajN1NnZyTEJRQk9SZzYwblN1Qzk3WWVQSFJET2JsM01uWEJE?=
 =?utf-8?B?emxmdktxNENiT1NZdVllQzZrOG50QXVZenhoY0g0aWtuR3NFcVdXSk5SaFBK?=
 =?utf-8?B?NHdmOUxsQVJvb04vZk45dHNCT1RpSnF1RHNKSTU4UHJmRHhTMFVvWE1oQjk2?=
 =?utf-8?B?V0ZGaUw4S2QrQlZiZXVqcmJTOENPZ0VEdXF6cVdpSTBraUt2OEQ4SjNNYWoz?=
 =?utf-8?B?OURtSWx6MWcveVVrcGVhVEpGZ0dWalJaY1NBZ1hQMlB4YmREa3o2ajUwa1h0?=
 =?utf-8?B?T0FLWGRpV0NVTkY4UFhFdHRJeDhPNjcvTTdwcm0ybVR3UWRUME1HaFFTYzRD?=
 =?utf-8?Q?bg7n/g+A0NnAmLLjbS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a004674c-476c-4548-2f1d-08df2f811199
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 14:39:10.3358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 045IRzCFFOM3q/MpWMiL3YyGHdT8UtH/LfhyEL8Osy26oxZbMfYGadEWI0tx+7d5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9242

On Wed, Oct 21, 2026 at 10:31:54AM -0400, Mimi Zohar wrote:
> On Wed, 2026-10-21 at 10:51 -0300, Jason Gunthorpe wrote:
> > On Wed, Oct 21, 2026 at 08:23:05AM -0400, Mimi Zohar wrote:
> > > On Tue, 2026-10-20 at 13:52 -0300, Jason Gunthorpe wrote:
> > > > On Tue, Oct 20, 2026 at 05:11:03PM +0100, Yeoreum Yun wrote:
> > > > > But, I have a related concern about deferred probing of RoT devices.
> > > > > 
> > > > > For example, if TPM probing is deferred until after the attestation
> > > > > subsystem has been initialized, how would the subsystem handle the
> > > > > TPM becoming available later (This is reason for
> > > > > IMA_INIT_LATE_SYNC).
> > > 
> > > FYI, this patch set initializes at module_initcall(), not even late_initcall().
> > 
> > Yeah, it's fine for where this patch series is.
> > 
> > > > I don't think it would be any different, the mechanism for TPM would
> > > > become generalized and apply to any attestation driver.
> > > > 
> > > > This series doesn't attempt to do that flow yet, moving ima over and
> > > > dealing with this is another series :)
> > > 
> > > When TPM device initialization is deferred, it is retried during
> > > late_initcall().
> > > 
> > > As there is no way of ordering within an initcall level, there is a race between
> > > the device driver probing and the call to late_initcall(). The solution was to
> > > allow IMA to register at late_initcall_sync() based on a Kconfig.
> > > 
> > > Both device_initcall() and module_initcall() are at level 6. Are you sure:
> > > • the PCIe SPDM Devices will be ready at module_initcall()?
> > > • the PCIe SPDM Devices are not deferred to late_initcall()?
> > 
> > Why does SPDM need to get involved here? The device acceptance flow
> > and SPDM stuff will be managed in the initrd. The subsystem can accept
> > drivers and load a TPM/etc earlier while doing SPDM later. That's fine.
> 
> If there are no PCIe SPDM ROTs, then it is irrelevant.  Otherwise, the question
> is whether the PCIe SPDM device will be ready at module_initcall().

I don't expect it to be, it will probably be loaded by the initrd as a
module.

I still not sure what coupling you see here with SPDM?

SPDM is part of the device acceptance flow. It doesn't need to be
ready before initrd starts.

Jason
