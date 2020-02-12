From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 0/6] clone3 & cgroups: allow spawning processes into
 cgroups
Date: Wed, 12 Feb 2020 18:01:27 -0500
Message-ID: <20200212230127.GA88887@mtj.thefacebook.com>
References: <20200205132623.670015-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200205132623.670015-1-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

On Wed, Feb 05, 2020 at 02:26:17PM +0100, Christian Brauner wrote:
> Hey Tejun,
> 
> This is v6 of the promised series to enable spawning processes into a
> target cgroup different from the parent's cgroup.

Applied 1-6 to cgroup/for-5.7. There was a conflict with 0cd9d33ace33
("cgroup: init_tasks shouldn't be linked to the root cgroup") which
got fixed up while applying. I'd really appreciate if you can take a
look to see everything is ok.

Thanks a lot for working on this. This is really great.

-- 
tejun
