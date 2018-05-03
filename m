From: Adam Manzanares <Adam.Manzanares@wdc.com>
Subject: Re: [PATCH v2] fs: Add aio iopriority support for block_dev
Date: Thu, 3 May 2018 20:15:26 +0000
Message-ID: <47e0a519-37b4-f5e7-0616-8659d11c2b69@wdc.com>
References: <20180503182114.2797-1-adam.manzanares@wdc.com>
 <20180503183353.GC1562@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180503183353.GC1562@bombadil.infradead.org>
Content-Language: en-US
Content-ID: <3822E9025F1FC74CA698A76F10CDBAAA@namprd04.prod.outlook.com>
Sender: owner-linux-aio@kvack.org
To: Matthew Wilcox <willy@infradead.org>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "bcrl@kvack.org" <bcrl@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

DQoNCk9uIDUvMy8xOCAxMTozMyBBTSwgTWF0dGhldyBXaWxjb3ggd3JvdGU6DQo+IE9uIFRodSwg
TWF5IDAzLCAyMDE4IGF0IDExOjIxOjE0QU0gLTA3MDAsIGFkYW0ubWFuemFuYXJlc0B3ZGMuY29t
IHdyb3RlOg0KPj4gSWYgd2Ugd2FudCB0byBhdm9pZCBibG9hdGluZyBzdHJ1Y3Qga2lvY2IsIEkg
c3VnZ2VzdCB3ZSB0dXJuIHRoZSBwcml2YXRlIGZpZWxkDQo+PiBpbnRvIGEgdW5pb24gb2YgdGhl
IHByaXZhdGUgYW5kIGtpX2lvcHJpbyBmaWVsZC4gSXQgc2VlbXMgbGlrZSB0aGUgdXNlcnMgb2YN
Cj4+IHRoZSBwcml2YXRlIGZpZWxkIGFsbCB1c2UgaXQgYXQgYSBwb2ludCB3aGVyZSB3ZSBjYW4g
eWFuayB0aGUgcHJpb3JpdHkgZnJvbQ0KPj4gdGhlIGtpb2NiIGJlZm9yZSB0aGUgcHJpdmF0ZSBm
aWVsZCBpcyB1c2VkLiBDb21tZW50cyBhbmQgc3VnZ2VzdGlvbnMgd2VsY29tZS4NCj4gDQo+IE9y
IHdlIGNvdWxkIGp1c3QgbWFrZSBraV9oaW50IGEgdTggb3IgdTE2IC4uLiBzZWVtcyB1bmxpa2Vs
eSB3ZSdsbCBuZWVkDQo+IDMyIGJpdHMgb2Yga2lfaGludC4gIChjdXJyZW50bHkgZGVmaW5lZCB2
YWx1ZXMgYXJlIDEtNSkNCg0KSSBsaWtlIHRoZSBhcHByb2FjaCBvZiB1c2luZyBhIHUxNiBmb3Ig
dGhlIGtpX2hpbnQuIEknbGwgdXBkYXRlIGFuZCANCnJlc3VibWl0Lg0KDQo+PiBAQCAtMzAwLDYg
KzMwMSw3IEBAIHN0cnVjdCBraW9jYiB7DQo+PiAgIAl2b2lkCQkJKnByaXZhdGU7DQo+PiAgIAlp
bnQJCQlraV9mbGFnczsNCj4+ICAgCWVudW0gcndfaGludAkJa2lfaGludDsNCj4+ICsJdTE2CQkJ
a2lfaW9wcmlvOyAvKiBTZWUgbGludXgvaW9wcmlvLmggKi8NCj4+ICAgfSBfX3JhbmRvbWl6ZV9s
YXlvdXQ7DQo+PiAgIA0KPj4gICBzdGF0aWMgaW5saW5lIGJvb2wgaXNfc3luY19raW9jYihzdHJ1
Y3Qga2lvY2IgKmtpb2NiKQ==

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
