From: Karol Lewandowski <lmctlx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 0/5] kdbus: add support for lsm
Date: Sun, 9 Nov 2014 01:07:57 +0100
Message-ID: <20141109000757.GA23762@pix>
References: <54539AF3.6060302@samsung.com>
 <1414773397-26490-1-git-send-email-k.lewandowsk@samsung.com>
 <20141107180120.GA15387@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141107180120.GA15387-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, desrt-0xnayjDhYQY@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, casey.schaufler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, r.krypa-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 07, 2014 at 10:01:20AM -0800, Greg KH wrote:
> On Fri, Oct 31, 2014 at 05:36:32PM +0100, Karol Lewandowski wrote:
> > This is set of EXPERIMENTAL patches adding lsm support to kdbus.
> > (Rebased on top of v3.17.)
> > 
> > >From least to most invasive:
> > 
> >  - (1) kdbus: extend structures with security pointer for lsm
> > 
> >    Trivial.  Applicable as-is.
> > 
> >  - (2) security: export security_file_receive for modules
> >    (3) kdbus: check if lsm permits installing received fds
> > 
> >    fd_install doesn't seem to consult LSM, these patches
> >    ensure that receiving process has the right to sent fds. 
> > 
> >    Compile-tested only.
> > 
> >  - (4) security: introduce lsm hooks for kdbus
> >    (5) kdbus: make use of new lsm hooks
> > 
> >    Set of proof-of-concept hooks discussed previously with Paul Moore.
> > 
> >    kdbus integration patch (5) for review, but unlikely for integration
> >    at this stage.
> > 
> >    Likewise, compile-tested only.
> > 
> > 
> > Karol Lewandowski (5):
> >   kdbus: extend structures with security pointer for lsm
> >   security: export security_file_receive for modules
> >   kdbus: check if lsm permits installing received fds
> >   security: introduce lsm hooks for kdbus
> >   kdbus: make use of new lsm hooks
> 
> These looks reasonable to me, thanks for sending them.  They will need
> to be refreshed again after this next round of changes, but it shouldn't
> be that hard to do so.

Sure thing.

For completness - there are accompanying Smack and SELinux patches that
could go together with above patches, ie.

  https://github.com/lmctl/linux/commit/103c26fd27d1ec8c32d85dd3d85681f936ac66fb

  http://git.infradead.org/users/pcmoore/selinux/commitdiff/eef4844f91fef6092b6bfac941ebe7f18375be9d

I've got some free time on my hands now, so I'll try to revisit these too.

Cheers,
Karol Lewandowski
