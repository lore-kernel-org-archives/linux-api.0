From: Dan Smith <danms-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/80] Kernel based checkpoint/restart [v18]
Date: Wed, 30 Sep 2009 09:29:23 -0700
Message-ID: <87eipoo0po.fsf@caffeine.danplanet.com>
References: <1253749920-18673-1-git-send-email-orenl@librato.com>
	<20090924154139.2a7dd5ec.akpm@linux-foundation.org>
	<20090928163704.GA3327@us.ibm.com> <4AC20BB8.4070509@free.fr>
	<87iqf0o5sf.fsf@caffeine.danplanet.com> <4AC38477.4070007@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AC38477.4070007-GANU6spQydw@public.gmane.org> (Daniel Lezcano's message of "Wed\, 30 Sep 2009 18\:16\:55 +0200")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Lezcano <daniel.lezcano-GANU6spQydw@public.gmane.org>
Cc: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

DL> If the checkpoint is done from the kernel, why the restart
DL> wouldn't be in the kernel too ?

I think thus far we have taken the approach of "if it can be done
reasonably in userspace, then do it there" right?  Setup of the
network devices is easy to do in userspace, allows more flexibility
from a policy standpoint, and ensures that all existing security
checks are performed.  Also, migration may be easier if the userspace
bits can call custom hooks allowing for routing changes and other
infrastructure-specific operations.

DL> Is there any documentation about the statefile format I can use if
DL> I want to implement myself an userspace CR solution based on this
DL> kernel patchset ?

See linux-cr/include/linux/checkpoint_hdr.h and user-cr/restart.c.

-- 
Dan Smith
IBM Linux Technology Center
email: danms-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
