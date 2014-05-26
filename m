From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 0/6] namespaces: log namespaces per task
Date: Mon, 26 May 2014 16:17:32 -0400
Message-ID: <20140526201732.GD8079@madcap2.tricolour.ca>
References: <cover.1400271129.git.rgb@redhat.com>
 <CAHO5Pa0EdUsV9jJuLbkmbvFyopecQiUDZd0UasAJ5kMhtsVxjQ@mail.gmail.com>
 <20140526165858.GC8079@madcap2.tricolour.ca>
 <CAKgNAkgfV5K6BWjibCVwzJE3GYfmAHNzk+aU05M0xEdrfZmzPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKgNAkgfV5K6BWjibCVwzJE3GYfmAHNzk+aU05M0xEdrfZmzPg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 14/05/26, Michael Kerrisk (man-pages) wrote:
> Hi Richard
> 
> On Mon, May 26, 2014 at 6:58 PM, Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On 14/05/22, Michael Kerrisk wrote:
> >> Richard,
> >
> > Hi Michael,
> >
> >> On Tue, May 20, 2014 at 3:12 PM, Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >> > The purpose is to track namespaces in use by logged processes from the
> >> > perspective of init_*_ns.
> >> >
> >> > 1/6 defines a function to generate them and assigns them.
> >> >
> >> > Use a serial number per namespace (unique across one boot of one kernel)
> >> > instead of the inode number (which is claimed to have had the right to change
> >> > reserved and is not necessarily unique if there is more than one proc fs).  It
> >> > could be argued that the inode numbers have now become a defacto interface and
> >> > can't change now, but I'm proposing this approach to see if this helps address
> >> > some of the objections to the earlier patchset.
> >> >
> >> > 2/6 adds access functions to get to the serial numbers in a similar way to
> >> > inode access for namespace proc operations.
> >> >
> >> > 3/6 implements, as suggested by Serge Hallyn, making these serial numbers
> >> > available in /proc/self/ns/{ipc,mnt,net,pid,user,uts}_snum.  I chose "snum"
> >> > instead of "seq" for consistency with inum and there are a number of other uses
> >> > of "seq" in the namespace code.
> >> >
> >> > 4/6 exposes proc's ns entries structure which lists a number of useful
> >> > operations per namespace type for other subsystems to use.
> >>
> >> Since the 3 and 4 change the ABI, please CC iterations of this patch
> >> series to linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, as per Documentation/SubmitChecklist.
> >
> > Neither patch 3/6 nor 4/6 changes the syscall interface.
> 
> (Agreed.)
> 
> > Patch 3/6 adds /proc/<pid>/ns/ entries, which looks more like #16 in
> > that document (for which /proc/<pid>/ns/<nstype> was never added).
> 
> But, that's a change to the surface that the kernel exposes to user
> space, right? If so, it is best CCed to linux-api.

Got it.  Thanks!

> Thanks,
> 
> Michael

- RGB

--
Richard Guy Briggs <rbriggs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
