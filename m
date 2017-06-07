From: Martin Fuzzey <mfuzzey@parkeon.com>
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on
 fallback
Date: Wed, 7 Jun 2017 19:54:34 +0200
Message-ID: <59383DDA.3040702@parkeon.com>
References: <20170524205658.GK8951@wotan.suse.de>
 <20170524214027.7775-1-mcgrof@kernel.org>
 <CALCETrXUrirO-vg3M+MGhn=0gZTwx0phsRDS4TCwWWgNYC6RsA@mail.gmail.com>
 <CAB=NE6VENGmTEZ3_8EWmv6bhT81k=szg0_POWJm2SP+V21CeBw@mail.gmail.com>
 <CALCETrU4__YUGk36PN=FbuEf0SBaTrxQQqm4sWs2NrZ+6WN7jA@mail.gmail.com>
 <CANh8QzwPb_+RKs5QVt7mdFk8h_rOMVS3j9m0OADgvzBtNqBBLg@mail.gmail.com>
 <20170607170858.GK27288@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170607170858.GK27288@wotan.suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-fsdevel@vger.kernel.org, Alan Cox <alan@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, Andy Lutomirski <luto@kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, jewalt@lgsinnovations.com, rafal@milecki.pl, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Li, Yi" <yi1.li@linux.intel.com>, atull@opensource.altera.com, Moritz Fischer <moritz.fischer@ettus.com>, Petr Mladek <pmladek@suse.com>, Johannes Berg <johannes.berg@intel.com>, Emmanuel Grumbach <emmanuel.grumbach@intel.com>, Luca Coelho <luciano.coelho@intel.com>, Kalle Valo <kvalo@codeaurora.org>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.o>
List-Id: linux-api@vger.kernel.org

On 07/06/17 19:08, Luis R. Rodriguez wrote:
> On Thu, May 25, 2017 at 10:28:38AM +0200, Fuzzey, Martin wrote:
>> 1) Android init calls write() on the sysfs file
>> 2) The sysfs .store() callback registered by a driver is called
>> 3) The driver calls request_firmware()
>> 4) request_firmware() sends the firmware load request to userspace and
>> calls wait_for_completion_interruptible()
> Martin, just for completeness on documenting on the commit log of the next
> swait proposed fix for this -- what signal did the process get from which you
> note the child dies below ? Exactly what in Android sent this signal ?

Android didn't send the signal, the kernel did (SIGCHLD).

Like this:

1) Android init (pid=1) fork()s (say pid=42) [this child process is 
totally unrelated to firmware loading]
2) Android init (pid=1) does a write() on a (driver custom) sysfs file 
which ends up calling request_firmware() kernel side
3) The firmware loading fallback mechanism is used, the request is sent 
to userspace and pid 1 waits in the kernel on wait_*
4) before firmware loading completes pid 42 dies (for any reason - in my 
case normal termination)
5) Kernel delivers SIGCHLD to pid=1 to tell it a child has died, which 
causes -ERESTARTSYS to be returned from wait_*


Martin
