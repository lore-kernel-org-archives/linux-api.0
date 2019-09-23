From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: For review: pidfd_send_signal(2) manual page
Date: Mon, 23 Sep 2019 22:27:47 +0200
Message-ID: <ca28a4d7-0c0e-2dee-b875-dc28b5dd0f0c@gmail.com>
References: <f21dbd73-5ef4-fb5b-003f-ff4fec34a1de@gmail.com>
 <20190923142932.2gujbddnzyp4ujeu@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190923142932.2gujbddnzyp4ujeu@wittgenstein>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: mtk.manpages@gmail.com, Oleg Nesterov <oleg@redhat.com>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Daniel Colascione <dancol@google.com>, Joel Fernandes <joel@joelfernandes.org>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hello Christian,

On 9/23/19 4:29 PM, Christian Brauner wrote:
> On Mon, Sep 23, 2019 at 11:12:00AM +0200, Michael Kerrisk (man-pages) wrote:
>> Hello Christian and all,
>>
>> Below, I have the rendered version of the current draft of
>> the pidfd_send_signal(2) manual page that I have written.
>> The page source can be found in a Git branch at:
>> https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/log/?h=draft_pidfd
>>
>> I would be pleased to receive corrections and notes on any
>> details that should be added. (For example, are there error
>> cases that I have missed?)
>>
>> Would you be able to review please?
> 
> Michael,
> 
> A big big thank you for doing this! Really appreciated.
> I'm happy to review this!
> 
>>
>> Thanks,
>>
>> Michael
>>
>>
>> NAME
>>        pidfd_send_signal - send a signal to a process specified by a file
>>        descriptor
>>
>> SYNOPSIS
>>        int pidfd_send_signal(int pidfd, int sig, siginfo_t info,
>>                              unsigned int flags);
>>
>> DESCRIPTION
>>        The pidfd_send_signal() system call sends the signal  sig  to  the
>>        target  process  referred  to by pidfd, a PID file descriptor that
>>        refers to a process.
>>
>>        If the info argument points to a  siginfo_t  buffer,  that  buffer
>>        should be populated as described in rt_sigqueueinfo(2).
>>
>>        If  the  info  argument  is  a NULL pointer, this is equivalent to
>>        specifying a pointer to a siginfo_t buffer whose fields match  the
>>        values  that  are  implicitly supplied when a signal is sent using
>>        kill(2):
>>
>>        *  si_signo is set to the signal number;
>>        *  si_errno is set to 0;
>>        *  si_code is set to SI_USER;
>>        *  si_pid is set to the caller's PID; and
>>        *  si_uid is set to the caller's real user ID.
>>
>>        The calling process must either be in the same  PID  namespace  as
>>        the  process  referred  to  by pidfd, or be in an ancestor of that
>>        namespace.
>>
>>        The flags argument is reserved for  future  use;  currently,  this
>>        argument must be specified as 0.
>>
>> RETURN VALUE
>>        On  success,  pidfd_send_signal()  returns  0.   On success, -1 is
> 
> This should probably be "On error, -1 is [...]".

Thanks. Fixed.


Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
