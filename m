From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Mon, 26 Jan 2015 15:46:30 +0100
Message-ID: <54C65346.5070504@gmail.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org> <54BE5DC8.70706@gmail.com> <54BE9D08.7010804@zonque.org> <54BF805B.4000609@gmail.com> <54BFDAAA.50203@zonque.org> <54C0CE8A.5080805@gmail.com> <CANq1E4S=3qNw599L85uj-8aXwxeV+mcurB_Nu_rHH8opAeePjw@mail.gmail.com> <54C10DDC.9000503@gmail.com> <20150123160854.GA5210@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150123160854.GA5210-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Theodore T'so <tytso-3s7WtUTddSA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Greg,

On 01/23/2015 05:08 PM, Greg Kroah-Hartman wrote:
> On Thu, Jan 22, 2015 at 09:49:00AM -0500, Austin S Hemmelgarn wrote:
>> While I agree that there should be a way for userspace to get the li=
st of
>> supported operations, userspace apps will only actually care about t=
hat
>> once, when they begin talking to kdbus, because (ignoring the live k=
ernel
>> patching that people have been working on recently) the list of supp=
orted
>> operations isn't going to change while the system is running.  While=
 a u64
>> copy has relatively low overhead, it does have overhead, and that is=
 very
>> significant when you consider part of the reason some people want kd=
bus is
>> for the performance gain.  Especially for those automotive applicati=
ons that
>> have been mentioned which fire off thousands of messages during star=
t-up,
>> every little bit of performance is significant.
>=20
> A single u64 in a structure is not going to be measurable at all,
> processors just copy memory too fast these days for 4 extra bytes to =
be
> noticable. =20

It depends on the definition of measurable, I suppose, but this stateme=
nt
appears incorrect to me. In some cases (e.g., kdbus_msg_info) we're tal=
king
about *two* u64 fields (kernel_gs, kernel_msg_flags) being used to pass=
 back
sets of valid flags. That's 16 bytes, and it definitely makes a differe=
nce.
Simply running a loop that does a naive memcpy() in a tight user-space
loop (code below), I see the following for the execution of 1e9 loops:

    Including the two extra u64 fields: 3.2 sec
    Without the two extra u64 fields:   2.6 sec

On the same box, doing 1e9 calls to getppid() (i.e., pretty much the
simplest syscall, giving us a rough measure of the context switch) take=
s
68 seconds. In other words, the cost of copying those 16 bytes is about=
 1%
of the base context switch/syscall cost. I assume the costs of copying=20
those 16 bytes across the kernel-user-space boundary would not be cheap=
er,=20
but have not tested that. If my assumption is correct, then 1% seems a
significant figure to me in an API whose raison d'=EAtre is speed.

> So let's make this as easy as possible for userspace, making
> it simpler logic there, which is much more important than saving
> theoretical time in the kernel.

But this also missed the other part of the point. Copying these fields =
on
every operation, when in fact they are only needed once, clutters the A=
PI,
in my opinion. Good APIs are as simple as they can be to do their job.=20
Redundancy is an enemy of simplicity. Simplest would have been a one ti=
me=20
API that returns a structure containing all of the supported flags acro=
ss=20
the API. Alternatively, the traditional EINVAL approach is well underst=
ood,
and suffices.

Thanks,

Michael

=3D=3D=3D=3D=3D=3D=3D=3D=3D

#include <stdint.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct kdbus_msg_info {
    uint64_t offset;
    uint64_t msg_size;
    uint64_t return_flags;
};

struct kdbus_cmd_send {
        uint64_t size;
        uint64_t flags;
#if FIELDS >=3D 1
        uint64_t kernel_flags;
#endif
#if FIELDS >=3D 2
        uint64_t kernel_msg_flags;
#endif
        uint64_t return_flags;
        uint64_t msg_address;
        struct kdbus_msg_info reply;
        //struct kdbus_item items[0];
} __attribute__((aligned(8)));

int
main(int argc, char *argv[])
{
    long nloops, j;
    struct kdbus_cmd_send src, dst;
    memset(&dst, 0, sizeof(struct kdbus_cmd_send));

    printf("struct size: %zd\n", sizeof(struct kdbus_cmd_send));
    nloops =3D (argc > 1) ? atol(argv[1]) : 1000000000;

    for (j =3D 0; j < nloops; j++) {
        memcpy(&dst, &src, sizeof(struct kdbus_cmd_send));
    }

    exit(EXIT_SUCCESS);
}


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
