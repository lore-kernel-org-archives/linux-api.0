From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v12 01/12] lib: introduce copy_struct_{to,from}_user
 helpers
Date: Thu, 5 Sep 2019 19:28:01 +0100
Message-ID: <20190905182801.GR1131@ZenIV.linux.org.uk>
References: <20190904201933.10736-1-cyphar@cyphar.com>
 <20190904201933.10736-2-cyphar@cyphar.com>
 <20190905180750.GQ1131@ZenIV.linux.org.uk>
 <20190905182303.7f6bxpa2enbgcegv@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190905182303.7f6bxpa2enbgcegv@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian@brauner.io>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@r>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 05, 2019 at 08:23:03PM +0200, Christian Brauner wrote:

> Because every caller of that function right now has that limit set
> anyway iirc. So we can either remove it from here and place it back for
> the individual callers or leave it in the helper.
> Also, I'm really asking, why not? Is it unreasonable to have an upper
> bound on the size (for a long time probably) or are you disagreeing with
> PAGE_SIZE being used? PAGE_SIZE limit is currently used by sched, perf,
> bpf, and clone3 and in a few other places.

For a primitive that can be safely used with any size (OK, any within
the usual 2Gb limit)?  Why push the random policy into the place where
it doesn't belong?

Seriously, what's the point?  If they want to have a large chunk of
userland memory zeroed or checked for non-zeroes - why would that
be a problem?
