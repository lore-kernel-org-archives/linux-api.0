From: Madars Vitolins <m@silodev.com>
Subject: Re: [PATCH] epoll: add exclusive wakeups flag
Date: Tue, 15 Mar 2016 01:09:21 +0200
Message-ID: <de62d81aa9c8865a2af30c10158462f0@silodev.com>
References: <cover.1449523436.git.jbaron@akamai.com>
 <56A9C03B.7020104@gmail.com> <56AA56A2.3000700@akamai.com>
 <56AB1F6C.7000609@gmail.com> <56E1C2B5.2040905@akamai.com>
 <56E1D1D7.8040000@gmail.com> <56E1DBC2.6040109@akamai.com>
 <CAKgNAkgb-2omfCc=oBr66_CViJjBQ6=3vNfES99m6ZQ7g36p2Q@mail.gmail.com>
 <56E32FC5.4030902@akamai.com> <56E353CF.6050503@gmail.com>
 <56E6D0ED.20609@akamai.com> <56E6F941.9040307@gmail.com>
 <56E711C3.8020008@akamai.com> <56E71894.4090607@gmail.com>
 <56E7273D.3010403@gmail.com> <56E73C9B.9060206@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56E73C9B.9060206@akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Baron <jbaron@akamai.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@kernel.org, peterz@infradead.org, viro@ftp.linux.org.uk, normalperson@yhbt.net, corbet@lwn.net, luto@amacapital.net, torvalds@linux-foundation.org, hagen@jauu.net, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Jason and Michael,

Hmm... I tried to play with those pipe samples bellow, but even with=20
sleep I got that all process wakeups (maybe I miss something too), also=
=20
tried with EPOLLIN.

On same bases I created sample with Posix Queues with EPOLLIN |=20
EPOLLEXCLUSIVE and the goods news are that it works correctly.

file q.c:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/epoll.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <errno.h>
#include <mqueue.h>

#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
                         } while (0)

#define usageErr(msg, progName) \
                         do { fprintf(stderr, "Usage: "); \
                              fprintf(stderr, msg, progName); \
                              exit(EXIT_FAILURE); } while (0)

#ifndef EPOLLEXCLUSIVE
#define EPOLLEXCLUSIVE (1 << 28)
#endif

#define MAX_SIZE 10

int
main (int argc, char *argv[])
{
   int epfd, nready;
   struct epoll_event ev, rev;
   mqd_t fd;
   struct mq_attr attr;
   char buffer[MAX_SIZE + 1];
   int cnum;

   /* initialize the queue attributes */
   attr.mq_flags =3D 0;
   attr.mq_maxmsg =3D 5;
   attr.mq_msgsize =3D MAX_SIZE;
   attr.mq_curmsgs =3D 0;

   /* cleanup for multiple runs... */
   mq_unlink ("/TESTQ");

   /* create the message queue */
   fd =3D
     mq_open ("/TESTQ", O_CREAT | O_RDWR | O_NONBLOCK, S_IWUSR | S_IRUS=
R,
	     &attr);
   if (fd =3D=3D -1)
     errExit ("open");

   for (cnum =3D 0; cnum < 3; cnum++)
     {
       switch (fork ())
	{
	case -1:
	  errExit ("fork");

	case 0:		/* Child */
	  epfd =3D epoll_create (2);
	  if (epfd =3D=3D -1)
	    errExit ("epoll_create");

	  ev.events =3D EPOLLIN | EPOLLEXCLUSIVE;
	  if (epoll_ctl (epfd, EPOLL_CTL_ADD, fd, &ev) =3D=3D -1)
	    errExit ("epoll_ctl");

	  printf ("About to wait...\n");
	  nready =3D epoll_wait (epfd, &rev, 1, -1);
	  if (nready =3D=3D -1)
	    errExit ("epoll-wait");

	  printf ("Child %d: epoll_wait() returned %d\n", cnum, nready);
	  exit (EXIT_SUCCESS);

	default:
	  break;
	}
     }
   sleep (1);
   /* send a msq to Q */
   memset (buffer, 0, MAX_SIZE);
   if (0 > mq_send (fd, buffer, MAX_SIZE, 0))
     errExit ("mq_send");
   printf ("msg sent ok...\n");

   wait (NULL);
   wait (NULL);
   wait (NULL);

   exit (EXIT_SUCCESS);
}
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

$ gcc q.c -lrt
$ ./a.out
About to wait...
About to wait...
About to wait...
msg sent ok...
Child 2: epoll_wait() returned 1
^C
$



Best regards,
Madars


Jason Baron @ 2016-03-15 00:35 rakst=C4=ABja:
> Hi Michael,
>=20
> On 03/14/2016 05:03 PM, Michael Kerrisk (man-pages) wrote:
>> Hi Jason,
>>=20
>> On 03/15/2016 09:01 AM, Michael Kerrisk (man-pages) wrote:
>>> Hi Jason,
>>>=20
>>> On 03/15/2016 08:32 AM, Jason Baron wrote:
>>>>=20
>>>>=20
>>>> On 03/14/2016 01:47 PM, Michael Kerrisk (man-pages) wrote:
>>>>> [Restoring CC, which I see I accidentally dropped, one iteration=20
>>>>> back.]
>>=20
>> [...]
>>=20
>>>>> Returning to the second sentence in this description:
>>>>>=20
>>>>>               When a wakeup event occurs and multiple epoll file=20
>>>>> descrip=E2=80=90
>>>>>               tors are attached to the same target file using=20
>>>>> EPOLLEXCLU=E2=80=90
>>>>>               SIVE, one or  more  of  the  epoll  file  descripto=
rs=20
>>>>>  will
>>>>>               receive  an  event with epoll_wait(2).
>>>>>=20
>>>>> There is a point that is unclear to me: what does "target file"=20
>>>>> refer to?
>>>>> Is it an open file description (aka open file table entry) or an=20
>>>>> inode?
>>>>> I suspect the former, but it was not clear in your original text.
>>>>>=20
>>>>=20
>>>> So from epoll's perspective, the wakeups are associated with a 'wa=
it
>>>> queue'. So if the open() and subsequent EPOLL_CTL_ADD (which is do=
ne=20
>>>> via
>>>> file->poll()) results in adding to the same 'wait queue' then we=20
>>>> will
>>>> get 'exclusive' wakeup behavior.
>>>>=20
>>>> So in general, I think the answer here is that its associated with=
=20
>>>> the
>>>> inode (I coudn't say with 100% certainty without really looking at=
=20
>>>> all
>>>> file->poll() implementations). Certainly, with the 'FIFO' example=20
>>>> below,
>>>> the two scenarios will have the same behavior with respect to
>>>> EPOLLEXCLUSIVE.
>>=20
>> So, I was actually a little surprised by this, and went away and=20
>> tested
>> this point. It appears to me that that the two scenarios described=20
>> below
>> do NOT have the same behavior with respect to EPOLLEXCLUSIVE. See=20
>> below.
>>=20
>>> So, in both scenarios, *one or more* processes will get a wakeup?
>>> (I'll try to add something to the text to clarify the detail we're
>>> discussing.)
>>>=20
>>>> Also, the 'non-exclusive' mode would be subject to the same questi=
on=20
>>>> of
>>>> which wait queue is the epfd is associated with...
>>>=20
>>> I'm not sure of the point you are trying to make here?
>>>=20
>>> Cheers,
>>>=20
>>> Michael
>>>=20
>>>=20
>>>>> To make this point even clearer, here are two scenarios I'm=20
>>>>> thinking of.
>>>>> In each case, we're talking of monitoring the read end of a FIFO.
>>>>>=20
>>>>> =3D=3D=3D
>>>>>=20
>>>>> Scenario 1:
>>>>>=20
>>>>> We have three processes each of which
>>>>> 1. Creates an epoll instance
>>>>> 2. Opens the read end of the FIFO
>>>>> 3. Adds the read end of the FIFO to the epoll instance, specifyin=
g
>>>>>    EPOLLEXCLUSIVE
>>>>>=20
>>>>> When input becomes available on the FIFO, how many processes
>>>>> get a wakeup?
>>=20
>> When I test this scenario, all three processes get a wakeup.
>>=20
>>>>> =3D=3D=3D
>>>>>=20
>>>>> Scenario 3
>>>>>=20
>>>>> A parent process opens the read end of a FIFO and then calls
>>>>> fork() three times to create three children. Each child then:
>>>>>=20
>>>>> 1. Creates an epoll instance
>>>>> 2. Adds the read end of the FIFO to the epoll instance, specifyin=
g
>>>>> EPOLLEXCLUSIVE
>>>>>=20
>>>>> When input becomes available on the FIFO, how many processes
>>>>> get a wakeup?
>>=20
>> When I test this scenario, one process gets a wakeup.
>>=20
>> In other words, "target file" appears to mean open file description
>> (aka open file table entry), not inode.
>>=20
>> This is actually what I suspected might be the case, but now I am
>> puzzled. Given what I've discovered and what you suggest are the
>> semantics, is the implementation correct? (I suspect that it is,
>> but it is at odds with your statement above. My test programs are
>> inline below.
>>=20
>> Cheers,
>>=20
>> Michael
>>=20
>=20
> Thanks for the test cases. So in your first test case, you are exitin=
g
> immediately after the epoll_wait() returns. So this is actually causi=
ng
> the next wakeup. And then the 2nd thread returns from epoll_wait() an=
d
> this causes the 3rd wakeup.
>=20
> So the wakeups are actually not happening from the write directly, bu=
t
> instead from the readers doing a close(). If you do some sort of slee=
p
> after the epoll_wait() you can confirm the behavior. So I believe thi=
s
> is working as expected.
>=20
> Thanks,
>=20
> -Jason
>=20
>=20
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>=20
>> /* t_EPOLLEXCLUSIVE_multipen.c
>>=20
>>    Licensed under GNU GPLv2 or later.
>> */
>> #include <sys/epoll.h>
>> #include <sys/stat.h>
>> #include <fcntl.h>
>> #include <sys/types.h>
>> #include <stdio.h>
>> #include <stdlib.h>
>> #include <unistd.h>
>> #include <string.h>
>>=20
>> #define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
>>                         } while (0)
>>=20
>> #define usageErr(msg, progName) \
>>                         do { fprintf(stderr, "Usage: "); \
>>                              fprintf(stderr, msg, progName); \
>>                              exit(EXIT_FAILURE); } while (0)
>>=20
>> #ifndef EPOLLEXCLUSIVE
>> #define EPOLLEXCLUSIVE (1 << 28)
>> #endif
>>=20
>> int
>> main(int argc, char *argv[])
>> {
>>     int fd, epfd, nready;
>>     struct epoll_event ev, rev;
>>=20
>>     if (argc !=3D 2 || strcmp(argv[1], "--help") =3D=3D 0)
>>         usageErr("%s <FIFO>n", argv[0]);
>>=20
>>     epfd =3D epoll_create(2);
>>     if (epfd =3D=3D -1)
>>         errExit("epoll_create");
>>=20
>>     fd =3D open(argv[1], O_RDONLY);
>>     if (fd =3D=3D -1)
>>         errExit("open");
>>     printf("Opened %s\n", argv[1]);
>>=20
>>     ev.events =3D EPOLLIN | EPOLLEXCLUSIVE;
>>     if (epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev) =3D=3D -1)
>>         errExit("epoll_ctl");
>>=20
>>     nready =3D epoll_wait(epfd, &rev, 1, -1);
>>     if (nready =3D=3D -1)
>>         errExit("epoll-wait");
>>     printf("epoll_wait() returned %d\n", nready);
>>=20
>>     exit(EXIT_SUCCESS);
>> }
>>=20
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>=20
>> /* t_EPOLLEXCLUSIVE_fork.c
>>=20
>>    Licensed under GNU GPLv2 or later.
>> */
>>=20
>> #include <sys/epoll.h>
>> #include <sys/stat.h>
>> #include <fcntl.h>
>> #include <sys/types.h>
>> #include <sys/wait.h>
>> #include <stdio.h>
>> #include <stdlib.h>
>> #include <unistd.h>
>> #include <string.h>
>>=20
>> #define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
>>                         } while (0)
>>=20
>> #define usageErr(msg, progName) \
>>                         do { fprintf(stderr, "Usage: "); \
>>                              fprintf(stderr, msg, progName); \
>>                              exit(EXIT_FAILURE); } while (0)
>>=20
>> #ifndef EPOLLEXCLUSIVE
>> #define EPOLLEXCLUSIVE (1 << 28)
>> #endif
>>=20
>> int
>> main(int argc, char *argv[])
>> {
>>     int fd, epfd, nready;
>>     struct epoll_event ev, rev;
>>     int cnum;
>>=20
>>     if (argc !=3D 2 || strcmp(argv[1], "--help") =3D=3D 0)
>>         usageErr("%s <FIFO>n", argv[0]);
>>=20
>>     fd =3D open(argv[1], O_RDONLY);
>>     if (fd =3D=3D -1)
>>         errExit("open");
>>     printf("Opened %s\n", argv[1]);
>>=20
>>     for (cnum =3D 0; cnum < 3; cnum++) {
>>         switch (fork()) {
>>         case -1:
>>             errExit("fork");
>>=20
>>         case 0: /* Child */
>>             epfd =3D epoll_create(2);
>>             if (epfd =3D=3D -1)
>>                 errExit("epoll_create");
>>=20
>>             ev.events =3D EPOLLIN | EPOLLEXCLUSIVE;
>>             if (epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev) =3D=3D -1)
>>                 errExit("epoll_ctl");
>>=20
>>             nready =3D epoll_wait(epfd, &rev, 1, -1);
>>             if (nready =3D=3D -1)
>>                 errExit("epoll-wait");
>>             printf("Child %d: epoll_wait() returned %d\n", cnum,=20
>> nready);
>>             exit(EXIT_SUCCESS);
>>=20
>>         default:
>>             break;
>>         }
>>     }
>>=20
>>     wait(NULL);
>>     wait(NULL);
>>     wait(NULL);
>>=20
>>     exit(EXIT_SUCCESS);
>> }
>>=20
