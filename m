From: Joel Fernandes <joelaf@google.com>
Subject: Re: [PATCH v14 1/6] sched/core: uclamp: Extend CPU's cgroup controller
Date: Tue, 3 Sep 2019 10:21:59 -0400
Message-ID: <CAJWu+opnNT3bQwe+SsdR0Q+PSt7DA=JAQ_5sbZ6h2DXd4ZqwHA@mail.gmail.com>
References: <20190822132811.31294-1-patrick.bellasi@arm.com>
 <20190822132811.31294-2-patrick.bellasi@arm.com> <CAJuCfpGWtrg02LNE3PJZag9-LLVT=by2v+9x_tm1PyoXwZ8DqQ@mail.gmail.com>
 <20190903085248.GB8756@blackbody.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190903085248.GB8756@blackbody.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Alessio Balsini <balsini@android.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Quentin Perret <quentin.perret@arm.com>, Paul Turner <pjt@google.com>, Steve Muckle <smuckle@google.com>, Todd Kjos <tkjos@google.com>, Peter Zijlstra <peterz@infradead.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Tejun Heo <tj@kernel.org>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Juri Lelli <juri.lelli@redhat.com>, Ingo Molnar <mingo@redhat.com>, cgroups mailinglist <cgroups@vger.kernel.org>, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux PM <linux-pm@vge>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 3, 2019 at 4:53 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrote:
>
> On Mon, Sep 02, 2019 at 04:02:57PM -0700, Suren Baghdasaryan <surenb@goog=
le.com> wrote:
> > > +static inline void cpu_uclamp_print(struct seq_file *sf,
> > > +                                   enum uclamp_id clamp_id)
> > > [...]
> > > +       rcu_read_lock();
> > > +       tg =3D css_tg(seq_css(sf));
> > > +       util_clamp =3D tg->uclamp_req[clamp_id].value;
> > > +       rcu_read_unlock();
> > > +
> > > +       if (util_clamp =3D=3D SCHED_CAPACITY_SCALE) {
> > > +               seq_puts(sf, "max\n");
> > > +               return;
> > > +       }
> > > +
> > > +       percent =3D tg->uclamp_pct[clamp_id];
> >
> > You are taking RCU lock when accessing tg->uclamp_req but not when
> > accessing tg->uclamp_pct.
> Good point.
>
> > Is that intentional? Can tg be destroyed under you?
> Actually, the rcu_read{,un}lock should be unnecessary in the context of
> the kernfs file op handler -- the tg/css won't go away as long as its
> kernfs file is being worked with.
>

Also, add to that the fact that there is no rcu_dereference() call to
access any of the pointers in the reader or any of its callers. And, I
don't see any "wait for completion" type of pattern here so that
rcu_read_{lock, unlock}() pair does seem useless.

thanks,

 - Joel
