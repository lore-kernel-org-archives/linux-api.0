From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Wed, 10 May 2017 00:35:34 -0700
Message-ID: <20170510073534.GA19359@infradead.org>
References: <20170509064522.anusoikaalvlux3w@gmail.com>
 <20170509085659.GA32555@infradead.org>
 <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
 <20170509130250.GA11381@infradead.org>
 <20170509160322.GA15902@infradead.org>
 <20170510021118.GA390@ZenIV.linux.org.uk>
 <20170510024524.GB390@ZenIV.linux.org.uk>
 <20170510031254.GC390@ZenIV.linux.org.uk>
 <20170510065301.GC4115@infradead.org>
 <20170510072746.GF390@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20170510072746.GF390@ZenIV.linux.org.uk>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mark Rutland <mark.rutland@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Greg KH <greg@kroah.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-s390 <linux-s390@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Christoph Hellwig <hch@infradead.org>, Christian Borntraeger <borntraeger@de.ibm.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Catalin Marinas <catalin.marinas@arm.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>, Kees Cook <keescook@c>
List-Id: linux-api@vger.kernel.org

T24gV2VkLCBNYXkgMTAsIDIwMTcgYXQgMDg6Mjc6NDdBTSArMDEwMCwgQWwgVmlybyB3cm90ZToK
PiBBbmQgeW91ICpzdGlsbCogZG8gdGhlIHNhbWUuICBDaHJpc3RvcGgsIHRoaXMgaXMgcmlkaWN1
bG91cyAtIHRoZSB3b3JzdAo+IHBhcnQgb2YgdGhlIGFyZWEgaXMgbm90IGEgY291cGxlIG9mIGZ1
bmN0aW9ucyBpbiBmcy9yZWFkX3dyaXRlLmMsIGl0J3MKPiBhIGZ1Y2tpbmcgbG90IG9mIC0+cmVh
ZCgpIGFuZCAtPndyaXRlKCkgaW5zdGFuY2VzIGluIHNoaXR0eSBkcml2ZXIgY29kZSwKPiBwYXJk
b24gdGhlIHJlZHVuZGFuY2UuICBBbmQgX3RoYXRfIGlzIHN0aWxsIGRvbmUgdW5kZXIgc2V0X2Zz
KEtFUk5FTF9EUykuCgpGb3Igbm93IHllcy4gIEJ1dCBpdCBwcm92aWRlcyBhIHNhbmUgQVBJIG9u
IHRvcCwgYW5kIHRoZW4gd2UgY2FuCnN0YXJ0IG1vdmluZyB0aGUgZHJpdmVycyB0aGF0IG1hdHRl
ciB0byB0aGUgaXRlciB2YXJpYW50cyBhbmQgZHJvcApzdXBwb3J0IGZvciB0aGUgcmVzdCBzb29u
LiAgTW9zdCBpbi1rZXJuZWwgSS9PIGlzIGRvbmUgdG8gZmlsZXMsIGFuZAp0aGUgcmVzdCB0byBh
IHZlcnkgbGltaXRlZCBzZXQgb2YgZGV2aWNlcy4gKG5vdCBhY2NvdW50aW5nIGZvciBzb2NrZXRz
CnRocm91Z2ggdGhlaXIgb3duIEFQSXMsIHRoYXRzIGFub3RoZXIgc3RvcnkpCgo+IFRoYXQncyB3
aGF0IEknbSBvYmplY3RpbmcgdG8uICBDZW50cmFsaXplZCBrZXJuZWxfcmVhZHYoKSBldC5hbC4g
LSBzdXJlLAo+IGFuZCBmcy9yZWFkX3dyaXRlLmMgaXMgdGhlIHJpZ2h0IHBsYWNlIGZvciB0aG9z
ZS4gIE5vIGFyZ3VtZW50cyBoZXJlLgo+IENvbnZlcnNpb24gdG8gdGhvc2UgLSBhYnNvbHV0ZWx5
OyBkcml2ZXJzIGhhdmUgbm8gZnVja2luZyBidXNpbmVzcyB0b3VjaGluZwo+IHNldF9mcygpIGF0
IGFsbC4gIEJ1dCB5b3VyIHByaW1pdGl2ZXMgYXJlIHRyb3VibGUgd2FpdGluZyB0byBoYXBwZW4u
Cj4gTGV0IHRoZW0gdGFrZSBrdmVjIGFycmF5cy4gIEFuZCBsZXQgdGhlbSwgaW4gY2FzZSB3aGVu
IHRoZXJlJ3Mgbm8KPiAtPnJlYWRfaXRlcigpLy0+d3JpdGVfaXRlcigpLCBkbyBzZXRfZnMoKS4g
IFN0YXRpY2FsbHksIHdpdGhvdXQgdGhpcwo+IGlmIChpdGVyLT50eXBlICYgSVRFUl9LVkVDKSAu
Li4gc3R1ZmYuCgpPaCB3ZcS6bC4gIEkgY2FuIGRvIHRoYXQgZmlyc3QsIGJ1dCBJIHRoaW5rIGV2
ZW50dWFsbHkgd2UnbGwgaGF2ZSB0bwpnZXQgYmFjayB0byB3aGF0IEkndmUgZG9uZSBub3cuCgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpsaW51eC1hcm0t
a2VybmVsIG1haWxpbmcgbGlzdApsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcK
aHR0cDovL2xpc3RzLmluZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1hcm0ta2Vy
bmVsCg==
