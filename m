From: Adam Manzanares <Adam.Manzanares@wdc.com>
Subject: Re: [PATCH v4 0/3] AIO add per-command iopriority
Date: Fri, 18 May 2018 15:03:06 +0000
Message-ID: <e1062b8f-20e9-8f13-6bb7-d522193c895f@wdc.com>
References: <20180517203803.2664-1-adam.manzanares@wdc.com>
 <3ec960cf-e14c-6ff6-3356-186136f43df7@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3ec960cf-e14c-6ff6-3356-186136f43df7@kernel.dk>
Content-Language: en-US
Content-ID: <D523657124DBC34796DD94E0BBBC349E@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "bcrl@kvack.org" <bcrl@kvack.org>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "pombredanne@nexb.com" <pombredanne@nexb.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "bigeasy@linutronix.de" <bigeasy@linutronix.de>, "rgoldwyn@suse.com" <rgoldwyn@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

DQoNCk9uIDUvMTcvMTggNzo0MSBQTSwgSmVucyBBeGJvZSB3cm90ZToNCj4gT24gNS8xNy8xOCAy
OjM4IFBNLCBhZGFtLm1hbnphbmFyZXNAd2RjLmNvbSB3cm90ZToNCj4+IEZyb206IEFkYW0gTWFu
emFuYXJlcyA8YWRhbS5tYW56YW5hcmVzQHdkYy5jb20+DQo+Pg0KPj4gVGhpcyBpcyB0aGUgcGVy
LUkvTyBlcXVpdmFsZW50IG9mIHRoZSBpb3ByaW9fc2V0IHN5c3RlbSBjYWxsLg0KPj4gU2VlIHRo
ZSBmb2xsb3dpbmcgbGluayBmb3IgcGVyZm9ybWFuY2UgaW1wbGljYXRpb25zIG9uIGEgU0FUQSBI
REQ6DQo+PiBodHRwczovL2xrbWwub3JnL2xrbWwvMjAxNi8xMi82LzQ5NQ0KPj4NCj4+IEZpcnN0
IHBhdGNoIGZhY3RvcnMgaW9wcmlvX2NoZWNrX2NhcCBmdW5jdGlvbiBvdXQgb2YgaW9wcmlvX3Nl
dCBzeXN0ZW0gY2FsbCB0bw0KPj4gYWxzbyBiZSB1c2VkIGJ5IHRoZSBhaW8gaW9wcmlvIGludGVy
ZmFjZS4NCj4+DQo+PiBTZWNvbmQgcGF0Y2ggY29udmVydHMga2lvY2Iga2lfaGludCBmaWVsZCB0
byBhIHUxNiB0byBhdm9pZCBraW9jYiBibG9hdC4NCj4+DQo+PiBUaGlyZCBwYXRjaCBwYXNzZXMg
aW9wcmlvIGhpbnQgZnJvbSBhaW8gaW9jYiB0byBraW9jYiBhbmQgZW5hYmxlcyBibG9ja19kZXYN
Cj4+IHVzYWdlIG9mIHRoZSBwZXIgSS9PIGlvcHJpbyBmZWF0dXJlLg0KPj4NCj4+IHYyOiBtZXJn
ZSBwYXRjaGVzDQo+PiAgICAgIHVzZSBJT0NCX0ZMQUdfSU9QUklPDQo+PiAgICAgIHZhbGlkYXRl
IGludGVuZGVkIHVzZSB3aXRoIElPQ0JfSU9QUklPDQo+PiAgICAgIGFkZCBsaW51eC1hcGkgYW5k
IGxpbnV4LWJsb2NrIHRvIGNjDQo+Pg0KPj4gdjM6IGFkZCBpb3ByaW9fY2hlY2tfY2FwIGZ1bmN0
aW9uDQo+PiAgICAgIGNvbnZlcnQga2lvY2Iga2lfaGludCB0byB1MTYNCj4+ICAgICAgdXNlIGlv
cHJpb19jaGVja19jYXAgd2hlbiBhZGRpbmcgaW9wcmlvIHRvIGtpb2NiIGluIGFpby5jDQo+Pg0K
Pj4gdjQ6IGhhbmRsZSBJT0NCX0lPUFJJTyBpbiBhaW9fcHJlcF9ydw0KPj4gICAgICBub3RlIHBh
dGNoIDMgZGVwZW5kcyBvbiBwYXRjaCAxIGluIGNvbW1pdCBtc2cNCj4+DQo+PiBBZGFtIE1hbnph
bmFyZXMgKDMpOg0KPj4gICAgYmxvY2s6IGFkZCBpb3ByaW9fY2hlY2tfY2FwIGZ1bmN0aW9uDQo+
PiAgICBmczogQ29udmVydCBraW9jYiByd19oaW50IGZyb20gZW51bSB0byB1MTYNCj4+ICAgIGZz
OiBBZGQgYWlvIGlvcHJpb3JpdHkgc3VwcG9ydCBmb3IgYmxvY2tfZGV2DQo+Pg0KPj4gICBibG9j
ay9pb3ByaW8uYyAgICAgICAgICAgICAgIHwgMjIgKysrKysrKysrKysrKysrKy0tLS0tLQ0KPj4g
ICBmcy9haW8uYyAgICAgICAgICAgICAgICAgICAgIHwgMTYgKysrKysrKysrKysrKysrKw0KPj4g
ICBmcy9ibG9ja19kZXYuYyAgICAgICAgICAgICAgIHwgIDIgKysNCj4+ICAgaW5jbHVkZS9saW51
eC9mcy5oICAgICAgICAgICB8IDE3ICsrKysrKysrKysrKysrKy0tDQo+PiAgIGluY2x1ZGUvbGlu
dXgvaW9wcmlvLmggICAgICAgfCAgMiArKw0KPj4gICBpbmNsdWRlL3VhcGkvbGludXgvYWlvX2Fi
aS5oIHwgIDEgKw0KPj4gICA2IGZpbGVzIGNoYW5nZWQsIDUyIGluc2VydGlvbnMoKyksIDggZGVs
ZXRpb25zKC0pDQo+IA0KPiBUaGlzIGxvb2tzIGZpbmUgdG8gbWUgbm93LiBJIGNhbiBwaWNrIHVw
ICMxIGZvciA0LjE4IC0gYW5kIDIrMyBhcyB3ZWxsLA0KPiB1bmxlc3Mgc29tZW9uZSBlbHNlIHdh
bnRzIHRvIHRha2UgdGhlbS4NCg0KR3JlYXQsIHRoYW5rcyBKZW5zLg0KDQo+IA==
