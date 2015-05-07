From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [Intel-gfx] [RFC PATCH 03/11] perf: Add PERF_EVENT_IOC_FLUSH ioctl
Date: Thu, 7 May 2015 15:20:09 +0100
Message-ID: <20150507142009.GX22099@nuc-i3427.alporthouse.com>
References: <1431008154-6833-1-git-send-email-robert@sixbynine.org>
 <1431008154-6833-4-git-send-email-robert@sixbynine.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <1431008154-6833-4-git-send-email-robert@sixbynine.org>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Robert Bragg <robert@sixbynine.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-api@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Daniel Vetter <daniel.vetter@intel.com>
List-Id: linux-api@vger.kernel.org

T24gVGh1LCBNYXkgMDcsIDIwMTUgYXQgMDM6MTU6NDZQTSArMDEwMCwgUm9iZXJ0IEJyYWdnIHdy
b3RlOgo+IFRvIGFsbG93IGZvciBwbXVzIHRoYXQgbWF5IGhhdmUgaW50ZXJuYWwgYnVmZmVyaW5n
IChlLmcuIHRoZSBoYXJkd2FyZQo+IGl0c2VsZiB3cml0ZXMgb3V0IGRhdGEgdG8gaXRzIG93biBj
aXJjdWxhciBidWZmZXIgd2hpY2ggaXMgb25seQo+IHBlcmlvZGljYWxseSBmb3J3YXJkZWQgdG8g
dXNlcnNwYWNlIHZpYSBwZXJmKSB0aGlzIGlvY3RsIGVuYWJsZXMKPiB1c2Vyc3BhY2UgdG8gZXhw
bGljaXRseSBlbnN1cmUgaXQgaGFzIHJlY2VpdmVkIGFsbCBzYW1wbGVzIGJlZm9yZSBhCj4gcG9p
bnQgaW4gdGltZS4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBSb2JlcnQgQnJhZ2cgPHJvYmVydEBzaXhi
eW5pbmUub3JnPgo+IC0tLQo+ICBpbmNsdWRlL2xpbnV4L3BlcmZfZXZlbnQuaCAgICAgIHwgNyAr
KysrKysrCj4gIGluY2x1ZGUvdWFwaS9saW51eC9wZXJmX2V2ZW50LmggfCAxICsKPiAga2VybmVs
L2V2ZW50cy9jb3JlLmMgICAgICAgICAgICB8IDUgKysrKysKPiAgMyBmaWxlcyBjaGFuZ2VkLCAx
MyBpbnNlcnRpb25zKCspCj4gCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvcGVyZl9ldmVu
dC5oIGIvaW5jbHVkZS9saW51eC9wZXJmX2V2ZW50LmgKPiBpbmRleCAxYWYzNWI0Li42OWEwY2I5
IDEwMDY0NAo+IC0tLSBhL2luY2x1ZGUvbGludXgvcGVyZl9ldmVudC5oCj4gKysrIGIvaW5jbHVk
ZS9saW51eC9wZXJmX2V2ZW50LmgKPiBAQCAtMjY2LDYgKzI2NiwxMyBAQCBzdHJ1Y3QgcG11IHsK
PiAgCSAqIGZsdXNoIGJyYW5jaCBzdGFjayBvbiBjb250ZXh0LXN3aXRjaGVzIChuZWVkZWQgaW4g
Y3B1LXdpZGUgbW9kZSkKPiAgCSAqLwo+ICAJdm9pZCAoKmZsdXNoX2JyYW5jaF9zdGFjaykJKHZv
aWQpOwo+ICsKPiArCS8qCj4gKwkgKiBGbHVzaCBidWZmZXJlZCBzYW1wbGVzIChFLmcuIGZvciBw
bXUgaGFyZHdhcmUgdGhhdCB3cml0ZXMgc2FtcGxlcyB0bwo+ICsJICogc29tZSBpbnRlcm1lZGlh
dGUgYnVmZmVyKSB1c2Vyc3BhY2UgbWF5IG5lZWQgdG8gZXhwbGljaXRseSBlbnN1cmUKPiArCSAq
IHN1Y2ggc2FtcGxlcyBoYXZlIGJlZW4gZm9yd2FyZGVkIHRvIHBlcmYuCj4gKwkgKi8KPiArCXZv
aWQgKCpmbHVzaCkJCQkoc3RydWN0IHBlcmZfZXZlbnQgKmV2ZW50KTsgLypvcHRpb25hbCAqLwoK
dm9pZCByZXR1cm4/Ci1DaHJpcwoKLS0gCkNocmlzIFdpbHNvbiwgSW50ZWwgT3BlbiBTb3VyY2Ug
VGVjaG5vbG9neSBDZW50cmUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0
b3Aub3JnCmh0dHA6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmkt
ZGV2ZWwK
