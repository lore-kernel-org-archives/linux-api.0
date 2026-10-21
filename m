Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792594205;
	b=baaJr84oVFNDzmxLkTC3QGARh4LhLa0XWzKijtibYNxatTSKsNhNFjVGS+I2q4qkVDv6
	 E4BcvKq1QILjgN02W1j+BozjrzldjkK2rRYRTtzRwRDh+BNpC+aH03OstcTX2U0W0c0BM
	 N/JZYrw60ZGwP0LbqzCNCEUidJ2vhuYFQnLKG6tx+GcGfwnzCmKgC0DFrCGuKkMIwR525
	 rlV6Oe1EicY+8kSMvOiKMLKKnBK3fudambS/Lt8/0FviJhp52SwA5rMrQ7gy1/7L7M2Yn
	 rrksMU94AnRUlaY+ZZoNIobH7LcoekvTQkRTbW1fIiCnMcy1ZDzRgCPqVAa2hyjmxlw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792594205;
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
	bh=aCJ/QWSvXd9fbvseZ83+F3AbtyCHKU0OXrRiY4OPwRU=;
	b=NRNIePpsG+5eFyqRw7C8JEJDNTO8NW2AwZ9uvMhG7/g1fS0KOXm3T147K8bv0OucIks+
	 P48dPZJFDxMB3l0kl2+0WHWJXCigRXe/jv3rQGBXhnPwucDYh3owIoGkgdHMLU8RVteuY
	 HROleRdi4SWz/K3pB04jxP3xvp4GtZwgKIe1E4u/LTj4MpicRW5h0IbeI2nsKxbAsMHnr
	 jJ9vXN8RE/jtTxdDqmiOQQYDWuLYKjFDHz94G9X6Y26YtV7XY3CZIxR9T872rnEqVO4Ej
	 /sWloRdKrUA+pyx3pSDacK5Nwt/IIROxCEWC5zOsIikEO0Lg4YM3/4GI8rMpRFf14ZQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YwSoYSVW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.43
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012043.outbound.protection.outlook.com [40.93.195.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D701606A319;
	Wed, 21 Oct 2026 14:50:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D701606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YwSoYSVW
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e8uXtkRWxuKE+JN5i4rxSGVjuYmYJf19Eh/6DHBwFoYG+15lHi3qOJuUiqLGkzS29esyZz31MZuP+txsvVukM7UqCDFKI1qupMwggSda1h6HskFGeYlVXN6xqq7QsCJVxMOuY+/2hJPOuTZZDu2iot9rP+7lUBJvwfctkpYvXYavNO0wvbrpLJJMS9efxt0EqMVtDqJK5LRb3vh9VARRWISf6NqFuvyi15FWM+SUXpMfOTE5+5If7dbufNMglXm4SR+IqS1IFA8hRZ/0MAxfEFnwXqtuN+r/nuNUxi13Zl2biIxAEapCUkz7AAO2BVntxoALVndzE4hDw+izEX6eDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aCJ/QWSvXd9fbvseZ83+F3AbtyCHKU0OXrRiY4OPwRU=;
 b=MB6fTS/HqFVGls/FJ5ae0QX2aHEIRPsrr1Jiy/vUGdVBXHTxL4mgemHGi+KUrnojMmFYISiAlj2xKdShbonFX8IBdH74YGlzgEEQmalo6zK4oXAhJ5SRuxjKhWcLfkKr2lyrGWim93nOzdIRk2nzbU3rPdOb7SgWxcVXnlA5dChstMXaYIC/l4unyuaMj2oy188nPF7Xo9MOYRns3HhSwHeZJ/8a6+KGc/3z6ifhgM4YLSNig46dg01fSH8zy93SKeIq9ezUHlgXGMl4ekmnfppgh3b1wpglsnKh4MEw5Zhe6zuCEgaFnsSIP2eIZZln7D2NehKtzXGZlU+qi3DHKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCJ/QWSvXd9fbvseZ83+F3AbtyCHKU0OXrRiY4OPwRU=;
 b=YwSoYSVWT4alG0dDXKheAONZQrIqydKUjJT+GGb8MpvPApJkDZsuZsQ8itDNczEHHkSum0nplNplqmxmmWgDzaqtFZphDwDqrsBlCiR0/Nw73mix7bkzoW91jED37AvOGR3AXzJsyojClnxd1oYUJ3YSvgj4Q0Cxq0qS3UpVtTqs04WlhrhxM7akblIb6F2inoZN4oHLvwQYFLnjwsApEFcgj4ApR1PYdDcFGuNsWC8jUSPzULxTql8YvXDCgZF3lUbGwlpxjtSutFpkTFjOGJtOAZlMNQRI2SP+Hb9ekC9XogUbLZY8GnjAO53XTBXJ10sVG4Qp3qQ2IsOujvP6Dg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DSWPR12MB999154.namprd12.prod.outlook.com
 (2603:10b6:8:36e::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 14:49:52 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 14:49:52 +0000
Date: Wed, 21 Oct 2026 11:49:51 -0300
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
Message-ID: <20261021144951.GR3008132@nvidia.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-14-jiri@resnulli.us>
 <179245258505.58760.3972297562218204862.b4-review@b4>
 <atjEgLYpgbZNzfkZ@FV6GYCPJ69>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atjEgLYpgbZNzfkZ@FV6GYCPJ69>
X-ClientProxiedBy: YT1PR01CA0094.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::33) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DSWPR12MB999154:EE_
X-MS-Office365-Filtering-Correlation-Id: f36097d9-8b5f-43a5-2fc8-08df2f829059
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|6133799003|18002099003|22082099003|10067099003|11063799006|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	QBzd2WnrSM5dsr437FD7kEx91w5p/LImssnwaHlPPsedInv7xBqoHZ6xU/QrFnMN0AS5IfB0DYF5dkQ9eRxAZHYvTke2OSCmwWUqAEUIbA1Gh9oYi732H1KJM/GYh23MjNRgrZmAJuxv/f4fuCczF2TfjGUpTeECcCzav4neoD5X1xqakA18QLW5Puy5VkVA2GrsqhlmmqOJhIMzc1iX8SuzZ9ObbKokegWsE1HnijQg8O5l+09PwDdwJffLognmJPktBb6BWDFN9jnbL/0FtYzbp65Du9/QhjUHt5oi2AYMFBMgXEn+8HhTP7eHibQIC2l57rvernP2arSxAV5uY5INWSeA/iImZ9ToIduvZOInh5YXuqzLDvIMEjv4w118xploOf6o/TSunk94nCXKF2Rl3TduMXbCylynkM/W3e1Lnw5moPRZmoR6ViZOW8dAo/9JwOCnjiDx7j+efBLilIgSviyAkusUC59MyY71Iett5XaxwMyRQ/n+7/NvydsLU/5MpZQ4nP3c7ri3m67JtW7FpNQADEwEQ9bQhJ6smrC3Q1E5y0Ww1cplyC7nycrl+tiq5aCHgiBGkrqWKn51M9T+a0eEQROLQ2CD3rrbLbi8q1Saf8um20nZokg58DeKkG1vXUrsSin7WBdNHxckUSHqLFuByRrVwJxKjCLdLq8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(6133799003)(18002099003)(22082099003)(10067099003)(11063799006)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c4wvjnN3XTiZFmL4//S9CkAMXMLWJo3BccpPAzflJtwdrNSRClzXYx7nCmD2?=
 =?us-ascii?Q?Hnrb6nJ6UKg0E3e9XQm5TxScn4CHZPVqyP5vi9fA+7P/HTH75nAIEfOoh/ub?=
 =?us-ascii?Q?UwaZinurWVuehdkmg5NxfJUBj1v+qlShHiyk1Kj41oTn0uSGtMmzG0yyz5Lm?=
 =?us-ascii?Q?UuGygmj1V+huz4/NoXsD8yBxiDqTFSM1aLB/E92poxRQfJ75CKAeO1zZYDkm?=
 =?us-ascii?Q?k9OSGQ+uQlE3e8hgvj+znMAeJOaLnXfeh4v7t/ygPP1k0xxJRdlBRN85ylVW?=
 =?us-ascii?Q?j6o0bMN/IuScLRLN7EAeJIeYjjVKkjsZsW5CqBsjJeqxibWnPouXBPDRzcUr?=
 =?us-ascii?Q?H9X+Jy9rLpxZxmPnvCuwpQxlMxN5gykvHSGDj8OCM8uIXMqiGn4nlCMWpHrU?=
 =?us-ascii?Q?gI9RvPYpPS7US7rUmyALZWrM/kxirb2b1UVO/Mc3WVUf+W2k0FQ1RgiplypS?=
 =?us-ascii?Q?Jo9etxpavDzZ7uNyNChpS3jbGKp/+2VmWavG1If1HYwmiuxMtmt7J7smKEb+?=
 =?us-ascii?Q?c2RDSq98MRtTZX52U0FTPU6JNPO2BNMZTjUr3at6a1/6yYqSeGTjfARLqbCy?=
 =?us-ascii?Q?mIqdduPeLf37XVPO8TmryCPeY/VZKZwhzQl+rjQN/5mQ47f9I4l+IxS2LA/L?=
 =?us-ascii?Q?5mkiZJKyi6tuWLLfj3oDxNrJPZtGj2FhU9EpF6ZAitgNKXMXwaPv6DDBVeW/?=
 =?us-ascii?Q?LPZKjZIHy31XL6J7V1mbtG0ewLTJfeZAqNeT6BV2oZySZxANtbOY9JTpSHNW?=
 =?us-ascii?Q?q7u4c4vVGV7Sc6Kr2ai/9Fc9WtAbyPSnqlh7RSwh0UvSbFoSfUR1FMNTpHwL?=
 =?us-ascii?Q?H9mlD3g2DwrjaN9BiYvQZcRzKHc/ot33UChANfEdrT2U9CHR2b8Q43omCjIX?=
 =?us-ascii?Q?U8WR71kWBx6Fudtvvq/m8AWED5L23flK71HJdtosUCcRLQGDLtyrmyWsZlQj?=
 =?us-ascii?Q?6Qgca9E7L9JMfbO/2SWk71AEMCcbwJalaMaFyhWkTc3xQwowfaBVn3oLn+jL?=
 =?us-ascii?Q?/AqZvD31TCtmHtNpvvDSgbr9b0Csyitj0yGvifpy4kbPzWZJ2z6RBP6x1W/d?=
 =?us-ascii?Q?5JQPwpxrplfQvk84RMrS7jWOxMHSgoKhmYp5Kwgirmu0Di9CBiiAsYpWsO4M?=
 =?us-ascii?Q?XYNBw5zbw5DlLJE7uG+5lbeLs99JkNrK7ew6ys6hGyPyubW9RC7r5Htpqj4o?=
 =?us-ascii?Q?BVfydRoGyuCZ9yCZyXCyF8SkmOoNk94kD0JQwhoBIyvNUzgIQUuE+1yMeIT5?=
 =?us-ascii?Q?v95NwAOqgD/k+ftDQHuDMudmqNWgy2z0zcLyPj0p4rvON0puapJ9/LpBnyt0?=
 =?us-ascii?Q?EINov1ebDWMrvJ5AgWPDnPCYPoLfx5dUaNj8ELJrnYzmwxXK0leIXsqPWNce?=
 =?us-ascii?Q?EcJ4nDC9e7K6eZuEeDpJ+k6Nrep0cHWTPGgMqEKyEtunh9DA5ktnCzxOKIla?=
 =?us-ascii?Q?jQhZdnCDtK/xOo/k+I646cbH+S/XdQjS+oiXjrauB7cF6y8CBAIO/7W1jmE+?=
 =?us-ascii?Q?PWN4sZAJhGP9eh5EzzI9szoM9nedqWQXIKktoSHOxL5IaOwKCg2cUfpwHfCq?=
 =?us-ascii?Q?lEzlGgQODWi/VrBu/Z9emhhLcY9tKO7coa0eV+NgnbSdT8ydlYQdMwEBDrIn?=
 =?us-ascii?Q?qHaFv7HlyZvR6lNn7LH0vWETBO/W/cixK6njVhyC7Urm0SLwdjprCIeLUR4g?=
 =?us-ascii?Q?x7MUZ0L3VWzeuD/+U5m69p5Wq9dE6+P7wSU32B+5P4wy4uAD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f36097d9-8b5f-43a5-2fc8-08df2f829059
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 14:49:52.4767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WCroOxfJatSWnur/iYHGTtRD7GCkvUIWEUUg2DPoN6xyypf01Pcx7JWf10dPbgXu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR12MB999154

On Wed, Oct 21, 2026 at 04:23:17PM +0200, Jiri Pirko wrote:
> >> +    attr-sets:
> >> +      - name: item-request
> >> +        attrs: item.index
> >> +        optional-attrs:
> >> +          - item.label
> >> +          - item.data
> >> +      - name: item-reply
> >> +        attrs: item.index
> >> +        optional-attrs: item.label
> >> +      - name: items-reply
> >> +        optional-attrs: list.item
> >
> >I haven't quite figured out what attr-sets is about. I think these
> >blocks should have some # comments with more guidance what is going on.
> 
> "group" defines attrs with all the description once. "set" just puts
> together multiple atrrs from multiple groups. Will try to document it
> more clearly.

Maybe also include a explanation why it is like this, how it should be
used, etc.

> >> +
> >> +    ops:
> >> +      - name: item-set
> >> +        type: action
> >> +        optional: true
> >> +        request:
> >> +          attrs: item-request
> >> +      - name: items-dump
> >> +        type: query
> >> +        availability: dynamic
> >> +        pre-post: true
> >> +        reply:
> >> +          attrs: items-reply
> >> +        suggested-reply-length: 4096
> >> +      - name: item-changed
> >> +        type: event
> >> +        reply:
> >> +          attrs: item-reply
> >> +
> >> +An attribute has one payload form: ``type``, ``enum``, ``flags``, ``attrs``, or
> >> +``blob``. An attr set names one message level. ``attrs`` are required and
> >> +``optional-attrs`` are optional. Its bounds and membership are ABI.
> >
> >The attribute first point of view is maybe a little too netlinky, I
> >prefer to think of this as a system call first, with a first class
> >'query' to get a list of things
> >
> >Alot of stuff this is going to deal with won't be the netlink esque
> >'dump a table, set a table' kind of flow, but a bunch of different
> >system calls with arguments.
> 
> 
> Can you elaborate a bit more about this please? I'm not clear about what
> you mean by this. "'query' to get a list of things" sound cryptic to me.
> Are you talking about doc or about family yaml as well?

Just documentation. Netlink sort of evolved from a table row based API
concept into something more complete, but here we are starting more
from a systemcall concept that also has some first class tables too.

Maybe it just isn't clear what the original doc paragraph is trying to
say.

> >> +.. code-block:: c
> >> +
> >> +    int ctlv_example_vendor_details_extension_fill(
> >> +                            void *priv, struct ctlv_op_ctx *ctx,
> >> +                            const struct ctlv_cursor *request,
> >> +                            struct ctlv_cursor *nest)
> >> +    {
> >> +            ctlv_example_vendor_vendor_serial_put(nest,
> >> +                                                   example_serial(priv));
> >> +            return 0;
> >> +    }
> >
> >I suppose this like RDMA and each HW driver using this gets its own
> >full scheme tree that only has its own stuff in it?
> 
> It's the "family". Each child inheriting a subsystem family. It fills
> up the subsystem family defines stubs/extensions. It can add ops too.

I haven't got that far in the patches, but I think it would be good to
spend more time here explaining the fundamentals of how the extension
mechanism is expected to be used..

It looks like RDMA to me where you have some 'common' and some
'driver' parts but at this point in the docs it isn't clear how that
is reached. Like does each driver gets its own family? What is a
'family chain' etc Where is it reported?

> >What about userspace, it "knows" somehow what to do?
> 
> Userspace sees the family chain. It also has ability to do introspection
> seeing right away which op supports with attrs in which nests.

I was hoping the introspection would not be essential to use the
interface..

Jason
