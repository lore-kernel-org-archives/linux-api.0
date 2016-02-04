From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: linux-api scope (Re: [PATCH v2 11/22] media: dvb-frontend invoke
 enable/disable_source handlers)
Date: Thu, 4 Feb 2016 20:48:50 +0100
Message-ID: <CAKgNAkj-veqrgChhTwkOPOXTsA=wytha26aokMixVrZmAxNz6Q@mail.gmail.com>
References: <CALCETrUNxPhcKiT+aswO5rr+ZpPPCkT30+Exd0iWwQnMN921Qg@mail.gmail.com>
 <CAKgNAkg+cjJS2G5TKvYAYizXWaPewVNtdBQN1x0otbPM7huy5g@mail.gmail.com> <56B361C5.8000101@osg.samsung.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56B361C5.8000101@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Andy Lutomirski <luto@kernel.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, ALSA development <alsa-devel@alsa-project.org>, Josh Triplett <josh@joshtriplett.org>, Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

Hi Shuah,

On 4 February 2016 at 15:35, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> On 02/04/2016 07:04 AM, Michael Kerrisk (man-pages) wrote:
>> [expanding the CC a little]
>>
>> Hi Andy, (and Shuah)
>>
>> On 4 February 2016 at 05:51, Andy Lutomirski <luto@kernel.org> wrote:
>>> [cc list heavily trimmed]
>>>
>>> On Wed, Feb 3, 2016 at 8:03 PM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
>>>> Change dvb frontend to check if tuner is free when
>>>> device opened in RW mode. Call to enable_source
>>>> handler either returns with an active pipeline to
>>>> tuner or error if tuner is busy. Tuner is released
>>>> when frontend is released calling the disable_source
>>>> handler.
>>>
>>> As an actual subscriber to linux-api, I prefer for the linux-api list
>>> to be lowish-volume and mostly limited to API-related things.  Is this
>>> API related?  Do people think that these series should be sent to
>>> linux-api?
>>
>> I think not, and I'd like to stem the flood of mail to the list.
>> There's two things that we could do:
>
> I simply followed the getmaintainers generate3d list.
> A bit surprised to see linux-api, but didn't want to
> leave it out.

Yep -- you and many others. That's the problem with automated solutions ;-).

>> 1. Shuah, I know we talked about this in the past, and it made some
>> sense to me at the time for kselftest to use linux-api@, but maybe
>> it's time to create a dedicated list, and move the traffic there? It'd
>> help focus the traffic of linux-api more on its original purpose.
>
> Yes that is a good plan - I will request a new mailing list and
> send in a patch to Kselftest MAINTIANER's entry.

Thanks, and sorry for the inconvenience. I guess a prominent mail onto
linux-api@ advertising the new list, once it has been created, would
not go amiss.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
