From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RFC: on adding new CLONE_* flags [WAS Re: [PATCH 0/4] clone: add CLONE_PIDFD]
Date: Tue, 30 Apr 2019 09:24:06 -0700
Message-ID: <CAHk-=wit1f_eARfgHYBQwjU2ndd_75OuHQurXNmrEHuhjQViJA@mail.gmail.com>
References: <20190414201436.19502-1-christian@brauner.io> <dc05ffe3-c2ff-8b3e-d181-e0cc620bf91d@metux.net>
 <20190415195911.z7b7miwsj67ha54y@yavin> <CALCETrWxMnaPvwicqkMLswMynWvJVteazD-bFv3ZnBKWp-1joQ@mail.gmail.com>
 <20190420071406.GA22257@ip-172-31-15-78> <CAG48ez0gG4bd-t1wdR2p6-N2FjWbCqm_+ZThKfF7yKnD=KLqAQ@mail.gmail.com>
 <CAG48ez15bf1EJB0XTJsGFpvf8r5pj9+rv1axKVr13H1NW7ARZw@mail.gmail.com>
 <CAHk-=wi_N81mKYFz33ycoWiL7_tGbZBMJOsAs16inYzSza+OEw@mail.gmail.com> <20190430123901.GD23020@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190430123901.GD23020@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jann Horn <jannh@google.com>, Kevin Easton <kevin@guarana.org>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian@brauner.io>, Aleksa Sarai <cyphar@cyphar.com>, "Enrico Weigelt, metux IT consult" <lkml@metux.net>, Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Joel Fernandes <joel@joelfernandes.org>, Daniel Colascione <dancol@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 30, 2019 at 5:39 AM Oleg Nesterov <oleg@redhat.com> wrote:
>
> Yes, but I am wondering if man vfork should clarify what "child terminates"
> actually means. I mean, the child can do clone(CLONE_THREAD) + sys_exit(),
> this will wake the parent thread up before the child process exits or execs.

That falls solidly into the "give people rope" category.

If the vfork() child wants to mess with the parent, it has many easier
ways to do it than create more threads.

As mentioned, the real problem with vfork() tends to be that the child
unintentionally messes with the parent because it just gets the stack
sharing wrong. No need to add intention there.

> I see nothing wrong, but I was always curious whether it was designed this
> way on purpose or not.

Oh, it's definitely on purpose. Trying to do some nested usage count
would be horrendously complex, and even a trivial "don't allow any
other clone() calls if we already have a vfork completion pending" is
just unnecessary logic.

Because at least in *theory*, there's actually nothing horribly wrong
with allowing a thread to be created during the vfork(). I don't see
the _point_, but it's not conceptually something that couldn't work
(you'd need a separate thread stack etc, but that's normal clone()).

So no, there's no safety or bogus "you can't do that". If you want to
play games after vfork(), go wild.

                   Linus
