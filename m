From: Jann Horn <jannh@google.com>
Subject: Re: For review: documentation of clone3() system call
Date: Mon, 28 Oct 2019 20:09:13 +0100
Message-ID: <CAG48ez20hn8vToY+=C62nA-rbUfxh=JD6N-f7XVS3_GZOoPjxw@mail.gmail.com>
References: <CAKgNAkjo2WHq+zESU1iuCHJJ0x-fTNrakS9-d1+BjzUuV2uf2Q@mail.gmail.com>
 <CAG48ez3q=BeNcuVTKBN79kJui4vC6nw0Bfq6xc-i0neheT17TA@mail.gmail.com> <20191028172143.4vnnjpdljfnexaq5@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191028172143.4vnnjpdljfnexaq5@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Florian Weimer <fweimer@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 28, 2019 at 6:21 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
> On Mon, Oct 28, 2019 at 04:12:09PM +0100, Jann Horn wrote:
> > On Fri, Oct 25, 2019 at 6:59 PM Michael Kerrisk (man-pages)
> > <mtk.manpages@gmail.com> wrote:
> > > I've made a first shot at adding documentation for clone3(). You can
> > > see the diff here:
> > > https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/commit/?id=faa0e55ae9e490d71c826546bbdef954a1800969
[...]
> > You might want to note somewhere that its flags can't be
> > seccomp-filtered because they're stored in memory, making it
> > inappropriate to use in heavily sandboxed processes.
>
> Hm, I don't think that belongs on the clone manpage. Granted that
> process creation is an important syscall but so are a bunch of others
> that aren't filterable because of pointer arguments.
> We can probably mention on the seccomp manpage that seccomp can't filter
> on pointer arguments and then provide a list of examples. If you setup a
> seccomp filter and don't know that you can't filter syscalls with
> pointer args that seems pretty bad to begin with.

Fair enough.

[...]
> One thing I never liked about clone() was that userspace had to know
> about stack direction. And there is a lot of ugly code in userspace that
> has nasty clone() wrappers like:
[...]
> where stack + stack_size is addition on a void pointer which usually
> clang and gcc are not very happy about.
> I wanted to bring this up on the mailing list soon: If possible, I don't
> want userspace to need to know about stack direction and just have stack
> point to the beginning and then have the kernel do the + stack_size
> after the copy_clone_args_from_user() if the arch needs it. For example,
> by having a dumb helder similar to copy_thread_tls()/coyp_thread() that
> either does the + stack_size or not. Right now, clone3() is supported on
> parisc and afaict, the stack grows upwards for it. I'm not sure if there
> are obvious reasons why that won't work or it would be a bad idea...

That would mean adding a new clone flag that redefines how those
parameters work and describing the current behavior in the manpage as
the behavior without the flag (which doesn't exist on 5.3), right?
