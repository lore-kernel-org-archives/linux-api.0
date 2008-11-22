From: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Subject: Re: [take 3] Use pid in inotify events.
Date: Sat, 22 Nov 2008 12:41:44 +0300
Message-ID: <20081122094144.GB12543@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <cfec22b10811201434v2230d11dvc9797018e433fd20@mail.gmail.com> <20081120230612.GB6536@ioremap.net> <200811211939.46812.arnd@arndb.de> <4927B0D5.4020907@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4927B0D5.4020907-KzQzY1MbaKjAHznzqCTclw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Newall <davidn-KzQzY1MbaKjAHznzqCTclw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Nov 22, 2008 at 05:42:21PM +1030, David Newall (davidn-KzQzY1MbaKjAHznzqCTclw@public.gmane.org) wrote:
> Why not require local access to use the same mechanism as remote, i.e.
> by "network mounting" the data on the local machine, too.  That way
> there's no confusion over where the change originated nor who's copy
> must be invalidated.

There is always a possibility that some application will access given
data directly and not via mounted partition, plus I have to patch
server's kernel with out of the tree modules, so intestead I could
implement lsm-based module to catch access and embed cache coherency
protocol there. Inotify in this case is the simplest approach.

-- 
	Evgeniy Polyakov
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
