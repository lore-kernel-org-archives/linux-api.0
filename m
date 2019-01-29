From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Tue, 29 Jan 2019 01:58:51 +0100
Message-ID: <CAG48ez2dESJAg80N3+vgSWy_Pb+Est0S-jshhmZD2nnwgpuR3w@mail.gmail.com>
References: <20190128213538.13486-1-axboe@kernel.dk> <20190128213538.13486-6-axboe@kernel.dk>
 <CAG48ez0vDqDH4ks7q4L3F+xt-4kVQrN1yw34QwFAmwQyy27FTw@mail.gmail.com>
 <e9326a77-54c5-e2b8-d9e5-663261462597@kernel.dk> <CAG48ez17NW0GJVRC6dFcHZTgQifFz5og1XCUbXkHKhr6f=j74Q@mail.gmail.com>
 <c20a1250-9f3f-a286-9baf-5b71db0c128f@kernel.dk> <51c759f4-7ce5-182b-98e8-2c0e99ca4f9a@kernel.dk>
 <CAG48ez3XGjFZbPiof4u4QGtoumBXXfCsFxOQ_2pGt=MnqqY7ZQ@mail.gmail.com> <a89d28dc-d0c4-d84e-b3f2-20d10c6f673e@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <a89d28dc-d0c4-d84e-b3f2-20d10c6f673e@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 29, 2019 at 1:55 AM Jens Axboe <axboe@kernel.dk> wrote:
> On 1/28/19 5:34 PM, Jann Horn wrote:
> > On Tue, Jan 29, 2019 at 1:32 AM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 1/28/19 5:03 PM, Jens Axboe wrote:
> >>>> But you only do that teardown on ->release, right? And ->release
> >>>> doesn't have much to do with the process lifetime.
> >>>
> >>> Yes, only on ->relase().
> >>
> >> OK, so I reworked the files struct to just grab it, then we ensure that
> >> doesn't go away. For mm, it's a bit more tricky. I think the best
> >> solution here is to add a fops->flush() and check for the process
> >> exiting its files. If it does, we quiesce the async contexts and prevent
> >> further use of that mm. We can't just keep holding a reference to the mm
> >> like we do with the files.
> >>
> >> That should solve both cases.
> >
> > You still have to hold a reference on the mm though, I think (for
> > example, because two tasks might be sharing the fd table without
> > sharing the mm).
>
> Yes good point, except we can't hold a reference to it.

Why not? kvm_create_vm() does it, too:

    mmgrab(current->mm);
    kvm->mm = current->mm;

> But I think
> we can get around this by using an mmu notifier instead. That eliminates
> the need for ->flush() as well.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
