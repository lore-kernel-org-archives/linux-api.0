From: Christian Brauner <christian.brauner@canonical.com>
Subject: Re: [kernel-hardening] Re: [PATCH resend 2/2] userns: control
 capabilities of some user namespaces
Date: Wed, 8 Nov 2017 20:02:25 +0100
Message-ID: <20171108190223.vdkyepcaegmub6le@gmail.com>
References: <20171104235346.GA17170@mail.hallyn.com>
 <CAF2d9jg1tZz-hnVBeXm3geq7jSBt5v5w6+p5B1V-7huS4qbMBA@mail.gmail.com>
 <20171106150302.GA26634@mail.hallyn.com>
 <1510003994.736.0.camel@gmail.com>
 <20171106221418.GA32543@mail.hallyn.com>
 <CAFUG7CcEy9a=RxBQZJR-C_2VuhZXrzJ_QxJnrSxdM=ox36DsXQ@mail.gmail.com>
 <20171106233913.GA1518@mail.hallyn.com>
 <CAFUG7CcW077LHcQEqk7qy7iVvmi-3J8psD1Kwj45XvHThiZC6w@mail.gmail.com>
 <20171107032802.GA6669@mail.hallyn.com>
 <CAF2d9jiwu3Ss7Dtem8qSptKgMc0Mc_o8MAAJkWM5CwJaFsbrcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAF2d9jiwu3Ss7Dtem8qSptKgMc0Mc_o8MAAJkWM5CwJaFsbrcg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mahesh Bandewar =?utf-8?B?KOCkruCkueClh+CktiDgpKzgpILgpKHgpYfgpLXgpL4=?= =?utf-8?B?4KSwKQ==?= <maheshb@google.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Boris Lukashev <blukashev@sempervictus.com>, Daniel Micay <danielmicay@gmail.com>, Mahesh Bandewar <mahesh@bandewar.net>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 08, 2017 at 03:09:59AM -0800, Mahesh Bandewar (महेश बंडेवार) wrote:
> Sorry folks I was traveling and seems like lot happened on this thread. :p
> 
> I will try to response few of these comments selectively -
> 
> > The thing that makes me hesitate with this set is that it is a
> > permanent new feature to address what (I hope) is a temporary
> > problem.
> I agree this is permanent new feature but it's not solving a temporary
> problem. It's impossible to assess what and when new vulnerability
> that could show up. I think Daniel summed it up appropriately in his
> response
> 
> > Seems like there are two naive ways to do it, the first being to just
> > look at all code under ns_capable() plus code called from there.  It
> > seems like looking at the result of that could be fruitful.
> This is really hard. The main issue that there were features designed
> and developed before user-ns days with an assumption that unprivileged
> users will never get certain capabilities which only root user gets.
> Now that is not true anymore with user-ns creation with mapping root
> for any process. Also at the same time blocking user-ns creation for
> eveyone is a big-hammer which is not needed too. So it's not that easy
> to just perform a code-walk-though and correct those decisions now.
> 
> > It seems to me that the existing control in
> > /proc/sys/kernel/unprivileged_userns_clone might be the better duct tape
> > in that case.
> This solution is essentially blocking unprivileged users from using
> the user-namespaces entirely. This is not really a solution that can
> work. The solution that this patch-set adds allows unprivileged users
> to create user-namespaces. Actually the proposed solution is more
> fine-grained approach than the unprivileged_userns_clone solution
> since you can selectively block capabilities rather than completely
> blocking the functionality.

I've been talking to Stéphane today about this and we should also keep in mind
that we have:

chb@conventiont|~
> ls -al /proc/sys/user/
total 0
dr-xr-xr-x 1 root root 0 Nov  6 23:32 .
dr-xr-xr-x 1 root root 0 Nov  2 22:13 ..
-rw-r--r-- 1 root root 0 Nov  8 19:48 max_cgroup_namespaces
-rw-r--r-- 1 root root 0 Nov  8 19:48 max_inotify_instances
-rw-r--r-- 1 root root 0 Nov  8 19:48 max_inotify_watches
-rw-r--r-- 1 root root 0 Nov  8 19:48 max_ipc_namespaces
-rw-r--r-- 1 root root 0 Nov  8 19:48 max_mnt_namespaces
-rw-r--r-- 1 root root 0 Nov  8 19:48 max_net_namespaces
-rw-r--r-- 1 root root 0 Nov  8 19:48 max_pid_namespaces
-rw-r--r-- 1 root root 0 Nov  8 19:48 max_user_namespaces
-rw-r--r-- 1 root root 0 Nov  8 19:48 max_uts_namespaces

These files allow you to limit the number of namespaces that can be created
*per namespace* type. So let's say your system runs a bunch of user namespaces
you can do:

chb@conventiont|~
> echo 0 > /proc/sys/user/max_user_namespaces

So that the next time you try to create a user namespaces you'd see:

chb@conventiont|~
> unshare -U
unshare: unshare failed: No space left on device

So there's not even a need to upstream a new sysctl since we have ways of
blocking this.

Also I'd like to point out that a lot of capability checks and actual security
vulnerabilities are associated with CAP_SYS_ADMIN. So what you likely want to do
is block CAP_SYS_ADMIN in user namespaces but at this point they become
basically useless for a lot of interesting use cases. In addition, this patch
would add another layer of complexity that is - imho - not really warranted
given what we already have. The relationship between capabilities and user
namespaces should stay as simply as possible so that it stays maintaineable.
User namespaces already introduce a proper layer of complexity.
Just my two cents. I might be totally off here of course.

Christian
