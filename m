From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 0/2] Add further ioctl() operations for namespace
 discovery
Date: Wed, 21 Dec 2016 10:53:00 +0100
Message-ID: <24b5d73e-0071-6be4-fa5b-391eb8aa0f78@gmail.com>
References: <0e229ec4-e3fc-dd46-c5b9-3afa0f14bfcd@gmail.com>
 <87bmw7pm31.fsf@xmission.com>
 <65dd9028-8aa8-123e-ddff-807c44079a50@gmail.com>
 <878trae4g6.fsf@xmission.com>
 <fa9eec50-b634-51e9-fa37-4911010a1496@gmail.com>
 <8737hi5e67.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <8737hi5e67.fsf@xmission.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: mtk.manpages@gmail.com, "Serge E. Hallyn" <serge@hallyn.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, "W. Trevor King" <wking@tremily.us>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

Hi Eric,

On 12/21/2016 01:17 AM, Eric W. Biederman wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
> 
>> Hi Eric,
>>
>> On 12/20/2016 09:22 PM, Eric W. Biederman wrote:
>>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>>
>>>> Hello Eric,
>>>>
>>>> On 12/19/2016 11:53 PM, Eric W. Biederman wrote:
>>>>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>>>>
>>>>>> Eric,

[...]

>>>> 3. NS_GET_NSTYPE and NS_GET_CREATOR_UID solve my problem, but
>>>>    obviously your idea would make life simpler for user space.
>>>>    Am I correct to understand that you mean an API that takes
>>>>    three pieces of info: a PID, a capability, and an fd referring
>>>>    to a /proc/PID/ns/xxx, and tells us whether PID has the specified
>>>>    capability for operations in the specified namespace?
>>>
>>> Something like that.  But yes something we can wire up to
>>> ns_capable_noaudit and be told the result.  
>>
>> Yes, that was my line of thinking also. It seems to me that to
>> prevent information leaks, we also should check that the caller
>> has some suitable capability in the target namespace, right?
>> (I presume a ptrace_may_access() check.)
> 
> Well over the target process but yes.
> 
>>> That will let the
>>> LSMs and any future kerel changes have their say, without any extra
>>> maintenance burden in the kernel.
>>
>> Yes.
>>
>>> What I really don't want is for userspace to start depending on the
>>> current formula being the only factors that say if it has a capabliltiy
>>> in a certain situation because in practice that just isn't true.
>>> Permission checks just keep evoloving in the kernel.
>>
>> This was the bit I hadn't really considered when I first started down 
>> this path, but I started to see the light a bit already today, but
>> didn't have it so crisply in my mind as you just said it there.
>>
>> So, we have two ioctls already in 4.9, I proposed two more. And 
>> then we have this fifth operation. Should we have an nsctl(2)?
> 
> I would rather move the other direction and have a system call.

Okay -- I'll give that a some thought.

>> In the meantime, here's something I hacked together. I know it
>> needs work, but I just want to check whether it's the direction
>> that you were meaning in terms of the checks. It's done as an
>> ioctl() (structure hard coded in place while I play about, and
>> some names and types should certainly be better). Leaving aside 
>> the messy bits, is the below roughly the kind of checking you 
>> expect to be embodied in this operation?
> 
> Yes.  It probably nees u32 instead of long, or eles we need to have
> a compat version for 32bit OS's.

Yes.

> Now the question becomes who are the users of this?  Because it just
> occurred to me that we now have an interesting complication.  Userspace
> extending the meaning of the capability bits, and using to protect
> additional things.  Ugh.  That could be a maintenance problem of another
> flavor.  Definitely not my favorite.

I don't follow you here. Could you say some more about what you mean?

> The access system is limited to asking about yourself, and to
> asking very specific questions.  If our new operation did something
> similar and only allowed asking about yourself, and a capablity I would
> find it less scary, 

Okay. But that's a less interesting operation from my point of view.
I mean: one way of knowing if we have permission to do an operation
is to try to do it.

> and I am wondering if it would be possible to ask
> not about a capability but an operation that the capability guards
> such as chroot.
> 
> Implementing target operations instead of target capabilities would be a
> bit trickier to implement (as it requires factoring out the permission
> checks) but it may be much more useful in the long run.

But, would this not mean factoring out the permission checks on a per 
operation basis? (There are of courses hundreds of such checks.)

> So why are we asking the questions about what permissions a process has?

My main interest here is monitoring/discovery/debugging on a running
system. NS_GET_PARENT, NS_GET_USERNS, NS_GET_CREATOR_UID, and 
NS_GET_NSTYPE provide most of what I'd like to see. Being able to ask
"does this process have permissions in that namespace?" would be nice 
to have in terms of understanding/debugging a system.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
