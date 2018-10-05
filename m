From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [REVIEW][PATCH 2/6] signal: Fail sigqueueinfo if si_signo != sig
Date: Fri, 05 Oct 2018 08:50:51 +0200
Message-ID: <878t3cc2es.fsf@xmission.com>
References: <87h8idv6nw.fsf@xmission.com>
        <20180925171906.19683-2-ebiederm@xmission.com>
        <20181005060611.GA19061@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005060611.GA19061@gmail.com> (Andrei Vagin's message of
        "Thu, 4 Oct 2018 23:06:13 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Andrei Vagin <avagin@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

Andrei Vagin <avagin@gmail.com> writes:

> On Tue, Sep 25, 2018 at 07:19:02PM +0200, Eric W. Biederman wrote:
>> The kernel needs to validate that the contents of struct siginfo make
>> sense as siginfo is copied into the kernel, so that the proper union
>> members can be put in the appropriate locations.  The field si_signo
>> is a fundamental part of that validation.  As such changing the
>> contents of si_signo after the validation make no sense and can result
>> in nonsense values in the kernel.
>
> Accoding to the man page, the user should not set si_signo, it has to be set
> by kernel.

I wanted to say look at copy_siginfo_from_user32 it uses si_signo and it
has always done so.  But before I got to fixing copy_siginfo_from_user32
only looked at si_code.  This is one of the areas where we deliberately
slightly changed the KABI.  To start looking an signo instead of magic
kernel internal si_code values.

So yes.  Looking at si_signo instead of the passed in signo appears to
be a regression all of the way around (except for ptrace) where that
value is not present.  So I will see if I can figure out how to refactor
the code to accomplish that.

I am travelling for the next couple of days so I won't be able to get to
this for a bit.

I am thinking I will need two version of copy_siginfo_from user now.
One for ptrace and one for rt_sgiqueueinfo.  Sigh.

> $ man 2 rt_sigqueueinfo
>
>     The uinfo argument specifies the data to accompany  the  signal.   This
>        argument  is  a  pointer to a structure of type siginfo_t, described in
>        sigaction(2) (and defined  by  including  <sigaction.h>).   The  caller
>        should set the following fields in this structure:
>
>        si_code
>               This  must  be  one of the SI_* codes in the Linux kernel source
>               file include/asm-generic/siginfo.h, with  the  restriction  that
>               the  code  must  be  negative (i.e., cannot be SI_USER, which is
>               used by the kernel to indicate a signal  sent  by  kill(2))  and
>               cannot  (since  Linux  2.6.39) be SI_TKILL (which is used by the
>               kernel to indicate a signal sent using tgkill(2)).
>
>        si_pid This should be set to a process ID, typically the process ID  of
>               the sender.
>
>        si_uid This  should  be set to a user ID, typically the real user ID of
>               the sender.
>
>        si_value
>               This field contains the user data to accompany the signal.   For
>               more information, see the description of the last (union sigval)
>               argument of sigqueue(3).
>
>        Internally, the kernel sets the si_signo field to the  value  specified
>        in  sig,  so that the receiver of the signal can also obtain the signal
>        number via that field.
>
>> 
>> As such simply fail if someone is silly enough to set si_signo out of
>> sync with the signal number passed to sigqueueinfo.
>> 
>> I don't expect a problem as glibc's sigqueue implementation sets
>> "si_signo = sig" and CRIU just returns to the kernel what the kernel
>> gave to it.
>> 
>> If there is some application that calls sigqueueinfo directly that has
>> a problem with this added sanity check we can revisit this when we see
>> what kind of crazy that application is doing.
>
>
> I already know two "applications" ;)
>
> https://github.com/torvalds/linux/blob/master/tools/testing/selftests/ptrace/peeksiginfo.c
> https://github.com/checkpoint-restore/criu/blob/master/test/zdtm/static/sigpending.c
>
> Disclaimer: I'm the author of both of them.
>
>> 
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>>  kernel/signal.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>> 
>> diff --git a/kernel/signal.c b/kernel/signal.c
>> index 7b49c31d3fdb..e445b0a63faa 100644
>> --- a/kernel/signal.c
>> +++ b/kernel/signal.c
>> @@ -3306,7 +3306,8 @@ static int do_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t *info)
>>  	    (task_pid_vnr(current) != pid))
>>  		return -EPERM;
>>  
>> -	info->si_signo = sig;
>> +	if (info->si_signo != sig)
>> +		return -EINVAL;
>>  
>>  	/* POSIX.1b doesn't mention process groups.  */
>>  	return kill_proc_info(sig, info, pid);
>> @@ -3354,7 +3355,8 @@ static int do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig, siginfo_t *info)
>>  	    (task_pid_vnr(current) != pid))
>>  		return -EPERM;
>>  
>> -	info->si_signo = sig;
>> +	if (info->si_signo != sig)
>> +		return -EINVAL;
>>  
>>  	return do_send_specific(tgid, pid, sig, info);
>>  }
