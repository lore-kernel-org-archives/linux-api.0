From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 0/2] Add further ioctl() operations for namespace
 discovery
Date: Thu, 22 Dec 2016 08:20:33 +0100
Message-ID: <142285b7-225b-fd15-3c8e-9ae2d02e82b5@gmail.com>
References: <0e229ec4-e3fc-dd46-c5b9-3afa0f14bfcd@gmail.com>
 <87bmw7pm31.fsf@xmission.com>
 <65dd9028-8aa8-123e-ddff-807c44079a50@gmail.com>
 <878trae4g6.fsf@xmission.com>
 <fa9eec50-b634-51e9-fa37-4911010a1496@gmail.com>
 <8737hi5e67.fsf@xmission.com>
 <24b5d73e-0071-6be4-fa5b-391eb8aa0f78@gmail.com>
 <87a8boq03m.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87a8boq03m.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: mtk.manpages@gmail.com, "Serge E. Hallyn" <serge@hallyn.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, "W. Trevor King" <wking@tremily.us>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Andrei Vagin <avagin@virtuozzo.com>
List-Id: linux-api@vger.kernel.org

Hi Eric,

On 12/22/2016 01:27 AM, Eric W. Biederman wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
> 
>> Hi Eric,
>>
>> On 12/21/2016 01:17 AM, Eric W. Biederman wrote:
>>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>>
>>>> Hi Eric,
>>>>
>>>> On 12/20/2016 09:22 PM, Eric W. Biederman wrote:
>>>>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>>>>
>>>>>> Hello Eric,
>>>>>>
>>>>>> On 12/19/2016 11:53 PM, Eric W. Biederman wrote:
>>>>>>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>>>>>>
> 
>>> Now the question becomes who are the users of this?  Because it just
>>> occurred to me that we now have an interesting complication.  Userspace
>>> extending the meaning of the capability bits, and using to protect
>>> additional things.  Ugh.  That could be a maintenance problem of another
>>> flavor.  Definitely not my favorite.
>>
>> I don't follow you here. Could you say some more about what you mean?
> 
> I have seen user space userspace do thing such as extend CAP_SYS_REBOOT
> to things such as permission to invoke "shutdown -r now".  Which
> depending on what a clean reboot entails could be greately increasing
> the scope of CAP_SYS_REBOOT.
> 
> I am concerned for that and similar situations that userspace
> applications could lead us into situation that one wrong decision could
> wind up being an unfixable mistake because fixing the mistake would
> break userspsace.

Okay.

>>> So why are we asking the questions about what permissions a process has?
>>
>> My main interest here is monitoring/discovery/debugging on a running
>> system. NS_GET_PARENT, NS_GET_USERNS, NS_GET_CREATOR_UID, and 
>> NS_GET_NSTYPE provide most of what I'd like to see. Being able to ask
>> "does this process have permissions in that namespace?" would be nice 
>> to have in terms of understanding/debugging a system.
> 
> If we are just looking at explanations then I seem to have been
> over-engineering things.  So let's just aim at the two ioctls.
> Or at least the information in those ioctls.

Okay.

> With at least a comment on the ioctl returning the OWNER_UID that
> describes why it is not a problem to if the owners uid is something like
> ((uid_t)-3).  Which overlaps with the space for error return codes.
>
> I don't know if we are fine or not, but that review comment definitely
> deserves some consideration.


See my reply just sent to Andrei. We should instead then just return 
the UID via a buffer pointed to by the ioctl() argument:

ioctl(fd, NS_GET_OWNER_UID, &uid);

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
