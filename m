From: Gabriel Laskar <gabriel@lse.epita.fr>
Subject: [PATCH 16/20] drm: fix inclusion of drm.h in tegra_drm.h
Date: Mon, 30 Nov 2015 15:10:54 +0100
Message-ID: <1448892658-14256-17-git-send-email-gabriel@lse.epita.fr>
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
To: Thierry Reding <thierry.reding@gmail.com>, =?UTF-8?q?Terje=20Bergstr=C3=B6m?= <tbergstrom@nvidia.com>, David Airlie <airlied@linux.ie>, Stephen Warren <swarren@wwwdotorg.org>, Alexandre Courbot <gnurou@gmail.com>, "open list:DRM DRIVERS FOR NVIDIA TEGRA" <dri-devel@lists.freedesktop.org>, "open list:DRM DRIVERS FOR NVIDIA TEGRA" <linux-tegra@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Emil Velikov <emil.l.velikov@gmail.com>
List-Id: linux-api@vger.kernel.org

VXNpbmcgYCNpbmNsdWRlICJkcm0uaCJgIGluc3RlYWQgb2YgYCNpbmNsdWRlIDxkcm0vZHJtLmg+
YCBhbGxvdyBkcm0KaGVhZGVycyB0byBiZSBtb3ZlZCBpbiBhbm90aGVyIGRpcmVjdG9yeSB3aXRo
b3V0IGNoYW5nZXMsIGxpa2UgZm9yIHRoZQpsaWJkcm0gaW1wb3J0cy4KClNpZ25lZC1vZmYtYnk6
IEdhYnJpZWwgTGFza2FyIDxnYWJyaWVsQGxzZS5lcGl0YS5mcj4KQ0M6IEVtaWwgVmVsaWtvdiA8
ZW1pbC5sLnZlbGlrb3ZAZ21haWwuY29tPgpDQzogTWlra28gUmFwZWxpIDxtaWtrby5yYXBlbGlA
aWtpLmZpPgoKLS0tCiBpbmNsdWRlL3VhcGkvZHJtL3RlZ3JhX2RybS5oIHwgMiArLQogMSBmaWxl
IGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvaW5j
bHVkZS91YXBpL2RybS90ZWdyYV9kcm0uaCBiL2luY2x1ZGUvdWFwaS9kcm0vdGVncmFfZHJtLmgK
aW5kZXggNTM5MTc4MC4uMjdkMGIwNSAxMDA2NDQKLS0tIGEvaW5jbHVkZS91YXBpL2RybS90ZWdy
YV9kcm0uaAorKysgYi9pbmNsdWRlL3VhcGkvZHJtL3RlZ3JhX2RybS5oCkBAIC0yMyw3ICsyMyw3
IEBACiAjaWZuZGVmIF9VQVBJX1RFR1JBX0RSTV9IXwogI2RlZmluZSBfVUFQSV9URUdSQV9EUk1f
SF8KIAotI2luY2x1ZGUgPGRybS9kcm0uaD4KKyNpbmNsdWRlICJkcm0uaCIKIAogI2RlZmluZSBE
Uk1fVEVHUkFfR0VNX0NSRUFURV9USUxFRCAgICAgKDEgPDwgMCkKICNkZWZpbmUgRFJNX1RFR1JB
X0dFTV9DUkVBVEVfQk9UVE9NX1VQICgxIDw8IDEpCi0tIAoyLjYuMgoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApk
cmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHA6Ly9saXN0cy5mcmVlZGVza3RvcC5v
cmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWwK
