From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 4/6] tpm: TPM 2.0 sysfs attributes
Date: Mon, 20 Oct 2014 13:45:15 +0300
Message-ID: <20141020104515.GB5647@intel.com>
References: <1413372916-12091-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1413372916-12091-5-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141016093146.GA25070@kroah.com>
 <20141016160358.GB12979@intel.com>
 <CA+i0qc4XgqF4c+TcyXvPG6XFs_LNvWWRs8p_=-iGeD_bQU9Zpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+i0qc4XgqF4c+TcyXvPG6XFs_LNvWWRs8p_=-iGeD_bQU9Zpw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tomas Winkler <tomasw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, monty.wiseman-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Oct 20, 2014 at 12:09:27AM +0300, Tomas Winkler wrote:
> >
> > Here the options are limited because misc_register already spawns
> > KOBJ_ADD. Not much to do unless we would wipe the current use of
> > misc driver completely.
> 
> I would strongly recommend to drop the misc layer here, as tpm itself
> can provide the needed abstraction for the devices.

This is exactly what I'm going to do for v4 of the patch set and take
the rtc subsystem as a guideline how to structure things in proper way.

It is ABI break but if you look at the TPM1 sysfs attributes most of
them haven't been ever machine readable anyway so I'll at least give it
shot and a take the feedback. I'm fully aware that doing such thing is 
comparable to killing your own mother :)

Past experiences of trying to do such thing [1] have not been succesful
but on the other hand this is very different scenario and different user
volumes.

It would make sense to rip off all the "human-only" TPM1 attributes in
the same round. I'm wondering what is the set of sysfs attributes is
that TrouSerS is dependent of? I would suggest to leave that subset
available and remove attributes such as 'pcrs' that breaks all the
conventions.

[1] http://lwn.net/Articles/172306/

/Jarkko
