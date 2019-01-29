From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Tue, 29 Jan 2019 13:05:59 +0100
Message-ID: <CAK8P3a0MDbsdVB80pU+SyDSZDDYy+whK6c9vs-7-yunQ21CiDA@mail.gmail.com>
References: <20190123153536.7081-1-axboe@kernel.dk> <20190123153536.7081-6-axboe@kernel.dk>
 <20190128145700.GA9795@lst.de> <CALCETrV30uN2qOUEf+kNGWdphBtps7K3rEk8_8+VAwdtPomRkQ@mail.gmail.com>
 <dab3fa32-3887-3264-9fe1-bc3b7abc58b3@kernel.dk> <20190129064548.GA3280@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190129064548.GA3280@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Andy Lutomirski <luto@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-aio <linux-aio@kvack.org>, linux-block <linux-block@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Avi Kivity <avi@scylladb.com>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 29, 2019 at 7:45 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Jan 28, 2019 at 06:20:08PM -0700, Jens Axboe wrote:
> > Sure, that would be straight forward. Is there a strong reason to do
> > so outside of "that would be nice"? It's not like it's a huge amount
> > of code.
>
> And it would be really painful for userspace.  Because now you
> can't pass struct iovec through from a higher level, but will instead
> of to copy the iovec to a different type in the submission path.

Agreed. However, if we decide to add the in_compat_syscall() check
to set_user_sigmask()/set_compat_user_sigmask(), we probably want
to do the same thing in import_iovec()/compat_import_iovec() and
rw_copy_check_uvector()/compat_rw_copy_check_uvector().

      Arnd

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
