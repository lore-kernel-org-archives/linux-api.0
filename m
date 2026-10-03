Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021118.outbound.protection.outlook.com [40.93.194.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C45E54B;
	Sat,  3 Oct 2026 00:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790985686; cv=fail; b=K6jpQLiVhCdDKzJn7iIOlqWKqfjAKIARdiuOdadDyPoxdfJPnG/ibZAo9MUUvauRg++ylwBD7jl15vV841vffLXu0nI9J3pBm22eOC/+m/G/Qqn27GbSPO7tdj0DMK7xZIQ1AZJMRF21b5Uepet3DRPyGoGn5swwjYLx2xJjys4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790985686; c=relaxed/simple;
	bh=iXBLtL/FjVwA638XLtR1dh9VmfDkcqdovSOvS00k5B0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=URAAdaDgyL7AIym3xzQnhxWuxkVsWL/cRH6YBucUVwvxj9j4fwH7gFIoqdjRoEotfkCU+QiZjI9gEKPQXECmgzdbD/pV2rX6jf0EmMv6PNqQ64VVFiO0BAQ74MuSA+LD08x1nbn2s9YcJOWcv+Etfw58LwJUl2Aei9HScqM2qng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=TFbSqLZp; arc=fail smtp.client-ip=40.93.194.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="TFbSqLZp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WGkbPWYka2gmh1ACz3q4OH3v4+aps3ooamYs7Rq8GnZzfnY8FsoNZMu55PyIvhxa6vxo2GAB7e03PC5w8kcvQaE0uBDFaM2b08+C1SUseSWbPz8rzAmcRh8zt2JVpHAyvoSfuhdD6mS4en9S8I+W5rMJmtSI9ECf7No3wU/Fnpkyq17OYTNf2kXtbexHtnNfVX02NodBZ3a29UfE+MZOuSYl9FywqwmT3O4p2+pcyD8FjfyVCA5hlT8mXV5AGabwo7kDQNr/xlCEPxazrLjnwy4FtvF8NURvtnp5lZVMmMYSVxdUXtXYT9c6lD7wQPpBHH8/y4YSswVW6/O+rB2QBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TVE0NL3FSEwQ8ij1mcF9yWpbJjBwQsePAccdXOgfXdM=;
 b=FZjnE001BVzrm5TsRSAp7icKRiMsfes9a0PLTLbw7pXA1Wa2w37bNCKn92O25fmKnhURSGOwaVYtRFbUZiJN7M+QpKgtEbhXduQT/mitz1rkryX5QCUGKN2R1e3ivP8hN7D9OgvOLAfYdOu4/Kn1jSVeHFYaQlT8EoZxaM6ur3CVsDEBekhwa3lpP745Sg+uwSf6uNoFtnZfTWVPxEr0cZx1aRkMf8pOCru2WThwwI6uDVNTVCLWCwIy4ySa8RdP6Hjs2UBVULt6XUIXTneVtUbX0zJQsQdSyM8ypYh9GtlEMJC8SXFwGhQfoa5hcS6BuParDuoxFTWz8ihLOw7pJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=rambus.com; dmarc=pass action=none header.from=rambus.com;
 dkim=pass header.d=rambus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVE0NL3FSEwQ8ij1mcF9yWpbJjBwQsePAccdXOgfXdM=;
 b=TFbSqLZpf56g0RIEVl7+GxcENiYSqV55Yq5zrfvIYhLt1ow3BdCXwWa7eVHNq4PCtBuYRJ9QZEmpg4ghhGZlHz4C6FubDD6eYaiW4WTFZvrn41t3gXMjVUIyj2YLbKVub7Ohgh7zREXpDhBjsj5m61tjVzIziuwyOTwNRKigp4pNryVTWchVVlgoUTDoBjRAoRR4IUeCMUij1lhp5A/nPAnYaMppqKTVZHgXnN/U5w0FqYWNdSJq2ldprgxsYT735qWcqxj//QjAzUj2qP3k5POXYDwZ39//kc4HcVHDUBa9XRxIZbpc7GxpCnF9aGFeAVqK2Slgiz+2s/UHbI/tnQ==
Received: from SA3PR04MB9001.namprd04.prod.outlook.com (2603:10b6:806:398::17)
 by CH0PR04MB8049.namprd04.prod.outlook.com (2603:10b6:610:f5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Sat, 3 Oct
 2026 00:01:18 +0000
Received: from SA3PR04MB9001.namprd04.prod.outlook.com
 ([fe80::3da3:45d7:8860:e196]) by SA3PR04MB9001.namprd04.prod.outlook.com
 ([fe80::3da3:45d7:8860:e196%3]) with mapi id 15.21.0472.016; Sat, 3 Oct 2026
 00:01:18 +0000
From: "Ousherovitch, Alex" <aousherovitch@rambus.com>
To: Rob Herring <robh@kernel.org>
CC: Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>, Herbert Xu
	<herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul
 Walmsley <pjw@kernel.org>, "Krishnamoorthy, Saravanakrishnan"
	<skrishnamoorthy@rambus.com>, Shuah Khan <shuah@kernel.org>, Alexandre Ghiti
	<alex@ghiti.fr>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"Wittenauer, Joel" <Joel.Wittenauer@cryptography.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, Shuah
 Khan <skhan@linuxfoundation.org>, "Nguyen, Thi" <thin@rambus.com>
Subject: RE: [PATCH v5 01/19] dt-bindings: crypto: add Rambus CryptoManager
 Hub
Thread-Topic: [PATCH v5 01/19] dt-bindings: crypto: add Rambus CryptoManager
 Hub
Thread-Index: AQHdRvhGld39hFyFYk6+ULPndM1E4LbkXasAgAao6gA=
Date: Sat, 3 Oct 2026 00:01:18 +0000
Message-ID:
 <SA3PR04MB90013895036055B61215C0C3D7882@SA3PR04MB9001.namprd04.prod.outlook.com>
References: <20260917225929.2494111-1-aousherovitch@rambus.com>
 <20260917225929.2494111-2-aousherovitch@rambus.com>
 <20260928181848.GA150882-robh@kernel.org>
In-Reply-To: <20260928181848.GA150882-robh@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-version: 11.11.2.117
dlp-reaction: no-action
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=rambus.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR04MB9001:EE_|CH0PR04MB8049:EE_
x-ms-office365-filtering-correlation-id: 91844cb5-09ed-4dbe-7051-08df20e1735b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|366016|7416014|1800799024|38070700021|4143699003|10067099003|56012099006|11063799006|22082099003|18002099003;
x-microsoft-antispam-message-info:
 GYg2wwXIFF3D/zmjAkQVypvf4ZrdbKz63xbRU8LM/4E+F8jkJwMPWEWOH/uF9DHz+jXYSho8G9lk5IVECkXI7HWYd13aZX4pa53RXGbL+zN8A5/6CxIacyL4d/5YVnDVoFF3m7gE0jP8v3aDQk9fWOtX5IC/pYF+7kYHt9jMa4P3UUAqcsaFsUpS78YPI+U3/EQVJVw/mrFdLrFAXqnDCnDIgaZ2/UP160azDsYfysGHYXnbwG5UmCtyNZpKNQO1vjXIznUqKS37e627UAWjnbxcQo+qJ4Lk0hbrHJYYGl4ysJuF7hfSiDy449laFoHpk8/S23acBdwSUBiT7Vo9VLIYgPplpgUDJr5ABxc3qyCFy2bI2KXuqXe/CWORnPYsMsLuqF90Bdj1HdGozroZG7cWytW7mvhOMdcAvpbuK4h30I9LMSreFN6hZzXwQ4/it2I8jVL95xxi3eDW3LFWtOjUkAh/wxzWI0vFuTsBIjMuBj5tSN8bLr8Aq60K/g7GOj51Q4iKAvpjlLTei5oasellHe7ac+8n4Oj9VLqRoWfMMxfywAY5hOXD9iCNrHcHc6ygdAaRt8AhQdEWC0RfzH5WN+LTYkKNVMWdQv6zlQWIRH3C4jNF0ncn/wO5bqdxQec+yScexWNItP3DfGbfBX2KGujpN3mzXCCiPoue3sR85ucoDALs/hSeocKYpsCM40whviTi2WfpeuuwnT6eSe9ROKsgB2tDMZ5v4j0zQm0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR04MB9001.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(7416014)(1800799024)(38070700021)(4143699003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?gZtnzLNDnK+0XiC4if9KgmEy4BxDspTawounrZh6Z0e88dXK3fZpDbdG5b25?=
 =?us-ascii?Q?pfdO2zs7RdF4dVoTZP++ww8fge0B2N/q0S5xqWWHgj3n/0M0jue2Gg8P/NqC?=
 =?us-ascii?Q?utPup9KuuiRdRGpzs8X/StSEjKxTz46dBmZUFtpKNFYuGv9X4CMzqdA27HdZ?=
 =?us-ascii?Q?m38iRAJ/PNzTmFIv+V6EMT76jlWavwy3HvMFqbNw7QPACxe9CzrCD06b12/4?=
 =?us-ascii?Q?wbA51AVXqUJYoQr/XiGnrqI19HNebRP5d5+xNZM4PBdPgnVUPjOsGHASdDxL?=
 =?us-ascii?Q?wIUzzCGH7lT2OH3Od7FkyzeZFtMiIRb2lvHaSYnp/kBgzNOBNdP7ymNZWePP?=
 =?us-ascii?Q?cf7pJY/9gKsvQzEK7DfbzMlHAgn87HchIEeaC5jF/ElB9f0i2v1yVxra4q8j?=
 =?us-ascii?Q?CcHlJffygvV+n1YcKTsYPrW40BBrciCa11VeYm7tTN7jVOxzve1LO9HXyRtT?=
 =?us-ascii?Q?MSTjtxxnASg6opLSV9A3zd+VXeOBu0E+VLHWPQHTJ67NI9y3Qre0etEDwtZ1?=
 =?us-ascii?Q?iYjOUXd9s42bNqAaIVt8vmgRnn4DcSk4HEkBGMYTKXqLdJIHi7Bo62vbokfG?=
 =?us-ascii?Q?sU3JXf7PTXfRStchzZWQt2ismRoZjkkwY9ajO3a8MtwBDF7/444/2ey6tDBl?=
 =?us-ascii?Q?zjeMoSi4jUVqu7q8dqUNiFwPDCfI1wtt9ZfmH3PjCM3Tto+2I/56B0Gm2qI+?=
 =?us-ascii?Q?/3bFmVbRnip4OWW562SATgoBv38WnlrkPgesSWbk09opTwikaOsNVshoPWC4?=
 =?us-ascii?Q?4FE41j3kRN63ZW/Rjs1YDYyDAzKJhU6QPeFAXNB866LnqoZ0l25Wrz9LpMfB?=
 =?us-ascii?Q?EAGErbsPmZrTHn5JblmSXqUHi0E92JqwL6GMwej11NYX+PooCxL+nprqoAR3?=
 =?us-ascii?Q?0B+SFsFTxCSUwwMRL3jUByZ3AeYkzvd8GGdKb81gOXip7e11dqyZvN4nPkOG?=
 =?us-ascii?Q?5y+l51XCNLzMm5xgDdnFMxHRBXDI1mYG7DrRBZGyN+HO2OWmGYvZq6N4+81v?=
 =?us-ascii?Q?PNzmtsaHow3foZ9WLtItaSGAGfLFQhTqkTjE+5MfSBzKdybhAH5PyEPIE9DL?=
 =?us-ascii?Q?fqrzOlgp8IdAFb37KZ0PJ4fT8ELJ5MTTld+8yjUCublPndhH9m3JuAPqbGIe?=
 =?us-ascii?Q?gIYD5Ra/rCghDESzAxz4sRjhPv/xpXC4+Y7cMC4TqyJisw9Yo79tw95mD2Go?=
 =?us-ascii?Q?KBdnPNlsjUY7e6T15Bge/eD67tqa1gNF1d7MiKPs2y86AgOWBOgedmOObc2z?=
 =?us-ascii?Q?dncwnsFeSlgD1ghTW/K12/akjyudLRUoKUyx10AV44aLYFGF/Cj8khjsAulH?=
 =?us-ascii?Q?geryelnt6lOQ339qXJWXZQkQEjCg0a6/iZ40RwXgqVNBan7CSiCvLkZqUwV4?=
 =?us-ascii?Q?8SydICk4wcE5dQCcNOLlken0LhcrUQaVOgDR5mdbZ4rrPcugHC7MhtU4H9KG?=
 =?us-ascii?Q?DfZwgljtMDsyU/j80q/qH99ntG71T+ZMeGX6VoGMDUemHP3H+fmqzEKu6gFI?=
 =?us-ascii?Q?AsWYzC1gp5sPClDPEzKcishYg/fgB1zMyNwJsL+GSb1uheO7G8S0aCFGh8q6?=
 =?us-ascii?Q?0rWwNAZeRAQ+oGOcYGRDUb8UAMNwTn4qESfzpujzJxme1gseCPp/6vqbYCw3?=
 =?us-ascii?Q?TDLXcGhTWLyxChAx/Y9uhEzyaQeqwPltkficRSdZ3Wo9zKhlqqYDShFHO/5z?=
 =?us-ascii?Q?erXPi3L2d9QDDYVLL6sOFV5DzApGCRucEfzbAIUXae8Yl5Sc/mri1zjP0rjb?=
 =?us-ascii?Q?b/MHIYjZyA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR04MB9001.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91844cb5-09ed-4dbe-7051-08df20e1735b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2026 00:01:18.4266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IA1huov3CBLRWUJRHTIkQf01+uQGS+HxiCRvAbD7aII9mNyhxgSgXEchlb8rqI9QVhSjuECz+IB/xl56Krg5gOQQN5FJS4IJ8Ade/okI4kU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8049

On Sun, Sep 28, 2026 at 06:18:48PM -0600, Rob Herring wrote:
> > +  clock-names:
> > +    oneOf:
> [...]
> Can be simplified to:
>
> items:
>   - const: core
>   - enum: [ core-div2, rt ]
>   - const: rt

Thanks, I'll use that, with minItems: 1 so the lone "core" case still
validates:

    clock-names:
      minItems: 1
      items:
        - const: core
        - enum: [ core-div2, rt ]
        - const: rt

> > +      reg:
> > +        maxItems: 1
> [...]
> Is there a maximum number of instances? If so, 'maximum: N'.

Yes -- the hardware supports up to 64 mailbox instances, so the index is
0..63.  I'll add 'maximum: 63' to the queue reg.

Both will be in v6.

Thanks,
Alex
