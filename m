From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Mon, 3 Jul 2017 11:50:42 -0700
Message-ID: <CAPcyv4gUOs4+cNNGL_VeZms2P5Ypwgu-WknE4kJ0-sRij5y1QQ@mail.gmail.com>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info> <20170703123025.7479702e@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170703123025.7479702e-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, ksummit <ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 3, 2017 at 9:30 AM, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org> wrote:
> On Sun, 2 Jul 2017 19:51:43 +0200
[..]
>>
>> Ugh, pretty long mail. Sorry about that. Maybe I shouldn't have looked
>> so closely into LWN.net articles about regression tracking and older
>> discussions about it.
>
> Anyway, I know that selftests are not the answer for everything, but
> anything that has a way to reproduce a bug should be added to it. Sure,
> it may depend on various hardware and/or file systems and different
> configs, but if we have a central location to place all bug reproducing
> tests (which we do have), then we should utilize it.

I agree with Steven, and I would add that you don't necessarily need
specific hardware to write a test for a driver regression, see
examples in tools/testing/nvdimm. I also tend to think that
back-stopping regressions with new tests helps with the burn-out
problem of tracking regressions. Where building tools and tests is
potentially more fulfilling than just bug tracking.
