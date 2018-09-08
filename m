From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v6 1/5] seccomp: add a return code to trap to userspace
Date: Sat, 8 Sep 2018 14:35:56 -0600
Message-ID: <20180908203556.GF3444@cisco.cisco.com>
References: <20180906152859.7810-1-tycho@tycho.ws>
 <20180906152859.7810-2-tycho@tycho.ws>
 <20180906221412.GA26209@sec>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180906221412.GA26209@sec>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyler Hicks <tyhicks@canonical.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 06, 2018 at 10:15:12PM +0000, Tyler Hicks wrote:
> On 2018-09-06 09:28:55, Tycho Andersen wrote:
> >  /**
> >   * struct seccomp_filter - container for seccomp BPF programs
> >   *
> > @@ -66,6 +114,30 @@ struct seccomp_filter {
> >  	bool log;
> >  	struct seccomp_filter *prev;
> >  	struct bpf_prog *prog;
> > +
> > +#ifdef CONFIG_SECCOMP_USER_NOTIFICATION
> > +	/*
> > +	 * A semaphore that users of this notification can wait on for
> > +	 * changes. Actual reads and writes are still controlled with
> > +	 * filter->notify_lock.
> > +	 */
> > +	struct semaphore request;
> > +
> > +	/* A lock for all notification-related accesses. */
> > +	struct mutex notify_lock;
> > +
> > +	/* Is there currently an attached listener? */
> > +	bool has_listener;
> > +
> > +	/* The id of the next request. */
> > +	u64 next_id;
> > +
> > +	/* A list of struct seccomp_knotif elements. */
> > +	struct list_head notifications;
> > +
> > +	/* A wait queue for poll. */
> > +	wait_queue_head_t wqh;
> > +#endif
> 
> I suspect that these additions would benefit from better struct packing
> since there could be a lot of seccomp_filter structs floating around in
> memory on a system with a large number of running containers or
> otherwise sandboxed processes.
> 
> IIRC, there's a 3 byte hole following the log member that could be used
> by has_listener, at least, and I'm not sure how the rest of the new
> members affect things.

So it turns out the additions are fairly major. The previous
sizeof(struct seccomp_filter) == 24 bytes on x86_64, with the three
byte hole you mentioned.

The new members alone actual sizes are:

sizeof(struct sempahore) request == 80
sizeof(struct mutex) notify_lock == 128
sizeof(struct list_head) notifications == 16
sizeof(struct wait_queue_head_t) wqh == 72

+ the base types of next_id, has_listener gives a grand total of 305
additional bytes, assuming it's packed perfectly. That seems like
quite a huge hit for everyone to endure, especially since it won't be
perfectly packed.

Instead, what if we add a struct notification, and a struct
notification* to struct seccomp_filter? Then we can drop the bool
has_listener because we can use a null test, and the 304 bytes are
only paid by people who actually use this feature (as well as the cost
of an additional indirection, but who cares, they're trapping to
userspace anyway). Unless I hear any objections, I'll do this for v7
:)

Tycho
