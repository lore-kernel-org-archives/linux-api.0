From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 00/13][V3] kexec: A new system call to allow in
 kernel loading
Date: Fri, 6 Jun 2014 14:04:50 -0400
Message-ID: <20140606180450.GI1526@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <20140603131203.GA23395@redhat.com>
 <20140604092214.GA17528@dhcp-17-89.nay.redhat.com>
 <20140604175031.GA4406@redhat.com>
 <CAHO5Pa0dxpq7YNe5eUMPE9Mn5m7XCnB1C5mZxrvt2-OqOpVZAA@mail.gmail.com>
 <20140605140416.GB17389@redhat.com>
 <5391556D.6090204@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5391556D.6090204-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: WANG Chao <chaowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, Greg Kroah-Hartman <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 06, 2014 at 07:45:17AM +0200, Michael Kerrisk (man-pages) wrote:
> On 06/05/2014 04:04 PM, Vivek Goyal wrote:
> > On Wed, Jun 04, 2014 at 09:39:10PM +0200, Michael Kerrisk wrote:
> >> Vivek,
> >>
> >> As per Documentation/SubmitChecklist , please CC linux-api@ on patces
> >> that change the ABI/API. See
> >> https://www.kernel.org/doc/man-pages/linux-api-ml.html.
> > 
> > Hi Michael,
> > 
> > Sorry, I did not notice that. I will CC linux-api@ in next version of
> > patches in patches which introduce new systemcal..
> > 
> >>
> >> Also, is there some draft man page for this new system call?
> > 
> > No, there is none yet. In fact I don't see a man page for old kexec
> > system call either kexec_load().
> 
> Is this not what you are meaning:
> http://man7.org/linux/man-pages/man2/kexec_load.2.html
> ?
> (It probably could be improved...)

Yep. I missed it.

> 
> > Do you want me to write man page for this new syscall?
> 
> These days, that's considered a desirable accompaniment to new 
> syscall proposals.

Ok, I will write one for kexec_file_load() too. Or extend the existing
one to include both syscalls.

Thanks
Vivek
