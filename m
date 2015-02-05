From: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC v2 0/7] epoll: Introduce new syscalls,
 epoll_ctl_batch and epoll_pwait1
Date: Thu, 5 Feb 2015 17:01:46 +0800
Message-ID: <20150205090146.GC5048@ad.nay.redhat.com>
References: <1423046213-7043-1-git-send-email-famz@redhat.com>
 <54D2142B.8090105@gmail.com>
 <20150205015251.GA23497@ad.nay.redhat.com>
 <54D31F6F.4030301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54D31F6F.4030301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <peter>
List-Id: linux-api@vger.kernel.org

On Thu, 02/05 08:44, Michael Kerrisk (man-pages) wrote:
> Hello Fam Zheng,
> 
> On 02/05/2015 02:52 AM, Fam Zheng wrote:
> > On Wed, 02/04 13:44, Michael Kerrisk (man-pages) wrote:
> >> Hello Fam Zheng,
> >>
> >> On 02/04/2015 11:36 AM, Fam Zheng wrote:
> >>> Changes from v1 (https://lkml.org/lkml/2015/1/20/189):
> >>>
> >>>   - As discussed in previous thread [1], split the call to epoll_ctl_batch and
> >>>     epoll_pwait. [Michael]
> >>>
> >>>   - Fix memory leaks. [Omar]
> >>>
> >>>   - Add a short comment about the ignored copy_to_user failure. [Omar]
> >>>
> >>>   - Cover letter rewritten.
> >>>
> >>> This adds two new system calls as described below. I mentioned glibc wrapping
> >>> of sigarg in epoll_pwait1 description, so don't read it as end user man page
> >>> yet.
> >>
> >> Fair enough. But I think it would be helpful to say a little more already.
> >> See my comment below.
> >>
> >>> One caveat is the possible failure of the last copy_to_user in epoll_ctl_batch,
> >>> which returns per command error code. Ideas to improve that are welcome!
> >>>
> >>> 1) epoll_ctl_batch
> >>> ------------------
> >>>
> >>> NAME
> >>>        epoll_ctl_batch - modify an epoll descriptor in batch
> >>>
> >>> SYNOPSIS
> >>>
> >>>        #include <sys/epoll.h>
> >>>
> >>>        int epoll_ctl_batch(int epfd, int flags,
> >>>                            int ncmds, struct epoll_ctl_cmd *cmds);
> >>>
> >>> DESCRIPTION
> >>>
> >>>        The system call performs a batch of epoll_ctl operations. It allows
> >>>        efficient update of events on this epoll descriptor.
> >>>
> >>>        Flags is reserved and must be 0.
> >>>
> >>>        Each operation is specified as an element in the cmds array, defined as:
> >>>
> >>>            struct epoll_ctl_cmd {
> >>>
> >>>                   /* Reserved flags for future extension, must be 0. */
> >>>                   int flags;
> >>>
> >>>                   /* The same as epoll_ctl() op parameter. */
> >>>                   int op;
> >>>
> >>>                   /* The same as epoll_ctl() fd parameter. */
> >>>                   int fd;
> >>>
> >>>                   /* The same as the "events" field in struct epoll_event. */
> >>>                   uint32_t events;
> >>>
> >>>                   /* The same as the "data" field in struct epoll_event. */
> >>>                   uint64_t data;
> >>>
> >>>                   /* Output field, will be set to the return code after this
> >>>                    * command is executed by kernel */
> >>>                   int error_hint;
> >>
> >> Why 'error_hint', rather than just stay 'status' or 'result'? I mean
> >> is it really a "hint"? Also, it can be 0 meaning "success" (no error).
> > 
> > Because the convention is weak here: the copy_to_user, to assign values to this
> > field in user provided array, could (very unlikely) fail, at which point the
> > commands are already executed so there is no return. This corner case
> > inconsistency makes it hard to be a contract.
> 
> I still think it's a poor name. Yes, it could unlikely fail.
> Still, 'status' or 'result_status' or something like that is better.
> 
> >>>            };
> >>>
> >>>        Commands are executed in their order in cmds, and if one of them failed,
> >>>        the rest after it are not tried.
> >>>
> >>>        Not that this call isn't atomic in terms of updating the epoll
> >>>        descriptor, which means a second epoll_ctl or epoll_ctl_batch call
> >>>        during the first epoll_ctl_batch may make the operation sequence
> >>>        interleaved. However, each single epoll_ctl_cmd operation has the same
> >>>        semantics as a epoll_ctl call.
> >>
> >> (Good to include that warning!)
> >>
> >>> RETURN VALUE
> >>>
> >>>        If one or more of the parameters are incorrect, -1 is returned and errno
> >>>        is set appropriately. Otherwise, the number of succeeded commands is
> >>>        returned.
> >>>
> >>>        Each error_hint field may be set to the error code or 0, depending on
> >>>        the result of the command. If there is some error in returning the error
> >>>        to user, it may also be unchanged, even though the command may actually
> >>>        be executed. In this case, it's still ensured that the i-th (i = ret)
> >>>        command is the failed command.
> >>
> >> Sorry -- I'm not clear here. Can you say some more here? What sort
> >> of error might there be when "returning the error to the user"?
> > 
> > As explained above. See also the last comment of Omar:
> > 
> > https://lkml.org/lkml/2015/1/21/103
> 
> Okay -- but could you please actually explain this in more detail in the 
> man page. Then others do not need to ask the same question.

OK, I'll name it 'status' and add more details in next revision.

> 
> > <...>
> > 
> >>> DESCRIPTION
> >>>
> >>>        The epoll_pwait1 system call differs from epoll_pwait only in parameter
> >>>        types. The first difference is timeout, a pointer to timespec structure
> >>>        which allows nanosecond presicion; the second difference, which should
> >>>        probably be wrapper by glibc and only expose a sigset_t pointer as in
> >>>        pselect6.
> >>
> >> Here I think it still helps to explain that 'struct sigags' is a sigset_t* +
> >> the size of the pointed-to set.
> > 
> > Yes, will add.
> > 
> >>
> >>>        If timeout is NULL, it's treated as if 0 is specified in epoll_pwait
> >>
> >> The convention I would expect here is that NULL means infinite timeout,
> >> like select(), and timeout == {0,0} would get the "return immediately"
> >> behavior. Why did you choose your convention? And, how does one otherwise 
> >> request an infinite timeout?
> > 
> > I'm wrong. I should follow the conventions of pselect and ppoll. Thanks for
> > catching that.
> 
> Good.
> 
> >>
> >>>        (return immediately). Otherwise it's converted to nanosecond scalar,
> >>>        again, with the same convention as epoll_pwait's timeout.
> >>>
> >>> RETURN VALUE
> >>>
> >>>        The same as said in epoll_pwait(2).
> >>>
> >>> ERRORS
> >>>
> >>>        The same as said in man epoll_pwait(2), plus:
> >>>
> >>>        EINVAL flags is not zero.
> >>>
> >>>
> >>> CONFORMING TO
> >>>
> >>>        epoll_pwait1() is Linux-specific.
> >>>
> >>> SEE ALSO
> >>>
> >>>        epoll_create(2), epoll_ctl(2), epoll_wait(2), epoll_pwait(2), epoll(7)
> >>
> >> In your earlier patch set, there was the ability to select the clock
> >> used for timeouts. Why did this go away? I'm not sure whether we need
> >> that functionality or not, but it would be good to know why you
> >> dropped it this time.
> >>
> > 
> > No room for another "int clockid". Options:
> 
> Ahh yes. I overlooked that. But again, if your commit message or
> the man page said something about why you dropped this argument,
> then we would not run around in circles having the same 
> conversations repeatedly.
> 
> I keep loving this recent quote from akpm:
> http://lwn.net/Articles/616226/

Good point!

> 
> > 0) Don't have it.
> > 
> > 1) "Or" into lower bits of flags.
> > 
> > 2) Encode into flags bits.
> > 
> > 3) Squash "int clockid" in the last argument (currently "sig" but need to name
> > it "spec", again).
> 
> Well, it's up to you. In https://lkml.org/lkml/2015/1/20/189
> you initially proposed to have the clockid. Do you need it,
> or not? I am agnostic about it. If you do decide you want it,
> then I think (3) is the best option.

Then let's do it this way. clockid would be useful because different
applications care about different clocks.

> 
> I'm very pleased that you expand this man page as you go.
> But, for the next iteration, I think it would be better to make
> it even more complete--it really is helpful to have documentation
> as a starting point to discuss the API, and the better the doc,
> the better the discussion.
> 

Sure, I'll take your points. Thanks for the advice!

Fam
