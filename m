From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 13/18] io_uring: add file set registration
Date: Wed, 30 Jan 2019 08:35:35 -0700
Message-ID: <a54c68d0-7069-a72c-5604-37b0e1ed53bf@kernel.dk>
References: <20190129192702.3605-1-axboe@kernel.dk>
 <20190129192702.3605-14-axboe@kernel.dk>
 <CAG48ez2kLWUEambWesQQaeVn_u=PtjuMeDUc49yamhYspfd7Sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <CAG48ez2kLWUEambWesQQaeVn_u=PtjuMeDUc49yamhYspfd7Sg@mail.gmail.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jann Horn <jannh@google.com>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 1/29/19 6:29 PM, Jann Horn wrote:
> On Tue, Jan 29, 2019 at 8:27 PM Jens Axboe <axboe@kernel.dk> wrote:
>> We normally have to fget/fput for each IO we do on a file. Even with
>> the batching we do, the cost of the atomic inc/dec of the file usage
>> count adds up.
>>
>> This adds IORING_REGISTER_FILES, and IORING_UNREGISTER_FILES opcodes
>> for the io_uring_register(2) system call. The arguments passed in must
>> be an array of __s32 holding file descriptors, and nr_args should hold
>> the number of file descriptors the application wishes to pin for the
>> duration of the io_uring context (or until IORING_UNREGISTER_FILES is
>> called).
>>
>> When used, the application must set IOSQE_FIXED_FILE in the sqe->flags
>> member. Then, instead of setting sqe->fd to the real fd, it sets sqe->fd
>> to the index in the array passed in to IORING_REGISTER_FILES.
>>
>> Files are automatically unregistered when the io_uring context is
>> torn down. An application need only unregister if it wishes to
>> register a new set of fds.
> 
> Crazy idea:
> 
> Taking a step back, at a high level, basically this patch creates sort
> of the same difference that you get when you compare the following
> scenarios for normal multithreaded I/O in userspace:
> 
> ===========================================================
> ~/tests/fdget_perf$ cat fdget_perf.c
> #define _GNU_SOURCE
> #include <sys/wait.h>
> #include <sched.h>
> #include <unistd.h>
> #include <stdbool.h>
> #include <string.h>
> #include <err.h>
> #include <signal.h>
> #include <sys/eventfd.h>
> #include <stdio.h>
> 
> // two different physical processors on my machine
> #define CORE_A 0
> #define CORE_B 14
> 
> static void pin_to_core(int coreid) {
>   cpu_set_t set;
>   CPU_ZERO(&set);
>   CPU_SET(coreid, &set);
>   if (sched_setaffinity(0, sizeof(cpu_set_t), &set))
>     err(1, "sched_setaffinity");
> }
> 
> static int fd = -1;
> 
> static volatile int time_over = 0;
> static void alarm_handler(int sig) { time_over = 1; }
> static void run_stuff(void) {
>   unsigned long long iterations = 0;
>   if (signal(SIGALRM, alarm_handler) == SIG_ERR) err(1, "signal");
>   alarm(10);
>   while (1) {
>     uint64_t val;
>     read(fd, &val, sizeof(val));
>     if (time_over) {
>       printf("iterations = 0x%llx\n", iterations);
>       return;
>     }
>     iterations++;
>   }
> }
> 
> static int child_fn(void *dummy) {
>   pin_to_core(CORE_B);
>   run_stuff();
>   return 0;
> }
> 
> static char child_stack[1024*1024];
> 
> int main(int argc, char **argv) {
>   fd = eventfd(0, EFD_NONBLOCK);
>   if (fd == -1) err(1, "eventfd");
> 
>   if (argc != 2) errx(1, "bad usage");
>   int flags = SIGCHLD;
>   if (strcmp(argv[1], "shared") == 0) {
>     flags |= CLONE_FILES;
>   } else if (strcmp(argv[1], "cloned") == 0) {
>     /* nothing */
>   } else {
>     errx(1, "bad usage");
>   }
>   pid_t child = clone(child_fn, child_stack+sizeof(child_stack), flags, NULL);
>   if (child == -1) err(1, "clone");
> 
>   pin_to_core(CORE_A);
>   run_stuff();
>   int status;
>   if (wait(&status) != child) err(1, "wait");
>   return 0;
> }
> ~/tests/fdget_perf$ gcc -Wall -o fdget_perf fdget_perf.c
> ~/tests/fdget_perf$ ./fdget_perf shared
> iterations = 0x8d3010
> iterations = 0x92d894
> ~/tests/fdget_perf$ ./fdget_perf cloned
> iterations = 0xad3bbd
> iterations = 0xb08838
> ~/tests/fdget_perf$ ./fdget_perf shared
> iterations = 0x8cc340
> iterations = 0x8e4e64
> ~/tests/fdget_perf$ ./fdget_perf cloned
> iterations = 0xada5f3
> iterations = 0xb04b6f
> ===========================================================
> 
> This kinda makes me wonder whether this is really something that
> should be implemented specifically for the io_uring API, or whether it
> would make sense to somehow handle part of this in the generic VFS
> code and give the user the ability to prepare a new files_struct that
> can then be transferred to the worker thread, or something like
> that... I'm not sure whether there's a particularly clean way to do
> that though.
> 
> Or perhaps you could add a userspace API for marking file descriptor
> table entries as "has percpu refcounting" somehow, with one percpu
> refcount per files_struct and one bit per fd, allocated when percpu
> refcounting is activated for the files_struct the first time, or
> something like that...

There's undoubtedly a win by NOT sharing, obviously. Not sure how to do
this in a generalized fashion, cleanly, it's easier (and a better fit)
to do it for specific cases, like io_uring here. If others want to go
down that path, io_uring could always be adapted to use that
infrastructure.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
