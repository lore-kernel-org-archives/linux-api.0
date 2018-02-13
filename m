From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next 0/3] sysvipc: introduce STAT_ALL commands
Date: Tue, 13 Feb 2018 15:06:43 -0800
Message-ID: <20180213150643.0bf5b03f49be656728e1475e@linux-foundation.org>
References: <20180213174136.6346-1-dave@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180213174136.6346-1-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: mhocko@kernel.org, mtk.manpages@gmail.com, keescook@chromium.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 13 Feb 2018 09:41:33 -0800 Davidlohr Bueso <dave@stgolabs.net> wrote:

> Hi,
> 
> The following patches adds the discussed[1] new command for shm
> as well as for sems and msq as they are subject to the same discrepancies
> for ipc object permission checks between the syscall and via procfs.
> These new commands are justified in that (1) we are stuck with this
> semantics as changing syscall and procfs can break userland; and (2) some
> users can benefit from performance (for large amounts of shm segments,
> for example) from not having to parse the procfs interface.
> 
> Once (if) merged, I will submit the necesary manpage updates. But I'm
> thinking something like:
> 
> ...
> 
> [1] https://lkml.org/lkml/2017/12/19/220

It would be nice to summarize the above discussion right here, rather
than merely linking to an email thread.

A reported-by:mhocko would be appropriate.

Really, the only reason for this patchset is to speed up the userspace
interface, yes?  But the changelog is awfull skimpy on the details
here.  Who cares about it and why and which apps can be changed (ipcs?)
and why do we care and how much better does it get, etc.


Dumb question: an admin can do `chmod 0400 /proc/sysvipc/shm' and then
this data is hidden from unprivileged users.  So doesn't this change
represent a security hole for such users?
