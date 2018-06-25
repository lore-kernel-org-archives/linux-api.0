From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v2 2/2] rusage: allow 64-bit times
	ru_utime/ru_stime
Date: Sun, 24 Jun 2018 20:26:08 -0500
Message-ID: <87y3f31wsv.fsf@xmission.com>
References: <20180420120605.1612248-1-arnd@arndb.de>
 <20180420120605.1612248-2-arnd@arndb.de>
 <20180621154915.GA31947@gmail.com>
 <CAK8P3a1QYTfRNQt2+a29BpvgYM_pnSFrO=NBvVo=BdUa2q9ngQ@mail.gmail.com>
 <20180621161121.GB7222@gmail.com>
 <CAK8P3a1mx16S+DhEMQA6WBJ7efdhN5YaKKVHU6n+E6kfifM-Qg@mail.gmail.com>
 <20180622021636.GA11266@gmail.com> <87a7rm3eb5.fsf@xmission.com>
 <20180624071258.GB29407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20180624071258.GB29407@gmail.com> (Ingo Molnar's message of
 "Sun, 24 Jun 2018 09:12:58 +0200")
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-arch <linux-arch@vger.kernel.org>, Paul Eggert <eggert@cs.ucla.edu>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Deepa Dinamani <deepa.kernel@gmail.com>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Al Viro <viro@zeniv.linux.org.uk>, linux-alpha@vger.kernel.org, Matt Turner <mattst88@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Richard Henderson <rth@twiddle.net>
List-Id: linux-api@vger.kernel.org

SW5nbyBNb2xuYXIgPG1pbmdvQGtlcm5lbC5vcmc+IHdyaXRlczoKCj4gKiBFcmljIFcuIEJpZWRl
cm1hbiA8ZWJpZWRlcm1AeG1pc3Npb24uY29tPiB3cm90ZToKPgo+PiBUaGUgdHJvdWJsZSB3aXRo
IGF0dHJpYnV0ZXMgaXMgdGhhdCBtZWFucyB5b3UgY2FuJ3QgZmlsdGVyIHlvdXIgc3lzdGVtCj4+
IGNhbGwgYXJndW1lbnRzIHdpdGggc2VjY29tcC4gWy4uLl0KPgo+IFRoZXJlJ3Mgbm90aGluZyBr
ZWVwaW5nIHNlY2NvbXAgZnJvbSBzZWN1cmVseSBmZXRjaGluZyB0aG9zZSBhcmd1bWVudHMgYW5k
IAo+IGV4dGVuZGluZyBmaWx0ZXJpbmcgdG8gdGhlbSBhcyB3ZWxsIC4uLgo+Cj4gQWxsb3dpbmcg
dGhhdCB3b3VsZCBtYWtlIHNlbnNlIGZvciBhIGxvdCBvZiBvdGhlciBzeXN0ZW0gY2FsbHMgYXMK
PiB3ZWxsLgoKUG9zc2libHkuICBUaGUgY2hhbGxlbmdlIGlzIHRoYXQgaWYgdGhlIGZldGNoIGZv
ciB0aGUga2VybmVsIHRvIHVzZQp0aG9zZSBhcmd1bWVudHMgaXMgZGlmZmVyZW50IGZyb20gdGhl
IGZldGNoIG9mIHNlY2NvbXAgdG8gdGVzdCB0aG9zZQphcmd1bWVudHMgeW91IGhhdmUgYSB0aW1l
IG9mIHRlc3QgdnMgdGltZSBvZiB1c2UgcmFjZS4KCkdpdmVuIHRoZSBsb2NhdGlvbiBvZiB0aGUg
c2VjY29tcCBob29rIGF0IHRoZSBrZXJuZWwgdXNlciBzcGFjZSBib3JkZXIKdGhlcmUgaXMgbm8g
ZWFzeSB3YXkgZm9yIHNlY2NvbXAgdG8gc2hhcmUgdGhlIGZldGNoIHdpdGggdGhlIHN5c3RlbQpj
YWxsIGl0c2VsZi4KClNvIEkgZG9uJ3Qgc2VlIGhvdyBzZWNjb21wIGNvdWxkIHBlcmZvcm0gdGhl
IGZldGNoIHNlY3VyZWx5LgoKRXJpYwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwpZMjAzOCBtYWlsaW5nIGxpc3QKWTIwMzhAbGlzdHMubGluYXJvLm9yZwpo
dHRwczovL2xpc3RzLmxpbmFyby5vcmcvbWFpbG1hbi9saXN0aW5mby95MjAzOAo=
