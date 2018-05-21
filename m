From: Adam Manzanares <Adam.Manzanares@wdc.com>
Subject: Re: [PATCH v5 4/5] fs: blkdev set bio prio from kiocb prio
Date: Mon, 21 May 2018 21:43:16 +0000
Message-ID: <d4f44ce3-3f4b-e8d9-4b8a-7f846dfd6d10@wdc.com>
References: <20180521160147.2372-1-adam.manzanares@wdc.com>
 <20180521160147.2372-5-adam.manzanares@wdc.com>
 <x49r2m4u3e6.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <x49r2m4u3e6.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
Content-ID: <AE2EC24D79BCCD4797C45A4993BF3654@namprd04.prod.outlook.com>
Sender: owner-linux-aio@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "bcrl@kvack.org" <bcrl@kvack.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@kernel.org" <mingo@kernel.org>, "pombredanne@nexb.com" <pombredanne@nexb.com>, "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "bigeasy@linutronix.de" <bigeasy@linutronix.de>, "jack@suse.cz" <jack@suse.cz>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "rgoldwyn@suse.com" <rgoldwyn@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>
List-Id: linux-api@vger.kernel.org

DQoNCk9uIDUvMjEvMTggMjowNCBQTSwgSmVmZiBNb3llciB3cm90ZToNCj4gYWRhbS5tYW56YW5h
cmVzQHdkYy5jb20gd3JpdGVzOg0KPiANCj4+IEZyb206IEFkYW0gTWFuemFuYXJlcyA8YWRhbS5t
YW56YW5hcmVzQHdkYy5jb20+DQo+Pg0KPj4gTm93IHRoYXQga2lvY2IgaGFzIGFuIGlvcHJpbyBm
aWVsZCBjb3B5IHRoaXMgb3ZlciB0byB0aGUgYmlvIHdoZW4gaXQgaXMNCj4+IGNyZWF0ZWQgZnJv
bSB0aGUga2lvY2IuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogQWRhbSBNYW56YW5hcmVzIDxhZGFt
Lm1hbnphbmFyZXNAd2RjLmNvbT4NCj4+IC0tLQ0KPj4gICBmcy9ibG9ja19kZXYuYyB8IDEgKw0K
Pj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4+DQo+PiBkaWZmIC0tZ2l0IGEv
ZnMvYmxvY2tfZGV2LmMgYi9mcy9ibG9ja19kZXYuYw0KPj4gaW5kZXggN2VjOTIwZTI3MDY1Li5k
YTFlOTRkMmJiNzUgMTAwNjQ0DQo+PiAtLS0gYS9mcy9ibG9ja19kZXYuYw0KPj4gKysrIGIvZnMv
YmxvY2tfZGV2LmMNCj4+IEBAIC0zNTUsNiArMzU1LDcgQEAgX19ibGtkZXZfZGlyZWN0X0lPKHN0
cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0IGlvdl9pdGVyICppdGVyLCBpbnQgbnJfcGFnZXMpDQo+
PiAgIAkJYmlvLT5iaV93cml0ZV9oaW50ID0gaW9jYi0+a2lfaGludDsNCj4+ICAgCQliaW8tPmJp
X3ByaXZhdGUgPSBkaW87DQo+PiAgIAkJYmlvLT5iaV9lbmRfaW8gPSBibGtkZXZfYmlvX2VuZF9p
bzsNCj4+ICsJCWJpby0+YmlfaW9wcmlvID0gaW9jYi0+a2lfaW9wcmlvOw0KPj4gICANCj4+ICAg
CQlyZXQgPSBiaW9faW92X2l0ZXJfZ2V0X3BhZ2VzKGJpbywgaXRlcik7DQo+PiAgIAkJaWYgKHVu
bGlrZWx5KHJldCkpIHsNCj4gDQo+IEZvcmdvdCB0byBtZW50aW9uLCB5b3Ugc2hvdWxkIGFsc28g
Y29udmVydCBfX2Jsa2Rldl9kaXJlY3RfSU9fc2ltcGxlLg0KDQpOUC4NCg0KPiANCj4gLUplZmYN
Cj4g

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
