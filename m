From: Paul Burton <paul.burton@mips.com>
Subject: Re: [PATCH 11/15] mips: fix n32 compat_ipc_parse_version
Date: Thu, 10 Jan 2019 19:39:50 +0000
Message-ID: <20190110193949.5wsysvchhhh2gfmu@pburton-laptop>
References: <20190110162435.309262-1-arnd@arndb.de>
 <20190110162435.309262-12-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20190110162435.309262-12-arnd@arndb.de>
Content-Language: en-US
Content-ID: <84563C58F4996247B8C9CD40953EB594@namprd22.prod.outlook.com>
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
Cc: "dalias@libc.org" <dalias@libc.org>, "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>, "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>, "linux@dominikbrodowski.net" <linux@dominikbrodowski.net>, "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>, "deepa.kernel@gmail.com" <deepa.kernel@gmail.com>, "hpa@zytor.com" <hpa@zytor.com>, "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "dave@stgolabs.net" <dave@stgolabs.net>, "y2038@lists.linaro.org" <y2038@lists.linaro.org>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>, "deller@gmx.de" <deller@gmx.de>, "x86@kernel.org" <x86@kernel.org>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>mi
List-Id: linux-api@vger.kernel.org

SGkgQXJuZCwKCk9uIFRodSwgSmFuIDEwLCAyMDE5IGF0IDA1OjI0OjMxUE0gKzAxMDAsIEFybmQg
QmVyZ21hbm4gd3JvdGU6Cj4gV2hpbGUgcmVhZGluZyB0aHJvdWdoIHRoZSBzeXN2aXBjIGltcGxl
bWVudGF0aW9uLCBJIG5vdGljZWQgdGhhdCB0aGUgbjMyCj4gc2VtY3RsL3NobWN0bC9tc2djdGwg
c3lzdGVtIGNhbGxzIGJlaGF2ZSBkaWZmZXJlbnRseSBiYXNlZCBvbiB3aGV0aGVyCj4gbzMyIHN1
cHBvcnQgaXMgZW5hYmxlZCBvciBub3Q6IFdpdGhvdXQgbzMyLCB0aGUgSVBDXzY0IGZsYWcgcGFz
c2VkIGJ5Cj4gdXNlciBzcGFjZSBpcyByZWplY3RlZCBidXQgY2FsbHMgd2l0aG91dCB0aGF0IGZs
YWcgZ2V0IElQQ182NCBiZWhhdmlvci4KPiAKPiBBcyBmYXIgYXMgSSBjYW4gdGVsbCwgdGhpcyB3
YXMgaW5hZHZlcnRlbnRseSBjaGFuZ2VkIGJ5IGEgY2xlYW51cCBwYXRjaAo+IGJ1dCBuZXZlciBu
b3RpY2VkIGJ5IGFueW9uZSwgcG9zc2libHkgbm9ib2R5IGhhcyB0cmllZCB1c2luZyBzeXN2aXBj
Cj4gb24gbjMyIGFmdGVyIGxpbnV4LTMuMTkuCj4gCj4gQ2hhbmdlIGl0IGJhY2sgdG8gdGhlIG9s
ZCBiZWhhdmlvciBub3cuCj4gCj4gRml4ZXM6IDc4YWFmOTU2YmEzYSAoIk1JUFM6IENvbXBhdDog
Rml4IGJ1aWxkIGVycm9yIGlmIENPTkZJR19NSVBTMzJfQ09NUEFUIGJ1dCBubyBjb21wYXQgQUJJ
LiIpCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKPiBTaWduZWQtb2ZmLWJ5OiBBcm5kIEJl
cmdtYW5uIDxhcm5kQGFybmRiLmRlPgo+IC0tLQo+IEFzIHN0YXRlZCBhYm92ZSwgdGhpcyB3YXMg
b25seSBmb3VuZCBieSBpbnNwZWN0aW9uLCB0aGUgcGF0Y2ggaXMgbm90Cj4gdGVzdGVkLiBQbGVh
c2UgcmV2aWV3IGFjY29yZGluZ2x5LgoKTmljZSBjYXRjaCEgV291bGQgeW91IHByZWZlciB0byBt
ZXJnZSB0aGlzIHlvdXJzZWxmLCBvciB0aGF0IEkgdGFrZSBpdAp0aHJvdWdoIHRoZSBtaXBzIHRy
ZWU/CgpJZiB0aGUgZm9ybWVyIHRoZW46CgogIEFja2VkLWJ5OiBQYXVsIEJ1cnRvbiA8cGF1bC5i
dXJ0b25AbWlwcy5jb20+CgpJIHN1c3BlY3Qga2VybmVscyBjb25maWd1cmVkIHdpdGggbjMyIHN1
cHBvcnQgYnV0IG5vIG8zMiBzdXBwb3J0IGFyZQpwcm9iYWJseSBub3QgdmVyeSBjb21tb24gLSBm
b3IgaW50ZXJuYWwgdGVzdGluZyB3ZSBjdXJyZW50bHkgYWx3YXlzCmVuYWJsZSBib3RoLgoKVGhh
bmtzLAogICAgUGF1bAoKPiAtLS0KPiAgYXJjaC9taXBzL0tjb25maWcgfCAxICsKPiAgMSBmaWxl
IGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspCj4gCj4gZGlmZiAtLWdpdCBhL2FyY2gvbWlwcy9LY29u
ZmlnIGIvYXJjaC9taXBzL0tjb25maWcKPiBpbmRleCA3ODcyOTA3ODFiOGMuLjBkMTRmNTFkMDAw
MiAxMDA2NDQKPiAtLS0gYS9hcmNoL21pcHMvS2NvbmZpZwo+ICsrKyBiL2FyY2gvbWlwcy9LY29u
ZmlnCj4gQEAgLTMxNTUsNiArMzE1NSw3IEBAIGNvbmZpZyBNSVBTMzJfTzMyCj4gIGNvbmZpZyBN
SVBTMzJfTjMyCj4gIAlib29sICJLZXJuZWwgc3VwcG9ydCBmb3IgbjMyIGJpbmFyaWVzIgo+ICAJ
ZGVwZW5kcyBvbiA2NEJJVAo+ICsJc2VsZWN0IEFSQ0hfV0FOVF9DT01QQVRfSVBDX1BBUlNFX1ZF
UlNJT04KPiAgCXNlbGVjdCBDT01QQVQKPiAgCXNlbGVjdCBNSVBTMzJfQ09NUEFUCj4gIAlzZWxl
Y3QgU1lTVklQQ19DT01QQVQgaWYgU1lTVklQQwo+IC0tIAo+IDIuMjAuMAo+IApfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpZMjAzOCBtYWlsaW5nIGxpc3QK
WTIwMzhAbGlzdHMubGluYXJvLm9yZwpodHRwczovL2xpc3RzLmxpbmFyby5vcmcvbWFpbG1hbi9s
aXN0aW5mby95MjAzOAo=
