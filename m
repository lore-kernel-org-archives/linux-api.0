From: Devin Heitmueller <dheitmueller-eb9eJ82Ua7k9XoPSrs7Ehg@public.gmane.org>
Subject: Re: [PATCH 17/31] media: au0828 video change to use v4l_enable_media_tuner()
Date: Thu, 28 Jan 2016 14:33:05 -0500
Message-ID: <CAGoCfiwaFEWhCD9Bf61CAUiKJnFu3WKd=X2-QFBH1yERXuFRpQ@mail.gmail.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
	<2d2392f96a7f10a8d94a4d7fa6d5657b56b75593.1452105878.git.shuahkh@osg.samsung.com>
	<20160128135752.536e909e@recife.lan>
	<56AA6A2A.1020801@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56AA6A2A.1020801-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, tiwai-IBi9RG/b67k@public.gmane.org, Clemens Ladisch <clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, "sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, Pawel Osciak <pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Jaroslav Kysela <perex-/Fr2/VpizcU@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Malcolm Priestley <tvboxspy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, chehabrafael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, Stefan Richter <stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>, inki.dae-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, jh1009.sung-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Prabhakar Lad <prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, p.zabel@pe
List-Id: linux-api@vger.kernel.org

Hi Shuah, Mauro,

>> Did you test the code when the input is not a tuner, but, instead,
>> Composite or S-Video connector, as shown at:
>>       https://mchehab.fedorapeople.org/mc-next-gen/au0828.png
>
> I am not sure if I did or not. I can double check this case.
> Do you have concerns that this won't work?

I'm not sure how you expect the MC framework to be handling this case,
but I can tell you that the hardware will *not* support simultaneous
streaming of the DVB feed at the same time as the analog feed, even if
you're using the composite/s-video input and not actually using the
xc5000 tuner in analog mode.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
