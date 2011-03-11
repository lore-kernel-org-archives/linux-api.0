From: Scott James Remnant <scott-Umf49k1wg4FWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFCv4] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock changes
Date: Fri, 11 Mar 2011 11:51:38 -0800
Message-ID: <AANLkTi=_DG8uYLxDnXF=so5daUE=w-pxL67mYaFAGkkL@mail.gmail.com>
References: <1299681411-9227-1-git-send-email-virtuoso@slind.org>
	<20110309162513.5058c824.akpm@linux-foundation.org>
	<AANLkTin7=rK2Sc2D7aMhPnPWU9LJq7KMSvwxv_PHERcK@mail.gmail.com>
	<20110310002534.f984f8b2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110310002534.f984f8b2.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Alexander Shishkin <virtuoso-0lOfPCoBze7YtjvyW6yDsg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ken MacLeod <ken-VbOJbV3qneKf+c8Povm/Gg@public.gmane.org>, Shaun Reich <predator106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Tokarev <mjt-XAri/EZa3C4vJsYlp49lxw@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Stultz <johnstul-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 10, 2011 at 12:25 AM, Andrew Morton
<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Wed, 9 Mar 2011 18:01:09 -0800 Scott James Remnant <scott@netsplit=
=2Ecom> wrote:
>
>> > It would be helpful to know if the identified users of this featur=
e
>> > actually find it useful and adequate. __I guess the most common
>> > application is the 1,001 desktop clock widgets. __Do you have any
>> > feedback from any of the owners of those?
>> >
>> cron is another obvious one (or init systems attempting to replace
>> cron). Having to wakeup and check the time every minute can be
>> non-conducive to power savings, it would be better if we could just
>> sleep until the next alarm and be woken up if the time changes in
>> between.
>>
>> (That being said, we also need to poll for and/or check for timezone
>> changes - but those are entirely userspace, so we can deal with that
>> separately)
>
> Sure, there will be lots of applications.
>
> But what I'm asking isn't "it is a good feature". =A0I'm asking "is t=
he
> feature implemented well". =A0Ideally someone would get down and modi=
fy
> cron to use the interface in this patch.
>
So I've just been thinking today - and I'm actually not sure whether
this is needed at all for this case.

A good cron implementation is going to set timers according to
CLOCK_REALTIME; in the case where the clock changes forwards, those
timers will fire as part of the clock changing already no? And in the
case where the clock changes backwards, you don't want to re-run old
ones anyway.

Even the hourly/daily cases are actually at a fixed time, so would be
triggered - and a decent implementation wouldn't trigger a given
script more than once.

I'm going to test this in userspace shortly to see whether it's the cas=
e.

Scott
