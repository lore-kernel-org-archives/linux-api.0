From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [virtio-dev] Re: [PATCH] Add virtio gpu driver.
Date: Thu, 26 Mar 2015 10:04:03 +0100
Message-ID: <20150326095736-mutt-send-email-mst@redhat.com>
References: <1427213239-8775-1-git-send-email-kraxel@redhat.com>
 <20150324171255-mutt-send-email-mst@redhat.com>
 <1427295121.23304.5.camel@nilsson.home.kraxel.org>
 <20150325162246-mutt-send-email-mst@redhat.com>
 <1427297836.23304.29.camel@nilsson.home.kraxel.org>
 <20150325180721-mutt-send-email-mst@redhat.com>
 <1427353959.9779.2.camel@nilsson.home.kraxel.org>
 <20150326091545-mutt-send-email-mst@redhat.com>
 <1427359367.9779.9.camel@nilsson.home.kraxel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <1427359367.9779.9.camel@nilsson.home.kraxel.org>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: virtio-dev@lists.oasis-open.org, "open list:ABI/API" <linux-api@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, open list <linux-kernel@vger.kernel.org>, "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>, "open list:VIRTIO CORE, NET..." <virtualization@lists.linux-foundation.org>, Dave Airlie <airlied@redhat.com>
List-Id: linux-api@vger.kernel.org

T24gVGh1LCBNYXIgMjYsIDIwMTUgYXQgMDk6NDI6NDdBTSArMDEwMCwgR2VyZCBIb2ZmbWFubiB3
cm90ZToKPiAgIEhpLAo+IAo+ID4gQW5kIGlzIGl0IHBvc3NpYmxlIHRvIHVzZSBvZmZzZXQgd2l0
aGluIEJBUiBhbmQvb3IgbWVtb3J5IEJBUnM/Cj4gPiBJZiB5ZXMgSSdkIHN0cm9uZ2x5IHByZWZl
ciB0aGlzLgo+IAo+IFdoYXQgaXMgdGhlIHBvaW50PyAgRG8geW91IHdhbnQgcGxhY2UgdmlydGlv
IHJlZ2lvbnMgYW5kIHZnYSBmcmFtZWJ1ZmZlcgo+IGluIHRoZSBzYW1lIHBjaSBiYXI/ICBXaHk/
ICB2aXJ0aW8gaXMgbW1pbyBhbmQgdHJhcHMgaW50byBxZW11IG9uCj4gYWNjZXNzLCB3aGVyZWFz
IHRoZSB2Z2EgZnJhbWVidWZmZXIgaXMgbWVtb3J5LWJhY2tlZCAod2l0aCBkaXJ0eQo+IHRyYWNr
aW5nIHR1cm5lZCBvbikuICBEb24ndCB0aGluayB0aGlzIGlzIGEgZ29vZCBpZGVhLCBldmVuIHRo
b3VnaCB0aGUKPiBtZW1vcnkgYXBpIHdvdWxkIHByb2JhYmx5IGFsbG93IHRvIGRvIHRoaXMuCj4g
Cj4gY2hlZXJzLAo+ICAgR2VyZAoKQWJzb2x1dGVseSwgaXQncyBwcmV0dHkgY29tbW9uIHRvIG1p
eCByZWdpb25zIGluIGEgQkFSLgpGb3IgZXhhbXBsZSwgd2UgaGF2ZSB2aXJ0aW8ga2ljayAoaW9l
dmVudGZkIGJhY2tlZCwKaGFuZGxlZCBpbiBrZXJuZWwpIGluIHNhbWUgQkFSIGFzIGNvbW1vbiBh
bmQgZGV2aWNlCnNwZWNpZmljIGNvbmZpZ3VyYXRpb24uCgpXZSBkaWQgdGhlIHNhbWUgdGhpbmcg
eW91IGFyZSBub3cgZG9pbmcgd2l0aCB0aGUKdmlydGlvIEJBUiwgYW5kIG5vdyB3ZSBoYXZlIHRv
IG1haW50YWluIHR3byBjb2RlCmJhc2VzLCB2aXJ0aW8gcGNpIGNvbmZpZyB3YXMgZGVzaWduZWQg
dG8gYmUgZnV0dXJlIHByb29mCnNvIHdoeSBub3QgdXNlIGl0PwoKVGhpcyBpcyBtb3N0bHkganVz
dCBtYWtpbmcgc3VyZSB3ZSBkb24ndCBwYWludCBvdXJzZWx2ZXMgaW50byBhIGNvcm5lci4KCi0t
IApNU1QKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJp
LWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHA6
Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWwK
