From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [RFC] selftests: report proper exit statuses
Date: Mon, 14 Dec 2015 14:19:35 +1100
Message-ID: <1450063175.29082.2.camel@ellerman.id.au>
References: <1449875706-106875-1-git-send-email-computersforpeace@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449875706-106875-1-git-send-email-computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Brian,

On Fri, 2015-12-11 at 15:15 -0800, Brian Norris wrote:

> There are several places where we don't report proper exit statuses, and
> this can have consequences -- for instance, the gen_kselftest_tar.sh
> script might try to produce a tarball for you, even if the 'make' or
> 'make install' steps didn't complete properly.
> 
> This is only an RFC (and really, it's more like a bug report), since I'm
> not really satisfied with my solution.

The changes to the tar script are probably OK.

But in general we do not want to exit after the first failure, which is what
your changes to the for loops would do.

The intention is to build and run as many tests as possible, on as many
architectures and machines as possible. So stopping the build because a header
or library is missing, or stopping the test run because one test fails, is the
exact opposite of what we want to happen.

For example a test might fail because it was written for x86 and doesn't work
on powerpc, if that caused all my powerpc tests to not run, I would be very
unpleased.

> It's probably not exhaustive, and
> there seem to be some major other deficiencies (e.g., verbose/useless
> output during build and run, non-paralle build, shell for-loops sidestep
> some normal 'make' behavior).

The goals for the kernel selftests are to make it as easy as possible to merge
tests, so that as many developers as possible create tests *and* merge them.

The current scheme supports that by not imposing much in the way of build
system requirements, or standards on what is or isn't appropriate output etc.

But if have ideas for improving things while still keeping the requirements on
test code low then I'm all ears.

cheers
