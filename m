From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 17/19] y2038: use __kernel_timespec in sys_futex
Date: Sat, 16 May 2015 09:21:14 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1505160920380.4225@nanos>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
 <1430929826-318934-18-git-send-email-arnd@arndb.de>
 <alpine.DEB.2.11.1505160049210.4225@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <alpine.DEB.2.11.1505160049210.4225@nanos>
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
Cc: libc-alpha@sourceware.org, baolin.wang@linaro.org, y2038@lists.linaro.org, linux-api@vger.kernel.org, ruchandani.tina@gmail.com, linux-kernel@vger.kernel.org, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org
List-Id: linux-api@vger.kernel.org

T24gU2F0LCAxNiBNYXkgMjAxNSwgVGhvbWFzIEdsZWl4bmVyIHdyb3RlOgo+IE9uIFdlZCwgNiBN
YXkgMjAxNSwgQXJuZCBCZXJnbWFubiB3cm90ZToKPiAKPiA+IENvbnZlcnNpb24gZm9yIHN5c19m
dXRleCBpcyBwYXJ0aWN1bGFybHkgZWFzeSwgd2UgY2FuIHVzZSB0aGUgdW5tb2RpZmllZAo+ID4g
Y29tcGF0X3N5c19mdXRleCBvbiAzMi1iaXQgc3lzdGVtcyB0byBwcm92aWRlIGNvbXBhdGliaWxp
dHkgZm9yIDMyLWJpdAo+ID4gdGltZV90LCBhbmQgY2hhbmdlIHN5c19mdXRleCB0byBwYXNzIGEg
X19rZXJuZWxfdGltZXNwZWMsIHdoaWNoIG1hdGNoZXMKPiA+IHdoYXQgZnV0dXJlIGxpYmMgaW1w
bGVtZW50YXRpb25zIHdpbGwgdXNlIGFzIHRoZWlyIHN0cnVjdCB0aW1lc3BlYy4KPiAKPiBVbmxl
c3MgSSdtIG1pc3Npbmcgc29tZXRoaW5nIEkgZG91YnQgdGhhdCB5b3UgZ2V0IGF3YXkgdGhhdCBl
YXN5LiBJdAo+IHdvcmtzIG9uIDMyYml0LCBidXQgbm90IG9uIDY0IGJpdCB3aXRoIDMyYml0IGFw
cCBzdXBwb3J0Ogo+IAo+IE5hdGl2ZSA2NGJpdDogCSAgIHN5c19mdXRleCgpCj4gMzJiaXQgdGlt
ZXNwZWMzMjogIGNvbXBhdF9zeXNfZnV0ZXgoKQo+IDMyYml0IHRpbWVzcGVjNjQ6ICA/Pz8/Pwo+
IAo+IFlvdSBjYW5ub3QgbWFwIHRoYXQgdG8gc3lzX2Z1dGV4KCkgYmVjYXVzZSB0aGUgcG9pbnRl
ciBzaXplIGRpZmZlcnMuCgpJZ25vcmUgdGhhdC4gWW91IGFyZSByaWdodC4gUmV2aWV3IGluZHVj
ZWQgYnJhaW5tZWx0Li4uLgoKICAgICAgIHRnbHgKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18KWTIwMzggbWFpbGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFy
by5vcmcKaHR0cHM6Ly9saXN0cy5saW5hcm8ub3JnL21haWxtYW4vbGlzdGluZm8veTIwMzgK
