From: Adam Manzanares <Adam.Manzanares@wdc.com>
Subject: Re: [PATCH v3 2/3] fs: Convert kiocb rw_hint from enum to u16
Date: Wed, 9 May 2018 15:29:00 +0000
Message-ID: <a22de016-686f-ce93-c311-71a6719ee521@wdc.com>
References: <20180508174202.2537-1-adam.manzanares@wdc.com>
 <20180508174202.2537-3-adam.manzanares@wdc.com>
 <20180509133432.GD28388@thunk.org>
 <0aad993b-448c-3586-cfc0-f2e50b1dda28@kernel.dk>
 <20180509152149.GG28388@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180509152149.GG28388@thunk.org>
Content-Language: en-US
Content-ID: <1D1CEED69CA4194DAC16276FE7E2C4F9@namprd04.prod.outlook.com>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "bcrl@kvack.org" <bcrl@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

DQoNCk9uIDUvOS8xOCAxMToyMSBBTSwgVGhlb2RvcmUgWS4gVHMnbyB3cm90ZToNCj4gT24gV2Vk
LCBNYXkgMDksIDIwMTggYXQgMDg6MjM6MDBBTSAtMDYwMCwgSmVucyBBeGJvZSB3cm90ZToNCj4+
IFN0cmVhbXMgaXMgZXNzZW50aWFsbHkgdGhlIG9ubHkgdGhpbmcga2lfaGludCBpcyBjdXJyZW50
bHkgdXNlZCBmb3IsDQo+PiB3aXRoIHRoZSB3cml0ZSBsaWZlIHRpbWUgaGludHMgbWFwcGluZyB0
byBhIHN0cmVhbS4gVGhlIGlkZWEgZm9yIHRoZQ0KPj4gdXNlciBzaWRlIEFQSSB3YXMgdG8gaGF2
ZSBvdGhlciB0aGluZ3MgdGhhbiBqdXN0IHdyaXRlIGxpZmUgdGltZSBoaW50cy4NCj4+DQo+PiBT
aW5jZSBBZGFtIHdhbnRzIHRvIGRvIHByaW9yaXRpZXMsIGhlJ2QgZWl0aGVyIG5lZWQgdG8gcGFj
ayBpbnRvIHRoZQ0KPj4gZXhpc3Rpbmcga2lfaGludCwgb3IgZG8gdGhpcyBwYXRjaCBkb2VzLCB3
aGljaCBpcyBtYWtlIGl0IHNtYWxsZXIgYW5kDQo+PiBhZGQgYSBuZXcgbWVtYmVyLiBJIHRoaW5r
IHRoZSBsYXR0ZXIgaXMgY2xlYW5lci4NCj4gDQo+IEZhaXIgZW5vdWdoOyBidXQgbWF5YmUgd2Ug
Y2FuIHVzZSBhIHU4IGluc3RlYWQgb2YgYSB1MTY/ICA2NSw1MzUNCj4gcHJpb3JpdGllcyBzdGls
bCBzZWVtIGxpa2Ugd2F5IG1vcmUgdGhhbiB3b3VsZCBldmVyIG1ha2Ugc2Vuc2UuICBJDQo+IHRo
aW5rIDI1NiBwcmlvcml0aWVzIGlzIHN0aWxsIHdheSB0byBtYW55LCBidXQgaXQncyBzaW1wbGVy
IHdoaWxlDQo+IHN0aWxsIHJlc2VydmluZyBudW1iZXIgb2YgYml0cyBmb3IgZnV0dXJlIHNlLg0K
DQpUaGUgaW50ZW50aW9uIHdhcyB0byBtaW1pYyB0aGUgaW9wcmlvX3NldCBzeXN0ZW0gY2FsbCwg
d2hpY2ggdXNlcyAzIGJpdHMgDQpmb3IgYSBwcmlvIGNsYXNzIGFuZCAxMyBiaXRzIGZvciBhIHBy
aW9fdmFsdWUuDQoNCklESyB3aGF0IGlzIHRoZSByaWdodCBhbW91bnQgb2YgYml0cyB0byB1c2Us
IGJ1dCB0aGUgZXhpc3RpbmcgdXNlIG9mIA0KYml0cyBzZWVtZWQgZmxleGlibGUgZW5vdWdoIHRv
IHN1cHBvcnQgbWFueSB0eXBlcyBvZiBhcHBsaWNhdGlvbnMgYW5kIA0KZGV2aWNlcy4NCj4gDQo+
ICAgICAgICAgICAgICAJCSAgICAgICAJICAgICAgIAkgICAtIFRlZA0KPiA=

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
