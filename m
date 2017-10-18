From: Ben Maurer <bmaurer@fb.com>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Wed, 18 Oct 2017 16:41:44 +0000
Message-ID: <CY4PR15MB1688286D6B1283A1C234BAE6CF4E0@CY4PR15MB1688.namprd15.prod.outlook.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>,<20171012230326.19984-2-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171012230326.19984-2-mathieu.desnoyers@efficios.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

PiBUaGUgbGF5b3V0IG9mIHN0cnVjdCByc2VxX2NzIGlzIGFzIGZvbGxvd3M6DQoNCj4gc3RhcnRf
aXANCj4gSW5zdHJ1Y3Rpb24gcG9pbnRlciBhZGRyZXNzIG9mIHRoZSBmaXJzdCBpbnN0cnVjdGlv
biBvZiB0aGUNCj4gc2VxdWVuY2Ugb2YgY29uc2VjdXRpdmUgYXNzZW1ibHkgaW5zdHJ1Y3Rpb25z
Lg0KDQo+IHBvc3RfY29tbWl0X2lwDQo+IEluc3RydWN0aW9uIHBvaW50ZXIgYWRkcmVzcyBhZnRl
ciB0aGUgbGFzdMKgIGluc3RydWN0aW9uwqAgb2YNCj7CoCB0aGUgc2VxdWVuY2Ugb2YgY29uc2Vj
dXRpdmUgYXNzZW1ibHkgaW5zdHJ1Y3Rpb25zLg0KDQo+wqAgYWJvcnRfaXANCj4gSW5zdHJ1Y3Rp
b27CoCBwb2ludGVywqAgYWRkcmVzc8KgIHdoZXJlwqAgdG8gbW92ZSB0aGUgZXhlY3V0aW9uDQo+
wqAgZmxvdyBpbiBjYXNlIG9mIGFib3J0IG9mIHRoZSBzZXF1ZW5jZSBvZiBjb25zZWN1dGl2ZSBh
c3NlbeKAkA0KPsKgIGJseSBpbnN0cnVjdGlvbnMuDQoNClJlYWxseSBtaW5vciBwZXJmb3JtYW5j
ZSBwZXJmb3JtYW5jZSB0aG91Z2h0IGhlcmUuDQoNCjEpIEluIHRoZSBrZXJuZWwgYXQgY29udGV4
dCBzd2l0Y2ggdGltZSB5b3UnZCBuZWVkIGNvZGUgbGlrZToNCg0KaWYgKGlwID49IHN0YXJ0X2lw
ICYmIGlwIDw9IHBvc3RfY29tbWl0X2lwKQ0KDQpUaGlzIGJyYW5jaCB3b3VsZCBiZSBoYXJkIHRv
IHByZWRpY3QgYmVjYXVzZSBtb3N0IGluc3RydWN0aW9uIHBvaW50ZXJzIHdvdWxkIGJlIGVpdGhl
ciBiZWZvcmUgb3IgYWZ0ZXIuIElmIHBvc3RfY29tbWl0X2lwIHdlcmUgcmVsYXRpdmUgdG8gc3Rh
cnRfaXAgeW91IGNvdWxkIGRvIHRoaXM6DQoNCmlmIChpcCAtIHN0YXJ0X2lwIDw9IHBvc3RfY29t
bWl0X29mZnNldCkNCg0Kd2hpY2ggaXMgYSBzaW5nbGUgYnJhbmNoIHRoYXQgd291bGQgYmUgbW9y
ZSBwcmVkaWN0YWJsZS4NCg0KMikgSW4gYSBzaGFyZWQgbGlicmFyeSBhIHJzZXFfY3Mgc3RydWN0
dXJlIHdvdWxkIGhhdmUgdG8gYmUgcmVsb2NhdGVkIGF0IHJ1bnRpbWUgYmVjYXVzZSBhdCBjb21w
aWxhdGlvbiB0aW1lIHRoZSBmaW5hbCBhZGRyZXNzIG9mIHRoZSBsaWJyYXJ5IHdvdWxkbid0IGJl
IGtub3duLiBJJ20gbm90IHN1cmUgaWYgdGhpcyBpcyBpbXBvcnRhbnQgZW5vdWdoIHRvIGFkZHJl
c3MsIGJ1dCBpdCBjb3VsZCBiZSBzb2x2ZWQgYnkgbWFraW5nIHRoZSBwb2ludGVycyByZWxhdGl2
ZSB0byB0aGUgYWRkcmVzcyBvZiByc2VxX2NzLiBCdXQgdGhpcyB3b3VsZCBtYWtlIGZvciBhbiB1
Z2xpZXIgQVBJLg0K
