From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH v4] signal: add taskfd_send_signal() syscall
Date: Thu, 6 Dec 2018 14:01:23 -0800
Message-ID: <CAKOZuetc_mFO=8tUHRJWpv6gyCYSR4u3AWkEAKZsd+a-CV7E5w@mail.gmail.com>
References: <20181206121858.12215-1-christian@brauner.io> <87sgzahf7k.fsf@xmission.com>
 <D372C766-572C-4897-8F02-2FD0E72CCFAC@brauner.io> <875zw6bh2z.fsf@xmission.com>
 <20181206193017.wpxls5p3zgjd6rv2@brauner.io> <871s6u9z6u.fsf@xmission.com>
 <20181206213152.gvci7ijr3dokew7w@brauner.io> <87o99y72gi.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87o99y72gi.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christian Brauner <christian@brauner.io>, linux-kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Florian Weimer <fweimer@redhat.com>, tglx@linutronix.de, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 6, 2018 at 1:47 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Christian Brauner <christian@brauner.io> writes:
>
> >> Your intention is to add the thread case to support pthreads once the
> >> process case is sorted out.  So this is something that needs to be made
> >> clear.  Did I miss how you plan to handle threads?
> >
> > Yeah, maybe you missed it in the commit message [2] which is based on a
> > discussion with Andy [3] and Arnd [4]:
>
> Looking at your references I haven't missed it.  You are not deciding
> anything as of yet to keep it simple.  Except you are returning
> EOPNOTSUPP.  You are very much intending to do something.

So what *should* happen in that case? A panic? Come on. There's
nothing wrong with returning an error pending an expansion of
capabilities later.

> Decide.  Do you use the flags parameter or is the width of the
> target depending on the flags.

Huh?

> That is fundamental to how the system call and it's extensions work.
> That is fundamental to my review.

Your review makes no sense and comes off as an increasingly nitpicky
strategy of blocking the change no matter what Christian does. On
several occasions, you've just said "no, I don't like this" without
constructively trying to suggest an alternative that allows us to make
progress. That's obstruction, and this patch should get into the tree
over your nack.

> Until that is decided.
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> There are a lot of fundamental maintenance issues and you can very easily
> get them wrong if you are not clear on the job of the file descriptor
> and the job of the flags argument.

There are no maintenance issues. Christian has bent over backwards
trying to address all the code concerns raised in this thread, and
nothing has been good enough.

> I want don't want new crap that we have to abandon that has a nasty set
> of bugs because no one wanted to think through the system call all of
> the way and understand the corner cases.

What bugs? You have identified no bugs. There is no problem with the
API signature. It signals a task. You get that from proc.
