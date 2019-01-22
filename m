From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v6 08/16] sched/cpufreq: uclamp: Add utilization clamping
 for FAIR tasks
Date: Tue, 22 Jan 2019 11:27:35 +0000
Message-ID: <20190122112735.lxlebhjyz3ztip5k@e110439-lin>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-9-patrick.bellasi@arm.com>
 <3006911.57lVBuUGX3@aspire.rjw.lan>
 <20190122110205.lpk6o2jdfe3mttjr@e110439-lin>
 <CAJZ5v0j2NQY_gKJOAy=rP5_1Dk9TODKNhW0vuvsynTN3BUmYaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJZ5v0j2NQY_gKJOAy=rP5_1Dk9TODKNhW0vuvsynTN3BUmYaQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux PM <linux-pm@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 22-Jan 12:04, Rafael J. Wysocki wrote:
> On Tue, Jan 22, 2019 at 12:02 PM Patrick Bellasi
> <patrick.bellasi@arm.com> wrote:
> >
> > On 22-Jan 11:37, Rafael J. Wysocki wrote:
> > > On Tuesday, January 15, 2019 11:15:05 AM CET Patrick Bellasi wrote:
> 
> Merge the two together, please.

Ok, will do in v7, thanks.

-- 
#include <best/regards.h>

Patrick Bellasi
