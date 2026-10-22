Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.57
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792674708;
	b=sJPzOLxdQgy8CN9MiFVvVwN4NOdJN9a9qsgapjkXNIAyK7pZChL7MQswjh0dtHxksmmZ
	 oyZhkVMwO1vYITzcRrh9l7mVDEJ05iNniUvub83x7pv+gcuLEyI51jB8V9Vr+Xts871Sm
	 7dLnR34YaPAeozRoAwjUrWoR4Y2ey3dOaDZ/FzNccl0vX0W5d05X5IYtqptAUDrYcJxF5
	 WjXABW9D9BY1U7pB4LAfF+e7dyNNGm8eBmwrXkxlscvIRy30wxRmwEvr45VDNBtLgfARJ
	 kUNJIcIwOmr4VYSbZFm8MUbiLdUo9NoK+uRUTd8MDM/INcaFY+EmjM7JMzzkOO3OWbQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792674708;
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
	bh=ndoRAQDqEwXsZH8UzjlDh9Wj7CkiAkwv+RCHrWtXTIQ=;
	b=Zo5ACnly7lKnDfbCPEiOf+OUuUaMLH58basCjevpgeMIBl+PLWRQDNSApmZ/eikNjNlp
	 wDfaMTslDkD1M5GxyIoVRf0LypNv2wUwU1afhYl47emWmjwOLpE23xB67LYxaVWIlIt4e
	 BBlrCz6IHv35cMAzMyJdY2rWgicUL6yEdGlT+Rf2WUdzLxVa7xTWOamkYOiyA4oT/2Rf4
	 sqVxqAeMS2NrnucUJAb4tfbKtsEVy50Z2sznzxpOqv+fzKHLyLmrUTQ2CQGhL1Kx7gsiM
	 sp2UBVoS4sHJ8S7Nt8pRuzNxGvtPpkutd+LNrQTJ6jirdp3KQF+3DBJIEnaWXd5dJvw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qBfZBOnu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.57
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010057.outbound.protection.outlook.com [52.101.56.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF4B606A319;
	Thu, 22 Oct 2026 13:11:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CEF4B606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qBfZBOnu
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fb0RoDbxjn0uSSDSznc7j0UUtBAicijk0apw8sICcXsVdXd/tATU10wZ7eB4AJutojfaz5wQ5/YwultBwcUwUW+rDFV7D0SMJnOkZd0MJ/rX6qccwArr1own2pUVYTU48N9Nzkh6/CMpk2R/zxJGinQzJTMLmdB+xt9ZgsC/g5HtcvspKuGTBiGVrWlFeBvOex71I4nH46/vRQpbYx52KaDTXNipDpwzXyiRs/0KDG4Q2jTjgT96Mt3embnAEzeD7xDGsUH87F9SS+SN+SlBGYThcShFR0ymYZGwC1i2DBuEXSpK8BwWsmvUOWgFMsjle7rw3Rx8akrkBqHJvOsgVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ndoRAQDqEwXsZH8UzjlDh9Wj7CkiAkwv+RCHrWtXTIQ=;
 b=aesoU7dXygQEUdkQmeZA5cldrObB+4ZGu/tun9iUPc5rOR+PpIEBtobffRozK3a9pkkfcgr8YK7kklv+zEltPkniPa6no/VUzsPJAdJ168Kc89DfaJh2jdq5ymUzF0z7I5KtS8qWWUf3ly11Z+H7SmgKIzmIOfHHonudBQZ5eRPpbocN8yy8JswDHIELBknzK6T/pZ6De15FvsyQtUNvVUCKLWlQ9JJcCWdaS4iCpiD3CZKif3TounMWXxr6GDOnHMsIfdZ9oaZOoUbDkDT1ax+ioYg3VF6Zc4yuUA3FQj5LVtDUd9qtlG2cikqN0OvnSLErtw38MqU692TrCkofQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndoRAQDqEwXsZH8UzjlDh9Wj7CkiAkwv+RCHrWtXTIQ=;
 b=qBfZBOnu4BCZkyhBOLG+yeAbkMZXcIcU/+SsbB92x5J0j7IjuOcMJ/IDkboGG4g3Ao9ZOw0cxBLCzcLvhgsZUy2zXgSKNm6dS5LbUo6DevMGNfky4ghR5T3JNl+y29F7kIxvIPyyZ4qxRO+PylcBXXLTUISMirBse6jTvODBxvRo8QQDi92CedUWLWvSMgWT+p5JguDDAh/OalDS+EZVDsLNz2S42/0nqdV8bX2SzhVw7VR4podVmpUqSqr4z8TpQ6rxlu2iWkXKffRA/qt9t7EM1QOM5i+aWadN0MJMNGlMdzjC4bBidhXf2vdGA/BNov9hTwDz1QacmOB6/ZDssQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SA1PR12MB6848.namprd12.prod.outlook.com
 (2603:10b6:806:25f::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Thu, 22 Oct
 2026 13:11:42 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.016; Thu, 22 Oct 2026
 13:11:42 +0000
Date: Thu, 22 Oct 2026 10:11:41 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, Jiri Pirko <jiri@resnulli.us>,
	Dionna Glaze <drdeeglaze@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org,
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com,
	aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com,
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com,
	ankita@nvidia.com, suzuki.poulose@arm.com, kas@kernel.org,
	rick.p.edgecombe@intel.com, elena.reshetova@intel.com,
	dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com,
	roberto.sassu@huawei.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <20261022131141.GD3008132@nvidia.com>
References: <atPgqROZZxnihYfC@kernel.org>
 <20261017231007.GP13920@nvidia.com>
 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
 <atX9fugGUsI0hGcA@FV6GYCPJ69>
 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
 <20261019225658.GS13920@nvidia.com>
 <ath4vwt7KGyDXKVJ@FV6GYCPJ69>
 <103486a4a29ecc7b72940dd051c00ae59266bd05.camel@linux.ibm.com>
 <20261021143529.GP3008132@nvidia.com>
 <95b895522bb314187ac1cdc5d0c143c01f0705a9.camel@HansenPartnership.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95b895522bb314187ac1cdc5d0c143c01f0705a9.camel@HansenPartnership.com>
X-ClientProxiedBy: BL0PR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:208:91::38) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|SA1PR12MB6848:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c370204-11d9-4183-bf14-08df303e0411
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|261009223027099003|261021121427099003|10067099003|56012099006|18002099003|22082099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	P+SPDIy+9J0oKAIcT+bFSkBgHyR8HoidDmYlaHP7i487Kb7OOBJZ/ngNIvqsHozY/PFTRmRl9Qq1JlKAI5qyf8tGu3wHrv9vTo9SEtWqRB7JF96WKJKvCiOul2U+2qi73Djr76PueHcweJP8kr4G9wcLUvfVt0+mQKUFkyGrQ3l2vYOzPw9gBHcfcJ0RfjbJuvXPRBZZrxGJQKebAi7DJtDmpmIIHaW1FIbUZ9caDBpcX+xZy4IZPKEQhHD5FXKvRUrnMjSQhz9x84J4jH5nHPMnWpU5TKXhZpAe9dryO78ev6Lbcxy+eLfd022Ac4c+CAwaHLQQtB+iF5QvR1Ksk6aQTYMA9EWqCqxkTW+ywOPIIFgEyd90GqPjEwZrj+fZy9AzXQ8+iz1yJZBnF668at11hMwBN/H66juNEn/otClbQ2fs1qGwElwkAlrMQnCTD5ARJ4SuV+EHuN0Bh04pDQyro8G4dfBs34leu/RqNnkeCehOM6OV7MAboY0FTOQknnvIXfoVzoh2b9VsNBvg0Y5UcHdx3U8NjOgLIEb3ms570N4YfW0kuGGjaxBf0DgkALLcnEANuNnO3NZwM6RunWhTa+Dp4IEDo33RDO99ULSGKb7Qr1DiBbQT/Y/Srf7RmpBw5VYe/l0HEDpPgGY+Ev/b0N9zOq5gArWjdvhKoRU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(261009223027099003)(261021121427099003)(10067099003)(56012099006)(18002099003)(22082099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eFYv58T45ki9j2XpduVPRUIt7LKbxUI30PxwnOhs4MB1OHqXjwCzbgrcriP/?=
 =?us-ascii?Q?Gf9hLkBpeiKnsq5tL+G6X1r//6ofBBT2q33Nt6xKVmF4o+nHGrdcoPtzM0zW?=
 =?us-ascii?Q?LJr5KzqazvkkzguRrS9J3/ledJK1tjOwAgSO5peHJPhAqhdX6nrE+PgPkOF1?=
 =?us-ascii?Q?eDxJeHZOWUzmbk27GUxEsbN4o9ew+MpzA2IuNP5pEgrTs+32vAkxAWTzA77n?=
 =?us-ascii?Q?8Mc2F8f6YlypbUoYaIF+pNauO8+hUWbbSSh0HPoSiNm4tObb4k0JDFneEMz2?=
 =?us-ascii?Q?kk39DLxyfyVS8xEOZftkGLdnLq5OjPzsSa5Fi/XMck4xI1SVv3fS6zNzFTa8?=
 =?us-ascii?Q?tNKB0Sn3kQRQLB6H4JnuMgEAI+q/sYLcDP23MACJC78ONbeyi52mv+5Va4ZE?=
 =?us-ascii?Q?49K4XTgeST1Ol+neotGjIS09XJWGsapHD5EHTPUqE8jIEmgxCK1jd7WF+5iY?=
 =?us-ascii?Q?AeCE/1cyimZZTxwlvxMJ4GgpcXZj+oGT1z0eYafEVu7S1N8ph6XuAtp8cdzS?=
 =?us-ascii?Q?IkpbrvEuiiu5OYcxbG6HhwAbSCv+wkn9hzGBBgUXFV7E/mECgadwcF7bgN/K?=
 =?us-ascii?Q?ohIEoN10LoiyReU/0MyBHKO8dvbqfDz3l6x6tYN4jjtkmOQ5kTd3Tj+yp1UQ?=
 =?us-ascii?Q?d9GTMwIsGe6QG+pz5Rls9BZKHRU5oelIa4j2P3ZD5Ff8vRpRcG4nl0YTNcxf?=
 =?us-ascii?Q?rpY1ZuJqa9BdNFM1ekVH11SFEpyrNdrULydrARjmC+qOCAsPstKoknnpYHj5?=
 =?us-ascii?Q?+8vP43tVOwfGPOEmsr3kC5ogrvEbOeAeWBnSdaw0oZvmGlIxNNMPfu3tNCyy?=
 =?us-ascii?Q?1tOe/s0SGDLvzeLTbomqvH/ZSPrmrAoOjUNNtIocr+jyGPU6by1pjSAyPYNf?=
 =?us-ascii?Q?8AfFVeWvdU2xIBkEVm5HM+BA6/BDGZUvzRNuKeLHLKKvM10vtiw7hHROBSvs?=
 =?us-ascii?Q?QXKFahDhMbM9i7/1lnTJcpV9OBp+Y2pYFNFhnYdomyYbyfVwiahO7u7wnoze?=
 =?us-ascii?Q?hEzyaLRzYfTjJPEx0c36WquLQmvk4q8jYAp/JniX10Iure0idg8ZWGRmB3qq?=
 =?us-ascii?Q?HGA8ibI+Wu8dJ/DWS9UeKdD87BhxACjh9jk7KBRsetgZmUs9o2Zi/auVbAGE?=
 =?us-ascii?Q?PTELK62N/d+vOjZJkEfDAf6SAlu6es5oPeP0LIUv87w+FsEHprLvWAzKJU4t?=
 =?us-ascii?Q?IkzkSp7+exGOt8rOZUlCkYZsTLh54hYbalzmwI+eryp8p1owFNkCrG3Aej4w?=
 =?us-ascii?Q?ymyS+XjrODFUhqFXX9vT0afL3/27ClVzKah8hC6r3hEPlAqk/+VBCgh1miE3?=
 =?us-ascii?Q?6dH4MJymY5z6uxXEwqRhH//I8/VqaE1EmBZrKVsARjMar4veFDXWnsmeZRZF?=
 =?us-ascii?Q?m5dD85YDu1pGskkcftLxnI2JG1/cFz0GvYc/67ZGMDNidr/xWjo67YBsnYuL?=
 =?us-ascii?Q?UD+8YJmDz09mtaSN8z0E2AxFKqmFuUyRCkqPKYo3ed/8OcS4dpcFHwkxmY8g?=
 =?us-ascii?Q?rmiWwq9b0oA7QaKccMPRYHuKB0YUB1gh/xTUFKwtxH25EMFrSQCIlz12DAlP?=
 =?us-ascii?Q?+enFQx2QK+BOfUSWM1TF9fn4f/1OEFsneu9Q1v9T9g3YUfM8ErVLAi06tjXD?=
 =?us-ascii?Q?1bC+BAvybtvMob0acu2e1FviIrTQ74Q4PMaGzL9euRlLVcwzceFWiJ0g2sd1?=
 =?us-ascii?Q?RYskJIh1Z+Wq51Sbto8UpHtKWfqsKTFgb2BiRc4Kf+1rbPrp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c370204-11d9-4183-bf14-08df303e0411
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 13:11:42.5440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8q6Nn8tWKUn1EYWJHhw+DHDRR0b5InKaENPE7+Eoc5C4qJodInM87hRlR9nPOftX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6848

On Thu, Oct 22, 2026 at 08:26:29AM -0400, James Bottomley wrote:
> On Wed, 2026-10-21 at 11:35 -0300, Jason Gunthorpe wrote:
> > Maybe we can build a multiplexed scheme on the spare? I don't know.
> 
> Direct sharing of PCRs is certainly possible, but not in all
> circumstances. To share a log, each logging entity must record entries
> in such a way that the relying party can disentangle them with absolute
> certainty.  The problem with the latter is that both the TCG and the
> IMA log format have unmeasured (or advisory) log entries.  You can fool
> a relying party trying to disentangle a combined log simply by
> converting the advisory entry of one logging entity to being the
> advisory entry of another and bingo, it disappears from the other log.

My understanding was the unmeasured entries exist only to help the
verifier understand the log structure, and what data is in the
log. Like you might record a firmware version so that the verifier can
locate the reference measurement.

If they are corrupted somehow then the verifier should fail to
understand or reconstruct the log and fail the verification. 

It seems to me if corrupting them in any way compromises the
verification then that's a pretty catastrophic bug in the verifier..

Though I fully agree with the sentiment, sharing a PCR requires a
robust scheme for the verifier to recover everything. If we ever build
sharing we may not end up using TCG log format.

> trust the entity provisioning and running the vTPM.  The closest we
> come to having an autonomously attested vTPM is the SVSM-vTPM in SEV-
> SNP which can give an attestation of the ephemeral EK tied to the
> launch measurement of the enclave.

I understood the AMD approach a little differently.. The verifier gets
a signed token from the CVM's ROT (in ARM terms the realm token) which
has a hash that includes all the vTPM code (launch measurement), and
the token's report_data/challange/nonce is a hash of the random EK the
vTPM code built at boot.

So the verifier can construct a chain from ROT, to the VTPM code, to
the EK, to the quote from the vTPM, to the PCRs.

One of the things we need to check in this series is how well it
represents the AMD scheme where we have the ROT signing lots of
different things depending on the GUID..

Jason
