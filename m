From: "Edgecombe, Rick P" <rick.p.edgecombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] mm: extend memfd with ability to create "secret"
 memory areas
Date: Tue, 11 Feb 2020 19:52:47 +0000
Message-ID: <ab0a11ad5fde0cc71a725aac3ea81cc996e35bf1.camel@intel.com>
References: <20200130162340.GA14232@rapoport-lnx>
         <df5a888b-1a11-e806-741d-94684b22c966@intel.com>
         <20200208173922.GA15879@hump>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200208173922.GA15879@hump>
Content-Language: en-US
Content-ID: <7C45F3DD1BF1A748ACA077A657B22C5C-Hry67jCOGbCcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "alan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <alan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org" <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Reshetova, Elena" <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "tycho-E0fblnxP3wo@public.gmane.org" <tycho-E0fblnxP3wo@public.gmane.org>, "luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

T24gU2F0LCAyMDIwLTAyLTA4IGF0IDE5OjM5ICswMjAwLCBNaWtlIFJhcG9wb3J0IHdyb3RlOg0K
PiA+IERvIHdlIG5lZWQgdG8gbWFrZSBrbWFwKCkgd29yayBvbiB0aGVzZT8NCj4gDQo+IEkgZG9u
J3QgdGhpbmsgd2UgbmVlZCB0byBtYWtlIGttYXAoKSB3b3JrIG9uIHRoZXNlLiBUaGUgaWRlYSBp
cyB0byBwcmV2ZW50DQo+IGtlcm5lbCBmcm9tIGFjY2Vzc2luZyBzdWNoIG1lbW9yeSBhcmVhcy4N
Cg0KRm9yIHRoZSBWTSB1c2UgY2FzZSwgS1ZNIGRvZXMga21hcCgpIGd1ZXN0IG1lbW9yeSB3aGVu
IGVtdWxhdGluZyBwYWdlIHRhYmxlDQpvcGVyYXRpb25zIGluIHNvbWUgY2FzZXM6DQphcmNoL3g4
Ni9rdm0vcGFnaW5nX3RtcGwuaDpGTkFNRShjbXB4Y2hnX2dwdGUpLg0K
