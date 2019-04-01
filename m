From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sun, 31 Mar 2019 20:13:38 -0600
Message-ID: <18C7FCB9-2CBA-4237-94BB-9C4395A2106B@amacapital.net>
References: <20190329155425.26059-1-christian@brauner.io> <CAHk-=wjq4dTPcz-qsvhpm5F42SDHCoqEWv1V=rs_kt6MC=ZThA@mail.gmail.com> <BCD99947-5F55-4116-8F74-D6832E50340B@brauner.io> <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com> <CAKOZuevv_QgvzmusA+yey76vo4hn9bEVwud2RumuOr0K4++15A@mail.gmail.com> <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com> <20190330171215.3yrfxwodstmgzmxy@brauner.io> <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com> <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net> <CAHk-=wiaLtH41Mc5qAjOeCWavPqV0DhS581KYa0QBt8uraTK1Q@mail.gmail.com> <20190331211041.vht7dnqg4e4bilr2@brauner.io> <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <christian@brauner.io>, Daniel Colascione <dancol@google.com>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@>
List-Id: linux-api@vger.kernel.org



> On Mar 31, 2019, at 3:17 PM, Linus Torvalds <torvalds@linux-foundation.org=
> wrote:
>=20
>> On Sun, Mar 31, 2019 at 2:10 PM Christian Brauner <christian@brauner.io> w=
rote:
>>=20
>> I don't think that we want or can make them equivalent since that would
>> mean we depend on procfs.
>=20
> Sure we can.
>=20
> If /proc is enabled, then you always do that dance YOU ALREADY WROTE
> THE CODE FOR to do the stupid ioctl.
>=20
> And if /procfs isn't enabled, then you don't do that.
>=20
> Ta-daa. Done. No stupid ioctl, and now /proc and pidfd_open() return
> the same damn thing.
>=20
> And guess what? If /proc isn't enabled, then obviously pidfd_open()
> gives you the /proc-less thing, but at least there is no crazy "two
> different file descriptors for the same thing" situation, because then
> the /proc one doesn't exist.
>=20

I wish we could do this, and, in a clean design, it would be a no-brainer.  B=
ut /proc has too much baggage.  Just to mention two such things, there=E2=80=
=99s =E2=80=9Cnet=E2=80=9D and =E2=80=9C../sys=E2=80=9D.  This crud is why w=
e have all kinds of crazy rules that prevent programs in sandboxes from maki=
ng a new mounts and mounting /proc in it.  If we make it possible to clone a=
 new process and this access /proc without having /proc mounted, we=E2=80=99=
ll open up a big can of worms.

Maybe we could have a sanitized view of /proc and make a pidfd be a director=
y fd pointing at that.=
