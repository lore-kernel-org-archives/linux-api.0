From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm v9 0/8] idle memory tracking
Date: Mon, 27 Jul 2015 12:25:27 -0700
Message-ID: <20150727122527.c6f7786177e9b5096e623d18@linux-foundation.org>
References: <cover.1437303956.git.vdavydov@parallels.com>
	<20150721163402.43ad2527d9b8caa476a1c9e1@linux-foundation.org>
	<CAGXu5jLPT-2c_H3kjCzbVgRKQO0xMskVd7JcAMmWZSmFgzZ4ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLPT-2c_H3kjCzbVgRKQO0xMskVd7JcAMmWZSmFgzZ4ng@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>, Andres Lagar-Cavilla <andreslc@google.com>, Minchan Kim <minchan@kernel.org>, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>, Michel Lespinasse <walken@google.com>, David Rientjes <rientjes@google.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Jonathan Corbet <corbet@lwn.net>, Linux API <linux-api@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, 27 Jul 2015 12:18:57 -0700 Kees Cook <keescook@chromium.org> wrote:

> > Why were these put in /proc anyway?  Rather than under /sys/fs/cgroup
> > somewhere?  Presumably because /proc/kpageidle is useful in non-memcg
> > setups.
> 
> Do we need a /proc/vm/ for holding these kinds of things? We're
> collecting a lot there. Or invent some way for this to be sensible in
> /sys?

/proc is the traditional place for such things (/proc/kpagecount,
/proc/kpageflags, /proc/pagetypeinfo).  But that was probably a
mistake.

/proc/sys/vm is rather a dumping ground of random tunables and
statuses, but yes, I do think that moving the kpageidle stuff into there
would be better.
