From: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Subject: Re: [RFC PATCH v4 1/5] glibc: Perform rseq(2) registration at nptl
 init and thread creation
Date: Thu, 22 Nov 2018 16:24:56 +0000
Message-ID: <7032ab45-8314-b85d-5b4d-f83b41dab5b6@arm.com>
References: <20181121183936.8176-1-mathieu.desnoyers@efficios.com>
 <20181122143603.GD23599@brightrain.aerifal.cx>
 <782067422.9852.1542899056778.JavaMail.zimbra@efficios.com>
 <87a7m1ywni.fsf@oldenburg.str.redhat.com>
 <20181122151710.GF23599@brightrain.aerifal.cx>
 <875zwpyw81.fsf@oldenburg.str.redhat.com>
 <1306224240.10055.1542900799576.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <libc-alpha-return-97469-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <1306224240.10055.1542900799576.JavaMail.zimbra@efficios.com>
Content-ID: <9173429E9D72E04E90A56A409D0D6B1C@eurprd08.prod.outlook.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Florian Weimer <fweimer@redhat.com>
Cc: nd <nd@arm.com>, Rich Felker <dalias@libc.org>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <Will.Deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

T24gMjIvMTEvMTggMTU6MzMsIE1hdGhpZXUgRGVzbm95ZXJzIHdyb3RlOg0KPiAtLS0tLSBPbiBO
b3YgMjIsIDIwMTgsIGF0IDEwOjIxIEFNLCBGbG9yaWFuIFdlaW1lciBmd2VpbWVyQHJlZGhhdC5j
b20gd3JvdGU6DQo+PiBSaWdodCwgYnV0IGluIGNhc2Ugb2YgdXNlci1zdXBwbGllZCBzdGFja3Ms
IHdlIGFjdHVhbGx5IGZyZWUgVExTIG1lbW9yeQ0KPj4gYXQgdGhpcyBwb2ludCwgc28gc2lnbmFs
cyBuZWVkIHRvIGJlIGJsb2NrZWQgYmVjYXVzZSB0aGUgVENCIGlzDQo+PiAocGFydGlhbGx5KSBn
b25lIGFmdGVyIHRoYXQuDQo+IA0KPiBVbmZvcnR1bnRhdGVseSwgZGlzYWJsaW5nIHNpZ25hbHMg
aXMgbm90IGVub3VnaC4NCj4gDQo+IFdpdGggcnNlcSByZWdpc3RlcmVkLCB0aGUga2VybmVsIGFj
Y2Vzc2VzIHRoZSByc2VxIFRMUyBhcmVhIHdoZW4gcmV0dXJuaW5nIHRvDQo+IHVzZXItc3BhY2Ug
YWZ0ZXIgX3ByZWVtcHRpb25fIG9mIHVzZXItc3BhY2UsIHdoaWNoIGNhbiBiZSB0cmlnZ2VyZWQg
YXQgYW55DQo+IHBvaW50IGJ5IGFuIGludGVycnVwdCBvciBhIGZhdWx0LCBldmVuIGlmIHNpZ25h
bHMgYXJlIGJsb2NrZWQuDQo+IA0KPiBTbyBpZiB0aGVyZSBhcmUgY2FzZXMgd2hlcmUgdGhlIFRM
UyBtZW1vcnkgaXMgZnJlZWQgd2hpbGUgdGhlIHRocmVhZCBpcyBzdGlsbA0KPiBydW5uaW5nLCB3
ZSBfbmVlZF8gdG8gZXhwbGljaXRseSB1bnJlZ2lzdGVyIHJzZXEgYmVmb3JlaGFuZC4NCg0KaSB0
aGluayB0aGUgbWFuIHBhZ2Ugc2hvdWxkIHBvaW50IHRoaXMgb3V0Lg0KDQp0aGUgbWVtb3J5IG9m
IGEgcmVnaXN0ZXJlZCByc2VxIG9iamVjdCBtdXN0IG5vdCBiZSBmcmVlZA0KYmVmb3JlIHRocmVh
ZCBleGl0LiAoZWl0aGVyIHVucmVnaXN0ZXIgaXQgb3IgZnJlZSBsYXRlcikNCg0KYW5kIGlkZWFs
bHkgYWxzbyBwb2ludCBvdXQgdGhhdCBjIGxhbmd1YWdlIHRocmVhZCBzdG9yYWdlDQpkdXJhdGlv
biBkb2VzIG5vdCBwcm92aWRlIHRoaXMgZ3VhcmFudGVlOiBpdCBtYXkgYmUgZnJlZWQNCmJ5IHRo
ZSBpbXBsZW1lbnRhdGlvbiBiZWZvcmUgdGhyZWFkIGV4aXQgKHdoaWNoIGlzIGN1cnJlbnRseQ0K
bm90IG9ic2VydmFibGUsIGJ1dCB3aXRoIHRoZSByc2VxIHN5c2NhbGwgaXQgaXMpLg0K
