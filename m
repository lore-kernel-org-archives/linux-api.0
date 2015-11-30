From: Gabriel Laskar <gabriel@lse.epita.fr>
Subject: [PATCH 08/20] drm: fix inclusion of drm.h in i810_drm.h
Date: Mon, 30 Nov 2015 15:10:46 +0100
Message-ID: <1448892658-14256-9-git-send-email-gabriel@lse.epita.fr>
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
b3V0IGNoYW5nZXMsIGxpa2UgZm9yCnRoZSBsaWJkcm0gaW1wb3J0cy4KClNpZ25lZC1vZmYtYnk6
IEdhYnJpZWwgTGFza2FyIDxnYWJyaWVsQGxzZS5lcGl0YS5mcj4KQ0M6IEVtaWwgVmVsaWtvdiA8
ZW1pbC5sLnZlbGlrb3ZAZ21haWwuY29tPgpDQzogTWlra28gUmFwZWxpIDxtaWtrby5yYXBlbGlA
aWtpLmZpPgoKLS0tCiBpbmNsdWRlL3VhcGkvZHJtL2k4MTBfZHJtLmggfCAyICstCiAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9pbmNs
dWRlL3VhcGkvZHJtL2k4MTBfZHJtLmggYi9pbmNsdWRlL3VhcGkvZHJtL2k4MTBfZHJtLmgKaW5k
ZXggMzQ3MzZlZi4uYmRiMDI4NyAxMDA2NDQKLS0tIGEvaW5jbHVkZS91YXBpL2RybS9pODEwX2Ry
bS5oCisrKyBiL2luY2x1ZGUvdWFwaS9kcm0vaTgxMF9kcm0uaApAQCAtMSw3ICsxLDcgQEAKICNp
Zm5kZWYgX0k4MTBfRFJNX0hfCiAjZGVmaW5lIF9JODEwX0RSTV9IXwogCi0jaW5jbHVkZSA8ZHJt
L2RybS5oPgorI2luY2x1ZGUgImRybS5oIgogCiAvKiBXQVJOSU5HOiBUaGVzZSBkZWZpbmVzIG11
c3QgYmUgdGhlIHNhbWUgYXMgd2hhdCB0aGUgWHNlcnZlciB1c2VzLgogICogaWYgeW91IGNoYW5n
ZSB0aGVtLCB5b3UgbXVzdCBjaGFuZ2UgdGhlIGRlZmluZXMgaW4gdGhlIFhzZXJ2ZXIuCi0tIAoy
LjYuMgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJp
LWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHA6
Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWwK
