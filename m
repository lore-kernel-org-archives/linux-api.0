From: Adam Manzanares <Adam.Manzanares@wdc.com>
Subject: Re: [PATCH v2] fs: Add aio iopriority support for block_dev
Date: Thu, 3 May 2018 20:58:17 +0000
Message-ID: <e81c74fd-a4a2-80e0-476c-6ff35f158abf@wdc.com>
References: <20180503182114.2797-1-adam.manzanares@wdc.com>
 <20180503183353.GC1562@bombadil.infradead.org>
 <47e0a519-37b4-f5e7-0616-8659d11c2b69@wdc.com>
 <18300bdb-a12f-0b6c-1317-6db3e4391d57@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <18300bdb-a12f-0b6c-1317-6db3e4391d57@kernel.dk>
Content-Language: en-US
Content-ID: <E98C0F07F155E64EBB398B22DCB40485@namprd04.prod.outlook.com>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "bcrl@kvack.org" <bcrl@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

DQoNCk9uIDUvMy8xOCAxOjI0IFBNLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBPbiA1LzMvMTggMjox
NSBQTSwgQWRhbSBNYW56YW5hcmVzIHdyb3RlOg0KPj4NCj4+DQo+PiBPbiA1LzMvMTggMTE6MzMg
QU0sIE1hdHRoZXcgV2lsY294IHdyb3RlOg0KPj4+IE9uIFRodSwgTWF5IDAzLCAyMDE4IGF0IDEx
OjIxOjE0QU0gLTA3MDAsIGFkYW0ubWFuemFuYXJlc0B3ZGMuY29tIHdyb3RlOg0KPj4+PiBJZiB3
ZSB3YW50IHRvIGF2b2lkIGJsb2F0aW5nIHN0cnVjdCBraW9jYiwgSSBzdWdnZXN0IHdlIHR1cm4g
dGhlIHByaXZhdGUgZmllbGQNCj4+Pj4gaW50byBhIHVuaW9uIG9mIHRoZSBwcml2YXRlIGFuZCBr
aV9pb3ByaW8gZmllbGQuIEl0IHNlZW1zIGxpa2UgdGhlIHVzZXJzIG9mDQo+Pj4+IHRoZSBwcml2
YXRlIGZpZWxkIGFsbCB1c2UgaXQgYXQgYSBwb2ludCB3aGVyZSB3ZSBjYW4geWFuayB0aGUgcHJp
b3JpdHkgZnJvbQ0KPj4+PiB0aGUga2lvY2IgYmVmb3JlIHRoZSBwcml2YXRlIGZpZWxkIGlzIHVz
ZWQuIENvbW1lbnRzIGFuZCBzdWdnZXN0aW9ucyB3ZWxjb21lLg0KPj4+DQo+Pj4gT3Igd2UgY291
bGQganVzdCBtYWtlIGtpX2hpbnQgYSB1OCBvciB1MTYgLi4uIHNlZW1zIHVubGlrZWx5IHdlJ2xs
IG5lZWQNCj4+PiAzMiBiaXRzIG9mIGtpX2hpbnQuICAoY3VycmVudGx5IGRlZmluZWQgdmFsdWVz
IGFyZSAxLTUpDQo+Pg0KPj4gSSBsaWtlIHRoZSBhcHByb2FjaCBvZiB1c2luZyBhIHUxNiBmb3Ig
dGhlIGtpX2hpbnQuIEknbGwgdXBkYXRlIGFuZA0KPj4gcmVzdWJtaXQuDQo+IA0KPiBJdCdzIGlu
dGVuZGVkIHRvIGJlIGEgbWFzay4gSWYgeW91IGRvIHNocmluayBpdCBmb3Igbm93LCB0aGVuIHdl
IG5lZWQgc29tZQ0KPiBndWFyZCBjb2RlIHRvIGVuc3VyZSBpdCBjYW4gYWx3YXlzIGNhcnJ5IHdo
YXQgaXQgbmVlZHMgdG8uDQo+IA0KDQpHb3QgaXQsIEknbGwgYWRkIHRoZSBndWFyZCB0byByd19o
aW50X3ZhbGlkIGFsb25nIHdpdGggYSBjb21tZW50IGFib3V0IA0KYmVpbmcgbGltaXRlZCBieSB0
aGUgc2l6ZSBvZiBraV9oaW50IGluIGNhc2Ugd2UgZ2V0IHRvIGEgc2l0dWF0aW9uIHdoZXJlIA0K
MTYgYml0cyBpcyBub3QgZW5vdWdoLg0K

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
