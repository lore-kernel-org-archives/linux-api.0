Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795004483;
	b=CNWd5IJqCE2w1rRjaBKRhbAWTwE13VWK+EnncVFR3pQGRx0r4jrM2k+b3vgz8HGQJEJW
	 wpPe7TTwcOTFq8iCIACe5BN77pUmNLCfkskGmgpdXObSpLy1OVqS0fd+8KIFs+B7g9cmB
	 qsCQ+2kve1mc/6vAm7i6JnFv+ZRcLBt1QRvemD1JLbtMoVH8NiczAZ0br/EJjGrvHDCUS
	 NnpkeXD33aBgXdRda4Fq/tqBdtfs26qITNYIF2jh4FRA31rIP/apiPutmrNjDsH7RRuXJ
	 YOS4B8Tm6Y/TodCE6EF2uajqHWKlgDbEjhOPXRUdcMrTlVfz7bGY66y29r3HPJmrprQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795004483;
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
	bh=XU0GeUJQUlxiKqeYrY2/dXr8IdIj18MdgrKdVn7Y04k=;
	b=38Qz1ZQ6eXXkK8Turs5OHMY6V8FKoHnSDtx/yLMUWJgYqncSTtqigEgN1Xmt0k2bfDG6
	 CTplOfSLZ43p68rmvmfclJXj0RshWh3YXqPqK6KYcJkn5bm1iOTF/hDZ6bBVgC4N84EUP
	 nFzSbU33e5prAv5yFVKPgvhNsBtDbhVLoNfDkmTuJgBteyoJ7FjUsu8xo+PLC8HEqinCT
	 pLSRR8NJrmgVbfcTC4wX1Mz0xWDEcaVqSn1Qo/c1K+4dP+fZrOIOiN7qgUvEmMu2kzA0F
	 /Rmkxs3RB81e6zQYL6Kh1nSrev+yXd9ehsm/HzwOT2H6Bt6SAfr/fZLPklK2ttsjw+w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SO1T4TEx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.54
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012054.outbound.protection.outlook.com [40.107.209.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3C2606A31C;
	Wed, 18 Nov 2026 12:21:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F3C2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SO1T4TEx
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o/HCoTXCudgdaYjlELtVNaBjZYdYnHgFDHNKF+PxlOzXUTQbN53fD5lOs85LM079PPokE6zmtOnbDFLzUS40AVZCs6OfVtzlPi+T4tQcs03beyFj/GsCz+Cy3k7C2Pf/3efFSaNyxpPkx/LQLniqSmTDQH5YqvOqLHWExBr3fJGwFJYkkuvTEZ4biYsl8Dc98yXVLOVzdRxfOAtfFyWPww5i9jYABHi9BOMzWk6bJGI4F8YhUXo7sk2blZVYPolDlcIMs0EtrIIf/Y5t2lNEFNSkbAMxUSrJD1ai9F71EPdgHY7CvP5PKuQbqLows+EEM0HQVpRhhoyoaD8jePYYSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XU0GeUJQUlxiKqeYrY2/dXr8IdIj18MdgrKdVn7Y04k=;
 b=xuJ1kYDsleyx9TfBuzMvnGdKuLJ8xPmI98sROcu6coq5Haa+QZL9t4qyal+nqOKNCSzvd/WgYmIHxX0bqB+LLmEb1+cI1aATEs7XoKkhKGz85OUgenPSMhsDUvKrm5YK7JtGKmNOfdRutEGXllZmWJBQ/7taes6qnLLydHIQEjp1D3Jt9fuIsarjn5GttII5TzHlL98VqiZRMhYqdRPsIIPyFhpZhrUh90UIXhp1mll8mGybVHWNEySNI2OYSC+26wo0UKoPdRvTcy6VhegC8Ff+8ih9CpbluCcBdMXsJzZ6nCQ4Igw3OjLGdWuX+yPn4Ev7Lhi8BUhL1NK3GswFHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XU0GeUJQUlxiKqeYrY2/dXr8IdIj18MdgrKdVn7Y04k=;
 b=SO1T4TExVokrtWedey6347Sj9L0G4IGVBM8hIo7Dq7gisFMTbsAqA0v4jKoFdC7xmxPzozSNaJgsWDEnCK5qhhm/6ztdPGxxjIO3WNfQPQDz6K4NN9G6qRMLBXGdZ6GPFx0qF90+lFtVZRX+bWxv9fLnfYYfRlCv5/OlR4f2UBeH07Idcij31bKxfid1LLDk7g2r/qbg1+DG5dmDDVtSZhBL9hn9FYOOgnLZ2A9hpwfZEoOKT1W9F6qkJy8+F61nGveT4BqyAAh69CZ5jGGe1Fmb0BV82rep/BkQ9ORzMdIRA9frKI6EzFSyYavXW/l+0ogEWEmIhrwQEwiltSaIng==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9407.namprd12.prod.outlook.com (2603:10b6:408:1f9::13)
 by DS5PR12MB590516.namprd12.prod.outlook.com (2603:10b6:8:47d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 12:21:19 +0000
Received: from LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96]) by LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96%4]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 12:21:19 +0000
Date: Wed, 18 Nov 2026 14:21:10 +0200
From: Ido Schimmel <idosch@nvidia.com>
To: Yuen Su <zypulsecore@gmail.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
	Stephen Hemminger <stephen@networkplumber.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: Re: [PATCH net 1/2] ipv4: accept nexthop dump attributes in route
 deletes
Message-ID: <20261118122110.GA1179460@shredder>
References: <20261118084510.332821-1-zypulsecore@gmail.com>
 <20261118084510.332821-2-zypulsecore@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118084510.332821-2-zypulsecore@gmail.com>
X-ClientProxiedBy: TL2P290CA0005.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::15) To LV8PR12MB9407.namprd12.prod.outlook.com
 (2603:10b6:408:1f9::13)
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
X-MS-TrafficTypeDiagnostic: LV8PR12MB9407:EE_|DS5PR12MB590516:EE_
X-MS-Office365-Filtering-Correlation-Id: b02c382d-9714-4443-fde4-08df456e7300
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|261021123027099003|261021135927099003|10067099003|261022075727099003|11063799006|56012099006|4143699003|261026140227099003|261028144727099003|261021121427099003|261022105027099003|261026121527099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	hW40p0tgpjRaX4KfLP82OKp0zWX6sWd7GvPW17AM2Vunh/unWmpAfZfcguHo8w3sU9Ncp0wED5Fc5M2gsA/QUM53zg53JsVsqY9wKYzL096paAUJeoqoH6Jqie8jc0U22iwAuMxy7eGo8+Ho0srYpOD0hfAwNeRsMYBytxUFeJsJLjt3vDlGCFz59LJlQ46axdpfHxp5B7s5wmSgAKfq7UMETyNL0z88u0ZkFjodw0XyXeYQVzO2PKhCKq3qtlHYtk0IVSQkpa7mho0v794BhTNKJ9IM79fswRo3bAnkkmrQw1qY8S5chRZHBzKjD8MmNm4II912mXwjzw37Nk0K0cL42gzEJXDPjDyTW8TobyDV3LnR2Ywg0XYsCVx297oWPALYlVRRinDp39QKHA3BTKAgesKfT500I5XaA2yHCkChVDXJtuCBhdul+TvDslx4Rpqfe8I+/Y8eeLehDGvxL93V8NllFkvuEQrAqFRZWUeAPHhmLXGumxHr84Qp8tryxwwUPaHaLTn63XkYYahhmqaSn2TbwvAS/s8YxLi+tt04BmpJ7hJ5l+eluNYmtSOCyi0PKVvEKS46/naW+6TME6j8pqjLgJkNse811ymCD0xIozuopoRcf2Mxzl0/KFL4BW7/f+H2npjh7anFCkHWro/tynNZ0ep4hQXps8yomTQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9407.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(261021123027099003)(261021135927099003)(10067099003)(261022075727099003)(11063799006)(56012099006)(4143699003)(261026140227099003)(261028144727099003)(261021121427099003)(261022105027099003)(261026121527099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mP1cXlTjLN4EWCfBcaNqPDp58Ic8FnBQHsCpCGEeLobBNxTZqiRhDSS9FGAf?=
 =?us-ascii?Q?mLuVxRL7rhaWPjxnaWXdRVNuOiWaJZ2nTt+r9qS+XUxm7t6DcGJmczWzQbqx?=
 =?us-ascii?Q?lJX68dlGMMTuJj+LgQLgeS3Ip9L14qlCkK6l3C3ocbU4kyxkCjI+kPiQNFCg?=
 =?us-ascii?Q?9WMZD0Z1D7g1ngOaxV9Osy7jpVGozyoex8i4vmof1nku7Ge1E6jmvXJxwjgJ?=
 =?us-ascii?Q?F/J9J7lB/QYeKvPqwZJzB/H26+xL950BfAZbACX3vvC0QPvrNNZnVWXDqPyp?=
 =?us-ascii?Q?2jOif46/QryCIo1JXo7hbt5Djz2+M9rKP3SnG+1PVsNjzN7/6VJQkjyi+5ZH?=
 =?us-ascii?Q?5nDcSCQzCNX9woFHkyB/bTl2klJU9OH/s7CF+ko3lKZ8TRUOcHD/sMOl3fJD?=
 =?us-ascii?Q?Arm5bq4aF2OKduSlrsbA1uQMYgtOfqRz2N8CI5Qwev7b9Z64VVu4nnocb1TR?=
 =?us-ascii?Q?qDvI6ymm/UuSFsQrKJMIvxxO6LhsUpL/9ThgK32aGNO3L4BaqhWznvLi1R3x?=
 =?us-ascii?Q?6xh1PxwxHkqUBBXyp7FkBE9qMEf2/38QAGfQs4TzQnhH70AAC/AFag8Z+bO3?=
 =?us-ascii?Q?qPDsSPI8ahUXK1++D4vWYH69tGoWvgrhczyEN+1hNY4ehES/zXeKfwL4Uuvn?=
 =?us-ascii?Q?rOKqSx68ZiWFj0KSDBQOJhBM14EzOKDSs1LqGw+dE5jdtdW1VpgimrYtf647?=
 =?us-ascii?Q?EJQ5SzGAV6RsP3+bIsJsTYYcBVNBAKVisFYyNq0ZSJ4pJmMEk30iYewrugZ9?=
 =?us-ascii?Q?8loM5mox8USu6jK7co5al36LZ/imvF2k81YB32+s60CZmb8EHMbVMmP41uUq?=
 =?us-ascii?Q?QR7ZqJOcMvxe54L1TTXU1NpdynJSpfg96uESpQZ1rLvw27Cc+MYPBuEJcBYS?=
 =?us-ascii?Q?XpcI155+LkMmzu3jDHD1DcFrmvt/Y47DIHkt9+pOrfdt7z6qhQ64+SCGQWB6?=
 =?us-ascii?Q?DFViA6RTAcPTzMKZ7615fxTyrKbxenFWGjHpDeduOfVKqXx4Olyou17aGVmU?=
 =?us-ascii?Q?Rv5dzqjy+Tc9OIyO6SWgb0JvKqcpHUVUhJD/B3QRW37iYq/JVz8YMr18Zppe?=
 =?us-ascii?Q?IUg7b3mNmHTsAAbVd8J2QI0FX+ba6tHATHFmHFq//pzki6+TXNF0U6hfmFtu?=
 =?us-ascii?Q?3+X6WT2QlDW6mNwQeuHEu6n7xNE/wxESsvJDKGH3f8zv0yA13MKBdJr+wkUT?=
 =?us-ascii?Q?wGWBsnlDXTE5mmGVFaBHXjuycuYV5JmbbtYKmTkgorBasW4vOA9BV2tRfWLR?=
 =?us-ascii?Q?31F0SLK6FEbBcjVzDQW65VmCn7sMOhD+/f0+lqxhC8uRt3pq3MSa/RKGzF/W?=
 =?us-ascii?Q?tpfzsovdnQ/C7zfQhNF21mZO3v02yfaxw+RtrnVQGzkZZyc5P6dQeepc4vcH?=
 =?us-ascii?Q?1D0kzg/kbSqiWaoL0trSnduChy72qyO8XIoEL3xh7uoFqXKpFMD+UO+EVHKf?=
 =?us-ascii?Q?CShM3b7hJRkpstxUNpR+P4UQZb/DVIPhEfd7//CZ5X9uvZKBiggbwHBBWmLZ?=
 =?us-ascii?Q?NTdHleo2I57sGiWnlS6F+2JcHeKPi9p0J4WeXgZ0WDUf7wm+wvKDKNjC6moL?=
 =?us-ascii?Q?EDDGv5tv2mwzvyP/VraoLtEf4shGNky72/vLomeWM/JK6U7/ocO8UeT2gE7m?=
 =?us-ascii?Q?vPpywudDB7cj0LVaeJs2eWXQ0shvtxS9F2QdB2kFvs4tmXx+/RjOlKrGznzH?=
 =?us-ascii?Q?051gkp1jTg/awExhrW93fomTOvG7jRIZW9ufcpvmfrv8k9thkMnqtwQdQzD6?=
 =?us-ascii?Q?BwIS3zyIEg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b02c382d-9714-4443-fde4-08df456e7300
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9407.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 12:21:19.2133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kJVqZo1a59YHupFMFgbkJFbbN/r4JjTv8SFUkDdufB5JHQOIxrSbwsBejMIzE9yiLRfpdof71502NbqyQFCQNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PR12MB590516

On Wed, Nov 18, 2026 at 04:45:09PM +0800, Yuen Su wrote:
> ip route flush reuses route dump messages as RTM_DELROUTE requests.

That's an iproute2 design choice. Where does it say that the kernel has
to accept netlink messages that it dumped when they are delivered as
requests (potentially with a different type, as in this case:
RTM_NEWROUTE -> RTM_DELROUTE)?

I assume it was implemented this way because it was easy / convenient,
but you can tell that it doesn't make sense by how fragile it is.

Another example (that wasn't accepted):

https://lore.kernel.org/netdev/20260923-lwt-encap-noflag-v1-0-8de7ab6c86e9@gmail.com/

> With nexthop compatibility mode enabled, the dump includes RTA_NH_ID
> alongside expanded nexthop attributes. rtm_to_fib_config() rejects the
> combination with -EINVAL, leaving the routes installed.

OK, but why do you need this compatibility mode in the first place and
you're not simply disabling it like most production systems that are
using nexthop objects?

Note that iproute2 can include the necessary information in route dumps
even when the compatibility mode is disabled (with -d):

# sysctl -wq net.ipv4.nexthop_compat_mode=0
# ip route show
192.0.2.0/24 nhid 1
# ip -d route show
unicast 192.0.2.0/24 nhid 1 proto boot scope global
	nh_info id 1 dev dummy1 scope host proto unspec
# ip nexthop
id 1 dev dummy1 scope host

Is this patch motivated by an actual use case or an LLM report?

> 
> Skip the mutual exclusion check for RTM_DELROUTE. fib_nh_match()
> already uses the ID to match the nexthop when an ID is supplied, so
> the expanded fields do not constrain that match. Keep the validation
> for RTM_NEWROUTE and leave the other delete selectors intact.

This leaves save / restore broken.

> 
> The failure was reproduced while investigating the iproute2 flush
> report below. An unmodified kernel and iproute2 reproduced it without
> fault injection in a fresh network namespace with compatibility mode
> enabled.
> 
>     ip link add d0 type dummy
>     ip link set d0 up
>     ip -4 nexthop add id 101 via 192.0.2.1 dev d0 onlink
>     ip -4 route add 198.51.100.0/24 table 1111 nhid 101 metric 10
>     ip -4 route flush table 1111 metric 10
> 
> Verified the flush and the existing new-route validation in QEMU/KVM.
> The IPv4 compatibility selftest reproduced the failure on the base
> kernel and passed with the fix. The IPv4 group and IPv6 compatibility
> selftests also passed with the fix.
> 
> Codex assisted with isolating the IPv4 delete change, writing the
> regression test and running the QEMU comparisons.
> 
> Fixes: 493ced1ac47c ("ipv4: Allow routes to use nexthop objects")

Not a regression, never worked. If anything it should be targeted at
net-next, but I don't think that such patches should be accepted. The
fix belongs in iproute2.

> Link: https://lists.openwall.net/netdev/2026/10/26/186
> Signed-off-by: Yuen Su <zypulsecore@gmail.com>
