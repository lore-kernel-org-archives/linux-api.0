From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?=
        <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH resend 2/2] userns: control
 capabilities of some user namespaces
Date: Thu, 9 Nov 2017 09:55:41 +0900
Message-ID: <CAF2d9jjed4Q7QvCD9Kpaa7L-Ngg3XFbJvt0jNVUUwt=52wDjjw@mail.gmail.com>
References: <20171104235346.GA17170@mail.hallyn.com> <CAF2d9jg1tZz-hnVBeXm3geq7jSBt5v5w6+p5B1V-7huS4qbMBA@mail.gmail.com>
 <20171106150302.GA26634@mail.hallyn.com> <1510003994.736.0.camel@gmail.com>
 <20171106221418.GA32543@mail.hallyn.com> <CAFUG7CcEy9a=RxBQZJR-C_2VuhZXrzJ_QxJnrSxdM=ox36DsXQ@mail.gmail.com>
 <20171106233913.GA1518@mail.hallyn.com> <CAFUG7CcW077LHcQEqk7qy7iVvmi-3J8psD1Kwj45XvHThiZC6w@mail.gmail.com>
 <20171107032802.GA6669@mail.hallyn.com> <CAF2d9jiwu3Ss7Dtem8qSptKgMc0Mc_o8MAAJkWM5CwJaFsbrcg@mail.gmail.com>
 <20171108190223.vdkyepcaegmub6le@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171108190223.vdkyepcaegmub6le-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christian Brauner <christian.brauner-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Boris Lukashev <blukashev-JNja4Z15B3SvB/ACxS1yDA@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mahesh Bandewar <mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel-hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 9, 2017 at 4:02 AM, Christian Brauner
<christian.brauner-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> On Wed, Nov 08, 2017 at 03:09:59AM -0800, Mahesh Bandewar (=E0=A4=AE=E0=
=A4=B9=E0=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=
=A4=BE=E0=A4=B0) wrote:
>> Sorry folks I was traveling and seems like lot happened on this thread. =
:p
>>
>> I will try to response few of these comments selectively -
>>
>> > The thing that makes me hesitate with this set is that it is a
>> > permanent new feature to address what (I hope) is a temporary
>> > problem.
>> I agree this is permanent new feature but it's not solving a temporary
>> problem. It's impossible to assess what and when new vulnerability
>> that could show up. I think Daniel summed it up appropriately in his
>> response
>>
>> > Seems like there are two naive ways to do it, the first being to just
>> > look at all code under ns_capable() plus code called from there.  It
>> > seems like looking at the result of that could be fruitful.
>> This is really hard. The main issue that there were features designed
>> and developed before user-ns days with an assumption that unprivileged
>> users will never get certain capabilities which only root user gets.
>> Now that is not true anymore with user-ns creation with mapping root
>> for any process. Also at the same time blocking user-ns creation for
>> eveyone is a big-hammer which is not needed too. So it's not that easy
>> to just perform a code-walk-though and correct those decisions now.
>>
>> > It seems to me that the existing control in
>> > /proc/sys/kernel/unprivileged_userns_clone might be the better duct ta=
pe
>> > in that case.
>> This solution is essentially blocking unprivileged users from using
>> the user-namespaces entirely. This is not really a solution that can
>> work. The solution that this patch-set adds allows unprivileged users
>> to create user-namespaces. Actually the proposed solution is more
>> fine-grained approach than the unprivileged_userns_clone solution
>> since you can selectively block capabilities rather than completely
>> blocking the functionality.
>
> I've been talking to St=C3=A9phane today about this and we should also ke=
ep in mind
> that we have:
>
> chb@conventiont|~
>> ls -al /proc/sys/user/
> total 0
> dr-xr-xr-x 1 root root 0 Nov  6 23:32 .
> dr-xr-xr-x 1 root root 0 Nov  2 22:13 ..
> -rw-r--r-- 1 root root 0 Nov  8 19:48 max_cgroup_namespaces
> -rw-r--r-- 1 root root 0 Nov  8 19:48 max_inotify_instances
> -rw-r--r-- 1 root root 0 Nov  8 19:48 max_inotify_watches
> -rw-r--r-- 1 root root 0 Nov  8 19:48 max_ipc_namespaces
> -rw-r--r-- 1 root root 0 Nov  8 19:48 max_mnt_namespaces
> -rw-r--r-- 1 root root 0 Nov  8 19:48 max_net_namespaces
> -rw-r--r-- 1 root root 0 Nov  8 19:48 max_pid_namespaces
> -rw-r--r-- 1 root root 0 Nov  8 19:48 max_user_namespaces
> -rw-r--r-- 1 root root 0 Nov  8 19:48 max_uts_namespaces
>
> These files allow you to limit the number of namespaces that can be creat=
ed
> *per namespace* type. So let's say your system runs a bunch of user names=
paces
> you can do:
>
> chb@conventiont|~
>> echo 0 > /proc/sys/user/max_user_namespaces
>
> So that the next time you try to create a user namespaces you'd see:
>
> chb@conventiont|~
>> unshare -U
> unshare: unshare failed: No space left on device
>
> So there's not even a need to upstream a new sysctl since we have ways of
> blocking this.
>
I'm not sure how it's solving the problem that my patch-set is addressing?
I agree though that the need for unprivileged_userns_clone sysctl goes
away as this is equivalent to setting that sysctl to 0 as you have
described above.
However as I mentioned earlier, blocking processes from creating
user-namespaces is not the solution. Processes should be able to
create namespaces as they are designed but at the same time we need to
have controls to 'contain' them if a need arise. Setting max_no to 0
is not the solution that I'm looking for since it doesn't solve the
problem.

> Also I'd like to point out that a lot of capability checks and actual sec=
urity
> vulnerabilities are associated with CAP_SYS_ADMIN. So what you likely wan=
t to do
> is block CAP_SYS_ADMIN in user namespaces but at this point they become
> basically useless for a lot of interesting use cases. In addition, this p=
atch
> would add another layer of complexity that is - imho - not really warrant=
ed
> given what we already have.
I disagree. I'm not sure how this patch is adding complexity? Simply
the functionality is maintained exactly as it is with an extra knob
which allows you to take control back if a situation arise. Once the
kernel is patched for whatever was discovered, life returns back to
normal by readjusting the knob. It's as simple as that!

> The relationship between capabilities and user
> namespaces should stay as simply as possible so that it stays maintaineab=
le.
> User namespaces already introduce a proper layer of complexity.
> Just my two cents. I might be totally off here of course.
The side effect of the solution is that you have sort-of scaled-down /
broken functionality without blocking the feature completely until
life returns to normal. If the workload needs the exact same
capability that is being controlled, then tough luck but chances of
you having a workload that is not in contention with the capability
that is being controlled is very high. In a situation like that you
wont even notice the change but at the same time admin can ensure that
the exploit is contained. This has a very high value.

>

> Christian
