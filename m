From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v6 2/2] staging: ion: create one device entry per heap
Date: Mon, 6 Nov 2017 15:42:04 +0100
Message-ID: <CA+M3ks5pV=j_DeQ9ohhtv62WL=pzWH0Q5jdKtQby5vs=NUZT-Q@mail.gmail.com>
References: <1508774137-13835-1-git-send-email-benjamin.gaignard@linaro.org>
 <1508774137-13835-3-git-send-email-benjamin.gaignard@linaro.org>
 <3e3af8e3-76c5-754c-caaa-3f8c9b54723f@redhat.com>
 <20171031191153.avolosp6n5gb3xao@sirena.co.uk>
 <20171102104407.GA14048@kroah.com>
 <20171102111019.kpsvobvzfiezdndp@sirena.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20171102111019.kpsvobvzfiezdndp@sirena.co.uk>
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
Cc: driverdevel <devel@driverdev.osuosl.org>, Greg KH <gregkh@linuxfoundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Riley Andrews <riandrews@android.com>, linux-api@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-api@vger.kernel.org

MjAxNy0xMS0wMiAxMjoxMCBHTVQrMDE6MDAgTWFyayBCcm93biA8YnJvb25pZUBrZXJuZWwub3Jn
PjoKPiBPbiBUaHUsIE5vdiAwMiwgMjAxNyBhdCAxMTo0NDowN0FNICswMTAwLCBHcmVnIEtIIHdy
b3RlOgo+PiBPbiBUdWUsIE9jdCAzMSwgMjAxNyBhdCAwNzoxMTo1M1BNICswMDAwLCBNYXJrIEJy
b3duIHdyb3RlOgo+Cj4+ID4gVGhlcmUgd2FzIGEgZGlzY3Vzc2lvbiBhIHdoaWxlIGFnbyBpbiB0
aGUgY29udGV4dCBvZiBJMkMvU1BJIE1GRHMKPj4gPiB3aGljaCBjb25jbHVkZWQgdGhhdCBpZiB5
b3UgbmVlZCBhIGJ1cyBhbmQgaXQncyBnb2luZyB0byBiZSBlZmZlY3RpdmVseQo+PiA+IG5vb3Ag
dGhlbiB5b3Ugc2hvdWxkIGp1c3QgdXNlIHRoZSBwbGF0Zm9ybSBidXMgYXMgYW55dGhpbmcgZWxz
ZSB3aWxsCj4+ID4gY29uc2lzdCBhbG1vc3QgZW50aXJlbHkgb2YgY3V0J24ncGFzdGUgZnJvbSB0
aGUgcGxhdGZvcm0gYnVzIHdpdGggc29tZQo+PiA+IGxpZ2h0IHNlZCB1c2FnZSBhbmQgY29kZSBk
dXBsaWNhdGlvbiBpcyBiYWQuICBJdCdzIG5vdCBzdXBlciBsb3ZlbHkgYXMKPj4gPiBpdCdzIG5v
dCBhY3R1YWxseSBhIG1lbW9yeSBtYXBwZWQgZGV2aWNlIGJ1dCBpdCdzIHRoZSBiZXN0IGlkZWEg
d2UndmUKPj4gPiBnb3QuCj4KPj4gVWdoLCBJIGhhdGUgdGhhdC4gIFdoYXQncyB3cm9uZyB3aXRo
IHVzaW5nIGEgInZpcnR1YWwiIGRldmljZSBpbnN0ZWFkPwo+Cj4gSXQgd2FzIHRoZSBkdXBsaWNh
dGlvbiwgaW5pdGlhbGx5IGV2ZXJ5b25lIHdhcyBtYWtpbmcgYnVzZXMuCj4KPj4gSSBjYW4gY3Jl
YXRlIGEgInZpcnR1YWwiIGJ1cyBmb3IgdGhpbmdzIGxpa2UgdGhpcyBpZiB0aGV5IHJlYWxseSB3
YW50IGEKPj4gInNpbXBsZSIgYnVzLCBhYnVzaW5nIHBsYXRmb3JtIGZvciB0aGlzIGlzIHRoZSBt
YWpvciByZWFzb24gSSBoYXRlIHRoZQo+PiBwbGF0Zm9ybSBidXMgY29kZS4uLgo+Cj4gSW4gdGhl
IE1GRCBjYXNlIHRoZXkncmUgcGh5c2ljYWwgZGV2aWNlcywgdGhleSdyZSBqdXN0IHVzdWFsbHkg
b24gdGhlCj4gd3Jvbmcgc2lkZSBvZiBhbiBJMkMgb3IgU1BJIGxpbmsuICBQbHVzIE1GRCBhbHJl
YWR5IGhhbmRsZXMgcGxhdGZvcm0KPiBkZXZpY2VzIGZvciB0aGluZ3MgdGhhdCBhcmUgbWVtb3J5
IG1hcHBlZCBzbyBpdCdzIGEgYml0IG9mIGEgbW9yZQo+IG5hdHVyYWwgZml0IHRoZXJlLgoKV2hh
dCBJIGNhbiBkbyBpcyB0byByZWdpc3RlciBhbiBpb24gYnVzIChsaWtlIGNlYyBvbmUgZm9yIGV4
YW1wbGUpLAphZGQgb25lIGlvbiBwYXJlbnQgZGV2aWNlIHNvIGhlYXBzIHdpbGwgYXBwZWFyIGlu
IC9zeXMvYnVzL2lvbi9pb24qCmFuZCAvc3lzL2RldmljZXMvaW9uL2lvbioKCkRvZXMgdGhhdCBj
b3VsZCBzb3VuZCBnb29kIGVub3VnaCA/CgpCZW5qYW1pbgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZl
bEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFp
bG1hbi9saXN0aW5mby9kcmktZGV2ZWwK
