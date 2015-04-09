From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH v2 0/7] CLONE_FD: Task exit notification via file
 descriptor
Date: Wed, 8 Apr 2015 19:19:49 -0700
Message-ID: <20150409021948.GA1027@jtriplet-mobl1>
References: <cover.1426376419.git.josh@joshtriplett.org>
 <20150331220807.6927e780@lwn.net>
 <20150331220224.GA22707@cloud>
 <20150401092420.4c1dbb6e@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150401092420.4c1dbb6e-T1hC0tSOHrs@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 01, 2015 at 09:24:20AM +0200, Jonathan Corbet wrote:
> On Tue, 31 Mar 2015 15:02:24 -0700
> josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org wrote:
> 
> > > This would appear to assume that a clonefd_info structure is the only
> > > thing that will ever be read from this descriptor.  It seems to me that
> > > there is the potential for, someday, wanting to be able to read and write
> > > other things as well.  Should this structure be marked with type and
> > > length fields so that other structures could be added in the future?  
> > 
> > I don't think it makes sense for a caller to get an arbitrary structure
> > on read(), and have to figure out what they got and ignore something
> > they don't understand.  Instead, I think it makes more sense for the
> > caller to say "Hey, here's a flag saying I understand the new thing, go
> > ahead and give me the new thing".  So, for instance, if you want to
> > receive SIGSTOP/SIGCONT messages for child processes through this
> > descriptor, we could add a flag for that.
> 
> The flag is fine, but, once we have set that flag saying we want those
> messages, how do we know which type of structure we've gotten?  That's
> the piece of the puzzle I'm missing, sorry if I'm being overly slow.

If you pass a flag saying you can handle a new set of potential
structures, those structures can then include any necessary
disambiguating flags/IDs/etc.  No need for them to match the current
clonefd_info structure if userspace has opted into a new version.

- Josh Triplett
