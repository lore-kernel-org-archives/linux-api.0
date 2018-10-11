From: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Subject: Re: [RFC PATCH for 4.21 01/16] rseq/selftests: Add reference counter
 to coexist with glibc
Date: Thu, 11 Oct 2018 17:04:28 +0000
Message-ID: <f22ef029-2f30-6bd9-e46a-9e7b0a1e9225@arm.com>
References: <20181010191936.7495-1-mathieu.desnoyers@efficios.com>
 <20181010191936.7495-2-mathieu.desnoyers@efficios.com>
 <38596780-30f7-0763-0c17-7517dbf0bf59@arm.com>
 <1917048565.2402.1539270808972.JavaMail.zimbra@efficios.com>
 <3896e4f5-aab1-ae79-5360-088fd15ed380@arm.com>
 <1680616760.2469.1539275846360.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1680616760.2469.1539275846360.JavaMail.zimbra@efficios.com>
Content-Language: en-US
Content-ID: <64087B4148EC8346BD3D59C1397425D5@eurprd08.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: nd <nd@arm.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <Catalin.Marinas@arm.com>
List-Id: linux-api@vger.kernel.org

T24gMTEvMTAvMTggMTc6MzcsIE1hdGhpZXUgRGVzbm95ZXJzIHdyb3RlOg0KPiAtLS0tLSBPbiBP
Y3QgMTEsIDIwMTgsIGF0IDEyOjIwIFBNLCBTemFib2xjcyBOYWd5IFN6YWJvbGNzLk5hZ3lAYXJt
LmNvbSB3cm90ZToNCj4+IE9uIDExLzEwLzE4IDE2OjEzLCBNYXRoaWV1IERlc25veWVycyB3cm90
ZToNCj4+PiAtLS0tLSBPbiBPY3QgMTEsIDIwMTgsIGF0IDY6MzcgQU0sIFN6YWJvbGNzIE5hZ3kg
U3phYm9sY3MuTmFneUBhcm0uY29tIHdyb3RlOg0KPj4+PiBPbiAxMC8xMC8xOCAyMDoxOSwgTWF0
aGlldSBEZXNub3llcnMgd3JvdGU6DQo+Pj4+PiArX19hdHRyaWJ1dGVfXygodmlzaWJpbGl0eSgi
aGlkZGVuIikpKSBfX3RocmVhZA0KPj4+Pj4gK3ZvbGF0aWxlIHN0cnVjdCBsaWJjX3JzZXEgX19s
aWJfcnNlcV9hYmkgPSB7DQo+Pj4+IC4uLg0KPj4gYnV0IGl0J3MgaW4gYSBtYWdpYyBzdHJ1Y3Qg
dGhhdCdzIGNhbGxlZCAiYWJpIiB3aGljaCBpcyBjb25mdXNpbmcsDQo+PiB0aGUgY291bnRlciBp
cyBub3QgYWJpLCBpdCdzIGluIGEgaGlkZGVuIG9iamVjdC4NCj4gDQo+IE5vLCBpdCBpcyByZWFs
bHkgYW4gQUJJIGJldHdlZW4gdXNlci1zcGFjZSBhcHBzL2xpYnMuIEl0J3Mgbm90IG1lYW50IHRv
IGJlDQo+IGhpZGRlbi4gZ2xpYmMgaW1wbGVtZW50cyBpdHMgb3duIHJlZ2lzdGVyL3VucmVnaXN0
ZXIgZnVuY3Rpb25zIChpdCBkb2VzIG5vdA0KPiBsaW5rIGFnYWluc3QgbGlicnNlcSkuIGxpYnJz
ZXEgZXhwb3NlcyByZWdpc3Rlci91bnJlZ2lzdGVyIGZ1bmN0aW9ucyBhcyBwdWJsaWMNCj4gQVBJ
cy4gVGhvc2UgYWxzbyB1c2UgdGhlIHJlZmNvdW50LiBJIGFsc28gcGxhbiB0byBoYXZlIGV4aXN0
aW5nIGxpYnJhcmllcywgZS5nLg0KPiBsaWJsdHRuZy11c3QgYW5kIHBvc3NpYmx5IGxpYnVyY3Ug
Zmxhdm9ycywgaW1wbGVtZW50IHRoZQ0KPiByZWdpc3RyYXRpb24vdW5yZWdpc3RyYXRpb24gYW5k
IHJlZmNvdW50IGhhbmRsaW5nIG9uIHRoZWlyIG93biwgc28gd2UgZG9uJ3QNCj4gaGF2ZSB0byBh
ZGQgYSByZXF1aXJlbWVudCBvbiBhZGRpdGlvbmFsIGxpbmtpbmcgb24gbGlicnNlcSBmb3IgcHJl
LWV4aXN0aW5nDQo+IGxpYnJhcmllcy4NCj4gDQo+IFNvIHRoYXQgcmVmY291bnQgaXMgbm90IGFu
IEFCSSBiZXR3ZWVuIGtlcm5lbCBhbmQgdXNlci1zcGFjZSwgYnV0IGl0J3MgYQ0KPiB1c2VyLXNw
YWNlIEFCSSBuZXZlcnRoZWxlc3MgKGJldHdlZW4gcHJvZ3JhbSBhbmQgc2hhcmVkIG9iamVjdHMp
Lg0KPiANCg0KaWYgdGhhdCdzIHdoYXQgeW91IHdhbnQsIHRoZW4geW91ciBkZWNsYXJhdGlvbiBp
cyB3cm9uZy4NCnRoZSBvYmplY3Qgc2hvdWxkIG5vdCBoYXZlIGhpZGRlbiB2aXNpYmlsaXR5Lg0K
DQp0aGVuIGVhY2ggbGlicmFyeSAoZ2xpYmMgZXRjKSB3aWxsIGhhdmUgaXRzIG93biBzZXBhcmF0
ZQ0KdGxzIG9iamVjdCB3aXRoIHRoZWlyIG93biBzZXBhcmF0ZSByZWZjb3VudGVyIChhbmQgdGhl
eQ0Kd2lsbCB1bnJlZ2lzdGVyIHdoZW4gdGhlaXIgb3duIHJlZmNvdW50ZXIgaGl0cyAwKQ0KDQpl
aXRoZXIgdGhlIHN0cnVjdCBzaG91bGQgYmUgcHVibGljIGFiaSAoZXh0ZXJuIHRscw0Kc3ltYm9s
KSBvciB0aGUgcmVnaXN0ZXIvdW5yZWdpc3RlciBmdW5jdGlvbnMgc2hvdWxkDQpiZSBwdWJsaWMg
YWJpIChzbyB3aGVuIG11bHRpcGxlIGltcGxlbWVudGF0aW9ucyBhcmUNCnByZXNlbnQgaW4gdGhl
IHNhbWUgcHJvY2VzcyBvbmx5IG9uZSBvZiB0aGVtIHdpbGwNCnByb3ZpZGUgZGVmaW5pdGlvbiBm
b3IgdGhlIHB1YmxpYyBhYmkgc3ltYm9sIGFuZA0KdGh1cyB0aGVyZSB3aWxsIGJlIG9uZSByZWZj
b3VudGVyKS4NCg==
