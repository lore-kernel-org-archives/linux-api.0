From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH 11/10] pipe: Add fsync() support [ver #2]
Date: Sat, 2 Nov 2019 15:30:49 -0700
Message-ID: <E590C3AF-1D09-4927-B83F-DD0A6A148B6D@amacapital.net>
References: <CAHk-=wj1BLz6s9cG9Ptk4ULxrTy=MkF7ZH=HF67d7M5HL1fd_A@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wj1BLz6s9cG9Ptk4ULxrTy=MkF7ZH=HF67d7M5HL1fd_A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Nov 2, 2019, at 3:04 PM, Linus Torvalds <torvalds@linux-foundation.org>=
 wrote:
>=20
> =EF=BB=BFOn Sat, Nov 2, 2019 at 1:31 PM Andy Lutomirski <luto@amacapital.n=
et> wrote:
>>=20
>> Add in the fact that it=E2=80=99s not obvious that vmsplice *can* be used=
 correctly, and I=E2=80=99m wondering if we should just remove it or make it=
 just do write() under the hood.
>=20
> Sure it can. Just don't modify the data you vmsplice. It's really that sim=
ple.

So you allocate memory, vmsplice, and munmap() without reusing it?  Just pla=
in free() won=E2=80=99t be good enough. I suspect the TLB overhead will make=
 this a loss in most workloads?

Or maybe you vmsplice from a read-only mapping of a file that you know no on=
e modifies?  This could be useful, but you can just splice() from the file d=
irectly.=
