From: Laura Abbott <labbott@redhat.com>
Subject: Re: [PATCH v6 1/2] staging: ion: reorder include
Date: Thu, 9 Nov 2017 13:02:59 -0800
Message-ID: <42b0c9ca-36f2-4437-a50b-fdec984ea78c@redhat.com>
References: <1509983985-20950-1-git-send-email-benjamin.gaignard@linaro.org>
 <1509983985-20950-2-git-send-email-benjamin.gaignard@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <1509983985-20950-2-git-send-email-benjamin.gaignard@linaro.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>, sumit.semwal@linaro.org, gregkh@linuxfoundation.org, arve@android.com, riandrews@android.com, broonie@kernel.org, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
List-Id: linux-api@vger.kernel.org

T24gMTEvMDYvMjAxNyAwNzo1OSBBTSwgQmVuamFtaW4gR2FpZ25hcmQgd3JvdGU6Cj4gUHV0IGlu
Y2x1ZGUgaW4gYWxwaGFiZXRpYyBvcmRlcgo+IAoKQWNrZWQtYnk6IExhdXJhIEFiYm90dCA8bGFi
Ym90dEByZWRoYXQuY29tPgoKPiBTaWduZWQtb2ZmLWJ5OiBCZW5qYW1pbiBHYWlnbmFyZCA8YmVu
amFtaW4uZ2FpZ25hcmRAbGluYXJvLm9yZz4KPiAtLS0KPiAgIGRyaXZlcnMvc3RhZ2luZy9hbmRy
b2lkL2lvbi9pb24uYyB8IDE0ICsrKysrKystLS0tLS0tCj4gICAxIGZpbGUgY2hhbmdlZCwgNyBp
bnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3N0
YWdpbmcvYW5kcm9pZC9pb24vaW9uLmMgYi9kcml2ZXJzL3N0YWdpbmcvYW5kcm9pZC9pb24vaW9u
LmMKPiBpbmRleCBhN2Q5YjBlLi5mZGE5NzU2IDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvc3RhZ2lu
Zy9hbmRyb2lkL2lvbi9pb24uYwo+ICsrKyBiL2RyaXZlcnMvc3RhZ2luZy9hbmRyb2lkL2lvbi9p
b24uYwo+IEBAIC0xNSwyOCArMTUsMjggQEAKPiAgICAqCj4gICAgKi8KPiAgIAo+ICsjaW5jbHVk
ZSA8bGludXgvYW5vbl9pbm9kZXMuaD4KPiArI2luY2x1ZGUgPGxpbnV4L2RlYnVnZnMuaD4KPiAg
ICNpbmNsdWRlIDxsaW51eC9kZXZpY2UuaD4KPiArI2luY2x1ZGUgPGxpbnV4L2RtYS1idWYuaD4K
PiAgICNpbmNsdWRlIDxsaW51eC9lcnIuaD4KPiArI2luY2x1ZGUgPGxpbnV4L2V4cG9ydC5oPgo+
ICAgI2luY2x1ZGUgPGxpbnV4L2ZpbGUuaD4KPiAgICNpbmNsdWRlIDxsaW51eC9mcmVlemVyLmg+
Cj4gICAjaW5jbHVkZSA8bGludXgvZnMuaD4KPiAtI2luY2x1ZGUgPGxpbnV4L2Fub25faW5vZGVz
Lmg+Cj4gKyNpbmNsdWRlIDxsaW51eC9pZHIuaD4KPiAgICNpbmNsdWRlIDxsaW51eC9rdGhyZWFk
Lmg+Cj4gICAjaW5jbHVkZSA8bGludXgvbGlzdC5oPgo+ICAgI2luY2x1ZGUgPGxpbnV4L21lbWJs
b2NrLmg+Cj4gICAjaW5jbHVkZSA8bGludXgvbWlzY2RldmljZS5oPgo+IC0jaW5jbHVkZSA8bGlu
dXgvZXhwb3J0Lmg+Cj4gICAjaW5jbHVkZSA8bGludXgvbW0uaD4KPiAgICNpbmNsdWRlIDxsaW51
eC9tbV90eXBlcy5oPgo+ICAgI2luY2x1ZGUgPGxpbnV4L3JidHJlZS5oPgo+IC0jaW5jbHVkZSA8
bGludXgvc2xhYi5oPgo+ICsjaW5jbHVkZSA8bGludXgvc2NoZWQvdGFzay5oPgo+ICAgI2luY2x1
ZGUgPGxpbnV4L3NlcV9maWxlLmg+Cj4gKyNpbmNsdWRlIDxsaW51eC9zbGFiLmg+Cj4gICAjaW5j
bHVkZSA8bGludXgvdWFjY2Vzcy5oPgo+ICAgI2luY2x1ZGUgPGxpbnV4L3ZtYWxsb2MuaD4KPiAt
I2luY2x1ZGUgPGxpbnV4L2RlYnVnZnMuaD4KPiAtI2luY2x1ZGUgPGxpbnV4L2RtYS1idWYuaD4K
PiAtI2luY2x1ZGUgPGxpbnV4L2lkci5oPgo+IC0jaW5jbHVkZSA8bGludXgvc2NoZWQvdGFzay5o
Pgo+ICAgCj4gICAjaW5jbHVkZSAiaW9uLmgiCj4gICAKPiAKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRl
dmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9t
YWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbAo=
