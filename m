From: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Subject: Re: error value for "internal error"
Date: Wed, 3 May 2017 11:10:22 +0200
Message-ID: <CAJfpegscqNH19pTQeJOhCMTKG=u1dShpDLXNJMuR_UEtxbz97Q@mail.gmail.com>
References: <CAJfpegv3xS_MEVVeAnd4JUvjxoJd9PQdbsEzCPXNpUeex4SxHA@mail.gmail.com>
 <CA+55aFxScO3nZPoj8HbHsyuwT1WA6BuT9Hi=A3AD+1LF3JsVCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFxScO3nZPoj8HbHsyuwT1WA6BuT9Hi=A3AD+1LF3JsVCA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 2, 2017 at 8:37 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Tue, May 2, 2017 at 7:03 AM, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org> wrote:
>> I've been wondering what to return for soft asserts like this:
>>
>>         if (WARN_ON(something unexpected))
>>                 return -E????;
>>
>> EINVAL doesn't fit because it means the input from userspace was
>> wrong.  EIO means something went bad with the hardware.
>
> I think we've traditionally just used EIO for "something went wrong".
> It's not necessarily hardware that went wrong.
>
> That's particularly true when there is a WARN_ON() that then gives
> more details of where this actually happened in the system logs - at
> that point the error number really doesn't matter all that much.

Still, wouldn't it make sense to differentiate between

 a) something went wrong with the hardware

 b) the kernel is buggy

which are completely different things?

The only reason to use a traditional errno like EIO, is that userspace
may be able to handle it instead of just throwing up its hands and
exiting.   In case of a kernel internal error, it's unlikely that
userspace will be able to work around it, while hardware errors are
more promising.  But maybe I'm wrong about this one...

Thanks,
Miklos
