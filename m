From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v8 1/2] seccomp: add a return code to trap to userspace
Date: Fri, 2 Nov 2018 07:38:39 -0600
Message-ID: <20181102133839.GJ2180@cisco>
References: <20181029224031.29809-1-tycho@tycho.ws>
 <20181029224031.29809-2-tycho@tycho.ws>
 <20181101134001.GA23232@redhat.com>
 <20181101195635.GG2180@cisco>
 <20181102100234.GA12360@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181102100234.GA12360@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 02, 2018 at 11:02:35AM +0100, Oleg Nesterov wrote:
> On 11/01, Tycho Andersen wrote:
> >
> > On Thu, Nov 01, 2018 at 02:40:02PM +0100, Oleg Nesterov wrote:
> > >
> > > Somehow I no longer understand why do you need to take all locks. Isn't
> > > the first filter's notify_lock enough? IOW,
> > >
> > > 		for (cur = current->seccomp.filter; cur; cur = cur->prev) {
> > > 			if (cur->notif)
> > > 				return ERR_PTR(-EBUSY);
> > > 			first = cur;
> > > 		}
> > >
> > > 		if (first)
> > > 			mutex_lock(&first->notify_lock);
> > >
> > > 		... initialize filter->notif ...
> > >
> > > 	out:
> > > 		if (first)
> > > 			mutex_unlock(&first->notify_lock);
> > >
> > > 		return ret;
> >
> > The idea here is to prevent people from "nesting" notify filters. So
> > if any filter in the chain has a listener attached, it refuses to
> > install another filter with a listener.
> 
> Yes, I understand, so we need to check cur->notif. My point was, we do not
> need to take all the locks in the ->prev chain, we need only one:
> first->notify_lock.
> 
> But you know what? today I think that we do not need any locking at all,
> all we need is the lockless
> 
> 	for (cur = current->seccomp.filter; cur; cur = cur->prev)
> 		if (cur->notif)
> 			return ERR_PTR(-EBUSY);
> 
> at the start, nothing more.

Hmm, you're right. The locking is residual from when the old ptrace()
API was also a thing: with that, you could attach a filter at any
point in the tree, so we needed to lock to prevent that. But now
that it's only possible to do it at the bottom, we don't need to lock.

> > But it just occurred to me that we don't handle the TSYNC case
> > correctly by doing it this way,
> 
> Why? Perhaps I missed your point, but TSYNC case looks fine. I mean, if 2
> threads do seccomp_set_mode_filter(NEW_LISTENER | TSYNC) then only one can
> win the race and succeed, but this has nothing to do with init_listener(),
> we rely on ->siglock and is_ancestor() check.

Yes, agreed.

Thanks!

Tycho
