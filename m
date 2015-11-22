From: Yakir Yang <ykk@rock-chips.com>
Subject: [RFC PATCH v1 0/2] Add basic HDCP function support for dw_hdmi driver
Date: Sun, 22 Nov 2015 21:31:17 +0800
Message-ID: <1448199077-10221-1-git-send-email-ykk@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Russell King <rmk+kernel@arm.linux.org.uk>, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, Thierry Reding <treding@nvidia.com>, Philipp Zabel <p.zabel@pengutronix.de>, Andy Yan <andy.yan@rock-chips.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rockchip@lists.infradead.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

SGksCgpUaGlzIHNlcmllcyB0cnkgdG8gYWRkIHRoZSBiYXNpYyBIRENQIGZ1bmN0aW9uIHN1cHBv
cnQgZm9yIGJyaWRnZQpkd19oZG1pIGRyaXZlci4gQmVzaWRlIHRoaXMgc2VyaWVzIGFsc28gcmVz
ZW5kIHRoZSBwYXRjaCBmcm9tIFNlYW4KUGF1bCB0aGF0IHRyeSB0byBpbnRyb2R1Y2UgYSBjb21t
b24gd2F5IGZvciB1c2Vyc3BhY2UgdG8gb3BlcmF0ZQp0aGUgSERDUCBmdW5jdGlvbi4KClVzZXJz
cGFjZSBjb3VsZCBjaG9zZSB0byBlbmFibGUvZGlzYWJsZSB0aGUgSERDUCBmdW5jdGlvbiB0aHJv
dWdodAp0aGUgbmV3IHN0YW5kYXJkIHByb3BlcnRpZXMgIkNvbnRlbnQgUHJvdGVjdGlvbiIsIGFu
ZCBkcml2ZXIgd291bGQKcmVmbGVjdCB0aGUgSERDUCBhdXRoIHN0YXR1cyB0byAiQ29udGVudCBQ
cm90ZWN0aW9uIEtTViIgcHJvcGVydHkuCgpCZXNpZGUgdGhpcyBzZXJpZXMgYWxzbyBiYXNlIG9u
IFZsYWRpbWlyIFphcG9sc2tpeSdzIHBhdGNoIHRoYXQgaGVscAp0byBpbnRyb2R1Y2UgRERDIHN1
cHBvcnQgZm9yIGR3X2hkbWkgZHJpdmVyLgoKW1Jlc2VuZF0gU2VhbiBQdWFsOiBodHRwczovL3Bh
dGNod29yay5rZXJuZWwub3JnL3BhdGNoLzcyNzk4MDEKW1JlYmFzZWQgb25dIFZsYWRpbWlyIFph
cG9sc2tpeTogaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wYXRjaC83Mjc5ODAxCgpUaGFu
a3MKLSBZYWtpcgoKCgpTZWFuIFBhdWwgKDEpOgogIGRybTogQWRkIENvbnRlbnQgUHJvdGVjdGlv
biBwcm9wZXJ0aWVzIHRvIGRybQoKWWFraXIgWWFuZyAoMSk6CiAgZHJtOiBicmlkZ3cvZHdfaGRt
aTogYWRkIGJhc2ljIGhkbWkgaGRjcCBkcml2ZXIKCiBkcml2ZXJzL2dwdS9kcm0vYnJpZGdlL2R3
X2hkbWkuYyB8IDM1NSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0KIGRy
aXZlcnMvZ3B1L2RybS9icmlkZ2UvZHdfaGRtaS5oIHwgIDIwICsrKwogZHJpdmVycy9ncHUvZHJt
L2RybV9jcnRjLmMgICAgICAgfCAgMjEgKysrCiBkcml2ZXJzL2dwdS9kcm0vZHJtX3N5c2ZzLmMg
ICAgICB8ICA0NiArKysrKwogaW5jbHVkZS9kcm0vYnJpZGdlL2R3X2hkbWkuaCAgICAgfCAgMTcg
KysKIGluY2x1ZGUvZHJtL2RybV9jcnRjLmggICAgICAgICAgIHwgICAzICsKIGluY2x1ZGUvdWFw
aS9kcm0vZHJtX21vZGUuaCAgICAgIHwgICA0ICsKIDcgZmlsZXMgY2hhbmdlZCwgNDQ3IGluc2Vy
dGlvbnMoKyksIDE5IGRlbGV0aW9ucygtKQoKLS0gCjEuOS4xCgoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmkt
ZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHA6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcv
bWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWwK
