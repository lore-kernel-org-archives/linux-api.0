From: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v2 3/3] console_codes.4: Add CSI sequence for cursor blink
 interval
Date: Thu, 26 Mar 2015 13:57:44 +0000 (GMT)
Message-ID: <alpine.DEB.2.11.1503261356490.2411@local>
References: <alpine.DEB.2.11.1501262034380.1945@localhost.localdomain> <alpine.DEB.2.11.1501262040380.2052@localhost.localdomain> <20150225094946.GA24627@amd> <alpine.LNX.2.11.1502252319330.276@localhost> <20150226220243.GC9935@amd> <alpine.LNX.2.11.1502271905580.4212@localhost>
 <alpine.LNX.2.11.1502271911380.4248@localhost> <20150325111949.GA24230@kroah.com> <alpine.DEB.2.11.1503261341260.2164@local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1503261341260.2164@local>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add a Console Private CSI sequence to specify the current console's
cursor blink interval. The interval is specified as a number of
milliseconds until the next cursor display state toggle, from 50 to
65535.

Signed-off-by: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
---
 man4/console_codes.4 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/man4/console_codes.4 b/man4/console_codes.4
index 34f7535..7d05076 100644
--- a/man4/console_codes.4
+++ b/man4/console_codes.4
@@ -377,6 +377,7 @@ ESC [ 15 ]      	T{
 Bring the previous console to the front
 (since Linux 2.6.0).
 T}
+ESC [ 16 ; \fIn\fP ]   	Set the cursor blink interval in milliseconds.
 .TE
 .SS Character sets
 The kernel knows about 4 translations of bytes into console-screen
-- 
2.1.0
