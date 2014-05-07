From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] MAINTAINERS: Add linux-api for review of API/ABI changes
Date: Wed, 07 May 2014 11:00:43 -0700
Message-ID: <1399485643.2911.12.camel@joe-AO725>
References: <20140506205953.GA16997@jtriplet-mobl1>
	 <5369C37A.1000001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5369C37A.1000001@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>
List-Id: linux-api@vger.kernel.org

On Wed, 2014-05-07 at 07:24 +0200, Michael Kerrisk (man-pages) wrote:
> On 05/06/2014 10:59 PM, Josh Triplett wrote:
> > This makes it more likely that patch submitters will CC API/ABI changes
> > to the linux-api list, and tools like get_maintainer.pl will do so
> > automatically.
> > 
> > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> > Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Every little bit helps, I guess. However, what I think would make a difference
> is if if people constantly posted reminders to CC linux-api when they see API/API
> changes on the lists. (And the reminders should of course CC linux-api).
[]
> > diff --git a/MAINTAINERS b/MAINTAINERS
[]
> > +ABI/API
> > +L:	linux-api@vger.kernel.org
> > +F:	Documentation/ABI/
> > +F:	include/linux/syscalls.h
> > +F:	include/uapi/
> > +F:	kernel/sys_ni.c

Perhaps this should have a
	"S:	Odd Fixes"
line too.
