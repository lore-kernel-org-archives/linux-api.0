From: Al Grant <Al.Grant-5wv7dgnIgG8@public.gmane.org>
Subject: RE: [PATCH V2 3/6] stm class: provision for statically assigned
 masterIDs
Date: Mon, 8 Feb 2016 17:44:49 +0000
Message-ID: <AM4PR08MB0785EAA2B628765D7EA3FDA086D50@AM4PR08MB0785.eurprd08.prod.outlook.com>
References: <1454487337-30184-1-git-send-email-zhang.chunyan@linaro.org>
	<1454487337-30184-4-git-send-email-zhang.chunyan@linaro.org>
	<87mvrf5ngl.fsf@ashishki-desk.ger.corp.intel.com>
	<CANLsYky2twQ98u241YyHD=atYRp1N56YVHUQNY2E2Ljsq0cseA@mail.gmail.com>
	<87twlj49k7.fsf@ashishki-desk.ger.corp.intel.com>
 <CANLsYkw=mG+ch8QzxmbwWs9o+mndVNo1MuqXcrPrNJYj_SQcHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANLsYkw=mG+ch8QzxmbwWs9o+mndVNo1MuqXcrPrNJYj_SQcHQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Nicolas GUION <nicolas.guion-qxv4g6HH51o@public.gmane.org>, Jon Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, Mike Leach <Mike.Leach-5wv7dgnIgG8@public.gmane.org>, "Jeremiassen, Tor" <tor-l0cyMroinI0@public.gmane.org>, Lyra Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

PiBNaWtlIGRpZCB3cml0ZSAibWFzdGVyIElEcyBhcmUgaGFyZHdpcmVkIHRvIGluZGl2aWR1YWwg
Y29yZXMgYW5kIGNvcmUgc2VjdXJpdHkNCj4gc3RhdGVzIiwgd2hpY2ggbWFrZSBhc3NpZ25tZW50
IGZvciBvbmUgcGxhdGZvcm0gdmVyeSBzdGF0aWMuDQo+IE9uIHRoZSBmbGlwIHNpZGUgdGhvc2Ug
d2lsbCBjaGFuZ2UgZnJvbSBvbmUgc3lzdGVtIHRvIGFub3RoZXIuDQoNCkl0IGRlcGVuZHMgb24g
eW91ciBwZXJzcGVjdGl2ZS4gIEZyb20gdGhlIHBlcnNwZWN0aXZlIG9mIGEgdXNlcnNwYWNlDQpw
cm9jZXNzIG5vdCBwaW5uZWQgdG8gYSBjb3JlLCB0aGUgbWFzdGVyIGlkIHdpbGwgYXBwZWFyIHRv
IHZhcnkNCmR5bmFtaWNhbGx5IGFuZCB1bnByZWRpY3RhYmx5IGFzIHRoZSB0aHJlYWQgbWlncmF0
ZXMgZnJvbSBvbmUNCmNvcmUgdG8gYW5vdGhlci4gIChUaGF0J3MgYWN0dWFsbHkgdXNlZnVsIGlm
IHRoZSBkZWNvZGVyIHdhbnRzIHRvIGtub3cNCndoZXJlIHRoZSB0aHJlYWQgaXMgcnVubmluZyBh
dCBhbnkgZ2l2ZW4gcG9pbnQsIGFzIGl0IGNhbiBmaW5kIHRoYXQgb3V0DQpmb3IgZnJlZSwgd2l0
aG91dCB0aGUgbmVlZCB0byB0cmFjayBtaWdyYXRpb24gZXZlbnRzLikNCg0KT24gdGhlIG90aGVy
IGhhbmQgaWYgeW91IGFyZSBwaW5uZWQgKGUuZy4geW91J3JlIHRoZSBrZXJuZWwgb24gYQ0KcGFy
dGljdWxhciBjb3JlLCBvciB5b3UncmUgYSBwZXItY29yZSB3b3JrZXIgdGhyZWFkIGluIHNvbWUg
dGhyZWFkDQpwb29saW5nIHN5c3RlbSkgdGhlbiB5b3UgaGF2ZSBhIGZpeGVkIG1hc3RlciBpZCwg
YW5kIHRoZW4geW91IGNhbg0KaGF2ZSBvbmUgaW5zdGFuY2UgcGVyIGNvcmUgYWxsIHVzaW5nIHRo
ZSBzYW1lIHJhbmdlIG9mIGNoYW5uZWwNCm51bWJlcnMsIHdpdGggdGhlIG1hc3RlciBpZCBpbmRp
Y2F0aW5nIHRoZSBjb3JlIC0gdGhpcyBzYXZlcyBvbg0KY2hhbm5lbCBzcGFjZSBjb21wYXJlZCB0
byBoYXZpbmcgdG8gZ2l2ZSBlYWNoIGNvcmUgaXRzIG93bg0KcmFuZ2Ugb2YgY2hhbm5lbCBzcGFj
ZS4NCg0KQWwNCklNUE9SVEFOVCBOT1RJQ0U6IFRoZSBjb250ZW50cyBvZiB0aGlzIGVtYWlsIGFu
ZCBhbnkgYXR0YWNobWVudHMgYXJlIGNvbmZpZGVudGlhbCBhbmQgbWF5IGFsc28gYmUgcHJpdmls
ZWdlZC4gSWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVkIHJlY2lwaWVudCwgcGxlYXNlIG5vdGlm
eSB0aGUgc2VuZGVyIGltbWVkaWF0ZWx5IGFuZCBkbyBub3QgZGlzY2xvc2UgdGhlIGNvbnRlbnRz
IHRvIGFueSBvdGhlciBwZXJzb24sIHVzZSBpdCBmb3IgYW55IHB1cnBvc2UsIG9yIHN0b3JlIG9y
IGNvcHkgdGhlIGluZm9ybWF0aW9uIGluIGFueSBtZWRpdW0uIFRoYW5rIHlvdS4NCg==
