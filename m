From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Next round: revised futex(2) man page for review
Date: Wed, 07 Oct 2015 10:34:19 +0100
Message-ID: <5614E71B.3040500@gmail.com>
References: <55B61EF3.7080302@gmail.com> <20150805222140.GA74817@vmdeb7> <alpine.DEB.2.11.1508200031220.3873@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1508200031220.3873@nanos>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, bert hubert <bert.hubert-dxZxOz86jR8sYtaaK7K+xw@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 08/19/2015 03:40 PM, Thomas Gleixner wrote:
> On Wed, 5 Aug 2015, Darren Hart wrote:
>> On Mon, Jul 27, 2015 at 02:07:15PM +0200, Michael Kerrisk (man-pages) wrote:
>>> .\" FIXME XXX ===== Start of adapted Hart/Guniguntala text =====
>>> .\"       The following text is drawn from the Hart/Guniguntala paper
>>> .\"       (listed in SEE ALSO), but I have reworded some pieces
>>> .\"       significantly. Please check it.
>>>
>>>        The PI futex operations described below  differ  from  the  other
>>>        futex  operations  in  that  they impose policy on the use of the
>>>        value of the futex word:
>>>
>>>        *  If the lock is not acquired, the futex word's value  shall  be
>>>           0.
>>>
>>>        *  If  the  lock is acquired, the futex word's value shall be the
>>>           thread ID (TID; see gettid(2)) of the owning thread.
>>>
>>>        *  If the lock is owned and there are threads contending for  the
>>>           lock,  then  the  FUTEX_WAITERS  bit shall be set in the futex
>>>           word's value; in other words, this value is:
>>>
>>>               FUTEX_WAITERS | TID
>>>
>>>
>>>        Note that a PI futex word never just has the value FUTEX_WAITERS,
>>>        which is a permissible state for non-PI futexes.
>>
>> The second clause is inappropriate. I don't know if that was yours or
>> mine, but non-PI futexes do not have a kernel defined value policy, so
>> ==FUTEX_WAITERS cannot be a "permissible state" as any value is
>> permissible for non-PI futexes, and none have a kernel defined state.
> 
> Depends. If the regular futex is configured as robust, then we have a
> kernel defined value policy as well.

Okay -- so do we need a change to the text here?

>>> .\" FIXME I'm not quite clear on the meaning of the following sentence.
>>> .\"       Is this trying to say that while blocked in a
>>> .\"       FUTEX_WAIT_REQUEUE_PI, it could happen that another
>>> .\"       task does a FUTEX_WAKE on uaddr that simply causes
>>> .\"       a normal wake, with the result that the FUTEX_WAIT_REQUEUE_PI
>>> .\"       does not complete? What happens then to the FUTEX_WAIT_REQUEUE_PI
>>> .\"       opertion? Does it remain blocked, or does it unblock
>>> .\"       In which case, what does user space see?
>>>
>>>               The
>>>               waiter   can  be  removed  from  the  wait  on  uaddr  via
>>>               FUTEX_WAKE without requeueing on uaddr2.
>>
>> Userspace should see the task wake and continue executing. This would
>> effectively be a cancelation operation - which I didn't think was
>> supported. Thomas?
> 
> We probably never intended to support it, but looking at the code it
> works (did not try it though). It returns to user space with
> -EWOULDBLOCK. So it basically behaves like any other spurious wakeup.

Again, I assume no changes are required to the man page(?).

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
