From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v2 3/3] restartable sequences: basic self-tests
Date: Wed, 6 Apr 2016 13:39:22 +0000 (UTC)
Message-ID: <528054829.46502.1459949962537.JavaMail.zimbra@efficios.com>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com> <20151027235716.16059.47610.stgit@pjt-glaptop.roam.corp.google.com> <1276514010.46061.1459888406999.JavaMail.zimbra@efficios.com> <20160406074309.GE3430@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160406074309.GE3430-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Paul Turner <commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Apr 6, 2016, at 3:43 AM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:

> On Tue, Apr 05, 2016 at 08:33:27PM +0000, Mathieu Desnoyers wrote:
> 
>> A problematic execution sequence would be
>> 
>> * Exhibit A: ABA (all threads running on same CPU):
>> 
>> Initial state: the list has a single entry "object Z"
>> 
>>        Thread A                       Thread B
>> - percpu_list_pop()
>>   - cpu = rseq_current_cpu();
>>   - head = list->heads[cpu];
>>     (head is a pointer to object Z)
>>   - next = head->next;
>>   (preempted)
>>                                       (scheduled in)
>>                                       - percpu_list_pop()
>>                                         - cpu = rseq_current_cpu();
>>                                         - head = list->heads[cpu];
>>                                           (head is a pointer to object Z)
>>                                         - rseq_percpu_cmpxchgcheck succeeds
>>                                       - percpu_list_push of a new object Y
>>                                       - percpu_list_push of a re-used object Z
>>                                         (its next pointer now points to object Y
>>                                         rather than end of list)
>>                                       (preempted)
>>   (scheduled in)
>>   - rseq_percpu_cmpxchgcheck succeeds,
>>     setting a wrong value into the list
>>     head: it will store an end of list,
>>     thus skipping over object Y.
> 
> OK, so I'm still trying to wake up, but I'm not seeing how
> rseq_percpu_cmpxchgcheck() would succeed in this case.
> 
> If you look at the code, the 'check' part would fail, that is:
> 
>> +struct percpu_list_node *percpu_list_pop(struct percpu_list *list)
>> +{
>> +	int cpu;
>> +	struct percpu_list_node *head, *next;
>> +
>> +	do {
>> +		cpu = rseq_current_cpu();
>> +		head = list->heads[cpu];
>> +		/*
>> +		 * Unlike a traditional lock-less linked list; the availability
>> +		 * of a cmpxchg-check primitive allows us to implement pop
>> +		 * without concerns over ABA-type races.
>> +		 */
>> +		if (!head) return 0;
>> +		next = head->next;
>> +	} while (cpu != rseq_percpu_cmpxchgcheck(cpu,
>> +		(intptr_t *)&list->heads[cpu], (intptr_t)head, (intptr_t)next,
>> +		(intptr_t *)&head->next, (intptr_t)next));
> 
> The extra compare is 'head->next == next', and our thread-A will have
> @next == NULL (EOL), while the state after thread-B ran would be
> @head->next = &Y.
> 
> So the check will fail, the cmpxchg will fail, and around we go.
> 
>> +
>> +	return head;
>> +}
> 
> Or am I completely not getting it?

No, you're right. I entirely missed the role of check_ptr and
check_val in rseq_percpu_cmpxchgcheck. That indeed ensures we
atomically check, from a per-cpu perspective, that both the
pointer we are about to update and the next pointer are still
the same. Mystery solved. :-)

And of course, for the percpu_list_push(), the rseq_percpu_cmpxchg()
there is enough, because we always try to add a node we own into
the list, and only ever compare to the head. This one is
straightforwardly ABA-free even without rseq.

There is still the question of use-after-free however that
remains open. My understanding is that this lock-free list
should be paired with either a type-safe memory allocator,
using RCU, or a garbage collector.

Thoughts ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
