From: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] epoll: add exclusive wakeups flag
Date: Mon, 14 Mar 2016 22:36:09 -0400
Message-ID: <56E77519.3040209@akamai.com>
References: <cover.1449523436.git.jbaron@akamai.com>
 <56A9C03B.7020104@gmail.com> <56AA56A2.3000700@akamai.com>
 <56AB1F6C.7000609@gmail.com> <56E1C2B5.2040905@akamai.com>
 <56E1D1D7.8040000@gmail.com> <56E1DBC2.6040109@akamai.com>
 <CAKgNAkgb-2omfCc=oBr66_CViJjBQ6=3vNfES99m6ZQ7g36p2Q@mail.gmail.com>
 <56E32FC5.4030902@akamai.com> <56E353CF.6050503@gmail.com>
 <56E6D0ED.20609@akamai.com> <56E6F941.9040307@gmail.com>
 <56E711C3.8020008@akamai.com> <56E71894.4090607@gmail.com>
 <56E7273D.3010403@gmail.com> <56E73C9B.9060206@akamai.com>
 <56E748B2.4080209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56E748B2.4080209-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, m@silodev.com, corbet-T1hC0tSOHrs@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hagen-GvnIQ6b/HdU@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Michael,

On 03/14/2016 07:26 PM, Michael Kerrisk (man-pages) wrote:
> Hi Jason,
>=20
> On 03/15/2016 11:35 AM, Jason Baron wrote:
>> Hi Michael,
>>
>> On 03/14/2016 05:03 PM, Michael Kerrisk (man-pages) wrote:
>>> Hi Jason,
>>>
>>> On 03/15/2016 09:01 AM, Michael Kerrisk (man-pages) wrote:
>>>> Hi Jason,
>>>>
>>>> On 03/15/2016 08:32 AM, Jason Baron wrote:
>>>>>
>>>>>
>>>>> On 03/14/2016 01:47 PM, Michael Kerrisk (man-pages) wrote:
>>>>>> [Restoring CC, which I see I accidentally dropped, one iteration=
 back.]
>>>
>>> [...]
>>>
>>>>>> Returning to the second sentence in this description:
>>>>>>
>>>>>>               When a wakeup event occurs and multiple epoll file=
 descrip=E2=80=90
>>>>>>               tors are attached to the same target file using EP=
OLLEXCLU=E2=80=90
>>>>>>               SIVE, one or  more  of  the  epoll  file  descript=
ors  will
>>>>>>               receive  an  event with epoll_wait(2).
>>>>>>
>>>>>> There is a point that is unclear to me: what does "target file" =
refer to?
>>>>>> Is it an open file description (aka open file table entry) or an=
 inode?
>>>>>> I suspect the former, but it was not clear in your original text=
=2E
>>>>>>
>>>>>
>>>>> So from epoll's perspective, the wakeups are associated with a 'w=
ait
>>>>> queue'. So if the open() and subsequent EPOLL_CTL_ADD (which is d=
one via
>>>>> file->poll()) results in adding to the same 'wait queue' then we =
will
>>>>> get 'exclusive' wakeup behavior.
>>>>>
>>>>> So in general, I think the answer here is that its associated wit=
h the
>>>>> inode (I coudn't say with 100% certainty without really looking a=
t all
>>>>> file->poll() implementations). Certainly, with the 'FIFO' example=
 below,
>>>>> the two scenarios will have the same behavior with respect to
>>>>> EPOLLEXCLUSIVE.
>>>
>>> So, I was actually a little surprised by this, and went away and te=
sted
>>> this point. It appears to me that that the two scenarios described =
below
>>> do NOT have the same behavior with respect to EPOLLEXCLUSIVE. See b=
elow.
>>>
>>>> So, in both scenarios, *one or more* processes will get a wakeup?
>>>> (I'll try to add something to the text to clarify the detail we're=
=20
>>>> discussing.)
>>>>
>>>>> Also, the 'non-exclusive' mode would be subject to the same quest=
ion of
>>>>> which wait queue is the epfd is associated with...
>>>>
>>>> I'm not sure of the point you are trying to make here?
>>>>
>>>> Cheers,
>>>>
>>>> Michael
>>>>
>>>>
>>>>>> To make this point even clearer, here are two scenarios I'm thin=
king of.
>>>>>> In each case, we're talking of monitoring the read end of a FIFO=
=2E
>>>>>>
>>>>>> =3D=3D=3D
>>>>>>
>>>>>> Scenario 1:
>>>>>>
>>>>>> We have three processes each of which
>>>>>> 1. Creates an epoll instance
>>>>>> 2. Opens the read end of the FIFO
>>>>>> 3. Adds the read end of the FIFO to the epoll instance, specifyi=
ng
>>>>>>    EPOLLEXCLUSIVE
>>>>>>
>>>>>> When input becomes available on the FIFO, how many processes
>>>>>> get a wakeup?
>>>
>>> When I test this scenario, all three processes get a wakeup.
>>>
>>>>>> =3D=3D=3D
>>>>>>
>>>>>> Scenario 3
>>>>>>
>>>>>> A parent process opens the read end of a FIFO and then calls
>>>>>> fork() three times to create three children. Each child then:
>>>>>>
>>>>>> 1. Creates an epoll instance
>>>>>> 2. Adds the read end of the FIFO to the epoll instance, specifyi=
ng
>>>>>> EPOLLEXCLUSIVE
>>>>>>
>>>>>> When input becomes available on the FIFO, how many processes
>>>>>> get a wakeup?
>>>
>>> When I test this scenario, one process gets a wakeup.
>>>
>>> In other words, "target file" appears to mean open file description
>>> (aka open file table entry), not inode.
>>>
>>> This is actually what I suspected might be the case, but now I am
>>> puzzled. Given what I've discovered and what you suggest are the
>>> semantics, is the implementation correct? (I suspect that it is,
>>> but it is at odds with your statement above. My test programs are
>>> inline below.
>>>
>>> Cheers,
>>>
>>> Michael
>>>
>>
>> Thanks for the test cases. So in your first test case, you are exiti=
ng
>> immediately after the epoll_wait() returns. So this is actually caus=
ing
>> the next wakeup.=20
>=20
> Can I just check my understanding of the rationale for the preceding=20
> point. The next process is getting woken up, because the previous pro=
cess
> did not "consume" the event (that is, the input is still available on=
 the=20
> FIFO). Right?
>=20
>> And then the 2nd thread returns from epoll_wait() and
>> this causes the 3rd wakeup.
>=20
> I added the sleep() calls, but still things don't seem to happen
> quite as you suggest. In the first scenario, after the first process
> terminates, *all* of the remaining processes wake from epoll_wait().
> What's happening in this case? (This smells like a possible bug.)

Yes, you are right. When the first process exits() and thus closes
the read-side of the pipe, it will wake up all the other calls that
are in epoll_wait(). When the file closes, since there are no more
fds referencing it, the pipe_release() routine does a wakeup specifying
both POLLIN and POLLOUT. In this case, all of the epoll exclusive
waiters will get a wakeup. The combination of POLLIN and POLLOUT is
not expected to be the typical use-case here. Normally, we would have
the threads in event loops, and just POLLIN would be set resulting
in the exclusive waskeup behavior. So yes, there can be multiple
wakeups in some cases, but the *common* case of only POLLIN or only
POLLOUT set will yield exclusive wakeups. There is no guarantee here
that only 1 thread wakes up - only that *at least* one.

>=20
> In the second scenario (fork()), after the first process terminates
> (without consuming the FIFO input), all of the other processes remain=
=20
> blocked in epoll-wait(). (Note, I extended the test program here
> to allow the number of child processes to be specified as a command-l=
ine
> argument.) I think I can make sense of that: it's because the open=20
> file descriptor for the read end of the FIFO has been duplicated
> in all of the child processes, and closing the FD in one child
> does not cause the corresponding open file description in other
> processes to be torn down because there are other FDs that still
> refer to it.
>=20

Yes, exactly. The final process is going to invoke the pipe_release(),
but at that point there is nobody left to wakeup.

>> So the wakeups are actually not happening from the write directly, b=
ut
>> instead from the readers doing a close(). If you do some sort of sle=
ep
>> after the epoll_wait() you can confirm the behavior. So I believe th=
is
>> is working as expected.
>=20
> As note above, I'm still slightly puzzled.
> Revised test programs pasted below.
>=20

Ok, hopefully this makes sense.

Thanks,

-Jason

> Cheers,
>=20
> Michael
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> /* t_EPOLLEXCLUSIVE_multiopen.c
>=20
>   Licensed under GNU GPLv2 or later.
> */
>=20
> #include <sys/epoll.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> #include <sys/types.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <string.h>
>=20
> #define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
>                         } while (0)
>=20
> #define usageErr(msg, progName) \
>                         do { fprintf(stderr, "Usage: "); \
>                              fprintf(stderr, msg, progName); \
>                              exit(EXIT_FAILURE); } while (0)
>=20
> #ifndef EPOLLEXCLUSIVE
> #define EPOLLEXCLUSIVE (1 << 28)
> #endif
>=20
> int
> main(int argc, char *argv[])
> {
>     int fd, epfd, nready;
>     struct epoll_event ev, rev;
>=20
>     if (argc !=3D 2 || strcmp(argv[1], "--help") =3D=3D 0)
>         usageErr("%s <FIFO>\n", argv[0]);
>=20
>     epfd =3D epoll_create(2);
>     if (epfd =3D=3D -1)
>         errExit("epoll_create");
>=20
>     fd =3D open(argv[1], O_RDONLY);
>     if (fd =3D=3D -1)
>         errExit("open");
>     printf("Opened %s\n", argv[1]);
>=20
>     ev.events =3D EPOLLIN | EPOLLEXCLUSIVE;
>     if (epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev) =3D=3D -1)
>         errExit("epoll_ctl");
>=20
>     nready =3D epoll_wait(epfd, &rev, 1, -1);
>     if (nready =3D=3D -1)
>         errExit("epoll-wait");
>     printf("epoll_wait() returned %d\n", nready);
>=20
>     printf("sleeping\n");
>     sleep(3);
>     printf("Terminating\n");
>     exit(EXIT_SUCCESS);
> }
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> /* t_EPOLLEXCLUSIVE_fork.c=20
> =20
>   Licensed under GNU GPLv2 or later.
> */
>=20
> #include <sys/epoll.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> #include <sys/types.h>
> #include <sys/wait.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <string.h>
>=20
> #define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
>                         } while (0)
>=20
> #define usageErr(msg, progName) \
>                         do { fprintf(stderr, "Usage: "); \
>                              fprintf(stderr, msg, progName); \
>                              exit(EXIT_FAILURE); } while (0)
>=20
> #ifndef EPOLLEXCLUSIVE
> #define EPOLLEXCLUSIVE (1 << 28)
> #endif
>=20
> int
> main(int argc, char *argv[])
> {
>     int fd, epfd, nready;
>     struct epoll_event ev, rev;
>     int cnum, cmax;
>=20
>     if (argc < 2 || strcmp(argv[1], "--help") =3D=3D 0)
>         usageErr("%s <FIFO> [num-children]\n", argv[0]);
>=20
>     fd =3D open(argv[1], O_RDONLY);
>     if (fd =3D=3D -1)
>         errExit("open");
>     printf("Opened %s\n", argv[1]);
>=20
>     cmax =3D (argc > 2) ? atoi(argv[2]) : 3;
>=20
>     for (cnum =3D 0; cnum < cmax; cnum++) {
>         switch (fork()) {
>         case -1:
>             errExit("fork");
>=20
>         case 0: /* Child */
>             epfd =3D epoll_create(2);
>             if (epfd =3D=3D -1)
>                 errExit("epoll_create");
>=20
>             ev.events =3D EPOLLIN | EPOLLEXCLUSIVE;
>             if (epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev) =3D=3D -1)
>                 errExit("epoll_ctl");
>=20
>             nready =3D epoll_wait(epfd, &rev, 1, -1);
>             if (nready =3D=3D -1)
>                 errExit("epoll-wait");
>             printf("Child %d: epoll_wait() returned %d\n", cnum, nrea=
dy);
>             printf("sleeping\n");
>             sleep(3);
>             printf("Child %d terminating\n", cnum);
>             exit(EXIT_SUCCESS);
>=20
>         default:
>             break;
>         }
>     }
>=20
>     for (cnum =3D 0; cnum < cmax; cnum++)
>         wait(NULL);
>=20
>     exit(EXIT_SUCCESS);
> }
>=20
