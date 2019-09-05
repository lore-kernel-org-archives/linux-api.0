From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v12 01/12] lib: introduce copy_struct_{to,from}_user
 helpers
Date: Thu, 5 Sep 2019 13:40:21 +0200
Message-ID: <20190905114020.52xaqqgp43wdctbl@wittgenstein>
References: <20190904201933.10736-1-cyphar@cyphar.com>
 <20190904201933.10736-2-cyphar@cyphar.com>
 <20190905110915.4vvhicg4ldmpi5u6@wittgenstein>
 <20190905112718.ojg3znly6x3m4mjq@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190905112718.ojg3znly6x3m4mjq@yavin.dot.cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian@brauner.io>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg
List-Id: linux-api@vger.kernel.org

On Thu, Sep 05, 2019 at 09:27:18PM +1000, Aleksa Sarai wrote:
> On 2019-09-05, Christian Brauner <christian.brauner@ubuntu.com> wrote:
> > On Thu, Sep 05, 2019 at 06:19:22AM +1000, Aleksa Sarai wrote:
> > > A common pattern for syscall extensions is increasing the size of a
> > > struct passed from userspace, such that the zero-value of the new fields
> > > result in the old kernel behaviour (allowing for a mix of userspace and
> > > kernel vintages to operate on one another in most cases). This is done
> > > in both directions -- hence two helpers -- though it's more common to
> > > have to copy user space structs into kernel space.
> > > 
> > > Previously there was no common lib/ function that implemented
> > > the necessary extension-checking semantics (and different syscalls
> > > implemented them slightly differently or incompletely[1]). A future
> > > patch replaces all of the common uses of this pattern to use the new
> > > copy_struct_{to,from}_user() helpers.
> > > 
> > > [1]: For instance {sched_setattr,perf_event_open,clone3}(2) all do do
> > >      similar checks to copy_struct_from_user() while rt_sigprocmask(2)
> > >      always rejects differently-sized struct arguments.
> > > 
> > > Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> > > Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
> > 
> > I would probably split this out into a separate patchset. It can very
> > well go in before openat2(). Thoughts?
> 
> Yeah, I'll split this and the related patches out -- though I will admit
> I'm not sure how you're supposed to deal with multiple independent
> patchsets that depend on each other. How will folks reviewing openat2(2)
> know to include the lib/struct_user.c changes?

The way I usually deal with this is to make two branches. One with the
changes the other depends on and then merge this branch into the other
and put the changes on top. Then you can provide a complete branch that
people can test when you send the patchset out by just linking to it in
the cover letter.
(But if it's too much hazzle just leave it.)

> 
> Also, whose tree should it go through?

If people think splitting it out makes sense and we can settle the
technical details I can take it and let it stew in linux-next at least
for a little while.
I have changes to clone3() in there that touch
copy_clone_args_from_user() anyway and there are tests for clone3()
struct copying so we'd catch regressions (for clone3() at least) pretty
quickly.
If we don't see any major issues in the next two weeks it might even be
ok to send for 5.4.

Christian
