From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Date: Thu, 30 Jan 2020 08:29:30 -0700
Message-ID: <e6d98755-7122-63f5-2047-18ef9f42c60e@kernel.dk>
References: <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <CAG48ez17Ums4s=gjai-Lakr2tWf9bjmYYeNb5aGrwAD51ypZMA@mail.gmail.com>
 <4f833fc5-b4c0-c304-c3c2-f63c050b90a2@kernel.dk>
 <9ce2e571-ed84-211a-4e99-d830ecdaf0e2@kernel.dk>
 <CAG48ez1qVCoOwcdA7YZcKObQ9frWNxCjHOp6RYeqd+q_n4KJJQ@mail.gmail.com>
 <20200130102635.ar2bohr7n4li2hyd@wittgenstein>
 <cf801c52-7719-bb5c-c999-ab9aab0d4871@kernel.dk>
 <20200130151342.u554shnaliau42jq@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200130151342.u554shnaliau42jq@wittgenstein>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 1/30/20 8:13 AM, Christian Brauner wrote:
> On Thu, Jan 30, 2020 at 07:11:08AM -0700, Jens Axboe wrote:
>> On 1/30/20 3:26 AM, Christian Brauner wrote:
>>> On Thu, Jan 30, 2020 at 11:11:58AM +0100, Jann Horn wrote:
>>>> On Thu, Jan 30, 2020 at 2:08 AM Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org> wrote:
>>>>> On 1/29/20 10:34 AM, Jens Axboe wrote:
>>>>>> On 1/29/20 7:59 AM, Jann Horn wrote:
>>>>>>> On Tue, Jan 28, 2020 at 8:42 PM Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org> wrote:
>>>>>>>> On 1/28/20 11:04 AM, Jens Axboe wrote:
>>>>>>>>> On 1/28/20 10:19 AM, Jens Axboe wrote:
>>>>>>> [...]
>>>>>>>>>> #1 adds support for registering the personality of the invoking task,
>>>>>>>>>> and #2 adds support for IORING_OP_USE_CREDS. Right now it's limited to
>>>>>>>>>> just having one link, it doesn't support a chain of them.
>>>>>>> [...]
>>>>>>>> I didn't like it becoming a bit too complicated, both in terms of
>>>>>>>> implementation and use. And the fact that we'd have to jump through
>>>>>>>> hoops to make this work for a full chain.
>>>>>>>>
>>>>>>>> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
>>>>>>>> This makes it way easier to use. Same branch:
>>>>>>>>
>>>>>>>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-creds
>>>>>>>>
>>>>>>>> I'd feel much better with this variant for 5.6.
>>>>>>>
>>>>>>> Some general feedback from an inspectability/debuggability perspective:
>>>>>>>
>>>>>>> At some point, it might be nice if you could add a .show_fdinfo
>>>>>>> handler to the io_uring_fops that makes it possible to get a rough
>>>>>>> overview over the state of the uring by reading /proc/$pid/fdinfo/$fd,
>>>>>>> just like e.g. eventfd (see eventfd_show_fdinfo()). It might be
>>>>>>> helpful for debugging to be able to see information about the fixed
>>>>>>> files and buffers that have been registered. Same for the
>>>>>>> personalities; that information might also be useful when someone is
>>>>>>> trying to figure out what privileges a running process actually has.
>>>>>>
>>>>>> Agree, that would be a very useful addition. I'll take a look at it.
>>>>>
>>>>> Jann, how much info are you looking for? Here's a rough start, just
>>>>> shows the number of registered files and buffers, and lists the
>>>>> personalities registered. We could also dump the buffer info for
>>>>> each of them, and ditto for the files. Not sure how much verbosity
>>>>> is acceptable in fdinfo?
>>>>
>>>> At the moment, I personally am just interested in this from the
>>>> perspective of being able to audit the state of personalities, to make
>>>> important information about the security state of processes visible.
>>>>
>>>> Good point about verbosity in fdinfo - I'm not sure about that myself either.
> 
> Afaik, there's no rule here. I would expect that it shouldn't exceed
> 4096kb just because that is the limit that seems to be enforced for
> writes to proc files atm; other than that it should be the wild west.
> The fdinfo files are mostly interesting for anon_inode fds imho and the
> ones that come to mind right now simply don't have a lot of information
> to provide:
> 
> eventfd
> timerfd
> seccomp_notify_fd
> 
> Potentially, the mount fds from David could be extended in the future.

4MB is huge, I'd not get anywhere near that. So I'd say the current
format is probably fine. I honed it a little bit to be prettier, looks
good to me. I'll send it out for review.

> (Side note: One thing that comes to mind is that we should probably
> enforce^Wdocument that all fdinfo files use CamelCase?)

Fine with me, seems to already be the norm, would be nice to have it
documented.

-- 
Jens Axboe
