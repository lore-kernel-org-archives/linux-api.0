From: Will Deacon <will@kernel.org>
Subject: Re: [PATCH -next] treewide: remove unused argument in lock_release()
Date: Fri, 20 Sep 2019 10:38:06 +0100
Message-ID: <20190920093700.7nfaghxdrmubp2do@willie-the-truck>
References: <1568909380-32199-1-git-send-email-cai@lca.pw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1568909380-32199-1-git-send-email-cai@lca.pw>
Sender: netdev-owner@vger.kernel.org
To: Qian Cai <cai@lca.pw>
Cc: akpm@linux-foundation.org, mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, maarten.lankhorst@linux.intel.com, mripard@kernel.org, sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org, gregkh@linuxfoundation.org, jslaby@suse.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, intel-gfx@lists.freedesktop.org, tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org, tj@kernel.org, mark@fasheh.com, jlbec@evilplan.or, joseph.qi@linux.alibaba.com, ocfs2-devel@oss.oracle.com, davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org, duyuyang@gmail.com, juri.lelli@redhat.com, vincent.guittot@linaro.org, hannes@cmpxc
List-Id: linux-api@vger.kernel.org

On Thu, Sep 19, 2019 at 12:09:40PM -0400, Qian Cai wrote:
> Since the commit b4adfe8e05f1 ("locking/lockdep: Remove unused argument
> in __lock_release"), @nested is no longer used in lock_release(), so
> remove it from all lock_release() calls and friends.
> 
> Signed-off-by: Qian Cai <cai@lca.pw>
> ---

Although this looks fine to me at a first glance, it might be slightly
easier to manage if you hit {spin,rwlock,seqcount,mutex,rwsem}_release()
first with coccinelle scripts, and then hack lock_release() as a final
patch. That way it's easy to regenerate things if needed.

Cheers,

Will
