From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 5/6] clone3: allow spawning processes into cgroups
Date: Tue, 4 Feb 2020 12:13:07 +0100
Message-ID: <20200204111307.hxtundpcneju2y7n@wittgenstein>
References: <20200121154844.411-1-christian.brauner@ubuntu.com>
 <20200121154844.411-6-christian.brauner@ubuntu.com>
 <20200129132719.GD11384@blackbody.suse.cz>
 <20200202093702.cdlyytywty7hk3rn@wittgenstein>
 <20200203143228.GC13360@blackbody.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200203143228.GC13360-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Feb 03, 2020 at 03:32:28PM +0100, Michal Koutný wrote:
> On Sun, Feb 02, 2020 at 10:37:02AM +0100, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
> > cgroup_post_fork() is called past the point of no return for fork and
> > cgroup_css_set_put_fork() is explicitly documented as only being
> > callable before forks point of no return:
> I missed this and somehow incorrectly assumed it's called at the end of
> fork too. I find the css_set refcounting correct now.
> 
> BTW any reason why not to utilize cgroup_css_set_put_fork() for the
> regular cleanup in cgroup_post_fork() too?

Hmyeah, should be doable if we do:
kargs->cset = NULL;
cgroup_css_set_put_fork(kargs);

Christian
