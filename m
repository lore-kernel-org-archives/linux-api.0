From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v4 10/12] KVM: arm64: guest debug,
 HW assisted debug support
Date: Fri, 15 May 2015 17:16:26 +0100
Message-ID: <87y4kpke91.fsf@linaro.org>
References: <1431700035-23479-1-git-send-email-alex.bennee@linaro.org>
 <1431700035-23479-11-git-send-email-alex.bennee@linaro.org>
 <20150515152346.GB23652@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-reply-to: <20150515152346.GB23652@leverpostej>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>, Will Deacon <Will.Deacon@arm.com>, Peter Zijlstra <peterz@infr>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>, Russell King <linux@arm.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, Gleb Natapov <gleb@kernel.org>, "zhichao.huang@linaro.org" <zhichao.huang@linaro.org>, Catalin Marinas <Catalin.Marinas@arm.com>, "bp@suse.de" <bp@suse.de>, Marc Zyngier <Marc.Zyngier@arm.com>, "r65777@freescale.com" <r65777@freescale.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, adead.org@lists.cs.columbia.edu, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>d
List-Id: linux-api@vger.kernel.org

Ck1hcmsgUnV0bGFuZCA8bWFyay5ydXRsYW5kQGFybS5jb20+IHdyaXRlczoKCj4gSGkgQWxleCwK
Pgo+IE9uIEZyaSwgTWF5IDE1LCAyMDE1IGF0IDAzOjI3OjEzUE0gKzAxMDAsIEFsZXggQmVubsOp
ZSB3cm90ZToKPj4gVGhpcyBhZGRzIHN1cHBvcnQgZm9yIHVzZXJzcGFjZSB0byBjb250cm9sIHRo
ZSBIVyBkZWJ1ZyByZWdpc3RlcnMgZm9yCj4+IGd1ZXN0IGRlYnVnLiBJbiB0aGUgZGVidWcgaW9j
dGwgd2UgY29weSB0aGUgSU1QREVGIGRlZmluZWQgbnVtYmVyIG9mCj4+IHJlZ2lzdGVycyBpbnRv
IGEgbmV3IHJlZ2lzdGVyIHNldCBjYWxsZWQgaG9zdF9kZWJ1Z19zdGF0ZS4gVGhlcmUgaXMgbm93
Cj4+IGEgbmV3IHZjcHUgcGFyYW1ldGVyIGNhbGxlZCBkZWJ1Z19wdHIgd2hpY2ggc2VsZWN0cyB3
aGljaCByZWdpc3RlciBzZXQKPj4gaXMgdG8gY29waWVkIGludG8gdGhlIHJlYWwgcmVnaXN0ZXJz
IHdoZW4gd29ybGQgc3dpdGNoIG9jY3Vycy4KPj4gCj4+IEkndmUgbW92ZWQgc29tZSBoZWxwZXIg
ZnVuY3Rpb25zIGludG8gdGhlIGh3X2JyZWFrcG9pbnQuaCBoZWFkZXIgZm9yCj4+IHJlLXVzZS4K
Pj4gCj4+IEFzIHdpdGggc2luZ2xlIHN0ZXAgd2UgbmVlZCB0byB0d2VhayB0aGUgZ3Vlc3QgcmVn
aXN0ZXJzIHRvIGVuYWJsZSB0aGUKPj4gZXhjZXB0aW9ucyBzbyB3ZSBuZWVkIHRvIHNhdmUgYW5k
IHJlc3RvcmUgdGhvc2UgYml0cy4KPj4gCj4+IFR3byBuZXcgY2FwYWJpbGl0aWVzIGhhdmUgYmVl
biBhZGRlZCB0byB0aGUgS1ZNX0VYVEVOU0lPTiBpb2N0bCB0byBhbGxvdwo+PiB1c2Vyc3BhY2Ug
dG8gcXVlcnkgdGhlIG51bWJlciBvZiBoYXJkd2FyZSBicmVhayBhbmQgd2F0Y2ggcG9pbnRzCj4+
IGF2YWlsYWJsZSBvbiB0aGUgaG9zdCBoYXJkd2FyZS4KPgo+IFRoZXJlJ3MgdGhlIHVuZm9ydHVu
YXRlIHBvc3NpYmlsaXR5IHRoYXQgdGhlc2UgY291bGQgdmFyeSBhY3Jvc3MgY29yZXMKPiBpbiBh
IGJpZy5MSVRUTEUgc3lzdGVtICh0aG91Z2ggd2UgaGF2ZW4ndCBzZWVuIHRoYXQgdGh1cyBmYXIp
LiBUaGUKPiBrZXJuZWwgc2FuaXR5IGNoZWNrcyBzaG91bGQgY3VycmVudGx5IGV4cGxvZGUgaWYg
c3VjaCBhIGNhc2UgaXMKPiBlbmNvdW50ZXJlZCwgYnV0IEkgZG9uJ3Qga25vdyB3aGF0IHdlJ2Qg
ZG8gd2VyZSB0aGF0IHRvIGhhcHBlbi4KCkkgc3VzcGVjdCB3ZSB3b3VsZCBoYXZlIHRvIGRpc2Fi
bGUgSFcgYXNzaXN0ZWQgYnJlYWtwb2ludHMgb3IgcmV0dXJuIHRoZQpsb3dlc3QgY29tbW9uIGRl
bm9taW5hdG9yIGlmIHdlIGNhbiB0ZWxsIHdoaWNoIGNvcmVzIHdlIHNoYWxsIGV2ZXJ5IGJlCnNj
aGVkdWxlZCBvbi4KCj4KPiBUaGlzIGdldHMgbW9yZSBmdW4gd2hlbiB5b3UgY29uc2lkZXIgdGhl
IGNvbnRleHQtYXdhcmUgYnJlYWtwb2ludHMgYXJlCj4gdGhlIGhpZ2hlc3QgbnVtYmVyZWQuIFNv
IHRoZSBzZXQgb2YgKGNvbnRleHQtYXdhcmUpIGJyZWFrcG9pbnRzIG1pZ2h0Cj4gbm90IGludGVy
c2VjdCBhY3Jvc3MgYWxsIENQVXMuCgpJIGRpZG4ndCBzZWUgYSByZWZlcmVuY2UgdG8gdGhhdCBp
biB0aGUgQVJNIEFSTS4gSXQgc2VlbWVkIHRvIGltcGx5IGFueQpicmVha3BvaW50IGNvdWxkIGJl
IGNvbnRleHQgYXdhcmUgaXMgLkJUIHdhcyBhcHByb3ByaWF0ZWx5IHNldCBhbmQKbGlua2VkIHRv
IHRoZSBWUi4gIAoKQXMgaXQgaGFwcGVucyB0aGUgZ2RiIHN0dWIgaW50ZXJmYWNlIGluIFFFTVUg
aXMgZmFpcmx5IGxpbWl0ZWQgc28gd2hpbGUKSSBleHBvc2UgdGhlIGZ1bGwgZGVidWcgcmVnaXN0
ZXJzIEkgZG9uJ3QgdGhpbmsgdGhlcmUgaXMgY3VycmVudGx5IGEgd2F5CnRvIGV4cG9zZSBhbnkg
b2YgdGhlIGZhbmN5IGxpbmtpbmcvY29udGV4dCBzdHVmZiB0byB0aGUgdXNlcnNwYWNlCmRlYnVn
Z2VyLiBIb3dldmVyIEkgZGlkIG1ha2UgdGhlIEFCSSBwYXNzIGZ1bGwgcmF3IHZhbHVlcyBpbiBz
byB0aGlzCmNvdWxkIGJlY29tZSBhIHBvc3NpYmlsaXR5IGxhdGVyIHdpdGhvdXQgaGF2aW5nIHRv
IGV4cGFuZCB0aGUgQUJJLgoKCj4gSSdtIG5vdCBzdXJlIHdoYXQgdGhlIGJlc3QgdGhpbmcgdG8g
ZG8gaXMgdy5yLnQuIGV4cG9zaW5nIHRoYXQgdG8KPiB1c2Vyc3BhY2UuCj4KPiBUaGFua3MsCj4g
TWFyay4KCi0tIApBbGV4IEJlbm7DqWUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1i
aWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3Zt
YXJtCg==
