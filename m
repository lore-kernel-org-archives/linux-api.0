From: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v7][PATCH 2/9] General infrastructure for checkpoint
	restart
Date: Mon, 27 Oct 2008 16:20:36 -0500
Message-ID: <20081027212036.GA32162@us.ibm.com>
References: <20081021124130.a002e838.akpm@linux-foundation.org> <20081021202410.GA10423@us.ibm.com> <48FE82DF.6030005@cs.columbia.edu> <20081022152804.GA23821@us.ibm.com> <48FF4EB2.5060206@cs.columbia.edu> <87tzayh27r.wl%peter@chubb.wattle.id.au> <49059FED.4030202@cs.columbia.edu> <1225125752.12673.79.camel@nimitz> <4905F648.4030402@cs.columbia.edu> <1225140705.5115.40.camel@enoch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1225140705.5115.40.camel@enoch>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>, Peter Chubb <peterc-M3ycANVxPotyL3EAZA59ERCuuivNXqWP@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Matt Helsley (matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org):
> On Mon, 2008-10-27 at 13:11 -0400, Oren Laadan wrote:
> > Dave Hansen wrote:
> > > On Mon, 2008-10-27 at 07:03 -0400, Oren Laadan wrote:
> > >>> In our implementation, we simply refused to checkpoint setid
> > >> programs.
> > >>
> > >> True. And this works very well for HPC applications.
> > >>
> > >> However, it doesn't work so well for server applications, for
> > >> instance.
> > >>
> > >> Also, you could use file system snapshotting to ensure that the file
> > >> system view does not change, and still face the same issue.
> > >>
> > >> So I'm perfectly ok with deferring this discussion to a later time :)
> > > 
> > > Oren, is this a good place to stick a process_deny_checkpoint()?  Both
> > > so we refuse to checkpoint, and document this as something that has to
> > > be addressed later?
> > 
> > why refuse to checkpoint ?
> 
> 	If most setuid programs hold privileged resources for extended periods
> of time after dropping privileges then it seems like a good idea to
> refuse to checkpoint. Restart of those programs would be quite
> unreliable unless/until we find a nice solution.

I agree with Dave and Matt.  Let's assume that we have a setuid root
program which creates some resources then drops to username kooky.  If
you now checkpoint and restart that program, then a stupid restart will
either

	1. be done as user kooky and not be able to recreate the
	resources, fail.
	2. be done as user root and not drop uid back to kooky, unsafe.

For the earliest prototypes of c/r, I think saying that setuid an the
life of a container makes checkpoint impossible is the right thing to
do.

-serge
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
