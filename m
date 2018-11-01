From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v8 1/2] seccomp: add a return code to trap to userspace
Date: Thu, 1 Nov 2018 13:56:35 -0600
Message-ID: <20181101195635.GG2180@cisco>
References: <20181029224031.29809-1-tycho@tycho.ws>
 <20181029224031.29809-2-tycho@tycho.ws>
 <20181101134001.GA23232@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181101134001.GA23232@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Nov 01, 2018 at 02:40:02PM +0100, Oleg Nesterov wrote:
> On 10/29, Tycho Andersen wrote:
> >
> > +static struct file *init_listener(struct seccomp_filter *filter)
> > +{
> > +	struct file *ret = ERR_PTR(-EBUSY);
> > +	struct seccomp_filter *cur, *last_locked = NULL;
> > +	int filter_nesting = 0;
> > +
> > +	for (cur = current->seccomp.filter; cur; cur = cur->prev) {
> > +		mutex_lock_nested(&cur->notify_lock, filter_nesting);
> > +		filter_nesting++;
> > +		last_locked = cur;
> > +		if (cur->notif)
> > +			goto out;
> > +	}
> 
> Somehow I no longer understand why do you need to take all locks. Isn't
> the first filter's notify_lock enough? IOW,
> 
> 		for (cur = current->seccomp.filter; cur; cur = cur->prev) {
> 			if (cur->notif)
> 				return ERR_PTR(-EBUSY);
> 			first = cur;
> 		}
> 
> 		if (first)
> 			mutex_lock(&first->notify_lock);
> 
> 		... initialize filter->notif ...
> 
> 	out:
> 		if (first)
> 			mutex_unlock(&first->notify_lock);
> 
> 		return ret;

The idea here is to prevent people from "nesting" notify filters. So
if any filter in the chain has a listener attached, it refuses to
install another filter with a listener.

But it just occurred to me that we don't handle the TSYNC case
correctly by doing it this way, and it's not necessarily obvious to me
how we can :). So let me look into that.

Tycho
