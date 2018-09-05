From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC] UAPI: Check headers by compiling all together as C++
Date: Wed, 5 Sep 2018 13:42:58 -0400
Message-ID: <20180905133711-mutt-send-email-mst@kernel.org>
References: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
 <20180905165552.GB25206@kroah.com>
 <a1efae8d26cc5b73b180e9521d6b62590c55aa86.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <a1efae8d26cc5b73b180e9521d6b62590c55aa86.camel@opteya.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: moderated for non-subscribers <alsa-devel@alsa-project.org>, David Airlie <airlied@linux.ie>, Greg KH <greg@kroah.com>, Jason Wang <jasowang@redhat.com>, Mat Martineau <mathew.j.martineau@linux.intel.com>, dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org, David Howells <dhowells@redhat.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, keyrings@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-nvdimm@lists.01.org, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu, coreteam@netfilter.org, Kent Overstreet <kent.overstreet@gmail.com>, linux-kbuild@vger.kernel.org, linux-arm-msm@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Jaroslav Kysela <perex@perex.cz>, Jan Harkes <jaharkes@cs.cmu.edu>, Michal Marek <michal.lkml@markovi.net>linux
List-Id: linux-api@vger.kernel.org

T24gV2VkLCBTZXAgMDUsIDIwMTggYXQgMDc6MzM6MzhQTSArMDIwMCwgWWFubiBEcm9uZWF1ZCB3
cm90ZToKPiBIaSwKPiAKPiBMZSBtZXJjcmVkaSAwNSBzZXB0ZW1icmUgMjAxOCDDoCAxODo1NSAr
MDIwMCwgR3JlZyBLSCBhIMOpY3JpdCA6Cj4gPiBPbiBXZWQsIFNlcCAwNSwgMjAxOCBhdCAwNDo1
NDoyN1BNICswMTAwLCBEYXZpZCBIb3dlbGxzIHdyb3RlOgo+ID4gPiAKPiA+ID4gSGVyZSdzIGEg
c2V0IG9mIHBhdGNoZXMgdGhhdCBpbnNlcnRzIGEgc3RlcCBpbnRvIHRoZSBidWlsZCBwcm9jZXNz
IHRvIG1ha2UKPiA+ID4gc3VyZSB0aGF0IHRoZSBVQVBJIGhlYWRlcnMgY2FuIGFsbCBiZSBidWls
dCB0b2dldGhlciB3aXRoIEMrKyAoaWYgdGhlCj4gPiA+IGNvbXBpbGVyIGJlaW5nIHVzZWQgc3Vw
cG9ydHMgQysrKS4gIEFsbCBidXQgdGhlIGZpbmFsIHBhdGNoIHBlcmZvcm0gZml4dXBzLAo+ID4g
PiBpbmNsdWRpbmc6Cj4gPiAKPiA+IFdhaXQsIHdoeSBkbyB3ZSBjYXJlPyAgV2hhdCBoYXMgcmVj
ZW50bHkgY2hhbmdlZCB0byBzdGFydCB0byBkaXJlY3RseQo+ID4gaW1wb3J0IGtlcm5lbCB1YXBp
IGZpbGVzIGludG8gQysrIGNvZGU/Cj4gPiAKPiA+IEFuZCBpZiB1c2Vyc3BhY2Ugd2FudHMgdG8g
ZG8gdGhpcywgY2FuJ3QgdGhleSBkbyB0aGUgQyBuYW1lc3BhY2UgdHJpY2sKPiA+IHRoZW1zZWx2
ZXMgd2hlbiB0aGV5IGRvIHRoZSBpbXBvcnQ/ICBUaGF0IG11c3QgYmUgaG93IHRoZXkgYXJlIGRv
aW5nIGl0Cj4gPiB0b2RheSwgcmlnaHQ/Cj4gPiAKPiAKPiBUaGV5IGNhbid0Lgo+IAo+IAo+IEFk
ZGluZyBleHRlcm4gIkMiIHsgfSBkb2Vzbid0IG1hZ2ljYWxseSBtYWtlICJjbGFzcyIgYSBub24g
a2V5d29yZC4KPiBFdmVuIGlmIGl0IHdhcyB0aGUgY2FzZSwgd3JpdGluZyBDKysgY29kZSB1c2lu
ZyB3aGF0ZXZlci0+Y2xhc3Mgd291bGQKPiBwcm9iYWJseSBicm9rZSBiZWNhdXNlIGNsYXNzIGlz
IGEga2V5d29yZCBpbiBDKysuCgpJIHRoaW5rIGl0J3MgYSBidWcgaW4gdGhlIGxhbmd1YWdlIFRC
SC4KCj4gLS0gCj4gWWFubiBEcm9uZWF1ZAo+IE9QVEVZQQo+IApfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1k
ZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcv
bWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWwK
