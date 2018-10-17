From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v7 1/6] seccomp: add a return code to trap to userspace
Date: Wed, 17 Oct 2018 14:29:33 -0600
Message-ID: <20181017202933.GB14047@cisco>
References: <20180927151119.9989-1-tycho@tycho.ws>
 <20180927151119.9989-2-tycho@tycho.ws>
 <CAGXu5jJr3JWLYGrJ+knu3sj4wwJ_irVvs+JRrY5MuYT3voLegg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jJr3JWLYGrJ+knu3sj4wwJ_irVvs+JRrY5MuYT3voLegg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Jann Horn <jannh@google.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 27, 2018 at 02:31:24PM -0700, Kees Cook wrote:
> On Thu, Sep 27, 2018 at 8:11 AM, Tycho Andersen <tycho@tycho.ws> wrote:
> > @@ -60,4 +62,29 @@ struct seccomp_data {
> >         __u64 args[6];
> >  };
> >
> > +struct seccomp_notif {
> > +       __u16 len;
> > +       __u64 id;
> > +       __u32 pid;
> > +       __u8 signaled;
> > +       struct seccomp_data data;
> > +};
> > +
> > +struct seccomp_notif_resp {
> > +       __u16 len;
> > +       __u64 id;
> > +       __s32 error;
> > +       __s64 val;
> > +};
> 
> So, len has to come first, for versioning. However, since it's ahead
> of a u64, this leaves a struct padding hole. pahole output:
> 
> struct seccomp_notif {
>         __u16                      len;                  /*     0     2 */
> 
>         /* XXX 6 bytes hole, try to pack */
> 
>         __u64                      id;                   /*     8     8 */
>         __u32                      pid;                  /*    16     4 */
>         __u8                       signaled;             /*    20     1 */
> 
>         /* XXX 3 bytes hole, try to pack */
> 
>         struct seccomp_data        data;                 /*    24    64 */
>         /* --- cacheline 1 boundary (64 bytes) was 24 bytes ago --- */
> 
>         /* size: 88, cachelines: 2, members: 5 */
>         /* sum members: 79, holes: 2, sum holes: 9 */
>         /* last cacheline: 24 bytes */
> };
> struct seccomp_notif_resp {
>         __u16                      len;                  /*     0     2 */
> 
>         /* XXX 6 bytes hole, try to pack */
> 
>         __u64                      id;                   /*     8     8 */
>         __s32                      error;                /*    16     4 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         __s64                      val;                  /*    24     8 */
> 
>         /* size: 32, cachelines: 1, members: 4 */
>         /* sum members: 22, holes: 2, sum holes: 10 */
>         /* last cacheline: 32 bytes */
> };
> 
> How about making len u32, and moving pid and error above "id"? This
> leaves a hole after signaled, so changing "len" won't be sufficient
> for versioning here. Perhaps move it after data?

Just to confirm my understanding; I've got these as:

struct seccomp_notif {
	__u32                      len;                  /*     0     4 */
	__u32                      pid;                  /*     4     4 */
	__u64                      id;                   /*     8     8 */
	__u8                       signaled;             /*    16     1 */

	/* XXX 7 bytes hole, try to pack */

	struct seccomp_data        data;                 /*    24    64 */
	/* --- cacheline 1 boundary (64 bytes) was 24 bytes ago --- */

	/* size: 88, cachelines: 2, members: 5 */
	/* sum members: 81, holes: 1, sum holes: 7 */
	/* last cacheline: 24 bytes */
};
struct seccomp_notif_resp {
	__u32                      len;                  /*     0     4 */
	__s32                      error;                /*     4     4 */
	__u64                      id;                   /*     8     8 */
	__s64                      val;                  /*    16     8 */

	/* size: 24, cachelines: 1, members: 4 */
	/* last cacheline: 24 bytes */
};

in the next version. Since the structure has no padding at the end of
it, I think the Right Thing will happen. Note that this is slightly
different than what Kees suggested, if I add signaled after data, then
I end up with:

struct seccomp_notif {
	__u32                      len;                  /*     0     4 */
	__u32                      pid;                  /*     4     4 */
	__u64                      id;                   /*     8     8 */
	struct seccomp_data        data;                 /*    16    64 */
	/* --- cacheline 1 boundary (64 bytes) was 16 bytes ago --- */
	__u8                       signaled;             /*    80     1 */

	/* size: 88, cachelines: 2, members: 5 */
	/* padding: 7 */
	/* last cacheline: 24 bytes */
};

which I think will have the versioning problem if the next member
introduces is < 7 bytes.

Tycho
