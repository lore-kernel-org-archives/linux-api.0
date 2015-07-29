From: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 01/11] stm class: Introduce an abstraction for System Trace Module devices
Date: Wed, 29 Jul 2015 16:46:49 +0300
Message-ID: <871tfrkree.fsf@ashishki-desk.ger.corp.intel.com>
References: <1436177344-16751-1-git-send-email-alexander.shishkin@linux.intel.com> <1436177344-16751-2-git-send-email-alexander.shishkin@linux.intel.com> <CAAfSe-vOgnMXCy6fb8yuQ0O_5x1L1QtCmGjNjH+OtGAg6KJHrg@mail.gmail.com> <877fpjkseh.fsf@ashishki-desk.ger.corp.intel.com> <20150729133529.GI20130@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150729133529.GI20130-GFdadSzt00ze9xe1eoZjHA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Chunyan Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, peter.lachner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, norbert.schulz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, keven.boell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yann.fouassier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, laurent.fert-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, "linux-api@vger.kernel.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> On Wed, Jul 29, 2015 at 04:25:10PM +0300, Alexander Shishkin wrote:
>
>> There has to be a way to defer stm_probe(), although a quick look at
>> amba code suggests it's not implemented.
>
> What makes you say this?  Probe deferral is implemented in the driver
> core rather than individual buses, the buses don't need to know anything
> about it.

I stand corrected, it indeed is.

So returning EPROBE_DEFER from stm_probe() should Just Work (provided
stm_probe() handles its error paths correctly).

Regards,
--
Alex
