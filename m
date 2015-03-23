From: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 01/11] stm class: Introduce an abstraction for System Trace Module devices
Date: Mon, 23 Mar 2015 21:41:58 +0200
Message-ID: <87384v7b7d.fsf@ashishki-desk.ger.corp.intel.com>
References: <1427056381-27614-1-git-send-email-alexander.shishkin@linux.intel.com> <1427056381-27614-2-git-send-email-alexander.shishkin@linux.intel.com> <CANLsYkycrE-VyyLWLYtBFNijhLP8UejVjDEXYv4FBP88eyZrRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANLsYkycrE-VyyLWLYtBFNijhLP8UejVjDEXYv4FBP88eyZrRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, peter.lachner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, norbert.schulz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, keven.boell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yann.fouassier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, laurent.fert-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Kaixu Xia <kaixu.xia-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:

>> +source "drivers/hwtracing/stm/Kconfig"
>> +
>>  endmenu
>
> When the coresight framework and drivers were submitted for review
> people asked that I move the Kconfig options to
> "arch/arm[64]/kernel.debug", resulting in coresight configurable
> options showing up under the "Kernel Hacking" department.  To me the
> request was not deprived of logic since if one is dealing with HW
> tracing, some serious kernel hacking is likely happening.

To me this is very much a non-sequitur conclusion: if one's likely to
use CONFIG_x for kernel debugging doesn't necessarily mean CONFIG_x is a
strictly kernel debugging feature. One might move serial drivers under
"Kernel Hacking" by the same token. I also suspect that sweeping things
under "Kernel Hacking" is kind of a license to go easy on code review.

> Now that the Intel drivers are coming in, that we have a generic STM,
> and "drivers/hwtracing" has already been created, we should take a
> minute to ponder if tracers for various architecture should go under
> "arch/XYX/kernel.debug" or if we should introduce a new "hwtracing"
> submenu in the drivers list.

I'm in favor of the latter. If some bits in this submenu are strictly
specific to kernel hacking an appropriate dependency can be used.

> Because of the STM sources (which are bound to grow in numbers) I
> _think_ it would be easier to have a new submenu in the drivers list
> but I'm not strongly opinionated on the topic.  Please take a minute
> to think about it and get back to me with your opinion.  I'd also be
> interested to know what other community members think - it's
> definitely not the first time this kind of dilemma happens...

I don't see why any of these should be hidden under Kconfig.debug, they
are mostly device drivers. They shouldn't add any runtime footprint
unless they are actually used and it's up to the user how to use them
(provided we handle capabilities/permissions correctly, which we should
do regardless).

So yes, my opinion -- let's have a submenu in hwtracing.

Regards,
--
Alex
