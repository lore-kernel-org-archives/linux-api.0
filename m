Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.251.196.230
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795492991;
	b=DpPsczh6cYBwtedJmPdiRpbXzUTEEZgmtyUOrP/bf8l8tK7Lb9It6u8+oIeNFWhbQw5f
	 sDUf/iQyY6CKhH0YwcFc6dx7lX+fCEPll4rhwmLa0ZPQDGY07l3nKQj9rU897fC0EQqdt
	 DAAxiaTVS14R+cEivTAZPUa01uw3T8cYmf1qojGMVSVybn9bC4CPWgy9vAJbBHoyLw6XH
	 0frjyew49YoP/JeoPDs4TQCJoLKIuXEdOVz0Xx+ZLLU40UomMyiWI3c1H2Vfn2VaJSR8C
	 gYwnC1ODzHEOZVdJyVfswLhnNIq22kA4Hh1RdnGfMfvn4kKDYl3HYFi7AB5I6Zag8zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795492991;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 Received:Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-originating-ip:x-tm-snts-smtp:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-MAIL;
	bh=dEAWrCcLPoqiH1o+NThWPO02RVOnV+Cf+QRng64jUU0=;
	b=HzvkVAvBqGFUYP2yBXClPfP1JbC5xPir5MO8hJFua1udrJSuHIFR8S6f5AY3HA5BJOmT
	 oWfIumWk6rTyeKINolciz5QXoduF0ixzKh4X2b/6QyDhZhVtUYiqjHhJMr0IGecPm11Av
	 Erm4x4ThlcNSJdDUHu9KSbFRexMv9Tk2uC+D7gj5A84Z7N+aLDeCNplkZ9kbAQdfSFHsF
	 6pg0TTLzBshXnul3uVbAFWxzDbQx6Ah13W+cCK6eKA0vrTepV7z0empZiFLqaOdc/aBu+
	 cOBKqE6mDSkyDh256kGiu07xS58y8/EUjwM6z4Sri1m19oWGqOHYZ8cIXIIj+BwDgPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ite.com.tw;
	spf=pass smtp.mailfrom=ite.com.tw;
	dkim=pass header.d=ite.com.tw header.i=@ite.com.tw header.a=rsa-sha256 header.s=dkim header.b=HbaxFBEA;
	arc=none smtp.remote-ip=60.251.196.230
Received: from ironport.ite.com.tw (itemail.ite.com.tw [60.251.196.230])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0488A606A31E;
	Tue, 24 Nov 2026 04:03:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0488A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ite.com.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ite.com.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ite.com.tw header.i=@ite.com.tw header.a=rsa-sha256 header.s=dkim header.b=HbaxFBEA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=ite.com.tw; s=dkim;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dEAWrCcLPoqiH1o+NThWPO02RVOnV+Cf+QRng64jUU0=;
  b=HbaxFBEANVXtFVK/5R+pUSwpN1JUCxpyTpnUzBFCDwLppZqCQwod+Bg7
   i+RMVlfx1kv667648HGnf+LsYIYzTZ3+gS3I4BSIPvAeiBbcBG4PMKsAn
   LyLu8gYpXAK/JYea+ZJTT2RQZ29vdljSaxh29c9m6EwNMvzNaXmugNVGZ
   WvIlRGgXBeRSwntUeeHWPo3VXzPfR2kh4IxGR1bMQAlU9J3Y9wcx1fziT
   tpBlCnEGtsUbs+ABfHT+zdeZ8Lv1QEz0sMmlNCOAknqy5cBHq4icqGLK5
   dZD9Nb/uOAiV8YJQHQoaqEkn/CQVtiYAiz1CXqAIems4f0TKVEJf06bm6
   g==;
X-CSE-ConnectionGUID: nB9btFpES06NvHCzbSAmeQ==
X-CSE-MsgGUID: dPhrvm1CT9Sw0PNH81Hx5Q==
Received: from unknown (HELO mse.ite.com.tw) ([192.168.35.30])
  by ironport.ite.com.tw with ESMTP; 24 Nov 2026 12:03:00 +0800
Received: from tpemail1.internal.ite.com.tw (TPEMAIL1.internal.ite.com.tw [192.168.15.58])
	by mse.ite.com.tw with ESMTP id 6AO42tcK054934;
	Tue, 24 Nov 2026 12:02:55 +0800 (+08)
	(envelope-from Hermes.Wu@ite.com.tw)
Received: from TPEMAIL1.internal.ite.com.tw (192.168.15.58) by
 TPEMAIL1.internal.ite.com.tw (192.168.15.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 24 Nov 2026 12:02:54 +0800
Received: from TPEMAIL1.internal.ite.com.tw ([fe80::63c1:9095:c5a6:3291]) by
 TPEMAIL1.internal.ite.com.tw ([fe80::63c1:9095:c5a6:3291%3]) with mapi id
 15.02.2562.046; Tue, 24 Nov 2026 12:02:54 +0800
From: <Hermes.Wu@ite.com.tw>
To: <Hermes.Wu@ite.com.tw>, <mchehab@kernel.org>, <robh@kernel.org>,
        <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
        <hverkuil+cisco@kernel.org>, <hverkuil@kernel.org>
CC: <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <broonie@kernel.org>,
        <lgirdwood@gmail.com>, <linux-sound@vger.kernel.org>,
        <linux-api@vger.kernel.org>
Subject: RE: [PATCH v2 1/9] media: v4l2-ctrls: add DV RX audio sampling rate
 and present controls
Thread-Topic: [PATCH v2 1/9] media: v4l2-ctrls: add DV RX audio sampling rate
 and present controls
Thread-Index: AQGjzAf29/U6qc1EEeqYH4GUceBqBQIP9cY2t595iuA=
Date: Tue, 24 Nov 2026 04:02:54 +0000
Message-ID: <242d6f760d9d47408285dd8c823582f8@ite.com.tw>
References: <20261124-upstream-it6625-alsa-i2s-v2-0-a154685f6989@ite.com.tw>
 <20261124-upstream-it6625-alsa-i2s-v2-1-a154685f6989@ite.com.tw>
In-Reply-To: <20261124-upstream-it6625-alsa-i2s-v2-1-a154685f6989@ite.com.tw>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tm-snts-smtp: B4F3CEC3C575450E11A7FD2E06239EFCBB8D7A027EDD391DD84FBBE7C38DB2E62002:8
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
X-MAIL:mse.ite.com.tw 6AO42tcK054934

VGhlIFNpZ25lZC1vZmYtYnkgaXMgbWlzc2luZyBmcm9tIHRoaXMgcGF0Y2gsIHNvcnJ5IGFib3V0
IHRoYXQ6DQoNClNpZ25lZC1vZmYtYnk6IEhlcm1lcyBXdSA8SGVybWVzLnd1QGl0ZS5jb20udHc+
DQoNClRoZSBuZXh0IHZlcnNpb24gd2lsbCBjYXJyeSBpdCBpbiB0aGUgcGF0Y2ggaXRzZWxmLg0K
DQpCZXN0IHJlZ2FyZHMsDQpIZXJtZXMNCg==
