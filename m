From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH 2/4] mm: introduce external memory hinting API
Date: Tue, 14 Jan 2020 20:20:57 +0100
Message-ID: <20200114192056.b6wi4adsps6xi4t4@wittgenstein>
References: <20200110213433.94739-1-minchan@kernel.org>
 <20200110213433.94739-3-minchan@kernel.org>
 <56ea0927-ad2e-3fbd-3366-3813330f6cec@virtuozzo.com>
 <20200113104256.5ujbplyec2sk4onn@wittgenstein>
 <20200113184408.GD110363@google.com>
 <20200113191046.2tidyvc544zvchek@wittgenstein>
 <CAKOZuev5k3EquMd-6VbvruahjjtxQzRhUVo2ttgVyk+yYz9aOA@mail.gmail.com>
 <20200113204237.ew6nn4ohxu7auw3u@wittgenstein>
 <CAKOZueu=U4c2URaq8Pz-B00XV+TxaKwHRNXv3BUiDbQrLQpJ3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <CAKOZueu=U4c2URaq8Pz-B00XV+TxaKwHRNXv3BUiDbQrLQpJ3A@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Daniel Colascione <dancol@google.com>
Cc: Minchan Kim <minchan@kernel.org>, Kirill Tkhai <ktkhai@virtuozzo.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, oleksandr@redhat.com, Suren Baghdasaryan <surenb@google.com>, Tim Murray <timmurray@google.com>, Sandeep Patil <sspatil@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, John Dias <joaodias@google.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 13, 2020 at 01:04:44PM -0800, Daniel Colascione wrote:
> On Mon, Jan 13, 2020 at 12:42 PM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> >
> > On Mon, Jan 13, 2020 at 11:27:03AM -0800, Daniel Colascione wrote:
> > > On Mon, Jan 13, 2020 at 11:10 AM Christian Brauner
> > > <christian.brauner@ubuntu.com> wrote:
> > > > This does not
> > > > affect the permission checking you're performing here.
> > >
> > > Pidfds-as-capabilities sounds like a good change. Can you clarify what
> > > you mean here though? Do you mean that in order to perform some
> > > process-directed operation X on process Y, the pidfd passed to X must
> > > have been opened with PIDFD_CAP_X *and* the process *using* the pidfds
> > > must be able to perform operation X on process Y? Or do pidfds in this
> > > model "carry" permissions in the same way that an ordinary file
> > > descriptor "carries" the ability to write to a file if it was opened
> > > with O_WRONLY even if the FD is passed to a process that couldn't
> > > otherwise write to that file? Right now, pidfds are identity-only and
> > > always rely on the caller's permissions. I like the capability bit
> > > model because it makes pidfds more consistent with other file
> > > descriptors and enabled delegation of capabilities across the system.
> >
> > I'm going back and forth on this. My initial implementation has it that
> > you'd need both, PIDFD_FLAG/CAP_X and the process using the pidfd must
> > be able to perform the operation X on process Y. The alternative becomes
> > tricky for e.g. anything that requires ptrace_may_access() permissions
> > such as getting an fd out from another task based on its pidfd and so
> > on.
> 
> I think the alternative is necessary though. What's the point of the
> pidfd capability bits if they don't grant access? If I have a pidfd
> for Y that doesn't let me do operation X, but I have ambient authority
> to do Y anyway, then I can just make my own pidfd for Y and then use
> that new pidfd to do X. AFAICT, pidfd capabilities only do something
> when they replace ptrace_may_access and friends for access control.
> Otherwise, they seem purely advisory. Am I missing something?

(Sorry for the late reply. It's kinda busy atm.)
Yes, I think the best option is to explore the possibility to make them
act similar to open(). I'll try to post patches soon.

Christian
