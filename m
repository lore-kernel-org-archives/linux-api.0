From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH -next] treewide: remove unused argument in lock_release()
Date: Fri, 20 Sep 2019 08:50:36 -0400
Message-ID: <1568983836.5576.194.camel@lca.pw>
References: <1568909380-32199-1-git-send-email-cai@lca.pw>
         <20190920093700.7nfaghxdrmubp2do@willie-the-truck>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190920093700.7nfaghxdrmubp2do@willie-the-truck>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will@kernel.org>, torvalds@linux-foundation.org
Cc: ast@kernel.org, akpm@linux-foundation.org, mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, maarten.lankhorst@linux.intel.com, mripard@kernel.org, sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org, gregkh@linuxfoundation.org, jslaby@suse.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, intel-gfx@lists.freedesktop.org, tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org, tj@kernel.org, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, ocfs2-devel@oss.oracle.com, davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org, duyuyang@gmail.com, juri.lelli@redhat.com, vincent.guittot
List-Id: linux-api@vger.kernel.org

On Fri, 2019-09-20 at 10:38 +0100, Will Deacon wrote:
> On Thu, Sep 19, 2019 at 12:09:40PM -0400, Qian Cai wrote:
> > Since the commit b4adfe8e05f1 ("locking/lockdep: Remove unused argument
> > in __lock_release"), @nested is no longer used in lock_release(), so
> > remove it from all lock_release() calls and friends.
> > 
> > Signed-off-by: Qian Cai <cai@lca.pw>
> > ---
> 
> Although this looks fine to me at a first glance, it might be slightly
> easier to manage if you hit {spin,rwlock,seqcount,mutex,rwsem}_release()
> first with coccinelle scripts, and then hack lock_release() as a final
> patch. That way it's easy to regenerate things if needed.

I am not sure if it worth the extra efforts where I have to retest it on all
architectures, and the patch is really simple, but I can certainly do that if
you insist.

I have just confirmed the patch [1] also applied correctly to the latest
mainline, so it might be the best time just for Linus to merge it directly so it
does not introduce build errors later on?

[1]

https://lore.kernel.org/lkml/1568909380-32199-1-git-send-email-cai@lca.pw/
