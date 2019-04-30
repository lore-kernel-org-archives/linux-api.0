From: Jann Horn <jannh@google.com>
Subject: Re: RFC: on adding new CLONE_* flags [WAS Re: [PATCH 0/4] clone: add CLONE_PIDFD]
Date: Mon, 29 Apr 2019 20:38:36 -0400
Message-ID: <CAG48ez1CV54c1xZ9s26ym=9avkihiNi=ppW-CWA1-qrCpYdc1A@mail.gmail.com>
References: <20190414201436.19502-1-christian@brauner.io> <dc05ffe3-c2ff-8b3e-d181-e0cc620bf91d@metux.net>
 <20190415195911.z7b7miwsj67ha54y@yavin> <CALCETrWxMnaPvwicqkMLswMynWvJVteazD-bFv3ZnBKWp-1joQ@mail.gmail.com>
 <20190420071406.GA22257@ip-172-31-15-78> <CAG48ez0gG4bd-t1wdR2p6-N2FjWbCqm_+ZThKfF7yKnD=KLqAQ@mail.gmail.com>
 <CAG48ez15bf1EJB0XTJsGFpvf8r5pj9+rv1axKVr13H1NW7ARZw@mail.gmail.com> <CAHk-=wi_N81mKYFz33ycoWiL7_tGbZBMJOsAs16inYzSza+OEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wi_N81mKYFz33ycoWiL7_tGbZBMJOsAs16inYzSza+OEw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kevin Easton <kevin@guarana.org>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian@brauner.io>, Aleksa Sarai <cyphar@cyphar.com>, "Enrico Weigelt, metux IT consult" <lkml@metux.net>, Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Joel Fernandes <joel@joelfernandes.org>, Daniel Colascione <dancol@google.com>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 29, 2019 at 4:21 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, Apr 29, 2019 at 12:55 PM Jann Horn <jannh@google.com> wrote:
> >
> > ... I guess that already has a name, and it's called vfork(). (Well,
> > except that the Linux vfork() isn't a real vfork().)
>
> What?
>
> Linux vfork() is very much a real vfork(). What do you mean?

... uuuh, whoops. Turns out I don't know what I'm talking about.
Nevermind. For some reason I thought vfork() was just
CLONE_VFORK|SIGCHLD, but now I see I got that completely wrong.
