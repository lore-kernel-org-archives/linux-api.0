From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v5 1/6] cgroup: unify attach permission checking
Date: Wed, 29 Jan 2020 14:25:41 +0100
Message-ID: <20200129132540.GA11384@blackbody.suse.cz>
References: <20200121154844.411-1-christian.brauner@ubuntu.com>
 <20200121154844.411-2-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200121154844.411-2-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Jan 21, 2020 at 04:48:39PM +0100, Christian Brauner <christian.brauner@ubuntu.com> wrote:
> +static int cgroup_attach_permissions(struct cgroup *src_cgrp,
> +				     struct cgroup *dst_cgrp,
> +				     struct super_block *sb, bool thread)
I suggest inverting the logic of the last argument to make it consistent
with other functions that use threadgroup argument for similar
distinction.

Apart from that
Acked-by: Michal Koutný <mkoutny@suse.com>
