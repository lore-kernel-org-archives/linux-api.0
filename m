From: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Subject: Re: [PATCH 2/5] glibc: sched_getcpu(): use rseq cpu_id TLS on Linux
 (v2)
Date: Thu, 18 Apr 2019 15:33:33 +0000
Message-ID: <c9c53d4b-ed9b-f2d9-60b0-e5e805de0324@arm.com>
References: <20190416173216.9028-1-mathieu.desnoyers@efficios.com>
 <20190416173216.9028-3-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <libc-alpha-return-101522-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20190416173216.9028-3-mathieu.desnoyers@efficios.com>
Content-ID: <8E32C93A8CB8DF46A798F4AD2DCCAD17@eurprd08.prod.outlook.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Carlos O'Donell <carlos@redhat.com>
Cc: nd <nd@arm.com>, Florian Weimer <fweimer@redhat.com>, Joseph Myers <joseph@codesourcery.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <Will.Deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

T24gMTYvMDQvMjAxOSAxODozMiwgTWF0aGlldSBEZXNub3llcnMgd3JvdGU6DQo+IC0tLSBhL3N5
c2RlcHMvdW5peC9zeXN2L2xpbnV4L3NjaGVkX2dldGNwdS5jDQo+ICsrKyBiL3N5c2RlcHMvdW5p
eC9zeXN2L2xpbnV4L3NjaGVkX2dldGNwdS5jDQo+IEBAIC0zNywzICszNywyNiBAQCBzY2hlZF9n
ZXRjcHUgKHZvaWQpDQo+ICAgIHJldHVybiAtMTsNCj4gICNlbmRpZg0KPiAgfQ0KPiArDQo+ICsj
aWZkZWYgX19OUl9yc2VxDQo+ICsjaW5jbHVkZSA8c3lzL3JzZXEuaD4NCj4gKyNlbmRpZg0KPiAr
DQo+ICsjaWYgZGVmaW5lZCBfX05SX3JzZXEgJiYgZGVmaW5lZCBSU0VRX1NJRw0KPiArZXh0ZXJu
IF9fYXR0cmlidXRlX18gKCh0bHNfbW9kZWwgKCJpbml0aWFsLWV4ZWMiKSkpDQo+ICtfX3RocmVh
ZCB2b2xhdGlsZSBzdHJ1Y3QgcnNlcSBfX3JzZXFfYWJpOw0KDQppJ2QgZXhwZWN0IHN5cy9yc2Vx
LmggdG8gcHJvdmlkZSB0aGlzIGRlY2xhcmF0aW9uLg0KDQo+ICsNCj4gK2ludA0KPiArc2NoZWRf
Z2V0Y3B1ICh2b2lkKQ0KPiArew0KPiArICBpbnQgY3B1X2lkID0gX19yc2VxX2FiaS5jcHVfaWQ7
DQo+ICsNCj4gKyAgcmV0dXJuIGNwdV9pZCA+PSAwID8gY3B1X2lkIDogdnN5c2NhbGxfc2NoZWRf
Z2V0Y3B1ICgpOw0KPiArfQ0KPiArI2Vsc2UNCj4gK2ludA0KPiArc2NoZWRfZ2V0Y3B1ICh2b2lk
KQ0KPiArew0KPiArICByZXR1cm4gdnN5c2NhbGxfc2NoZWRfZ2V0Y3B1ICgpOw0KPiArfQ0KPiAr
I2VuZGlmDQo+IC0tIDIuMTcuMQ0KPiANCg0K
