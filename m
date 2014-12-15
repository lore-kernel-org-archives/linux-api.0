From: "Young, David" <dayoung-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: selftests: standardized results output?
Date: Mon, 15 Dec 2014 11:42:12 -0500
Message-ID: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3DABAC24@USMBX1.msg.corp.akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Shuah Khan (shuahkhan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)" <shuahkhan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org" <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,  I'm looking into what sorts of tools can consume the selftest output, and
found this on the wikipage:

https://kselftest.wiki.kernel.org/standardize_the_test_output

The current suggestion (as of the last-modified date on that wiki page for
October) is to use the Test Anything Protocol [TAP] for standard output.  I
notice that there is at least one test that conforms to TAP output, but
the majority of the tests are not using it.

There's also the kselftest.h file that suggests exit codes for the individual
test applications.

I'm interested in knowing what is the intention of this standardization, so
that I can put some work into a "glue" layer for a tool like buildbot,
autotest, or Jenkins for executing and consuming the results of these
selftests.

1) Is this output standard a "nice to have" that won't be much enforced?
2) Will the exit codes be utilized outside of the current makefile-based
   approach for executing the tests?  The current make target just runs all the
   tests without really concerning itself with the exit values of the
   individual tests.  It's simple, which isn't a bad thing, but it lacks a
   summarized result.  Is the intention to use a different harness to consume
   and report results?
3) Are the TAP results intended to be the exclusive (std)output of the tests,
   or will the tests report in a hybrid fashion?
   Such an example would be a test that produces some verbose stdout to the
   console, while simultaneously creating a TAP-compliant results.tap file as
   well... or vice versa with the stdout being TAP and a more verbose but
   free-form log.txt 

Thanks,

- David Young
