From: Adam Manzanares <Adam.Manzanares@wdc.com>
Subject: Re: [PATCH v6 2/5] fs: Convert kiocb rw_hint from enum to u16
Date: Tue, 22 May 2018 15:43:51 +0000
Message-ID: <8b685910-9dfc-b0d0-769f-f5fc482a3252@wdc.com>
References: <20180522150737.9893-1-adam.manzanares@wdc.com>
 <20180522150737.9893-3-adam.manzanares@wdc.com>
 <11fb2ee5-8352-2d35-3154-68637d99b096@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <11fb2ee5-8352-2d35-3154-68637d99b096@kernel.dk>
Content-Language: en-US
Content-ID: <AB44D661A4E4E941A45540D624793234@namprd04.prod.outlook.com>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "bcrl@kvack.org" <bcrl@kvack.org>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@kernel.org" <mingo@kernel.org>, "pombredanne@nexb.com" <pombredanne@nexb.com>, "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "bigeasy@linutronix.de" <bigeasy@linutronix.de>, "jack@suse.cz" <jack@suse.cz>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "rgoldwyn@suse.com" <rgoldwyn@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "hch@infradread.org" <hch@infradread.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>
List-Id: linux-api@vger.kernel.org

DQoNCk9uIDUvMjIvMTggODozMiBBTSwgSmVucyBBeGJvZSB3cm90ZToNCj4gT24gNS8yMi8xOCA5
OjA3IEFNLCBhZGFtLm1hbnphbmFyZXNAd2RjLmNvbSB3cm90ZToNCj4+IEZyb206IEFkYW0gTWFu
emFuYXJlcyA8YWRhbS5tYW56YW5hcmVzQHdkYy5jb20+DQo+Pg0KPj4gSW4gb3JkZXIgdG8gYXZv
aWQga2lvY2IgYmxvYXQgZm9yIHBlciBjb21tYW5kIGlvcHJpb3JpdHkgc3VwcG9ydCwgcndfaGlu
dA0KPj4gaXMgY29udmVydGVkIGZyb20gZW51bSB0byBhIHUxNi4gQWRkZWQgYSBndWFyZCBhcm91
bmQga2lfaGludCBhc3NpZ25tZW50Lg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEFkYW0gTWFuemFu
YXJlcyA8YWRhbS5tYW56YW5hcmVzQHdkYy5jb20+DQo+PiBSZXZpZXdlZC1ieTogQ2hyaXN0b3Bo
IEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+PiAtLS0NCj4+ICAgaW5jbHVkZS9saW51eC9mcy5oIHwg
MTMgKysrKysrKysrKystLQ0KPj4gICAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9mcy5oIGIv
aW5jbHVkZS9saW51eC9mcy5oDQo+PiBpbmRleCA3ZjA3OTc3YmRmZDcuLjUwZGU0MGRiYmI4NSAx
MDA2NDQNCj4+IC0tLSBhL2luY2x1ZGUvbGludXgvZnMuaA0KPj4gKysrIGIvaW5jbHVkZS9saW51
eC9mcy5oDQo+PiBAQCAtMjg0LDYgKzI4NCw4IEBAIGVudW0gcndfaGludCB7DQo+PiAgIAlXUklU
RV9MSUZFX0VYVFJFTUUJPSBSV0hfV1JJVEVfTElGRV9FWFRSRU1FLA0KPj4gICB9Ow0KPj4gICAN
Cj4+ICsjZGVmaW5lIE1BWF9LSV9ISU5UCQkoKDEgPDwgMTYpIC0gMSkgLyoga2lfaGludCB0eXBl
IGlzIHUxNiAqLw0KPiANCj4gSW5zdGVhZCBvZiBoYXZpbmcgdG8gZG8gdGhpcyBhbmQgbm93IHJl
bHkgb24gdGhvc2Ugbm93IGJlaW5nIHN5bmNlZCwNCj4gaG93IGFib3V0IHNvbWV0aGluZyBsaWtl
IHRoZSBiZWxvdy4NCj4gDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2ZzLmggYi9pbmNs
dWRlL2xpbnV4L2ZzLmgNCj4gaW5kZXggNzYwZDhkYTFiNmM3Li4wNzA0MzhkMGI2MmQgMTAwNjQ0
DQo+IC0tLSBhL2luY2x1ZGUvbGludXgvZnMuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L2ZzLmgN
Cj4gQEAgLTI5OSw3ICsyOTksNyBAQCBzdHJ1Y3Qga2lvY2Igew0KPiAgIAl2b2lkICgqa2lfY29t
cGxldGUpKHN0cnVjdCBraW9jYiAqaW9jYiwgbG9uZyByZXQsIGxvbmcgcmV0Mik7DQo+ICAgCXZv
aWQJCQkqcHJpdmF0ZTsNCj4gICAJaW50CQkJa2lfZmxhZ3M7DQo+IC0JZW51bSByd19oaW50CQlr
aV9oaW50Ow0KPiArCXUxNgkJCWtpX2hpbnQ7DQo+ICAgfSBfX3JhbmRvbWl6ZV9sYXlvdXQ7DQo+
ICAgDQo+ICAgc3RhdGljIGlubGluZSBib29sIGlzX3N5bmNfa2lvY2Ioc3RydWN0IGtpb2NiICpr
aW9jYikNCj4gQEAgLTE5MjcsMTIgKzE5MjcsMjIgQEAgc3RhdGljIGlubGluZSBlbnVtIHJ3X2hp
bnQgZmlsZV93cml0ZV9oaW50KHN0cnVjdCBmaWxlICpmaWxlKQ0KPiAgIA0KPiAgIHN0YXRpYyBp
bmxpbmUgaW50IGlvY2JfZmxhZ3Moc3RydWN0IGZpbGUgKmZpbGUpOw0KPiAgIA0KPiArc3RhdGlj
IGlubGluZSB1MTYga2lfaGludF92YWxpZGF0ZShlbnVtIHJ3X2hpbnQgaGludCkNCj4gK3sNCj4g
Kwl0eXBlb2YoKChzdHJ1Y3Qga2lvY2IgKikwKS0+a2lfaGludCkgbWF4X2hpbnQgPSAtMTsNCj4g
Kw0KPiArCWlmIChoaW50IDw9IG1heF9oaW50KQ0KPiArCQlyZXR1cm4gaGludDsNCj4gKw0KPiAr
CXJldHVybiAwOw0KPiArfQ0KPiArDQo+ICAgc3RhdGljIGlubGluZSB2b2lkIGluaXRfc3luY19r
aW9jYihzdHJ1Y3Qga2lvY2IgKmtpb2NiLCBzdHJ1Y3QgZmlsZSAqZmlscCkNCj4gICB7DQo+ICAg
CSpraW9jYiA9IChzdHJ1Y3Qga2lvY2IpIHsNCj4gICAJCS5raV9maWxwID0gZmlscCwNCj4gICAJ
CS5raV9mbGFncyA9IGlvY2JfZmxhZ3MoZmlscCksDQo+IC0JCS5raV9oaW50ID0gZmlsZV93cml0
ZV9oaW50KGZpbHApLA0KPiArCQkua2lfaGludCA9IGtpX2hpbnRfdmFsaWRhdGUoZmlsZV93cml0
ZV9oaW50KGZpbHApKSwNCj4gICAJfTsNCj4gICB9DQoNCkxvb2tzIGdvb2QuIEknbGwgcmVzdWJt
aXQuDQoNCj4gICANCj4g

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
