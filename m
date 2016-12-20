From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] Add further ioctl() operations for namespace
 discovery
Date: Tue, 20 Dec 2016 16:35:28 +0100
Message-ID: <65dd9028-8aa8-123e-ddff-807c44079a50@gmail.com>
References: <0e229ec4-e3fc-dd46-c5b9-3afa0f14bfcd@gmail.com>
 <87bmw7pm31.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87bmw7pm31.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Eric,

On 12/19/2016 11:53 PM, Eric W. Biederman wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
> 
>> Eric,
>>
>> The code proposed in this patch series is pretty small. Is there any
>> chance we could make the 4.10 merge window, if the changes seem
>> acceptable to you?
> 
> I see why you are asking but I am not comfortable with aiming for
> the merge window that is on-going and could close at any moment.
> I have seen recenly too many patches that should work fine have
> some odd minor issue.  Like an extra _ in a label used in an ifdef
> that resulted in memory stomps.    Linus might be more brave but i would
> rather wait until the next merge window, so I don't need to worry about
> spoiling anyone's holidays with a typo someone over looked.

I'll just gently ask if you'll reconsider and take another look at the
patches. They patches are very small, and don't change any existing
behavior. And if we see a problem in the next weeks they could be pulled.
In the meantime, I'd be aiming to publicize this API somewhat, so that we
might get some eyeballs to spot design bugs. But, I do understand your
position, if the answer is still "not for this merge window".

> At first glance these patches seem reasonable. I don't see any problem
> with the ioctls you have added.
> 
> That said I have a question.  Should we provide a more direct way to
> find the answer to your question?  Something like the access system
> call?
> 
> I think a more direct answer would be more maintainable in the long run
> as it does not bind tools to specific implementation details in the
> future.  Which could allow us to account for LSM policies and the like.

My thoughts:

1. Regarding NS_GET_NSTYPE...  It always struck me as a little odd
   that you could ask setns() to check if the supplied FD referred
   to a certain type of NS (and thus, in a round about way, setns()
   gives us the same information as NS_GET_NSTYPE), but you can't
   directly ask what the NS type is. The fact that setns() has this
   facility suggests that there could be other uses for the operation
   "tell me what type of NS this FD refers to". 

2. Regarding NS_GET_CREATOR_UID... There are defined rules about what
   this UID means with respect to capabilities in a namespace. It's
   not an implementation detail, as I understand it. Also in terms of
   introspecting to try to understand the structure of namespaces on
   a running system, knowing this UID is useful in and of itself.

3. NS_GET_NSTYPE and NS_GET_CREATOR_UID solve my problem, but
   obviously your idea would make life simpler for user space.
   Am I correct to understand that you mean an API that takes
   three pieces of info: a PID, a capability, and an fd referring
   to a /proc/PID/ns/xxx, and tells us whether PID has the specified
   capability for operations in the specified namespace?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
