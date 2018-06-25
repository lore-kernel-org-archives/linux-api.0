From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 2/2] rusage: allow 64-bit times
	ru_utime/ru_stime
Date: Mon, 25 Jun 2018 11:14:26 +0200
Message-ID: <20180625091426.GA18351@gmail.com>
References: <20180420120605.1612248-1-arnd@arndb.de>
 <20180420120605.1612248-2-arnd@arndb.de>
 <20180621154915.GA31947@gmail.com>
 <CAK8P3a1QYTfRNQt2+a29BpvgYM_pnSFrO=NBvVo=BdUa2q9ngQ@mail.gmail.com>
 <20180621161121.GB7222@gmail.com>
 <CAK8P3a1mx16S+DhEMQA6WBJ7efdhN5YaKKVHU6n+E6kfifM-Qg@mail.gmail.com>
 <20180622021636.GA11266@gmail.com> <87a7rm3eb5.fsf@xmission.com>
 <20180624071258.GB29407@gmail.com> <87y3f31wsv.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
Content-Disposition: inline
In-Reply-To: <87y3f31wsv.fsf@xmission.com>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-arch <linux-arch@vger.kernel.org>, Paul Eggert <eggert@cs.ucla.edu>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Deepa Dinamani <deepa.kernel@gmail.com>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Al Viro <viro@zeniv.linux.org.uk>, linux-alpha@vger.kernel.org, Matt Turner <mattst88@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Richard Henderson <rth@twiddle.net>
List-Id: linux-api@vger.kernel.org

CiogRXJpYyBXLiBCaWVkZXJtYW4gPGViaWVkZXJtQHhtaXNzaW9uLmNvbT4gd3JvdGU6Cgo+IElu
Z28gTW9sbmFyIDxtaW5nb0BrZXJuZWwub3JnPiB3cml0ZXM6Cj4gCj4gPiAqIEVyaWMgVy4gQmll
ZGVybWFuIDxlYmllZGVybUB4bWlzc2lvbi5jb20+IHdyb3RlOgo+ID4KPiA+PiBUaGUgdHJvdWJs
ZSB3aXRoIGF0dHJpYnV0ZXMgaXMgdGhhdCBtZWFucyB5b3UgY2FuJ3QgZmlsdGVyIHlvdXIgc3lz
dGVtCj4gPj4gY2FsbCBhcmd1bWVudHMgd2l0aCBzZWNjb21wLiBbLi4uXQo+ID4KPiA+IFRoZXJl
J3Mgbm90aGluZyBrZWVwaW5nIHNlY2NvbXAgZnJvbSBzZWN1cmVseSBmZXRjaGluZyB0aG9zZSBh
cmd1bWVudHMgYW5kIAo+ID4gZXh0ZW5kaW5nIGZpbHRlcmluZyB0byB0aGVtIGFzIHdlbGwgLi4u
Cj4gPgo+ID4gQWxsb3dpbmcgdGhhdCB3b3VsZCBtYWtlIHNlbnNlIGZvciBhIGxvdCBvZiBvdGhl
ciBzeXN0ZW0gY2FsbHMgYXMKPiA+IHdlbGwuCj4gCj4gUG9zc2libHkuICBUaGUgY2hhbGxlbmdl
IGlzIHRoYXQgaWYgdGhlIGZldGNoIGZvciB0aGUga2VybmVsIHRvIHVzZQo+IHRob3NlIGFyZ3Vt
ZW50cyBpcyBkaWZmZXJlbnQgZnJvbSB0aGUgZmV0Y2ggb2Ygc2VjY29tcCB0byB0ZXN0IHRob3Nl
Cj4gYXJndW1lbnRzIHlvdSBoYXZlIGEgdGltZSBvZiB0ZXN0IHZzIHRpbWUgb2YgdXNlIHJhY2Uu
CgpUaG9zZSBmZXRjaGVkIHZhbHVlcyBzaG91bGQgb2J2aW91c2x5IHRoZW4gYmUgdXNlZCB0byBj
YWxsIHBlcm1pdHRlZCBzeXN0ZW0gY2FsbHMuCgo+IEdpdmVuIHRoZSBsb2NhdGlvbiBvZiB0aGUg
c2VjY29tcCBob29rIGF0IHRoZSBrZXJuZWwgdXNlciBzcGFjZSBib3JkZXIKPiB0aGVyZSBpcyBu
byBlYXN5IHdheSBmb3Igc2VjY29tcCB0byBzaGFyZSB0aGUgZmV0Y2ggd2l0aCB0aGUgc3lzdGVt
Cj4gY2FsbCBpdHNlbGYuCj4gCj4gU28gSSBkb24ndCBzZWUgaG93IHNlY2NvbXAgY291bGQgcGVy
Zm9ybSB0aGUgZmV0Y2ggc2VjdXJlbHkuCgpMb29rcyBsaWtlIG1vcmUgb2YgYSBzZWNjb21wIG1p
cy1kZXNpZ24vbWlzLWltcGxlbWVudGF0aW9uIHRoYW4gc29tZSBmdW5kYW1lbnRhbCAKcHJvYmxl
bS4KCk1pcy1kZXNpZ25lZCBzZWN1cml0eSBmZWF0dXJlcyBzaG91bGQgbm90IGhpbmRlciBzeXN0
ZW0gY2FsbCBkZXNpZ24uCgpUaGFua3MsCgoJSW5nbwpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwpZMjAzOCBtYWlsaW5nIGxpc3QKWTIwMzhAbGlzdHMubGlu
YXJvLm9yZwpodHRwczovL2xpc3RzLmxpbmFyby5vcmcvbWFpbG1hbi9saXN0aW5mby95MjAzOAo=
