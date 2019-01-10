From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 11/15] mips: fix n32 compat_ipc_parse_version
Date: Fri, 11 Jan 2019 00:04:09 +0100
Message-ID: <CAK8P3a1-QvHrPOupHx3sc+c6zAS9E-u8hYbt4keWzpiPgNOD-Q@mail.gmail.com>
References: <20190110162435.309262-1-arnd@arndb.de>
 <20190110162435.309262-12-arnd@arndb.de>
 <20190110193949.5wsysvchhhh2gfmu@pburton-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20190110193949.5wsysvchhhh2gfmu@pburton-laptop>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Paul Burton <paul.burton@mips.com>
Cc: "dalias@libc.org" <dalias@libc.org>, "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>, "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>, "linux@dominikbrodowski.net" <linux@dominikbrodowski.net>, "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>, "deepa.kernel@gmail.com" <deepa.kernel@gmail.com>, "hpa@zytor.com" <hpa@zytor.com>, "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "dave@stgolabs.net" <dave@stgolabs.net>, "y2038@lists.linaro.org" <y2038@lists.linaro.org>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>, "deller@gmx.de" <deller@gmx.de>, "x86@kernel.org" <x86@kernel.org>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>mi
List-Id: linux-api@vger.kernel.org

T24gVGh1LCBKYW4gMTAsIDIwMTkgYXQgODo0MCBQTSBQYXVsIEJ1cnRvbiA8cGF1bC5idXJ0b25A
bWlwcy5jb20+IHdyb3RlOgo+IE9uIFRodSwgSmFuIDEwLCAyMDE5IGF0IDA1OjI0OjMxUE0gKzAx
MDAsIEFybmQgQmVyZ21hbm4gd3JvdGU6Cj4gPiBXaGlsZSByZWFkaW5nIHRocm91Z2ggdGhlIHN5
c3ZpcGMgaW1wbGVtZW50YXRpb24sIEkgbm90aWNlZCB0aGF0IHRoZSBuMzIKPiA+IHNlbWN0bC9z
aG1jdGwvbXNnY3RsIHN5c3RlbSBjYWxscyBiZWhhdmUgZGlmZmVyZW50bHkgYmFzZWQgb24gd2hl
dGhlcgo+ID4gbzMyIHN1cHBvcnQgaXMgZW5hYmxlZCBvciBub3Q6IFdpdGhvdXQgbzMyLCB0aGUg
SVBDXzY0IGZsYWcgcGFzc2VkIGJ5Cj4gPiB1c2VyIHNwYWNlIGlzIHJlamVjdGVkIGJ1dCBjYWxs
cyB3aXRob3V0IHRoYXQgZmxhZyBnZXQgSVBDXzY0IGJlaGF2aW9yLgo+ID4KPiA+IEFzIGZhciBh
cyBJIGNhbiB0ZWxsLCB0aGlzIHdhcyBpbmFkdmVydGVudGx5IGNoYW5nZWQgYnkgYSBjbGVhbnVw
IHBhdGNoCj4gPiBidXQgbmV2ZXIgbm90aWNlZCBieSBhbnlvbmUsIHBvc3NpYmx5IG5vYm9keSBo
YXMgdHJpZWQgdXNpbmcgc3lzdmlwYwo+ID4gb24gbjMyIGFmdGVyIGxpbnV4LTMuMTkuCj4gPgo+
ID4gQ2hhbmdlIGl0IGJhY2sgdG8gdGhlIG9sZCBiZWhhdmlvciBub3cuCj4gPgo+ID4gRml4ZXM6
IDc4YWFmOTU2YmEzYSAoIk1JUFM6IENvbXBhdDogRml4IGJ1aWxkIGVycm9yIGlmIENPTkZJR19N
SVBTMzJfQ09NUEFUIGJ1dCBubyBjb21wYXQgQUJJLiIpCj4gPiBDYzogc3RhYmxlQHZnZXIua2Vy
bmVsLm9yZwo+ID4gU2lnbmVkLW9mZi1ieTogQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4K
PiA+IC0tLQo+ID4gQXMgc3RhdGVkIGFib3ZlLCB0aGlzIHdhcyBvbmx5IGZvdW5kIGJ5IGluc3Bl
Y3Rpb24sIHRoZSBwYXRjaCBpcyBub3QKPiA+IHRlc3RlZC4gUGxlYXNlIHJldmlldyBhY2NvcmRp
bmdseS4KPgo+IE5pY2UgY2F0Y2ghIFdvdWxkIHlvdSBwcmVmZXIgdG8gbWVyZ2UgdGhpcyB5b3Vy
c2VsZiwgb3IgdGhhdCBJIHRha2UgaXQKPiB0aHJvdWdoIHRoZSBtaXBzIHRyZWU/CgpVcCB0byB5
b3U6IGlmIHlvdSB3YW50IHRvIG1lcmdlIGl0IGZvciA1LjAsIEknbGwganVzdCBkcm9wIGl0IGZy
b20gbXkgdHJlZS4KCj4gSWYgdGhlIGZvcm1lciB0aGVuOgo+Cj4gICBBY2tlZC1ieTogUGF1bCBC
dXJ0b24gPHBhdWwuYnVydG9uQG1pcHMuY29tPgoKVGhhbmtzIQoKPiBJIHN1c3BlY3Qga2VybmVs
cyBjb25maWd1cmVkIHdpdGggbjMyIHN1cHBvcnQgYnV0IG5vIG8zMiBzdXBwb3J0IGFyZQo+IHBy
b2JhYmx5IG5vdCB2ZXJ5IGNvbW1vbiAtIGZvciBpbnRlcm5hbCB0ZXN0aW5nIHdlIGN1cnJlbnRs
eSBhbHdheXMKPiBlbmFibGUgYm90aC4KCkRvIHlvdSBrbm93IG9mIGFueW9uZSBhY3R1YWxseSBz
dGlsbCB1c2luZyBuMzIgaW4gcHJvZHVjdGlvbiBzeXN0ZW1zCndpdGggNC54IGtlcm5lbHM/IEkg
d29uZGVyIGlmIGl0IGp1c3QgZmVsbCBvdXQgb2YgcG9wdWxhcml0eSBhcyB0aGUgNjQtYml0Cm1h
Y2hpbmVzIHRoYXQgdXNlZCBpdCBlaXRoZXIgYmVjYW1lIGxhcmdlIGVub3VnaCB0byB3YW50IDY0
LWJpdAp1c2VyIHNwYWNlLCBvciBnb3QgcmVwbGFjZWQgYnkgYXJtNjQgb3IgbWlwczMyIGhhcmR3
YXJlLgoKICAgICAgQXJuZApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwpZMjAzOCBtYWlsaW5nIGxpc3QKWTIwMzhAbGlzdHMubGluYXJvLm9yZwpodHRwczov
L2xpc3RzLmxpbmFyby5vcmcvbWFpbG1hbi9saXN0aW5mby95MjAzOAo=
