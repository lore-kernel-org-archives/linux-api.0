From: Chunyan Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 01/11] stm class: Introduce an abstraction for System
 Trace Module devices
Date: Thu, 30 Jul 2015 14:15:51 +0800
Message-ID: <CAAfSe-tM3iWq1UEAQQVL-V6gw4+MeG2KmNHw1nanLR2kzFVwQg@mail.gmail.com>
References: <1436177344-16751-1-git-send-email-alexander.shishkin@linux.intel.com>
	<1436177344-16751-2-git-send-email-alexander.shishkin@linux.intel.com>
	<CAAfSe-vOgnMXCy6fb8yuQ0O_5x1L1QtCmGjNjH+OtGAg6KJHrg@mail.gmail.com>
	<877fpjkseh.fsf@ashishki-desk.ger.corp.intel.com>
	<20150729133529.GI20130@sirena.org.uk>
	<871tfrkree.fsf@ashishki-desk.ger.corp.intel.com>
	<CAAfSe-sQjPHQQ7-jh-Xq6nR3O0gtP3AM4m=gGJjUE26rsbQDMQ@mail.gmail.com>
	<87zj2e9p25.fsf@ashishki-desk.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87zj2e9p25.fsf-qxRn5AmX6ZD9BXuAQUXR0fooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, peter.lachner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, norbert.schulz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, keven.boell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yann.fouassier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, laurent.fert-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 30, 2015 at 1:45 PM, Alexander Shishkin
<alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> Chunyan Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>
>> If let stm_probe() implement probe deferral, it has to have a global
>> variable for the later calling of "stm_register_device", because the
>
> No, it doesn't. Please read about probe deferral.

Could you please read my another email sent out today, I explained
more details in that email.

Thanks,
Chunyan

>
> Regards,
> --
> Alex
