From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v9 08/10] open: openat2(2) syscall
Date: Thu, 18 Jul 2019 23:29:50 +0200
Message-ID: <CAK8P3a3MiYK4bJiA3G_m5H-TpfN5__--b+=szsJBhG7_it+NQg@mail.gmail.com>
References: <20190706145737.5299-1-cyphar@cyphar.com> <20190706145737.5299-9-cyphar@cyphar.com>
 <CAK8P3a33rGhPDFfRBAQyLTMG_WoEgX_toDgWR2O7rSwxKsZG+w@mail.gmail.com> <20190718161231.xcno272nvqpln3wj@yavin>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190718161231.xcno272nvqpln3wj@yavin>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Christian Brauner <christian@brauner.io>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-foundation.org, alpha <linux-alp>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 18, 2019 at 6:12 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
> On 2019-07-18, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Sat, Jul 6, 2019 at 5:00 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
> >
> > In fact, that seems similar enough to the existing openat() that I think
> > you could also just add the fifth argument to the existing call when
> > a newly defined flag is set, similarly to how we only use the 'mode'
> > argument when O_CREAT or O_TMPFILE are set.
>
> I considered doing this (and even had a preliminary version of it), but
> I discovered that I was not in favour of this idea -- once I started to
> write tests using it -- for a few reasons:
>
>   1. It doesn't really allow for clean extension for a future 6th
>          argument (because you are using up O_* flags to signify "use the
>          next argument", and O_* flags don't give -EINVAL if they're
>          unknown). Now, yes you can do the on-start runtime check that
>          everyone does -- but I've never really liked having to do it.
>
>          Having reserved padding for later extensions (that is actually
>          checked and gives -EINVAL) matches more modern syscall designs.
>
>   2. I really was hoping that the variadic openat(2) could be done away
>      using this union setup (Linus said he didn't like it, and suggested
>          using something like 'struct stat' as an argument for openat(2) --
>          though personally I am not sure I would personally like to use an
>          interface like that).
>
>   3. In order to avoid wasting a syscall argument for mode/mask you need
>          to either have something like your suggested mode_mask (which makes
>          the syscall arguments less consistent) or have some sort of
>          mode-like argument that is treated specially (which is really awful
>          on multiple levels -- this one I also tried and even wrote my
>          original tests using). And in both cases, the shims for
>          open{,at}(2) are somewhat less clean.

These are all good reasons, thanks for providing the background.

> All of that being said, I'd be happy to switch to whatever you think
> makes the most sense. As long as it's possible to get an O_PATH with
> RESOLVE_IN_ROOT set, I'm happy.

I don't feel I should be in charge of making the decision. I'd still
prefer avoiding the indirect argument structure because

4. it's inconsistent with most other syscalls

5. you get the same problem with seccomp and strace that
   clone3() has -- these and others only track the register
   arguments by default.

6. copying the structure adds a small overhead compared to
   passing registers

7. the calling conventions may be inconvenient for  a user space
   library, so you end up with different prototypes for the low-level
   syscall and the libc abstraction.

I don't see any of the above seven points as a showstopper
either way, so I hope someone else has a strong opinion
and can make the decision easier for you.

In the meantime just keep what you have, so you don't have
to change it multiple times.

       Arnd
