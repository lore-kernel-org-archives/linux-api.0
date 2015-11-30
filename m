From: Gabriel Laskar <gabriel@lse.epita.fr>
Subject: [PATCH 17/20] drm: fix inclusion of drm.h in virtgpu_drm.h
Date: Mon, 30 Nov 2015 15:10:55 +0100
Message-ID: <1448892658-14256-18-git-send-email-gabriel@lse.epita.fr>
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
aWtpLmZpPgoKLS0tCiBpbmNsdWRlL3VhcGkvZHJtL3ZpcnRncHVfZHJtLmggfCAzICstLQogMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2luY2x1ZGUvdWFwaS9kcm0vdmlydGdwdV9kcm0uaCBiL2luY2x1ZGUvdWFwaS9kcm0vdmlydGdw
dV9kcm0uaAppbmRleCA0YmNmYmU2Li5jNzRmMWY5IDEwMDY0NAotLS0gYS9pbmNsdWRlL3VhcGkv
ZHJtL3ZpcnRncHVfZHJtLmgKKysrIGIvaW5jbHVkZS91YXBpL2RybS92aXJ0Z3B1X2RybS5oCkBA
IC0yNCw4ICsyNCw3IEBACiAjaWZuZGVmIFZJUlRHUFVfRFJNX0gKICNkZWZpbmUgVklSVEdQVV9E
Uk1fSAogCi0jaW5jbHVkZSA8c3RkZGVmLmg+Ci0jaW5jbHVkZSAiZHJtL2RybS5oIgorI2luY2x1
ZGUgImRybS5oIgogCiAvKiBQbGVhc2Ugbm90ZSB0aGF0IG1vZGlmaWNhdGlvbnMgdG8gYWxsIHN0
cnVjdHMgZGVmaW5lZCBoZXJlIGFyZQogICogc3ViamVjdCB0byBiYWNrd2FyZHMtY29tcGF0aWJp
bGl0eSBjb25zdHJhaW50cy4KLS0gCjIuNi4yCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0
cy5mcmVlZGVza3RvcC5vcmcKaHR0cDovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xp
c3RpbmZvL2RyaS1kZXZlbAo=
