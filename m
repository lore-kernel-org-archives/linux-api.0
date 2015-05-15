From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v4 02/12] KVM: define common KVM_GUESTDBG_USE_SW/HW_BP bits
Date: Fri, 15 May 2015 17:58:38 +0200
Message-ID: <555617AE.9030508@de.ibm.com>
References: <1431700035-23479-1-git-send-email-alex.bennee@linaro.org>
 <1431700035-23479-3-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1431700035-23479-3-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org
Cc: Tony Krowiak <akrowiak@linux.vnet.ibm.com>, Alexey Kardashevskiy <aik@ozlabs.ru>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, linux-s390@vger.kernel.org, Michael Mueller <mimu@linux.vnet.ibm.com>, Nadav Amit <namit@cs.technion.ac.il>, Michael Ellerman <mpe@ellerman.id.au>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, "Jason J. Herne" <jjherne@linux.vnet.ibm.com>, jan.kiszka@siemens.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, r65777@freescale.com, Cornelia Huck <cornelia.huck@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Eric Farman <farman@linux.vnet.ibm.com>, linux-api@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, Dominik Dingel <dingel@linux.vnet.ibm.com>, dahi@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>
List-Id: linux-api@vger.kernel.org

QW0gMTUuMDUuMjAxNSB1bSAxNjoyNyBzY2hyaWViIEFsZXggQmVubsOpZToKPiBpbmRleCBlZjFh
NWZjLi5hY2E0Zjg2IDEwMDY0NAo+IC0tLSBhL2FyY2gvczM5MC9pbmNsdWRlL3VhcGkvYXNtL2t2
bS5oCj4gKysrIGIvYXJjaC9zMzkwL2luY2x1ZGUvdWFwaS9hc20va3ZtLmgKPiBAQCAtMTE0LDgg
KzExNCw2IEBAIHN0cnVjdCBrdm1fZnB1IHsKPiAgCV9fdTY0IGZwcnNbMTZdOwo+ICB9Owo+IAo+
IC0jZGVmaW5lIEtWTV9HVUVTVERCR19VU0VfSFdfQlAJCTB4MDAwMTAwMDAKPiAtCgoKPiBkaWZm
IC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L2t2
bS5oCj4gaW5kZXggNzBhYzY0MS4uN2M1ZGQxMSAxMDA2NDQKPiAtLS0gYS9pbmNsdWRlL3VhcGkv
bGludXgva3ZtLmgKPiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgKWy4uLl0KPiArI2Rl
ZmluZSBLVk1fR1VFU1REQkdfVVNFX1NXX0JQCQkoMSA8PCAxNikKPiArI2RlZmluZSBLVk1fR1VF
U1REQkdfVVNFX0hXX0JQCQkoMSA8PCAxNykKClRoaXMgaXMgYSBhYmkgYnJlYWsgZm9yIHMzOTAs
IG5vPwoKRGF2aWQgZG8geW91IHJlbWVtYmVyIHdoeSB3ZSBkaWQgbm90IHVzZSBTV19CUD8KCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWls
aW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNv
bHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
