From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?=
        <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH resend 2/2] userns: control
 capabilities of some user namespaces
Date: Fri, 10 Nov 2017 13:30:56 +0900
Message-ID: <CAF2d9ji5WVUjKSnmy+PFw+Ee9hMNXNPssLONLVxt6HDM1dSeOA@mail.gmail.com>
References: <20171106150302.GA26634@mail.hallyn.com> <1510003994.736.0.camel@gmail.com>
 <20171106221418.GA32543@mail.hallyn.com> <CAFUG7CcEy9a=RxBQZJR-C_2VuhZXrzJ_QxJnrSxdM=ox36DsXQ@mail.gmail.com>
 <20171106233913.GA1518@mail.hallyn.com> <CAFUG7CcW077LHcQEqk7qy7iVvmi-3J8psD1Kwj45XvHThiZC6w@mail.gmail.com>
 <20171107032802.GA6669@mail.hallyn.com> <CAF2d9jiwu3Ss7Dtem8qSptKgMc0Mc_o8MAAJkWM5CwJaFsbrcg@mail.gmail.com>
 <20171108190223.vdkyepcaegmub6le@gmail.com> <CAF2d9jjed4Q7QvCD9Kpaa7L-Ngg3XFbJvt0jNVUUwt=52wDjjw@mail.gmail.com>
 <20171109032134.GA15666@mail.hallyn.com> <CAF2d9jgs5MYn1dMT2mbhF=6UB2Hoo5kwmJhXuE6memBfWzkWXQ@mail.gmail.com>
 <871sl7dsh8.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <871sl7dsh8.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Christian Brauner <christian.brauner-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Boris Lukashev <blukashev-JNja4Z15B3SvB/ACxS1yDA@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mahesh Bandewar <mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel-hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 10, 2017 at 6:58 AM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> "Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=
=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0)" <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes=
:
>
>> [resend response as earlier one failed because of formatting issues]
>>
>> On Thu, Nov 9, 2017 at 12:21 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrot=
e:
>>>
>>> On Thu, Nov 09, 2017 at 09:55:41AM +0900, Mahesh Bandewar (=E0=A4=AE=E0=
=A4=B9=E0=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=
=A4=BE=E0=A4=B0) wrote:
>>> > On Thu, Nov 9, 2017 at 4:02 AM, Christian Brauner
>>> > <christian.brauner-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
>>> > > On Wed, Nov 08, 2017 at 03:09:59AM -0800, Mahesh Bandewar (=E0=A4=
=AE=E0=A4=B9=E0=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=
=B5=E0=A4=BE=E0=A4=B0) wrote:
>>> > >> Sorry folks I was traveling and seems like lot happened on this th=
read. :p
>>> > >>
>>> > >> I will try to response few of these comments selectively -
>>> > >>
>>> > >> > The thing that makes me hesitate with this set is that it is a
>>> > >> > permanent new feature to address what (I hope) is a temporary
>>> > >> > problem.
>>> > >> I agree this is permanent new feature but it's not solving a tempo=
rary
>>> > >> problem. It's impossible to assess what and when new vulnerability
>>> > >> that could show up. I think Daniel summed it up appropriately in h=
is
>>> > >> response
>>> > >>
>>> > >> > Seems like there are two naive ways to do it, the first being to=
 just
>>> > >> > look at all code under ns_capable() plus code called from there.=
  It
>>> > >> > seems like looking at the result of that could be fruitful.
>>> > >> This is really hard. The main issue that there were features desig=
ned
>>> > >> and developed before user-ns days with an assumption that unprivil=
eged
>>> > >> users will never get certain capabilities which only root user get=
s.
>>> > >> Now that is not true anymore with user-ns creation with mapping ro=
ot
>>> > >> for any process. Also at the same time blocking user-ns creation f=
or
>>> > >> eveyone is a big-hammer which is not needed too. So it's not that =
easy
>>> > >> to just perform a code-walk-though and correct those decisions now=
.
>>> > >>
>>> > >> > It seems to me that the existing control in
>>> > >> > /proc/sys/kernel/unprivileged_userns_clone might be the better d=
uct tape
>>> > >> > in that case.
>>> > >> This solution is essentially blocking unprivileged users from usin=
g
>>> > >> the user-namespaces entirely. This is not really a solution that c=
an
>>> > >> work. The solution that this patch-set adds allows unprivileged us=
ers
>>> > >> to create user-namespaces. Actually the proposed solution is more
>>> > >> fine-grained approach than the unprivileged_userns_clone solution
>>> > >> since you can selectively block capabilities rather than completel=
y
>>> > >> blocking the functionality.
>>> > >
>>> > > I've been talking to St=C3=A9phane today about this and we should a=
lso keep in mind
>>> > > that we have:
>>> > >
>>> > > chb@conventiont|~
>>> > >> ls -al /proc/sys/user/
>>> > > total 0
>>> > > dr-xr-xr-x 1 root root 0 Nov  6 23:32 .
>>> > > dr-xr-xr-x 1 root root 0 Nov  2 22:13 ..
>>> > > -rw-r--r-- 1 root root 0 Nov  8 19:48 max_cgroup_namespaces
>>> > > -rw-r--r-- 1 root root 0 Nov  8 19:48 max_inotify_instances
>>> > > -rw-r--r-- 1 root root 0 Nov  8 19:48 max_inotify_watches
>>> > > -rw-r--r-- 1 root root 0 Nov  8 19:48 max_ipc_namespaces
>>> > > -rw-r--r-- 1 root root 0 Nov  8 19:48 max_mnt_namespaces
>>> > > -rw-r--r-- 1 root root 0 Nov  8 19:48 max_net_namespaces
>>> > > -rw-r--r-- 1 root root 0 Nov  8 19:48 max_pid_namespaces
>>> > > -rw-r--r-- 1 root root 0 Nov  8 19:48 max_user_namespaces
>>> > > -rw-r--r-- 1 root root 0 Nov  8 19:48 max_uts_namespaces
>>> > >
>>> > > These files allow you to limit the number of namespaces that can be=
 created
>>> > > *per namespace* type. So let's say your system runs a bunch of user=
 namespaces
>>> > > you can do:
>>> > >
>>> > > chb@conventiont|~
>>> > >> echo 0 > /proc/sys/user/max_user_namespaces
>>> > >
>>> > > So that the next time you try to create a user namespaces you'd see=
:
>>> > >
>>> > > chb@conventiont|~
>>> > >> unshare -U
>>> > > unshare: unshare failed: No space left on device
>>> > >
>>> > > So there's not even a need to upstream a new sysctl since we have w=
ays of
>>> > > blocking this.
>>> > >
>>> > I'm not sure how it's solving the problem that my patch-set is addres=
sing?
>>> > I agree though that the need for unprivileged_userns_clone sysctl goe=
s
>>> > away as this is equivalent to setting that sysctl to 0 as you have
>>> > described above.
>>>
>>> oh right that was the reasoning iirc for not needing the other sysctl.
>>>
>>> > However as I mentioned earlier, blocking processes from creating
>>> > user-namespaces is not the solution. Processes should be able to
>>> > create namespaces as they are designed but at the same time we need t=
o
>>> > have controls to 'contain' them if a need arise. Setting max_no to 0
>>> > is not the solution that I'm looking for since it doesn't solve the
>>> > problem.
>>>
>>> well yesterday we were told that was explicitly not the goal, but that =
was
>>> not by you ... i just mention it to explain why we seem to be walking i=
n
>>> circles a bit.
>>>
>>> anyway the bounding set doesn't actually make sense so forget that.   t=
he
>>> question then is just whether it makes sense to allow things to continu=
e
>>> at all in this situation.  would you mind indulging me by giving one or=
 two
>>> concrete examples in the previous known cves of what capabilities you w=
ould
>>> have dropped tto allow the rest to continue to be safely used?
>>>
>> Of course. Let's take an example of the CVE that I have mentioned in
>> my cover-letter -
>> CVE-2017-7308(https://cve.mitre.org/cgi-bin/cvename.cgi?name=3DCVE-2017-=
7308).
>> It's well documented and even has a
>> exploit(https://github.com/xairy/kernel-exploits/tree/master/CVE-2017-73=
08)
>> c-program that can demonstrate how it can be used against non-patched
>> kernel. There is very nice blog
>> post(https://googleprojectzero.blogspot.kr/2017/05/exploiting-linux-kern=
el-via-packet.html)
>> about this vulnerability by Andrey Konovalov.
>>
>> This is about the AF_PACKET socket interface that is protected behind
>> NET_RAW capability. This capability is not available to unprivileged
>> user. However, any unprivileged user can get NET_RAW capability (as
>> demonstrated in the cover-letter code that I have attached in this
>> patch series) so this NET_RAW capability is available to any
>> unprivileged user on the host if the kernel has user-namespaces
>> available.
>>
>> With this patch-set applied, all that is needed is to flip a bit with
>> the sysctl (kernel.controlled_userns_caps_whitelist) as demonstrated
>> below -
>>
>> root@lphh6:~# uname -a
>> Linux lphh6 4.14.0-smp-DEV #97 SMP @1510203579 x86_64 GNU/Linux
>> root@lphh6:~# sysctl -q kernel.controlled_userns_caps_whitelist
>> kernel.controlled_userns_caps_whitelist =3D 1f,ffffffff
>>
>> Now when I run the program (demo from the cover-letter) as a normal
>> unprivileged user I can't create a RAW socket in init-ns but I can in
>> the child-ns.
>>
>> dumbo@lphh6:~$ /tmp/acquire_raw
>> Attempting to open RAW socket before unshare()...
>> socket() SOCK_RAW failed: : Operation not permitted
>> Attempting to open RAW socket after unshare()...
>> Successfully opened RAW-Sock after unshare().
>> dumbo@lphh6:~$
>>
>> Now as a root user. Take off CAP_NET_RAW
>>
>> root@lphh6:~# sysctl -w kernel.controlled_userns_caps_whitelist=3D1f,fff=
fdfff
>> kernel.controlled_userns_caps_whitelist =3D 1f,ffffdfff
>> root@lphh6:~#
>>
>> Now run the same program as an unprivileged user -
>>
>> dumbo@lphh6:~$ /tmp/acquire_raw
>> Attempting to open RAW socket before unshare()...
>> socket() SOCK_RAW failed: : Operation not permitted
>> Attempting to open RAW socket after unshare()...
>> socket() SOCK_RAW failed: : Operation not permitted
>> dumbo@lphh6:~$
>>
>> Notice that it has failed to create a raw socket in init and in child
>> namespace. It's not blocking creation of user-namespaces but allowing
>> admin turn individual capability bits on and off.
>>
>> This is very simplistic example of just demonstrating how capability
>> bits turn-on/off works. So let's assume a sandboxed environment where
>> we don't know what a binary that we are about run in an environment
>> which is identified as susceptible. By turning off the NET_RAW bit,
>> the admin gets an assurance that system is safe and if binary fails
>> because it's not getting this capability then that bad but a sad
>> consequence (without compromising the host integrity) but if it
>> doesn't use the NET_RAW capability but any other combination of
>> remaining 36 capabilities, it would get whatever is necessary. This
>> means we can safely allow processes to create user-namespaces by
>> taking off certain capabilities in question for temporary/extended
>> period until proper fix is applied without compromising the system
>> integrity. The impact will vary based on which capability is taken off
>> and admin would / should be ware of for the environment that he/she is
>> dealing with.
>
> My challenge with this reasoning is that I don't know that it meanifully
> generalizes to any other capability.
>
> I can in the sandbox today create a user namespace and then set
> max_net_namespaces to 0, and drop CAP_NET_RAW and that blocks
> the attack.  (Possibly with a little spice to prevent a suid root
> program from reacquiring CAP_NET_RAW).
>
This is problematic since you are expecting the user-namespace creator
to perform this operation and then block the child process from
creating the user-namespace. This is similar to making user-namespace
creation a privileged operation discussed previously.

> So while your solution doesn't look horrible especially if it can be
> done at a user namespace level so the restrictions can be limited to a
> single sandbox.  I am not at all certain that the capabilities is the
> proper place to limit code reachability.
>
> I would very much like to see which capabilities that are available with
> ns_capable, are more meaningful to limit than just dropping the
> capability during sandbox creation and denying the creation of the
> corresponding namespace.
>
The primary assumption in this approach is that we can drop
capabilities before running the workload and then not allowing
workload to create the user-namespace. This does not work for cases
where workload needs to create user-namespaces.

> CAP_NET_RAW is one.  Are there any other capabilities that are
> meanginful to limit?
>
There are currently 37 capabilities and I see many of those are
currently namespace aware (with ns_capable() call). Also there seems
to be disproportionate amount of capable() to ns_capable() calls. This
could be a result of not every feature available kernel-wide being
namespace aware/capable etc. and this will evolve and mature i.e.
ns_capable() will continue to grow where this would be applicable.
Also Probably I'm the wrong person to ask this question to since I
understand networking more than anything else. However, the main point
is that we cannot predict which vulnerability is going to get
published tomorrow networking or non-networking, so having a tool that
gives controls to admin while allowing user-namespace creation is
super useful.

thanks,
--mahesh..

> Eric
