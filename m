From: Laura Abbott <labbott@redhat.com>
Subject: Re: [PATCH v6 2/2] staging: ion: create one device entry per heap
Date: Tue, 31 Oct 2017 12:45:25 -0700
Message-ID: <75c8c6ac-2f56-f477-8fcd-794504499111@redhat.com>
References: <1508774137-13835-1-git-send-email-benjamin.gaignard@linaro.org>
 <1508774137-13835-3-git-send-email-benjamin.gaignard@linaro.org>
 <3e3af8e3-76c5-754c-caaa-3f8c9b54723f@redhat.com>
 <20171031191153.avolosp6n5gb3xao@sirena.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20171031191153.avolosp6n5gb3xao@sirena.co.uk>
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
To: Mark Brown <broonie@kernel.org>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, arve@android.com, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, riandrews@android.com, linux-api@vger.kernel.org, dan.carpenter@oracle.com
List-Id: linux-api@vger.kernel.org

T24gMTAvMzEvMjAxNyAxMjoxMSBQTSwgTWFyayBCcm93biB3cm90ZToKPiBPbiBUdWUsIE9jdCAz
MSwgMjAxNyBhdCAxMjowMzozNVBNIC0wNzAwLCBMYXVyYSBBYmJvdHQgd3JvdGU6Cj4gCj4+IEkn
bSBub3QgYSBmYW4gb2YgdGhlIHBsYXRmb3JtIGJ1cyBidXQgSSBoYXZlIG1peGVkIGZlZWxpbmdz
IGFib3V0Cj4+IGNyZWF0aW5nIGEgZGVkaWNhdGVkIGJ1cyB0eXBlLiBJIGd1ZXNzIGlmIHdlIHJl
YWxseSBuZWVkIGEgYnVzCj4+IHR5cGUgd2UgY2FuIGRvIGl0IGxhdGVyPwo+IAo+IFRoZXJlIHdh
cyBhIGRpc2N1c3Npb24gYSB3aGlsZSBhZ28gaW4gdGhlIGNvbnRleHQgb2YgSTJDL1NQSSBNRkRz
Cj4gd2hpY2ggY29uY2x1ZGVkIHRoYXQgaWYgeW91IG5lZWQgYSBidXMgYW5kIGl0J3MgZ29pbmcg
dG8gYmUgZWZmZWN0aXZlbHkKPiBub29wIHRoZW4geW91IHNob3VsZCBqdXN0IHVzZSB0aGUgcGxh
dGZvcm0gYnVzIGFzIGFueXRoaW5nIGVsc2Ugd2lsbAo+IGNvbnNpc3QgYWxtb3N0IGVudGlyZWx5
IG9mIGN1dCduJ3Bhc3RlIGZyb20gdGhlIHBsYXRmb3JtIGJ1cyB3aXRoIHNvbWUKPiBsaWdodCBz
ZWQgdXNhZ2UgYW5kIGNvZGUgZHVwbGljYXRpb24gaXMgYmFkLiAgSXQncyBub3Qgc3VwZXIgbG92
ZWx5IGFzCj4gaXQncyBub3QgYWN0dWFsbHkgYSBtZW1vcnkgbWFwcGVkIGRldmljZSBidXQgaXQn
cyB0aGUgYmVzdCBpZGVhIHdlJ3ZlCj4gZ290Lgo+IAoKVGhhbmtzIGZvciB0aGUgcG9pbnRlci4K
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVs
IG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlz
dHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==
