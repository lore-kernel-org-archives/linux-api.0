From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] epoll: Support for disabling items, and a self-test
 app.
Date: Fri, 19 Oct 2012 15:03:29 +0200
Message-ID: <50814FA1.2050202@redhat.com>
References: <1345756535-8372-1-git-send-email-palewis@adobe.com> <CAKgNAkg0R2LwfpF8beCkawTfPu7oj_DDaDxf2VJ+xB6UTgRSaw@mail.gmail.com> <20121017163004.fb9de1b3.akpm@linux-foundation.org> <508044D7.7070005@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <508044D7.7070005@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, mtk.manpages@gmail.com, "Paton J. Lewis" <palewis@adobe.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jason Baron <jbaron@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Paul Holland <pholland@adobe.com>, Davide Libenzi <davidel@xmailserver.org>, libc-alpha@sourceware.org, Linux API <linux-api@vger.kernel.org>, paulmck@linux.vnet.ibm.com
List-Id: linux-api@vger.kernel.org

Il 18/10/2012 20:05, Andy Lutomirski ha scritto:
> 
> Unless something is rather buggy in kernel land (and I don't think it
> is), once EPOLL_CTL_DEL has returned, no call to epoll_wait that starts
> *after* EPOLL_CTL_DEL finishes will return that object.  This suggests
> an RCU-like approach: once EPOLL_CTL_DEL has returned and every thread
> has returned from an epoll_wait call that started after the
> EPOLL_CTL_DEL returns, then the data structure can be safely freed.
> 
> In pseudocode:
> 
> delete(fd, pdata) {
>   pdata->dead = true;
>   EPOLL_CTL_DEL(fd);
>   rcu_call(delete pdata);
> }
> 
> wait() {
>   epoll_wait;
>   for each event pdata {
>     if (pdata->gone) continue;
>     process the event;
>   }
> 
>   rcu_this_is_a_grace_period();
> }
> 
> Of course, these are not normal grace periods and would need to be
> tracked separately.  (The optimal data structure to do this without
> killing scalability is not obvious.  urcu presumably implements such a
> thing.)
> 
> Am I right?

Equip each thread with a) an id or something else that lets each thread
refer to "the next" thread; b) a lists of "items waiting to be deleted".
 Then the deleting thread adds the item being deleted to the first
thread's list.  Before executing epoll_wait, thread K empties its list
and passes the buck, appending the old contents of its list to that of
thread K+1.  This is an O(1) operation no matter how many items are
being deleted; only Thread N, being the last thread, actually has to go
through the list and delete the items.

The lists need to be protected by a mutex, but contention should really
be rare since there are just two writers.  Note that each thread only
needs to hold one mutex at a time, and the deletion loop does not need
to happen with the mutex held at all, so there's no worries of
"cascading" waits on the mutexes.

Compared to http://thread.gmane.org/gmane.linux.kernel/1311457, you get
rid of the per-item mutex and the operations that have to be done with
the (now per-thread) mutex held remain pretty trivial.

Paolo
