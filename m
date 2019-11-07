From: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Subject: Re: Continuing the UAPI split
Date: Thu, 7 Nov 2019 16:21:05 +0000
Message-ID: <facb4d0d-4e20-41f0-4c01-b210c677c24c@arm.com>
References: <CALN7hCK0EXLXjPRPr+tuuF2-uQvkLMCFDNzGhv9HS-jrAz6Hmg@mail.gmail.com>
 <0B17C6F2-DC2B-4192-B4AD-BD11D6B9F2B6@ubuntu.com>
 <87zhh7j38y.fsf@oldenburg2.str.redhat.com>
 <CALN7hCJ_umFqC1L0T19CuiGiGoVwac5807NDw4LiDqSD-VJL=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <libc-alpha-return-106765-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <CALN7hCJ_umFqC1L0T19CuiGiGoVwac5807NDw4LiDqSD-VJL=Q@mail.gmail.com>
Content-ID: <7259AF935704D94F85E0736EA8EE530F@eurprd08.prod.outlook.com>
To: Elichai Turkel <elichai.turkel@gmail.com>, Florian Weimer <fweimer@redhat.com>
Cc: nd <nd@arm.com>, Christian Brauner <christian.brauner@ubuntu.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, libc-alpha <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

T24gMDcvMTEvMjAxOSAxMzowMywgRWxpY2hhaSBUdXJrZWwgd3JvdGU6DQo+IEEgcmVuYW1lIHRv
IHRoZSBzdHJ1Y3RzL3R5cGVzIHNvIHRoZXkgd29uJ3QgY29sbGlkZSB3aXRoIGxpYmM/DQo+IFBy
aW9yaXRpemluZyBQT1NJWCBjb25mb3JtYW5jZSBpbiB0aGUga2VybmVsKEkgdGhpbmsgdGhhdCBz
aGlwIGhhcyBsb25nIHNhaWxlZCk/DQoNCmhvc3RlZCBjIGNvZGUgY2FuIG9ubHkgdXNlIGxpbnV4
IGFwaSBoZWFkZXJzIHJlbGlhYmx5DQppZiB0aG9zZSByZXNwZWN0IHRoZSBpc28gYyBhbmQgcG9z
aXggcnVsZXMuDQoNCmxpbnV4IHNob3VsZCBtYWludGFpbiBhIGNsZWFuIHNldCBvZiBjIGhlYWRl
cnMgKG9yDQppbnRlcmZhY2UgZGVzY3JpcHRpb25zIGZyb20gd2hpY2ggc3VjaCBoZWFkZXJzIGNh
biBiZQ0KZ2VuZXJhdGVkKS4NCg0KcHJvdmlkaW5nIGNsZWFuIGhlYWRlcnMgdGhhdCB3b3JrIGlu
IGJvdGggaG9zdGVkIGFuZA0KZnJlZXN0YW5kaW5nIGVudmlyb25tZW50cyBpcyBub3QgdHJpdmlh
bDogZS5nLiB0aGUNCmZvcm1lciByZXF1aXJlcyB0eXBlIGRlZmluaXRpb25zIHRvIHVzZSBsaWJj
IHR5cGVzLA0KdGhlIGxhdHRlciByZXF1aXJlcyB0eXBlIGRlZmluaXRpb25zIHRoYXQgZG9uJ3Qg
ZGVwZW5kDQpvbiB0aGUgbGliYy4NCg0KZS5nLiBhIHBvc3NpYmxlIGFwcHJvYWNoIGlzIHRvIHVz
ZSBpc28gYyBpbXBsZW1lbnRhdGlvbg0KcmVzZXJ2ZWQgbmFtZXNwYWNlIGZvciBhbGwgbGludXgg
YXBpIGlkZW50aWZpZXJzLCBzbw0KaXQncyBlbnRpcmVseSBpbmRlcGVuZGVudCBvZiBsaWJjIGFu
ZCBub24tY29uZmxpY3RpbmcsDQp0aGVuIGxpYmMgaGVhZGVycyBjYW4gcmVwbGljYXRlIGRlY2xh
cmF0aW9ucyB0aGF0IGl0DQp3YW50cyB0byBleHBvc2UgKHdpdGggZGlmZmVyZW50IG5hbWVzIGFu
ZCBsaWJjIHR5cGVzKS4NCih0aGVyZSBhcmUgb3RoZXIgd2F5cywgYnV0IHRoZSBjdXJyZW50IGhl
YWRlcnMgYXJlIGhhcmQNCnRvIHVzZSB3aGljaCBhZmZlY3RzIGEgbG90IG9mIHVzZXJzKQ0KDQo+
IE9yIGp1c3QgZ2l2aW5nIHVwIGFuZCB0ZWxsaW5nIHVzZXJzIHRoZXkgY2FuJ3QganVzdCBkaXJl
Y3RseSBpbmNsdWRlDQo+IGJvdGggbGliYyBoZWFkZXJzIGFuZCBrZXJuZWwgaGVhZGVycz8NCg0K
aW5jbHVkaW5nIGJvdGggbGliYyBhbmQgbGludXggaGVhZGVycyBpcyBmcmFnaWxlIGFuZA0Kd2ls
bCBicmVhayBkaWZmZXJlbnRseSBhY3Jvc3MgdGhlIGRpZmZlcmVudCBsaW51eA0KbGliYyBpbXBs
ZW1lbnRhdGlvbnMuDQo=
