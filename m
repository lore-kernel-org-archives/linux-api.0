From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 1/5] selftests: Add futex functional tests
Date: Mon, 11 May 2015 12:06:05 -0600
Message-ID: <5550EF8D.8080403@osg.samsung.com>
References: <cover.1431121818.git.dvhart@linux.intel.com> <57d921b1c30e8258ca4b2f55637424527317e92f.1431121818.git.dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <57d921b1c30e8258ca4b2f55637424527317e92f.1431121818.git.dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Darren Hart <dvhart@linux.intel.com>, linux-api@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Davidlohr Bueso <dave@stgolabs.net>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On 05/08/2015 04:09 PM, Darren Hart wrote:
> The futextest testsuite [1] provides functional, stress, and
> performance tests for the various futex op codes. Those tests will be of
> more use to futex developers if they are included with the kernel
> source.
> 
> Copy the core infrastructure and the functional tests into selftests,
> but adapt them for inclusion in the kernel:
> 
> - Update the Makefile to include the run_tests target, remove reference
>   to the performance and stress tests from the contributed sources.
> - Replace my dead IBM email address with my current Intel email address.
> - Remove the warrantee and write-to paragraphs from the license blurbs.
> - Remove the NAME section as the filename is easily determined. ;-)
> - Make the whitespace usage consistent in a couple of places.
> - Cleanup various CodingStyle violations.
> 
> A future effort will explore moving the performance and stress tests
> into the kernel.
> 
> 1. http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git
> 
> Cc: Shuah Khan <shuahkh@osg.samsung.com>
> Cc: linux-api@vger.kernel.org
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> ---

Daren,

I am seeing

fatal: cannot convert from y to UTF-8

when I try to apply the patch. Did you use git send-email?


-- Shuah



-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
