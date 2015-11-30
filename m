From: Gabriel Laskar <gabriel@lse.epita.fr>
Subject: [PATCH 05/20] drm: drm_mode.h fix includes
Date: Mon, 30 Nov 2015 15:10:43 +0100
Message-ID: <1448892658-14256-6-git-send-email-gabriel@lse.epita.fr>
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

SW5zdGVhZCBvZiB1c2luZyBsaW51eC90eXBlcy5oLCBkcm0gaGVhZGVycyBzaG91bGQgdXNlIGRy
bS5oLCBpbiBvcmRlcgp0byBoYW5kbGUgdGhlIHBvcnRhYmlsaXR5IGlzc3VlcyBpbiBvbmx5IG9u
ZSBwbGFjZS4KClNpZ25lZC1vZmYtYnk6IEdhYnJpZWwgTGFza2FyIDxnYWJyaWVsQGxzZS5lcGl0
YS5mcj4KQ0M6IEVtaWwgVmVsaWtvdiA8ZW1pbC5sLnZlbGlrb3ZAZ21haWwuY29tPgpDQzogTWlr
a28gUmFwZWxpIDxtaWtrby5yYXBlbGlAaWtpLmZpPgoKLS0tCiBpbmNsdWRlL3VhcGkvZHJtL2Ry
bV9tb2RlLmggfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRp
b24oLSkKCmRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvZHJtL2RybV9tb2RlLmggYi9pbmNsdWRl
L3VhcGkvZHJtL2RybV9tb2RlLmgKaW5kZXggNmMxMWNhNC4uOWM5ZjYxZCAxMDA2NDQKLS0tIGEv
aW5jbHVkZS91YXBpL2RybS9kcm1fbW9kZS5oCisrKyBiL2luY2x1ZGUvdWFwaS9kcm0vZHJtX21v
ZGUuaApAQCAtMjcsNyArMjcsNyBAQAogI2lmbmRlZiBfRFJNX01PREVfSAogI2RlZmluZSBfRFJN
X01PREVfSAogCi0jaW5jbHVkZSA8bGludXgvdHlwZXMuaD4KKyNpbmNsdWRlICJkcm0uaCIKIAog
I2RlZmluZSBEUk1fRElTUExBWV9JTkZPX0xFTgkzMgogI2RlZmluZSBEUk1fQ09OTkVDVE9SX05B
TUVfTEVOCTMyCi0tIAoyLjYuMgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRl
c2t0b3Aub3JnCmh0dHA6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9k
cmktZGV2ZWwK
