From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 0/7] CLONE_FD: Task exit notification via file descriptor
Date: Mon, 16 Mar 2015 15:36:16 -0700
Message-ID: <CAGXu5jJr_DieZ281=H0ZNtNvOagO0pm8PRfNvRWKp4YwS=55GA@mail.gmail.com>
References: <cover.1426376419.git.josh@joshtriplett.org>
	<CAGXu5jLmLLgVNCP=cyUiXuiszVXsS88SNUK2iBqArbA2V6vdHA@mail.gmail.com>
	<2381173.VxaIO6vGG3@tjmaciei-mobl4>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2381173.VxaIO6vGG3@tjmaciei-mobl4>
Sender: linux-kernel-owner@vger.kernel.org
To: Thiago Macieira <thiago.macieira@intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 16, 2015 at 3:14 PM, Thiago Macieira
<thiago.macieira@intel.com> wrote:
> On Monday 16 March 2015 14:44:20 Kees Cook wrote:
>> >               O_CLOEXEC
>> >                      Set  the  close-on-exec  flag on the new file
>> >descriptor. See the description of the O_CLOEXEC flag in open(2)  for
>> >reasons why this may be useful.
>>
>> This begs the question: what happens when all CLONE_FD fds for a
>> process are closed? Will the parent get SIGCHLD instead, will it
>> auto-reap, or will it be un-wait-able (I assume not this...)
>
> Depends on CLONE_AUTOREAP. If it's on, then no one gets SIGCHLD, no one can
> wait() on it and the process autoreaps itself.
>
> If it's no active, then the old rules apply: parent gets SIGCHILD and can
> wait(). If the parent exited first, then the child gets reparented to init,
> which can do the wait().
>
> A child without CLONE_AUTOREAP should be wait()able. If it gets wait()ed
> before the clonefd is read, the clonefd() will return a 0 read. If it gets
> read before wait, then wait() reaps another child or returns -ECHILD. That's
> no different than two threads doing simultaneous wait() on the same child.

Cool. I think detailing this in the manpage would be helpful.

And just so I understand the races here, what happens in CLONE_FD
(without CLONE_AUTOREAP) case where the child dies, but the parent
never reads from the CLONE_FD fd, and closes it (or dies)? Will the
modes switch that late in the child's lifetime? (i.e. even though the
details were written to the fd, they were never read, yet it'll still
switch and generate a SIGCHLD, etc?)

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
