From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 05/79] exynos_drm.h: use __u64 from linux/types.h
Date: Thu, 15 Oct 2015 07:55:43 +0200
Message-ID: <1444888618-4506-6-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, linux-samsung-soc@vger.kernel.org, Joonyoung Shim <jy0922.shim@samsung.com>, David Airlie <airlied@linux.ie>, mikko.rapeli@iki.fi, Seung-Woo Kim <sw0312.kim@samsung.com>, dri-devel@lists.freedesktop.org, Inki Dae <inki.dae@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>, Kukjin Kim <kgene@kernel.org>, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

Rml4ZXMgdXNlcnNwYWNlIGNvbXBpbGF0aW9uIGVycm9yOgoKZHJtL2V4eW5vc19kcm0uaDozMDoy
OiBlcnJvcjogdW5rbm93biB0eXBlIG5hbWUg4oCYdWludDY0X3TigJkKClNpZ25lZC1vZmYtYnk6
IE1pa2tvIFJhcGVsaSA8bWlra28ucmFwZWxpQGlraS5maT4KLS0tCiBpbmNsdWRlL3VhcGkvZHJt
L2V4eW5vc19kcm0uaCB8IDYgKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCsp
LCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9kcm0vZXh5bm9zX2Ry
bS5oIGIvaW5jbHVkZS91YXBpL2RybS9leHlub3NfZHJtLmgKaW5kZXggNTU3NWVkMS4uY2Y0MzFi
NyAxMDA2NDQKLS0tIGEvaW5jbHVkZS91YXBpL2RybS9leHlub3NfZHJtLmgKKysrIGIvaW5jbHVk
ZS91YXBpL2RybS9leHlub3NfZHJtLmgKQEAgLTI3LDcgKzI3LDcgQEAKICAqCS0gdGhpcyBoYW5k
bGUgd2lsbCBiZSBzZXQgYnkgZ2VtIG1vZHVsZSBvZiBrZXJuZWwgc2lkZS4KICAqLwogc3RydWN0
IGRybV9leHlub3NfZ2VtX2NyZWF0ZSB7Ci0JdWludDY0X3Qgc2l6ZTsKKwlfX3U2NCBzaXplOwog
CXVuc2lnbmVkIGludCBmbGFnczsKIAl1bnNpZ25lZCBpbnQgaGFuZGxlOwogfTsKQEAgLTQ0LDcg
KzQ0LDcgQEAgc3RydWN0IGRybV9leHlub3NfZ2VtX2NyZWF0ZSB7CiBzdHJ1Y3QgZHJtX2V4eW5v
c19nZW1faW5mbyB7CiAJdW5zaWduZWQgaW50IGhhbmRsZTsKIAl1bnNpZ25lZCBpbnQgZmxhZ3M7
Ci0JdWludDY0X3Qgc2l6ZTsKKwlfX3U2NCBzaXplOwogfTsKIAogLyoqCkBAIC01OCw3ICs1OCw3
IEBAIHN0cnVjdCBkcm1fZXh5bm9zX2dlbV9pbmZvIHsKIHN0cnVjdCBkcm1fZXh5bm9zX3ZpZGlf
Y29ubmVjdGlvbiB7CiAJdW5zaWduZWQgaW50IGNvbm5lY3Rpb247CiAJdW5zaWduZWQgaW50IGV4
dGVuc2lvbnM7Ci0JdWludDY0X3QgZWRpZDsKKwlfX3U2NCBlZGlkOwogfTsKIAogLyogbWVtb3J5
IHR5cGUgZGVmaW5pdGlvbnMuICovCi0tIAoyLjUuMAoKCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCmxpbnV4LWFybS1rZXJuZWwgbWFpbGluZyBsaXN0Cmxp
bnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZwpodHRwOi8vbGlzdHMuaW5mcmFkZWFk
Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LWFybS1rZXJuZWwK
