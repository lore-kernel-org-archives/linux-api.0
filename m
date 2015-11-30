From: Gabriel Laskar <gabriel@lse.epita.fr>
Subject: [PATCH 10/20] drm: fix inclusion of drm.h in mga_drm.h
Date: Mon, 30 Nov 2015 15:10:48 +0100
Message-ID: <1448892658-14256-11-git-send-email-gabriel@lse.epita.fr>
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
aWtpLmZpPgoKLS0tCiBpbmNsdWRlL3VhcGkvZHJtL21nYV9kcm0uaCB8IDIgKy0KIDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2luY2x1
ZGUvdWFwaS9kcm0vbWdhX2RybS5oIGIvaW5jbHVkZS91YXBpL2RybS9tZ2FfZHJtLmgKaW5kZXgg
MjM3NWJmZC4uZmNhODE3MCAxMDA2NDQKLS0tIGEvaW5jbHVkZS91YXBpL2RybS9tZ2FfZHJtLmgK
KysrIGIvaW5jbHVkZS91YXBpL2RybS9tZ2FfZHJtLmgKQEAgLTM1LDcgKzM1LDcgQEAKICNpZm5k
ZWYgX19NR0FfRFJNX0hfXwogI2RlZmluZSBfX01HQV9EUk1fSF9fCiAKLSNpbmNsdWRlIDxkcm0v
ZHJtLmg+CisjaW5jbHVkZSAiZHJtLmgiCiAKIC8qIFdBUk5JTkc6IElmIHlvdSBjaGFuZ2UgYW55
IG9mIHRoZXNlIGRlZmluZXMsIG1ha2Ugc3VyZSB0byBjaGFuZ2UgdGhlCiAgKiBkZWZpbmVzIGlu
IHRoZSBYc2VydmVyIGZpbGUgKG1nYV9zYXJlYS5oKQotLSAKMi42LjIKCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwOi8vbGlzdHMuZnJlZWRlc2t0b3Au
b3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==
