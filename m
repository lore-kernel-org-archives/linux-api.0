From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: linux-api scope (Re: [PATCH v2 11/22] media: dvb-frontend invoke
 enable/disable_source handlers)
Date: Thu, 4 Feb 2016 07:35:49 -0700
Message-ID: <56B361C5.8000101@osg.samsung.com>
References: <CALCETrUNxPhcKiT+aswO5rr+ZpPPCkT30+Exd0iWwQnMN921Qg@mail.gmail.com>
 <CAKgNAkg+cjJS2G5TKvYAYizXWaPewVNtdBQN1x0otbPM7huy5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkg+cjJS2G5TKvYAYizXWaPewVNtdBQN1x0otbPM7huy5g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ALSA development <alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/04/2016 07:04 AM, Michael Kerrisk (man-pages) wrote:
> [expanding the CC a little]
> 
> Hi Andy, (and Shuah)
> 
> On 4 February 2016 at 05:51, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> [cc list heavily trimmed]
>>
>> On Wed, Feb 3, 2016 at 8:03 PM, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:
>>> Change dvb frontend to check if tuner is free when
>>> device opened in RW mode. Call to enable_source
>>> handler either returns with an active pipeline to
>>> tuner or error if tuner is busy. Tuner is released
>>> when frontend is released calling the disable_source
>>> handler.
>>
>> As an actual subscriber to linux-api, I prefer for the linux-api list
>> to be lowish-volume and mostly limited to API-related things.  Is this
>> API related?  Do people think that these series should be sent to
>> linux-api?
> 
> I think not, and I'd like to stem the flood of mail to the list.
> There's two things that we could do:

I simply followed the getmaintainers generate3d list.
A bit surprised to see linux-api, but didn't want to
leave it out.

> 
> 1. Shuah, I know we talked about this in the past, and it made some
> sense to me at the time for kselftest to use linux-api@, but maybe
> it's time to create a dedicated list, and move the traffic there? It'd
> help focus the traffic of linux-api more on its original purpose.

Yes that is a good plan - I will request a new mailing list and
send in a patch to Kselftest MAINTIANER's entry.

> 
> 2. However, I think the bigger cause of the flood is the change made
> to MAINTAINERS by Josh's commit
> ea8f8fc8631d9f890580a94d57a18bfeb827fa2e:
> 
> +ABI/API
> +L:     linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +F:     Documentation/ABI/
> +F:     include/linux/syscalls.h
> +F:     include/uapi/
> +F:     kernel/sys_ni.c
> 
> The change was well-intentioned (I Acked it), but folk run
> scripts/get-maintainers.pl without thinking too much about its output
> and add all of the resulting lists and CCs to their patch submissions.
> This means we get a lot of useless noise relating to drivers and
> unrelated Documentation changes, and actually miss some of the really
> important changes (e.g., extensions of system calls; and new /proc
> entries tend to get lost in the noise). Furthermore, people doing
> things such as adding new system calls often don't tun
> scripts/get-maintainers.pl it seems. Certainly, I have to often enough
> remind peple to CC linux-api when adding new system calls.
> 
> I'll craft a patch to trim the MAINTAINERS entry.
> 

Thanks for doing this,
-- Shuah



-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
