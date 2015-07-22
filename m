From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v4 1/5] nohz_full: add support for "cpu_isolated" mode
Date: Wed, 22 Jul 2015 15:02:28 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1507221501220.15682@east.gentwo.org>
References: <1436817481-8732-1-git-send-email-cmetcalf@ezchip.com> <1436817481-8732-2-git-send-email-cmetcalf@ezchip.com> <CALCETrWaBe10u1X+AqYM7TsbguL=aF-TyuN3xjqgR5Cg2=FiAA@mail.gmail.com> <55A4271B.9040506@ezchip.com> <CALCETrUMGx+ZC9rtAAErKaGg-LEtYXMOSVD1dCi7im3b1SMrVg@mail.gmail.com>
 <55AE993E.6040501@ezchip.com> <CALCETrVoHvofNHG81Q2Vb2i1qc7f2dy=qgkyb5NWNfUgYxhE8Q@mail.gmail.com> <20150721203622.GX3717@linux.vnet.ibm.com> <alpine.DEB.2.11.1507220856030.17411@east.gentwo.org> <20150722192834.GA32511@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150722192834.GA32511@linux.vnet.ibm.com>
Sender: linux-doc-owner@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Chris Metcalf <cmetcalf@ezchip.com>, Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Viresh Kumar <viresh.kumar@linaro.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, 22 Jul 2015, Paul E. McKenney wrote:

> > > Didn't Christoph Lameter fix this?  Or is this an additional problem?
> >
> > Well the vmstat update must realize first that there are no outstanding
> > updates before switching itself off. So typically there is one extra tick.
> > But we could add another function that will simply fold the differential
> > immediately and turn the kworker task in the expectation that the
> > processor will stay quiet.
>
> Got it, thank you!
>
> 								Thanx, Paul

Ok here is a function that quiets down the vmstat kworkers.


Subject: vmstat: provide a function to quiet down the diff processing

quiet_vmstat() can be called in anticipation of a OS "quiet" period
where no tick processing should be triggered. quiet_vmstat() will fold
all pending differentials into the global counters and disable the
vmstat_worker processing.

Note that the shepherd thread will continue scanning the differentials
from another processor and will reenable the vmstat workers if it
detects any changes.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/vmstat.c
===================================================================
--- linux.orig/mm/vmstat.c
+++ linux/mm/vmstat.c
@@ -1394,6 +1394,20 @@ static void vmstat_update(struct work_st
 }

 /*
+ * Switch off vmstat processing and then fold all the remaining differentials
+ * until the diffs stay at zero. The function is used by NOHZ and can only be
+ * invoked when tick processing is not active.
+ */
+void quiet_vmstat(void)
+{
+	do {
+		if (!cpumask_test_and_set_cpu(smp_processor_id(), cpu_stat_off))
+			cancel_delayed_work(this_cpu_ptr(&vmstat_work));
+
+	} while (refresh_cpu_vm_stats());
+}
+
+/*
  * Check if the diffs for a certain cpu indicate that
  * an update is needed.
  */
Index: linux/include/linux/vmstat.h
===================================================================
--- linux.orig/include/linux/vmstat.h
+++ linux/include/linux/vmstat.h
@@ -211,6 +211,7 @@ extern void __inc_zone_state(struct zone
 extern void dec_zone_state(struct zone *, enum zone_stat_item);
 extern void __dec_zone_state(struct zone *, enum zone_stat_item);

+void quiet_vmstat(void);
 void cpu_vm_stats_fold(int cpu);
 void refresh_zone_stat_thresholds(void);

@@ -272,6 +273,7 @@ static inline void __dec_zone_page_state
 static inline void refresh_cpu_vm_stats(int cpu) { }
 static inline void refresh_zone_stat_thresholds(void) { }
 static inline void cpu_vm_stats_fold(int cpu) { }
+static inline void quiet_vmstat(void) { }

 static inline void drain_zonestat(struct zone *zone,
 			struct per_cpu_pageset *pset) { }
