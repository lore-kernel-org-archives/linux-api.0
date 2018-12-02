From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Sat, 01 Dec 2018 18:06:49 -0600
Message-ID: <87lg58pzae.fsf@xmission.com>
References: <20181120105124.14733-1-christian@brauner.io>
        <87in0g5aqo.fsf@oldenburg.str.redhat.com>
        <36323361-90BD-41AF-AB5B-EE0D7BA02C21@amacapital.net>
        <993B98AC-51DF-4131-AF7F-7DA2A7F485F1@brauner.io>
        <CALCETrWnQNMQcCmFZrftVVYgAMW6DT3gyxvVb_v9_enUCUkHiw@mail.gmail.com>
        <20181129195551.woe2bl3z3yaysqb6@brauner.io>
        <6E21165F-2C76-4877-ABD9-0C86D55FD6AA@amacapital.net>
        <CAK8P3a2i9DFaS9-3A9V_pKwFfwVR0bDqgLosmivge3Cx2VyiuQ@mail.gmail.com>
        <87y39b2lm2.fsf@xmission.com>
        <20181130065606.kmilbbq46oeycjp5@brauner.io>
        <CAK8P3a0kqPii5TwFAo_JHLX=o_FDMFVKXxgzzbDjLFZ7OQ5QCQ@mail.gmail.com>
        <87y399s3sc.fsf@xmission.com> <87tvjxp8pc.fsf@xmission.com>
        <F53D6D38-3521-4C20-9034-5AF447DF62FF@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <F53D6D38-3521-4C20-9034-5AF447DF62FF@amacapital.net> (Andy
        Lutomirski's message of "Sat, 1 Dec 2018 07:52:37 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Arnd Bergmann <arnd@arndb.de>, christian@brauner.io, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, cyphar@cyphar.com, Al Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Daniel Colascione <dancol@google.com>, Tim Murray <timmurray@google.com>, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

>> On Dec 1, 2018, at 7:28 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> 
>> 
>> It just occurs to me that the simple way to implement
>> procfd_sigqueueinfo info is like:
>> 
>> int copy_siginfo_from_user_any(kernel_siginfo_t *info, siginfo_t *uinfo)
>> {
>> #ifdef CONFIG_COMPAT
>>    if (in_compat_syscall)
>>        return copy_siginfo_from_user32(info, uinfo);
>> #endif
>>    return copy_siginfo_from_user(info, uinfo);                        
>> }
>> 
>> long procfd_sigqueueinfo(int fd, siginfo_t *uinfo)
>> {
>>    kernel_siginfo info;
>> 
>>        if (copy_siginfo_from_user_any(&info, uinfo))
>>            return -EFAULT;
>>    ...;                
>> }
>> 
>> It looks like there is already a place in ptrace.c that already
>> hand rolls copy_siginfo_from_user_any.
>> 
>> So while I would love to figure out the subset of siginfo_t tha we can
>> just pass through, as I think that would make a better more forward
>> compatible copy_siginfo_from_user32.
>
> Seems reasonable to me. It’s less code overall than any other suggestion, too.
>
>>  I think for this use case we just
>> add the in_compat_syscall test and then we just need to ensure this new
>> system call is placed in the proper places in the syscall table.
>> 
>> Because we will need 3 call sights: x86_64, x32 and ia32.  As the layout
>> changes between those three subarchitecuters.
>> 
>> 
>
> If it’s done this way, it can just be “common” in the 64-bit
> table. And we kick the can a bit farther down the road :)
>
> I’m working on patches to clean up x86’s syscall mess. It’s slow
> because I keep finding new messes.  So far I have rt_sigreturn working
> like every other syscall — whee.
>
> Also, Eric, for your edification, I have a draft patch set to
> radically simplify x86’s signal delivery and return.  Once that’s
> done, I can trivially speed up delivery by a ton by using sysret.

Nice.

Do we care about the performance of synchronous signal delivery (AKA
hardware exceptions) vs ordinary signal delivery.  I get the feeling
there are serious simplifications to be had in that case.

Eric
