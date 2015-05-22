From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Subject: Re: [PATCH v8 14/16] ARM: dts: Introduce STM32F429 MCU
Date: Fri, 22 May 2015 15:09:30 +0200
Message-ID: <555F2A8A.5020205@suse.de>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>	<2282066.NWoIT9ZyLc@wuerfel>	<CALszF6CaO_yuNiSDuDV+4d2NRe_+32j=zcSE1HPhB1UH59cW9w@mail.gmail.com>	<13641152.Yt4ZI3oT6L@wuerfel>	<CALszF6CK5ezrO6D=4zr6zEPC7VanzbQjnZJwKOZekEZ5L4D-Dg@mail.gmail.com>	<1432285588.3929.28.camel@pengutronix.de>	<20150522091822.GF8557@lukather>	<1432289231.3929.60.camel@pengutronix.de>
 <CALszF6CQ1_HQXJ8=vgytvVo2t4_ue5_nsE06HPyHMzSLrntqKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CALszF6CQ1_HQXJ8=vgytvVo2t4_ue5_nsE06HPyHMzSLrntqKg@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Will Deacon <will.deacon@arm.com>, Stefan Agner <stefan@agner.ch>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Peter Meerwald <pmeerw@pmeerw.net>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Linux-Arch <linux-arch@vger.kernel.org>, Daniel Thompson <daniel.thompson@linaro.org>, Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>, Jonathan Corbet <corbet@lwn.net>, Jiri Slaby <jslaby@suse.cz>, Daniel Lezcano <daniel.lezcano@linaro.org>, Nicolae Rosia <nicolae.rosia@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Antti Palosaari <crope@iki.fi>, Geert Uytterhoeven <geert@linux-m68k.>
List-Id: linux-api@vger.kernel.org

QW0gMjIuMDUuMjAxNSB1bSAxNDozMiBzY2hyaWViIE1heGltZSBDb3F1ZWxpbjoKPiAyMDE1LTA1
LTIyIDEyOjA3IEdNVCswMjowMCBQaGlsaXBwIFphYmVsIDxwLnphYmVsQHBlbmd1dHJvbml4LmRl
PjoKPj4gVGhlIFNUTTMyRjQyN3h4L1NUTTMyRjQyOXh4IG1hbnVhbCwgVGFibGUgMTMuICJTVE0z
MkY0Mjd4eCBhbmQKPj4gU1RNMzJGNDI5eHggcmVnaXN0ZXIgYm91bmRhcnkgYWRkcmVzc2VzIiBj
b250YWlucyB0aGlzIGVudHJ5Ogo+PiAgICAgQnVzICAgIEJvdW5kYXJ5IGFkZHJlc3MgICAgICAg
UGVyaXBoZXJhbAo+PiAgICAgQUhCMSAgIDB4NDAwMjM4MDAtMHg0MDAyMzhiZiAgUkNDCj4+Cj4+
IEFuZCB0aGF0J3MgaG93IEknZCBleHBlY3QgaXQgdG8gYmUgZGVzY3JpYmVkIGJ5IHRoZSBkZXZp
Y2UgdHJlZToKPj4KPj4gICAgIHJjYzogcmNjQDQwMDIzODAwIHsKPj4gICAgICAgICBjb21wYXRp
YmxlID0gInN0LHN0bTMyLXJjYyI7Cj4+ICAgICAgICAgcmVnID0gPDB4NDAwMjM4MDAgMHhjMD47
Cj4+ICAgICB9Owo+Pgo+IAo+IERvaW5nIHRoYXQsIHNpbmNlIHRoaXMgcmVnaXN0ZXIgYmFuayBj
b250YWlucyBib3RoIHJlc2V0IGFuZCBjbG9jawo+IHJlZ2lzdGVycywgdGhlIHJlc2V0IGRldmlj
ZSBjYW5ub3QgZ2V0IHRoZSBJTyByZXNvdXJjZSBhdCBwcm9iZSB0aW1lCj4gYmVjYXVzZSB0aGUg
Y2xvY2sgZHJpdmVyIGhhcyBhbHJlYWR5IHJlc2VydmVkIGl0Lgo+IERhbmllbCwgd2hvIGhhcyBz
dGFydGVkIHRvIHdvcmsgb24gdGhlIGNsb2NrIGRyaXZlciBpcyBmYWNpbmcgdGhpcyBpc3N1ZS4K
PiBUaGlzIGlzIHdoeSBJIHByb3Bvc2VkIHRoaXMgYmluZGluZyBmb3IgInJlZyIgcHJvcGVydHku
CgpBcyB5b3Ugc2hvdWxkIGtub3csIEkgZGlkIGhhdmUgYW4gUkNDIGNsayBkcml2ZXIsIGFuZCB0
aGVyZSBpcyBubyBzdWNoCmlzc3VlLiBUaGUgdHdvIGRyaXZlcnMgdXNlIGRpZmZlcmVudCBtZWNo
YW5pc21zIGZvciBpbml0aWFsaXphdGlvbi4gQW5kCkknbSBwcmV0dHkgc3VyZSB0aGF0IEkndmUg
YWxyZWFkeSByZW1hcmtlZCB0aGF0IG9uIHRoZSBsaXN0LCB0b28uCgpSZWdhcmRzLApBbmRyZWFz
CgotLSAKU1VTRSBMaW51eCBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcsIEdl
cm1hbnkKR0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgSmFuZSBTbWl0aGFyZCwgRGlsaXAgVXBtYW55
dSwgR3JhaGFtIE5vcnRvbjsgSFJCCjIxMjg0IChBRyBOw7xybmJlcmcpCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpsaW51eC1hcm0ta2VybmVsIG1haWxp
bmcgbGlzdApsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcKaHR0cDovL2xpc3Rz
LmluZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1hcm0ta2VybmVsCg==
