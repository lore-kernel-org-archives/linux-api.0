From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 14/15] arch: add split IPC system calls where
	needed
Date: Wed, 16 Jan 2019 11:09:12 +1100
Message-ID: <874la9zcnr.fsf@concordia.ellerman.id.au>
References: <20190110162435.309262-1-arnd@arndb.de>
 <20190110162435.309262-15-arnd@arndb.de>
 <87pnsz28k2.fsf@concordia.ellerman.id.au>
 <CAK8P3a0uas76i2W1yjFvxHT-2=A8_egUZeAUM-Vya6386+87Xg@mail.gmail.com>
 <CAK8P3a3eUzGDrJtV2ySpgHwjKHwZYr+1xHp6tChCt1gWi=mJ+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <CAK8P3a3eUzGDrJtV2ySpgHwjKHwZYr+1xHp6tChCt1gWi=mJ+g@mail.gmail.com>
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
Cc: Rich Felker <dalias@libc.org>, linux-ia64@vger.kernel.org, Linux-sh list <linux-sh@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-mips@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>, Deepa Dinamani <deepa.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux <sparclinux@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, y2038 Mailman List <y2038@lists.linaro.org>, Helge Deller <deller@gmx.de>, the arch/x86 maintainers <x86@kernel.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Firoz Khan <firoz.khan@linaro.org>, Matt Turner <mattst88@gmail.com>, Fenghua Yu <fenghua.yu@intel.com>, Will Deacon <will.deacon@arm.com>linux-
List-Id: linux-api@vger.kernel.org

QXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4gd3JpdGVzOgoKPiBPbiBUdWUsIEphbiAxNSwg
MjAxOSBhdCA0OjAxIFBNIEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+IHdyb3RlOgo+Pgo+
PiBPbiBNb24sIEphbiAxNCwgMjAxOSBhdCA0OjU5IEFNIE1pY2hhZWwgRWxsZXJtYW4gPG1wZUBl
bGxlcm1hbi5pZC5hdT4gd3JvdGU6Cj4+ID4gQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4g
d3JpdGVzOgo+PiA+ID4gIGFyY2gvbTY4ay9rZXJuZWwvc3lzY2FsbHMvc3lzY2FsbC50YmwgICAg
IHwgMTEgKysrKysrKysrKysKPj4gPiA+ICBhcmNoL21pcHMva2VybmVsL3N5c2NhbGxzL3N5c2Nh
bGxfbzMyLnRibCB8IDExICsrKysrKysrKysrCj4+ID4gPiAgYXJjaC9wb3dlcnBjL2tlcm5lbC9z
eXNjYWxscy9zeXNjYWxsLnRibCAgfCAxMiArKysrKysrKysrKysKPj4gPgo+PiA+IEkgaGF2ZSBz
b21lIGNoYW5nZXMgSSdkIGxpa2UgdG8gbWFrZSB0byBvdXIgc3lzY2FsbCB0YWJsZSB0aGF0IHdp
bGwKPj4gPiBjbGFzaCB3aXRoIHRoaXMuCj4+ID4KPj4gPiBJJ2xsIHRyeSBhbmQgc2VuZCB0aGVt
IHRvZGF5Lgo+Pgo+PiBPay4gQXJlIHRob3NlIGZvciA1LjAgb3IgNS4xPyBJZiB0aGV5IGFyZSBp
bnRlbmRlZCBmb3IgNS4wLCBpdCB3b3VsZCBiZQo+PiBuaWNlIGZvciBtZSB0byBoYXZlIGEgYnJh
bmNoIGJhc2VkIG9uIDUuMC1yYzEgdGhhdCBJIGNhbiBwdXQKPj4gdGhlIG90aGVyIHBhdGNoZXMg
b24gdG9wIG9mLgo+Cj4gVGhlcmUgaXMgYWxzbyBhbm90aGVyIGNoYW5nZSB0aGF0IEkgY29uc2lk
ZXJlZDoKPgo+IEF0IHRoZSBlbmQgb2YgbXkgc2VyaWVzLCB3ZSBoYXZlIGEgbG90IG9mIGVudHJp
ZXMgbGlrZQo+Cj4gMjQ1ICAgICAzMiAgICAgIGNsb2NrX3NldHRpbWUgICAgICAgICAgICAgICAg
ICAgc3lzX2Nsb2NrX3NldHRpbWUzMgo+IDI0NSAgICAgNjQgICAgICBjbG9ja19zZXR0aW1lICAg
ICAgICAgICAgICAgICAgIHN5c19jbG9ja19zZXR0aW1lCj4gMjQ1ICAgICBzcHUgICAgIGNsb2Nr
X3NldHRpbWUgICAgICAgICAgICAgICAgICAgc3lzX2Nsb2NrX3NldHRpbWUKPgo+IHdoaWNoIGNv
dWxkIGJlIGZvbGRlZCBpbnRvCj4KPiAyNDUgICAgIDMyICAgICAgY2xvY2tfc2V0dGltZSAgICAg
ICAgICAgICAgICAgICBzeXNfY2xvY2tfc2V0dGltZTMyCj4gMjQ1ICAgICBzcHU2NCBjbG9ja19z
ZXR0aW1lICAgICAgICAgICAgICAgICAgIHN5c19jbG9ja19zZXR0aW1lCj4KPiBpZiB3ZSBqdXN0
IGFkZCBhbm90aGVyIG9wdGlvbiB0byB0aGUgQUJJIGZpZWxkLiBBbnkgdGhvdWdodHMgb24KPiB0
aGF0PwoKTXkgc2VyaWVzIHNwbGl0cyBzcHUgb3V0IGludG8gYSBzZXBhcmF0ZSBmaWVsZC4gU28g
dGhlIGFib3ZlIHdvdWxkIGJlOgoKMjQ1ICAgICAzMgktCWNsb2NrX3NldHRpbWUgICAgICAgICAg
ICAgICAgICAgc3lzX2Nsb2NrX3NldHRpbWUzMgoyNDUgICAgIDY0CXNwdQljbG9ja19zZXR0aW1l
ICAgICAgICAgICAgICAgICAgIHN5c19jbG9ja19zZXR0aW1lCgpjaGVlcnMKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWTIwMzggbWFpbGluZyBsaXN0Clky
MDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6Ly9saXN0cy5saW5hcm8ub3JnL21haWxtYW4vbGlz
dGluZm8veTIwMzgK
