From: Cyril Hrubis <chrubis@suse.cz>
Subject: Re: [PATCH 1/5] selftests: Add futex functional tests
Date: Tue, 12 May 2015 22:05:28 +0200
Message-ID: <20150512200528.GA1336@rei>
References: <D1763F31.CC237%dvhart@linux.intel.com>
 <5550FB2C.1000403@osg.samsung.com>
 <D17653E0.CC29F%dvhart@linux.intel.com>
 <5551164E.5080409@osg.samsung.com>
 <D17670E1.CC354%dvhart@linux.intel.com>
 <55512B54.50304@osg.samsung.com>
 <55512B86.2040900@osg.samsung.com>
 <D1767EA1.CC3DA%dvhart@linux.intel.com>
 <20150512100256.GA5122@rei.suse.de>
 <D1777231.CC5D0%dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <D1777231.CC5D0%dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Darren Hart <dvhart@linux.intel.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Davidlohr Bueso <dave@stgolabs.net>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
List-Id: linux-api@vger.kernel.org

Hi!
> >> I'm happy to do that, but I would like to make sure I'm doing the right
> >> thing.
> >
> >The right thing here is to add -pthread to CFLAGS which sets both flags
> >for preprocessor and linker (see man gcc).
> 
> Hi Cyril,
> 
> Thanks. I read that, and mentioned it, but my concern with -pthread in the
> CFLAGS and LDFLAGS is that it is a non-standard compiler flag. I
> understand we have a number of gcc-isms in our build - but do we want to
> add more?
>
> I'm also struggling to find any kind of prescribed documentation on this
> beyond the short blurb in the gcc man page which describes what this
> option does, but not when to use it. I'll need something concrete to
> justify changes to testcase Makefiles to Shuah.

Sorry to mislead you with the pointing at gcc man page.

It is a Linux standard. Have a look at pthreads manual page:
http://man7.org/linux/man-pages/man7/pthreads.7.html

"On Linux, programs that use the Pthreads API should be compiled using
 cc -pthread."

Or any pthread_foo() manual page that starts with:

"Compile and link with -pthread."

The portable way i.e. POSIX would be getting compiler flags with getconf
but as this is a Linux kernel testsuite I would not bother with that.
Hmm, and it looks like this is not implemented on Linux anyway.

-- 
Cyril Hrubis
chrubis@suse.cz
