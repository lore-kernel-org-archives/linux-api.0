From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v3 resend 1/2] mm: Add an F_SEAL_FUTURE_WRITE seal to
 memfd
Date: Fri, 9 Nov 2018 17:49:13 -0800
Message-ID: <20181110014913.GA202500@google.com>
References: <20181108041537.39694-1-joel@joelfernandes.org>
 <CAG48ez1h=v-JYnDw81HaYJzOfrNhwYksxmc2r=cJvdQVgYM+NA@mail.gmail.com>
 <A7EC46BC-441A-4A06-9E2F-A26DA88B5320@amacapital.net>
 <CAMkWEXOLJ=ymbVjQfA2MD8XA7Y9Lu3ByJYUY-JvpnYKJ5gkY1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMkWEXOLJ=ymbVjQfA2MD8XA7Y9Lu3ByJYUY-JvpnYKJ5gkY1w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Tirado <mtirado418@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Jann Horn <jannh@google.com>, LKML <linux-kernel@vger.kernel.org>, jreck@google.com, john.stultz@linaro.org, tkjos@google.com, gregkh@linuxfoundation.org, hch@infradead.org, viro@zeniv.linux.org.uk, Andrew Morton <akpm@linux-foundation.org>, dancol@google.com, bfields@fieldses.org, jlayton@kernel.org, khalid.aziz@oracle.com, Lei.Yang@windriver.com, linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, marcandre.lureau@redhat.com, mike.kravetz@oracle.com, minchan@kernel.org, shuah@kernel.org, valdis.kletnieks@vt.edu, hughd@google.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 09, 2018 at 08:02:14PM +0000, Michael Tirado wrote:
[...]
> > > That aside: I wonder whether a better API would be something that
> > > allows you to create a new readonly file descriptor, instead of
> > > fiddling with the writability of an existing fd.
> >
> > Every now and then I try to write a patch to prevent using proc to reopen
> > a file with greater permission than the original open.
> >
> > I like your idea to have a clean way to reopen a a memfd with reduced
> > permissions. But I would make it a syscall instead and maybe make it only
> > work for memfd at first.  And the proc issue would need to be fixed, too.
> 
> IMO the best solution would handle the issue at memfd creation time by
> removing the race condition.

I agree, this is another idea I'm exploring. We could add a new .open
callback to shmem_file_operations and check for seals there.

thanks,

 - Joel
