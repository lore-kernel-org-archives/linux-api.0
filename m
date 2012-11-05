From: Michael Wang <wangyun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2] epoll: Support for disabling items, and a self-test
 app.
Date: Mon, 05 Nov 2012 11:09:20 +0800
Message-ID: <50972DE0.5060204@linux.vnet.ibm.com>
References: <1345756535-8372-1-git-send-email-palewis@adobe.com> <CAKgNAkg0R2LwfpF8beCkawTfPu7oj_DDaDxf2VJ+xB6UTgRSaw@mail.gmail.com> <5086D27F.1000007@adobe.com> <50873DFA.5010205@adobe.com> <CAKgNAkj=52rPitKT2b4_=dwczpfub6RQojjX4rNhFZQZHecSTA@mail.gmail.com> <20121026215242.GB19911@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121026215242.GB19911-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Helsley <matthltc-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Paton J. Lewis" <palewis-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jason Baron <jbaron-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Holland <pholland-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, "libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org" <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul McKenney <paulmck-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/27/2012 05:52 AM, Matt Helsley wrote:
> On Thu, Oct 25, 2012 at 12:23:24PM +0200, Michael Kerrisk (man-pages) wrote:
>> Hi Pat,
>>
>>
>>>> I suppose that I have a concern that goes in the other direction. Is
>>>> there not some other solution possible that doesn't require the use of
>>>> EPOLLONESHOT? It seems overly restrictive to require that the caller
>>>> must employ this flag, and imposes the burden that the caller must
>>>> re-enable monitoring after each event.
>>>>
>>>> Does a solution like the following (with no requirement for EPOLLONESHOT)
>>>> work?
>>>>
>>>> 0. Implement an epoll_ctl() operation EPOLL_CTL_XXX
>>>>    where the name XXX might be chosen based on the decision
>>>>    in 4(a).
>>>> 1. EPOLL_CTL_XXX employs a private flag, EPOLLUSED, in the
>>>>    per-fd events mask in the ready list. By default,
>>>>    that flag is off.
>>>> 2. epoll_wait() always clears the EPOLLUSED flag if a
>>>>    file descriptor is found to be ready.
>>>> 3. If an epoll_ctl(EPOLL_CTL_XXX) discovers that the EPOLLUSED
>>>>    flag is NOT set, then
>>>>         a) it sets the EPOLLUSED flag
>>>>         b) It disables I/O events (as per EPOLL_CTL_DISABLE)
>>>>            (I'm not 100% sure if this is necesary).
>>>>         c) it returns EBUSY to the caller
>>>> 4. If an epoll_ctl(EPOLL_CTL_XXX) discovers that the EPOLLUSED
>>>>    flag IS set, then it
>>>>         a) either deletes the fd or disables events for the fd
>>>>            (the choice here is a matter of design taste, I think;
>>>>            deletion has the virtue of simplicity; disabling provides
>>>>            the option to re-enable the fd later, if desired)
>>>>         b) returns 0 to the caller.
>>>>
>>>> All of the above with suitable locking around the user-space cache.
>>>>
>>>> Cheers,
>>>>
>>>> Michael
>>>
>>>
>>> I don't believe that proposal will solve the problem. Consider the case
>>> where a worker thread has just executed epoll_wait and is about to execute
>>> the next line of code (which will access the data associated with the fd
>>> receiving the event). If the deletion thread manages to call
>>> epoll_ctl(EPOLL_CTL_XXX) for that fd twice in a row before the worker thread
>>> is able to execute the next statement, then the deletion thread will
>>> mistakenly conclude that it is safe to destroy the data that the worker
>>> thread is about to access.
>>
>> Okay -- I had the idea there might be a hole in my proposal ;-).
>>
>> By the way, have you been reading the comments in the two LWN articles
>> on EPOLL_CTL_DISABLE?
>> https://lwn.net/Articles/520012/
>> http://lwn.net/SubscriberLink/520198/fd81ba0ecb1858a2/
>>
>> There's some interesting proposals there--some suggesting that an
>> entirely user-space solution might be possible. I haven't looked
>> deeply into the ideas though.
> 
> Yeah, I became quite interested so I wrote a crude epoll + urcu test.

I still think we could use this idea in kernel, actually implement the
rcu lock mechanism inside epoll_wait().

Since the epoll_wait() invoked by different threads, we could easily
track the status of epi usage by a thread, and DISABLE should return
0 only when all the threads who referenced the epi invoked epoll_wait()
again.

It's module would like:

delete thread:
	1. set fd stop flag(user flag)		//tell worker don't use fd any more
	2. epoll_ctl(DISABLE)
	3. if return BUSY, try later					//rcu_syn
	3. else, do delete

worker thread:
	1. invoke epoll_wait()
	2. if fd stop flag set, epoll_wait() again
	3. else, do job on fd

in epoll_wait():
	1. epi event arrived
	2. if epi stop flag set(kernel flag), don't return it
	3. else, record epi usage in current thread and add
	   it's ref count						//rcu_lock
	4. dec the epi ref count when thread invoke
	   epoll_wait() again						//rcu_unlock

in epoll_ctl(DISABLE):
	1. set epi stop flag(kernel flag)
	2. if epi ref count is not 0, return BUSY

Please let me know if I miss some thing ;-)

Regards,
Michael Wang

> Since it's RCU review to ensure I've not made any serious mistakes could
> be quite helpful:
> 
> #define _LGPL_SOURCE 1
> #define _GNU_SOURCE 1
> 
> #include <stdlib.h>
> #include <stdio.h>
> #include <string.h>
> #include <unistd.h>
> #include <pthread.h>
> #include <errno.h>
> #include <fcntl.h>
> #include <time.h>
> 
> #include <sys/epoll.h>
> 
> /*
>  * Locking Voodoo:
>  *
>  * The globabls prefixed by _ require special care because they will be
>  * accessed from multiple threads.
>  *
>  * The precise locking scheme we use varies whether READERS_USE_MUTEX is defined
>  * When we're using userspace RCU the mutex only gets acquired for writes
>  *     to _-prefixed globals. Reads are done inside RCU read side critical
>  *     sections.
>  * Otherwise the epmutex covers reads and writes to them all and the test
>  * is not very scalable.
>  */
> static pthread_mutex_t epmutex = PTHREAD_MUTEX_INITIALIZER;
> static int _p[2]; /* Send dummy data from one thread to another */
> static int _epfd; /* Threads wait to read/write on epfd */
> static int _nepitems = 0;
> 
> #ifdef READERS_USE_MUTEX
> #define init_lock() do {} while(0)
> #define init_thread() do {} while(0)
> #define read_lock pthread_mutex_lock
> #define read_unlock pthread_mutex_unlock
> #define fini_thread() do {} while(0)
> /* Because readers use the mutex synchronize_rcu() is a no-op */
> #define synchronize_rcu() do {} while(0)
> #else
> #include <urcu.h>
> #define init_lock rcu_init
> #define init_thread rcu_register_thread
> #define read_lock(m) rcu_read_lock()
> #define read_unlock(m) rcu_read_unlock()
> #define fini_thread() do { rcu_unregister_thread(); } while(0)
> #endif
> #define write_lock pthread_mutex_lock
> #define write_unlock pthread_mutex_unlock
> 
> /* We send this data through the pipe. */
> static const char *data = "test";
> const size_t dlen = 5;
> 
> static inline int harmless_errno(void)
> {
> 	return ((errno == EWOULDBLOCK) || (errno == EAGAIN) || (errno == EINTR));
> }
> 
> static void* thread_main(void *thread_nr)
> {
> 	struct epoll_event ev;
> 	int rc = 0;
> 	char buffer[dlen];
> 	unsigned long long _niterations = 0;
> 
> 	init_thread();
> 	while (!rc) {
> 		read_lock(&epmutex);
> 		if (_nepitems < 1) {
> 			read_unlock(&epmutex);
> 			break;
> 		}
> 		rc = epoll_wait(_epfd, &ev, 1, 1);
> 		if (rc < 1) {
> 			read_unlock(&epmutex);
> 			if (rc == 0)
> 				continue;
> 			if (harmless_errno()) {
> 				rc = 0;
> 				continue;
> 			}
> 			break;
> 		}
> 
> 		if (ev.events & EPOLLOUT) {
> 			rc = write(_p[1], data, dlen);
> 			read_unlock(&epmutex);
> 			if (rc < 0) {
> 				if (harmless_errno()) {
> 					rc = 0;
> 					continue;
> 				}
> 				break;
> 			}
> 			rc = 0;
> 		} else if (ev.events & EPOLLIN) {
> 			rc = read(_p[0], buffer, dlen);
> 			read_unlock(&epmutex);
> 			if (rc < 0) {
> 				if (harmless_errno()) {
> 					rc = 0;
> 					continue;
> 				}
> 				break;
> 			}
> 			rc = 0;
> 		} else
> 			read_unlock(&epmutex);
> 		_niterations++;
> 	}
> 	fini_thread();
> 	return (void *)_niterations;
> }
> 
> /* Some sample numbers from varying MAX_THREADS on my laptop:
>  * With a global mutex:
>  * 1 core for the main thread
>  * 1 core for epoll_wait()'ing threads
>  * The mutex doesn't scale -- increasing the number of threads despite
>  * having more real cores just causes performance to go down.
>  * 7 threads,  213432.128160 iterations per second
>  * 3 threads,  606560.183997 iterations per second
>  * 2 threads, 1346006.413404 iterations per second
>  * 1 thread , 2148936.348793 iterations per second
>  *
>  * With URCU:
>  * 1 core for the main thread which spins reading niterations.
>  * N-1 cores for the epoll_wait()'ing threads.
>  * "Hyperthreading" doesn't help here -- I've got 4 cores:
>  * 7 threads, 1537304.965009 iterations per second
>  * 4 threads, 1912846.753203 iterations per second
>  * 3 threads, 2278639.336464 iterations per second
>  * 2 threads, 1928805.899146 iterations per second
>  * 1 thread , 2007198.066327 iterations per second
>  */
> #define MAX_THREADS 3
> 
> int main (int argc, char **argv)
> {
> 	struct timespec before, req, after;
> 	unsigned long long niterations = 0;
> 	pthread_t threads[MAX_THREADS];
> 	struct epoll_event ev;
> 	int nthreads = 0, rc;
> 
> 	init_lock();
> 
> 	/* Since we haven't made the threads yet we can safely use _ globals */
> 	rc = pipe2(_p, O_NONBLOCK);
> 	if (rc < 0)
> 		goto error;
> 
> 	_epfd = epoll_create1(EPOLL_CLOEXEC);
> 	if (_epfd < 0)
> 		goto error;
> 
> 	/* Monitor the pipe via epoll */
> 	ev.events = EPOLLIN;
> 	ev.data.u32 = 0; /* index in _p[] */
> 	rc = epoll_ctl(_epfd, EPOLL_CTL_ADD, _p[0], &ev);
> 	if (rc < 0)
> 		goto error;
> 	_nepitems++;
> 	printf("Added fd %d to epoll set %d\n", _p[0], _epfd);
> 	ev.events = EPOLLOUT;
> 	ev.data.u32 = 1;
> 	rc = epoll_ctl(_epfd, EPOLL_CTL_ADD, _p[1], &ev);
> 	if (rc < 0)
> 		goto error;
> 	_nepitems++;
> 	printf("Added fd %d to epoll set %d\n", _p[1], _epfd);
> 	fflush(stdout);
> 
> 	/* 
> 	 * After the first pthread_create() we can't safely use _ globals
> 	 * without adhering to the locking scheme. pthread_create() should
> 	 * also imply some thorough memory barriers so all our previous
> 	 * modifications to the _ globals should be visible after this point.
> 	 */
> 	for (rc = 0; nthreads < MAX_THREADS; nthreads++) {
> 		rc = pthread_create(&threads[nthreads], NULL, &thread_main,
> 				    (void *)(long)nthreads);
> 		if (rc < 0)
> 			goto error;
> 	}
> 
> 	/* Wait for our child threads to do some "work" */
> 	req.tv_sec = 30;
> 	rc = clock_gettime(CLOCK_MONOTONIC_RAW, &before);
> 	rc = nanosleep(&req, NULL);
> 	rc = clock_gettime(CLOCK_MONOTONIC_RAW, &after);
> 
> 	/* 
> 	 * Modify the epoll interest set. This can leave stale
> 	 * data in other threads because they may have done an
> 	 * epoll_wait() with RCU read lock held instead of the
> 	 * epmutex.
> 	 */
> 	write_lock(&epmutex);
> 	rc = epoll_ctl(_epfd, EPOLL_CTL_DEL, _p[0], &ev);
> 	if (rc == 0) {
> 		_nepitems--;
> 		printf("Removed fd %d from epoll set %d\n", _p[0], _epfd);
> 		rc = epoll_ctl(_epfd, EPOLL_CTL_DEL, _p[1], &ev);
> 		if (rc == 0) {
> 			printf("Removed fd %d from epoll set %d\n", _p[1], _epfd);
> 			_nepitems--;
> 		}
> 	}
> 	write_unlock(&epmutex);
> 	if (rc < 0)
> 		goto error;
> 
> 	/*
> 	 * Wait until the stale data are no longer in use.
> 	 * We could use call_rcu() here too, but let's keep the test simple.
> 	 */
> 	printf("synchronize_rcu()\n");
> 	fflush(stdout);
> 	synchronize_rcu();
> 
> 	printf("closing fds\n");
> 	fflush(stdout);
> 
> 	/* Clean up the stale data */
> 	close(_p[0]);
> 	close(_p[1]);
> 	close(_epfd);
> 	
> 	printf("closed fds (%d, %d, %d)\n", _p[0], _p[1], _epfd);
> 	fflush(stdout);
> 
> 	/*
> 	 * Test is done. Join all the threads so that we give time for
> 	 * races to show up.
> 	 */
> 	niterations = 0;
> 	for (; nthreads > 0; nthreads--) {
> 		unsigned long long thread_iterations;
> 
> 		rc = pthread_join(threads[nthreads - 1],
> 				  (void *)&thread_iterations);
> 		niterations += thread_iterations;
> 	}
> 
> 	after.tv_sec -= before.tv_sec;
> 	after.tv_nsec -= before.tv_nsec;
> 	if (after.tv_nsec < 0) {
> 		--after.tv_sec;
> 		after.tv_nsec += 1000000000;
> 	}
> 	printf("%f iterations per second\n", (double)niterations/((double)after.tv_sec + (double)after.tv_nsec/1000000000.0));
> 	exit(EXIT_SUCCESS);
> error:
> 	/* This is trashy testcase code -- it doesn't do full cleanup! */
> 	for (; nthreads > 0; nthreads--)
> 		rc = pthread_cancel(threads[nthreads - 1]);
> 	exit(EXIT_FAILURE);
> }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
