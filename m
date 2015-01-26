From: Devin Heitmueller <dheitmueller-eb9eJ82Ua7k9XoPSrs7Ehg@public.gmane.org>
Subject: Re: [PATCH 1/3] media: Fix ALSA and DVB representation at media
 controller API
Date: Mon, 26 Jan 2015 09:41:41 -0500
Message-ID: <CAGoCfiwi0nj_9sYNzEFOp5BvedFe+HphJ2bVtx_bnBw3d-Bsyw@mail.gmail.com>
References: <cover.1422273497.git.mchehab@osg.samsung.com>
	<cb0517f150942a2d3657c1f2e55754061bfae2c4.1422273497.git.mchehab@osg.samsung.com>
	<54C63D16.3070607@xs4all.nl>
	<20150126113416.311fb376@recife.lan>
	<CAGoCfixoSxspEzpCB95BVPXBrZr2gpDVWHbaikESsuB1V=WM1g@mail.gmail.com>
	<20150126123129.2076b9f8@recife.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150126123129.2076b9f8-+RedX5hVuTR+urZeOPWqwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>, Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Ricardo Ribalda <ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Ramakrishnan Muthukrishnan <ramakrmu-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

> It is actually trivial to get the device nodes once you have the
> major/minor. The media-ctl library does that for you. See:

No objection then.

On a related note, you would be very well served to consider testing
your dvb changes with a device that has more than one DVB tuner (such
as the hvr-2200/2250).  That will help you shake out any edge cases
related to ensuring that the different DVB nodes appear in different
groups.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
