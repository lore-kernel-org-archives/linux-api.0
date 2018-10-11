From: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Subject: Re: [RFC PATCH for 4.21 01/16] rseq/selftests: Add reference counter
 to coexist with glibc
Date: Thu, 11 Oct 2018 10:37:25 +0000
Message-ID: <38596780-30f7-0763-0c17-7517dbf0bf59@arm.com>
References: <20181010191936.7495-1-mathieu.desnoyers@efficios.com>
 <20181010191936.7495-2-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181010191936.7495-2-mathieu.desnoyers@efficios.com>
Content-Language: en-US
Content-ID: <098D89D6A661F644B1E5C7D8D0DD5A03@eurprd08.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>
Cc: nd <nd@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.c>
List-Id: linux-api@vger.kernel.org

T24gMTAvMTAvMTggMjA6MTksIE1hdGhpZXUgRGVzbm95ZXJzIHdyb3RlOg0KPiBJbiBvcmRlciB0
byBpbnRlZ3JhdGUgcnNlcSBpbnRvIHVzZXItc3BhY2UgYXBwbGljYXRpb25zLCBhZGQgYSByZWZl
cmVuY2UNCj4gY291bnRlciBmaWVsZCBhZnRlciB0aGUgc3RydWN0IHJzZXEgVExTIEFCSSBzbyBt
YW55IHJzZXEgdXNlcnMgY2FuIGJlDQo+IGxpbmtlZCBpbnRvIHRoZSBzYW1lIGFwcGxpY2F0aW9u
IChlLmcuIGxpYnJzZXEgYW5kIGdsaWJjKS4gVGhlDQo+IHJlZmVyZW5jZSBjb3VudCBlbnN1cmVz
IHRoYXQgcnNlcSBzeXNjYWxsIHJlZ2lzdHJhdGlvbi91bnJlZ2lzdHJhdGlvbg0KPiBoYXBwZW5z
IG9ubHkgZm9yIHRoZSBtb3N0IGVhcmx5L2xhdGUgdXNlciBmb3IgZWFjaCB0aHJlYWQsIHRodXMg
ZW5zdXJpbmcNCj4gdGhhdCByc2VxIGlzIHJlZ2lzdGVyZWQgYWNyb3NzIHRoZSBsaWZldGltZSBv
ZiBhbGwgcnNlcSB1c2VycyBmb3IgYQ0KPiBnaXZlbiB0aHJlYWQuDQouLi4NCj4gK19fYXR0cmli
dXRlX18oKHZpc2liaWxpdHkoImhpZGRlbiIpKSkgX190aHJlYWQNCj4gK3ZvbGF0aWxlIHN0cnVj
dCBsaWJjX3JzZXEgX19saWJfcnNlcV9hYmkgPSB7DQouLi4NCj4gK2V4dGVybiBfX2F0dHJpYnV0
ZV9fKCh3ZWFrLCBhbGlhcygiX19saWJfcnNlcV9hYmkiKSkpIF9fdGhyZWFkDQo+ICt2b2xhdGls
ZSBzdHJ1Y3QgcnNlcSBfX3JzZXFfYWJpOw0KLi4uDQo+IEBAIC03MCw3ICs4Niw3IEBAIGludCBy
c2VxX3JlZ2lzdGVyX2N1cnJlbnRfdGhyZWFkKHZvaWQpDQo+ICAJc2lnc2V0X3Qgb2xkc2V0Ow0K
PiAgDQo+ICAJc2lnbmFsX29mZl9zYXZlKCZvbGRzZXQpOw0KPiAtCWlmIChyZWZjb3VudCsrKQ0K
PiArCWlmIChfX2xpYl9yc2VxX2FiaS5yZWZjb3VudCsrKQ0KPiAgCQlnb3RvIGVuZDsNCj4gIAly
YyA9IHN5c19yc2VxKCZfX3JzZXFfYWJpLCBzaXplb2Yoc3RydWN0IHJzZXEpLCAwLCBSU0VRX1NJ
Ryk7DQoNCndoeSBkbyB5b3UgdXNlIGEgbG9jYWwgcmVmY291bnRlciBpbnN0ZWFkIG9mIHRoZSBf
X3JzZXFfYWJpIG9uZT8NCg0Kd2hhdCBwcmV2ZW50cyBjYWxsaW5nIHJzZXFfcmVnaXN0ZXJfY3Vy
cmVudF90aHJlYWQgbW9yZSB0aGFuIDRHIHRpbWVzPw0KDQp3aHkgY2FudCB0aGUga2VybmVsIHNl
ZSB0aGF0IHRoZSBzYW1lIGFkZHJlc3MgaXMgcmVnaXN0ZXJlZCBhZ2FpbiBhbmQgc3VjY2VlZD8N
Cg==
