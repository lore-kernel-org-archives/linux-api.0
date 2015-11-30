From: Gabriel Laskar <gabriel@lse.epita.fr>
Subject: [PATCH 18/20] drm: fix inclusion of drm.h in vmwgfx_drm.h
Date: Mon, 30 Nov 2015 15:10:56 +0100
Message-ID: <1448892658-14256-19-git-send-email-gabriel@lse.epita.fr>
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
aWtpLmZpPgoKLS0tCiBpbmNsdWRlL3VhcGkvZHJtL3Ztd2dmeF9kcm0uaCB8IDQgKy0tLQogMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2luY2x1ZGUvdWFwaS9kcm0vdm13Z2Z4X2RybS5oIGIvaW5jbHVkZS91YXBpL2RybS92bXdnZnhf
ZHJtLmgKaW5kZXggMDViMjA0OS4uMjQ1NDU0MyAxMDA2NDQKLS0tIGEvaW5jbHVkZS91YXBpL2Ry
bS92bXdnZnhfZHJtLmgKKysrIGIvaW5jbHVkZS91YXBpL2RybS92bXdnZnhfZHJtLmgKQEAgLTI4
LDkgKzI4LDcgQEAKICNpZm5kZWYgX19WTVdHRlhfRFJNX0hfXwogI2RlZmluZSBfX1ZNV0dGWF9E
Uk1fSF9fCiAKLSNpZm5kZWYgX19LRVJORUxfXwotI2luY2x1ZGUgPGRybS9kcm0uaD4KLSNlbmRp
ZgorI2luY2x1ZGUgImRybS5oIgogCiAjZGVmaW5lIERSTV9WTVdfTUFYX1NVUkZBQ0VfRkFDRVMg
NgogI2RlZmluZSBEUk1fVk1XX01BWF9NSVBfTEVWRUxTIDI0Ci0tIAoyLjYuMgoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcg
bGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHA6Ly9saXN0cy5mcmVlZGVz
a3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWwK
