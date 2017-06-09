From: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on fallback
Date: Thu, 8 Jun 2017 18:10:20 -0700
Message-ID: <CAB=NE6WHoP21BJTb7jmNVZJruHr9zWCTOyDtyhgQWy7CT=6q0g@mail.gmail.com>
References: <20170524205658.GK8951@wotan.suse.de> <20170524214027.7775-1-mcgrof@kernel.org>
 <CALCETrXUrirO-vg3M+MGhn=0gZTwx0phsRDS4TCwWWgNYC6RsA@mail.gmail.com>
 <CAB=NE6VENGmTEZ3_8EWmv6bhT81k=szg0_POWJm2SP+V21CeBw@mail.gmail.com>
 <CALCETrU4__YUGk36PN=FbuEf0SBaTrxQQqm4sWs2NrZ+6WN7jA@mail.gmail.com>
 <CANh8QzwPb_+RKs5QVt7mdFk8h_rOMVS3j9m0OADgvzBtNqBBLg@mail.gmail.com>
 <20170607170858.GK27288@wotan.suse.de> <59383DDA.3040702@parkeon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <59383DDA.3040702-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Martin Fuzzey <mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Cox <alan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, jewalt-d4N2ExZK1jaSe5ORCPIMD9BPR1lH4CV8@public.gmane.org, rafal-g1n6cQUeyibVItvQsEIGlw@public.gmane.org, Arend Van Spriel <arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "Li, Yi" <yi1.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, atull-yzvPICuk2ABMcg4IHK0kFoH6Mc4MB0Vx@public.gmane.org, Moritz Fischer <moritz.fischer-+aYTwkv1SeIAvxtiuMwx3w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Johannes Berg <johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Emmanuel Grumbach <emmanuel.grumbach@i>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 7, 2017 at 10:54 AM, Martin Fuzzey <mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org> wrote:
> On 07/06/17 19:08, Luis R. Rodriguez wrote:
>>
>> On Thu, May 25, 2017 at 10:28:38AM +0200, Fuzzey, Martin wrote:
>>>
>>> 1) Android init calls write() on the sysfs file
>>> 2) The sysfs .store() callback registered by a driver is called
>>> 3) The driver calls request_firmware()
>>> 4) request_firmware() sends the firmware load request to userspace and
>>> calls wait_for_completion_interruptible()
>>
>> Martin, just for completeness on documenting on the commit log of the next
>> swait proposed fix for this -- what signal did the process get from which
>> you
>> note the child dies below ? Exactly what in Android sent this signal ?
>
>
> Android didn't send the signal, the kernel did (SIGCHLD).
>
> Like this:
>
> 1) Android init (pid=1) fork()s (say pid=42) [this child process is totally
> unrelated to firmware loading]
> 2) Android init (pid=1) does a write() on a (driver custom) sysfs file which
> ends up calling request_firmware() kernel side
> 3) The firmware loading fallback mechanism is used, the request is sent to
> userspace and pid 1 waits in the kernel on wait_*
> 4) before firmware loading completes pid 42 dies (for any reason - in my
> case normal termination)

Interesting, could one interpretation here be that the process
successfully finishing + the signal being sent beats out the timing of
the firmware_class syfs code detecting that the write completed ?

> 5) Kernel delivers SIGCHLD to pid=1 to tell it a child has died, which
> causes -ERESTARTSYS to be returned from wait_*

  Luis
