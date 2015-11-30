From: Gabriel Laskar <gabriel@lse.epita.fr>
Subject: [PATCH 07/20] drm: fix inclusion of drm.h in exynos_sarea.h
Date: Mon, 30 Nov 2015 15:10:45 +0100
Message-ID: <1448892658-14256-8-git-send-email-gabriel@lse.epita.fr>
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
To: Inki Dae <inki.dae@samsung.com>, Joonyoung Shim <jy0922.shim@samsung.com>, Seung-Woo Kim <sw0312.kim@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>, David Airlie <airlied@linux.ie>, Kukjin Kim <kgene@kernel.org>, Krzysztof Kozlowski <k.kozlowski@samsung.com>, "open list:DRM DRIVERS FOR EXYNOS" <dri-devel@lists.freedesktop.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, "moderated list:ARM/SAMSUNG EXYNOS ARM
 ARCHITECTURES" <linux-arm-kernel@lists.infradead.org>, "moderated list:ARM/SAMSUNG EXYNOS ARM
 ARCHITECTURES" <linux-samsung-soc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Emil Velikov <emil.l.velikov@gmail.com>
List-Id: linux-api@vger.kernel.org

VXNpbmcgYCNpbmNsdWRlICJkcm0uaCJgIGluc3RlYWQgb2YgYCNpbmNsdWRlIDxkcm0vZHJtLmg+
YCBhbGxvdyBkcm0KaGVhZGVycyB0byBiZSBtb3ZlZCBpbiBhbm90aGVyIGRpcmVjdG9yeSB3aXRo
b3V0IGNoYW5nZXMsIGxpa2UgZm9yIHRoZQpsaWJkcm0gaW1wb3J0cy4KClNpZ25lZC1vZmYtYnk6
IEdhYnJpZWwgTGFza2FyIDxnYWJyaWVsQGxzZS5lcGl0YS5mcj4KQ0M6IEVtaWwgVmVsaWtvdiA8
ZW1pbC5sLnZlbGlrb3ZAZ21haWwuY29tPgpDQzogTWlra28gUmFwZWxpIDxtaWtrby5yYXBlbGlA
aWtpLmZpPgoKLS0tCiBpbmNsdWRlL3VhcGkvZHJtL2V4eW5vc19kcm0uaCB8IDIgKy0KIDEgZmls
ZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvdWFwaS9kcm0vZXh5bm9zX2RybS5oIGIvaW5jbHVkZS91YXBpL2RybS9leHlub3NfZHJt
LmgKaW5kZXggNTU3NWVkMS4uYTViMmRkOSAxMDA2NDQKLS0tIGEvaW5jbHVkZS91YXBpL2RybS9l
eHlub3NfZHJtLmgKKysrIGIvaW5jbHVkZS91YXBpL2RybS9leHlub3NfZHJtLmgKQEAgLTE1LDcg
KzE1LDcgQEAKICNpZm5kZWYgX1VBUElfRVhZTk9TX0RSTV9IXwogI2RlZmluZSBfVUFQSV9FWFlO
T1NfRFJNX0hfCiAKLSNpbmNsdWRlIDxkcm0vZHJtLmg+CisjaW5jbHVkZSAiZHJtLmgiCiAKIC8q
KgogICogVXNlci1kZXNpcmVkIGJ1ZmZlciBjcmVhdGlvbiBpbmZvcm1hdGlvbiBzdHJ1Y3R1cmUu
Ci0tIAoyLjYuMgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3Jn
Cmh0dHA6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWwK
