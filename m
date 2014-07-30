From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 11/11] seccomp: Add tgid and tid into seccomp_data
Date: Tue, 29 Jul 2014 21:08:11 -0700
Message-ID: <87oaw7ij4k.fsf@x220.int.ebiederm.org>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
	<1406296033-32693-12-git-send-email-drysdale@google.com>
	<CALCETrVJX4+-6vkRaDj4kV_bXiYL5fj_PtO53g9fRf=i4X2Tww@mail.gmail.com>
	<CAGXu5jJZ7mhmq1BrdTP5Ww15+C2iLQKjLy1Xh0=9qZvVK5E9Cw@mail.gmail.com>
	<CALCETrVChObsQpL6dt-ByiCjbPrtpXAXQgy_apBY-OpGQHaPjg@mail.gmail.com>
	<87vbqhp4hf.fsf@x220.int.ebiederm.org>
	<CALCETrWaUsi1Ea3YTXLN6BFqcoHnbFTuMvcNncS5rq0nSgOatA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWaUsi1Ea3YTXLN6BFqcoHnbFTuMvcNncS5rq0nSgOatA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Andy Lutomirski's message of "Tue, 29 Jul 2014 21:05:42 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:

> On Mon, Jul 28, 2014 at 2:18 PM, Eric W. Biederman
> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
>>
>>> [cc: Eric Biederman]
>>>
>>
>>> Can we do one better and add a flag to prevent any non-self pid
>>> lookups?  This might actually be easy on top of the pid namespace work
>>> (e.g. we could change the way that find_task_by_vpid works).
>>>
>>> It's far from just being signals.  There's access_process_vm, ptrace,
>>> all the signal functions, clock_gettime (see CPUCLOCK_PID -- yes, this
>>> is ridiculous), and probably some others that I've forgotten about or
>>> never noticed in the first place.
>>
>> So here is the practical question.
>>
>> Are these processes that only can send signals to their thread group
>> allowed to call fork()?
>>
>>
>> If fork is allowed and all pid lookups are restricted to their own
>> thread group that wait, waitpid, and all of the rest of the wait family
>> will never return the pids of their children, and zombies will
>> accumulate.  Aka the semantics are fundamentally broken.
>
> Good point.
>
> I can imagine at least three ways that fork() could continue working, though:
>
> 1. Allow lookups of immediate children, too.  (I don't love this one.)
> 2. Allow non-self pids to be translated in but not out.  This way
> P_ALL will continue working.
> 3. Have the kernel treat any PID-restricted process as though it were NOCLDWAIT.
>
> I think I like #3.  Thoughts?
>
>>
>> If fork is not allowed pid namespaces already solve this problem.
>
> PID namespaces are fairly heavyweight.  Julien pointed out that using
> PID namespaces requires a bunch of dummy PID 1 processes.

Only if you can't tolerate init exiting.  The reasoning with respect to
signals and signals being ignored was wrong.  And if you only have one
process you care about and no children to worry about neither the
difference in signal handling nor the world dies whe init exits applies.

Therefore given what I have read described pid namespaces are a trivial
solution to this problem space.

Eric
