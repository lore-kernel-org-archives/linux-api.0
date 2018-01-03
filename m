From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCHv4 0/2] capability controlled user-namespaces
Date: Wed, 03 Jan 2018 10:44:06 -0600
Message-ID: <87po6qzycp.fsf@xmission.com>
References: <20180103072642.161742-1-mahesh@bandewar.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20180103072642.161742-1-mahesh@bandewar.net> (Mahesh Bandewar's
        message of "Tue, 2 Jan 2018 23:26:42 -0800")
Sender: owner-linux-security-module@vger.kernel.org
To: Mahesh Bandewar <mahesh@bandewar.net>
Cc: LKML <linux-kernel@vger.kernel.org>, James Morris <james.l.morris@oracle.com>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Linux Security <linux-security-module@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>, Mahesh Bandewar <maheshb@google.com>
List-Id: linux-api@vger.kernel.org

Mahesh Bandewar <mahesh@bandewar.net> writes:

> From: Mahesh Bandewar <maheshb@google.com>
>
> TL;DR version
> -------------
> Creating a sandbox environment with namespaces is challenging
> considering what these sandboxed processes can engage into. e.g.
> CVE-2017-6074, CVE-2017-7184, CVE-2017-7308 etc. just to name few.
> Current form of user-namespaces, however, if changed a bit can allow
> us to create a sandbox environment without locking down user-
> namespaces.

In other conversations it appears it has been pointed out that user
namespaces are not necessarily safe under no_new_privs.  In theory
user namespaces should be safe but in practice not so much.

So let me ask.  Would your concerns be addressed if we simply made
creation and joining of user namespaces impossible in a no_new_privs
sandbox?

Eric

>
> Detailed version
> ----------------
>
> Problem
> -------
> User-namespaces in the current form have increased the attack surface as
> any process can acquire capabilities which are not available to them (by
> default) by performing combination of clone()/unshare()/setns() syscalls.
>
>     #define _GNU_SOURCE
>     #include <stdio.h>
>     #include <sched.h>
>     #include <netinet/in.h>
>
>     int main(int ac, char **av)
>     {
>         int sock = -1;
>
>         printf("Attempting to open RAW socket before unshare()...\n");
>         sock = socket(AF_INET6, SOCK_RAW, IPPROTO_RAW);
>         if (sock < 0) {
>             perror("socket() SOCK_RAW failed: ");
>         } else {
>             printf("Successfully opened RAW-Sock before unshare().\n");
>             close(sock);
>             sock = -1;
>         }
>
>         if (unshare(CLONE_NEWUSER | CLONE_NEWNET) < 0) {
>             perror("unshare() failed: ");
>             return 1;
>         }
>
>         printf("Attempting to open RAW socket after unshare()...\n");
>         sock = socket(AF_INET6, SOCK_RAW, IPPROTO_RAW);
>         if (sock < 0) {
>             perror("socket() SOCK_RAW failed: ");
>         } else {
>             printf("Successfully opened RAW-Sock after unshare().\n");
>             close(sock);
>             sock = -1;
>         }
>
>         return 0;
>     }
>
> The above example shows how easy it is to acquire NET_RAW capabilities
> and once acquired, these processes could take benefit of above mentioned
> or similar issues discovered/undiscovered with malicious intent. Note
> that this is just an example and the problem/solution is not limited
> to NET_RAW capability *only*. 
>
> The easiest fix one can apply here is to lock-down user-namespaces which
> many of the distros do (i.e. don't allow users to create user namespaces),
> but unfortunately that prevents everyone from using them.
>
> Approach
> --------
> Introduce a notion of 'controlled' user-namespaces. Every process on
> the host is allowed to create user-namespaces (governed by the limit
> imposed by per-ns sysctl) however, mark user-namespaces created by
> sandboxed processes as 'controlled'. Use this 'mark' at the time of
> capability check in conjunction with a global capability whitelist.
> If the capability is not whitelisted, processes that belong to 
> controlled user-namespaces will not be allowed.
>
> Processes that do not have CAP_SYS_ADMIN in init-ns can *only* create
> controlled user-namespaces. In other words, user-namespaces created by
> privileged processes (those which have CAP_SYS_ADMIN in init-ns) are
> not controlled. A hierarchy underneath any controlled user-ns is always
> controlled.
>
> A global whitelist is list of capabilities governed by a sysctl
> (kernel.controlled_userns_caps_whitelist) which is available to
> (privileged) user in init-ns to modify while it's applicable to all
> controlled user-namespaces on the host irrespective of when that user-ns
> was created.
>
> Marking user-namespaces controlled without modifying the whitelist is
> equivalent of the current behavior. The default value of whitelist includes
> all capabilities so that the compatibility is maintained. However it gives
> admins fine-grained ability to control various capabilities system wide
> without locking down user-namespaces.
>
> Example
> -------
> Here is the example that demonstrates the behavior of a kernel that has
> this patch-set applied. It uses the same c-code from this commit-log and
> is called acquire_raw.c -
>
> (a) The 'root' user has all the capabilities all the time (before and
>     after taking capability).
>
>     root@vm0:~# id
>     uid=0(root) gid=0(root) groups=0(root)
>
>     root@vm0:~# sysctl -q kernel.controlled_userns_caps_whitelist 
>     kernel.controlled_userns_caps_whitelist = 1f,ffffffff
>
>     root@vm0:~# ./acquire_raw 
>     Attempting to open RAW socket before unshare()...
>     Successfully opened RAW-Sock before unshare().
>     Attempting to open RAW socket after unshare()...
>     Successfully opened RAW-Sock after unshare().
>
>     root@vm0:~# sysctl -w kernel.controlled_userns_caps_whitelist=1f,ffffdfff
>     kernel.controlled_userns_caps_whitelist = 1f,ffffdfff
>
>     root@vm0:~# ./acquire_raw 
>     Attempting to open RAW socket before unshare()...
>     Successfully opened RAW-Sock before unshare().
>     Attempting to open RAW socket after unshare()...
>     Successfully opened RAW-Sock after unshare().
>
> (b) Unprivileged user cannot change the mask.
>
>     mahesh@vm0:~$ id
>     uid=1000(mahesh) gid=1000(mahesh)
>     groups=1000(mahesh),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),118(lpadmin),128(sambashare)
>
>     mahesh@vm0:~$ sysctl -q kernel.controlled_userns_caps_whitelist 
>     kernel.controlled_userns_caps_whitelist = 1f,ffffffff
>
>     mahesh@vm0:~$ sysctl -w kernel.controlled_userns_caps_whitelist=1f,ffffdfff
>     sysctl: permission denied on key 'kernel.controlled_userns_caps_whitelist'
>
> (c) Unprivileged user does not have CAP_NET_RAW in init-ns but can get
>     that capability inside child-user-ns when the controlled_userns_caps
>     mask is unchanged (current behavior).
>
>     mahesh@vm0:~$ sysctl -q kernel.controlled_userns_caps_whitelist 
>     kernel.controlled_userns_caps_whitelist = 1f,ffffffff
>
>     mahesh@vm0:~$ ./acquire_raw 
>     Attempting to open RAW socket before unshare()...
>     socket() SOCK_RAW failed: : Operation not permitted
>     Attempting to open RAW socket after unshare()...
>     Successfully opened RAW-Sock after unshare().
>
> (d) Changing the controlled_userns_caps_whitelist mask will prevent user
>     for acquiring 'controlled capability' inside user-namespace.
>
>     mahesh@vm0:~$ sysctl -q kernel.controlled_userns_caps_whitelist 
>     kernel.controlled_userns_caps_whitelist = 1f,ffffdfff
>     mahesh@vm0:~$ ./acquire_raw 
>     Attempting to open RAW socket before unshare()...
>     socket() SOCK_RAW failed: : Operation not permitted
>     Attempting to open RAW socket after unshare()...
>     socket() SOCK_RAW failed: : Operation not permitted
>
>
> Please see individual patches in this series.
>
> Mahesh Bandewar (2):
>   capability: introduce sysctl for controlled user-ns capability whitelist
>   userns: control capabilities of some user namespaces
>
>  Documentation/sysctl/kernel.txt | 21 +++++++++++++++++
>  include/linux/capability.h      |  7 ++++++
>  include/linux/user_namespace.h  | 25 ++++++++++++++++++++
>  kernel/capability.c             | 52 +++++++++++++++++++++++++++++++++++++++++
>  kernel/sysctl.c                 |  5 ++++
>  kernel/user_namespace.c         |  4 ++++
>  security/commoncap.c            |  8 +++++++
>  7 files changed, 122 insertions(+)
