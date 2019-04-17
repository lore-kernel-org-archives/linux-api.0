From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: RFC: on adding new CLONE_* flags [WAS Re: [PATCH 0/4] clone: add CLONE_PIDFD]
Date: Wed, 17 Apr 2019 09:46:49 -0700
Message-ID: <DA79A567-A002-4935-80A3-AB273C750AFD@amacapital.net>
References: <20190414201436.19502-1-christian@brauner.io> <dc05ffe3-c2ff-8b3e-d181-e0cc620bf91d@metux.net> <20190415195911.z7b7miwsj67ha54y@yavin> <CALCETrWxMnaPvwicqkMLswMynWvJVteazD-bFv3ZnBKWp-1joQ@mail.gmail.com> <87v9zc6cz2.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87v9zc6cz2.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, "Enrico Weigelt, metux IT consult" <lkml@metux.net>, Christian Brauner <christian@brauner.io>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Joel Fernandes <joel@joelfernandes.org>, Daniel
List-Id: linux-api@vger.kernel.org



> On Apr 17, 2019, at 5:19 AM, Florian Weimer <fweimer@redhat.com> wrote:
>=20
> * Andy Lutomirski:
>=20
>> I would personally *love* it if distros started setting no_new_privs
>> for basically all processes.
>=20
> Wouldn't no_new_privs inhibit all security transitions, including those
> that reduce privileges?  And therefore effectively reduce security?

In principle, you still can reduce privileges with no_new_privs.  SELinux ha=
s a whole mechanism for privilege-reducing transitions on exec that works in=
 no_new_privs mode. Also, all the traditional privilege dropping techniques w=
ork =E2=80=94 setresuid(), unshare(), etc are all unaffected.

>=20
>> There seems to be some demand to be able to do large
> parts of container setup using posix_spawn, so we'll probably add
> support for things like writing to arbitrary files eventually.  And of
> course, proper error reporting, so that you can figure out which file
> creation action failed.
>=20

ISTM the way to handle this is to have a way to make a container, set it up,=
 and then clone/spawn into it.  The current unshare() API is severely awkwar=
d.

Maybe the new better kernel spawn API shouldn=E2=80=99t support unshare-like=
 semantics at all and should instead work like setns().=
