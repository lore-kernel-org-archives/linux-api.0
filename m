From: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
Subject: [PATCH 0/2] add cursor blink interval terminal escape sequence
Date: Fri, 27 Feb 2015 19:10:05 +0000 (UTC)
Message-ID: <alpine.LNX.2.11.1502271905580.4212@localhost>
References: <alpine.DEB.2.11.1501262034380.1945@localhost.localdomain> <alpine.DEB.2.11.1501262040380.2052@localhost.localdomain> <20150225094946.GA24627@amd> <alpine.LNX.2.11.1502252319330.276@localhost> <20150226220243.GC9935@amd>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150226220243.GC9935@amd>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Greg, the first patch of this series is for the tty tree.

Tomi, the second patch of this series is for your tree, but it depends on
the first patch. Also, will you remove these two previously queued patches?
"fbcon: store cursor blink interval in fbcon_ops"
"fbcon: expose cursor blink interval via sysfs"

Michael, I plan to send a documentation patch if these are accepted.

This patch series adds an escape sequence to specify the current console's
cursor blink interval. The default interval is set to fbcon's currently 
hardcoded 200 msecs.

Scot Doyle (2):
  vt: add cursor blink interval escape sequence
  fbcon: use the cursor blink interval provided by vt

 drivers/tty/vt/vt.c            |  9 +++++++++
 drivers/video/console/fbcon.c  | 10 +++++-----
 drivers/video/console/fbcon.h  |  1 +
 include/linux/console_struct.h |  1 +
 4 files changed, 16 insertions(+), 5 deletions(-)

-- 
2.3.0

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
