From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Date: Mon, 21 Jul 2014 09:45:55 -0700
Message-ID: <871tte3bjw.fsf@tassilo.jf.intel.com>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
	<8761iq3bp3.fsf@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8761iq3bp3.fsf@tassilo.jf.intel.com> (Andi Kleen's message of
	"Mon, 21 Jul 2014 09:42:48 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@linux.intel.com>, Davidlohr Bueso <davidlohr@hp.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>
List-Id: linux-api@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Waiman Long <Waiman.Long@hp.com> writes:
>
>> This patch series introduces two new futex command codes to support
>> a new optimistic spinning futex for implementing an exclusive lock
>> primitive that should perform better than the same primitive using
>> the wait-wake futex in cases where the lock owner is actively working
>> instead of waiting for I/O completion.
>
> How would you distinguish those two cases automatically?

Also BTW traditionally the spinning was just done in user space.

This would be always even more efficient, because it would 
even avoid the syscall entry path.

Given the glibc adaptive mutexes are not very good, but I'm sure those
could be improved.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
