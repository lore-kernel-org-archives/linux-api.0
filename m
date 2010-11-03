From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 11/12] ipv4: Export arp_bind_neighbour() symbol to GPL
	modules
Date: Tue, 02 Nov 2010 18:30:31 -0700
Message-ID: <20101103013030.4641.36031.stgit@crlf.mtv.corp.google.com>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101103012917.4641.57113.stgit-+dUuAhMFdFN6FDdRrpk8kO4/NqBCd+6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
Cc: adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

The netoops driver would like to use this function to do do ARP resolution when
being configured with an IPV4 address.

Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
TODO: Is this really the right interface to get an L2 address?
---
 net/ipv4/arp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 96c1955..97b488c 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -528,6 +528,7 @@ int arp_bind_neighbour(struct dst_entry *dst)
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(arp_bind_neighbour);
 
 /*
  * Check if we can use proxy ARP for this path
