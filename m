From: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC v13][PATCH 00/14] Kernel based checkpoint/restart
Date: Thu, 12 Feb 2009 15:13:53 -0800
Message-ID: <1234480433.30155.226.camel@nimitz>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
	 <1234285547.30155.6.camel@nimitz>
	 <20090211141434.dfa1d079.akpm@linux-foundation.org>
	 <1234462282.30155.171.camel@nimitz>  <1234467035.3243.538.camel@calx>
	 <1234479457.30155.214.camel@nimitz>  <1234479924.3152.13.camel@calx>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1234479924.3152.13.camel@calx>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Cedric Le Goater <clg-NmTC/0ZBporQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2009-02-12 at 17:05 -0600, Matt Mackall wrote:
> On Thu, 2009-02-12 at 14:57 -0800, Dave Hansen wrote:
> > > Also, what happens if I checkpoint a process in 2.6.30 and restore it in
> > > 2.6.31 which has an expanded idea of what should be restored? Do your
> > > file formats handle this sort of forward compatibility or am I
> > > restricted to one kernel?
> > 
> > In general, you're restricted to one kernel.  But, people have mentioned
> > that, if the formats change, we should be able to write in-userspace
> > converters for the checkpoint files.  
> 
> I mentioned this because it seems like a key use case is upgrading
> kernels out from under long-lived applications.

The key users as I envision it aren't really kernel hackers who are
always running 2.6-next and running radically different kernels from
moment to moment. :)

Distros are pretty picky about changing things internal to the kernel
during errata updates or even service packs.  While that can be a pain
for some of us developers trying to get features and fixes in, it is a
godsend for trying to do something like process migration across an
update.

My random speculation would be that for things that if a kernel upgrade
can be performed with ksplice (http://www.ksplice.com/) -- the original
non-fancy version at least -- we can probably migrate across the
upgrade.

-- Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
