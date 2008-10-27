From: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Subject: Re: [RFC v7][PATCH 2/9] General infrastructure for checkpoint	restart
Date: Mon, 27 Oct 2008 07:03:09 -0400
Message-ID: <49059FED.4030202@cs.columbia.edu>
References: <1224481237-4892-1-git-send-email-orenl@cs.columbia.edu>	<1224481237-4892-3-git-send-email-orenl@cs.columbia.edu>	<20081021124130.a002e838.akpm@linux-foundation.org>	<20081021202410.GA10423@us.ibm.com>	<48FE82DF.6030005@cs.columbia.edu>	<20081022152804.GA23821@us.ibm.com>	<48FF4EB2.5060206@cs.columbia.edu> <87tzayh27r.wl%peter@chubb.wattle.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87tzayh27r.wl%peter-LkDQP0DxSMGxwJ88Py/mJxCuuivNXqWP@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Chubb <peterc-M3ycANVxPotyL3EAZA59ERCuuivNXqWP@public.gmane.org>
Cc: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-api@vger.kernel.org



Peter Chubb wrote:
>>>>>> "Oren" == Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org> writes:
> 
> 
> Oren> Nope, since we will fail to restart in many cases. We will need
> Oren> a way to move from caller's credentials to saved credentials,
> Oren> and even from caller's credentials to privileged credentials
> Oren> (e.g. to reopen a file that was created by a setuid program
> Oren> prior to dropping privileges).
> 
> You can't necessarily tell the difference between this and revocation
> of privilege.  For most security models, it must be possible to change
> the permissions on the file, and then the restart should fail.
> 
> In our implementation, we simply refused to checkpoint setid programs.

True. And this works very well for HPC applications.

However, it doesn't work so well for server applications, for instance.

Also, you could use file system snapshotting to ensure that the file
system view does not change, and still face the same issue.

So I'm perfectly ok with deferring this discussion to a later time :)

Oren.

> --
> Dr Peter Chubb  http://www.gelato.unsw.edu.au  peterc AT gelato.unsw.edu.au
> http://www.ertos.nicta.com.au           ERTOS within National ICT Australia
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
