From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 02/17] y2038: Remove newstat family from default
	syscall set
Date: Wed, 25 Apr 2018 20:36:15 +0200
Message-ID: <CAMuHMdVThd7nV=EsSSZ1puC6b8V85pWHDSGvJpLaeeafo-vRaw@mail.gmail.com>
References: <20180425160311.2718314-1-arnd@arndb.de>
 <20180425160311.2718314-3-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20180425160311.2718314-3-arnd@arndb.de>
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
Yi5kZT4gd3JvdGU6Cj4gV2UgaGF2ZSBmb3VyIGdlbmVyYXRpb25zIG9mIHN0YXQoKSBzeXNjYWxs
czoKPiAtIHRoZSBvbGRzdGF0IHN5c2NhbGxzIHRoYXQgYXJlIG9ubHkgdXNlZCBvbiB0aGUgb2xk
ZXIgYXJjaGl0ZWN0dXJlcwo+IC0gdGhlIG5ld3N0YXQgZmFtaWx5IHRoYXQgaXMgdXNlZCBvbiBh
bGwgNjQtYml0IGFyY2hpdGVjdHVyZXMgYnV0Cj4gICBsYWNrZWQgc3VwcG9ydCBmb3IgbGFyZ2Ug
ZmlsZXMgb24gMzItYml0IGFyY2hpdGVjdHVyZXMuCj4gLSB0aGUgc3RhdDY0IGZhbWlseSB0aGF0
IGlzIHVzZWQgbW9zdGx5IG9uIDMyLWJpdCBhcmNoaXRlY3R1cmVzIHRvCj4gICByZXBsYWNlIG5l
d3N0YXQKPiAtIHN0YXR4KCkgdG8gcmVwbGFjZSBhbGwgb2YgdGhlIGFib3ZlLCBhZGRpbmcgNjQt
Yml0IHRpbWVzdGFtcHMgYW1vbmcKPiAgIG90aGVyIHRoaW5ncy4KPgo+IFdlIGFscmVhZHkgY29t
cGlsZSBzdGF0NjQgb25seSBvbiB0aG9zZSBhcmNoaXRlY3R1cmVzIHRoYXQgbmVlZCBpdCwKPiBi
dXQgbmV3c3RhdCBpcyBhbHdheXMgYnVpbHQsIGluY2x1ZGluZyBvbiB0aG9zZSB0aGF0IGRvbid0
IHJlZmVyZW5jZQo+IGl0LiBUaGlzIGFkZHMgYSBuZXcgX19BUkNIX1dBTlRfTkVXX1NUQVQgc3lt
Ym9sIGFsb25nIHRoZSBsaW5lcyBvZgo+IF9fQVJDSF9XQU5UX09MRF9TVEFUIGFuZCBfX0FSQ0hf
V0FOVF9TVEFUNjQgdG8gY29udHJvbCBjb21waWxhdGlvbiBvZgo+IG5ld3N0YXQuIEFsbCBhcmNo
aXRlY3R1cmVzIHRoYXQgbmVlZCBpdCB1c2UgYW4gZXhwbGljdCBkZWZpbmUsIHRoZQo+IG90aGVy
cyBub3cgZ2V0IGEgbGl0dGxlIGJpdCBzbWFsbGVyLCBhbmQgZnV0dXJlIGFyY2hpdGVjdHVyZSAo
aW5jbHVkaW5nCj4gNjQtYml0IHRhcmdldHMpIHdvbid0IGV2ZXIgc2VlIGl0Lgo+Cj4gU2lnbmVk
LW9mZi1ieTogQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4KCkZvciBtNjhrOgpBY2tlZC1i
eTogR2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydEBsaW51eC1tNjhrLm9yZz4KCkdye29ldGplLGVl
dGluZ31zLAoKICAgICAgICAgICAgICAgICAgICAgICAgR2VlcnQKCi0tIApHZWVydCBVeXR0ZXJo
b2V2ZW4gLS0gVGhlcmUncyBsb3RzIG9mIExpbnV4IGJleW9uZCBpYTMyIC0tIGdlZXJ0QGxpbnV4
LW02OGsub3JnCgpJbiBwZXJzb25hbCBjb252ZXJzYXRpb25zIHdpdGggdGVjaG5pY2FsIHBlb3Bs
ZSwgSSBjYWxsIG15c2VsZiBhIGhhY2tlci4gQnV0CndoZW4gSSdtIHRhbGtpbmcgdG8gam91cm5h
bGlzdHMgSSBqdXN0IHNheSAicHJvZ3JhbW1lciIgb3Igc29tZXRoaW5nIGxpa2UgdGhhdC4KICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAtLSBMaW51cyBUb3J2YWxkcwpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpZMjAzOCBtYWlsaW5nIGxpc3QK
WTIwMzhAbGlzdHMubGluYXJvLm9yZwpodHRwczovL2xpc3RzLmxpbmFyby5vcmcvbWFpbG1hbi9s
aXN0aW5mby95MjAzOAo=
