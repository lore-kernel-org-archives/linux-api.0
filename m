From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Wed, 21 Jan 2015 09:57:55 +0100
Message-ID: <54BF6A13.2090008@gmail.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org> <54BE5F1F.8070703@gmail.com> <54BE957A.60305@zonque.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54BE957A.60305-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel-cYrQPVfZooxQFI55V6+gNQ@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Daniel,

On 01/20/2015 06:50 PM, Daniel Mack wrote:
> Hi Michael,
> 
> Thanks a lot for for intense review of the documentation. Much appreciated.
> 
> I've addressed all but the below issues, following your suggestions.

Are your changes already visible somewhere?

> On 01/20/2015 02:58 PM, Michael Kerrisk (man-pages) wrote:
>>> +    and KDBUS_CMD_ENDPOINT_MAKE (see above).
>>> +
>>> +    Following items are expected for KDBUS_CMD_BUS_MAKE:
>>> +    KDBUS_ITEM_MAKE_NAME
>>> +      Contains a string to identify the bus name.
>>
>> So, up to here, I've seen no definition of 'kdbus_item', which leaves me 
>> asking questions like: what subfield is KDBUS_ITEM_MAKE_NAME stored in?
>> which subfield holds the pointer to the string?
>>
>> Somewhere earlier,  kdbus_item needs to be exaplained in more detail, 
>> I think.
> 
> Hmm, you're quoting text from section 5, and section 4 actually
> describes the concept of items quite well I believe?

Well, Section 4 is pretty short. My point is that most of the various 
blob formats (e.g., kdbus_pids, kdbus_caps, kdbus_memfd) are not
documented in kdbus.txt. They all should be, IMO.

>>> +  __s64 priority;
>>> +    With KDBUS_RECV_USE_PRIORITY set in flags, receive the next message in
>>> +    the queue with at least the given priority. If no such message is waiting
>>> +    in the queue, -ENOMSG is returned.
>>
>> ###
>> How do I simply select the highest priority message, without knowing what 
>> its priority is?
> 
> The wording is indeed unclear here. KDBUS_RECV_USE_PRIORITY causes the
> messages to be dequeued by their priority. The 'priority' field is
> simply a filter that request a minimum priority. By setting this field
> to the highest possible value, you effectively bypass the filter. I've
> added a better description now.

Thanks for the clarification.

>>> +  -ENOMEM	The kernel memory is exhausted
>>> +  -ENOTTY	Illegal ioctl command issued for the file descriptor
>>
>> Why ENOTTY here, rather than EINVAL? The latter is, I beleive, the usual 
>> ioctl() error for invalid commands, I believe (If you keep ENOTTY, add an
>> explanation in this document.)
> 
> Hmm, no. -ENOTTY is commonly used as return code when calling ioctls
> that can't be handled by the FDs they're called on. 'man errno(3)' even
> states: "ENOTTY   Inappropriate I/O control operation (POSIX.1)".

Okay.

>>> +  -EINVAL	Unsupported item attached to command
>>> +
>>> +For all ioctls that carry a struct as payload:
>>> +
>>> +  -EFAULT	The supplied data pointer was not 64-bit aligned, or was
>>> +		inaccessible from the kernel side.
>>> +  -EINVAL	The size inside the supplied struct was smaller than expected
>>> +  -EMSGSIZE	The size inside the supplied struct was bigger than expected
>>
>> Why two different errors for smaller and larger than expected? (If you keep things this
>> way, pelase explain the reason in this document.)
> 
> Providing a struct that is smaller than the minimum doesn't give the
> ioctl a valid set of information to process the request. Hence, I think
> -EINVAL is appropriate. However, -EMSGSIZE is something that users might
> hit when they make message payloads too big, and I think it's good to
> have a change to distinguish the two cases in error handling. I added
> something in the document now.

Thanks.

> Again, thanks a lot for reading the documentation so accurately!

You're welcome.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
