Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=219.87.157.213
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795493068;
	b=1wpKQeYXw7t+28cLh1rVNSnJzI+HTTzdVZtOmY29N5PwK39K2ernXlrSgepDEjhK800D
	 qj5abVKd6yYzn/OT60fNKT4yhJDWJq0jSX+sBBvGT1rgnLrQiYfbF+bjj4udYpl4iNDFM
	 RDSgMvjpiCU4zefTn6pn8qATYHvGmBcvMY/5vCr2dRKAPhJL2VGlkFIACXHbwbdC00ZpH
	 Qq1+I2LTx3Y99G+YSD/NrExSsR2SUOMj5d1q6lQZlQoSjM28SJ9iI5DTfTwX5e3+L2SE4
	 aURg0T/H89WLi2VHggDxUHXBL//mDINeBbmwmIgS+RAsS/rh13jOmjQgt2SLpn0pxRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795493068;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 Received:Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-originating-ip:x-tm-snts-smtp:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-MAIL;
	bh=dEAWrCcLPoqiH1o+NThWPO02RVOnV+Cf+QRng64jUU0=;
	b=SG/1LCiOIOUFHA4132wVVZf5pzX2IP5snfh05aJIA9upI92LxR5bEdut46ocdWsZQIF/
	 TToqu8c8Ud/cpbOph+x1d0S96hmmKGkExwitCd8vdGAnrHEk4jybStjlTIiOWaPwrXBOU
	 g0Bu2MQLSk9wEnmdjCuwT6feMaL4Lj72HOCbMqEG40DpZeagU+PJQdUKeV4YKm1X3+soO
	 lE2HuiIbb1PoMWK7tKssuTqhE3cLzek5q4TTllwH+IK6D6DmSvjppN7acjdj+UoMY472y
	 oin3HeiI80eWYwYFwykez33dQqKS/RrX5vPgiiy+7LA96SWBkDGlzbXrZWrgMoTEOiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ite.com.tw;
	spf=pass smtp.mailfrom=ite.com.tw;
	dkim=pass header.d=ite.com.tw header.i=@ite.com.tw header.a=rsa-sha256 header.s=dkim header.b="hhOo56/9";
	arc=none smtp.remote-ip=219.87.157.213
Received: from ironport.ite.com.tw (unknown [219.87.157.213])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C376606A322;
	Tue, 24 Nov 2026 04:04:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C376606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ite.com.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ite.com.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ite.com.tw header.i=@ite.com.tw header.a=rsa-sha256 header.s=dkim header.b=hhOo56/9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=ite.com.tw; s=dkim;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dEAWrCcLPoqiH1o+NThWPO02RVOnV+Cf+QRng64jUU0=;
  b=hhOo56/9ZFHFp9xNU6L7xYfJ5fU3DDsY02xJBOkfy0XNwKw0D1I6iZjb
   QEd3Uz31rPRqkaIuqE23zvsyJvwXvFy2/Mhsva4ZeRNxXD5l1/Bn3HYGw
   pWCqO8Rk3ZRohgOrvCIGMbBLi4AKuV5Ax1XKLDeNuoZnYcIZEtpmxRvpL
   3R385ypE8mYJzOZc9oAJooiGmT4OO9P2oEiC4L8UPLKqEpBxlMfF9cFsl
   TP2hSyoyf92NS2TutbdAPpPBVsXf8cdRd6ZedbbbO1Y6KYrOwDcW7VoZD
   3bn8NVtah8GP0ahZJxDC/8KjOx05KwvWrm4L9BNW8tvum7Hn9zCPdb7iE
   Q==;
X-CSE-ConnectionGUID: h/fAIDetRKKIlsimI97AkQ==
X-CSE-MsgGUID: oy362wzoRtajGhP9azZp3g==
Received: from unknown (HELO mse.ite.com.tw) ([192.168.35.30])
  by ironport.ite.com.tw with ESMTP; 24 Nov 2026 12:04:20 +0800
Received: from tpemail1.internal.ite.com.tw (TPEMAIL1.internal.ite.com.tw [192.168.15.58])
	by mse.ite.com.tw with ESMTP id 6AO44G8V056318;
	Tue, 24 Nov 2026 12:04:16 +0800 (+08)
	(envelope-from Hermes.Wu@ite.com.tw)
Received: from TPEMAIL1.internal.ite.com.tw (192.168.15.58) by
 TPEMAIL1.internal.ite.com.tw (192.168.15.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 24 Nov 2026 12:04:16 +0800
Received: from TPEMAIL1.internal.ite.com.tw ([fe80::63c1:9095:c5a6:3291]) by
 TPEMAIL1.internal.ite.com.tw ([fe80::63c1:9095:c5a6:3291%3]) with mapi id
 15.02.2562.046; Tue, 24 Nov 2026 12:04:16 +0800
From: <Hermes.Wu@ite.com.tw>
To: <Hermes.Wu@ite.com.tw>, <mchehab@kernel.org>, <robh@kernel.org>,
        <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
        <hverkuil+cisco@kernel.org>, <hverkuil@kernel.org>
CC: <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <broonie@kernel.org>,
        <lgirdwood@gmail.com>, <linux-sound@vger.kernel.org>,
        <linux-api@vger.kernel.org>
Subject: RE: [PATCH v2 8/9] media: i2c: it6625: use the standard audio rate
 and present controls
Thread-Topic: [PATCH v2 8/9] media: i2c: it6625: use the standard audio rate
 and present controls
Thread-Index: AQGjzAf29/U6qc1EEeqYH4GUceBqBQDHK9mct6nASzA=
Date: Tue, 24 Nov 2026 04:04:16 +0000
Message-ID: <4529217252414e4aae7fae1fecf44940@ite.com.tw>
References: <20261124-upstream-it6625-alsa-i2s-v2-0-a154685f6989@ite.com.tw>
 <20261124-upstream-it6625-alsa-i2s-v2-8-a154685f6989@ite.com.tw>
In-Reply-To: <20261124-upstream-it6625-alsa-i2s-v2-8-a154685f6989@ite.com.tw>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tm-snts-smtp: E2799EA8931143F52E15C7D03EFB0E4ECC717B7CDB651AF557A22ABE8DB3700B2002:8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MAIL:mse.ite.com.tw 6AO44G8V056318

VGhlIFNpZ25lZC1vZmYtYnkgaXMgbWlzc2luZyBmcm9tIHRoaXMgcGF0Y2gsIHNvcnJ5IGFib3V0
IHRoYXQ6DQoNClNpZ25lZC1vZmYtYnk6IEhlcm1lcyBXdSA8SGVybWVzLnd1QGl0ZS5jb20udHc+
DQoNClRoZSBuZXh0IHZlcnNpb24gd2lsbCBjYXJyeSBpdCBpbiB0aGUgcGF0Y2ggaXRzZWxmLg0K
DQpCZXN0IHJlZ2FyZHMsDQpIZXJtZXMNCg==
