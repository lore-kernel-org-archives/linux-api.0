From: Pavel Machek <pavel@ucw.cz>
Subject: Andoid Binder sneaking in [was Re: [GIT PULL] Staging driver patches
 for 3.19-rc1]
Date: Sun, 28 Dec 2014 18:53:16 +0100
Message-ID: <20141228175316.GC3922@amd>
References: <20141215175535.GA4665@kroah.com>
 <CAFLxGvwvj_ihWQQV3yY8Czxt0F2ieP=CRBrPMKqUatpjj9zdvQ@mail.gmail.com>
 <20141215183915.GA15554@infradead.org>
 <20141215184103.GA6761@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20141215184103.GA6761@kroah.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Richard Weinberger <richard.weinberger@gmail.com>, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, arve@android.com, john.stultz@linaro.org, viro@zeniv.linux.org.uk, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Mon 2014-12-15 10:41:03, Greg KH wrote:
> On Mon, Dec 15, 2014 at 10:39:15AM -0800, Christoph Hellwig wrote:
> > On Mon, Dec 15, 2014 at 07:23:35PM +0100, Richard Weinberger wrote:
> > > I don't understand this kind of logic.
> > > a) Binder is considered a piece of shite.
> > > b) Google is working on a (hopefully sane) replacement.
> > > 
> > > Why moving it out of staging then? What is the benefit?
> > 
> > There is none, and Greg didn't even bother addressing the various
> > comments when this first came up.
> 
> I thought I did, it was a long thread at the time, and I was on the road
> for 3 weeks, sorry if I missed something.

I pointed quite a lot of simple cleanups that could be done, but got
no feedback...

You should really post new version for review to people that commented
on the old one.

Plus "I set a rule that code must be cleaned in staging, and this is
not happening here, so it has to be moved to mainline, ignoring all
the usual rules" is quite interesting justification.

> > So a clear NAK from me on this one.
> 
> You don't have to maintain it, I do, so why does it concern you?

You ignored even NAKs from people that maintain stuff this interfaces with.

Late NAK here, too, FWIW. Because it is going to be used as an
argument "it is in mainline, so it must be ok". You are willing to
ignore mainline rules for this; it should be way easier to ignore
single staging rule for this one.
									
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
