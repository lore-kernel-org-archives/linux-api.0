From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Tue, 14 Jul 2015 15:13:00 +0200
Message-ID: <20150714131300.GA6804@amd>
References: <alpine.DEB.2.00.1505081517470.28239@cobra.newdream.net>
 <CAHQdGtTFTN2XuvmarFZ9HPQV=cuhh7FosdHSrJME_U4htr=i8w@mail.gmail.com>
 <20150511144719.GA14088@thunk.org>
 <alpine.DEB.2.00.1505110920520.28239@cobra.newdream.net>
 <20150511231021.GC14088@thunk.org>
 <20150512050821.GA9404@chicago.guarana.org>
 <5551E7EB.8040301@gmail.com>
 <21842.1555.38099.868100@quad.stoffel.home>
 <20150512143637.GA6370@fieldses.org>
 <20150513083951.5eb63bc0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150513083951.5eb63bc0-wvvUuzkyo1EYVZTmpyfIwg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, John Stoffel <john-HgN6juyGXH5AfugRpC6u6w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kevin Easton <kevin-RFfraI6bZkdAfugRpC6u6w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi!

> BTW When you "swap" to a file the mtime doesn't get updated.  No one seems to
> complain about that.  I guess it is a rather narrow use-case though.

Actually yes, I'd like to complain.

It was not swap, it was mount -o loop, but I guess that's the same
case. Then rsync refused to work on that file... and being on slow ARM
system it took me a while to figure out WTF is going on.

So yes, we have problems with mtime, and yes, they matter.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
