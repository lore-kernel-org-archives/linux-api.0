From: Martin Fuzzey <mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on
 fallback
Date: Fri, 9 Jun 2017 09:40:47 +0200
Message-ID: <593A50FF.40604@parkeon.com>
References: <20170524205658.GK8951@wotan.suse.de>
 <20170524214027.7775-1-mcgrof@kernel.org>
 <CALCETrXUrirO-vg3M+MGhn=0gZTwx0phsRDS4TCwWWgNYC6RsA@mail.gmail.com>
 <CAB=NE6VENGmTEZ3_8EWmv6bhT81k=szg0_POWJm2SP+V21CeBw@mail.gmail.com>
 <CALCETrU4__YUGk36PN=FbuEf0SBaTrxQQqm4sWs2NrZ+6WN7jA@mail.gmail.com>
 <CANh8QzwPb_+RKs5QVt7mdFk8h_rOMVS3j9m0OADgvzBtNqBBLg@mail.gmail.com>
 <20170607170858.GK27288@wotan.suse.de> <59383DDA.3040702@parkeon.com>
 <CAB=NE6WHoP21BJTb7jmNVZJruHr9zWCTOyDtyhgQWy7CT=6q0g@mail.gmail.com>
 <CAB=NE6UQZMmLvxTu7RcFHh3neAh+RFpTTFCSwJ8_EsmmtEq94Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAB=NE6UQZMmLvxTu7RcFHh3neAh+RFpTTFCSwJ8_EsmmtEq94Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alan Cox <alan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, jewalt-d4N2ExZK1jaSe5ORCPIMD9BPR1lH4CV8@public.gmane.org, rafal-g1n6cQUeyibVItvQsEIGlw@public.gmane.org, Arend Van Spriel <arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "Li, Yi" <yi1.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, atull-yzvPICuk2ABMcg4IHK0kFoH6Mc4MB0Vx@public.gmane.org, Moritz Fischer <moritz.fischer-+aYTwkv1SeIAvxtiuMwx3w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Johannes Berg <johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Emmanuel
List-Id: linux-api@vger.kernel.org

On 09/06/17 03:57, Luis R. Rodriguez wrote:
> On Thu, Jun 8, 2017 at 6:10 PM, Luis R. Rodriguez <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>> Android didn't send the signal, the kernel did (SIGCHLD).
>>>
>>> Like this:
>>>
>>> 1) Android init (pid=1) fork()s (say pid=42) [this child process is totally
>>> unrelated to firmware loading]
>>> 2) Android init (pid=1) does a write() on a (driver custom) sysfs file which
>>> ends up calling request_firmware() kernel side
>>> 3) The firmware loading fallback mechanism is used, the request is sent to
>>> userspace and pid 1 waits in the kernel on wait_*
>>> 4) before firmware loading completes pid 42 dies (for any reason - in my
>>> case normal termination)
> Martin just to be clear, by "normal case termination" do you mean
> completing successfully ?? Ie the firmware actually did make it onto
> the device ?

The firmware did *not* make it onto the device since the 
request_firmware() call returned an error
(the code that would have transfered it to the device is only executed 
following a successful request_firmware)

The process that terminates normally is unrelated to firmware loading as 
I said above.

The only things that matter are:
- It is a child process of the process that calls request_firmware()
- It terminates *while* the the wait_ is still in progress


Here is a way of reproducing the problem using the test_firmware module 
(which I only just saw) on normal linux with no Android or custom driver


#!/bin/sh
set -e

# Make sure the system firmware loader doesn't get in the way
/etc/init.d/udev stop

modprobe test_firmware

DIR=/sys/devices/virtual/misc/test_firmware

echo 10 >/sys/class/firmware/timeout;
sleep 2 &
echo -n "/some/non/existing/file.bin" > "$DIR"/trigger_request;



If run with the "sleep 2 &" it terminates after 2 seconds
If the sleep is commented it runs for the expected 10 seconds (the 
firmware loading timeout)

Since the sleep process is a child of the script process requesting a 
firmware load its death causes a SIGCHLD causing request_firmware() to 
abort prematurely.


Martin
