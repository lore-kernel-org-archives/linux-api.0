From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv3 0/2] capability controlled user-namespaces
Date: Sat, 30 Dec 2017 09:50:42 +0100
Message-ID: <7658ff18-23fc-6aff-6bac-15573f67ddfb@gmail.com>
References: <20171205223052.12687-1-mahesh@bandewar.net>
 <CAF2d9jit74_VCdD-pEFy3bJo2W1-0cDo0BOJC5beJiy8yFPCWg@mail.gmail.com>
 <CAKgNAkgzyUT5-Gb7COjz5Um0f=ViH8s8ap4Jh9vvtyS8G=iDkw@mail.gmail.com>
 <CAF2d9jjCJxu+oiCCSa1zN8OxfdiCMQb4dx7Mc0YdNgJuMNkOzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAF2d9jjCJxu+oiCCSa1zN8OxfdiCMQb4dx7Mc0YdNgJuMNkOzw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS1?= =?UTF-8?B?4KS+4KSwKQ==?= <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel-hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mahesh Bandewar <mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Mahesh,

On 12/28/2017 01:45 AM, Mahesh Bandewar (महेश बंडेवार) wrote:
> On Wed, Dec 27, 2017 at 12:23 PM, Michael Kerrisk (man-pages)
> <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hello Mahesh,
>>
>> On 27 December 2017 at 18:09, Mahesh Bandewar (महेश बंडेवार)
>> <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>> Hello James,
>>>
>>> Seems like I missed your name to be added into the review of this
>>> patch series. Would you be willing be pull this into the security
>>> tree? Serge Hallyn has already ACKed it.
>>
>> We seem to have no formal documentation/specification of this feature.
>> I think that should be written up before this patch goes into
>> mainline...
>>
> absolutely. I have added enough information into the Documentation dir
> relevant to this feature (please look at the  individual patches),
> that could be used. I could help if needed.

Yes, but I think that the documentation is rather incomplete.
I'll also reply to the relevant Documentation thread.

See also some comments below about this commit message, which
should make things *much* easier for the reader.

>>> On Tue, Dec 5, 2017 at 2:30 PM, Mahesh Bandewar <mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org> wrote:
>>>> From: Mahesh Bandewar <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>>
>>>> TL;DR version
>>>> -------------
>>>> Creating a sandbox environment with namespaces is challenging
>>>> considering what these sandboxed processes can engage into. e.g.
>>>> CVE-2017-6074, CVE-2017-7184, CVE-2017-7308 etc. just to name few.
>>>> Current form of user-namespaces, however, if changed a bit can allow
>>>> us to create a sandbox environment without locking down user-
>>>> namespaces.
>>>>
>>>> Detailed version
>>>> ----------------
>>>>
>>>> Problem
>>>> -------
>>>> User-namespaces in the current form have increased the attack surface as
>>>> any process can acquire capabilities which are not available to them (by
>>>> default) by performing combination of clone()/unshare()/setns() syscalls.
>>>>
>>>>     #define _GNU_SOURCE
>>>>     #include <stdio.h>
>>>>     #include <sched.h>
>>>>     #include <netinet/in.h>
>>>>
>>>>     int main(int ac, char **av)
>>>>     {
>>>>         int sock = -1;
>>>>
>>>>         printf("Attempting to open RAW socket before unshare()...\n");
>>>>         sock = socket(AF_INET6, SOCK_RAW, IPPROTO_RAW);
>>>>         if (sock < 0) {
>>>>             perror("socket() SOCK_RAW failed: ");
>>>>         } else {
>>>>             printf("Successfully opened RAW-Sock before unshare().\n");
>>>>             close(sock);
>>>>             sock = -1;
>>>>         }
>>>>
>>>>         if (unshare(CLONE_NEWUSER | CLONE_NEWNET) < 0) {
>>>>             perror("unshare() failed: ");
>>>>             return 1;
>>>>         }
>>>>
>>>>         printf("Attempting to open RAW socket after unshare()...\n");
>>>>         sock = socket(AF_INET6, SOCK_RAW, IPPROTO_RAW);
>>>>         if (sock < 0) {
>>>>             perror("socket() SOCK_RAW failed: ");
>>>>         } else {
>>>>             printf("Successfully opened RAW-Sock after unshare().\n");
>>>>             close(sock);
>>>>             sock = -1;
>>>>         }
>>>>
>>>>         return 0;
>>>>     }
>>>>
>>>> The above example shows how easy it is to acquire NET_RAW capabilities
>>>> and once acquired, these processes could take benefit of above mentioned
>>>> or similar issues discovered/undiscovered with malicious intent.

But you do not actually describe what the problem is. I think
it's not sufficient to simply refer to some CVEs.
Your mail message/commit should clearly describe what the issue is,
rather than leave the reader to decipher a bunch of CVEs, and derive
your concerns from those CVEs.

>>>> Note
>>>> that this is just an example and the problem/solution is not limited
>>>> to NET_RAW capability *only*.
>>>>
>>>> The easiest fix one can apply here is to lock-down user-namespaces which
>>>> many of the distros do (i.e. don't allow users to create user namespaces),
>>>> but unfortunately that prevents everyone from using them.
>>>>
>>>> Approach
>>>> --------
>>>> Introduce a notion of 'controlled' user-namespaces. Every process on
>>>> the host is allowed to create user-namespaces (governed by the limit
>>>> imposed by per-ns sysctl) however, mark user-namespaces created by
>>>> sandboxed processes as 'controlled'. Use this 'mark' at the time of
>>>> capability check in conjunction with a global capability whitelist.
>>>> If the capability is not whitelisted, processes that belong to
>>>> controlled user-namespaces will not be allowed.
>>>>
>>>> Once a user-ns is marked as 'controlled'; all its child user-
>>>> namespaces are marked as 'controlled' too.

How is a user-ns marked as "controlled"? It is not clear at this point.
Please clarify this in your cover mail (and on the Documentation patch.)

>>>> A global whitelist is list of capabilities governed by the
>>>> sysctl which is available to (privileged) user in init-ns to modify

What "the sysctl? Please name it at this point. (This may be purely a 
language issue. Do you mean "...governed by *a* sysctl, 
[sysctl-name-inserted-here]"?)

>>>> while it's applicable to all controlled user-namespaces on the host.
>>>>
>>>> Marking user-namespaces controlled without modifying the whitelist is
>>>> equivalent of the current behavior. The default value of whitelist includes
>>>> all capabilities so that the compatibility is maintained. However it gives
>>>> admins fine-grained ability to control various capabilities system wide
>>>> without locking down user-namespaces.

Is there a way that a process can see whether it is a controlled user-ns
versus an uncontrolled user-ns? I think it would be good to explain that 
in this cover mail, and perhaps also in the documentation patch.

In general, it's not too obvious what you are trying to do, based on 
this commit message.

Can I suggest including as part of the commit messages a walk through
shell session that demonstrates the use of these interfaces and how
they allow/disallow capabilities. I think such a walkthrough might also
be worth including in the Documentation patch.

Thanks,

Michael


>>>>
>>>> Please see individual patches in this series.
>>>>
>>>> Mahesh Bandewar (2):
>>>>   capability: introduce sysctl for controlled user-ns capability whitelist
>>>>   userns: control capabilities of some user namespaces
>>>>
>>>>  Documentation/sysctl/kernel.txt | 21 +++++++++++++++++
>>>>  include/linux/capability.h      |  7 ++++++
>>>>  include/linux/user_namespace.h  | 25 ++++++++++++++++++++
>>>>  kernel/capability.c             | 52 +++++++++++++++++++++++++++++++++++++++++
>>>>  kernel/sysctl.c                 |  5 ++++
>>>>  kernel/user_namespace.c         |  4 ++++
>>>>  security/commoncap.c            |  8 +++++++
>>>>  7 files changed, 122 insertions(+)
>>>>
>>>> --
>>>> 2.15.0.531.g2ccb3012c9-goog
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-api" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> Michael Kerrisk
>> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
>> Linux/UNIX System Programming Training: http://man7.org/training/
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
