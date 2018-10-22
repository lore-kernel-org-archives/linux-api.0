From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v7 1/6] seccomp: add a return code to trap to userspace
Date: Mon, 22 Oct 2018 11:42:41 +0200
Message-ID: <20181022094240.mp7pd2m2abyttrfb@brauner.io>
References: <20180927151119.9989-1-tycho@tycho.ws>
 <20180927151119.9989-2-tycho@tycho.ws>
 <CAGXu5jJr3JWLYGrJ+knu3sj4wwJ_irVvs+JRrY5MuYT3voLegg@mail.gmail.com>
 <20181017202933.GB14047@cisco>
 <CAGXu5jK5yN7zcPUMzFYnUbRrVkLNE0YDCioYdNC3P6mF437+5g@mail.gmail.com>
 <20181021160437.GB25202@cisco>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181021160437.GB25202@cisco>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "Eric W . Biederman" <ebiederm@xmission.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On Sun, Oct 21, 2018 at 05:04:37PM +0100, Tycho Andersen wrote:
> On Wed, Oct 17, 2018 at 03:21:02PM -0700, Kees Cook wrote:
> > On Wed, Oct 17, 2018 at 1:29 PM, Tycho Andersen <tycho@tycho.ws> wrote:
> > > On Thu, Sep 27, 2018 at 02:31:24PM -0700, Kees Cook wrote:
> > >> On Thu, Sep 27, 2018 at 8:11 AM, Tycho Andersen <tycho@tycho.ws> wrote:
> > >> > @@ -60,4 +62,29 @@ struct seccomp_data {
> > >> >         __u64 args[6];
> > >> >  };
> > >> >
> > >> > +struct seccomp_notif {
> > >> > +       __u16 len;
> > >> > +       __u64 id;
> > >> > +       __u32 pid;
> > >> > +       __u8 signaled;
> > >> > +       struct seccomp_data data;
> > >> > +};
> > >> > +
> > >> > +struct seccomp_notif_resp {
> > >> > +       __u16 len;
> > >> > +       __u64 id;
> > >> > +       __s32 error;
> > >> > +       __s64 val;
> > >> > +};
> > >>
> > >> So, len has to come first, for versioning. However, since it's ahead
> > >> of a u64, this leaves a struct padding hole. pahole output:
> > >>
> > >> struct seccomp_notif {
> > >>         __u16                      len;                  /*     0     2 */
> > >>
> > >>         /* XXX 6 bytes hole, try to pack */
> > >>
> > >>         __u64                      id;                   /*     8     8 */
> > >>         __u32                      pid;                  /*    16     4 */
> > >>         __u8                       signaled;             /*    20     1 */
> > >>
> > >>         /* XXX 3 bytes hole, try to pack */
> > >>
> > >>         struct seccomp_data        data;                 /*    24    64 */
> > >>         /* --- cacheline 1 boundary (64 bytes) was 24 bytes ago --- */
> > >>
> > >>         /* size: 88, cachelines: 2, members: 5 */
> > >>         /* sum members: 79, holes: 2, sum holes: 9 */
> > >>         /* last cacheline: 24 bytes */
> > >> };
> > >> struct seccomp_notif_resp {
> > >>         __u16                      len;                  /*     0     2 */
> > >>
> > >>         /* XXX 6 bytes hole, try to pack */
> > >>
> > >>         __u64                      id;                   /*     8     8 */
> > >>         __s32                      error;                /*    16     4 */
> > >>
> > >>         /* XXX 4 bytes hole, try to pack */
> > >>
> > >>         __s64                      val;                  /*    24     8 */
> > >>
> > >>         /* size: 32, cachelines: 1, members: 4 */
> > >>         /* sum members: 22, holes: 2, sum holes: 10 */
> > >>         /* last cacheline: 32 bytes */
> > >> };
> > >>
> > >> How about making len u32, and moving pid and error above "id"? This
> > >> leaves a hole after signaled, so changing "len" won't be sufficient
> > >> for versioning here. Perhaps move it after data?
> > >
> > > Just to confirm my understanding; I've got these as:
> > >
> > > struct seccomp_notif {
> > >         __u32                      len;                  /*     0     4 */
> > >         __u32                      pid;                  /*     4     4 */
> > >         __u64                      id;                   /*     8     8 */
> > >         __u8                       signaled;             /*    16     1 */
> > >
> > >         /* XXX 7 bytes hole, try to pack */
> > >
> > >         struct seccomp_data        data;                 /*    24    64 */
> > >         /* --- cacheline 1 boundary (64 bytes) was 24 bytes ago --- */
> > >
> > >         /* size: 88, cachelines: 2, members: 5 */
> > >         /* sum members: 81, holes: 1, sum holes: 7 */
> > >         /* last cacheline: 24 bytes */
> > > };
> > > struct seccomp_notif_resp {
> > >         __u32                      len;                  /*     0     4 */
> > >         __s32                      error;                /*     4     4 */
> > >         __u64                      id;                   /*     8     8 */
> > >         __s64                      val;                  /*    16     8 */
> > >
> > >         /* size: 24, cachelines: 1, members: 4 */
> > >         /* last cacheline: 24 bytes */
> > > };
> > >
> > > in the next version. Since the structure has no padding at the end of
> > > it, I think the Right Thing will happen. Note that this is slightly
> > > different than what Kees suggested, if I add signaled after data, then
> > > I end up with:
> > >
> > > struct seccomp_notif {
> > >         __u32                      len;                  /*     0     4 */
> > >         __u32                      pid;                  /*     4     4 */
> > >         __u64                      id;                   /*     8     8 */
> > >         struct seccomp_data        data;                 /*    16    64 */
> > >         /* --- cacheline 1 boundary (64 bytes) was 16 bytes ago --- */
> > >         __u8                       signaled;             /*    80     1 */
> > >
> > >         /* size: 88, cachelines: 2, members: 5 */
> > >         /* padding: 7 */
> > >         /* last cacheline: 24 bytes */
> > > };
> > >
> > > which I think will have the versioning problem if the next member
> > > introduces is < 7 bytes.
> > 
> > It'll be a problem in either place. What I was thinking was that
> > specific versioning is required instead of just length.
> 
> Euh, so I implemented this, and it sucks :). It's ugly, and generally
> feels bad.
> 
> What if instead we just get rid of versioning all together, and
> instead introduce a u32 flags? We could have one flag right now
> (SECCOMP_NOTIF_FLAG_SIGNALED), and use introduce others as we add more
> information to the response. Then we can add
> SECCOMP_NOTIF_FLAG_EXTRA_FOO, and add another SECCOMP_IOCTL_GET_FOO to
> grab the info?
> 
> FWIW, it's not really clear to me that we'll ever add anything to the
> response since hopefully we'll land PUT_FD, so maybe this is all moot
> anyway.

I guess the only argument against a flag would be that you run out of
bits quickly if your interface grows (cf. mount, netlink etc.). But this
is likely not a concern here.
I actually think that the way vfs capabilities are done is pretty
nice. By accident or design they allow transparent translation between
old and new formats in-kernel. So would be cool if we can have the same
guarantee for this interface.

Christian
