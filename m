From: Adam Manzanares <Adam.Manzanares@wdc.com>
Subject: Re: [PATCH v5 0/5] AIO add per-command iopriority
Date: Mon, 21 May 2018 21:42:22 +0000
Message-ID: <9791140b-1674-0e36-cbd9-f2bf8b6b25f5@wdc.com>
References: <20180521160147.2372-1-adam.manzanares@wdc.com>
 <x49fu2kvi9q.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <x49fu2kvi9q.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
Content-ID: <43084E3A8FBF734AA54DCA567ADE63B2@namprd04.prod.outlook.com>
Sender: owner-linux-aio@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "bcrl@kvack.org" <bcrl@kvack.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@kernel.org" <mingo@kernel.org>, "pombredanne@nexb.com" <pombredanne@nexb.com>, "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "bigeasy@linutronix.de" <bigeasy@linutronix.de>, "jack@suse.cz" <jack@suse.cz>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "rgoldwyn@suse.com" <rgoldwyn@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>
List-Id: linux-api@vger.kernel.org

DQoNCk9uIDUvMjEvMTggMTo1NyBQTSwgSmVmZiBNb3llciB3cm90ZToNCj4gSGksIEFkYW0sDQo+
IA0KPiBhZGFtLm1hbnphbmFyZXNAd2RjLmNvbSB3cml0ZXM6DQo+IA0KPj4gRnJvbTogQWRhbSBN
YW56YW5hcmVzIDxhZGFtLm1hbnphbmFyZXNAd2RjLmNvbT4NCj4+DQo+PiBUaGlzIGlzIHRoZSBw
ZXItSS9PIGVxdWl2YWxlbnQgb2YgdGhlIGlvcHJpb19zZXQgc3lzdGVtIGNhbGwuDQo+PiBTZWUg
dGhlIGZvbGxvd2luZyBsaW5rIGZvciBwZXJmb3JtYW5jZSBpbXBsaWNhdGlvbnMgb24gYSBTQVRB
IEhERDoNCj4+IGh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDE2LzEyLzYvNDk1DQo+Pg0KPj4gRmly
c3QgcGF0Y2ggZmFjdG9ycyBpb3ByaW9fY2hlY2tfY2FwIGZ1bmN0aW9uIG91dCBvZiBpb3ByaW9f
c2V0IHN5c3RlbSBjYWxsIHRvDQo+PiBhbHNvIGJlIHVzZWQgYnkgdGhlIGFpbyBpb3ByaW8gaW50
ZXJmYWNlLg0KPj4NCj4+IFNlY29uZCBwYXRjaCBjb252ZXJ0cyBraW9jYiBraV9oaW50IGZpZWxk
IHRvIGEgdTE2IHRvIGF2b2lkIGtpb2NiIGJsb2F0Lg0KPj4NCj4+IFRoaXJkIHBhdGNoIHBhc3Nl
cyBpb3ByaW8gaGludCBmcm9tIGFpbyBpb2NiIHRvIGtpb2NiIGFuZCBpbml0aXRhbGl6ZXMga2lv
Y2INCj4+IGlvcHJpbyB2YWx1ZSBhcHByb3ByaWF0ZWx5IHdoZW4gaXQgaXMgbm90IGV4cGxpY2l0
bHkgc2V0Lg0KPj4NCj4+IEZvdXJ0aCBwYXRjaCBlbmFibGVzIHRoZSBmZWF0dXJlIGZvciBibGtk
ZXYuDQo+Pg0KPj4gRmlmdGggcGF0Y2ggZW5hYmxlcyB0aGUgZmVhdHVyZSBmb3IgaW9tYXAgZGly
ZWN0IElPDQo+Pg0KPj4gTm90ZTogdGhpcyB3b3JrIGlzIGJhc2VkIG9uIHRvcCBvZiBsaW51eC12
ZnMvZm9yLW5leHQNCj4gDQo+IEknbGwgY29vayB1cCBhIGxpYmFpbyB0ZXN0IGNhc2UuICBDYW4g
eW91IHB1dCB0b2dldGhlciBhIG1hbi1wYWdlcw0KPiB1cGRhdGUgZm9yIHRoaXM/DQoNCkhlbGxv
IEplZmYsDQoNCkknbGwgc2VuZCBvdXQgYSBtYW4tcGFnZXMgdXBkYXRlIHNvb24uDQoNClRoYW5r
cywNCkFkYW0NCg0KPiANCj4gVGhhbmtzIQ0KPiBKZWZmDQo+IA==

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
