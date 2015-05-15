From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v4 02/12] KVM: define common KVM_GUESTDBG_USE_SW/HW_BP bits
Date: Fri, 15 May 2015 19:46:08 +0200
Message-ID: <555630E0.8060305@siemens.com>
References: <1431700035-23479-1-git-send-email-alex.bennee@linaro.org>	<1431700035-23479-3-git-send-email-alex.bennee@linaro.org>	<555613F2.9060204@de.ibm.com>
 <20150515193315.6d3e82d2@thinkpad-w530>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <20150515193315.6d3e82d2@thinkpad-w530>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: David Hildenbrand <dahi@linux.vnet.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: Tony Krowiak <akrowiak@linux.vnet.ibm.com>, kvm@vger.kernel.org, supporter@lists.cs.columbia.edu, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, kvmarm@lists.cs.columbia.edu, S390 <linux-s390@vger.kernel.org>, Michael Mueller <mimu@linux.vnet.ibm.com>, Nadav Amit <namit@cs.technion.ac.il>, Michael Ellerman <mpe@ellerman.id.au>, "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>, Gleb Natapov <gleb@kernel.org>, Ingo Molnar <mingo@redhat.com>, zhichao.huang@linaro.org, r65777@freescale.com, bp@suse.de, "Jason J. Herne" <jjherne@linux.vnet.ibm.com>, marc.zyngier@arm.com, pbonzini@redhat.com, Cornelia Huck <cornelia.huck@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, Eric Farman <farman@linux.vnet.ibm.com>, list@lists.c
List-Id: linux-api@vger.kernel.org

T24gMjAxNS0wNS0xNSAxOTozMywgRGF2aWQgSGlsZGVuYnJhbmQgd3JvdGU6Cj4+IEFtIDE1LjA1
LjIwMTUgdW0gMTY6Mjcgc2NocmllYiBBbGV4IEJlbm7DqWU6Cj4+PiArKysgYi9hcmNoL3MzOTAv
aW5jbHVkZS91YXBpL2FzbS9rdm0uaAo+Pj4gQEAgLTExNCw4ICsxMTQsNiBAQCBzdHJ1Y3Qga3Zt
X2ZwdSB7Cj4+PiAgCV9fdTY0IGZwcnNbMTZdOwo+Pj4gIH07Cj4+Pgo+Pj4gLSNkZWZpbmUgS1ZN
X0dVRVNUREJHX1VTRV9IV19CUAkJMHgwMDAxMDAwMAo+PiBbLi4uXQo+Pj4gKysrIGIvaW5jbHVk
ZS91YXBpL2xpbnV4L2t2bS5oCj4+IFsuLi5dCj4+PiArI2RlZmluZSBLVk1fR1VFU1REQkdfVVNF
X1NXX0JQCQkoMSA8PCAxNikKPj4+ICsjZGVmaW5lIEtWTV9HVUVTVERCR19VU0VfSFdfQlAJCSgx
IDw8IDE3KQo+Pgo+PiBUaGlzIGlzIGFuIEFCSSBicmVhayBmb3IgczM5MCwgbm8/Cj4+Cj4+IERh
dmlkLCBkbyB5b3UgcmVtZW1iZXIgd2h5IHdlIGRvIG5vdCB1c2UgS1ZNX0dVRVNUREJHX1VTRV9T
V19CUD8KPj4KPiAKPiBXZSBuZXZlciBoYWQgdG8gdGVsbCB0aGUga2VybmVsIGFib3V0IHNvZnR3
YXJlIGJyZWFrcG9pbnRzIGFzIHRoaXMgaXMgYWxsCj4gaGFuZGxlZCB2aWEgNCBieXRlIERJQUcg
aW5zdHJ1Y3Rpb25zIHVudGlsIG5vdy4gV2UgZG9uJ3QgaGF2ZSB0byB0dXJuIHRoaXMKPiBtZWNo
YW5pc20gb24uIFFFTVUgY2FuIGRpcmVjdGx5IGluc2VydCB0aGUgZGVzaXJlZCBESUFHIGluc3Ry
dWN0aW9ucyBhbmQgZ2V0cwo+IG5vdGlmaWVkIHdoZW4gdGhleSBhcmUgYWJvdXQgdG8gZ2V0IGV4
ZWN1dGVkLgo+IAo+IChCdXQgd2Ugc3RpbGwgaGF2ZSAyIGJ5dGUgYnJlYWtwb2ludCBzdXBwb3J0
IHRvZG8gLSBzdGlsbCB0YmQgaG93IGV4YWN0bHkgdGhpcwo+IHdpbGwgYmUgcmVhbGl6ZWQgLSBj
b3VsZCBiZSB0dXJuZWQgb24gdmlhIHN1Y2ggYSBtZWNoYW5pc20pCj4gCj4gVGhlIHByb2JsZW0g
aXMsIHRoYXQgdGhlc2UgYml0cyBhcmUgYXJjaCBzcGVjaWZpYywgbm93IEFsZXggd2FudHMgdG8g
dW5pZnkKPiB0aGVtIGZvciBhbGwgYXJjaHMuCj4gCj4gU28geWVzLCB0aGlzIGlzIGFuIEFCSSBi
cmVhayBmb3IgdXMgYW5kIGJyZWFrcyBoYXJkd2FyZSBicmVha3BvaW50cy4oSSB0aGluawo+IHRo
ZSBmaXJzdCB2ZXJzaW9uIG9mIHRoaXMgcGF0Y2ggZGlkbid0IGNvbnRhaW4gdGhpcyBBQkkgYnJl
YWsgd2hlbiBJIGhhZCBhIGxvb2spCj4gCj4gSSB3b25kZXIgaWYgaXQgd291bGRuJ3QgbWFrZSBt
b3JlIHNlbnNlIHRvCj4gCj4gLSBpbnRyb2R1Y2UgbmV3IGJpdHMgaW4gdGhlIGFyY2gtdW5zcGVj
aWZpYyBzZWN0aW9uCj4gLSByZXdvcmsgdGhlIGV4aXN0aW5nIGltcGxlbWVudGVycyB0byBhY2Nl
cHQgYm90aCBiaXRzCj4gCj4gT3IgdG8gc2ltcGx5IGxlYXZlIHN0dWZmIGFzIGl0IGlzIGFuZCBo
YW5kbGUgaXQgdmlhIGFyY2ggc3BlY2lmaWMgYml0cy4KCldpdGggb25lIGFyY2ggcHJvdmluZyB0
aGUgImFsbCBuZWVkIHRoaXMiIHRoZW9yeSB3cm9uZywganVzdCBkcm9wIHRoaXMKcGF0Y2guIEV2
ZW4gcXVpY2tlciB3aGVuIGl0IGJyZWFrcyBhbiBBQkkuCgpKYW4KCi0tIApTaWVtZW5zIEFHLCBD
b3Jwb3JhdGUgVGVjaG5vbG9neSwgQ1QgUlRDIElUUCBTRVMtREUKQ29ycG9yYXRlIENvbXBldGVu
Y2UgQ2VudGVyIEVtYmVkZGVkIExpbnV4Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2
bWFybQo=
