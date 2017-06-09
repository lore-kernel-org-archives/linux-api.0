From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on fallback
Date: Thu, 8 Jun 2017 18:57:09 -0700
Message-ID: <CAB=NE6UQZMmLvxTu7RcFHh3neAh+RFpTTFCSwJ8_EsmmtEq94Q@mail.gmail.com>
References: <20170524205658.GK8951@wotan.suse.de> <20170524214027.7775-1-mcgrof@kernel.org>
 <CALCETrXUrirO-vg3M+MGhn=0gZTwx0phsRDS4TCwWWgNYC6RsA@mail.gmail.com>
 <CAB=NE6VENGmTEZ3_8EWmv6bhT81k=szg0_POWJm2SP+V21CeBw@mail.gmail.com>
 <CALCETrU4__YUGk36PN=FbuEf0SBaTrxQQqm4sWs2NrZ+6WN7jA@mail.gmail.com>
 <CANh8QzwPb_+RKs5QVt7mdFk8h_rOMVS3j9m0OADgvzBtNqBBLg@mail.gmail.com>
 <20170607170858.GK27288@wotan.suse.de> <59383DDA.3040702@parkeon.com> <CAB=NE6WHoP21BJTb7jmNVZJruHr9zWCTOyDtyhgQWy7CT=6q0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAB=NE6WHoP21BJTb7jmNVZJruHr9zWCTOyDtyhgQWy7CT=6q0g@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Martin Fuzzey <mfuzzey@parkeon.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, Alan Cox <alan@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, Andy Lutomirski <luto@kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, jewalt@lgsinnovations.com, rafal@milecki.pl, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Li, Yi" <yi1.li@linux.intel.com>, atull@opensource.altera.com, Moritz Fischer <moritz.fischer@ettus.com>, Petr Mladek <pmladek@suse.com>, Johannes Berg <johannes.berg@intel.com>, Emmanuel
List-Id: linux-api@vger.kernel.org

On Thu, Jun 8, 2017 at 6:10 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Wed, Jun 7, 2017 at 10:54 AM, Martin Fuzzey <mfuzzey@parkeon.com> wrote:
>> On 07/06/17 19:08, Luis R. Rodriguez wrote:
>>>
>>> On Thu, May 25, 2017 at 10:28:38AM +0200, Fuzzey, Martin wrote:
>>>>
>>>> 1) Android init calls write() on the sysfs file
>>>> 2) The sysfs .store() callback registered by a driver is called
>>>> 3) The driver calls request_firmware()
>>>> 4) request_firmware() sends the firmware load request to userspace and
>>>> calls wait_for_completion_interruptible()
>>>
>>> Martin, just for completeness on documenting on the commit log of the next
>>> swait proposed fix for this -- what signal did the process get from which
>>> you
>>> note the child dies below ? Exactly what in Android sent this signal ?
>>
>>
>> Android didn't send the signal, the kernel did (SIGCHLD).
>>
>> Like this:
>>
>> 1) Android init (pid=1) fork()s (say pid=42) [this child process is totally
>> unrelated to firmware loading]
>> 2) Android init (pid=1) does a write() on a (driver custom) sysfs file which
>> ends up calling request_firmware() kernel side
>> 3) The firmware loading fallback mechanism is used, the request is sent to
>> userspace and pid 1 waits in the kernel on wait_*
>> 4) before firmware loading completes pid 42 dies (for any reason - in my
>> case normal termination)

Martin just to be clear, by "normal case termination" do you mean
completing successfully ?? Ie the firmware actually did make it onto
the device ?

> Interesting, could one interpretation here be that the process
> successfully finishing + the signal being sent beats out the timing of
> the firmware_class syfs code detecting that the write completed ?
>
>> 5) Kernel delivers SIGCHLD to pid=1 to tell it a child has died, which
>> causes -ERESTARTSYS to be returned from wait_*
>
>   Luis
