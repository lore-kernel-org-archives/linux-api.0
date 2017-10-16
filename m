From: Laura Abbott <labbott@redhat.com>
Subject: Re: [PATCH v5 2/2] staging: ion: create one device entry per heap
Date: Mon, 16 Oct 2017 15:09:11 -0700
Message-ID: <2a9246e0-eafa-7812-6cf4-2482ff1ed158@redhat.com>
References: <1506518409-16887-3-git-send-email-benjamin.gaignard@linaro.org>
 <2e15edc2-a17f-3930-7d5b-4b5b7d2e0a4d@redhat.com>
 <20171003164849.rcdgez6lbpmq5llt@sirena.org.uk>
 <2417c969-357f-d5d9-153a-2180d09b0dc6@redhat.com>
 <20171003230830.GA132839@sspatil-desktop.mtv.corp.google.com>
 <20171004101720.ob5f467tro7agpcz@sirena.co.uk>
 <CA+M3ks5ZCUdTU5qU=Xi-MXXJQS6X-x=7qqs-5Myi7zeAAi8mJg@mail.gmail.com>
 <e3f91eff-df33-e203-2ce2-1f1dc98236ef@redhat.com>
 <20171009220858.zwbguqkamzmswqcq@sirena.co.uk>
 <dda39ec7-e1d7-8a11-2470-271cb7ba66e7@redhat.com>
 <20171010091151.rfdsphstboubm7ps@sirena.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20171010091151.rfdsphstboubm7ps@sirena.co.uk>
Content-Language: en-US
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
Cc: driverdevel <devel@driverdev.osuosl.org>, Sandeep Patil <sspatil@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, =?UTF-8?Q?Arve_Hj=c3=b8nnev=c3=a5g?= <arve@android.com>, linux-api@vger.kernel.org, Riley Andrews <riandrews@android.com>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-api@vger.kernel.org

T24gMTAvMTAvMjAxNyAwMjoxMSBBTSwgTWFyayBCcm93biB3cm90ZToKPiBPbiBNb24sIE9jdCAw
OSwgMjAxNyBhdCAwNToxMDozN1BNIC0wNzAwLCBMYXVyYSBBYmJvdHQgd3JvdGU6Cj4+IE9uIDEw
LzA5LzIwMTcgMDM6MDggUE0sIE1hcmsgQnJvd24gd3JvdGU6Cj4+PiBPbiBNb24sIE9jdCAwOSwg
MjAxNyBhdCAwMjoyNTo0N1BNIC0wNzAwLCBMYXVyYSBBYmJvdHQgd3JvdGU6Cj4gCj4+Pj4gQW55
d2F5LCB0byBtb3ZlIHRoaXMgZm9yd2FyZCBJIHRoaW5rIHdlIG5lZWQgdG8gc2VlIGEgcHJvb2Yg
b2YgY29uY2VwdAo+Pj4+IG9mIHVzaW5nIHNlbGludXggdG8gcHJvdGVjdCBhY2Nlc3MgdG8gc3Bl
Y2lmaWMgaGVhcHMuCj4gCj4+PiBBcmVuJ3QgVW5peCBwZXJtaXNzaW9ucyBlbm91Z2ggd2l0aCBz
ZXBhcmF0ZSBmaWxlcyBvciBhbSBJCj4+PiBtaXN1bmRlcnN0YW5kaW5nIHdoYXQgeW91J3JlIGxv
b2tpbmcgdG8gc2VlIGEgcHJvb2Ygb2YgY29uY2VwdCBmb3I/Cj4gCj4+IFRoZSBnb2FsIGlzIHRv
IGJlIGFibGUgdG8gcmVzdHJpY3QgaGVhcCBhY2Nlc3MgdG8gY2VydGFpbiBzZXJ2aWNlcwo+PiBh
bmQgc2VsaW51eCBncm91cHMgb24gQW5kcm9pZCBzbyBzdHJhaWdodCB1bml4IHBlcm1pc3Npb25z
IGFyZW4ndAo+PiBzdWZmaWNpZW50Lgo+IAo+IE9oLCB0aGVyZSdzIEFuZHJvaWQgdXNlcnMgZm9y
IHRoaXM/ICBUaGUgdXNlcnMgSSB3YXMgYXdhcmUgb2Ygd2VyZQo+IG5vbi1BbmRyb2lkLiAgVGhv
dWdoIGV2ZW4gc28gSSdkIGhhdmUgdGhvdWdodCB0aGF0IGdpdmVuIHRoYXQgU0VMaW51eCBpcwo+
IGEgc3VwZXJzZXQgb2YgVW5peCBmaWxlIHBlcm1pc3Npb25zIGl0IG91Z2h0IHRvIGJlIHN1ZmZp
Y2llbnQgdG8gYmUgYWJsZQo+IHRvIHVzZSB0aGVtLiAgSSdkIGJlZW4gdGhpbmtpbmcgcGVvcGxl
IHdlcmUgc3VnZ2VzdGluZyBTRUxpbnV4IGFzIGEKPiByZXBsYWNlbWVudCBmb3IgZmlsZSBwZXJt
aXNzaW9ucywgdXNpbmcgdGhlIHNpbmdsZSBmaWxlIGFuZCB0aGUgZ3JlYXRlcgo+IGNhcGFiaWxp
dGllcyBvZiBTRUxpbnV4Lgo+IApVbml4IGZpbGUgcGVybWlzc2lvbnMgYXJlIG5lY2Vzc2FyeSBi
dXQgbm90IHN1ZmZpY2llbnQsIHRoZXkKY2FuIGJlIHVzZWQgc2VwYXJhdGVseS4gTW9zdGx5IHdo
YXQgSSB3YW50IHRvIHNlZSBiZWZvcmUKbWVyZ2luZyB0aGlzIGlzIGFuIGV4YW1wbGUgdGhhdCBz
cGxpdHRpbmcgdGhlIElvbiBoZWFwcyBwcm92aWRlcwptb3JlIHByb3RlY3Rpb24gdGhhbiBqdXN0
IGtlZXBpbmcgL2Rldi9pb24uCgpUaGFua3MsCkxhdXJhCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVs
QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWls
bWFuL2xpc3RpbmZvL2RyaS1kZXZlbAo=
