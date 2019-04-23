From: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup and
 thread creation (v8)
Date: Tue, 23 Apr 2019 11:16:03 +0000
Message-ID: <a1bd2595-b7ae-b06b-9c71-802901ed8587@arm.com>
References: <20190416173216.9028-1-mathieu.desnoyers@efficios.com>
 <1770787324.668.1555530989646.JavaMail.zimbra@efficios.com>
 <1066731871.915.1555593471194.JavaMail.zimbra@efficios.com>
 <6cbfea7b-9d83-74a5-9cd2-af56a5d68818@arm.com>
 <1055153722.1072.1555602067220.JavaMail.zimbra@efficios.com>
 <79996d13-2ba2-ed7d-b202-e7d38f1fd870@arm.com>
 <604915684.1299.1555607449814.JavaMail.zimbra@efficios.com>
 <846db7ef-f75e-53b8-3c4c-461ec730a17e@arm.com>
 <1531569198.1389.1555611422188.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1531569198.1389.1555611422188.JavaMail.zimbra@efficios.com>
Content-Language: en-US
Content-ID: <683B99399D7B2B4FAF62C9C4A80FA203@eurprd08.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: nd <nd@arm.com>, Joseph Myers <joseph@codesourcery.com>, Will Deacon <Will.Deacon@arm.com>, carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

T24gMTgvMDQvMjAxOSAxOToxNywgTWF0aGlldSBEZXNub3llcnMgd3JvdGU6DQo+IC0tLS0tIE9u
IEFwciAxOCwgMjAxOSwgYXQgMTozNyBQTSwgU3phYm9sY3MgTmFneSBTemFib2xjcy5OYWd5QGFy
bS5jb20gd3JvdGU6DQo+PiB5b3UgaGF2ZSB0byBhZGQgYSBkb2N1bWVudGF0aW9uIGNvbW1lbnQg
c29tZXdoZXJlDQo+PiBleHBsYWluaW5nIGlmIFJTRVFfU0lHIGlzIHRoZSB2YWx1ZSB0aGF0J3Mg
cGFzc2VkIHRvDQo+PiB0aGUga2VybmVsIGFuZCB0aGVuIGFhcmNoNjQgYXNtIGNvZGUgaGFzIHRv
IHVzZQ0KPj4NCj4+IC5pbnN0IGVuZGlhbmZpeHVwKFJTRVFfU0lHKSAvLyBvcg0KPj4gLndvcmQg
UlNFUV9TSUcNCj4gDQo+IFVzaW5nICIud29yZCIgd29uJ3QgYWxsb3cgb2JqZHVtcCB0byBzaG93
IHRoZSBpbnN0cnVjdGlvbiBpdA0KPiBtYXBzIHRvLiBJdCB3aWxsIGNvbnNpZGVyIGl0IGFzIGRh
dGEuIFNvIC5pbnN0IGlzIHByZWZlcnJlZCBoZXJlLg0KDQppcyB0aGVyZSBzb21lIHNwZWNpZmlj
IHJlYXNvbiB5b3UgcHJlZmVyIC5pbnN0Pw0KDQpkaXNhc3NlbWJsaW5nIGEgY2FuYXJ5IHZhbHVl
IGFzIGRhdGEgKHRoYXQgaXMNCm5ldmVyIGV4ZWN1dGVkLCBidXQgbG9hZGVkIGFuZCBjb21wYXJl
ZCBieSB0aGUNCmtlcm5lbCBhcyBkYXRhKSBzb3VuZHMgbW9yZSBzZW1hbnRpY2FsbHkgY29ycmVj
dA0KdG8gbWUgdGhhbiBzaG93aW5nIGl0IGFzIGFuIGluc3RydWN0aW9uLg0KDQppIGd1ZXNzIGhh
dmluZyBpdCBhcyBhbiBpbnN0cnVjdGlvbiBjYW4gYXZvaWQNCmlzc3VlcyBpZiBzb21lIHRvb2xz
IGRpc2xpa2UgLndvcmQgaW4gLnRleHQsDQpidXQgb3RoZXJ3aXNlIC53b3JkIHNlZW1zIGJldHRl
ci4NCg==
