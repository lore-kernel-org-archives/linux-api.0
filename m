From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Tue, 14 Jul 2015 13:50:43 +0200
Message-ID: <20150714115043.GB31973@amd>
References: <1430949612-21356-1-git-send-email-zab@redhat.com>
 <20150507002617.GJ4327@dastard>
 <20150507172053.GA659@lenny.home.zabbo.net>
 <alpine.DEB.2.00.1505071752520.28239@cobra.newdream.net>
 <21836.51274.843585.839614@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <21836.51274.843585.839614@quad.stoffel.home>
Sender: linux-kernel-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Sage Weil <sage@newdream.net>, Zach Brown <zab@redhat.com>, Dave Chinner <david@fromorbit.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


> Sage> I think this is the fundamental question: who do we give the
> Sage> ammunition to, the user or app writer, or the sysadmin?
> 
> Sage> One might argue that we gave the user a similar power with
> Sage> O_NOATIME (the power to break applications that assume atime is
> Sage> accurate).  Here we give developers/users the power to not
> Sage> update mtime and suffer the consequences (like, obviously,
> Sage> breaking mtime-based backups).  It should be pretty obvious to
> Sage> anyone using the flag what the consequences are.
> 
> Not modifying atime doesn't really break anything except people who
> think they can tell when a file was last accessed.  Which isn't
> critical (unless your in a paranoid security conscious place...) but
> MTIME is another beast entirely.   Turning that off is going to break
> lots of hidden assumptions.  
> 
> Sage> Note that we can suffer similar lapses in mtime with fdatasync
> Sage> followed by a system crash.  And as Andy points out it's
> Sage> semi-broken for writable mmap.  The crash case is obviously a
> Sage> slightly different thing, but the idea that mtime can't always
> Sage> be trusted certainly isn't crazy talk.
> 
> True, but after a crash... people expect and understand there might be
> corruption in a filesystem.

Umm. No; people do not expect anything newer than ext3 to get
corrupted, ever.

In fact, I did not know about fdatasync/crash. That's rather nasty
surprise.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
