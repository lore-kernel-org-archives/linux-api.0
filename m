Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011012.outbound.protection.outlook.com [52.101.52.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EE26DCE1;
	Sat, 17 Oct 2026 23:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792278618; cv=fail; b=Lgd05XfEbw43iGBKNdGXsk8GaS4UsYCaihRZyVR0MXUYa7rqeXm+LeOWEWs1mkf95M+ntEcI8m4j0ZqeySB7bziw+FVFmAOBsGe+RkT2YXY19O6jkCYrvxxrrsVlwjKr6xmDgGSW4+BRtmXviIjIP42WnC4AmiEh/LlRGEMVbME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792278618; c=relaxed/simple;
	bh=js0GyCtPXJzknYNuw5YosF7FlInyD0G5zHN4kaVFFBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=grZtGrrOEgwNzMUexnonYGIMhd1Xjhu/kPx6zRBQ6vZi54wzg7d3CNmRcv93VvvLnVKuefyaDRHZUGpycIrd4N6NyJs1h8pmdn/NqzwOp2rdNgyGR/nJRTq8mIuc8ZMFainyQmvtH7csx9MxBtCZT3iy554PLmPgTh2R0jMJcWc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b8fDZOR0; arc=fail smtp.client-ip=52.101.52.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b8fDZOR0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x+mI5sDqJ12wt1ZLIqN+GkUq6DJ6aF0SsA9y3Z2gxbFUG0zGzBLZ7Bx7Hmkq4+fcz0Gyp1gWe30wG2mlw4BSY5lC02tVAzHoGEoDWGXQERRf/YNg11c+fLFL43CqXe73xbCwYItG9BK9twypZ14WsborruGVebgP9BnziLjQmfJDToPuS/ldsLDWouK3T/WBJdGjCxQElAIB4fp4IYI3qqe3gmW3qGVjhZo7xhPGwKD/AqMYkSWbI+487SVmeSjfoGWC8nhYmxLBnr6A6pZN2UpAi/guX2VBvT8S6kQHvO8ZeY1OzodSsjfKeRIyYHU/0WVaJoT5WBOu51+bEaCvAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iXU57OeQ4ixRQ35q9O2KVqdfiqxsAEwnzWj/YftGRx8=;
 b=uxXgb6k18+/BhxwJqTSpzfZ1SpnRRxLy7KaFo9kbO0rFOA4bW6GrbgzNJ/zaN4ad1dKw1QHUT+KBHVUTimZl5Rbg+0hdJUi+Lw9rCuC6TF1O3r310wthRReJ3ONwmWkIfAxLFY5o0rDgAw1Up+y9jd4eM7c9SF/VzU6d3UnOMsCnca5xq6vPtHBMP5DyNCSr3y57bNicPoyLQuFkDcOfjb+kOAsgWUHqRkm1nnOUdDGdYe8cIod0MIFeW/qouAnYM6wgxco1JMO5YPVrRQlfle6deW3T9FTRDoP0Ls1yrrqwuBZtwprm12MhF7mk03YU0+vsBgO/m+/ZUwVit4DTaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iXU57OeQ4ixRQ35q9O2KVqdfiqxsAEwnzWj/YftGRx8=;
 b=b8fDZOR0ZVzYSjyTHSuhdQyVWumy5irT4IUjpj8H+pk58Nj1YF+wxMTGe0VZmSzyfruDMuxrZcItnqJuLasZJDHN4Hk0v6w1/GuRfnB0Ft2wJt1es7Z85j09CWGyPj4zFIme7mCpkQtcLhMDOCywAbSkLSZFbFnpwII7vOilXcXBUUmKJDrkDKNDVQUvKc44q7vJ7v8/duqji5CsDDfFSNbaQdbZK1/sk/98r8fdxCws/AqoM1/RRONrnygr/Pzk8oHZCENkWLeaRS0IT2xSYmrPrNfnpukMN7GBaJAE++IFjoZYpoeHK3mql862U47Jw+b29f6UB72jNBrcTzACVw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS4PR12MB9795.namprd12.prod.outlook.com
 (2603:10b6:8:29e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.18; Sat, 17 Oct
 2026 23:10:08 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0522.017; Sat, 17 Oct 2026
 23:10:08 +0000
Date: Sat, 17 Oct 2026 20:10:07 -0300
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
Message-ID: <20261017231007.GP13920@nvidia.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261016234354.GA664420@nvidia.com>
 <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
 <20261017203407.GM13920@nvidia.com>
 <atPgqROZZxnihYfC@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atPgqROZZxnihYfC@kernel.org>
X-ClientProxiedBy: BN0PR08CA0017.namprd08.prod.outlook.com
 (2603:10b6:408:142::24) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS4PR12MB9795:EE_
X-MS-Office365-Filtering-Correlation-Id: b4a4f8a8-1cd1-49bc-fc2d-08df2ca3c997
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|56012099006|4143699003|11063799006|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	IUgmjI6Hz/rZhD6zN04IOOiTAVmKl1xQiz/cH+1z+8ttQP00HSJI3IjSgfyK6wYOdmXBukrK1pU4Dlv0PMRxNd+jbbqKqTov6b2kSjJsEAWuHMP9rxooz6eQ78rG3f7uAYoZ13f08F7xw9pLe0hcf4j1PbH495hZhc+Hl0RzShUvqp69XKy7Pp644l1haNwyv74wpq2HQWgjAs4iS2ocGnDcvX/wGAyYLyaIaRO/D8TCRsLBhxDmldZJr5Lzd25iSW2Ca3aUJtaG/j0OrYL5Zrppaw+uYEU7axrphxjkfuXCCDL/7kChjhTRQdd03WO0jcZ+4ZaOM7l+f4r447dpPZIikHZnglPU0l0P3BbIUruMbqV9dUvjKJPlpi5fpQLkoJuJH8y2nRkFhPms+yCx/dT6B9N8pBp1BQPmEaK3YDhj1DTh5qYqt6tVGx970Xrp2it/0ha3eYkXXWNXVE0KSXFMp5mjKa4pEOFMSXaqmKNSdb0Q/+W6DQI3sGLhBeYLKSspKMFXQKhHHroFB4T+fnrOPTEZwnICMhVEfltE54zPjhayTel3SL0FyhV++oyr2HWd3LQJOMnuJG9bMjm0lbiUlTibNwbkV93VsC5RnJ7v1VL7q/m2skdQ+8zyThgycO3ywhRJQs+4S05fHkLKmK1mTnsoR4FthfO1vtEg3WA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(56012099006)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PwkyOeVB80LL8t/kl3ilUZ83bv9MnAkuHwSeB/TLb/U5GeURMoKN5Ca2NiFt?=
 =?us-ascii?Q?0nvHqLSwuXSDmyi1O+hUHonhXkvW/WBbParsVxBhmSyNcUDdNo/UKVuteU9G?=
 =?us-ascii?Q?z3JfYziu5HJXwApVA2Z61zp6viXrn1HNM+XSFlYGtMb53+MmdnPRpBX3LKZu?=
 =?us-ascii?Q?KcqOpB/pLLHJm7EX8PB9GtVx6dSzd3ldOpclB5JP3yT+90tVeXQ6WDqxXxt5?=
 =?us-ascii?Q?GzPusckJrEzwckxE82RgEE8fcaB9flgdT5/GN7Uemk1LcIBDNDIKb1/s/BtP?=
 =?us-ascii?Q?4CjqSHOESpwTqzGQUjmoJkki9375Qi4YLE5ptK3QoR5u8Z0p9s0auKDI5/KS?=
 =?us-ascii?Q?loSyCI5VVtybz0+xhCscZt0Qm8UCSubKPfPmFCFktWfeZAuYx6tjWJtEuGoP?=
 =?us-ascii?Q?twEvRRcODpnvZN7/wFDzOxGCVYLT0UJFNVrqXwIXTlzuCF5QOyDCwphC2aBq?=
 =?us-ascii?Q?RJ4v6fXCTyYT0AnrOI1yEYB+DHr37fBKiKZu82QEl5ZWtdxbVqraqJb7w7VL?=
 =?us-ascii?Q?hcpKXDIa7QPeYq7GqhabdvOPTiVBfEugL+r42fn+M5CR5GqcbWLY/Zc1UD6X?=
 =?us-ascii?Q?ZuiNo1ypaPyo7Yw0pafCPMiKMsnmet0ebwzlWioAwBVXn+GJUtWLqaXgee2L?=
 =?us-ascii?Q?+QkGdylxryx9vz4seVv2dmiwAZ2Bugf5hpTch6V8yg9uTmZRdj4H2/1l+juQ?=
 =?us-ascii?Q?S3oeZQlM+Vv6dlENpyuB3v+r0cv+L+IwKXzxCprBWNWH6lsJmsTpKhwciiRQ?=
 =?us-ascii?Q?ks8jQNiSx+VSdEEBgfWN2ryzReCB4HsMeQRhnyvdD7ig3XThDJ0mo3mLfJ77?=
 =?us-ascii?Q?SywPT1SGmHprF3v6HAFVNPRJuEMBQuJ6tL9EkXWoGlpHdX5AZh1NVCiPjltK?=
 =?us-ascii?Q?x9+4RbcTW5nvjt86QvcsweEugxG/vS0ZcVW/3UBV9XsRcXMAgmYPArv5lwEX?=
 =?us-ascii?Q?fJfruakeLxSDkV1GmSXaql5n5UkoP9a5pW5acwhMwhMkkYPt3U+u7v9m7yCc?=
 =?us-ascii?Q?1Yhk0F7dAk7ES0Siqp0I7bL/Y0HOaJqv0WZ7boImDK1fPKk5II/p1NUzlawF?=
 =?us-ascii?Q?LLtEUd7FtaNaQmG3WAypuNWxGeMD/YSmg7On0iwR6wgh7vvOd2js0vFbVJfd?=
 =?us-ascii?Q?GJDJq8USGM3PRcQVnhkW4fQX5pnkjoMYpeS9sFtE68rWevdMCzahzwNU/O9J?=
 =?us-ascii?Q?3tdrIiTDXTFnE4Mc+DGZQlW71e5XtTmpvIYtAsRATu1fhy1eooK50f03CMNh?=
 =?us-ascii?Q?GUo8ZiydM4WFv6O9072HNTTqYSrde1elskczxdoC/RfUxqYmb7A5HzN4V1gH?=
 =?us-ascii?Q?FpvQDvfM9TMFZEzgE79bNIVw91F8rXOCxrmIFAeOPDQl0HC/ZQpc7K2xNvMq?=
 =?us-ascii?Q?wzsGJNh269XF1ckY7/HVKtvEZdHzNby21C+xPStsOVAX8pi88vdwlZ3TgoGB?=
 =?us-ascii?Q?zTV0pF2DoVFOQhx6msNSs2Djq6+HyPGZPH9+jcHIAUl71KGpQFLJW3K2RY6I?=
 =?us-ascii?Q?CGEMTfdIKr8vjou8p+VCLNrtDshnerP3e+uJHRtG6xlMSVZbaIwyrre3/KI5?=
 =?us-ascii?Q?ZslvND1Qo/aN3VgVaS82bFiKwXIEgbpwEDiw3zweqJ30tnCB363UquGuQb/X?=
 =?us-ascii?Q?ipYPK+627mMxHew7vQSSq4IiIs4fscPTxW7koaIASO6AfVarpxCKLBMSwf/V?=
 =?us-ascii?Q?bRJCnIq4XwfS6uAGzGgHcTHfIo08LEi4f2JqdZbwAJXXSaZE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4a4f8a8-1cd1-49bc-fc2d-08df2ca3c997
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2026 23:10:08.4179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IVAqY4fKQ7ZIp12uKuAngBENeDZCdeuwAkk+caZaz3uPRo2ZUyIwwBhJXJISU0ai
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9795

On Sat, Oct 17, 2026 at 11:55:05PM +0300, Jarkko Sakkinen wrote:
> On Sat, Oct 17, 2026 at 05:34:07PM -0300, Jason Gunthorpe wrote:
> > > +Jarkko
> > > The TPM driver is pretty entrenched and heavily used by different user
> > > space applications, so it seems really ambitious to bundle in TPM
> > > here.
> > 
> > By "ROT agility" I mean if you want to do an extend operation you
> > should not have to know the details of the HW holding the "PCR".
> > 
> > One of the APIs offered here is a HW agnostic extend that can be used
> > to build ROT agility into user space programs that are doing
> > logging. That's systemd-pcr-extend for example.
> > 
> > The extent of the TPM support is to be able to issue a PCR extend
> > triggered with a TPM command by the agnostic API. Not ambitious at
> > all.
> 
> I wish I had a better picture what is going on.
> 
> I don't have capacity to heavily on this but can help sorting out
> issues if they are put better into nutshell.

No worries, thank you. The eventual TPM commands are probably the
easiest thing here. The really big investment was mapping out the
capabilities for a wide range of a HW types and come with with a
reasonable language to describe all of it

> I would recommend to at least check out tpm2-protocol because when
> I did it my main use case was exactly protocol interceptor. It is
> designed from the bottom for that one use case. Plus zero cost
> memory usage can be casted to a raw pointer.

Currently we don't have an intention to flow TPM command packets
through this. Anything would be a high level operation like 'extend'

Jason
