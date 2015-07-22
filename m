From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v4 1/5] nohz_full: add support for "cpu_isolated" mode
Date: Wed, 22 Jul 2015 08:57:45 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1507220856030.17411@east.gentwo.org>
References: <1436817481-8732-1-git-send-email-cmetcalf@ezchip.com> <1436817481-8732-2-git-send-email-cmetcalf@ezchip.com> <CALCETrWaBe10u1X+AqYM7TsbguL=aF-TyuN3xjqgR5Cg2=FiAA@mail.gmail.com> <55A4271B.9040506@ezchip.com> <CALCETrUMGx+ZC9rtAAErKaGg-LEtYXMOSVD1dCi7im3b1SMrVg@mail.gmail.com>
 <55AE993E.6040501@ezchip.com> <CALCETrVoHvofNHG81Q2Vb2i1qc7f2dy=qgkyb5NWNfUgYxhE8Q@mail.gmail.com> <20150721203622.GX3717@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150721203622.GX3717@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Chris Metcalf <cmetcalf@ezchip.com>, Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Viresh Kumar <viresh.kumar@linaro.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, 21 Jul 2015, Paul E. McKenney wrote:

> > > In the current version, there's also the vmstat_update() that
> > > may schedule delayed work and interrupt the core again
> > > shortly before realizing that there are no more counter updates
> > > happening, at which point it quiesces.  Currently we handle
> > > this in cpu_isolated mode simply by spinning and waiting for
> > > the timer interrupts to complete.
> >
> > Perhaps we should fix that?
>
> Didn't Christoph Lameter fix this?  Or is this an additional problem?

Well the vmstat update must realize first that there are no outstanding
updates before switching itself off. So typically there is one extra tick.
But we could add another function that will simply fold the differential
immediately and turn the kworker task in the expectation that the
processor will stay quiet.
