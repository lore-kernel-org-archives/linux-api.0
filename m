From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH v6 08/16] sched/cpufreq: uclamp: Add utilization clamping
 for FAIR tasks
Date: Tue, 22 Jan 2019 12:04:54 +0100
Message-ID: <CAJZ5v0j2NQY_gKJOAy=rP5_1Dk9TODKNhW0vuvsynTN3BUmYaQ@mail.gmail.com>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-9-patrick.bellasi@arm.com> <3006911.57lVBuUGX3@aspire.rjw.lan>
 <20190122110205.lpk6o2jdfe3mttjr@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190122110205.lpk6o2jdfe3mttjr@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux PM <linux-pm@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 22, 2019 at 12:02 PM Patrick Bellasi
<patrick.bellasi@arm.com> wrote:
>
> On 22-Jan 11:37, Rafael J. Wysocki wrote:
> > On Tuesday, January 15, 2019 11:15:05 AM CET Patrick Bellasi wrote:

[cut]

> >
> > IMO it would be better to combine this patch with the next one.
>
> Main reason was to better document in the changelog what we do for the
> two different classes...
>
> > At least some things in it I was about to ask about would go away
> > then. :-)
>
> ... but if it creates confusion I can certainly merge them.
>
> Or maybe clarify better in this patch what's not clear: may I ask what
> were your questions ?
>
> > Besides, I don't really see a reason for the split here.
>
> Was mainly to make the changes required for RT more self-contained.
>
> For that class only, not for FAIR, we have additional code in the
> following patch which add uclamp_default_perf which are system
> defaults used to track/account tasks requesting the maximum frequency.
>
> Again, I can either better clarify the above patch or just merge the
> two together: what do you prefer ?

Merge the two together, please.
