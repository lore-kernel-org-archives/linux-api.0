From: Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
Subject: Re: kdbus: add code for buses, domains and endpoints
Date: Thu, 30 Oct 2014 15:48:56 +0100
Message-ID: <20141030144855.GA9705@dztty>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
 <8738a6w6kv.fsf@x220.int.ebiederm.org>
 <20141030095854.GA4716@dztty>
 <87wq7hiwjb.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87wq7hiwjb.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, desrt-0xnayjDhYQY@public.gmane.org, hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 30, 2014 at 05:15:04AM -0700, Eric W. Biederman wrote:
> Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org> writes:
> 
> > On Wed, Oct 29, 2014 at 08:59:44PM -0700, Eric W. Biederman wrote:
> >> Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> writes:
> >> 
> >> The way capabilities are checked in this patch make me very nervous.
> >> 
> >> We are not checking permissions at open time.  Every other location
> >> of calling capable on file like objects has been show to be suceptible
> >> to file descriptor pass attacks.
> > Yes, I do understand the concern, this is valid for some cases! but we
> > can't apply it on the ioctl API ?! please see below:
> >
> > All (perhaps not all) the current ioctl do not check for fd passing
> > attacks! if a privileged do arbitrary ioctl on untrusted fds we are
> > already owned... the dumb privileged process is the one to blame, right?
> >
> >
> > Example:
> > 1) fs/ext4/ioctl.c:ext4_ioctl()
> >    they have:
> >    inode_owner_or_capable() + capable() checks
> >
> >    for all the restricted ioctl()
> >
> > 2) fs/xfs/xfs_ioctl.c:xfs_file_ioctl()
> >    they have:
> >    capable() checks
> >
> > 3) fs/btrfs/ioctl.c:btrfs_ioctl()
> >    they have capable() + inode_owner_or_capable()
> >
> > ... long list
> >
> > These are sensible API and they do not care at all about fd passing,
> > so I don't think we should care either ?! or perhaps I'm missing
> > something ?
> 
> - It is an easy mistake to make.
> - We have not performed extensive audits of the capable calls at this
>   time to veryify that fd passing is safe.
> - Unless it is egregious we are likely to grandfather the existing usage
>   in to avoid breaking userspace.
> 
> None of that is an excuse for kdbus to get it wrong once it has been
> pointed out in review.
Of course! but our goal here is not to produce some sort of new
capability checks or new security mechanisms in this field. We want to
follow what other API are doing and be consistent. So every one who reads
the code can understand it, it is the standard API, the standard scheme
used in every crucial part of the kernel. If there is really some sort
of proven bugs affecting these ioctl() API say in ext4, btrfs or other
devices, in this case we need to follow and update, we have too!


> > The capable() is done as it is, and for the inode_owner_or_capable() you
> > will notice that we followed the same logic and did use it in our
> > kdbus_bus_uid_is_privileged() to stay safe and follow what other API are
> > doing.
> 
> What others are doing makes it very hard to safely use allow those
> ioctls in a tightly sandboxed application, as it is unpredictable
> what the sandboxed ioctl can do with the file descriptor.
> 
> Further an application that calls setresuid at different times during
> it's application will behave differently.  Which makes ioctls that do
> not have consistent behavior after open time inappropriate for use in
> userspace libraries.
We are consistent in our checks, you say that the application will
behave differently when it calls setresuid() sure! If it changes its
creds then regain of course it will behave differently! and the checks
are here to make sure that setresuid() and alike work correctly when the
application changes its creds and calls-in.

Thanks!

-- 
Djalal Harouni
http://opendz.org
