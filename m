From: Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH v2 4/4] drm/tegra: Allow non-authenticated processes to create
 buffer objects
Date: Fri, 27 Jun 2014 10:28:26 +0200
Message-ID: <1403857706-15989-4-git-send-email-thierry.reding@gmail.com>
References: <1403857706-15989-1-git-send-email-thierry.reding@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <1403857706-15989-1-git-send-email-thierry.reding@gmail.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

RnJvbTogVGhpZXJyeSBSZWRpbmcgPHRyZWRpbmdAbnZpZGlhLmNvbT4KClRoaXMgbWF0Y2hlcyB3
aGF0IG90aGVyIGRyaXZlcnMgZG8gZm9yIGVxdWl2YWxlbnQgSU9DVExzLgoKUmV2aWV3ZWQtYnk6
IFN0w6lwaGFuZSBNYXJjaGVzaW4gPG1hcmNoZXVAY2hyb21pdW0ub3JnPgpTaWduZWQtb2ZmLWJ5
OiBUaGllcnJ5IFJlZGluZyA8dHJlZGluZ0BudmlkaWEuY29tPgotLS0KQ2hhbmdlcyBpbiB2MjoK
LSBub25lCgogZHJpdmVycy9ncHUvZHJtL3RlZ3JhL2RybS5jIHwgMiArLQogMSBmaWxlIGNoYW5n
ZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9n
cHUvZHJtL3RlZ3JhL2RybS5jIGIvZHJpdmVycy9ncHUvZHJtL3RlZ3JhL2RybS5jCmluZGV4IDZl
MmU3MTRhMDY0OS4uNWNiYTVlNzM2MTMwIDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vdGVn
cmEvZHJtLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL3RlZ3JhL2RybS5jCkBAIC01OTksNyArNTk5
LDcgQEAgc3RhdGljIGludCB0ZWdyYV9nZW1fZ2V0X2ZsYWdzKHN0cnVjdCBkcm1fZGV2aWNlICpk
cm0sIHZvaWQgKmRhdGEsCiAKIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZHJtX2lvY3RsX2Rlc2MgdGVn
cmFfZHJtX2lvY3Rsc1tdID0gewogI2lmZGVmIENPTkZJR19EUk1fVEVHUkFfU1RBR0lORwotCURS
TV9JT0NUTF9ERUZfRFJWKFRFR1JBX0dFTV9DUkVBVEUsIHRlZ3JhX2dlbV9jcmVhdGUsIERSTV9V
TkxPQ0tFRCB8IERSTV9BVVRIKSwKKwlEUk1fSU9DVExfREVGX0RSVihURUdSQV9HRU1fQ1JFQVRF
LCB0ZWdyYV9nZW1fY3JlYXRlLCBEUk1fVU5MT0NLRUQpLAogCURSTV9JT0NUTF9ERUZfRFJWKFRF
R1JBX0dFTV9NTUFQLCB0ZWdyYV9nZW1fbW1hcCwgRFJNX1VOTE9DS0VEKSwKIAlEUk1fSU9DVExf
REVGX0RSVihURUdSQV9TWU5DUFRfUkVBRCwgdGVncmFfc3luY3B0X3JlYWQsIERSTV9VTkxPQ0tF
RCksCiAJRFJNX0lPQ1RMX0RFRl9EUlYoVEVHUkFfU1lOQ1BUX0lOQ1IsIHRlZ3JhX3N5bmNwdF9p
bmNyLCBEUk1fVU5MT0NLRUQpLAotLSAKMi4wLjAKCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxp
c3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4v
bGlzdGluZm8vZHJpLWRldmVsCg==
