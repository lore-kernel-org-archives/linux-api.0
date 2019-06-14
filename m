From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup and
 thread creation (v10)
Date: Fri, 14 Jun 2019 13:29:29 +0000
Message-ID: <69a53ec2ce184af29c4cae58e0b2fb57@AcuMS.aculab.com>
References: <20190503184219.19266-1-mathieu.desnoyers@efficios.com>
 <c16c9785-7f8c-430b-a4df-a53e47bf1600@redhat.com>
 <914051741.43025.1560348011775.JavaMail.zimbra@efficios.com>
 <802638054.3032.1560506584705.JavaMail.zimbra@efficios.com>
 <87ftocwkei.fsf@oldenburg2.str.redhat.com>
 <1635690189.3049.1560507249693.JavaMail.zimbra@efficios.com>
 <87tvcsv1pk.fsf@oldenburg2.str.redhat.com>
 <1190407525.3131.1560516910936.JavaMail.zimbra@efficios.com>
 <1085273942.3137.1560517301721.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1085273942.3137.1560517301721.JavaMail.zimbra@efficios.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Mathieu Desnoyers' <mathieu.desnoyers@efficios.com>, Florian Weimer <fweimer@redhat.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

RnJvbTogTWF0aGlldSBEZXNub3llcnMNCj4gU2VudDogMTQgSnVuZSAyMDE5IDE0OjAyDQouLi4N
Cj4gQnV0IG15IG9yaWdpbmFsIGlzc3VlIHJlbWFpbnM6IGlmIEkgZGVmaW5lIGEgdmFyaWFibGUg
Y2FsbGVkIF9fcnNlcV9oYW5kbGVkDQo+IHdpdGhpbiBlaXRoZXIgdGhlIG1haW4gZXhlY3V0YWJs
ZSBvciB0aGUgcHJlbG9hZGVkIGxpYnJhcnksIGl0IG92ZXJzaGFkb3dzDQo+IHRoZSBsaWJjIG9u
ZToNCg0KMSkgVGhhdCBpcyB0aGUgd2FzIGVsZiBzeW1ib2wgcmVzb2x1dGlvbiBpcyByZXF1aXJl
ZCB0byB3b3JrLg0KICAgT3RoZXJ3aXNlIHZhcmlhYmxlcyBsaWtlICdlcnJubycgKG5vbi10aHJl
YWQgc2FmZSBmb3JtKSB3b3VsZG4ndCB3b3JrLg0KDQoyKSBEb24ndCBkbyBpdCB0aGVuIDotKQ0K
ICAgTmFtZXMgc3RhcnRpbmcgd2l0aCBfXyB3aWxsIGJlIHJlc2VydmVkIChwcm9iYWJseSAnZm9y
IHRoZSBpbXBsZW1lbnRhdGlvbicpLg0KDQpUaGUgcmVhbCAnZnVuJyBzdGFydHMgYmVjYXVzZSwg
dW5kZXIgc29tZSBjaXJjdW1zdGFuY2VzLCBsb29raW5nIHVwIGEgc3ltYm9sIGFzOg0KCWZvbyA9
IGRsc3ltKGxpYl9oYW5kbGUsICJmb28iKTsNCkNhbiBmaW5kIHRoZSBkYXRhIGl0ZW0gaW5zdGVh
ZCBvZiB0aGUgZnVuY3Rpb24hDQpVc3VhbGx5IGl0IHdvcmtzIChldmVuIHdoZW4gZm9vIGlzIGds
b2JhbCBkYXRhKSBiZWNhdXNlICdsaWJfaGFuZGxlJyByZWZlcnMNCnRvIGEgZGlmZmVyZW50IHN5
bWJvbCB0YWJsZS4NCkJ1dCBpdCBjYW4gZ28gaG9ycmlibHkgd3JvbmcuDQoNCglEYXZpZA0KDQot
DQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwg
TWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2Fs
ZXMpDQo=
