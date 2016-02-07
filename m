From: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Subject: Re: [PATCH v8 2/4] kobject: export kset_find_obj() for module use
Date: Sun, 7 Feb 2016 09:27:24 -0500
Message-ID: <20160207142724.GA26236@GLSMBP.INI.CMU.EDU>
References: <1453990994-17801-1-git-send-email-somlo@cmu.edu>
 <1453990994-17801-3-git-send-email-somlo@cmu.edu>
 <20160207072423.GC16215@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160207072423.GC16215-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sudeep.holla-5wv7dgnIgG8@public.gmane.org, agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ehabkost-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, revol-GANU6spQydw@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Feb 06, 2016 at 11:24:23PM -0800, Greg KH wrote:
> On Thu, Jan 28, 2016 at 09:23:12AM -0500, Gabriel L. Somlo wrote:
> > From: Gabriel Somlo <somlo-D+Gtc/HYRWM@public.gmane.org>
> > 
> > Signed-off-by: Gabriel Somlo <somlo-D+Gtc/HYRWM@public.gmane.org>
> > ---
> >  lib/kobject.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/lib/kobject.c b/lib/kobject.c
> > index 7cbccd2..90d1be6 100644
> > --- a/lib/kobject.c
> > +++ b/lib/kobject.c
> > @@ -861,6 +861,7 @@ struct kobject *kset_find_obj(struct kset *kset, const char *name)
> >  	spin_unlock(&kset->list_lock);
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL(kset_find_obj);
> 
> EXPORT_SYMBOL_GPL() please here.  I'll edit it by hand if you don't want
> to resend the series.

If you don't mind editing, that'd be much appreciated!

I'll make sure and remember to use EXPORT_SYMBOL_GPL() for the next
chance I get... :)

Thanks much,
--Gabriel

> 
> thanks.
> 
> greg k-h
