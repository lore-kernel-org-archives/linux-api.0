From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on
 fallback
Date: Sat, 10 Jun 2017 00:55:27 +0200
Message-ID: <20170609225527.GF27288@wotan.suse.de>
References: <20170524214027.7775-1-mcgrof@kernel.org>
 <CALCETrXUrirO-vg3M+MGhn=0gZTwx0phsRDS4TCwWWgNYC6RsA@mail.gmail.com>
 <CAB=NE6VENGmTEZ3_8EWmv6bhT81k=szg0_POWJm2SP+V21CeBw@mail.gmail.com>
 <CALCETrU4__YUGk36PN=FbuEf0SBaTrxQQqm4sWs2NrZ+6WN7jA@mail.gmail.com>
 <CANh8QzwPb_+RKs5QVt7mdFk8h_rOMVS3j9m0OADgvzBtNqBBLg@mail.gmail.com>
 <20170607170858.GK27288@wotan.suse.de>
 <59383DDA.3040702@parkeon.com>
 <CAB=NE6WHoP21BJTb7jmNVZJruHr9zWCTOyDtyhgQWy7CT=6q0g@mail.gmail.com>
 <CAB=NE6UQZMmLvxTu7RcFHh3neAh+RFpTTFCSwJ8_EsmmtEq94Q@mail.gmail.com>
 <593A50FF.40604@parkeon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <593A50FF.40604@parkeon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Martin Fuzzey <mfuzzey@parkeon.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Alan Cox <alan@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, Andy Lutomirski <luto@kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, jewalt@lgsinnovations.com, rafal@milecki.pl, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Li, Yi" <yi1.li@linux.intel.com>, atull@opensource.altera.com, Moritz Fischer <moritz.fischer@ettus.com>, Petr Mladek <pmladek@suse.com>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 09, 2017 at 09:40:47AM +0200, Martin Fuzzey wrote:
> On 09/06/17 03:57, Luis R. Rodriguez wrote:
> > On Thu, Jun 8, 2017 at 6:10 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> > > > Android didn't send the signal, the kernel did (SIGCHLD).
> > > > 
> > > > Like this:
> > > > 
> > > > 1) Android init (pid=1) fork()s (say pid=42) [this child process is totally
> > > > unrelated to firmware loading]
> > > > 2) Android init (pid=1) does a write() on a (driver custom) sysfs file which
> > > > ends up calling request_firmware() kernel side
> > > > 3) The firmware loading fallback mechanism is used, the request is sent to
> > > > userspace and pid 1 waits in the kernel on wait_*
> > > > 4) before firmware loading completes pid 42 dies (for any reason - in my
> > > > case normal termination)
> > Martin just to be clear, by "normal case termination" do you mean
> > completing successfully ?? Ie the firmware actually did make it onto
> > the device ?
> 
> The firmware did *not* make it onto the device since the request_firmware()
> call returned an error
> (the code that would have transfered it to the device is only executed
> following a successful request_firmware)
> 
> The process that terminates normally is unrelated to firmware loading as I
> said above.
> 
> The only things that matter are:
> - It is a child process of the process that calls request_firmware()
> - It terminates *while* the the wait_ is still in progress
> 
> 
> Here is a way of reproducing the problem using the test_firmware module
> (which I only just saw) on normal linux with no Android or custom driver
> 
> 
> #!/bin/sh
> set -e
> 
> # Make sure the system firmware loader doesn't get in the way
> /etc/init.d/udev stop
> 
> modprobe test_firmware
> 
> DIR=/sys/devices/virtual/misc/test_firmware
> 
> echo 10 >/sys/class/firmware/timeout;
> sleep 2 &
> echo -n "/some/non/existing/file.bin" > "$DIR"/trigger_request;
> 
> 
> 
> If run with the "sleep 2 &" it terminates after 2 seconds
> If the sleep is commented it runs for the expected 10 seconds (the firmware
> loading timeout)
> 
> Since the sleep process is a child of the script process requesting a
> firmware load its death causes a SIGCHLD causing request_firmware() to abort
> prematurely.

BTW I've run some more tests and if you use request_firmware_nowait() the above
issue also is avoidable. Also, if you use the custom fallback (uevent parameter
is false) the timeout is max value always. The only way to kill the custom
requests is through the echo -1 > loading or the max timeout triggers (don't
rely on that!). The custom interface was a bad idea though so best to just
avoid it.

Anyway I can reproduce in my tests now, will add this testcase as well.
The stable fixes will be sent as well.

  Luis
