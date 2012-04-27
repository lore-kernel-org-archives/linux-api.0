From: "Myklebust, Trond" <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/6] Extended file stat system call
Date: Fri, 27 Apr 2012 00:30:30 +0000
Message-ID: <1335486630.2559.3.camel@lade.trondhjem.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <10104.1335477476-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <97D20760D41AC74DB579F031DEB22641-oP88Kt8RkgzdA/Lu/QRl1Q@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>, "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org" <wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org>, "kfm-devel-RoXCvvDuEio@public.gmane.org" <kfm-devel-RoXCvvDuEio@public.gmane.org>, "nautilus-list-rDKQcyrBJuzYtjvyW6yDsg@public.gmane.org" <nautilus-list-rDKQcyrBJuzYtjvyW6yDsg@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org" <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

T24gVGh1LCAyMDEyLTA0LTI2IGF0IDIyOjU3ICswMTAwLCBEYXZpZCBIb3dlbGxzIHdyb3RlOg0K
PiBNeWtsZWJ1c3QsIFRyb25kIDxUcm9uZC5NeWtsZWJ1c3RAbmV0YXBwLmNvbT4gd3JvdGU6DQo+
IA0KPiA+IFlvdSBhcmUgc3RpbGwgbm90IGV4cGxhaW5pbmcgd2h5IHRoZXkgbmVlZCB0byBrbm93
IHRoZSB2YWx1ZXMgYXQgYWxsPyBJZg0KPiA+IHRoZSB2YWx1ZXMgYXJlIGJvZ3VzLCB0aGVuIGRv
bid0IHJldHVybiB0aGVtLCBhbmQgZG9uJ3Qgc2V0IHRoZSBmbGFnDQo+ID4gdGhhdCBzYXlzIHRo
ZXkgYXJlIGJlaW5nIHJldHVybmVkLg0KPiB0aA0KPiBXaGF0IGlmIHRoZSB4c3RhdCgpIGFuZCBz
dHJ1Y3QgeHN0YXQgZXZlbnR1YWxseSBiZWNvbWVzIHdoYXQgdXNlcnNwYWNlIHVzZXMgYXMNCj4g
c3RhdCgpIChhcyBhIHdyYXBwZXIpIGFuZCBzdHJ1Y3Qgc3RhdCAoaWYgc3VjaCBhIHRoaW5nIGlz
IHBvc3NpYmxlIHdpdGggZ2xpYmMNCj4gdmVyc2lvbmluZyk/ICBEbyBvbGRlciBwcm9ncmFtcyB0
aGF0IHRoaW5rIHRoZXkncmUgdXNpbmcgc3RhdCgpIGFuZCBkb24ndCBrbm93DQo+IGFib3V0IHRo
ZSBleHRyYSBmaWVsZHMgYXZhaWxhYmxlIGV4cGVjdCB0byBzZWUgYSB1c2VmdWwgdmFsdWUgaW4g
c3RfaW5vPw0KDQpEb2VzIGl0IHJlYWxseSBtYXR0ZXIgd2hldGhlciBpdCBpcyB0aGUga2VybmVs
IG9yIHVzZXJsYW5kIHRoYXQgaXMNCnJlc3BvbnNpYmxlIGZvciBmYWtpbmcgdXAgaW5vZGUgbnVt
YmVycz8gSWYgdXNlcmxhbmQgd2FudHMgdG8gdXNlDQp4c3RhdCgpIGluIG9yZGVyIHRvIGZha2Ug
dXAgYSBzdGF0KCkgY2FsbCwgdGhlbiBpdCBnZXRzIHRvIHRha2UNCnJlc3BvbnNpYmlsaXR5IGZv
ciB0aGUgcmVzdWx0cy4NCg0KLS0gDQpUcm9uZCBNeWtsZWJ1c3QNCkxpbnV4IE5GUyBjbGllbnQg
bWFpbnRhaW5lcg0KDQpOZXRBcHANClRyb25kLk15a2xlYnVzdEBuZXRhcHAuY29tDQp3d3cubmV0
YXBwLmNvbQ0KDQo=
