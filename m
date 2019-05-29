From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH RFC v8 01/10] namei: obey trailing magic-link DAC permissions
Date: Wed, 29 May 2019 08:10:00 -0700
Message-ID: <9712F80E-1016-4DB7-996D-B423E07A1C1F@amacapital.net>
References: <20190520133305.11925-1-cyphar@cyphar.com> <20190520133305.11925-2-cyphar@cyphar.com> <CALCETrVCwe49q5mu=f6jTYNSgosQSjjY5chukMPo6eZtQGqo5g@mail.gmail.com> <20190523020009.mi25uziu2b3whf4l@yavin> <20190524031109.v24r6typyug2rlto@yavin>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190524031109.v24r6typyug2rlto@yavin>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Christian Brauner <christian@brauner.io>, Eric Biederman <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Containers <contai>
List-Id: linux-api@vger.kernel.org



> On May 23, 2019, at 8:11 PM, Aleksa Sarai <cyphar@cyphar.com> wrote:
>=20
>> On 2019-05-23, Aleksa Sarai <cyphar@cyphar.com> wrote:
>>> On 2019-05-22, Andy Lutomirski <luto@kernel.org> wrote:
>>> What are actual examples of uses for this exception?  Breaking
>>> selftests is not, in and of itself, a huge problem.
>>=20
>> Not as far as I know. All of the re-opening users I know of do re-opens
>> of O_PATH or are re-opening with the same (or fewer) privileges. I also
>> ran this for a few days on my laptop without this exception, and didn't
>> have any visible issues.
>=20
> I have modified the patch to WARN_ON(may_open_magiclink() =3D=3D -EACCES).=

>=20
> So far (in the past day on my openSUSE machines) I have only seen two
> programs which have hit this case: kbd[1]'s "loadkeys" and "kbd_mode"
> binaries. In addition to there not being any user-visible errors -- they
> actually handle permission errors gracefully!
>=20
>  static int
>  open_a_console(const char *fnam)
>  {
>      int fd;
>=20
>      /*
>       * For ioctl purposes we only need some fd and permissions
>       * do not matter. But setfont:activatemap() does a write.
>       */
>      fd =3D open(fnam, O_RDWR);
>      if (fd < 0)
>          fd =3D open(fnam, O_WRONLY);
>      if (fd < 0)
>          fd =3D open(fnam, O_RDONLY);
>      if (fd < 0)
>          return -1;
>      return fd;
>  }
>=20
> The above gets called with "/proc/self/fd/0" as an argument (as well as
> other console candidates like "/dev/console"). And setfont:activatemap()
> actually does handle read-only fds:
>=20
>  static void
>  send_escseq(int fd, const char *seq, int n)
>  {
>      if (write(fd, seq, n) !=3D n) /* maybe fd is read-only */
>          printf("%s", seq);
>  }
>=20
>  void activatemap(int fd)
>  {
>      send_escseq(fd, "\033(K", 3);
>  }
>=20
> So, thus far, not only have I not seen anything go wrong -- the only
> program which actually hits this case handles the error gracefully.
> Obviously we got lucky here, but the lack of any users of this
> mis-feature leads me to have some hope that we can block it without
> anyone noticing.
>=20
> But I emphatically do not want to break userspace here (except for
> attackers, obviously).

Hmm. This will break any script that does echo foo >/dev/stdin too.

Just to throw an idea out there, what if the open were allowed if the file m=
ode is sufficient or if the magic link target is openable with the correct m=
ode without magic?  In other words, first check as in your code but without t=
he exception and, if that check fails, then walk the same path that d_path w=
ould return and see if it would work as a normal open?  Of course, that seco=
nd attempt would need to disable magic links to avoid recursing.  I=E2=80=99=
m not sure I love this idea...

Otherwise, I imagine we can live with the exception, especially if the new o=
pen API turns it off by default.
