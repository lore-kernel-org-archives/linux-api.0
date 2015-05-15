From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v4 02/12] KVM: define common KVM_GUESTDBG_USE_SW/HW_BP bits
Date: Fri, 15 May 2015 17:42:42 +0200
Message-ID: <555613F2.9060204@de.ibm.com>
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
Cc: Tony Krowiak <akrowiak@linux.vnet.ibm.com>, Alexey Kardashevskiy <aik@ozlabs.ru>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, S390 <linux-s390@vger.kernel.org>, Michael Mueller <mimu@linux.vnet.ibm.com>, Nadav Amit <namit@cs.technion.ac.il>, Michael Ellerman <mpe@ellerman.id.au>, "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>, supporter@lists.cs.columbia.edu, Ingo Molnar <mingo@redhat.com>, "Jason J. Herne" <jjherne@linux.vnet.ibm.com>, jan.kiszka@siemens.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, r65777@freescale.com, Cornelia Huck <cornelia.huck@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Eric Farman <farman@linux.vnet.ibm.com>, list@lists.cs.columbia.edu, ABI/API <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

QW0gMTUuMDUuMjAxNSB1bSAxNjoyNyBzY2hyaWViIEFsZXggQmVubsOpZToKPiArKysgYi9hcmNo
L3MzOTAvaW5jbHVkZS91YXBpL2FzbS9rdm0uaAo+IEBAIC0xMTQsOCArMTE0LDYgQEAgc3RydWN0
IGt2bV9mcHUgewo+ICAJX191NjQgZnByc1sxNl07Cj4gIH07Cj4gCj4gLSNkZWZpbmUgS1ZNX0dV
RVNUREJHX1VTRV9IV19CUAkJMHgwMDAxMDAwMApbLi4uXQo+ICsrKyBiL2luY2x1ZGUvdWFwaS9s
aW51eC9rdm0uaApbLi4uXQo+ICsjZGVmaW5lIEtWTV9HVUVTVERCR19VU0VfU1dfQlAJCSgxIDw8
IDE2KQo+ICsjZGVmaW5lIEtWTV9HVUVTVERCR19VU0VfSFdfQlAJCSgxIDw8IDE3KQoKVGhpcyBp
cyBhbiBBQkkgYnJlYWsgZm9yIHMzOTAsIG5vPwoKRGF2aWQsIGRvIHlvdSByZW1lbWJlciB3aHkg
d2UgZG8gbm90IHVzZSBLVk1fR1VFU1REQkdfVVNFX1NXX0JQPwoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxt
YW4vbGlzdGluZm8va3ZtYXJtCg==
