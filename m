Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022111.outbound.protection.outlook.com [40.93.195.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4B1369D6E;
	Tue, 11 Aug 2026 18:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.111
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786472349; cv=fail; b=GaVp8Ft3W12h2SxYhK8/HE29lpfAbdjjkXyJnC2xnIxkXzHU8VqaN7N5hm38pJfX+JfrbkUthUgu2G4IQwHhF+hVt++GiAGB2qUKYOtTGLLia7qdCBkCAp2O/0j10gRfuKE3HyAEy98hi1ApCrDgkhmZvW6JP6OBYf7l/jkec9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786472349; c=relaxed/simple;
	bh=UWXE6/Z3zHhgJGXuR2mw7p9nMff248hT/WZ10KMIAUw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BHpWO+K1wKaofoiw7IM8sfXCtuYBpU7lXHpyVwFHV18H3NJ7zgtrJVTCaHbHPnLVuvDEiSl9w5HGqvmD/R6LZ0d/KT6RsjvOAwUd30ElQ2s1nShLHWSDieMPkV4WqtE8VHPGnRGOAqrkpGHCy5AARCpdvdgmPqfTwIMgtp44ZCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=BTFqc7KF; arc=fail smtp.client-ip=40.93.195.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="BTFqc7KF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iv4UT5Q7eFR4JZt6t/s4e0z6BedOZ7/sFccIfNS9wHSeioYhm1foKkyeGw9a5m8adknyEZz5kFY3E5wRq9YVA7cZyVlHWoRLxjeG0bXf3t7wRbs9d7s7w72Qrk3Wt5yNEA5uK4gJN2qR4p9mwm9vOT3e5gjNsR20h2LeuVikE14cBR7rzAN3LtgpZ9Ass9rJxEAG/IOeA3lzdIYiIDTVCv0nwclZ0c6sXwVnm+25NrNnov+gpMCl5P1/k5JM3u+lfkUjoctIryV8ujfVAbAd4dXs2e4/ysWvzXvVlvQZt0yQ9Mc713kmulSDfhCNcWVe0yXx3y/vPbVNNn2fo++g3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yO/1D/hG6dScRBMHptmji7sp6uE3uSXEnL8We9AwRVs=;
 b=FUlacm7M60Ur1J2ESv5mlXK1t47+pMY0rcU1c0nxfcHbMH6DQsTaOTvrAS/hY6no55PTlAnHJhh8gdV6PJpq5dbTQhP9lbb6H0QGy7shwgfNl6kEbRgXVsE5T5gghmmuWgaQODG3vjVrXINADiZ6IPv3mTRhR/uJlDb0LOr1tYbPeHRRhWin8iKrLmyAG/8obcBp+RuIcjW0VrWsQ4sxWINEkeU/1TUKrxBzh4vbN5NcQ8YP621MRzcnScBCt9xjX74l8ERybvJALMniKlIY/STFgMs5CNsFPe7ThO5oRABLqs3KE1syFuRX2fOVUk9HrBgYEBWSIH8PGpagrqdrig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=rambus.com; dmarc=pass action=none header.from=rambus.com;
 dkim=pass header.d=rambus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yO/1D/hG6dScRBMHptmji7sp6uE3uSXEnL8We9AwRVs=;
 b=BTFqc7KFK1XsonqfZqxZyBXp3WI//k1xJ0gbH1fghfWHcbVMPcSek/l9zdXCtOMR5/EXscMCugUj8QuxGmCT24pChq06+pLrzAtnd2JF1f37p+NuB6czrEcanPrH/hogtdGei7mEVWwSmjJCUtAapXjwi/vmP6HlJFXObUnURPCgARtSfxpPVlaccaDYoYF664q6smSlwewdhVmkPhHg8/2nbmpZW4ybqCDQh1BXcGJvWox7mnH/XZBR99rFnN9SVVcdkhtUg24j/GHRrBApOLVlDk1OLAz7dWLJBUEwW0Ip4lXF3TZA+M3YAWynMNe2TBBwmZOnijve4gtyOZe5cQ==
Received: from SA3PR04MB9001.namprd04.prod.outlook.com (2603:10b6:806:398::17)
 by SA3PR04MB8692.namprd04.prod.outlook.com (2603:10b6:806:2f0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 18:19:01 +0000
Received: from SA3PR04MB9001.namprd04.prod.outlook.com
 ([fe80::3da3:45d7:8860:e196]) by SA3PR04MB9001.namprd04.prod.outlook.com
 ([fe80::3da3:45d7:8860:e196%4]) with mapi id 15.21.0292.024; Tue, 11 Aug 2026
 18:19:01 +0000
From: "Ousherovitch, Alex" <aousherovitch@rambus.com>
To: Krzysztof Kozlowski <krzk@kernel.org>, "Krishnamoorthy, Saravanakrishnan"
	<skrishnamoorthy@rambus.com>
CC: Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>, Herbert Xu
	<herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul
 Walmsley <pjw@kernel.org>, Rob Herring <robh@kernel.org>, Shuah Khan
	<shuah@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "Wittenauer, Joel"
	<Joel.Wittenauer@cryptography.com>, "linux-api@vger.kernel.org"
	<linux-api@vger.kernel.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, Shuah Khan <skhan@linuxfoundation.org>,
	"Nguyen, Thi" <thin@rambus.com>
Subject: RE: [PATCH v3 02/19] crypto: cmh - add core platform driver
Thread-Topic: [PATCH v3 02/19] crypto: cmh - add core platform driver
Thread-Index: AQHdJd2LtMX2FjDMV0GCzBlfTeqwP7aYi/aAgACgzIA=
Date: Tue, 11 Aug 2026 18:19:01 +0000
Message-ID:
 <SA3PR04MB90014C87363F2C6258249673D7DD2@SA3PR04MB9001.namprd04.prod.outlook.com>
References: <20260806195519.2703224-1-skrishnamoorthy@rambus.com>
 <20260806195519.2703224-3-skrishnamoorthy@rambus.com>
 <20260811-meerkat-of-excellent-satiation-d4c32f@quoll>
In-Reply-To: <20260811-meerkat-of-excellent-satiation-d4c32f@quoll>
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
x-ms-traffictypediagnostic: SA3PR04MB9001:EE_|SA3PR04MB8692:EE_
x-ms-office365-filtering-correlation-id: 6df47571-6d87-4a26-231b-08def7d504b6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|11063799006|56012099006|10067099003|6133799003|4143699003|3023799007|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info:
 W6IRnCL0t4POTAfcAC5UOq4bs05wt3qZYbWtiMk8A35uWT/HtwCbojOqngGPHCCC1XYlT5DK6U8aY/YwMA0n5Vepnm8ihy2no2WV1/7JWP8eHyf19dZWjr+t7mXLLHmcWFRENBwUBDY44cfKaT6A2AkEIMwH5e/md6hmnqsMyo3qEPbAkBvywCirVuqggDcebyic2qJxSs9QQyHcHcPBlmH50ARi4LAsfG50bp3e4lt+tVpyeIh5Xpltc3AhXN6tNohaqxHEetvNXtW0OtLuR7zV/YuF9+rWzbLgWCumOfKaD8exnppt1JtnONUGZkdu9e9OtPSQJj2xnv7aP5gK1IqZITg9n6TXul/FYXmk+8dpGaFlow5+c8GIRYulmT38KcglEzqr/WMm5Jh82OtnzoriUXXK6rae02ykK6cM/8krOq3Vyj1JbVwcfkHKmvLcFQL8Fu3q24khOuwfwzhHeNu7SByFyGil4S+zIOWukeNGIa6Te/TRL2oQvDif3lK9Kmwi2gXpyKC/P2GzXu030SRYtLReXik0zer/tf3LuUznjx2pZOGuPzcp6egNiFEUyz4oidd4E5bP3StOIWrveg254D7NOpr7sPtLPU9h+SScgTsdp/Pg9blrYs1kXR6QrGYOkqkz1UVBbhpQr+DQnkdf6fOVOxgS1yS8yf0eckTMMe3DUUWKZyjRtZl9MtCTPoUddJvNGdKATUxj1isIezNHFkvhqCVSPQW2kU5T9MI=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR04MB9001.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(11063799006)(56012099006)(10067099003)(6133799003)(4143699003)(3023799007)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?PpcYD/oAAXL3R0rqQBnJP11KDUpo5whELL8wKNklW6pXaG34vvnchXUzCP1q?=
 =?us-ascii?Q?WOknhtJGFGIuHZ57PwKQAWHJBnCnVgyjYSUkkSYnyppBOIiZhSZgkKhLehV3?=
 =?us-ascii?Q?5DpPhqqbMw0AS3SpNfe7TVs52wBe/kEhmvt8r7XgrYhpNbrVhDRy8sDLqGDa?=
 =?us-ascii?Q?HPqJXJvfb2UWyF9Vpby7hhaV9GrJxrxoPl5bUTus6N8l1VYjFBkmK5CLFR+c?=
 =?us-ascii?Q?96eIybo94I0soPDDaxmuodmzP8CadgPs+d0g7T1JtJQolOTnSBtxnrT+PLmk?=
 =?us-ascii?Q?KyA6d9wXxeSXt5OoXsDwyekOzZZoiWNGr+wrrkt9WtU7nAL+MjizHc1mpKDu?=
 =?us-ascii?Q?AerF+/mlQp1zaZvkS8m/a1ghF1Jbfi6ZEnDd+chwqNdsexefz2ei51aTJKyw?=
 =?us-ascii?Q?/LHBTOQZhPZTDyxSrm7D2r0FIqCWKga+MkDVriRwbCSxzpb0WFE6isRym0lY?=
 =?us-ascii?Q?SSW4x30GtUGX8mjKq4HjGQzCjGEN6ZswJhKKvxbD3tq4raBolQZexJ1h001y?=
 =?us-ascii?Q?lxBKBav+QqlxBcp2epAPKvQO5QfFFUg7wdLdojFzwmwcbKeVyxHFR/bLAJfD?=
 =?us-ascii?Q?xkWFN+pILw5lFkQrtqI1wXJzmPHOz0TfAgZ/YlTEsNtY7Mob+rggjRv0st4s?=
 =?us-ascii?Q?r2zfWws+CrB7PTaNXQByfRJYtPs6nNvLb5nBA075LFwBPiiDk9c64NmYk85B?=
 =?us-ascii?Q?zWF7pwJ8FXuUsBRC8jAoRPPUZGAII0yTZQsBWDAd+zJQvpXBjU4S1nmzVPu3?=
 =?us-ascii?Q?rYePDADueC9do3OQXGWUVXmbiU7ORklr7WmcZKBZUfeHv2yi0eZoybR1LQVV?=
 =?us-ascii?Q?9CXwlkV/8DTXKMb0KeQi5LSQvYSDP37gXMZaSjQkAkUY9ikT5FQ4OwDT5Hku?=
 =?us-ascii?Q?WilcG9BaLO4xB9MxCMonwsqccNu5s8ryWfbV3RpxEHFvG4TgCHLyBbJcUZfJ?=
 =?us-ascii?Q?xrrigpzP/wPwhkGtDdZhHptktO4U/Rouyc4XMD+vIkisFBIe2SmtoroMsP46?=
 =?us-ascii?Q?gdoi+5+ZojPl/m/ZXEl/PgZdbwg1lN0++7ixxfEvyscy+cdOZiT/hC+0kGM0?=
 =?us-ascii?Q?S9s2M5ftw1BdOsNw3nYuyB+v3ZG17BMsQ6DomRXSJbFx1NyCjbtRvniODI66?=
 =?us-ascii?Q?RnQD5kM5iHo+pEKW2upbQNmfSueXh3aGO8Bq4GlfcNtlnPEDpIX3gg07XbLB?=
 =?us-ascii?Q?+1ltK06iz5sd4QUZhxP+KvdmkfobpTd0w2zKVupBgaybvfmodPDCMhtQajiA?=
 =?us-ascii?Q?bijyuE/LLKd9pXPsh42FvHKS6ALsnYAbY9cHFWAi809RHDG5vol6UQl0yQw4?=
 =?us-ascii?Q?OTCDcMxeZeeFK0Mh7MnSBPawx1d7Tp6fx3bVxNY+5T8hX/fv7gjq94TFK6Po?=
 =?us-ascii?Q?qUlG6SZ+FOnhe46WmAT0pMjM87PyKnrAJJ1ZNrJ4RFVlksHa4xb18gsGM4o6?=
 =?us-ascii?Q?lU9RbFgiuIotZ+Kyitbief7fpTTpuUNvZaCiDbN9GJmEk9ii4OsX0KlGrA9B?=
 =?us-ascii?Q?gfLZJ1pPRaNRN2WyRmeiAu4e5KLFmJ+BU47nGBkyrk5TMpgFbtcc57pezCri?=
 =?us-ascii?Q?veAEIKH4hwugPT4rZOYKViXcz0D9Hssf8TMBce8uj03WppWaWn1HzAgLfocB?=
 =?us-ascii?Q?FGIdGZci/HDv2H7b5O9Ib0XunPm461DhA+sx9OtUB04s164995ogJGTh27TF?=
 =?us-ascii?Q?BnPmwvpxArr1aWGAEFarKO5GXxxLvIF4qmxX9L1xiOx4R5ZSg5S3490VVXcH?=
 =?us-ascii?Q?3gjRaIPhqw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6df47571-6d87-4a26-231b-08def7d504b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2026 18:19:01.2232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yIk1pwwQsGUeghmF1/nbseqDiE2KPAb42o4wlfrI0EwKpMVBlXG0y8UMeUg3zxxNef1bGJgaPgQUa7O43uhR2konL9NlpS6CVom7NwLh/Gg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR04MB8692

On Tue, Aug 11, 2026 at 10:31:47AM +0200, Krzysztof Kozlowski <krzk@kernel.=
org> wrote:
> > Reviewed-by: Joel Wittenauer <Joel.Wittenauer@cryptography.com>
> > Reviewed-by: Thi Nguyen <thin@rambus.com>
>
> These two reviews did not happen, drop the tags. The code has trivial
> mistakes from downstream code. Internal review would point these trivial
> issues, so I do not believe you received valid, meaningful internal
> review which would justify the tags.

We will drop them. Any future Reviewed-by will come from on-list review.

> > +MODULE_ALIAS("platform:cmh");
>
> Why?

Redundant with the OF match table; we will remove it.

> > +MODULE_IMPORT_NS("CRYPTO_INTERNAL");
>
> Why all this is in completely odd place, not next to the module init
> code?

We will move it next to the module code.

> > +static struct cmh_device *g_cmh_dev;
>
> Eh, no. Don't implement singletons.

We will remove the singleton and use dev_get_drvdata() /
platform_get_drvdata().

> > +	dev_info(cmh_dev(), "CMH eSW fully operational ...\n", sw_boot);
>
> Drop

We will remove the dev_info() logging across the driver,
keeping only genuine error paths.

> > +	if (g_cmh_dev)
> > +		return -EBUSY;
>
> NAK

We will drop the single-instance guard together with the singleton.

> > +	dev_info(&pdev->dev, "loading v%s\n", CMH_VERSION);
>
> NAK and internal review should tell you that

Will remove.

> > +	dev_info(cmh_dev(), "sic_base=3D0x%llx size=3D0x%zx mbx_count=3D%u\n"=
,
>
> How many dev_info are you going to print?

Will remove.

> > +		dev_info(cmh_dev(), "enabled %d clock(s)\n", ret);
>
> Again?

Will remove.

> > +		dev_err(cmh_dev(), "failed to acquire reset GPIO (rc=3D%d)\n", ret);
>
> Syntax is ret =3D dev_err_probe and internal review should tell you that.

We will use return dev_err_probe(...) on the probe error paths.

> > +	(void)cmh_debugfs_init(cfg);
>
> Why the cast?

We will drop the cast and check the return.

> > +	g_cmh_dev =3D dev;
>
> Nope (and we do not call things "g" from globals)

Will be gone with the singleton removal.

> > +	dev_info(cmh_dev(), "initialized successfully\n");
>
> NAK

Will remove.

> > +	dev_info(&pdev->dev, "unloaded successfully\n");
>
> NAK

Will remove.

> > +		.name           =3D CMH_DRV_NAME,
>
> Use name directly.

We will use "cmh" directly.

> > +	 * g_cmh_dev -- that would defeat deferred probe.
> > +	 */
>
> Why do you need this? Why your driver is done differently than all
> others?

We will drop the custom init/exit and use module_platform_driver().

> > +module_init(cmh_init);
> > +module_exit(cmh_exit);
>
> And this is not module_platform_driver because...?

Will switch to module_platform_driver() in v4.

> > +	dev_info(cmh_dev(), "MQI init complete (%u mailboxes)\n", cfg->mbx_co=
unt);
>
> NAK

Will remove.

> > +	dev_info(cmh_dev(), "MQI cleanup complete\n");
>
> NAK

Will remove.

> > +		dev_info(cmh_dev(), "rh: no mailbox IRQs -- polling mode\n");
>
> So a warning or info?

Will remove -- polling is a normal configuration, not worth logging.

> > +		dev_warn(cmh_dev(), "rh: no IRQs -- using watchdog polling ...\n",
>
> And here it is a warning?

Will remove.

> > +	{
>
> What is with this indentation?

We will drop the naked block and restructure.

> > +	dev_info(cmh_dev(), "rh: initialized (%u IRQs, ...)\n",
>
> One more dev_info....

Will remove.

> > +	dev_dbg(cmh_dev(), "rh: suspended\n");
>
> No, you cannot have even debug messages which re-implement and
> duplicated standard tracing and standard debugging code.

We will remove these debug messages.

> > +static unsigned int backlog_max_depth =3D 1024;
> > +module_param(backlog_max_depth, uint, 0444);
>
> Drop all module params, not really right way to do things.

We will drop all module parameters and move the genuinely useful knobs
to debugfs.

> > +#define CMH_VERSION    "1.0.0"
>
> NAK, this is not allowed in Linux kernel code. Do you see drivers
> (except complete junk from AMD) doing this?

We will remove the driver-version define entirely.

Thanks for the review.

Regards,
Alex
