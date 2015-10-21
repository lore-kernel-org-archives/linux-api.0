From: Emil Velikov <emil.l.velikov@gmail.com>
Subject: Re: [PATCH v4 09/79] via_drm.h: don't include non-existing
 via_drmclient.h
Date: Wed, 21 Oct 2015 16:01:18 +0100
Message-ID: <CACvgo52RaeWsiCaVb=0RXFXp1A9a9OGMoFHhjwdU8LoYCVommA@mail.gmail.com>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
 <1444888618-4506-10-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <1444888618-4506-10-git-send-email-mikko.rapeli@iki.fi>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: "open list:ABI/API" <linux-api@vger.kernel.org>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, ML dri-devel <dri-devel@lists.freedesktop.org>
List-Id: linux-api@vger.kernel.org

T24gMTUgT2N0b2JlciAyMDE1IGF0IDA2OjU1LCBNaWtrbyBSYXBlbGkgPG1pa2tvLnJhcGVsaUBp
a2kuZmk+IHdyb3RlOgo+IEZpeGVzIGNvbXBpbGVyIGVycm9yOgo+Cj4gZHJtL3ZpYV9kcm0uaDoz
NjoyNzogZmF0YWwgZXJyb3I6IHZpYV9kcm1jbGllbnQuaDogTm8gc3VjaCBmaWxlIG9yIGRpcmVj
dG9yeQo+Cj4gU2lnbmVkLW9mZi1ieTogTWlra28gUmFwZWxpIDxtaWtrby5yYXBlbGlAaWtpLmZp
Pgo+IC0tLQo+ICBpbmNsdWRlL3VhcGkvZHJtL3ZpYV9kcm0uaCB8IDMgLS0tCj4gIDEgZmlsZSBj
aGFuZ2VkLCAzIGRlbGV0aW9ucygtKQo+Cj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9kcm0v
dmlhX2RybS5oIGIvaW5jbHVkZS91YXBpL2RybS92aWFfZHJtLmgKPiBpbmRleCA4YjA1MzNjLi5k
MTljMGUyIDEwMDY0NAo+IC0tLSBhL2luY2x1ZGUvdWFwaS9kcm0vdmlhX2RybS5oCj4gKysrIGIv
aW5jbHVkZS91YXBpL2RybS92aWFfZHJtLmgKPiBAQCAtMzMsOSArMzMsNiBAQAo+ICAjaWZuZGVm
IF9WSUFfREVGSU5FU18KPiAgI2RlZmluZSBfVklBX0RFRklORVNfCj4KPiAtI2lmbmRlZiBfX0tF
Uk5FTF9fCj4gLSNpbmNsdWRlICJ2aWFfZHJtY2xpZW50LmgiCj4gLSNlbmRpZgo+Ck5vdyB0aGlz
IG9uZSBpcyBtZXNzeS4gSWYgd2UgcmVtb3ZlIGl0LCBleGlzdGluZyB1c2Vyc3BhY2UgWzBdIHdv
bid0CmJlIGFibGUgdG8gYnVpbGQuIEFzIHRoZXkgZG9uJ3QgaW5jbHVkZSB0aGUgYWJvdmUgaGVh
ZGVyIHdoZXJlIG5lZWRlZCwKYnV0IGluc3RlYWQgcmVseSBvbiB2aWFfZHJtLmguIERlc3BpdGUg
dGhlIGZhY3QgdGhhdCBlYWNoIHVzZXIKcHJvdmlkZXMgaXRzIG93biBjb3B5IG9mIHZpYV9kcm1j
bGllbnQuaC4KVGhlcmUgaXMgc29tZSB2ZXJ5IG9sZCBoYXJkd2FyZS9zb2Z0d2FyZSBpbnZvbHZl
ZCBzbyBJJ20gbm90IHN1cmUgaG93Cm11Y2ggb2YgYSByZWFsIGlzc3VlIHRoaXMgcGF0Y2ggd2ls
bCBiZS4gSWYgdGhlIG1haW50YWluZXJzIGRlY2lkZSB0bwpwaWNrIGl0IHVwLCBsZXQgbWUga25v
dyBhbmQgSSdsbCByb2xsIGEgZml4IGZvciB0aGUgZGR4LgoKLUVtaWwKClswXSBUaGVyZSBhcmUg
dHdvIHVzZXJzIGFmYWljdCAtIHRoZSB2aWEgZHJpIG1lc2EgbW9kdWxlIGFuZAp4Zjg2LXZpZGVv
LXZpYS4gV2l0aCB0aGUgZm9ybWVyIG51a2VkIHNvbWUgNSB5ZWFycyBhZ28gd2l0aCBtZXNhCmNv
bW1pdCBlNDM0NDE2MWJkZTJlMjRmY2ZiYTY1ZDMwZDU4ZjA4N2JkOGJmOTRkCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmRyaS1kZXZlbCBtYWlsaW5nIGxp
c3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwOi8vbGlzdHMuZnJlZWRlc2t0
b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==
