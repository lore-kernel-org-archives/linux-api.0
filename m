From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH -next] treewide: remove unused argument in lock_release()
Date: Tue, 01 Oct 2019 08:46:44 -0400
Message-ID: <1569934004.5576.249.camel@lca.pw>
References: <1568909380-32199-1-git-send-email-cai@lca.pw>
         <20190930072938.GK4553@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190930072938.GK4553@hirez.programming.kicks-ass.net>
Sender: netdev-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, mingo@redhat.com, will@kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, maarten.lankhorst@linux.intel.com, mripard@kernel.org, sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org, gregkh@linuxfoundation.org, jslaby@suse.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, intel-gfx@lists.freedesktop.org, tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org, tj@kernel.org, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, ocfs2-devel@oss.oracle.com, davem@davemloft.net, st@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org, duyuyang@gmail.com, juri.lelli@redhat.com, vincent.guittot@linaro.org
List-Id: linux-api@vger.kernel.org

On Mon, 2019-09-30 at 09:29 +0200, Peter Zijlstra wrote:
> On Thu, Sep 19, 2019 at 12:09:40PM -0400, Qian Cai wrote:
> > Since the commit b4adfe8e05f1 ("locking/lockdep: Remove unused argument
> > in __lock_release"), @nested is no longer used in lock_release(), so
> > remove it from all lock_release() calls and friends.
> 
> Right; I never did this cleanup for not wanting the churn, but as long
> as it applies I'll take it.

Not sure when you would like to merge this. As you know, the longer it is
pending, the more churn it could have. If you could give me rough timeline
(i.e., aim for v5.4-rc2 or v5.5), I'll double-check for breakage and rebase it
if necessary.
