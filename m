From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: RFC(v2): Audit Kernel Container IDs
Date: Mon, 11 Dec 2017 08:52:43 -0800
Message-ID: <50813ebc-5de7-c930-79dc-c1d3cfcfb172@schaufler-ca.com>
References: <20171012141359.saqdtnodwmbz33b2@madcap2.tricolour.ca>
 <75b7d6a6-42ba-2dff-1836-1091c7c024e7@schaufler-ca.com>
 <7ebca85a-425c-2b95-9a5f-59d81707339e@digikod.net>
 <f8ea78be-9bbf-2967-7b12-ac93bb85b0bc@schaufler-ca.com>
 <1513009857.6310.337.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513009857.6310.337.camel@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Paris <eparis@redhat.com>, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>, Richard Guy Briggs <rgb@redhat.com>, cgroups@vger.kernel.org, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Audit <linux-audit@redhat.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux Network Development <netdev@vger.kernel.org>
Cc: mszeredi@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>, Simo Sorce <simo@redhat.com>, jlayton@redhat.com, Carlos O'Donell <carlos@redhat.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Eric Paris <eparis@parisplace.org>, trondmy@primarydata.com, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On 12/11/2017 8:30 AM, Eric Paris wrote:
> On Sat, 2017-12-09 at 10:28 -0800, Casey Schaufler wrote:
>> Because a container doesn't have to use namespaces to be a container
>> you still need a mechanism for a process to declare that it is in
>> fact
>> in a container, and to identify the container.
> I like the idea but I'm still tossing it around in my head (and
> thinking about Casey's statement too). Lets say we have a 'docker-like' 
> container with pid=100  netns=X,userns=Y,mountns=Z. If I'm on the host
> in all init namespaces and I run
>   nsenter -t 100 -n ip link set eth0 promisc on
> How should this be logged? Did this command run in it's own 'container'
> unrelated to the 'docker-like' container?

Jose Bollo's PTAGS ( https://gitlab.com/jobol/ptags ) would be
prefect. Any time you declare something to be a container or
enter a namespace you slap a tag on it. Identifying nested
containers would be easy, you'd have multiple tags.

PTAGS unfortunately needs module stacking, but how hard could that be?


> -Eric
