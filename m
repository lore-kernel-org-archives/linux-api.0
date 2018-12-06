From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v4] signal: add taskfd_send_signal() syscall
Date: Thu, 6 Dec 2018 23:39:51 +0100
Message-ID: <20181206223948.gyfdtkgbhtozmpsp@brauner.io>
References: <20181206121858.12215-1-christian@brauner.io>
 <87sgzahf7k.fsf@xmission.com>
 <D372C766-572C-4897-8F02-2FD0E72CCFAC@brauner.io>
 <875zw6bh2z.fsf@xmission.com>
 <20181206193017.wpxls5p3zgjd6rv2@brauner.io>
 <871s6u9z6u.fsf@xmission.com>
 <20181206213152.gvci7ijr3dokew7w@brauner.io>
 <87o99y72gi.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87o99y72gi.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@kernel.org, arnd@arndb.de, serge@hallyn.com, jannh@google.com, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, keescook@chromium.org, fweimer@redhat.com, tglx@linutronix.de, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 06, 2018 at 03:46:53PM -0600, Eric W. Biederman wrote:
> Christian Brauner <christian@brauner.io> writes:
> 
> >> Your intention is to add the thread case to support pthreads once the
> >> process case is sorted out.  So this is something that needs to be made
> >> clear.  Did I miss how you plan to handle threads?
> >
> > Yeah, maybe you missed it in the commit message [2] which is based on a
> > discussion with Andy [3] and Arnd [4]:
> 
> Looking at your references I haven't missed it.  You are not deciding
> anything as of yet to keep it simple.  Except you are returning
> EOPNOTSUPP.  You are very much intending to do something.

That was clear all along and was pointed at every occassion in the
threads. I even went through the hazzle to give you all of the
references when there's lore.kernel.org.

> 
> Decide.  Do you use the flags parameter or is the width of the
> target depending on the flags.

I'm sorry I don't understand what you a) mean with this sentence "width
of the target" and b) what you *exactly* want from us to get this accepted.

> 
> That is fundamental to how the system call and it's extensions work.
> That is fundamental to my review.
> 
> Until that is decided.
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> There are a lot of fundamental maintenance issues and you can very easily
> get them wrong if you are not clear on the job of the file descriptor
> and the job of the flags argument.
> 
> I want don't want new crap that we have to abandon that has a nasty set
> of bugs because no one wanted to think through the system call all of
> the way and understand the corner cases.

That's why this system call is exactly kept as simple as it is. Which I
had to fight for! You kept consistenly asking for features such as:
- add a pid parameter maybe
- allow to signal into ancestor and cousin pid namespaces
I fought all of those off for the sake of keeping this patch as simple
as possible so that we can get it in.
We don't even need to decide whether we go for flags or another type of
fd right now. The point was that we can postpone this to a later
discussion. Which also has been discussed in multiple threads. That's
literally what I wrote in prior mails and nearly everyone agreed that
this is a good strategy.

I honestly have no idea what to make of your review given that it
started from a naming issue and suddenly the whole api is crap.
If you want this to be named fd_send_signal() to get in. Then seriously,
I'm happy to rename it. I honestly don't care even though I think taskfd
is a better name.

> 
> Eric
