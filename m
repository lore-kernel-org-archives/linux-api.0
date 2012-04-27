From: "Myklebust, Trond" <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/6] Extended file stat system call
Date: Fri, 27 Apr 2012 00:33:06 +0000
Message-ID: <1335486786.2559.6.camel@lade.trondhjem.org>
References: <1335460011.9701.30.camel@lade.trondhjem.org>
	 <20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
	 <CAH2r5ms4WQV3DnTvqNN=2N71Cj8UHwj8Z6+RHXgrAOv6mSoyQg@mail.gmail.com>
	 <20656.1335450358@redhat.com>
	 <CAH2r5mv1Lijdwk5zsQwYJr4Etb6fhrRyNXm-iFCQX+HecboGrQ@mail.gmail.com>
	 <1335453958.9701.10.camel@lade.trondhjem.org>
	 <CAH2r5mt5af-_hxBRKK72iD5Gr99bo91ec78Rov8EGVEx8=21mA@mail.gmail.com>
	 <1335459642.9701.27.camel@lade.trondhjem.org>
	 <CAH2r5mvmCfLrxRHje6Wx5X84zxPEHwRMUJGsjvWBujMu7w841w@mail.gmail.com>
	 <10104.1335477476@redhat.com>
	 <20120426220552.D98D62C0D3@topped-with-meat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120426220552.D98D62C0D3-j1d2VQoJOwwHfwO+Tb3JRVaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <8E5B68735050F648AFA35C4B20BDE1F9-oP88Kt8RkgzdA/Lu/QRl1Q@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>, "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org" <wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org>, "kfm-devel-RoXCvvDuEio@public.gmane.org" <kfm-devel-RoXCvvDuEio@public.gmane.org>, "nautilus-list-rDKQcyrBJuzYtjvyW6yDsg@public.gmane.org" <nautilus-list-rDKQcyrBJuzYtjvyW6yDsg@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org" <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

T24gVGh1LCAyMDEyLTA0LTI2IGF0IDE1OjA1IC0wNzAwLCBSb2xhbmQgTWNHcmF0aCB3cm90ZToN
Cj4gPiBXaGF0IGlmIHRoZSB4c3RhdCgpIGFuZCBzdHJ1Y3QgeHN0YXQgZXZlbnR1YWxseSBiZWNv
bWVzIHdoYXQgdXNlcnNwYWNlDQo+ID4gdXNlcyBhcyBzdGF0KCkgKGFzIGEgd3JhcHBlcikgYW5k
IHN0cnVjdCBzdGF0IChpZiBzdWNoIGEgdGhpbmcgaXMNCj4gPiBwb3NzaWJsZSB3aXRoIGdsaWJj
IHZlcnNpb25pbmcpPyAgDQo+IA0KPiBJdCdzIGNlcnRhaW5seSBwb3NzaWJsZSB3aXRoIHN5bWJv
bCB2ZXJzaW9uaW5nLCB0aG91Z2ggaXQgc2VlbXMgbXVjaCBtb3JlDQo+IGxpa2VseSB0aGF0IHdl
J2Qgc3RpY2sgd2l0aCB0aGUgZXhpc3Rpbmcgc3RydWN0IHN0YXQgYW5kIHN0YXQqIGludGVyZmFj
ZXMNCj4gYW5kIG9ubHkgaGF2ZSB0aGUgaW1wbGVtZW50YXRpb24gdXNpbmcgc3RhdHggdW5kZXJu
ZWF0aCAoZS5nLiBmb3IgbmV3DQo+IG1hY2hpbmVzIG9yIGtlcm5lbCBBQklzIHdoZXJlIHRoZSBr
ZXJuZWwgc3RvcHMgcHJvdmlkaW5nIGFueSBjYWxscyBleGNlcHQNCj4gZm9yIHN0YXR4YXQpLCBh
dCBsZWFzdCBmb3IgdGhlIGZvcmVzZWVhYmxlIGZ1dHVyZS4NCj4gDQo+ID4gRG8gb2xkZXIgcHJv
Z3JhbXMgdGhhdCB0aGluayB0aGV5J3JlIHVzaW5nIHN0YXQoKSBhbmQgZG9uJ3Qga25vdyBhYm91
dA0KPiA+IHRoZSBleHRyYSBmaWVsZHMgYXZhaWxhYmxlIGV4cGVjdCB0byBzZWUgYSB1c2VmdWwg
dmFsdWUgaW4gc3RfaW5vPw0KPiANCj4gUE9TSVggcmVxdWlyZXMgdGhhdCBzdF9pbm8gaGF2ZSBh
IHVzZWZ1bCB2YWx1ZSBmb3IgdGhlIHN0YW5kYXJkICpzdGF0IGNhbGxzLg0KDQpZZXMsIGJ1dCB3
ZSdyZSB0YWxraW5nIGFib3V0IG5vbi1QT1NJWCBmaWxlc3lzdGVtcyBoZXJlLiBJZiB0aGUNCmZp
bGVzeXN0ZW0gZG9lc24ndCBoYXZlIGEgdXNlZnVsIHZhbHVlIGZvciBzdF9pbm8sIHRoZW4gdGhl
IHVzdWFsIHdheSBvZg0KZGVhbGluZyB3aXRoIHRob3NlIFBPU0lYIHJlcXVpcmVtZW50cyBpcyB0
byBmYWtlIHVwIHZhbHVlcy4gVGhlIHF1ZXN0aW9uDQp0aGVuIGJlY29tZXMgd2hldGhlciBvciBu
b3Qgd2UgY2FyZSBpZiBpdCBpcyB0aGUga2VybmVsIG9yIHVzZXJsYW5kIHRoYXQNCmZha2VzIHVw
IHRob3NlIHZhbHVlcy4NCg0KLS0gDQpUcm9uZCBNeWtsZWJ1c3QNCkxpbnV4IE5GUyBjbGllbnQg
bWFpbnRhaW5lcg0KDQpOZXRBcHANClRyb25kLk15a2xlYnVzdEBuZXRhcHAuY29tDQp3d3cubmV0
YXBwLmNvbQ0KDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
