From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v5 2/2] staging: ion: create one device entry per heap
Date: Thu, 5 Oct 2017 15:06:12 +0200
Message-ID: <CA+M3ks5ZCUdTU5qU=Xi-MXXJQS6X-x=7qqs-5Myi7zeAAi8mJg@mail.gmail.com>
References: <1506518409-16887-1-git-send-email-benjamin.gaignard@linaro.org>
 <1506518409-16887-3-git-send-email-benjamin.gaignard@linaro.org>
 <2e15edc2-a17f-3930-7d5b-4b5b7d2e0a4d@redhat.com>
 <20171003164849.rcdgez6lbpmq5llt@sirena.org.uk>
 <2417c969-357f-d5d9-153a-2180d09b0dc6@redhat.com>
 <20171003230830.GA132839@sspatil-desktop.mtv.corp.google.com>
 <20171004101720.ob5f467tro7agpcz@sirena.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20171004101720.ob5f467tro7agpcz@sirena.co.uk>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Mark Brown <broonie@kernel.org>
Cc: driverdevel <devel@driverdev.osuosl.org>, Sandeep Patil <sspatil@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, linux-api@vger.kernel.org, Riley Andrews <riandrews@android.com>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-api@vger.kernel.org

MjAxNy0xMC0wNCAxMjoxNyBHTVQrMDI6MDAgTWFyayBCcm93biA8YnJvb25pZUBrZXJuZWwub3Jn
PjoKPiBPbiBUdWUsIE9jdCAwMywgMjAxNyBhdCAwNDowODozMFBNIC0wNzAwLCBTYW5kZWVwIFBh
dGlsIHdyb3RlOgo+Cj4+IEl0IGlzIGVudGlyZWx5IHBvc3NpYmxlIGFuZCBlYXN5IGluIGFuZHJv
aWQvdWV2ZW50ZCB0byBjcmVhdGUgdGhvc2Ugbm9kZXMKPj4gdW5kZXIgIi9kZXYvaW9uLyIuICAo
YXNzdW1pbmcgdGhlIGhlYXAgJ3N1YnN5c3RlbScgZm9yIHRoZXNlIG5ldyBkZXZpY2VzIHdpbGwK
Pj4gcG9pbnQgdG8gJ2lvbicpLgoKSSB0aGluayBpdCBpcyB0aGUgc2FtZSBwcm9ibGVtIHRoYW4g
Zm9yIHdlYmNhbSB1bmRlciB2NGwgZnJhbWV3b3JrLgpFYWNoIHRpbWUgeW91IHBsdWcgYSB3ZWJj
YW0geW91IGdvdCBhIHY0bCBub2RlIGJ1dCBhbmRyb2lkL3VldmVudCBydWxlcwp0aGUgcGx1ZyBv
cmRlciBkb2Vzbid0IGhhdmUgaW1wYWN0LgpUaGUgc2FtZSB0aGluayB3aWxsIGhhcHBlbiBmb3Ig
aW9uIG5vZGVzIGl0IG1heSBiZSBldmVuIGVhc2llciBiZWNhdXNlCnRoZSBoZWFwIHdpbGwgYWx3
YXlzIGJlaW5nIGNyZWF0ZWQgaW4gdGhlIHNtYWUgb3JkZXIgZm9yIGEgZ2l2ZW4gcHJvZHVjdApj
b25maWd1cmF0aW9uLgoKPgo+IFRoZSByZWFzb24gSSBkaWRuJ3Qgc2F5IC9kZXYvaW9uL2ZvbyBp
bml0aWFsbHkgaXMgdGhhdCBpZiBwZW9wbGUgd2FudCB0bwo+IGtlZXAgdGhlIGV4aXN0aW5nIC9k
ZXYvaW9uIGFyb3VuZCBmb3IgY29tcGF0aWJpbGl0eSByZWFzb25zIHRoZW4gdGhlCj4gL2Rldi9p
b24gbmFtZSBpc24ndCBhdmFpbGFibGUgd2hpY2ggbWlnaHQgY2F1c2UgaXNzdWVzLiAgT3RoZXJ3
aXNlIGp1c3QKPiBkdW1waW5nIGV2ZXJ5dGhpbmcgdW5kZXIgYSBkaXJlY3RvcnkgKHBlcmhhcHMg
d2l0aCBhIGRpZmZlcmVudCBuYW1lKSB3YXMKPiBteSBmaXJzdCB0aG91Z2h0IGFzIHdlbGwuCj4K
Pj4gKEFsc28gRldJVywgdGhlIFNFTGludXggcGVybWlzc2lvbnMgYXJlIGFsc28gcG9zc2libGUg
d2l0aCB0aGUgY3VycmVudCBpb24KPj4gaW1wbGVtZW50YXRpb24gYnkgYWRkaW5nIHJ1bGVzIHRv
IGRpc2FsbG93IHNwZWNpZmljIGlvY3RscyBpbnN0ZWFkIG9mIGFkZGluZwo+PiBwZXJtaXNzaW9u
cyB0byBhY2Nlc3MgZGV2aWNlIG5vZGUgYXMgdGhpcyBjaGFuZ2Ugd291bGQgZG8pCj4KPiBBSVVJ
IHRoZSByZXF1ZXN0IGlzIHRvIGxpbWl0IGFjY2VzcyB0byBzcGVjaWZpYyBoZWFwcywgYW5kIG9i
dmlvdXNseSBub3QKPiBldmVyeW9uZSB3YW50cyB0byBkZWFsIHdpdGggU0VMaW51eCBhdCBhbGwu
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmRyaS1kZXZl
bCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xp
c3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbAo=
