From: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH v2] inotify: Extend ioctl to allow to request id of new
 watch descriptor
Date: Mon, 12 Feb 2018 11:42:15 +0300
Message-ID: <573950bf-284f-fb4a-c1ba-bc3a7c47dc45@virtuozzo.com>
References: <151810242614.30935.12876744458891870220.stgit@localhost.localdomain>
 <ca006760-de72-37b3-f6fd-311c86f29b62@virtuozzo.com>
 <20180209125656.e440e0518540d6b76ae42bc0@linux-foundation.org>
 <bb9bafab-9a50-d19e-7293-65e74aca4720@virtuozzo.com>
 <CANXojcxKH1zFHOPsJh7zbjshUkFGagah-vN6EvMU7Q-9kLFmpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANXojcxKH1zFHOPsJh7zbjshUkFGagah-vN6EvMU7Q-9kLFmpg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gorcunov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11.02.2018 14:30, Stef Bon wrote:
> 2018-02-09 23:45 GMT+01:00 Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>:
>> On 09.02.2018 23:56, Andrew Morton wrote:
>>> On Fri, 9 Feb 2018 18:04:54 +0300 Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>>>
>>>> Watch descriptor is id of the watch created by inotify_add_watch().
>>>> It is allocated in inotify_add_to_idr(), and takes the numbers
>>>> starting from 1. Every new inotify watch obtains next available
>>>> number (usually, old + 1), as served by idr_alloc_cyclic().
>>>>
>>>> CRIU (Checkpoint/Restore In Userspace) project supports inotify
>>>> files, and restores watched descriptors with the same numbers,
>>>> they had before dump. Since there was no kernel support, we
>>>> had to use cycle to add a watch with specific descriptor id:
>>>>
>>>>      while (1) {
>>>>              int wd;
>>>>
>>>>              wd = inotify_add_watch(inotify_fd, path, mask);
>>>>              if (wd < 0) {
>>>>                      break;
>>>>              } else if (wd == desired_wd_id) {
>>>>                      ret = 0;
>>>>                      break;
>>>>              }
>>>>
>>>>              inotify_rm_watch(inotify_fd, wd);
>>>>      }
>>>>
>>>> (You may find the actual code at the below link:
>>>>  https://github.com/checkpoint-restore/criu/blob/v3.7/criu/fsnotify.c#L577)
> 
> Well using a ioctl command to force a specific wd is possible, but
> isn't it also possible
> to do a "freeze" of all (inotify) watches which are involved, and
> "unfreeze" when restoring?

Regarding C/R, all inotifies are involved ;) Also, all regular files, sockets,
memory mappings, etc. 

Checkpoint code attaches to a process via ptrace() and injects parasite code,
which collects data and metadata of all the process's entities. It's rather
difficult action, because several processes may be checkpointed, and they may
share files/memory mappings/fs/etc. Also, they may be related to different
namespaces. It's long to tell. You may dive into CRIU code, if you're interested.

Then, restore code tries to recreate the processes from ground (possible,
on another physical machine). It uses standard linux system calls to do that,
i.e., it starts from clone() and then creates everything else. When there is
the time to restore a file (inotify in our case), standard linux inotify_init1()
is called. We create the inotify fd, then dup2() it to appropriate number.
Then, we need to add watched files/directories to the inotify. And they must
be added with the same watch descriptor id, as they was at checkpoint time.
We use inotify_add_watch() and it returns id == 1, as you can see in kernel
code. But we need another id, say, 0xfffff. And there is no syscall like dup2()
for inotify watch descriptors. So, we use cyclic inotify_add_watch()/inotify_rm_watch()
as next inotify_add_watch() returns incremented id (see the kernel) despite inotify_rm_watch()
was called to remove old. After 0xfffff-1 iterations, inotify_add_watch() reaches
id we need and returns it. This scheme is very slow, and the patch allows to
restory inotify using 2 syscalls only (ioctl+inotify_add_watch).

So, answering your question: No, it's not possible to use freeze/unfreeze
to do that.

Kirill
