From: Darren Hart <dvhart@linux.intel.com>
Subject: Re: futex(2) man page update help request
Date: Thu, 15 May 2014 08:47:12 -0700
Message-ID: <CF9A2F18.90E61%dvhart@linux.intel.com>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <537407ED.8050606@zytor.com>
 <CF999CD6.90A93%dvhart@linux.intel.com>
 <5374C54B.7040408@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5374C54B.7040408@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>
Cc: "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Davidlohr Bueso <davidlohr.bueso@hp.com>, Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Linux API <linux-api@vger.kernel.org>, Carlos O'Donell <carlos@redhat.com>
List-Id: linux-api@vger.kernel.org

On 5/15/14, 6:46, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
wrote:

>On 05/15/2014 07:21 AM, Darren Hart wrote:
>> On 5/14/14, 17:18, "H. Peter Anvin" <hpa@zytor.com> wrote:
>> 
>>> On 05/14/2014 09:18 AM, Darren Hart wrote:
>>>>
>>>> However, unless I'm sorely mistaken, the larger problem is that glibc
>>>> removed the futex() call entirely, so these man pages don't describe
>>>> something users even have access to anymore. I had to revert to
>>>>calling
>>>> the syscalls directly in the futextest test suite because of this:
>>>>
>>>>
>>>> 
>>>>http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/tree/i
>>>>nc
>>>> lu
>>>> de/futextest.h#n67
>>>>
>>>
>>> This really comes down to the fact that we should have a libinux which
>>> contains the basic system call wrapper machinery for Linux specific
>>> things and nothing else.
>>>
>>> syscall(3) is toxic and breaks randomly on some platforms.
>> 
>> Peter Z and I have had a good time discussing this in the past.... And
>> here it is again. :-)
>
>People have a number of times noted that there are problems
>with syscall(), but I'm not knowledgeable on the details.
>I'd happily take a patch to the man page (which, for historical
>reasons, is actually syscall(2)) that explains the the problems
>(and ideally notes those platforms where there are no problems).


>From my perspective, a named interface with specific documented interfaces
is far more usable than a vargs direct syscall. That just leaves all kinds
of room for error - which of course is why we all write our own wrappers
in our apps rather than use it directly... If we all do it, it seems to me
that is a strong indicator we should provide it in some kind of common
library. Maybe that's libc... Maybe that's libnix...
-- 
Darren Hart					Open Source Technology Center
darren.hart@intel.com				            Intel Corporation
