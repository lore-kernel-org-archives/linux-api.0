From: Adam Manzanares <Adam.Manzanares@wdc.com>
Subject: Re: [PATCH v7 0/5] AIO add per-command iopriority
Date: Tue, 22 May 2018 22:31:27 +0000
Message-ID: <30e8e33f-8e66-2fb3-977a-ee6fe04f1d3c@wdc.com>
References: <20180522175221.2391-1-adam.manzanares@wdc.com>
 <da84d129-4dcd-c861-bfc4-62cd425e60e3@kernel.dk>
 <20180522183019.GD30522@ZenIV.linux.org.uk>
 <4b8732e8-1c51-3181-56a1-d03f7b229f63@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <4b8732e8-1c51-3181-56a1-d03f7b229f63@kernel.dk>
Content-Language: en-US
Content-ID: <B3D9CD9C2C2F2D47BBAA699DC67CB5F0@namprd04.prod.outlook.com>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "bcrl@kvack.org" <bcrl@kvack.org>, "mingo@kernel.org" <mingo@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>, "peterz@infradead.org" <peterz@infradead.org>, "pombredanne@nexb.com" <pombredanne@nexb.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "bigeasy@linutronix.de" <bigeasy@linutronix.de>, "rgoldwyn@suse.com" <rgoldwyn@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "hch@infradread.org" <hch@infradread.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>
List-Id: linux-api@vger.kernel.org

DQoNCk9uIDUvMjIvMTggMTE6MzAgQU0sIEplbnMgQXhib2Ugd3JvdGU6DQo+IE9uIDUvMjIvMTgg
MTI6MzAgUE0sIEFsIFZpcm8gd3JvdGU6DQo+PiBPbiBUdWUsIE1heSAyMiwgMjAxOCBhdCAxMTo1
NTowNEFNIC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPj4+IE9uIDUvMjIvMTggMTE6NTIgQU0s
IGFkYW0ubWFuemFuYXJlc0B3ZGMuY29tIHdyb3RlOg0KPj4+PiBGcm9tOiBBZGFtIE1hbnphbmFy
ZXMgPGFkYW0ubWFuemFuYXJlc0B3ZGMuY29tPg0KPj4+Pg0KPj4+PiBUaGlzIGlzIHRoZSBwZXIt
SS9PIGVxdWl2YWxlbnQgb2YgdGhlIGlvcHJpb19zZXQgc3lzdGVtIGNhbGwuDQo+Pj4+IFNlZSB0
aGUgZm9sbG93aW5nIGxpbmsgZm9yIHBlcmZvcm1hbmNlIGltcGxpY2F0aW9ucyBvbiBhIFNBVEEg
SEREOg0KPj4+PiBodHRwczovL2xrbWwub3JnL2xrbWwvMjAxNi8xMi82LzQ5NQ0KPj4+Pg0KPj4+
PiBGaXJzdCBwYXRjaCBmYWN0b3JzIGlvcHJpb19jaGVja19jYXAgZnVuY3Rpb24gb3V0IG9mIGlv
cHJpb19zZXQgc3lzdGVtIGNhbGwgdG8NCj4+Pj4gYWxzbyBiZSB1c2VkIGJ5IHRoZSBhaW8gaW9w
cmlvIGludGVyZmFjZS4NCj4+Pj4NCj4+Pj4gU2Vjb25kIHBhdGNoIGNvbnZlcnRzIGtpb2NiIGtp
X2hpbnQgZmllbGQgdG8gYSB1MTYgdG8gYXZvaWQga2lvY2IgYmxvYXQuDQo+Pj4+DQo+Pj4+IFRo
aXJkIHBhdGNoIHBhc3NlcyBpb3ByaW8gaGludCBmcm9tIGFpbyBpb2NiIHRvIGtpb2NiIGFuZCBp
bml0aWFsaXplcyBraW9jYg0KPj4+PiBpb3ByaW8gdmFsdWUgYXBwcm9wcmlhdGVseSB3aGVuIGl0
IGlzIG5vdCBleHBsaWNpdGx5IHNldC4NCj4+Pj4NCj4+Pj4gRm91cnRoIHBhdGNoIGVuYWJsZXMg
dGhlIGZlYXR1cmUgZm9yIGJsa2Rldi4NCj4+Pj4NCj4+Pj4gRmlmdGggcGF0Y2ggZW5hYmxlcyB0
aGUgZmVhdHVyZSBmb3IgaW9tYXAgZGlyZWN0IElPDQo+Pj4NCj4+PiBMR1RNLCB5b3UgY2FuIGFk
ZDoNCj4+Pg0KPj4+IFJldmlld2VkLWJ5OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+DQo+
Pj4NCj4+PiBBbCwgYXJlIHlvdSBwaWNraW5nIHRoaXMgc2VyaWVzIHVwLCBvciBzaG91bGQgST8N
Cj4+DQo+PiBQcm9iYWJseSBiZXR0ZXIgaWYgSSBkbywgb25jZSBJIGZpbmlzaCByZXZpZXdpbmcg
Q2hyaXN0b3BoJ3MgcGF0Y2hzZXQgLQ0KPj4gd2UgYWxyZWFkeSBoYXZlIGEgYnVuY2ggb2Ygc3R1
ZmYgYXJvdW5kIGZzL2Fpby5jIGluIHRoaXMgY3ljbGUuLi4NCj4gDQo+IEFscmlnaHQsIHNvdW5k
cyBnb29kLCB0aGFua3MgQWwuDQo+IA0KDQpJIHdhcyB3b3JraW5nIG9uIHRoZSBtYW4gcGFnZSB1
cGRhdGUgZm9yIHRoaXMgZmVhdHVyZSBhbmQgbm90aWNlZCBJIA0KY291bGQgYmUgYml0IG1vcmUg
aW5mb3JtYXRpdmUgb24gZXJyb3IgaWYgSSByZXR1cm4gdGhlIGVycm9yIHZhbHVlIA0KcmV0dXJu
ZWQgYnkgaW9wcmlvX2NoZWNrX2NhcCBpbiBmcy9haW8uYy4NCg0KU2hvdWxkIEkgcmVzZW5kIHRo
ZSB3aG9sZSBzZXJpZXM/

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
