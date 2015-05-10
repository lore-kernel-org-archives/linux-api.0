From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 0/3] add cursor blink interval terminal escape sequence
Date: Sun, 10 May 2015 15:32:14 +0200
Message-ID: <20150510133214.GA32575@kroah.com>
References: <alpine.DEB.2.11.1501262034380.1945@localhost.localdomain>
 <alpine.DEB.2.11.1501262040380.2052@localhost.localdomain>
 <20150225094946.GA24627@amd>
 <alpine.LNX.2.11.1502252319330.276@localhost>
 <20150226220243.GC9935@amd>
 <alpine.LNX.2.11.1502271905580.4212@localhost>
 <alpine.LNX.2.11.1502271911380.4248@localhost>
 <20150325111949.GA24230@kroah.com>
 <alpine.DEB.2.11.1503261341260.2164@local>
 <20150328075443.GD5248@xo-6d-61-c0.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150328075443.GD5248@xo-6d-61-c0.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Scot Doyle <lkml14@scotdoyle.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Jiri Slaby <jslaby@suse.cz>, Tomi Valkeinen <tomi.valkeinen@ti.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, Mar 28, 2015 at 08:54:43AM +0100, Pavel Machek wrote:
> On Thu 2015-03-26 13:51:04, Scot Doyle wrote:
> > v2: Add documentation to console_codes man page (man-pages repo)
> > 
> > This patch series adds an escape sequence to specify the current console's
> > cursor blink interval. The default interval is set to fbcon's currently 
> > hardcoded 200 msecs.
> 
> Actually... Greg, can you import console_codes.4 into kernel tree somehow?

Is that file part of the manpages project?  If so, it's fine where it
is, otherwise feel free to send a patch.

thanks,

greg k-h
