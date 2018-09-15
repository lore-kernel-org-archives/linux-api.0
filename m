From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 4/5] pselect6: use __kernel_timespec
Date: Sat, 15 Sep 2018 20:42:01 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1809152039440.1650@nanos.tec.linutronix.de>
References: <20180915050843.19183-1-deepa.kernel@gmail.com>
 <20180915050843.19183-5-deepa.kernel@gmail.com>
 <CAK8P3a2Kkm2ubg_MVN_BJL=s7qpUB1-np=9zVpcJ2U-aPAJswg@mail.gmail.com>
 <CABeXuvoOEW9+5BPiDN+2S1boyMSg+csvSAd4ue03TB+yEO6dLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <CABeXuvoOEW9+5BPiDN+2S1boyMSg+csvSAd4ue03TB+yEO6dLg@mail.gmail.com>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: linux-aio <linux-aio@kvack.org>, Arnd Bergmann <arnd@arndb.de>, y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

T24gU2F0LCAxNSBTZXAgMjAxOCwgRGVlcGEgRGluYW1hbmkgd3JvdGU6Cgo+IE9uIFNhdCwgU2Vw
IDE1LCAyMDE4IGF0IDg6MjggQU0gQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4gd3JvdGU6
Cj4gPgo+ID4gT24gU2F0LCBTZXAgMTUsIDIwMTggYXQgNzowOSBBTSBEZWVwYSBEaW5hbWFuaSA8
ZGVlcGEua2VybmVsQGdtYWlsLmNvbT4gd3JvdGU6Cj4gPgo+ID4gPiArI2lmIGRlZmluZWQoQ09O
RklHXzY0QklUX1RJTUUpCj4gPiA+ICsKPiA+ID4gK0NPTVBBVF9TWVNDQUxMX0RFRklORTYocHNl
bGVjdDZfdGltZTY0LCBpbnQsIG4sIGNvbXBhdF91bG9uZ190IF9fdXNlciAqLCBpbnAsCj4gPiA+
ICsgICAgICAgY29tcGF0X3Vsb25nX3QgX191c2VyICosIG91dHAsIGNvbXBhdF91bG9uZ190IF9f
dXNlciAqLCBleHAsCj4gPiA+ICsgICAgICAgc3RydWN0IF9fa2VybmVsX3RpbWVzcGVjIF9fdXNl
ciAqLCB0c3AsIHZvaWQgX191c2VyICosIHNpZykKPiA+Cj4gPiBJIGdvdCBhIGxpbmsgZXJyb3Ig
aGVyZSBzaW5jZSBjb21wYXRfc3lzX3BzZWxlY3Q2X3RpbWU2NCBhbmQKPiA+IGNvbXBhdF9zeXNf
cHBvbGxfdGltZTY0IGFyZSBvbmx5IGRlZmluZWQgd2hlbiBDT05GSUdfNjRCSVRfVElNRQo+ID4g
aXMgc2V0Lgo+ID4KPiA+IEkgZGlkIG5vdCB0aGluayB3ZSB3b3VsZCBzZWxlY3QgdGhpcyBzeW1i
b2wgb24gYXJtNjQsIGlzIHRoYXQgYSBtaXN0YWtlCj4gPiBvbiBteSBzaWRlLCBvciBzaG91bGQg
dGhlICNpZmRlZiBjaGVjayBiZSByZW1vdmVkPwo+IAo+IEJ1dCwgdGhpcyBpcyBhIGNvbXBhdCBz
eXNjYWxsLgo+IFdoZW4gd2UgaW50cm9kdWNlZCB0aGlzIENPTkZJR182NEJJVF9USU1FIHdlIHBs
YW5uZWQgdG8gdXNlIGl0IGZvcgo+IGNvbXBhdCBzeXNjYWxscyBhbHNvIGlzIG15IHVuZGVyc3Rh
bmRpbmcuCj4gCj4gY29uZmlnIDY0QklUX1RJTUUKPiAgICAgICAgICBkZWZfYm9vbCBBUkNIX0hB
U182NEJJVF9USU1FCj4gICAgICAgICAgaGVscAo+ICAgICAgICAgICBUaGlzIHNob3VsZCBiZSBz
ZWxlY3RlZCBieSBhbGwgYXJjaGl0ZWN0dXJlcyB0aGF0IG5lZWQgdG8gc3VwcG9ydAo+ICAgICAg
ICAgICAgbmV3IHN5c3RlbSBjYWxscyB3aXRoIGEgNjQtYml0IHRpbWVfdC4gVGhpcyBpcyByZWxl
dmFudCBvbiBhbGwgMzItYml0Cj4gICAgICAgICAgICBhcmNoaXRlY3R1cmVzLCBhbmQgNjQtYml0
IGFyY2hpdGVjdHVyZXMgYXMgcGFydCBvZiBjb21wYXQgc3lzY2FsbAo+ICAgICAgICAgICAgaGFu
ZGxpbmcuCj4gCj4gVGhpcyBtZWFucyBpdCBzaG91bGQgYmUgc2V0IG9uIDY0IGJpdCBhcmNoaXRl
Y2h0dXJlcyBhbHNvIHJpZ2h0PwoKSXQncyBvbmx5IHNldCB3aGVuIDMyYml0IGNvbXBhdCBtb2Rl
IGlzIGVuYWJsZWQgb24gdGhlIDY0Yml0IGtlcm5lbC4KClRoYW5rcywKCgl0Z2x4Cl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClkyMDM4IG1haWxpbmcgbGlz
dApZMjAzOEBsaXN0cy5saW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMubGluYXJvLm9yZy9tYWlsbWFu
L2xpc3RpbmZvL3kyMDM4Cg==
