From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sun, 31 Mar 2019 16:40:15 -0700
Message-ID: <CAHk-=whw1cnWPSWw1tHXT5xTMbnJFbCtx9_re6U1RZ_7LE9gXA@mail.gmail.com>
References: <BCD99947-5F55-4116-8F74-D6832E50340B@brauner.io>
 <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com>
 <CAKOZuevv_QgvzmusA+yey76vo4hn9bEVwud2RumuOr0K4++15A@mail.gmail.com>
 <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com>
 <20190330171215.3yrfxwodstmgzmxy@brauner.io> <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
 <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net> <CAHk-=wiaLtH41Mc5qAjOeCWavPqV0DhS581KYa0QBt8uraTK1Q@mail.gmail.com>
 <20190331211041.vht7dnqg4e4bilr2@brauner.io> <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
 <20190331220259.qntxynluk765hpnt@brauner.io> <CAHk-=wh0jgRkZiNdFD96Zpjx+_G+NVSHieAt+QgWCQBJ2A-5Aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wh0jgRkZiNdFD96Zpjx+_G+NVSHieAt+QgWCQBJ2A-5Aw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Andy Lutomirski <luto@amacapital.net>, Daniel Colascione <dancol@google.com>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@red>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 31, 2019 at 3:16 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I would actually suggest we just make the rules be that the
> pidfd_open() always return the internal /proc entry regardless of any
> mount-point (or any "hidepid")

The clever alternative, which might be the RightWay(tm) is to just
create a completely unattached dentry, and basically tie it into the
actual /proc filesystem hierarchy at lookup() time when somebody does
the openat() using it for the first time. You'd get a very simple
callback: since the dentry would be unattached, you'd be guaranteed to
get a "lookup()" from the VFS layer, and that lookup would then do the
"hook into the actual /proc filesystem".

We already kind of do things like that in the VFS layer when we have
unattached dentries (because of "look up by filehandle" etc). In many
ways the "pidfd_open()" really is exactly a "look up by file handle"
operation, it just so happens that the "file handle" is just the
pid/namespace combination.

And if the splice alias (which is what the VFS layer calls that "tie
aliased dentry to the parent" operation) fails, because the /proc
filesystem isn't mounted or whatever, then trying to look up names off
the thing will also fail.

It's a tiny bit too clever for my taste, and it's not *exactly* the
same thing as our normal inode alias handling, but it's pretty close
conceptually (and even practically).

So it would basically do something very similar to the ioctl, but it
would do it implicitly and automatically at that first lookup.

That would also mean that you'd not actually pay the cost of doing any
of this *unless* you also end up trying to open things in /proc using
that pidfd.

                    Linus
