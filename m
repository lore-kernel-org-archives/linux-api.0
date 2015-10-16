From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC 0/6] Non perf based Gen Graphics OA unit driver
Date: Fri, 16 Oct 2015 12:33:45 +0200
Message-ID: <20151016103345.GS3816@twins.programming.kicks-ass.net>
References: <1443537549-6905-1-git-send-email-robert@sixbynine.org>
 <20151016094306.GA3604@twins.programming.kicks-ass.net>
 <20151016100228.GA22732@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20151016100228.GA22732@gmail.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt.fleming@intel.com>, dri-devel@lists.freedesktop.org, Kan Liang <kan.liang@intel.com>, intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Sourab Gupta <sourab.gupta@intel.com>, linux-api@vger.kernel.org, Zheng Yan <zheng.z.yan@intel.com>, Daniel Vetter <daniel.vetter@intel.com>, Robert Bragg <robert@sixbynine.org>
List-Id: linux-api@vger.kernel.org

T24gRnJpLCBPY3QgMTYsIDIwMTUgYXQgMTI6MDI6MjhQTSArMDIwMCwgSW5nbyBNb2xuYXIgd3Jv
dGU6Cj4gCj4gKiBQZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+IHdyb3RlOgo+
IAo+ID4gPiAtIFdlIG1heSBiZSBtYWtpbmcgc29tZSB0ZWNobmljYWwgY29tcHJvbWlzZXMgYS50
Lm0gZm9yIHRoZSBzYWtlIG9mCj4gPiA+ICAgdXNpbmcgcGVyZi4KPiA+ID4gCj4gPiA+ICAgICBw
ZXJmX2V2ZW50X29wZW4oKSByZXF1aXJlcyBldmVudHMgdG8gZWl0aGVyIHJlbGF0ZSB0byBhIHBp
ZCBvciBhCj4gPiA+ICAgICBzcGVjaWZpYyBjcHUgY29yZSwgd2hpbGUgb3VyIGRldmljZSBwbXUg
cmVsYXRlcyB0byBuZWl0aGVyLiAgRXZlbnRzCj4gPiA+ICAgICBvcGVuZWQgd2l0aCBhIHBpZCB3
aWxsIGJlIGF1dG9tYXRpY2FsbHkgZW5hYmxlZC9kaXNhYmxlZCBhY2NvcmRpbmcKPiA+ID4gICAg
IHRvIHRoZSBzY2hlZHVsaW5nIG9mIHRoYXQgcHJvY2VzcyAtIHNvIG5vdCBhcHByb3ByaWF0ZSBm
b3IgdXMuCj4gPiAKPiA+IFJpZ2h0OyB0aGUgdHJhZGl0aW9uYWwgY3B1L3BpZCBtYXBwaW5nIGRv
ZXNuJ3Qgd29yayB3ZWxsIGZvciBkZXZpY2VzOwo+ID4gYnV0IG1heWJlLCB3aXRoIHNvbWUgd29y
aywgd2UgY2FuIGNyZWF0ZSBzb21ldGhpbmcgbGlrZSB0aGF0Cj4gPiBnbG9iYWwvbG9jYWwgcmVu
ZGVyIGNvbnRleHQgZnJvbSBpdDsgYWx0aG91Z2ggSSd2ZSBubyBjbHVlIHdoYXQgZm9ybQo+ID4g
dGhhdCB3b3VsZCBuZWVkIGF0IHRoaXMgdGltZS4KPiAKPiBDb3VsZCBzb21lb25lIHBsZWFzZSBo
ZWxwIHdpdGggc29tZSB2ZXJ5IGJhc2ljIHF1ZXN0aW9ucywgc3VjaCBhcyB3aGF0IHRoZSAKPiBo
YXJkd2FyZSBtb2RlbCBvZiB0aGUgJ09BJyB1bml0IG1vZGVsIGlzPyBIb3cgYXJlIE9BIHJlZ2lz
dGVycyBzZXQgdXAsIGhvdyBhcmUgCj4gdGhlaXIgdmFsdWVzIG1hZGUgYWNjZXNzaWJsZSB0byB0
aGUgaG9zdCBzaWRlLCBldGMuCgpSb2JlcnQgbGlua2VkIHRvOgoKICBodHRwczovLzAxLm9yZy9z
aXRlcy9kZWZhdWx0L2ZpbGVzL2RvY3VtZW50YXRpb24vb2JzZXJ2YWJpbGl0eV9wZXJmb3JtYW5j
ZV9jb3VudGVyc19oYXN3ZWxsLnBkZgoKSW4gYSBwcmV2aW91cyBwb3N0aW5nLiBJdCBoYXMgc29t
ZSBpbmZvLCBidXQgZnVsbCBkb2N1bWVudGF0aW9uLCBpcyBhcwpwZXIgdGhlIGluaXRpYWwgcG9z
dCwgJ3BlbmRpbmcnLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5v
cmcKaHR0cDovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZl
bAo=
