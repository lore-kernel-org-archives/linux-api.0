Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.202.87.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795659373;
	b=Rxd6JHmYdLhb2b+XDw7VXs6FFRGNm6KeP008s/U+wa9o2fc58vC39AM74LswSfZJ03Ps
	 ZahaI0Iy2+FqXhcXvS9KOxLgjew2kAMdscofBcbpJlI327paIGmAFyKwm6gk5Daak0qcE
	 ZE9iFJakB4xtgHXQKEpYUwjCT/6ic2pv/HeQ1Pte5MFoxbqlybwE4S/L6d18v5oZk9r08
	 wRX+rwUIVbzYbeDfQ6LvA7AA9IFvPng6dlfeaBGwzBdrPEvWyDii7gLD9yK/xoMELpeUh
	 W0WGoGYDUT6UXwfMqUv0aqWKD0CV7OhD9pqGU+szs0IeEfCD9l+KS4yR9kPOUFSye5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795659373;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 Received:Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-originating-ip:x-tm-snts-smtp:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-MAIL;
	bh=FBGOdv8sbSGqy+s2KiFSS234niBKjQ6B3apGvG33pGY=;
	b=TOMOoR87ZQPTlrUuqO4yoHGRhU4G3WsZFuo/XxI3BpH5zm+vdyMH71dcwnUpfey8nkOq
	 R/m4NzIH6qcSIvyYwRkWuWD1rnIyR3uY/xm/Vl9t9gOTnpcNFkj5DSMqwOXmpaCszI8Mx
	 yQh0pBnHyXkVsqlVLuRrforNwa0UoQiNypQ2mWR/Y31WEkdPlIGThyrq21gcqVVXoVHXB
	 ejmwqznwa/tYo9Now/yor5/60iUiZDzKuMToqPy4/bXG6vxuHGjE22/cAE+dhoJh/N1wW
	 O4Q5Mh8oxl/L+EtW9Z1GRuUmCPziQJb4QKaoah0f0roDlfT6Vm8UOPaLYQjUDnbWXXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ite.com.tw;
	spf=pass smtp.mailfrom=ite.com.tw;
	dkim=pass header.d=ite.com.tw header.i=@ite.com.tw header.a=rsa-sha256 header.s=dkim header.b=Nrv+x5z9;
	arc=none smtp.remote-ip=210.202.87.179
Received: from ironport.ite.com.tw (unknown [210.202.87.179])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6AC606A321;
	Thu, 26 Nov 2026 02:16:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A6AC606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ite.com.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ite.com.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ite.com.tw header.i=@ite.com.tw header.a=rsa-sha256 header.s=dkim header.b=Nrv+x5z9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=ite.com.tw; s=dkim;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FBGOdv8sbSGqy+s2KiFSS234niBKjQ6B3apGvG33pGY=;
  b=Nrv+x5z90ZA5ONj8lx/bfr9C5ZwWR9JjWf0urio756W2oG6Y7bmHvxN2
   UYAFOoQ6+bPa4zscTHvxfqCQ4KkAX/h6SiLYZRc8dJ+nXtqfWbxBt1GkO
   m8xfx6FBayvfSdyzFYjIdMsuAG8de5E8jCYY+3dFSL3L83dj6a2dJAlmb
   PZG4pvCZ2ZERtxesfsa0RtrmQ7AEF7vCw22cgfQEwhp3e5EnSzvP2TNtF
   VLpQH1zOQia6TKMD//M9udsNwJJvVHdeth2Iqf/Ks6HKcL7SUQt21fsMN
   xQ0qzaMKHQe7gvtQP1ULVzzhqfEkoyp3+9UMqMHQQC9tl4VqViIpsgk+6
   w==;
X-CSE-ConnectionGUID: zjAILwc2QkKFGynlc3UlSg==
X-CSE-MsgGUID: 57j3kFIKRuGKBL+ZgtO/3g==
Received: from unknown (HELO mse.ite.com.tw) ([192.168.35.30])
  by ironport.ite.com.tw with ESMTP; 26 Nov 2026 10:16:03 +0800
Received: from tpemail1.internal.ite.com.tw (TPEMAIL1.internal.ite.com.tw [192.168.15.58])
	by mse.ite.com.tw with ESMTP id 6AQ2G1qE099082;
	Thu, 26 Nov 2026 10:16:01 +0800 (+08)
	(envelope-from Hermes.Wu@ite.com.tw)
Received: from TPEMAIL1.internal.ite.com.tw (192.168.15.58) by
 TPEMAIL1.internal.ite.com.tw (192.168.15.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 26 Nov 2026 10:16:00 +0800
Received: from TPEMAIL1.internal.ite.com.tw ([fe80::63c1:9095:c5a6:3291]) by
 TPEMAIL1.internal.ite.com.tw ([fe80::63c1:9095:c5a6:3291%3]) with mapi id
 15.02.2562.046; Thu, 26 Nov 2026 10:16:00 +0800
From: <Hermes.Wu@ite.com.tw>
To: <hverkuil+cisco@kernel.org>, <mchehab@kernel.org>, <robh@kernel.org>,
        <krzk+dt@kernel.org>, <conor+dt@kernel.org>, <hverkuil@kernel.org>
CC: <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <broonie@kernel.org>,
        <lgirdwood@gmail.com>, <linux-sound@vger.kernel.org>,
        <linux-api@vger.kernel.org>
Subject: RE: [PATCH v2 1/9] media: v4l2-ctrls: add DV RX audio sampling rate
 and present controls
Thread-Topic: [PATCH v2 1/9] media: v4l2-ctrls: add DV RX audio sampling rate
 and present controls
Thread-Index: AQHdfNng9/U6qc1EEeqYH4GUceBqBbc/njcA
Date: Thu, 26 Nov 2026 02:16:00 +0000
Message-ID: <aacbf13f25774be5bf599661202360e2@ite.com.tw>
References: <20261124-upstream-it6625-alsa-i2s-v2-0-a154685f6989@ite.com.tw>
 <20261124-upstream-it6625-alsa-i2s-v2-1-a154685f6989@ite.com.tw>
 <6dba4041-fd5c-448d-9f9d-e3c1dcff8185@kernel.org>
In-Reply-To: <6dba4041-fd5c-448d-9f9d-e3c1dcff8185@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tm-snts-smtp: E25FC086321F315CA2AA2582423C583D50719BB9EBB7574CE2488192CC74B8E92002:8
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
X-MAIL:mse.ite.com.tw 6AQ2G1qE099082

SGkgSGFucywNCg0KT24gMjUvMTEvMjAyNiAxMzozOCwgSGFucyBWZXJrdWlsIHdyb3RlOg0KPj4g
K2BgVjRMMl9DSURfRFZfUlhfQVVESU9fU0FNUExJTkdfUkFURSAoaW50ZWdlcilgYA0KPj4gKyAg
ICBSZWFkcyB0aGUgc2FtcGxpbmcgcmF0ZSwgaW4gSHosIG9mIHRoZSBhdWRpbyB0aGF0IHRoZSBy
ZWNlaXZlcg0KPj4gKyAgICByZWNlaXZlcyBmcm9tIHRoZSBzb3VyY2UuIEl0IGlzIDAgaWYgbm8g
YXVkaW8gaXMgcmVjZWl2ZWQsIG9yIGlmIHRoZQ0KPg0KPiByZWNlaXZlZCAtPiBwcmVzZW50DQo+
DQo+IElzIHRoaXMgaW5kZWVkIHRoZSBjYXNlLCB0aGF0IGl0IGlzIDAgaWYgVjRMMl9DSURfRFZf
UlhfQVVESU9fUFJFU0VOVCBpcw0KPiBmYWxzZT8gSSB0aGluayBib3RoIHRoZSB0YzM1ODc0MyBh
bmQgdGhpcyBkcml2ZXIgYWN0dWFsbHkgZG8gbm90IHNldCB0aGUNCj4gc2FtcGxpbmcgcmF0ZSB0
byAwIGlmIGF1ZGlvIGRpc2FwcGVhcnMuIChNaWdodCBiZSB3cm9uZywgSSBkaWRuJ3QgZGlnIGRl
ZXBseQ0KPiBpbnRvIHRoaXMpDQoNCllvdSdyZSByaWdodCBhYm91dCB0YzM1ODc0MzogaXRzIHJh
dGUgY29udHJvbCBjYW4ga2VlcCB0aGUgcHJldmlvdXMgdmFsdWUNCmFmdGVyIHRoZSBhdWRpbyBk
aXNhcHBlYXJzLiBJVDY2MjUgZG9lcyBzZXQgaXQgdG8gMCwgYnV0IHRoZSBkb2N1bWVudGF0aW9u
DQpzaG91bGRuJ3QgcmVxdWlyZSB0aGF0Lg0KDQo+IEknbSBpbmNsaW5lZCB0byBkcm9wIHRoYXQg
cmVxdWlyZW1lbnQsIGFuZCBpbnN0ZWFkLi4uDQo+DQo+PiArICAgIHJlY2VpdmVyIGNhbm5vdCBk
ZXRlcm1pbmUgdGhlIHNhbXBsaW5nIHJhdGUuIFRoaXMgcmVhZC1vbmx5IGNvbnRyb2wNCj4+ICsg
ICAgaXMgYXBwbGljYWJsZSB0byBIRE1JIGFuZCBEaXNwbGF5UG9ydCBjb25uZWN0b3JzLg0KPg0K
PiAuLi5hZGQgJ1RoZSB2YWx1ZSBpcyBvbmx5IG1lYW5pbmdmdWwgd2hpbGUgYGBWNEwyX0NJRF9E
Vl9SWF9BVURJT19QUkVTRU5UYGAgaXMgc2V0LicNCj4gdG8gdGhlIGRlc2NyaXB0aW9uLg0KPg0K
PiBTbyAnMCcgaXMgc3BlY2lmaWMgdG8gdGhlIGNhc2UgdGhhdCB0aGVyZSBpcyBhdWRpbyBwcmVz
ZW50LCBidXQgdGhlIHNhbXBsaW5nIHJhdGUNCj4gY2Fubm90IGJlIGRldGVybWluZWQuIElmIHRo
ZXJlIGlzIG5vIGF1ZGlvIHByZXNlbnQsIHRoZW4sIGp1c3QgbGlrZSBBVURJT19UWVBFLCB0aGUN
Cj4gdmFsdWUgaXMgbm90IG1lYW5pbmdmdWwuIEkuZS4sIGl0IHNob3VsZCBiZSBpZ25vcmVkLg0K
DQpBZ3JlZWQuIEluIHYzIHRoZSBkZXNjcmlwdGlvbiB3aWxsIHJlYWQ6DQoNCiAgUmVhZHMgdGhl
IHNhbXBsaW5nIHJhdGUsIGluIEh6LCBvZiB0aGUgYXVkaW8gdGhhdCBpcyBwcmVzZW50IG9uIHRo
ZQ0KICByZWNlaXZlcidzIGlucHV0LiBJdCBpcyAwIGlmIGF1ZGlvIGlzIHByZXNlbnQgYnV0IHRo
ZSByZWNlaXZlciBjYW5ub3QNCiAgZGV0ZXJtaW5lIHRoZSBzYW1wbGluZyByYXRlLiBUaGUgdmFs
dWUgaXMgb25seSBtZWFuaW5nZnVsIHdoaWxlDQogIGBgVjRMMl9DSURfRFZfUlhfQVVESU9fUFJF
U0VOVGBgIGlzIHNldC4gVGhpcyByZWFkLW9ubHkgY29udHJvbCBpcw0KICBhcHBsaWNhYmxlIHRv
IEhETUkgYW5kIERpc3BsYXlQb3J0IGNvbm5lY3RvcnMuDQoNCmFuZCBJJ2xsIHVwZGF0ZSB0aGUg
Y29tbWl0IG1lc3NhZ2UgdG8gbWF0Y2guDQoNCkJlc3QgcmVnYXJkcywNCkhlcm1lcw0K
