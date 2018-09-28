From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v7 1/6] seccomp: add a return code to trap to userspace
Date: Fri, 28 Sep 2018 08:39:01 -0600
Message-ID: <20180928143901.GB18045@cisco.lan>
References: <20180927151119.9989-1-tycho@tycho.ws>
 <20180927151119.9989-2-tycho@tycho.ws>
 <CAGXu5jJr3JWLYGrJ+knu3sj4wwJ_irVvs+JRrY5MuYT3voLegg@mail.gmail.com>
 <20180927224839.GF15491@cisco.cisco.com>
 <CAGXu5jJ8VSJ6BqqxAL+B12bv2xTNU3CzpBOMf-zEChO9opaFMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ8VSJ6BqqxAL+B12bv2xTNU3CzpBOMf-zEChO9opaFMA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Stephane Graber <stgraber@ubuntu.com>, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Jann Horn <jannh@google.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 27, 2018 at 04:10:29PM -0700, Kees Cook wrote:
> On Thu, Sep 27, 2018 at 3:48 PM, Tycho Andersen <tycho@tycho.ws> wrote:
> > On Thu, Sep 27, 2018 at 02:31:24PM -0700, Kees Cook wrote:
> >> On Thu, Sep 27, 2018 at 8:11 AM, Tycho Andersen <tycho@tycho.ws> wrote:
> >> struct seccomp_notif {
> >>         __u16                      len;                  /*     0     2 */
> >>
> >>         /* XXX 6 bytes hole, try to pack */
> >>
> >>         __u64                      id;                   /*     8     8 */
> >>         __u32                      pid;                  /*    16     4 */
> >>         __u8                       signaled;             /*    20     1 */
> >>
> >>         /* XXX 3 bytes hole, try to pack */
> >>
> >>         struct seccomp_data        data;                 /*    24    64 */
> >>         /* --- cacheline 1 boundary (64 bytes) was 24 bytes ago --- */
> >>
> >>         /* size: 88, cachelines: 2, members: 5 */
> >>         /* sum members: 79, holes: 2, sum holes: 9 */
> >>         /* last cacheline: 24 bytes */
> >> };
> >> struct seccomp_notif_resp {
> >>         __u16                      len;                  /*     0     2 */
> >>
> >>         /* XXX 6 bytes hole, try to pack */
> >>
> >>         __u64                      id;                   /*     8     8 */
> >>         __s32                      error;                /*    16     4 */
> >>
> >>         /* XXX 4 bytes hole, try to pack */
> >>
> >>         __s64                      val;                  /*    24     8 */
> >>
> >>         /* size: 32, cachelines: 1, members: 4 */
> >>         /* sum members: 22, holes: 2, sum holes: 10 */
> >>         /* last cacheline: 32 bytes */
> >> };
> >>
> >> How about making len u32, and moving pid and error above "id"? This
> >> leaves a hole after signaled, so changing "len" won't be sufficient
> >> for versioning here. Perhaps move it after data?
> >
> > I'm not sure what you mean by "len won't be sufficient for versioning
> > here"? Anyway, I can do some packing on these; I didn't bother before
> > since I figured it's a userspace interface, so saving a few bytes
> > isn't a huge deal.
> 
> I was thinking the "len" portion was for determining if the API ever
> changes in the future. My point was that given the padding holes, e.g.
> adding a u8 after signaled, "len" wouldn't change, so the kernel might
> expect to starting reading something after signaled that it wasn't
> checking before, but the len would be the same.

Oh, yeah. That's ugly :(

> >> I have to say, I'm vaguely nervous about changing the semantics here
> >> for passing back the fd as the return code from the seccomp() syscall.
> >> Alternatives seem less appealing, though: changing the meaning of the
> >> uargs parameter when SECCOMP_FILTER_FLAG_NEW_LISTENER is set, for
> >> example. Hmm.
> >
> > From my perspective we can drop this whole thing. The only thing I'll
> > ever use is the ptrace version. Someone at some point (I don't
> > remember who, maybe stgraber) suggested this version would be useful
> > as well.
> 
> Well that would certainly change the exposure of the interface pretty
> drastically. :)
> 
> So, let's talk more about this, as it raises another thought I had
> too: for the PTRACE interface to work, you have to know specifically
> which filter you want to get notifications for. Won't that be slightly
> tricky?

Not necessarily. The way I imagine using it is:

1. container manager forks init task
2. init task does a bunch of setup stuff, then installs the filter
3. optionally install any user specified filter (or just merge the
   filter with step 2 instead of chaining them)
4. container manager grabs the listener fd from the container init via
   ptrace
5. init execs the user specified init

So the offset will always be known at least in my usecase. The
container manager doesn't want to install the filter on itself, so it
won't use NEW_LISTENER. Similarly, we don't want init to use
NEW_LISTENER, because if the user has decided to block sendmsg as part
of their policy, there's no way to get the fd out.

> > Anyway, let me know if your nervousness outweighs this, I'm happy to
> > drop it.
> 
> I'm not opposed to keeping it, but if you don't think anyone will use
> it ... we should probably drop it just to avoid the complexity. It's a
> cool API, though, so I'd like to hear from others first before you go
> tearing it out. ;) (stgraber added to CC)

It does seem useful for lighter weight cases than a container. The "I
want to run some random binary that I don't have the source for that
tries to make some privileged calls it doesn't really need" case. But
as a Container Guy I think I have in my contract somewhere that I have
to use containers :). But let's see what people think.

> >> > +       if (copy_from_user(&size, buf, sizeof(size)))
> >> > +               return -EFAULT;
> >> > +       size = min_t(size_t, size, sizeof(resp));
> >> > +       if (copy_from_user(&resp, buf, size))
> >> > +               return -EFAULT;
> >>
> >> For sanity checking on a double-read from userspace, please add:
> >>
> >>     if (resp.len != size)
> >>         return -EINVAL;
> >
> > Won't that fail if sizeof(resp) < resp.len, because of the min_t()?
> 
> Ah, true. In that case, probably do resp.len = size to avoid any logic
> failures due to the double-read? I just want to avoid any chance of
> confusing the size and actually using it somewhere.

Yep, sounds good.

Tycho
