Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11022085.outbound.protection.outlook.com [52.101.53.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794A0263C8F;
	Tue, 11 Aug 2026 18:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786472626; cv=fail; b=IKL3sFwLivDXLOPvgbMRg7sz7v0s3qNiXU7i6GTj9WtJSvBHUIdEEfjazB4zkV/NGcLDTUo3KdXLKZm4z/T+7pjZ/0JVoktS94l3k97QG9016QCUfgQPE4hz/D2VGs0puJhGRxN6jGWdgAqS0e+I+ZRK1tsg4mfe1yiify1eJi0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786472626; c=relaxed/simple;
	bh=jS97OSE+0pBr2ZpnrIn386t62mD2FLQ2QdLtWDTmpSw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tpSMD67bZBXgDkFcBauaKeb6KDKCONWckTv2P8oP9Q5uYDArygpNNTMz1ynGjonU0iiQtHK4CRcYx6enem2zTywMA5MrpAVgJVtYzfeTCLT5kC9gKtqJcrkakowNXHl4SHQnb+UPY9zZzEuNwGK9/A6dPwQM9YvIxg37YYg0AN0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=IAmXo19i; arc=fail smtp.client-ip=52.101.53.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="IAmXo19i"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WpjWKlwSY8uWtPPnYIzneBua64DR+PxrotE43AadeuqLMw/EsYLM06/czYaDry3WzLllbZgn0i+YJYCvDZpCqhrAjxM3Cza9DxmdUBY6LabveRDhJL8zxt+zo4Djq5GlwxBv1RSQL+Hj1wCYQsZ7QJCDO5OSzyJCCVJPZa/j+Dy8HQwk3+LkNCC7118ZHa8LW9l/tqAoWQn9uAZ7r9bjGM+0ExDtvhFyjDMlNEpxmbS+NTU3FK6C06hS/t9nExgji+t+4KVKDKMZL8UbTUJnW/5ga+k0ErnO4uBdgJLtu5fLqPTuaO/LvVxNWcdVof/cKZQ4ei3JM7uyqox6LRWoiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jS97OSE+0pBr2ZpnrIn386t62mD2FLQ2QdLtWDTmpSw=;
 b=MY8w5papvLkD26/XEnj6rNzF2zNd7YU0CxeHqooBuMwQuojDZJFnV6jtI3hv5JCKkJDQsoR76Tb8T4CAMp7pj1haB8wN5T22e9GOjPwJPhigLtbVucsTf1CBYwrNpwm1x0GSKx3M+zKEingLA/CnGpAIh97w1Ga5ansgpQF/eIgElNVVBU/vVsusWZG9tBlwT++TrOyHGg2QS+XYFP5tyrcEG4d1iIAVlSoXnzT9oGjWk24A+ot0ewTBmb33RQ1XXB/UdAJPmpvt6SECrJAWpl7LSmL20SaQGQTDnOhlmtLIhjQ1PwUQnGPBxOSQVIimOFv0UVI9sCw4uL+12EjNUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=rambus.com; dmarc=pass action=none header.from=rambus.com;
 dkim=pass header.d=rambus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jS97OSE+0pBr2ZpnrIn386t62mD2FLQ2QdLtWDTmpSw=;
 b=IAmXo19i8a8FRyUhYA9hclU8mlZO1OV4/J7nx/cJJ9JptmpyrScRlF0BCmTDDAMEQdB4Jby3I2y+XPMObmz9m9/OC08Px1OQ+YmVm0JIp4Dk6KpTG0w/fCTuJJ7JCTorTD8sV1yhLLVcXb0jEW0SW6LhDybBAwdv6UPUuQYvuuJKFVryzcR403E+TI1Y7IBnmygMOAQIrs6TfW5BOxQFliiZtVuAgsZ3B8/Mfs3XvfyUDp0qWRGbazLf04MKM8uaUJjduEoIeiKvT/v+3rWDrIfFrK06GJGE18UnDzcpBKLr+qCkpweyTTCOwzL2GdZCdJ6/N7n29MZyc/mJlCYFrA==
Received: from SA3PR04MB9001.namprd04.prod.outlook.com (2603:10b6:806:398::17)
 by BY5PR04MB6453.namprd04.prod.outlook.com (2603:10b6:a03:1e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Tue, 11 Aug
 2026 18:23:41 +0000
Received: from SA3PR04MB9001.namprd04.prod.outlook.com
 ([fe80::3da3:45d7:8860:e196]) by SA3PR04MB9001.namprd04.prod.outlook.com
 ([fe80::3da3:45d7:8860:e196%4]) with mapi id 15.21.0292.024; Tue, 11 Aug 2026
 18:23:41 +0000
From: "Ousherovitch, Alex" <aousherovitch@rambus.com>
To: Krzysztof Kozlowski <krzk@kernel.org>, "Krishnamoorthy, Saravanakrishnan"
	<skrishnamoorthy@rambus.com>, Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley
	<conor+dt@kernel.org>, "David S. Miller" <davem@davemloft.net>, Herbert Xu
	<herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul
 Walmsley <pjw@kernel.org>, Rob Herring <robh@kernel.org>, Shuah Khan
	<shuah@kernel.org>
CC: Alexandre Ghiti <alex@ghiti.fr>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "Wittenauer, Joel"
	<Joel.Wittenauer@cryptography.com>, "linux-api@vger.kernel.org"
	<linux-api@vger.kernel.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, Shuah Khan <skhan@linuxfoundation.org>,
	"Nguyen, Thi" <thin@rambus.com>
Subject: RE: [PATCH v3 11/19] crypto: cmh - add DRBG hwrng
Thread-Topic: [PATCH v3 11/19] crypto: cmh - add DRBG hwrng
Thread-Index: AQHdJd2McKY5TZ9ZKEyR3JOvtdiCxbaYjcOAgACjaKA=
Date: Tue, 11 Aug 2026 18:23:41 +0000
Message-ID:
 <SA3PR04MB9001AC1DB7241932BA70FFA5D7DD2@SA3PR04MB9001.namprd04.prod.outlook.com>
References: <20260806195519.2703224-1-skrishnamoorthy@rambus.com>
 <20260806195519.2703224-12-skrishnamoorthy@rambus.com>
 <8f45e30e-bed0-4e01-994d-40929dbf769d@kernel.org>
In-Reply-To: <8f45e30e-bed0-4e01-994d-40929dbf769d@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-version: 11.11.2.117
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=rambus.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR04MB9001:EE_|BY5PR04MB6453:EE_
x-ms-office365-filtering-correlation-id: 395cdcfe-0f31-41ca-8669-08def7d5abb6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|38070700021|921020|10067099003|56012099006|11063799006|4143699003|3023799007|22082099003|18002099003;
x-microsoft-antispam-message-info:
 dM2lKCkyWJ49AZhg8MMqs/hv9OwK7vSTxY6saZpCHdxGnYfCQ6Uj4PMx+QJVr8x7LEQRL61FosiwEzqnVM+vsgYMqn798yHYL1QiWT/W8V563Qlbtzqvmnbo+6Xbt2ItG4b4s3NHuMXjPup8haqbaQ5JSE+vmdXry1w/Z6wGnXZcL7IuiI0LvDdaxE80CtNMnQra63JKX7acHpj19aHzL3NSa7FMs/MP6ulOQAw2XT9gUjfgWUvjbsRh1Pu7ALZ1uLjCLlnUpaI7XNlcyTlbwyoPM8cRsWOOVJIqhpF+5R0Druj0wWWUzujbHS7hQpUqrTxj+VbzpCqJTJbqly3RLXD9qgHyY8vikZr0PgufcmLCB9PY2J36TUvUaYqrpNaneEnvQmGZo2AnZpAgzaLdzy3XXw6b5vrVBbv5PW8g7u2RZYANh20CoG7F1w8GW5lfMMrxwl01i1eUJAMtlCqJfr8FGPTr5b97AvqY3FvCMm2c/xIt6yW9Mfw0MYrCOKLBsia1JjEMqJgUqzKP2JDRn9G41F7Y7Bk3wQuCiXUjYJIfK9Bl756hzujwsxf7gaoBsAtjHc68eUAcE5m0sc/81yuIGHNwMHPodhshn8MTmF3Aa7A2nLcGdLNxmm2PviIaa+EtGQmt56X8AQ6UjrwBi3e6sSPZGn1Ste3qgkR3f7LEOKYo0TkJnbGycKWOUQOhRMagPuo1hayOOmh18ZkDlx5pBr+XMHQIqybtKMcho1mEApKA96Rj2K02z7RqYaV1
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR04MB9001.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(38070700021)(921020)(10067099003)(56012099006)(11063799006)(4143699003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NmlCdEYxQjB1aUc0Y29IcmY5ZWUwSkJsNnU3UUNwR21CbGoyNGJWNkFYSVhZ?=
 =?utf-8?B?UVZQYmFWR0lxZjRnRkF0ZFNHK2lWQnE0SlZHaXBFYlpYb3hUTzZOUnV3cDJD?=
 =?utf-8?B?RG9wTm1LVkNEUFoxcUxidmdOMXZiM0pHRjZFRTlvcmtvSExBY0NFcGRTbkg5?=
 =?utf-8?B?SloyanRQOFpSM2NsMzNKUjFOSjJBamNuaHovVk9aQ05CUnAxcDgrTXBqWi9z?=
 =?utf-8?B?MnI5SUVIbWNoUmtmaHVmbnRoMWdCbk4wY0kxS0drc0RJci9wMFl2UnZDT3l1?=
 =?utf-8?B?RmMzczE4V3BlamJQTkVmaWNnU2FEOHNBTGsyYXJHWVdQTFp3ei8waUNOTmN5?=
 =?utf-8?B?cFlNb1NhaTM0SHVWUGpmK1p3ZU96aWhMRDU1dmk4SUhYRFNUdFJUeDBub1M0?=
 =?utf-8?B?a2FvSEMzaFR5OTl6SjhsZzJoaXcvOThVMWEwbmNCYmtkZ3RuTUxTcy9Zc0VR?=
 =?utf-8?B?UGxTcXA5b1ltTlU4aTgxM3phTjZOTXY3RXlYLzBZNkxCN3o1bmFHNy9xa1VK?=
 =?utf-8?B?M0VFbEZTY1gzMW5vbWk3WmFaSEtKWGRtZG5TeHJMNWtma21oREFaeE15cEpB?=
 =?utf-8?B?UnIrcEtuZnMyVnpIYk0xUkxSWXdab3pqSVRja2JkKzdBL09QQmVveUJNWkM0?=
 =?utf-8?B?S2hiS1N3SWNFU0JDNmJvdjZJYU0xMVFwTHNsNFlDWjk1Q2lyMjFPZG8vdFhD?=
 =?utf-8?B?MWg1K1gralpvaWgwa3FmeFR3a3ZXTGNZZHhzQmlFcmt5N3RzV3Q4SlBTbzlk?=
 =?utf-8?B?R0pkYWRPcG1WVTB0ZGF2RFEwRENDNDRSMFFOd0JXOWZWY3ZlbmtPbXpmVjlN?=
 =?utf-8?B?RzdxWnZlUnFIdFdqcGloejYzV2NkdkkxRENFM1RudE5jdC8rcXY4RFBabS93?=
 =?utf-8?B?MWpNN3ExRHVvN2p2RmpobW1QYUxpOGgrZjhQMmUrWHREeU94U2VIcURxMy85?=
 =?utf-8?B?ZXBNYTN6YVhQbzB2ZlBOMzlidHJiNlZOcTBMV0djVWEyM2VMR0tVaFNQa0lR?=
 =?utf-8?B?MjBkYk5tZHkzNTAyUk9WZ0JrbFpuUVlJOUpwQkhrS1IxcittcnJObTNTZ3ox?=
 =?utf-8?B?dW90NmVqdEhCU3M0Y1pTUTZaSHU5NU0rTTc5SDdrY0R1ckY3THptY0VkL3FM?=
 =?utf-8?B?NzAzOFh2Zmt4NTh0c1VRY0xXTTZ1TCtyd3pBbGJOamFHdzJ4aFpXZ0I3NzhP?=
 =?utf-8?B?QTVoaVd3c25kekNaaVo0MDVEQlVzYU9GeWdDQUZrZnV4M1d5VkhoS2pvY21Q?=
 =?utf-8?B?dGpMOFE0WThZWkQ3eGxnYllDYjNtZzJocDFqMEhqWkdSeXJzZ3JUNUlhaGRo?=
 =?utf-8?B?ZjdjQ0tFczV1dW9PdnFaOTdlem1RK1lOZHFGck1OSkpwV2FGQXhHLy9BTE5i?=
 =?utf-8?B?bzFtVU1TcnZPRmpFdWJ2TVFVamUwcW5XVWxYRnJpSFlrMEJ2bUdWVG00ejJa?=
 =?utf-8?B?TXRCZEVmZVZKNURwaldST3dFQlRNTVUrcHFJMEdkdFVkS05TQkIwS2FUai9r?=
 =?utf-8?B?MHpWbWRFdWlRQmtmamhyb1FOQ0dyMHN4NTlZaE0yNnlzYkpZeUkxbU0rMmY1?=
 =?utf-8?B?aFNseVp6YzdpYXM3eVFqUjE3Z1I3dmttUjhWTVpmTlduTlJ4cWhIOVhDYVhQ?=
 =?utf-8?B?QURoUUFXRWNuaDcvU3pGRXFBbWpsSHE1MnhTd2FYbXZRdU1McG9VYytOZTNF?=
 =?utf-8?B?aUplS3ZtQXhvM2E5OEw3OG5iOVRTM1Zxemw0NTRLMUI4K3REd0QvOURCeEtw?=
 =?utf-8?B?RHF6NXlXbEpubjU5cDJwM1JiNWNKaUI4RTg4Mk9RbWU1SzA3c1VIa1RHRGxa?=
 =?utf-8?B?ZlZFOHBpdmh2N1hXaTFNd0VzZUdUbExnNmpYd0YvSnFnS0pjN21iNkFTUEdx?=
 =?utf-8?B?NW13elZnTlJ2bkhacmdURFVtbnVPSW0wQ1RFWVpSMkV0N2hsTW5VQ20zQVNq?=
 =?utf-8?B?T2R5aUVSRWxXS1R0Yk5TOFFyWWVxYW8xZ2R0UDJNbWRyNytQTjdFeGxRZUJV?=
 =?utf-8?B?NThUT245Q25keHduUW45b3R0STJmSDEzYXVoSEIzT3IyUytZa0JwSFlYbHQy?=
 =?utf-8?B?Q2NWU3VWR24zSlZyL0VnTzNNcWpRbUsybHFCZnUzajNURi9IckkrcHcrckFZ?=
 =?utf-8?B?TkpjWG1zZEc3SGpHejVDTUlmM25xNW5heWp1eFlzWHpiTzlScm83NnViWWg5?=
 =?utf-8?B?a2JTM0hRN25ja21SUlg5SCtHVUprcmpHM1lTRk9Vdk50N1l5QzJ0Nm81K2Jq?=
 =?utf-8?B?a1owS1RFNi9QMVEwWE9nSHE1ZXlhcE9DZkg5UVo0UEV2aTUxaHB0dEVobjVZ?=
 =?utf-8?B?MGJpYXgrVWF3c2Y3Ykw4dzNPZlprSGNNRmlUWm5OSGt6dDY2Yk91Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR04MB9001.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 395cdcfe-0f31-41ca-8669-08def7d5abb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2026 18:23:41.3924
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E9IudZ+EY1ry1TORH7VeIedT9qFmy0fdFKdpKMXg8H3FI9q8YFSc7GlqB22DeF4s7tfwStBuITl9zMsDxNt0BZOGn5lwOR24qehR4DUsIWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6453

T24gVHVlLCBBdWcgMTEsIDIwMjYgYXQgMTA6Mzg6MTNBTSArMDIwMCwgS3J6eXN6dG9mIEtvemxv
d3NraSA8a3J6a0BrZXJuZWwub3JnPiB3cm90ZToNCj4gPiArCWRldl9pbmZvKGNtaF9kZXYoKSwg
InJuZzogdW5yZWdpc3RlcmVkIHJhbWJ1cy1jbWgtZHJiZ1xuIik7DQo+DQo+IFNvIGV2ZXJ5IGZ1
bmN0aW9uIGhhcyBkZXZfaW5mbz8NCj4NCj4gVGhpcyBpcyBvbmUgb2YgaXRzIGtpbmQgZHJpdmVy
LCBiZWNhdXNlIEkgbmV2ZXIgc2F3IHNvIG11Y2ggb2Ygc3BhbW1pbmcNCj4gZG1lc2cuIEl0IHNo
b3VsZCByYWlzZSBleWVicm93cyBvZiB5b3VyIGludGVybmFsIHJldmlld2VycywgdGhlcmVmb3Jl
IEkNCj4gaW5zaXN0IG9uIHBlcmZvcm1pbmcgcmV2aWV3cyBvbiB0aGUgbWFpbGluZyBsaXN0IGlm
IHlvdSB3YW50IHRoZW0gdG8gYmUNCj4gdHJhY2tlZC4NCg0KV2Ugd2lsbCByZW1vdmUgdGhlIGRl
dl9pbmZvKCkgbG9nZ2luZyBhY3Jvc3MgdGhlIGRyaXZlciBpbiB2NCAodGhlIHNhbWUNCmNsZWFu
dXAgYXMgb24gcGF0Y2ggMDIpLCBrZWVwaW5nIG9ubHkgcmVhbCBlcnJvciBwYXRocy4gVW5kZXJz
dG9vZCBvbg0Kb24tbGlzdCByZXZpZXdzLg0KDQpSZWdhcmRzLA0KQWxleA0K
