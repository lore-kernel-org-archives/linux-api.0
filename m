From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: Re: [PATCH 10/98] via_drm.h: hide struct via_file_private in userspace
Date: Wed, 2 Sep 2015 22:17:51 +0300
Message-ID: <20150902191751.GY9187@lakka.kapsi.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
 <1433000370-19509-11-git-send-email-mikko.rapeli@iki.fi>
 <CACvgo52HDRuaQ+1qXg6O9ikhwNFSRCgopv6aAbujywOG+msmYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <CACvgo52HDRuaQ+1qXg6O9ikhwNFSRCgopv6aAbujywOG+msmYQ@mail.gmail.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Emil Velikov <emil.l.velikov@gmail.com>
Cc: linux-api@vger.kernel.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, ML dri-devel <dri-devel@lists.freedesktop.org>
List-Id: linux-api@vger.kernel.org

T24gV2VkLCBKdW4gMDMsIDIwMTUgYXQgMDU6NTA6MjJQTSArMDEwMCwgRW1pbCBWZWxpa292IHdy
b3RlOgo+IEhpIE1pa2tvLAo+IAo+IE9uIDMwIE1heSAyMDE1IGF0IDE2OjM4LCBNaWtrbyBSYXBl
bGkgPG1pa2tvLnJhcGVsaUBpa2kuZmk+IHdyb3RlOgo+ID4gRml4ZXMgY29tcGlsZXIgZXJyb3Ig
c2luY2UgbGlzdF9oZWFkIGlzIG5vdCBleHBvcnRlZCB0byB1c2Vyc3BhY2UgaGVhZGVycy4KPiA+
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBNaWtrbyBSYXBlbGkgPG1pa2tvLnJhcGVsaUBpa2kuZmk+Cj4g
PiAtLS0KPiA+ICBpbmNsdWRlL3VhcGkvZHJtL3ZpYV9kcm0uaCB8IDIgKysKPiA+ICAxIGZpbGUg
Y2hhbmdlZCwgMiBpbnNlcnRpb25zKCspCj4gPgo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFw
aS9kcm0vdmlhX2RybS5oIGIvaW5jbHVkZS91YXBpL2RybS92aWFfZHJtLmgKPiA+IGluZGV4IDc5
MTUzMWUuLjM0Y2U2NTggMTAwNjQ0Cj4gPiAtLS0gYS9pbmNsdWRlL3VhcGkvZHJtL3ZpYV9kcm0u
aAo+ID4gKysrIGIvaW5jbHVkZS91YXBpL2RybS92aWFfZHJtLmgKPiA+IEBAIC0yNzIsOCArMjcy
LDEwIEBAIHR5cGVkZWYgc3RydWN0IGRybV92aWFfZG1hYmxpdCB7Cj4gPiAgICAgICAgIGRybV92
aWFfYmxpdHN5bmNfdCBzeW5jOwo+ID4gIH0gZHJtX3ZpYV9kbWFibGl0X3Q7Cj4gPgo+ID4gKyNp
ZmRlZiBfX0tFUk5FTF9fCj4gPiAgc3RydWN0IHZpYV9maWxlX3ByaXZhdGUgewo+ID4gICAgICAg
ICBzdHJ1Y3QgbGlzdF9oZWFkIG9ial9saXN0Owo+ID4gIH07Cj4gPiArI2VuZGlmCj4gPgo+IFdl
IG1pZ2h0IHdhbnQgdG8gZm9sbG93IHRoZSBleGFtcGxlIG9mIG90aGVyIGRyaXZlcnMgKGk5MTUp
IGFuZCBtb3ZlCj4gaXQgdG8gZHJpdmVycy9ncHUvZHJtL3ZpYV9kcnYuaCwgVGhlcmUgYXJlIHR3
byB1c2VycyBvZiB0aGlzIHN0cnVjdAo+ICh2aWFfZHJ2LmMgYW5kIHZpYV9tbS5jKSwgYW5kIGVh
Y2ggb25lIGV4cGxpY2l0bHkgaW5jbHVkZXMgdGhlIGhlYWRlci4KPiBIb3cgZG9lcyB0aGF0IHNv
dW5kID8KPiAKPiBTYW1lIHN1Z2dlc3Rpb24gZ29lcyBmb3IgdGhlIGVxdWl2YWxlbnQgc2lzIHBh
dGNoLgoKVGhhbmtzLCBtb3ZlZCBib3RoIG9mIHRoZSBmaWxlX3ByaXZhdGUgZGVmaW5pdGlvbnMg
dG8gdGhlIGRyaXZlciBoZWFkZXJzLgoKLU1pa2tvCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxp
c3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4v
bGlzdGluZm8vZHJpLWRldmVsCg==
