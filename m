From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: For review: pidfd_send_signal(2) manual page
Date: Tue, 24 Sep 2019 21:10:54 +0200
Message-ID: <d6f72bcc-613b-45c5-98f5-67f904ace644@gmail.com>
References: <f21dbd73-5ef4-fb5b-003f-ff4fec34a1de@gmail.com>
 <87ftkmu2i6.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87ftkmu2i6.fsf@x220.int.ebiederm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: mtk.manpages@gmail.com, Oleg Nesterov <oleg@redhat.com>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Daniel Colascione <dancol@google.com>, Joel Fernandes <joel@joelfernandes.org>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 9/23/19 11:27 PM, Eric W. Biederman wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
> 
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
> 
>  This needs to be "siginfo_t *info," -----------------------^

Thanks, Eric. Fixed.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
