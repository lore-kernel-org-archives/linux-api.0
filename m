From: Gabriel Laskar <gabriel@lse.epita.fr>
Subject: [PATCH 15/20] drm: fix inclusion of drm.h in savage_drm.h
Date: Mon, 30 Nov 2015 15:10:53 +0100
Message-ID: <1448892658-14256-16-git-send-email-gabriel@lse.epita.fr>
References: <1448892658-14256-1-git-send-email-gabriel@lse.epita.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <1448892658-14256-1-git-send-email-gabriel@lse.epita.fr>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: David Airlie <airlied@linux.ie>, "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Emil Velikov <emil.l.velikov@gmail.com>
List-Id: linux-api@vger.kernel.org

VXNpbmcgYCNpbmNsdWRlICJkcm0uaCJgIGluc3RlYWQgb2YgYCNpbmNsdWRlIDxkcm0vZHJtLmg+
YCBhbGxvdyBkcm0KaGVhZGVycyB0byBiZSBtb3ZlZCBpbiBhbm90aGVyIGRpcmVjdG9yeSB3aXRo
b3V0IGNoYW5nZXMsIGxpa2UgZm9yIHRoZQpsaWJkcm0gaW1wb3J0cy4KClNpZ25lZC1vZmYtYnk6
IEdhYnJpZWwgTGFza2FyIDxnYWJyaWVsQGxzZS5lcGl0YS5mcj4KQ0M6IEVtaWwgVmVsaWtvdiA8
ZW1pbC5sLnZlbGlrb3ZAZ21haWwuY29tPgpDQzogTWlra28gUmFwZWxpIDxtaWtrby5yYXBlbGlA
aWtpLmZpPgoKLS0tCiBpbmNsdWRlL3VhcGkvZHJtL3NhdmFnZV9kcm0uaCB8IDIgKy0KIDEgZmls
ZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvdWFwaS9kcm0vc2F2YWdlX2RybS5oIGIvaW5jbHVkZS91YXBpL2RybS9zYXZhZ2VfZHJt
LmgKaW5kZXggOWRjOWRjMS4uNTc0MTQ3NCAxMDA2NDQKLS0tIGEvaW5jbHVkZS91YXBpL2RybS9z
YXZhZ2VfZHJtLmgKKysrIGIvaW5jbHVkZS91YXBpL2RybS9zYXZhZ2VfZHJtLmgKQEAgLTI2LDcg
KzI2LDcgQEAKICNpZm5kZWYgX19TQVZBR0VfRFJNX0hfXwogI2RlZmluZSBfX1NBVkFHRV9EUk1f
SF9fCiAKLSNpbmNsdWRlIDxkcm0vZHJtLmg+CisjaW5jbHVkZSAiZHJtLmgiCiAKICNpZm5kZWYg
X19TQVZBR0VfU0FSRUFfREVGSU5FU19fCiAjZGVmaW5lIF9fU0FWQUdFX1NBUkVBX0RFRklORVNf
XwotLSAKMi42LjIKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9y
ZwpodHRwOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
Cg==
