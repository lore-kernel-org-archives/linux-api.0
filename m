From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v06 25/36] uapi linux/android/binder.h: use __kernel_pid_t and
 __kernel_uid_t
Date: Sun,  6 Aug 2017 18:44:16 +0200
Message-ID: <20170806164428.2273-26-mikko.rapeli@iki.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170806164428.2273-1-mikko.rapeli@iki.fi>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: devel@driverdev.osuosl.org, Todd Kjos <tkjos@android.com>, Mikko Rapeli <mikko.rapeli@iki.fi>, Riley Andrews <riandrews@android.com>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, Martijn Coenen <maco@google.com>, John Stultz <john.stultz@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

Rml4ZXMgdXNlcnNwYWNlIGNvbXBpbGF0aW9uIGVycm9yczoKCmVycm9yOiB1bmtub3duIHR5cGUg
bmFtZSDigJhwaWRfdOKAmQogIHBpZF90ICBzZW5kZXJfcGlkCmVycm9yOiB1bmtub3duIHR5cGUg
bmFtZSDigJh1aWRfdOKAmQogIHVpZF90ICBzZW5kZXJfZXVpZDsKClNpZ25lZC1vZmYtYnk6IE1p
a2tvIFJhcGVsaSA8bWlra28ucmFwZWxpQGlraS5maT4KQ2M6IEdyZWcgS3JvYWgtSGFydG1hbiA8
Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+CkNjOiBBcnZlIEhqw7hubmV2w6VnIDxhcnZlQGFu
ZHJvaWQuY29tPgpDYzogUmlsZXkgQW5kcmV3cyA8cmlhbmRyZXdzQGFuZHJvaWQuY29tPgpDYzog
VG9kZCBLam9zIDx0a2pvc0BhbmRyb2lkLmNvbT4KQ2M6IE1hcnRpam4gQ29lbmVuIDxtYWNvQGdv
b2dsZS5jb20+CkNjOiBkZXZlbEBkcml2ZXJkZXYub3N1b3NsLm9yZwotLS0KIGluY2x1ZGUvdWFw
aS9saW51eC9hbmRyb2lkL2JpbmRlci5oIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNl
cnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51
eC9hbmRyb2lkL2JpbmRlci5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L2FuZHJvaWQvYmluZGVyLmgK
aW5kZXggNTFmODkxZmIxYjE4Li40ZjcyNDc3MjJhZDYgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvdWFw
aS9saW51eC9hbmRyb2lkL2JpbmRlci5oCisrKyBiL2luY2x1ZGUvdWFwaS9saW51eC9hbmRyb2lk
L2JpbmRlci5oCkBAIC0yMjksOCArMjI5LDggQEAgc3RydWN0IGJpbmRlcl90cmFuc2FjdGlvbl9k
YXRhIHsKIAogCS8qIEdlbmVyYWwgaW5mb3JtYXRpb24gYWJvdXQgdGhlIHRyYW5zYWN0aW9uLiAq
LwogCV9fdTMyCSAgICAgICAgZmxhZ3M7Ci0JcGlkX3QJCXNlbmRlcl9waWQ7Ci0JdWlkX3QJCXNl
bmRlcl9ldWlkOworCV9fa2VybmVsX3BpZF90CQlzZW5kZXJfcGlkOworCV9fa2VybmVsX3VpZF90
CQlzZW5kZXJfZXVpZDsKIAliaW5kZXJfc2l6ZV90CWRhdGFfc2l6ZTsJLyogbnVtYmVyIG9mIGJ5
dGVzIG9mIGRhdGEgKi8KIAliaW5kZXJfc2l6ZV90CW9mZnNldHNfc2l6ZTsJLyogbnVtYmVyIG9m
IGJ5dGVzIG9mIG9mZnNldHMgKi8KIAotLSAKMi4xMy4zCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpkZXZlbCBtYWlsaW5nIGxpc3QKZGV2ZWxAbGludXhk
cml2ZXJwcm9qZWN0Lm9yZwpodHRwOi8vZHJpdmVyZGV2LmxpbnV4ZHJpdmVycHJvamVjdC5vcmcv
bWFpbG1hbi9saXN0aW5mby9kcml2ZXJkZXYtZGV2ZWwK
