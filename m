From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH v2 3/3] console_codes.4: Add CSI sequence for cursor
 blink interval
Date: Sat, 28 Mar 2015 08:51:06 +0100
Message-ID: <20150328075104.GC5248@xo-6d-61-c0.localdomain>
References: <alpine.DEB.2.11.1501262034380.1945@localhost.localdomain>
 <alpine.DEB.2.11.1501262040380.2052@localhost.localdomain>
 <20150225094946.GA24627@amd>
 <alpine.LNX.2.11.1502252319330.276@localhost>
 <20150226220243.GC9935@amd>
 <alpine.LNX.2.11.1502271905580.4212@localhost>
 <alpine.LNX.2.11.1502271911380.4248@localhost>
 <20150325111949.GA24230@kroah.com>
 <alpine.DEB.2.11.1503261341260.2164@local>
 <alpine.DEB.2.11.1503261356490.2411@local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1503261356490.2411@local>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu 2015-03-26 13:57:44, Scot Doyle wrote:
> Add a Console Private CSI sequence to specify the current console's
> cursor blink interval. The interval is specified as a number of
> milliseconds until the next cursor display state toggle, from 50 to
> 65535.
> 
> Signed-off-by: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>

Acked-by: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
