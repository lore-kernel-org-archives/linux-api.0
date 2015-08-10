From: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Subject: Re: [PATCH 2/3] kobject: export kset_find_obj() to be used from
 modules
Date: Mon, 10 Aug 2015 15:04:42 -0400
Message-ID: <20150810190442.GO31816@HEDWIG.INI.CMU.EDU>
References: <cover.1439220623.git.somlo@cmu.edu>
 <5c2bafb073e1386e39c4f73a83e7d835547b6b1f.1439220623.git.somlo@cmu.edu>
 <20150810183304.GC18817@kroah.com>
 <20150810184310.GM31816@HEDWIG.INI.CMU.EDU>
 <20150810185400.GC19646@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150810185400.GC19646-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, paul-DWxLp4Yu+b8AvxtiuMwx3w@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gleb-RmZWMc9puTNJc61us3aD9laTQe2KTcn/@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kernelnewbies-7JyXY6prKcjpASu1u0TL5ti2O/JbrIOy@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Aug 10, 2015 at 11:54:00AM -0700, Greg KH wrote:
> On Mon, Aug 10, 2015 at 02:43:10PM -0400, Gabriel L. Somlo wrote:
> > On Mon, Aug 10, 2015 at 11:33:04AM -0700, Greg KH wrote:
> > > On Mon, Aug 10, 2015 at 12:31:19PM -0400, Gabriel L. Somlo wrote:
> > > > From: "Gabriel Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
> > > > 
> > > > Signed-off-by: Gabriel Somlo <somlo-D+Gtc/HYRWM@public.gmane.org>
> > > > ---
> > > >  lib/kobject.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/lib/kobject.c b/lib/kobject.c
> > > > index 3e3a5c3..f9754a0 100644
> > > > --- a/lib/kobject.c
> > > > +++ b/lib/kobject.c
> > > > @@ -1058,3 +1058,4 @@ EXPORT_SYMBOL(kobject_del);
> > > >  
> > > >  EXPORT_SYMBOL(kset_register);
> > > >  EXPORT_SYMBOL(kset_unregister);
> > > > +EXPORT_SYMBOL(kset_find_obj);
> > > 
> > > checkpatch doesn't like this for obvious reasons :)
> > 
> > When I run checkpatch on this one, it comes back fine. Could you
> > please elaborate ?
> > 
> > [staging]$ scripts/checkpatch.pl
> > 0002-kobject-export-kset_find_obj-to-be-used-from-modules.patch 
> > total: 0 errors, 0 warnings, 4 lines checked
> > 
> > 0002-kobject-export-kset_find_obj-to-be-used-from-modules.patch has no
> > obvious style problems and is ready for submission.
> 
> EXPORT_SYMBOL() should be below the function definition itself, not at
> the bottom of the file.  Odd that checkpatch doesn't catch this when
> done in this manner, it will if you run it on the whole file after your
> patch is applied (along with the existing problems.)

Got it, fix lined up for v2

> But this is a minor issue, see my other review first...

Yeah, but it was the low hanging fruit, so I replied to it first ;)

Thanks much,
--Gabriel
