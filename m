From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v12 01/12] lib: introduce copy_struct_{to,from}_user
 helpers
Date: Fri, 6 Sep 2019 09:00:49 +0200
Message-ID: <20190906070048.tmhuemasmsn55spq@wittgenstein>
References: <20190904201933.10736-1-cyphar@cyphar.com>
 <20190904201933.10736-2-cyphar@cyphar.com>
 <20190905180750.GQ1131@ZenIV.linux.org.uk>
 <20190905182303.7f6bxpa2enbgcegv@wittgenstein>
 <20190905182801.GR1131@ZenIV.linux.org.uk>
 <20190905195618.pwzgvuzadkfpznfz@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190905195618.pwzgvuzadkfpznfz@yavin.dot.cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian@brauner.io>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg
List-Id: linux-api@vger.kernel.org

On Fri, Sep 06, 2019 at 05:56:18AM +1000, Aleksa Sarai wrote:
> On 2019-09-05, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Thu, Sep 05, 2019 at 08:23:03PM +0200, Christian Brauner wrote:
> > 
> > > Because every caller of that function right now has that limit set
> > > anyway iirc. So we can either remove it from here and place it back for
> > > the individual callers or leave it in the helper.
> > > Also, I'm really asking, why not? Is it unreasonable to have an upper
> > > bound on the size (for a long time probably) or are you disagreeing with
> > > PAGE_SIZE being used? PAGE_SIZE limit is currently used by sched, perf,
> > > bpf, and clone3 and in a few other places.
> > 
> > For a primitive that can be safely used with any size (OK, any within
> > the usual 2Gb limit)?  Why push the random policy into the place where
> > it doesn't belong?
> > 
> > Seriously, what's the point?  If they want to have a large chunk of
> > userland memory zeroed or checked for non-zeroes - why would that
> > be a problem?
> 
> Thinking about it some more, there isn't really any r/w amplification --
> so there isn't much to gain by passing giant structs. Though, if we are
> going to permit 2GB buffers, isn't that also an argument to use
> memchr_inv()? :P

I think we should just do a really dumb, easy to understand minimal
thing for now. It could even just be what every caller is doing right
now anyway with the get_user() loop.
The only way to settle memchr_inv() vs all the other clever ways
suggested here is to benchmark it and see if it matters *for the current
users* of this helper. If it does, great we can do it. If it doesn't why
bother having that argument right now?
Once we somehow end up in a possible world where we apparently have
decided it's a great idea to copy 2GB argument structures for a syscall
into or from the kernel we can start optimizing the hell out of this.
Before that and especially with current callers I honestly doubt it
matters whether we use memchr_inv() or while() {get_user()} loops.

Christian
