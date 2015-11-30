From: Gabriel Laskar <gabriel@lse.epita.fr>
Subject: [PATCH 12/20] drm: fix inclusion of drm.h in omap_drm.h
Date: Mon, 30 Nov 2015 15:10:50 +0100
Message-ID: <1448892658-14256-13-git-send-email-gabriel@lse.epita.fr>
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
aWtpLmZpPgoKLS0tCiBpbmNsdWRlL3VhcGkvZHJtL29tYXBfZHJtLmggfCAyICstCiAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9pbmNs
dWRlL3VhcGkvZHJtL29tYXBfZHJtLmggYi9pbmNsdWRlL3VhcGkvZHJtL29tYXBfZHJtLmgKaW5k
ZXggMWQwYjExNy4uMDc1MGMwMSAxMDA2NDQKLS0tIGEvaW5jbHVkZS91YXBpL2RybS9vbWFwX2Ry
bS5oCisrKyBiL2luY2x1ZGUvdWFwaS9kcm0vb21hcF9kcm0uaApAQCAtMjAsNyArMjAsNyBAQAog
I2lmbmRlZiBfX09NQVBfRFJNX0hfXwogI2RlZmluZSBfX09NQVBfRFJNX0hfXwogCi0jaW5jbHVk
ZSA8ZHJtL2RybS5oPgorI2luY2x1ZGUgImRybS5oIgogCiAvKiBQbGVhc2Ugbm90ZSB0aGF0IG1v
ZGlmaWNhdGlvbnMgdG8gYWxsIHN0cnVjdHMgZGVmaW5lZCBoZXJlIGFyZQogICogc3ViamVjdCB0
byBiYWNrd2FyZHMtY29tcGF0aWJpbGl0eSBjb25zdHJhaW50cy4KLS0gCjIuNi4yCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGlu
ZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cDovL2xpc3RzLmZyZWVk
ZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbAo=
