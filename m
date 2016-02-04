From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: linux-api scope (Re: [PATCH v2 11/22] media: dvb-frontend invoke
 enable/disable_source handlers)
Date: Thu, 4 Feb 2016 15:04:47 +0100
Message-ID: <CAKgNAkg+cjJS2G5TKvYAYizXWaPewVNtdBQN1x0otbPM7huy5g@mail.gmail.com>
References: <CALCETrUNxPhcKiT+aswO5rr+ZpPPCkT30+Exd0iWwQnMN921Qg@mail.gmail.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUNxPhcKiT+aswO5rr+ZpPPCkT30+Exd0iWwQnMN921Qg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, ALSA development <alsa-devel@alsa-project.org>, Josh Triplett <josh@joshtriplett.org>, Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

[expanding the CC a little]

Hi Andy, (and Shuah)

On 4 February 2016 at 05:51, Andy Lutomirski <luto@kernel.org> wrote:
> [cc list heavily trimmed]
>
> On Wed, Feb 3, 2016 at 8:03 PM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
>> Change dvb frontend to check if tuner is free when
>> device opened in RW mode. Call to enable_source
>> handler either returns with an active pipeline to
>> tuner or error if tuner is busy. Tuner is released
>> when frontend is released calling the disable_source
>> handler.
>
> As an actual subscriber to linux-api, I prefer for the linux-api list
> to be lowish-volume and mostly limited to API-related things.  Is this
> API related?  Do people think that these series should be sent to
> linux-api?

I think not, and I'd like to stem the flood of mail to the list.
There's two things that we could do:

1. Shuah, I know we talked about this in the past, and it made some
sense to me at the time for kselftest to use linux-api@, but maybe
it's time to create a dedicated list, and move the traffic there? It'd
help focus the traffic of linux-api more on its original purpose.

2. However, I think the bigger cause of the flood is the change made
to MAINTAINERS by Josh's commit
ea8f8fc8631d9f890580a94d57a18bfeb827fa2e:

+ABI/API
+L:     linux-api@vger.kernel.org
+F:     Documentation/ABI/
+F:     include/linux/syscalls.h
+F:     include/uapi/
+F:     kernel/sys_ni.c

The change was well-intentioned (I Acked it), but folk run
scripts/get-maintainers.pl without thinking too much about its output
and add all of the resulting lists and CCs to their patch submissions.
This means we get a lot of useless noise relating to drivers and
unrelated Documentation changes, and actually miss some of the really
important changes (e.g., extensions of system calls; and new /proc
entries tend to get lost in the noise). Furthermore, people doing
things such as adding new system calls often don't tun
scripts/get-maintainers.pl it seems. Certainly, I have to often enough
remind peple to CC linux-api when adding new system calls.

I'll craft a patch to trim the MAINTAINERS entry.

Cheers,

Michael




> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
