From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v6 1/5] vfs: add flags parameter to ->mmap() in 'struct
 file_operations'
Date: Thu, 24 Aug 2017 10:42:09 -0700
Message-ID: <CAPcyv4gd1qgtP7DjfRnXDebhYb1_4jnuM3HTL-ma2snz7FMAOg@mail.gmail.com>
References: <150353211413.5039.5228914877418362329.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150353211985.5039.4333061601382775843.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170824165838.GB3121@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20170824165838.GB3121@infradead.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, Takashi Iwai <tiwai@suse.com>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Daniel Vetter <daniel.vetter@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>
List-Id: linux-api@vger.kernel.org

T24gVGh1LCBBdWcgMjQsIDIwMTcgYXQgOTo1OCBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBp
bmZyYWRlYWQub3JnPiB3cm90ZToKPiBPbiBXZWQsIEF1ZyAyMywgMjAxNyBhdCAwNDo0ODo0MFBN
IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4+IFdlIGFyZSBydW5uaW5nIHJ1bm5pbmcgc2hv
cnQgb2Ygdm1hLT52bV9mbGFncy4gV2UgY2FuIGF2b2lkIG5lZWRpbmcgYQo+PiBuZXcgVk1fKiBm
bGFnIGluIHNvbWUgY2FzZXMgaWYgdGhlIG9yaWdpbmFsIEBmbGFncyBzdWJtaXR0ZWQgdG8gbW1h
cCgyKQo+PiBpcyBtYWRlIGF2YWlsYWJsZSB0byB0aGUgLT5tbWFwKCkgJ3N0cnVjdCBmaWxlX29w
ZXJhdGlvbnMnCj4+IGltcGxlbWVudGF0aW9uLiBGb3IgZXhhbXBsZSwgdGhlIHByb3Bvc2VkIGFk
ZGl0aW9uIG9mIE1BUF9ESVJFQ1QgY2FuIGJlCj4+IGltcGxlbWVudGVkIHdpdGhvdXQgdGFraW5n
IHVwIGEgbmV3IHZtX2ZsYWdzIGJpdC4gQW5vdGhlciBtb3RpdmF0aW9uIHRvCj4+IGF2b2lkIHZt
X2ZsYWdzIGlzIHRoYXQgdGhleSBhcHBlYXIgaW4gL3Byb2MvJHBpZC9zbWFwcywgYW5kIHdlIGhh
dmUgc2Vlbgo+PiBzb2Z0d2FyZSB0aGF0IHRyaWVzIHRvIGRhbmdlcm91c2x5IChUT0NUT1UpIHJl
YWQgc21hcHMgdG8gaW5mZXIgdGhlCj4+IGJlaGF2aW9yIG9mIGEgdmlydHVhbCBhZGRyZXNzIHJh
bmdlLgo+Pgo+PiBUaGlzIGNvbnZlcnNpb24gd2FzIHBlcmZvcm1lZCBieSB0aGUgZm9sbG93aW5n
IHNlbWFudGljIHBhdGNoLiBUaGVyZQo+PiB3ZXJlIGEgZmV3IG1hbnVhbCBlZGl0cyBmb3Igb2Rk
aXRpZXMgbGlrZSBwcm9jX3JlZ19tbWFwLgo+Pgo+PiBUaGFua3MgdG8gSnVsaWEgZm9yIGhlbHBp
bmcgbWUgd2l0aCBjb2NjaW5lbGxlIGl0ZXJhdGlvbiB0byBjb3ZlciBjYXNlcwo+PiB3aGVyZSB0
aGUgbW1hcCByb3V0aW5lIGlzIGRlZmluZWQgaW4gYSBzZXBhcmF0ZSBmaWxlIGZyb20gdGhlICdz
dHJ1Y3QKPj4gZmlsZV9vcGVyYXRpb25zJyBpbnN0YW5jZSB0aGF0IGNvbnN1bWVzIGl0Lgo+Cj4g
SG93IGFyZSB3ZSBnb2luZyB0byBjaGVjayB0aGF0IGFuIGluc3RhbmNlIGFjdHVhbGx5IHN1cHBv
cnRzIGFueQo+IG9mIHRob3NlIGZsYWdzPwoKSW4gcGF0Y2ggMyBJIHZhbGlkYXRlIHRoZSBmbGFn
cyBieSBpbnRyb2R1Y2luZyBhbgoibW1hcF9zdXBwb3J0ZWRfbWFzayIgZmllbGQgdG8gJ3N0cnVj
dCBmaWxlX29wZXJhdGlvbnMnLiBJdCB3aWxsIGJlCnplcm8gYnkgZGVmYXVsdCBmb3IgYWxtb3N0
IGFsbCBpbXBsZW1lbnRhdGlvbnMgYW5kIHplcm8gbWVhbnMgInN1cHBvcnQKdGhlIGxlZ2FjeSBt
bWFwIGZsYWdzIi4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3Jn
Cmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
Cg==
