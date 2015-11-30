From: Gabriel Laskar <gabriel@lse.epita.fr>
Subject: [PATCH 13/20] drm: fix inclusion of drm.h in qxl_drm.h
Date: Mon, 30 Nov 2015 15:10:51 +0100
Message-ID: <1448892658-14256-14-git-send-email-gabriel@lse.epita.fr>
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
aWtpLmZpPgoKLS0tCiBpbmNsdWRlL3VhcGkvZHJtL3F4bF9kcm0uaCB8IDMgKy0tCiAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvaW5j
bHVkZS91YXBpL2RybS9xeGxfZHJtLmggYi9pbmNsdWRlL3VhcGkvZHJtL3F4bF9kcm0uaAppbmRl
eCBlYmViZDM2Li40Mzg3YjU3IDEwMDY0NAotLS0gYS9pbmNsdWRlL3VhcGkvZHJtL3F4bF9kcm0u
aAorKysgYi9pbmNsdWRlL3VhcGkvZHJtL3F4bF9kcm0uaApAQCAtMjQsOCArMjQsNyBAQAogI2lm
bmRlZiBRWExfRFJNX0gKICNkZWZpbmUgUVhMX0RSTV9ICiAKLSNpbmNsdWRlIDxzdGRkZWYuaD4K
LSNpbmNsdWRlICJkcm0vZHJtLmgiCisjaW5jbHVkZSAiZHJtLmgiCiAKIC8qIFBsZWFzZSBub3Rl
IHRoYXQgbW9kaWZpY2F0aW9ucyB0byBhbGwgc3RydWN0cyBkZWZpbmVkIGhlcmUgYXJlCiAgKiBz
dWJqZWN0IHRvIGJhY2t3YXJkcy1jb21wYXRpYmlsaXR5IGNvbnN0cmFpbnRzLgotLSAKMi42LjIK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmRyaS1kZXZl
bCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwOi8vbGlz
dHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==
