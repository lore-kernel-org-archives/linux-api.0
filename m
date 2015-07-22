From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Wed, 22 Jul 2015 15:47:13 +0200
Message-ID: <20150722134713.GB20106@amd>
References: <20150511144719.GA14088@thunk.org>
 <alpine.DEB.2.00.1505110920520.28239@cobra.newdream.net>
 <20150511231021.GC14088@thunk.org>
 <20150512050821.GA9404@chicago.guarana.org>
 <5551E7EB.8040301@gmail.com>
 <21842.1555.38099.868100@quad.stoffel.home>
 <20150512143637.GA6370@fieldses.org>
 <20150513083951.5eb63bc0@notabene.brown>
 <20150714131300.GA6804@amd>
 <20150715145456.0376796b@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150715145456.0376796b@noble>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: NeilBrown <neilb-IBi9RG/b67k@public.gmane.org>
Cc: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, John Stoffel <john-HgN6juyGXH5AfugRpC6u6w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kevin Easton <kevin-RFfraI6bZkdAfugRpC6u6w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed 2015-07-15 14:54:56, NeilBrown wrote:
> On Tue, 14 Jul 2015 15:13:00 +0200 Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org> wrote:
> 
> > Hi!
> > 
> > > BTW When you "swap" to a file the mtime doesn't get updated.  No one seems to
> > > complain about that.  I guess it is a rather narrow use-case though.
> > 
> > Actually yes, I'd like to complain.
> > 
> > It was not swap, it was mount -o loop, but I guess that's the same
> > case. Then rsync refused to work on that file... and being on slow ARM
> > system it took me a while to figure out WTF is going on.
> > 
> > So yes, we have problems with mtime, and yes, they matter.
> > 									Pavel
> 
> Odd...
> I assume you mean
>   mount -o loop /some/file  /mountpoint
> 
> and then when you write to the filesystem on /mountpoint the mtime
> of /some/file doesn't get updated?
> I think it should.
>  drivers/block/loop.c uses vfs_iter_write() to write to a file.
>  That calls f_op->write_iter which will typically call
>  generic_file_write_iter() which will call file_update_time() to update
>  the time stamps.

Yes, that. I'm pretty sure I seen it, but it was probably on 2.6.X
kernel... Does it make sense to try to reproduce it on the old kernel?

> What filesystem was /some/file on?

Very probably VFAT.

> I just did some testing on ext4 and it seems to do the right thing
> mtime gets updated.

Yes, I tried here, and it seems to be ok.

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
