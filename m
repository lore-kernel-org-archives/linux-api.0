From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: How Not To Use kref (was Re: kdbus: add code for buses, domains and
 endpoints)
Date: Thu, 30 Oct 2014 23:38:01 +0000
Message-ID: <20141030233801.GF7996@ZenIV.linux.org.uk>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1414620056-6675-9-git-send-email-gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, desrt-0xnayjDhYQY@public.gmane.org, hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 29, 2014 at 03:00:52PM -0700, Greg Kroah-Hartman wrote:

> +static void __kdbus_domain_user_free(struct kref *kref)
> +{
> +	struct kdbus_domain_user *user =
> +		container_of(kref, struct kdbus_domain_user, kref);
> +
> +	BUG_ON(atomic_read(&user->buses) > 0);
> +	BUG_ON(atomic_read(&user->connections) > 0);
> +
> +	mutex_lock(&user->domain->lock);
	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +	idr_remove(&user->domain->user_idr, user->idr);
> +	hash_del(&user->hentry);
	^^^^^^^^^^^^^^^^^^^^^^^^
> +	mutex_unlock(&user->domain->lock);
> +
> +	kdbus_domain_unref(user->domain);
> +	kfree(user);
> +}

> +struct kdbus_domain_user *kdbus_domain_user_unref(struct kdbus_domain_user *u)
> +{
> +	if (u)
> +		kref_put(&u->kref, __kdbus_domain_user_free);
> +	return NULL;
> +}

If you remove an object from some search structures, taking the lock in
destructor is Too Fucking Late(tm).  Somebody might have already found
that puppy and decided to pick it (all under that lock) just as we'd
got to that point in destructor and blocked there.  Oops...

Normally I'd say "just use kref_put_mutex()", but this case is even worse.
Look:

refcount is 1
A: kref_put_mutex() 
	see that it's potential 1->0 crossing, need to take mutex
	mutex_lock()
B: kref_get()
refcount is 2
A:	got the sodding mutex
	atomic_dec_and_test
refcount is 1 now
	OK, it's not 1->0, after all, just drop the mutex and bugger off
B: kref_put_mutex()
	see that it's potential 1->0 crossing, need to take mutex
	mutex_lock() blocks
A:	mutex_unlock() lets B go
B:	... got it
	atomic_dec_and_test
refcount is 0
	call the destructor now, which ends with
	kdbus_domain_unref(user->domain);
	... which just happens to be the last reference to ->domain
	... and frees it, along with ->domain->mutex

But what's to guarantee that A will be past the last point where mutex_unlock()
is looking at the mutex?  Sure, it's hard to hit, but AFAICS it's not
impossible, especially if the following happens (assuming mutex-dec.h-style
mutices):

B: mutex_lock()
	atomic_dec_return -> -1
	__mutex_lock_slowpath()
A: mutex_unlock()
	atomic_inc_return -> 0
	get preempted
B: note that A has already incremented it to 0 and bugger off - we'd got it

and there we go, with A getting the timeslice back and deciding to call
__mutex_unlock_slowpath() when B has already freed the damn thing.

Basically, kref_put_mutex() is only usable when destructor callback cannot end
up freeing the mutex.

kref_get_unless_zero() might be a usable approach, but IMO the whole thing is
simply outside of kref applicability.  Using it for something that needs to
deal with removal from search structures from the destructor callback is
already stretching the things; this one is far worse.  kref isn't a universal
tool for expressing lifetime cycles.  It works for really simple cases and
might eliminate some amount of boilerplate code.  It's been greatly oversold
and overused, though...
