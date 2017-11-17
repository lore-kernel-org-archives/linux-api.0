From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/9] posix_clocks: Prepare syscalls for 64 bit
 time_t conversion
Date: Fri, 17 Nov 2017 09:58:26 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1711170954000.1709@nanos>
References: <20171110224259.15930-1-deepa.kernel@gmail.com>
 <CAK8P3a2uD=xV5GKtL+nhVoPckb6uoXztEvXK-iP_OYbct8QvJA@mail.gmail.com>
 <CABeXuvpy1jbqjeUFHHX-MrJXQLA2QNYbAa6OX7qOpPp4q-mQYQ@mail.gmail.com>
 <alpine.DEB.2.20.1711160958430.2191@nanos>
 <CAK8P3a0wxs59T1zW4ahbJXeW6QjStm0mbCFoL_RQexAa6dzh_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <CAK8P3a0wxs59T1zW4ahbJXeW6QjStm0mbCFoL_RQexAa6dzh_w@mail.gmail.com>
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

T24gRnJpLCAxNyBOb3YgMjAxNywgQXJuZCBCZXJnbWFubiB3cm90ZToKPiBPbiBUaHUsIE5vdiAx
NiwgMjAxNyBhdCAxMDowNCBBTSwgVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+
IHdyb3RlOgo+ID4gT24gV2VkLCAxNSBOb3YgMjAxNywgRGVlcGEgRGluYW1hbmkgd3JvdGU6Cj4g
Pj4gV291bGQgdGhpcyB3b3JrIGZvciBldmVyeW9uZT8KPiA+Cj4gPiBIYXZpbmcgZXh0cmEgY29u
ZmlnIHN3aXRjaGVzIHdoaWNoIGFyZSBzZWxlY3RhYmxlIGJ5IGFyY2hpdGVjdHVyZXMgYW5kCj4g
PiByZW1vdmVkIHdoZW4gZXZlcnl0aGluZyBpcyBjb252ZXJ0ZWQgaXMgZGVmaW5pdGVseSB0aGUg
cmlnaHQgd2F5IHRvIGdvLgo+ID4KPiA+IFRoYXQgYWxsb3dzIHlvdSB0byBncmFkdWFsbHkgY29u
dmVydCBzdHVmZiB3L28gaW5mbGljdGluZyB3cmVja2FnZSBhbGwgb3Zlcgo+ID4gdGhlIHBsYWNl
Lgo+IAo+IFRoZSBDT05GSUdfNjRCSVRfVElNRSB3b3VsZCBkbyB0aGF0IG5pY2VseSBmb3IgdGhl
IG5ldyBzdHVmZiBsaWtlCj4gdGhlIGNvbmRpdGlvbmFsIGRlZmluaXRpb24gb2YgX19rZXJuZWxf
dGltZXNwZWMsIHRoaXMgb25lIHdvdWxkIGdldAo+IHJlbW92ZWQgYWZ0ZXIgd2UgY29udmVydCBh
bGwgYXJjaGl0ZWN0dXJlcy4KPiAKPiBBIHNlY29uZCBpc3N1ZSBpcyBob3cgdG8gY29udHJvbCB0
aGUgY29tcGlsYXRpb24gb2YgdGhlIGNvbXBhdCBzeXNjYWxscy4KPiBDT05GSUdfQ09NUEFUXzMy
QklUX1RJTUUgaGFuZGxlcyB0aGF0IGFuZCBjb3VsZCBiZSBkZWZpbmVkCj4gaW4gS2NvbmZpZyBh
cyAnZGVmX2Jvb2wgKCE2NEJJVCAmJiBDT05GSUdfNjRCSVRfVElNRSkgfHwgQ09NUEFUJywKPiB0
aGlzIGlzIHRoZW4ganVzdCBhIG1vcmUgcmVhZGFibGUgd2F5IG9mIGV4cHJlc3NpbmcgZXhhY3Rs
eSB3aGVuIHRoZQo+IGZ1bmN0aW9ucyBzaG91bGQgYmUgYnVpbHQuCj4gCj4gRm9yIGNvbXBsZXRl
bmVzcywgdGhlcmUgbWF5IGJlIGEgdGhpcmQgY2F0ZWdvcnksIGRlcGVuZGluZyBvbiBob3cKPiB3
ZSBoYW5kbGUgdGhpbmdzIGxpa2Ugc3lzX25hbm9zbGVlcCgpOiBIZXJlLCB3ZSB3YW50IHRoZSBu
YXRpdmUKPiBzeXNfbmFub3NsZWVwIG9uIDY0LWJpdCBhcmNoaXRlY3R1cmVzLCBhbmQgY29tcGF0
X3N5c19uYW5vc2xlZXAoKQo+IHRvIGhhbmRsZSB0aGUgMzItYml0IHRpbWVfdCB2YXJpYW50IG9u
IGJvdGggMzItYml0IGFuZCA2NC1iaXQgdGFyZ2V0cywKPiBidXQgb3VyIHBsYW4gaXMgdG8gbm90
IGhhdmUgYSBuYXRpdmUgMzItYml0IHN5c19uYW5vc2xlZXAgb24gMzItYml0Cj4gYXJjaGl0ZWN0
dXJlcyBhbnkgbW9yZSwgYXMgbmV3IGdsaWJjIHNob3VsZCBjYWxsIGNsb2NrX25hbm9zbGVlcCgp
Cj4gd2l0aCBhIG5ldyBzeXNjYWxsIG51bWJlciBpbnN0ZWFkLiBTaG91bGQgd2UgdGhlbiBlbmNs
b3NlCgpJc24ndCB0aGF0IGdvaW5nIHRvIGJyZWFrIGV4aXN0aW5nIHVzZXJzcGFjZT8KClRoYW5r
cwoKCXRnbHgKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
WTIwMzggbWFpbGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6Ly9saXN0cy5s
aW5hcm8ub3JnL21haWxtYW4vbGlzdGluZm8veTIwMzgK
