From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH] Add virtio gpu driver.
Date: Wed, 25 Mar 2015 15:52:01 +0100
Message-ID: <1427295121.23304.5.camel@nilsson.home.kraxel.org>
References: <1427213239-8775-1-git-send-email-kraxel@redhat.com>
 <20150324171255-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20150324171255-mutt-send-email-mst@redhat.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtio-dev@lists.oasis-open.org, "open
 list:ABI/API" <linux-api@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, open list <linux-kernel@vger.kernel.org>, "open
 list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>, "open list:VIRTIO
 CORE, NET..." <virtualization@lists.linux-foundation.org>, Dave Airlie <airlied@redhat.com>
List-Id: linux-api@vger.kernel.org

ICBIaSwKCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92aXJ0aW8vdmlydGlvX3BjaV9jb21tb24u
YyBiL2RyaXZlcnMvdmlydGlvL3ZpcnRpb19wY2lfY29tbW9uLmMKPiA+IGluZGV4IGU4OTRlYjIu
LmEzMTY3ZmEgMTAwNjQ0Cj4gPiAtLS0gYS9kcml2ZXJzL3ZpcnRpby92aXJ0aW9fcGNpX2NvbW1v
bi5jCj4gPiArKysgYi9kcml2ZXJzL3ZpcnRpby92aXJ0aW9fcGNpX2NvbW1vbi5jCj4gPiBAQCAt
NTEwLDcgKzUxMCw3IEBAIHN0YXRpYyBpbnQgdmlydGlvX3BjaV9wcm9iZShzdHJ1Y3QgcGNpX2Rl
diAqcGNpX2RldiwKPiA+ICAJCWdvdG8gZXJyX2VuYWJsZV9kZXZpY2U7Cj4gPiAgCj4gPiAgCXJj
ID0gcGNpX3JlcXVlc3RfcmVnaW9ucyhwY2lfZGV2LCAidmlydGlvLXBjaSIpOwo+ID4gLQlpZiAo
cmMpCj4gPiArCWlmIChyYyAmJiAoKHBjaV9kZXYtPmNsYXNzID4+IDgpICE9IFBDSV9DTEFTU19E
SVNQTEFZX1ZHQSkpCj4gPiAgCQlnb3RvIGVycl9yZXF1ZXN0X3JlZ2lvbnM7Cj4gPiAgCj4gPiAg
CWlmIChmb3JjZV9sZWdhY3kpIHsKPiAKPiBUaGlzIGlzIHByb2JhYmx5IHdoYXQgeW91IGRlc2Ny
aWJlZCBhcyAidGhlIG9ubHkgY29uY2Vybj8KCkFoZW0sIG5vLCBmb3Jnb3QgdGhhdCBvbmUsIGJ1
dCBpdCBpcyByZWxhdGVkLiAgV2l0aCB2ZXNhZmIgdXNpbmcgYW5kCnJlZ2lzdGVyaW5nIHRoZSB2
Z2EgY29tcGF0IGZyYW1lYnVmZmVyIGJhciBwY2lfcmVxdWVzdF9yZWdpb25zIHdpbGwgbm90CnN1
Y2NlZWQuCgp2ZXNhZmIgd2lsbCBiZSB1bnJlZ2lzdGVyZWQgbGF0ZXIgb24gKHRoaXMgaXMgd2hh
dCBJIHdhcyByZWZlcmluZyB0bykgYnkKdGhlIHZpcnRpby1ncHUgZHJpdmVyLgoKPiBJZiB3ZSBv
bmx5IG5lZWQgdG8gcmVxdWVzdCBzcGVjaWZpYwo+IHJlZ2lvbnMsIEkgdGhpbmsgd2Ugc2hvdWxk
IGRvIGV4YWN0bHkgdGhhdCwgcmVxdWVzdGluZyBvbmx5IHBhcnRzIG9mCj4gcmVnaW9ucyB0aGF0
IGFyZSBjb3ZlcmVkIGJ5IHRoZSB2aXJ0aW8gY2FwYWJpbGl0aWVzLgoKVGhhdCBzaG91bGQgd29y
ayB0b28uCgpjaGVlcnMsCiAgR2VyZAoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZy
ZWVkZXNrdG9wLm9yZwpodHRwOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGlu
Zm8vZHJpLWRldmVsCg==
