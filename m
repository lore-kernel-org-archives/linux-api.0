Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792593335;
	b=YXC/KhvGqs9G8eHQXF9L+CC1R3WGgljt/WFBNkUfXwgiq5oOJbYvbYLuuPJnhanUezFY
	 8l6Bfr+DPuNF8XbmqgaW0NVbaLkUQo7pwI8EJuSbePXbbLuDfFfTCJqY7H37nQohQFv7y
	 pY/7VVysz9x6OqFmQ+WM6i1t/GuUbGGXs+s8tKQh/3LsAC/Fx+Nfq8TdFn0pdffXVkUrm
	 JK25outYqPWBy5nX9qyJU7jbwphBY+k2AyCYeeoKojnCg/C/U0zhGHc6v/ro4Jhufzd21
	 ZzSVyOJM4KCIsyTS+CCUuvNZJJvvWdVbIjavA1SGdQzou6l9rc2Ud/YbnMJtjnlTRBQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792593335;
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
	bh=6PJyUzzN5QW9sAAFb8LWvG3kbRiJ5Bm6VDaOA9704+k=;
	b=ZTb076tk6IgPAM1ci3GR7JADXI242dUOERVY9PYyQRC4JbeapN015rpgYMnq8aQIFJ0j
	 GUNWfie5SB771+zK7LpbxXIR6AaN4DagAQY2OZqE2FPl3BrfLK6yyNnh8QTUwWKQmpGJV
	 EbsQVWdUUd25uh/1ZLnDnZ2Fy1hb9eDV2BncCM7rgllr+54lgqgTKyJeqhSmiKg38/Ljt
	 ti7fFphMqKWAJf9Hv7pOYy8jSaYfHlbKd3e/B5Gvq91/3sR7NUnK26MCBSJxa3JgaOnI3
	 XAiWKzL79LU8CzxEhooLrvid3RkhlNBSkAElxmsminOV3BKm3coVvM+iSwuNecKNrVw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=UwmZifLj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.26
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010026.outbound.protection.outlook.com [40.93.198.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76B9606A32D;
	Wed, 21 Oct 2026 14:35:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B76B9606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=UwmZifLj
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LIQxPH/gucD/bqdh2grPWJQdy8A5N1XGuvQ2xgnMPAVH8JV6lwDgkZHFN6VkdO2BXfvmqIlKuBixJbPqq0FbWQgriDNLLfnIDdm9H12bh06SjcqIEzgA1zCwFitrmYork8+fcuey+/e9exNslbRzEN/smoaBsaaAvP297u3HOtLeYh/SUP3vFjGUjj3BcqJvxGdedG9kRqShOdsFtVX0n1UsbJ0EWl5r20KKH1dsAzF11XLYN9A/HtAm0Ri9S7bkajTQcS7QzEe990a1o7PWVzV9/fYsfMF+wdbbeoRVc4nik7/8XeEPUvBjInlJkLeAz0a+31E3GDWI873/T20K2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6PJyUzzN5QW9sAAFb8LWvG3kbRiJ5Bm6VDaOA9704+k=;
 b=hztNDyFHxkpaE2mEllZ9Dl04YxcBSH0n2OBWAizgC+avtweMCynGs5oUgQfX9/BIBNRhr0YjiyJycxQ8TfTi/nZx8pCSolytyLuxdEhGDTTUWRgBDwyrbwFsDxY7LGU/2f9IHlSufb1IrpMwAXk4ZtoiltHinBFaOc9LYM/tMNx4+B6TIjcmOCSBEeaS3NYlVmUFpAvUvwobdlM+zupemxvS3+6qHbWlVxm9oL12g0zBOdKvXyxCksxm0AuPDAE8KQsLPqAHI4sujHOxtaEGsas0sZ2vpWHQG5kiM4FFLWDP1qPJoeI9s8OEkgf8YU/22E7Yu18jd+cLxd+d31/WaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6PJyUzzN5QW9sAAFb8LWvG3kbRiJ5Bm6VDaOA9704+k=;
 b=UwmZifLjH4USqk42IA9jOG0JIF66JTKdC2kHSDJ6F8Lsyld0/El0kad2WsC7mUcRceeBybLh0IInFVYo604BVaJ6hjcEZJ1l07lJ57B0Sb6wwLMjKvOJyFoqtdRqGVDSEpEeg7UntR6or1RMzsQQS6jV75Ryx2IZbDyftffJuS8IbjGbprQL0D6Ygjz/NPzx46ZuOZglARIaqYu3U1zHYmhRAywfGtzDaoY+Pwmro/c4Cue5yJeflc4xHgrFJlIw7etzUPSKTtkAloMzaHpDMTOcGiCaKdza1uQEtXC95ZN2+tPuWh9Nm1/IFjiRVxBAjrEYkj8MvgJmYAvt9NCaAw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LY0PR12MB727857.namprd12.prod.outlook.com
 (2603:10b6:408:3ba::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 14:35:30 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 14:35:30 +0000
Date: Wed, 21 Oct 2026 11:35:29 -0300
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
Message-ID: <20261021143529.GP3008132@nvidia.com>
References: <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
 <20261017203407.GM13920@nvidia.com>
 <atPgqROZZxnihYfC@kernel.org>
 <20261017231007.GP13920@nvidia.com>
 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
 <atX9fugGUsI0hGcA@FV6GYCPJ69>
 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
 <20261019225658.GS13920@nvidia.com>
 <ath4vwt7KGyDXKVJ@FV6GYCPJ69>
 <103486a4a29ecc7b72940dd051c00ae59266bd05.camel@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <103486a4a29ecc7b72940dd051c00ae59266bd05.camel@linux.ibm.com>
X-ClientProxiedBy: YT4PR01CA0018.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::26) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LY0PR12MB727857:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bd9d0df-00d1-4c33-a074-08df2f808eb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|6133799003|22082099003|18002099003|4143699003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	HeSms7foGbA6TpGgbQHw9l5Yx4SGbuLSpOMeMjiexoGAC9uyRYrOMGl9G1ekWT40hm/XJLGSQ53TwiuAW4ZHKcZ96Xa1tU+QREyxKuCor4aHLfnfIak9kDoZBY2eFzbkg3GvYtwoB3lg5DWGOE042zj/uCdZKJd/8p4sj2PE97J08efxGjHMqKtFEJ7swZeWKMQzZBLaRihMzvqe4eR9rnIDWr8cahH5+ZTvY2JjDI7drdipW17BB2gwfG9lqkyfyGzemgrae3GoUjVcaVd4FTS0iyauBLDXTu/AYAeUYkrbvxTEIt/UQdet1MIhsj6qTEJgaPM8TQyyX1cnA1I13zWhB/03w2bf/86ghnnBvSH5j98B1Hea5Yatw180yBWe3VdxprSbMF3FtQ0ZbfJWn4HJTbB6FYUPao868p2UJt9k54SuatkGh/NZnN8N6sm7XOpsbJfvh1DF1qegG3K8C8mXU2nMgD2G7BEw0peq9LR/RHxgYZEAWtzWnsSEd/Ms1JO8DZLoqh+3yKZx/mfQYGcfoC2yGYqF1bm3reYiuQy1Pd0a6HU1GsK34CmAbbyIyy8105vfg0uS0627WYgAFL8BYLQP1rHnv4UL8mHyM4qnAZFB8SifKtBhoCXMeuckqloPrtRsZADoWgLePkDjfndVebQrnwRMU3syBsZknCM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(6133799003)(22082099003)(18002099003)(4143699003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4DxjdK7ShxQO4vqp+dR6dOklPL4BS7cRH7/Pzdg3kwCrGTeGfA+05lmRAQoj?=
 =?us-ascii?Q?1r9FRF4waVA0Z7RMwp9T+bh9e0PPNrzHAR0rZWGiDNjctxmWPDhtFvwziy1t?=
 =?us-ascii?Q?cPMRiBYVKxnvdIwbxtb+lgzfPLsfKaUeX0fGiEmOQwGWLwbC3APQjCY3Bcy9?=
 =?us-ascii?Q?aLRGy4WLjSlwq1cZhFiMeeOetLflQb1e50iqMgeWITcatbbGC9Q+eMpBPu94?=
 =?us-ascii?Q?O53KYhJO9cx5hBJwyHHzqg5tCPezA69wPT9olCfxYmznA6pgQWD8Cak8Fgm7?=
 =?us-ascii?Q?abUCDLzF8K8Su8O+vP+qcFk6MAlLrOZ0of3qji7FOTo0yXBeGY+GgrE7mqvZ?=
 =?us-ascii?Q?PGUQdKdkITRB4Qr1ELj80xrxb+X4HVm5AHqeoE2jgyEprPO7nDfHsYVuze1i?=
 =?us-ascii?Q?doA82LsZRDPDWQ3rBB2gcLOYq5xP8fqiIXGDUrcITxONqvoOCqSQ4dEqB+Qk?=
 =?us-ascii?Q?eSqFLaCLOKyRcGM1yRXRqMle5i3SXqjTe2OYVVdRtNs9hh4ZjK+nnpJOHMlV?=
 =?us-ascii?Q?P5wO4X4jwd64ZbuVsmW8d/zZUhtY9pRHsFv22yxCQo8BNEIX0KEfZIhT4TdV?=
 =?us-ascii?Q?L0jws71yhdEw1Szff9fEwnju5JhRge9sAuqazcwtByaYQWrpPWAcTjSkSZ8F?=
 =?us-ascii?Q?6oZ8PhKkDays2wUO1Jllft91hXhOcG+pQVQq3V1PGe5ktKVSR3QXgt4NIJm/?=
 =?us-ascii?Q?E1owZfM6E2dEqcQedRTnpxBBLdyymCxTLOSleVbzZhHIcigduI8Obg7zSGwx?=
 =?us-ascii?Q?oPTapdFGi/gfA2NzyEeDcqvWR0mBdB1eBC3zOFSIDjTu6svetBrZhx/JQJpB?=
 =?us-ascii?Q?jTNrScXefj7NuRq4G49e+lIuORWtqbz+BtjE1tueSUO+EY2occeBEDFRA3b4?=
 =?us-ascii?Q?MIjvBmLq328STgxtbdcI7XguiXQ7wJtyDOweyFTBusMH16FhsuP1xDmnhj9x?=
 =?us-ascii?Q?2fatt6sjzvvzxGcPDYGg/9VJTmOSmCeHC+eAaj0035JTtrhbALWQTFO4zrXj?=
 =?us-ascii?Q?CEcQBBTtkfM8u6F/7fRoc+W/svvlHdisFzCy/Ma6JtYBJQrIe9quz8fOOEo/?=
 =?us-ascii?Q?hOx/0F44K18vlNMDjpz8Hn4YZJhFXa0AqD6BMQx1WkUXJCYt4TXneChW8NBN?=
 =?us-ascii?Q?1AIvjlGy6H176yLaDSSe2l5T5CSvpAf1TqBa1hDrFcJmxUDO45itrtHDPRb7?=
 =?us-ascii?Q?JEqnXAYDsR0bXysQN5tQySpe0fztfcmRkB4lnw8e7IUADbolLNe7yVowjVWO?=
 =?us-ascii?Q?8xcEb2kZ2hgo23hYn9C17sfXO3ylhqvUlIt0IWeiJQ4nWJBcWf3MhdzJDrRM?=
 =?us-ascii?Q?a7pBXxd+8k1TaKaJyv6qh+pIoFzEfww1SysuMlilGAesFjc7ey/DZbKb2ptN?=
 =?us-ascii?Q?dkCLh1CHrTFjSnCpnAiq/nGFJamU0GIGUhtullKJrSQS/aB+dHrQlPnfjTsd?=
 =?us-ascii?Q?0FW77jjmyajmZcZhkJDmRPFH1N4q1xXiTuADtGdRyNZNMY+FiMkEP70SeTdU?=
 =?us-ascii?Q?xm8XKYePaGml/+DaHCmDiHHNj2Ka3QOdp1QWRAzqoQ0Bpe6GD0G8yzxDSNeN?=
 =?us-ascii?Q?lbY26Dg8cbw1/idcATYweTeeKKvO4oa3uVkeFsFwIGTetUIYzJEidOY8ZMiz?=
 =?us-ascii?Q?wwGWAeARmO73wRJaFy+JXMZWFeMNH8NioGiABsJ5jt8XJEi0Vyb/EBX9jCWz?=
 =?us-ascii?Q?UpLrr4o6eIFRSC1x7MMlvPT90L6j37LHM7XGJOqQgJdpgw8E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd9d0df-00d1-4c33-a074-08df2f808eb4
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 14:35:30.7559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dVRXDGQRiDXrz0LUokLnq/LNZMSccK7jnf91+Pvt9wAVvpi0qogL8r7hQND/2Z2Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LY0PR12MB727857

On Wed, Oct 21, 2026 at 10:12:34AM -0400, Mimi Zohar wrote:
> > > I think for now we should not include a new dynamic log here, the uAPI
> > > around this Jiri drafted can remain a future step. I don't want to
> > > open complicated discussions about new functionality at this
> > > stage. The whole CTLV idea in general is a big enough thing to bite
> > > off for this series.
> > 
> > Okay, dropping the log from this set.
> 
> Thank you.  Please keep in mind going forward, that the scarce hardware register
> limitation (like the 4 TDX RTMRs) should be resolved (e.g. by multiplexing the
> extension path), not by combining distinct measurement lists.

I'm not sure what you mean?

Since the HW doesn't support sealing the only *technical* requirement
is the verifier can reproduce the measurement register hash. So long
as we can get there we can do whatever.

Multiplexing extension alone isn't enough. We need some scheme to
reconstruct interleaved logs too. 

For example we could add an atomic sequence number for each
extend. Every log sharing a register can report the sequence
number. The verifier would have to globally sort all logs to confirm
the hash.

Hopefully we don't have to tackle this problem. I hope that 4
registers is enough for Linux. One for IMA, one for systemd, one for
user? Plus a spare!

Maybe we can build a multiplexed scheme on the spare? I don't know.

But we almost certainly need to have logs sequentially created in time
occupying the same register. Ie IMA may take over the register from
UEFI logging. Here we'd want to report the start/end hash values of
the logs back to userspace so the verifier can stitch the order back
together.

It would also be nice to think about a way to restrict the registers
to help avoid multi-user conflicts from misconfiguration.

Jason
