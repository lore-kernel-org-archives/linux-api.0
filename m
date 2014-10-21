From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the
 kernel
Date: Tue, 21 Oct 2014 22:05:22 +0200
Message-ID: <20141021200522.GB2969@amd>
References: <20141016124741.GA3832@kroah.com>
 <20141016231221.GA13592@kroah.com>
 <20141021103622.GB23161@amd>
 <4227199.e5u61J7jtX@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4227199.e5u61J7jtX@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Santosh Shilimkar <santosh.shilimkar-l0cyMroinI0@public.gmane.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rebecca Schultz Zavin <rebecca-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Anup Patel <anup.patel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue 2014-10-21 16:12:24, Arnd Bergmann wrote:
> On Tuesday 21 October 2014 12:36:22 Pavel Machek wrote:
> > On Fri 2014-10-17 01:12:21, Greg Kroah-Hartman wrote:
> > > On Thu, Oct 16, 2014 at 10:09:04AM -0700, John Stultz wrote:
> > > > On Thu, Oct 16, 2014 at 5:47 AM, Greg Kroah-Hartman
> > > > <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> > > > > From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> > 
> > > > Are the Android guys comfortable with the ABI stability rules they'll
> > > > now face?
> > > 
> > > Just because something is in staging, doesn't mean you don't have to
> > > follow the same ABI stability rules as the rest of the kernel.  If a
> > > change had happened to this code that broke userspace in the past, I
> > > would have reverted it.  So this should not be anything different from
> > > what has been happening inthe past.
> > 
> > Actually, there's big difference.
> > 
> > If Al Viro changes core filesystem in a way that breaks
> > staging/binder, binder is broken, and if it can't be fixed... well it
> > can't be fixed.
> > 
> > If Al Viro changes core filesystem in a way that breaks
> > drivers/binder, Al's change is going to be reverted.
> 
> One might have argued that we'd have to do that already, but the reasons
> for doing that with binder in the main kernel are certainly stronger.
> 
> > It is really hard to review without API documentation. Normally, API
> > documentation is required for stuff like this.
> > 
> > For example: does it add new files in /proc?
> > 
> > Given that it is stable, can we get rid of binder_debug() and
> > especially BINDER_DEBUG_ENTRY stuff?
> 
> Good point. We require documentation for every single sysfs attribute
> that gets added to a driver (some escape the review, but that doesn't
> change the rule), so we should not make an exception for a new procfs
> file here.

Actually, it looked like it is debugfs file. Code was messy enough
that I was not sure.

> > Could binder_transcation() be split to smaller functions according to
> > CodingStyle? 17 goto targets at the end of function are not exactly
> > easy to read.
> > 
> > ginder_thread_read/write also needs splitting.
> 
> Yes, in principle, but this is still a detail that would mainly serve
> to simplify review. The problem is more the lack of review and
> documentation of the API.

Yes, the problem is that code is impossible to review without API
documentation.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
