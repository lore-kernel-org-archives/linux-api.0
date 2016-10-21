From: Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
Subject: Re: [PATCH 2/3] ARM: convert to generated system call tables
Date: Fri, 21 Oct 2016 17:57:21 +0100
Message-ID: <20161021165721.GD1041@n2100.armlinux.org.uk>
References: <E1bwa6s-0004ZY-4k@rmk-PC.armlinux.org.uk>
 <3851270.xZRcP9hae0@wuerfel>
 <20161021133708.GA1041@n2100.armlinux.org.uk>
 <4337157.Eff9E2riVH@wuerfel>
 <20161021154856.GC1041@n2100.armlinux.org.uk>
 <alpine.DEB.2.20.1610211641430.27636@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1610211641430.27636-9YEB1lltEqivcGRMvF24k2I39yigxGEX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Myers <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 21, 2016 at 04:48:36PM +0000, Joseph Myers wrote:
> On Fri, 21 Oct 2016, Russell King - ARM Linux wrote:
> 
> > To stop adding OABI syscalls altogether.  I'm sure that there will
> > come a point (if it hasn't already) that glibc no longer supports
> > OABI, and at that point it probably becomes rather silly to keep
> > adding OABI syscalls.
> 
> glibc hasn't supported OABI since 2012 (support removed in version 2.16 
> released 2012-06-30).  GCC support was also removed in 2012 (removal 
> released in version 4.8, released 2013-03-22).

Right, so arguably its pointless adding new syscalls to OABI anymore.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
