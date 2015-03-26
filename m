From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [virtio-dev] Re: [PATCH] Add virtio gpu driver.
Date: Thu, 26 Mar 2015 16:07:16 +0100
Message-ID: <1427382436.8786.15.camel@nilsson.home.kraxel.org>
References: <20150324171255-mutt-send-email-mst@redhat.com>
 <1427295121.23304.5.camel@nilsson.home.kraxel.org>
 <20150325162246-mutt-send-email-mst@redhat.com>
 <1427297836.23304.29.camel@nilsson.home.kraxel.org>
 <20150325180721-mutt-send-email-mst@redhat.com>
 <1427353959.9779.2.camel@nilsson.home.kraxel.org>
 <20150326091545-mutt-send-email-mst@redhat.com>
 <1427359367.9779.9.camel@nilsson.home.kraxel.org>
 <20150326095736-mutt-send-email-mst@redhat.com>
 <1427369923.9779.18.camel@nilsson.home.kraxel.org>
 <20150326124751-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20150326124751-mutt-send-email-mst@redhat.com>
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

ICBIaSwKCj4gSSBkb24ndCBrbm93LiBUaGlzIHNlZW1zIGV4YWN0bHkgbGlrZSB0aGUga2luZCBv
ZiB0aGluZwo+IHdlIGhhZCBpbiBtaW5kIHdoZW4gd2UgYWRkZWQgdGhlIHZpcnRpbyBwY2kgY2Fw
YWJpbGl0eS4KPiBGb3IgZXhhbXBsZSwgd2UgaGF2ZSB0ZXh0IGluIHNwZWMgdGhhdCByZXF1aXJl
cyBkcml2ZXJzCj4gdG8gc2tpcCB1bmtub3duIGNhcGFiaWxpdGllcy4KPiAKPiBBbmQgeWVzLCBp
ZiBiaW9zIHBva2VzIGF0IGEgc3BlY2lmaWMgYmFyIHRoZW4gd2UgZG8KPiBuZWVkIHRvIGxpc3Qg
dGhpcyBpbmZvIGluIHRoZSB2aXJ0aW8gc3BlYyBzbyB0aGlzIG1ha2VzCj4gaXQgYW4gaXNzdWUg
dGhhdCBpcyB2aXJ0aW8gcmVsYXRlZC4KCkhtbSwgdmlydGlvLXZnYSBpcyBhIHR3by1pbi1vbmUg
ZGV2aWNlIGJhc2ljYWxseS4gIFdoZW4gdmlydGlvIGlzCmVuYWJsZWQgaXQgYmVoYXZlcyBsaWtl
IHZpcnRpby1ncHUtcGNpLCBvdGhlcndpc2UgaXQgYmVoYXZlcyB2ZXJ5CnNpbWxpYXIgdG8gc3Rk
dmdhLiAgU28geW91IG5lZWQgdG8ga25vdyBub3RoaW5nIGFib3V0IHZpcnRpbyB0byBoYW5kbGUK
dGhlIHZnYSBzaWRlLCBhbmQgSSB3YW50IGtlZXAgaXQgdGhhdCB3YXkuCgpXaGVuIG5vIHZnYSBj
b21wYXRpYmlsaXR5IGlzIG5lZWRlZCB0aGVyZSBhbHdheXMgaXMgdGhlIG9wdGlvbiB0byBqdXN0
CnVzZSB2aXJ0aW8tZ3B1LXBjaSBpbnN0ZWFkLgoKPiBZZXMsIGl0J3Mgbm90IGFib3V0IHdoYXQg
d2UgcHV0IHRoZXJlIG5vdy4gSXQncyBhYm91dCBiZWluZyBhYmxlCj4gdG8gbW92ZSB0aGluZ3Mg
YWJvdXQgaW4gdGhlIGZ1dHVyZSB3aXRob3V0IGJyZWFraW5nIGd1ZXN0cy4KCldlIGRvbid0IGhh
dmUgdGhhdCB0b2RheSBmb3Igc3RkdmdhLCBhbmQgSSBzdGlsbCBmYWlsIHRvIHNlZSB3aGF0IHRo
aXMKYnV5cyB1cy4KCgpDb21wbGV0ZWx5IGRpZmZlcmVudCB0aGluZyBjcm9zc2luZyBteSBtaW5k
OiAgSSB0aGluayB3ZSBjYW4gbWFrZQp2aXJ0aW8tdmdhIGZ1bGx5IGNvbXBhdGlibGUgd2l0aCBz
dGR2Z2EuICBzdGR2Z2EgaGFzIHR3byBiYXJzLCBtZW1vcnkKKCMwKSBhbmQgbW1pbyAoIzIpLiAg
V2UgY2FuIG1ha2UgdGhlIG1taW8gYmFyIGxhcmdlciBhbmQgcGxhY2UgYWxsIHRoZQp2aXJ0aW8g
cmVnaW9ucyB0aGVyZS4KCgpJIHRoaW5rIGluIGFueSBjYXNlIEknbGwgZ28gc3BsaXQgb2ZmIHRo
ZSB2Z2EgY29tcGF0aWJpbGl0eSBiaXRzIHRvIGEKZGlmZmVyZW50IHBhdGNoIChhbmQgcG9zc2li
bGUgYSBzZXBhcmF0ZSBwYXRjaCBzZXJpZXMpLgoKY2hlZXJzLAogIEdlcmQKCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBs
aXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cDovL2xpc3RzLmZyZWVkZXNr
dG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbAo=
