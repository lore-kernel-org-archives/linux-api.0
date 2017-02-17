From: Jason Baron <jbaron@akamai.com>
Subject: Re: [RFC 1/2] fs,eventpoll: Add ability to install target file by its
 number
Date: Fri, 17 Feb 2017 13:34:04 -0500
Message-ID: <c8bc1234-25b4-92dd-d305-839d85489e49@akamai.com>
References: <20170217083324.627615532@openvz.org>
 <CALCETrUOaNaS6yAhLM9jLb8PD2eg2ZwXfu4v327aAOy82SbLwg@mail.gmail.com>
 <20170217171136.GA23766@uranus>
 <CALCETrUmUOXL=72SA-pqNhQda0ic946UNnWUe_vwSHVruiyFfg@mail.gmail.com>
 <20170217180118.GB23766@uranus>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170217180118.GB23766@uranus>
Sender: linux-kernel-owner@vger.kernel.org
To: Cyrill Gorcunov <gorcunov@gmail.com>, Andy Lutomirski <luto@amacapital.net>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linuxfoundation.org>, Andrew Vagin <avagin@virtuozzo.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Kirill Kolyshkin <kir@openvz.org>, Andrey Vagin <avagin@openvz.org>
List-Id: linux-api@vger.kernel.org



On 02/17/2017 01:01 PM, Cyrill Gorcunov wrote:
> On Fri, Feb 17, 2017 at 09:20:34AM -0800, Andy Lutomirski wrote:
>>>>
>>>> This is a scary thing to let an unprivileged process do.
>>>>
>>>> I'm wondering if there might be a nicer way to address this using a
>>>> better interface in /proc.
>>>
>>> Well, I tend to agree. Need to add security checking if the target
>>> file is accessable by a caller. As to better interface to procfs
>>> nothing comes to mind immediately. Another potential problem is that
>>> since it is never guaranteed that target file number listed in fdinfo
>>> matching existing /proc/pid/fd/N, so that I think we will have to
>>> use this dup functionality for every target file, which of course
>>> not that fast. Probably need to think more if I manage to invent
>>> some better and faster interface to find where exactly target file
>>> belong in the whole process tree of a container.
>>
>> i was imagining some proc or proc-like interface that lets you inspect
>> an open file without needing to know what process has the fd.
>
> We will have to find out which process opened the target fd (currently
> in criu we simply assume that target file is always in process which
> created epoll and other scenarios are not supported. in most situations
> that's enough but unfortunately we find a testcase where it's not
> true and have to find a way to support migrated targets too).
>
>> What if you introduced a new type of fd that's an "fd reference".  You
>> could add a kcmp mode that tells you whether an fd reference refers to
>> the same thing as a real fd, but you'd arrange for fd references to be
>> otherwise useless.
>>
>> Alternatively, you could simply have an interface like kcmp (maybe a
>> new kcmp mode) that lets you compare an epoll set entry to an actual
>> fd.  Then you could figure out what it is but only if you already have
>> the fd by some other means.  Of course, if there are no references
>> left, you still have a problem.  Hmm.
>
> kcmp over target set seems to be preferred since it gonna be a way
> faster. But I think about fd-ref idea too. Thanks a huge!
>

I sort of like kcmp() for this as well maybe the epoll fd argument can 
be a pointer to something like:

struct epoll_slot {
	int epfd;
	int slot;
};

Where 'epfd' is the epoll fd, and slot is just an index into the target 
fds associated with the epoll fd. That is, you would start from 0 and go 
up to n. When you reach the last one you get in -EBADSLT or something.

Regarding Andy's point of of not having a reference by some other means, 
I think you have to have it basically otherwise it would be removed from 
the epfd. I guess it could be being passed via a unix socket? But there 
must be a way to get at those anyways, in order to restore them.

Also, in the initial patch this function can not restore all target 
epoll files:

'ep_find_tfd(struct eventpoll *ep, int tfd)'

Because the 'target' file for an epfd is the pair: {fd, file}. Thus, you 
could have say two different 'target' files with the same fd number.

Thanks,

-Jason
	
