From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sun, 31 Mar 2019 14:09:03 -0600
Message-ID: <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net>
References: <20190329155425.26059-1-christian@brauner.io> <CAHk-=wjq4dTPcz-qsvhpm5F42SDHCoqEWv1V=rs_kt6MC=ZThA@mail.gmail.com> <BCD99947-5F55-4116-8F74-D6832E50340B@brauner.io> <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com> <CAKOZuevv_QgvzmusA+yey76vo4hn9bEVwud2RumuOr0K4++15A@mail.gmail.com> <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com> <20190330171215.3yrfxwodstmgzmxy@brauner.io> <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <christian@brauner.io>, Daniel Colascione <dancol@google.com>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@>
List-Id: linux-api@vger.kernel.org



> On Mar 30, 2019, at 11:24 AM, Linus Torvalds <torvalds@linux-foundation.or=
g> wrote:
>=20
>> On Sat, Mar 30, 2019 at 10:12 AM Christian Brauner <christian@brauner.io>=
 wrote:
>>=20
>>=20
>> To clarify, what the Android guys really wanted to be part of the api is
>> a way to get race-free access to metadata associated with a given pidfd.
>> And the idea was that *if and only if procfs is mounted* you could do:
>>=20
>> int pidfd =3D pidfd_open(1234, 0);
>>=20
>> int procfd =3D open("/proc", O_RDONLY | O_CLOEXEC);
>> int procpidfd =3D ioctl(pidfd, PIDFD_TO_PROCFD, procfd);
>=20
> And my claim is that this is three system calls - one of them very
> hacky - to just do
>=20
>    int pidfd =3D open("/proc/%d", O_PATH);

Hi Linus-

I want to re-check this because I think Christian=E2=80=99s example was bad.=
  I proposed these ioctls, but that wasn=E2=80=99t the intended use.  The re=
al point is:

int pidfd =3D new_improved_clone(...);

To be useful, this type of API *must* work without proc mounted.

And, later:

openat(fd to pidfd=E2=80=99s proc directory, =E2=80=9Cstatus=E2=80=9D, ...);=


And we want a non-utterly-crappy way to do this.  The ioctl is certainly ugl=
y, but it *works*.

Another approach is:

pid_t pid =3D pidfd_get_pid(pidfd);
sprintf(buf, =E2=80=9C/proc/%d=E2=80=9D, pid);
int procfd =3D open(buf, O_PATH);
if (pidfd_get_pid(pidfd) !=3D pid) {
  we lose;
}

But this is clunky.

Do you think the clunky version is okay, or do you have a suggestion for mak=
ing it better?

=E2=80=94Andy
