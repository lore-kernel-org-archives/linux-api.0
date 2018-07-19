From: Christian Brauner <christian.brauner@canonical.com>
Subject: Re: [PATCH 0/6 v1 resend] statfs: handle mount propagation
Date: Thu, 19 Jul 2018 17:30:28 +0200
Message-ID: <20180719153027.GA21410@gmail.com>
References: <20180525124825.23875-1-christian@brauner.io>
 <20180613140625.GA31082@mailbox.org>
 <20180613142454.GA1845@kroah.com>
 <20180613150702.GA5403@mailbox.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180613150702.GA5403@mailbox.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de, kstewart@linuxfoundation.org, pombredanne@nexb.com, linux-api@vger.kernel.org, ebiederm@xmission.com, seth.forshee@canonical.com, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

On Wed, Jun 13, 2018 at 05:07:02PM +0200, Christian Brauner wrote:
> On Wed, Jun 13, 2018 at 04:24:54PM +0200, Greg KH wrote:
> > On Wed, Jun 13, 2018 at 04:06:25PM +0200, Christian Brauner wrote:
> > > On Fri, May 25, 2018 at 02:48:19PM +0200, Christian Brauner wrote:
> > > > From: Christian Brauner <christian.brauner@ubuntu.com>
> > > > 
> > > > Hey,
> > > > 
> > > > This is v1 of this patchset. All changes from v0 to v1 are non-functional.
> > > > Specifically, the commit messages and justification have been extended as
> > > > requested by Linus and Al.
> > > 
> > > Hey everyone,
> > > 
> > > Just a ping whether the requested changes have made this series suitable
> > > for inclusion. Would be excellent if someone could do another review. :)
> > 
> > It's the middle of the merge window, no new code gets accepted right
> > now, so just wait until next week at the _earliest_ before worrying
> 
> Ok, sorry. It was just that this was sent out before well over a month
> ago and I was just worried that it had been overlooked.

Hey everyone,

It's been a few weeks. I just wanted to check whether the changes made
to the series would make it suitable for inclusion. I checked against
current master and it should still apply cleanly.

Thanks!
Christian

> 
> Thanks!
> Christian
> 
> > about someone reviewing this.
> > 
> > thanks,
> > 
> > greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
