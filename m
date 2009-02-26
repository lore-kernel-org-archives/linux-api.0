From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [patch 0/3] add rt_tgsigqueueinfo syscall [RESEND]
Date: Thu, 26 Feb 2009 23:13:33 +0100 (CET)
Message-ID: <alpine.LFD.2.00.0902262311350.9135@localhost.localdomain>
References: <20090226133339.875832967@linutronix.de> <cfd18e0f0902261319v20ba7bd1pcc91ccc4b2c7d577@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cfd18e0f0902261319v20ba7bd1pcc91ccc4b2c7d577-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-6lXkIZvqkOAvJsYlp49lxw@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Michael,

On Fri, 27 Feb 2009, Michael Kerrisk wrote:
> I haven't looked at this iteration of the patch, to check if it is
> different from the version you posted a few months ago.  I assume it
> isn't different, since you didn't mention any differences.  In that
> case, there are still the questions I raised back then, so I'll just
> repeat them now.

Right, no fundamental changes.
 
> Back in October, I did some testing of this interface.  Two potential
> issues that I saw, both of which relate to inconsistencies with
> rt_sigqueueinfo():
> 
> 1) With rt_siqueueinfo(), we can get the PID (TGID) of the sender,
> which enables the receiver of the signal to know who the sender was,
> and perhaps use that information to (for example) send a signal in the
> other direction.
> 
> With rt_tgsigqueueinfo(), we don't quite have that ability: all that
> the receiver gets is the TGID of the sender, not the TID.  This means
> that we can't (for example) send a signal back to the precise thread
> that signaled us. I'm not sure if this matters or not (but perhaps it
> might when sender and receiver are in the same process?).  I'm also
> not sure whether we want to do anything about this (i.e., extending
> siginfo_t to include a si_tid field), but I wanted to point out this
> assymetry w.r.t. to rt_sigqueueinfo(), in case you had not considered
> it.
> 
> 2) With rt_sigqueueinfo(), we can specify the si_pid and and si_uid
> fields that should be sent to the receiver.  This is not possible with
> rt_tgsigqueueinfo(), which always supplied the caller';s PID and UID
> in the si_pid and si_uid fields sent to the receiver.  See the
> following, created using my test programs below (the 111 & 222
> arguments to t_*sigqueueinfo set the si_pid and si_uid fields in the
> siginfo_t given to the *sigqueueinfo() syscall):

I can see your concern, but I have no strong opinion in either
direction. 

Roland ??

Thanks,

	tglx
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
