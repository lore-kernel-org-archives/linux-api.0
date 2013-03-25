From: Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH 0/3] posix timers: Extend kernel API to report more info
 about timers (v3)
Date: Mon, 25 Mar 2013 17:32:29 +0400
Message-ID: <515051ED.7060306@parallels.com>
References: <513D9FD9.6020507@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <513D9FD9.6020507@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Matthew Helsley <matt.helsley@gmail.com>, linux-api@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 03/11/2013 01:11 PM, Pavel Emelyanov wrote:
> Hi.
> 
> Currently kernel doesn't provide any API for getting information about
> what timers are currently created by process and in which state they 
> are. Also, the way timer IDs are generated makes it impossible to create
> a timer with any desired ID. Both facilities are very very tempting by
> the checkpoint-restore project.
> 
> That said, this series fixes posix timers API in this way:
> 
> 1. it makes timers IDs generation per-signal_struct to allow for
>    recreation of a timer with desired ID;
> 2. it adds per-task proc file where all timers created by it are
>    listed.
> 
> This v3 series is ported on v3.9-rc2 and patches' changelogs are fixed
> according to Thomas' feedback to contain info why the change is required.

Gentlemen,

I'm sorry for bothering you again, but I've (hopefully) addressed the issues
Thomas pointed out with the previous version of this set, thus I would like
to ask you about your plans about it. If there's anything else I should do,
just let me know.

Thanks,
Pavel
