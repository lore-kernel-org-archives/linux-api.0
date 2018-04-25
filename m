From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 04/17] asm-generic: Remove unneeded
	__ARCH_WANT_SYS_LLSEEK macro
Date: Wed, 25 Apr 2018 20:36:43 +0200
Message-ID: <CAMuHMdXzNwNxbrcbJxdh+ON5MU7Wp2OPYriHq9mk3eViXOWaOg@mail.gmail.com>
References: <20180425160311.2718314-1-arnd@arndb.de>
 <20180425160311.2718314-5-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20180425160311.2718314-5-arnd@arndb.de>
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
Cc: Linux-Arch <linux-arch@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, libc-alpha <libc-alpha@sourceware.org>, y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, "Albert ARIBAUD (3ADEV)" <albert.aribaud@3adev.fr>, Peter Zijlstra <peterz@infradead.org>, Deepa Dinamani <deepa.kernel@gmail.com>, netdev <netdev@vger.kernel.org>, Darren Hart <dvhart@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

T24gV2VkLCBBcHIgMjUsIDIwMTggYXQgNjowMiBQTSwgQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5k
Yi5kZT4gd3JvdGU6Cj4gVGhlIHN5c19sbHNlZWsgc3l0ZW0gY2FsbCBpcyBuZWVkZWQgb24gYWxs
IDMyLWJpdCBhcmNoaXRlY3R1cmVzIGFuZAo+IG5vbmUgb2YgdGhlIDY0LWJpdCBvbmVzLCBzbyB3
ZSBjYW4gcmVtb3ZlIHRoZSBfX0FSQ0hfV0FOVF9TWVNfTExTRUVLIGd1YXJkCj4gYW5kIHNpbXBs
aWZ5IHRoZSBpbmNsdWRlL2FzbS1nZW5lcmljL3VuaXN0ZC5oIGhlYWRlciBmdXJ0aGVyLgo+Cj4g
U2luY2UgMzItYml0IHRhc2tzIGNhbiBydW4gZWl0aGVyIG5hdGl2ZWx5IG9yIGluIGNvbXBhdCBt
b2RlIG9uIDY0LWJpdAo+IGFyY2hpdGVjdHVyZXMsIHdlIGhhdmUgdG8gY2hlY2sgZm9yIGJvdGgg
IUNPTkZJR182NEJJVCBhbmQgQ09ORklHX0NPTVBBVC4KPgo+IFRoZXJlIGFyZSBhIGZldyA2NC1i
aXQgYXJjaGl0ZWN0dXJlcyB0aGF0IGFsc28gcmVmZXJlbmNlIHN5c19sbHNlZWsKPiBpbiB0aGVp
ciA2NC1iaXQgQUJJIChlLmcuIHNwYXJjKSwgYnV0IEkgdmVyaWZpZWQgdGhhdCB0aG9zZSBhbGwK
PiBzZWxlY3QgQ09ORklHX0NPTVBBVCwgc28gdGhlICNpZiBjaGVjayBpcyBzdGlsbCBjb3JyZWN0
IGhlcmUuIEl0J3MKPiBhIGJpdCBvZGQgdG8gaW5jbHVkZSBpdCBpbiB0aGUgc3lzY2FsbCB0YWJs
ZSB0aG91Z2gsIGFzIGl0J3MgdGhlCj4gc2FtZSBhcyBzeXNfbHNlZWsoKSBvbiA2NC1iaXQsIGJ1
dCB3aXRoIHN0cmFuZ2UgY2FsbGluZyBjb252ZW50aW9ucy4KPgo+IFNpZ25lZC1vZmYtYnk6IEFy
bmQgQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+CgpGb3IgbTY4azoKQWNrZWQtYnk6IEdlZXJ0IFV5
dHRlcmhvZXZlbiA8Z2VlcnRAbGludXgtbTY4ay5vcmc+CgpHcntvZXRqZSxlZXRpbmd9cywKCiAg
ICAgICAgICAgICAgICAgICAgICAgIEdlZXJ0CgotLSAKR2VlcnQgVXl0dGVyaG9ldmVuIC0tIFRo
ZXJlJ3MgbG90cyBvZiBMaW51eCBiZXlvbmQgaWEzMiAtLSBnZWVydEBsaW51eC1tNjhrLm9yZwoK
SW4gcGVyc29uYWwgY29udmVyc2F0aW9ucyB3aXRoIHRlY2huaWNhbCBwZW9wbGUsIEkgY2FsbCBt
eXNlbGYgYSBoYWNrZXIuIEJ1dAp3aGVuIEknbSB0YWxraW5nIHRvIGpvdXJuYWxpc3RzIEkganVz
dCBzYXkgInByb2dyYW1tZXIiIG9yIHNvbWV0aGluZyBsaWtlIHRoYXQuCiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgLS0gTGludXMgVG9ydmFsZHMKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KWTIwMzggbWFpbGluZyBsaXN0ClkyMDM4QGxpc3Rz
LmxpbmFyby5vcmcKaHR0cHM6Ly9saXN0cy5saW5hcm8ub3JnL21haWxtYW4vbGlzdGluZm8veTIw
MzgK
