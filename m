From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v12 10/12] namei: aggressively check for nd->root escape
 on ".." resolution
Date: Wed, 4 Sep 2019 14:35:22 -0700
Message-ID: <CAHk-=wiHRW3Z9xPRiExi9jLjB0cdGhM=3vaW+b80mjuRcbORyw@mail.gmail.com>
References: <20190904201933.10736-1-cyphar@cyphar.com> <20190904201933.10736-11-cyphar@cyphar.com>
 <CAHk-=wiod1rQMU+6Zew=cLE8uX4tUdf42bM5eKngMnNVS2My7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wiod1rQMU+6Zew=cLE8uX4tUdf42bM5eKngMnNVS2My7g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Rasmus
List-Id: linux-api@vger.kernel.org

On Wed, Sep 4, 2019 at 2:09 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So you'd have three stages:
>
>  1) ".." always returns -EXDEV
>
>  2) ".." returns -EXDEV if there was a concurrent rename/mount
>
>  3) ".." returns -EXDEV if there was a concurrent rename/mount and we
> reset the sequence numbers and check if you escaped.

In fact, I wonder if this should return -EAGAIN instead - to say that
"retrying may work".

Because then:

> Also, I'm not 100% convinced that (3) is needed at all. I think the
> retry could be done in user space instead, which needs to have a
> fallback anyway. Yes? No?

Any user mode fallback would want to know whether it's a final error
or whether simply re-trying might make it work again.

I think that re-try case is valid for any of the possible "races
happened, we can't guarantee that it's safe", and retrying inside the
kernel (or doing that re-validation) could have latency issues.

Maybe ".." is the only such case. I can't think of any other ones in
your series, but at least conceptually they could happen. For example,
we've had people who wanted pathname lookup without any IO happening,
because if you have to wait for IO you could want to use another
thread etc if you're doing some server in user space..

                     Linus
