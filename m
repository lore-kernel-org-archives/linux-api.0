From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v4 10/12] KVM: arm64: guest debug,
 HW assisted debug support
Date: Fri, 15 May 2015 18:09:03 +0100
Message-ID: <CAFEAcA8Z1Na9LY3m-DvGXpjUtCkc_H3+uAKWVRB4EBZWP6enJg@mail.gmail.com>
References: <1431700035-23479-1-git-send-email-alex.bennee@linaro.org>
 <1431700035-23479-11-git-send-email-alex.bennee@linaro.org>
 <20150515152346.GB23652@leverpostej> <87y4kpke91.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <87y4kpke91.fsf@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>, Will Deacon <Will.Deacon@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>, Russell King <linux@arm.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, Gleb Natapov <gleb@kernel.org>, "zhichao.huang@linaro.org" <zhichao.huang@linaro.org>, Catalin Marinas <Catalin.Marinas@arm.com>, "bp@suse.de" <bp@suse.de>, Marc Zyngier <Marc.Zyngier@arm.com>, "r65777@freescale.com" <r65777@freescale.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "dahi@linux.vnet.ibm.com" <da>
List-Id: linux-api@vger.kernel.org

T24gMTUgTWF5IDIwMTUgYXQgMTc6MTYsIEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJv
Lm9yZz4gd3JvdGU6Cj4gTWFyayBSdXRsYW5kIDxtYXJrLnJ1dGxhbmRAYXJtLmNvbT4gd3JpdGVz
Ogo+PiBUaGlzIGdldHMgbW9yZSBmdW4gd2hlbiB5b3UgY29uc2lkZXIgdGhlIGNvbnRleHQtYXdh
cmUgYnJlYWtwb2ludHMgYXJlCj4+IHRoZSBoaWdoZXN0IG51bWJlcmVkLiBTbyB0aGUgc2V0IG9m
IChjb250ZXh0LWF3YXJlKSBicmVha3BvaW50cyBtaWdodAo+PiBub3QgaW50ZXJzZWN0IGFjcm9z
cyBhbGwgQ1BVcy4KPgo+IEkgZGlkbid0IHNlZSBhIHJlZmVyZW5jZSB0byB0aGF0IGluIHRoZSBB
Uk0gQVJNLiBJdCBzZWVtZWQgdG8gaW1wbHkgYW55Cj4gYnJlYWtwb2ludCBjb3VsZCBiZSBjb250
ZXh0IGF3YXJlIGlzIC5CVCB3YXMgYXBwcm9wcmlhdGVseSBzZXQgYW5kCj4gbGlua2VkIHRvIHRo
ZSBWUi4KCk5vOyBzZWUgRDIuOS4yOyB0aGVyZSBtdXN0IGJlIGF0IGxlYXN0IG9uZSBjb250ZXh0
LWF3YXJlCmJyZWFrcG9pbnQsIGJ1dCBubyByZXF1aXJlbWVudCBmb3IgbW9yZSB0aGFuIHRoYXQu
CgotLSBQTU0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
a3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8v
bGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
