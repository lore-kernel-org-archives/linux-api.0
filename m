Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=219.87.157.213
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793843476;
	b=wC0ug/6kQNt3hq3SwHpHTIHAsm+bUfCKxxXZ5HIv8ED7P6Y0tUOhw2I5TX8lNseAApkC
	 cYVkIIC/cynNithgidIUlxxNKibb2M+TX3zQPltBxyNwF5v0wWwm8wKFI5pvQpqYsvOX8
	 Y1cYM7iYTYjttrdkVN74WpkS7xjTKgxuZ1uuFGu3BPMHp2Dr8M5+RjW4ob+GHpSpYN13N
	 rHBziW8jsyEgGNQynOPGAgaw8fyB0bS/T3F9sGDNi0beliubORmSqY6m6rrzaRidqQcKL
	 tC50ag3/+lDcpTtBjLIAhNMPceTj8euYC5XDNL1ZbbbfEULPjnVFAALQT41w/VTUG2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793843476;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 Received:Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-originating-ip:x-tm-snts-smtp:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-MAIL;
	bh=LbT+cDt3x5H3RSlP6PJ6sjoErQEa3773tcGsgbYPWQg=;
	b=JnGWYFuU2UJUyB7F9/r6UZFX7dmP/d1c+ly0uAOJPRA0z3aamrijRM+GGKjm9VT2wFXX
	 vL2pR4MBUeQqnQxNByYLEIsYcz1H0Zr9zTl2m532wtEnF0zk5b97DJZAIy6i7LlDl3vfR
	 N3AnLrddVVhDNJ/7LhgzDtDXvWiVGq+vCWDA5Xwdd2GqDuRlQfNgUNwX7IT8MHnz/0TIR
	 utaTf7260EbV41BLn8aX1RGPkNeh40Je57QZMKBc6k1eOZbisV75yBskDY3eFqlaksdCt
	 uGjs6m/vBICz7NjxIaIYcIsCyrBQ7mrsjANg0WWpLWCgGNqT6fPp25qfunrkFnWhBIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ite.com.tw;
	spf=pass smtp.mailfrom=ite.com.tw;
	dkim=pass header.d=ite.com.tw header.i=@ite.com.tw header.a=rsa-sha256 header.s=dkim header.b=GSTl0NbS;
	arc=none smtp.remote-ip=219.87.157.213
Received: from ironport.ite.com.tw (unknown [219.87.157.213])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B542606A31B;
	Thu,  5 Nov 2026 01:51:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B542606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ite.com.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ite.com.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ite.com.tw header.i=@ite.com.tw header.a=rsa-sha256 header.s=dkim header.b=GSTl0NbS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=ite.com.tw; s=dkim;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LbT+cDt3x5H3RSlP6PJ6sjoErQEa3773tcGsgbYPWQg=;
  b=GSTl0NbSoL/bHoZShCiPCDOG4zpZkxuRpvMHuPrnq3vYGbDmrRHWjqKq
   eafc1tcP4CaV4ozd+rkW6ADyXAwYksMlN87/bKH65qbI5g8vGbpTfj6Yq
   CxIa8UrxdVGWiJnsKyrnxR+hMxl3I3/YQmkT8A7Obt2T99RzoJnQdQfH6
   MVzNTTxfuZ6ZTYQsqURR55dFI7yLiHkqnfo/oO8XMqykRhn2cTa9PCDVt
   mc8540/jQb4136i20P2YT01bdcZrEXQfhXSfyQ85xF5VYoSZZZvJHZot0
   Rx09yeqSfqN5O8wrdq2dVTJ7wO/1C0FcukJxV9rvaYCybfS2+Gt+VeMQA
   w==;
X-CSE-ConnectionGUID: Ho0X/4iXTfe1+B0p127BJw==
X-CSE-MsgGUID: bvNrJYKpQJudTrTDXMPhAQ==
Received: from unknown (HELO mse.ite.com.tw) ([192.168.35.30])
  by ironport.ite.com.tw with ESMTP; 05 Nov 2026 09:51:04 +0800
Received: from tpemail1.internal.ite.com.tw (TPEMAIL1.internal.ite.com.tw [192.168.15.58])
	by mse.ite.com.tw with ESMTP id 6A51owQl083341;
	Thu, 5 Nov 2026 09:50:58 +0800 (+08)
	(envelope-from Hermes.Wu@ite.com.tw)
Received: from TPEMAIL1.internal.ite.com.tw (192.168.15.58) by
 TPEMAIL1.internal.ite.com.tw (192.168.15.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 5 Nov 2026 09:50:57 +0800
Received: from TPEMAIL1.internal.ite.com.tw ([fe80::63c1:9095:c5a6:3291]) by
 TPEMAIL1.internal.ite.com.tw ([fe80::63c1:9095:c5a6:3291%3]) with mapi id
 15.02.2562.046; Thu, 5 Nov 2026 09:50:57 +0800
From: <Hermes.Wu@ite.com.tw>
To: <krzk@kernel.org>
CC: <mchehab@kernel.org>, <robh@kernel.org>, <krzk+dt@kernel.org>,
        <conor+dt@kernel.org>, <hverkuil+cisco@kernel.org>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <broonie@kernel.org>,
        <lgirdwood@gmail.com>, <linux-sound@vger.kernel.org>,
        <linux-api@vger.kernel.org>
Subject: RE: [PATCH 1/5] dt-bindings: media: ite,it6625: add audio DAI
 properties
Thread-Topic: [PATCH 1/5] dt-bindings: media: ite,it6625: add audio DAI
 properties
Thread-Index: AQHdbGgxolHeqP/vkkmm0FEYfk19CbcetuOg
Date: Thu, 5 Nov 2026 01:50:57 +0000
Message-ID: <01818606697f4504b67d6f461d04ae57@ite.com.tw>
References: <20261103-upstream-it6625-alsa-i2s-v1-0-bb91e2879b01@ite.com.tw>
 <20261103-upstream-it6625-alsa-i2s-v1-1-bb91e2879b01@ite.com.tw>
 <20261104-sparkling-icy-hound-fd0dac@quoll>
In-Reply-To: <20261104-sparkling-icy-hound-fd0dac@quoll>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tm-snts-smtp: 0A64C475197B0BD3ADEB90642EE49E854F58658056F55C1F726BA9C9AD51143C2002:8
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
X-MAIL:mse.ite.com.tw 6A51owQl083341

SGkgS3J6eXN6dG9mDQo+DQo+LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj5Gcm9tOiBLcnp5
c3p0b2YgS296bG93c2tpIDxrcnprQGtlcm5lbC5vcmc+IA0KPlNlbnQ6IFdlZG5lc2RheSwgTm92
ZW1iZXIgNCwgMjAyNiAxMDoyNCBQTQ0KPlRvOiBIZXJtZXMgV3UgKOWQs+S9s+WujykgPEhlcm1l
cy5XdUBpdGUuY29tLnR3Pg0KPkNjOiBNYXVybyBDYXJ2YWxobyBDaGVoYWIgPG1jaGVoYWJAa2Vy
bmVsLm9yZz47IFJvYiBIZXJyaW5nIDxyb2JoQGtlcm5lbC5vcmc+OyBLcnp5c3p0b2YgS296bG93
c2tpIDxrcnprK2R0QGtlcm5lbC5vcmc+OyBDb25vciBEb29sZXkgPGNvbm9yK2R0QGtlcm5lbC5v
cmc+OyBIYW5zIFZlcmt1aWwgPGh2ZXJrdWlsK2Npc2NvQGtlcm5lbC5vcmc+OyBsaW51eC1tZWRp
YUB2Z2VyLmtlcm5lbC5vcmc7IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJu
ZWxAdmdlci5rZXJuZWwub3JnOyBNYXJrIEJyb3duIDxicm9vbmllQGtlcm5lbC5vcmc+OyBMaWFt
IEdpcmR3b29kIDxsZ2lyZHdvb2RAZ21haWwuY29tPjsgbGludXgtc291bmRAdmdlci5rZXJuZWwu
b3JnOyBsaW51eC1hcGlAdmdlci5rZXJuZWwub3JnDQo+U3ViamVjdDogUmU6IFtQQVRDSCAxLzVd
IGR0LWJpbmRpbmdzOiBtZWRpYTogaXRlLGl0NjYyNTogYWRkIGF1ZGlvIERBSSBwcm9wZXJ0aWVz
DQo+DQo+T24gVHVlLCBOb3YgMDMsIDIwMjYgYXQgMDI6NTA6MTlQTSArMDgwMCwgSGVybWVzIFd1
IHdyb3RlOg0KPj4gSVQ2NjI1IGFuZCBJVDY2MjYgZGVjb2RlIHRoZSBIRE1JIGF1ZGlvIHN0cmVh
bSBhbmQgb3V0cHV0IGl0IG9uIGFuIEkyUyANCj4+IGludGVyZmFjZSwgZHJpdmluZyB0aGUgYml0
IGFuZCBmcmFtZSBjbG9ja3MgdGhlbXNlbHZlcy4gVGhlIGJyaWRnZSBoYXMgDQo+PiB1cCB0byBl
aWdodCBJMlMgZGF0YSBwaW5zLg0KPj4gDQo+PiBBZGQgJyNzb3VuZC1kYWktY2VsbHMnIHNvIHRo
ZSBicmlkZ2UgY2FuIGJlIHJlZmVyZW5jZWQgYXMgYW4gYXVkaW8gDQo+PiBjb2RlYyBEQUksIGFu
ZCAnaXRlLGkycy1kYXRhLWxhbmVzJyB0byBkZXNjcmliZSB3aGljaCBkYXRhIHBpbnMgYXJlIA0K
Pj4gY29ubmVjdGVkIHRvIHRoZSBhdWRpbyByZWNlaXZlciwgaW4gSERNSSBjaGFubmVsLXBhaXIg
b3JkZXIuIFdpdGhvdXQgDQo+PiB0aGUgcHJvcGVydHkgb25seSBTRDAgaXMgY29ubmVjdGVkLg0K
Pj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBIZXJtZXMgV3UgPEhlcm1lcy53dUBpdGUuY29tLnR3Pg0K
Pj4gLS0tDQo+PiAgLi4uL2RldmljZXRyZWUvYmluZGluZ3MvbWVkaWEvaTJjL2l0ZSxpdDY2MjUu
eWFtbCAgfCAyMyANCj4+ICsrKysrKysrKysrKysrKysrKysrKy0NCj4+ICAxIGZpbGUgY2hhbmdl
ZCwgMjIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPg0KPlJldmlld2VkLWJ5OiBLcnp5
c3p0b2YgS296bG93c2tpIDxrcnp5c3p0b2Yua296bG93c2tpQG9zcy5xdWFsY29tbS5jb20+DQoN
ClRoYW5rcyBmb3IgeW91ciByZXZpZXcuDQoNCj5CZXN0IHJlZ2FyZHMsDQo+S3J6eXN6dG9mDQo+
DQo+DQo=
