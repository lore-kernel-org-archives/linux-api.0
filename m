From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC PATCH] fork: report pid reservation failure properly
Date: Wed, 4 Feb 2015 11:27:19 +0100
Message-ID: <20150204102719.GB29434@dhcp22.suse.cz>
References: <20150203150557.GB8907@dhcp22.suse.cz>
 <CAKgNAkjiz6Uop_QVBNyyHFu8kgAR46nB1HWi0yOKt4ZX=666vg@mail.gmail.com>
 <20150203155248.GD8907@dhcp22.suse.cz>
 <87bnlalo7k.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87bnlalo7k.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue 03-02-15 14:44:31, Eric W. Biederman wrote:
> Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> writes:
> 
> > On Tue 03-02-15 16:33:03, Michael Kerrisk wrote:
> >> Hi Michal,
> >> 
> >> 
> >> On 3 February 2015 at 16:05, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> >> > Hi,
> >> > while debugging an unexpected ENOMEM from fork (there was no memory
> >> > pressure and OVERCOMMIT_ALWAYS) I have found out that fork returns
> >> > ENOMEM even when not short on memory.
> >> >
> >> > In this particular case it was due to depleted pid space which is
> >> > documented to return EAGAIN in man pages.
> >> >
> >> > Here is a quick fix up.
> >> 
> >> Could you summarize briefly what the user-space visible change is
> >> here?
> >
> > The user visible change is that the userspace will get EAGAIN when
> > calling fork and the pid space is depleted because of a system wide
> > limit as per man page description rather than ENOMEM which we return
> > currently.
> 
> I don't think that EAGAIN is any better than ENOMEM,

Well, EAGAIN is what the documentation says (both POSIX and ours).
I do not want to get to language lawyering but we should either change
the documentation and reason why we differ from POSIX or change the
behavior. I find the later option more viable because ENOMEM is really
hard to debug when there is not a lack of memory.

> nor do I know that it is safe to return EBUSY from fork.  What nonsense
> will applications do when they see an unexpected error code.

Agreed, any new error code might be confusing.

> >> It is not so obvious from your message. I believe you're turning
> >> some cases of ENOMEM into EAGAIN, right?
> >
> > Yes, except for the case mentioned below which discusses a potential
> > error code for pid namespace triggered failures.
> >
> >> Note, by the way, that if I understandwhat you intend, this change
> >> would bring the implementation closer to POSIX, which specifies:
> >
> > True.
> >
> > HTH.
> >
> >>        EAGAIN The  system  lacked  the  necessary  resources  to  create
> >>               another  process, or the system-imposed limit on the total
> >>               number of processes under execution system-wide  or  by  a
> >>               single user {CHILD_MAX} would be exceeded.
> >> 
> 
> Note.  All of those documented errors documented to return EAGAIN
> are the kind of errors that if you wait a while you can reasonably
> expect fork to succeed later.
> 
> With respecting to dealing with errors from fork, fork
> is a major pain.  Fork only has only two return codes documented,
> and fork is one of the most complicated system calls in the kernel with
> the most failure modes of any system call I am familiar with.  Mapping 
> a plethora of failure modes onto two error codes is always going to be
> problematic from some view point.

Agreed.

> EAGAIN is a bad idea in general because that means try again and if you
> have hit a fixed limit trying again is wrong.

I don't know what was the justification for EAGAIN but it was like that
for ages so I assume there is a code which relies on that.

> Frankly I think posix is probably borked to recommend EAGAIN instead of
> ENOMEM.
>
> Everyone in the world uses fork which makes is quite tricky to figure
> out which assumptions on the return values of fork exist in the wild,
> so it is not clear if it is safe to add new more descriptive return
> messages.
> 
> With respect to the case where PIDNS_HASH_ADDING would cause fork to
> fail, that only happens after init has exited in a pid namespace, so it
> is very much a permanent failure, and there are no longer any processes
> in the specific pid namespace nor will there ever be any more processes
> in that pid namespace.  EINVAL might actually makes sense.  Of course
> a sensible error code from fork does not seem to be allowed.
> 
> Of the two return codes that are allowed for fork, EAGAIN and ENOMEM
> ENOMEM seems to be better as it is a more permanement failure.

Yes, if a new error code is really a nogo I would go for ENOMEM.

> I agree it is a little confusing, but I don't see anything that is other
> than a little confusing.
> 
> Other than someone doing:
> 
> unshare(CLONE_NEWPID);
> pid = fork();
> waitpid(pid);
> fork();   /* returns ENOMEM */

Ohh, I got it finally. unshare itself doesn't move the calling process
into a new namsepace.

> Was there any other real world issue that started this goal to fix fork?

I haven't seen any real world issue wrt. PIDNS_HASH_ADDING. It came out
from the error code propagation.
But I have seen ENOMEM when pid space was depleted and that confused
people and they reported it as a bug. Exactly because there was a ton of
memory free and no overcommit.

> I think there is a reasonable argument for digging into the fork return
> code situation.  Perhaps it is just a matter of returning exotic return
> codes for the weird and strange cases like trying to create a pid in a
> dead pid namespace.
> 
> But what we have works, and I don't know of anything bad that happens
> except when people are developing new code they get confused.
> 
> Further we can't count on people to read their man pages because this
> behavior of returning ENOMEM is documented in pid_namespaces(7).  Which
> makes me really thinking changing the code to match the manpage is more
> likely to break code than to fix code.

OK, I will remove the pid namespace related error code propagation and
keep it returning ENOMEM but I think the EAGAIN part is still worth fixing.
Will post a new patch.
-- 
Michal Hocko
SUSE Labs
