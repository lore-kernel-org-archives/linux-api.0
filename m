From: Robert Bragg <robert@sixbynine.org>
Subject: [RFC PATCH 04/11] perf: Add a PERF_RECORD_DEVICE event
	type
Date: Thu,  7 May 2015 15:15:47 +0100
Message-ID: <1431008154-6833-5-git-send-email-robert@sixbynine.org>
References: <1431008154-6833-1-git-send-email-robert@sixbynine.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <1431008154-6833-1-git-send-email-robert@sixbynine.org>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: intel-gfx@lists.freedesktop.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, David Airlie <airlied@linux.ie>, linux-api@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Daniel Vetter <daniel.vetter@intel.com>
List-Id: linux-api@vger.kernel.org

VG8gYWxsb3cgZm9yIG1vcmUgZXh0ZW5zaWJsZSwgZGV2aWNlIHNwZWNpZmljLCBwZXJmIHJlY29y
ZCB0eXBlcyB0aGlzCmFkZHMgYSBnZW5lcmljIFBFUkZfUkVDT1JEX0RFVklDRSB0eXBlIHRoYXQg
Y2FuIGJlIHVzZWQgYnkgZGV2aWNlCmRyaXZlcnMuIERyaXZlciBkZXZlbG9wZXJzIGNhbiB0aGVu
IGRvY3VtZW50IHNvbWUgZHJpdmVyLXNwZWNpZmljIGhlYWRlcgp0byBmdXJ0aGVyIGRldGFpbCBz
dWNoIGEgcmVjb3JkJ3MgdHlwZS4KClNpZ25lZC1vZmYtYnk6IFJvYmVydCBCcmFnZyA8cm9iZXJ0
QHNpeGJ5bmluZS5vcmc+Ci0tLQogaW5jbHVkZS91YXBpL2xpbnV4L3BlcmZfZXZlbnQuaCB8IDEz
ICsrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspCgpkaWZmIC0t
Z2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L3BlcmZfZXZlbnQuaCBiL2luY2x1ZGUvdWFwaS9saW51
eC9wZXJmX2V2ZW50LmgKaW5kZXggYTI1OTY3Yi4uNjg4ZTE5MiAxMDA2NDQKLS0tIGEvaW5jbHVk
ZS91YXBpL2xpbnV4L3BlcmZfZXZlbnQuaAorKysgYi9pbmNsdWRlL3VhcGkvbGludXgvcGVyZl9l
dmVudC5oCkBAIC03MjYsNiArNzI2LDE5IEBAIGVudW0gcGVyZl9ldmVudF90eXBlIHsKIAkgKi8K
IAlQRVJGX1JFQ09SRF9NTUFQMgkJCT0gMTAsCiAKKwkvKgorCSAqIFRoZSBERVZJQ0UgcmVjb3Jk
IGltcGxpZXMgc29tZSBkZXZpY2UgZHJpdmVyIHNwZWNpZmljIHJlY29yZCB0aGF0CisJICogd2ls
bCBoYXZlIHNvbWUgZnVydGhlciBtZWNoYW5pc20gZm9yIGRlc2NyaWJpbmcgdGhlIGNvbnRlbnRz
IG9mCisJICogdGhlIHJlY29yZCAoaS5lLiBzb21lIGRyaXZlciBzcGVjaWZpYyBldmVudCBoZWFk
ZXIpLgorCSAqCisJICogc3RydWN0IHsKKwkgKglzdHJ1Y3QgcGVyZl9ldmVudF9oZWFkZXIJaGVh
ZGVyOworCSAqCisJICoJc3RydWN0IERFVklDRV9FVkVOVF9IRUFERVIJZGV2aWNlX2hlYWRlcjsK
KwkgKiB9OworCSAqLworCVBFUkZfUkVDT1JEX0RFVklDRQkJCT0gMTEsCisKIAlQRVJGX1JFQ09S
RF9NQVgsCQkJLyogbm9uLUFCSSAqLwogfTsKIAotLSAKMi4zLjIKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkludGVsLWdmeCBtYWlsaW5nIGxpc3QKSW50
ZWwtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3Jn
L21haWxtYW4vbGlzdGluZm8vaW50ZWwtZ2Z4Cg==
