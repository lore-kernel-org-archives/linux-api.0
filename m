From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 0/1] ns: introduce proc_get_ns_by_fd()
Date: Tue, 29 Sep 2015 14:05:42 -0500
Message-ID: <87si5xxczd.fsf@x220.int.ebiederm.org>
References: <20150925135246.27620.97496.stgit@buzz>
	<20150925175654.GA12504@redhat.com>
	<871tdi8pqj.fsf@x220.int.ebiederm.org>
	<20150929164315.GA16734@redhat.com>
	<874mid16bk.fsf@x220.int.ebiederm.org>
	<20150929183833.GA21875@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20150929183833.GA21875-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Oleg Nesterov's message of
	"Tue, 29 Sep 2015 20:38:33 +0200")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chen Fan <chen.fan.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> On 09/29, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>>
>> > OK, I won't insist, this too looks better to me than proc_ns_fdget(&fd_ref).
>> >
>> > And in any case fcheck_files() makes more sense than fdget(), somehow I did
>> > not think about this when I sent 1/1.
>> >
>> > Hmm. and after the quick look at cleanup_net() I can't understand whether
>> > get_net_ns_by_fd() can use ns_by_fd_rcu() + maybe_get_net(to_net_ns()) or
>> > not... Can it?
>>
>> Some of those places need a reference that allows them to sleep, and the
>> code is shared with the legacy pid case so with an addition of get_net
>> we can use ns_by_fd_rcu().   There are cases like setns that could
>> use ns_by_fd_rcu() with code reording.
>>
>> We can implement get_net_ns_by_fd as:
>> struct net *get_net_ns_by_fd(int fd)
>> {
>>         struct net *net;
>>
>> 	rcu_read_lock();
>> 	net = net_ns_by_fd_rcu(fd);
>>         if (!IS_ERR(net))
>>         	get_net(net);
>>         rcu_read_unlock();
>>
>> 	return net;
>> }
>>
>> Which means we can achieve code sharing with the pure rcu version
>> as a base.
>
> Yes, this is what I meant... but don't we need maybe_get_net() ?

Let me see.

The call chain is a little interesting so let's trace it.

thread1                               thread2
  net = net_ns_by_fd_rcu(fd);           fput(file)
  get_net(net);                           ____fput
                                            __fput
                                              dput
                                                dentry_kill
                                                  __dentry_kill
                                                    dentry_iput
                                                      iput
                                                        iput_final
                                                          evict
                                                            ->evict_inode (nsfs_evict)
                                                              netns_put
                                                                 put_net
                                                                   __put_net
                                                                      queue_work(net_cleanup_work)
                                                                      ...
                                                                      cleanup_net
                                                                        synchronize_rcu.


Given that someone in another thread can put the file descriptor and I
don't see anything explicitly waiting until after the rcu critical
section ends to put the network namespace I guess we do need
maybe_get_net.

In practice I think the delay logic in fput will act as an rcu barrier,
but that is not guaranteed so we had better not count on it.  Sigh.

Anyway this is a long ways from a syscall to translate pids.

Eric
