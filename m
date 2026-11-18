Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=219.87.157.213
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794978343;
	b=WAxItr0nnwEqjZ+iZaxNmbucliP9GhTz+di4XuPVD/3oi4THUx02e8c0Qv1PSZ5Vrn3W
	 RUI43KNNiQF5cyCTZqw1CloMih7Bc1O1UtE5ouyxv7zFSpqdnEF8qiaC+7B74S3VUlLuJ
	 1GNGiecCXgPOWDnqWGXPrceRbGm6cRHBw6c5YYVKUZOVeMmwBcuQe/6NutsZ9DlIjf0Ue
	 /PhmEAX2yqTgUzDmQUrbwTsyKStu1e7ZsYVJtx/hwg1IUPoMiOY9vLSnsuRV63dF7lNVy
	 u1EAROitADOoH0ZG+tSy5ahv8uKerjmFaMPSgIqrrSuTaymawGE7LrCfcKEDW/BqGHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794978343;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 Received:Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-originating-ip:x-tm-snts-smtp:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-MAIL;
	bh=niL/66HcQYfGiv+TPYu+CovP2Oq0rJ3Fl4O5tMwyo68=;
	b=qzMo/sEI+vjWewoIPuSV3Z1yKwRsgGxTbkx7lTrwtLQbO+XCv/jsObLETYR/gKvcybpE
	 XUafoPP1D7q1VVfk9/VpE00SHGvsKPlkAzr9IiuyzOHayiCKrM+HgVz+wjum6d+80w560
	 i84ycNzVSv4+bi7lWSdAaYCYSUdhEuqJAyXWRmHJAzv7dXpQqXagedONWTt+4Q6IGXvxF
	 aqibDhOWT/KgpIqZf0a4vJ1iFp4L72cIOEKnQY4EZ6C7MelVB1psnpWP1Ai/c3oFZ+CDH
	 vDCm3Zzwz03mv+HcEuoGAHTWnCw/+MY61dyxnb7CNwYuevFnbUrUPg+1vPHuEUOBZfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ite.com.tw;
	spf=pass smtp.mailfrom=ite.com.tw;
	dkim=pass header.d=ite.com.tw header.i=@ite.com.tw header.a=rsa-sha256 header.s=dkim header.b=FsGb51LQ;
	arc=none smtp.remote-ip=219.87.157.213
Received: from ironport.ite.com.tw (unknown [219.87.157.213])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B09606A31C;
	Wed, 18 Nov 2026 05:05:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43B09606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ite.com.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ite.com.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ite.com.tw header.i=@ite.com.tw header.a=rsa-sha256 header.s=dkim header.b=FsGb51LQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=ite.com.tw; s=dkim;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=niL/66HcQYfGiv+TPYu+CovP2Oq0rJ3Fl4O5tMwyo68=;
  b=FsGb51LQ/RKVjK/nuNsStcVypaHOTe6x0fHEXJI2NlHkAQxO/6mESi8t
   JhybBRNwKbyEiLFxxNtMRi6rCnwJM9FIfW/HgAgFnTr+y0vwTRGW19KA9
   fhPaLEYDBwgR8YfmvLfOdU+ctG0RWVxpnDne/iLBOJJrItc9i83vEie8m
   Ymi9ZHlZH54OdhC6ZSsP2Fm+lLnRjoVqVyKV0iPw0uRrokJypKMCkLwQw
   von89QR2Dt7zXXQbpwI6h1xknb0iJvcASEmnHioKtGpRaynwdkWar0Hox
   zfBjm7qaydvsh5DISa6q+ZM7QsYKA1B2gDK4irQQ5SNlmd+Lw7uDl0zQX
   Q==;
X-CSE-ConnectionGUID: 3NBhzDxdTXu0g35DtVtuBA==
X-CSE-MsgGUID: cAQN69FkRqSfn9+S4FIXww==
Received: from unknown (HELO mse.ite.com.tw) ([192.168.35.30])
  by ironport.ite.com.tw with ESMTP; 18 Nov 2026 13:05:39 +0800
Received: from tpemail1.internal.ite.com.tw (TPEMAIL1.internal.ite.com.tw [192.168.15.58])
	by mse.ite.com.tw with ESMTP id 6AI55XPM009808;
	Wed, 18 Nov 2026 13:05:33 +0800 (+08)
	(envelope-from Hermes.Wu@ite.com.tw)
Received: from TPEMAIL1.internal.ite.com.tw (192.168.15.58) by
 TPEMAIL1.internal.ite.com.tw (192.168.15.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 18 Nov 2026 13:05:32 +0800
Received: from TPEMAIL1.internal.ite.com.tw ([fe80::63c1:9095:c5a6:3291]) by
 TPEMAIL1.internal.ite.com.tw ([fe80::63c1:9095:c5a6:3291%3]) with mapi id
 15.02.2562.046; Wed, 18 Nov 2026 13:05:32 +0800
From: <Hermes.Wu@ite.com.tw>
To: <hverkuil+cisco@kernel.org>, <mchehab@kernel.org>, <robh@kernel.org>,
        <krzk+dt@kernel.org>, <conor+dt@kernel.org>
CC: <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <broonie@kernel.org>,
        <lgirdwood@gmail.com>, <linux-sound@vger.kernel.org>,
        <linux-api@vger.kernel.org>
Subject: RE: [PATCH 2/5] media: Documentation: it6625: document the audio
 controls
Thread-Topic: [PATCH 2/5] media: Documentation: it6625: document the audio
 controls
Thread-Index: AQHdcdX93RoL2u2CFUyeme408I10pbczUFWA
Date: Wed, 18 Nov 2026 05:05:32 +0000
Message-ID: <4b85b91fba654ab18c2d5afd1820e473@ite.com.tw>
References: <20261103-upstream-it6625-alsa-i2s-v1-0-bb91e2879b01@ite.com.tw>
 <20261103-upstream-it6625-alsa-i2s-v1-2-bb91e2879b01@ite.com.tw>
 <a554e557-3d10-465e-ad3b-90d8357b60f2@kernel.org>
In-Reply-To: <a554e557-3d10-465e-ad3b-90d8357b60f2@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tm-snts-smtp: F9F7769ED813F902E0C8B49A24F5A47D5679E3D240F4F49702DF0BCE5CEBA6692002:8
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
X-MAIL:mse.ite.com.tw 6AI55XPM009808

SGkgSGFucywNCg0KT24gMTEvMTEvMjAyNiAxMzoxMiwgSGFucyBWZXJrdWlsIHdyb3RlOg0KPiBX
ZSBuZWVkIHRvIG1ha2Ugc3RhbmRhcmQgY29udHJvbHMgZm9yIHRoZSBhdWRpbyBzYW1wbGluZyBy
YXRlIGFuZCBwcmVzZW5jZS4NCj4gVGhleSBhcmUgYWxzbyB1c2VkIGJ5IHRoZSB0YzM1ODc0MyBk
cml2ZXIsIGFuZCBhcmUgaW4gZmFjdCBjb21tb24gZm9yIGFsbA0KPiBIRE1JIHJlY2VpdmVyIGRy
aXZlcnMgKEkga25vdyBvZiBhIGJ1bmNoIG9mIG91dC1vZi10cmVlIGRyaXZlcnMgdGhhdCB1c2Ug
dGhlDQo+IHNhbWUgY29udHJvbHMpLg0KPg0KPiBTbyByYXRoZXIgdGhhbiBjcmVhdGluZyBkcml2
ZXItc3BlY2lmaWMgY29udHJvbHMsIGNhbiB5b3UgYWRkIHN0YW5kYXJkDQo+IGNvbnRyb2xzIGZv
ciB0aGlzPyBUaGV5IGJlbG9uZyB0byB0aGUgVjRMMl9DSURfRFZfQ0xBU1MgY29udHJvbCBjbGFz
cy4NCj4NCj4gU28gdGhlIGRlZmluZXMgYmVjb21lOg0KPg0KPiBWNEwyX0NJRF9EVl9SWF9BVURJ
T19TQU1QTElOR19SQVRFIGFuZCBWNEwyX0NJRF9EVl9SWF9BVURJT19QUkVTRU5ULg0KDQpUaGFu
a3MgZm9yIHRoZSByZXZpZXcuIEkgd2lsbCBhZGQgdGhlIHR3byBzdGFuZGFyZCBjb250cm9scyBh
bmQgc2VuZA0KdjIgaW4gdGhpcyBvcmRlcjoNCg0KICAxLiB2NGwyLWN0cmxzOiBhZGQgVjRMMl9D
SURfRFZfUlhfQVVESU9fU0FNUExJTkdfUkFURSBhbmQNCiAgICAgVjRMMl9DSURfRFZfUlhfQVVE
SU9fUFJFU0VOVCAocmVhZC1vbmx5OyB0aGUgcmF0ZSBhcyBhbiBpbnRlZ2VyIGluDQogICAgIEh6
LCAwIHdoZW4gdGhlcmUgaXMgbm8gYXVkaW8gb3IgdGhlIHJhdGUgaXMgdW5rbm93bjsgcHJlc2Vu
dCBhcyBhDQogICAgIGJvb2xlYW4pLCB3aXRoIHRoZWlyIGRvY3VtZW50YXRpb24gaW4gZXh0LWN0
cmxzLWR2LnJzdC4NCiAgMi4gdGMzNTg3NDM6IHNldCB0aGUgc3RhbmRhcmQgY29udHJvbHMgaW4g
YWRkaXRpb24gdG8gaXRzIGN1c3RvbSBvbmVzLg0KICAzLiBUaGUgSVQ2NjI1IHBhdGNoZXMsIHVz
aW5nIHRoZSBzdGFuZGFyZCBjb250cm9scy4gVGhlIGl0NjYyNS5yc3QNCiAgICAgcGF0Y2ggaXMg
ZHJvcHBlZC4NCg0KU2hvdWxkIHRoZSB0YzM1ODc0MyBjaGFuZ2UgZ28gaW4gdGhlIHNhbWUgc2Vy
aWVzLCBvciB3b3VsZCB5b3UgcHJlZmVyDQppdCBzZW50IHNlcGFyYXRlbHk/DQoNCk9uZSBxdWVz
dGlvbiBhYm91dCBJVDY2MjUgaXRzZWxmLiBJdHMgdHdvIGRyaXZlci1zcGVjaWZpYyBjb250cm9s
cywNClY0TDJfQ0lEX0lUNjYyNV9BVURJT19TQU1QTElOR19SQVRFIGFuZCBWNEwyX0NJRF9JVDY2
MjVfQVVESU9fUFJFU0VOVCwNCmFyZSBub3QgbmV3IGluIHRoaXMgc2VyaWVzLiBUaGV5IGNhbWUg
d2l0aCB0aGUgZHJpdmVyIGl0c2VsZiwgY29tbWl0DQoxNDJlNWYwMGJkNTcgKCJtZWRpYTogaTJj
OiBhZGQgZHJpdmVyIGZvciBJVEUgSVQ2NjI1L0lUNjYyNiIpLCB3aGljaCBpcw0KaW4gbWVkaWEg
bmV4dCBhbmQgaW4gdjcuNC1yYzEgYnV0IG5vdCB5ZXQgaW4gYSByZWxlYXNlZCBrZXJuZWwuIFRo
aXMNCmF1ZGlvIHNlcmllcyBvbmx5IGRvY3VtZW50cyB0aGVtLiBXaGljaCBkbyB5b3UgcHJlZmVy
Og0KDQogIGEpIGtlZXAgdGhlbSBhbmQgYWxzbyBzZXQgdGhlIHN0YW5kYXJkIGNvbnRyb2xzLCBh
cyBmb3IgdGMzNTg3NDM7IG9yDQogIGIpIHJlbW92ZSB0aGVtIHdpdGggYSBmaXggZm9yIHY3LjQs
IGJlZm9yZSB0aGV5IGVuZCB1cCBpbiBhIHJlbGVhc2UsDQogICAgIHNvIHRoYXQgSVQ2NjI1IG9u
bHkgaGFzIHRoZSBzdGFuZGFyZCBjb250cm9scz8NCg0KQWJvdXQgeW91ciBjb21tZW50IG9uIHBh
dGNoIDUvNSAodGhlIGF1ZGlvIHR5cGUgY29udHJvbCBhcyBhIHN0YW5kYXJkDQpEViBjb250cm9s
KTogdGhlIHZhbHVlIElUNjYyNSByZXBvcnRzIHRoZXJlIGlzIHRoZSB0eXBlIG9mIHRoZSBIRE1J
DQphdWRpbyBzdHJlYW0gYXMgdGhlIGJyaWRnZSBmaXJtd2FyZSBjbGFzc2lmaWVzIGl0IChMUENN
LCBjb21wcmVzc2VkLA0KSEJSIG9yIG9uZS1iaXQpLCBub3QgdGhlIGNvZGVjLiBJdCBpcyBub3Qg
YWx3YXlzIGV4YWN0OiB0aGUgZmlybXdhcmUNCmFsc28gcmVwb3J0cyBIQlIgZm9yIHNvbWUgY29t
cHJlc3NlZCBzdHJlYW1zIGF0IG9yZGluYXJ5IHJhdGVzLCBzdWNoIGFzDQo0OCBrSHogRFRTLiBJ
IHdvdWxkIHByb3Bvc2UgYSByZWFkLW9ubHkgbWVudSBjb250cm9sOg0KDQogIFY0TDJfQ0lEX0RW
X1JYX0FVRElPX1RZUEUNCiAgICBWNEwyX0RWX1JYX0FVRElPX1RZUEVfTFBDTSAgICAgIGxpbmVh
ciBQQ00gKGF1ZGlvIHNhbXBsZSBwYWNrZXRzKQ0KICAgIFY0TDJfRFZfUlhfQVVESU9fVFlQRV9J
RUM2MTkzNyAgY29tcHJlc3NlZCBhdWRpbywgSUVDIDYxOTM3DQogICAgVjRMMl9EVl9SWF9BVURJ
T19UWVBFX0hCUiAgICAgICBoaWdoIGJpdCByYXRlIGF1ZGlvIHBhY2tldHMNCiAgICBWNEwyX0RW
X1JYX0FVRElPX1RZUEVfT05FX0JJVCAgIG9uZS1iaXQgKERTRCkgYXVkaW8gcGFja2V0cw0KDQpU
aGUgY29kZWMgb2YgYSBjb21wcmVzc2VkIHN0cmVhbSAoQUMtMywgRFRTLCAuLi4pIGlzIG5vdCBy
ZXBvcnRlZCBieQ0KdGhlIGJyaWRnZTsgdXNlcnNwYWNlIGZpbmRzIGl0IGluIHRoZSBJRUMgNjE5
MzcgZGF0YS4gRG9lcyB0aGF0IGZpdA0Kd2hhdCB5b3UgaGFkIGluIG1pbmQsIG9yIHNob3VsZCB0
aGUgY29udHJvbCBkZXNjcmliZSBzb21ldGhpbmcgZWxzZT8NCg0KQmVzdCByZWdhcmRzLA0KSGVy
bWVzDQo=
