From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 0/2] Add further ioctl() operations for namespace discovery
Date: Wed, 21 Dec 2016 13:17:04 +1300
Message-ID: <8737hi5e67.fsf@xmission.com>
References: <0e229ec4-e3fc-dd46-c5b9-3afa0f14bfcd@gmail.com>
        <87bmw7pm31.fsf@xmission.com>
        <65dd9028-8aa8-123e-ddff-807c44079a50@gmail.com>
        <878trae4g6.fsf@xmission.com>
        <fa9eec50-b634-51e9-fa37-4911010a1496@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <fa9eec50-b634-51e9-fa37-4911010a1496@gmail.com> (Michael
        Kerrisk's message of "Tue, 20 Dec 2016 21:55:43 +0100")
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, "W. Trevor King" <wking@tremily.us>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

> Hi Eric,
>
> On 12/20/2016 09:22 PM, Eric W. Biederman wrote:
>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>> 
>>> Hello Eric,
>>>
>>> On 12/19/2016 11:53 PM, Eric W. Biederman wrote:
>>>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>>>
>>>>> Eric,
>>>>>
>>>>> The code proposed in this patch series is pretty small. Is there any
>>>>> chance we could make the 4.10 merge window, if the changes seem
>>>>> acceptable to you?
>>>>
>>>> I see why you are asking but I am not comfortable with aiming for
>>>> the merge window that is on-going and could close at any moment.
>>>> I have seen recenly too many patches that should work fine have
>>>> some odd minor issue.  Like an extra _ in a label used in an ifdef
>>>> that resulted in memory stomps.    Linus might be more brave but i would
>>>> rather wait until the next merge window, so I don't need to worry about
>>>> spoiling anyone's holidays with a typo someone over looked.
>>>
>>> I'll just gently ask if you'll reconsider and take another look at the
>>> patches. They patches are very small, and don't change any existing
>>> behavior. And if we see a problem in the next weeks they could be pulled.
>>> In the meantime, I'd be aiming to publicize this API somewhat, so that we
>>> might get some eyeballs to spot design bugs. But, I do understand your
>>> position, if the answer is still "not for this merge window".
>> 
>> My position is still not this merge window.  I am more than happy to
>> queue up the changes for the next one.  Even on the best of days there
>> is a reasonable chance Linus would not be happy to receive code
>> development done in the merge window.
>
> Okay. So, I can at least think about this at leisure! (Actually, 
> I think I really do mean: thanks for saying "no" again.)
>
>> I think there is also just a little bit of discussion that needs
>> to happen with these new userspace APIs (below).  And I have seen way
>> too many times user space APIs added too quickly and having to be
>> repaired afterwards.
>
> Yes, I certainly understand that.
>
>>>> At first glance these patches seem reasonable. I don't see any problem
>>>> with the ioctls you have added.
>>>>
>>>> That said I have a question.  Should we provide a more direct way to
>>>> find the answer to your question?  Something like the access system
>>>> call?
>>>>
>>>> I think a more direct answer would be more maintainable in the long run
>>>> as it does not bind tools to specific implementation details in the
>>>> future.  Which could allow us to account for LSM policies and the like.
>>>
>>> My thoughts:
>>>
>>> 1. Regarding NS_GET_NSTYPE...  It always struck me as a little odd
>>>    that you could ask setns() to check if the supplied FD referred
>>>    to a certain type of NS (and thus, in a round about way, setns()
>>>    gives us the same information as NS_GET_NSTYPE), but you can't
>>>    directly ask what the NS type is. The fact that setns() has this
>>>    facility suggests that there could be other uses for the operation
>>>    "tell me what type of NS this FD refers to".
>> 
>> Yes.  I have no problem with that one.
>> 
>>> 2. Regarding NS_GET_CREATOR_UID... There are defined rules about what
>>>    this UID means with respect to capabilities in a namespace. It's
>>>    not an implementation detail, as I understand it. Also in terms of
>>>    introspecting to try to understand the structure of namespaces on
>>>    a running system, knowing this UID is useful in and of itself.
>> 
>> I am not quite sold on the name NS_GET_CREATOR_UID.  NS_GET_OWNER_UID
>> seems to match the code better.  The owner is the creator but
>> the important part seems to be the ownership not the act of creation.
>
> I actually thought about NS_GET_OWNER, but shied away from it
> because it had echoes of "get owning userns". NS_GET_OWNER_UID
> is better than NS_GET_OWNER, and certainly not worse than
> NS_GET_CREATOR_UID.
>
>>> 3. NS_GET_NSTYPE and NS_GET_CREATOR_UID solve my problem, but
>>>    obviously your idea would make life simpler for user space.
>>>    Am I correct to understand that you mean an API that takes
>>>    three pieces of info: a PID, a capability, and an fd referring
>>>    to a /proc/PID/ns/xxx, and tells us whether PID has the specified
>>>    capability for operations in the specified namespace?
>> 
>> Something like that.  But yes something we can wire up to
>> ns_capable_noaudit and be told the result.  
>
> Yes, that was my line of thinking also. It seems to me that to
> prevent information leaks, we also should check that the caller
> has some suitable capability in the target namespace, right?
> (I presume a ptrace_may_access() check.)

Well over the target process but yes.

>> That will let the
>> LSMs and any future kerel changes have their say, without any extra
>> maintenance burden in the kernel.
>
> Yes.
>
>> What I really don't want is for userspace to start depending on the
>> current formula being the only factors that say if it has a capabliltiy
>> in a certain situation because in practice that just isn't true.
>> Permission checks just keep evoloving in the kernel.
>
> This was the bit I hadn't really considered when I first started down 
> this path, but I started to see the light a bit already today, but
> didn't have it so crisply in my mind as you just said it there.
>
> So, we have two ioctls already in 4.9, I proposed two more. And 
> then we have this fifth operation. Should we have an nsctl(2)?

I would rather move the other direction and have a system call.

> In the meantime, here's something I hacked together. I know it
> needs work, but I just want to check whether it's the direction
> that you were meaning in terms of the checks. It's done as an
> ioctl() (structure hard coded in place while I play about, and
> some names and types should certainly be better). Leaving aside 
> the messy bits, is the below roughly the kind of checking you 
> expect to be embodied in this operation?

Yes.  It probably nees u32 instead of long, or eles we need to have
a compat version for 32bit OS's.

Now the question becomes who are the users of this?  Because it just
occurred to me that we now have an interesting complication.  Userspace
extending the meaning of the capability bits, and using to protect
additional things.  Ugh.  That could be a maintenance problem of another
flavor.  Definitely not my favorite.

The access system is limited to asking about yourself, and to
asking very specific questions.  If our new operation did something
similar and only allowed asking about yourself, and a capablity I would
find it less scary, and I am wondering if it would be possible to ask
not about a capability but an operation that the capability guards
such as chroot.

Implementing target operations instead of target capabilities would be a
bit trickier to implement (as it requires factoring out the permission
checks) but it may be much more useful in the long run.

So why are we asking the questions about what permissions a process has?

Eric
