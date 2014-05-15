From: Darren Hart <dvhart@linux.intel.com>
Subject: Re: futex(2) man page update help request
Date: Thu, 15 May 2014 09:14:05 -0700
Message-ID: <CF9A3521.90ECC%dvhart@linux.intel.com>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <20140515152834.GA6926@rei.Home>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140515152834.GA6926@rei.Home>
Sender: linux-kernel-owner@vger.kernel.org
To: chrubis@suse.cz
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Davidlohr Bueso <davidlohr.bueso@hp.com>, Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Linux API <linux-api@vger.kernel.org>, Carlos O'Donell <carlos@redhat.com>
List-Id: linux-api@vger.kernel.org

On 5/15/14, 8:28, "chrubis@suse.cz" <chrubis@suse.cz> wrote:

>Hi!
>> 
>> However, unless I'm sorely mistaken, the larger problem is that glibc
>> removed the futex() call entirely, so these man pages don't describe
>> something users even have access to anymore. I had to revert to calling
>> the syscalls directly in the futextest test suite because of this:
>> 
>> 
>>http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/tree/inc
>>lu
>
>So there actually exists some tests for futexes, I've been asked if we
>have these as a LTP[1] maintainer several times.
>
>Are these tests executed regulary as a part of some automated framework?
>If not it would make sense to port them to LTP (looking at the code that
>would be quite easy task) and get them executed by several QA
>departments for free. What do you think?
>
>[1] http://linux-test-project.github.io/

I've used LTP in the past (quite a bit), and I felt there was some
advantage to keeping futextest independent. Perhaps things have changed
enough since then (~2009 era) that we should reconsider. We can discuss
the pros/cons there if you like. I have agreed to move the performance
related tests over to perf, and Davidlohr has added some other such tests
to perf. Trinity now covers the planned fuzz testing for futexes (very
well... Obviously) so that idea will be dropped, leaving pure functional
tests in futextest.

-- 
Darren Hart					Open Source Technology Center
darren.hart@intel.com				            Intel Corporation
