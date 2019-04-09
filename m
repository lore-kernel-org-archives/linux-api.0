From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH] io_uring: add support for barrier fsync
Date: Tue, 9 Apr 2019 18:56:56 +0000
Message-ID: <FBAE8433-865B-4D4D-B658-27E234FE829F@fb.com>
References: <7c7276e4-8ffa-495a-6abf-926a58ee899e@kernel.dk>
 <20190409181742.GA24925@infradead.org>
 <5f8d9644-9e8f-c9d2-611e-4b144c62539c@kernel.dk>
 <5BF7FDDE-212E-4F9A-9B50-26BDA99E952A@fb.com>
 <a7f00629-f822-7271-7a4e-ad3b802752e4@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a7f00629-f822-7271-7a4e-ad3b802752e4@kernel.dk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

T24gOSBBcHIgMjAxOSwgYXQgMTQ6NDYsIEplbnMgQXhib2Ugd3JvdGU6DQoNCj4gT24gNC85LzE5
IDEyOjQyIFBNLCBDaHJpcyBNYXNvbiB3cm90ZToNCg0KPj4gTG9va2luZyBhdCB0aGUgcGF0Y2gs
IHdoeSBpcyBmc3luYyBzcGVjaWFsPyAgU2VlbXMgbGlrZSB5b3UgY291bGQgYWRkDQo+PiB0aGlz
IG9yZGVyaW5nIGJpdCB0byBhbnkgd3JpdGU/DQo+DQo+IEl0J3MgcmVhbGx5IG5vdCwgdGhlIGV4
YWN0IHNhbWUgdGVjaG5pcXVlIGNvdWxkIGJlIHVzZWQgb24gYW55IHR5cGUgb2YNCj4gY29tbWFu
ZCB0byBpbXBseSBvcmRlcmluZy4gTXkgaW5pdGlhbCBpZGVhIHdhcyB0byBoYXZlIGFuIGV4cGxp
Y2l0DQo+IGJhcnJpZXIvb3JkZXJpbmcgY29tbWFuZCwgYnV0IEkgZGlkbid0IHRoaW5rIHRoYXQg
c2VwYXJhdGluZyBpdCBmcm9tIA0KPiBhbg0KPiBhY3R1YWwgY29tbWFuZCB3b3VsZCBiZSBuZWVk
ZWQvdXNlZnVsLg0KDQpNaWdodCB3YW50IHRvIG9yZGVyIGRpc2NhcmRzPyAgQ29tbWl0IGEgdHJh
bnNhY3Rpb24gdG8gZnJlZSBzb21lIGJsb2NrcywgDQpkaXNjYXJkIHRob3NlIGJsb2Nrcz8NCg0K
Pg0KPj4gV2hpbGUgeW91J3JlIGhlcmUsIGRvIHlvdSB3YW50IHRvIGFkZCBhIHdheSB0byBGVUEv
Y2FjaGUgZmx1c2g/DQo+PiBCYXNpY2FsbHkgdGhlIHJlc3Qgb2Ygd2hhdCB1c2VyIGxhbmQgd291
bGQgbmVlZCB0byBtYWtlIHRoZWlyIG93bg0KPj4gd3JpdGUtYmFjay1jYWNoZS1zYWZlIGltcGxl
bWVudGF0aW9uLg0KPg0KPiBGVUEgd291bGQgYmUgYSBXUklURVYvV1JJVEVfRklYRUQgZmxhZywg
dGhhdCBzaG91bGQgYmUgdHJpdmlhbGx5IA0KPiBkb2FibGUuDQo+DQo+IEluIHRlcm1zIG9mIGNh
Y2hlIGZsdXNoLCB0aGF0J3MgdmVyeSBoZWF2eSBoYW5kZWQgKGFuZCBzdG9yYWdlDQo+IG9yaWVu
dGVkKS4gIFdoYXQgYXBwbGljYXRpb25zIHdvdWxkIHdhbnQvbmVlZCB0byBkbyBhbiBleHBsaWNp
dCB3aG9sZQ0KPiBkZXZpY2UgZmx1c2g/DQoNCkJhc2ljYWxseSBpZiBzb21lb25lIGlzIHdyaXRp
bmcgYSB1c2VybGFuZCBmaWxlc3lzdGVtIHRoZXknZCB3YW50IHRvIA0KY2FjaGUgZmx1c2ggZm9y
IHRoZSBzYW1lIHJlYXNvbnMgdGhlIGtlcm5lbCBmaWxlc3lzdGVtcyBkby4NCg0KDQotY2hyaXMN
Cg==
