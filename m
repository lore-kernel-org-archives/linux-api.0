From: Scott James Remnant <scott@netsplit.com>
Subject: Re: [RFCv4] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock changes
Date: Mon, 14 Mar 2011 18:53:08 -0700
Message-ID: <AANLkTim9HhzE3wL+C3JVbU38sfrJrYMc0o2TMae_8ciK@mail.gmail.com>
References: <1299681411-9227-1-git-send-email-virtuoso@slind.org>
	<20110309162513.5058c824.akpm@linux-foundation.org>
	<AANLkTin7=rK2Sc2D7aMhPnPWU9LJq7KMSvwxv_PHERcK@mail.gmail.com>
	<20110310002534.f984f8b2.akpm@linux-foundation.org>
	<AANLkTi=_DG8uYLxDnXF=so5daUE=w-pxL67mYaFAGkkL@mail.gmail.com>
	<alpine.LFD.2.00.1103112054540.2787@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1103112054540.2787@localhost6.localdomain6>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org, Ken MacLeod <ken@bitsko.slc.ut.us>, Shaun Reich <predator106@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>, Michael Tokarev <mjt@tls.msk.ru>, Marcelo Tosatti <mtosatti@redhat.com>, John Stultz <johnstul@us.ibm.com>, Chris Friesen <chris.friesen@genband.com>, Kay Sievers <kay.sievers@vrfy.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Artem Bityutskiy <dedekind1@gmail.com>, Davide Libenzi <davidel@xmailserver.org>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 11, 2011 at 11:56 AM, Thomas Gleixner <tglx@linutronix.de> =
wrote:
> On Fri, 11 Mar 2011, Scott James Remnant wrote:
>> On Thu, Mar 10, 2011 at 12:25 AM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>> > On Wed, 9 Mar 2011 18:01:09 -0800 Scott James Remnant <scott@netsp=
lit.com> wrote:
>> >
>> >> > It would be helpful to know if the identified users of this fea=
ture
>> >> > actually find it useful and adequate. __I guess the most common
>> >> > application is the 1,001 desktop clock widgets. __Do you have a=
ny
>> >> > feedback from any of the owners of those?
>> >> >
>> >> cron is another obvious one (or init systems attempting to replac=
e
>> >> cron). Having to wakeup and check the time every minute can be
>> >> non-conducive to power savings, it would be better if we could ju=
st
>> >> sleep until the next alarm and be woken up if the time changes in
>> >> between.
>> >>
>> >> (That being said, we also need to poll for and/or check for timez=
one
>> >> changes - but those are entirely userspace, so we can deal with t=
hat
>> >> separately)
>> >
>> > Sure, there will be lots of applications.
>> >
>> > But what I'm asking isn't "it is a good feature". =A0I'm asking "i=
s the
>> > feature implemented well". =A0Ideally someone would get down and m=
odify
>> > cron to use the interface in this patch.
>> >
>> So I've just been thinking today - and I'm actually not sure whether
>> this is needed at all for this case.
>>
>> A good cron implementation is going to set timers according to
>> CLOCK_REALTIME; in the case where the clock changes forwards, those
>> timers will fire as part of the clock changing already no? And in th=
e
>> case where the clock changes backwards, you don't want to re-run old
>> ones anyway.
>>
>> Even the hourly/daily cases are actually at a fixed time, so would b=
e
>> triggered - and a decent implementation wouldn't trigger a given
>> script more than once.
>
> Yeah, I was wondering about today as well. Though when you set back
> your clock several days, stuff might be surprised if it's not woken u=
p
> for several days :)
>
I've checked the code, and more importantly, tested the
setting-forward example - timers do indeed fire at the point the clock
is wound forwards. This means there doesn't appear to be a utility for
this patch in the cron case.

In the wound back case, I believe that even current cron goes to some
effort to avoid firing events that have already happened?

Scott
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
