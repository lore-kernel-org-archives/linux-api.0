From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [REVIEW][PATCH 0/4] /proc/thread-self
Date: Thu, 31 Jul 2014 23:16:00 -0700
Message-ID: <87ha1wag67.fsf@x220.int.ebiederm.org>
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
	<1406860795.3036.3.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1406860795.3036.3.camel-5JQ4ckphU/8SZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org> (Davidlohr
	Bueso's message of "Thu, 31 Jul 2014 19:39:55 -0700")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org> writes:

> On Thu, 2014-07-31 at 17:30 -0700, Eric W. Biederman wrote:
>> This is small chance changing /proc/net and /proc/mounts will cause
>> userspace regressions (although nothing has shown up in my testing) if
>> that happens we can just point the change that moves them from
>> /proc/self/... to /proc/thread-self/...
>
> Isn't breaking userspace a no no, no matter what? At least some
> util-linux programs makes use of both /proc/mounts and /proc/net.

The only programs that will notice that /proc/mounts and /proc/net have
changed where they point are multi-threaded programs.

The vast majority of multi-thread programs have the same mount namespace
and network namespace across all threads.  Those programs will simply
see the case where /proc/mounts and /proc/net work now after the initial
thread has terminated.  (A Bug fix).

For the weird multi-threaded applications that access /proc/mounts or
/proc/net and have different namespaces in different threads this most
likely is a bug fix.  But this could potentially introduce a regression.

Which is a long way of saying that we don't have to remain bug
compatible with past versions of linux if no one cares about our bugs.

So while I am seriously concerned about the possibility of introducing a
regression the only way to find out if anyone cares is to release the
code and to release these patches, and see if anything breaks.  The
changes that might have to be reverted are trivial one liners, so it
will be easy to fix if something shows up.

So if you or anyone else knows of applications that are multi-threaded
have different namespaces on different threads and depend on
/proc/mounts or /proc/net always reflecting the namespace of the initial
thread in the program let me know.  Until then this series fixes at
least one long-standing annoying bug.

Eric
