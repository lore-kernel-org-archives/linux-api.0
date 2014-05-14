From: Darren Hart <dvhart@linux.intel.com>
Subject: Re: futex(2) man page update help request
Date: Wed, 14 May 2014 14:03:13 -0700
Message-ID: <CF99279F.907FC%dvhart@linux.intel.com>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
 <1400100977.3865.30.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1400100977.3865.30.camel@buesod1.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <davidlohr@hp.com>, mtk.manpages@gmail.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Davidlohr Bueso <davidlohr.bueso@hp.com>, Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Linux API <linux-api@vger.kernel.org>, Carlos O'Donell <carlos@redhat.com>, mathieu.desnoyers@efficios.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

On 5/14/14, 13:56, "Davidlohr Bueso" <davidlohr@hp.com> wrote:

>On Wed, 2014-05-14 at 21:03 +0200, Michael Kerrisk (man-pages) wrote:
>> Hi Darren,
>> 
>> On Wed, May 14, 2014 at 6:18 PM, Darren Hart <dvhart@linux.intel.com>
>>wrote:
>> > On 5/14/14, 3:35, "Michael Kerrisk (man-pages)"
>><mtk.manpages@gmail.com>
>> > wrote:
>> >
>> >>[So, some futex recent discussions remind me I should make this
>>request]
>> >>
>> >>Hello all (especially those in the To:, namely Thomas, Darren, Ingo,
>> >>Jakub),
>> >>
>> >>The futex man pages:
>> >>http://man7.org/linux/man-pages/man2/futex.2.html
>> >>http://man7.org/linux/man-pages/man7/futex.7.html
>> >>are currently in a sorry state. I'm by no means convinced that all of
>>the
>> >>futex operations described there are explained fully and correctly.
>>And
>> >>probably not all error cases for each operation are properly
>>documented.
>> >>I'd be very happy if some folk could review those pages and send me
>> >>corrections (Git:
>> >>http://git.kernel.org/pub/scm/docs/man-pages/man-pages).
>> >>
>> >>But worse, a number of futex operations remain undocumented in
>>futex(2)
>> >>(see the list below).
>> >>
>> >>I am aware of Documentation/pi-futex.txt and
>> >>Documentation/futex-requeue-pi.txt. However, both of those documents
>> >>are rather thin on details / explain what certain FUTEX_* operations
>>are
>> >>used for rather than what they do / focus on the implementation,
>>rather
>> >>than the semantics.
>> >>
>> >>What I would like is that the futex(2) page documenta each one of
>> >>these operations with a focus on the semantics in a way that might be
>> >>useful to writers of library functions or those who simply wish to
>> >>better understand (from a user-space perspective) what futexes are
>> >>and how they are used. However, I don't have the knowledge to do
>> >>this well in any reasonable time.
>> >>
>> >>Would the folk in the To: list (or anyone else who is knowledgeable)
>> >>be willing to write patches
>> >>(Git: http://git.kernel.org/pub/scm/docs/man-pages/man-pages )
>> >>or just supply me with some raw text that documents these currently
>> >>undocumented futex operations, in the manner suggested?
>> >
>> > Yes, I'll be glad to help.
>> 
>> Thanks!
>> 
>> > However, unless I'm sorely mistaken, the larger problem is that glibc
>> > removed the futex() call entirely, so these man pages don't describe
>> 
>> I don't think futex() ever was in glibc--that's by design, and
>> completely understandable: no user-space application would want to
>> directly use futex().
>
>That's actually not quite true. There are plenty of software efforts out
>there that use futex calls directly to implement userspace serialization
>mechanisms as an alternative to the bulky sysv semaphores. I worked
>closely with an in-memory DB project that makes heavy use of them. Not
>everyone can simply rely on pthreads.

Userspace RCU from Mattieu Desnoyers / Efficios uses it as well - or did.

>
>> (BTW, I mispoke in my earlier mail when I said I
>> wanted documentation suitable for "writers of library functions" -- I
>> meant suitable for "writers of *C library*".)
>
>While kind of beyond the scope of documentation like manpages, I would
>very much welcome this! The internet is full of
>misleading/false/stupid/incomplete references to futexes and how to use
>them. Having a best practises helps the kernel directly avoiding users
>from misusing them.

Agreed.

-- 
Darren Hart					Open Source Technology Center
darren.hart@intel.com				            Intel Corporation
