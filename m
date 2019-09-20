From: Will Deacon <will@kernel.org>
Subject: Re: [PATCH -next] treewide: remove unused argument in lock_release()
Date: Fri, 20 Sep 2019 14:49:43 +0100
Message-ID: <20190920134942.iiygzg6s7dcay56l@willie-the-truck>
References: <1568909380-32199-1-git-send-email-cai@lca.pw>
 <20190920093700.7nfaghxdrmubp2do@willie-the-truck>
 <1568983836.5576.194.camel@lca.pw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1568983836.5576.194.camel@lca.pw>
Sender: linux-kernel-owner@vger.kernel.org
To: Qian Cai <cai@lca.pw>
Cc: torvalds@linux-foundation.org, ast@kernel.org, akpm@linux-foundation.org, mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, maarten.lankhorst@linux.intel.com, mripard@kernel.org, sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org, gregkh@linuxfoundation.org, jslaby@suse.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, intel-gfx@lists.freedesktop.org, tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org, tj@kernel.org, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, ocfs2-devel@oss.oracle.com, davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org, duyuyang@gmail.com, juri.lelli@redh
List-Id: linux-api@vger.kernel.org

On Fri, Sep 20, 2019 at 08:50:36AM -0400, Qian Cai wrote:
> On Fri, 2019-09-20 at 10:38 +0100, Will Deacon wrote:
> > On Thu, Sep 19, 2019 at 12:09:40PM -0400, Qian Cai wrote:
> > > Since the commit b4adfe8e05f1 ("locking/lockdep: Remove unused argument
> > > in __lock_release"), @nested is no longer used in lock_release(), so
> > > remove it from all lock_release() calls and friends.
> > > 
> > > Signed-off-by: Qian Cai <cai@lca.pw>
> > > ---
> > 
> > Although this looks fine to me at a first glance, it might be slightly
> > easier to manage if you hit {spin,rwlock,seqcount,mutex,rwsem}_release()
> > first with coccinelle scripts, and then hack lock_release() as a final
> > patch. That way it's easy to regenerate things if needed.
> 
> I am not sure if it worth the extra efforts where I have to retest it on all
> architectures, and the patch is really simple, but I can certainly do that if
> you insist.

I'm not insisting, just thought it might be easier to get it merged that
way. If you prefer to go with the big diff,

Acked-by: Will Deacon <will@kernel.org>

Will
