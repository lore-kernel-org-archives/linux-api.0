From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [RFC] add manpages for Memory Protection Keys
Date: Thu, 10 Mar 2016 11:43:24 -0800
Message-ID: <56E1CE5C.4070206@intel.com>
References: <1457559619-16510-1-git-send-email-dave.hansen@intel.com>
 <56E1A9CD.9030903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56E1A9CD.9030903-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dave-gkUM19QKKo4@public.gmane.org
Cc: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

Michael, thanks again for the detailed review.  I've tried to respond to
all your comments.  Here's an incremental patch from the last one.  I'll
also resend the entire thing shortly.

	https://www.sr71.net/~dave/intel/pkey-man-20160310.0.patch

Just a few questions to clarify some of your review comments below...

On 03/10/2016 09:07 AM, Michael Kerrisk (man-pages) wrote:
> On 03/09/2016 10:40 PM, Dave Hansen wrote:
>> +.PP
>> +.I flags
>> +may contain zero or more disable operations:
>> +.TP
>> +.B PKEY_DISABLE_ACCESS
>> +Disable all data access to memory covered by the returned protection key.
>> +.TP
>> +.B PKEY_DISABLE_WRITE
>> +Disable write access to memory covered by the returned protection key.
>> +.SH RETURN VALUE
>> +On success,
>> +.BR pkey_alloc ()
>> +returns a positive protection key value.
>> +.BR pkey_free ()
>> +returns zero.
>> +On error, \-1 is returned, and
>> +.I errno
>> +is set appropriately.
>> +.SH ERRORS
>> +.TP
>> +.B EINVAL
>> +.IR pkey ,
>> +.IR flags ,
>> +or
>> +.I access_rights
>> +is invalid.
>> +.TP
>> +.B ENOSPC
> 
> At the start of the following paragraph, add
> 
> .(RB pkey_alloc ())
> 
> so that the reader knows that this error applies only for that syscall.

I'm not seeing that actually affect the formatting in the resulting
manpage as I view it.  Is that really the syntax you want?  Is there
another example bit of syntax I should be looking for?

...
> In a previous review of the pages, I asked:
> 
> [[
> And I have a question (and the answer probably should 
> be documented in the manual page).  What happens when 
> one signal handler interrupts the execution of another? 
> Do pkey_set() calls in the first handler persist into the 
> second handler? I presume not, but it would be good to 
> be a little more explicit about this.
> ]]
> 
> I think this point does need to be covered in the man page.

I did reword some things in response to this review comment, but not
thoroughly enough. :)

How about the following as a change to the existing second paragraph?

The effects of a call to
.BR pkey_set ()
from a signal handler will not persist when the signal handler
returns.  This is true whether the return is to a normal,
non-signal context, or to another signal handler.

...
>> +
>> +To use this feature, the processor must support it, and Linux
>> +must contain support for the feature on a given processor.  As of
>> +early 2016 only future Intel x86 processors are supported, and this
>> +hardware supports 16 protection keys in each process.  However,
>> +pkey 0 is used as the default key, so a maximum of 15 are available
>> +for actual application use.
> 
> Is there a recommended way for an application to discover whether the
> system supports pkeys? If so, that should be documented here.

I've added the following text:

Any application wanting to use protection keys needs to be able
to function without them.  They might be unavailable because the
hardware the application runs on does not support them, the
kernel code does not contain support, the kernel support has been
disabled, or because the keys have all been allocated, perhaps by
a library the application is using.  It is recommended that
applications wanting to use protection keys should simply call
.BR pkey_alloc()
instead of attempting to detect support for the
feature in any other way.

Hardware support for protection keys may be enumerated with
the cpuid instruction.  Details on how to do this can be
found in the Intel Software Developers Manual.  The kernel
performs this enumeration and exposes the information in
/proc/cpuinfo under the "flags" field.  "pku" in this field
indicates hardware support for protection keys and "ospke"
indicates that the kernel contains and has enabled protection
keys support,.

...
>> +.BR pkey_mprotect (2),
>> +.BR pkey_alloc (2),
>> +.BR pkey_free (2),
>> +.BR pkey_set (2),
>> +.BR pkey_get (2),
> 
> Would it be possible to get a small, complete working example program
> in one of these pages? The axample could show how pkeys override
> traditional memory protections. I appreciate that the rest of us do
> not yet have suitable hardware, but presumably you do.

Sure, I'll include one in pkey(7).

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
