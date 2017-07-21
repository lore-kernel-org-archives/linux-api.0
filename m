From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 6/7] fcntl: Don't use ambiguous SIG_POLL si_codes
Date: Thu, 20 Jul 2017 21:33:52 -0500
Message-ID: <87lgni7c33.fsf@xmission.com>
References: <87o9shg7t7.fsf_-_@xmission.com>
        <20170718140651.15973-6-ebiederm@xmission.com>
        <20170720161603.GA14430@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20170720161603.GA14430@redhat.com> (Oleg Nesterov's message of
        "Thu, 20 Jul 2017 18:16:04 +0200")
Sender: linux-arch-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrei Vagin <avagin@virtuozzo.com>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>, Andrey Vagin <avagin@openvz.org>, Serge Hallyn <serge@hallyn.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Peter Zijlstra <peterz@infradead.org>, Willy Tarreau <w@1wt.eu>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Linux Containers <containers@lists.linux-foundation.org>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org



Oleg Nesterov <oleg@redhat.com> writes:

> On 07/18, Eric W. Biederman wrote:
>>
>> -			BUG_ON((reason & __SI_MASK) != __SI_POLL);
>> +			BUG_ON((reason < POLL_IN) || (reason > NSIGPOLL));
>                                                       ^^^^^^^^^^^^^^^^^
> looks obviously wrong? Say, POLL_IN is obviously > NSIGPOLL == 6.

Strictly speaking that code is wrong until the next patch
when I remove __SI_POLL.  That is my mistake.

When the values are not their messed up internal kernel variants
the code works fine and makes sense.

#define POLL_IN		1	/* data input available */
#define POLL_OUT	2	/* output buffers available */
#define POLL_MSG	3	/* input message available */
#define POLL_ERR	4	/* i/o error */
#define POLL_PRI	5	/* high priority input available */
#define POLL_HUP	6	/* device disconnected */
#define NSIGPOLL	6

> Probably you meant
>
> 			BUG_ON((reason < POLL_IN) || (reason - POLL_IN > NSIGPOLL)
>
> ?
>
> but this contradicts with the next line:

>>  			if (reason - POLL_IN >= NSIGPOLL)
>>  				si.si_band  = ~0L;
>
> confused...

I am mystified why we test for a condition that we have been bugging on
for ages.

Eric
