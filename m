From: Christian Brauner <christian@brauner.io>
Subject: Re: RFC: on adding new CLONE_* flags [WAS Re: [PATCH 0/4] clone: add CLONE_PIDFD]
Date: Mon, 29 Apr 2019 22:51:39 +0200
Message-ID: <CAHrFyr5HxpGXA2YrKza-oB-GGwJCqwPfyhD-Y5wbktWZdt0sGQ@mail.gmail.com>
References: <20190414201436.19502-1-christian@brauner.io> <dc05ffe3-c2ff-8b3e-d181-e0cc620bf91d@metux.net>
 <20190415195911.z7b7miwsj67ha54y@yavin> <CALCETrWxMnaPvwicqkMLswMynWvJVteazD-bFv3ZnBKWp-1joQ@mail.gmail.com>
 <20190420071406.GA22257@ip-172-31-15-78> <CAG48ez0gG4bd-t1wdR2p6-N2FjWbCqm_+ZThKfF7yKnD=KLqAQ@mail.gmail.com>
 <CAG48ez15bf1EJB0XTJsGFpvf8r5pj9+rv1axKVr13H1NW7ARZw@mail.gmail.com>
 <CAHk-=wi_N81mKYFz33ycoWiL7_tGbZBMJOsAs16inYzSza+OEw@mail.gmail.com> <87zho8bl8x.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87zho8bl8x.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Kevin Easton <kevin@guarana.org>, Andy Lutomirski <luto@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, "Enrico Weigelt, metux IT consult" <lkml@metux.net>, Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Joel Fernandes <joel@joelfernandes.org>, Daniel Colascione <danco>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 29, 2019 at 10:38 PM Florian Weimer <fweimer@redhat.com> wrote:
>
> * Linus Torvalds:
>
> > On Mon, Apr 29, 2019 at 12:55 PM Jann Horn <jannh@google.com> wrote:
> >>
> >> ... I guess that already has a name, and it's called vfork(). (Well,
> >> except that the Linux vfork() isn't a real vfork().)
> >
> > What?
> >
> > Linux vfork() is very much a real vfork(). What do you mean?
>
> In Linux-as-the-ABI (as opposed to Linux-as-the-implementation), vfork
> is sometimes implemented as fork, so applications cannot rely on the
> vfork behavior regarding the stopped parent and the shared address
> space.
>
> In fact, it would be nice to have a flag we can check in the posix_spawn
> implementation, so that we can support vfork-as-fork without any run
> time cost to native Linux.

After the next merge window we'll be out of flags if things go as planned.
To address this problem, Jann and I are currently in the middle of working
on a clone version that we intend to send out for discussion afterwards.
If the proposal is acceptable it would bump the number of available flags
significantly, putting things like this within reach.

Christian
