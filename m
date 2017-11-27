From: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v6 2/2] staging: ion: create one device entry per heap
Date: Mon, 27 Nov 2017 17:12:23 +0100
Message-ID: <20171127161222.oig34dt2uc4lzpk2@phenom.ffwll.local>
References: <1509983985-20950-1-git-send-email-benjamin.gaignard@linaro.org>
 <1509983985-20950-3-git-send-email-benjamin.gaignard@linaro.org>
 <1e7fc718-825c-1028-1c28-a75a7320103f@redhat.com>
 <CA+M3ks6vP+W77QBzbczxzcV7YZCoBusC=wgjZPUNLrCYFFDARA@mail.gmail.com>
 <20171127114357.GB3710@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20171127114357.GB3710@kroah.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: driverdevel <devel@driverdev.osuosl.org>, linux-api@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Mark Brown <broonie@kernel.org>, Riley Andrews <riandrews@android.com>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-api@vger.kernel.org

T24gTW9uLCBOb3YgMjcsIDIwMTcgYXQgMTI6NDM6NTdQTSArMDEwMCwgR3JlZyBLcm9haC1IYXJ0
bWFuIHdyb3RlOgo+IE9uIE1vbiwgTm92IDI3LCAyMDE3IGF0IDExOjQ2OjE4QU0gKzAxMDAsIEJl
bmphbWluIEdhaWduYXJkIHdyb3RlOgo+ID4gMjAxNy0xMS0wOSAyMjoxNyBHTVQrMDE6MDAgTGF1
cmEgQWJib3R0IDxsYWJib3R0QHJlZGhhdC5jb20+Ogo+ID4gPiBPbiAxMS8wNi8yMDE3IDA3OjU5
IEFNLCBCZW5qYW1pbiBHYWlnbmFyZCB3cm90ZToKPiA+ID4+Cj4gPiA+PiBJbnN0ZWFkIGEgZ2V0
dGluZyBvbmx5IG9uZSBjb21tb24gZGV2aWNlICIvZGV2L2lvbiIgZm9yCj4gPiA+PiBhbGwgdGhl
IGhlYXBzIHRoaXMgcGF0Y2ggYWxsb3cgdG8gY3JlYXRlIG9uZSBkZXZpY2UKPiA+ID4+IGVudHJ5
ICgiL2Rldi9pb25YIikgcGVyIGhlYXAuCj4gPiA+PiBHZXR0aW5nIGFuIGVudHJ5IHBlciBoZWFw
IGNvdWxkIGFsbG93IHRvIHNldCBzZWN1cml0eSBydWxlcwo+ID4gPj4gcGVyIGhlYXAgYW5kIGds
b2JhbCBvbmVzIGZvciBhbGwgaGVhcHMuCj4gPiA+Pgo+ID4gPj4gQWxsb2NhdGlvbiByZXF1ZXN0
cyB3aWxsIGJlIG9ubHkgYWxsb3dlZCBpZiB0aGUgbWFza19pZAo+ID4gPj4gbWF0Y2ggd2l0aCBk
ZXZpY2UgbWlub3IuCj4gPiA+PiBRdWVyeSByZXF1ZXN0IGNvdWxkIGJlIGRvbmUgb24gYW55IG9m
IHRoZSBkZXZpY2VzLgo+ID4gPj4KPiA+ID4KPiA+ID4gV2l0aCB0aGlzIHBhdGNoLCBzeXNmcyBs
b29rcyBsaWtlOgo+ID4gPgo+ID4gPiAkIGxzIC9zeXMvZGV2aWNlcy8KPiA+ID4gYnJlYWtwb2lu
dCBpb24gcGxhdGZvcm0gc29mdHdhcmUgc3lzdGVtIHZpcnR1YWwKPiA+ID4KPiA+ID4gRnJvbSBh
biBJb24gcGVyc3BlY3RpdmUsIHlvdSBjYW4gaGF2ZQo+ID4gPgo+ID4gPiBBY2tlZC1ieTogTGF1
cmEgQWJib3R0IDxsYWJib3R0QHJlZGhhdC5jb20+Cj4gPiA+Cj4gPiA+IEFub3RoZXIgQWNrIGZv
ciB0aGUgZGV2aWNlIG1vZGVsIHN0dWZmIHdvdWxkIGJlIGdvb2QgYnV0IEknbGwKPiA+ID4gYXNz
dW1lIGRlYWZlbmluZyBzaWxlbmNlIG1lYW5zIG5vYm9keSBoYXRlcyBpdC4KPiA+IAo+ID4gR3Jl
ZywgY2FuIHdlIGdldCB5b3VyIHBvaW50IG9mIHZpZXcgb2YgdGhpcyA/Cj4gCj4gSXQncyAxIGRh
eSBhZnRlciB0aGUgbWVyZ2Ugd2luZG93IGhhcyBjbG9zZWQsIGFuZCBteSB0b2RvIHBhdGNoIHF1
ZXVlCj4gbG9va3MgbGlrZSB0aGlzOgo+IAkkIG1kZnJtIC1jIH4vbWFpbC90b2RvLwo+IAkxNTIz
IG1lc3NhZ2VzIGluIC9ob21lL2dyZWdraC9tYWlsL3RvZG8vCj4gCj4gUGxlYXNlIGdpdmUgbWUg
YSBjaGFuY2UgdG8gY2F0Y2ggdXAuLi4KCmNvbW1pdCBtb2RlbCBmdHcsIHdlIGhhdmUgNDAwKyBw
YXRjaGVzIGZvciA0LjE2IGFscmVhZHkgbWVyZ2VkIGFuZCB0ZXN0ZWQKYW5kIGFsbCByZWFkeSwg
cmlnaHQgd2hlbiAtcmMxIGdldHMgdGFnZ2VkLiBNYWtlcyB0aGUgbWVyZ2Ugd2luZG93IHRoZQpt
b3N0IHJlbGF4ZWQgdGltZSBvZiBhbGwsIGJlY2F1c2UgYWxsIHRoZSBvdGhlciBtYWludGFpbmVy
cyBhcmUgZHJvd25pbmcKYW5kIHdvbnQgcGVzdGVyIHlvdS4KCkp1c3Qgc2F5aW5nLCB0aGlzIGlz
IGFuIGVudGlyZWx5IGZpeGFibGUgcHJvYmxlbSA6LVAKCkNoZWVycywgRGFuaWVsCi0tIApEYW5p
ZWwgVmV0dGVyClNvZnR3YXJlIEVuZ2luZWVyLCBJbnRlbCBDb3Jwb3JhdGlvbgpodHRwOi8vYmxv
Zy5mZndsbC5jaApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
XwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcK
aHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWwK
