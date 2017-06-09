From: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on fallback
Date: Thu, 8 Jun 2017 18:33:36 -0700
Message-ID: <CAB=NE6USSj0sBzJSFOyyRQu=0rQXdbHc2+GNk1fse+Y8H6TrgQ@mail.gmail.com>
References: <20170526194640.GS8951@wotan.suse.de> <CAKdAkRTrcTVOAP5GK-R=Au_tL5WqSn5UkQEzNe5NcCWXS8mbtA@mail.gmail.com>
 <CAB=NE6Wh9inuA-R9-zegnvJV=s_6o_doMNDOhBVhYn4ZQ_Ku5Q@mail.gmail.com>
 <20170526215518.GB40877@dtor-ws> <20170605202410.GQ8951@wotan.suse.de>
 <1496760796.5682.48.camel@linux.intel.com> <20170606164734.GB27288@wotan.suse.de>
 <20170606221151.ygoxqkwhhjsqw632@thunk.org> <20170607002237.GJ27288@wotan.suse.de>
 <CALCETrVi2_9-+SnyF6TzUDJfrJs6E_3uAncjKP=44zzY1xGwZg@mail.gmail.com>
 <20170607062515.GA23434@dtor-ws> <CALCETrXbHpkN9Pujj=U1VpAR9MTOyCAqCtL0=7-vb1EdpEwCMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXbHpkN9Pujj=U1VpAR9MTOyCAqCtL0=7-vb1EdpEwCMg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Alan Cox <alan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Boyd <stephen.boyd-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Li, Yi" <yi1.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Fuzzey, Martin" <mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, jewalt-d4N2ExZK1jaSe5ORCPIMD9BPR1lH4CV8@public.gmane.org, rafal-g1n6cQUeyibVItvQsEIGlw@public.gmane.org, Arend Van Spriel <arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, atull-yzvPICuk2ABMcg4IHK0kFoH6Mc4MB0Vx@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jun 8, 2017 at 6:14 PM, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Tue, Jun 6, 2017 at 11:25 PM, Dmitry Torokhov
> <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Tue, Jun 06, 2017 at 09:56:47PM -0700, Andy Lutomirski wrote:
>>> On Tue, Jun 6, 2017 at 5:22 PM, Luis R. Rodriguez <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>> > On Tue, Jun 06, 2017 at 06:11:51PM -0400, Theodore Ts'o wrote:
>>> >> On Tue, Jun 06, 2017 at 06:47:34PM +0200, Luis R. Rodriguez wrote:
>>> >> > On Tue, Jun 06, 2017 at 03:53:16PM +0100, Alan Cox wrote:
>>> >
>>> > We rely on swait, and swait right now only uses -ERESTARTSYS. Are
>>> > you saying we could mask out -ERESTARTSYS and map it to -ERESTARTNOINTR
>>> > or -ERESTARTNOHAND if we see fit for some future functionality / need ?
>>>
>>> I think that has essentially nothing to do with swait.  User code does
>>> some syscall.  That syscall triggers a firmware load.  The caller gets
>>> a signal.  If you're going to let firmware load get interrupted, you
>>> need to consider what the syscall is.
>>
>> I think it is way too complicated and I do not think driver writers will
>> stand a chance of implementing this correctly, given that often firmware
>> load might be triggered indirectly and by multitude of syscalls.
>>
>
> That's what I meant, but I said it unclearly.  I meant that, if we're
> going to start allowing interruption, we would need to audit all the
> callers.  Ugh.

There are actually two audits worth evaluating if what we've concluded
is fair game:

  a) firmware sync calls on interruptible paths
  b) use of swait / old interruptible waits on sysfs paths

As for a) we drove tons of code away from using sync, request
firmware, and on async firmware the return value is lost, we only can
currently know if a failure of some sort occurred. If that push to
async failed we also scared away tons of drivers to use
request_firmware() calls on init and later incorrectly on probe due to
serialized init + probe delay on boot. From what I recall my last
Coccinelle evil-monster-hunt, I did indeed find quite a bit of drivers
still still relying on sync firmware which ultimately revealed use on
a probe path. The signal however was only effective as of commit
0cb64249ca500 ("firmware_loader: abort request if wait_for_completion
is interrupted") merged as of v4.0. Creating awareness of the issue
seems fair, but I don't think its worth a huge fly swatter.

I have no information to contribute for b) other than I was reluctant
to even consider it.

> I suppose we could have request_firmware_interruptable(), but that
> seems like it's barely worth it.

I don't think that's worth it, given the signal was effective only as
of v4.0, we already had a big push away from sync requests, and also
had the "don't use request firmware" on init scare which also
propagated to probe later.

  Luis
