From: Paul Holland <pholland@adobe.com>
Subject: Re: [PATCH v2] epoll: Support for disabling items, and a self-test
 app.
Date: Fri, 19 Oct 2012 06:29:08 -0700
Message-ID: <CCA6A06A.10264%pholland@adobe.com>
References: <50814FA1.2050202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <libc-alpha-return-33748-glibc-alpha=m.gmane.org@sourceware.org>
In-Reply-To: <50814FA1.2050202@redhat.com>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
To: Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>, Paton Lewis <palewis@adobe.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jason Baron <jbaron@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Davide Libenzi <davidel@xmailserver.org>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>, Linux API <linux-api@vger.kernel.org>, "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

On 10/19/12 6:03 AM, "Paolo Bonzini" <pbonzini@redhat.com> wrote:

>Il 18/10/2012 20:05, Andy Lutomirski ha scritto:
>>=20
>> Unless something is rather buggy in kernel land (and I don't think it
>> is), once EPOLL_CTL_DEL has returned, no call to epoll_wait that starts
>> *after* EPOLL_CTL_DEL finishes will return that object.  This suggests
>> an RCU-like approach: once EPOLL_CTL_DEL has returned and every thread
>> has returned from an epoll_wait call that started after the
>> EPOLL_CTL_DEL returns, then the data structure can be safely freed.
>>=20
>> In pseudocode:
>>=20
>> delete(fd, pdata) {
>>   pdata->dead =3D true;
>>   EPOLL_CTL_DEL(fd);
>>   rcu_call(delete pdata);
>> }
>>=20
>> wait() {
>>   epoll_wait;
>>   for each event pdata {
>>     if (pdata->gone) continue;
>>     process the event;
>>   }
>>=20
>>   rcu_this_is_a_grace_period();
>> }
>>=20
>> Of course, these are not normal grace periods and would need to be
>> tracked separately.  (The optimal data structure to do this without
>> killing scalability is not obvious.  urcu presumably implements such a
>> thing.)
>>=20
>> Am I right?
>
>Equip each thread with a) an id or something else that lets each thread
>refer to "the next" thread; b) a lists of "items waiting to be deleted".
> Then the deleting thread adds the item being deleted to the first
>thread's list.  Before executing epoll_wait, thread K empties its list
>and passes the buck, appending the old contents of its list to that of
>thread K+1.  This is an O(1) operation no matter how many items are
>being deleted; only Thread N, being the last thread, actually has to go
>through the list and delete the items.
>
>The lists need to be protected by a mutex, but contention should really
>be rare since there are just two writers.  Note that each thread only
>needs to hold one mutex at a time, and the deletion loop does not need
>to happen with the mutex held at all, so there's no worries of
>"cascading" waits on the mutexes.
>
>Compared to http://thread.gmane.org/gmane.linux.kernel/1311457, you get
>rid of the per-item mutex and the operations that have to be done with
>the (now per-thread) mutex held remain pretty trivial.
>
>Paolo

A disadvantage of solutions in this direction, which was not preset in
Paton's patch, is that all calls to epoll_wait would need to specify some
timeout value (!=3D -1) to guarantee that they each come out of epoll_wait
and execute the "pass the buck" or "grace_period" logic.  So you would
then have contention between designs that want highly responsive "delete"
operations (those would require very short timeout values to epoll_wait)
and those that want low execution overhead (those would want larger
timeout values).


>
