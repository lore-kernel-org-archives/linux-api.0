From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] io_uring: use __kernel_timespec in timeout ABI
Date: Tue, 1 Oct 2019 17:57:42 +0200
Message-ID: <CAK8P3a19TDk0uo1eu4CcaKHvQCPUJGMjBV8Txtpgvg1ifAgW_A@mail.gmail.com>
References: <20190930202055.1748710-1-arnd@arndb.de>
 <8d5d34da-e1f0-1ab5-461e-f3145e52c48a@kernel.dk>
 <623e1d27-d3b1-3241-bfd4-eb94ce70da14@kernel.dk>
 <CAK8P3a3AAFXNmpQwuirzM+jgEQGj9tMC_5oaSs4CfiEVGmTkZg@mail.gmail.com>
 <ca0a5bbe-c20e-d5be-110e-942c604ad2d7@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <ca0a5bbe-c20e-d5be-110e-942c604ad2d7@kernel.dk>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Hannes Reinecke <hare@suse.com>, y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, Jackie Liu <liuyun01@kylinos.cn>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, =?UTF-8?Q?Stefan_B=C3=BChler?= <source@stbuehler.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Hristo Venev <hristo@venev.name>
List-Id: linux-api@vger.kernel.org

T24gVHVlLCBPY3QgMSwgMjAxOSBhdCA1OjUyIFBNIEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5k
az4gd3JvdGU6Cj4gT24gMTAvMS8xOSA5OjQ5IEFNLCBBcm5kIEJlcmdtYW5uIHdyb3RlOgo+ID4g
T24gVHVlLCBPY3QgMSwgMjAxOSBhdCA1OjM4IFBNIEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5k
az4gd3JvdGU6Cgo+ID4gV2hhdCdzIHdyb25nIHdpdGggdXNpbmcgX19rZXJuZWxfdGltZXNwZWM/
IEp1c3QgdGhlIG5hbWU/Cj4gPiBJIHN1cHBvc2UgbGlidXJpbmcgY291bGQgYWRkIGEgbWFjcm8g
dG8gZ2l2ZSBpdCBhIGRpZmZlcmVudCBuYW1lCj4gPiBmb3IgaXRzIHVzZXJzLgo+Cj4gSnVzdCB0
aGF0IGl0IHNlZW1zIEkgbmVlZCB0byBtYWtlIGl0IGF2YWlsYWJsZSB0aHJvdWdoIGxpYnVyaW5n
IG9uCj4gc3lzdGVtcyB0aGF0IGRvbid0IGhhdmUgaXQgeWV0LiBOb3QgYSBiaWcgZGVhbCwgdGhv
dWdoLgoKQWgsIHJpZ2h0LiBJIHQgd291bGQgbm90IGNvdmVyIHRoZSBjYXNlIG9mIGJ1aWxkaW5n
IGFnYWluc3Qga2VybmVsCmhlYWRlcnMgZWFybGllciB0aGFuIGxpbnV4LTUuMSBidXQgcnVubmlu
ZyBvbiBhIDUuNCsga2VybmVsLgoKSSBhc3N1bWVkIHRoYXQgdGhhdCB5b3Ugd291bGQgcmVxdWly
ZSBuZXcga2VybmVsIGhlYWRlcnMgYW55d2F5LApidXQgaWYgeW91IGhhdmUgYSBjb3B5IG9mIHRo
ZSBpb191cmluZyBoZWFkZXIsIHRoYXQgaXMgbm90IG5lY2Vzc2FyeS4KCj4gT25lIHRoaW5nIHRo
YXQgc3RydWNrIG1lIGFib3V0IHRoaXMgYXBwcm9hY2ggLSB3ZSB0aGVuIGxvc2UgdGhlIGFiaWxp
dHkgdG8KPiBkaWZmZXJlbnRpYXRlIGJldHdlZW4gImRvbid0IHdhbnQgYSB0aW1lZCB0aW1lb3V0
IiB3aXRoIHRzID09IE5VTEwsIHZzCj4gdHZfc2VjIGFuZCB0dl9uc2VjIGJvdGggYmVpbmcgMC4K
CllvdSBjb3VsZCBhbHdheXMgZGVmaW5lIGEgc3BlY2lhbCBjb25zdGFudCBzdWNoIGFzCicjZGVm
aW5lIElPX1VSSU5HX1RJTUVPVVRfTkVWRVIgLTF1bGwnIGlmIHlvdSB3YW50IHRvCnN1cHBvcnQg
Zm9yICduZXZlciB3YWl0IGlmIGl0J3Mgbm90IGFscmVhZHkgZG9uZScgYW5kICd3YWl0IGluZGVm
aW5pdGVseScuCgo+IEkgdGhpbmsgSSdsbCBzdHVjayB3aXRoIHRoYXQgeW91IGhhZCBhbmQganVz
dCB1c2UgX19rZXJuZWxfdGltZXNwZWMgaW4KPiBsaWJ1cmluZy4KCk9rLgoKICAgICAgIEFybmQK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWTIwMzggbWFp
bGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6Ly9saXN0cy5saW5hcm8ub3Jn
L21haWxtYW4vbGlzdGluZm8veTIwMzgK
