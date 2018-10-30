From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v8 1/2] seccomp: add a return code to trap to userspace
Date: Tue, 30 Oct 2018 16:32:28 -0600
Message-ID: <20181030223228.GG7343@cisco>
References: <20181029224031.29809-1-tycho@tycho.ws>
 <20181029224031.29809-2-tycho@tycho.ws>
 <CAGXu5jLjum=TDab67L5XdWKEmzU_5rYeLfGXB1vb2BmfZdPuHQ@mail.gmail.com>
 <20181030215404.GF7343@cisco>
 <CAGXu5j+ZPxu6egE1fEr+N9+zLx3N+SJ_vbS_zzj9_hrdWrrrWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5j+ZPxu6egE1fEr+N9+zLx3N+SJ_vbS_zzj9_hrdWrrrWQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 30, 2018 at 03:00:17PM -0700, Kees Cook wrote:
> On Tue, Oct 30, 2018 at 2:54 PM, Tycho Andersen <tycho@tycho.ws> wrote:
> > On Tue, Oct 30, 2018 at 02:49:21PM -0700, Kees Cook wrote:
> >> On Mon, Oct 29, 2018 at 3:40 PM, Tycho Andersen <tycho@tycho.ws> wrote:
> >> >     * switch to a flags based future-proofing mechanism for struct
> >> >       seccomp_notif and seccomp_notif_resp, thus avoiding version issues
> >> >       with structure length (Kees)
> >> [...]
> >> >
> >> > +struct seccomp_notif {
> >> > +       __u64 id;
> >> > +       __u32 pid;
> >> > +       __u32 flags;
> >> > +       struct seccomp_data data;
> >> > +};
> >> > +
> >> > +struct seccomp_notif_resp {
> >> > +       __u64 id;
> >> > +       __s64 val;
> >> > +       __s32 error;
> >> > +       __u32 flags;
> >> > +};
> >>
> >> Hrm, so, what's the plan for when struct seccomp_data changes size?
> >
> > I guess my plan was don't ever change the size again, just use flags
> > and have extra state available via ioctl().
> >
> >> I'm realizing that it might be "too late" for userspace to discover
> >> it's running on a newer kernel. i.e. it gets a user notification, and
> >> discovers flags it doesn't know how to handle. Do we actually need
> >> both flags AND a length? Designing UAPI is frustrating! :)
> >
> > :). I don't see this as such a big problem -- in fact it's better than
> > the length mode, where you don't know what you don't know, because it
> > only copied as much info as you could handle. Older userspace would
> > simply not use information it didn't know how to use.
> >
> >> Do we need another ioctl to discover the seccomp_data size maybe?
> >
> > That could be an option as well, assuming we agree that size would
> > work, which I thought we didn't?
> 
> Size alone wasn't able to determine the layout of the seccomp_notif
> structure since it had holes (in the prior version). seccomp_data
> doesn't have holes and is likely to change in size (see the recent
> thread on adding the MPK register to it...)

Oh, sorry, I misread this as seccomp_notif, not seccomp_data.

> I'm trying to imagine the right API for this. A portable user of
> seccomp_notif expects the id/pid/flags/data to always be in the same
> place, but it's the size of seccomp_data that may change. So it wants
> to allocate space for seccomp_notif header and "everything else", of
> which is may only understand the start of seccomp_data (and ignore any
> new trailing fields).
> 
> So... perhaps the "how big are things?" ioctl would report the header
> size and the seccomp_data size. Then both are flexible. And flags
> would be left as a way to "version" the header?
> 
> Any Linux API list members want to chime in here?

So:

struct seccomp_notify_sizes {
    u16 seccomp_notify;
    u16 seccomp_data;
};

ioctl(fd, SECCOMP_IOCTL_GET_SIZE, &sizes);

This would be only one extra syscall over the lifetime of the listener
process, which doesn't seem too bad. One thing that's slightly
annoying is that you can't do it until you actually get an event, so
maybe it could be a command on the seccomp syscall instead:

seccomp(SECCOMP_GET_NOTIF_SIZES, 0, &sizes);

?

Tycho
