From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v6 2/2] staging: ion: create one device entry per heap
Date: Tue, 28 Nov 2017 18:08:22 +0100
Message-ID: <20171128170822.GA22359@kroah.com>
References: <1509983985-20950-1-git-send-email-benjamin.gaignard@linaro.org>
 <1509983985-20950-3-git-send-email-benjamin.gaignard@linaro.org>
 <20171128133217.GA29995@kroah.com>
 <20171128162620.levmpcgaixilwq3n@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20171128162620.levmpcgaixilwq3n@sirena.org.uk>
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
Cc: devel@driverdev.osuosl.org, linux-api@vger.kernel.org, arve@android.com, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, riandrews@android.com, dan.carpenter@oracle.com
List-Id: linux-api@vger.kernel.org

T24gVHVlLCBOb3YgMjgsIDIwMTcgYXQgMDQ6MjY6MjBQTSArMDAwMCwgTWFyayBCcm93biB3cm90
ZToKPiBPbiBUdWUsIE5vdiAyOCwgMjAxNyBhdCAwMjozMjoxN1BNICswMTAwLCBHcmVnIEtIIHdy
b3RlOgo+IAo+ID4gV2hlcmUgaXMgdGhlIGRvY3VtZW50YXRpb24gZm9yIHRoZSBuZXcgc3lzZnMg
ZmlsZXMgYW5kIHRoZSBuZXcgaW9jdGwKPiAKPiBEaWRuJ3Qgc2VlIGFueSBzeXNmcyBmaWxlcyBp
biB0aGVyZT8KCk5ldyBzdHJ1Y3QgZGV2aWNlcyB3ZXJlIGNyZWF0ZWQgYW5kIHJlZ2lzdGVyZWQu
ICBXaHkgd291bGQgdGhhdCBoYXBwZW4KaWYgdGhlcmUgd2FzIG5vdCBhIG5lZWQgZm9yIHN5c2Zz
IGZpbGVzPyA6KQoKPiA+IGNhbGwgeW91IGFkZGVkPyAgV2hhdCBkaWQgeW91IGRvIHRvIHRlc3Qg
dGhpcyBvdXQ/ICBXaGVyZSBhcmUgdGhlIEFPU1AKPiA+IHBhdGNoZXMgdG8gdXNlIHRoaXM/ICBI
YXBwZW4gdG8gaGF2ZSBhIFZUUyB0ZXN0IGZvciBpdD8KPiAKPiBEbyB3ZSBuZWVkIHRvIGNvbnZl
cnQgQW5kcm9pZCBmb3IgdGhpcyB0byBiZSBhY2NlcHRlZD8gIFRoZSBzaW5nbGUKPiBkZXZpY2Ug
aXMgYmVpbmcga2VwdCBhcm91bmQgZm9yIGl0IGFuZCB0aGUgdXNlIGNhc2Ugd2FzIGZyb20gbm9u
LUFuZHJvaWQKPiB1c2VycyB3YXNuJ3QgaXQ/CgpTbyB3ZSBhcmUganVzdCBnb2luZyB0byBhZGQg
a2VybmVsIGZlYXR1cmVzIHdpdGggbm8gdXNlcnNwYWNlIHVzZXJzIG9mCml0IGF0IGFsbD8gIFdo
eSB3b3VsZCB3ZSBkbyB0aGF0PyAgSG93IHdhcyBpdCBldmVuIHRlc3RlZD8KCmdyZWcgay1oCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmRyaS1kZXZlbCBt
YWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3Rz
LmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbAo=
