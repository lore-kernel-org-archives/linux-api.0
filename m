From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v2 0/5] pid: add pidfd_open()
Date: Mon, 1 Apr 2019 17:00:03 +0000
Message-ID: <8c53a2601a3742bbb017a2a8aca77eaf@AcuMS.aculab.com>
References: <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com>
 <CAKOZuevv_QgvzmusA+yey76vo4hn9bEVwud2RumuOr0K4++15A@mail.gmail.com>
 <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com>
 <20190330171215.3yrfxwodstmgzmxy@brauner.io>
 <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
 <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net>
 <CAHk-=wiaLtH41Mc5qAjOeCWavPqV0DhS581KYa0QBt8uraTK1Q@mail.gmail.com>
 <20190331211041.vht7dnqg4e4bilr2@brauner.io>
 <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
 <18C7FCB9-2CBA-4237-94BB-9C4395A2106B@amacapital.net>
 <20190401114059.7gdsvcqyoz2o5bbz@yavin>
 <CAHk-=wgKqBQznZdTQaM6yQ+_5dcz-+q8=2sbQsAoDh55hQTLMA@mail.gmail.com>
 <CAKOZuev4Q4CY0-2rUpTujSKMVJ9L9Exv=_divFC0G0_OaQHaGw@mail.gmail.com>
 <CAGLj2rF85hZLAR79oEA1dQARadw1OHr8bxqCLbvO6g9B6ou2Qw@mail.gmail.com>
 <CAKOZuetovU9NawSjUfGTAwXVfnmKC9GFtmS8FxAE5Hjmzq0HHA@mail.gmail.com>
 <CAHk-=wjgENV0pT8=MjB1UVBeWCrECCNXv15AKKX7Kfg7Eak7qw@mail.gmail.com>
 <CAKOZuet2QCoW1XMpTAzXS868PhF-gh14czFn4gwE4A=oX=Yr8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuet2QCoW1XMpTAzXS868PhF-gh14czFn4gwE4A=oX=Yr8w@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Daniel Colascione' <dancol@google.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jonathan Kowalski <bl0pbl33p@gmail.com>, Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@amacapital.net>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux>
List-Id: linux-api@vger.kernel.org

RnJvbTogRGFuaWVsIENvbGFzY2lvbmUNCj4gU2VudDogMDEgQXByaWwgMjAxOSAxNzo0NQ0KLi4u
DQo+ID4gTm93LCBub25lIG9mIHRoaXMgd2FzIGV2ZXIgcmVhbGx5IHVzZWQuIFRoZSBwZW9wbGUg
d2hvIHdhbnRlZCBBSU8NCj4gPiB3YW50ZWQgdGhlIGJyYWluLWRhbWFnZWQgUE9TSVgga2luZCBv
ZiBBSU8sIG5vdCBzb21ldGhpbmcgY29vbCBhbmQNCj4gPiBjbGV2ZXIuIFNvIEkgc3VzcGVjdCB0
aGUgd2hvbGUgZXhpdC1zaWduYWwgdGhpbmcgd2FzIGp1c3QgdXNlZCBmb3INCj4gPiByYW5kb20g
c21hbGwgcGVyLXByb2plY3QgdGhpbmdzLg0KPiANCj4gQUlPIGlzIGEgd2hvbGUgb3RoZXIgYmFs
bCBvZiB3YXguIDotKQ0KDQpGb3IgQUlPIHlvdSBuZWVkIHRvIGdvIGJhY2sgYW5kIHRlbGwgSyZS
IHRvIHVzZSB0aGUgSU9fUUlPIHN0dWZmIGZyb20NClJTWC8xMU0gcmF0aGVyIHRoYW4gdGhlICdJ
TyBpbiBwcm9jZXNzIGNvbnRleHQnIHRoZXkgdXNlZCBmb3IgVW5peCA6LSkNCg0KVGhlbiB5b3Un
ZCBlbmQgdXAgd2l0aCB0aGUgd2luZG93cyBrZXJuZWwuLi4uLg0KDQoJRGF2aWQNCg0KLQ0KUmVn
aXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRv
biBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K
