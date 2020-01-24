From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH 3/4] seccomp: Add SECCOMP_USER_NOTIF_FLAG_PIDFD to get
 pidfd on listener trap
Date: Fri, 24 Jan 2020 10:03:32 -0800
Message-ID: <20200124180332.GA4151@cisco>
References: <20200124091743.3357-1-sargun@sargun.me>
 <20200124091743.3357-4-sargun@sargun.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200124091743.3357-4-sargun@sargun.me>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, christian.brauner@ubuntu.com
List-Id: linux-api@vger.kernel.org

On Fri, Jan 24, 2020 at 01:17:42AM -0800, Sargun Dhillon wrote:
> Currently, this just opens the group leader of the thread that triggere
> the event, as pidfds (currently) are limited to group leaders.

I don't love the semantics of this; when they're not limited to thread
group leaders any more, we won't be able to change this. Is that work
far off?

Tycho
