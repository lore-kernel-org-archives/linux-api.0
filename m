From: Gabriel Laskar <gabriel@lse.epita.fr>
Subject: [PATCH 14/20] drm: fix inclusion of drm.h in r128_drm.h
Date: Mon, 30 Nov 2015 15:10:52 +0100
Message-ID: <1448892658-14256-15-git-send-email-gabriel@lse.epita.fr>
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
aWtpLmZpPgoKLS0tCiBpbmNsdWRlL3VhcGkvZHJtL3IxMjhfZHJtLmggfCAyICstCiAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9pbmNs
dWRlL3VhcGkvZHJtL3IxMjhfZHJtLmggYi9pbmNsdWRlL3VhcGkvZHJtL3IxMjhfZHJtLmgKaW5k
ZXggNzZiMGFhMy4uN2E0NGM2NSAxMDA2NDQKLS0tIGEvaW5jbHVkZS91YXBpL2RybS9yMTI4X2Ry
bS5oCisrKyBiL2luY2x1ZGUvdWFwaS9kcm0vcjEyOF9kcm0uaApAQCAtMzMsNyArMzMsNyBAQAog
I2lmbmRlZiBfX1IxMjhfRFJNX0hfXwogI2RlZmluZSBfX1IxMjhfRFJNX0hfXwogCi0jaW5jbHVk
ZSA8ZHJtL2RybS5oPgorI2luY2x1ZGUgImRybS5oIgogCiAvKiBXQVJOSU5HOiBJZiB5b3UgY2hh
bmdlIGFueSBvZiB0aGVzZSBkZWZpbmVzLCBtYWtlIHN1cmUgdG8gY2hhbmdlIHRoZQogICogZGVm
aW5lcyBpbiB0aGUgWCBzZXJ2ZXIgZmlsZSAocjEyOF9zYXJlYS5oKQotLSAKMi42LjIKCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmRyaS1kZXZlbCBtYWls
aW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwOi8vbGlzdHMuZnJl
ZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==
