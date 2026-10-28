Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.13.36
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793207091;
	b=Ig/t+lPJOt8ZgBoYIyvYtyNMc+SQjgTW+l7gy7bQu4PEcdqPRhf2gMx9X+gIbZqt7/cX
	 fOj3pBG+khpoBvugfoqkfnMC7o25mltynSfTNb2tSKsAl+S73V1aOunO2HSKaevj6gaaf
	 Ubl3pU8LfNrHZYtShEQs3cRgheh+LDniTEe7hvp+Fr29gOtFUeLylzy9NOSx6D+3ewmHr
	 cO1hHUxixlep5w5j1rZKXCCmIy17pamV1F+4iiqm9kfXjcB7gSui10a9+ukW31Ly+EpnT
	 iUwUsogdl3qfcZskFDznUzm9V8fCp4Ku5N/pNeyS7zQ/jvaAqrLTEosIgw+V0mBcMXQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207091;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-slblob-mailprops:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=cpLDyW8UkPP884hkN4EGtlrqnA++fiMEd88KHx3Un/I=;
	b=uVJJzO51Yq8feAW5vmEWtbxCtSH+9TQy6oZtpa1cfrX9zh1Eadh+iSu5fCIg9ULdjYAD
	 fgOoRaT59YJxwGgeKALGvUep3uRj4tfSsjMKc5roaVuyrY/hBCdojGQg8eWEaKij0LB/V
	 IT9AaYggd6w6OiCiMVYMyGYGOP3ZIFAE6K0S88x1cmrEGNY8SjT0a2+KUfPsad8A+7jgb
	 xXl+09x35VCkZdPBhdWjaj8YkJxfAOcaSyyQXHdylB0cnwCCWdJQn0vq6cw8UlPjZ1ebk
	 6efbPaZCLknVGEQET1q52A15GxwWy6T/gV+SKZk6bJuxLHnv/ADR8074ZmFfTfOa1pQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=rxHktLEv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.13.36
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazolkn19011036.outbound.protection.outlook.com [52.103.13.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27970606A31D;
	Wed, 28 Oct 2026 17:04:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27970606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=rxHktLEv
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xnn3UHSpqrG9tQYxb+1bwEz8clWshEzi5L3odQqo4pEyHE4LomCxnWRqLcDTcTQ3XnjEwFNIBjz5ocLU8e/CAZNOFvSbj9Mzba+ayCxuFyBN1Mo2iQhfmHi5aLoZumt5hUa8IlZtzjeU/IoFx3tLM3rqXwEDv/tvClMJiWIL6D53ds6pNoJ4TjOQ+vyJ+LJgqMu7c63E7/AiypHPY9Idy8dxDVppmSOfJCsk/7M1F2BVcy3clDcS0Q0uBejiSSyhd/uolWCBwpzykW3qz89QXqHCeB4VOxNyYOstdf51VxmsqPJecQNDnyNQpUbRGPFMPDDKvyaE7T8EoPNKTBVRMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=cpLDyW8UkPP884hkN4EGtlrqnA++fiMEd88KHx3Un/I=;
 b=m88eeTr+uxMdvHVqob/Pl8rQK4pyI87zC12H2P+ZN+OTNBniVyNZVoL0hc6J3co+s2e7Ntsn1QFn+Siu/w3rM2Pa6yEmLl+827BqkztL0zQfGhXqx444dwk2CoSKFEcfU3e9iWBL8ib0QkHBk/jVQKFYK2l/56CHn+Zsiaxj3ktAzje8plj9jkuF90SStPTxP6+2uJ+H79AnJX1H2l10Gubsjbj1nTOd2eKhe/dsmGDAaOlAZ0K8jefv0BmhNsNdg1mRwST7/pGPlNjD7xJo3Ah19lXyYApkjWivfq8ffd1S7fZwwCjEzZ8LIZBsQ7aHilQjsE3BTd37Fhd7CstCoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cpLDyW8UkPP884hkN4EGtlrqnA++fiMEd88KHx3Un/I=;
 b=rxHktLEvgo9nrhIrov2KjyNQ4CSdJkoLBXdJ0lCHR1QHc9nAPeMu5v5S8t0vfUUmcLztvP3Dcmjh3WzjQLYMKd4Z00VGzMkzCLclWRszaSOUBmoh7D8lqdvNCnXfOsPjFNbFHs6fVaZGRL/ImGVCc9CP8tPN0xje3IV1+9Z4OHtor7oSZ2kGpZ7mz1rth2Ht/THIgpDH+MLbgsSevLIHaQTmwDa9/bIzhKAz3g5Lcrkd9cczQh5qaSYEkjhOJ4EK5HU/CLgGvpgpzP+XXjuwywImGMoVmjTdwaG6z4rlFlQdxZB5+m8KIqu+J/e3hu2ZN1iB08mV2VBjaPqdadQc1Q==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by MN7PR05MB211011.namprd05.prod.outlook.com
 (2603:10b6:208:633::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 17:04:03 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 17:04:03 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Manfred Spraul
	<manfred@colorfullife.com>, Alexey Gladkov <legion@kernel.org>, "Eric W .
 Biederman" <ebiederm@xmission.com>
CC: Yingjie Wang <x-professor@outlook.com>, Vasily Averin
	<vasily.averin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt
	<shakeel.butt@linux.dev>, =?iso-8859-1?Q?Michal_Koutn=FD?=
	<mkoutny@suse.com>, Michal Hocko <mhocko@suse.com>, Alejandro Colomar
	<alx@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v4 2/3] ipc/sem: reject negative SEMOPM values
Thread-Topic: [PATCH v4 2/3] ipc/sem: reject negative SEMOPM values
Thread-Index: AQHdZv5SqBSvVazyxU+7LHARfc+IAA==
Date: Wed, 28 Oct 2026 17:03:59 +0000
Message-ID:
 <f720aa7102f44aed528b787337499592ec260a32.1793207025.git.x-professor@outlook.com>
References: <cover.1793207025.git.x-professor@outlook.com>
In-Reply-To: <cover.1793207025.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|MN7PR05MB211011:EE_
x-ms-office365-filtering-correlation-id: 072b9f22-1c50-488c-4408-08df35157678
x-ms-exchange-slblob-mailprops:
 iS5pQZgsAQDZd5pLvsexcGXRgbvG27NWraBZf1tfLtervTlbC8LWZzWdvdDy/1eMOgGmujC6dBGj1ZNibF6jyuxHGXCORkyoLgPLuw1LfXboDRnDLxHgcecJqfSQJIJZrnWQKsKev8kYpyF2cicHhowim9Z8We76oLpkZ+G6qngiQDmUaUSau/x+gTiYwCdSKwiSGTEGIf2ELWuIelHoTEmmi89DEjuGGH2t1utI/BpDk204umNdj1bTK7EHFN8njQaJD4OkXXslw3jN4vlyvqeOc7hCy2WwnY21k4eWMz+gdq6uiIFbceL1TPCihnGEyW0gMu/OV3mF4wTnVXaioyzonrl8zqQko0YuXW3Vvs+W0pYX0WzNbl7af3+GK7iQPYIqSpvZOKuIVvO6a4p8zErkfA0KthaobiGE7Y4NZSgV2bnw82pHF9+58B7m9jxMqDUVaSpSkyO4dS4bCkTGvwZUZWc7cU6Mw5rbOfWLPBKRRksaNGPw6UJVr1LJrM23iWKK46JVKxChIfe0TDLVYjDt0cgW6uApEGDDYBf2FAfWc+5U6qeMnwmoIuQUl2vejtlsZMAz5b5tLkZOlQ0NbfvdvjK2cFOw/ji2dS7sqlVoQzzQ5WylGYp4iCpm1JDNKuafK5C6obzmwDqWyztPlfNH+RiqYRl9CG/b3M9ACp7QsvVgTTEo1lL1SR12kyQ8bOJW/3otkhFIQsXaLx2QeFCrjSuBnpySEmtGi34Q6nqYmmu5VgGtI4HYxcByWZ5N1Fh1SGxb11iLhjVK2d78dSl2RwYTbExM9COp37amZYUfrqY2XwS7zRiEb3MlvL+l
x-microsoft-antispam:
 BCL:0;ARA:14566002|22091999003|15080799012|24121999003|24021099003|31061999003|8062599012|12121999013|8060799015|41001999006|38102599003|4140399003|25010399006|19110799012|102099032|3412199025|4302099013|440099028|1602099012|12091999003|52005399003|40105399003|26121999007|10035399007|1710799026;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?8SWMCtlBeOURuCCPDi5CkYvwmwe7W5dWZYekOSzAeDvJWMCny3QSXX8RYE?=
 =?iso-8859-1?Q?hyZElxL7lFw4prI+xP7Gq9Tt5JfeMNLfRFGodSRbZ+pdBG+GnnzMViIwdI?=
 =?iso-8859-1?Q?A+v59Fust/Nq0VHZHB0iFKNsz0CJRrgnF8E3nRQliO9yqc1HDlWwcCxXmR?=
 =?iso-8859-1?Q?tWYm/aMEa0Pt73u5n+fwlsMPX+0Zm8Tf9JojPhrtBM+rtwm9Ta8NVu09xU?=
 =?iso-8859-1?Q?L41QwmnDXBm7IRlQt1Aawwuc6zYBJ08lXnt7gRwXWi/43GXzwEevkjREpy?=
 =?iso-8859-1?Q?vmaB8wqOqoIimq4kd3yJQ4w8tDu8C9vylTYS0+SM/9vbHimMGK/EE5TbJ4?=
 =?iso-8859-1?Q?mSVEfR/+Lf8s2bGxrQSaiKvy8nG3zPWgJOuSKF3+04STEmwFvin3KoqrBz?=
 =?iso-8859-1?Q?//DlW8Jv2ZS40N58IKakuNt72vnU7Epsrli6bQ3bK3Pp3hWFo/hpo5gHb+?=
 =?iso-8859-1?Q?vA7blX5xOzpoQyuInGpTZTOcK0gnIFklHCErFuTG6ez8UMfS5TLKmJfrIM?=
 =?iso-8859-1?Q?jc+P3iGDuagVRIeiPNAsKV28f1n0ZUiSpoocL2quEAqg15oIlw+I4vkmG0?=
 =?iso-8859-1?Q?Lp+FhpAZbj+1KjcYstWzdj6Yp7DZJjsqHfJTsn4ub/rr4Bhg8r9FlbIjvp?=
 =?iso-8859-1?Q?3Me9ZbDJUzqqxpzlwz/FHMhX5FalsobNzU8A8fDP7KhUOqQWE5TT8yHCgU?=
 =?iso-8859-1?Q?q+Riv2dfI5EtpfVzyZVb+amv19YIKLC9K2Bc45IlgMaUhItTsMOF/xjpsv?=
 =?iso-8859-1?Q?g+H9VQ8L5OfhfRWDngfIrh0cbvSLbGRTOycKH5y1w53Vztbz7jvI8yu/px?=
 =?iso-8859-1?Q?PSzmEoms8EUBbZVtI67yZOPQsE/zq+deaBsJ/WAPkIOShdbdBcqFSkiSko?=
 =?iso-8859-1?Q?kxZLVtARsMDceGvDYjXYviz985zwj3c8mJxdTWPZgzWABxljRu17AUGyVS?=
 =?iso-8859-1?Q?9gHKDI7hOiCZB0ABirAd3tkIE+BkfDX4yhJYTFCAqQQbudldvEVqhp4HIp?=
 =?iso-8859-1?Q?sZklRs0v+qTo9meLSiXbml8GyLncJO9XiQRZwNm8gzaHFU36rn1ciDXsf2?=
 =?iso-8859-1?Q?1Oxkl/zMK/xtYnUuGH3e2CoknqCTsThBp7n0Kykw9K7aKpkwE7n1JBc2c/?=
 =?iso-8859-1?Q?rLz+3oO6qH0C+kn3kD/SHktjy2UXsBdvrmxbWQmX3s24ux8wjE+3c1uh+d?=
 =?iso-8859-1?Q?3f6E3Xjx9mRpBfPetP7HsTBXZwOqj/KGEat+Hs+OcDoew1BMPHzeN4kkbG?=
 =?iso-8859-1?Q?T8hzGq7txYALykPtT/zOv/EI2DqDsCueZVWnij8hk=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?tHGBtT95vmOhFzGP5LygOpCyFH9LaGmOlzU/jgzW4NE0N4kYi1H6Be57Ev?=
 =?iso-8859-1?Q?l5iY27Bq7flVGexaqD5OFgNPpGaIgc40Z4/uokgDmG7/Ofoa4g4FZ2u+ak?=
 =?iso-8859-1?Q?9V7d1EAQCbdDECxLZov6UgzRZPlnDJXUW81MYsIavAPSglOkTP/9/MLvZq?=
 =?iso-8859-1?Q?WSeGQRPSUUWASyjGuS4LqVYM5onlW+zEVeMyV6Uugr8U5AgsHoolOe3sCs?=
 =?iso-8859-1?Q?sERNuoxvoIQuOHSIKiUrgCI6y1f2FJhNhMkA8j40IBXzQ8U2v5dgrdM0Dt?=
 =?iso-8859-1?Q?gXf3a7j6J3TSLctil+arfAdCX09xStPnpgHhHzgQcNaUe8c4Md+l/m2Naj?=
 =?iso-8859-1?Q?oxf1iyKMEstG5gyF3dXIaZOauDhAKvLrxt0pfXxr8HvYhcya0AYjK1xA7S?=
 =?iso-8859-1?Q?u12gK6pLsiCUEmTlQd4uDNwZhkA5yejnKBzzKwpALimY3HXDeM3JQ4ZSL/?=
 =?iso-8859-1?Q?mU8V5uoVw8aPuFt6aLa8GcZUYcSTQWdIcSJdU87WxQFiaDAENamWiWYvPV?=
 =?iso-8859-1?Q?MOTMQ/z5Lg7k85PGYnB1tFHAtoi4Eg+Z405RyVYSk6Mq5ovJ5eTcwL/VIK?=
 =?iso-8859-1?Q?sgFiumuOz9Zrxj+bTOPf/GTGdlb9bTi6WLPjNTKEGTpQ1+x11Ttgz6O0wd?=
 =?iso-8859-1?Q?Rc9VdX6r3F/nNQE2sgv8SYaqi7jDpAhkko4IiH5SC/zK5iSLun0/0xZL1X?=
 =?iso-8859-1?Q?QlPOVaMKKABAMdjupKZ7TqfuD2W4KUkwh5QxPZ4tpLpvqqoSED0EmAzIfl?=
 =?iso-8859-1?Q?uacx7UxOpjX4gydDwIsAEh3CY+HYXtfsrk7RONxk+fVykCkXejPaGcEXzk?=
 =?iso-8859-1?Q?rya7tEJcwsX6nUVk6fIfYvxJxISEh8GF/1tpEcaz1SOiuevG7XR2CxX0G2?=
 =?iso-8859-1?Q?yvaktLq8xPtUKRkZ+ITAjs3uLEaeC+o9bFzTyFS7Lb3gtAUItldJ58mw+I?=
 =?iso-8859-1?Q?a1/wQ8OWVVx+aACYh6ra5OV2ogEvJWHqEnw0/t1lPFT7IBliGFtutMHWqN?=
 =?iso-8859-1?Q?kVi2mbapyHAIZLjOHsYTyPDbj2HJ7KFwq7cAk9b1N4t46dS/ZljbSXZr6h?=
 =?iso-8859-1?Q?Kuoj9W15/6x5fZwJeV36Oz8fFbhA+CySwcifgV/TbZ8wgOSENGv6IZtDJZ?=
 =?iso-8859-1?Q?HmdbZEAXWY9QdIMazNJIskTENUc0LiIyRv4Rq7CaOpCzdYHpE8H2hhhx6M?=
 =?iso-8859-1?Q?4Jo1Q0u4eSYGHdrLfi3LsqLUY6dW4oIbIt2OTvo+NAImG2XLst5++MaMU1?=
 =?iso-8859-1?Q?gINAgBV/YVJ0H+uKrzkGbl/XTr6GyvTXT984nzDeSlbTM68nW3sp/+SDnm?=
 =?iso-8859-1?Q?9aABWL0KluxjP6WQzoj5IFle6x19eqs7XMnjy2AHSDS5LPOtpU28GK+d84?=
 =?iso-8859-1?Q?QR9T/oblWm9K1hvdqU/OaVuHCyVJTytt+u/H/mTFXkqI/egvJ+hbhA2ApE?=
 =?iso-8859-1?Q?U/h0Ax7sF/aHHmxL?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 072b9f22-1c50-488c-4408-08df35157678
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2026 17:03:59.1056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN7PR05MB211011

The SEMOPM field has been stored as an int while semop() receives an=0A=
unsigned operation count since the beginning of Git history. A negative=0A=
SEMOPM accepted by proc_dointvec() is converted to a large unsigned value=
=0A=
in the comparison, defeating the intended operation-count limit.=0A=
=0A=
Commit 50ec499b9a43 ("sysctl: allow change system v ipc sysctls inside ipc=
=0A=
namespace") made kernel.sem writable by IPC namespace owners without=0A=
capabilities in the initial user namespace.=0A=
=0A=
Parse writes against a temporary copy and validate SEMOPM and SEMMNI=0A=
before changing the live settings. Hold a per-namespace mutex from the=0A=
snapshot through publication so concurrent sysctl writers cannot publish=0A=
stale values for fields they did not supply. Access the live fields with=0A=
READ_ONCE() and WRITE_ONCE(), preserving the per-field access semantics of=
=0A=
proc_dointvec(). Read requests continue to use proc_dointvec() directly.=0A=
=0A=
Failed writes leave the live settings unchanged. Successful partial writes=
=0A=
change only the supplied fields relative to the latest locked snapshot.=0A=
The writer mutex retains the existing per-field visibility for readers.=0A=
=0A=
Keep zero and positive SEMOPM values valid. Zero continues to reject every=
=0A=
non-empty semop() request.=0A=
=0A=
Suggested-by: Andrew Morton <akpm@linux-foundation.org>=0A=
Link: https://lore.kernel.org/r/20261016155905.2a659b7bb7d61f33467a3263@lin=
ux-foundation.org=0A=
Link: https://lore.kernel.org/r/51c93c19-f1dd-455f-8698-6b1ee30eb630@colorf=
ullife.com=0A=
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")=0A=
Cc: stable@vger.kernel.org=0A=
Reviewed-by: Manfred Spraul <manfred@colorfullife.com>=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
 include/linux/ipc_namespace.h |  3 +++=0A=
 ipc/ipc_sysctl.c              | 35 ++++++++++++++++++++++++++---------=0A=
 ipc/sem.c                     |  1 +=0A=
 ipc/util.h                    |  9 ---------=0A=
 4 files changed, 30 insertions(+), 18 deletions(-)=0A=
=0A=
diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h=
=0A=
index 12faca29bbb9c..c06568ccfca88 100644=0A=
--- a/include/linux/ipc_namespace.h=0A=
+++ b/include/linux/ipc_namespace.h=0A=
@@ -4,6 +4,7 @@=0A=
 =0A=
 #include <linux/err.h>=0A=
 #include <linux/idr.h>=0A=
+#include <linux/mutex.h>=0A=
 #include <linux/rwsem.h>=0A=
 #include <linux/notifier.h>=0A=
 #include <linux/nsproxy.h>=0A=
@@ -31,6 +32,8 @@ struct ipc_ids {=0A=
 struct ipc_namespace {=0A=
 	struct ipc_ids	ids[3];=0A=
 =0A=
+	/* Serialize kernel.sem writers. */=0A=
+	struct mutex	sem_ctls_mutex;=0A=
 	int		sem_ctls[4];=0A=
 	int		used_sems;=0A=
 =0A=
diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c=0A=
index d038d944257f6..0e3608258fe29 100644=0A=
--- a/ipc/ipc_sysctl.c=0A=
+++ b/ipc/ipc_sysctl.c=0A=
@@ -51,21 +51,38 @@ static int proc_ipc_auto_msgmni(const struct ctl_table =
*table, int write,=0A=
 static int proc_ipc_sem_dointvec(const struct ctl_table *table, int write,=
=0A=
 	void *buffer, size_t *lenp, loff_t *ppos)=0A=
 {=0A=
+	struct ctl_table ipc_table;=0A=
 	struct ipc_namespace *ns =3D=0A=
 		container_of(table->data, struct ipc_namespace, sem_ctls);=0A=
-	int ret, semmni;=0A=
+	int sem_ctls[ARRAY_SIZE(ns->sem_ctls)];=0A=
+	size_t i;=0A=
+	int ret;=0A=
+=0A=
+	if (!write)=0A=
+		return proc_dointvec(table, write, buffer, lenp, ppos);=0A=
 =0A=
-	semmni =3D ns->sem_ctls[3];=0A=
-	ret =3D proc_dointvec(table, write, buffer, lenp, ppos);=0A=
+	mutex_lock(&ns->sem_ctls_mutex);=0A=
+	for (i =3D 0; i < ARRAY_SIZE(sem_ctls); i++)=0A=
+		sem_ctls[i] =3D READ_ONCE(ns->sem_ctls[i]);=0A=
 =0A=
-	if (!ret)=0A=
-		ret =3D sem_check_semmni(ns);=0A=
+	ipc_table =3D *table;=0A=
+	ipc_table.data =3D sem_ctls;=0A=
 =0A=
-	/*=0A=
-	 * Reset the semmni value if an error happens.=0A=
-	 */=0A=
+	ret =3D proc_dointvec(&ipc_table, write, buffer, lenp, ppos);=0A=
 	if (ret)=0A=
-		ns->sem_ctls[3] =3D semmni;=0A=
+		goto out_unlock;=0A=
+=0A=
+	if (sem_ctls[2] < 0 ||=0A=
+	    sem_ctls[3] < 0 || sem_ctls[3] > ipc_mni) {=0A=
+		ret =3D -ERANGE;=0A=
+		goto out_unlock;=0A=
+	}=0A=
+=0A=
+	for (i =3D 0; i < ARRAY_SIZE(sem_ctls); i++)=0A=
+		WRITE_ONCE(ns->sem_ctls[i], sem_ctls[i]);=0A=
+=0A=
+out_unlock:=0A=
+	mutex_unlock(&ns->sem_ctls_mutex);=0A=
 	return ret;=0A=
 }=0A=
 =0A=
diff --git a/ipc/sem.c b/ipc/sem.c=0A=
index a8c9807175520..0f7d32c12993f 100644=0A=
--- a/ipc/sem.c=0A=
+++ b/ipc/sem.c=0A=
@@ -249,6 +249,7 @@ static int sysvipc_sem_proc_show(struct seq_file *s, vo=
id *it);=0A=
 =0A=
 void sem_init_ns(struct ipc_namespace *ns)=0A=
 {=0A=
+	mutex_init(&ns->sem_ctls_mutex);=0A=
 	ns->sc_semmsl =3D SEMMSL;=0A=
 	ns->sc_semmns =3D SEMMNS;=0A=
 	ns->sc_semopm =3D SEMOPM;=0A=
diff --git a/ipc/util.h b/ipc/util.h=0A=
index a55d6cebe6d3b..51b4efa3d6db0 100644=0A=
--- a/ipc/util.h=0A=
+++ b/ipc/util.h=0A=
@@ -245,15 +245,6 @@ int ipcget(struct ipc_namespace *ns, struct ipc_ids *i=
ds,=0A=
 void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,=0A=
 		void (*free)(struct ipc_namespace *, struct kern_ipc_perm *));=0A=
 =0A=
-static inline int sem_check_semmni(struct ipc_namespace *ns) {=0A=
-	/*=0A=
-	 * Check semmni range [0, ipc_mni]=0A=
-	 * semmni is the last element of sem_ctls[4] array=0A=
-	 */=0A=
-	return ((ns->sem_ctls[3] < 0) || (ns->sem_ctls[3] > ipc_mni))=0A=
-		? -ERANGE : 0;=0A=
-}=0A=
-=0A=
 #ifdef CONFIG_COMPAT=0A=
 #include <linux/compat.h>=0A=
 struct compat_ipc_perm {=0A=
-- =0A=
2.43.0=0A=
=0A=
