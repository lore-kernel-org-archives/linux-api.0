From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 24/24] debugfs: Restrict debugfs when the kernel is
 locked down
Date: Thu, 12 Apr 2018 10:23:13 +0200
Message-ID: <20180412082313.GA6054@kroah.com>
References: <20180411195436.GA7126@kroah.com>
 <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
 <152346403637.4030.15247096217928429102.stgit@warthog.procyon.org.uk>
 <12769.1523477356@warthog.procyon.org.uk>
 <20180411203308.GA10167@kroah.com>
 <CALCETrWynogzZcaKMLWKce1rMvAC_sViReBDyiEWL-rm21HvAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWynogzZcaKMLWKce1rMvAC_sViReBDyiEWL-rm21HvAg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: David Howells <dhowells@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, James Morris <jmorris@namei.org>, LKML <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 11, 2018 at 07:54:12PM -0700, Andy Lutomirski wrote:
> On Wed, Apr 11, 2018 at 1:33 PM, Greg KH <greg@kroah.com> wrote:
> > On Wed, Apr 11, 2018 at 09:09:16PM +0100, David Howells wrote:
> >> Greg KH <greg@kroah.com> wrote:
> >>
> >> > Why not just disable debugfs entirely?  This half-hearted way to sorta
> >> > lock it down is odd, it is meant to not be there at all, nothing in your
> >> > normal system should ever depend on it.
> >> >
> >> > So again just don't allow it to be mounted at all, much simpler and more
> >> > obvious as to what is going on.
> >>
> >> Yeah, I agree - and then I got complaints because it seems that it's been
> >> abused to allow drivers and userspace components to communicate.
> >
> > With in-kernel code?  Please let me know and I'll go fix it up to not
> > allow that, as that is not ok.
> >
> > I do know of some bad examples of out-of-tree code abusing debugfs to do
> > crazy things (battery level monitoring?), but that's their own fault...
> >
> > debugfs is for DEBUGGING!  For anything you all feel should be "secure",
> > then just disable it entirely.
> >
> 
> Debugfs is very, very useful for, ahem, debugging.  I really think
> this is an example of why we should split lockdown into the read and
> write varieties and allow mounting and reading debugfs when only write
> is locked down.

Ok, but be sure that there are no "secrets" in those debugging files if
you really buy into the whole "lock down" mess...

Really, it's easier to just disable the whole thing.

greg k-h
