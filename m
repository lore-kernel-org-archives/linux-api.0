From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v3] selftests/seccomp: build and pass on arm64
Date: Thu, 15 Oct 2015 17:01:32 -0600
Message-ID: <5620304C.3070701@osg.samsung.com>
References: <20151006193025.GA11826@www.outflux.net>
 <561FB33F.5030906@osg.samsung.com>
 <CAGXu5jKXeu-kBie+wJODoAjoK1kX+ScFRSn0s3s_wvN+sHT1yw@mail.gmail.com>
 <56200761.8050607@osg.samsung.com>
 <CAGXu5jJMpSTBFqS3Xj0ftMYVwJuUU8MUbggrWW8wN5CGDBsLvA@mail.gmail.com>
 <56203023.2060007@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56203023.2060007-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/15/2015 05:00 PM, Shuah Khan wrote:
> On 10/15/2015 04:07 PM, Kees Cook wrote:
>> On Thu, Oct 15, 2015 at 1:06 PM, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:
>>> On 10/15/2015 12:42 PM, Kees Cook wrote:
>>>> On Thu, Oct 15, 2015 at 7:07 AM, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:
>>>>> On 10/06/2015 01:30 PM, Kees Cook wrote:
>>>>>> Changing arm64 syscalls is done via a specific register set, more like s390
>>>>>> than like arm (specific ptrace call) and x86 (part of general registers).
>>>>>> Since (restarting) poll doesn't exist on arm64, switch to using nanosleep
>>>>>> for testing restart_syscall. And since it looks like the syscall ABI is
>>>>>> inconsistent on arm-compat, so we must work around it (and document it) in
>>>>>> the test.
>>>>>>
>>>>>> Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>>>>>> ---
>>>>>> v3:
>>>>>>  - correctly set syscall number on native arm64.
>>>>>> v2:
>>>>>>  - switch to nanosleep from a bad mix of poll and ppoll for testing restart.
>>>>>> ---
>>>>>
>>>>> Is this good to go? Failed to apply to linux-kselftest next.
>>>>> If you can rebase and resend. I can get this into 4.4-rc1
>>>>
>>>> Yes please. :)
>>>>
>>>
>>> ok. Please rebase to linux-kselftest next and resend the patch.
>>
>> Am I looking at the right tree? linux-kselftest#next doesn't appear to
>> have the s390 patch that was included in 4.3.
>>
> 
> I see what happened. Your patch is linux-next fixes and that went into
> 4.3-rc2. I can get linux-next rebase to 4.3-rc2 and get your patch in.
> Thanks for clearing this up.

oops rebase linux-kselftest next i.e

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
