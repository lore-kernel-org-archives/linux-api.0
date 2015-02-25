From: Mitchell Erblich <erblichs-ihVZJaRskl1bRRN4PJnoQQ@public.gmane.org>
Subject: Notification and Proposals to changes of the Scheduling subsystem
Date: Tue, 24 Feb 2015 17:20:22 -0800
Message-ID: <71F17C8D-ECCA-4B37-9278-81DFCB79A556@earthlink.net>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jbeulich-UKVsQwr1y4U@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Please note that this engineer only receives memory subsystem patches a=
nd thus please include my email on responses.

Please note that this proposal is from this engineer.

This also fulfills any legal notification of work done, but not submitt=
ed.


	Notification & Proposal of Feasibility to Support System V Release 4 D=
efacto Standard Scheduling Extensions, etc within Linux


SCHED_IA
	Over 10 years ago, System V Release 4 was enhanced with additional fea=
tures by Sun Microsystems. One of the more minor extensions dealt with =
the subdivision of process=92s scheduling characteristics and was known=
 as he INTERACTIVE /IA scheduling class. This scheduling class was targ=
eted to frequent sleepers, with the mouse icon being one the first proc=
esses/tasks..

	Linux has no explicit SCHED_IA scheduling policy, but does alter sched=
uling characteristics based on some sleep behavior (example: GENTLE_FAI=
R_SLEEPERS) within the fair share scheduling configuration option. Proc=
esses / tasks that are CPU bound that fit into a SLEEPER behavior can h=
ave a hybrid behavior over time where during any one scheduling period,=
 it may consume its variable length allocated time. This can alter its =
expected short latency to be current / ONPROC. To simplify the implemen=
tation, it is suggested that SCHED_IA be a sub scheduling policy of SCH=
ED_NORMAL. Shouldn=92t an administrator be able to classify that the NO=
RMAL long term behavior of a task, be one as a FIXED sleeper?=20

	Thus, the first Proposal is to explicitly support the SCHED_IA schedul=
ing policy within the Linux kernel. After kernel support, any applicati=
on that has the same functionality as priocntl(1) then needs to be alte=
red to support this new scheduling policy.


Note: Administrator in this context should be a task with a UID, EUID, =
GID, EGID, etc, that has the proper CAPABILITY to alter scheduling beha=
vior.


SCHED_UNFAIR
		UNIX / Linux scheduling has in the most part attempt to achieve some =
level of process / task scheduling fairness with Linux using the fair s=
hare scheduling class. Exceptions do exist, but are not being discussed=
 below. In general this type of scheduling is acceptable in a generic i=
mplementation, but has weaknesses when UNIX / Linux is moved into a dif=
ferent environment. Many companies use UNIX / Linux in heavy networking=
 environments where one or more tasks can infrequently attempt to consu=
me more than its fair share.

		This proposal is to acknowledge that =93nice=94 and a few other sched=
uling workarounds do no always suffice to allow this temporary inequali=
ty to exist. Yes, a cpumask could be set that allows only certain tasks=
 to run on specific nodes, however the implied assumption is that they =
only infrequently need to have inequality / greater =93time slice=94 th=
an their fair share. A network protocol example is a convergence task t=
hat needs to run until it is finished and until that happens needed rou=
ting changes will not occur. The time window in which all tasks need to=
 be run, SHOULD not need this task in consecutive time windows, thus ov=
er longer periods of time, it still fulfills the fair scheduling policy=
=2E Again the proper CAPABILITY needs to be specified with the priocntl=
(1) like application as running many tasks per CPU COULD then effect th=
e performance of the system.

		Thus, explicit support for a new SCHED_UNFAIR scheduling policy is pr=
oposed / suggested within the Linux kernel. Again it can be a sub sched=
uling policy of SCHED_NORMAL.

Thank you,
		Mitchell Erblich
		UNIX Kernel Engineer
=09


=09


=09
			--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
