From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>
Subject: RE: [PATCH v4 3/8] iio: Add support for DA9150 GPADC
Date: Mon, 8 Dec 2014 13:23:07 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A0337AB52290B@SW-EX-MBX01.diasemi.com>
References: <cover.1416938054.git.Adam.Thomson.Opensource@diasemi.com>
 <377be6cf23ba23dac0b21fe2a449307ec5bac63a.1416938054.git.Adam.Thomson.Opensource@diasemi.com>
 <5480E7F4.7090808@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5480E7F4.7090808-Mmb7MZpHnFY@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, "Opensource [Adam Thomson]" <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Support Opensource <Support.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

T24gRGVjZW1iZXIgMDQsIDIwMTQgMjM6MDIsIEhhcnRtdXQgS25hYWNrIHdyb3RlOg0KDQo+ID4g
KwlpbmRpb19kZXYgPSBkZXZtX2lpb19kZXZpY2VfYWxsb2MoJnBkZXYtPmRldiwNCj4gPiArCQkJ
CQkgIHNpemVvZihzdHJ1Y3QgZGE5MTUwX2dwYWRjKSk7DQo+IEJUVzogSWYgeW91IHVzZSBzaXpl
b2YoKmdwYWRjKSBpbnN0ZWFkIChsaWtlIGl0IGlzIHVzdWFsbHkgZG9uZSBhcyB3ZWxsKSwNCj4g
aXQgd2lsbCBwZXJmZWN0bHkgZml0IGluIG9uZSBsaW5lLg0KDQpJIHByZWZlcnJlZCB0byBiZSBl
eHBsaWNpdCB0aGF0IHRoZSBpdGVtIGlzIGEgc3RydWN0LCBidXQgcmVhbGx5IG5vdCB0aGF0IGZ1
c3NlZA0KZWl0aGVyIHdheS4gQWxzbyBoYXZlIGJlZW4gYXNrZWQgcHJldmlvdXNseSBpbiBhIHNl
cGFyYXRlIGRyaXZlciB0byBtYWtlIHRoZQ0Kc2FtZSBtb2QgeW91IG1lbnRpb24gc28gd2lsbCB1
cGRhdGUgYWNjb3JkaW5nbHkuDQoNCj4gPiArCXJldCA9IGRldm1fcmVxdWVzdF90aHJlYWRlZF9p
cnEoZGV2LCBpcnEsIE5VTEwsIGRhOTE1MF9ncGFkY19pcnEsDQo+ID4gKwkJCQkJSVJRRl9PTkVT
SE9ULCAiR1BBREMiLCBncGFkYyk7DQo+ID4gKwlpZiAocmV0KSB7DQo+ID4gKwkJZGV2X2Vycihk
ZXYsICJGYWlsZWQgdG8gcmVxdWVzdCBJUlEgJWQ6ICVkXG4iLCBpcnEsIHJldCk7DQo+ID4gKwkJ
Z290byBpaW9fbWFwX3VucmVnOw0KPiBZb3UgbmVlZCB0byByZXR1cm4gcmV0IGhlcmUsIG5vIGp1
bXAgdG8gZXJyb3Igb3V0IHBhdGguDQoNClllcywgdGhhbmtzLiBBbm5veWVkIEkgbWlzc2VkIHRo
YXQgaW4gdGhlIHJlLWZhY3Rvci4gV2lsbCBmaXggaXQuDQo=
