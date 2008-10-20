From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Document kernel taint flags properly
Date: Mon, 20 Oct 2008 13:43:18 -0700
Message-ID: <20081020204318.GB21131@kroah.com>
References: <20081017225515.GA14133@kroah.com> <cfd18e0f0810180151v232f623pdbf0f12cad6532d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cfd18e0f0810180151v232f623pdbf0f12cad6532d6-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Oct 18, 2008 at 03:51:11AM -0500, Michael Kerrisk wrote:
> Greg,
> 
> Small corrections below.
> 
> On Fri, Oct 17, 2008 at 5:55 PM, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
> > From: Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>
> >
> > This fills in the documentation for all of the current kernel taint
> > flags, and fixes the number for TAINT_CRAP, which was incorrectly
> > described.
> >
> > Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Cc: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>
> >
> > ---
> >  Documentation/sysctl/kernel.txt |   24 +++++++++++++++++-------
> >  1 file changed, 17 insertions(+), 7 deletions(-)
> >
> > --- a/Documentation/sysctl/kernel.txt
> > +++ b/Documentation/sysctl/kernel.txt
> > @@ -363,11 +363,21 @@ tainted:
> >  Non-zero if the kernel has been tainted.  Numeric values, which
> >  can be ORed together:
> >
> > -  1 - A module with a non-GPL license has been loaded, this
> > -      includes modules with no license.
> > -      Set by modutils >= 2.4.9 and module-init-tools.
> > -  2 - A module was force loaded by insmod -f.
> > -      Set by modutils >= 2.4.9 and module-init-tools.
> > -  4 - Unsafe SMP processors: SMP with CPUs not designed for SMP.
> > - 64 - A module from drivers/staging was loaded.
> > +   1 - A module with a non-GPL license has been loaded, this
> > +       includes modules with no license.
> > +       Set by modutils >= 2.4.9 and module-init-tools.
> > +   2 - A module was force loaded by insmod -f.
> > +       Set by modutils >= 2.4.9 and module-init-tools.
> > +   4 - Unsafe SMP processors: SMP with CPUs not designed for SMP.
> > +   8 - A module was forcefully unloaded from the system by rmmod -f.
> 
> s/forcefully/forcibly/
> 
> > +  16 - A hardware machine check error occured on the system.
> 
> occurred

Thanks, I've updated this in my version.

Randy, I can send this through my tree, is that ok?  Or do you want it
to go through yours?

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
