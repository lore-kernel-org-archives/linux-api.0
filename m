From: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH 0/4] enable migration of driver pages
Date: Wed, 29 Jul 2015 12:55:54 +0200
Message-ID: <20150729105554.GU16722@phenom.ffwll.local>
References: <1436776519-17337-1-git-send-email-gioh.kim@lge.com>
 <20150729104945.GA30872@techsingularity.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20150729104945.GA30872@techsingularity.net>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Mel Gorman <mgorman@techsingularity.net>
Cc: aquini@redhat.com, mst@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org, bfields@fieldses.org, minchan@kernel.org, Gioh Kim <gurugio@hanmail.net>, linux-mm@kvack.org, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, Gioh Kim <gioh.kim@lge.com>, linux-fsdevel@vger.kernel.org, jlayton@poochiereds.net, koct9i@gmail.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz
List-Id: linux-api@vger.kernel.org

T24gV2VkLCBKdWwgMjksIDIwMTUgYXQgMTE6NDk6NDVBTSArMDEwMCwgTWVsIEdvcm1hbiB3cm90
ZToKPiBPbiBNb24sIEp1bCAxMywgMjAxNSBhdCAwNTozNToxNVBNICswOTAwLCBHaW9oIEtpbSB3
cm90ZToKPiA+IE15IEFSTS1iYXNlZCBwbGF0Zm9ybSBvY2N1cmVkIHNldmVyZSBmcmFnbWVudGF0
aW9uIHByb2JsZW0gYWZ0ZXIgbG9uZy10ZXJtCj4gPiAoc2V2ZXJhbCBkYXlzKSB0ZXN0LiBTb21l
dGltZXMgZXZlbiBvcmRlci0zIHBhZ2UgYWxsb2NhdGlvbiBmYWlsZWQuIEl0IGhhcwo+ID4gbWVt
b3J5IHNpemUgNTEyTUIgfiAxMDI0TUIuIDMwJSB+IDQwJSBtZW1vcnkgaXMgY29uc3VtZWQgZm9y
IGdyYXBoaWMgcHJvY2Vzc2luZwo+ID4gYW5kIDIwfjMwIG1lbW9yeSBpcyByZXNlcnZlZCBmb3Ig
enJhbS4KPiA+IAo+IAo+IFRoZSBwcmltYXJ5IG1vdGl2YXRpb24gb2YgdGhpcyBzZXJpZXMgaXMg
dG8gcmVkdWNlIGZyYWdtZW50YXRpb24gYnkgYWxsb3dpbmcKPiBtb3JlIGtlcm5lbCBwYWdlcyB0
byBiZSBtb3ZlZC4gQ29uY2VwdHVhbGx5IHRoYXQgaXMgYSB3b3J0aHdoaWxlIGdvYWwgYnV0Cj4g
dGhlcmUgc2hvdWxkIGJlIGF0IGxlYXN0IG9uZSBtYWpvciBpbi1rZXJuZWwgdXNlciBhbmQgd2hp
bGUgYmFsbG9vbgo+IHBhZ2VzIHdlcmUgYSBnb29kIHN0YXJ0aW5nIHBvaW50LCBJIHRoaW5rIHdl
IHJlYWxseSBuZWVkIHRvIHNlZSB3aGF0IHRoZQo+IHpyYW0gY2hhbmdlcyBsb29rIGxpa2UgYXQg
dGhlIHNhbWUgdGltZS4KCkkgdGhpbmsgZ3B1IGRyaXZlcnMgcmVhbGx5IHdvdWxkIGJlIHRoZSBw
ZXJmZWN0IGNhbmRpZGF0ZSBmb3IgY29tcGFjdGluZwprZXJuZWwgcGFnZSBhbGxvY2F0aW9ucy4g
QW5kIHRoaXMgYWxzbyBzZWVtcyB0aGUgcHJpbWFyeSBtb3RpdmF0aW9uIGZvcgp0aGlzIHBhdGNo
IHNlcmllcywgc28gSSB0aGluayB0aGF0J3MgcmVhbGx5IHdoYXQgd2Ugc2hvdWxkIHVzZSB0byBq
dWRnZQp0aGVzZSBwYXRjaGVzLgoKT2YgY291cnNlIHRoZW4gdGhlcmUncyB0aGUgc2VlbWluZ2x5
IGV0ZXJuYWwgY2hpY2tlbi9lZ2cgcHJvYmxlbSBvZgp1cHN0cmVhbSBncHUgZHJpdmVycyBmb3Ig
U29DcyA6KAotRGFuaWVsCi0tIApEYW5pZWwgVmV0dGVyClNvZnR3YXJlIEVuZ2luZWVyLCBJbnRl
bCBDb3Jwb3JhdGlvbgpodHRwOi8vYmxvZy5mZndsbC5jaApfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZl
bEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cDovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWls
bWFuL2xpc3RpbmZvL2RyaS1kZXZlbAo=
