From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v4 1/2] staging: ion: simplify ioctl args checking function
Date: Tue, 26 Sep 2017 14:07:04 +0200
Message-ID: <1506427625-19202-2-git-send-email-benjamin.gaignard@linaro.org>
References: <1506427625-19202-1-git-send-email-benjamin.gaignard@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <1506427625-19202-1-git-send-email-benjamin.gaignard@linaro.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: labbott@redhat.com, sumit.semwal@linaro.org, gregkh@linuxfoundation.org, arve@android.com, riandrews@android.com, broonie@kernel.org, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
List-Id: linux-api@vger.kernel.org

TWFrZSBhcmd1bWVudHMgY2hlY2tpbmcgbW9yZSBlYXN5IHRvIHJlYWQuCgpTaWduZWQtb2ZmLWJ5
OiBCZW5qYW1pbiBHYWlnbmFyZCA8YmVuamFtaW4uZ2FpZ25hcmRAbGluYXJvLm9yZz4KLS0tCiBk
cml2ZXJzL3N0YWdpbmcvYW5kcm9pZC9pb24vaW9uLWlvY3RsLmMgfCAxMSArKysrKy0tLS0tLQog
MSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvYW5kcm9pZC9pb24vaW9uLWlvY3RsLmMgYi9kcml2ZXJzL3N0
YWdpbmcvYW5kcm9pZC9pb24vaW9uLWlvY3RsLmMKaW5kZXggZDlmOGIxNC4uZTI2Yjc4NiAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL2FuZHJvaWQvaW9uL2lvbi1pb2N0bC5jCisrKyBiL2Ry
aXZlcnMvc3RhZ2luZy9hbmRyb2lkL2lvbi9pb24taW9jdGwuYwpAQCAtMjcsMTkgKzI3LDE4IEBA
IHVuaW9uIGlvbl9pb2N0bF9hcmcgewogCiBzdGF0aWMgaW50IHZhbGlkYXRlX2lvY3RsX2FyZyh1
bnNpZ25lZCBpbnQgY21kLCB1bmlvbiBpb25faW9jdGxfYXJnICphcmcpCiB7Ci0JaW50IHJldCA9
IDA7Ci0KIAlzd2l0Y2ggKGNtZCkgewogCWNhc2UgSU9OX0lPQ19IRUFQX1FVRVJZOgotCQlyZXQg
PSBhcmctPnF1ZXJ5LnJlc2VydmVkMCAhPSAwOwotCQlyZXQgfD0gYXJnLT5xdWVyeS5yZXNlcnZl
ZDEgIT0gMDsKLQkJcmV0IHw9IGFyZy0+cXVlcnkucmVzZXJ2ZWQyICE9IDA7CisJCWlmIChhcmct
PnF1ZXJ5LnJlc2VydmVkMCB8fAorCQkgICAgYXJnLT5xdWVyeS5yZXNlcnZlZDEgfHwKKwkJICAg
IGFyZy0+cXVlcnkucmVzZXJ2ZWQyICkKKwkJCXJldHVybiAtRUlOVkFMOwogCQlicmVhazsKIAlk
ZWZhdWx0OgogCQlicmVhazsKIAl9CiAKLQlyZXR1cm4gcmV0ID8gLUVJTlZBTCA6IDA7CisJcmV0
dXJuIDA7CiB9CiAKIC8qIGZpeCB1cCB0aGUgY2FzZXMgd2hlcmUgdGhlIGlvY3RsIGRpcmVjdGlv
biBiaXRzIGFyZSBpbmNvcnJlY3QgKi8KLS0gCjIuNy40CgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZl
bEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFp
bG1hbi9saXN0aW5mby9kcmktZGV2ZWwK
