Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.61
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792515179;
	b=4l39WjTU9gz4ePh8CU50hgqIHlErbJa4NgOfgxQ8r84mRjHC1zOmDV8zbtpbGjHcPntI
	 LqTBQ7+JZGOgsDjm/dmnJJo5A1Ajl+N4vnMzjyfoOxwsakLKZ4jBDfHLUgQBU4kabM1Mk
	 kFkTJFll0e4Vx/aLNQ+fMK/Ysl4UAW7c0hN4wWwCMtqAwXbHsOdXSlCDnfGDyWMFtDUyS
	 tBoka5uqqk+6uOCnZKIO0wRmFs/SVYQMaOgkRPm7cFIce6yhhCy1Kwtps4t4biIzMAK5y
	 Npl2aEC3Nl1yKIG4Mh9Uoi1eyIhL6onYy++P2G0tG6pSyQlyS6ux8woCUIy6Cs+3wDw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792515179;
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
	bh=hqqQE1/CsCVoz40XPIKaEuJ8xskcO1J59GVnhJovNHo=;
	b=w8iDuTt8hfpYIBs/LWl8U7Lq/Hgmiqz7e/ihjWLgGrLYjD85egLPNDpqWMgppWuUjKi2
	 oiLlnJ+ymtAt+4YNdUfdwr+UCrP00BNjmHibvo4+/H8m316IJtKzQlFtKiSqSWMYNoo3u
	 /BapMLE7fkT4Ul1ODGerRMlr2Ufx49o9a2L7AjLSYLBK3tX/0VVjHV8AAS9OIwvSLsl+H
	 1yzWgd9ny4KJZBW1qnUfMb1RmF1/K6oaN0jnJkPgKzK5OwKXbg1jRD9nAUJE0bEYRHoSB
	 2AIgeuOml4h09QKIu585nhqyWHYiTsviW1X+LOPQl8UVqZkGGE85PCB5VZ+IF4QgTqA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Ey+Dg2H2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.61
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013061.outbound.protection.outlook.com [40.93.201.61])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8076F60A2629;
	Tue, 20 Oct 2026 16:52:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8076F60A2629
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Ey+Dg2H2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rEs6NOFFqgFGfar3o9KcX0Yp3bMzBFdX1YZAl6rLTXEOY8cxcHtIC7GsyPQodOTEGX/sndXudxwfIgu+oB9Pd3a+dggMofD2dijahdDqD14LRl/peHeubTfrrwcNJFVlXxNvo+gs4O8amjFUk+qOs3Q3hdkDihoEPSkSRrA3rUD8XbIl8B4eb/g7O1rPn944AJ/PVe3MwRt09ara/ZBqOr0Y8HNO2r/m/1+cs8jY6v9OaHtZGkJNQyJRrXHrGX9X5ADyvCppu8SITMi0IXGWsF2ZyIjvjycz9+R0WyYXDHwuV3vAUpubC2kapOPP5F902ArJvjDzg6zHVI7MQkFGhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hqqQE1/CsCVoz40XPIKaEuJ8xskcO1J59GVnhJovNHo=;
 b=x9rEAkVz9Vm0XsfqQ8PNjpIbBJ/y/k8cRo/aMlj6KtBoz+fwRn96f/Lo4n2NbTwSW3DMdb1Gw+2aPnMfcKsGKYxr8ll7Fk8rZrsrjKX0Fpr/4ADd40LVmEoqAdK2nPRTrQHCazOYWbC/YYNYQcaB/Mv4BI38I4wmZkTG433muU37fxHz737CEiFCmMcuUiKV4WSTmAQ8ELgiNI/eKiON0IsuTTHIFdN9PXGahUMAouU5v3wTdthmKQ/KfXassZ+iTss0PedvKFXD+voIegnrhSurzH4aK4v8HWh/530juHDPnQ+wGjngXBccCcIhXlqIlcU+qKgae3Ki4AmgNDbdCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hqqQE1/CsCVoz40XPIKaEuJ8xskcO1J59GVnhJovNHo=;
 b=Ey+Dg2H2ltwY90Taj6FkTBfFEn0uErusEsLHn7NLd+BdAzMG1mBT8KSsI+V99nfibjA1VxQY6njpnAURC/q/7f+Cy3Our1f/8yJVT+9rnMkLrXai7hAhA1bPw7/pcYJiJ0DwjuY4aL1IcJ4be84K5P0iHgC6Y9bsvY1yi2r5aMGbYMcQWlkXdpFGiD0TNnpiPlAbzZlWfjDCTK6x8A0ICXVlCAOYYIn3rgkLVfOtww/bcGxFwaRi2vRuCi5taUqWd3jfFO+DO8gH829RL+ph1NkZmzn/dmkBH/9ywdpF9w61uneWsz1C+EQ8uY8CFGHLJ4oTzc6MepY+AWx7ZnUpAw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA0PR12MB7530.namprd12.prod.outlook.com
 (2603:10b6:208:440::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Tue, 20 Oct
 2026 16:52:53 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.012; Tue, 20 Oct 2026
 16:52:53 +0000
Date: Tue, 20 Oct 2026 13:52:51 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, Dionna Glaze <drdeeglaze@gmail.com>,
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
Message-ID: <20261020165251.GG3008132@nvidia.com>
References: <20261017203407.GM13920@nvidia.com>
 <atPgqROZZxnihYfC@kernel.org>
 <20261017231007.GP13920@nvidia.com>
 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
 <atX9fugGUsI0hGcA@FV6GYCPJ69>
 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
 <a69c7e7ac4fd07a9c375faadc599e96bb8c8534e.camel@linux.ibm.com>
 <20261020140655.GV13920@nvidia.com>
 <aa00515a0f364fea0150cf1550a09d9400e4632f.camel@linux.ibm.com>
 <ateSly15N5mLrM1m@e129823.arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ateSly15N5mLrM1m@e129823.arm.com>
X-ClientProxiedBy: PH8P220CA0063.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:2d9::27) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA0PR12MB7530:EE_
X-MS-Office365-Filtering-Correlation-Id: 894aa23c-4951-4282-fcba-08df2eca9570
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|10067099003|22082099003|18002099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	klyjVuvOOKed6SI+1zW07bmD+qhTQNQOm2MKpCxVNURup5ZenocwyagWmxuWJ1XuCYt8K5U2+YvfG9UkJUQjo0RQMApctf/GXls5UCptIsOIPM91rRekgig+JuD6gUntjvGrdiJlBKotfHGl9lCqBxOFAfaF5j0avf0hJ/2SufFceg56evQqiQAMy7X0tmtLVBAkc59d25TW4dvHUz2rITqXOypcIbJSj4F1Ge8ZTQQ9QGwdDlEZNiVkhCBlFWB0wKkfRxSqQvk00hCwk60pj16f5X03EuFBR+N3HUXqDfCdlnKPKiFWNaXUpzJPrwTRTV7k+enyn1Q7SDeOXS4Q/9AxKDHUVWUIBO9XxPwyZvl1LcZqTNXZ6vbMKvBTxnZBbBhnsW8eGNlfMKXZoX9/utimGsHX0sXlAKY/wMycEmz3lUkmuEyLL6ElUE6OhW5pvdfiWtS3H5tCDaUSDGdn8Hi1JEXSL4HhMckhU7IWee6OJSnmBoBQxYDV+f80+1dN3BxVWVwSI7PcPtalAogS9hZWZ6qyirzsz86kcpwXtGNmLq2xlmWnve7RUCAKEcqeKpAGET9zdarYiOlEHxoho83UNfPuLJ6+dEjLP72xvs9vX9nBCrHWUfTXLZebWioNkdNiTL6bkPNN6Gma8pnqRU6mK54+GW+mvevSTia8TYk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(10067099003)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b+nqCQrKIEafq7FwqGFdI8fcZWUh+/nguuSeMUVB3+hW6JlVSwi5E9b2Am4Z?=
 =?us-ascii?Q?3syEfUmmYDiUgaHrnXHKQJxhXPZPDbylaHYY3yaEhB7G5oIy/Un7Q/zFqcVX?=
 =?us-ascii?Q?kI+rizRoTd5Awm+yHTKZZ+oTS/EaxoTqyqEpZG8YhnvJ/QSgB541f4r/k6i4?=
 =?us-ascii?Q?UladINnvxflYIVxVsINwFTcNv7XVQQD8Ajc1PenA58fYhArdFpipVlgZpKtE?=
 =?us-ascii?Q?3MbpQVXfsj06QQkLkczJjEN5Pz6sB19xjjc2mQoeQ/fieQu+mMo7FiM2KChm?=
 =?us-ascii?Q?Jo7HtwCMxYgydjP1G6zUsIWeZvDijbCa9LS7/coumBCqWgF6o37Umgp+z8na?=
 =?us-ascii?Q?U8usNoBYUltgpikxFAijnQy+rSpLUT8upoUJePcfanL/tUn3fye5rtQWPJ5m?=
 =?us-ascii?Q?QR3XnFyp3MghCtX3q1yGge9shNa1hreMeV/HbogsM7xgAU9nmsRxi1Go4Z6k?=
 =?us-ascii?Q?cZMWf/Y53u2W6xDry5FhSz9dLm1jAxPeSjThPdVNbj5OSIH3AdAxJd/IhKR3?=
 =?us-ascii?Q?50XoSCkFFeTRmUlaCXSVEgKZqYfHAcqoHqKFtCkLEfvfgjhwN3gXuJVuWSQP?=
 =?us-ascii?Q?kQc1qTfJoxIpMW6T8F/VS/0vfut6dF0/neDpIf70pEVLWu0oPoWrgMpoNgND?=
 =?us-ascii?Q?sek+wez48U3fvk24bl9wkTxgHMjcOqXP68TvFjuD2Rh3AIlGGzuaRGCUDI7q?=
 =?us-ascii?Q?H0aEgHExEHRbYsIM2qH3/5mUYJdcYrojtzEDhHNxkGLMJPUA+GitPA6tMk44?=
 =?us-ascii?Q?7W3gwfv42/8+6dLyeN3FIfyJ7ErfrC0ErIRPhN38NanUiLcCZmrw94BdxwVN?=
 =?us-ascii?Q?zhl20WY/IAbSVzFTPuIJ6DsCUtizRNmEpJvFqqX/z5AhYmOp4c9K/Jai6G5/?=
 =?us-ascii?Q?YeVt39ybLR1O/PjC3nymiquQOtxoRP8mZyIxVnPClzwM6XOPT5FJdUYdlm9P?=
 =?us-ascii?Q?ccafhpeysQ5NK0Kl5PGbY+ULD8mrnwNASkT/LGNj5HKaB3D6noqll8bDJt8E?=
 =?us-ascii?Q?jfqFTjNQ8OLyJebuc7u39CIh07dZRB4KFYOkAOv2CzGimP2rxb5ps4rtLluz?=
 =?us-ascii?Q?2ofVNEVREtJv8RLApocsGIRrI9OeFlyqc4tKqh9Wo1qhan/wGIQ68qDxjvmA?=
 =?us-ascii?Q?qbUuqZCnGWlcJ+rLWikn6Tww1sM8cQ8+GjRijYGmQv6S0SaMouFwWrMl4sg2?=
 =?us-ascii?Q?S+u/k/Wj7InAuD4qneoT4xy1E3MAcIFJjCRgxSqZsBwOKqctF1Lg/UVpKzMM?=
 =?us-ascii?Q?fO6fvEUriSC4sJPQvD4t+/wcbfDd/6jEXDM2rzglGLCJ0ZA9++gkjNJqDFiZ?=
 =?us-ascii?Q?M8Zop3g4tdQW6lnaH1DP8QKqwWCLIuOxjVfCx9Tx2wvk8l/dXBUa5jMI5CWD?=
 =?us-ascii?Q?tCJfXmpRtENU+TEIsrtBrxtP4hyn7fD9fge9SWlSpqlnYtZbIRWqck+fGsv4?=
 =?us-ascii?Q?qf/HmGDkKuJEgWzqs7nA6tpRX4xxapkRJF18a2nz9ekeaXfFxGcebQ7aO/hx?=
 =?us-ascii?Q?of/NxtoIyXhY1lT5Uuh3ngnqoAkDtTUEMRBo9ShrnfTu0MZbaFOljbGRZhBp?=
 =?us-ascii?Q?qMNUEb76F9r4LtvAxkCyEH4zqEgE/iqSggS2kycdQVtocjS6tjMtSIkk07HP?=
 =?us-ascii?Q?xDiGqla68XfkHtoLGy4hrhqL0UsGoCPRmm8LYS1hCpg4SxVR8JDfYs15FopZ?=
 =?us-ascii?Q?d41zaMWR9LApVQIh8iasJZJcNXtqNd2jw+fZwm5aPKhGWKyx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 894aa23c-4951-4282-fcba-08df2eca9570
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 16:52:53.6336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SeAIaoZaESG5xSa2pvTdxF47Ljc/NCkMJ1R8fhCj2eGaEj4fwk9HvabNtbNm6lSr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7530

On Tue, Oct 20, 2026 at 05:11:03PM +0100, Yeoreum Yun wrote:
> But, I have a related concern about deferred probing of RoT devices.
> 
> For example, if TPM probing is deferred until after the attestation
> subsystem has been initialized, how would the subsystem handle the
> TPM becoming available later (This is reason for
> IMA_INIT_LATE_SYNC).

I don't think it would be any different, the mechanism for TPM would
become generalized and apply to any attestation driver.

This series doesn't attempt to do that flow yet, moving ima over and
dealing with this is another series :)

Jason
