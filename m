From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] epoll: add exclusive wakeups flag
Date: Tue, 15 Mar 2016 10:03:57 +1300
Message-ID: <56E7273D.3010403@gmail.com>
References: <cover.1449523436.git.jbaron@akamai.com>
 <56A9C03B.7020104@gmail.com> <56AA56A2.3000700@akamai.com>
 <56AB1F6C.7000609@gmail.com> <56E1C2B5.2040905@akamai.com>
 <56E1D1D7.8040000@gmail.com> <56E1DBC2.6040109@akamai.com>
 <CAKgNAkgb-2omfCc=oBr66_CViJjBQ6=3vNfES99m6ZQ7g36p2Q@mail.gmail.com>
 <56E32FC5.4030902@akamai.com> <56E353CF.6050503@gmail.com>
 <56E6D0ED.20609@akamai.com> <56E6F941.9040307@gmail.com>
 <56E711C3.8020008@akamai.com> <56E71894.4090607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56E71894.4090607-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, m@silodev.com, corbet-T1hC0tSOHrs@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hagen-GvnIQ6b/HdU@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Jason,

On 03/15/2016 09:01 AM, Michael Kerrisk (man-pages) wrote:
> Hi Jason,
>=20
> On 03/15/2016 08:32 AM, Jason Baron wrote:
>>
>>
>> On 03/14/2016 01:47 PM, Michael Kerrisk (man-pages) wrote:
>>> [Restoring CC, which I see I accidentally dropped, one iteration ba=
ck.]

[...]

>>> Returning to the second sentence in this description:
>>>
>>>               When a wakeup event occurs and multiple epoll file de=
scrip=E2=80=90
>>>               tors are attached to the same target file using EPOLL=
EXCLU=E2=80=90
>>>               SIVE, one or  more  of  the  epoll  file  descriptors=
  will
>>>               receive  an  event with epoll_wait(2).
>>>
>>> There is a point that is unclear to me: what does "target file" ref=
er to?
>>> Is it an open file description (aka open file table entry) or an in=
ode?
>>> I suspect the former, but it was not clear in your original text.
>>>
>>
>> So from epoll's perspective, the wakeups are associated with a 'wait
>> queue'. So if the open() and subsequent EPOLL_CTL_ADD (which is done=
 via
>> file->poll()) results in adding to the same 'wait queue' then we wil=
l
>> get 'exclusive' wakeup behavior.
>>
>> So in general, I think the answer here is that its associated with t=
he
>> inode (I coudn't say with 100% certainty without really looking at a=
ll
>> file->poll() implementations). Certainly, with the 'FIFO' example be=
low,
>> the two scenarios will have the same behavior with respect to
>> EPOLLEXCLUSIVE.

So, I was actually a little surprised by this, and went away and tested
this point. It appears to me that that the two scenarios described belo=
w
do NOT have the same behavior with respect to EPOLLEXCLUSIVE. See below=
=2E

> So, in both scenarios, *one or more* processes will get a wakeup?
> (I'll try to add something to the text to clarify the detail we're=20
> discussing.)
>=20
>> Also, the 'non-exclusive' mode would be subject to the same question=
 of
>> which wait queue is the epfd is associated with...
>=20
> I'm not sure of the point you are trying to make here?
>=20
> Cheers,
>=20
> Michael
>=20
>=20
>>> To make this point even clearer, here are two scenarios I'm thinkin=
g of.
>>> In each case, we're talking of monitoring the read end of a FIFO.
>>>
>>> =3D=3D=3D
>>>
>>> Scenario 1:
>>>
>>> We have three processes each of which
>>> 1. Creates an epoll instance
>>> 2. Opens the read end of the FIFO
>>> 3. Adds the read end of the FIFO to the epoll instance, specifying
>>>    EPOLLEXCLUSIVE
>>>
>>> When input becomes available on the FIFO, how many processes
>>> get a wakeup?

When I test this scenario, all three processes get a wakeup.

>>> =3D=3D=3D
>>>
>>> Scenario 3
>>>
>>> A parent process opens the read end of a FIFO and then calls
>>> fork() three times to create three children. Each child then:
>>>
>>> 1. Creates an epoll instance
>>> 2. Adds the read end of the FIFO to the epoll instance, specifying
>>> EPOLLEXCLUSIVE
>>>
>>> When input becomes available on the FIFO, how many processes
>>> get a wakeup?

When I test this scenario, one process gets a wakeup.

In other words, "target file" appears to mean open file description
(aka open file table entry), not inode.

This is actually what I suspected might be the case, but now I am
puzzled. Given what I've discovered and what you suggest are the
semantics, is the implementation correct? (I suspect that it is,
but it is at odds with your statement above. My test programs are
inline below.

Cheers,

Michael

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

/* t_EPOLLEXCLUSIVE_multipen.c

   Licensed under GNU GPLv2 or later.
*/
#include <sys/epoll.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
                        } while (0)

#define usageErr(msg, progName) \
                        do { fprintf(stderr, "Usage: "); \
                             fprintf(stderr, msg, progName); \
                             exit(EXIT_FAILURE); } while (0)

#ifndef EPOLLEXCLUSIVE
#define EPOLLEXCLUSIVE (1 << 28)
#endif

int
main(int argc, char *argv[])
{
    int fd, epfd, nready;
    struct epoll_event ev, rev;

    if (argc !=3D 2 || strcmp(argv[1], "--help") =3D=3D 0)
        usageErr("%s <FIFO>n", argv[0]);

    epfd =3D epoll_create(2);
    if (epfd =3D=3D -1)
        errExit("epoll_create");

    fd =3D open(argv[1], O_RDONLY);
    if (fd =3D=3D -1)
        errExit("open");
    printf("Opened %s\n", argv[1]);

    ev.events =3D EPOLLIN | EPOLLEXCLUSIVE;
    if (epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev) =3D=3D -1)
        errExit("epoll_ctl");

    nready =3D epoll_wait(epfd, &rev, 1, -1);
    if (nready =3D=3D -1)
        errExit("epoll-wait");
    printf("epoll_wait() returned %d\n", nready);

    exit(EXIT_SUCCESS);
}

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

/* t_EPOLLEXCLUSIVE_fork.c=20

   Licensed under GNU GPLv2 or later.
*/

#include <sys/epoll.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
                        } while (0)

#define usageErr(msg, progName) \
                        do { fprintf(stderr, "Usage: "); \
                             fprintf(stderr, msg, progName); \
                             exit(EXIT_FAILURE); } while (0)

#ifndef EPOLLEXCLUSIVE
#define EPOLLEXCLUSIVE (1 << 28)
#endif

int
main(int argc, char *argv[])
{
    int fd, epfd, nready;
    struct epoll_event ev, rev;
    int cnum;

    if (argc !=3D 2 || strcmp(argv[1], "--help") =3D=3D 0)
        usageErr("%s <FIFO>n", argv[0]);

    fd =3D open(argv[1], O_RDONLY);
    if (fd =3D=3D -1)
        errExit("open");
    printf("Opened %s\n", argv[1]);

    for (cnum =3D 0; cnum < 3; cnum++) {
        switch (fork()) {
        case -1:
            errExit("fork");

        case 0: /* Child */
            epfd =3D epoll_create(2);
            if (epfd =3D=3D -1)
                errExit("epoll_create");

            ev.events =3D EPOLLIN | EPOLLEXCLUSIVE;
            if (epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev) =3D=3D -1)
                errExit("epoll_ctl");

            nready =3D epoll_wait(epfd, &rev, 1, -1);
            if (nready =3D=3D -1)
                errExit("epoll-wait");
            printf("Child %d: epoll_wait() returned %d\n", cnum, nready=
);
            exit(EXIT_SUCCESS);

        default:
            break;
        }
    }

    wait(NULL);
    wait(NULL);
    wait(NULL);

    exit(EXIT_SUCCESS);
}

--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
