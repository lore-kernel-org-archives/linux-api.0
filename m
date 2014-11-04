From: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: How Not To Use kref (was Re: kdbus: add code for buses, domains
 and endpoints)
Date: Tue, 4 Nov 2014 10:11:09 +0100
Message-ID: <CANq1E4RGrqZxxBi+_Ub_jnwZwQABh92tu-6sPf3Ar8TgzPcP1A@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
	<1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
	<20141030233801.GF7996@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141030233801.GF7996-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Alban Crequy <alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Al

On Fri, Oct 31, 2014 at 12:38 AM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
> On Wed, Oct 29, 2014 at 03:00:52PM -0700, Greg Kroah-Hartman wrote:
>
>> +static void __kdbus_domain_user_free(struct kref *kref)
>> +{
>> +     struct kdbus_domain_user *user =
>> +             container_of(kref, struct kdbus_domain_user, kref);
>> +
>> +     BUG_ON(atomic_read(&user->buses) > 0);
>> +     BUG_ON(atomic_read(&user->connections) > 0);
>> +
>> +     mutex_lock(&user->domain->lock);
>         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> +     idr_remove(&user->domain->user_idr, user->idr);
>> +     hash_del(&user->hentry);
>         ^^^^^^^^^^^^^^^^^^^^^^^^
>> +     mutex_unlock(&user->domain->lock);
>> +
>> +     kdbus_domain_unref(user->domain);
>> +     kfree(user);
>> +}
>
>> +struct kdbus_domain_user *kdbus_domain_user_unref(struct kdbus_domain_user *u)
>> +{
>> +     if (u)
>> +             kref_put(&u->kref, __kdbus_domain_user_free);
>> +     return NULL;
>> +}
>
> If you remove an object from some search structures, taking the lock in
> destructor is Too Fucking Late(tm).  Somebody might have already found
> that puppy and decided to pick it (all under that lock) just as we'd
> got to that point in destructor and blocked there.  Oops...

Nice catch! I fixed it up via kref_get_unless_zero(). This has the
side-effect that there might be multiple domain_user objects for the
same user, but all but one will have ref==0. They don't carry and
valuable data in those cases, so we're fine. We will just end up using
the next one, or creating a new one.

Thanks a lot!
David
