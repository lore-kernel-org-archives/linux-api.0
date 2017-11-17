From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/9] posix_clocks: Prepare syscalls for 64 bit
 time_t conversion
Date: Fri, 17 Nov 2017 11:40:48 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1711171138510.7700@nanos>
References: <20171110224259.15930-1-deepa.kernel@gmail.com>
 <CAK8P3a2uD=xV5GKtL+nhVoPckb6uoXztEvXK-iP_OYbct8QvJA@mail.gmail.com>
 <CABeXuvpy1jbqjeUFHHX-MrJXQLA2QNYbAa6OX7qOpPp4q-mQYQ@mail.gmail.com>
 <alpine.DEB.2.20.1711160958430.2191@nanos>
 <CAK8P3a0wxs59T1zW4ahbJXeW6QjStm0mbCFoL_RQexAa6dzh_w@mail.gmail.com>
 <alpine.DEB.2.20.1711170954000.1709@nanos>
 <CAK8P3a3fcVKTwoqN0CxYchzcFqUZPBeko=oYsA9eNxu4bQoYyw@mail.gmail.com>
 <alpine.DEB.2.20.1711171049180.1709@nanos>
 <CAK8P3a10N42rBO8XBrZWYOCwVB8jayjgZu2oa8FSpHTzszQacQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <CAK8P3a10N42rBO8XBrZWYOCwVB8jayjgZu2oa8FSpHTzszQacQ@mail.gmail.com>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Rutland <mark.rutland@arm.com>, "open list:RALINK MIPS ARCHITECTURE" <linux-mips@linux-mips.org>, Peter Zijlstra <peterz@infradead.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Stefan Haberland <sth@linux.vnet.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Paul Mackerras <paulus@samba.org>, Deepa Dinamani <deepa.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux <sparclinux@vger.kernel.org>, devel@driverdev.osuosl.org, linux-s390 <linux-s390@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, Michael Ellerman <mpe@ellerman.id.au>, Helge Deller <deller@gmx.de>, the arch/x86 maintainers <x86@kernel.org>, sebott@linux.vnet.ibm.com, "James E.J. Bottomley" <jejb@parisc-linux.org>, Will Deacon <will.deacon@arm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Ingo Molnar <mingo@redhat.com>, oprofile-list@lists.sf.net, Catali
List-Id: linux-api@vger.kernel.org

T24gRnJpLCAxNyBOb3YgMjAxNywgQXJuZCBCZXJnbWFubiB3cm90ZToKPiBPbiBGcmksIE5vdiAx
NywgMjAxNyBhdCAxMDo1NCBBTSwgVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+
IHdyb3RlOgo+ID4gT24gRnJpLCAxNyBOb3YgMjAxNywgQXJuZCBCZXJnbWFubiB3cm90ZToKPiA+
PiBPbiBGcmksIE5vdiAxNywgMjAxNyBhdCA5OjU4IEFNLCBUaG9tYXMgR2xlaXhuZXIgPHRnbHhA
bGludXRyb25peC5kZT4gd3JvdGU6Cj4gPj4KPiA+PiBObywgc3lzY2FsbCB0aGF0IGV4aXN0aW5n
IDMyLWJpdCB1c2VyIHNwYWNlIGVudGVycyB3b3VsZCBiZSBoYW5kbGVkIGJ5Cj4gPj4gY29tcGF0
X3N5c19uYW5vc2xlZXAoKSBvbiBib3RoIDMyLWJpdCBhbmQgNjQtYml0IGtlcm5lbHMgYXQgdGhh
dAo+ID4+IHBvaW50LiBUaGUgaWRlYSBoZXJlIGlzIHRvIG1ha2UgdGhlIGNvZGUgcGF0aCBtb3Jl
IHVuaWZvcm0gYmV0d2Vlbgo+ID4+IDMyLWJpdCBhbmQgNjQtYml0IGtlcm5lbHMuCj4gPgo+ID4g
U28gb24gYSAzMmJpdCBzeXN0ZW0gY29tcGF0X3N5c19uYW5vc2xlZXAoKSB3b3VsZCBiZSB0aGUg
bGVnYWN5Cj4gPiBzeXNfbmFub3NsZWVwKCkgd2l0aCB0aGUgZXhpc3Rpbmcgc3lzY2FsbCBudW1i
ZXIsIGJ1dCB5b3UgZG9uJ3Qgd2FudCB0bwo+ID4gaW50cm9kdWNlIGEgbmV3IHN5c19uYW5vc2xl
ZXA2NCgpIGZvciAzMmJpdC4gVGhhdCBtYWtlcyBhIGxvdCBvZiBzZW5zZS4KPiA+Cj4gPiBTbyBi
YWNrIHRvIHlvdXIgb3JpZ2luYWwgcXVlc3Rpb24gd2hldGhlciB0byB1c2UgI2lmIChNQUdJQyBs
b2dpYykgb3IgYQo+ID4gc2VwYXJhdGUgY29uZmlnIHN5bWJvbC4gUGxlYXNlIHVzZSB0aGUgbGF0
dGVyLCB0aGVzZSBtYWdpYyBsb2dpYyBjb25zdHJ1Y3RzCj4gPiBhcmUgaGFyZGVyIHRvIHJlYWQg
YW5kIHByb25lIHRvIGdldCB3cm9uZyBhdCBzb21lIHBvaW50LiBIYXZpbmcgdGhlCj4gPiBkZWNp
c2lvbiBsb2dpYyBpbiBvbmUgcGxhY2UgaXMgYWx3YXlzIHRoZSByaWdodCB0aGluZyB0byBkby4K
PiAKPiBIb3cgYWJvdXQgdGhpczoKPiAKPiBjb25maWcgTEVHQUNZX1RJTUVfU1lTQ0FMTFMKPiAg
ICAgICBkZWZfYm9vbCA2NEJJVCB8fCAhNjRCSVRfVElNRQo+ICAgICAgIGhlbHAKPiAgICAgICAg
IFRoaXMgY29udHJvbHMgdGhlIGNvbXBpbGF0aW9uIG9mIHRoZSBmb2xsb3dpbmcgc3lzdGVtIGNh
bGxzOgo+IHRpbWUsIHN0aW1lLAo+ICAgICAgICAgZ2V0dGltZW9mZGF5LCBzZXR0aW1lb2ZkYXks
IGFkanRpbWV4LCBuYW5vc2xlZXAsIGFsYXJtLCBnZXRpdGltZXIsCj4gICAgICAgICBzZXRpdGlt
ZXIsIHNlbGVjdCwgdXRpbWUsIHV0aW1lcywgZnV0aW1lc2F0LCBhbmQKPiB7b2xkLG5ld317bCxm
LH1zdGF0eyw2NH0uCj4gICAgICAgICBUaGVzZSBhbGwgcGFzcyAzMi1iaXQgdGltZV90IGFyZ3Vt
ZW50cyBvbiAzMi1iaXQgYXJjaGl0ZWN0dXJlcyBhbmQKPiAgICAgICAgIGFyZSByZXBsYWNlZCBi
eSBvdGhlciBpbnRlcmZhY2VzIChlLmcuIHBvc2l4IHRpbWVycyBhbmQgY2xvY2tzLCBzdGF0eCku
Cj4gICAgICAgICBDIGxpYnJhcmllcyBpbXBsZW1lbnRpbmcgNjQtYml0IHRpbWVfdCBpbiAzMi1i
aXQgYXJjaGl0ZWN0dXJlcyBoYXZlIHRvCj4gICAgICAgICBpbXBsZW1lbnQgdGhlIGhhbmRsZXMg
Ynkgd3JhcHBpbmcgYXJvdW5kIHRoZSBuZXdlciBpbnRlcmZhY2VzLgoKcy9oYW5kbGVzL2hhbmRs
aW5nLyA/Pz8/Cgo+ICAgICAgICAgTmV3IGFyY2hpdGVjdHVyZXMgc2hvdWxkIG5vdCBleHBsaWNp
dGx5IGRpc2FibGUgdGhpcy4KCk5ldyBhcmNoaXRlY3R1cmVzIHNob3VsZCBuZXZlciBlbmFibGUg
dGhpcywgcmlnaHQ/CgpUaGFua3MsCgoJdGdseApfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwpZMjAzOCBtYWlsaW5nIGxpc3QKWTIwMzhAbGlzdHMubGluYXJv
Lm9yZwpodHRwczovL2xpc3RzLmxpbmFyby5vcmcvbWFpbG1hbi9saXN0aW5mby95MjAzOAo=
