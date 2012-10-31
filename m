From: Michael Wang <wangyun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v3] epoll: Support for disabling items, and a self-test
 app.
Date: Wed, 31 Oct 2012 14:32:22 +0800
Message-ID: <5090C5F6.6000603@linux.vnet.ibm.com>
References: <1351210112-23238-1-git-send-email-palewis@adobe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351210112-23238-1-git-send-email-palewis-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Paton J. Lewis" <palewis-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jason Baron <jbaron-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Holland <pholland-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 10/26/2012 08:08 AM, Paton J. Lewis wrote:
> From: "Paton J. Lewis" <palewis-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>
> 
> It is not currently possible to reliably delete epoll items when using the
> same epoll set from multiple threads. After calling epoll_ctl with
> EPOLL_CTL_DEL, another thread might still be executing code related to an
> event for that epoll item (in response to epoll_wait). Therefore the deleting
> thread does not know when it is safe to delete resources pertaining to the
> associated epoll item because another thread might be using those resources.
> 
> The deleting thread could wait an arbitrary amount of time after calling
> epoll_ctl with EPOLL_CTL_DEL and before deleting the item, but this is
> inefficient and could result in the destruction of resources before another
> thread is done handling an event returned by epoll_wait.
> 
> This patch enhances epoll_ctl to support EPOLL_CTL_DISABLE, which disables an
> epoll item. If epoll_ctl returns -EBUSY in this case, then another thread may
> handling a return from epoll_wait for this item. Otherwise if epoll_ctl
> returns 0, then it is safe to delete the epoll item. This allows multiple
> threads to use a mutex to determine when it is safe to delete an epoll item
> and its associated resources, which allows epoll items to be deleted both
> efficiently and without error in a multi-threaded environment. Note that
> EPOLL_CTL_DISABLE is only useful in conjunction with EPOLLONESHOT, and using
> EPOLL_CTL_DISABLE on an epoll item without EPOLLONESHOT returns -EINVAL.
> 
> This patch also adds a new test_epoll self-test program to both demonstrate
> the need for this feature and test it.

Hi, Paton

I'm just think about may be we could use this way.

Seems like currently we are depending on the epoll_ctl() to indicate the
start point of safe section and epoll_wait() for the end point, like:
	
	while () {	
		epoll_wait()			--------------

		fd event arrived		safe section

		clear fd epi->event.events	
						--------------
		if (fd need stop)
			continue;
						--------------
		...fd data process...

		epoll_ctl(MOD)			danger section

		set fd epi->event.events 	--------------

		continue;
	}

So we got a safe section and do delete work in this section won't cause
trouble since we have a stop check directly after it.

Actually what we want is to make sure no one will touch the fd any more
after we DISABLE it.

Then what about we add a ref count and a stop flag in epi, maintain it like:

	epoll_wait()

	check user events and
	dec the ref count of fd		---------------------------

	...

	fd event arrived		safe sec if ref count is 0

	if epi stop flag set
		do nothing
	else
		inc epi ref count	---------------------------
		send event

And what DISABLE do is:

	set epi stop flag

	if epi ref count is not 0
		wait until ref count be 0

So after DISABLE return, we can safely delete any thing related to that epi.

One thing is that the user should not change the events info returned by
epoll_wait().

It's just a propose, but if it works, there will be no limit on ONESHOT
any more ;-)
		
Regards,
Michael Wang

> 
> Signed-off-by: Paton J. Lewis <palewis-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>
> ---
>  fs/eventpoll.c                             |   40 ++-
>  include/linux/eventpoll.h                  |    1 +
>  tools/testing/selftests/Makefile           |    2 +-
>  tools/testing/selftests/epoll/Makefile     |   11 +
>  tools/testing/selftests/epoll/test_epoll.c |  364 ++++++++++++++++++++++++++++
>  5 files changed, 414 insertions(+), 4 deletions(-)
>  create mode 100644 tools/testing/selftests/epoll/Makefile
>  create mode 100644 tools/testing/selftests/epoll/test_epoll.c
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 739b098..c718afd 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -339,7 +339,7 @@ static inline struct epitem *ep_item_from_epqueue(poll_table *p)
>  /* Tells if the epoll_ctl(2) operation needs an event copy from userspace */
>  static inline int ep_op_has_event(int op)
>  {
> -	return op != EPOLL_CTL_DEL;
> +	return op == EPOLL_CTL_ADD || op == EPOLL_CTL_MOD;
>  }
> 
>  /* Initialize the poll safe wake up structure */
> @@ -664,6 +664,36 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
>  	return 0;
>  }
> 
> +/*
> + * Disables a "struct epitem" in the eventpoll set. Returns -EBUSY if the item
> + * had no event flags set, indicating that another thread may be currently
> + * handling that item's events (in the case that EPOLLONESHOT was being
> + * used). Otherwise a zero result indicates that the item has been disabled
> + * from receiving events. A disabled item may be re-enabled via
> + * EPOLL_CTL_MOD. Must be called with "mtx" held.
> + */
> +static int ep_disable(struct eventpoll *ep, struct epitem *epi)
> +{
> +	int result = 0;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ep->lock, flags);
> +	if (epi->event.events & EPOLLONESHOT) {
> +		if (epi->event.events & ~EP_PRIVATE_BITS) {
> +			if (ep_is_linked(&epi->rdllink))
> +				list_del_init(&epi->rdllink);
> +			/* Ensure ep_poll_callback will not add epi back onto
> +			   ready list: */
> +			epi->event.events &= EP_PRIVATE_BITS;
> +		} else
> +			result = -EBUSY;
> +	} else
> +		result = -EINVAL;
> +	spin_unlock_irqrestore(&ep->lock, flags);
> +
> +	return result;
> +}
> +
>  static void ep_free(struct eventpoll *ep)
>  {
>  	struct rb_node *rbp;
> @@ -996,8 +1026,6 @@ static void ep_rbtree_insert(struct eventpoll *ep, struct epitem *epi)
>  	rb_insert_color(&epi->rbn, &ep->rbr);
>  }
> 
> -
> -
>  #define PATH_ARR_SIZE 5
>  /*
>   * These are the number paths of length 1 to 5, that we are allowing to emanate
> @@ -1701,6 +1729,12 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
>  		} else
>  			error = -ENOENT;
>  		break;
> +	case EPOLL_CTL_DISABLE:
> +		if (epi)
> +			error = ep_disable(ep, epi);
> +		else
> +			error = -ENOENT;
> +		break;
>  	}
>  	mutex_unlock(&ep->mtx);
> 
> diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
> index 657ab55..e91f7e3 100644
> --- a/include/linux/eventpoll.h
> +++ b/include/linux/eventpoll.h
> @@ -25,6 +25,7 @@
>  #define EPOLL_CTL_ADD 1
>  #define EPOLL_CTL_DEL 2
>  #define EPOLL_CTL_MOD 3
> +#define EPOLL_CTL_DISABLE 4
> 
>  /* Set the One Shot behaviour for the target file descriptor */
>  #define EPOLLONESHOT (1 << 30)
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index 28bc57e..4cf477f 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -1,4 +1,4 @@
> -TARGETS = breakpoints vm
> +TARGETS = breakpoints epoll vm
> 
>  all:
>  	for TARGET in $(TARGETS); do \
> diff --git a/tools/testing/selftests/epoll/Makefile b/tools/testing/selftests/epoll/Makefile
> new file mode 100644
> index 0000000..19806ed
> --- /dev/null
> +++ b/tools/testing/selftests/epoll/Makefile
> @@ -0,0 +1,11 @@
> +# Makefile for epoll selftests
> +
> +all: test_epoll
> +%: %.c
> +	gcc -pthread -g -o $@ $^
> +
> +run_tests: all
> +	./test_epoll
> +
> +clean:
> +	$(RM) test_epoll
> diff --git a/tools/testing/selftests/epoll/test_epoll.c b/tools/testing/selftests/epoll/test_epoll.c
> new file mode 100644
> index 0000000..54284eb
> --- /dev/null
> +++ b/tools/testing/selftests/epoll/test_epoll.c
> @@ -0,0 +1,364 @@
> +/*
> + *  tools/testing/selftests/epoll/test_epoll.c
> + *
> + *  Copyright 2012 Adobe Systems Incorporated
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  Paton J. Lewis <palewis-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>
> + *
> + */
> +
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <pthread.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <sys/epoll.h>
> +#include <sys/socket.h>
> +
> +/*
> + * A pointer to an epoll_item_private structure will be stored in the epoll
> + * item's event structure so that we can get access to the epoll_item_private
> + * data after calling epoll_wait:
> + */
> +struct epoll_item_private {
> +	int index;  /* Position of this struct within the epoll_items array. */
> +	int fd;
> +	uint32_t events;
> +	pthread_mutex_t mutex;  /* Guards the following variables... */
> +	int stop;
> +	int status;  /* Stores any error encountered while handling item. */
> +	/* The following variable allows us to test whether we have encountered
> +	   a problem while attempting to cancel and delete the associated
> +	   event. When the test program exits, 'deleted' should be exactly
> +	   one. If it is greater than one, then the failed test reflects a real
> +	   world situation where we would have tried to access the epoll item's
> +	   private data after deleting it: */
> +	int deleted;
> +};
> +
> +struct epoll_item_private *epoll_items;
> +
> +/*
> + * Delete the specified item from the epoll set. In a real-world secneario this
> + * is where we would free the associated data structure, but in this testing
> + * environment we retain the structure so that we can test for double-deletion:
> + */
> +void delete_item(int index)
> +{
> +	__sync_fetch_and_add(&epoll_items[index].deleted, 1);
> +}
> +
> +/*
> + * A pointer to a read_thread_data structure will be passed as the argument to
> + * each read thread:
> + */
> +struct read_thread_data {
> +	int stop;
> +	int status;  /* Indicates any error encountered by the read thread. */
> +	int epoll_set;
> +};
> +
> +/*
> + * The function executed by the read threads:
> + */
> +void *read_thread_function(void *function_data)
> +{
> +	struct read_thread_data *thread_data =
> +		(struct read_thread_data *)function_data;
> +	struct epoll_event event_data;
> +	struct epoll_item_private *item_data;
> +	char socket_data;
> +
> +	/* Handle events until we encounter an error or this thread's 'stop'
> +	   condition is set: */
> +	while (1) {
> +		int result = epoll_wait(thread_data->epoll_set,
> +					&event_data,
> +					1,	/* Number of desired events */
> +					1000);  /* Timeout in ms */
> +		if (result < 0) {
> +			/* Breakpoints signal all threads. Ignore that while
> +			   debugging: */
> +			if (errno == EINTR)
> +				continue;
> +			thread_data->status = errno;
> +			return 0;
> +		} else if (thread_data->stop)
> +			return 0;
> +		else if (result == 0)  /* Timeout */
> +			continue;
> +
> +		/* We need the mutex here because checking for the stop
> +		   condition and re-enabling the epoll item need to be done
> +		   together as one atomic operation when EPOLL_CTL_DISABLE is
> +		   available: */
> +		item_data = (struct epoll_item_private *)event_data.data.ptr;
> +		pthread_mutex_lock(&item_data->mutex);
> +
> +		/* Remove the item from the epoll set if we want to stop
> +		   handling that event: */
> +		if (item_data->stop)
> +			delete_item(item_data->index);
> +		else {
> +			/* Clear the data that was written to the other end of
> +			   our non-blocking socket: */
> +			do {
> +				if (read(item_data->fd, &socket_data, 1) < 1) {
> +					if ((errno == EAGAIN) ||
> +					    (errno == EWOULDBLOCK))
> +						break;
> +					else
> +						goto error_unlock;
> +				}
> +			} while (item_data->events & EPOLLET);
> +
> +			/* The item was one-shot, so re-enable it: */
> +			event_data.events = item_data->events;
> +			if (epoll_ctl(thread_data->epoll_set,
> +						  EPOLL_CTL_MOD,
> +						  item_data->fd,
> +						  &event_data) < 0)
> +				goto error_unlock;
> +		}
> +
> +		pthread_mutex_unlock(&item_data->mutex);
> +	}
> +
> +error_unlock:
> +	thread_data->status = item_data->status = errno;
> +	pthread_mutex_unlock(&item_data->mutex);
> +	return 0;
> +}
> +
> +/*
> + * A pointer to a write_thread_data structure will be passed as the argument to
> + * the write thread:
> + */
> +struct write_thread_data {
> +	int stop;
> +	int status;  /* Indicates any error encountered by the write thread. */
> +	int n_fds;
> +	int *fds;
> +};
> +
> +/*
> + * The function executed by the write thread. It writes a single byte to each
> + * socket in turn until the stop condition for this thread is set. If writing to
> + * a socket would block (i.e. errno was EAGAIN), we leave that socket alone for
> + * the moment and just move on to the next socket in the list. We don't care
> + * about the order in which we deliver events to the epoll set. In fact we don't
> + * care about the data we're writing to the pipes at all; we just want to
> + * trigger epoll events:
> + */
> +void *write_thread_function(void *function_data)
> +{
> +	const char data = 'X';
> +	int index;
> +	struct write_thread_data *thread_data =
> +		(struct write_thread_data *)function_data;
> +	while (!thread_data->stop)
> +		for (index = 0;
> +		     !thread_data->stop && (index < thread_data->n_fds);
> +		     ++index)
> +			if ((write(thread_data->fds[index], &data, 1) < 1) &&
> +				(errno != EAGAIN) &&
> +				(errno != EWOULDBLOCK)) {
> +				thread_data->status = errno;
> +				return;
> +			}
> +}
> +
> +/*
> + * Arguments are currently ignored:
> + */
> +int main(int argc, char **argv)
> +{
> +	const int n_read_threads = 100;
> +	const int n_epoll_items = 500;
> +	int index;
> +	int epoll_set = epoll_create1(0);
> +	struct write_thread_data write_thread_data = {
> +		0, 0, n_epoll_items, malloc(n_epoll_items * sizeof(int))
> +	};
> +	struct read_thread_data *read_thread_data =
> +		malloc(n_read_threads * sizeof(struct read_thread_data));
> +	pthread_t *read_threads = malloc(n_read_threads * sizeof(pthread_t));
> +	pthread_t write_thread;
> +	int socket_pair[2];
> +	struct epoll_event event_data;
> +
> +	printf("-----------------\n");
> +	printf("Runing test_epoll\n");
> +	printf("-----------------\n");
> +
> +	epoll_items = malloc(n_epoll_items * sizeof(struct epoll_item_private));
> +
> +	if (epoll_set < 0 || epoll_items == 0 || write_thread_data.fds == 0 ||
> +		read_thread_data == 0 || read_threads == 0)
> +		goto error;
> +
> +	if (sysconf(_SC_NPROCESSORS_ONLN) < 2) {
> +		printf("Error: please run this test on a multi-core system.\n");
> +		goto error;
> +	}
> +
> +	/* Create the socket pairs and epoll items: */
> +	for (index = 0; index < n_epoll_items; ++index) {
> +		if (socketpair(AF_UNIX,
> +			       SOCK_STREAM | SOCK_NONBLOCK,
> +			       0,
> +			       socket_pair) < 0)
> +			goto error;
> +		write_thread_data.fds[index] = socket_pair[0];
> +		epoll_items[index].index = index;
> +		epoll_items[index].fd = socket_pair[1];
> +		if (pthread_mutex_init(&epoll_items[index].mutex, NULL) != 0)
> +			goto error;
> +		/* We always use EPOLLONESHOT because this test is currently
> +		   structured to demonstrate the need for EPOLL_CTL_DISABLE,
> +		   which only produces useful information in the EPOLLONESHOT
> +		   case (without EPOLLONESHOT, calling epoll_ctl with
> +		   EPOLL_CTL_DISABLE will never return EBUSY). If support for
> +		   testing events without EPOLLONESHOT is desired, it should
> +		   probably be implemented in a separate unit test. */
> +		epoll_items[index].events = EPOLLIN | EPOLLONESHOT;
> +		if (index < n_epoll_items / 2)
> +			epoll_items[index].events |= EPOLLET;
> +		epoll_items[index].stop = 0;
> +		epoll_items[index].status = 0;
> +		epoll_items[index].deleted = 0;
> +		event_data.events = epoll_items[index].events;
> +		event_data.data.ptr = &epoll_items[index];
> +		if (epoll_ctl(epoll_set,
> +			      EPOLL_CTL_ADD,
> +			      epoll_items[index].fd,
> +			      &event_data) < 0)
> +			goto error;
> +	}
> +
> +#ifdef EPOLL_CTL_DISABLE
> +	/* Test to make sure that using EPOLL_CTL_DISABLE without EPOLLONESHOT
> +	   returns a clear error: */
> +	if (socketpair(AF_UNIX,
> +		       SOCK_STREAM | SOCK_NONBLOCK,
> +		       0,
> +		       socket_pair) < 0)
> +		goto error;
> +	event_data.events = EPOLLIN;
> +	event_data.data.ptr = NULL;
> +	if (epoll_ctl(epoll_set, EPOLL_CTL_ADD,
> +		      socket_pair[1], &event_data) < 0)
> +		goto error;
> +	if ((epoll_ctl(epoll_set, EPOLL_CTL_DISABLE,
> +		       socket_pair[1], NULL) == 0) || (errno != EINVAL))
> +		goto error;
> +	if (epoll_ctl(epoll_set, EPOLL_CTL_DEL, socket_pair[1], NULL) != 0)
> +		goto error;
> +#endif
> +
> +	/* Create and start the read threads: */
> +	for (index = 0; index < n_read_threads; ++index) {
> +		read_thread_data[index].stop = 0;
> +		read_thread_data[index].status = 0;
> +		read_thread_data[index].epoll_set = epoll_set;
> +		if (pthread_create(&read_threads[index],
> +				   NULL,
> +				   read_thread_function,
> +				   &read_thread_data[index]) != 0)
> +			goto error;
> +	}
> +
> +	if (pthread_create(&write_thread,
> +			   NULL,
> +			   write_thread_function,
> +			   &write_thread_data) != 0)
> +		goto error;
> +
> +	/* Cancel all event pollers: */
> +#ifdef EPOLL_CTL_DISABLE
> +	for (index = 0; index < n_epoll_items; ++index) {
> +		pthread_mutex_lock(&epoll_items[index].mutex);
> +		++epoll_items[index].stop;
> +		if (epoll_ctl(epoll_set,
> +			      EPOLL_CTL_DISABLE,
> +			      epoll_items[index].fd,
> +			      NULL) == 0)
> +			delete_item(index);
> +		else if (errno != EBUSY) {
> +			pthread_mutex_unlock(&epoll_items[index].mutex);
> +			goto error;
> +		}
> +		/* EBUSY means events were being handled; allow the other thread
> +		   to delete the item. */
> +		pthread_mutex_unlock(&epoll_items[index].mutex);
> +	}
> +#else
> +	for (index = 0; index < n_epoll_items; ++index) {
> +		pthread_mutex_lock(&epoll_items[index].mutex);
> +		++epoll_items[index].stop;
> +		pthread_mutex_unlock(&epoll_items[index].mutex);
> +		/* Wait in case a thread running read_thread_function is
> +		   currently executing code between epoll_wait and
> +		   pthread_mutex_lock with this item. Note that a longer delay
> +		   would make double-deletion less likely (at the expense of
> +		   performance), but there is no guarantee that any delay would
> +		   ever be sufficient. Note also that we delete all event
> +		   pollers at once for testing purposes, but in a real-world
> +		   environment we are likely to want to be able to cancel event
> +		   pollers at arbitrary times. Therefore we can't improve this
> +		   situation by just splitting this loop into two loops
> +		   (i.e. signal 'stop' for all items, sleep, and then delete all
> +		   items). We also can't fix the problem via EPOLL_CTL_DEL
> +		   because that command can't prevent the case where some other
> +		   thread is executing read_thread_function within the region
> +		   mentioned above: */
> +		usleep(1);
> +		pthread_mutex_lock(&epoll_items[index].mutex);
> +		if (!epoll_items[index].deleted)
> +			delete_item(index);
> +		pthread_mutex_unlock(&epoll_items[index].mutex);
> +	}
> +#endif
> +
> +	/* Shut down the read threads: */
> +	for (index = 0; index < n_read_threads; ++index)
> +		__sync_fetch_and_add(&read_thread_data[index].stop, 1);
> +	for (index = 0; index < n_read_threads; ++index) {
> +		if (pthread_join(read_threads[index], NULL) != 0)
> +			goto error;
> +		if (read_thread_data[index].status)
> +			goto error;
> +	}
> +
> +	/* Shut down the write thread: */
> +	__sync_fetch_and_add(&write_thread_data.stop, 1);
> +	if ((pthread_join(write_thread, NULL) != 0) || write_thread_data.status)
> +		goto error;
> +
> +	/* Check for final error conditions: */
> +	for (index = 0; index < n_epoll_items; ++index) {
> +		if (epoll_items[index].status != 0)
> +			goto error;
> +		if (pthread_mutex_destroy(&epoll_items[index].mutex) < 0)
> +			goto error;
> +	}
> +	for (index = 0; index < n_epoll_items; ++index)
> +		if (epoll_items[index].deleted != 1) {
> +			printf("Error: item data deleted %1d times.\n",
> +				   epoll_items[index].deleted);
> +			goto error;
> +		}
> +	
> +	printf("[PASS]\n");
> +	return 0;
> +
> + error:
> +	printf("[FAIL]\n");
> +	return errno;
> +}
> 
