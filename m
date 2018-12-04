From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH v9 3/4] seccomp: add a return code to trap to userspace
Date: Mon, 3 Dec 2018 18:10:09 -0600
Message-ID: <20181204001009.GA8796@mail.hallyn.com>
References: <20181203032827.27978-1-tycho@tycho.ws>
 <20181203032827.27978-4-tycho@tycho.ws>
 <20181203052650.GC31406@mail.hallyn.com>
 <20181203155211.GB3504@cisco>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181203155211.GB3504@cisco>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Dec 03, 2018 at 08:52:11AM -0700, Tycho Andersen wrote:
> On Sun, Dec 02, 2018 at 11:26:50PM -0600, Serge E. Hallyn wrote:
> > On Sun, Dec 02, 2018 at 08:28:26PM -0700, Tycho Andersen wrote:
> > > +struct seccomp_knotif {
> > > +	/* The struct pid of the task whose filter triggered the notification */
> > > +	struct task_struct *task;
> > > +
> > > +	/* The "cookie" for this request; this is unique for this filter. */
> > > +	u64 id;
> > > +
> > > +	/*
> > > +	 * The seccomp data. This pointer is valid the entire time this
> > > +	 * notification is active, since it comes from __seccomp_filter which
> > 
> > define 'active' - is a notification in state REPLIED still active?
> 
> Yes,
> 
> > Actually while looking at that, I came to wondering - when are knotifs
> > freed?  Seems like only during seccomp_notify_release(), i.e. when the
> > tracing task stops polling for events?  Is that going to be a problem?
> > Or am I misreading this?
> 
> they're stack allocated in do_user_notification(). So "active" in this
> sense really means "somewhere in do_user_notification()".

D'oh!  I see, thanks :)

> > > +	if (ret == 0 && copy_to_user(buf, &unotif, sizeof(unotif))) {
> > > +		ret = -EFAULT;
> > > +
> > > +		/*
> > > +		 * Userspace screwed up. To make sure that we keep this
> > > +		 * notification alive, let's reset it back to INIT. It
> > 
> > Is keeping the notification alive the right thing to do?
> > 
> > If userspace has messed up in something this touchy, it seems unlikely
> > that it'll to better if we give it a do-over...  I'm not sure whether
> > killing the whole thing (victim and tracer) is the right thing or not.
> 
> I suppose we could do that too. I just didn't want to get into a
> situation where the notification is lost and the task is stuck because
> userspace screwed up here.

Yeah, that's probably best - I'm just trying to see whether there is
any way that this could be abused.  My underactive imagination hasn't
come up with anything yet.

-serge
