From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on fallback
Date: Fri, 26 May 2017 14:26:45 -0700
Message-ID: <CAKdAkRTrcTVOAP5GK-R=Au_tL5WqSn5UkQEzNe5NcCWXS8mbtA@mail.gmail.com>
References: <20170524205658.GK8951@wotan.suse.de> <20170524214027.7775-1-mcgrof@kernel.org>
 <CALCETrXUrirO-vg3M+MGhn=0gZTwx0phsRDS4TCwWWgNYC6RsA@mail.gmail.com>
 <CAB=NE6VENGmTEZ3_8EWmv6bhT81k=szg0_POWJm2SP+V21CeBw@mail.gmail.com>
 <CALCETrU4__YUGk36PN=FbuEf0SBaTrxQQqm4sWs2NrZ+6WN7jA@mail.gmail.com>
 <CANh8QzwPb_+RKs5QVt7mdFk8h_rOMVS3j9m0OADgvzBtNqBBLg@mail.gmail.com>
 <87fufr3mdy.fsf@xmission.com> <20170526194640.GS8951@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170526194640.GS8951@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, "Fuzzey, Martin" <mfuzzey@parkeon.com>, Andy Lutomirski <luto@kernel.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, jewalt@lgsinnovations.com, rafal@milecki.pl, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Li, Yi" <yi1.li@linux.intel.com>, atull@opensource.altera.com, Moritz Fischer <moritz.fischer@ettus.com>, Petr Mladek <pmladek@suse.com>, Johannes Berg <johannes.berg@intel.com>, Emmanuel Grumbach <emmanuel.grumbach@intel.com>, Luca Coelho <luciano.coelho@intel>
List-Id: linux-api@vger.kernel.org

On Fri, May 26, 2017 at 12:46 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Fri, May 26, 2017 at 06:09:29AM -0500, Eric W. Biederman wrote:
>> "Fuzzey, Martin" <mfuzzey@parkeon.com> writes:
>> >>>> Maybe SIGCHLD shouldn't interrupt firmware loading?
>> >
>> > I don't think there's a way of doing that without disabling all
>> > signals (ie using the non interruptible wait variants).
>> > It used to be that way (which is why I only ran into this after
>> > updating from an ancient 3.16 kernel to a slightly less ancient 4.4)
>> > But there are valid reasons for wanting to be able to interrupt
>> > firmware loading (like being able to kill the userspace helper)
>>
>> Perhaps simply using a killable wait and not a fully interruptible
>> wait would be better?
>
> What do you mean by a killable wait BTW?

https://lwn.net/Articles/288056/

I think only interrupting firmware loading with fatal signals would
make a lot of sense.

>
> ret = swait_event_interruptible_timeout() is being used right now.

It looks like we are missing swait_event_killable*(), but I do not
think it would be hard to add.

-- 
Dmitry
