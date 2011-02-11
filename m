From: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH V10 15/15] ptp: Added a clock driver for the National
 Semiconductor PHYTER.
Date: Fri, 11 Feb 2011 09:19:01 +0100
Message-ID: <20110211081901.GB12270@riccoc20.at.omicron.at>
References: <cover.1296124770.git.richard.cochran@omicron.at>
 <9a8c774950f1a78259a49681ee2fe7977ace44d6.1296124770.git.richard.cochran@omicron.at>
 <1296612712.3336.214.camel@work-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1296612712.3336.214.camel@work-vm>
Sender: netdev-owner@vger.kernel.org
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>, Peter Zijlstra <peterz@infradead.org>, Rodolfo Giometti <giometti@linux.it>, Thomas Gleixner <tglx@linutronix.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>, Russell King <linux@arm.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 01, 2011 at 06:11:52PM -0800, john stultz wrote:
> On Thu, 2011-01-27 at 12:00 +0100, Richard Cochran wrote:
> > This patch adds support for the PTP clock found on the DP83640.
> > The basic clock operations and one external time stamp have
> > been implemented.
> > 
> > Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
> 
> Acked-by: John Stultz <johnstul@us.ibm.com>

I am going to post the PHC patches one more time, and I want to expand
this driver to support mutiple PHYs. So, I would ask you to please
take a second look at this driver then.

Thanks,

Richard
