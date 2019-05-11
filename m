From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v6 5/6] binfmt_*: scope path resolution of interpreters
Date: Sat, 11 May 2019 13:21:11 -0400
Message-ID: <CAHk-=wh1JJD_RabMaFfinsAQp1vHGJOQ1rKqihafY=r7yHc8sQ@mail.gmail.com>
References: <20190506165439.9155-1-cyphar@cyphar.com> <20190506165439.9155-6-cyphar@cyphar.com>
 <CAG48ez0-CiODf6UBHWTaog97prx=VAd3HgHvEjdGNz344m1xKw@mail.gmail.com>
 <20190506191735.nmzf7kwfh7b6e2tf@yavin> <20190510204141.GB253532@google.com>
 <CALCETrW2nn=omqJb4p+m-BDsCOhg+YZQ3ELd4BdhODV3G44gfA@mail.gmail.com>
 <20190510225527.GA59914@google.com> <C60DC580-854D-478D-AF23-5F29FB7C3E50@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <C60DC580-854D-478D-AF23-5F29FB7C3E50@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jann Horn <jannh@google.com>, Andy Lutomirski <luto@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Christian Brauner <christian@brauner.io>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>Linu
List-Id: linux-api@vger.kernel.org

On Sat, May 11, 2019 at 1:00 PM Andy Lutomirski <luto@amacapital.net> wrote=
:
>
> A better =E2=80=9Cspawn=E2=80=9D API should fix this.

Andy, stop with the "spawn would be better".

Spawn is garbage. It's garbage because it's fundamentally too
inflexible, and it's garbage because it is quite complex to try to
work around the inflexibility by having those complex "action pointer
arrays" to make up for its failings.

And spawn() would fundamentally have all the same permission issues
that you now point to execve() as having, so it doesn't even *solve*
anything.

You've said this whole "spawn would fix things" thing before, and it's
wrong. Spawn isn't better. Really. If fixes absolutely zero things,
and the only reason for spawn existing is because VMS and NT had that
broken and inflexible model.

There's at least one paper from some MS people about how "spawn()" is
wonderful, and maybe you bought into the garbage from that. But that
paper is about how they hate fork(), not because of execve(). And if
you hate fork, use "vfork()" instead (preferably with an immediate
call to a non-returning function in the child to avoid the stack
re-use issue that makes it so simple to screw up vfork() in hard to
debug ways).

execve() is a _fine_ model. That's not the problem in this whole issue
at all - never was, and never will be.

The problem in this discussion is (a) having privileges you shouldn't
have and (b) having other interfaces that make it easyish to change
the filesystem layout to confuse those entities with privileges.

So the reason the open flags can be problematic is exactly because
they effectively change filesystem layout. And no, it's not just
AT_THIS_ROOT, although that's the obvious one. Things like "you can't
follow symlinks" can also effectively change the layout: imagine if
you have a PATH-like lookup model, and you end up having symlinks as
part of the standard filesystem layout.. Now a "don't follow symlinks"
can turn the *standard* executable into something that isn't found,
and then you might end up executing something else instead (think root
having '.' as the last entry in path, which some people used to
suggest as the fix for the completely bad "first entry" case)..

Notice? None of the real problems are about execve or would be solved
by any spawn API. You just think that because you've apparently been
talking to too many MS people that think fork (and thus indirectly
execve()) is bad process management.

                Linus
