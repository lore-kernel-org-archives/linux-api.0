From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Documenting ptrace access mode checking
Date: Fri, 24 Jun 2016 10:18:21 +0200
Message-ID: <8dc0a0ec-c46d-778f-137f-b06dae9b2a39@gmail.com>
References: <e335a243-2199-2185-c7b3-fb1c898e9ab4@gmail.com>
 <87ziqewc3r.fsf@x220.int.ebiederm.org> <20160622215142.GA14751@redhat.com>
 <f8069f83-f7b6-ee2c-5167-fa0d50732180@gmail.com>
 <871t3nka3c.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <871t3nka3c.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 06/23/2016 08:56 PM, Eric W. Biederman wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>
>> Hi Oleg,
>>
>> On 06/22/2016 11:51 PM, Oleg Nesterov wrote:
>>> On 06/21, Eric W. Biederman wrote:
>>>>
>>>> Adding Oleg just because he seems to do most of the ptrace related
>>>> maintenance these days.
>>>
>>> so I have to admit that I never even tried to actually understand
>>> ptrace_may_access ;)
>>>
>>>> We certainly need something that gives a high level view so people
>>>> reading the man page can know what to expect.   If you get down into the
>>>> weeds we run the danger of people beginning to think they can depend
>>>> upon bugs in the implementation.
>>>
>>> Personally I agree. I think "man ptrace" shouldn't not tell too much
>>> about kernel internals.
>>
>> See my other replies on this topic. Somehow, we need a way of
>> describing the behavior that user-space sees. I think it's
>> inevitable that that means talking about what;s going on
>> "under the hood".
>>
>> Regarding Eric's point that "we run the danger of people beginning
>> to think they can depend upon bugs in the implementation": when it
>> comes to breaking the ABI, the presence or absence of documentation
>> doesn't save us on that point (Linus has a few times made his position
>> wrt to documentation clear).
>
> Which are interesting in this respect as a bug in the implementation
> that is a security issue can and will be changed, even if userspace
> breaks.  Breaking userspace is not desirable but when there is no other
> reasonable choice it will happen.

Yes, good point.

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
