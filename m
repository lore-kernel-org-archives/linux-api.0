From: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on fallback
Date: Fri, 9 Jun 2017 14:29:09 -0700
Message-ID: <CAB=NE6W8MCGjEEmtopnfcHs8FOQ5DsftwDRBO8qD9hnaimfKwQ@mail.gmail.com>
References: <20170526194640.GS8951@wotan.suse.de> <CAKdAkRTrcTVOAP5GK-R=Au_tL5WqSn5UkQEzNe5NcCWXS8mbtA@mail.gmail.com>
 <CAB=NE6Wh9inuA-R9-zegnvJV=s_6o_doMNDOhBVhYn4ZQ_Ku5Q@mail.gmail.com>
 <20170526215518.GB40877@dtor-ws> <20170605202410.GQ8951@wotan.suse.de>
 <1496760796.5682.48.camel@linux.intel.com> <20170606164734.GB27288@wotan.suse.de>
 <20170606221151.ygoxqkwhhjsqw632@thunk.org> <20170607002237.GJ27288@wotan.suse.de>
 <CALCETrVi2_9-+SnyF6TzUDJfrJs6E_3uAncjKP=44zzY1xGwZg@mail.gmail.com>
 <20170607062515.GA23434@dtor-ws> <CALCETrXbHpkN9Pujj=U1VpAR9MTOyCAqCtL0=7-vb1EdpEwCMg@mail.gmail.com>
 <CAB=NE6USSj0sBzJSFOyyRQu=0rQXdbHc2+GNk1fse+Y8H6TrgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAB=NE6USSj0sBzJSFOyyRQu=0rQXdbHc2+GNk1fse+Y8H6TrgQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Alan Cox <alan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Boyd <stephen.boyd-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Li, Yi" <yi1.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Fuzzey, Martin" <mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, jewalt-d4N2ExZK1jaSe5ORCPIMD9BPR1lH4CV8@public.gmane.org, rafal-g1n6cQUeyibVItvQsEIGlw@public.gmane.org, Arend Van Spriel <arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Moritz Fischer <moritz.fische>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 8, 2017 at 6:33 PM, Luis R. Rodriguez <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Thu, Jun 8, 2017 at 6:14 PM, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> That's what I meant, but I said it unclearly.  I meant that, if we're
>> going to start allowing interruption, we would need to audit all the
>> callers.  Ugh.
>
> There are actually two audits worth evaluating if what we've concluded
> is fair game:
>
>   a) firmware sync calls on interruptible paths
>   b) use of swait / old interruptible waits on sysfs paths

And as I noted in the other thread -- another possible issue could be
any swait / interruptable wait on init or probe. Provided any child
completes and the kernel code for wait handler does abort, that
request would be terminated. This could for instance happen at bootup
as modules load and any child from the loader terminates.

We already have Coccinelle grammar to hunt for "though shall not
request firmware on init or probe", such SmPL grammar could be in turn
be repruposed to hunt for these types of conditions.

  Luis
