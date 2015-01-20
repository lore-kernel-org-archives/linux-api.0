From: Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Tue, 20 Jan 2015 18:50:50 +0100
Message-ID: <54BE957A.60305@zonque.org>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org> <54BE5F1F.8070703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54BE5F1F.8070703@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no, jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: daniel@zonque.or, dh.herrmann@gmail.com, tixxdz@opendz.org
List-Id: linux-api@vger.kernel.org

Hi Michael,

Thanks a lot for for intense review of the documentation. Much appreciated.

I've addressed all but the below issues, following your suggestions.


On 01/20/2015 02:58 PM, Michael Kerrisk (man-pages) wrote:
>> +    and KDBUS_CMD_ENDPOINT_MAKE (see above).
>> +
>> +    Following items are expected for KDBUS_CMD_BUS_MAKE:
>> +    KDBUS_ITEM_MAKE_NAME
>> +      Contains a string to identify the bus name.
> 
> So, up to here, I've seen no definition of 'kdbus_item', which leaves me 
> asking questions like: what subfield is KDBUS_ITEM_MAKE_NAME stored in?
> which subfield holds the pointer to the string?
> 
> Somewhere earlier,  kdbus_item needs to be exaplained in more detail, 
> I think.

Hmm, you're quoting text from section 5, and section 4 actually
describes the concept of items quite well I believe?

>> +  __s64 priority;
>> +    With KDBUS_RECV_USE_PRIORITY set in flags, receive the next message in
>> +    the queue with at least the given priority. If no such message is waiting
>> +    in the queue, -ENOMSG is returned.
> 
> ###
> How do I simply select the highest priority message, without knowing what 
> its priority is?

The wording is indeed unclear here. KDBUS_RECV_USE_PRIORITY causes the
messages to be dequeued by their priority. The 'priority' field is
simply a filter that request a minimum priority. By setting this field
to the highest possible value, you effectively bypass the filter. I've
added a better description now.

>> +  -ENOMEM	The kernel memory is exhausted
>> +  -ENOTTY	Illegal ioctl command issued for the file descriptor
> 
> Why ENOTTY here, rather than EINVAL? The latter is, I beleive, the usual 
> ioctl() error for invalid commands, I believe (If you keep ENOTTY, add an
> explanation in this document.)

Hmm, no. -ENOTTY is commonly used as return code when calling ioctls
that can't be handled by the FDs they're called on. 'man errno(3)' even
states: "ENOTTY   Inappropriate I/O control operation (POSIX.1)".

>> +  -EINVAL	Unsupported item attached to command
>> +
>> +For all ioctls that carry a struct as payload:
>> +
>> +  -EFAULT	The supplied data pointer was not 64-bit aligned, or was
>> +		inaccessible from the kernel side.
>> +  -EINVAL	The size inside the supplied struct was smaller than expected
>> +  -EMSGSIZE	The size inside the supplied struct was bigger than expected
> 
> Why two different errors for smaller and larger than expected? (If you keep things this
> way, pelase explain the reason in this document.)

Providing a struct that is smaller than the minimum doesn't give the
ioctl a valid set of information to process the request. Hence, I think
-EINVAL is appropriate. However, -EMSGSIZE is something that users might
hit when they make message payloads too big, and I think it's good to
have a change to distinguish the two cases in error handling. I added
something in the document now.


Again, thanks a lot for reading the documentation so accurately!

Daniel
