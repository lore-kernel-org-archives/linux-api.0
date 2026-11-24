Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.96.82
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795530533;
	b=R9nZcp1jhWAFhfjRpA8zbwksJB7gZpefNXLUqU7eZJ8jBGh6I5qRPKuerzucQRgUH2MA
	 zJbNUOy2mwddpmw8UV6Iba0Cr88XO6w4mWx2XfSCGT3PG2xpT/LRFI5Q9Vn06KUbjdaS/
	 PwJL4P1qepc/D/nNWUNDrBIJVSPfopMIymGoxQY1PN0/SVdTZqxdbxNoGtmupinJ1agEx
	 CyDiJ3necLh5d3iwJuPvfPEDFe4VgHjmUsnSActKPl6Pr/IF9VoHLml3waA64oBCrmR82
	 GpirAINVyiq/X9DH49moMRGJobezBw57e4p1QMH/ZABPDMFx/+8+mn/oc9hT9QKzlQg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795530533;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 Content-Transfer-Encoding:Content-Type:Date:Message-Id:Subject:From:
	 To:Cc:X-Mailer:References:In-Reply-To:X-ClientProxiedBy:MIME-Version:
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
	bh=XCnT406AtVTLQM1dtuV3kPZfQWiESMWizu0qq6qxkz4=;
	b=AjgX+YXnTA36WI5wzhsIgnxzmwJw35ttbWNf9yYDfZma0/AnxROBVQyRl5E/yPUiXQVE
	 c2htgLvz0tXdBn4+b8uYj6i8xfvZdm5+DHA+WNqN7cmpFIwMPDvpaH4E996dV/ZGHdyt+
	 eOYgILcYC9uk/wjmQEO3aWhLK/kenwtKioqfHjsnHcT4XwUEJeb6oZPUzu8uYFVTjtVut
	 H8ojULudPBS2n8Yk90h30sf3dzHFj6h8+Bg992K0P/KCSpRB8kH/OVeEmlLuEUEXpDgOR
	 OoGh+kV6Ft5xmA1TO1/kOm4wAy+y8R7nxA3lSKL58O2AbXPFQuSmC1Qg12lXdX2E/0w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=garyguo.net;
	spf=pass smtp.mailfrom=garyguo.net;
	dkim=pass header.d=garyguo.net header.i=@garyguo.net header.a=rsa-sha256 header.s=selector1 header.b="WBx/jTit";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.96.82
Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022082.outbound.protection.outlook.com [52.101.96.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2FD606A31E;
	Tue, 24 Nov 2026 14:28:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E2FD606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=garyguo.net header.i=@garyguo.net header.a=rsa-sha256 header.s=selector1 header.b=WBx/jTit
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S/q7wmUZE4FkkTd3jUlZzq9RAUroEiu+nOVkjdJEsAuej6fsOAZ9VDic4jOvRZXtNiD5smS1s4V8Cf2/N+wShec37NjEJx7zP8eV9FggG5Y7xC9p2Y8ApsR/HEI2V+nQ37exa30hQu+gxvEGYgZXns14aJqMgE8TyWuUi1HVaEa06ze4HpXsIj0KE8XVbzjct4nL9UPaVnuucS347z3NYG7vixei1nLeqzPyzCHGCZep50ILd9ndd6IehfEDe+aaWVTBwfggfNoWWTLAxjWRAddTzSotjOCg6V52Xx0WfzqYxLLtfqQsP1vgM2Z20KLSSd8+pgVjCwERDN3ibT9moA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XCnT406AtVTLQM1dtuV3kPZfQWiESMWizu0qq6qxkz4=;
 b=F3uggCA4EvlejuDShLsl+b06IyEeJeeVEY37YtpoqvfrqMLryGQOyzNGnabFYQPy5UFy9tpluDnTljUy3ZhcV+vXShZ85RXiEFDqIJr7zT08lN7BsxSaknRIMm2GFevtja43SDlEo/Ed9sWBjUKl9upXQvFxepCFEL4fJARjfo/NUVyj7JY4GsCyXFD1nEzofplYXJA850I8OiEVwbUHGgYEgGszEs7RqNX+me1yBYCXUjmsulwT9TpHRzGsbXIdLl/lNsHVMujjcZLjAv1eKLWpRVBYMLntflPey86MZuTTmTJ8jxECzHmJJxRutONyFnS0bta5wCZbSDRKEHHVcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCnT406AtVTLQM1dtuV3kPZfQWiESMWizu0qq6qxkz4=;
 b=WBx/jTitou+GRrxOxcroL4jerw01F61c2p9Z52PrQk1fmELCi1mZg++vi4iad+1zF/wqjSH6Dd1kQQ7/tTrAWh4qtwE19nTmPzllsagIHzoy5NKzXUsguh1mnEbQ4WF4oQczMnyz2tad7CLkR0ro165u22Gbn/5BsxN7qVFGU7A=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1cb::9)
 by CWXP265MB2581.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:ab::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 14:28:50 +0000
Received: from CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
 ([fe80::55f6:f98b:7fad:c6e3]) by CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
 ([fe80::55f6:f98b:7fad:c6e3%2]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 14:28:50 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Nov 2026 14:28:48 +0000
Message-Id: <DN3IG9MGAI6H.1TFVHTSMMTSUH@garyguo.net>
Subject: Re: [PATCH] rust: drm: enable standard fdinfo for Rust drivers
From: "Gary Guo" <gary@garyguo.net>
To: <peder.bergan@gmail.com>, "Danilo Krummrich" <dakr@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>
Cc: "David Airlie" <airlied@gmail.com>, "Simona Vetter" <simona@ffwll.ch>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Gary
 Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>,
 "Daniel Almeida" <daniel.almeida@collabora.com>, "Tamir Duberstein"
 <tamird@kernel.org>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, "Asahi Lina"
 <lina+kernel@asahilina.net>, "Lyude Paul" <lyude@redhat.com>,
 <dri-devel@lists.freedesktop.org>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>
X-Mailer: aerc 0.22.0
References: <20261119-fix-drm-rust-fdinfo-v1-1-c10f4134488d@gmail.com>
In-Reply-To: <20261119-fix-drm-rust-fdinfo-v1-1-c10f4134488d@gmail.com>
X-ClientProxiedBy: PR3P195CA0029.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:102:b6::34) To CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:400:1cb::9)
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
X-MS-TrafficTypeDiagnostic: CWLP265MB6051:EE_|CWXP265MB2581:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c316de3-c818-49cc-f1fb-08df4a3741f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|10070799003|1800799024|10067099003|56012099006|261022105027099003|261021121427099003|261026140227099003|261009223027099003|261102123227099003|261028144727099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	QXpGyaBzDFQYKEabOJ163CVJH+Cv2ju6h0yHCnylNdZNCn5W5551gAmMplYChFs+Fv7c1O3gNWqSy8mhokaeIO0+Pk3o9PIU9F3wSzbQS7CQHAtkfpsFeRZnb4VSnGun6gOSzeZ45ACRBTR1SSAryUFkPzDCIFa7j4/kS/018t2PBcl5MEiz9IY1ko619pRZyCnZQFf4PJCBWZQUtBr0IncFc87jDDkbUS3kBeVq97AbaDjlSAtd7k2cNwcI/jQQ+0VrZn42iz1lAENg8n3R8R7mqvwGswQxji+KSa88AkR9JLqOT2iyq+Ov3Ir1yYNXgT3LfVcEdytTewPfZ/6z1erxpdj9HyfQV8x1TdMMkeDEfUww2HjlFZKmLvTSU8LvKI/LZiQ0q+vVirggUNCzBaGn8107jHX+o4u5NtY0U6QYA0GPo7aKoJCqEuIyrFG1DgvD/th7ajyxOwzssT2mlIz0j5hhBFyg5nMbhyN7mJO6W/draJyvhHYCcGLqbecgCa0Jz82E/PnQhZ7hZFOmNiHRMLeUJdxjHYmTPYwsviGyFKDR/ncjN3yyaMHnpbgmvotXbNEts5wlZavdeRP74PRsXRDJaixVKrbRyxbfWOlG0b6vx2fcvJcas2fyyXp3
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(10070799003)(1800799024)(10067099003)(56012099006)(261022105027099003)(261021121427099003)(261026140227099003)(261009223027099003)(261102123227099003)(261028144727099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y3U3QVVDYkluZDJaaGlpdTVKZVlQbmp2S05zelRNVFc1WTkvL0NsejlmejZs?=
 =?utf-8?B?bFFvMlNZdHowYm9xNVZmRlB1TUhXZnZSSlcwMlZPQlVkM1EzamIybjg2cUhQ?=
 =?utf-8?B?ODhyR20wbkdCOEwraGp5Zm5sR2MzZ2FDRG9ONG1GVkhaNzkyRGNHUU0vTnpB?=
 =?utf-8?B?NGk5MTE4UDJ0V2o1Sjl1WUtZdFlOcUVLVVJQVGZybGxsaU5SS0NhWkN5ZEhF?=
 =?utf-8?B?bGlGUmljdXp5TW5BMFNMRnlSQXlLZExjT1d3eFFiNHlBZ3RTN0N0Vng2aDFl?=
 =?utf-8?B?OU5ST2YwQlF6SHVXMXlLajgxL3BORDRla0NqRkZwS1cwQm81K3ROZnQ0eDln?=
 =?utf-8?B?cWQwOGlHa2psQXNaQlZld1YrcDZxUG9GbkVVTGxaMEVMRFdLdUxLeEhmc2s3?=
 =?utf-8?B?aXlQM1Z5VUwveWRXWFRFL0ZpZTV3YnFEeWUwbVZZTGhpd09MK2FWdlh5TGNl?=
 =?utf-8?B?emJJYlkyc3diTTNQMU53cStaSmwvTklqTU80NDJVQWRycTYvR3NMZE01Q0Fw?=
 =?utf-8?B?Qm91SUkybzBvOUVHamxHMm5LVXFMdG5UQ2NTSDRuWStXSjltMmw1dklmYjBM?=
 =?utf-8?B?UkFTMlhMTU02UjRDRkpTNk0yaEhsL3NwMVRBNklhdlhudEJtaEtnUm5TQThx?=
 =?utf-8?B?Qm5lbVFrenh5b3poMGJRMDJaZHAvempvUjV5b09YSXlTTXZWQURsUVVjUjNn?=
 =?utf-8?B?dmdqcEtHQ3h4clkxa1h4WWtZbmYwbG5mUHpVdjg2UEFBaHp5VldGTFVhZi9Y?=
 =?utf-8?B?TGNrNnNmQmdMU1pxcndiQW5QTWo0Z1pwbDI3NTk3ZnMvdWNpWnM4eHZOK0o0?=
 =?utf-8?B?dlVPam51MGZLTHhORFJqY1FsY05HYVp2L3BySURoeFQydjJNa01VaXpNNkRM?=
 =?utf-8?B?SzlHOFN1VkRlSHdhZ0tNYnFpZC9hczdMMVU5UW5NWTJ1Y1Z6czhteW9lNVpk?=
 =?utf-8?B?ZEs4SSt5Wkt2S2lmbGRkTFU3L2IzZTBBei9LYlBQVk1SdnlnbWNRcWtibndW?=
 =?utf-8?B?SlJkTlNmNEZSVjlBc3VXNnVGSFlxd083Mi93bnV2aUQ3TGZwYlNQK1hMZS9y?=
 =?utf-8?B?U2RYVVNnbmR3TTZML01rdno3Rnh4cE1WVktiK2J0RCtvWVRWbk1WMGV1alN6?=
 =?utf-8?B?aGdQT1dnR01yblJYaURGMTByaTVxcUtWbTI5T0o0b243UVpqdkc0dFFuZ1ZT?=
 =?utf-8?B?TTRBVE9xcG1jc0ZCRHU5cnA0Q1M1U2FaeUpBWlpBeHdXd296Wk1aNzcrQzZ4?=
 =?utf-8?B?THdPWVZCNW5Ub0x4Q1FPQUhiZHA0QnM0MkZXZFE3V1k0VGl1SVhJTHhTQUV2?=
 =?utf-8?B?aTdtRjZlaVVrcEJ6YS9YSUFkM2J1ZTF1Ulg2OVVvZjJLa2ljMEJZT1hnUmRk?=
 =?utf-8?B?TnBwcHg1UkJtK01BVE9sMWpUL3diSG9SSE1TWTBMOXhBaU4vbGZTUThOY3J2?=
 =?utf-8?B?YlJXK0p4Y1psd2pKbDVQaW1xK3pseTRNTmVqdER4VUM4NHNZWkY3dng5RjZ5?=
 =?utf-8?B?dVl2cFRzem1TdkxMNTcxQmcvVW93YjFjZmdNSmNkWisvQmQ0L0RUQVlOYjE1?=
 =?utf-8?B?cnU4TWt1MHBOcFB1cUtUeTRkdjNpSkpMN3R0dXNCbTVtY3dnU3dnQldCdGs2?=
 =?utf-8?B?OWtqbFRDWE1BZWE0Y2tBL0RoZzRVTXh1NFQ5dDg2cDB2R1MyOU80bUY0K0Z5?=
 =?utf-8?B?QmlnejZXZVhzb01pcEc0T1ozR3I2QmdoUE8rdERVTWZyTVlDNVFYbmlGK2hl?=
 =?utf-8?B?Y01oekpwRFluYitmZ2hHSUZGZ0o1OEZqVzZ1eDlXVFMyeVNybUNxYk9OMlRD?=
 =?utf-8?B?UFM2aHBPZngzVVZKbitDMHlJeXZtWUdCWTVVWFZ3MG5XM2wwNWx4NVZ2U1do?=
 =?utf-8?B?UkJMSlRNckIxdWdzRDZQN3lwY3lLTU5MTVQ0TFZCcUZqVCs4TXZvVGtvRVN0?=
 =?utf-8?B?VDZxNE92N3kzRGRhcmMrbDhuT3N0K0d5cFhNazRnd2ppbU9qRTJGZk1Va29N?=
 =?utf-8?B?L2RGQi9IV0I3QXhIRVRCNll2N1Vzc1FzNzBSZ2Q2LzV6SGdrTWdlZmN6eW52?=
 =?utf-8?B?QkJxejZxTWphNVJPTldtbHlsZTNxNFk4K0lyQXdCSzJIaG00RXR2ZzJMOURM?=
 =?utf-8?B?NnJ3dnZXTHJvWFI0YmlXa096V1Jzb0I5VEZSeURISW1HZ2V3T0Q5ZnUveTYv?=
 =?utf-8?B?c3hydlFINzlyeUIvV3hHQzVHMW1NWUJtcDlSUGt0MENEVW1tQ0FkYitHYmR4?=
 =?utf-8?B?ZmU0Y3FsTW5BNjNIY2dpdnIvWDNZYWQ3RjFKenFwcHoyblN0S3piQU95QWJs?=
 =?utf-8?B?R2xOcy9hN0JkSHJHcTJUbU9JZTFTVTdJZUt1VGt3V0FCL1VDbEh0dz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c316de3-c818-49cc-f1fb-08df4a3741f6
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 14:28:50.4785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ndv2nUO4jaRxnOwf9aHZUORfTeq1F/glBbmXgkHAtad2IAjCpKot6O/cQA79HZ4D5e/d+49G1EKq+LH+CJznSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP265MB2581

On Thu Nov 19, 2026 at 9:48 AM GMT, Peder Bergan via B4 Relay wrote:
> From: Peder Bergan <peder.bergan@gmail.com>
>=20
> DRM monitoring tools use drm-driver and drm-client-id in procfs fdinfo
> to identify DRM clients. The common Rust DRM file operations leave
> show_fdinfo unset, so these entries are missing for those clients.
>=20
> Set show_fdinfo to drm_show_fdinfo. The DRM core helper emits the
> standard client information and calls the separate driver statistics
> hook if the driver provides one.
>=20
> Fixes: c284d3e42338 ("rust: drm: gem: Add GEM object abstraction")
> Closes: https://github.com/Rust-for-Linux/linux/issues/1266
> Signed-off-by: Peder Bergan <peder.bergan@gmail.com>

Reviewed-by: Gary Guo <gary@garyguo.net>

I agree with Janne that the "Fixes" tag is not warranted.

Best,
Gary

> ---
> Matt Mireles reported the missing fdinfo fields on an Asahi kernel and
> suggested using this helper.
>=20
> The x86-64 LLVM=3D1 CLIPPY=3D1 build adds the drm_show_fdinfo callback to
> nova-drm.ko's file operations table.
>=20
> The pending move of the file operations into drm::device [1] should
> carry this assignment into UnregisteredDevice::FOPS.
>=20
> [1] https://lore.kernel.org/dri-devel/20261118163203.2483856-4-dakr@kerne=
l.org/
>=20
> OpenAI Codex assisted with coding and testing.
> ---
>  rust/kernel/drm/gem/mod.rs | 1 +
>  1 file changed, 1 insertion(+)

