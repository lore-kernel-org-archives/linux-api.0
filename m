From: Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH 1/7] tuner-core: properly initialize media controller
 subdev
Date: Tue, 13 Jan 2015 18:35:08 +0200
Message-ID: <54B5493C.5030102@iki.fi>
References: <cover.1420315245.git.mchehab@osg.samsung.com>	<4ff2de5fce002a6f6f87993440f45e0f198c57cb.1420315245.git.mchehab@osg.samsung.com>	<3223125.oELRrvBOf4@avalon> <20150111122553.76394653@recife.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150111122553.76394653-+RedX5hVuTR+urZeOPWqwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Cc: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Prabhakar Lad <prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 01/11/2015 04:25 PM, Mauro Carvalho Chehab wrote:
> Em Sun, 11 Jan 2015 16:02:41 +0200
> Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org> escreveu:

>> I'm not too familiar with tuners, do they all have a single output only and no
>> input ?
>
> They have an input: the antenna connector. However, I don't see any need
> to map it for most tuners, as there's generally just one input, hardwired
> into the tuner chip.
>
> There are some hardware with 2 antenna connectors, but for different
> functions (FM and TV). They're selected automatically when the V4L2
> driver switches between FM and TV.
>
> In any case, the tuner-core doesn't provide any way to select the
> antenna input.
>
> So, if a driver would need to select the input, it would either need
> to not use tuner-core or some patch will be required to add such
> functionality inside tuner-core.

Tuner has antenna as a input and output is intermediate frequency or 
baseband (IF/BB (zero-IF)).

I think most modern silicon tuners actually has more than one physical 
antenna inputs - but those are left unused or same physical antenna 
connector is wired to all those inputs.

Sooner or later there will be receiver having multiple antenna 
connectors which are selectable by software. So let it be at least 
option easy to add later.

regards
Antti

-- 
http://palosaari.fi/
