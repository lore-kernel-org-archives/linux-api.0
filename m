From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: selftests: standardized results output?
Date: Thu, 18 Dec 2014 14:28:36 +1100
Message-ID: <1418873316.13333.1.camel@ellerman.id.au>
References: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3DABAC24@USMBX1.msg.corp.akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3DABAC24-/aPJBeqlRkAyyULh10xnlCahX2Nl78RV0E9HWUfgJXw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Young, David" <dayoung-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Shuah Khan (shuahkhan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)" <shuahkhan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org" <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 2014-12-15 at 11:42 -0500, Young, David wrote:
> Hi,  I'm looking into what sorts of tools can consume the selftest output, and
> found this on the wikipage:
> 
> https://kselftest.wiki.kernel.org/standardize_the_test_output
> 
> The current suggestion (as of the last-modified date on that wiki page for
> October) is to use the Test Anything Protocol [TAP] for standard output.  I
> notice that there is at least one test that conforms to TAP output, but
> the majority of the tests are not using it.
> 
> There's also the kselftest.h file that suggests exit codes for the individual
> test applications.
> 
> I'm interested in knowing what is the intention of this standardization, so
> that I can put some work into a "glue" layer for a tool like buildbot,
> autotest, or Jenkins for executing and consuming the results of these
> selftests.

I'm not the selftests "maintainer", but I have written a bunch of code under
selftests, so the following is my 2c.

The barrier for entry to selftests should be as low as we can make it. Our
preference should always be for more tests, even if some of them start out a
bit crufty.

As such, requiring tests to produce perfectly formatted output or error codes
is the wrong approach in my opinion.

So ..

> 1) Is this output standard a "nice to have" that won't be much enforced?

Yes I think so. I think at best we would hope for tests to converge on the
standard over time, but there will always be new tests arriving that are not so
well behaved.

> 2) Will the exit codes be utilized outside of the current makefile-based
>    approach for executing the tests?  The current make target just runs all the
>    tests without really concerning itself with the exit values of the
>    individual tests.  It's simple, which isn't a bad thing, but it lacks a
>    summarized result.  Is the intention to use a different harness to consume
>    and report results?

One of the advantages of producing TAP or some other standard format would be
to avoid needing our own harness just to produce a summary.

> 3) Are the TAP results intended to be the exclusive (std)output of the tests,
>    or will the tests report in a hybrid fashion?
>    Such an example would be a test that produces some verbose stdout to the
>    console, while simultaneously creating a TAP-compliant results.tap file as
>    well... or vice versa with the stdout being TAP and a more verbose but
>    free-form log.txt 

We probably want to be able to do both of those.


FWIW, (most of) the tests under tools/testing/selftests/powerpc produce subunit
v1 output (https://pypi.python.org/pypi/python-subunit).

So you can do:

 $ cd tools/testing/selftests/powerpc
 $ make run_tests 2>&1 | subunit-1to2 | subunit-stats --no-passthrough
 Total tests:      32
 Passed tests:     32
 Failed tests:      0
 Skipped tests:     0
 Seen tags: git_version:next-20141209-0-g5348e33


subunit has the advantage over TAP IMO that it uses "success", "failure" and
"error" rather than "ok", "not ok".

There is now a subunit v2, which is a binary protocol. I don't think we want
a binary protocol, but it does have the advantage of being much more robust
than text based output.

cheers
