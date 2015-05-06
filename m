From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [GIT PULL] selftest: Add futex functional tests
Date: Wed, 06 May 2015 11:34:52 -0700
Message-ID: <1430937292.1940.32.camel@stgolabs.net>
References: <cover.1427493640.git.dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1427493640.git.dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
List-Id: linux-api@vger.kernel.org

On Fri, 2015-03-27 at 15:17 -0700, Darren Hart wrote:
> Hi Shuah,
> 
> This series begins the process of migrating my futextest tests into kselftest.
> I've started with only the functional tests, as the performance and stress may
> not be appropriate for kselftest as they stand.
> 
> I cleaned up various complaints from checkpatch, but I ignored others that would
> require significant rework of the testcases, such as not using volatile and not
> creating new typedefs.
> 
> The patches will follow, but I'm providing a pull request for your convenience
> as well.
> 
> The following changes since commit 0b63accf87225b5eb7e52814c374cf02d733d4bb:
> 
>   tools, update rtctest.c to verify passage of time (2015-03-24 22:02:59 -0600)
> 
> are available in the git repository at:
> 
>   git://git.infradead.org/users/dvhart/linux.git futextest
> 
> Darren Hart (5):
>   selftests: Add futex functional tests
>   selftest/futex: Update Makefile to use lib.mk
>   selftest/futex: Increment ksft pass and fail counters
>   selftest: Add futex tests to the top-level Makefile
>   kselftest: Add exit code defines

I haven't really gone through these, but given how much I use these
tests from your tree, I'm very glad to see them converted for upstream.
I hope its as easy to use in kselftests though.

Acked-by: Davidlohr Bueso <dave@stgolabs.net>
