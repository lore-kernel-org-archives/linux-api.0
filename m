From: Chunyan Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 01/11] stm class: Introduce an abstraction for System
 Trace Module devices
Date: Thu, 30 Jul 2015 11:38:45 +0800
Message-ID: <CAAfSe-sQjPHQQ7-jh-Xq6nR3O0gtP3AM4m=gGJjUE26rsbQDMQ@mail.gmail.com>
References: <1436177344-16751-1-git-send-email-alexander.shishkin@linux.intel.com>
	<1436177344-16751-2-git-send-email-alexander.shishkin@linux.intel.com>
	<CAAfSe-vOgnMXCy6fb8yuQ0O_5x1L1QtCmGjNjH+OtGAg6KJHrg@mail.gmail.com>
	<877fpjkseh.fsf@ashishki-desk.ger.corp.intel.com>
	<20150729133529.GI20130@sirena.org.uk>
	<871tfrkree.fsf@ashishki-desk.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <871tfrkree.fsf-qxRn5AmX6ZD9BXuAQUXR0fooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, peter.lachner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, norbert.schulz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, keven.boell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yann.fouassier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, laurent.fert-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 29, 2015 at 9:46 PM, Alexander Shishkin
<alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:
>
>> On Wed, Jul 29, 2015 at 04:25:10PM +0300, Alexander Shishkin wrote:
>>
>>> There has to be a way to defer stm_probe(), although a quick look at
>>> amba code suggests it's not implemented.
>>
>> What makes you say this?  Probe deferral is implemented in the driver
>> core rather than individual buses, the buses don't need to know anything
>> about it.
>
> I stand corrected, it indeed is.
>
> So returning EPROBE_DEFER from stm_probe() should Just Work (provided
> stm_probe() handles its error paths correctly).

If let stm_probe() implement probe deferral, it has to have a global
variable for the later calling of "stm_register_device", because the
first parameter of "stm_register_device" is " struct device * " which
comes from amba_probe(), after finished amba_probe(), we may not get
this structure by other means.

This was a similar policy that we both thought was not good :)

>
> Regards,
> --
> Alex
