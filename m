From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH 11/10] pipe: Add fsync() support [ver #2]
Date: Sat, 2 Nov 2019 13:31:10 -0700
Message-ID: <CC3328CC-2F05-461E-AAC3-8DEBAB1BA162@amacapital.net>
References: <25886.1572723272@warthog.procyon.org.uk>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <25886.1572723272@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Nov 2, 2019, at 12:34 PM, David Howells <dhowells@redhat.com> wrote:
>=20
> =EF=BB=BFLinus Torvalds <torvalds@linux-foundation.org> wrote:
>=20
>>>> Similar synchronization is required for reusing memory after vmsplice()=
?
>>>> I don't see other way how sender could safely change these pages.
>=20
> Actually, it's probably worse than that.  If the output of the pipe gets t=
eed
> or spliced somewhere else, you still don't know when the vmspliced pages a=
re
> finished with.
>=20
>=20

I sometimes wonder whether vmsplice should be disallowed or severely restric=
ted. Even ignoring these usability issues, it makes me very uncomfortable th=
at you can have some data queue up on a pipe, tee() it, and get *different* d=
ata in the original pipe and the teed copy because the sender used vmsplice a=
nd is messing with you.

Add in the fact that it=E2=80=99s not obvious that vmsplice *can* be used co=
rrectly, and I=E2=80=99m wondering if we should just remove it or make it ju=
st do write() under the hood.

I suppose the kernel could guarantee that it stops referring to the vmsplice=
 source pages as soon as anything sees *or* tees the data. This way it would=
 be, at least in principle, possible to say =E2=80=9Chey, the pipe has consu=
med the first n vmspliced bytes, so I can reuse that memory=E2=80=9D.=
