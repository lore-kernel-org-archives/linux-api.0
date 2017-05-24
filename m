From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on fallback
Date: Wed, 24 May 2017 15:38:32 -0700
Message-ID: <CAB=NE6VENGmTEZ3_8EWmv6bhT81k=szg0_POWJm2SP+V21CeBw@mail.gmail.com>
References: <20170524205658.GK8951@wotan.suse.de> <20170524214027.7775-1-mcgrof@kernel.org>
 <CALCETrXUrirO-vg3M+MGhn=0gZTwx0phsRDS4TCwWWgNYC6RsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXUrirO-vg3M+MGhn=0gZTwx0phsRDS4TCwWWgNYC6RsA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, jewalt@lgsinnovations.com, rafal@milecki.pl, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Li, Yi" <yi1.li@linux.intel.com>, atull@opensource.altera.com, Moritz Fischer <moritz.fischer@ettus.com>, Petr Mladek <pmladek@suse.com>, Johannes Berg <johannes.berg@intel.com>, Emmanuel Grumbach <emmanuel.grumbach@intel.com>, Luca Coelho <luciano.coelho@intel.com>, Kalle Valo <kvalo@codeaurora.org>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, David Howells <dhowells@redhat.com>, Peter Jones <pjones@redhat.com>, Hans
List-Id: linux-api@vger.kernel.org

On Wed, May 24, 2017 at 3:00 PM, Andy Lutomirski <luto@kernel.org> wrote:
> On Wed, May 24, 2017 at 2:40 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
>> From: Martin Fuzzey <mfuzzey@parkeon.com>
>>
>> Commit 0cb64249ca500 ("firmware_loader: abort request if wait_for_completion
>> is interrupted") added via 4.0 added support to abort the fallback mechanism
>> when a signal was detected and wait_for_completion_interruptible() returned
>> -ERESTARTSYS. Although the abort was effective we were unfortunately never
>> really propagating this error though and as such userspace could not know
>> why the abort happened.
>
> Can you give a simple example of what's going on and why it matters?
>
> ERESTARTSYS and friends are highly magical, and I'm not convinced that
> allowing _request_firmware_load to return -ERESTARTSYS is actually a
> good idea.  What if there are system calls that can't handle this
> style of restart that start being restarted as a result?

This seems to be a linux-api question, so Cc'ing them and Michael.

For those not familiar it is worth explaining first the user interface.

This describes the fallback mechanism of the Linux firmware API if
direct filesystem lookup fails. Although most distros disable this
stuff today some distros (Android) seem to be always relying on it
today. Other than Android, since most distros have the forced fallback
mechanism off but *enable* requests to require it, only 2 upstream
drivers do this, so on other distros we only have 2 drivers which
typically require the the fallback mechanism.

The exposed user interface here is we enable a knob through sysfs to
enable userspace to write a file as a fallback mechanism then, and we
expect to get woken up today when userspace finds the needed file and
then writes the file to the sysfs knob. We wait for userspace using
swait_event_interruptible_timeout(). While we wait we can get a
-ERESTARTSYS since swait_event_interruptible_timeout() uses
__swait_event_interruptible_timeout() under the hood and this in turn
___swait_event() which can prepare_to_swait_event() which can return
-ERESTARTSYS on signal_pending_state().

The issue discovered was that Android could issue SIGCHLD and the
waiter gets a signal but the reason for the exact reason for the
failure is not propagated. The proposed patch propagates -ERESTARTSYS
when that is returned on signal_pending_state() as we wait.

So linux-api folks please speak up.

 Luis
