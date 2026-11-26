Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=219.87.157.213
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795659413;
	b=WGiaEzv2u21TEBleg37GPsBQ+yRXodN8VDss/t60JPjjo/rXOucHx4WtGgGm9YOSVWfV
	 oMlD8sTMav2HksNyXvVGHrliYboP48OeTm3O7F53MVEl/K2naUntpCDlqBrFpvl4dZUqq
	 7Yzr8kmTZ30tGA9R+Rg9Mi68LY53NSiMHEY9hy/x6JyW/o6TB+6lFMBvlVwSSrU9lh6/+
	 uMNDNE/cd7lbp2Wrl09gSx2xb1TINp6UXTKSVOULSzeB0mm85s2MgkLrsiZacg3SVgzRK
	 yKOrlKEeas0LfX2wxGO3WiMkwxGbMHsABqTLe5RVt6nDNdCIPjDMk8aHr18hC3EWmvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795659413;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 Received:Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-originating-ip:x-tm-snts-smtp:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-MAIL;
	bh=9WHVu77k7FNQ11FtWv1h08ZNc7vcSlPMs7UA0+dd7Qg=;
	b=m3juamdnAfAwJRZin84QIU8UEynmG7eyxC9YTg6nOQoBzDgzcVuy61ZYi+AQa6fuIAvZ
	 yIR7SJ/N+kFXOhux7oy2EK2nsGskLCvrUvl0oO3AWPA8jQ7m/hAkrMELINyk4bqjkvta+
	 qUEuUzEL5g8kv37U/C6YGVpO2X4mJKWKLymNmLuc4KB+q1ney5scU6omIjE9nBolJkf56
	 qHXKo/hHSEj91ZAKEdNqg7PIxUnTDK8iFbxgdeHTLBGZmFP/VgQoXlwlPZaZXvPjJD77f
	 heGoDWZ1mOQ5dqu+USZbOOuBgUTWNwuJRxS/aY5MPZ0lYNZw4hyxC5JgtAsmDN27hRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ite.com.tw;
	spf=pass smtp.mailfrom=ite.com.tw;
	dkim=pass header.d=ite.com.tw header.i=@ite.com.tw header.a=rsa-sha256 header.s=dkim header.b=VN77K7DG;
	arc=none smtp.remote-ip=219.87.157.213
Received: from ironport.ite.com.tw (unknown [219.87.157.213])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCDD606A321;
	Thu, 26 Nov 2026 02:16:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DBCDD606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ite.com.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ite.com.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ite.com.tw header.i=@ite.com.tw header.a=rsa-sha256 header.s=dkim header.b=VN77K7DG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=ite.com.tw; s=dkim;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9WHVu77k7FNQ11FtWv1h08ZNc7vcSlPMs7UA0+dd7Qg=;
  b=VN77K7DGcafQTfJ/q3aLqCxnmQGx7GYZyi5x68aGawHVLj6OrFCIMo0N
   Vjw0ZrD4rsi4izuT9PAQuoVUvCqaaLvxvA/5udVK0sWXIlagzd8r9GmgZ
   1MgooGr+BPAwo3IYSNrgjpBg6RBPGi0GPZg8ka2qqfeXN75SlutsiL+21
   MGGWG34P1KxKiiTEKJyJhQ9Uf2nsd58jbIqwz6rZxLs6fDqoIO3Pr21Q6
   c2OR3jVX+EYY1E6UgBJedso9AlA4/2hhxGqQP2N7d2fv+eXEj+wG4MhzG
   bIc+yYVuhGj+1STgjxtC9uP6NPtFpaGRQ8T22Kt7lCbdHle4xgENTDqhv
   Q==;
X-CSE-ConnectionGUID: 3rXS2iKbQ/q+tqTfv4+UVg==
X-CSE-MsgGUID: XZcbSRNZSvGcf3GHv5iMSw==
Received: from unknown (HELO mse.ite.com.tw) ([192.168.35.30])
  by ironport.ite.com.tw with ESMTP; 26 Nov 2026 10:16:44 +0800
Received: from tpemail1.internal.ite.com.tw (TPEMAIL1.internal.ite.com.tw [192.168.15.58])
	by mse.ite.com.tw with ESMTP id 6AQ2Gd8I099846;
	Thu, 26 Nov 2026 10:16:39 +0800 (+08)
	(envelope-from Hermes.Wu@ite.com.tw)
Received: from TPEMAIL1.internal.ite.com.tw (192.168.15.58) by
 TPEMAIL1.internal.ite.com.tw (192.168.15.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 26 Nov 2026 10:16:39 +0800
Received: from TPEMAIL1.internal.ite.com.tw ([fe80::63c1:9095:c5a6:3291]) by
 TPEMAIL1.internal.ite.com.tw ([fe80::63c1:9095:c5a6:3291%3]) with mapi id
 15.02.2562.046; Thu, 26 Nov 2026 10:16:39 +0800
From: <Hermes.Wu@ite.com.tw>
To: <hverkuil+cisco@kernel.org>, <mchehab@kernel.org>, <robh@kernel.org>,
        <krzk+dt@kernel.org>, <conor+dt@kernel.org>, <hverkuil@kernel.org>
CC: <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <broonie@kernel.org>,
        <lgirdwood@gmail.com>, <linux-sound@vger.kernel.org>,
        <linux-api@vger.kernel.org>
Subject: RE: [PATCH v2 9/9] media: uapi: it6625: remove the driver-specific
 audio controls
Thread-Topic: [PATCH v2 9/9] media: uapi: it6625: remove the driver-specific
 audio controls
Thread-Index: AQHdfNqV9/U6qc1EEeqYH4GUceBqBbc/nnXA
Date: Thu, 26 Nov 2026 02:16:39 +0000
Message-ID: <bda1d2cb8f9b40c9a9b2fe8bcc803382@ite.com.tw>
References: <20261124-upstream-it6625-alsa-i2s-v2-0-a154685f6989@ite.com.tw>
 <20261124-upstream-it6625-alsa-i2s-v2-9-a154685f6989@ite.com.tw>
 <c356089d-775d-4998-813f-644b15eddfc3@kernel.org>
In-Reply-To: <c356089d-775d-4998-813f-644b15eddfc3@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tm-snts-smtp: FE9D0D804F3E459055980357402D1545374A544AB0C7B9B092762B1DAF07EF882002:8
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
X-MAIL:mse.ite.com.tw 6AQ2Gd8I099846

SGkgSGFucywNCg0KT24gMjUvMTEvMjAyNiAxMzo0MywgSGFucyBWZXJrdWlsIHdyb3RlOg0KPj4g
VjRMMl9DSURfSVQ2NjI1X0FVRElPX1NBTVBMSU5HX1JBVEUgYW5kIFY0TDJfQ0lEX0lUNjYyNV9B
VURJT19QUkVTRU5UDQo+PiBoYXZlIGJlZW4gcmVwbGFjZWQgYnkgdGhlIHN0YW5kYXJkIFY0TDJf
Q0lEX0RWX1JYX0FVRElPX1NBTVBMSU5HX1JBVEUNCj4+IGFuZCBWNEwyX0NJRF9EVl9SWF9BVURJ
T19QUkVTRU5UIGNvbnRyb2xzLCBhbmQgdGhlIGRyaXZlciBubyBsb25nZXIgdXNlcw0KPj4gdGhl
bS4gVGhleSB3ZXJlIGFkZGVkIHRvZ2V0aGVyIHdpdGggdGhlIGRyaXZlciBhbmQgYXJlIG5vdCBw
YXJ0IG9mIGFueQ0KPj4gcmVsZWFzZWQga2VybmVsIHlldC4NCj4NCj4gV2VsbCwgdGhhdCdzIG5v
dCByZWFsbHkgdHJ1ZS4gQnkgdGhlIHRpbWUgdGhpcyBwYXRjaCB3b3VsZCBnbyBpbiwgdGhlIGRy
aXZlcg0KPiB3aWxsIGJlIHBhcnQgb2YgYSByZWxlYXNlZCBrZXJuZWwuDQoNCllvdSdyZSByaWdo
dCwgdGhlIGRyaXZlciBhbmQgaXRzIHByaXZhdGUgY29udHJvbHMgYXJlIGFscmVhZHkgaW4NCnY3
LjQtcmMxLiBJJ2xsIGNvcnJlY3QgdGhlIGNvbW1pdCBtZXNzYWdlIGluIHYzOiBpdCB3aWxsIHNh
eSB0aGF0DQpyZW1vdmluZyB0aGUgY29udHJvbHMgYnJlYWtzIHRoZSB1QVBJLCB0aGF0IHRoZXkg
YXJlIHJlcGxhY2VkIGJ5IHRoZQ0Kc3RhbmRhcmQgY29udHJvbHMsIGFuZCB0aGF0IHRoZSBpbXBh
Y3QgaXMgZXhwZWN0ZWQgdG8gYmUgdmVyeSBzbWFsbC4NCg0KPiBUaGF0IHNhaWQsIHRoaXMgaXMg
b25lIGNhc2Ugd2hlcmUgSSBhbSBpbiBmYXZvciBvZiBkcm9wcGluZyB0aGUgb2xkIGNvbnRyb2xz
DQo+IGV2ZW4gdGhvdWdoIGl0IHN0cmljdGx5IHNwZWFraW5nIGJyZWFrcyB0aGUgdUFQSS4NCj4N
Cj4gSSdtIG5vdCBhd2FyZSBvZiBhbnkgaGFyZHdhcmUgYm9hcmRzIHRoYXQgdXNlIHRoaXMgY2hp
cCwgc28gdGhlIGltcGFjdCBpcyB2ZXJ5DQo+IHNtYWxsIGlmIG5vdCB6ZXJvLg0KDQpUaGFuayB5
b3UsIEknbGwga2VlcCB0aGUgcGF0Y2guDQoNCj4gSXQncyBhY3R1YWxseSBhbiBpbnRlcmVzdGlu
ZyBxdWVzdGlvbjogYXJlIHRoZXJlIGJvYXJkcy9TQkNzIGNvbW1lcmNpYWxseSBhdmFpbGFibGUN
Cj4gdGhhdCB1c2UgdGhpcyBjaGlwPyBJdCdzIGFuIGludGVyZXN0aW5nIG9uZSwgaXQgbWlnaHQg
YmUgbmljZSBpZiB0aGVyZSB3b3VsZCBiZQ0KPiBhIGJvYXJkIGZvciBlLmcuIHRoZSBSYXNwYmVy
cnkgUGkuDQoNCldlIGRldmVsb3AgYW5kIHRlc3QgdGhlIGRyaXZlciBvbiBhIFJhc3BiZXJyeSBQ
aSA1LCB3aXRoIHRoZSBJVDY2MjUNCmNvbm5lY3RlZCB0byBpdHMgQ1NJLTIgY2FtZXJhIGNvbm5l
Y3RvciBhbmQgdGhlIGF1ZGlvIG92ZXIgSTJTLg0KDQpCZXN0IHJlZ2FyZHMsDQpIZXJtZXMNCg==
