From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [Y2038] [PATCH 1/7] [media] dvb: use ktime_t for internal timeout
Date: Tue, 15 Sep 2015 22:30 +0200
Message-ID: <48082122.rhhMXK7OaH@wuerfel>
References: <1442332148-488079-1-git-send-email-arnd@arndb.de> <1442332148-488079-2-git-send-email-arnd@arndb.de> <55F85B97.8000700@saftware.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55F85B97.8000700-p6skyjIMMCQb1SvskN2V4Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org
Cc: Andreas Oberritter <obi-p6skyjIMMCQb1SvskN2V4Q@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tuesday 15 September 2015 19:55:35 Andreas Oberritter wrote:

> >  		/* show speed every SPEED_PKTS_INTERVAL packets */
> >  		if (!(demux->speed_pkts_cnt % SPEED_PKTS_INTERVAL)) {
> > -			cur_time = current_kernel_time();
> > +			cur_time = ktime_get();
> >  
> > -			if (demux->speed_last_time.tv_sec != 0 &&
> > -					demux->speed_last_time.tv_nsec != 0) {
> > -				delta_time = timespec_sub(cur_time,
> > -						demux->speed_last_time);
> > +			if (ktime_to_ns(demux->speed_last_time) == 0) {
> 
> if ktime_to_ns does what I think it does, then you should invert the logic.

Thanks for taking a critical look here, you are absolutely right, and I've
now fixed it.

	Arnd
