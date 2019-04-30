From: Florian Weimer <fweimer@redhat.com>
Subject: Re: RFC: on adding new CLONE_* flags [WAS Re: [PATCH 0/4] clone: add CLONE_PIDFD]
Date: Tue, 30 Apr 2019 09:01:52 +0200
Message-ID: <87muk8asdb.fsf@oldenburg2.str.redhat.com>
References: <20190414201436.19502-1-christian@brauner.io>
        <dc05ffe3-c2ff-8b3e-d181-e0cc620bf91d@metux.net>
        <20190415195911.z7b7miwsj67ha54y@yavin>
        <CALCETrWxMnaPvwicqkMLswMynWvJVteazD-bFv3ZnBKWp-1joQ@mail.gmail.com>
        <20190420071406.GA22257@ip-172-31-15-78>
        <CAG48ez0gG4bd-t1wdR2p6-N2FjWbCqm_+ZThKfF7yKnD=KLqAQ@mail.gmail.com>
        <CAG48ez15bf1EJB0XTJsGFpvf8r5pj9+rv1axKVr13H1NW7ARZw@mail.gmail.com>
        <CAHk-=wi_N81mKYFz33ycoWiL7_tGbZBMJOsAs16inYzSza+OEw@mail.gmail.com>
        <87zho8bl8x.fsf@oldenburg2.str.redhat.com>
        <CAHk-=wiPv4QJBC0qX8xxnT5P2C7S5uDG0HKdvdSpcoXaHG91tQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wiPv4QJBC0qX8xxnT5P2C7S5uDG0HKdvdSpcoXaHG91tQ@mail.gmail.com>
        (Linus Torvalds's message of "Mon, 29 Apr 2019 14:31:30 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jann Horn <jannh@google.com>, Kevin Easton <kevin@guarana.org>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian@brauner.io>, Aleksa Sarai <cyphar@cyphar.com>, "Enrico Weigelt, metux IT consult" <lkml@metux.net>, Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Joel Fernandes <joel@joelfernandes.org>, Daniel Colascione <dancol@goo>
List-Id: linux-api@vger.kernel.org

* Linus Torvalds:

> On Mon, Apr 29, 2019 at 1:38 PM Florian Weimer <fweimer@redhat.com> wrote:
>>
>> In Linux-as-the-ABI (as opposed to Linux-as-the-implementation), vfork
>> is sometimes implemented as fork, so applications cannot rely on the
>> vfork behavior regarding the stopped parent and the shared address
>> space.
>
> What broken library does that?
>
> Sure, we didn't have a proper vfork() long long long ago. But that
> predates both git and BK, so it's some time in the 90's. We've had a
> proper vfork() *forever*.

It's not so much about libraries, it's alternative implementations of
the system call interface: valgrind, qemu-user and WSL.  For valgrind
and qemu-user, it's about cloning the internal data structures, so that
the subprocess does not clobber what's in the parent process (which may
have multiple threads and may not be fully blocked due to vfork).  For
WSL, who knows what's going on there.

>> In fact, it would be nice to have a flag we can check in the posix_spawn
>> implementation, so that we can support vfork-as-fork without any run
>> time cost to native Linux.
>
> No. Just make a bug-report to whatever broken library you use. What's
> the point of having a library that can't even get vfork() right? Why
> would you want to have a flag to say "vfork is broken"?

It's apparently quite difficult to fix valgrind and qemu-user.  WSL is
apparently not given the resources it needs, yet a surprising number of
people see it as a viable replacement and report what are essentially
vfork-related bugs.

If I had the flag, I could at least fix posix_spawn in glibc to consult
it before assuming that vfork shares address space.  (The sharing allows
straightforward reporting of the vfork error code, without resorting to
pipes or creating a MAP_SHARED mapping.)  For obvious reasons, I do not
want to apply the workaround unconditionally.

Thanks,
Florian
