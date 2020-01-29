From: Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Date: Wed, 29 Jan 2020 15:59:42 +0100
Message-ID: <CAG48ez17Ums4s=gjai-Lakr2tWf9bjmYYeNb5aGrwAD51ypZMA@mail.gmail.com>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk> <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk> <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk> <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b88f0590-71c9-d2bd-9d17-027b05d30d7a-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 28, 2020 at 8:42 PM Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org> wrote:
> On 1/28/20 11:04 AM, Jens Axboe wrote:
> > On 1/28/20 10:19 AM, Jens Axboe wrote:
[...]
> >> #1 adds support for registering the personality of the invoking task,
> >> and #2 adds support for IORING_OP_USE_CREDS. Right now it's limited to
> >> just having one link, it doesn't support a chain of them.
[...]
> I didn't like it becoming a bit too complicated, both in terms of
> implementation and use. And the fact that we'd have to jump through
> hoops to make this work for a full chain.
>
> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
> This makes it way easier to use. Same branch:
>
> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-creds
>
> I'd feel much better with this variant for 5.6.

Some general feedback from an inspectability/debuggability perspective:

At some point, it might be nice if you could add a .show_fdinfo
handler to the io_uring_fops that makes it possible to get a rough
overview over the state of the uring by reading /proc/$pid/fdinfo/$fd,
just like e.g. eventfd (see eventfd_show_fdinfo()). It might be
helpful for debugging to be able to see information about the fixed
files and buffers that have been registered. Same for the
personalities; that information might also be useful when someone is
trying to figure out what privileges a running process actually has.
