From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on fallback
Date: Thu, 8 Jun 2017 18:14:25 -0700
Message-ID: <CALCETrXbHpkN9Pujj=U1VpAR9MTOyCAqCtL0=7-vb1EdpEwCMg@mail.gmail.com>
References: <20170526194640.GS8951@wotan.suse.de> <CAKdAkRTrcTVOAP5GK-R=Au_tL5WqSn5UkQEzNe5NcCWXS8mbtA@mail.gmail.com>
 <CAB=NE6Wh9inuA-R9-zegnvJV=s_6o_doMNDOhBVhYn4ZQ_Ku5Q@mail.gmail.com>
 <20170526215518.GB40877@dtor-ws> <20170605202410.GQ8951@wotan.suse.de>
 <1496760796.5682.48.camel@linux.intel.com> <20170606164734.GB27288@wotan.suse.de>
 <20170606221151.ygoxqkwhhjsqw632@thunk.org> <20170607002237.GJ27288@wotan.suse.de>
 <CALCETrVi2_9-+SnyF6TzUDJfrJs6E_3uAncjKP=44zzY1xGwZg@mail.gmail.com> <20170607062515.GA23434@dtor-ws>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170607062515.GA23434@dtor-ws>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Alan Cox <alan@linux.intel.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Stephen Boyd <stephen.boyd@linaro.org>, "Li, Yi" <yi1.li@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>, "Eric W. Biederman" <ebiederm@xmission.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, "Fuzzey, Martin" <mfuzzey@parkeon.com>, Linux API <linux-api@vger.kernel.org>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, jewalt@lgsinnovations.com, rafal@milecki.pl, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 6, 2017 at 11:25 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Tue, Jun 06, 2017 at 09:56:47PM -0700, Andy Lutomirski wrote:
>> On Tue, Jun 6, 2017 at 5:22 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
>> > On Tue, Jun 06, 2017 at 06:11:51PM -0400, Theodore Ts'o wrote:
>> >> On Tue, Jun 06, 2017 at 06:47:34PM +0200, Luis R. Rodriguez wrote:
>> >> > On Tue, Jun 06, 2017 at 03:53:16PM +0100, Alan Cox wrote:
>> >
>> > We rely on swait, and swait right now only uses -ERESTARTSYS. Are
>> > you saying we could mask out -ERESTARTSYS and map it to -ERESTARTNOINTR
>> > or -ERESTARTNOHAND if we see fit for some future functionality / need ?
>>
>> I think that has essentially nothing to do with swait.  User code does
>> some syscall.  That syscall triggers a firmware load.  The caller gets
>> a signal.  If you're going to let firmware load get interrupted, you
>> need to consider what the syscall is.
>
> I think it is way too complicated and I do not think driver writers will
> stand a chance of implementing this correctly, given that often firmware
> load might be triggered indirectly and by multitude of syscalls.
>

That's what I meant, but I said it unclearly.  I meant that, if we're
going to start allowing interruption, we would need to audit all the
callers.  Ugh.

I suppose we could have request_firmware_interruptable(), but that
seems like it's barely worth it.

--Andy
