From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v2 1/2] fork: add clone3
Date: Tue, 4 Jun 2019 10:42:20 +0000
Message-ID: <8e7f7afb177049ac9f8e7223f19e8767@AcuMS.aculab.com>
References: <20190603144331.16760-1-christian@brauner.io>
 <4020.1559640492@warthog.procyon.org.uk>
 <20190604094317.4wfelmbw4lgxzide@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190604094317.4wfelmbw4lgxzide@brauner.io>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Christian Brauner' <christian@brauner.io>, David Howells <dhowells@redhat.com>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "jannh@google.com" <jannh@google.com>, "keescook@chromium.org" <keescook@chromium.org>, "fweimer@redhat.com" <fweimer@redhat.com>, "oleg@redhat.com" <oleg@redhat.com>, "arnd@arndb.de" <arnd@arndb.de>, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

RnJvbTogQ2hyaXN0aWFuIEJyYXVuZXINCj4gU2VudDogMDQgSnVuZSAyMDE5IDEwOjQzDQouLi4N
Cj4gPiA+ICsJdTY0IGNsb25lX2ZsYWdzID0gYXJncy0+ZmxhZ3M7DQo+ID4gPiArCWludCBfX3Vz
ZXIgKmNoaWxkX3RpZHB0ciA9IGFyZ3MtPmNoaWxkX3RpZDsNCj4gPiA+ICsJdW5zaWduZWQgbG9u
ZyB0bHMgPSBhcmdzLT50bHM7DQo+ID4gPiArCXVuc2lnbmVkIGxvbmcgc3RhY2tfc3RhcnQgPSBh
cmdzLT5zdGFjazsNCj4gPiA+ICsJdW5zaWduZWQgbG9uZyBzdGFja19zaXplID0gYXJncy0+c3Rh
Y2tfc2l6ZTsNCj4gPg0KPiA+IFNvbWUgb2YgdGhlc2UgYXJlIG9ubHkgdXNlZCBvbmNlLCBzbyBp
dCdzIHByb2JhYmx5IG5vdCB3b3J0aCBzdGlja2luZyB0aGVtIGluDQo+ID4gbG9jYWwgdmFyaWFi
bGVzLg0KPiANCj4gWzFdOg0KPiBPaywgd2lsbCBkb3VibGUgY2hlY2suDQo+IFRoaXMgd2FzIGp1
c3QgdG8gbWluaW1pemUgY29weS1wYXN0ZSBlcnJvcyBmb3IgdmFyaWFibGVzIHdoaWNoIHdlcmUg
dXNlZA0KPiBtdWx0aXBsZSB0aW1lcy4NCg0KRXZlbiB0aGUgb25lcyB0aGF0IGFyZSB1c2VkIG11
bHRpcGxlIHRpbWVzIG1heSBiZSBiZXR0ZXIgYmVpbmcNCnJlcGVhdGVkbHkgcmVhZCBmcm9tIGFy
Z3MtPnh4eC4NCg0KSWYgeW91IGFyZSAibHVja3kiICdhcmdzJyB3aWxsIGJlIGluIGEgcmVnaXN0
ZXIgdmFyaWFibGVzDQpzbyBhbGwgdGhlIGFjY2Vzc2VzIGFyZSBjaGVhcC4NCldpdGggdG9vIG1h
bnkgbG9jYWxzIGV2ZXJ5dGhpbmcgZ2V0cyBjb3BpZWQgb250byB0aGUgYWN0dWFsDQpzdGFjayAt
IGVzcGVjaWFsbHkgbGlrZWx5IGlmIHRoZXJlIGFyZSBhbnkgZnVuY3Rpb24gY2FsbHMNCih0aGF0
IG1pZ2h0IGNvbmNlaXZhYmx5IGNoYW5nZSAqYXJncykgYWZ0ZXIgdGhlIGxvY2Fscw0KYXJlIGlu
aXRpYWxpc2VkLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBC
cmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdp
c3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K
