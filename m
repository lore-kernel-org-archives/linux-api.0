From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v6 5/6] binfmt_*: scope path resolution of interpreters
Date: Mon, 6 May 2019 16:41:00 -0700
Message-ID: <A982EE7E-7E92-460A-A458-2F9C3586E9DA@amacapital.net>
References: <20190506165439.9155-1-cyphar@cyphar.com> <20190506165439.9155-6-cyphar@cyphar.com> <CAG48ez0-CiODf6UBHWTaog97prx=VAd3HgHvEjdGNz344m1xKw@mail.gmail.com> <20190506191735.nmzf7kwfh7b6e2tf@yavin>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190506191735.nmzf7kwfh7b6e2tf@yavin>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Jann Horn <jannh@google.com>, Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Christian Brauner <christian@brauner.io>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux
List-Id: linux-api@vger.kernel.org



> On May 6, 2019, at 12:17 PM, Aleksa Sarai <cyphar@cyphar.com> wrote:
>=20
>> On 2019-05-06, Jann Horn <jannh@google.com> wrote:
>>> On Mon, May 6, 2019 at 6:56 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
>>> The need to be able to scope path resolution of interpreters became
>>> clear with one of the possible vectors used in CVE-2019-5736 (which
>>> most major container runtimes were vulnerable to).
>>>=20
>>> Naively, it might seem that openat(2) -- which supports path scoping --
>>> can be combined with execveat(AT_EMPTY_PATH) to trivially scope the
>>> binary being executed. Unfortunately, a "bad binary" (usually a symlink)=

>>> could be written as a #!-style script with the symlink target as the
>>> interpreter -- which would be completely missed by just scoping the
>>> openat(2). An example of this being exploitable is CVE-2019-5736.
>>>=20
>>> In order to get around this, we need to pass down to each binfmt_*
>>> implementation the scoping flags requested in execveat(2). In order to
>>> maintain backwards-compatibility we only pass the scoping AT_* flags.
>>>=20
>>> To avoid breaking userspace (in the exceptionally rare cases where you
>>> have #!-scripts with a relative path being execveat(2)-ed with dfd !=3D
>>> AT_FDCWD), we only pass dfd down to binfmt_* if any of our new flags are=

>>> set in execveat(2).
>>=20
>> This seems extremely dangerous. I like the overall series, but not this p=
atch.
>>=20
>>> @@ -1762,6 +1774,12 @@ static int __do_execve_file(int fd, struct filena=
me *filename,
>>>=20
>>>        sched_exec();
>>>=20
>>> +       bprm->flags =3D flags & (AT_XDEV | AT_NO_MAGICLINKS | AT_NO_SYML=
INKS |
>>> +                              AT_THIS_ROOT);
>> [...]
>>> +#define AT_THIS_ROOT           0x100000 /* - Scope ".." resolution to d=
irfd (like chroot(2)). */
>>=20
>> So now what happens if there is a setuid root ELF binary with program
>> interpreter "/lib64/ld-linux-x86-64.so.2" (like /bin/su), and an
>> unprivileged user runs it with execveat(..., AT_THIS_ROOT)? Is that
>> going to let the unprivileged user decide which interpreter the
>> setuid-root process should use? =46rom a high-level perspective, opening
>> the interpreter should be controlled by the program that is being
>> loaded, not by the program that invoked it.
>=20
> I went a bit nuts with openat_exec(), and I did end up adding it to the
> ELF interpreter lookup (and you're completely right that this is a bad
> idea -- I will drop it from this patch if it's included in the next
> series).
>=20
> The proposed solutions you give below are much nicer than this patch so
> I can drop it and work on fixing those issues separately.
>=20
>> In my opinion, CVE-2019-5736 points out two different problems:
>>=20
>> The big problem: The __ptrace_may_access() logic has a special-case
>> short-circuit for "introspection" that you can't opt out of; this
>> makes it possible to open things in procfs that are related to the
>> current process even if the credentials of the process wouldn't permit
>> accessing another process like it. I think the proper fix to deal with
>> this would be to add a prctl() flag for "set whether introspection is
>> allowed for this process", and if userspace has manually un-set that
>> flag, any introspection special-case logic would be skipped.
>=20
> We could do PR_SET_DUMPABLE=3D3 for this, I guess?
>=20
>> An additional problem: /proc/*/exe can be used to open a file for
>> writing; I think it may have been Andy Lutomirski who pointed out some
>> time ago that it would be nice if you couldn't use /proc/*/fd/* to
>> re-open files with more privileges, which is sort of the same thing.
>=20
> This is something I'm currently working on a series for, which would
> boil down to some restrictions on how re-opening of file descriptors
> works through procfs.
>=20
> However, execveat() of a procfs magiclink is a bit hard to block --
> there is no way for userspace to to represent a file being "open for
> execute" so they are all "open for execute" by default and blocking it
> outright seems a bit extreme (though I actually hope to eventually add
> the ability to mark an O_PATH as "open for X" to resolveat(2) -- hence
> why I've reserved some bits).

There=E2=80=99s an O_MAYEXEC series floating around.

>=20
> (Thinking more about it, there is an argument that I should include the
> above patch into this series so that we can block re-opening of fds
> opened through resolveat(2) without explicit flags from the outset.)
>=20
> --=20
> Aleksa Sarai
> Senior Software Engineer (Containers)
> SUSE Linux GmbH
> <https://www.cyphar.com/>
