From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 7/7] [RFC] [media] introduce v4l2_timespec type
	for timestamps
Date: Tue, 15 Sep 2015 22:27:56 +0200
Message-ID: <1872149.XE0by8RQTx@wuerfel>
References: <1442332148-488079-1-git-send-email-arnd@arndb.de>
 <1442332148-488079-8-git-send-email-arnd@arndb.de>
 <55F84824.2000603@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <55F84824.2000603@xs4all.nl>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: y2038@lists.linaro.org
Cc: linux-samsung-soc@vger.kernel.org, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
List-Id: linux-api@vger.kernel.org

T24gVHVlc2RheSAxNSBTZXB0ZW1iZXIgMjAxNSAxODozMjozNiBIYW5zIFZlcmt1aWwgd3JvdGU6
Cj4gPiAgCj4gPiAtICAgICBrdGltZV9nZXRfdHMoJnRpbWVzdGFtcCk7Cj4gPiArICAgICBrdGlt
ZV9nZXRfdHM2NCgmdGltZXN0YW1wKTsKPiA+ICsgICAgIHZ0cy50dl9zZWMgPSB0aW1lc3RhbXAu
dHZfc2VjOwo+ID4gKyAgICAgdnRzLnR2X25zZWMgPSB0aW1lc3RhbXAudHZfbnNlYzsKPiAKPiBJ
IHByZWZlciB0byB0YWtlIHRoaXMgb3Bwb3J0dW5pdHkgdG8gY3JlYXRlIGEgdjRsMl9nZXRfdGlt
ZXNwZWMgaGVscGVyCj4gZnVuY3Rpb24sIGp1c3QgbGlrZSB2NGwyX2dldF90aW1ldmFsLgoKT2ss
IGdvb2QgaWRlYS4gSSdsbCBkbyB0aGF0IG9uY2Ugd2UgaGF2ZSBhZ3JlZWQgb24gdGhlIEFCSS4K
Cj4gPiBAQCAtMjA4OCw3ICsyMDk0LDcgQEAgc3RydWN0IHY0bDJfZXZlbnQgewo+ID4gICAgICAg
fSB1Owo+ID4gICAgICAgX191MzIgICAgICAgICAgICAgICAgICAgICAgICAgICBwZW5kaW5nOwo+
ID4gICAgICAgX191MzIgICAgICAgICAgICAgICAgICAgICAgICAgICBzZXF1ZW5jZTsKPiA+IC0g
ICAgIHN0cnVjdCB0aW1lc3BlYyAgICAgICAgICAgICAgICAgdGltZXN0YW1wOwo+ID4gKyAgICAg
c3RydWN0IHY0bDJfdGltZXNwZWMgICAgICAgICAgICB0aW1lc3RhbXA7Cj4gPiAgICAgICBfX3Uz
MiAgICAgICAgICAgICAgICAgICAgICAgICAgIGlkOwo+ID4gICAgICAgX191MzIgICAgICAgICAg
ICAgICAgICAgICAgICAgICByZXNlcnZlZFs4XTsKPiA+ICB9Owo+ID4gCj4gCj4gSSB0aGluayBJ
IGFtIE9LIHdpdGggdGhpcy4gVGhpcyB0aW1lc3RhbXAgaXMgdXNlZCBtdWNoIG1vcmUgcmFyZWx5
IGFuZCBJIGRvCj4gbm90IGV4cGVjdCB0aGlzIEFCSSBjaGFuZ2UgdG8gY2F1c2UgYW55IHByb2Js
ZW1zIGluIHVzZXJzcGFjZS4KCkknZCBzdGlsbCB3YWl0IHRoZSBvdXRjb21lIG9mIHRoZSB2NGwy
X3RpbWV2YWwgZGlzY3Vzc2lvbiB0aG91Z2guIEl0IG1heQpiZSB1c2VmdWwgZm9yIGNvbnNpc3Rl
bmN5IHRvIHBpY2sgdGhlIHNhbWUgYXBwcm9hY2ggZm9yIGJvdGggc3RydWN0dXJlcy4KCglBcm5k
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClkyMDM4IG1h
aWxpbmcgbGlzdApZMjAzOEBsaXN0cy5saW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMubGluYXJvLm9y
Zy9tYWlsbWFuL2xpc3RpbmZvL3kyMDM4Cg==
