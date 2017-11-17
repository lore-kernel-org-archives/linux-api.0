From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/9] posix_clocks: Prepare syscalls for 64 bit
	time_t conversion
Date: Fri, 17 Nov 2017 10:31:34 +0100
Message-ID: <CAK8P3a3fcVKTwoqN0CxYchzcFqUZPBeko=oYsA9eNxu4bQoYyw@mail.gmail.com>
References: <20171110224259.15930-1-deepa.kernel@gmail.com>
 <CAK8P3a2uD=xV5GKtL+nhVoPckb6uoXztEvXK-iP_OYbct8QvJA@mail.gmail.com>
 <CABeXuvpy1jbqjeUFHHX-MrJXQLA2QNYbAa6OX7qOpPp4q-mQYQ@mail.gmail.com>
 <alpine.DEB.2.20.1711160958430.2191@nanos>
 <CAK8P3a0wxs59T1zW4ahbJXeW6QjStm0mbCFoL_RQexAa6dzh_w@mail.gmail.com>
 <alpine.DEB.2.20.1711170954000.1709@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <alpine.DEB.2.20.1711170954000.1709@nanos>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Rutland <mark.rutland@arm.com>, "open list:RALINK MIPS ARCHITECTURE" <linux-mips@linux-mips.org>, Peter Zijlstra <peterz@infradead.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Stefan Haberland <sth@linux.vnet.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Paul Mackerras <paulus@samba.org>, Deepa Dinamani <deepa.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux <sparclinux@vger.kernel.org>, devel@driverdev.osuosl.org, linux-s390 <linux-s390@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, Michael Ellerman <mpe@ellerman.id.au>, Helge Deller <deller@gmx.de>, the arch/x86 maintainers <x86@kernel.org>, sebott@linux.vnet.ibm.com, "James E.J. Bottomley" <jejb@parisc-linux.org>, Will Deacon <will.deacon@arm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Ingo Molnar <mingo@redhat.com>, oprofile-list@lists.sf.net, Catali
List-Id: linux-api@vger.kernel.org

T24gRnJpLCBOb3YgMTcsIDIwMTcgYXQgOTo1OCBBTSwgVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxp
bnV0cm9uaXguZGU+IHdyb3RlOgo+IE9uIEZyaSwgMTcgTm92IDIwMTcsIEFybmQgQmVyZ21hbm4g
d3JvdGU6Cj4+IE9uIFRodSwgTm92IDE2LCAyMDE3IGF0IDEwOjA0IEFNLCBUaG9tYXMgR2xlaXhu
ZXIgPHRnbHhAbGludXRyb25peC5kZT4gd3JvdGU6Cj4+ID4gT24gV2VkLCAxNSBOb3YgMjAxNywg
RGVlcGEgRGluYW1hbmkgd3JvdGU6Cj4+ID4+IFdvdWxkIHRoaXMgd29yayBmb3IgZXZlcnlvbmU/
Cj4+ID4KPj4gPiBIYXZpbmcgZXh0cmEgY29uZmlnIHN3aXRjaGVzIHdoaWNoIGFyZSBzZWxlY3Rh
YmxlIGJ5IGFyY2hpdGVjdHVyZXMgYW5kCj4+ID4gcmVtb3ZlZCB3aGVuIGV2ZXJ5dGhpbmcgaXMg
Y29udmVydGVkIGlzIGRlZmluaXRlbHkgdGhlIHJpZ2h0IHdheSB0byBnby4KPj4gPgo+PiA+IFRo
YXQgYWxsb3dzIHlvdSB0byBncmFkdWFsbHkgY29udmVydCBzdHVmZiB3L28gaW5mbGljdGluZyB3
cmVja2FnZSBhbGwgb3Zlcgo+PiA+IHRoZSBwbGFjZS4KPj4KPj4gVGhlIENPTkZJR182NEJJVF9U
SU1FIHdvdWxkIGRvIHRoYXQgbmljZWx5IGZvciB0aGUgbmV3IHN0dWZmIGxpa2UKPj4gdGhlIGNv
bmRpdGlvbmFsIGRlZmluaXRpb24gb2YgX19rZXJuZWxfdGltZXNwZWMsIHRoaXMgb25lIHdvdWxk
IGdldAo+PiByZW1vdmVkIGFmdGVyIHdlIGNvbnZlcnQgYWxsIGFyY2hpdGVjdHVyZXMuCj4+Cj4+
IEEgc2Vjb25kIGlzc3VlIGlzIGhvdyB0byBjb250cm9sIHRoZSBjb21waWxhdGlvbiBvZiB0aGUg
Y29tcGF0IHN5c2NhbGxzLgo+PiBDT05GSUdfQ09NUEFUXzMyQklUX1RJTUUgaGFuZGxlcyB0aGF0
IGFuZCBjb3VsZCBiZSBkZWZpbmVkCj4+IGluIEtjb25maWcgYXMgJ2RlZl9ib29sICghNjRCSVQg
JiYgQ09ORklHXzY0QklUX1RJTUUpIHx8IENPTVBBVCcsCj4+IHRoaXMgaXMgdGhlbiBqdXN0IGEg
bW9yZSByZWFkYWJsZSB3YXkgb2YgZXhwcmVzc2luZyBleGFjdGx5IHdoZW4gdGhlCj4+IGZ1bmN0
aW9ucyBzaG91bGQgYmUgYnVpbHQuCj4+Cj4+IEZvciBjb21wbGV0ZW5lc3MsIHRoZXJlIG1heSBi
ZSBhIHRoaXJkIGNhdGVnb3J5LCBkZXBlbmRpbmcgb24gaG93Cj4+IHdlIGhhbmRsZSB0aGluZ3Mg
bGlrZSBzeXNfbmFub3NsZWVwKCk6IEhlcmUsIHdlIHdhbnQgdGhlIG5hdGl2ZQo+PiBzeXNfbmFu
b3NsZWVwIG9uIDY0LWJpdCBhcmNoaXRlY3R1cmVzLCBhbmQgY29tcGF0X3N5c19uYW5vc2xlZXAo
KQo+PiB0byBoYW5kbGUgdGhlIDMyLWJpdCB0aW1lX3QgdmFyaWFudCBvbiBib3RoIDMyLWJpdCBh
bmQgNjQtYml0IHRhcmdldHMsCj4+IGJ1dCBvdXIgcGxhbiBpcyB0byBub3QgaGF2ZSBhIG5hdGl2
ZSAzMi1iaXQgc3lzX25hbm9zbGVlcCBvbiAzMi1iaXQKPj4gYXJjaGl0ZWN0dXJlcyBhbnkgbW9y
ZSwgYXMgbmV3IGdsaWJjIHNob3VsZCBjYWxsIGNsb2NrX25hbm9zbGVlcCgpCj4+IHdpdGggYSBu
ZXcgc3lzY2FsbCBudW1iZXIgaW5zdGVhZC4gU2hvdWxkIHdlIHRoZW4gZW5jbG9zZQo+Cj4gSXNu
J3QgdGhhdCBnb2luZyB0byBicmVhayBleGlzdGluZyB1c2Vyc3BhY2U/CgpObywgc3lzY2FsbCB0
aGF0IGV4aXN0aW5nIDMyLWJpdCB1c2VyIHNwYWNlIGVudGVycyB3b3VsZCBiZSBoYW5kbGVkIGJ5
CmNvbXBhdF9zeXNfbmFub3NsZWVwKCkgb24gYm90aCAzMi1iaXQgYW5kIDY0LWJpdCBrZXJuZWxz
IGF0IHRoYXQKcG9pbnQuIFRoZSBpZGVhIGhlcmUgaXMgdG8gbWFrZSB0aGUgY29kZSBwYXRoIG1v
cmUgdW5pZm9ybSBiZXR3ZWVuCjMyLWJpdCBhbmQgNjQtYml0IGtlcm5lbHMuCgogICAgICBBcm5k
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClkyMDM4IG1h
aWxpbmcgbGlzdApZMjAzOEBsaXN0cy5saW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMubGluYXJvLm9y
Zy9tYWlsbWFuL2xpc3RpbmZvL3kyMDM4Cg==
