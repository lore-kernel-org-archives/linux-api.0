From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: RE: [PATCH 2/4] swait: add the missing killable swaits
Date: Thu, 29 Jun 2017 16:31:08 +0000
Message-ID: <BY2PR21MB00365B4A70BD334F4568A086CBD20@BY2PR21MB0036.namprd21.prod.outlook.com>
References: <20170614222017.14653-1-mcgrof@kernel.org>
 <20170614222017.14653-3-mcgrof@kernel.org> <20170629125402.GH26046@kroah.com>
 <alpine.DEB.2.20.1706291504570.1861@nanos> <20170629133530.GA14747@kroah.com>
 <alpine.DEB.2.20.1706291545320.1861@nanos>
 <CA+55aFxkp51RipBj7__T0hoy6tAdXJxTqjMdhnnnkKm71P6HuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxkp51RipBj7__T0hoy6tAdXJxTqjMdhnnnkKm71P6HuQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "mfuzzey@parkeon.com" <mfuzzey@parkeon.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, "jewalt@lgsinnovations.com" <jewalt@lgsinnovations.com>, "rafal@milecki.pl" <rafal@milecki.pl>, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Li, Yi" <yi1.li@linux.intel.com>, "atull@kernel.org" <atull@kernel.org>, Moritz Fischer <moritz.fischer@ettus.com>, Petr Mladek <pmladek@suse.com>, Johannes Berg <johannes.berg@intel.com>, Emmanuel Grumbach <emmanuel.grumbach@intel.com>, "Coelho, Luciano" <luciano.coelho@intel.com>
List-Id: linux-api@vger.kernel.org

TGludXMgVG9ydmFsZHMgd3JvdGU6DQo+IFRoZSB0aGluZyBpcyBzaW1wbHkgYSBjb2xsZWN0aW9u
IG9mIHNtYWxsIGhhY2tzIGFuZCBzaG91bGQgTk9UIGJlIHVzZWQNCj4gaW4gZ2VuZXJhbC4NCj4g
DQo+IEkgbmV2ZXIgd2FudCB0byBzZWUgYSBkcml2ZXIgdXNlIHRoYXQgY29kZSwgZm9yIGV4YW1w
bGUuIEl0IHdhcw0KPiBkZXNpZ25lZCBmb3IgUkNVIGFuZCBSVCwgYW5kIGl0IHNob3VsZCBkYW1u
IHdlbGwgYmUgbGltaXRlZCB0byB0aGF0Lg0KDQpNYXliZSBwdXQgI2lmbmRlZiBNT0RVTEUgYXJv
dW5kIHRoZSBlbnRpcmUgaW5jbHVkZSBmaWxlIHRoZW4/DQpBbmQgZGVmaW5pdGVseSByZW1vdmUg
dGhpcyBsaW5lOg0KDQoqIE9uZSB3b3VsZCByZWNvbW1lbmQgdXNpbmcgdGhpcyB3YWl0IHF1ZXVl
IHdoZXJlIHBvc3NpYmxlLg0KDQoNCg==
