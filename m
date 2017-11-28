From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v6 2/2] staging: ion: create one device entry per heap
Date: Tue, 28 Nov 2017 19:00:16 +0100
Message-ID: <20171128180016.GA10169@kroah.com>
References: <1509983985-20950-1-git-send-email-benjamin.gaignard@linaro.org>
 <1509983985-20950-3-git-send-email-benjamin.gaignard@linaro.org>
 <20171128133217.GA29995@kroah.com>
 <20171128162620.levmpcgaixilwq3n@sirena.org.uk>
 <20171128170822.GA22359@kroah.com>
 <20171128171223.qnd7z7h2lnxy5lkd@sirena.org.uk>
 <20171128172838.GA31113@kroah.com>
 <20171128173753.t7dk6n7ouwypmumw@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20171128173753.t7dk6n7ouwypmumw@sirena.org.uk>
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

T24gVHVlLCBOb3YgMjgsIDIwMTcgYXQgMDU6Mzc6NTNQTSArMDAwMCwgTWFyayBCcm93biB3cm90
ZToKPiBPbiBUdWUsIE5vdiAyOCwgMjAxNyBhdCAwNjoyODozOFBNICswMTAwLCBHcmVnIEtIIHdy
b3RlOgo+ID4gT24gVHVlLCBOb3YgMjgsIDIwMTcgYXQgMDU6MTI6MjNQTSArMDAwMCwgTWFyayBC
cm93biB3cm90ZToKPiAKPiA+ID4gSSB0aGluayBpdCdzIHJlYXNvbmFibGUgdG8gYXNrIGZvciB1
c2Vyc3BhY2UsIEknbSBxdWVyeWluZyB3aHkgaXQgbmVlZHMKPiA+ID4gdG8gc3BlY2lmaWNhbGx5
IGJlIEFuZHJvaWQuCj4gCj4gPiBEb2VzIGFueW9uZSBvdGhlciB0aGFuIEFuZHJvaWQgdXNlIHRo
aXMgaW50ZXJmYWNlPwo+IAo+IFRoZXJlJ3MgcGxlbnR5IG9mIG90aGVyIHVzZXJzcGFjZXMgdGhh
dCBoYXZlIHRoZSBzYW1lIHJlcXVpcmVtZW50cyBmb3IKPiBhbGxvY2F0aW9uIGZvciBhcHBsaWNh
dGlvbnMgbGlrZSB2aWRlbyBjYXB0dXJlLCBJIGJlbGlldmUgc29tZSBvZiB0aGVtCj4gaGF2ZSBh
Y3R1YWxseSBtb3ZlZCB0byBJT04gYWxyZWFkeSBhbmQgdGhleSdyZSBjZXJ0YWlubHkgd2hlcmUg
c29tZSBvZgo+IHRoZSByZXF1aXJlbWVudHMgaGVyZSBhcmUgY29taW5nIGZyb20uCgpUaGVuIHRo
ZSBLY29uZmlnIG9wdGlvbiBzaG91bGQgc3RhcnQgdG8gZGVzY3JpYmUgc29tZSBvZiB0aGlzIDop
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmRyaS1kZXZl
bCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xp
c3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbAo=
