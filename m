From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Subject: Re: [PATCH] drm/i915: fix definition of the
 DRM_IOCTL_I915_GET_SPRITE_COLORKEY ioctl
Date: Mon, 30 Mar 2015 11:00:46 +0300
Message-ID: <20150330080046.GG17410@intel.com>
References: <1427399236-14012-1-git-send-email-tt.rantala@gmail.com>
 <87a8yzq6yr.fsf@intel.com>
 <20150327080427.GB23521@phenom.ffwll.local>
 <551574C4.6000804@intel.com>
 <20150330065455.GG23521@phenom.ffwll.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20150330065455.GG23521@phenom.ffwll.local>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: linux-api@vger.kernel.org, intel-gfx@lists.freedesktop.org, Jesse Barnes <jesse.barnes@intel.com>, dri-devel@lists.freedesktop.org, Daniel Vetter <daniel.vetter@intel.com>
List-Id: linux-api@vger.kernel.org

T24gTW9uLCBNYXIgMzAsIDIwMTUgYXQgMDg6NTQ6NTVBTSArMDIwMCwgRGFuaWVsIFZldHRlciB3
cm90ZToKPiBPbiBGcmksIE1hciAyNywgMjAxNSBhdCAwODoxODoyOEFNIC0wNzAwLCBKZXNzZSBC
YXJuZXMgd3JvdGU6Cj4gPiBPbiAwMy8yNy8yMDE1IDAxOjA0IEFNLCBEYW5pZWwgVmV0dGVyIHdy
b3RlOgo+ID4gPiBPbiBGcmksIE1hciAyNywgMjAxNSBhdCAwODozOTo1NkFNICswMjAwLCBKYW5p
IE5pa3VsYSB3cm90ZToKPiA+ID4+IE9uIFRodSwgMjYgTWFyIDIwMTUsIFRvbW1pIFJhbnRhbGEg
PHR0LnJhbnRhbGFAZ21haWwuY29tPiB3cm90ZToKPiA+ID4+PiBGaXggZGVmaW5pdGlvbiBvZiB0
aGUgRFJNX0lPQ1RMX0k5MTVfR0VUX1NQUklURV9DT0xPUktFWSBpb2N0bCwgc28gdGhhdCBpdAo+
ID4gPj4+IGlzIGRpZmZlcmVudCBmcm9tIHRoZSBEUk1fSU9DVExfSTkxNV9TRVRfU1BSSVRFX0NP
TE9SS0VZIGlvY3RsLgo+ID4gPj4+Cj4gPiA+Pj4gU2lnbmVkLW9mZi1ieTogVG9tbWkgUmFudGFs
YSA8dHQucmFudGFsYUBnbWFpbC5jb20+Cj4gPiA+Pgo+ID4gPj4gV2hvYS4gQnJva2VuIHNpbmNl
IGl0cyBpbnRyb2R1Y3Rpb24gaW4KPiA+ID4+Cj4gPiA+PiBjb21taXQgOGVhMzA4NjQyMjllNTRi
MDFhYzBlOWZlODhjNGI3MzNhOTQwZWM0ZQo+ID4gPj4gQXV0aG9yOiBKZXNzZSBCYXJuZXMgPGpi
YXJuZXNAdmlydHVvdXNnZWVrLm9yZz4KPiA+ID4+IERhdGU6ICAgVHVlIEphbiAzIDA4OjA1OjM5
IDIwMTIgLTA4MDAKPiA+ID4+Cj4gPiA+PiAgICAgZHJtL2k5MTU6IGFkZCBjb2xvciBrZXkgc3Vw
cG9ydCB2NAo+ID4gPj4KPiA+ID4+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnCj4gPiA+IAo+
ID4gPiBOb3BlLCB3ZSdsbCBqdXN0IHJpcCBpdCBvdXQgYW5kIHJlcGxhY2UgaXQgYWxsIHdpdGgg
dGhlIGRybV9ub29wIGlvY3RsLiBBdAo+ID4gPiBsZWFzdCBJIGRpZG4ndCBmaW5kIGFueSB1c2Vy
c3BhY2UgYW55d2hlcmUgYW5kIG9ubHkgYnJva2VuIGRlZmluaXRpb25zLgo+ID4gPiBQcm9vZiBl
bm91Z2ggdGhpcyBpc24ndCB1c2VmdWwuCj4gPiA+IAo+ID4gPiBFdmVuIG1vcmUgc28gc2luY2Ug
dGhhdCBtZWFucyB3ZSBkb24ndCBoYXZlIHRvIGNvbnZlcnQgdGhlIGdldCBpb2N0bCBvdmVyCj4g
PiA+IHRvIGF0b21pYywgeWF5ISBJJ2xsIHNlbmQgcGF0Y2hlcy4KPiA+IAo+ID4gQ2FuIHdlIGp1
c3Qgc2tpcCB0aGUgbm9vcCBwYXJ0IGFuZCBkZWxldGUgaXQgYWx0b2dldGhlcj8gIEl0IHdhcyBv
bmx5Cj4gPiBhZGRlZCBzcGVjdWxhdGl2ZWx5IGFuZCBvYnZpb3VzbHkgbmV2ZXIgdXNlZCBhdCBh
bGwuLi4KPiAKPiBUaGUgdGFibGUgaXMgaW5kZXhlZCwgd2UgbmVlZCBhIGR1bW15IGVudHJ5LgoK
V2Ugc2hvdWxkbid0IG5lZWQgYW55IGR1bW1pZXMuIEFueSBtaXNzaW5nIGVudHJ5IGluIHRoZSB0
YWJsZSB3aWxsCmJlIHplcm9lZCwgc28gd2Ugc2hvdWxkIHNpbXBseSByZXR1cm4gLUVJTlZBTCBk
dWUgdG8gaW9jdGwtPmZ1bmM9PU5VTEwuCgotLSAKVmlsbGUgU3lyasOkbMOkCkludGVsIE9UQwpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpJbnRlbC1nZngg
bWFpbGluZyBsaXN0CkludGVsLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cDovL2xpc3Rz
LmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2ludGVsLWdmeAo=
