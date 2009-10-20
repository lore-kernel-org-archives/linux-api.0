From: Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Date: Mon, 19 Oct 2009 17:51:25 -0700
Message-ID: <20091020005125.GG27627@count0.beaverton.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <4AD8C7E4.9000903@free.fr> <20091016194451.GA28706@us.ibm.com> <4ADCCD68.9030003@free.fr> <4ADCDE7F.4090501@librato.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758069AbZJTAve@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4ADCDE7F.4090501@librato.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oren Laadan <orenl@librato.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>, randy.dunlap@oracle.com, arnd@arndb.de, linux-api@vger.kernel.org, Containers <containers@lists.linux-foundation.org>, Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org, Louis.Rilling@kerlabs.com, "Eric W. Biederman" <ebiederm@xmission.com>, kosaki.motohiro@jp.fujitsu.com, hpa@zytor.com, mingo@elte.hu, Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, torvalds@linux-foundation.org, Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com, Pavel Emelyanov <xemul@openvz.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 19, 2009 at 05:47:43PM -0400, Oren Laadan wrote:
> 
> 
> Daniel Lezcano wrote:
> > Sukadev Bhattiprolu wrote:
> >> Daniel Lezcano [daniel.lezcano@free.fr] wrote:
> >>   
> >>> Sukadev Bhattiprolu wrote:
> >>>     
> >>>> Subject: [RFC][v8][PATCH 0/10] Implement clone3() system call
> >>>>

<snip>

> > Another point. It's another way to extend the exhausted clone  flags as 
> > the cloneat can be called as a compatibility way, with cloneat(getpid(), 
> > 0, ... )
> 
> Which is what the proposed new clone_....() does.

Just to be clear -- Suka's proposing to extend the clone flags. However I
don't believe reusing the "pid" parameters as Daniel seemed to suggest
was ever part of Suka's proposed changes.

<snip>

> > I don't really see a difference between sys_restart(pid_t pid , int fd, 
> > long flags) where pid_t is the topmost in the hierarchy, fd is a file 
> > descriptor to a structure "pid_t * + struct clone_args *" and flags is 
> > "PROCTREE".

I think the difference has to do with keeping the code maintainable.

Clone creates the process so it's already involved in allocating and
assigning pids to the new task. Switching pids at sys_restart() would 
add another point in the code where pids are allocated and assigned.
This suggests we may have to worry about introducing new obscure races
for anyone who's working on the pid allocator to be careful of. At
least when all the code is "localized" to the clone paths we can be
reasonably certain of proper maintenance.

<snip>

> I really really really hope we can settle down on *a* name,
> *any* name, and move forward. Amen.

clone3() seemed to be the leading contender from what I've read so far.
Does anyone still object to clone3() after reading the whole thread?

Cheers,
	-Matt Helsley
