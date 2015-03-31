From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 01/10] KVM: add commentary for kvm_debug_exit_arch struct
Date: Tue, 31 Mar 2015 16:07:59 +0100
Message-ID: <1427814488-28467-2-git-send-email-alex.bennee@linaro.org>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org
Cc: Gleb Natapov <gleb@kernel.org>, jan.kiszka@siemens.com, open list <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de
List-Id: linux-api@vger.kernel.org

QnJpbmcgaW50byBsaW5lIHdpdGggdGhlIGNvbW1lbnRhcnkgZm9yIHRoZSBvdGhlciBzdHJ1Y3R1
cmVzIGFuZCB0aGVpcgpLVk1fRVhJVF8qIGNhc2VzLgoKU2lnbmVkLW9mZi1ieTogQWxleCBCZW5u
w6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgoKLS0tCgp2MgogIC0gYWRkIGNvbW1lbnRzIGZv
ciBvdGhlciBleGl0IHR5cGVzCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5o
IGIvaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oCmluZGV4IDgwNTU3MDYuLjVlZWRmODQgMTAwNjQ0
Ci0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9rdm0uaAorKysgYi9pbmNsdWRlL3VhcGkvbGludXgv
a3ZtLmgKQEAgLTIyNiw2ICsyMjYsNyBAQCBzdHJ1Y3Qga3ZtX3J1biB7CiAJCQlfX3UzMiBjb3Vu
dDsKIAkJCV9fdTY0IGRhdGFfb2Zmc2V0OyAvKiByZWxhdGl2ZSB0byBrdm1fcnVuIHN0YXJ0ICov
CiAJCX0gaW87CisJCS8qIEtWTV9FWElUX0RFQlVHICovCiAJCXN0cnVjdCB7CiAJCQlzdHJ1Y3Qg
a3ZtX2RlYnVnX2V4aXRfYXJjaCBhcmNoOwogCQl9IGRlYnVnOwpAQCAtMjc0LDYgKzI3NSw3IEBA
IHN0cnVjdCBrdm1fcnVuIHsKIAkJCV9fdTMyIGRhdGE7CiAJCQlfX3U4ICBpc193cml0ZTsKIAkJ
fSBkY3I7CisJCS8qIEtWTV9FWElUX0lOVEVSTkFMX0VSUk9SICovCiAJCXN0cnVjdCB7CiAJCQlf
X3UzMiBzdWJlcnJvcjsKIAkJCS8qIEF2YWlsYWJsZSB3aXRoIEtWTV9DQVBfSU5URVJOQUxfRVJS
T1JfREFUQTogKi8KQEAgLTI4NCw2ICsyODYsNyBAQCBzdHJ1Y3Qga3ZtX3J1biB7CiAJCXN0cnVj
dCB7CiAJCQlfX3U2NCBncHJzWzMyXTsKIAkJfSBvc2k7CisJCS8qIEtWTV9FWElUX1BBUFJfSENB
TEwgKi8KIAkJc3RydWN0IHsKIAkJCV9fdTY0IG5yOwogCQkJX191NjQgcmV0OwotLSAKMi4zLjQK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
