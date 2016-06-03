From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [RFCv3] add manpages for Memory Protection Keys
Date: Fri, 3 Jun 2016 07:53:56 -0700
Message-ID: <57519A04.5020700@intel.com>
References: <1464826600-17110-1-git-send-email-dave.hansen@intel.com>
 <647d23bf-a163-deee-d0ec-f961ecfb0b90@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <647d23bf-a163-deee-d0ec-f961ecfb0b90-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dave-gkUM19QKKo4@public.gmane.org
Cc: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 06/02/2016 05:25 PM, Michael Kerrisk (man-pages) wrote:
> The convention for man-pages is that new sentences always start 
> of new source lines. (This makes subsequent patches less "noisy", 
> since the common unit of change in a text is a sentence.)
> Could you fix this throughout please?

Yep, I can do that, and I'll also integrate all of your comments,
although I won't respond to all of them individually, I will integrate them.

>> +no longer be used in any protection-key-related operations.
>> +.PP
>> +.RB ( pkey_alloc ())
>> +.I flags
>> +may contain zero or more disable operations:
> 
> Why "zero or more" rather than "zero or one"? I mean:
> what sense could it make to OR together PKEY_DISABLE_ACCESS and
> PKEY_DISABLE_WRITE?

This is one of the attributes of the hardware that I carried up in to
the interfaces.  The hardware contains two bits: one to write-disable
and one to access-disable.  You're allowed to set both at the same time,
even though the "access" bit overrules the "write" bit when set.

So, it doesn't make a ton of logical sense with these two flags, but it
might if we ever got an "execute disable" feature or some other feature
that could be combined more arbitrarily.
