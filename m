From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH] thread_local_abi system call: caching current CPU
 number (x86)
Date: Fri, 17 Jul 2015 16:12:47 +0000 (UTC)
Message-ID: <466417291.1018.1437149567296.JavaMail.zimbra@efficios.com>
References: <1437076851-14848-1-git-send-email-mathieu.desnoyers@efficios.com> <5CDDBDF2D36D9F43B9F5E99003F6A0D48D616ED9@PRN-MBX02-1.TheFacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5CDDBDF2D36D9F43B9F5E99003F6A0D48D616ED9@PRN-MBX02-1.TheFacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ben Maurer <bmaurer@fb.com>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Jul 17, 2015, at 6:49 AM, Ben Maurer bmaurer@fb.com wrote:

> Mathieu Desnoyers wrote:
>> Expose a new system call allowing threads to register a userspace memory
>> area where to store the current CPU number. Scheduler migration sets the
> 
> I really like that this approach makes it easier to add a per-thread interaction
> between userspace and the kernel in the future.
> 
>>+       if (!tlap || t->thread_local_abi_len <
>>+                       offsetof(struct thread_local_abi, cpu)
>>+                       + sizeof(tlap->cpu))
> 
> Could you save a branch here by enforcing that thread_local_abi_len = 0 if
> thread_local_abi = null?

Yes, good idea! Will do.

Thanks!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
