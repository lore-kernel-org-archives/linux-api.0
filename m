From: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 01/11] stm class: Introduce an abstraction for System Trace Module devices
Date: Thu, 30 Jul 2015 09:37:53 +0300
Message-ID: <87vbd29mm6.fsf@ashishki-desk.ger.corp.intel.com>
References: <1436177344-16751-1-git-send-email-alexander.shishkin@linux.intel.com> <1436177344-16751-2-git-send-email-alexander.shishkin@linux.intel.com> <CAAfSe-vOgnMXCy6fb8yuQ0O_5x1L1QtCmGjNjH+OtGAg6KJHrg@mail.gmail.com> <877fpjkseh.fsf@ashishki-desk.ger.corp.intel.com> <CAAfSe-vgFSxA7OX7DSOB4XXdsan_3PWne0-16kSKZv_8HkHjgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAfSe-vgFSxA7OX7DSOB4XXdsan_3PWne0-16kSKZv_8HkHjgg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chunyan Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, peter.lachner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, norbert.schulz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, keven.boell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yann.fouassier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, laurent.fert-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, "linux-api@vger.kernel.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Chunyan Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> Sure, I mean, the root reason of this problem is here ( i.e.
> "stm_core_up" was zero then):
>      if (!stm_core_up)
>          return -EPROBE_DEFER;
>
> Why it was zero?
> Because the function (i.e. stm_core_init() ) in which "stm_core_up"
> would be added one hasn't been executed at this moment. It would be
> executed on module_init stage for you this version of patch.

Again, this is the indented behavior.

> The reason of this warning is:
> After stm_probe() failed, clk_core_disable() would be called from
> amba_put_disable_pclk(), then WARN_ON() happened:
>          if (WARN_ON(core->enable_count == 0))
>                  return;
>
> I'm guessing the reason why "core->enable_count" was 0 at this moment is:
> I don't know who created a thread to process the
> amba_pm_runtime_suspend(), in which clk_core_disable() was already
> called, "core->enable_count" was, of course, cleared to zero then.
> And this thread run before amba_put_disable_pclk(pcdev) which is just
> the one called from amba_probe() after
> "->probe"(i.e. stm_probe in this case) returning a non-zero value.

No, this is guesswork. In amba_probe(), clocks are enabled for the
drv->probe() and then disabled afterwards and that's where the refcount
ends up unbalanced, the probe is the culprit.

I can debug your driver for you but you'll at least need to put the code
up somewhere so I can see it.

Regards,
--
Alex
