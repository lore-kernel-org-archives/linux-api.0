From: Adam Manzanares <Adam.Manzanares@wdc.com>
Subject: Re: [PATCH v4 2/3] fs: Convert kiocb rw_hint from enum to u16
Date: Fri, 18 May 2018 19:53:36 +0000
Message-ID: <db91bfca-4ec9-726d-aac1-fa5979c65692@wdc.com>
References: <20180517203803.2664-1-adam.manzanares@wdc.com>
 <20180517203803.2664-3-adam.manzanares@wdc.com>
 <20180518160512.GG22791@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180518160512.GG22791@infradead.org>
Content-Language: en-US
Content-ID: <B812D3DA2D2F624ABD22CF050A2AD410@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "bcrl@kvack.org" <bcrl@kvack.org>, "mingo@kernel.org" <mingo@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "pombredanne@nexb.com" <pombredanne@nexb.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "bigeasy@linutronix.de" <bigeasy@linutronix.de>, "rgoldwyn@suse.com" <rgoldwyn@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

DQoNCk9uIDUvMTgvMTggOTowNSBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+PiArLyog
a2lfaGludCBjaGFuZ2VkIGZyb20gZW51bSB0byB1MTYsIG1ha2Ugc3VyZSByd19oaW50IGZpdHMg
aW50byB1MTYgKi8NCj4gDQo+IEkgZG9uJ3QgdGhpbmsgdGhpcyBjb21tZW50IGlzIHZlcnkgdXNl
ZnVsLg0KPiANCj4+ICtzdGF0aWMgaW5saW5lIHUxNiBraV9oaW50X3ZhbGlkKGVudW0gcndfaGlu
dCBoaW50KQ0KPiANCj4gSSdkIGNhbGwgdGhpcyBraV9oaW50X3ZhbGlkYXRlLg0KPiANCj4+ICt7
DQo+PiArCWlmIChoaW50ID4gTUFYX0tJX0hJTlQpDQo+PiArCQlyZXR1cm4gMDsNCj4+ICsNCj4+
ICsJcmV0dXJuIGhpbnQ7DQo+IA0KPiBOaXQ6IGtpbGwgdGhlIGVtcHR5IGxpbmUuDQo+IA0KDQpJ
J2xsIGNsZWFuIHRoaXMgdXAgaW4gdGhlIG5leHQgcmV2aXNpb24u
