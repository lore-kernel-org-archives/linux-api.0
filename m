From: Waiman Long <waiman.long-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [PATCH 3/7] locking/rwsem: check for active writer/spinner before
 wakeup
Date: Tue, 05 Aug 2014 13:56:16 -0400
Message-ID: <53E11AC0.6030200@hp.com>
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>  <1407119782-41119-4-git-send-email-Waiman.Long@hp.com> <1407187217.11985.14.camel@j-VirtualBox>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407187217.11985.14.camel@j-VirtualBox>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>, Scott J Norton <scott.norton-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 08/04/2014 05:20 PM, Jason Low wrote:
> On Sun, 2014-08-03 at 22:36 -0400, Waiman Long wrote:
>> On a highly contended rwsem, spinlock contention due to the slow
>> rwsem_wake() call can be a significant portion of the total CPU cycles
>> used. With writer lock stealing and writer optimistic spinning, there
>> is also a pretty good chance that the lock may have been stolen
>> before the waker wakes up the waiters. The woken tasks, if any,
>> will have to go back to sleep again.
>>
>> This patch adds checking code at the beginning of the rwsem_wake()
>> and __rwsem_do_wake() function to look for spinner and active
>> writer respectively.  The presence of an active writer will abort the
>> wakeup operation.  The presence of a spinner will still allow wakeup
>> operation to proceed as long as the trylock operation succeeds. This
>> strikes a good balance between excessive spinlock contention especially
>> when there are a lot of active readers and a lot of failed fastpath
>> operations because there are tasks waiting in the queue.
>>
>> Signed-off-by: Waiman Long<Waiman.Long-VXdhtT5mjnY@public.gmane.org>
>> ---
>>   include/linux/osq_lock.h    |    5 ++++
>>   kernel/locking/rwsem-xadd.c |   57 ++++++++++++++++++++++++++++++++++++++++++-
>>   2 files changed, 61 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/osq_lock.h b/include/linux/osq_lock.h
>> index 90230d5..79db546 100644
>> --- a/include/linux/osq_lock.h
>> +++ b/include/linux/osq_lock.h
>> @@ -24,4 +24,9 @@ static inline void osq_lock_init(struct optimistic_spin_queue *lock)
>>   	atomic_set(&lock->tail, OSQ_UNLOCKED_VAL);
>>   }
>>
>> +static inline bool osq_has_spinner(struct optimistic_spin_queue *lock)
>> +{
>> +	return atomic_read(&lock->tail) != OSQ_UNLOCKED_VAL;
>> +}
> Like with other locks, should we make this "osq_is_locked"? We can still
> add the rwsem has_spinner() abstractions which makes use of
> osq_is_locked() if we want.
>
>

Yes, that is a good idea. I will make the change in the next version.

-Longman
