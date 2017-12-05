From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?=
        <maheshb@google.com>
Subject: Re: [PATCHv2 2/2] userns: control capabilities of some user namespaces
Date: Tue, 5 Dec 2017 13:55:53 -0800
Message-ID: <CAF2d9jgsSZ6mCE8QwxPpoO7GoO4zeQzNfZuZwM9Gqqdi8uP4fw@mail.gmail.com>
References: <20171110053757.21170-1-mahesh@bandewar.net> <20171126064037.GB30279@mail.hallyn.com>
 <CAF2d9jhiZFiFODNXUY13F+4Pm+59+rZW=CnLPX1VUT3BAJdeeA@mail.gmail.com>
 <20171128230440.GB28297@mail.hallyn.com> <CAF2d9jhCDasnf2tbaGA04MV5ygZ9o1FaVRCEU2TkHjZR7d1ifw@mail.gmail.com>
 <20171129175712.GB14545@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171129175712.GB14545@mail.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Mahesh Bandewar <mahesh@bandewar.net>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 29, 2017 at 9:57 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=B6 =E0=A4=AC=
=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) (maheshb@google.com=
):
>> On Tue, Nov 28, 2017 at 3:04 PM, Serge E. Hallyn <serge@hallyn.com> wrot=
e:
>> > Quoting Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=B6 =E0=A4=
=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) (maheshb@google.=
com):
>> > ...
>> >> >> diff --git a/security/commoncap.c b/security/commoncap.c
>> >> >> index fc46f5b85251..89103f16ac37 100644
>> >> >> --- a/security/commoncap.c
>> >> >> +++ b/security/commoncap.c
>> >> >> @@ -73,6 +73,14 @@ int cap_capable(const struct cred *cred, struct=
 user_namespace *targ_ns,
>> >> >>  {
>> >> >>       struct user_namespace *ns =3D targ_ns;
>> >> >>
>> >> >> +     /* If the capability is controlled and user-ns that process
>> >> >> +      * belongs-to is 'controlled' then return EPERM and no need
>> >> >> +      * to check the user-ns hierarchy.
>> >> >> +      */
>> >> >> +     if (is_user_ns_controlled(cred->user_ns) &&
>> >> >> +         is_capability_controlled(cap))
>> >> >> +             return -EPERM;
>> >> >
>> >> > I'd be curious to see the performance impact on this on a regular
>> >> > workload (kernel build?) in a controlled ns.
>> >> >
>> >> Should it affect? If at all, it should be +ve since, the recursive
>> >> user-ns hierarchy lookup is avoided with the above check if the
>> >> capability is controlled.
>> >
>> > Yes but I expect that to be the rare case for normal lxc installs
>> > (which are of course what I am interested in)
>> >
>> >>  The additional cost otherwise is this check
>> >> per cap_capable() call.
>> >
>> > And pipeline refetching?
>> >
>> > Capability calls also shouldn't be all that frequent, but still I'm
>> > left wondering...
>>
>> Correct, and capability checks are part of the control-path and not
>> the data-path so shouldn't matter but I guess it doesn't hurt to
>> find-out the number. Do you have any workload in mind, that we can use
>> for this test/benchmark?
>
> I suppose if you did both (a) a kernel build and (b) a webserve
> like https://github.com/m3ng9i/ran , being hit for a minute by a
> heavy load of requests, those two together would be re-assuring.
>
Well, I did (a) and (b). Here are the results.

(a0) I used the ubuntu-artful (17.10) vm instance with standard kernel
to compile the kernel

mahesh@mahesh-vm0-artful:~/Work/Linux$ time make -j4 -s clean
mahesh@mahesh-vm0-artful:~/Work/Linux$ time make -j4 -s
real 6m47.525s
user 22m37.424s
sys 2m44.745s

(b0) Now in an user-namespce create by an user that does not have
SYS_ADMIN (just for apples-to-apples comparison)
mahesh@mahesh-vm0-artful:~$ sysctl -q kernel.controlled_userns_caps_whiteli=
st
sysctl: cannot stat /proc/sys/kernel/controlled_userns_caps_whitelist:
No such file or directory
mahesh@mahesh-vm0-artful:~$ id
uid=3D1000(mahesh) gid=3D1000(mahesh)
groups=3D1000(mahesh),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),118(lpa=
dmin),128(sambashare)
mahesh@mahesh-vm0-artful:~/Work/Linux$ unshare -Uf -- bash
nobody@mahesh-vm0-artful:~/Work/Linux$ id
uid=3D65534(nobody) gid=3D65534(nogroup) groups=3D65534(nogroup)
nobody@mahesh-vm0-artful:~/Work/Linux$ time make -j4 -s clean
nobody@mahesh-vm0-artful:~/Work/Linux$ time make -j4 -s
real 9m10.115s
user 25m20.984s
sys 2m48.129s


(a1) Now patched the same kernel and built and booted with this new kernel =
-

mahesh@mahesh-vm0-artful:~$ sysctl -q kernel.controlled_userns_caps_whiteli=
st
kernel.controlled_userns_caps_whitelist =3D 1f,ffffffff
mahesh@mahesh-vm0-artful:~/Work/Linux$ time make -j4 -s clean
mahesh@mahesh-vm0-artful:~/Work/Linux$ time make -j4 -s
real 6m39.964s
user 22m23.538s
sys 2m34.258s

(b1) Now in an user-namespace created by an user that does not have SYS_ADM=
IN

mahesh@mahesh-vm0-artful:~$ id
uid=3D1000(mahesh) gid=3D1000(mahesh)
groups=3D1000(mahesh),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),118(lpa=
dmin),128(sambashare)
mahesh@mahesh-vm0-artful:~/Work/Linux$ unshare -Uf -- bash
nobody@mahesh-vm0-artful:~/Work/Linux$ id
uid=3D65534(nobody) gid=3D65534(nogroup) groups=3D65534(nogroup)
nobody@mahesh-vm0-artful:~/Work/Linux$ make -s clean
nobody@mahesh-vm0-artful:~/Work/Linux$ time make -j4 -s
real 6m54.725s
user 23m18.833s
sys 2m38.996s

---

For the http-get test, I used the same 'ran' utility you have proposed
and wrapped inside a script like -
mahesh@mahesh-vm0-artful:~/Work/Scripts$ cat RanLauncher1m.sh
#!/bin/bash
set -v
(sleep 60; killall ran) &
time (cd ~/go/bin; ./ran -i index.html >& /dev/null)

and another script that constantly performs wget -
mahesh@mahesh-vm0-artful:~/Work/Scripts$ cat WgetLoop.sh#!/bin/bash
#set -v
while true; do
wget http://127.0.0.1:8080 >& /dev/null

... here are the results -
(A0) Kernel that is unpatched and comes with ubuntu-artful

mahesh@mahesh-vm0-artful:~/Work/Scripts$ ./RanLauncher1m.sh
(sleep 60; killall ran) &
time (cd ~/go/bin; ./ran -i index.html >& /dev/null)
real 1m0.009s
user 0m2.885s
sys 0m2.774s

(B0) Now in an user-ns created by an user that does not have SYS_ADMIN

mahesh@mahesh-vm0-artful:~/Work/Scripts$ unshare -Uf -- bash
nobody@mahesh-vm0-artful:~/Work/Scripts$ ./RanLauncher1m.sh
(sleep 60; killall ran) &
time (cd ~/go/bin; ./ran -i index.html >& /dev/null)
real 1m0.004s
user 0m3.003s
sys 0m2.737s

(A1) With the patched kernel

mahesh@mahesh-vm0-artful:~/Work/Scripts$ ./RanLauncher1m.sh
(sleep 60; killall ran) &
time (cd ~/go/bin; ./ran -i index.html >& /dev/null)

real 1m0.005s
user 0m1.941s
sys 0m1.507s


(B1) With patched kernel and inside user-ns

mahesh@mahesh-vm0-artful:~/Work/Scripts$ unshare -Uf -- bash
nobody@mahesh-vm0-artful:~/Work/Scripts$ ./RanLauncher1m.sh
(sleep 60; killall ran) &
time (cd ~/go/bin; ./ran -i index.html >& /dev/null)
real 1m0.004s
user 0m1.513s
sys 0m1.254s

> thanks,
> -serge
