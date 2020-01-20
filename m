From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v4 3/6] cgroup: refactor fork helpers
Date: Mon, 20 Jan 2020 15:04:53 +0100
Message-ID: <20200120140452.qyjogmmhyqc3gxon@wittgenstein>
References: <20200117181219.14542-1-christian.brauner@ubuntu.com>
 <20200117181219.14542-4-christian.brauner@ubuntu.com>
 <20200120140029.GB30403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200120140029.GB30403@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 20, 2020 at 03:00:30PM +0100, Oleg Nesterov wrote:
> This is probably the only patch in series I can understand ;)
> 
> To me it looks like a good cleanup regardless, but
> 
> On 01/17, Christian Brauner wrote:
> >
> > The patch just passes in the parent task_struct
> 
> For what? "parent" is always "current", no?

Yes. What exactly are you hinting at? :) Would you prefer that the
commit message speaks of "current" instead of "parent"?

Christian
