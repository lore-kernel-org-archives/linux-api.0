From: Stef Bon <stefbon@gmail.com>
Subject: Re: [PATCH v2] inotify: Extend ioctl to allow to request id of new
 watch descriptor
Date: Sun, 11 Feb 2018 12:30:21 +0100
Message-ID: <CANXojcxKH1zFHOPsJh7zbjshUkFGagah-vN6EvMU7Q-9kLFmpg@mail.gmail.com>
References: <151810242614.30935.12876744458891870220.stgit@localhost.localdomain>
 <ca006760-de72-37b3-f6fd-311c86f29b62@virtuozzo.com> <20180209125656.e440e0518540d6b76ae42bc0@linux-foundation.org>
 <bb9bafab-9a50-d19e-7293-65e74aca4720@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <bb9bafab-9a50-d19e-7293-65e74aca4720@virtuozzo.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, willy@infradead.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, gorcunov@virtuozzo.com
List-Id: linux-api@vger.kernel.org

2018-02-09 23:45 GMT+01:00 Kirill Tkhai <ktkhai@virtuozzo.com>:
> On 09.02.2018 23:56, Andrew Morton wrote:
>> On Fri, 9 Feb 2018 18:04:54 +0300 Kirill Tkhai <ktkhai@virtuozzo.com> wrote:
>>
>>> Watch descriptor is id of the watch created by inotify_add_watch().
>>> It is allocated in inotify_add_to_idr(), and takes the numbers
>>> starting from 1. Every new inotify watch obtains next available
>>> number (usually, old + 1), as served by idr_alloc_cyclic().
>>>
>>> CRIU (Checkpoint/Restore In Userspace) project supports inotify
>>> files, and restores watched descriptors with the same numbers,
>>> they had before dump. Since there was no kernel support, we
>>> had to use cycle to add a watch with specific descriptor id:
>>>
>>>      while (1) {
>>>              int wd;
>>>
>>>              wd = inotify_add_watch(inotify_fd, path, mask);
>>>              if (wd < 0) {
>>>                      break;
>>>              } else if (wd == desired_wd_id) {
>>>                      ret = 0;
>>>                      break;
>>>              }
>>>
>>>              inotify_rm_watch(inotify_fd, wd);
>>>      }
>>>
>>> (You may find the actual code at the below link:
>>>  https://github.com/checkpoint-restore/criu/blob/v3.7/criu/fsnotify.c#L577)

Well using a ioctl command to force a specific wd is possible, but
isn't it also possible
to do a "freeze" of all (inotify) watches which are involved, and
"unfreeze" when restoring?

Stef
