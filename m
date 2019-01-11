From: Paul Burton <paul.burton@mips.com>
Subject: Re: [PATCH 11/15] mips: fix n32 compat_ipc_parse_version
Date: Fri, 11 Jan 2019 19:25:17 +0000
Message-ID: <MWHPR2201MB12776696BE1B1E8EF4A90DA1C1850@MWHPR2201MB1277.namprd22.prod.outlook.com>
References: <20190110162435.309262-12-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20190110162435.309262-12-arnd@arndb.de>
Content-Language: en-US
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
Cc: Paul Burton <pburton@wavecomp.com>, "dalias@libc.org" <dalias@libc.org>, "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>, "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "linux@dominikbrodowski.net" <linux@dominikbrodowski.net>, "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>, "deepa.kernel@gmail.com" <deepa.kernel@gmail.com>, "hpa@zytor.com" <hpa@zytor.com>, "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "dave@stgolabs.net" <dave@stgolabs.net>, "y2038@lists.linaro.org" <y2038@lists.linaro.org>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>, "deller@gmx.de" <deller@gmx.de>, "x86@kernel.org" <x86@kernel.org>"linux@armlinux.org.uk" <linu>
List-Id: linux-api@vger.kernel.org

SGVsbG8sCgpBcm5kIEJlcmdtYW5uIHdyb3RlOgo+IFdoaWxlIHJlYWRpbmcgdGhyb3VnaCB0aGUg
c3lzdmlwYyBpbXBsZW1lbnRhdGlvbiwgSSBub3RpY2VkIHRoYXQgdGhlIG4zMgo+IHNlbWN0bC9z
aG1jdGwvbXNnY3RsIHN5c3RlbSBjYWxscyBiZWhhdmUgZGlmZmVyZW50bHkgYmFzZWQgb24gd2hl
dGhlcgo+IG8zMiBzdXBwb3J0IGlzIGVuYWJsZWQgb3Igbm90OiBXaXRob3V0IG8zMiwgdGhlIElQ
Q182NCBmbGFnIHBhc3NlZCBieQo+IHVzZXIgc3BhY2UgaXMgcmVqZWN0ZWQgYnV0IGNhbGxzIHdp
dGhvdXQgdGhhdCBmbGFnIGdldCBJUENfNjQgYmVoYXZpb3IuCj4gCj4gQXMgZmFyIGFzIEkgY2Fu
IHRlbGwsIHRoaXMgd2FzIGluYWR2ZXJ0ZW50bHkgY2hhbmdlZCBieSBhIGNsZWFudXAgcGF0Y2gK
PiBidXQgbmV2ZXIgbm90aWNlZCBieSBhbnlvbmUsIHBvc3NpYmx5IG5vYm9keSBoYXMgdHJpZWQg
dXNpbmcgc3lzdmlwYwo+IG9uIG4zMiBhZnRlciBsaW51eC0zLjE5Lgo+IAo+IENoYW5nZSBpdCBi
YWNrIHRvIHRoZSBvbGQgYmVoYXZpb3Igbm93Lgo+IAo+IEZpeGVzOiA3OGFhZjk1NmJhM2EgKCJN
SVBTOiBDb21wYXQ6IEZpeCBidWlsZCBlcnJvciBpZiBDT05GSUdfTUlQUzMyX0NPTVBBVCBidXQg
bm8gY29tcGF0IEFCSS4iKQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnCj4gU2lnbmVkLW9m
Zi1ieTogQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4KCkFwcGxpZWQgdG8gbWlwcy1maXhl
cy4KClRoYW5rcywKICAgIFBhdWwKClsgVGhpcyBtZXNzYWdlIHdhcyBhdXRvLWdlbmVyYXRlZDsg
aWYgeW91IGJlbGlldmUgYW55dGhpbmcgaXMgaW5jb3JyZWN0CiAgdGhlbiBwbGVhc2UgZW1haWwg
cGF1bC5idXJ0b25AbWlwcy5jb20gdG8gcmVwb3J0IGl0LiBdCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fClkyMDM4IG1haWxpbmcgbGlzdApZMjAzOEBsaXN0
cy5saW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMubGluYXJvLm9yZy9tYWlsbWFuL2xpc3RpbmZvL3ky
MDM4Cg==
