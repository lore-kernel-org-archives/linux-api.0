From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [RFC] selftests: report proper exit statuses
Date: Thu, 17 Dec 2015 20:26:39 +1100
Message-ID: <1450344399.13536.2.camel@ellerman.id.au>
References: <1449875706-106875-1-git-send-email-computersforpeace@gmail.com>
	 <1450063175.29082.2.camel@ellerman.id.au>
	 <20151214191536.GA108082@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151214191536.GA108082@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brian Norris <computersforpeace@gmail.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

Hi Brian,

On Mon, 2015-12-14 at 11:15 -0800, Brian Norris wrote:
> Hi Michael,
> 
> On Mon, Dec 14, 2015 at 02:19:35PM +1100, Michael Ellerman wrote:
> > On Fri, 2015-12-11 at 15:15 -0800, Brian Norris wrote:
> > 
> > > There are several places where we don't report proper exit statuses, and
> > > this can have consequences -- for instance, the gen_kselftest_tar.sh
> > > script might try to produce a tarball for you, even if the 'make' or
> > > 'make install' steps didn't complete properly.
> > > 
> > > This is only an RFC (and really, it's more like a bug report), since I'm
> > > not really satisfied with my solution.
> > 
> > The changes to the tar script are probably OK.
> > 
> > But in general we do not want to exit after the first failure, which is what
> > your changes to the for loops would do.
> > 
> > The intention is to build and run as many tests as possible, on as many
> > architectures and machines as possible. So stopping the build because a header
> > or library is missing, or stopping the test run because one test fails, is the
> > exact opposite of what we want to happen.
> > 
> > For example a test might fail because it was written for x86 and doesn't work
> > on powerpc, if that caused all my powerpc tests to not run, I would be very
> > unpleased.
> 
> I purposely handled errors on the compile/packaging steps, and not the
> test execution steps. As you rightly claim, I wouldn't expect a test
> suite to stop running all tests just because one test failed.

OK, sorry I didn't read your patch carefully enough.

> But are you suggesting to apply the same logic to the compile phase? You want
> to ignore build failures?

Yes absolutely.

For example the mqueue tests require libpopt, but I don't always have libpopt
available, especially when I'm cross compiling the selftests. And that's fine,
I don't care that much about the mqueue tests, so I'm happy for the build of
them to fail, but continue to build everything else.

Typically the lack of a required library would be caught by configure (or
similar). We could implement a configure-like step, but so far no one's thought
it was worth the effort.

And notice I said "configure-like", because IMO we don't want to require folks
to have autotools available. There is some configure-like logic in tools/perf
which AIUI is pretty stand alone, which we could possibly borrow, but I haven't
had time to look at it closely.


> It seems perhaps that a core point of contention here is that you're
> providing a 'make' build target, yet you don't want it to act at all
> like a make target.

Well I would argue it does act like a make target, just not one that requires
all dependencies to build successfully. We could implement the build as a lot
of shell scripts, but we would still want the same behaviour of building
whatever can be built.

> Right now, there is no way to tell whether the build
> succeeded at all (you could build exactly 0 tests, yet get a "success"
> error code), and therefore any kind of automated build and packaging
> system based on your make targets cannot know whether the package is
> going to be properly assembled at all.

That's true. But at least for me it's not a problem. I do run automated builds
using the selftests, and the metric I use is how many tests were run when I run
them. If the test run ends up with zero tests then I will notice that.

> > > It's probably not exhaustive, and
> > > there seem to be some major other deficiencies (e.g., verbose/useless
> > > output during build and run, non-paralle build, shell for-loops sidestep
> > > some normal 'make' behavior).
> > 
> > The goals for the kernel selftests are to make it as easy as possible to merge
> > tests, so that as many developers as possible create tests *and* merge them.
> 
> Either there's more behind this statement than meets the eye, or it's
> pretty terrible IMO. With the goal as stated, I could write a crap test
> that does nothing and fails to compile, and you'd like that to be
> merged? Seems like a recipe for a test suite that people contribute to,
> but no one runs.

Obviously I'd rather you didn't write tests that "do nothing". But failing to
compile is fine.

Why? Because Linux supports ~30 architectures. Requiring every selftest to
build on all 30, some of which support multiple word sizes and endians would be
insane. That would be a recipe for a test suite with no tests.

Again, that would usually be caught by configure or similar, but until someone
implements something like that, this is how it is.

And people are running the tests, I know that for a fact.

> > The current scheme supports that by not imposing much in the way of build
> > system requirements, or standards on what is or isn't appropriate output etc.
> 
> OK, well I'm not going to suggest enforcing exact output standards
> (though that might be nice, and I believe this showed up on more than
> one "TODO" list [1][2]), but I thought it's well established that a
> program's exit code should differentiate success from failure. Is that
> not a requirement?

It's not a requirement. But it certainly helps.

> Also, is it not reasonable for tests to enforce the rules they expect?
> e.g., if they require some library, they should check for it. And if
> they require some feature that's not on the present kernel, either they
> check for it, or we say it's unsupported to build the test on such a
> kernel (and therefore, it's not a bug to report a 'make' failure).

That's great, if people want to put in the effort to add that extra logic. But
it shouldn't be a barrier to getting tests in to begin with. And it's not
always easy or possible to "check for a feature", especially if the test is run
as non-root.

If you look at tools/testing/selftests/powerpc you'll see we have some tests
that use a SKIP_IF() macro to test for something and then exit with a
non-failure/non-success code.

> It feels very wrong to just ignore all build errors. Alternatives: we
> could either check for dependencies, or else provide a simple opt-out
> mechanism, so a user can opt out of builds they don't want (rather than
> having them automatically dropped just because of an unreported build
> failure).

A mechanism to check for dependenices would be fine, an opt-out doesn't work
for automated builds, because new tests can be merged that break the build
until someone updates it to opt-out.

But the end result is the same, some tests aren't built some of the time.

> > But if have ideas for improving things while still keeping the requirements on
> > test code low then I'm all ears.
> 
> I can try to come up with acceptable improvements, but I don't feel like
> I understand your requirements well enough yet.
> 
> The more I think about this, the more I think that there must be some
> balance between ease for the user and ease for the developer. Right now,
> we seem to be swung fairly far to the latter, and I don't know how much
> I'm allowed to swing back to the former.

OK. From my point of view, as a developer, the kernel selftests are written
by and for kernel developers. Anything that presents a considerable barrier to
kernel devs getting tests in would be a backward step IMO.

It's not that I love the current setup, but I think it is working pretty well
in practice.

cheers
