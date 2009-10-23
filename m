From: Oren Laadan <orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Date: Fri, 23 Oct 2009 15:34:10 -0400
Message-ID: <4AE20532.6060809@librato.com>
References: <20091020005125.GG27627@count0.beaverton.ibm.com>	<m1vdiad9jd.fsf@fess.ebiederm.org>	<20091020040315.GA26632@us.ibm.com>	<m1iqeauyvl.fsf@fess.ebiederm.org>	<20091020183329.GB22646@us.ibm.com>	<m1r5sxsw7w.fsf@fess.ebiederm.org>	<20091021062021.GA2667@us.ibm.com>	<m1eioxrtsb.fsf@fess.ebiederm.org>	<20091023004253.GA7915@us.ibm.com>	<m1bpjyrkep.fsf@fess.ebiederm.org>	<20091023053001.GA24972@us.ibm.com> <4AE20124.4010108@librato.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AE20124.4010108-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org



Oren Laadan wrote:
> 
> Sukadev Bhattiprolu wrote:
>> Eric W. Biederman [ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org] wrote:
>> | > | +	if (target < RESERVED_PIDS)
>> | >
>> | > Should we replace RESERVED_PIDS with 0 ? We currently allow new
>> | > containers to have pids 1..32K in the first pass and in subsequent
>> | > passes assign starting at RESERVED_PIDS.
>> | 
>> | If it is a preexisting namespace pid namespace removing the RESERVED_PIDS
>> | check removes most if not all of the point of RESERVED_PIDS.
>> | 
>> | In a new fresh pid namespace I have no problem with not performing
>> | the RESERVED_PIDS check.
>>
>> In that case can we do this
>>
>> 	if (target_pid < RESERVED_PIDS && !pid_ns->level)
>> 		return -EINVAL;
>>
>> instead ?
>> | 
>> | So I guess that makes the check.
>> | 
>> | if ((target < RESERVED_PIDS) && pid_ns->last_pid >= RESERVED_PIDS)
>> |    return -EINVAL;
>>
>> I am just wondering if there is a small corner case where C/R would randomly
>> fail because of this sequence:
>>
>> 	- C/R code calls clone() or clone3() say about RESERVED_PIDS-1
>> 	  times and ->last_pid == RESERVED_PIDS-1.
>>
>> 	- C/R code calls normal fork()/alloc_pidmap() for a short-lived
>> 	  child - its pid == ->last_pid == RESERVED_PIDS
>>
>> 	- C/R code then calls clone3()/set_pidmap() to set the pid of
>> 	  a new child to RESERVED_PID but fails (i.e it fails to restore
>> 	  a pid even when the pid is not in use).
> 
> Not only for short-lived children. The problem is restart will succeed
> or fail depending on the order in which tasks were checkpointed. If
> task with pid 290 is restarted after pid 305, restart will fail.
> 
> And because chekcpoint scans the task tree in a DFS manner, this is
> more likely to happen than not.
> 
> I wonder why you'd like to restrict a pid-specific clone like that ?
> It is already a privileged syscall, so it could be exempt. I suggest
> that only regular clones will be constrained.

I stand corrected by Suka: a pid-specific clone does not change
last_pid. Therefore, given that 'restart' only creates tasks with
pid-specific clone, this should be safe for c/r.

Oren.
