From: Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH 01/20] drm: use __u{32, 64} instead of uint{32,
 64}_t in virtgpu_drm.h
Date: Sun, 6 Dec 2015 07:03:51 +1000
Message-ID: <CAPM=9tw1Un5-fZUzYGzXLhVikEHj9gw1FfBDc=YMD7xeeKxS9Q@mail.gmail.com>
References: <1448892658-14256-1-git-send-email-gabriel@lse.epita.fr>
 <1448892658-14256-2-git-send-email-gabriel@lse.epita.fr>
 <CACvgo52bSiTJmze45WUSs+sW0RfcW7Uwaworb68YA54b3PvR9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <CACvgo52bSiTJmze45WUSs+sW0RfcW7Uwaworb68YA54b3PvR9Q@mail.gmail.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Emil Velikov <emil.l.velikov@gmail.com>
Cc: "open list:ABI/API" <linux-api@vger.kernel.org>, "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>, open list <linux-kernel@vger.kernel.org>, Mikko Rapeli <mikko.rapeli@iki.fi>
List-Id: linux-api@vger.kernel.org

T24gNSBEZWNlbWJlciAyMDE1IGF0IDAwOjIyLCBFbWlsIFZlbGlrb3YgPGVtaWwubC52ZWxpa292
QGdtYWlsLmNvbT4gd3JvdGU6Cj4gT24gMzAgTm92ZW1iZXIgMjAxNSBhdCAxNDoxMCwgR2Ficmll
bCBMYXNrYXIgPGdhYnJpZWxAbHNlLmVwaXRhLmZyPiB3cm90ZToKPj4gU2lnbmVkLW9mZi1ieTog
R2FicmllbCBMYXNrYXIgPGdhYnJpZWxAbHNlLmVwaXRhLmZyPgo+PiBDQzogRW1pbCBWZWxpa292
IDxlbWlsLmwudmVsaWtvdkBnbWFpbC5jb20+Cj4+IENDOiBNaWtrbyBSYXBlbGkgPG1pa2tvLnJh
cGVsaUBpa2kuZmk+Cj4+Cj4+IC0tLQo+PiAgaW5jbHVkZS91YXBpL2RybS92aXJ0Z3B1X2RybS5o
IHwgOTggKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4+ICAxIGZp
bGUgY2hhbmdlZCwgNDkgaW5zZXJ0aW9ucygrKSwgNDkgZGVsZXRpb25zKC0pCj4+Cj4gRm9yIHRo
ZSBzZXJpZXMKPiBSZXZpZXdlZC1ieTogRW1pbCBWZWxpa292IDxlbWlsLmwudmVsaWtvdkBnbWFp
bC5jb20+Cj4KPiBEYXZlIHdvdWxkIHlvdSBoYXZlIGFueSBjb21tZW50cyB3cnQgdGhpcyBhbmQg
dGhlIHJlbWFpbmRlciBvZiBNaWtrbydzCj4gc2VyaWVzID8gQWx0ZXJuYXRpdmVseSB3aGF0IGNh
biB3ZSBkbyB0byBnZXQgdGhvc2UgbWVyZ2VkICh3b3VsZCB5b3UKPiBsaWtlIGEgYnJhbmNoL3B1
bGwgcmVxdWVzdCkgPwoKWWVhaCBhIGdpdCBwdWxsIGZvciB0aGVzZSB3b3VsZCBiZSBnb29kLCBp
dCdzIGFib3V0IGFsbCBJIGNhbiBkbyB0bwpjYXJlIGFib3V0IHRoZW0uCgpEYXZlLgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGlu
ZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cDovL2xpc3RzLmZyZWVk
ZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbAo=
