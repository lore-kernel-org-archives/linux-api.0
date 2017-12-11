From: Eric Paris <eparis@redhat.com>
Subject: Re: RFC(v2): Audit Kernel Container IDs
Date: Mon, 11 Dec 2017 11:30:57 -0500
Message-ID: <1513009857.6310.337.camel@redhat.com>
References: <20171012141359.saqdtnodwmbz33b2@madcap2.tricolour.ca>
         <75b7d6a6-42ba-2dff-1836-1091c7c024e7@schaufler-ca.com>
         <7ebca85a-425c-2b95-9a5f-59d81707339e@digikod.net>
         <f8ea78be-9bbf-2967-7b12-ac93bb85b0bc@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f8ea78be-9bbf-2967-7b12-ac93bb85b0bc@schaufler-ca.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, Richard Guy Briggs <rgb@redhat.com>, cgroups@vger.kernel.org, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Audit <linux-audit@redhat.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux Network Development <netdev@vger.kernel.org>
Cc: mszeredi@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>, Simo Sorce <simo@redhat.com>, jlayton@redhat.com, Carlos O'Donell <carlos@redhat.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Eric Paris <eparis@parisplace.org>, trondmy@primarydata.com, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Sat, 2017-12-09 at 10:28 -0800, Casey Schaufler wrote:
> On 12/9/2017 2:20 AM, Mickaï¿½l Salaï¿½n wrote:

> >  What about automatically create
> > and assign an ID to a process when it enters a namespace different
> > than
> > one of its parent process? This delegates the (permission)
> > responsibility to the use of namespaces (e.g. /proc/sys/user/max_*
> > limit).
> 
> That gets ugly when you have a container that uses user, filesystem,
> network and whatever else namespaces. If all containers used the same
> set of namespaces I think this would be a fine idea, but they don't.
> 
> > One interesting side effect of this approach would be to be able to
> > identify which processes are in the same set of namespaces, even if
> > not
> > spawn from the container but entered after its creation (i.e. using
> > setns), by creating container IDs as a (deterministic) checksum
> > from the
> > /proc/self/ns/* IDs.
> > 
> > Since the concern is to identify a container, I think the ability
> > to
> > audit the switch from one container ID to another is enough. I
> > don't
> > think we need nested IDs.
> 
> Because a container doesn't have to use namespaces to be a container
> you still need a mechanism for a process to declare that it is in
> fact
> in a container, and to identify the container.

I like the idea but I'm still tossing it around in my head (and
thinking about Casey's statement too). Lets say we have a 'docker-like' 
container with pid=100  netns=X,userns=Y,mountns=Z. If I'm on the host
in all init namespaces and I run
  nsenter -t 100 -n ip link set eth0 promisc on
How should this be logged? Did this command run in it's own 'container'
unrelated to the 'docker-like' container?

-Eric
