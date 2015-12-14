From: Brian Norris <computersforpeace@gmail.com>
Subject: Re: [RFC] selftests: report proper exit statuses
Date: Mon, 14 Dec 2015 11:15:36 -0800
Message-ID: <20151214191536.GA108082@google.com>
References: <1449875706-106875-1-git-send-email-computersforpeace@gmail.com>
 <1450063175.29082.2.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1450063175.29082.2.camel@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

Hi Michael,

On Mon, Dec 14, 2015 at 02:19:35PM +1100, Michael Ellerman wrote:
> On Fri, 2015-12-11 at 15:15 -0800, Brian Norris wrote:
> 
> > There are several places where we don't report proper exit statuses, and
> > this can have consequences -- for instance, the gen_kselftest_tar.sh
> > script might try to produce a tarball for you, even if the 'make' or
> > 'make install' steps didn't complete properly.
> > 
> > This is only an RFC (and really, it's more like a bug report), since I'm
> > not really satisfied with my solution.
> 
> The changes to the tar script are probably OK.
> 
> But in general we do not want to exit after the first failure, which is what
> your changes to the for loops would do.
> 
> The intention is to build and run as many tests as possible, on as many
> architectures and machines as possible. So stopping the build because a header
> or library is missing, or stopping the test run because one test fails, is the
> exact opposite of what we want to happen.
> 
> For example a test might fail because it was written for x86 and doesn't work
> on powerpc, if that caused all my powerpc tests to not run, I would be very
> unpleased.

I purposely handled errors on the compile/packaging steps, and not the
test execution steps. As you rightly claim, I wouldn't expect a test
suite to stop running all tests just because one test failed. But are
you suggesting to apply the same logic to the compile phase? You want to
ignore build failures?

It seems perhaps that a core point of contention here is that you're
providing a 'make' build target, yet you don't want it to act at all
like a make target. Right now, there is no way to tell whether the build
succeeded at all (you could build exactly 0 tests, yet get a "success"
error code), and therefore any kind of automated build and packaging
system based on your make targets cannot know whether the package is
going to be properly assembled at all.

> > It's probably not exhaustive, and
> > there seem to be some major other deficiencies (e.g., verbose/useless
> > output during build and run, non-paralle build, shell for-loops sidestep
> > some normal 'make' behavior).
> 
> The goals for the kernel selftests are to make it as easy as possible to merge
> tests, so that as many developers as possible create tests *and* merge them.

Either there's more behind this statement than meets the eye, or it's
pretty terrible IMO. With the goal as stated, I could write a crap test
that does nothing and fails to compile, and you'd like that to be
merged? Seems like a recipe for a test suite that people contribute to,
but no one runs.

> The current scheme supports that by not imposing much in the way of build
> system requirements, or standards on what is or isn't appropriate output etc.

OK, well I'm not going to suggest enforcing exact output standards
(though that might be nice, and I believe this showed up on more than
one "TODO" list [1][2]), but I thought it's well established that a
program's exit code should differentiate success from failure. Is that
not a requirement?

Also, is it not reasonable for tests to enforce the rules they expect?
e.g., if they require some library, they should check for it. And if
they require some feature that's not on the present kernel, either they
check for it, or we say it's unsupported to build the test on such a
kernel (and therefore, it's not a bug to report a 'make' failure).

It feels very wrong to just ignore all build errors. Alternatives: we
could either check for dependencies, or else provide a simple opt-out
mechanism, so a user can opt out of builds they don't want (rather than
having them automatically dropped just because of an unreported build
failure).

> But if have ideas for improving things while still keeping the requirements on
> test code low then I'm all ears.

I can try to come up with acceptable improvements, but I don't feel like
I understand your requirements well enough yet.

The more I think about this, the more I think that there must be some
balance between ease for the user and ease for the developer. Right now,
we seem to be swung fairly far to the latter, and I don't know how much
I'm allowed to swing back to the former.

Brian

[1] https://kselftest.wiki.kernel.org/
[2] http://events.linuxfoundation.org/sites/events/files/slides/kselftest_feb23_2015.pdf
