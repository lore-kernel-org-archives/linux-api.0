From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 5 Jul 2017 17:40:44 +0200
Message-ID: <CAMuHMdU401+nZxJJU2O=x33LGU4iEAGNyYmhWvc2jCcFGdsLRw@mail.gmail.com>
References: <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
 <20170705084528.67499f8c@gandalf.local.home> <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
 <20170705092757.63dc2328@gandalf.local.home> <20170705140607.GA30187@kroah.com>
 <20170705143341.oees22k2snhtmkxo@sirena.org.uk> <20170705103658.226099c6@gandalf.local.home>
 <1499266228.3668.10.camel@HansenPartnership.com> <20170705105651.5da9c969@gandalf.local.home>
 <1499267389.3668.16.camel@HansenPartnership.com> <20170705152026.rkw73q2f6xmiju37@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170705152026.rkw73q2f6xmiju37-GFdadSzt00ze9xe1eoZjHA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org" <ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 5, 2017 at 5:20 PM, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Wed, Jul 05, 2017 at 08:09:49AM -0700, James Bottomley wrote:
>> On Wed, 2017-07-05 at 10:56 -0400, Steven Rostedt wrote:
>> > James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
>
>> > > you're protecting was accessed outside the lock, which is the usual
>> > > source of concurrency problems.  In other words lockdep is useful
>> > > but it's not a panacea.
>
>> > Still not an excuse to not have lockdep enabled during tests.
>
>> OK, what makes you think lockdep isn't enabled?  Since Kconfig is so
>> complex, I usually use a distro config ... they have it enabled (or at
>> least openSUSE does), so it's enabled for everything I do.
>
> Yeah, I see enough reports with it in embedded contexts to make me think
> people use it there.  I know I tend to have it turned on most of the
> time.  The concurrency stuff I'm thinking of here is more the things
> you're mentioning with just not taking locks at all when they are needed
> or concurrency with hardware.

I try to have it enabled as much as possible.
However, as it increases kernel size (huge static tables), hitting boot
loader limitations on several boards, I cannot enable all debugging
I would like to on all boards.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
