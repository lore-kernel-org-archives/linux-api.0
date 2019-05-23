From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v1 1/2] open: add close_range()
Date: Thu, 23 May 2019 16:29:44 +0000
Message-ID: <5e57c26cb7044b69acd3846ac474b5d5@AcuMS.aculab.com>
References: <20190522155259.11174-1-christian@brauner.io>
 <67e4458a-9cc4-d1aa-608c-73ebe9e2f7a3@yandex-team.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <67e4458a-9cc4-d1aa-608c-73ebe9e2f7a3@yandex-team.ru>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Konstantin Khlebnikov' <khlebnikov@yandex-team.ru>, Christian Brauner <christian@brauner.io>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "fweimer@redhat.com" <fweimer@redhat.com>
Cc: "jannh@google.com" <jannh@google.com>, "oleg@redhat.com" <oleg@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "arnd@arndb.de" <arnd@arndb.de>, "shuah@kernel.org" <shuah@kernel.org>, "dhowells@redhat.com" <dhowells@redhat.com>, "tkjos@android.com" <tkjos@android.com>, "ldv@altlinux.org" <ldv@altlinux.org>, "miklos@szeredi.hu" <miklos@szeredi.hu>, "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>, "linux-m68k@lists.linux-m68k.org" <linux-m68k@lists.linux-m68k.org>, "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>, linuxppc-dev@lists.
List-Id: linux-api@vger.kernel.org

RnJvbTogIEtvbnN0YW50aW4gS2hsZWJuaWtvdg0KPiBTZW50OiAyMyBNYXkgMjAxOSAxNzoyMg0K
Li4uLg0KPiAgPiBJbiBhZGRpdGlvbiwgdGhlIHN5c2NhbGwgd2lsbCBhbHNvIHdvcmsgZm9yIHRh
c2tzIHRoYXQgZG8gbm90IGhhdmUgcHJvY2ZzDQo+ICA+IG1vdW50ZWQgYW5kIG9uIGtlcm5lbHMg
dGhhdCBkbyBub3QgaGF2ZSBwcm9jZnMgc3VwcG9ydCBjb21waWxlZCBpbi4gSW4gc3VjaA0KPiAg
PiBzaXR1YXRpb25zIHRoZSBvbmx5IHdheSB0byBtYWtlIHN1cmUgdGhhdCBhbGwgZmlsZSBkZXNj
cmlwdG9ycyBhcmUgY2xvc2VkDQo+ICA+IGlzIHRvIGNhbGwgY2xvc2UoKSBvbiBlYWNoIGZpbGUg
ZGVzY3JpcHRvciB1cCB0byBVSU5UX01BWCBvciBSTElNSVRfTk9GSUxFLA0KPiAgPiBPUEVOX01B
WCB0cmlja2VyeSAoY2YuIGNvbW1lbnQgWzhdIG9uIFJ1c3QpLg0KDQpDb2RlIHVzaW5nIFJMSU1J
VF9OT0ZJTEUgaXMgYnJva2VuLg0KSXQgaXMgZWFzeSB0byByZWR1Y2UgdGhlIGhhcmQgbGltaXQg
YmVsb3cgdGhhdCBvZiBhbiBvcGVuIGZkLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRy
ZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1L
MSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K
