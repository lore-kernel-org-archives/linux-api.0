From: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v2 0/3] add cursor blink interval terminal escape sequence
Date: Thu, 26 Mar 2015 13:51:04 +0000 (GMT)
Message-ID: <alpine.DEB.2.11.1503261341260.2164@local>
References: <alpine.DEB.2.11.1501262034380.1945@localhost.localdomain> <alpine.DEB.2.11.1501262040380.2052@localhost.localdomain> <20150225094946.GA24627@amd> <alpine.LNX.2.11.1502252319330.276@localhost> <20150226220243.GC9935@amd> <alpine.LNX.2.11.1502271905580.4212@localhost>
 <alpine.LNX.2.11.1502271911380.4248@localhost> <20150325111949.GA24230@kroah.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150325111949.GA24230-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

v2: Add documentation to console_codes man page (man-pages repo)

This patch series adds an escape sequence to specify the current console's
cursor blink interval. The default interval is set to fbcon's currently 
hardcoded 200 msecs.

Scot Doyle (3):
  vt: add cursor blink interval escape sequence
  fbcon: use the cursor blink interval provided by vt
  console_codes.4: Add CSI sequence for cursor blink interval

 drivers/tty/vt/vt.c            |  9 +++++++++
 drivers/video/console/fbcon.c  | 10 +++++-----
 drivers/video/console/fbcon.h  |  1 +
 include/linux/console_struct.h |  1 +
 man4/console_codes.4           |  1 +
 5 files changed, 17 insertions(+), 5 deletions(-)

-- 
2.1.0
