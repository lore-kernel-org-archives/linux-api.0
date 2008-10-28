From: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v7][PATCH 2/9] General infrastructure for checkpoint
	restart
Date: Tue, 28 Oct 2008 13:33:22 -0500
Message-ID: <20081028183322.GA13684@us.ibm.com>
References: <48FE82DF.6030005@cs.columbia.edu> <20081022152804.GA23821@us.ibm.com> <48FF4EB2.5060206@cs.columbia.edu> <87tzayh27r.wl%peter@chubb.wattle.id.au> <49059FED.4030202@cs.columbia.edu> <1225125752.12673.79.camel@nimitz> <4905F648.4030402@cs.columbia.edu> <1225140705.5115.40.camel@enoch> <490637D8.4080404@cs.columbia.edu> <1225145373.12673.125.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1225145373.12673.125.camel@nimitz>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Chubb <peterc-M3ycANVxPotyL3EAZA59ERCuuivNXqWP@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Dave Hansen (dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org):
> On Mon, 2008-10-27 at 17:51 -0400, Oren Laadan wrote:
> > >       Instead, how about a flag to sys_checkpoint() -- DO_RISKY_CHECKPOINT --
> > > which checkpoints despite !may_checkpoint?
> > 
> > I also agree with Matt - so we have a quorum :)
> > 
> > so just to clarify: sys_checkpoint() is to fail (with what error ?) if the
> > deny-checkpoint test fails.
> > 
> > however, if the user is risky, she can specify CR_CHECKPOINT_RISKY to force
> > an attempt to checkpoint as is.
> 
> This sounds like an awful lot of policy to determine *inside* the
> kernel.  Everybody is going to have a different definition of risky, so
> this scheme will work for approximately 5 minutes until it gets
> patched. :)
> 
> Is it possible to enhance our interface such that users might have some
> kind of choice on these matters?

Well we could always just add a field to /proc/self/status, and let
userspace check that field (after freezing the task) for the
presence of CR_CHECKPOINT_RISKY and make up its own mind.

Though my preference is for simplicity - just refuse the checkpoint.
That way people might screan loudly enough for us to support the
features they want.  If we let them just bypass and hope for the
best that starts to dilute some of the intended effect of all this.

-serge
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
