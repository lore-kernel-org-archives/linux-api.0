From: Gabriel Laskar <gabriel@lse.epita.fr>
Subject: Re: [PATCH 01/20] drm: use __u{32,64} instead of uint{32,64}_t in
 virtgpu_drm.h
Date: Wed, 9 Dec 2015 14:56:07 +0100
Message-ID: <20151209145607.0a171a72@guiness>
References: <1448892658-14256-1-git-send-email-gabriel@lse.epita.fr>
 <1448892658-14256-2-git-send-email-gabriel@lse.epita.fr>
 <CACvgo52bSiTJmze45WUSs+sW0RfcW7Uwaworb68YA54b3PvR9Q@mail.gmail.com>
 <CAPM=9tw1Un5-fZUzYGzXLhVikEHj9gw1FfBDc=YMD7xeeKxS9Q@mail.gmail.com>
 <CACvgo504nh0-KQUMEm7D2U8cSvkFeZFhgb6Pgxkmtb1PRG6jUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <CACvgo504nh0-KQUMEm7D2U8cSvkFeZFhgb6Pgxkmtb1PRG6jUw@mail.gmail.com>
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
Cc: "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open
 list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>, Mikko Rapeli <mikko.rapeli@iki.fi>
List-Id: linux-api@vger.kernel.org

T24gTW9uLCA3IERlYyAyMDE1IDEzOjI5OjQxICswMDAwCkVtaWwgVmVsaWtvdiA8ZW1pbC5sLnZl
bGlrb3ZAZ21haWwuY29tPiB3cm90ZToKCj4gT24gNSBEZWNlbWJlciAyMDE1IGF0IDIxOjAzLCBE
YXZlIEFpcmxpZSA8YWlybGllZEBnbWFpbC5jb20+IHdyb3RlOgo+ID4gT24gNSBEZWNlbWJlciAy
MDE1IGF0IDAwOjIyLCBFbWlsIFZlbGlrb3YgPGVtaWwubC52ZWxpa292QGdtYWlsLmNvbT4gd3Jv
dGU6ICAKPiA+PiBPbiAzMCBOb3ZlbWJlciAyMDE1IGF0IDE0OjEwLCBHYWJyaWVsIExhc2thciA8
Z2FicmllbEBsc2UuZXBpdGEuZnI+IHdyb3RlOiAgCj4gPj4+IFNpZ25lZC1vZmYtYnk6IEdhYnJp
ZWwgTGFza2FyIDxnYWJyaWVsQGxzZS5lcGl0YS5mcj4KPiA+Pj4gQ0M6IEVtaWwgVmVsaWtvdiA8
ZW1pbC5sLnZlbGlrb3ZAZ21haWwuY29tPgo+ID4+PiBDQzogTWlra28gUmFwZWxpIDxtaWtrby5y
YXBlbGlAaWtpLmZpPgo+ID4+Pgo+ID4+PiAtLS0KPiA+Pj4gIGluY2x1ZGUvdWFwaS9kcm0vdmly
dGdwdV9kcm0uaCB8IDk4ICsrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0t
LQo+ID4+PiAgMSBmaWxlIGNoYW5nZWQsIDQ5IGluc2VydGlvbnMoKyksIDQ5IGRlbGV0aW9ucygt
KQo+ID4+PiAgCj4gPj4gRm9yIHRoZSBzZXJpZXMKPiA+PiBSZXZpZXdlZC1ieTogRW1pbCBWZWxp
a292IDxlbWlsLmwudmVsaWtvdkBnbWFpbC5jb20+Cj4gPj4KPiA+PiBEYXZlIHdvdWxkIHlvdSBo
YXZlIGFueSBjb21tZW50cyB3cnQgdGhpcyBhbmQgdGhlIHJlbWFpbmRlciBvZiBNaWtrbydzCj4g
Pj4gc2VyaWVzID8gQWx0ZXJuYXRpdmVseSB3aGF0IGNhbiB3ZSBkbyB0byBnZXQgdGhvc2UgbWVy
Z2VkICh3b3VsZCB5b3UKPiA+PiBsaWtlIGEgYnJhbmNoL3B1bGwgcmVxdWVzdCkgPyAgCj4gPgo+
ID4gWWVhaCBhIGdpdCBwdWxsIGZvciB0aGVzZSB3b3VsZCBiZSBnb29kLCBpdCdzIGFib3V0IGFs
bCBJIGNhbiBkbyB0bwo+ID4gY2FyZSBhYm91dCB0aGVtLgo+ID4gIAo+IEZyb20geW91ciBlYXJs
aWVyIHJlcGx5IEkgZ290IHRoZSBpbXByZXNzaW9uIHRoYXQgeW91J2xsIHBpY2sgTWlra28ncwo+
IHdvcmsuIEVpdGhlciB3YXksIGdsYWQgdG8gc2VlIHNvbWUgcHJvZ3Jlc3Mgb24gdGhlIHRvcGlj
Lgo+IAo+IE1pa2tvLCBHYWJyaWVsLAo+IAo+IFdpbGwgeW91IGd1eXMgYmUgc28ga2luZCB0byBz
ZW5kIHB1bGwgcmVxdWVzdHMgb3Igc2hhbGwgSSA/CgpJIGNhbiBzZW5kIGEgcHVsbCByZXF1ZXN0
IHdpdGggdGhlIGNoYW5nZXMgZnJvbSBtaWtrbyBhbmQgbWluZS4KCi0tIApHYWJyaWVsIExhc2th
cgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2
ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cDovL2xp
c3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbAo=
